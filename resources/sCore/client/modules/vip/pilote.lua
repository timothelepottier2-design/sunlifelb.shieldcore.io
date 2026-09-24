local piloteActive = false
local lastMode = nil

local function piloteMain(mode, speed, driveStyle)
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("~r~Vous devez être dans un véhicule.")
        return
    end

    local vipName = getPlayerVipName()
    if vipName ~= "legendary" then
        ESX.ShowNotification("~r~Vous n'avez pas les permissions nécessaires ! (VIP)")
        return
    end

    if piloteActive and lastMode == mode then
        ClearPedTasks(ped)
        ESX.ShowNotification("~r~Autopilote " .. mode .. " désactivé.")
        piloteActive = false
        lastMode = nil
        return
    end

    if not DoesBlipExist(GetFirstBlipInfoId(8)) then
        ESX.ShowNotification("~r~Vous n'avez pas défini de point de navigation !")
        return
    end

    local currentVehicle = GetVehiclePedIsIn(ped, false)
    local blip = GetFirstBlipInfoId(8)
    local dest = GetBlipCoords(blip)

    TaskVehicleDriveToCoord(ped, currentVehicle, dest.x, dest.y, dest.z, speed, 0, GetEntityModel(currentVehicle), driveStyle, 5.0, true)
    SetDriveTaskDrivingStyle(ped, driveStyle)

    ESX.ShowNotification("~g~Autopilote " .. mode .. " activé.")
    piloteActive = true
    lastMode = mode

    CreateThread(function()
        while piloteActive and lastMode == mode do
            Wait(1000)
            local currentPos = GetEntityCoords(currentVehicle)
            local distance = #(currentPos - dest)
            if distance <= 10.0 then
                ClearPedTasks(ped)
                ESX.ShowNotification('~b~Autopilote terminé. Vous êtes arrivé à destination.')
                piloteActive = false
                lastMode = nil
                break
            end
        end
    end)
end

RegisterCommand("+normalautopilot", function()
    piloteMain("normal", 25.0, 786603)
end)

RegisterCommand("+crazyautopilot", function()
    piloteMain("crazy", 100.0, 1074528293)
end)

RegisterKeyMapping('+normalautopilot', 'Autopilote normal', 'keyboard', '')
