Config = {
    VoiceSystem = "pma-voice", -- Voice system selection: "pma-voice" or "saltychat".
    UseCustomNotify = false, -- Use a custom notification system (true) or the default one (false).
    RadioItem = "radio", -- Radio item name
    RadioToggleKey = "F4",
    AllowMovement = true, -- By activating this, you enable the player to move while the menu is open.
    -- gouv et usss sont presents sur TOUS les canaux des services d'urgence
    -- (police, sheriff, ems, fourriere, lsfd) en plus de leurs canaux propres
    -- (16 et 31 pour le gouvernement, 36 pour l'USSS).
    RestrictedChannels = { -- Restricted channels for jobs.
        [1] = {police = true, gouv = true, usss = true, doj = true},
        [2] = {police = true, gouv = true, usss = true, doj = true},
        [3] = {police = true, gouv = true, usss = true, doj = true},
        [4] = {police = true, sheriff = true, gouv = true, usss = true, doj = true},
        [5] = {police = true, sheriff = true, gouv = true, usss = true, doj = true},
        [6] = {sheriff = true, gouv = true, usss = true, doj = true},
        [7] = {sheriff = true, gouv = true, usss = true, doj = true},
        [8] = {sheriff = true, gouv = true, usss = true, doj = true},
        [9] = {police = true, sheriff = true, ems = true, lsfd = true, gouv = true, usss = true, doj = true},
        [10] = {police = true, sheriff = true, bobcat = true, gouv = true, usss = true, doj = true},
        [11] = {police = true, sheriff = true, ems = true, fourriere = true, lsfd = true, bobcat = true, gouv = true, usss = true, doj = true},
        [12] = {ems = true, gouv = true, usss = true, doj = true},
        [13] = {ems = true, gouv = true, usss = true, doj = true},
        [14] = {lsfd = true, gouv = true, usss = true, doj = true},
        [15] = {lsfd = true, gouv = true, usss = true, doj = true},
        [16] = {gouv = true, doj = true},
        [17] = {bobcat = true},
        [18] = {taxi = true},
        [19] = {immo = true},
        [20] = {burgershot = true},
        [21] = {pearls = true},
        [22] = {pizzeria = true},
        [23] = {bahamas = true},
        [24] = {galaxy = true},
        [25] = {unicorn = true},
        [26] = {bennys = true},
        [27] = {harmony = true},
        [28] = {hayes = true},
        [29] = {pdm = true},
        [30] = {paletoauto = true},
        [31] = {gouv = true},
        [32] = {doj = true},
        [33] = {ammu = true},
        [34] = {fourriere = true, gouv = true, usss = true},
        [35] = {weazle = true},
        [36] = {usss = true},
    },
    JammerSettings = { -- Jammer settings to interfere with communication.
        available = false, -- DESACTIVE : feature jammer non utilisee (retiree pour reduire les broadcasts reseau -1).
        item_name = 'radioscanner', -- Name of the jammer item used by players.
        enable_jobs = true,
        restricted_jobs = { police = true, police = false }, -- Only certain jobs can use jammers.
        object = "ch_prop_ch_mobile_jammer_01x", -- Object representing the jammer in the game world.
        min_distance_between_jammers = 15, -- Minimum distance allowed between two jammers.
        range = 75.0, -- Effective range of the jammers.
    },
    MaxFrequency = 999, -- Maximum frequency value allowed in the game's radio communication system.
    Locale = 'en',
    -- ! PMA Voice Configs
    -- Radio communication effects and animation settings.
    RadioEffect = true, -- Enable radio submix (voice sounds like on real radio).
    RadioAnimation = false, -- Enable animation while talking on the radio.
    RadioKey = 'CAPS', -- Default keybind for talking on the radio (CAPS).
    RadioThemes = {
        [1] = { job = "police", theme = "theme2" },
        [2] = { job = "sheriff", theme = "theme3" },
    },
    CheckIsDead = function()
        -- if GetResourceState("qb-ambulancejob") == "started" then
        --     return exports["qb-ambulancejob"]:isDead()
        -- end
        local pData = GetPlayerData()
        return gPlayer.isDeads
    end
}