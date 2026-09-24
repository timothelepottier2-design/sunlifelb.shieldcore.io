ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
end)

local savedPropsConfigs = {}
local placedSavedProps = {}

function SpawnObj(obj)
    local ranks = ESX.PlayerData.rank
	local hasDiamond = false
    local isPolice = false

	for _, rankInfo in ipairs(ranks) do
		if rankInfo.name == "gold" or rankInfo.name == "diamond" or rankInfo.name == "platinium" or rankInfo.name == "legendary" then
			hasDiamond = true
		end
	end

    local PROPS_ALLOWED_JOBS <const> = {
        police    = true,
        sheriff   = true,
        ems       = true,
        fourriere = true,
        marshall  = true,
        lsfd      = true,
        usss      = true,
        gouv      = true,
    }

    if PROPS_ALLOWED_JOBS[ESX.PlayerData.job.name] then
        isPolice = true
    end

    if not hasDiamond and not isPolice then
        ESX.ShowNotification('~r~Il faut être VIP ou policier afin de poser des props au sol !')
        return
    end

    local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    ShowHelpNotification("~g~Appuyez sur E pour poser l'objet")

    SpawnObject(obj, objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end)
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 2.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)

        if IsControlJustReleased(1, 38) then
            placed = true
        end
    end

    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    TriggerServerEvent("props:placed", obj, NetId)

    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    table.insert(object, NetId)
end

function RemoveObj(netId)
    Citizen.CreateThread(function()
        local entity = NetworkGetEntityFromNetworkId(netId)
        if not entity or entity == 0 or not DoesEntityExist(entity) then
            for i = #object, 1, -1 do
                if object[i] == netId then
                    table.remove(object, i)
                    break
                end
            end
            TriggerServerEvent("props:removed", netId)
            return
        end

        SetNetworkIdCanMigrate(netId, true)
        NetworkRequestControlOfEntity(entity)

        local timeout = 0
        while not NetworkHasControlOfEntity(entity) and timeout < 100 do
            NetworkRequestControlOfEntity(entity)
            Wait(50)
            timeout = timeout + 1
        end

        if DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, false, false)
            SetEntityAsNoLongerNeeded(entity)
            TriggerServerEvent("props:deleteEntity", netId)
            DeleteObject(entity)
            DeleteEntity(entity)
            Wait(100)
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end

        for i = #object, 1, -1 do
            if object[i] == netId then
                table.remove(object, i)
                break
            end
        end
        for configId, placedNetId in pairs(placedSavedProps) do
            if placedNetId == netId then
                placedSavedProps[configId] = nil
                break
            end
        end
        TriggerServerEvent("props:removed", netId)
    end)
end

function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end

function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		print(('^2[NETDIAG][OBJET]^7 %s function.lua:150 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end

function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

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

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

ShowHelpNotification = function(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function SavePropToConfig(netId, propName)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return false end

    local coords = GetEntityCoords(entity)
    local rx, ry, rz = GetEntityRotation(entity, 0)
    rx = rx or 0.0
    ry = ry or 0.0
    rz = rz or GetEntityHeading(entity) or 0.0

    TriggerServerEvent("props:saveConfig",
        tostring(propName or GetEntityModel(entity)),
        GetEntityModel(entity),
        coords.x, coords.y, coords.z,
        rx, ry, rz
    )
    return true
end

local SAVED_PROP_PLACE_DISTANCE = 50.0

function PlaceSavedPropAtPosition(config)
    if not config or not config.id then return end

    local existingNetId = placedSavedProps[config.id]
    if existingNetId then
        local entity = NetworkGetEntityFromNetworkId(existingNetId)
        if entity and entity ~= 0 and DoesEntityExist(entity) then
            TriggerEvent("esx:showNotification", "~r~Ce prop est déjà placé sur la map")
            return
        else
            placedSavedProps[config.id] = nil
        end
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local propPos = vector3(tonumber(config.x), tonumber(config.y), tonumber(config.z))
    local dist = #(playerCoords - propPos)

    if dist > SAVED_PROP_PLACE_DISTANCE then
        TriggerEvent("esx:showNotification", "~r~Vous devez être à moins de " .. math.floor(SAVED_PROP_PLACE_DISTANCE) .. "m de l'emplacement pour poser ce prop")
        return
    end

    local obj = SpawnSavedProp(config)
    if obj then
        local NetId = NetworkGetNetworkIdFromEntity(obj)
        placedSavedProps[config.id] = NetId
        table.insert(object, NetId)
        TriggerServerEvent("props:placed", tostring(config.model), NetId)
        TriggerEvent("esx:showNotification", "~g~Prop placé à sa position sauvegardée")
    else
        TriggerEvent("esx:showNotification", "~r~Impossible de placer ce prop")
    end
end

function SpawnSavedProp(config)
    local model = tonumber(config.model)
    if not model or not IsModelInCdimage(model) then return nil end

    RequestModels(model)
    print(('^2[NETDIAG][OBJET]^7 %s function.lua:277 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local obj = CreateObject(model, config.x, config.y, config.z, true, false, true)
    if not DoesEntityExist(obj) then return nil end

    SetEntityRotation(obj, tonumber(config.rx) or 0, tonumber(config.ry) or 0, tonumber(config.rz) or 0, 0)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    PlaceObjectOnGroundProperly(obj)

    return obj
end

function GetSavedPropsConfigs()
    return savedPropsConfigs
end

function SpawnObjByModelHash(modelHash)
    local playerPed = PlayerPedId()
    local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    ShowHelpNotification("Appuyez sur E pour poser l'objet")

    SpawnObjectByHash(tonumber(modelHash), objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end)
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 2.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)

        if IsControlJustReleased(1, 38) then
            placed = true
        end
    end

    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    TriggerServerEvent("props:placed", tostring(modelHash), NetId)

    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    table.insert(object, NetId)
end

function SpawnObjectByHash(modelHash, coords, cb)
    Citizen.CreateThread(function()
        RequestModels(modelHash)
        Wait(1)
        print(('^2[NETDIAG][OBJET]^7 %s function.lua:341 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(modelHash)))
        local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, true, false, true)
        if cb then cb(obj) end
    end)
end

RegisterNetEvent("props:saveConfigResult")
AddEventHandler("props:saveConfigResult", function(success, message)
    if message then
        TriggerEvent("esx:showNotification", message)
    end
end)

RegisterNetEvent("props:placeRejected")
AddEventHandler("props:placeRejected", function(netId)
    if netId then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity and entity ~= 0 and DoesEntityExist(entity) then
            DeleteObject(entity)
            DeleteEntity(entity)
        end
        for i = #object, 1, -1 do
            if object[i] == netId then
                table.remove(object, i)
                break
            end
        end
        for configId, placedNetId in pairs(placedSavedProps) do
            if placedNetId == netId then
                placedSavedProps[configId] = nil
                break
            end
        end
    end
end)

RegisterNetEvent("props:loadConfigsResult")
AddEventHandler("props:loadConfigsResult", function(configs)
    savedPropsConfigs = configs or {}
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    TriggerServerEvent("props:loadConfigs")
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    TriggerServerEvent("props:loadConfigs")
end)

function DeleteSavedProp(configId)
    TriggerServerEvent("props:deleteConfig", configId)
end

RegisterNetEvent("props:deleteConfigResult")
AddEventHandler("props:deleteConfigResult", function()
    TriggerServerEvent("props:loadConfigs")
    TriggerEvent("esx:showNotification", "~g~Prop sauvegardé supprimé")
end)
