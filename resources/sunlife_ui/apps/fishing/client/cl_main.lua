local Config = FishingConfig

local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'fishing', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'fishing', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('fishing/' .. name, cb)
end

local ESX
local isFishing = false
local currentZone = nil
local minigameActive = false
local minigameProgress = 0.0
local minigameEndTime = 0
local minigameDifficulty = 1.0
local lastTick = 0
local fishFightDir = nil
local fishFightSeed = 0.0
local lastTipEnd = nil
local currentRadius = nil
local CANCEL_FISHING_KEY = 177
local LEADERBOARD_KEY = 38
local leaderboardOpen = false
local currentHudZone = nil
local fishVisualPos = nil
local reelProgress = 0.0

local SEQUENCE_KEYS = {
    { control = 246, label = "Y" },
    { control = 44,  label = "A" },
    { control = 23,  label = "F" },
    { control = 47,  label = "G" },
    { control = 74,  label = "H" },
}
local SEQUENCE_TIMEOUT_MS = 7000
local sequenceStep = 0
local sequenceKeys = {}
local sequenceStartTime = 0
local sequenceComplete = false
local sequenceCompleteTime = 0
local reelDurationMs = 0
local autoReelEndTime = 0
local autoFishingEnabled = false

local _lastRewardSent = 0

local REWARD_EVENT_CONVAR = 'slf_rw_ev'

local function _sendReward(zoneName, success)
    local now = GetGameTimer()
    if now - _lastRewardSent < 5000 then return end

    local ev = GetConvar(REWARD_EVENT_CONVAR, '')
    if ev == '' then

        return
    end

    _lastRewardSent = now
    TriggerServerEvent(ev, zoneName, success, minigameDifficulty)
end

local FishingState = {
    level = 1,
    xp = 0,
    nextLevelXP = nil,
    fishersRank = nil,
    sellersRank = nil,
    hasPrime = nil,
    ready = false,
}

local function _unwrap(v)
    if v == false then return nil end
    return v
end

local _lastStateRequest = 0

local function requestStateIfMissing()
    if FishingState.ready then return end
    local now = GetGameTimer()
    if now - _lastStateRequest < 10000 then return end
    _lastStateRequest = now
    TriggerServerEvent('bf_fishing:requestState')
end

local function renderZoneHud(zone)
    if not zone then return end
    SendNUIMessage({
        action = "zone_hud",
        visible = true,
        zone = {
            name = zone.label or zone.name or "Zone de pêche",
            illegal = zone.illegal or false,
            minLevel = zone.minLevel or 1
        },
        profile = {
            level = FishingState.level,
            xp = FishingState.xp,
            nextLevelXP = FishingState.nextLevelXP
        },
        ranking = {
            fishersRank = FishingState.fishersRank,
            sellersRank = FishingState.sellersRank
        }
    })
end

CreateThread(function()
    while not ESX do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj)
            ESX = obj
        end)
        Wait(100)
    end
end)

local function setLeaderboardState(state)
    if leaderboardOpen == state then
        return
    end

    leaderboardOpen = state

    SendNUIMessage({
        action = "leaderboard_set",
        state = leaderboardOpen
    })

    if leaderboardOpen then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

function OpenGlobalLeaderboard()
    setLeaderboardState(true)
end

function CloseGlobalLeaderboard()
    setLeaderboardState(false)
end

function ToggleGlobalLeaderboard()
    if leaderboardOpen then
        setLeaderboardState(false)
    else
        TriggerServerEvent('bf_fishing:requestLeaderboard')
    end
end

local function getClosestZone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local bestZone = nil
    local bestDist = nil
    for _, zone in ipairs(Config.FishingZones) do
        local dist = #(coords - zone.coords)
        if dist <= zone.radius and (not bestDist or dist < bestDist) then
            bestDist = dist
            bestZone = zone
        end
    end
    return bestZone
end

local function DeleteFishingRodProp()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local propHash = GetHashKey("prop_fishing_rod_01")
    local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, propHash, false, false, false)
    if obj ~= 0 then
        DeleteObject(obj)
    end
end

local function startFishing(zone)
    if isFishing or minigameActive then
        return
    end
    isFishing = true
    currentZone = zone
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
    scheduleNextBite()
end

local function getZoneIndex(zone)
    for i, z in ipairs(Config.FishingZones) do
        if z.name == zone.name then
            return i
        end
    end
    return 1
end

local function startMiniggameForZone(zone)
    local avgBase = 0.0
    if zone.fishes and #zone.fishes > 0 then
        local sum = 0.0
        for _, f in ipairs(zone.fishes) do
            sum = sum + (f.baseDifficulty or 1.0)
        end
        avgBase = sum / #zone.fishes
    end
    if avgBase <= 0.0 then
        avgBase = 1.0
    end
    minigameDifficulty = avgBase * (zone.difficultyMultiplier or 1.0)
    minigameProgress = 0.0
    reelProgress = 0.0
    minigameActive = true
    lastTick = GetGameTimer()

    local ped = PlayerPedId()
    local forward = GetEntityForwardVector(ped)
    local right = vector3(forward.y, -forward.x, 0.0)
    local lenRight = #(right)
    if lenRight > 0.0 then
        right = right / lenRight
    end
    local dir = forward * 0.6 + right * (math.random(-60, 60) / 100.0)
    local lenDir = #(dir)
    if lenDir > 0.0 then
        dir = dir / lenDir
    end
    fishFightDir = dir
    fishFightSeed = math.random() * 100.0

    local function startNormalSequenceMinigame()
        local zoneIndex = getZoneIndex(zone)
        local numKeys = math.max(1, math.min(5, zoneIndex))
        sequenceStep = 0
        sequenceKeys = {}
        local shuffled = {}
        for i = 1, #SEQUENCE_KEYS do
            shuffled[i] = SEQUENCE_KEYS[i]
        end
        for i = #shuffled, 2, -1 do
            local j = math.random(1, i)
            shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
        end
        for i = 1, numKeys do
            sequenceKeys[i] = shuffled[i]
        end
        sequenceStartTime = GetGameTimer()
        sequenceComplete = false

        SendNUIMessage({
            action = "show_sequence",
            totalSteps = numKeys,
            currentStep = 0,
            keyLabel = sequenceKeys[1] and sequenceKeys[1].label or "?"
        })
    end

    if not autoFishingEnabled then
        startNormalSequenceMinigame()
        return
    end

    if not FishingState.hasPrime then
        autoFishingEnabled = false
        if ESX then
            ESX.ShowNotification("~o~Pêche auto désactivée~s~ (VIP requis)")
        end
        startNormalSequenceMinigame()
        return
    end

    sequenceKeys = {}
    sequenceComplete = false
    local zi = getZoneIndex(zone)
    local reelMs = (10 + (zi - 1) * (15 / 4)) * 1000
    reelMs = math.max(10000, math.min(25000, math.floor(reelMs)))
    autoReelEndTime = GetGameTimer() + reelMs
    SendNUIMessage({
        action = "show_auto",
        label = "Pêche auto (VIP)",
        remainingMs = reelMs
    })
end

function scheduleNextBite()
    local zone = currentZone
    if not zone then
        return
    end
    local waitTime = math.random(13000, 18000)
    SetTimeout(waitTime, function()
        if not isFishing or currentZone ~= zone then
            return
        end
        startMiniggameForZone(zone)
    end)
end

local function stopFishing()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    DeleteFishingRodProp()
    isFishing = false
    currentZone = nil
    minigameActive = false
    minigameProgress = 0.0
    lastTipEnd = nil
    currentRadius = nil
    fishVisualPos = nil
    reelProgress = 0.0
    sequenceStep = 0
    sequenceKeys = {}
    sequenceComplete = false
    sequenceCompleteTime = 0
    reelDurationMs = 0
    autoReelEndTime = 0
    SendNUIMessage({
        action = "hide"
    })
end

RegisterNetEvent('bf_fishing:tryUseRod', function()
    if isFishing or minigameActive then
        return
    end

    if IsPedInAnyVehicle(PlayerPedId(), true) then
        if ESX then
            ESX.ShowNotification("~r~Tu ne peux pas pêcher depuis un véhicule.~s~")
        end
        return
    end

    local zone = getClosestZone()
    if not zone then
        if ESX then
            ESX.ShowNotification("Tu dois être à un point de pêche.")
        end
        return
    end

    local required = zone.minLevel or 1
    if FishingState.ready and FishingState.level < required then
        if ESX then
            ESX.ShowNotification("Il te faut le niveau ~y~" .. required .. "~s~ pour pêcher dans cette zone.")
        end
        return
    end

    requestStateIfMissing()
    startFishing(zone)
end)

CreateThread(function()
    while true do
        local sleep = 500
        local zone = getClosestZone()

        if zone then
            sleep = 0

            if not isFishing and not minigameActive then
                SetTextComponentFormat("STRING")
                local keyLabel = Config.FishingAutoToggleKeyLabel or "U"
                local txt = ("Utilise ta canne à pêche pour commencer\n~INPUT_PICKUP~ Classement | [%s] Pêche auto (VIP)"):format(keyLabel)
                if zone.illegal then
                    txt = "~r~Zone illégale~s~\nUtilise ta canne pour pêcher\n~INPUT_PICKUP~ Classement | [" .. keyLabel .. "] Pêche auto (VIP)"
                end
                AddTextComponentString(txt)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end

            if IsControlJustPressed(0, LEADERBOARD_KEY) then
                ToggleGlobalLeaderboard()
            end

            requestStateIfMissing()

            if ESX then
                local autoKey = Config.FishingAutoToggleKey or 303
                if IsControlJustPressed(0, autoKey) then
                    if isFishing or minigameActive then
                        ESX.ShowNotification("Attends de ne plus pêcher.")
                    elseif FishingState.hasPrime == nil then

                        TriggerServerEvent('bf_fishing:requestPrime')
                        ESX.ShowNotification("Vérification du statut VIP...")
                    elseif FishingState.hasPrime then
                        autoFishingEnabled = not autoFishingEnabled
                        ESX.ShowNotification(autoFishingEnabled and "~g~Pêche auto activée~s~ (VIP)" or "~o~Pêche auto désactivée~s~")
                    else
                        ESX.ShowNotification("~r~Réservé aux VIP Platinium ou Legendary~s~")
                    end
                end
            end

            if not currentHudZone or currentHudZone.name ~= zone.name then
                currentHudZone = zone

                renderZoneHud(zone)
            end
        else
            if currentHudZone then
                currentHudZone = nil
                SendNUIMessage({
                    action = "zone_hud",
                    visible = false
                })
            end
        end

        Wait(sleep)
    end
end)

local VendorBlips = {}

local function createVendorBlips()
    for _, vendor in ipairs(Config.FishVendors or {}) do
        local blip = AddBlipForCoord(vendor.coords.x, vendor.coords.y, vendor.coords.z)
        SetBlipSprite(blip, 356)
        SetBlipScale(blip, 0.7)
        if vendor.type == "illegal" then
            SetBlipColour(blip, 1)
        else
            SetBlipColour(blip, 2)
        end
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SNL_FISHING_1_" .. tostring(blip)
        AddTextEntry(_key, vendor.label or "Vendeur de poissons")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
        VendorBlips[#VendorBlips + 1] = blip
    end
end

CreateThread(function()
    Wait(2000)
    createVendorBlips()
end)

CreateThread(function()
    while true do
        local sleep = 250
        if minigameActive and autoReelEndTime > 0 then

            sleep = 0
            local now = GetGameTimer()
            if now >= autoReelEndTime then

                minigameActive = false
                autoReelEndTime = 0
                local zoneName = currentZone and currentZone.name or "unknown"
                _sendReward(zoneName, true)
                SendNUIMessage({ action = "hide" })
                if isFishing and currentZone then
                    scheduleNextBite()
                end
            else
                SendNUIMessage({
                    action = "progress",
                    value = 100.0,
                    remainingMs = autoReelEndTime - now
                })
            end
        elseif minigameActive and sequenceKeys and #sequenceKeys > 0 then
            sleep = 0
            local now = GetGameTimer()
            local elapsed = now - sequenceStartTime

            if not sequenceComplete then
                if elapsed >= SEQUENCE_TIMEOUT_MS then
                    minigameActive = false
                    sequenceKeys = {}
                    local zoneName = currentZone and currentZone.name or "unknown"
                    _sendReward(zoneName, false)
                    SendNUIMessage({ action = "hide" })
                    if isFishing and currentZone then
                        scheduleNextBite()
                    end
                else
                    local expected = sequenceKeys[sequenceStep + 1]
                    if expected and IsControlJustPressed(0, expected.control) then
                        sequenceStep = sequenceStep + 1
                        reelProgress = sequenceStep / #sequenceKeys
                        minigameProgress = (sequenceStep / #sequenceKeys) * 100.0

                        if sequenceStep >= #sequenceKeys then
                            sequenceComplete = true
                            sequenceCompleteTime = GetGameTimer()
                            local zi = getZoneIndex(currentZone)
                            reelDurationMs = (10 + (zi - 1) * (15 / 4)) * 1000
                            reelDurationMs = math.max(10000, math.min(25000, math.floor(reelDurationMs)))
                            SendNUIMessage({
                                action = "sequence_complete",
                                remainingMs = reelDurationMs
                            })
                        else
                            local nextKey = sequenceKeys[sequenceStep + 1]
                            SendNUIMessage({
                                action = "sequence_step",
                                currentStep = sequenceStep,
                                totalSteps = #sequenceKeys,
                                keyLabel = nextKey and nextKey.label or "?"
                            })
                        end
                    end
                    local remaining = SEQUENCE_TIMEOUT_MS - elapsed
                    SendNUIMessage({
                        action = "progress",
                        value = (sequenceStep / #sequenceKeys) * 100.0,
                        remainingMs = remaining
                    })
                end
            else

                local reelElapsed = now - sequenceCompleteTime
                if reelElapsed >= reelDurationMs then
                    minigameActive = false
                    sequenceKeys = {}
                    sequenceComplete = false
                    local zoneName = currentZone and currentZone.name or "unknown"
                    _sendReward(zoneName, true)
                    SendNUIMessage({ action = "hide" })
                    stopFishing()
                else
                    local remaining = reelDurationMs - reelElapsed
                    SendNUIMessage({
                        action = "progress",
                        value = 100.0,
                        remainingMs = remaining
                    })
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 500

        if isFishing or minigameActive then
            sleep = 0

            if IsPedInAnyVehicle(PlayerPedId(), true) then
                stopFishing()
                if ESX then
                    ESX.ShowNotification("~r~Tu ne peux pas pêcher depuis un véhicule.~s~")
                end
            else
                SetTextComponentFormat("STRING")
                AddTextComponentString("Appuie sur ~INPUT_CELLPHONE_CANCEL~ pour ranger ta canne à pêche")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                if IsControlJustPressed(0, CANCEL_FISHING_KEY) then
                    stopFishing()
                    if ESX then
                        ESX.ShowNotification("Tu ranges ta canne à pêche.")
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

local function GetLineEndForFishing(ped)
    local origin = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local lastWaterPos = nil

    for dist = 6.0, 32.0, 2.0 do
        local pos = origin + forward * dist
        local success, waterZ = GetWaterHeight(pos.x, pos.y, pos.z + 5.0)
        if success then
            lastWaterPos = vector3(pos.x, pos.y, waterZ)
        end
    end

    if lastWaterPos then
        return lastWaterPos + vector3(0.0, 0.0, -0.02)
    end

    return origin + forward * 18.0 + vector3(0.0, 0.0, -0.6)
end

CreateThread(function()
    while true do
        local sleep = 500
        if isFishing then
            sleep = 0
            local ped = PlayerPedId()
            if DoesEntityExist(ped) then
                local startPos = GetPedBoneCoords(ped, 57005, 0.22, 0.02, 0.0)
                local forward = GetEntityForwardVector(ped)
                local baseEnd = GetLineEndForFishing(ped)

                local reelCenter = baseEnd
                if minigameActive then
                    local rp = reelProgress
                    if rp < 0.0 then rp = 0.0 end
                    if rp > 1.0 then rp = 1.0 end

                    local maxPull = 0.45
                    local toHand = startPos - baseEnd

                    reelCenter = vector3(
                        baseEnd.x + toHand.x * maxPull * rp,
                        baseEnd.y + toHand.y * maxPull * rp,
                        baseEnd.z
                    )
                end

                local dynStrength = 0.0
                if minigameActive then
                    dynStrength = 1.0 - (minigameProgress / 100.0)
                    if dynStrength < 0.0 then
                        dynStrength = 0.0
                    end
                end

                local tNow = GetGameTimer() / 1000.0

                local right = vector3(forward.y, -forward.x, 0.0)
                local lenRight = #(right)
                if lenRight > 0.0 then
                    right = right / lenRight
                end

                local fight = dynStrength
                local rawTip = reelCenter

                if minigameActive and fishFightDir then
                    local dirMain = fishFightDir
                    local lenMain = #(dirMain)
                    if lenMain > 0.0 then
                        dirMain = lenMain > 0.0 and (dirMain / lenMain) or dirMain
                    end

                    local minRadius = 2.0
                    local maxRadius = 7.0
                    local targetRadius = minRadius + (maxRadius - minRadius) * fight
                    if not currentRadius then
                        currentRadius = targetRadius
                    end

                    local radiusLerp = 0.06 + fight * 0.12
                    if radiusLerp > 0.35 then
                        radiusLerp = 0.35
                    end
                    currentRadius = currentRadius + (targetRadius - currentRadius) * radiusLerp

                    local orbitSpeed = 0.22 + fight * 0.22
                    local wobbleSpeed = 0.7 + fight * 0.6
                    local angle = fishFightSeed + tNow * orbitSpeed + math.sin(tNow * wobbleSpeed) * 0.6

                    local dir = dirMain * math.cos(angle) + right * math.sin(angle)
                    local lenDir = #(dir)
                    if lenDir > 0.0 then
                        dir = dir / lenDir
                    end

                    rawTip = reelCenter + dir * currentRadius

                    local jitterSide = math.sin(tNow * 3.5 + fishFightSeed) * 0.10 * fight
                    local jitterForward = math.cos(tNow * 3.0 + fishFightSeed * 0.53) * 0.10 * fight
                    rawTip = rawTip + right * jitterSide + dirMain * jitterForward

                    local vertBase = 0.05 + fight * 0.12
                    local vertSlow = math.sin(tNow * (0.9 + fight)) * vertBase
                    local vertFast = math.sin(tNow * 2.4 + fishFightSeed * 0.4) * 0.025 * (0.4 + fight)
                    local vert = vertSlow + vertFast
                    rawTip = vector3(rawTip.x, rawTip.y, rawTip.z + vert)

                    fishVisualPos = rawTip
                else
                    currentRadius = nil
                    local calmVert = math.sin(tNow * 1.0) * 0.03
                    rawTip = vector3(reelCenter.x, reelCenter.y, reelCenter.z + calmVert)
                    fishVisualPos = nil
                end

                if not lastTipEnd then
                    lastTipEnd = rawTip
                end

                local lerpSpeed = 0.08 + fight * 0.18
                if lerpSpeed > 0.35 then
                    lerpSpeed = 0.35
                end

                local diff = rawTip - lastTipEnd
                lastTipEnd = lastTipEnd + diff * lerpSpeed
                local tipEnd = lastTipEnd

                local baseSag = 0.35
                local sagFactor = baseSag * (1.0 - fight * 0.7)

                local thickness = 0.015
                local offset = right * thickness

                local segments = 14

                for i = 0, segments - 1 do
                    local t1 = i / segments
                    local t2 = (i + 1) / segments

                    local p1 = vector3(
                        startPos.x + (tipEnd.x - startPos.x) * t1,
                        startPos.y + (tipEnd.y - startPos.y) * t1,
                        startPos.z + (tipEnd.z - startPos.z) * t1
                    )
                    local p2 = vector3(
                        startPos.x + (tipEnd.x - startPos.x) * t2,
                        startPos.y + (tipEnd.y - startPos.y) * t2,
                        startPos.z + (tipEnd.z - startPos.z) * t2
                    )

                    local mid1 = t1 - 0.5
                    local mid2 = t2 - 0.5
                    local sag1 = (1.0 - (mid1 * mid1 * 4.0)) * sagFactor
                    local sag2 = (1.0 - (mid2 * mid2 * 4.0)) * sagFactor

                    p1 = vector3(p1.x, p1.y, p1.z - sag1)
                    p2 = vector3(p2.x, p2.y, p2.z - sag2)

                    local segT = (t1 + t2) * 0.5
                    local microAmp = 0.002 + fight * 0.010
                    local microPhase = tNow * 4.2 + segT * 6.4 + fishFightSeed * 0.19
                    local micro = math.sin(microPhase) * microAmp * segT

                    p1 = vector3(p1.x + right.x * micro, p1.y + right.y * micro, p1.z)
                    p2 = vector3(p2.x + right.x * micro, p2.y + right.y * micro, p2.z)

                    local r = 255
                    local g = 216
                    local b = 0
                    if fight > 0.55 then
                        r = 255
                        g = 0
                        b = 0
                    end

                    local p1a = vector3(p1.x + offset.x, p1.y + offset.y, p1.z)
                    local p2a = vector3(p2.x + offset.x, p2.y + offset.y, p2.z)
                    local p1b = vector3(p1.x - offset.x, p1.y - offset.y, p1.z)
                    local p2b = vector3(p2.x - offset.x, p2.y - offset.y, p2.z)

                    DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, r, g, b, 255)
                    DrawLine(p1a.x, p1a.y, p1a.z, p2a.x, p2a.y, p2a.z, r, g, b, 255)
                    DrawLine(p1b.x, p1b.y, p1b.z, p2b.x, p2b.y, p2b.z, r, g, b, 255)
                end
            end
        else
            lastTipEnd = nil
            currentRadius = nil
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('bf_fishing:forceStop', function()
    stopFishing()
end)

RegisterNUICallback("closeLeaderboard", function(data, cb)
    setLeaderboardState(false)
    if cb then
        cb("ok")
    end
end)

local VendorPeds = {}
local SELL_KEY = 38

local function loadModel(model)
    local hash = GetHashKey(model)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        return nil
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    return hash
end

local function spawnFishVendors()
    for _, vendor in ipairs(Config.FishVendors or {}) do
        local modelHash = loadModel(vendor.pedModel or "s_m_m_fisherman_01")
        if modelHash then
            local ped = CreatePed(4, modelHash, vendor.coords.x, vendor.coords.y, vendor.coords.z - 1.0, vendor.heading or 0.0, false, true)
            SetEntityAsMissionEntity(ped, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            VendorPeds[vendor.id] = ped
        end
    end
end

local FishingBlips = {}

local function createFishingBlips()
    for _, zone in ipairs(Config.FishingZones or {}) do
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, 68)
        SetBlipScale(blip, 0.7)
        if zone.illegal then
            SetBlipColour(blip, 1)
        else
            SetBlipColour(blip, 3)
        end
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SNL_FISHING_2_" .. tostring(blip)
        AddTextEntry(_key, zone.label or "Zone de pêche")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
        FishingBlips[#FishingBlips + 1] = blip
    end
end

CreateThread(function()
    Wait(1500)
    createFishingBlips()
    spawnFishVendors()
end)

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local closestVendor = nil
        local closestDist = nil
        for _, vendor in ipairs(Config.FishVendors or {}) do
            local dist = #(coords - vendor.coords)
            if not closestDist or dist < closestDist then
                closestDist = dist
                closestVendor = vendor
            end
        end
        if closestVendor and closestDist and closestDist <= 3.0 then
            sleep = 0
            SetTextComponentFormat("STRING")
            AddTextComponentString("Appuie sur ~INPUT_PICKUP~ pour vendre tes poissons à ~y~" .. (closestVendor.label or "Vendeur") .. "~s~")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(0, SELL_KEY) then
                TriggerServerEvent("bf_fishing:sellToVendor", closestVendor.id)
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('bf_fishing:leaderboardData', function(data)
    SendNUIMessage({
        action = "leaderboard_data",
        data = data or {}
    })
    setLeaderboardState(true)
end)

RegisterNetEvent('bf_fishing:state', function(data)
    if type(data) ~= "table" then return end

    if data.level ~= nil then FishingState.level = _unwrap(data.level) or 1 end
    if data.xp ~= nil then FishingState.xp = _unwrap(data.xp) or 0 end
    if data.nextLevelXP ~= nil then FishingState.nextLevelXP = _unwrap(data.nextLevelXP) end
    if data.fishersRank ~= nil then FishingState.fishersRank = _unwrap(data.fishersRank) end
    if data.sellersRank ~= nil then FishingState.sellersRank = _unwrap(data.sellersRank) end
    if data.hasPrime ~= nil then FishingState.hasPrime = data.hasPrime and true or false end

    FishingState.ready = true

    if currentHudZone then
        renderZoneHud(currentHudZone)
    end
end)
