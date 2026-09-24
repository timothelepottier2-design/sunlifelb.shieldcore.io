ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect",function(a)
                ESX = a
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    ESX.TriggerServerCallback("doorlock:getDoorInfo", function(b)
        for c, d in pairs(b) do
            ConfigDoorlock.DoorList[c].locked = d
        end
    end)
end)

RegisterNetEvent("esx:affiliateJob")
AddEventHandler("esx:affiliateJob", function(e)
    ESX.PlayerData.job = e
end)

Citizen.CreateThread(function()
    while true do
        local ongoing = false
        for f, c in ipairs(ConfigDoorlock.DoorList) do
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), c.textCoords, true)

            if dst < 10.0 then
                ongoing = true
                if c.doors then
                    for g, h in ipairs(c.doors) do
                        if not h.object or not DoesEntityExist(h.object) then
                            if type(h.objName) == "number" then
                                h.object = GetClosestObjectOfType(h.objCoords, 1.0, h.objName, false, false, false)
                            else
                                h.object = GetClosestObjectOfType(h.objCoords, 1.0, GetHashKey(h.objName), false, false, false)
                            end
                        end
                    end
                else
                    if not c.object or not DoesEntityExist(c.object) then
                        c.object = GetClosestObjectOfType(c.objCoords, 1.0, GetHashKey(c.objName), false, false, false)
                    end
                end
            end
        end

        if ongoing then
            Citizen.Wait(0)
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local sleep = 500
        local nearbyDoor = false

        for doorIndex, doorData in ipairs(ConfigDoorlock.DoorList) do
            local distanceToDoor
            if doorData.doors then
                distanceToDoor = #(playerCoords - doorData.doors[1].objCoords)
            else
                distanceToDoor = #(playerCoords - doorData.objCoords)
            end

            local maxDistance = doorData.distance or 1.25
            if distanceToDoor < 10 then
                nearbyDoor = true
                freezeDoor(doorData)
            end

            if distanceToDoor < maxDistance then
                local iconSize = doorData.size or 1
                local iconText = doorData.locked and "🔒" or "🔓"

                ESX.Game.Utils.DrawText3D(doorData.textCoords, iconText, iconSize)

                if IsControlJustReleased(0, 38) and IsAuthorized(doorData) then
                    TriggerEvent("sound:play", "lockadoor", 1.00)
                    doorData.locked = not doorData.locked
                    TriggerServerEvent("doorlock:updateState", doorIndex, doorData.locked)
                end
            end
        end

        if not nearbyDoor then
            Citizen.Wait(sleep)
        else
            Citizen.Wait(0)
        end
    end
end)

function freezeDoor(doorData)
    if doorData.doors then
        for _, door in ipairs(doorData.doors) do
            FreezeEntityPosition(door.object, doorData.locked)
        end
    else
        FreezeEntityPosition(doorData.object, doorData.locked)
    end
end

function IsAuthorized(c)
    if ESX.PlayerData.job == nil then
        return false
    end

    for f, e in pairs(c.authorizedJobs) do
        if e == ESX.PlayerData.job.name then
            return true
        end
    end
    return false
end

RegisterNetEvent("doorlock:setState")
AddEventHandler("doorlock:setState", function(c, d)
    ConfigDoorlock.DoorList[c].locked = d
end)

local Doorlock = false
local garage = false

RegisterCommand("doorlockdo", function(source, args, rawCommand)
    if Doorlock then
        Doorlock = false
        ESX.ShowNotification("Doorlock ~r~OFF~w~!")
    else

        if args[1] == nil then

            return
        elseif args[2] == nil then

            return
        end

        job = args[1]
        distance = args[2]
        garage = args[3]
        ESX.ShowNotification("Doorlock ~g~ON~w~!")
        Doorlock = true

        StartMainDoorlockLoop()
    end
end)

function StartMainDoorlockLoop()
    Citizen.CreateThread(function()
        while true do
            if Doorlock then
                local IsFound, Object = GetEntityPlayerIsFreeAimingAt(PlayerId())

                if IsFound then
                    Doorlock = false
                    local _,__,yaw = table.unpack(GetEntityRotation(Object))

                    TriggerServerEvent("doorlock:SaveOnConfig", yaw, GetEntityCoords(Object), GetEntityModel(Object), job, Object, distance, garage)
                    break
                end
            end
            Citizen.Wait(500)
        end
    end)
end
