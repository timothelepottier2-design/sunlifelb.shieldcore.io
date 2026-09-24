-- Optimized ped clearing thread for MLO (e.g., custom interior/map)
-- Clears peds only if present, runs every 2 seconds to reduce CPU load
Citizen.CreateThread(function()
    local coords = vector3(-424.49, 1114.99, 326.74)  -- Define coords once for efficiency
    local radius = 150.0
    while true do
        Citizen.Wait(2000)  -- Increased from 500ms to reduce frequency
        
        -- Check for nearby peds before clearing (optimization)
        local ped = GetClosestPed(coords.x, coords.y, coords.z, radius, true, true, true, true, -1)
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            ClearAreaOfPeds(coords.x, coords.y, coords.z, radius, 1)
        end
    end
end)