local inVehicle, antiLoopThread = false, false

local function antiRoolLoop()
    if antiLoopThread then
        return
    end

    antiLoopThread = Citizen.CreateThread(function()
        while inVehicle do
            local ped = PlayerPedId()

            if not IsPedInAnyVehicle(ped, false) then
                break
            end

            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle == 0 then
                break
            end

            local roll = GetEntityRoll(vehicle)
            if roll > 75.0 or roll < -75.0 then
                DisableControlAction(2, 59, true)
                DisableControlAction(2, 60, true)
                Citizen.Wait(0)
            else
                Citizen.Wait(250)
            end
        end
        inVehicle = false
        antiLoopThread = nil
    end)
end

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    if not inVehicle then
        inVehicle = true
        antiRoolLoop()
    end
end)

AddEventHandler("sCore.exitedVehicle", function(plate, seat, displayName, netId)
    inVehicle = false
end)
