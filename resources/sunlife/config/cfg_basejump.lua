cfg_basejump = {}

cfg_basejump.PayAccount = "money"
cfg_basejump.UseOxTarget = true

cfg_basejump.JumpPoints = {
    {
        id = "mount_chiliad",
        label = "Saut Parachute - Mont Chiliad",
        price = 1500,
        enter = vec3(451.86, 5572.62, 781.18),
        enterHeading = 90.0,
        spawn = vec3(450.60, 5580.20, 1100.00),
        spawnHeading = 90.0,
        blip = { sprite = 94, scale = 0.85, color = 2 },
        npc = {
            model = "s_m_y_pilot_01",
            coords = vec3(451.86, 5572.62, 781.18),
            heading = 90.0,
            scenario = "WORLD_HUMAN_CLIPBOARD"
        }
    },
    {
        id = "maze_bank",
        label = "Saut Parachute - Maze Bank",
        price = 2500,
        enter = vec3(-75.20, -818.90, 326.17),
        enterHeading = 0.0,
        spawn = vec3(-75.20, -818.90, 900.00),
        spawnHeading = 0.0,
        blip = { sprite = 94, scale = 0.85, color = 27 },
        npc = {
            model = "s_m_y_airworker",
            coords = vec3(-75.20, -818.90, 326.17),
            heading = 0.0,
            scenario = "WORLD_HUMAN_STAND_IMPATIENT"
        }
    }
}
