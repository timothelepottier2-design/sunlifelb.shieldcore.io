Config = Config or {}

local locations = {
    {
        propModel = 'prompt_sandy_boatramp_dweather_sunny',
        spawnCoords = vector4(1406.14893, 3703.760578, 35.143572, 1.0),
        currentProp = nil,
        weatherTypesToDespawn = {'RAIN', 'THUNDER', 'BLIZZARD'},
        freeze = true,
        checkWeather = true,
        checkTime = true,
        startHour = 5,
        endHour = 20,
        distanceCheck = true,
        maxDistance = 50.0,
    },
    {
        propModel = 'prompt_sandy_boatramp_dweather_rainy',
        spawnCoords = vector4(1406.14893, 3703.760578, 35.143572, 1.0),
        currentProp = nil,
        weatherTypesToDespawn = {'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'THUNDER', 'CLEARING', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'NEUTRAL', 'BLIZZARD'},
        freeze = false,
        checkWeather = true,
        checkTime = false,
        distanceCheck = true,
        maxDistance = 50.0,
    },
    {
        propModel = 'prompt_sandy_boatramp_dweather_storm',
        spawnCoords = vector4(1406.14893, 3703.760578, 35.143572, 1.0),
        currentProp = nil,
        weatherTypesToDespawn = {'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'SMOG', 'FOGGY', 'XMAS', 'SNOW', 'SNOWLIGHT', 'NEUTRAL'},
        freeze = false,
        checkWeather = true,
        checkTime = false,
        distanceCheck = true,
        maxDistance = 50.0,
    },
    {
        propModel = 'prompt_sandy_boatramp_dweather_moon_clear',
        spawnCoords = vector4(1406.14893, 3703.760578, 35.143572, 1.0),
        currentProp = nil,
        weatherTypesToDespawn = {'THUNDER', 'STORM'},
        freeze = true,
        checkWeather = true,
        checkTime = true,
        startHour = 20,
        endHour = 6,
        distanceCheck = true,
        maxDistance = 50.0,
    }
}

function isWithinTimeRange(currentHour, startHour, endHour)
    if startHour <= endHour then
        return currentHour >= startHour and currentHour < endHour
    else
        -- Time range crosses midnight
        return currentHour >= startHour or currentHour < endHour
    end
end

function spawnProp(location)
    if location.currentProp == nil then
        if Config.Debug then
            print("Spawning prop:", location.propModel)
            print("Spawn coordinates: x="..location.spawnCoords.x..", y="..location.spawnCoords.y..", z="..location.spawnCoords.z..", heading="..location.spawnCoords.w)
        end

        local modelHash = GetHashKey(location.propModel)

        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end

        local x, y, z, heading = location.spawnCoords.x, location.spawnCoords.y, location.spawnCoords.z, location.spawnCoords.w

        location.currentProp = CreateObject(modelHash, x, y, z, false, false, true)
        SetEntityAsMissionEntity(location.currentProp, true, true)
        SetEntityRotation(location.currentProp, 0.0, 0.0, heading, 2, true)

        if Config.Debug then
            print("Prop spawned:", location.propModel)
            if location.freeze then
                print("Prop is frozen in position")
            end
        end

        if location.freeze then
            FreezeEntityPosition(location.currentProp, true)
        end
    else
        if Config.Debug then
            print("Prop already spawned:", location.propModel)
        end
    end
end

function despawnProp(location)
    if location.currentProp ~= nil then
        if Config.Debug then
            print("Despawning prop:", location.propModel)
        end

        DeleteObject(location.currentProp)
        location.currentProp = nil

        if Config.Debug then
            print("Prop despawned:", location.propModel)
        end
    else
        if Config.Debug then
            print("No prop to despawn:", location.propModel)
        end
    end
end

function getPlayerPosition()
    local playerPed = PlayerPedId()
    return GetEntityCoords(playerPed)
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)

        local currentWeather = GetPrevWeatherTypeHashName()
        local currentHour = GetClockHours()
        local playerCoords = getPlayerPosition()

        if Config.Debug then
            print("Current weather:", currentWeather)
            print("Current hour:", currentHour)
            print("playercoords:", playerCoords)
        end

        local desiredLocation = nil

        for _, location in ipairs(locations) do
            local shouldDespawn = false

            -- Check distance first
            if location.distanceCheck then
                local distance = Vdist(playerCoords, location.spawnCoords.x, location.spawnCoords.y, location.spawnCoords.z)
                if distance > location.maxDistance then
                    shouldDespawn = true
                end
            end

            -- Only check weather and time if within distance
            if not shouldDespawn then
                if location.checkWeather then
                    for _, weatherType in ipairs(location.weatherTypesToDespawn) do
                        if GetHashKey(weatherType) == currentWeather then
                            shouldDespawn = true
                            break
                        end
                    end
                end

                if location.checkTime then
                    local isTimeValid = isWithinTimeRange(currentHour, location.startHour, location.endHour)
                    if not isTimeValid then
                        shouldDespawn = true
                    end
                end
            end

            if not shouldDespawn then
                desiredLocation = location
                break  -- Only one prop should be active
            end
        end

        for _, location in ipairs(locations) do
            if location == desiredLocation then
                if location.currentProp == nil then
                    spawnProp(location)
                end
            else
                if location.currentProp ~= nil then
                    despawnProp(location)
                end
            end
        end
    end
end)
