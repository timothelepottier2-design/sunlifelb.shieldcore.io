Config = {
    GeneralDebug = false, -- Enables or disables debugging.
    UseLeaderboard = true, -- Enables or disables the use of a leaderboard to track players' table tennis scores.
    LeaderboardTopCount = 25, -- Perf : nb d'entrees (avec mugshot ~5KB) envoyees au client. Baisse = payload plus petit / moins de hitch.
    EnableBetting = true, -- Allows or disallows betting on table tennis matches.
    BettingInventoryName = "money", -- "money", etc. Specifies the name of the in-game currency that players can use to bet on table tennis matches.
    MinBet = 1000, -- Specifies the minimum amount of in-game currency players can bet on their table tennis match.
    MaxBet = 50000, -- Sets the maximum amount of in-game currency that players can bet on a table tennis match.
    BetStep = 1000, -- Determines the increment step for adjusting the bet amount during betting.
    PlayerIdentifier = "license", -- Identifies the player using their license or a specified identifier.

    Keys = {
        ActionKey = 38, -- Key code for performing actions in the game.
        LeaveKey = 177, -- Key code for leaving the table tennis game.
        MouseLock = 244, -- Key code for locking/unlocking the mouse during gameplay.
        RequestTop = 182, -- Key code for requesting the top players' scores.
        CameraTilt = 26 -- Key code for tilting the in-game camera.
    },
    -- All key codes can be found at: https://docs.fivem.net/docs/game-references/controls/

    -- Target
    UseTarget = true, -- whether to use target zones or not
    TargetZoneType = 4, -- 1: q_target, 2: bt_target, 3: qb-target, 4: ox_target

    Locale = "en", -- Sets the language/locale for in-game text and messages. Check `translation.lua` for available locales.
    SpawnDistance = 30.0, -- Sets the maximum distance at which table tennis objects (specified in "Objects") can spawn from the player. If the player's distance exceeds this value, the tables will despawn.

    -- Enable rcore_stats? (https://store.rcore.cz/package/6273968)
    Rcore_Stats = GetResourceState("rcore_stats") ~= "missing",

    -- Spawns the table tennis objects in the game world.
    -- Color variations can be found at: https://documentation.rcore.cz/paid-resources/rcore_pingpong/spawning-a-pong-table
    Objects = {
        { pos = vector3(252.185837, -771.934753, 29.719282), heading = 68.5, model = "prop_table_tennis" }, 
        { pos = vector3(-1719.719360, -1116.799194, 12.152875), heading = 318.5, model = "prop_table_tennis" }, 
        { pos = vector3(-1722.715210, -1114.148804, 12.152875), heading = 318.5, model = "prop_table_tennis" }, 
        { pos = vector3(-1477.696, -954.5209, 9.20347), heading = 408.0, model = "prop_table_tennis" }, 
        { pos = vector3(39.75943, 537.7939, 174.8531), heading = 110.0, model = "prop_table_tennis" }, 
        { pos = vector3(-589.0319, 105.8244, 67.19884), heading = 0.0, model = "prop_table_tennis" }, 
        { pos = vector3(-1249.2697753906, -3013.5925292969, -49.49015045166), heading = 0.0, model = "prop_table_tennis" }, 
        { pos = vector3(-1268.6055908203, -3031.0595703125, -49.490238189697), heading = 0.0, model = "prop_table_tennis" }, 
        { pos = vector3(-1264.8580322266, -3031.0646972656, -49.490238189697), heading = 0.0, model = "prop_table_tennis" }, 
        { pos = vector3(-1285.1489257812, -3013.2739257812, -49.490016937256), heading = 0.0, model = "prop_table_tennis" },
        { pos = vector3(233.6378, -895.9488, 29.6921), heading = 234.3418, model = "prop_table_tennis" },
        { pos = vector3(231.0315, -899.7401, 29.7019), heading = 238.0901, model = "prop_table_tennis" },
        { pos = vector3(-188.1191, -1586.0560, 33.8014), heading = 50.0070, model = "prop_table_tennis" },
        { pos = vector3(81.4898, -1942.8162, 19.8807), heading = 51.9725, model = "prop_table_tennis" },
        { pos = vector3(-157.1075, -1545.9688, 33.9537), heading = 49.7838, model = "prop_table_tennis" },
        { pos = vector3(86.5503, -1950.3677, 19.8378), heading = 143.1042, model = "prop_table_tennis" },
        { pos = vector3(348.0159, -2045.5524, 20.7980), heading = 319.2432, model = "prop_table_tennis" },
        { pos = vector3(342.6203, -2052.0752, 20.3743), heading = 319.7467, model = "prop_table_tennis" },
        { pos = vector3(-1546.2670, -423.4225, 40.9953), heading = 318.9495, model = "prop_table_tennis" },
        { pos = vector3(-913.5291, -793.8939, 15.7178), heading = 94.4862, model = "prop_table_tennis" },
        { pos = vector3(-664.7089, 307.4866, 82.0841), heading = 265.0206, model = "prop_table_tennis" },
        { pos = vector3(-1254.5237, -265.0308, 37.9340), heading = 298.8694, model = "prop_table_tennis" },
        { pos = vector3(-1041.3263, -849.3560, 3.8765), heading = 53.4066, model = "prop_table_tennis" },
        { pos = vector3(1679.5544, 2512.0283, 44.5648), heading = 323.6611, model = "prop_table_tennis" },
        { pos = vector3(-142.0316, 280.4914, 92.9280), heading = 89.4866, model = "prop_table_tennis" },
        { pos = vector3(487.8781, 4791.8955, -59.3939), heading = 290.1785, model = "prop_table_tennis" },
        { pos = vector3(488.8201, 4788.5791, -59.3939), heading = 286.3065, model = "prop_table_tennis" },
        { pos = vector3(490.3404, 4782.4004, -59.3940), heading = 289.0211, model = "prop_table_tennis" },
        { pos = vector3(-276.8814, -922.7514, 30.2160), heading = 68.8214, model = "prop_table_tennis" },
        { pos = vector3(1656.1768, 2539.6248, 44.5648), heading = 317.5587, model = "prop_table_tennis" },
        { pos = vector3(1713.1310, 2518.6497, 44.5648), heading = 298.3531, model = "prop_table_tennis" },
        { pos = vector3(1427.6118, 4686.9614, 132.9857), heading = 283.9641, model = "prop_table_tennis" },
        { pos = vector3(2790.2329, 4710.9907, 47.6274), heading = 194.4118, model = "prop_table_tennis" },
        { pos = vector3(-341.6029, 7746.6353, 5.3982), heading = 29.9406, model = "prop_table_tennis" },
        { pos = vector3(-311.3472, 7787.1641, 5.3982), heading = 318.2696, model = "prop_table_tennis" },
        { pos = vector3(-7.5585, -1090.6064, 26.0418), heading = 339.2682, model = "prop_table_tennis" },
        { pos = vector3(46.7339, 6510.3037, 34.6679), heading = 220.3651, model = "prop_table_tennis" },
        { pos = vector3(-220.0632, 6237.2969, 30.9441), heading = 45.0849, model = "prop_table_tennis" },
        { pos = vector3(-178.0024, -1165.8279, 22.0440), heading = 0.6877, model = "prop_table_tennis" },
        { pos = vector3(-920.3295, -2053.6340, 8.4050), heading = 45.7339, model = "prop_table_tennis" },
        { pos = vector3(965.3911, 2667.3169, 38.6436), heading = 92.1550, model = "prop_table_tennis" }
    },

    -- Models that are used for games against AI.
    AIModels = {
        "mp_f_deadhooker",
        "s_f_y_hooker_01",
        "s_f_y_movprem_01",
        "s_m_y_baywatch_01",
        "s_m_y_clown_01",
        "s_m_y_mime",
        "ig_amandatownley",
        "ig_denise",
        "ig_djblamryans",
        "ig_kerrymcintosh",
        "ig_lifeinvad_01",
        "ig_money",
    },
    -- All models can be found at: https://docs.fivem.net/docs/game-references/ped-models/

    -- Framework
    ESXResourceName = "es_extended",
    QBCoreResourceName = "qb-core"
}
