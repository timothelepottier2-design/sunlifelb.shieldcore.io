local ESX = exports["es_extended"]:getSharedObject()
local trackerBlip = nil
local installing = false

local function getClosestVehicle(coords, maxDist)
    local vehicles = GetGamePool("CVehicle")
    local closest, closestDist = 0, maxDist
    for i = 1, #vehicles do
        local veh = vehicles[i]
        local dist = #(GetEntityCoords(veh) - coords)
        if dist <= closestDist then
            closest, closestDist = veh, dist
        end
    end
    return closest
end

local function startInstall(veh)
    if installing then return false end
    installing = true
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
    local start = GetGameTimer()
    local duration = 5000
    CreateThread(function()
        while installing do
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            Wait(0)
        end
    end)
    while GetGameTimer() - start < duration do
        if not DoesEntityExist(veh) then installing = false break end
        if #(GetEntityCoords(ped) - GetEntityCoords(veh)) > 8.0 then installing = false break end
        if IsEntityDead(ped) then installing = false break end
        Wait(100)
    end
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    local ok = installing
    installing = false
    return ok
end

CreateThread(function()
    TriggerServerEvent("core:tracker:register")
end)

RegisterNetEvent("esx:playerLoaded", function()
    TriggerServerEvent("core:tracker:register")
end)

RegisterNetEvent("core:tracker:useItem", function()
    if installing then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("Sors du véhicule pour installer le traqueur.")
        return
    end
    local coords = GetEntityCoords(ped)
    local veh = getClosestVehicle(coords, 7.0)
    if veh == 0 then
        ESX.ShowNotification("Aucun véhicule assez proche.")
        return
    end
    if not startInstall(veh) then
        ESX.ShowNotification("Installation annulée.")
        return
    end
    if not NetworkGetEntityIsNetworked(veh) then
        print(('^1[NETDIAG][NETREG]^7 %s main.lua:86 NetworkRegisterEntityAsNetworked(veh=%s)'):format(GetCurrentResourceName(), tostring(veh)))
        NetworkRegisterEntityAsNetworked(veh)
    end
    local netId = VehToNet(veh)
    if not netId or netId == 0 then
        ESX.ShowNotification("Impossible d'installer le traqueur sur ce véhicule.")
        return
    end
    TriggerServerEvent("core:tracker:install", netId)
end)

RegisterNetEvent("core:tracker:update", function(x, y, z)
    if trackerBlip == nil or not DoesBlipExist(trackerBlip) then
        trackerBlip = AddBlipForCoord(x + 0.0, y + 0.0, z + 0.0)
        SetBlipSprite(trackerBlip, 1)
        SetBlipScale(trackerBlip, 0.8)
        SetBlipColour(trackerBlip, 1)
        AddTextEntry("BN_SUNLIFE_TRACKET_1", "Traqueur véhicule")
        BeginTextCommandSetBlipName("BN_SUNLIFE_TRACKET_1")
        EndTextCommandSetBlipName(trackerBlip)
    else
        SetBlipCoords(trackerBlip, x + 0.0, y + 0.0, z + 0.0)
    end
end)

RegisterNetEvent("core:tracker:clear", function()
    if trackerBlip and DoesBlipExist(trackerBlip) then
        RemoveBlip(trackerBlip)
    end
    trackerBlip = nil
end)

RegisterNetEvent("core:tracker:notify", function(msg)
    ESX.ShowNotification(msg)
end)
