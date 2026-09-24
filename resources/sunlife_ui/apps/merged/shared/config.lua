GymConfig = {}

GymConfig.InteractKey = 38
GymConfig.SessionMs = 20000
GymConfig.CooldownMs = 2500

GymConfig.Gain = {
    strength = 1,
    speed = 1,
    stamina = 1
}

GymConfig.Max = {
    strength = 100,
    speed = 100,
    stamina = 100
}

GymConfig.Buffs = {
    meleeDamage = { base = 1.0, max = 1.8 },
    runMultiplier = { base = 1.0, max = 1.18 },
    staminaTick = { base = 0.0, max = 1.0 }
}

GymConfig.Spots = {
    { label = 'Vespucci Gym – Curls', pos = vector3(-1204.867188, -1559.791016, 4.614794), radius = 1.6, type = 'curls' },
    { label = 'Vespucci Gym – Curls', pos = vector3(-1207.473511, -1562.843872, 4.607851), radius = 1.6, type = 'curls' },
    { label = 'Vespucci Gym – Sit-ups', pos = vector3(-1204.539307, -1568.214844, 4.607850), radius = 1.6, type = 'situps' },
    { label = 'Vespucci Gym – Sit-ups', pos = vector3(-1200.738892, -1572.857056, 4.608664), radius = 1.6, type = 'situps' },
    { label = 'Vespucci Gym – Sit-ups', pos = vector3(-1200.257446, -1577.249512, 4.608754), radius = 1.6, type = 'situps' },
    { label = 'Vespucci Gym – Push-ups', pos = vector3(-1197.508301, -1571.667358, 4.613149), radius = 1.6, type = 'pushups' },
    { label = 'Vespucci Gym – Push-ups', pos = vector3(-1199.383179, -1566.821411, 4.615706), radius = 1.6, type = 'pushups' },
    { label = 'Vespucci Gym – Push-ups', pos = vector3(-1199.733765, -1563.775391, 4.618868), radius = 1.6, type = 'pushups' }
}

GymConfig.Marker = {
    type = 1,
    scale = vec3(0.6, 0.6, 0.35),
    color = { r = 255, g = 106, b = 0, a = 100 }
}

GymConfig.VoiceSettings = {
    pma = {
        [1] = { meter = 3.0 },
        [2] = { meter = 10.0 },
        [3] = { meter = 20.0 }
    },
    saltychat = {
        use = false,
        ranges = {
            ["1"] = { meter = 3.0 },
            ["2"] = { meter = 10.0 },
            ["3"] = { meter = 20.0 }
        }
    }
}
