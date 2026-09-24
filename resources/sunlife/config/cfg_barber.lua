-- ============================================================
-- Barber configuration (mergé depuis vms_barber dans rg_core)
-- Code essentiel uniquement : ESX + esx_skin, markers, RageUI.
-- ============================================================

BarberConfig = {}

BarberConfig.PlayerLoaded = "esx:playerLoaded"
BarberConfig.JobUpdated   = "esx:setJob"

-- Distance des markers / accès
BarberConfig.DistanceView   = 8
BarberConfig.DistanceAccess = 1.1

-- Anim du barber qui coupe les cheveux
BarberConfig.AnimDict = "misshair_shop@barbers"
BarberConfig.Anim     = "keeper_idle_b"

-- Anim du client assis sur la chaise
BarberConfig.ChairSittingAnim = { 'switch@michael@sitting', 'idle' }

-- Permettre le maquillage (féminin) dans le menu
BarberConfig.CanMakeup = true

-- Intégration vms_tattooshop pour les hair fades (les deux modules sont dans rg_core, donc on garde l'intégration en interne)
BarberConfig.UseTattoshopHairFades = true

-- Item "tondeuse" requis ? (désactivé par défaut)
BarberConfig.UseHairClipperRequired = false
BarberConfig.HairClipperItem        = 'hair_clipper'

BarberConfig.Blip = {
    Sprite  = 71,
    Scale   = 0.6,
    Color   = 3,
    Display = 4,
}

BarberConfig.Markers = {
    ['FreeSeat'] = {
        id = 21,
        size = vec(0.25, 0.25, 0.25),
        bobUpAndDown = false,
        rotate = true,
    },
    ['TakenSeat'] = {
        id = 21,
        size = vec(0.25, 0.25, 0.25),
        bobUpAndDown = false,
        rotate = true,
    },
}

BarberConfig.CustomNames = {
    ["hair_1"] = {
        [0]  = "Chauve",
        [14] = "Dreadlocks",
        [16] = "Boucles afro",
        [79] = "Boucles",
    },
}

-- Liste des barbershops (toutes les positions originales, sans le système d'entreprise)
BarberConfig.Barbers = {
    ['HS_Barber_2'] = {
        position        = vector3(-32.15, -151.21, 56.08),
        barberSpawnPos  = vector4(-36.58, -156.26, 56.08, 335.87),
        barber          = "s_f_m_fembarber",
        takeSitMarker   = { FreeColor = {0, 255, 0, 125}, TakenColor = {128, 0, 31, 110} },
        Chairs = {
            [1] = { position = vector3(-33.49, -150.64, 56.09), barberPos = vector4(-34.35, -151.05, 56.09, 70.17),  chairCoord = vector4(-34.67, -150.17, 56.44, 70.0),   taken = false },
            [2] = { position = vector3(-33.92, -152.11, 56.09), barberPos = vector4(-34.92, -152.49, 56.09, 65.57),  chairCoord = vector4(-35.18, -151.61, 56.43, 70.81),  taken = false },
            [3] = { position = vector3(-34.41, -153.43, 56.09), barberPos = vector4(-35.35, -153.95, 56.09, 62.71),  chairCoord = vector4(-35.7,  -152.98, 56.42, 64.49),  taken = false },
        },
        prices = {
            ['hair_1']        = { price = 80  },
            ['hair_2']        = { price = 20  },
            ['hair_color_1']  = { price = 120 },
            ['hair_color_2']  = { price = 100 },
            ['hair_fade']     = { price = 90  },
            ['beard_1']       = { price = 90  },
            ['beard_2']       = { price = 50  },
            ['beard_3']       = { price = 80  },
            ['eye_color']     = { price = 300 },
            ['eyebrows_1']    = { price = 70  },
            ['eyebrows_2']    = { price = 50  },
            ['eyebrows_3']    = { price = 65  },
            ['makeup_1']      = { price = 220 },
            ['makeup_2']      = { price = 70  },
            ['makeup_3']      = { price = 100 },
            ['makeup_4']      = { price = 90  },
            ['lipstick_1']    = { price = 70  },
            ['lipstick_2']    = { price = 20  },
            ['lipstick_3']    = { price = 50  },
            ['blush_1']       = { price = 55  },
            ['blush_2']       = { price = 45  },
            ['blush_3']       = { price = 50  },
        },
    },
    ['HS_Barber_3'] = {
        position        = vector3(-1282.39, -1117.32, 5.99),
        barberSpawnPos  = vector4(-1278.26, -1119.28, 5.99, 84.21),
        barber          = "s_f_m_fembarber",
        takeSitMarker   = { FreeColor = {0, 255, 0, 125}, TakenColor = {128, 0, 31, 110} },
        Chairs = {
            [1] = { position = vector3(-1284.23, -1118.27, 6.0), barberPos = vector4(-1283.68, -1118.88, 6.0, 173.31), chairCoord = vector4(-1284.29, -1119.58, 6.32, 181.58), taken = false },
            [2] = { position = vector3(-1282.81, -1118.26, 6.0), barberPos = vector4(-1282.18, -1119.05, 6.0, 168.95), chairCoord = vector4(-1282.83, -1119.58, 6.3,  181.58), taken = false },
            [3] = { position = vector3(-1281.26, -1118.21, 6.0), barberPos = vector4(-1280.64, -1118.99, 6.0, 173.96), chairCoord = vector4(-1281.32, -1119.56, 6.34, 176.48), taken = false },
        },
        prices = {
            ['hair_1'] = {price=80}, ['hair_2'] = {price=20}, ['hair_color_1'] = {price=120}, ['hair_color_2'] = {price=100},
            ['hair_fade'] = {price=90}, ['beard_1'] = {price=90}, ['beard_2'] = {price=50}, ['beard_3'] = {price=80},
            ['eye_color'] = {price=300}, ['eyebrows_1'] = {price=70}, ['eyebrows_2'] = {price=50}, ['eyebrows_3'] = {price=65},
            ['makeup_1'] = {price=220}, ['makeup_2'] = {price=70}, ['makeup_3'] = {price=100}, ['makeup_4'] = {price=90},
            ['lipstick_1'] = {price=70}, ['lipstick_2'] = {price=20}, ['lipstick_3'] = {price=50},
            ['blush_1'] = {price=55}, ['blush_2'] = {price=45}, ['blush_3'] = {price=50},
        },
    },
    ['HS_Barber_4'] = {
        position        = vector3(1213.42, -472.78, 65.21),
        barberSpawnPos  = vector4(1216.58, -476.0, 65.21, 73.17),
        barber          = "s_f_m_fembarber",
        takeSitMarker   = { FreeColor = {0, 255, 0, 125}, TakenColor = {128, 0, 31, 110} },
        Chairs = {
            [1] = { position = vector3(1210.66, -473.39, 65.22), barberPos = vector4(1211.07, -474.24, 65.22, 161.51), chairCoord = vector4(1210.33, -474.67, 65.53, 163.11), taken = false },
            [2] = { position = vector3(1212.04, -473.8,  65.22), barberPos = vector4(1212.56, -474.56, 65.22, 157.56), chairCoord = vector4(1211.72, -475.02, 65.55, 162.0),  taken = false },
            [3] = { position = vector3(1213.64, -474.13, 65.22), barberPos = vector4(1213.97, -475.06, 65.22, 162.07), chairCoord = vector4(1213.18, -475.46, 65.55, 160.01), taken = false },
        },
        prices = {
            ['hair_1'] = {price=80}, ['hair_2'] = {price=20}, ['hair_color_1'] = {price=120}, ['hair_color_2'] = {price=100},
            ['hair_fade'] = {price=90}, ['beard_1'] = {price=90}, ['beard_2'] = {price=50}, ['beard_3'] = {price=80},
            ['eye_color'] = {price=300}, ['eyebrows_1'] = {price=70}, ['eyebrows_2'] = {price=50}, ['eyebrows_3'] = {price=65},
            ['makeup_1'] = {price=220}, ['makeup_2'] = {price=70}, ['makeup_3'] = {price=100}, ['makeup_4'] = {price=90},
            ['lipstick_1'] = {price=70}, ['lipstick_2'] = {price=20}, ['lipstick_3'] = {price=50},
            ['blush_1'] = {price=55}, ['blush_2'] = {price=45}, ['blush_3'] = {price=50},
        },
    },
    ['HS_Barber_5'] = {
        position        = vector3(-277.79, 6227.79, 30.7),
        barberSpawnPos  = vector4(-276.25, 6223.28, 30.7, 44.09),
        barber          = "s_f_m_fembarber",
        takeSitMarker   = { FreeColor = {0, 255, 0, 125}, TakenColor = {128, 0, 31, 110} },
        Chairs = {
            [1] = { position = vector3(-280.02, 6228.49, 30.71), barberPos = vector4(-280.08, 6227.54, 30.71, 130.38), chairCoord = vector4(-280.99, 6227.58, 31.02, 133.88), taken = false },
            [2] = { position = vector3(-278.98, 6227.4,  30.71), barberPos = vector4(-279.01, 6226.51, 30.71, 134.92), chairCoord = vector4(-279.91, 6226.51, 31.01, 137.31), taken = false },
            [3] = { position = vector3(-277.87, 6226.38, 30.71), barberPos = vector4(-277.97, 6225.36, 30.71, 128.69), chairCoord = vector4(-278.88, 6225.48, 31.01, 131.52), taken = false },
        },
        prices = {
            ['hair_1'] = {price=80}, ['hair_2'] = {price=20}, ['hair_color_1'] = {price=120}, ['hair_color_2'] = {price=100},
            ['hair_fade'] = {price=90}, ['beard_1'] = {price=90}, ['beard_2'] = {price=50}, ['beard_3'] = {price=80},
            ['eye_color'] = {price=300}, ['eyebrows_1'] = {price=70}, ['eyebrows_2'] = {price=50}, ['eyebrows_3'] = {price=65},
            ['makeup_1'] = {price=220}, ['makeup_2'] = {price=70}, ['makeup_3'] = {price=100}, ['makeup_4'] = {price=90},
            ['lipstick_1'] = {price=70}, ['lipstick_2'] = {price=20}, ['lipstick_3'] = {price=50},
            ['blush_1'] = {price=55}, ['blush_2'] = {price=45}, ['blush_3'] = {price=50},
        },
    },
    ['HS_Barber_7'] = {
        position        = vector3(-814.58, -184.39, 36.57),
        barberSpawnPos  = vector4(-808.27, -179.79, 36.57, 124.26),
        barber          = "s_f_m_fembarber",
        takeSitMarker   = { FreeColor = {0, 255, 0, 125}, TakenColor = {128, 0, 31, 110} },
        Chairs = {
            [1] = { position = vector3(-817.68, -184.44, 36.57), barberPos = vector4(-818.15, -184.76, 36.57, 344.45), chairCoord = vector4(-818.24, -183.42, 36.8, 30.3),  taken = false },
            [2] = { position = vector3(-815.9,  -183.45, 36.57), barberPos = vector4(-816.43, -183.68, 36.57, 351.06), chairCoord = vector4(-816.56, -182.41, 36.8, 30.3),  taken = false },
            [3] = { position = vector3(-814.16, -182.53, 36.57), barberPos = vector4(-814.65, -182.68, 36.57, 355.75), chairCoord = vector4(-814.76, -181.46, 36.8, 30.3),  taken = false },
            [4] = { position = vector3(-812.44, -181.54, 36.57), barberPos = vector4(-813.22, -181.52, 36.57, 25.87),  chairCoord = vector4(-813.05, -180.45, 36.8, 30.3),  taken = false },
        },
        prices = {
            ['hair_1'] = {price=80}, ['hair_2'] = {price=20}, ['hair_color_1'] = {price=120}, ['hair_color_2'] = {price=100},
            ['hair_fade'] = {price=90}, ['beard_1'] = {price=90}, ['beard_2'] = {price=50}, ['beard_3'] = {price=80},
            ['eye_color'] = {price=300}, ['eyebrows_1'] = {price=70}, ['eyebrows_2'] = {price=50}, ['eyebrows_3'] = {price=65},
            ['makeup_1'] = {price=220}, ['makeup_2'] = {price=70}, ['makeup_3'] = {price=100}, ['makeup_4'] = {price=90},
            ['lipstick_1'] = {price=70}, ['lipstick_2'] = {price=20}, ['lipstick_3'] = {price=50},
            ['blush_1'] = {price=55}, ['blush_2'] = {price=45}, ['blush_3'] = {price=50},
        },
    },
}

-- Traductions FR uniquement (langue serveur)
local L = {
    ["blip.barber"]                        = "Coiffeur",
    ["help.take_a_sit"]                    = "Appuyez sur ~INPUT_CONTEXT~ pour vous asseoir",
    ["notify.paid"]                        = "Vous avez payé %s$ pour un service.",
    ["notify.nomoney"]                     = "Vous n'avez pas assez d'argent.",
    ["notify.dont_have_hair_clipper"]      = "Vous n'avez pas de tondeuse à cheveux.",
}

function BarberT(key, ...)
    local s = L[key] or key
    if ... then
        return s:format(...)
    end
    return s
end

-- Webhook Discord (paiements barber)
BarberConfig.DiscordWebhook = "https://discord.com/api/webhooks/1357630452172718150/QEXK53bkLLAa5swZwweygWXj8icgwJIG30A9pVTV6ccB6jfHhl_zDQxH3BANutbUKamz"
