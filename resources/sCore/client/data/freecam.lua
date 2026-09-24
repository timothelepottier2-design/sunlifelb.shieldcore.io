Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
end)

local bypassStates = {}
local hasAlreadySpawned, isDetectionStarted = false, false
local detect = 0

local lastSentTime = 0
local SEND_COOLDOWN_MS = 90000
local DETECT_INTERVAL_MS = 10000
local DETECT_THRESHOLD = 3
local WEBHOOK = "https://canary.discord.com/api/webhooks/1432688131269857401/swLzQ6LyOHr-of0AkM3euOLv99j1IpjcOY_i_E75SQPy-RV9m5i-Avcoy2nLV1yA-vv-"

exports("setFreecamBypass", function(state)
    local resource = GetInvokingResource()
    if not resource or resource == "" then return end
    if state then
        bypassStates[resource] = true
    else
        bypassStates[resource] = nil
    end
end)

local function getCamDistance(ped)
    if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
        return 100.0
    elseif IsPedInAnyBoat(ped) then
        return 40.0
    elseif IsPedInAnyVehicle(ped, false) then
        if IsCinematicCamRendering() then
            return 170.0
        else
            return 30.0
        end
    else
        return 11.0
    end
end

local function vec3Table(v)
    return { x = v.x, y = v.y, z = v.z }
end

local function buildPayload(playerCoords, camCoords, camDistance, maxDistance, screenshot)
    return {
        screen = screenshot ~= nil,
        screenshot = screenshot,
        player = vec3Table(playerCoords),
        camera = vec3Table(camCoords),
        distance = camDistance,
        maxDistance = maxDistance,
    }
end

local function sendFreecamAlert(playerCoords, camCoords, camDistance, maxDistance)
    TriggerServerEvent("sCore.freecamDetected", buildPayload(
        playerCoords, camCoords, camDistance, maxDistance, nil
    ))
end

local function tryScreenshotUpload(playerCoords, camCoords, camDistance, maxDistance)
    if GetResourceState("screenshot-basic") ~= "started" then
        return
    end

    exports["screenshot-basic"]:requestScreenshotUpload(WEBHOOK, "files[]", function(data)
        local ok, image = pcall(json.decode, data or "{}")
        local link = ok
            and image
            and image.attachments
            and image.attachments[1]
            and (image.attachments[1].proxy_url or image.attachments[1].url)

        if not link or link == "" then
            return
        end

        TriggerServerEvent("sCore.freecamDetected", buildPayload(
            playerCoords, camCoords, camDistance, maxDistance, link
        ))
    end)
end

local function isAnyBypassActive()
    for _, v in pairs(bypassStates) do
        if v == true then
            return true
        end
    end
    return false
end

local function isRegularPlayer()
    local rank = exports.sCore:staffRank()
    return rank == nil or rank == "user"
end

local function startFreecamDetection()
    Citizen.CreateThread(function()
        while not ESX.IsPlayerLoaded() do
            Wait(20)
        end

        Wait(1000)

        while true do
            Wait(DETECT_INTERVAL_MS)

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) or IsPauseMenuActive() then
                goto continue
            end
            if not NetworkIsSessionStarted() then
                goto continue
            end

            local now = GetGameTimer()
            if (now - lastSentTime) < SEND_COOLDOWN_MS then
                goto continue
            end

            local camCoords = GetFinalRenderedCamCoord()
            local playerCoords = GetEntityCoords(ped)
            local camDistance = #(playerCoords - camCoords)
            local maxDistance = getCamDistance(ped)

            local isSpawning = #(playerCoords - vector3(0.0, 0.0, 1.0)) < 10.0
            local isSpawZone = #(playerCoords - vector3(-1044.73, -2749.13, 22.36)) < 10.0
            local inGunFight = #(playerCoords - vector3(5367.0542, -1106.7327, 354.2097)) < 100.0
            local isInParachute = IsPedInParachuteFreeFall(ped) or GetPedParachuteState(ped) ~= -1

            if not isAnyBypassActive()
                and not isSpawning
                and not isSpawZone
                and not inGunFight
                and not isInParachute
                and camDistance > maxDistance
                and isRegularPlayer()
            then
                detect = detect + 1

                if detect >= DETECT_THRESHOLD then
                    lastSentTime = now
                    detect = 0
                    sendFreecamAlert(playerCoords, camCoords, camDistance, maxDistance)
                    tryScreenshotUpload(playerCoords, camCoords, camDistance, maxDistance)
                end
            else
                detect = 0
            end
            ::continue::
        end
    end)
end

Citizen.CreateThread(function()
    if hasAlreadySpawned then
        return
    end
    hasAlreadySpawned = true

    if not isDetectionStarted then
        isDetectionStarted = true
        startFreecamDetection()
    end
end)

CreateThread(function()
    while true do
        local interval = 2000
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            interval = 0
            DisableControlAction(0, 80, true)
        end
        Wait(interval)
    end
end)
