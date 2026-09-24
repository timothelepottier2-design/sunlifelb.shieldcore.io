-- Luxart Vehicle Control - SETTINGS (slimmed).
-- All RegisterKeyMapping defaults are NONE - players bind keys in FiveM hotkey settings.

----------------------------------------------------------------------
-- KEYBINDINGS - hardcoded to NONE in cl_lvc.lua. Players bind keys in
-- FiveM hotkey settings (Paramètres > Touches > FiveM > LVC ...).
----------------------------------------------------------------------
-- LOCK REMINDER
----------------------------------------------------------------------
locked_press_count = 5
reminder_rate      = 10

----------------------------------------------------------------------
-- TONE BEHAVIOUR (formerly user-toggleable in the deleted RageUI menu)
----------------------------------------------------------------------
park_kill_default            = false
airhorn_interrupt_default    = true
reset_to_standby_default     = true

park_kill_masterswitch        = true
airhorn_interrupt_masterswitch = true
reset_to_standby_masterswitch = true
radio_masterswitch            = true

----------------------------------------------------------------------
-- VEHICULES D'URGENCE HORS CLASSE 18
-- LVC n'active les gyrophares / sirenes que pour la classe 18 (urgence).
-- Les deux-roues Bobcat sont de classe 8 (motos) : le gyro n'y repondait
-- jamais. Les modeles listes ici sont traites comme des vehicules
-- d'urgence quelle que soit leur classe.
----------------------------------------------------------------------
lvc_extra_emergency_models = {
    [`b4bike`]    = true, -- moto Bobcat
    [`b4bike2`]   = true, -- moto Bobcat 2
    [`b4bikedoj`] = true, -- moto DOJ (meme famille)
}

----------------------------------------------------------------------
-- RADARS AVANT / ARRIERE (lvc/cl_radar.lua)
-- Toujours actifs au volant d'un vehicule d'urgence, affiches dans le
-- panneau LVC. Aucune touche : le premier vehicule capte est verrouille
-- automatiquement (vitesse + plaque figees).
----------------------------------------------------------------------
radar_max_distance   = 150.0 -- portee en metres (avant ET arriere)
radar_los_max_distance = 150.0 -- au-dela, plus de test de ligne de vue (relief)
radar_cone_deg       = 12.0  -- demi-angle du cone de detection (degres)
radar_tick_ms        = 250   -- frequence de mesure (ms)
radar_min_patrol_kmh = 20    -- vitesse patrouille mini (km/h) pour mesurer
radar_lock_beep      = true  -- bip a chaque capture

----------------------------------------------------------------------
-- TURN SIGNALS / HAZARDS
----------------------------------------------------------------------
hazard_key            = 202   -- Backspace
left_signal_key       = 84    -- VEH_PREV_RADIO_TRACK
right_signal_key      = 83    -- VEH_NEXT_RADIO_TRACK
hazard_hold_duration  = 750

----------------------------------------------------------------------
-- BUTTON SFX (NUI audio)
----------------------------------------------------------------------
-- Choices must match a folder name under UI/sounds/.
button_sfx_scheme_choices = { 'SSP2000', 'SSP3000', 'Cencom', 'ST300' }
default_sfx_scheme_name   = 'SSP2000'

default_on_volume          = 0.5
default_off_volume         = 0.7
default_upgrade_volume     = 0.5
default_downgrade_volume   = 0.7
default_hazards_volume     = 0.09
default_lock_volume        = 0.25
default_lock_reminder_volume = 0.2
default_reminder_volume    = 0.09

-- Press/release SFX on horn / manu key.
default_airhorn_button_sfx = false
default_manu_button_sfx    = false

-- Activity reminder index (0 = off, 2..6 = preset intervals). Defaults to off.
default_activity_reminder_index = 1
