-- Luxart Vehicle Control - Audio (slim).
-- Plays button SFX through the (invisible) NUI page and handles the
-- "remember to turn on your siren" reminder.

AUDIO = {}

local activity_timer            = 0
local activity_reminder_index   = default_activity_reminder_index or 1
local activity_reminder_lookup  = { [2] = 30000, [3] = 60000, [4] = 120000, [5] = 300000, [6] = 600000 }

AUDIO.radio_masterswitch        = true
AUDIO.airhorn_button_SFX        = default_airhorn_button_sfx
AUDIO.manu_button_SFX           = default_manu_button_sfx

AUDIO.button_sfx_scheme_choices = button_sfx_scheme_choices
AUDIO.button_sfx_scheme         = default_sfx_scheme_name

AUDIO.on_volume                 = default_on_volume
AUDIO.off_volume                = default_off_volume
AUDIO.upgrade_volume            = default_upgrade_volume
AUDIO.downgrade_volume          = default_downgrade_volume
AUDIO.hazards_volume            = default_hazards_volume
AUDIO.lock_volume               = default_lock_volume
AUDIO.lock_reminder_volume      = default_lock_reminder_volume
AUDIO.activity_reminder_volume  = default_reminder_volume

-- Expose radio_masterswitch as a global so cl_lvc.lua can read it.
radio_masterswitch              = AUDIO.radio_masterswitch

----------------------------------------------------------------------
-- ACTIVITY REMINDER (single thread, idles when feature disabled).
----------------------------------------------------------------------
CreateThread(function()
    while true do
        if activity_reminder_index > 1
            and player_is_emerg_driver
            and veh
            and IsVehicleSirenOn(veh)
            and (state_lxsiren[veh] or 0) == 0
            and (state_pwrcall[veh] or 0) == 0
        then
            if activity_timer < 1 then
                AUDIO:Play('Reminder', AUDIO.activity_reminder_volume)
                AUDIO:ResetActivityTimer()
                Wait(1000)
            else
                Wait(1000)
                activity_timer = activity_timer - 1000
            end
        else
            Wait(2000)
        end
    end
end)

----------------------------------------------------------------------
-- NATIVE GTA SFX FALLBACK
-- Le LVC original joue ses SFX via un Audio() HTML qui pointe sur
-- html/sounds/<scheme>/<file>.ogg. On n'embarque pas ces .ogg ici, donc
-- on mappe les évènements logiques vers des sons frontend natifs GTA.
-- Lookup par nom logique (avant préfixage du scheme).
----------------------------------------------------------------------
-- Sons natifs GTA mappés sur les évènements logiques du LVC.
-- On vise un feeling "switch industriel" plus marqué que les clicks de menu :
--   * TOGGLE_ON / TOGGLE_OFF  : vrai click d'interrupteur (pause menu).
--   * Pin_Drop                : tap mécanique sec (planning board des heists).
--   * Beast_Confirm           : thunk lourd (validation heist prep).
local NATIVE_SFX = {
    On            = { name = 'TOGGLE_ON',       set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Off           = { name = 'TOGGLE_OFF',      set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Upgrade       = { name = 'Pin_Drop',        set = 'DLC_HEIST_PLANNING_BOARD_SOUNDS' },
    Downgrade     = { name = 'Pin_Drop',        set = 'DLC_HEIST_PLANNING_BOARD_SOUNDS' },
    Press         = { name = 'Pin_Drop',        set = 'DLC_HEIST_PLANNING_BOARD_SOUNDS' },
    Release       = { name = 'TOGGLE_OFF',      set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Key_Lock      = { name = 'Beast_Confirm',   set = 'DLC_HEIST_PREP_SCREEN_SOUNDS' },
    Locked_Press  = { name = 'ERROR',           set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Hazards_On    = { name = 'TOGGLE_ON',       set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Hazards_Off   = { name = 'TOGGLE_OFF',      set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    Reminder      = { name = 'CHECKPOINT_PERFECT', set = 'HUD_MINI_GAME_SOUNDSET' },
}

----------------------------------------------------------------------
-- API
----------------------------------------------------------------------
function AUDIO:Play(soundFile, soundVolume, schemeless)
    -- Fast-path: jouer un son natif GTA. `soundFile` est ici la clé logique
    -- ('On', 'Off', 'Upgrade'...) AVANT préfixage par le scheme. On lookup
    -- avant d'altérer la valeur pour pas casser les noms qualifiés.
    local native = NATIVE_SFX[soundFile]
    if native then
        PlaySoundFrontend(-1, native.name, native.set, true)
        return
    end

    -- Fallback NUI (pour si jamais un set d'.ogg est ajouté à html/sounds/).
    if not schemeless then
        soundFile = AUDIO.button_sfx_scheme .. '/' .. soundFile
    end
    SendNUIMessage({
        _type  = 'audio',
        file   = soundFile,
        volume = soundVolume,
    })
end

function AUDIO:ResetActivityTimer()
    activity_timer = activity_reminder_lookup[activity_reminder_index] or 0
end

function AUDIO:GetActivityTimer()           return activity_timer end
function AUDIO:GetActivityReminderIndex()   return activity_reminder_index end
function AUDIO:SetActivityReminderIndex(i)  if i then activity_reminder_index = i end end
