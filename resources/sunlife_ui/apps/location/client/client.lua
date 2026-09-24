local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'location', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'location', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('location/' .. name, cb)
end

OpenLocation = function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "openRent",
		resource = "SNL_Location",
		vehicles = data.vehicles
	})
end

local function awaitLocResult(timeoutMs)
    locCallback = nil
    local waited = 0
    local limit = timeoutMs or 10000
    while locCallback == nil and waited < limit do
        Citizen.Wait(50)
        waited = waited + 50
    end
    return locCallback
end

RegisterNUICallback('rent', function(data, cb)

    local price = tonumber(data.price) or 0
    local label = data.name or data.displayName or "Véhicule"
    local model = (data.nameHash or data.hash or data.model or data.name)

    if not model or model == "" then
        ESX.ShowNotification("~r~Modèle invalide pour la location.")
        cb('ok')
        return
    end

    TriggerServerEvent("loc:buyLoc", price)
    local result = awaitLocResult(10000)

    if result == 'can_spawn' then

        local p = pos and pos.x and pos or GetEntityCoords(PlayerPedId())
        local h = heading or GetEntityHeading(PlayerPedId())

        spawnLocCar(model)
        ESX.ShowNotification(("~r~-%s$ ~s~| ~g~%s loué"):format(GroupDigits(price), label))
    elseif result == 'not_enough_money' then
        ESX.ShowNotification(("~r~Pas assez d'argent (~o~%s$~r~)"):format(GroupDigits(price)))
    else
        ESX.ShowNotification("~r~Location indisponible pour le moment.")
    end

    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
	SetNuiFocus(false, false)
	cb('ok')
end)

ESX = nil

local LocActive = false
local sortauto = false
local pos = {}
local heading = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent("loc:callback")
AddEventHandler("loc:callback", function(cb)
	locCallback = cb
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

function generateLocPlate()
    local plateNumber = "LOC-" .. string.format("%03d", math.random(1, 999))
    return plateNumber
end

local function isVec3(v)
    return type(v) == "vector3" or (type(v) == "table" and v.x and v.y and v.z)
end

local function dist(a, b)
    return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z))
end

local function getNearestRentalSpawn()
    local ped = PlayerPedId()
    local p = GetEntityCoords(ped)

    local best = nil
    local bestD = nil

    local function scan(list)
        if not list then return end
        for _, v in pairs(list) do
            if v.menupos and v.spawnpos and v.h then
                local d = dist(p, v.menupos)
                if not bestD or d < bestD then
                    bestD = d
                    best = { pos = v.spawnpos, h = v.h }
                end
            end
        end
    end

    scan(LocConfig.vehiclespositions)
    scan(LocConfig.boatspositions)

    return best, (bestD or 99999.0)
end

local function findClearSpot(startPos, heading)
    local pos = startPos
    if not pos then return nil end

    local tries = {
        { x = 0.0,  y = 0.0 },
        { x = 2.5,  y = 0.0 },
        { x = -2.5, y = 0.0 },
        { x = 0.0,  y = 2.5 },
        { x = 0.0,  y = -2.5 },
        { x = 4.0,  y = 0.0 },
    }

    local hdg = heading or 0.0
    local rad = math.rad(hdg)

    for _, o in ipairs(tries) do
        local dx =  o.x * math.cos(rad) - o.y * math.sin(rad)
        local dy =  o.x * math.sin(rad) + o.y * math.cos(rad)
        local test = vector3(pos.x + dx, pos.y + dy, pos.z)
        if not IsAnyVehicleNearPoint(test.x, test.y, test.z, 2.3) then

            local found, z = GetGroundZFor_3dCoord(test.x, test.y, test.z, false)
            if found then test = vector3(test.x, test.y, z + 0.5) end
            return test
        end
    end
    return pos
end

function spawnLocCar(car, pos, heading)
    local modelHash = GetHashKey(car)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    local useAuto = true
    if pos and pos.x and pos.y and pos.z then
        local d = #(vector3(pos.x, pos.y, pos.z) - pedCoords)
        useAuto = (d <= 5.0)
    end

    if useAuto then
        local nearest = getNearestRentalSpawn()
        if nearest then
            pos = nearest.pos
            heading = nearest.h
        else
            pos = pedCoords
            heading = GetEntityHeading(ped)
        end
    end

    local spawnAt = findClearSpot(pos, heading or 0.0)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)
        Citizen.Wait(0)
    end

    TriggerServerEvent('eye:veh:authorize', modelHash, 'location')
    print(('^5[NETDIAG][VEHICLE]^7 %s client.lua:212 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(modelHash)))
    local vehicle = CreateVehicle(modelHash, spawnAt.x, spawnAt.y, spawnAt.z, heading or 0.0, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleFuelLevel(vehicle, 100.0)

    local plate = generateLocPlate()
    SetVehicleNumberPlateText(vehicle, plate)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)

    ESX.ShowNotification("~o~Véhicule sorti !")
end

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k,v in pairs(LocConfig.vehiclespositions) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.menupos.x, v.menupos.y, v.menupos.z)

			if dist <= 3.0 then
				nearThing = true
				ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de la location de véhicules")
				DrawMarker(6, v.menupos.x, v.menupos.y, v.menupos.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 106, 0, 100)
				if IsControlJustPressed(1,51) then
					if LocActive == false then
						pos = v.spawnpos
						heading = v.h
						v.vehicles = LocConfig.vehicles
						OpenLocation(v)
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(1500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k,v in pairs(LocConfig.boatspositions) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.menupos.x, v.menupos.y, v.menupos.z)

			if dist <= 3.0 then
				nearThing = true
				ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de la location de bateaux")
				DrawMarker(6, v.menupos.x, v.menupos.y, v.menupos.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 106, 0, 140)
				if IsControlJustPressed(1,51) then
					if LocActive == false then
						pos = v.spawnpos
						heading = v.h
						v.vehicles = LocConfig.boats
						OpenLocation(v)
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	Wait(1000)
	for k,v in pairs(LocConfig.vehiclespositions) do
		local bliploc = AddBlipForCoord(v.menupos.x, v.menupos.y, v.menupos.z)
		SetBlipSprite (bliploc, 524)
		SetBlipDisplay(bliploc, 4)
		SetBlipScale(bliploc, 0.8)
		SetBlipColour (bliploc, 14)
		SetBlipAsShortRange(bliploc, true)
		local _key = "BN_SNL_LOCATION_1_" .. tostring(bliploc)
		AddTextEntry(_key, "Location de véhicules")
		BeginTextCommandSetBlipName(_key)
		EndTextCommandSetBlipName(bliploc)
	end
end)

Citizen.CreateThread(function()
	Wait(1000)
	for k,v in pairs(LocConfig.boatspositions) do
		local bliploc = AddBlipForCoord(v.menupos.x, v.menupos.y, v.menupos.z)
		SetBlipSprite (bliploc, 471)
		SetBlipDisplay(bliploc, 4)
		SetBlipScale(bliploc, 0.8)
		SetBlipColour (bliploc, 14)
		SetBlipAsShortRange(bliploc, true)
		local _key = "BN_SNL_LOCATION_2_" .. tostring(bliploc)
		AddTextEntry(_key, "Location de bateaux")
		BeginTextCommandSetBlipName(_key)
		EndTextCommandSetBlipName(bliploc)
	end
end)

function GroupDigits(value)
	if value == nil then return 0 end
	local left,num,right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)', '%1'.." "):reverse())
end
