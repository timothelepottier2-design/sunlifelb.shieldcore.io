local Config = GymConfig

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

local REFRESH_MS       = 200
local DEFAULT_SCALE    = 1.00
local MAX_VOICE_METERS = 8.0

local HUD_ON = true
local hunger, thirst = 100, 100
local staminaPct = 100
local talking, radio = false, false
local voiceMeters = 3.5
local lastPush = 0

local ESX
local esxReady = false

CreateThread(function()
    while not ESX do
        if GetResourceState('es_extended') == 'started' then
            pcall(function()
                ESX = exports['es_extended']:getSharedObject()
            end)
        end
        if not ESX then Wait(500) end
    end

    while not ESX.GetPlayerData or not ESX.GetPlayerData() or not ESX.GetPlayerData().job do
        Wait(500)
    end
    esxReady = true
end)

local function getAccountAmount(accounts, names)
    if type(accounts) ~= 'table' then return 0 end
    for _, acc in ipairs(accounts) do
        for __, n in ipairs(names) do
            if acc.name == n then
                return tonumber(acc.money or acc.balance or acc.amount or 0) or 0
            end
        end
    end
    return 0
end

local function getItemAmount(inventory, names)
    if type(inventory) ~= 'table' then return 0 end
    local sum = 0
    for _, item in ipairs(inventory) do
        for __, n in ipairs(names) do
            if item.name == n then
                local c = tonumber(item.count or item.amount or item.quantity or item.qty or 0) or 0
                sum = sum + c
            end
        end
    end
    return sum
end

local function capitalizeFirst(str)
    if type(str) ~= 'string' or str == '' then return str end
    return (str:gsub('^%l', string.upper))
end

local function getEsxOverlayData()
    local name = GetPlayerName(PlayerId())
    local job = '—'
    local job2 = '—'
    local cash = 0
    local dirty = 0
    if ESX and ESX.GetPlayerData then
        local x = ESX.GetPlayerData()
        if x then
            if x.firstName and x.lastName then
                name = (x.firstName .. ' ' .. x.lastName)
            elseif x.firstname and x.lastname then
                name = (x.firstname .. ' ' .. x.lastname)
            elseif x.name then
                name = x.name
            end
            if x.job then
                job = x.job.label or x.job.name or job
                if x.job.grade_label then job = job .. ' - ' .. x.job.grade_label end
            end
            job2 = capitalizeFirst(exports["sunlife_ui"]:GetMyGangName())
            if x.inventory then
                cash = getItemAmount(x.inventory, {'money'})
                dirty = getItemAmount(x.inventory, {'dirtymoney', 'dirty_money'})
            end
        end
    end
    if cash == 0 and dirty == 0 and exports and exports.ox_inventory then
        pcall(function()
            cash = exports.ox_inventory:GetItemCount('money') or cash
            dirty = exports.ox_inventory:GetItemCount('dirtymoney') or dirty
        end)
    end
    return name, job, job2, cash, dirty
end

local function IsUiSuppressed()
    return IsCutsceneActive()
end

function buildmap()
	RequestStreamedTextureDict("squaremap", false)
	if not HasStreamedTextureDictLoaded("squaremap") then
		Wait(150)
	end
	SetMinimapClipType(0)

	SetBlipAlpha(GetNorthRadarBlip(), 0)
	SetRadarBigmapEnabled(true, false)
	SetMinimapClipType(0)
	Wait(50)
	SetRadarBigmapEnabled(false, false)
	Wait(1200)

	Wait(2500)

	if IsBigmapActive() then
		SetRadarBigmapEnabled(false, false)
		SetBigmapActive(false, false)
	end
end

Citizen.CreateThread(function()
    buildmap()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(3)
    EndScaleformMovieMethod()

    while true do
        Wait(30000)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local function clamp(x, a, b) if x < a then return a elseif x > b then return b else return x end end

local function computeMaxVoiceFromConfig()
    local maxM = MAX_VOICE_METERS
    if Config and Config.VoiceSettings then

        if Config.VoiceSettings.pma and type(Config.VoiceSettings.pma) == "table" then
            for _, entry in pairs(Config.VoiceSettings.pma) do
                if type(entry) == "table" and tonumber(entry.meter) then
                    maxM = math.max(maxM, tonumber(entry.meter))
                end
            end
        end

        if Config.VoiceSettings.saltychat and type(Config.VoiceSettings.saltychat.ranges) == "table" then
            for _, entry in pairs(Config.VoiceSettings.saltychat.ranges) do
                if type(entry) == "table" and tonumber(entry.meter) then
                    maxM = math.max(maxM, tonumber(entry.meter))
                end
            end
        end
    end
    return maxM
end

local function pushMicRange(forceMax)

    local maxM = forceMax or computeMaxVoiceFromConfig()
    SendNUIMessage({
        type     = "UPDATE_MIC_DISTANCE",
        distance = voiceMeters,
        max      = maxM
    })
end

local _lastPayload = {}
local _maxVoiceCache = MAX_VOICE_METERS
local _maxVoiceCacheAt = 0

local function _getMaxVoice()
    local now = GetGameTimer()
    if now - _maxVoiceCacheAt > 5000 then
        _maxVoiceCache = computeMaxVoiceFromConfig()
        _maxVoiceCacheAt = now
    end
    return _maxVoiceCache
end

local function nuiPush(force)
    local now = GetGameTimer()
    if not force and (now - lastPush) < REFRESH_MS then return end
    lastPush = now

    local maxForLevel = _getMaxVoice()
    local micLevel = 0
    if type(voiceMeters) == "number" then
        micLevel = clamp((voiceMeters / maxForLevel) * 100.0, 0.0, 100.0)
    end

    local ped = PlayerPedId()
    local rawHealth = GetEntityHealth(ped)
    local rawArmor = GetPedArmour(ped)
    local h, t = exports.es_extended:whatisthisgoingon()

    local stamInt = math.floor(staminaPct + 0.5)
    local micInt  = math.floor(micLevel + 0.5)

    if not force
        and _lastPayload.on == HUD_ON
        and _lastPayload.health == rawHealth
        and _lastPayload.armor == rawArmor
        and _lastPayload.hunger == h
        and _lastPayload.thirst == t
        and _lastPayload.stamina == stamInt
        and _lastPayload.micLevel == micInt
        and _lastPayload.talking == talking
        and _lastPayload.radio == radio
        and _lastPayload.underwater == isUnderwater
    then
        return
    end

    _lastPayload.on, _lastPayload.health, _lastPayload.armor = HUD_ON, rawHealth, rawArmor
    _lastPayload.hunger, _lastPayload.thirst = h, t
    _lastPayload.stamina, _lastPayload.micLevel = stamInt, micInt
    _lastPayload.talking, _lastPayload.radio, _lastPayload.underwater = talking, radio, isUnderwater

    SendNUIMessage({
        action = "statushud:set",
        on = HUD_ON,
        health = rawHealth,
        armor = rawArmor,
        hunger = h,
        thirst = t,
        stamina = stamInt,
        micLevel = micInt,
        talking = talking,
        radio = radio,
        underwater = isUnderwater
    })
end

local function setScale(scale)
    scale = tonumber(scale) or DEFAULT_SCALE
    SendNUIMessage({ action = "statushud:scale", scale = scale })
end

RegisterNetEvent('esx_status:onTick', function(_)
    local fs = exports.es_extended and exports.es_extended:returnStatus()
    if fs then
        hunger = clamp(tonumber(fs.faim) or hunger, 0, 100)
        thirst = clamp(tonumber(fs.soif) or thirst, 0, 100)
    end
    nuiPush(false)
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(h, t)
    local fs = exports.es_extended and exports.es_extended:returnStatus()
    if fs then
        hunger = h
        thirst = t
    end
    nuiPush(true)
end)

RegisterNetEvent('pma-voice:setTalkingMode', function(ranges)
    if Config and Config.VoiceSettings and Config.VoiceSettings.pma and Config.VoiceSettings.pma[ranges] then
        voiceMeters = tonumber(Config.VoiceSettings.pma[ranges].meter) or voiceMeters
        pushMicRange()
        nuiPush(false)
    end
end)

RegisterNetEvent('pma-voice:radioActive', function(isOn)
    radio = isOn and true or false
    nuiPush(false)
end)

RegisterNetEvent('SaltyChat_TalkStateChanged', function(state)
    talking = state and true or false
    nuiPush(false)
end)

RegisterNetEvent('SaltyChat_RadioTrafficStateChanged', function(_, isSending)
    radio = isSending and true or false
    nuiPush(false)
end)

RegisterNetEvent('SaltyChat_VoiceRangeChanged', function(rangeKey)
    if Config and Config.VoiceSettings and Config.VoiceSettings.saltychat and Config.VoiceSettings.saltychat.ranges then
        local entry = Config.VoiceSettings.saltychat.ranges[tostring(rangeKey)]
        if entry and entry.meter then
            voiceMeters = tonumber(entry.meter) or voiceMeters
            pushMicRange()
            nuiPush(false)
        end
    end
end)

CreateThread(function()
    while true do
        if not (Config and Config.VoiceSettings and Config.VoiceSettings.saltychat and Config.VoiceSettings.saltychat.use) then
            talking = NetworkIsPlayerTalking(PlayerId()) == 1
            nuiPush(false)
        end
        Wait(200)
    end
end)

local SUB_ENTER, SUB_EXIT = 0.35, 0.15
local isUnderwater = false

local SUB_ENTER, SUB_EXIT = 0.85, 0.35
local isUnderwater = false

CreateThread(function()
    while not esxReady do Wait(500) end
    while true do
        local pid = PlayerId()
        local ped = PlayerPedId()
        local wasUnder = isUnderwater
        local submerged = GetEntitySubmergedLevel(ped) or 0.0
        local swimUW = IsPedSwimmingUnderWater(ped) == 1

        if wasUnder then
            if (submerged < SUB_EXIT) and not swimUW then
                isUnderwater = false
            else
                isUnderwater = true
            end
        else
            if swimUW or (submerged > SUB_ENTER) then
                isUnderwater = true
            else
                isUnderwater = false
            end
        end

        if isUnderwater then
            local oxy = GetPlayerUnderwaterTimeRemaining(pid) or 0.0
            staminaPct = clamp((oxy / 10.0) * 100.0, 0.0, 100.0)
        else
            local remain = GetPlayerSprintStaminaRemaining(pid) or 100.0
            staminaPct = clamp(remain, 0.0, 100.0)
        end

        if isUnderwater and not wasUnder then
            staminaPct = 100.0
            nuiPush(true)
        end

        nuiPush(false)
        Wait(REFRESH_MS)
    end
end)

RegisterCommand('status_togglehud', function()
    HUD_ON = not HUD_ON
    nuiPush(true)
end, false)

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    Wait(300)
    SetNuiFocus(false, false)

    while not esxReady do Wait(200) end

    MAX_VOICE_METERS = computeMaxVoiceFromConfig()
    pushMicRange(MAX_VOICE_METERS)
    setScale(DEFAULT_SCALE)
    nuiPush(true)
end)

VoiceSettings = {
    ["pma"] = {
        {meter = 35},
        {meter = 65},
        {meter =  100}
    }
}

local overlay_players = 0
local overlay_max = 0

local hudSuppressed = false
local overlaySuppressed = false

local function IsInLoading()
  return false
end

local function overlaySetVisible(on)
  SendNUIMessage({ type = "overlay:visible", on = on and true or false })
end

local _lastOverlay = {}
local function pushOverlayToNUI()
    if IsUiSuppressed() then
        if not overlaySuppressed then
            overlaySuppressed = true
            SendNUIMessage({ type = "overlay:visible", on = false })
        end
        return
    elseif overlaySuppressed then
        overlaySuppressed = false
        SendNUIMessage({ type = "overlay:visible", on = true })
    end

    local name, job, job2, cash, dirty = getEsxOverlayData()
    local id = GetPlayerServerId(PlayerId())

    if _lastOverlay.id == id
        and _lastOverlay.players == overlay_players
        and _lastOverlay.max == overlay_max
        and _lastOverlay.name == name
        and _lastOverlay.job == job
        and _lastOverlay.job2 == job2
        and _lastOverlay.cash == cash
        and _lastOverlay.dirty == dirty
    then
        return
    end
    _lastOverlay.id, _lastOverlay.players, _lastOverlay.max = id, overlay_players, overlay_max
    _lastOverlay.name, _lastOverlay.job, _lastOverlay.job2 = name, job, job2
    _lastOverlay.cash, _lastOverlay.dirty = cash, dirty

    SendNUIMessage({
        type = "overlay:set",
        id = id,
        players = overlay_players,
        max = overlay_max,
        name = name,
        job = job,
        job2 = job2,
        cash = cash,
        dirty = dirty
    })
end

local _initialRequestDone = false
local function requestPlayersCountOnce()
    if _initialRequestDone then return end
    _initialRequestDone = true
    TriggerServerEvent("statushud:requestPlayersCount")
end

RegisterNetEvent("statushud:receivePlayersCount", function(playersCount, maxPlayers)
    local p = tonumber(playersCount) or 0
    local m = tonumber(maxPlayers) or 0

    if p == overlay_players and m == overlay_max then return end
    overlay_players = p
    overlay_max     = m
    pushOverlayToNUI()
end)

Citizen.CreateThread(function()

    while not esxReady do Wait(500) end

    requestPlayersCountOnce()

    CreateThread(function()
        while true do
            pushOverlayToNUI()
            Wait(2000)
        end
    end)
end)

CreateThread(function()
    local was = false
    while true do
        local now = IsCutsceneActive()
        if now and not was then

            SendNUIMessage({ action = "statushud:set", on = false })
            SendNUIMessage({ type = "overlay:visible", on = false })
            hudSuppressed = true
            overlaySuppressed = true
        elseif not now and was then

            hudSuppressed = false
            overlaySuppressed = false
            pushMicRange()
            nuiPush(true)
            overlaySetVisible(true)
        end
        was = now
        Wait(500)
    end
end)

local OVERLAY_ON = true

local function ShowStatusHUD()
    HUD_ON = true
    if not IsUiSuppressed() then
        nuiPush(true)
    else
        SendNUIMessage({ action = "statushud:set", on = false })
    end
end

local function HideStatusHUD()
    HUD_ON = false
    SendNUIMessage({ action = "statushud:set", on = false })
end

local function ShowOverlay()
    OVERLAY_ON = true
    if not IsUiSuppressed() then
        overlaySetVisible(true)
        pushOverlayToNUI()
    else
        overlaySetVisible(false)
    end
end

local function HideOverlay()
    OVERLAY_ON = false
    overlaySetVisible(false)
end

exports('ShowStatusHUD', ShowStatusHUD)
exports('HideStatusHUD', HideStatusHUD)
exports('ShowOverlay',   ShowOverlay)
exports('HideOverlay',   HideOverlay)

-- Etat reel du HUD (le F5 s'en sert pour ne pas deviner : avant, il partait
-- de "cache" alors que le HUD est affiche par defaut -> 2 appuis pour cacher).
exports('IsStatusHUDVisible', function()
    return HUD_ON == true or OVERLAY_ON == true
end)

exports('ShowHUDAndOverlay', function()
    ShowStatusHUD(); ShowOverlay()
end)
exports('HideHUDAndOverlay', function()
    HideStatusHUD(); HideOverlay()
end)

RegisterNetEvent('statushud:show',            function() ShowStatusHUD() end)
RegisterNetEvent('statushud:hide',            function() HideStatusHUD() end)
RegisterNetEvent('statushud:overlay:show',    function() ShowOverlay()   end)
RegisterNetEvent('statushud:overlay:hide',    function() HideOverlay()   end)
RegisterNetEvent('statushud:all:show',        function() ShowStatusHUD(); ShowOverlay() end)
RegisterNetEvent('statushud:all:hide',        function() HideStatusHUD(); HideOverlay() end)

local SAFE_VISIBLE = false
local SAFE_SUPPRESSED = false
local IN_SAFE = false

local function safezoneSetVisible(on)
    SAFE_VISIBLE = on and true or false
    if IsUiSuppressed() then
        SendNUIMessage({ type = "safezone:visible", on = false })
        return
    end
    SendNUIMessage({ type = "safezone:visible", on = SAFE_VISIBLE })
end

exports('SafeZoneShowFor', function(seconds)
    safezoneSetVisible(true)
    Citizen.SetTimeout(seconds, function()
        if not IN_SAFE then
            safezoneSetVisible(false)
        end
    end)
end)

AddEventHandler("UI:ShowSafe", function()
    IN_SAFE = true
    safezoneSetVisible(true)
end)

AddEventHandler("UI:HideSafe", function()
    IN_SAFE = false
    safezoneSetVisible(false)
end)
