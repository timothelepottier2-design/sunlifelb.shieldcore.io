local inVehicle, driveByThread = false, nil
local speedLimit <const> = 50.0

local function setDriveByStatus(status)
    SetPlayerCanDoDriveBy(PlayerId(), status)
end

local function driveByLoop()
    if driveByThread then
        return
    end

    driveByThread = Citizen.CreateThread(function()
        while inVehicle do
            local ped = PlayerPedId()

            if not IsPedInAnyVehicle(ped, false) then
                break
            end

            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle == 0 then
                break
            end

            local isDriver = (GetPedInVehicleSeat(vehicle, -1) == ped)
            if isDriver then
                setDriveByStatus(false)
            else
                local speedKmh = GetEntitySpeed(vehicle) * 3.6
                setDriveByStatus(speedKmh <= speedLimit)
            end

            Citizen.Wait(0)
        end

        setDriveByStatus(true)
        inVehicle = false
        driveByThread = nil
    end)
end

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    if not inVehicle then
        inVehicle = true
        driveByLoop()
    end
end)

AddEventHandler("sCore.exitedVehicle", function(plate, seat, displayName, netId)
    inVehicle = false
end)
