RegisterNetEvent("sCore.mainPutVehicle", function()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    local vehicle = lib.getClosestVehicle(playerCoords, 5.0, false)
    if vehicle and DoesEntityExist(vehicle) then
        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
        local freeSeat = nil

        for i = maxSeats - 1, 0, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat ~= nil then
            TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
        end
    end
end)
