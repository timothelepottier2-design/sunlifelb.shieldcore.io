KothConfig = {

    zones = {
        { key = "port",           name = "Port Los Santos", pos = vector3(198.338364, -2960.328369, 6.082098),  radius = 130.0 },
        { key = "federal_center", name = "Centre fédéral",  pos = vector3(2537.3740234375, -385.43792724609, 92.992782592773), radius = 130.0 },
        { key = "camp_secte",     name = "Camp de la secte", pos = vector3(58.008678436279, 3707.4348144531, 39.755004882812),  radius = 130.0 },
        { key = "port_bateau",    name = "Bateau du port", pos = vector3(1203.338135, -2995.148193, 5.902143),  radius = 130.0 },
        { key = "militaire",      name = "Zone militaire", pos = vector3(-2369.637207, 3318.449707, 32.827106),  radius = 130.0 },
        { key = "sandy",          name = "Sandy Shores", pos = vector3(1796.299561, 3784.284180, 33.725925),  radius = 130.0 },
    },

    schedule = {
        { hour = 0,  minute = 0 },
        { hour = 1,  minute = 0 },
        { hour = 2,  minute = 0 },
        { hour = 17, minute = 0 },
        { hour = 19, minute = 0 },
        { hour = 21, minute = 0 },
        { hour = 23, minute = 0 },
    },

    window_minutes    = 30,
    countdown_seconds = 120,
    min_gangs         = 2,
    presence_timeout  = 7,

    hb_interval_ms           = 2000,
    hud_refresh_active_s     = 2,
    hud_refresh_countdown_s  = 5,

    outzone_lockout_margin = 250.0,

    rewards = { xp = 250, money = 75000 },
    points_per_win = 1,

}
