World = {}


function World.GetDistanceBetweenCoords(coords1, coords2)
    local coords1 = vector3(coords1.x, coords1.y, coords1.z)
    local coords2 = vector3(coords2.x, coords2.y, coords2.z)
    return #(coords1 - coords2)
end

function World.GetPlayersServerIdsInZone(size)
    local players = {}

    local currentPosition = GetEntityCoords(PlayerPedId())
    for k,v in pairs(GetActivePlayers()) do
        local position = GetEntityCoords(GetPlayerPed(v))
        if World.GetDistanceBetweenCoords(currentPosition, position) <= size then
            table.insert(players, GetPlayerServerId(v))
        end
    end
    return players
end
local zeubHumide = {}
local MAX_HEADSHOTS = 15
local ACTIVE_THREADS_LIMIT = 1
local activeThreads = 0
local lastHeadshotCheck = 0
local headshotInterval = 5000 -- Intervalle minimum entre deux check (en ms)


function World.GetPlayersServerIdsInZoneForMug(size)
    local players = {}
    local currentPosition = GetEntityCoords(PlayerPedId())

    for _, playerId in pairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(playerId)
        local playerServerId = GetPlayerServerId(playerId)

        -- Ignorer le joueur local
        if playerServerId ~= GetPlayerServerId(PlayerId()) then
            local playerPosition = GetEntityCoords(playerPed)
            local distance = #(currentPosition - playerPosition)

            -- Si le joueur est dans le rayon spécifié
            if distance <= size then
                table.insert(players, {id = playerServerId})
            end
        end
    end

    return players
end


RegisterNetEvent("inv:get:getStaffService", function (tables)
    zeubHumide = tables
end)

function World.GetClosetPlayer()
    local player = 0
    local distance = 100

    local pPos = Player.GetPos()
    for k,v in pairs(GetActivePlayers()) do
        if v ~= GetPlayerIndex() then
            local position = GetEntityCoords(GetPlayerPed(v))
            local distanceToPlayer = World.GetDistanceBetweenCoords(pPos, position)
            if distanceToPlayer < distance then
                player = v
                distance = distanceToPlayer
            end
        end
    end

    return player, distance
end

function World.DisplayClosetPlayer()
    local player, distance = World.GetClosetPlayer()
    if player ~= 0 then
        local pPos = GetEntityCoords(GetPlayerPed(player), true)
        DrawMarker(20, pPos.x, pPos.y, pPos.z + 1.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
    end
end

function World.GetClosetVehicle(pos)
    local vehicle = 0
    local distance = 100

    local pPos
    if pos == nil then
        pPos = Player.GetPos()
    else
        pPos = pos
    end
    for k, v in pairs(Utils.EnumerateVehicles()) do
        local position = GetEntityCoords(v)
        local distanceToVehicle = World.GetDistanceBetweenCoords(pPos, position)
        if distanceToVehicle < distance then
            vehicle = v
            distance = distanceToVehicle
        end
    end

    return vehicle, distance
end

function World.DisplayClosetVehicle()
    local vehicle, distance = World.GetClosetVehicle()
    if vehicle ~= 0 then
        local vPos = GetEntityCoords(vehicle, true)
        DrawMarker(20, vPos.x, vPos.y, vPos.z + 1.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255, 255, 200, 1, true, 2, 0, nil, nil, 0)
    end
end

function World.GetClosetObject(pos, model, dst)
    local object = 0
    local distance = dst

    local pPos
    if pos == nil then
        pPos = Player.GetPos()
    else
        pPos = pos
    end
    for k, v in pairs(Utils.EnumerateObjects()) do
        if GetEntityModel(v) == model then
            local position = GetEntityCoords(v)
            local distanceToVehicle = World.GetDistanceBetweenCoords(pPos, position)
            if distanceToVehicle < distance then
                object = v
                distance = distanceToVehicle
            end
        end
    end

    return object, distance
end

function World.IsAreaEmpty(pos, radius)
    local IsEmpty = true
    local veh, dst = World.GetClosetVehicle(pos)
    if veh ~= 0 then
        if dst <= radius then
            IsEmpty = false
        end
    end
    return IsEmpty
end

function World.LoadModel(modelName)
    local model = GetHashKey(modelName)
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        return model
    else
        print("ERROR: Model " .. modelName .. " not found")
        return false
    end
end

function World.LoadModelFromHash(modelName)
    local model = modelName
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        return model
    else
        print("ERROR: Model " .. modelName .. " not found")
        return false
    end
end

function World.CreatePed(modelName, position)
    local model = World.LoadModel(modelName)
    if model ~= false then
        print(('^6[NETDIAG][PED]^7 %s world.lua:181 CreatePed NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(modelName)))
        local ped = CreatePed(4, model, position.x, position.y, position.z, position.w, true, false)
        SetEntityAsMissionEntity(ped, true, true)
        return ped
    else
        return false
    end
end
function World.CreateLocalPed(modelName, position)
    local model = World.LoadModel(modelName)
    if model ~= false then
        local ped = CreatePed(4, model, position.x, position.y, position.z, position.w, false, false)
        SetEntityAsMissionEntity(ped, true, true)
        return ped
    else
        return false
    end
end

function World.CreateVehicle(modelName, position, networked)
    local model = World.LoadModel(modelName)
    if model ~= false then
        print(('^5[NETDIAG][VEHICLE]^7 %s world.lua:202 CreateVehicle networked=%s model=%s'):format(GetCurrentResourceName(), tostring(networked), tostring(modelName)))
        local vehicle = CreateVehicle(model, position.x, position.y, position.z, position.w, networked, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        return vehicle
    else
        return false
    end
end

function World.CreateVehicleWithPlayerHeading(modelName, position, networked)
    local model = World.LoadModel(modelName)
    if model ~= false then
        print(('^5[NETDIAG][VEHICLE]^7 %s world.lua:213 CreateVehicle networked=%s model=%s'):format(GetCurrentResourceName(), tostring(networked), tostring(modelName)))
        local vehicle = CreateVehicle(model, position.x, position.y, position.z, Player.GetHeading(), networked, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        return vehicle
    else
        return false
    end
end

function World.CreateLocalObject(modelName, position)
    local model = World.LoadModel(modelName)
    if model ~= false then
        local object = CreateObject(model, position.x, position.y, position.z, false, true, true)
        SetEntityAsMissionEntity(object, true, true)
        return object
    else
        return false
    end
end

function World.CreateObject(modelName, position)
    local model = World.LoadModel(modelName)
    if model ~= false then
        print(('^2[NETDIAG][OBJET]^7 %s world.lua:238 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(modelName)))
        local object = CreateObject(model, position.x, position.y, position.z, true, true, false)
        SetEntityAsMissionEntity(object, true, true)
        return object
    else
        return false
    end
end

function World.IsPositionFree(position, range)
    local isFree = true
    local entityOnPosition = 0
    for k, entity in pairs(Utils.EnumerateVehicles()) do
        local coords = GetEntityCoords(entity)
        if World.GetDistanceBetweenCoords(position, coords) <= range then
            isFree = false
            entityOnPosition = entity
        end
    end
    return isFree, entityOnPosition
end

function World.AddBlip(name, pos, sprite, scale, color)
    local blip = AddBlipForCoord(pos)

    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

function World.DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end