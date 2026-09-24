if not PoliceConfig or not PoliceConfig.Enabled then return end

local ESX             = nil
local PlayerData      = {}

local Arresting       = false
local Aresztowany     = false
local SekcjaAnimacji  = 'mp_arrest_paired'
local AnimArresting   = 'cop_p2_back_left'
local AnimAresztowany = 'crook_p2_back_left'
local lastArrestAt    = 0

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('police:arrested', function(target)
    Aresztowany = true
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

    RequestAnimDict(SekcjaAnimacji)
    while not HasAnimDictLoaded(SekcjaAnimacji) do Wait(10) end

    AttachEntityToEntity(PlayerPedId(), targetPed, 11816,
        -0.1, 0.45, 0.0, 0.0, 0.0, 20.0,
        false, false, true, false, 20, false)
    TaskPlayAnim(playerPed, SekcjaAnimacji, AnimAresztowany,
        8.0, -8.0, 5500, 33, 0, false, false, false)

    Wait(950)
    DetachEntity(PlayerPedId(), true, false)
    SetPedConfigFlag(playerPed, 52, false)
    SetEntityCollision(playerPed, true, true)
    Aresztowany = false
end)

RegisterNetEvent('police:arreststarted', function()
    local playerPed = PlayerPedId()

    RequestAnimDict(SekcjaAnimacji)
    while not HasAnimDictLoaded(SekcjaAnimacji) do Wait(10) end

    TaskPlayAnim(playerPed, SekcjaAnimacji, AnimArresting,
        8.0, -8.0, 5500, 33, 0, false, false, false)
    Wait(3000)
    Arresting = false
end)

local function isCop(jobName)
    return PoliceConfig.AllowedJobs[jobName] == true
end

RegisterCommand("arrestPolice", function()

    if PoliceConfig.ArrestRequireShift and not IsControlPressed(0, 21) then
        return
    end

    if not PlayerData or not PlayerData.job then return end
    if not isCop(PlayerData.job.name) then return end

    local now = GetGameTimer()
    if (now - lastArrestAt) < (PoliceConfig.ArrestCooldown or 4000) then return end

    if Arresting or Aresztowany then return end
    if IsPedInAnyVehicle(PlayerPedId()) then return end

    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    if distance == -1 or distance > (PoliceConfig.ArrestDistance or 3.0) then return end
    if IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then return end

    Arresting    = true
    lastArrestAt = now

    local targetSrc = GetPlayerServerId(closestPlayer)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification("Vous arrêtez le citoyen #: ~r~" .. tostring(targetSrc))
    end
    TriggerServerEvent('police:startArrestation', targetSrc)

    Wait(3100)

    TriggerServerEvent('sCore.cuffPlayer', targetSrc)
end, false)

RegisterKeyMapping(
    "arrestPolice",
    "Faire une arrestation (POLICE) — Shift+G",
    "keyboard",
    PoliceConfig.ArrestKey or "G"
)
