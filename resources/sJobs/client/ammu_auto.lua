local ammuAutoActive = false
local openAmmuAuto = false
local selectedWeapon = { hash = nil, price = 0, label = nil }
local buyAmount = 1

local ammuAutoPoints <const> = {
    vector4(20.746309, -1111.181274, 29.797216, 120.12470245361),
    vector4(809.858154, -2153.179932, 29.619194, 330.08236694336),
    vector4(-1120.270508, 2698.919189, 18.554266, 220.10668945312),
    vector4(1692.556030, 3758.255615, 34.705387, 227.53259277344),
    vector4(-663.747498, -933.227295, 21.829355, 177.50155639648),
}

local PED_MODEL <const> = `s_m_y_ammucity_01`
local spawnedPeds = {}

local pedsSpawned = false

local function spawnAmmuPeds()
    if pedsSpawned then return end
    pedsSpawned = true

    RequestModel(PED_MODEL)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(PED_MODEL) and GetGameTimer() < timeout do
        Wait(10)
    end
    if not HasModelLoaded(PED_MODEL) then
        pedsSpawned = false
        return
    end

    for i = 1, #ammuAutoPoints do
        local p = ammuAutoPoints[i]
        local ped = CreatePed(4, PED_MODEL, p.x, p.y, p.z, p.w, false, true)
        SetEntityCoordsNoOffset(ped, p.x, p.y, p.z, false, false, false)
        SetEntityHeading(ped, p.w)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdoll(ped, false)
        SetPedCanBeTargetted(ped, false)
        SetEntityCanBeDamaged(ped, false)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
        spawnedPeds[#spawnedPeds + 1] = ped
    end

    SetModelAsNoLongerNeeded(PED_MODEL)
end

local function removeAmmuPeds()
    for i = 1, #spawnedPeds do
        if DoesEntityExist(spawnedPeds[i]) then
            DeleteEntity(spawnedPeds[i])
        end
    end
    spawnedPeds = {}
    pedsSpawned = false
end

local ammuWeapons <const> = {
    {
        cat_name = "Armes de poing",
        value = "petit",
        weapons = {
            {name = "Couteau", hash = "WEAPON_KNIFE", price = 30000},
            {name = "Batte", hash = "WEAPON_BAT", price = 15000},
            {name = "Marteau", hash = "WEAPON_HAMMER", price = 20000},
            {name = "Pied de biche", hash = "WEAPON_CROWBAR", price = 15000},
            {name = "Club de golf", hash = "WEAPON_GOLFCLUB", price = 15000},
            {name = "Machette", hash = "WEAPON_MACHETE", price = 35000},
            {name = "Poing américain", hash = "WEAPON_KNUCKLE", price = 25000},
            {name = "Couteau pliant", hash = "WEAPON_SWITCHBLADE", price = 40000},
            {name = "Dague", hash = "WEAPON_DAGGER", price = 40000},
            {name = "Bouteille", hash = "WEAPON_BOTTLE", price = 10000},
        },
    },
    {
        cat_name = "Armes",
        value = "moyen",
        weapons = {
            {name = "Pistolet 9mm", hash = "WEAPON_PISTOL", price = 250000},
            {name = "Pistolet lourd", hash = "WEAPON_HEAVYPISTOL", price = 300000},
            {name = "Pistolet cal50", hash = "WEAPON_PISTOL50", price = 350000},
            {name = "SMG MK2", hash = "WEAPON_SMG_MK2", price = 800000},
            {name = "Fusil Double Action", hash = "WEAPON_DOUBLEACTION", price = 650000},
        },
    },
    {
        cat_name = "Accessoires",
        value = "acc",
        weapons = {
            {name = "Gilet pare-balles", hash = "WEAPON_BULLET", price = 30000},
            {name = "Gilet pare-balles lourd", hash = "WEAPON_BULLET2", price = 55000},
            {name = "Chargeur Pistolet", hash = "clippistol", price = 1500},
            {name = "Chargeur SMG", hash = "clipsmg", price = 1500},
            {name = "Chargeur Revolver", hash = "cliprevolver", price = 1500},
            {name = "Chargeur Fusil", hash = "clipfusil", price = 1500},
            {name = "Chargeur Pompe", hash = "clippompe", price = 1500},
            {name = "Grip", hash = "grip", price = 150},
            {name = "Silencieux", hash = "silencieux", price = 300},
            {name = "Flashlight", hash = "flashlight", price = 200},
            {name = "Jumelles", hash = "jumelles", price = 200},
            {name = "Skin digital MK2", hash = "digital", price = 40000},
            {name = "Skin Squelette MK2", hash = "skull", price = 40000},
            {name = "Skin Sessanta MK2", hash = "sessanta", price = 40000},
            {name = "Skin Perseus MK2", hash = "perseus", price = 40000},
            {name = "Skin Léopard MK2", hash = "leopard", price = 40000},
            {name = "Skin Patriotic", hash = "patriotic", price = 40000},
            {name = "Skin de luxe", hash = "yusuf", price = 25000},
        },
    },
}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local ammuAutoPreviews <const> = {
    [1] = {
        weapon = vector4(14.183762, -1112.859850, 30.092149, 159.43266296387),
        cam    = vector3(14.782324, -1111.635620, 30.097184),
    },
    [2] = {
        weapon = vector4(815.554852, -2149.296904, 29.834119, 359.45188903809),
        cam    = vector3(815.487183, -2150.489014, 29.919175),
    },
}

local PREVIEW_FOV       <const> = 45.0
local PREVIEW_BLEND_MS  <const> = 500

local ammuPreviewProps <const> = {
    ["WEAPON_BULLET"]  = `prop_armour_pickup`,
    ["WEAPON_BULLET2"] = `prop_armour_pickup`,
    ["grip"]           = `w_at_afgrip`,
    ["silencieux"]     = `w_at_pi_supp`,
    ["flashlight"]     = `w_at_pi_flsh`,
}

local previewModelCache = {}

local function ammuPreviewModelFor(itemHash)
    local cached = previewModelCache[itemHash]
    if cached ~= nil then
        return cached or nil
    end

    local model = ammuPreviewProps[itemHash]
    if not model then
        local weapon = GetHashKey(itemHash)
        if IsWeaponValid(weapon) then
            model = GetWeapontypeModel(weapon)
        end
    end

    if not model or model == 0 or not IsModelValid(model) or not IsModelInCdimage(model) then
        previewModelCache[itemHash] = false
        return nil
    end

    previewModelCache[itemHash] = model
    return model
end

local previewSite   = nil
local previewCam    = nil
local previewObj    = nil
local previewItem   = nil
local previewGen    = 0

local function ammuPreviewDeleteObject()
    if previewObj and DoesEntityExist(previewObj) then
        DeleteEntity(previewObj)
    end
    previewObj = nil
end

local function ammuShowPreview(itemHash)
    if not previewSite or previewItem == itemHash then
        return
    end

    previewItem = itemHash
    previewGen = previewGen + 1
    local gen = previewGen

    local model = itemHash and ammuPreviewModelFor(itemHash) or nil
    if not model then
        ammuPreviewDeleteObject()
        return
    end

    Citizen.CreateThread(function()
        RequestModel(model)
        local timeout = GetGameTimer() + 3000
        while not HasModelLoaded(model) and GetGameTimer() < timeout do
            Wait(10)
        end

        if gen ~= previewGen or not previewSite or not HasModelLoaded(model) then
            SetModelAsNoLongerNeeded(model)
            return
        end

        ammuPreviewDeleteObject()

        local p = previewSite.weapon
        local obj = CreateObject(model, p.x, p.y, p.z, false, false, false)
        SetEntityCoordsNoOffset(obj, p.x, p.y, p.z, false, false, false)
        SetEntityHeading(obj, p.w)
        FreezeEntityPosition(obj, true)
        SetEntityCollision(obj, false, false)
        SetEntityInvincible(obj, true)
        previewObj = obj

        SetModelAsNoLongerNeeded(model)
    end)
end

local function ammuStartPreview(site)
    previewSite = site
    if not site or previewCam then
        return
    end

    local c, w = site.cam, site.weapon

    previewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(previewCam, c.x, c.y, c.z)
    SetCamFov(previewCam, PREVIEW_FOV)
    PointCamAtCoord(previewCam, w.x, w.y, w.z)
    SetCamActive(previewCam, true)
    RenderScriptCams(true, true, PREVIEW_BLEND_MS, true, true)
end

local function ammuStopPreview()
    previewGen = previewGen + 1
    previewSite = nil
    previewItem = nil
    ammuPreviewDeleteObject()

    if previewCam then
        RenderScriptCams(false, true, PREVIEW_BLEND_MS, true, true)
        DestroyCam(previewCam, false)
        previewCam = nil
    end
end

local PREVIEW_BLOCKED_CONTROLS <const> = { 21, 22, 30, 31, 32, 33, 34, 35, 36 }

local function ammuPreviewBlockMovement()
    for i = 1, #PREVIEW_BLOCKED_CONTROLS do
        DisableControlAction(0, PREVIEW_BLOCKED_CONTROLS[i], true)
    end
end

Citizen.CreateThread(function()
    RMenu.Add('ammuAuto', 'main', RageUI.CreateMenu("SunLife", "Armurerie automatique", 1, 100))
    RMenu:Get('ammuAuto', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('ammuAuto', 'main').EnableMouse = false
    RMenu:Get('ammuAuto', 'main').Closed = function()
        openAmmuAuto = false
    end

    RMenu.Add('ammuAuto', 'confirm', RageUI.CreateSubMenu(RMenu:Get('ammuAuto', 'main'), "SunLife", "Achat", 1, 100))
    RMenu:Get('ammuAuto', 'confirm'):SetRectangleBanner(255, 117, 31, 225)

    for _, cat in pairs(ammuWeapons) do
        RMenu.Add('ammuAuto', cat.value, RageUI.CreateSubMenu(RMenu:Get('ammuAuto', 'main'), "SunLife", cat.cat_name, 1, 100))
        RMenu:Get('ammuAuto', cat.value):SetRectangleBanner(255, 117, 31, 225)
        RMenu:Get('ammuAuto', cat.value):SetSubtitle(cat.cat_name)
    end
end)

function openAmmuAutoMenu(pointIndex)
    if openAmmuAuto then
        return
    end
    openAmmuAuto = true
    RageUI.Visible(RMenu:Get('ammuAuto', 'main'), true)

    ammuStartPreview(pointIndex and ammuAutoPreviews[pointIndex] or nil)

    Citizen.CreateThread(function()
        while openAmmuAuto do
            if previewSite then
                ammuPreviewBlockMovement()
            end

            RageUI.IsVisible(RMenu:Get('ammuAuto', 'main'), true, true, true, function()

                ammuShowPreview(nil)

                if not ammuAutoActive then
                    RageUI.CloseAll()
                    openAmmuAuto = false
                    return
                end
                for _, cat in pairs(ammuWeapons) do
                    RageUI.ButtonWithStyle(cat.cat_name, nil, {RightLabel = "→"}, true, function(_, _, _)
                    end, RMenu:Get('ammuAuto', cat.value))
                end
            end, function()
            end)

            for _, cat in pairs(ammuWeapons) do
                RageUI.IsVisible(RMenu:Get('ammuAuto', cat.value), true, true, true, function()
                    for _, w in pairs(cat.weapons) do
                        -- Affichage seulement : la regle est verifiee cote serveur.
                        -- Sans PPA, le PNJ ne vend que la melee et le SMG Mk II.
                        local needsPPA = cat.value == "moyen" and w.hash ~= "WEAPON_SMG_MK2"
                        local desc = needsPPA and "~r~PPA obligatoire~s~ : sans permis de port d'arme à votre nom, voyez un armurier." or nil
                        local right = ESX.Math.GroupDigits(w.price) .. "$" .. (needsPPA and "  🔒 PPA" or "")
                        RageUI.ButtonWithStyle(firstToUpper(w.name), desc, {RightLabel = right}, true, function(_, Active, Selected)
                            if Active then
                                ammuShowPreview(w.hash)
                            end
                            if Selected then
                                selectedWeapon.hash = w.hash
                                selectedWeapon.price = w.price
                                selectedWeapon.label = w.name
                                buyAmount = 1
                            end
                        end, RMenu:Get('ammuAuto', 'confirm'))
                    end
                end, function()
                end)
            end

            RageUI.IsVisible(RMenu:Get('ammuAuto', 'confirm'), true, true, true, function()
                RageUI.ButtonWithStyle("Article", nil, {RightLabel = selectedWeapon.label or "-"}, true, function(_, _, _)
                end)

                RageUI.ButtonWithStyle("Quantité", nil, {RightLabel = ESX.Math.GroupDigits(buyAmount)}, true, function(_, _, Selected)
                    if Selected then
                        local input = lib.inputDialog("Quantité à acheter", {
                            { type = "number", label = "Quantité", default = buyAmount, min = 1, max = 10 }
                        })
                        if input and input[1] then
                            buyAmount = tonumber(input[1]) or 1
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Acheter", nil, {RightLabel = selectedWeapon.hash and (ESX.Math.GroupDigits(selectedWeapon.price * buyAmount) .. "$") or nil}, true, function(_, _, Selected)
                    if Selected and selectedWeapon.hash then
                        TriggerServerEvent('sJobs:ammuAuto:buy', selectedWeapon.hash, buyAmount)
                        RageUI.CloseAll()
                        openAmmuAuto = false
                    end
                end)
            end, function()
            end)

            Wait(0)
        end

        ammuStopPreview()
    end)
end

Citizen.CreateThread(function()
    for i = 1, #ammuAutoPoints do
        local p = ammuAutoPoints[i]
        lib.points.new({
            coords = vector3(p.x, p.y, p.z),
            distance = 10,
            nearby = function(self)

                if not ammuAutoActive then
                    return
                end
                if self.currentDistance < 3.0 then
                    DrawMarker(6, self.coords.x, self.coords.y, self.coords.z - 0.8, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour acheter des armes (armurerie automatique)")
                    if IsControlJustPressed(0, 38) and not openAmmuAuto then
                        openAmmuAutoMenu(i)
                    end
                end
            end
        })
    end
end)

RegisterNetEvent('sJobs:ammuAuto:sync', function(active)
    ammuAutoActive = active and true or false
    if ammuAutoActive then
        spawnAmmuPeds()
    else
        removeAmmuPeds()
        if openAmmuAuto then
            RageUI.CloseAll()
            openAmmuAuto = false
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        removeAmmuPeds()

        ammuStopPreview()
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    Wait(1000)
    TriggerServerEvent('sJobs:ammuAuto:request')
end)

RegisterNetEvent('esx:playerLoaded', function()
    TriggerServerEvent('sJobs:ammuAuto:request')
end)
