RegisterNetEvent("sCore.mainOutVehicle", function()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    ClearPedTasksImmediately(ped)

    local xCoords = playerCoords.x + 2
    local yCoords = playerCoords.y + 2
    SetEntityCoords(ped, xCoords, yCoords, playerCoords.z)
end)
