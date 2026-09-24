cfg_gofast_mer = {
    npc = {
        pos = vector3(-264.944763, 6642.209961, 7.492140),
        heading = 139.66946411133,
        model = "s_m_y_dockwork_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
    },

    boat = {
        model = "toro",
        plate = "GOFASTM",
        pos = vector3(-293.375427, 6658.568359, -0.178091),
        heading = 131.89100646973,
    },

    startRadius   = 15.0,
    deliverRadius = 20.0,

    cooldownMs = 5 * 60 * 1000,

    missionTimeoutMs = 30 * 60 * 1000,

    missions = {
        {
            id = 1,
            label = "Sandy Shores",
            pos = vector3(1512.273071, 3812.747314, 29.506248),
            heading = 315.01077270508,
            rewardMin = 66000,
            rewardMax = 67500,
            minTravelMs = 67000,
        },
        {
            id = 2,
            label = "Grapeseed",
            pos = vector3(2261.338135, 4634.062988, 29.276844),
            heading = 314.80349731445,
            rewardMin = 69750,
            rewardMax = 71250,
            minTravelMs = 65000,
        },
        {
            id = 3,
            label = "Usine",
            pos = vector3(2810.704834, 1248.910767, -0.166048),
            heading = 112.42144775391,
            rewardMin = 81000,
            rewardMax = 82500,
            minTravelMs = 125000,
        },
        {
            id = 4,
            label = "Los Santos",
            pos = vector3(569.838196, -3162.578613, -0.182525),
            heading = 328.01495361328,
            rewardMin = 107250,
            rewardMax = 108750,
            minTravelMs = 197000,
        },
        {
            id = 5,
            label = "Cayo Perico",
            pos = vector3(4942.426758, -5159.811523, -0.475150),
            heading = 259.0272827148,
            rewardMin = 144750,
            rewardMax = 150000,
            minTravelMs = 259000,
        },
    },
}
