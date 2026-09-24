-- Luxart Vehicle Control - Core (slim, no HUD/menu/storage/lang).
-- Optimized for high-population servers: hot loops only run when player is
-- the driver of an emergency vehicle, idle threads sleep 1s+, no per-frame
-- world scans, no NUI traffic from the main loop.

----------------------------------------------------------------------
-- GLOBALS (consumed by cl_audio.lua and sv_lvc.lua handlers).
----------------------------------------------------------------------
key_lock                 = false
playerped                = nil
last_veh                 = nil
veh                      = nil
trailer                  = nil
player_is_emerg_driver   = false

tone_main_reset_standby  = reset_to_standby_default
tone_airhorn_intrp       = airhorn_interrupt_default
park_kill                = park_kill_default

state_indic              = {}
state_lxsiren            = {}
state_pwrcall            = {}
state_airmanu            = {}

actv_lxsrnmute_temp      = false
actv_manu                = nil
actv_horn                = nil

----------------------------------------------------------------------
-- LOCALS
----------------------------------------------------------------------
local count_bcast_timer  = 0
local delay_bcast_timer  = 300

local count_sndclean_timer = 0
local delay_sndclean_timer = 400

local actv_ind_timer     = false
local count_ind_timer    = 0
local delay_ind_timer    = 180

local srntone_temp       = 0
local lights_on          = false
local new_tone           = nil
local tone_mem_id        = nil
local tone_mem_option    = nil
local default_tone       = nil

local ind_state_o, ind_state_l, ind_state_r, ind_state_h = 0, 1, 2, 3

local snd_lxsiren        = {}
local snd_pwrcall        = {}
local snd_airmanu        = {}

-- Approved-tones option lookup (formerly persisted in cl_storage; default to "Cycle & Button").
local tone_options       = setmetatable({}, { __index = function() return 1 end })
function UTIL:GetToneOption(tone_id) return tone_options[tone_id] or 1 end

----------------------------------------------------------------------
-- Forward declarations
----------------------------------------------------------------------
local RegisterKeyMaps, MakeOrdinal

-- Vehicule d'urgence pour LVC : classe 18, ou modele liste dans
-- lvc_extra_emergency_models (SETTINGS.lua) — ex. deux-roues Bobcat.
local function IsLvcEmergencyVehicle(v)
    if not v or v == 0 then return false end
    if GetVehicleClass(v) == 18 then return true end
    local extra = lvc_extra_emergency_models
    return extra ~= nil and extra[GetEntityModel(v)] == true
end

----------------------------------------------------------------------
-- THREAD 1 - emergency-driver detection.
-- Cheap when out of vehicle (1s wait). When in any vehicle, ticks at 250ms
-- which is enough to react to enter/exit. The control disables for emergency
-- vehicles get a dedicated tight loop in THREAD 2.
----------------------------------------------------------------------
CreateThread(function()
    while true do
        playerped = PlayerPedId()

        if IsPedInAnyVehicle(playerped, false) then
            veh = GetVehiclePedIsUsing(playerped)
            _, trailer = GetVehicleTrailerVehicle(veh)
            if GetPedInVehicleSeat(veh, -1) == playerped and IsLvcEmergencyVehicle(veh) then
                player_is_emerg_driver = true
            else
                player_is_emerg_driver = false
            end
            Wait(250)
        else
            veh                    = nil
            trailer                = nil
            player_is_emerg_driver = false
            Wait(1000)
        end
    end
end)

----------------------------------------------------------------------
-- THREAD 2 - per-frame control disabling for emergency drivers ONLY.
-- DisableControlAction must run every frame to be effective.
----------------------------------------------------------------------
CreateThread(function()
    while true do
        if player_is_emerg_driver then
            DisableControlAction(0,  80, true) -- VEH_CIN_CAM
            DisableControlAction(0,  86, true) -- VEH_HORN
            DisableControlAction(0, 172, true) -- CELLPHONE_UP
            DisableControlAction(0,  85, true) -- VEH_RADIO_WHEEL (R)
            if veh ~= nil then SetVehicleRadioEnabled(veh, false) end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

----------------------------------------------------------------------
-- THREAD 3 - vehicle exit detection (event-driven, low cost).
----------------------------------------------------------------------
CreateThread(function()
    local last_state, last_v = false, nil
    while true do
        if player_is_emerg_driver then
            last_state, last_v = true, veh
            Wait(500)
        else
            if last_state and last_v then
                TriggerEvent('lvc:onVehicleExit', last_v)
                last_state, last_v = false, nil
            end
            Wait(500)
        end
    end
end)

----------------------------------------------------------------------
-- THREAD 4 - vehicle change detection.
----------------------------------------------------------------------
CreateThread(function()
    while true do
        if player_is_emerg_driver and veh ~= nil and last_veh ~= veh then
            last_veh = veh
            TriggerEvent('lvc:onVehicleChange')
        end
        Wait(1000)
    end
end)

----------------------------------------------------------------------
-- EVENT HANDLERS
----------------------------------------------------------------------
RegisterNetEvent('lvc:onVehicleExit', function(v)
    if not park_kill_masterswitch or not park_kill then return end
    v = v or veh
    if not v then return end

    if not tone_main_reset_standby and (state_lxsiren[v] or 0) ~= 0 then
        UTIL:SetToneByID('MAIN_MEM', state_lxsiren[v])
    end
    SetLxSirenStateForVeh(v, 0)
    SetPowercallStateForVeh(v, 0)
    SetAirManuStateForVeh(v, 0)
    HUD:SetItemState('siren', false)
    HUD:SetItemState('horn',  false)
    count_bcast_timer = delay_bcast_timer
end)

RegisterNetEvent('lvc:onVehicleChange', function()
    UTIL:UpdateApprovedTones(veh)
    HUD:RefreshHudItemStates()
    if veh then
        SetVehRadioStation(veh, 'OFF')
        Wait(500)
        SetVehRadioStation(veh, 'OFF')
    end
end)

----------------------------------------------------------------------
-- COMMANDS
----------------------------------------------------------------------
RegisterCommand('lvclock', function()
    if not player_is_emerg_driver then return end
    key_lock = not key_lock
    AUDIO:Play('Key_Lock', AUDIO.lock_volume, true)
    HUD:SetItemState('lock', key_lock)
end)
RegisterKeyMapping('lvclock', 'LVC - Verrouiller les commandes sirene', 'keyboard', '')

----------------------------------------------------------------------
-- Dedicated LIGHTS toggle command (bindable from FiveM hotkey settings).
-- Toggles the vehicle siren lights (R*) on/off. Also kills siren audio
-- when lights are turned off.
----------------------------------------------------------------------
RegisterCommand('_lvc_lights', function()
    if veh == nil or not player_is_emerg_driver or key_lock then return end
    local on = IsVehicleSirenOn(veh)
    if on then
        AUDIO:Play('Off', AUDIO.off_volume)
        SetVehicleSiren(veh, false)
        if trailer and trailer ~= 0 then SetVehicleSiren(trailer, false) end
        SetLxSirenStateForVeh(veh, 0)
        SetPowercallStateForVeh(veh, 0)
        HUD:SetItemState('switch', false)
        HUD:SetItemState('siren',  false)
    else
        AUDIO:Play('On', AUDIO.on_volume)
        SetVehicleSiren(veh, true)
        if trailer and trailer ~= 0 then SetVehicleSiren(trailer, true) end
        HUD:SetItemState('switch', true)
    end
    AUDIO:ResetActivityTimer()
    count_bcast_timer = delay_bcast_timer
end)
RegisterKeyMapping('_lvc_lights', 'LVC - Allumer / eteindre les feux de sirene', 'keyboard', '')

----------------------------------------------------------------------
-- INIT
----------------------------------------------------------------------
CreateThread(function()
    SetNuiFocus(false, false)
    UTIL:FixOversizeKeys(SIREN_ASSIGNMENTS)
    RegisterKeyMaps()
    TriggerEvent('chat:addSuggestion', '/lvclock', 'Verrouille / deverrouille les commandes sirene.')
end)

----------------------------------------------------------------------
-- DYNAMIC SIREN-TONE KEY REGISTRATIONS
----------------------------------------------------------------------
RegisterKeyMaps = function()
    for i, _ in ipairs(SIRENS) do
        if i ~= 1 then
            local cmd  = '_lvc_siren_' .. (i - 1)
            local desc = string.format('LVC - Sirene %s', MakeOrdinal(i - 1))

            RegisterCommand(cmd, function()
                if veh == nil or not player_is_emerg_driver or key_lock then return end

                local proposed_tone = UTIL:GetToneAtPos(i)
                if not proposed_tone then return end

                local opt = UTIL:GetToneOption(proposed_tone)
                if opt ~= 1 and opt ~= 3 then return end

                if (i - 1) >= #UTIL:GetApprovedTonesTable() then return end

                -- Auto-enable vehicle siren lights if they are off, so the
                -- user does not have to press the lights button first.
                if not IsVehicleSirenOn(veh) then
                    SetVehicleSiren(veh, true)
                    if trailer and trailer ~= 0 then SetVehicleSiren(trailer, true) end
                    HUD:SetItemState('switch', true)
                    AUDIO:Play('On', AUDIO.on_volume)
                    count_bcast_timer = delay_bcast_timer
                end

                if state_lxsiren[veh] ~= proposed_tone or state_lxsiren[veh] == 0 then
                    AUDIO:Play('Upgrade', AUDIO.upgrade_volume)
                    HUD:SetItemState('siren', true)
                    SetLxSirenStateForVeh(veh, proposed_tone)
                else
                    AUDIO:Play('Downgrade', AUDIO.downgrade_volume)
                    if (state_pwrcall[veh] or 0) == 0 then
                        HUD:SetItemState('siren', false)
                    end
                    SetLxSirenStateForVeh(veh, 0)
                end
                count_bcast_timer = delay_bcast_timer
            end)

            RegisterKeyMapping(cmd, desc, 'keyboard', '')
        end
    end
end

MakeOrdinal = function(n)
    local sufixes = { 'th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th' }
    local mod = n % 100
    if mod == 11 or mod == 12 or mod == 13 then return n .. 'th' end
    return n .. sufixes[(n % 10) + 1]
end

----------------------------------------------------------------------
-- SOUND CLEANUP - kills sounds for vehicles that no longer exist.
----------------------------------------------------------------------
local function CleanupSounds()
    if count_sndclean_timer < delay_sndclean_timer then
        count_sndclean_timer = count_sndclean_timer + 1
        return
    end
    count_sndclean_timer = 0

    local function release(state_tbl, snd_tbl, dead_check)
        for k, v in pairs(state_tbl) do
            if v and (not DoesEntityExist(k) or IsEntityDead(k) or (dead_check and dead_check(k))) then
                if snd_tbl[k] then
                    StopSound(snd_tbl[k])
                    ReleaseSoundId(snd_tbl[k])
                    snd_tbl[k]   = nil
                end
                state_tbl[k] = nil
            end
        end
    end

    release(state_lxsiren, snd_lxsiren)
    release(state_pwrcall, snd_pwrcall)
    release(state_airmanu, snd_airmanu, function(e) return IsVehicleSeatFree(e, -1) end)
end

----------------------------------------------------------------------
-- LOW-LEVEL VEH STATE SETTERS
----------------------------------------------------------------------
function TogIndicStateForVeh(v, newstate)
    if not DoesEntityExist(v) or IsEntityDead(v) then return end
    if newstate == ind_state_o then
        SetVehicleIndicatorLights(v, 0, false); SetVehicleIndicatorLights(v, 1, false)
    elseif newstate == ind_state_l then
        SetVehicleIndicatorLights(v, 0, false); SetVehicleIndicatorLights(v, 1, true)
    elseif newstate == ind_state_r then
        SetVehicleIndicatorLights(v, 0, true);  SetVehicleIndicatorLights(v, 1, false)
    elseif newstate == ind_state_h then
        SetVehicleIndicatorLights(v, 0, true);  SetVehicleIndicatorLights(v, 1, true)
    end
    state_indic[v] = newstate
end

function TogMuteDfltSrnForVeh(v, toggle)
    if DoesEntityExist(v) and not IsEntityDead(v) then
        DisableVehicleImpactExplosionActivation(v, toggle)
    end
end

function SetLxSirenStateForVeh(v, newstate)
    if not DoesEntityExist(v) or IsEntityDead(v) then return end
    if newstate == state_lxsiren[v] or newstate == nil then return end
    if snd_lxsiren[v] then
        StopSound(snd_lxsiren[v]); ReleaseSoundId(snd_lxsiren[v]); snd_lxsiren[v] = nil
    end
    if newstate ~= 0 then
        snd_lxsiren[v] = GetSoundId()
        PlaySoundFromEntity(snd_lxsiren[v], SIRENS[newstate].String, v, SIRENS[newstate].Ref, 0, 0)
        TogMuteDfltSrnForVeh(v, true)
    end
    state_lxsiren[v] = newstate
end

function SetPowercallStateForVeh(v, newstate)
    if not DoesEntityExist(v) or IsEntityDead(v) then return end
    if newstate == state_pwrcall[v] or newstate == nil then return end
    if snd_pwrcall[v] then
        StopSound(snd_pwrcall[v]); ReleaseSoundId(snd_pwrcall[v]); snd_pwrcall[v] = nil
    end
    if newstate ~= 0 then
        snd_pwrcall[v] = GetSoundId()
        PlaySoundFromEntity(snd_pwrcall[v], SIRENS[newstate].String, v, SIRENS[newstate].Ref, 0, 0)
    end
    state_pwrcall[v] = newstate
end

function SetAirManuStateForVeh(v, newstate)
    if not DoesEntityExist(v) or IsEntityDead(v) then return end
    if newstate == state_airmanu[v] or newstate == nil then return end
    if snd_airmanu[v] then
        StopSound(snd_airmanu[v]); ReleaseSoundId(snd_airmanu[v]); snd_airmanu[v] = nil
    end
    if newstate ~= 0 then
        snd_airmanu[v] = GetSoundId()
        PlaySoundFromEntity(snd_airmanu[v], SIRENS[newstate].String, v, SIRENS[newstate].Ref, 0, 0)
    end
    state_airmanu[v] = newstate
end

----------------------------------------------------------------------
-- REMOTE STATE EVENTS (other players' vehicles).
----------------------------------------------------------------------
local function applyRemote(sender, fn, newstate)
    local p = GetPlayerFromServerId(sender)
    if p == -1 then return end
    local ped_s = GetPlayerPed(p)
    if not DoesEntityExist(ped_s) or IsEntityDead(ped_s) or ped_s == PlayerPedId() then return end
    if not IsPedInAnyVehicle(ped_s, false) then return end
    fn(GetVehiclePedIsUsing(ped_s), newstate)
end

RegisterNetEvent('lvc:TogIndicState_c',     function(s, n) applyRemote(s, TogIndicStateForVeh, n) end)
RegisterNetEvent('lvc:TogDfltSrnMuted_c',   function(s)    applyRemote(s, function(v) TogMuteDfltSrnForVeh(v, true) end) end)
RegisterNetEvent('lvc:SetLxSirenState_c',   function(s, n) applyRemote(s, SetLxSirenStateForVeh, n) end)
RegisterNetEvent('lvc:SetPwrcallState_c',   function(s, n) applyRemote(s, SetPowercallStateForVeh, n) end)
RegisterNetEvent('lvc:SetAirManuState_c',   function(s, n) applyRemote(s, SetAirManuStateForVeh, n) end)

----------------------------------------------------------------------
-- MAIN GAMEPLAY LOOP - controls / cycling / broadcasts.
-- Runs at 250ms when in any vehicle, 5s when on foot. Inputs that need
-- frame-perfect detection (control disabling, IsControlPressed for hold) are
-- handled by THREAD 2 above.
----------------------------------------------------------------------
CreateThread(function()
    while true do
        CleanupSounds()

        local v = veh
        if v ~= nil and GetPedInVehicleSeat(v, -1) == playerped then
            DistantCopCarSirens(false)

            if state_indic[v] == nil then state_indic[v] = ind_state_o end

            -- Auto-cancel turn signals.
            if actv_ind_timer and (state_indic[v] == ind_state_l or state_indic[v] == ind_state_r) then
                if GetEntitySpeed(v) < 6 then
                    count_ind_timer = 0
                else
                    if count_ind_timer > delay_ind_timer then
                        count_ind_timer  = 0
                        actv_ind_timer   = false
                        state_indic[v]   = ind_state_o
                        TogIndicStateForVeh(v, state_indic[v])
                        count_bcast_timer = delay_bcast_timer
                    else
                        count_ind_timer = count_ind_timer + 1
                    end
                end
            end

            -- ---------------------- EMERGENCY VEHICLE ----------------------
            if IsLvcEmergencyVehicle(v) then
                lights_on = IsVehicleSirenOn(v)
                if radio_masterswitch then SetVehicleRadioEnabled(v, true) end

                if not IsEntityDead(v) then
                    TogMuteDfltSrnForVeh(v, true)
                    state_lxsiren[v] = state_lxsiren[v] or 0
                    state_pwrcall[v] = state_pwrcall[v] or 0
                    state_airmanu[v] = state_airmanu[v] or 0

                    if not lights_on and state_lxsiren[v] > 0 then
                        if not tone_main_reset_standby then
                            UTIL:SetToneByID('MAIN_MEM', state_lxsiren[v])
                        end
                        SetLxSirenStateForVeh(v, 0)
                        count_bcast_timer = delay_bcast_timer
                    end
                    if not lights_on and state_pwrcall[v] > 0 then
                        SetPowercallStateForVeh(v, 0)
                        count_bcast_timer = delay_bcast_timer
                    end

                    if not IsPauseMenuActive() and UpdateOnscreenKeyboard() ~= 0 then
                        if not key_lock then
                            -- TOG DEFAULT SIREN LIGHTS
                            if IsDisabledControlJustReleased(0, 85) then
                                if lights_on then
                                    AUDIO:Play('Off', AUDIO.off_volume)
                                    HUD:SetItemState('switch', false)
                                    HUD:SetItemState('siren',  false)
                                    SetVehicleSiren(v, false)
                                    if trailer and trailer ~= 0 then SetVehicleSiren(trailer, false) end
                                else
                                    AUDIO:Play('On', AUDIO.on_volume)
                                    HUD:SetItemState('switch', true)
                                    SetVehicleSiren(v, true)
                                    if trailer and trailer ~= 0 then SetVehicleSiren(trailer, true) end
                                end
                                AUDIO:ResetActivityTimer()
                                count_bcast_timer = delay_bcast_timer
                            -- TOG LX SIREN
                            elseif IsDisabledControlJustReleased(0, 19) then
                                if state_lxsiren[v] == 0 then
                                    if lights_on then
                                        AUDIO:Play('Upgrade', AUDIO.upgrade_volume)
                                        HUD:SetItemState('siren', true)
                                        if not tone_main_reset_standby then
                                            tone_mem_id     = UTIL:GetToneID('MAIN_MEM')
                                            tone_mem_option = UTIL:GetToneOption(tone_mem_id)
                                            if UTIL:IsApprovedTone(tone_mem_id) and tone_mem_option ~= 3 and tone_mem_option ~= 4 then
                                                SetLxSirenStateForVeh(v, tone_mem_id)
                                            else
                                                new_tone = UTIL:GetNextSirenTone(tone_mem_id, v, true)
                                                UTIL:SetToneByID('MAIN_MEM', new_tone)
                                                SetLxSirenStateForVeh(v, new_tone)
                                            end
                                        else
                                            default_tone = UTIL:GetToneAtPos(2)
                                            SetLxSirenStateForVeh(v, default_tone)
                                        end
                                    end
                                else
                                    AUDIO:Play('Downgrade', AUDIO.downgrade_volume)
                                    if (state_pwrcall[v] or 0) == 0 then
                                        HUD:SetItemState('siren', false)
                                    end
                                    if not tone_main_reset_standby then
                                        UTIL:SetToneByID('MAIN_MEM', state_lxsiren[v])
                                    end
                                    SetLxSirenStateForVeh(v, 0)
                                end
                                AUDIO:ResetActivityTimer()
                                count_bcast_timer = delay_bcast_timer
                            -- POWERCALL
                            elseif IsDisabledControlJustReleased(0, 172) then
                                if state_pwrcall[v] == 0 then
                                    if lights_on then
                                        AUDIO:Play('Upgrade', AUDIO.upgrade_volume)
                                        HUD:SetItemState('siren', true)
                                        SetPowercallStateForVeh(v, UTIL:GetToneID('AUX'))
                                        count_bcast_timer = delay_bcast_timer
                                    end
                                else
                                    AUDIO:Play('Downgrade', AUDIO.downgrade_volume)
                                    if (state_lxsiren[v] or 0) == 0 then
                                        HUD:SetItemState('siren', false)
                                    end
                                    SetPowercallStateForVeh(v, 0)
                                end
                                AUDIO:ResetActivityTimer()
                                count_bcast_timer = delay_bcast_timer
                            end

                            -- CYCLE LX TONES
                            if state_lxsiren[v] > 0 and IsDisabledControlJustReleased(0, 80) then
                                AUDIO:Play('Upgrade', AUDIO.upgrade_volume)
                                HUD:SetItemState('horn', false)
                                SetLxSirenStateForVeh(v, UTIL:GetNextSirenTone(state_lxsiren[v], v, true))
                                count_bcast_timer = delay_bcast_timer
                            end

                            -- MANU (push-to-play primary manual tone)
                            if state_lxsiren[v] < 1 then
                                if IsDisabledControlPressed(0, 80) then
                                    if not actv_manu then HUD:SetItemState('siren', true) end
                                    actv_manu = true
                                    AUDIO:ResetActivityTimer()
                                else
                                    if actv_manu then HUD:SetItemState('siren', false) end
                                    actv_manu = false
                                end
                            else
                                if actv_manu then HUD:SetItemState('siren', false) end
                                actv_manu = false
                            end

                            -- HORN
                            if IsDisabledControlPressed(0, 86) then
                                if not actv_horn then HUD:SetItemState('horn', true) end
                                actv_horn = true
                                AUDIO:ResetActivityTimer()
                            else
                                if actv_horn then HUD:SetItemState('horn', false) end
                                actv_horn = false
                            end

                            -- SFX
                            if AUDIO.airhorn_button_SFX then
                                if IsDisabledControlJustPressed(0, 86) then AUDIO:Play('Press',  AUDIO.upgrade_volume) end
                                if IsDisabledControlJustReleased(0, 86) then AUDIO:Play('Release', AUDIO.upgrade_volume) end
                            end
                            if AUDIO.manu_button_SFX and state_lxsiren[v] == 0 then
                                if IsDisabledControlJustPressed(0, 80) then AUDIO:Play('Press',  AUDIO.upgrade_volume) end
                                if IsDisabledControlJustReleased(0, 80) then AUDIO:Play('Release', AUDIO.upgrade_volume) end
                            end
                        else
                            -- LOCKED - just play reminder occasionally.
                            if (IsDisabledControlJustReleased(0, 86) or
                                IsDisabledControlJustReleased(0, 172) or
                                IsDisabledControlJustReleased(0, 19) or
                                IsDisabledControlJustReleased(0, 85)) then
                                if locked_press_count % reminder_rate == 0 then
                                    AUDIO:Play('Locked_Press', AUDIO.lock_reminder_volume, true)
                                end
                                locked_press_count = locked_press_count + 1
                            end
                        end
                    end

                    -- AIRHORN / MANU TONE STATE
                    local hmanu_state_new = 0
                    if     actv_horn and not actv_manu then hmanu_state_new = UTIL:GetToneID('ARHRN')
                    elseif not actv_horn and actv_manu then hmanu_state_new = UTIL:GetToneID('PMANU')
                    elseif actv_horn and actv_manu     then hmanu_state_new = UTIL:GetToneID('SMANU') end

                    if tone_airhorn_intrp then
                        if hmanu_state_new == UTIL:GetToneID('ARHRN') then
                            if state_lxsiren[v] > 0 and not actv_lxsrnmute_temp then
                                srntone_temp        = state_lxsiren[v]
                                SetLxSirenStateForVeh(v, 0)
                                actv_lxsrnmute_temp = true
                            end
                        else
                            if actv_lxsrnmute_temp then
                                SetLxSirenStateForVeh(v, srntone_temp)
                                actv_lxsrnmute_temp = false
                            end
                        end
                    end

                    if state_airmanu[v] ~= hmanu_state_new then
                        SetAirManuStateForVeh(v, hmanu_state_new)
                        count_bcast_timer = delay_bcast_timer
                    end
                end
            else
                TogMuteDfltSrnForVeh(v, true)
            end

            -- ---------------------- ANY LAND VEHICLE ----------------------
            local cls = GetVehicleClass(v)
            if cls ~= 14 and cls ~= 15 and cls ~= 16 and cls ~= 21 and not IsPauseMenuActive() then
                if IsDisabledControlJustReleased(0, left_signal_key) then
                    local cstate = state_indic[v]
                    if cstate == ind_state_l then
                        state_indic[v] = ind_state_o; actv_ind_timer = false
                    else
                        state_indic[v] = ind_state_l; actv_ind_timer = true
                    end
                    TogIndicStateForVeh(v, state_indic[v])
                    count_ind_timer = 0
                    count_bcast_timer = delay_bcast_timer
                elseif IsDisabledControlJustReleased(0, right_signal_key) then
                    local cstate = state_indic[v]
                    if cstate == ind_state_r then
                        state_indic[v] = ind_state_o; actv_ind_timer = false
                    else
                        state_indic[v] = ind_state_r; actv_ind_timer = true
                    end
                    TogIndicStateForVeh(v, state_indic[v])
                    count_ind_timer = 0
                    count_bcast_timer = delay_bcast_timer
                elseif IsControlPressed(0, hazard_key) and GetLastInputMethod(0) then
                    Wait(hazard_hold_duration)
                    if IsControlPressed(0, hazard_key) then
                        local cstate = state_indic[v]
                        if cstate == ind_state_h then
                            state_indic[v] = ind_state_o
                            AUDIO:Play('Hazards_Off', AUDIO.hazards_volume, true)
                        else
                            state_indic[v] = ind_state_h
                            AUDIO:Play('Hazards_On', AUDIO.hazards_volume, true)
                        end
                        TogIndicStateForVeh(v, state_indic[v])
                        actv_ind_timer  = false
                        count_ind_timer = 0
                        count_bcast_timer = delay_bcast_timer
                        Wait(300)
                    end
                end

                -- BROADCAST
                if count_bcast_timer > delay_bcast_timer then
                    count_bcast_timer = 0
                    if IsLvcEmergencyVehicle(v) then
                        TriggerServerEvent('lvc:TogDfltSrnMuted_s')
                        TriggerServerEvent('lvc:SetLxSirenState_s', state_lxsiren[v])
                        TriggerServerEvent('lvc:SetPwrcallState_s', state_pwrcall[v])
                        TriggerServerEvent('lvc:SetAirManuState_s', state_airmanu[v])
                    end
                    TriggerServerEvent('lvc:TogIndicState_s', state_indic[v])
                else
                    count_bcast_timer = count_bcast_timer + 1
                end
            end

            Wait(500)  -- matches legacy LVC tick rate; control disabling lives in THREAD 2
        else
            Wait(2000)
        end
    end
end)
