Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)

        if distance1 < 1000.0 then
            if pCoords.z < -5 then
                for height = 1, 1000 do
                    SetEntityCoords(PlayerPedId(), pCoords.x, pCoords.y, height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), pCoords.x, pCoords.y, height + 0.0)
                        break
                    end

                    Citizen.Wait(0)
                end
            end
        end

        if distance1 < 2500.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)
            Citizen.InvokeNative("0x5E1460624D194A38", true)
        else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
        end

        Citizen.Wait(5000)
    end
end)

CreateThread(function()
    SetToggleMinimapHeistIsland(true)
    local pauseActive = false

    while true do
        local wait = 500
        local pCoords = GetEntityCoords(PlayerPedId())
        local nearCayo = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false) < 2500.0

        if IsPauseMenuActive() and not IsMinimapInInterior() and nearCayo then
            if not pauseActive then
                pauseActive = true
                SetToggleMinimapHeistIsland(false)
            end
            SetRadarAsExteriorThisFrame()
            SetRadarAsInteriorThisFrame(GetHashKey("h4_fake_islandx"), 4700.0, -5145.0, 0, 0)
            wait = 0
        else
            if pauseActive then
                pauseActive = false
                SetToggleMinimapHeistIsland(true)
            end
        end

        Wait(wait)
    end
end)