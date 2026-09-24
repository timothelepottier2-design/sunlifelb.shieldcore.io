ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
end)

local fireHandles = {}

function loadParticleFx(asset)
    RequestNamedPtfxAsset(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        Wait(10)
    end
end

function startFireEffect(position)
    loadParticleFx("scr_agencyheistb")
    loadParticleFx("scr_trevor3")
    location = position

    UseParticleFxAsset("scr_agencyheistb")
    local smokeEffect1 = StartParticleFxLoopedAtCoord(
        "scr_env_agency3b_smoke",
        location.x, location.y, location.z + 1.0,
        0.0, 0.0, 0.0, 1.0,
        false, false, false, false
    )

    UseParticleFxAsset("scr_trevor3")
    local flamePlumeEffect = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        location.x, location.y, location.z + 1.2,
        0.0, 0.0, 0.0, 1.0,
        false, false, false, false
    )

    for i = 1, 3 do
        local offsetX = math.random(-2, 2)
        local offsetY = math.random(-2, 2)
        local smokeEffect = StartParticleFxLoopedAtCoord(
            "scr_env_agency3b_smoke",
            location.x + offsetX, location.y + offsetY, location.z + 1.0,
            0.0, 0.0, 0.0, 1.0,
            false, false, false, false
        )
        table.insert(fireHandles, smokeEffect)
    end

    table.insert(fireHandles, smokeEffect1)
    table.insert(fireHandles, flamePlumeEffect)
end

function stopFireEffect()
    for _, effect in ipairs(fireHandles) do
        StopParticleFxLooped(effect, false)
        RemoveParticleFx(effect, true)
    end
    fireHandles = {}
end

RegisterCommand("brinkss", function()
    OpenBrinksMenu()
end)

local previewVehFinal = nil
OpenBrinksMenu = function()
    ESX.TriggerServerCallback("staffbrinks:isStaff", function(isStaff)
        if isStaff then
            if IsPedDeadOrDying(PlayerPedId(), false) then return end

            local dureeEvenement = 200
            local nomEvenement = "Fourgon Blindé"
            local gainsEau = false
            local vehicule = "stockade"
            local nombrePalettes = 12
            local vehPos = nil
            local vehHeading = 0
            local vehHealth = 1000
            local palettePrice = 5000
            local coords = GetEntityCoords(PlayerPedId())

            if RMenu['brinks'] then
                for name, menu in pairs(RMenu['brinks']) do
                    RMenu:Delete('brinks', name)
                end
            end

            RMenu.Add('brinks', 'main', RageUI.CreateMenu("Brinks", "Paramètres de l'événement", 50, 100))
            local menu = RMenu:Get('brinks', 'main')
            menu:SetRectangleBanner(255, 106, 0, 140)

            menu.Closed = function()
                brinksMenuOpen = false

                if DoesEntityExist(previewVehFinal) then
                    DeleteEntity(previewVehFinal)
                    previewVehFinal = nil
                end

                if previewPaletteObjs then
                    for _, obj in ipairs(previewPaletteObjs) do
                        if DoesEntityExist(obj) then
                            DeleteEntity(obj)
                        end
                    end
                    previewPaletteObjs = {}
                end

                RMenu:Delete('brinks', 'main')
            end

            if brinksMenuOpen then
                brinksMenuOpen = false
                return
            else
                RageUI.CloseAll()
                brinksMenuOpen = true
                RageUI.Visible(menu, true)
            end

            local isChoosingPosition = false

            Citizen.CreateThread(function()
                while brinksMenuOpen do
                    Wait(1)

                    RageUI.IsVisible(menu, true, true, true, function()

                        RageUI.ButtonWithStyle("Durée de l'événement", "Le temps doit être défini en secondes.", {RightLabel = tostring(dureeEvenement)}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Durée en secondes", "", 50)
                                local num = tonumber(input)
                                if num then
                                    dureeEvenement = num
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Nom", nil, {RightLabel = nomEvenement}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Nom de l'événement", "", 30)
                                if input and input ~= "" then
                                    nomEvenement = input
                                else
                                    ESX.ShowNotification("~r~Nom invalide.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Véhicule", nil, {RightLabel = vehicule}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Nom du véhicule", "", 20)
                                if input and input ~= "" then
                                    vehicule = input
                                else
                                    ESX.ShowNotification("~r~Nom invalide.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Nombre de palettes", nil, {RightLabel = tostring(nombrePalettes)}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Nombre de palettes", "", 50)
                                local num = tonumber(input)
                                if num then
                                    nombrePalettes = num
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Récompense par palette", nil, {RightLabel = tonumber(palettePrice).."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Récompense par palette", "", 50)
                                local num = tonumber(input)
                                if num then
                                    palettePrice = num
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        if vehPos == nil then
                            RageUI.ButtonWithStyle("Position du véhicule", "Choisir la position du véhicule en mode aperçu.", {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SetVehiclePreview(vehicule, function(pos, heading)
                                        vehPos = pos
                                        vehHeading = heading

                                        palettesPos = {}
                                        for i = 1, nombrePalettes do
                                            local offset = GetRandomOffset(vehPos)
                                            table.insert(palettesPos, {
                                                pos = offset,
                                                taken = false,
                                            })
                                        end

                                        if previewPaletteObjs then
                                            for _, obj in ipairs(previewPaletteObjs) do
                                                if DoesEntityExist(obj) then
                                                    DeleteEntity(obj)
                                                end
                                            end
                                        end
                                        previewPaletteObjs = {}

                                        RequestModel(GetHashKey("prop_cash_crate_01"))
                                        while not HasModelLoaded(GetHashKey("prop_cash_crate_01")) do
                                            Citizen.Wait(100)
                                        end

                                        for _, p in ipairs(palettesPos) do
                                            local obj = CreateObject(GetHashKey("prop_cash_crate_01"), p.pos.x, p.pos.y, p.pos.z, false, false, false)
                                            SetEntityAlpha(obj, 150, false)
                                            SetEntityCollision(obj, false, false)
                                            FreezeEntityPosition(obj, true)
                                            PlaceObjectOnGroundProperly(obj)
                                            table.insert(previewPaletteObjs, obj)
                                        end

                                        ESX.ShowNotification("~g~Position et palettes sauvegardées (preview visible).")
                                    end)
                                end
                            end)
                        else
                            RageUI.ButtonWithStyle("~c~Position du véhicule", "Position déjà choisie.", {}, false, function(Hovered, Active, Selected)
                                if Selected then
                                    vehPos = nil
                                    if previewPaletteObjs then
                                        for _, obj in ipairs(previewPaletteObjs) do
                                            if DoesEntityExist(obj) then
                                                DeleteEntity(obj)
                                            end
                                        end
                                        previewPaletteObjs = {}
                                    end
                                end
                            end)
                        end

                        RageUI.ButtonWithStyle("Santé du véhicule", "Nombre de points de vie du véhicule (max 5000 recommandé)", {RightLabel = tostring(vehHealth)}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local input = KeyboardInputBrinks("Santé du véhicule", "", 50)
                                local num = tonumber(input)
                                if num then
                                    vehHealth = num
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Créer l'événement", "Lance l'événement Brinks.", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if not palettesPos or #palettesPos == 0 then
                                    ESX.ShowNotification("~r~Vous devez d'abord choisir la position du véhicule.")
                                    return
                                end
                                TriggerServerEvent("brinks:startEvent", dureeEvenement, nomEvenement, vehicule, nombrePalettes, vehPos, vehHeading, palettesPos, vehHealth, palettePrice)
                            end
                        end)

                    end)
                end
            end)
        end
    end)
end

function GetRandomOffset(basePos)
    local angle = math.random() * 2 * math.pi
    local radius = math.random(5, 15)
    local offsetX = math.cos(angle) * radius
    local offsetY = math.sin(angle) * radius
    return vector4(basePos.x + offsetX, basePos.y + offsetY, basePos.z, 1.0)
end

function SetVehiclePreview(modelName, callback)
    local playerPed = PlayerPedId()
    local modelHash = GetHashKey(modelName)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    local previewVeh = CreateVehicle(modelHash, GetEntityCoords(playerPed), GetEntityHeading(playerPed), false, false)
    SetEntityAlpha(previewVeh, 100, false)
    SetEntityCollision(previewVeh, false, false)
    SetEntityInvincible(previewVeh, true)
    FreezeEntityPosition(previewVeh, true)
    SetVehicleUndriveable(previewVeh, true)
    SetVehicleDoorsLocked(previewVeh, 10)

    local heading = GetEntityHeading(playerPed)
    local placing = true
    local previewPalettes = {}

    Citizen.CreateThread(function()
        while placing do
            Wait(0)

            local hit, coords, entity = RayCastGamePlayCamera(25.0)
            if hit then
                SetEntityCoords(previewVeh, coords.x, coords.y, coords.z, false, false, false, false)
                SetEntityHeading(previewVeh, heading)

                if IsControlJustPressed(0, 241) then
                    heading = heading + 10.0
                    if heading >= 360.0 then heading = heading - 360.0 end
                end

                if IsControlJustPressed(0, 242) then
                    heading = heading - 10.0
                    if heading < 0.0 then heading = heading + 360.0 end
                end

                if IsControlJustPressed(0, 191) then
                    placing = false
                    local pos = GetEntityCoords(previewVeh)
                    local finalHeading = GetEntityHeading(previewVeh)

                    for _, obj in ipairs(previewPalettes) do
                        if DoesEntityExist(obj) then
                            DeleteEntity(obj)
                        end
                    end

                    DeleteEntity(previewVeh)

                    if DoesEntityExist(previewVehFinal) then
                        DeleteEntity(previewVehFinal)
                    end
                    previewVehFinal = CreateVehicle(modelHash, pos, finalHeading, false, false)
                    SetEntityAsMissionEntity(previewVehFinal, true, true)
                    SetVehicleOnGroundProperly(previewVehFinal)
                    FreezeEntityPosition(previewVehFinal, true)

                    callback(pos, finalHeading)
                end
            end
        end
    end)
end

function RayCastGamePlayCamera(distance)
    local camRot = GetGameplayCamRot(2)
    local camCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(camRot)
    local destination = camCoord + direction * distance
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

function RotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

function KeyboardInputBrinks(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local brinksVehicle = nil
local brinksPalettes = {}
local brinksHealth = 1000
local vehiclePos = nil
local vehicleDestroyed = false

RegisterNetEvent("brinks:notifyEvent")
AddEventHandler("brinks:notifyEvent", function(pos, heading, vehicleModel, numPalettes, name, duration, palettes, vehHealth)
    ESX.ShowNotification("Allez attaquer le ~b~fourgon~s~ indiqué sur votre carte !")

    local brinksBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(brinksBlip, 477)
    SetBlipDisplay(brinksBlip, 4)
    SetBlipScale(brinksBlip, 0.8)
    SetBlipColour(brinksBlip, 5)
    SetBlipAsShortRange(brinksBlip, false)
    AddTextEntry("BN_SUNLIFE_STAFFBRINKS_1", "Fourgon à attaquer")
    BeginTextCommandSetBlipName("BN_SUNLIFE_STAFFBRINKS_1")
    EndTextCommandSetBlipName(brinksBlip)
    Citizen.SetTimeout(10 * 60 * 1000, function()
        RemoveBlip(brinksBlip)
    end)

    Citizen.CreateThread(function()
        while #(GetEntityCoords(PlayerPedId()) - pos) > 100.0 do
            Citizen.Wait(1000)
        end
    end)

    local model = GetHashKey(vehicleModel)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    brinksVehicle = CreateVehicle(model, pos.x, pos.y, pos.z, heading, false, false)
    SetEntityAsMissionEntity(brinksVehicle, true, true)
    SetVehicleOnGroundProperly(brinksVehicle)
    FreezeEntityPosition(brinksVehicle, true)

    local brinksMaxHealth = vehHealth
    brinksHealth = vehHealth
    vehiclePos = pos
    vehicleDestroyed = false

    brinksPalettes = {}
    for i = 1, #palettes do
        brinksPalettes[i] = {pos = palettes[i].pos, taken = false}
    end

    local endTime = GetGameTimer() + (duration * 1000)
    Citizen.CreateThread(function()
        local timeout = 0
        while not vehicleDestroyed do
            Wait(1)
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)

            local dist = #(playerPos - pos)
            local remaining = math.max(0, math.floor((endTime - GetGameTimer()) / 1000))
            if remaining <= 0 then
                TriggerEvent("brinks:stopEvent")
                break
            end

            if dist < 50 then
                local minutes = math.floor(remaining / 60)
                local seconds = remaining % 60

                local timeText = string.format("%02d:%02d", minutes, seconds)
                DrawText3DVec(pos.x, pos.y, pos.z + 3.0, ("Santé du véhicule: ~r~%s/"..brinksMaxHealth.."\n~w~Temps restant: ~y~%s"):format(math.floor(brinksHealth), timeText))

                if IsPedShooting(playerPed) and GetGameTimer() > timeout then
                    timeout = GetGameTimer() + 100
                    TriggerServerEvent("brinks:damageVehicle", 5)
                end
            end
        end
    end)
end)

RegisterNetEvent("brinks:updateHealth")
AddEventHandler("brinks:updateHealth", function(health)
    brinksHealth = health
end)

RegisterNetEvent("brinks:vehicleDestroyed")
AddEventHandler("brinks:vehicleDestroyed", function(pos, palettes)
    if DoesEntityExist(brinksVehicle) then
        FreezeEntityPosition(brinksVehicle, false)
        SetVehicleDoorsLocked(brinksVehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(brinksVehicle, false)
        SetVehicleUndriveable(brinksVehicle, true)
        SetEntityHealth(brinksVehicle, 0)
        ExplodeVehicle(brinksVehicle, true, false)
        SetVehicleDoorBroken(brinksVehicle, -1, false)
        SetVehicleDoorBroken(brinksVehicle, 0, false)
        SetVehicleDoorBroken(brinksVehicle, 1, false)
        SetVehicleDoorBroken(brinksVehicle, 2, false)
        SetVehicleDoorBroken(brinksVehicle, 3, false)
        startFireEffect(GetEntityCoords(brinksVehicle))

        Citizen.SetTimeout(3 * 60 * 1000, function()
            DeleteEntity(brinksVehicle)
        end)

        vehicleDestroyed = true
    end

    RequestModel(GetHashKey("prop_cash_crate_01"))
    while not HasModelLoaded(GetHashKey("prop_cash_crate_01")) do
        Citizen.Wait(100)
    end

    for i, palette in ipairs(brinksPalettes) do
        local prop = CreateObject(GetHashKey("prop_cash_crate_01"), palette.pos.x, palette.pos.y, palette.pos.z + 5.0, false, true, false)
        SetEntityAsMissionEntity(prop, true, true)
        PlaceObjectOnGroundProperly(prop)
        brinksPalettes[i].entity = prop
        brinksPalettes[i].taken = false
    end

    Citizen.CreateThread(function()
        while #brinksPalettes > 0 do
            Wait(1)
            local playerPed = PlayerPedId()
            local pPos = GetEntityCoords(playerPed)

            for i, palette in ipairs(brinksPalettes) do
                if not palette.taken and DoesEntityExist(palette.entity) then
                    local dist = #(pPos - GetEntityCoords(palette.entity))
                    if dist < 2.0 then
                        DrawText3D(palette.pos.x, palette.pos.y, palette.pos.z + 0.5, "~g~[E] Ramasser palette")
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("brinks:pickupPalette", i)
                        end
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent("brinks:paletteTaken")
AddEventHandler("brinks:paletteTaken", function(index)
    if brinksPalettes[index] and brinksPalettes[index].entity then
        DeleteEntity(brinksPalettes[index].entity)
        brinksPalettes[index].taken = true
    end
end)

RegisterNetEvent("brinks:stopEvent")
AddEventHandler("brinks:stopEvent", function()
    if DoesEntityExist(brinksVehicle) then
        DeleteEntity(brinksVehicle)
    end
    for i, palette in ipairs(brinksPalettes) do
        if palette.entity then
            DeleteEntity(palette.entity)
        end
    end
    brinksVehicle = nil
    brinksPalettes = {}
    brinksHealth = 1000
    vehicleDestroyed = false
end)

function DrawText3D(x,y,z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawText3DVec(x,y,z, text)
    SetTextScale(0.60, 0.60)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
