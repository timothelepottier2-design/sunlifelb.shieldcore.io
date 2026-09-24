TattooConfig = TattooConfig or {}

TattooConfig.PlayerLoaded = "esx:playerLoaded"
TattooConfig.PlayerLogout = "esx:onPlayerLogout"
TattooConfig.JobUpdated   = "esx:setJob"

TattooConfig.AutoExecuteQuery = true

TattooConfig.HairFadesCollection = 'multiplayer_overlays'

TattooConfig.ForceRemoteTattooSync = true

TattooConfig.DistanceView   = 8
TattooConfig.DistanceAccess = 1.1

TattooConfig.LiesAnims = {
    frontAnimDict = "amb@world_human_sunbathe@male@front@base",
    frontAnim     = "base",
    backAnimDict  = "switch@trevor@annoys_sunbathers",
    backAnim      = "trev_annoys_sunbathers_loop_girl",
}

TattooConfig.StartingCam = { vec(0.0, -0.2, 0.4), vec(0.0, -0.205, -0.6) }

TattooConfig.EnableTattooingAudioEffect = true

TattooConfig.Blip = {
    Sprite  = 75,
    Scale   = 0.75,
    Color   = 1,
    Display = 4,
}

TattooConfig.Markers = {
    ['FreeSeat']  = { id = 21, size = vec(0.25, 0.25, 0.25), bobUpAndDown = false, rotate = true },
    ['TakenSeat'] = { id = 21, size = vec(0.25, 0.25, 0.25), bobUpAndDown = false, rotate = true },
}

TattooConfig.SeatObject = 'v_36_tatseat2'
TattooConfig.SeatSpawnsList = {
    { coords = vector4(1864.51, 3747.72, 32.03, 249.59) },
    { coords = vector4(-294.39, 6199.81, 30.49, 50.5)   },
}

TattooConfig.Tattooshops = {
    ['Tattooshop_1'] = {
        pedModel              = "u_m_y_tattoo_01",
        pedHeadingToChair     = 197.46,
        pedHeadingToChairBack = 22.31,
        position              = vector3(1323.27, -1652.07, 51.28),
        tattooPedSpawnPos     = vector4(1327.66, -1654.03, 51.28, 42.35),
        takeSitMarker         = { FreeColor = {235, 235, 235, 125}, TakenColor = {128, 0, 31, 110} },
        categories = {
            ['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,
            ['8']=true,['9']=true,['10']=true,['11']=true,['12']=true,['13']=true,
            ['14']=true,['15']=true,['16']=true,['17']=true,['18']=true,['19']=true,
            ['20']=true,['21']=true,
        },
        Chairs = {
            [1] = {
                position     = vector3(1320.64, -1653.94, 51.28),
                tattooerPos  = vector4(1321.84, -1654.83, 51.28, 143.44),
                chairCoord   = vector4(1321.13, -1655.12, 51.9,  22.31),
                taken        = false,
            },
        },
    },
    ['Tattooshop_2'] = {
        pedModel              = "u_m_y_tattoo_01",
        pedHeadingToChair     = 328.24,
        pedHeadingToChairBack = 142.55,
        position              = vector3(321.61, 182.82, 102.59),
        tattooPedSpawnPos     = vector4(321.22, 184.9,  102.59, 166.42),
        takeSitMarker         = { FreeColor = {235, 235, 235, 125}, TakenColor = {128, 0, 31, 110} },
        categories = {
            ['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,
            ['8']=true,['9']=true,['10']=true,['11']=true,['12']=true,['13']=true,
            ['14']=true,['15']=true,['16']=true,['17']=true,['18']=true,['19']=true,
            ['20']=true,['21']=true,
        },
        Chairs = {
            [1] = {
                position     = vector3(324.74, 179.39, 102.59),
                tattooerPos  = vector4(324.97, 179.58, 102.59, 320.43),
                chairCoord   = vector4(325.83, 180.63, 103.21, 142.55),
                taken        = false,
            },
        },
    },
    ['Tattooshop_3'] = {
        pedModel              = "u_m_y_tattoo_01",
        pedHeadingToChair     = 47.38,
        pedHeadingToChairBack = 227.38,
        position              = vector3(-3169.77, 1076.14, 19.83),
        tattooPedSpawnPos     = vector4(-3174.33, 1074.58, 19.83, 251.8),
        takeSitMarker         = { FreeColor = {235, 235, 235, 125}, TakenColor = {128, 0, 31, 110} },
        categories = {
            ['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,
            ['8']=true,['9']=true,['10']=true,['11']=true,['12']=true,['13']=true,
            ['14']=true,['15']=true,['16']=true,['17']=true,['18']=true,['19']=true,
            ['20']=true,['21']=true,
        },
        Chairs = {
            [1] = {
                position     = vector3(-3168.68, 1077.88, 19.83),
                tattooerPos  = vector4(-3168.82, 1078.09, 19.83, 52.15),
                chairCoord   = vector4(-3169.75, 1078.94, 20.46, 227.38),
                taken        = false,
            },
        },
    },
    ['Tattooshop_4'] = {
        pedModel              = "u_m_y_tattoo_01",
        pedHeadingToChair     = 192.95,
        pedHeadingToChairBack = 16.03,
        position              = vector3(-1154.23, -1426.1, 3.95),
        tattooPedSpawnPos     = vector4(-1149.71, -1427.26, 3.95, 39.5),
        takeSitMarker         = { FreeColor = {235, 235, 235, 125}, TakenColor = {128, 0, 31, 110} },
        categories = {
            ['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,
            ['8']=true,['9']=true,['10']=true,['11']=true,['12']=true,['13']=true,
            ['14']=true,['15']=true,['16']=true,['17']=true,['18']=true,['19']=true,
            ['20']=true,['21']=true,
        },
        Chairs = {
            [1] = {
                position     = vector3(-1156.21, -1427.18, 3.95),
                tattooerPos  = vector4(-1156.22, -1427.28, 3.95, 187.62),
                chairCoord   = vector4(-1155.87, -1428.75, 4.58, 16.03),
                taken        = false,
            },
        },
    },
    ['Tattooshop_6'] = {
        pedModel              = "u_m_y_tattoo_01",
        pedHeadingToChair     = 29.33,
        pedHeadingToChairBack = 211.91,
        position              = vector3(-293.76, 6198.75, 30.49),
        tattooPedSpawnPos     = vector4(-294.52, 6197.87, 30.49, 317.01),
        takeSitMarker         = { FreeColor = {235, 235, 235, 125}, TakenColor = {128, 0, 31, 110} },
        categories = {
            ['1']=true,['2']=true,['3']=true,['4']=true,['5']=true,['6']=true,['7']=true,
            ['8']=true,['9']=true,['10']=true,['11']=true,['12']=true,['13']=true,
            ['14']=true,['15']=true,['16']=true,['17']=true,['18']=true,['19']=true,
            ['20']=true,['21']=true,
        },
        Chairs = {
            [1] = {
                position     = vector3(-293.76, 6198.75, 30.49),
                tattooerPos  = vector4(-293.8,  6198.72, 30.49, 30.68),
                chairCoord   = vector4(-294.57, 6199.93, 31.1,  211.91),
                taken        = false,
            },
        },
    },
}

TattooConfig.ClothesOff = {
    ["male"] = {
        sex      = 0,
        arms     = 15, arms_2   = 0,
        helmet_1 = -1, helmet_2 = 0,
        bproof_1 = 0,  bproof_2 = 0,
        tshirt_1 = 15, tshirt_2 = 0,
        torso_1  = 91, torso_2  = 0,
        pants_1  = 14, pants_2  = 0,
        shoes_1  = 34, shoes_2  = 0,
    },
    ["female"] = {
        sex      = 1,
        arms     = 15,  arms_2   = 0,
        helmet_1 = -1,  helmet_2 = 0,
        bproof_1 = 0,   bproof_2 = 0,
        tshirt_1 = 34,  tshirt_2 = 0,
        torso_1  = 101, torso_2  = 1,
        pants_1  = 16,  pants_2  = 0,
        shoes_1  = 0,   shoes_2  = 0,
    },
}

local L = {
    ["blip.tattoo"]                  = "Tatoueur",
    ["help.take_a_sit"]              = "Appuyez sur ~INPUT_CONTEXT~ pour vous asseoir",
    ["notify.paid"]                  = "Vous avez payé %s$ pour un service.",
    ["notify.nomoney"]               = "Vous n'avez pas assez d'argent.",
    ["notify.removing_tattooing"]    = "Tatouage en cours de retrait...",
}

function TattooT(key, ...)
    local s = L[key] or key
    if ... then
        return s:format(...)
    end
    return s
end

TattooConfig.DiscordWebhook = "https://discord.com/api/webhooks/1357630486972858471/HsmLwZZ6-uloQoJfBCwMCH2gomRYv0H7wSK2rtO0pO4HUiQ63RLFZSOSsI5EyZR-Cu7V"
