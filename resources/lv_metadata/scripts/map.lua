Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
            SetRadarAsExteriorThisFrame()
            --SetRadarAsInteriorThisFrame(GetHashKey('lv_fake_island'), 4208.072266 , 2246.389648, 0, 0) --Minimap Coloured
            SetRadarAsInteriorThisFrame(GetHashKey('lv_fake_island'), 4208.072266 , 2246.389648, 0, 0) -- Minimap no coloured
    end
end)