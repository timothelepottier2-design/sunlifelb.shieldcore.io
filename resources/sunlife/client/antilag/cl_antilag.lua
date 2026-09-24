ANTILAG = {}
ANTILAG.enabled = false

local p_flame_location = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4"
}
local p_flame_particle = "veh_backfire"
local p_flame_particle_asset = "core"
local p_flame_size = 2.5

local p_backfire_explosion = 0

local function PlayAntilagEffect(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end

    local vPos = GetEntityCoords(vehicle)

    AddExplosion(vPos.x, vPos.y, vPos.z, p_backfire_explosion, 0.0, true, true, 0.0, true)

    if not HasNamedPtfxAssetLoaded(p_flame_particle_asset) then
        RequestNamedPtfxAsset(p_flame_particle_asset)
        while not HasNamedPtfxAssetLoaded(p_flame_particle_asset) do
            Wait(0)
        end
    end

    for _, bones in pairs(p_flame_location) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, bones)
        if boneIndex ~= -1 then
            UseParticleFxAssetNextCall(p_flame_particle_asset)
            StartParticleFxNonLoopedOnEntityBone(p_flame_particle, vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, p_flame_size, false, false, false)
        end
    end
end

RegisterCommand("antilag", function(source, args, rawCommand)
    ESX.PlayerData = ESX.GetPlayerData()

    local ranks = ESX.PlayerData.rank
	local hasVIP = false

	if ranks then
		for _, rankInfo in ipairs(ranks) do
			if rankInfo.name == "gold" or rankInfo.name == "diamond" or rankInfo.name == "platinium" or rankInfo.name == "legendary" then
				hasVIP = true
			end
		end
	end

    if hasVIP == true then
        if ANTILAG.enabled then
            ESX.ShowNotification("~r~Antilag désactivé")
            ANTILAG.enabled = false
        else
            ESX.ShowNotification("~g~Antilag activé")
            ANTILAG.enable()
        end
    else
        ESX.ShowNotification("~r~L'antilag est uniquement disponible pour les VIP Diamond !")
    end
end)

ANTILAG.enable = function()
    if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 8 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 16 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 15 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 14 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 13 then ESX.ShowNotification("~r~Ce véhicule ne peut pas activer l'antilag") return end

    ANTILAG.enabled = true
    Citizen.CreateThread(function()
        local myServerId = GetPlayerServerId(PlayerId())
        while ANTILAG.enabled do
            local ped = PlayerPedId()

            if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                if IsPedInAnyVehicle(ped) then
                    local pedVehicle = GetVehiclePedIsIn(ped)
                    local RPM = GetVehicleCurrentRpm(pedVehicle)
                    local AntiLagDelay = (math.random(200, 700))
                    if GetPedInVehicleSeat(pedVehicle, -1) == ped then
                        if RPM > 0.75 then
                            local playersInArea = GetPlayersInArea(GetEntityCoords(ped), 100.0)
                            local inAreaData = {}

                            for i=1, #playersInArea, 1 do
                                local sid = GetPlayerServerId(playersInArea[i])
                                if sid ~= myServerId then
                                    inAreaData[#inAreaData+1] = sid
                                end
                            end

                            TriggerServerEvent("sunLife:antilag", inAreaData, GetVehicleNumberPlateText(pedVehicle))

                            PlayAntilagEffect(pedVehicle)
                            SetVehicleTurboPressure(pedVehicle, 25)
                            Wait(AntiLagDelay)
                        end
                    end
                else
                    ANTILAG.enabled = false
                end
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent("sunLife:sendAntilag")
AddEventHandler("sunLife:sendAntilag", function(plate)
    local vehicles = GetVehicles()

    for k,v in pairs(vehicles) do
        if GetVehicleNumberPlateText(v) == plate then
            PlayAntilagEffect(v)
        end
    end
end)

GetPlayers = function()
	local maxPlayers = 255
	local players    = {}

	for i=0, maxPlayers, 1 do
		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end

GetPlayersInArea = function(coords, area)
	local players       = GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
