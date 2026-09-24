if not PoliceConfig or not PoliceConfig.Enabled then return end

local Keys = {
    ["ESC"]=322,["F1"]=288,["F2"]=289,["F3"]=170,["F5"]=166,["F6"]=167,
    ["F7"]=168,["F8"]=169,["F9"]=56,["F10"]=57,
    ["TAB"]=37,["Q"]=44,["W"]=32,["E"]=38,["R"]=45,["T"]=245,["Y"]=246,
    ["U"]=303,["P"]=199,["[" ]=39,["]" ]=40,["ENTER"]=18,
    ["CAPS"]=137,["A"]=34,["S"]=8,["D"]=9,["F"]=23,["G"]=47,["H"]=74,
    ["K"]=311,["L"]=182,
    ["LEFTSHIFT"]=21,["Z"]=20,["X"]=73,["C"]=26,["V"]=0,["B"]=29,
    ["N"]=249,["M"]=244,
    ["LEFTCTRL"]=36,["LEFTALT"]=19,["SPACE"]=22,
    ["TOP"]=27,
}

local ESX             = nil
IsHandcuffed          = false
local HandcuffTimer   = {}
local DragStatus      = { IsDragged = false, CopId = nil }
local EscortedPlayer  = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Wait(0)
    end
end)

function GetEscortedPlayer()
    return EscortedPlayer
end

function GetClosestPlayerServerId(maxDist)
    maxDist = maxDist or 8.0
    local myPed    = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestId, closestDist = nil, maxDist
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if ped ~= myPed and DoesEntityExist(ped) then
            local dist = #(myCoords - GetEntityCoords(ped))
            if dist < closestDist then
                closestDist = dist
                closestId = GetPlayerServerId(player)
            end
        end
    end
    return closestId
end

function PoliceGetClosestVehicle(maxDist)
    maxDist = maxDist or 15.0
    local myCoords = GetEntityCoords(PlayerPedId())
    local closestVehicle, closestDist = nil, maxDist
    for _, vehicle in ipairs(GetGamePool('CVehicle')) do
        if DoesEntityExist(vehicle) then
            local dist = #(myCoords - GetEntityCoords(vehicle))
            if dist < closestDist then
                closestDist = dist
                closestVehicle = vehicle
            end
        end
    end
    return closestVehicle
end

local function startHandcuffTimer()
    if PoliceConfig.EnableHandcuffTimer and HandcuffTimer.Active then
        ESX.ClearTimeout(HandcuffTimer.Task)
    end
    HandcuffTimer.Active = true

end

RegisterNetEvent('police:menottage', function()
    IsHandcuffed    = not IsHandcuffed
    local playerPed = PlayerPedId()

    CreateThread(function()
        if IsHandcuffed then
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do Wait(100) end
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetEnableHandcuffs(playerPed, true)
            SetPedConfigFlag(playerPed, 52, false)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            FreezeEntityPosition(playerPed, false)
            SetEntityCollision(playerPed, true, true)
            DisplayRadar(false)

            if PoliceConfig.EnableHandcuffTimer then
                if HandcuffTimer.Active then
                    ESX.ClearTimeout(HandcuffTimer.Task)
                end
                startHandcuffTimer()
            end
        else
            if PoliceConfig.EnableHandcuffTimer and HandcuffTimer.Active then
                ESX.ClearTimeout(HandcuffTimer.Task)
            end
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            DisplayRadar(true)
        end
    end)
end)

RegisterNetEvent('police:unrestrain', function()
    if IsHandcuffed then
        local playerPed = PlayerPedId()
        IsHandcuffed = false
        DragStatus.IsDragged = false
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DetachEntity(playerPed, true, false)
        DisplayRadar(true)
        if PoliceConfig.EnableHandcuffTimer and HandcuffTimer.Active then
            ESX.ClearTimeout(HandcuffTimer.Task)
        end
    end
end)

RegisterNetEvent('police:drag', function(copID)
    if not IsHandcuffed then return end
    DragStatus.IsDragged = not DragStatus.IsDragged
    DragStatus.CopId     = tonumber(copID)
end)

RegisterNetEvent('police:drag:confirm', function(targetServerId, isDragging)
    if isDragging then
        EscortedPlayer = targetServerId
    else
        EscortedPlayer = nil
    end
end)

RegisterNetEvent('police:putInVehicle', function(vehicleNetId)
    local playerPed = PlayerPedId()
    if not IsHandcuffed then return end

    local vehicle = nil
    if vehicleNetId and vehicleNetId ~= 0 then
        vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if not vehicle or not DoesEntityExist(vehicle) then vehicle = nil end
    end
    if not vehicle then
        vehicle = PoliceGetClosestVehicle(15.0)
    end
    if not vehicle then
        if ESX and ESX.ShowNotification then ESX.ShowNotification('~r~Aucun véhicule à proximité') end
        return
    end

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    for i = maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle, i) then
            TaskWarpPedIntoVehicle(playerPed, vehicle, i)
            DragStatus.IsDragged = false
            return
        end
    end
    if ESX and ESX.ShowNotification then ESX.ShowNotification('~r~Véhicule plein') end
end)

RegisterNetEvent('police:OutVehicle', function()
    local playerPed = PlayerPedId()
    if not IsPedSittingInAnyVehicle(playerPed) then return end
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    TaskLeaveVehicle(playerPed, vehicle, 16)
end)

CreateThread(function()
    while true do
        Wait(1)
        if IsHandcuffed then
            local playerPed = PlayerPedId()
            SetPedConfigFlag(playerPed, 52, false)
            SetEntityCollision(playerPed, true, true)
            if DragStatus.IsDragged then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816,
                        0.54, 0.54, 0.0, 0.0, 0.0, 0.0,
                        false, false, true, false, 2, true)
                    SetEntityCollision(playerPed, true, true)
                else
                    DragStatus.IsDragged = false
                    DetachEntity(playerPed, true, false)
                end
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        if IsHandcuffed then
            DisableControlAction(2, 1, true)
            DisableControlAction(2, 2, true)
            DisableControlAction(2, 24, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(2, 25, true)
            DisableControlAction(2, 263, true)
            DisableControlAction(2, Keys['R'], true)
            DisableControlAction(2, Keys['TOP'], true)
            DisableControlAction(2, Keys['SPACE'], true)
            DisableControlAction(2, Keys['Q'], true)
            DisableControlAction(2, Keys['TAB'], true)
            DisableControlAction(2, Keys['F'], true)
            DisableControlAction(2, Keys['F1'], true)
            DisableControlAction(2, Keys['F2'], true)
            DisableControlAction(2, Keys['F3'], true)
            DisableControlAction(2, Keys['V'], true)
            DisableControlAction(2, Keys['P'], true)
            DisableControlAction(2, 59, true)
            DisableControlAction(2, Keys['LEFTCTRL'], true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
        else
            Wait(500)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerEvent('police:unrestrain')
end)

exports("isHandcuffed", function() return IsHandcuffed end)
exports("getEscortedPlayer", function() return EscortedPlayer end)
