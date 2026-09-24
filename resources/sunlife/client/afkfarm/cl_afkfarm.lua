local InAfkZone = false
active_vehicle = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    PlayerData = ESX.GetPlayerData()
end)

AFK = {

    ["entry"] = {
        pos = vector3(238.407486, -817.106934, 30.176451),
        heading = 70.915908813477,
        ped = {
            model = "a_m_y_business_03",
            scenario = "WORLD_HUMAN_CLIPBOARD",
        },
    },

    ["shop"] = {
        pos = vector3(239.319077, -814.786377, 30.201384),
        heading = 70.460563659668,
        ped = {
            model = "s_m_m_autoshop_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
        },
    },
    ["points"] = {
        ["afkzones"] = {
            {pos = vector3(-1620.916260, -848.248535, 10.131706)},
        },
		["boutique"] = {
            {pos = vector3(-1274.8911132812, -3006.1984863281, -49.489894866943)},
        },

        ["sortie"] = {
            {pos = vector3(-1258.9895019531, -3006.1589355469, -49.490177154541)},
        },

        ["entree"] = {
            {pos = vector3(238.407486, -817.106934, 30.176451)},
        },
        ["vehicules"] = {
            {pos = vector3(896.9922, -2105.902, 30.23097)},
        },
        ["sauvetage"] = {
            {pos = vector3(-1258.9895019531, -3006.1589355469, -49.490177154541)},
        },
        ["roue"] = {
            {pos = vector3(-1268.6359863281, -3005.1374511719, -48.490047454834)},
        },
    },
	listVehicles = {
		{label = 'Arias', model = 'arias', price = 2000},
        {label = 'Playboy', model = 'playboy', price = 2500},
        {label = 'Nspeedo', model = 'nspeedo', price = 3000},
        {label = 'Spritzer', model = 'spritzer', price = 3500},
        {label = 'Sunrise', model = 'sunrise1', price = 4000},
        {label = 'Frakas', model = 'frakas', price = 4500},
        {label = 'Buffalo4h', model = 'buffalo4h', price = 4500},
        {label = 'V-Stretch', model = 'vstretch', price = 5000},
        {label = 'Dubsta4x4', model = 'dubsta4x4', price = 5500},
        {label = 'Tempesta-ES', model = 'tempestaES', price = 6000},
        {label = 'Emerus', model = 'emerus', price = 6500},
        {label = 'Itali-GTR', model = 'italigtr', price = 7000},
        {label = 'Hellfire Coupe', model = 'gstghell1', price = 9000},
        {label = '440GT', model = 'gstbuc1', price = 10000},
        {label = 'Dinka CDY', model = 'gstcdy1', price = 11000},
        {label = 'Buffalo ST', model = 'gstbufst1', price = 13000},
        {label = 'Shinobid', model = 'shinobid', price = 15000},
	},

	-- Purement cosmetique : le serveur ne fait jamais confiance a cette liste,
	-- il ne lit que BOUTIQUE.AFK.listCoins de son cote. Garder les deux
	-- synchronises sinon le prix affiche ne sera pas celui debite.
	listCoins = {
		--{label = '500 Suncoins Boutique', amount = 500, price = 7000},
		--{label = '1000 Suncoins Boutique', amount = 1000, price = 12000},
	},

	listMoney = {
		{label = '50,000$ IG', model = '50000', price = 120},
		{label = '250,000$ IG', model = '250000', price = 480},
		{label = '500,000$ IG', model = '500000', price = 840},
        {label = '1,000,000$ IG', model = '1000000', price = 1440},
	},
    listItem = {
        {label = 'Pistolet de détresse', model = 'WEAPON_FLAREGUN', price = 200},
        {label = 'Gilet pare-balles lourd', model = 'WEAPON_BULLET2', price = 100},
		{label = 'Pistolet Lourd', model = 'WEAPON_HEAVYPISTOL', price = 450},
		{label = 'SMG MK2', model = 'WEAPON_SMG_MK2', price = 800},
	},
	['menuOpenned'] = false
}

local afkEntryPed = nil
local afkShopPed = nil

local AFK_LABEL_DIST = 20.0

local AFK_INTERACT_DIST = 1.4

local function spawnAfkPed(cfg)
    local model = joaat(cfg.ped.model)

    RequestModel(model)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(model) do
        Wait(10)
        if GetGameTimer() > timeout then return nil end
    end

    local ped = CreatePed(4, model, cfg.pos.x, cfg.pos.y, cfg.pos.z - 1.0, cfg.heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)

    if cfg.ped.scenario and cfg.ped.scenario ~= "" then
        TaskStartScenarioInPlace(ped, cfg.ped.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
    return ped
end

local function spawnAfkEntryPed()
    if afkEntryPed and DoesEntityExist(afkEntryPed) then return end
    afkEntryPed = spawnAfkPed(AFK["entry"])
end

local function spawnAfkShopPed()
    if afkShopPed and DoesEntityExist(afkShopPed) then return end
    afkShopPed = spawnAfkPed(AFK["shop"])
end

CreateThread(function()
    spawnAfkEntryPed()
    spawnAfkShopPed()

    Wait(2000)
    TriggerServerEvent("afk:requestState")
end)

Citizen.CreateThread(function()
    while true do
        local nearThing = false

        if not InAfkZone then
            local plyCoords = GetEntityCoords(PlayerPedId(), false)

            local entryCoords = AFK["entry"].pos
            if afkEntryPed and DoesEntityExist(afkEntryPed) then
                entryCoords = GetEntityCoords(afkEntryPed)
            end

            local shopCoords = AFK["shop"].pos
            if afkShopPed and DoesEntityExist(afkShopPed) then
                shopCoords = GetEntityCoords(afkShopPed)
            end

            local entryDist = #(plyCoords - entryCoords)
            local shopDist  = #(plyCoords - shopCoords)

            if entryDist < AFK_LABEL_DIST then
                nearThing = true
                AFK_Draw3DTextH(entryCoords.x, entryCoords.y, entryCoords.z - 0.8, "Zone AFK", 4, 0.2, 0.2, 1)
            end
            if shopDist < AFK_LABEL_DIST then
                nearThing = true
                AFK_Draw3DTextH(shopCoords.x, shopCoords.y, shopCoords.z - 0.8, "Boutique AFK", 4, 0.2, 0.2, 1)
            end

            local nearestIsShop = shopDist < entryDist
            local nearestDist = nearestIsShop and shopDist or entryDist

            if nearestDist < AFK_INTERACT_DIST then
                if nearestIsShop then
                    if not AFK['menuOpenned'] then
                        ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour ouvrir la boutique AFK")
                        if IsControlJustPressed(1, 38) then
                            AFK.openShop()
                        end
                    end
                else
                    ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour accéder à la zone AFK")
                    if IsControlJustPressed(1, 38) then
                        TriggerEvent("afk:enteringAFKZone")
                    end
                end
            end

            for k,v in pairs(AFK["points"]["sauvetage"]) do
		    	local plyCoords = GetEntityCoords(PlayerPedId(), false)
		    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

		    	if dist < 40.0 then
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 117, 31, 225, true, false)
                    AFK_Draw3DTextH(v.pos.x, v.pos.y, v.pos.z - 0.5, "Sortie d'urgence", 4, 0.2, 0.2, 4)
                    nearThing = true
		    		ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour sortir d'urgence de la zone AFK")
		    		if IsControlJustPressed(1, 38) then
						if AFK['menuOpenned'] == false then
		    				TriggerServerEvent("afk:LeaveAFKZone")
						end
		    		end
		    	end
		    end
        end

		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(1500)
		end
	end
end)

RegisterNetEvent('afk:enteringAFKZone')
AddEventHandler('afk:enteringAFKZone', function()
	TriggerServerEvent("afk:EnterAFKZone")
    InAfkZone = true

    local ped = PlayerPedId()
    if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    end

end)

local afkUiOpen = false
local afkLastCoins = 0

local afkCloseGen = 0

local function openAfkUi(payload)
    afkUiOpen = true
    afkLastCoins = (payload and payload.coins) or 0
    SetNuiFocus(true, true)
    SendNUIMessage({ app = 'afk', action = 'open', payload = payload })
end

local function closeAfkUi()
    if not afkUiOpen then return end
    afkUiOpen = false
    afkCloseGen = afkCloseGen + 1
    SetNuiFocus(false, false)
    SendNUIMessage({ app = 'afk', action = 'close' })
end

RegisterNetEvent('afk:ui:open', function(payload)

    InAfkZone = true
    openAfkUi(payload)
end)

RegisterNetEvent('afk:ui:update', function(payload)
    if not afkUiOpen then return end
    SendNUIMessage({ app = 'afk', action = 'update', payload = payload })

    local coins = (payload and payload.coins) or 0
    if coins > afkLastCoins then
        TriggerEvent("sound:play", "victory", 0.35)
        afkLastCoins = coins
    end
end)

RegisterNetEvent('afk:ui:close', function()
    -- Le serveur peut fermer une session de sa propre initiative (sortie
    -- forcee, session expiree, joueur sorti du volume). Sans cette remise a
    -- zero, InAfkZone restait vrai alors que la session n'existait plus :
    --
    --   * le watchdog de recentrage, plus bas, re-teleportait le joueur dans la
    --     zone qu'on venait de lui faire quitter — en bucket 0 et sans session,
    --     donc sans le moindre gain, et sans aucun moyen d'en ressortir ;
    --   * la boucle d'interaction restant desactivee, le ped d'entree ne
    --     repondait plus au [E] : impossible de relancer une session.
    InAfkZone = false
    SetEntityInvincible(PlayerPedId(), false)

    closeAfkUi()
end)

local afkBoardLastFetch = 0
local AFK_BOARD_MIN_INTERVAL = 5000

RegisterNUICallback('afkRequestBoard', function(_, cb)
    cb({})

    if not afkUiOpen then return end

    local now = GetGameTimer()
    if (now - afkBoardLastFetch) < AFK_BOARD_MIN_INTERVAL then return end
    afkBoardLastFetch = now

    local pdata = ESX.GetPlayerData and ESX.GetPlayerData() or nil
    local myIdentifier = pdata and pdata.identifier or nil

    ESX.TriggerServerCallback('BOUTIQUE:getAFKTop', function(rows)
        if not afkUiOpen then return end
        SendNUIMessage({
            app = 'afk',
            action = 'board',
            rows = rows or {},

            me = myIdentifier,
        })
    end)
end)

RegisterNUICallback('afkLeave', function(_, cb)
    cb({})

    if not InAfkZone then
        closeAfkUi()
        return
    end

    InAfkZone = false
    SetEntityInvincible(PlayerPedId(), false)

    SetNuiFocus(false, false)

    TriggerServerEvent("afk:LeaveAFKZone")

    afkCloseGen = afkCloseGen + 1
    local gen = afkCloseGen
    SetTimeout(6000, function()
        if afkCloseGen == gen and afkUiOpen then
            closeAfkUi()
        end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and afkUiOpen then
        SetNuiFocus(false, false)
    end
end)

local canRollWheel = true

AFK.showroom = {
    vehicle = { coords = vector3(237.884262, -808.726807, 30.315510), heading = 71.279396057129 },

    cam     = { coords = vector3(233.281189, -810.605225, 30.387590), heading = 289.04632568359 },
}

local afkPreviewCam = nil
local afkPreviewVehicles = {}
local afkLastPreview = nil

local function afkStopShowroomCamera()
    if not afkPreviewCam then return end
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(afkPreviewCam, false)
    afkPreviewCam = nil
end

local function afkStartShowroomCamera()
    if afkPreviewCam then return end
    local c = AFK.showroom.cam.coords
    local v = AFK.showroom.vehicle.coords

    afkPreviewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(afkPreviewCam, c.x, c.y, c.z)
    PointCamAtCoord(afkPreviewCam, v.x, v.y, v.z + 0.35)
    SetCamFov(afkPreviewCam, 48.0)
    SetCamActive(afkPreviewCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function afkDeletePreviewVehicles()
    for _, veh in pairs(afkPreviewVehicles) do
        if veh and DoesEntityExist(veh) and ESX and ESX.Game then
            ESX.Game.DeleteVehicle(veh)
        end
    end
    afkPreviewVehicles = {}
end

local function afkShowPreviewVehicle(modelName)
    if not ESX or not ESX.Game then return end

    CreateThread(function()
        local hash = GetHashKey(modelName)
        afkDeletePreviewVehicles()

        local sc = AFK.showroom.vehicle.coords
        ESX.Game.SpawnLocalVehicle(hash, { x = sc.x, y = sc.y, z = sc.z }, AFK.showroom.vehicle.heading, function(vehicle)

            if not AFK['menuOpenned'] then
                if vehicle and DoesEntityExist(vehicle) then ESX.Game.DeleteVehicle(vehicle) end
                return
            end

            table.insert(afkPreviewVehicles, vehicle)
            FreezeEntityPosition(vehicle, true)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleDirtLevel(vehicle, 0.0)
            SetVehicleNumberPlateText(vehicle, 'SHOW AFK')
            SetModelAsNoLongerNeeded(hash)

            if afkPreviewCam then
                PointCamAtEntity(afkPreviewCam, vehicle, 0.0, 0.0, 0.25, true)
            end
        end)
    end)
end

local function afkClearPreview()
    if afkLastPreview == nil then return end
    afkLastPreview = nil
    afkDeletePreviewVehicles()
    local v = AFK.showroom.vehicle.coords
    if afkPreviewCam then
        PointCamAtCoord(afkPreviewCam, v.x, v.y, v.z + 0.35)
    end
end

local function afkCloseShowroom()
    afkStopShowroomCamera()
    afkDeletePreviewVehicles()
    afkLastPreview = nil
end

AFK.openShop = function()
    RMenu.Add('afk', 'main', RageUI.CreateMenu('Boutique AFK', 'Dépensez vos AFK Coins', 1, 100))
    RMenu:Get('afk', 'main').Closed = function()
        AFK['menuOpenned'] = false
        afkCloseShowroom()

        RMenu:Delete('afk', 'main')
    end

    if AFK['menuOpenned'] then
        AFK['menuOpenned'] = false
        afkCloseShowroom()
        return
    else
        RageUI.CloseAll()

        AFK['menuOpenned'] = true
        afkStartShowroomCamera()
        RageUI.Visible(RMenu:Get('afk', 'main'), true)
    end

    for name, menu in pairs(RMenu['afk']) do
        RMenu:Get('afk', name):SetRectangleBanner(255, 117, 31, 225)
    end

    local mypoints = 0
    ESX.TriggerServerCallback('BOUTIQUE:getAFKPoints', function(points)
        if points then
            mypoints = points
        end
    end)

    Citizen.CreateThread(function()
        while AFK['menuOpenned'] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('afk', 'main'), true, false, true, function()

				RageUI.Separator("Vous avez " ..mypoints.. " AFK Coins")

                for i = 1, #AFK.listVehicles, 1 do
                    RageUI.ButtonWithStyle(AFK.listVehicles[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listVehicles[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)

                        if Active and afkLastPreview ~= i then
                            afkLastPreview = i
                            afkShowPreviewVehicle(AFK.listVehicles[i].model)
                        end
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKVehicle", i)
                        end
                    end)
                end

                for i = 1, #AFK.listCoins, 1 do
                    RageUI.ButtonWithStyle(AFK.listCoins[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listCoins[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Active then afkClearPreview() end
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKCoins", i)
                        end
                    end)
                end

                for i = 1, #AFK.listMoney, 1 do
                    RageUI.ButtonWithStyle(AFK.listMoney[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listMoney[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Active then afkClearPreview() end
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKMoney", i)
                        end
                    end)
                end

                for i = 1, #AFK.listItem, 1 do
                    RageUI.ButtonWithStyle(AFK.listItem[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listItem[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Active then afkClearPreview() end
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKItem", i)
                        end
                    end)
                end
            end)
        end

        afkCloseShowroom()
    end)
end

local AFK_ZONE_CENTER = vector3(-1267.7, -3016.0, -48.49)
local AFK_ZONE_RADIUS = 70.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        if InAfkZone then
            local coords = GetEntityCoords(PlayerPedId(), true)
            if #(coords - AFK_ZONE_CENTER) > AFK_ZONE_RADIUS then
                SetEntityCoords(PlayerPedId(), AFK_ZONE_CENTER.x, AFK_ZONE_CENTER.y, AFK_ZONE_CENTER.z)
            end
        end
    end
end)

function AFK_Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY,font)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function getAFKStatus()
    return InAfkZone
end

exports("getAFKStatus", function ()
    return getAFKStatus()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if afkEntryPed and DoesEntityExist(afkEntryPed) then
        DeleteEntity(afkEntryPed)
    end
    afkEntryPed = nil

    if afkShopPed and DoesEntityExist(afkShopPed) then
        DeleteEntity(afkShopPed)
    end
    afkShopPed = nil

    afkCloseShowroom()
end)
