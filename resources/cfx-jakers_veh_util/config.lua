Config = {}

Config.Framework = 'esx'  -- Options: 'standalone', 'qbcore', 'esx', 'auto'
Config.NotificationSystem = 'esx'  -- Options: 'ox_lib', 'qbcore', 'esx', 'native', 'auto'
Config.TargetSystem = 'ox_target'  -- Options: 'ox_target', 'qb_target', 'auto'

Config.Commands = {
    enabled = true,
    lower = 'ramps_lower',
    raise = 'ramps_raise',
    attach = 'ramps_attach',
    detach = 'ramps_detach',
    rope_attach = 'rope_attach',
    rope_detach = 'rope_detach',
}

Config.RampSModels = {
    [GetHashKey("vrunnerrc")] = {
        Jobs = 'fourriere',

        Vehicle = {
            ydr = 'vrunnerrc_ramps',
            basepos = { pos = { 0.0, 0.0, 0.0 }, rot = { 90.0, 0.0, 360.0 } },
            rollbackpos = { pos = { 0.0, -3.5, 0.0 }, rot = { 90.0, 0.0, 360.0 } },
            downpos = { pos = { 0.0, -3.7, 0.0 }, rot = { 100.0, 0.0, 360.0 } },
            attachpos = { pos = { 0.0, -2.5, 0.65 }, rot = { 0.0, 0.0, 0.0 } },
        },

        Animation = {
            dict = "amb@world_human_stand_mobile@male@text@base",
            anim = "base",
            prop_model = "prop_phone_ing",
            prop_bone = 28422,
            prop_placement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
            duration = 2000,
        },

        Rope = {
            ropeattachpos = { 0.0, 0.0, 0.47 },
            MaxRopeLength = 40.0,
            MinimumRopeLength = 0.0,
            winchcontrol = 172,
        },

        VehicleWhitelist = {
            ["sultan"] = { pos = { 0.0, -2.5, 0.65 }, rot = { 0.0, 0.0, 0.0 }, MinimumRopeLength = 0.0 },
            ["blista"] = { pos = { 0.0, -2.5, 1.15 }, rot = { 0.0, 0.0, 0.0 }, MinimumRopeLength = 0.0 },
        }
    },
}

Config.Locales = {
    lower = 'Abaisser la plateforme',
    raise = 'Lever la plateforme',
    attach_vehicle = 'Attacher le véhicule',
    detach_vehicle = 'Détacher le véhicule',
    rope_attach = 'Attacher la corde de remorquage',
    rope_detach = 'Détacher la corde de remorquage',
    no_veh = 'Aucun véhicule trouvé à proximité',
    no_target_veh = 'Aucun véhicule à proximité pour attacher la corde',
    rope_in_use = 'Détachez d’abord la corde de remorquage',
    vehicle_attached = 'Véhicule attaché',
    vehicle_detached = 'Véhicule détaché',
    bed_lowered = 'Rampes abaissées',
    bed_raised = 'Rampes levées',
    bed_moving = 'Rampes en mouvement',
    ramps_title = 'Remorquage',
    winch_on = 'Treuil activé',
    winch_off = 'Treuil désactivé',
    rope_attached = 'Corde attachée',
    rope_detached = 'Corde détachée',
}