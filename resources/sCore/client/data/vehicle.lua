local allowedJobs <const> = {
    lsfd = true,
    police = true,
    ems = true,
    bobcat = true,
    sheriff = true,
    fourriere = true,
    bennys = true,
    hayes = true,
    harmony = true,
    doj = true,
    gouv = true,
    usss = true,
}

MAX_SPEED_KMH = 320
local MAX_SPEED_MS = MAX_SPEED_KMH / 3.6

local UNCAPPED_MODELS = {
    [GetHashKey("pvita")]  = 350,
    [GetHashKey("thraxk")] = 400,
}

local function getCapForVehicle(veh)
    local model = GetEntityModel(veh)
    local custom = UNCAPPED_MODELS[model]
    if custom then return custom / 3.6, custom end
    return MAX_SPEED_MS, MAX_SPEED_KMH
end

function ApplyHardSpeedCap(veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) then return end
    local capMs = getCapForVehicle(veh)
    SetEntityMaxSpeed(veh, capMs)
end

exports("ApplyHardSpeedCap", ApplyHardSpeedCap)

AddEventHandler("sCore.enteredVehicle", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and veh ~= 0 then
        ApplyHardSpeedCap(veh)
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(200)
    end
    local lastVeh = 0
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then

                if veh ~= lastVeh then
                    ApplyHardSpeedCap(veh)
                    lastVeh = veh
                end

                local capMs = getCapForVehicle(veh)
                if GetEntitySpeed(veh) > capMs + (5 / 3.6) then
                    ApplyHardSpeedCap(veh)
                end
            end
            Citizen.Wait(1000)
        else
            lastVeh = 0
            Citizen.Wait(2000)
        end
    end
end)

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    local ped = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(ped, false)
    local vehicleClass = GetVehicleClass(currentVehicle)

    if vehicleClass == 18 and GetPedInVehicleSeat(currentVehicle, -1) == ped then
        local playerJob = ESX.PlayerData.job and ESX.PlayerData.job.name

        if playerJob and not allowedJobs[playerJob] then
           ClearPedTasksImmediately(ped)
           TaskLeaveVehicle(ped, currentVehicle, 0)
           ESX.ShowNotification("~r~Vous ne faites pas partie des forces de l'ordre !")
        end
    end
end)
