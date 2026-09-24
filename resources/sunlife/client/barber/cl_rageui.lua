-- ============================================================
-- Barber RageUI menu (mergé depuis vms_barber/client/barber_rageui.lua)
-- Self-service uniquement (pas de mode business).
-- ============================================================

local Config    = BarberConfig
local TRANSLATE = BarberT

local ESX = exports['es_extended']:getSharedObject()

local barberMenuOpen = false
local barberPaid     = false
-- Flag "coupe payée & sauvegardée". Volontairement PAS remis à zéro par
-- ResetState() : c'est ce qui évite la race où ResetState() (appelé dans Pay)
-- remet le flag à false AVANT que le callback Closed de RageUI ne se déclenche,
-- ce qui faisait annuler (RevertSkin) la coupe qu'on venait de payer.
-- Il n'est remis à false qu'à l'ouverture d'un nouveau menu.
local barberSaved    = false

local barberRageData       = nil
local barberRagePrices     = nil
local barberOriginalValues = {}
local barberCurrentValues  = {}

local barberListCache    = {}
local barberPayMethodIndex = 1
-- Garde de re-entrance : le controle "Select" de RageUI a un auto-repeat
-- (~125ms tant que la touche est maintenue). Sans ce flag, maintenir "Payer"
-- rappelait 'rg_barber:getMoney' ~8x/s (round-trip async non termine) =
-- retraits multiples + spam du hub de callbacks ESX.
local barberPaying       = false

local barberMainMenu, barberHairMenu, barberBeardMenu, barberEyesMenu, barberMakeupMenu, barberFadesMenu

if RageUI then
    RageUI.PanelColour = RageUI.PanelColour or {}
    if not RageUI.PanelColour.HairCut then
        RageUI.PanelColour.HairCut = {}
        for i = 0, 63 do
            local shade = math.floor((i / 63) * 255)
            RageUI.PanelColour.HairCut[#RageUI.PanelColour.HairCut + 1] = { shade, shade, shade, 255 }
        end
    end
    RageUI.PanelColour.Makeup   = RageUI.PanelColour.Makeup   or RageUI.PanelColour.HairCut
    RageUI.PanelColour.Lipstick = RageUI.PanelColour.Lipstick or RageUI.PanelColour.Makeup
    RageUI.PanelColour.Blush    = RageUI.PanelColour.Blush    or RageUI.PanelColour.Makeup
end

local styleOpacityMap = {
    beard_1    = "beard_2",
    eyebrows_1 = "eyebrows_2",
    makeup_1   = "makeup_2",
    lipstick_1 = "lipstick_2",
    blush_1    = "blush_2",
}

local function ResetState()
    barberMenuOpen        = false
    barberPaid            = false
    barberPaying          = false
    barberRageData        = nil
    barberRagePrices      = nil
    barberOriginalValues  = {}
    barberCurrentValues   = {}
    barberListCache       = {}
end

local function CloneData(data)
    barberOriginalValues = {}
    barberCurrentValues  = {}
    barberListCache      = {}
    for name, v in pairs(data) do
        barberOriginalValues[name] = v.value
        barberCurrentValues[name]  = v.value
    end
end

local function RevertSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
        Barber_UnloadPlayerProps()
    end)
end

local function SetComponent(key, value)
    if not barberRageData or not barberRageData[key] then return end

    local comp = barberRageData[key]
    if comp.min and value < comp.min then value = comp.min end
    if comp.max and value > comp.max then value = comp.max end
    if barberCurrentValues[key] == value then return end

    barberCurrentValues[key] = value
    comp.value = value

    BarberCharacter[key] = value
    TriggerEvent('skinchanger:change', tostring(key), tonumber(value))
    Barber_UnloadPlayerProps()

    local opacityKey = styleOpacityMap[key]
    if opacityKey and value and value > 0 and barberRageData[opacityKey] then
        local opComp = barberRageData[opacityKey]
        local opMin  = opComp.min or 0
        local opMax  = opComp.max or 10
        local opCur  = barberCurrentValues[opacityKey] or opComp.value or opMin
        if opCur <= opMin then
            SetComponent(opacityKey, opMax)
        end
    end
end

local function BuildDiff()
    local diff = {}
    for k, v in pairs(barberOriginalValues) do
        local cur = barberCurrentValues[k]
        if cur == nil then cur = v end
        if tonumber(v) ~= tonumber(cur) then
            diff[k] = { default = v, value = cur }
        end
    end
    return diff
end

local function ComputePrice()
    if not barberRagePrices or not BarberState.barberId then
        return 0, {}
    end
    local barberData = Config.Barbers[BarberState.barberId]
    if not barberData then return 0, {} end

    local total  = 0
    local values = {}
    local diff   = BuildDiff()

    for name, _ in pairs(diff) do
        if barberData.prices[name] then
            values[name] = barberData.prices[name].price
            total = total + barberData.prices[name].price
        end
    end

    if Config.UseTattoshopHairFades then
        for k, _ in pairs(BarberState.currentTattoos or {}) do
            if barberData.prices['hair_fade'] then
                values['fade:' .. k] = barberData.prices['hair_fade'].price
                total = total + barberData.prices['hair_fade'].price
            end
        end
    end

    return total, values
end

local function DrawList(label, key)
    if not barberRageData or not barberRageData[key] then return end
    local comp = barberRageData[key]
    local min  = comp.min or 0
    local max  = comp.max or 0
    if max < min then max = min end

    if not barberListCache[key] or barberListCache[key].min ~= min or barberListCache[key].max ~= max then
        local items = {}
        for i = min, max do items[#items + 1] = tostring(i) end
        barberListCache[key] = { items = items, min = min, max = max }
    end

    local cache = barberListCache[key]
    local cur   = barberCurrentValues[key] or comp.value or min
    if cur < cache.min then cur = cache.min end
    if cur > cache.max then cur = cache.max end
    local index = (cur - cache.min) + 1

    RageUI.List(label, cache.items, index, nil, {}, true, function(_, _, _, Index)
        if Index ~= index then
            SetComponent(key, cache.min + (Index - 1))
        end
    end)
end

local function DrawOpacity(label, key)
    if not barberRageData or not barberRageData[key] then return end
    local comp = barberRageData[key]
    local min  = comp.min or 0
    local max  = comp.max or 10
    if max < min then max = min end

    local cur = barberCurrentValues[key]
    if cur == nil then cur = comp.value or max end
    if cur < min then cur = min end
    if cur > max then cur = max end

    local steps = max - min + 1
    local sliderIndex = (cur - min) + 1
    local percent = 0
    if max ~= min then
        percent = math.floor(((cur - min) / (max - min)) * 100)
    end

    RageUI.Slider(label, sliderIndex, steps, tostring(percent) .. "%", false, {}, true, function(_, Active, _, value)
        if not Active then return end
        if value < 1 then value = 1 end
        if value > steps then value = steps end
        local newVal = min + (value - 1)
        if newVal ~= cur then SetComponent(key, newVal) end
    end)
end

local function DrawFades()
    if not Config.UseTattoshopHairFades or not BarberState.CURRENT_FADES then return end

    local fadeIndex = 0
    for id, _ in pairs(BarberState.CURRENT_FADES) do
        fadeIndex = fadeIndex + 1
        local idStr   = tostring(id)
        local checked = BarberState.Character_Temp_Tattoos[idStr] == true
        local label   = "Fade " .. tostring(fadeIndex)

        RageUI.Checkbox(label, nil, checked, {}, function(_, _, Selected)
            if not Selected then return end
            local fadeData = BarberState.CURRENT_FADES[tonumber(id)]
            local hadTattoo = fadeData and fadeData.hasTattoo
            local wasActive = BarberState.Character_Temp_Tattoos[idStr] == true
            local nowActive = not wasActive

            BarberState.Character_Temp_Tattoos[idStr] = nowActive

            if nowActive == (hadTattoo or false) then
                BarberState.currentTattoos[idStr] = nil
            else
                BarberState.currentTattoos[idStr] = true
            end

            if Tattoo_ReloadPlayerTattoosByBarber then
                Tattoo_ReloadPlayerTattoosByBarber(BarberState.Character_Temp_Tattoos, nil)
            end
        end)
    end
end

local function Pay(payType)
    if barberPaying then return end

    local total, _ = ComputePrice()
    if total <= 0 then
        ESX.ShowNotification("Aucun changement à payer.")
        return
    end

    barberPaying = true
    ESX.TriggerServerCallback("rg_barber:getMoney", function(success, paid)
        barberPaying = false
        if success then
            local newHairFades = BarberState.currentTattoos
            BarberState.currentTattoos = {}

            if Config.UseTattoshopHairFades and Tattoo_GetHairFadesList then
                BarberState.CURRENT_FADES = Tattoo_GetHairFadesList()
                for k, v in pairs(BarberState.CURRENT_FADES) do
                    if v.hasTattoo then
                        BarberState.Character_Temp_Tattoos[tostring(k)] = true
                    end
                end
            end

            barberPaid  = true
            barberSaved = true
            ESX.ShowNotification(TRANSLATE("notify.paid", paid))

            if BarberState.CURRENT_BARBER and BarberState.CURRENT_BARBER.barber and BarberState.Ped then
                FreezeEntityPosition(BarberState.Ped, false)
                Barber_LoadAnimDict(Config.AnimDict)
                TaskPlayAnim(BarberState.Ped, Config.AnimDict, Config.Anim, 8.0, 8.0, 15000, 0, 0, false, false, false)
            end

            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
                -- On recharge le skin pour verrouiller la coupe payée (même
                -- pattern que le makeupbox), évite tout reload d'ancien skin.
                TriggerEvent('skinchanger:loadSkin', skin)
            end)

            Barber_UnloadPlayerProps()
            RageUI.CloseAll()
            Barber_DeleteCam()
            ResetState()
        else
            ESX.ShowNotification(TRANSLATE("notify.nomoney"))
        end
    end, total, payType, BarberState.currentTattoos)
end

function OpenBarberRageMenu(payload)
    if barberMenuOpen then return end

    barberMenuOpen   = true
    barberPaid       = false
    barberSaved      = false
    barberRageData   = payload.data   or {}
    barberRagePrices = payload.prices or {}

    CloneData(barberRageData)

    if payload.hairFades  then BarberState.CURRENT_FADES = payload.hairFades end
    if payload.tempTattoos then BarberState.Character_Temp_Tattoos = payload.tempTattoos end

    Barber_CreateCam()

    if RageUI and RageUI.Settings and RageUI.Settings.Controls and RageUI.Settings.Controls.Mouse then
        RageUI.Settings.Controls.Mouse.Enabled = true
    end

    if RMenu['barber'] then
        for name, _ in pairs(RMenu['barber']) do
            RMenu:Delete('barber', name)
        end
    end

    RMenu.Add('barber', 'main',  RageUI.CreateMenu("Coiffeur", "Personnalisation", 1290, 100))
    RMenu.Add('barber', 'hair',  RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Cheveux",          "Coupe et couleurs"))
    RMenu.Add('barber', 'beard', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Barbe & sourcils", "Pilosité faciale"))
    RMenu.Add('barber', 'eyes',  RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Yeux",             "Regard"))
    if Config.CanMakeup then
        RMenu.Add('barber', 'makeup', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Maquillage", "Détails"))
    end
    if Config.UseTattoshopHairFades then
        RMenu.Add('barber', 'fades', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Fades", "Dégradés"))
    end

    barberMainMenu   = RMenu:Get('barber', 'main')
    barberHairMenu   = RMenu:Get('barber', 'hair')
    barberBeardMenu  = RMenu:Get('barber', 'beard')
    barberEyesMenu   = RMenu:Get('barber', 'eyes')
    barberMakeupMenu = Config.CanMakeup and RMenu:Get('barber', 'makeup') or nil
    barberFadesMenu  = Config.UseTattoshopHairFades and RMenu:Get('barber', 'fades') or nil

    for _, m in ipairs({ barberMainMenu, barberHairMenu, barberBeardMenu, barberEyesMenu, barberMakeupMenu, barberFadesMenu }) do
        if m then m:SetRectangleBanner(10, 10, 10, 200) end
    end

    barberHairMenu.EnableMouse     = true
    barberHairMenu.EnableControls  = true
    barberBeardMenu.EnableMouse    = true
    barberBeardMenu.EnableControls = true
    if barberMakeupMenu then
        barberMakeupMenu.EnableMouse    = true
        barberMakeupMenu.EnableControls = true
    end

    barberMainMenu.Closed = function()
        if not barberSaved then RevertSkin() end
        Barber_DeleteCam()
        ResetState()
        if RageUI and RageUI.Settings and RageUI.Settings.Controls and RageUI.Settings.Controls.Mouse then
            RageUI.Settings.Controls.Mouse.Enabled = false
        end
    end

    RageUI.CloseAll()
    RageUI.Visible(barberMainMenu, true)

    Citizen.CreateThread(function()
        while barberMenuOpen do
            Citizen.Wait(1)

            RageUI.IsVisible(barberMainMenu, true, true, true, function()
                RageUI.ButtonWithStyle("Cheveux",          nil, {}, true, function() end, barberHairMenu)
                RageUI.ButtonWithStyle("Barbe & sourcils", nil, {}, true, function() end, barberBeardMenu)
                RageUI.ButtonWithStyle("Yeux",             nil, {}, true, function() end, barberEyesMenu)
                if Config.CanMakeup and barberMakeupMenu then
                    RageUI.ButtonWithStyle("Maquillage", nil, {}, true, function() end, barberMakeupMenu)
                end
                if barberFadesMenu then
                    RageUI.ButtonWithStyle("Fades", nil, {}, true, function() end, barberFadesMenu)
                end
                RageUI.Separator("")

                local total, _ = ComputePrice()
                local items = { "Liquide", "Banque" }
                RageUI.List("Payer", items, barberPayMethodIndex, nil, { RightLabel = "~g~" .. tostring(total) .. "$" }, total > 0, function(_, _, Selected, Index)
                    barberPayMethodIndex = Index
                    if Selected then
                        Pay(Index == 1 and "cash" or "bank")
                    end
                end)
            end)

            RageUI.IsVisible(barberHairMenu, true, true, true, function()
                DrawList("Coupe",              "hair_1")
                DrawList("Variation",          "hair_2")
                DrawList("Couleur principale", "hair_color_1")
                DrawList("Reflets",            "hair_color_2")
            end)

            RageUI.IsVisible(barberBeardMenu, true, true, true, function()
                DrawList("Style de barbe",      "beard_1")
                DrawOpacity("Opacité barbe",    "beard_2")
                DrawList("Couleur de barbe",    "beard_3")
                DrawList("Sourcils",            "eyebrows_1")
                DrawOpacity("Opacité sourcils", "eyebrows_2")
                DrawList("Couleur des sourcils","eyebrows_3")
            end)

            RageUI.IsVisible(barberEyesMenu, true, true, true, function()
                DrawList("Couleur des yeux", "eye_color")
            end)

            if barberMakeupMenu then
                RageUI.IsVisible(barberMakeupMenu, true, true, true, function()
                    DrawList("Maquillage",            "makeup_1")
                    DrawOpacity("Opacité maquillage", "makeup_2")
                    DrawList("Couleur maquillage",    "makeup_3")
                    DrawList("Couleur secondaire",    "makeup_4")
                    DrawList("Rouge à lèvres",        "lipstick_1")
                    DrawOpacity("Opacité lèvres",     "lipstick_2")
                    DrawList("Couleur lèvres",        "lipstick_3")
                    DrawList("Blush",                 "blush_1")
                    DrawOpacity("Opacité blush",      "blush_2")
                    DrawList("Couleur blush",         "blush_3")
                end)
            end

            if barberFadesMenu then
                RageUI.IsVisible(barberFadesMenu, true, true, true, function()
                    DrawFades()
                end)
            end
        end
    end)
end
