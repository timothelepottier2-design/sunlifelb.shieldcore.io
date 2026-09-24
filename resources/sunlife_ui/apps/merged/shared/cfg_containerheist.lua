cfg_containers = {}

cfg_containers.CheckForUpdates = true

cfg_containers.StartPedLoc = vector4(-1248.867676, -1195.280640, 7.617117, 116.0)

cfg_containers.PedModel = "a_m_m_og_boss_01"

cfg_containers.StartPedAnimation = "WORLD_HUMAN_AA_SMOKE"

cfg_containers.PoliceJobtype = {
    "police",
    "sheriff",
}

cfg_containers.Cooldown = 30

cfg_containers.ContainerModels = {
    rowA = {'tr_prop_tr_container_01a','tr_prop_tr_container_01h','tr_prop_tr_container_01i'},
    rowB = {'tr_prop_tr_container_01c','tr_prop_tr_container_01f','tr_prop_tr_container_01g'}
}

cfg_containers.Sites = {
    { center = vector4(999.757568, -2923.721924, 5.900606, 0.0), colSpacing = 5.70, rowSpacing = 9.40 },
    { center = vector4(809.254822, -3036.295166, 5.742126, 90.0), colSpacing = 5.70, rowSpacing = 9.40 },
    { center = vector4(825.292175, -3218.562256, 5.899073, 90.0), colSpacing = 5.70, rowSpacing = 9.40 },
    { center = vector4(1270.457642, -3327.431641, 5.90159, 90.0), colSpacing = 5.70, rowSpacing = 9.40 },
    { center = vector4(524.020081, -2940.857178, 6.044458, 0.0), colSpacing = 5.70, rowSpacing = 9.40 },
}

cfg_containers['containers'] = {
    {
        pos = vector3(1091.08, -3188.91, 4.9),
        heading = 0.0,
        lock = {pos = vector3(1091.04, -3190.76, 6), taken = false},
        box = vector4(1091.0, -3187.94, 5.1, 355.21),
        containerModel = 'tr_prop_tr_container_01a',
        target = vector3(1091.0, -3191.08, 5.9)

    },
    {
        pos = vector3(1096.84, -3188.75, 4.9),
        heading = 0.0,
        lock = {pos = vector3(1096.87, -3190.61, 6), taken = false},
        box = vector4(1096.77, -3187.8, 5.1, 355.88),
        containerModel = 'tr_prop_tr_container_01h',
        target = vector3(1096.87, -3190.82, 5.9)
    },
    {
        pos = vector3(1101.13, -3188.95, 4.9),
        heading = 0.0,
        lock = {pos = vector3(1101.17, -3190.81, 6), taken = false},
        box = vector4(1101.2, -3188.0, 5.1, 355.36),
        containerModel = 'tr_prop_tr_container_01i',
        target = vector3(1101.17, -3191.02, 5.9)
    },
    {
        pos = vector3(1101.26, -3198.25, 4.9),
        heading = 180.0,
        lock = {pos = vector3(1101.27, -3196.39, 6), taken = false},
        box = vector4(1101.2, -3199.24, 5.1, 180.77),
        containerModel = 'tr_prop_tr_container_01c',
        target = vector3(1101.3, -3196.09, 5.9)
    },
    {
        pos = vector3(1096.83, -3197.88, 4.9),
        heading = 180.0,
        lock = {pos = vector3(1096.83, -3196.03, 6), taken = false},
        box = vector4(1096.81, -3198.84, 5.1, 180.77),
        containerModel = 'tr_prop_tr_container_01f',
        target = vector3(1096.77, -3195.75, 5.9)
    },
    {
        pos = vector3(1091.1, -3198.18, 4.9),
        heading = 180.0,
        lock = {pos = vector3(1091.08, -3196.33, 6), taken = false},
        box = vector4(1091.01, -3199.12, 5.1, 180.77),
        containerModel = 'tr_prop_tr_container_01g',
        target = vector3(1091.03, -3195.99, 5.9)
    },
}

cfg_containers.Items = {
    {amount = 1, name = "WEAPON_BULLET2"},
    {amount = 1, name = "WEAPON_PISTOL"},
    {amount = 1, name = "WEAPON_PISTOL50"},
    {amount = 20, name = "clippistol"},
    {amount = 1, name = "radio"},
    {amount = 20, name = "clipfusil"},
    {amount = 20, name = "clipfusil"},

    {amount = 1, name = "WEAPON_BAT"},
    {amount = 1, name = "WEAPON_BOTTLE"},
    {amount = 1, name = "WEAPON_KNUCKLE"},
    {amount = 1, name = "WEAPON_KNIFE"},
    {amount = 1, name = "WEAPON_MACHETE"},
    {amount = 1, name = "WEAPON_WRENCH"},
    {amount = 1, name = "WEAPON_POOLCUE"},
    {amount = 1, name = "WEAPON_DAGGER"},
    {amount = 1, name = "WEAPON_CROWBAR"},
    {amount = 1, name = "WEAPON_GOLFCLUB"},
    {amount = 1, name = "WEAPON_HATCHET"},
    {amount = 1, name = "WEAPON_SWITCHBLADE"},
    {amount = 1, name = "WEAPON_BATTLEAXE"},
    {amount = 1, name = "WEAPON_HAMMER"},
    {amount = 1, name = "WEAPON_FLASHLIGHT"},

    {amount = 1, name = "pilule"},
    {amount = 1, name = "pince"},
    {amount = 1, name = "lockpick"},
    {amount = 1, name = "sacp"},
    {amount = 1, name = "flashlight"},
    {amount = 1, name = "grip"},
    {amount = 1, name = "jumelles"},
    {amount = 1, name = "silencieux"},
    {amount = 1, name = "hackingunit"},
    {amount = 1, name = "blowtorch"},

    {amount = 1, name = "digital"},
    {amount = 1, name = "skull"},
    {amount = 1, name = "perseus"},
    {amount = 1, name = "patriotic"},
    {amount = 1, name = "sessanta"},
    {amount = 1, name = "leopard"},

    {amount = 20, name = "clippistol"},
    {amount = 20, name = "cliprevolver"},
    {amount = 20, name = "clipsmg"},
    {amount = 20, name = "clippompe"},
    {amount = 20, name = "clipfusil"},
}

cfg_containers.GuardOffsets = {
    { pos = vector3(4.0, -5.5, 0.0), h = 0.0 },
    { pos = vector3(-4.8, 4.2, 0.0), h = 180.0 },
}

ContainerAnimation = {
    ['objects'] = {
        'tr_prop_tr_grinder_01a',
        'ch_p_m_bag_var02_arm_s'
    },
    ['animations'] = {
        {'action', 'action_container', 'action_lock', 'action_angle_grinder', 'action_bag'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}
