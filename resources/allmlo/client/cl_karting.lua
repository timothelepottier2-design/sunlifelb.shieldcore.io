local kartCoords = vector3(-85.162, -2067.108, 21.797)
Citizen.CreateThread(function()
    while true do
        Wait((#(GetEntityCoords(PlayerPedId()) - kartCoords) < 150) and 0 or 1000)

        ClearAreaOfVehicles(kartCoords.x, kartCoords.y, kartCoords.z, 1000, false, false, false, false, false)
        RemoveVehiclesFromGeneratorsInArea(kartCoords.x - 90.0, kartCoords.y - 90.0, kartCoords.z - 90.0, kartCoords.x + 90.0, kartCoords.y + 90.0, kartCoords.z + 90.0)
    end
end)