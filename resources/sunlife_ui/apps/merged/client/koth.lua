local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'merged', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'merged', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('merged/' .. name, cb)
end

ESX = exports["es_extended"]:getSharedObject()

local CFG = KothConfig

local zones          = {}
local capBlips       = {}
local lastInsideKey  = nil
local resName        = GetCurrentResourceName()

local HB_INTERVAL_MS = (CFG and CFG.hb_interval_ms) or 2000

local INZONE_POLL_MS = 500

local BLIP_SPRITES = { skull = 84, flag = 143 }

local function dist(a, b) return #(a - b) end

local function insideZone(p, z)
    return dist(p, vector3(z.x, z.y, z.z)) <= z.radius
end

local function clearCapBlips()
    for _, b in pairs(capBlips) do
        if b.icon   and DoesBlipExist(b.icon)   then RemoveBlip(b.icon)   end
        if b.radius and DoesBlipExist(b.radius) then RemoveBlip(b.radius) end
    end
    capBlips = {}
end

local function blipTextForZone(z)
    local base = "Attaque de zone: " .. (z.name or z.key)
    local s = z.state
    if s == "active"    then return base .. " [COMBAT]"
    elseif s == "countdown" then return base .. " [DÉCOMPTE]"
    elseif s == "waiting"   then return base .. " [EN ATTENTE]"
    end
    return base
end

local function blipColorForState(state)
    if state == "active"    then return 1  end
    if state == "countdown" then return 5  end
    if state == "waiting"   then return 2  end
    return 39
end

local function createCapForZone(z)

    local gxt = "BN_KOTH_" .. tostring(z.key):upper()
    AddTextEntry(gxt, blipTextForZone(z))

    local ic = AddBlipForCoord(z.x, z.y, z.z)
    SetBlipSprite(ic, BLIP_SPRITES.skull)
    SetBlipColour(ic, blipColorForState(z.state))
    SetBlipScale(ic, 0.85)
    SetBlipAsShortRange(ic, true)
    BeginTextCommandSetBlipName(gxt)
    EndTextCommandSetBlipName(ic)

    local r = AddBlipForRadius(z.x, z.y, z.z, z.radius or 85.0)
    SetBlipColour(r, blipColorForState(z.state))
    SetBlipAlpha(r, 100)

    return { icon = ic, radius = r, gxt = gxt }
end

local function updateBlip(zoneKey, state)
    local b = capBlips[zoneKey]
    if not b then return end

    local z
    for i = 1, #zones do
        if zones[i].key == zoneKey then z = zones[i]; break end
    end
    if not z then return end

    z.state = state
    local color = blipColorForState(state)

    if b.icon and DoesBlipExist(b.icon) then
        SetBlipColour(b.icon, color)
        AddTextEntry(b.gxt, blipTextForZone(z))
        BeginTextCommandSetBlipName(b.gxt)
        EndTextCommandSetBlipName(b.icon)
        SetBlipAlpha(b.icon, (state ~= "idle") and 255 or 0)
    end
    if b.radius and DoesBlipExist(b.radius) then
        SetBlipColour(b.radius, color)
        SetBlipAlpha(b.radius, (state ~= "idle") and 100 or 0)
    end
end

local function rebuildCapBlips()
    clearCapBlips()
    for i = 1, #zones do
        local z = zones[i]
        capBlips[z.key] = createCapForZone(z)
        local visible = z.state and z.state ~= "idle"
        if capBlips[z.key].icon and DoesBlipExist(capBlips[z.key].icon) then
            SetBlipAlpha(capBlips[z.key].icon, visible and 255 or 0)
        end
        if capBlips[z.key].radius and DoesBlipExist(capBlips[z.key].radius) then
            SetBlipAlpha(capBlips[z.key].radius, visible and 100 or 0)
        end
    end
end

local safeZoneActive = false

local function isStateSafe(state)
    return state == "waiting" or state == "countdown"
end

local function applySafeZone(active)
    if safeZoneActive == active then return end
    safeZoneActive = active

    local pid = PlayerId()
    local ped = PlayerPedId()
    SetPlayerInvincible(pid, active)
    SetEntityInvincible(ped, active)
    SetPlayerCanDoDriveBy(pid, not active)

    if active then
        SendNUIMessage({
            action   = "koth:notify",
            text     = "Zone safe : PvP désactivé jusqu'au début du combat.",
            type     = "info",
            duration = 5000,
            banner   = false,
        })
    end
end

CreateThread(function()
    while true do
        if safeZoneActive then
            local pid = PlayerId()
            local ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            DisablePlayerFiring(pid, true)

            DisableControlAction(0, 24,  true)
            DisableControlAction(0, 25,  true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 37,  true)

            DisableControlAction(0, 69,  true)
            DisableControlAction(0, 70,  true)
            DisableControlAction(0, 92,  true)
            DisableControlAction(0, 114, true)
            DisableControlAction(0, 331, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

local OUTZONE_MARGIN     = (CFG and CFG.outzone_lockout_margin) or 250.0
local outzoneLockActive  = false

local function setOutzoneLock(active)
    if outzoneLockActive == active then return end
    outzoneLockActive = active
    SendNUIMessage({ action = "koth:outzone", active = active })
end

CreateThread(function()
    while true do
        if outzoneLockActive then
            local pid = PlayerId()
            DisablePlayerFiring(pid, true)

            DisableControlAction(0, 24,  true)
            DisableControlAction(0, 25,  true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)

            DisableControlAction(0, 69,  true)
            DisableControlAction(0, 70,  true)
            DisableControlAction(0, 92,  true)
            DisableControlAction(0, 114, true)
            DisableControlAction(0, 331, true)
            Wait(0)
        else
            Wait(300)
        end
    end
end)

CreateThread(function()
    while true do
        local wait = 800
        if zones and #zones > 0 then
            local p            = GetEntityCoords(PlayerPedId())
            local insideActive = false
            local nearActive   = false
            for i = 1, #zones do
                local z = zones[i]
                if z.state == "active" then
                    local r = z.radius or 85.0
                    local d = #(p - vector3(z.x, z.y, z.z))
                    if d <= r then
                        insideActive = true
                    elseif d <= (r + OUTZONE_MARGIN) then
                        nearActive = true
                    end
                end
            end
            local lock = nearActive and not insideActive
            if lock then wait = 300 end
            setOutzoneLock(lock)
        else
            setOutzoneLock(false)
        end
        Wait(wait)
    end
end)

local HUD = { active = false, zoneKey = nil, zoneName = nil, state = nil,
               status = "", countdown = 0, gangs = {} }
local hudHiddenByPlayer = false

local function HUD_PushShow()
    if hudHiddenByPlayer then return end
    SendNUIMessage({ action = "koth:show", zoneName = HUD.zoneName or "" })
end

local function HUD_PushUpdate()
    if hudHiddenByPlayer then return end
    SendNUIMessage({
        action       = "koth:update",
        state        = HUD.state or "waiting",
        status       = HUD.status or "",
        countdown    = HUD.countdown or 0,
        countdownMax = (CFG and CFG.countdown_seconds) or 120,
        gangs        = HUD.gangs or {},
    })
end

local function HUD_PushHide()
    SendNUIMessage({ action = "koth:hide" })
end

local function HUD_Stop()
    if not HUD.active then return end
    HUD.active   = false
    HUD.zoneKey  = nil
    HUD.zoneName = nil
    HUD.state    = nil
    HUD.status   = ""
    HUD.countdown = 0
    HUD.gangs    = {}
    HUD_PushHide()
end

local function HUD_Start(zoneKey, zoneName, state)
    HUD.active    = true
    HUD.zoneKey   = zoneKey
    HUD.zoneName  = zoneName or ""
    HUD.state     = state or "waiting"
    HUD.status    = ""
    HUD.countdown = 0
    HUD.gangs     = {}
    HUD_PushShow()
    HUD_PushUpdate()
end

local function HUD_Update(state, status, countdown, gangs)
    if not HUD.active then return end
    HUD.state     = state or "waiting"
    HUD.status    = status or ""
    HUD.countdown = countdown or 0
    HUD.gangs     = gangs or {}
    HUD_PushUpdate()
end

local function ToggleHud()
    hudHiddenByPlayer = not hudHiddenByPlayer
    if hudHiddenByPlayer then
        HUD_PushHide()
    elseif HUD.active then
        HUD_PushShow()
        HUD_PushUpdate()
    end
end

RegisterCommand("koth_toggle_hud", function() ToggleHud() end, false)
RegisterKeyMapping("koth_toggle_hud", "Attaque de zone — Afficher/Masquer le HUD", "keyboard", "X")

local function KothNotify(text, ntype, duration, banner)
    SendNUIMessage({
        action   = "koth:notify",
        text     = text or "",
        type     = ntype or "info",
        duration = duration or 5000,
        banner   = banner == true,
    })
end

CreateThread(function()
    while true do
        Wait(1000)
        if HUD.active and HUD.state == "countdown" and (HUD.countdown or 0) > 0 then
            HUD.countdown = HUD.countdown - 1
            HUD_PushUpdate()
        end
    end
end)

RegisterNetEvent("koth:notify", function(text, ntype, duration, banner)
    KothNotify(text, ntype, duration, banner)
end)

local lastShownState   = {}
local lastShownCdValue = {}

RegisterNetEvent("koth:state", function(zoneKey, state, data)
    data = data or {}
    updateBlip(zoneKey, state)

    if lastInsideKey == zoneKey then
        applySafeZone(isStateSafe(state))
    end

    if state == "idle" then
        if HUD.active and HUD.zoneKey == zoneKey then HUD_Stop() end
        lastShownState[zoneKey]   = nil
        lastShownCdValue[zoneKey] = nil
        return
    end

    if lastInsideKey ~= zoneKey then
        if state == "finished" and HUD.active and HUD.zoneKey == zoneKey then
            HUD_Stop()
        end
        return
    end

    local zoneName = zoneKey
    for i = 1, #zones do
        if zones[i].key == zoneKey then zoneName = zones[i].name; break end
    end

    local gangs       = data.gangs or {}
    local gangCount   = #gangs
    local stateChange = lastShownState[zoneKey] ~= state

    if state == "waiting" then
        if stateChange or not HUD.active or HUD.zoneKey ~= zoneKey then
            HUD_Start(zoneKey, zoneName, "waiting")
            KothNotify("Zone ouverte — En attente de groupes...", "warning", 6000)
        end
        HUD_Update("waiting", "En attente de groupes...", 0, gangs)

    elseif state == "countdown" then
        if stateChange or not HUD.active or HUD.zoneKey ~= zoneKey then
            HUD_Start(zoneKey, zoneName, "countdown")
        end
        HUD_Update("countdown",
            gangCount .. " groupe(s) détecté(s)",
            data.countdown or 0, gangs)

        local cd = data.countdown or 0
        local maxCd = (CFG and CFG.countdown_seconds) or 120

        if cd == maxCd and lastShownCdValue[zoneKey] ~= maxCd then
            KothNotify(
                gangCount .. " groupes détectés — Début dans " .. cd .. "s !",
                "warning", 5000)
            PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", false)
        end
        lastShownCdValue[zoneKey] = cd

    elseif state == "active" then
        if stateChange or not HUD.active or HUD.zoneKey ~= zoneKey then
            HUD_Start(zoneKey, zoneName, "active")
            KothNotify("Le combat commence ! Dernier groupe survivant gagne.",
                "combat", 6000)
        end
        local statusTxt = gangCount .. " groupe(s) en combat"
        if gangCount > 0 and gangCount <= 1 then
            statusTxt = "Dernier groupe sur zone !"
        end
        HUD_Update("active", statusTxt, 0, gangs)

    elseif state == "finished" then
        if stateChange or not HUD.active or HUD.zoneKey ~= zoneKey then
            HUD_Start(zoneKey, zoneName, "finished")
            local winner = data.winner_name or "?"
            KothNotify("Victoire de " .. winner .. " !", "victory", 7000)
            PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS", false)
        end
        local winner = data.winner_name or "?"
        HUD_Update("finished", "Vainqueur : " .. winner, 0, {})

        SetTimeout(5000, function()
            if HUD.active and HUD.zoneKey == zoneKey then HUD_Stop() end
        end)
    end

    lastShownState[zoneKey] = state
end)

RegisterNetEvent("koth:zones", function(data)
    if not data then return end
    for i = 1, #zones do
        local z = zones[i]
        if data[z.key] then
            z.state    = data[z.key].state or "idle"
            z.end_time = data[z.key].end_time or 0
            updateBlip(z.key, z.state)
        end
    end
end)

CreateThread(function()
    ESX.TriggerServerCallback("koth:getZones", function(z)
        zones = z or {}
        rebuildCapBlips()
    end)

    local timeout = 0
    while true do
        local interval    = 1000
        local p           = GetEntityCoords(PlayerPedId())
        local inAny       = false
        local currentKey  = nil

        for i = 1, #zones do
            local z = zones[i]
            if insideZone(p, z) then
                interval   = INZONE_POLL_MS
                currentKey = z.key
                if GetGameTimer() > timeout then
                    TriggerServerEvent("koth:hb", z.key)
                    timeout = GetGameTimer() + HB_INTERVAL_MS
                end
                inAny = true
            end
        end

        if inAny then
            local zState
            for i = 1, #zones do
                if zones[i].key == currentKey then
                    zState = zones[i].state
                    break
                end
            end

            if lastInsideKey ~= currentKey then
                if currentKey then
                    local zName = currentKey
                    for i = 1, #zones do
                        if zones[i].key == currentKey then
                            zName = zones[i].name
                            break
                        end
                    end
                    KothNotify("Vous entrez dans la zone " .. zName, "enter", 4000)

                    if zState and zState ~= "idle" and zState ~= "finished" then
                        HUD_Start(currentKey, zName, zState)
                    end
                end
                lastInsideKey = currentKey
            end

            applySafeZone(isStateSafe(zState))
        else
            if lastInsideKey ~= nil then
                KothNotify("Vous quittez la zone d'attaque", "exit", 3000)
                lastInsideKey = nil
                if HUD.active then HUD_Stop() end

                applySafeZone(false)
            end
        end

        Wait(interval)
    end
end)

CreateThread(function()
    while true do
        local interval = 1000
        local p        = GetEntityCoords(PlayerPedId())

        for i = 1, #zones do
            local z = zones[i]
            if z.state and z.state ~= "idle" then
                local d = #(p - vector3(z.x, z.y, z.z))
                if d < 500.0 then
                    interval = 0
                    DrawMarker(1, z.x, z.y, z.z - 1.0,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        z.radius * 2.0, z.radius * 2.0, 1.5,
                        255, 117, 31, 100, false, true, 2, false, nil, nil, false)
                end
            end
        end
        Wait(interval)
    end
end)

RegisterCommand("koth_start", function(_, args)
    TriggerServerEvent("koth:cmd:start", args[1])
end, false)

RegisterCommand("koth_stop", function(_, args)
    TriggerServerEvent("koth:cmd:stop", args[1])
end, false)

AddEventHandler("onResourceStop", function(res)
    if res ~= resName then return end
    HUD_Stop()
    clearCapBlips()

    applySafeZone(false)
    setOutzoneLock(false)
end)
