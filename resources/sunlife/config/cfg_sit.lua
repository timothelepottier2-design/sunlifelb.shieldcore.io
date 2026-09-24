ConfigSit = {}

ConfigSit.Debugmode = false
ConfigSit.DebugPoly = false

ConfigSit.UseNativeNotifiactions = true

ConfigSit.TeleportToLastPosWhenNoRoute = false

ConfigSit.AlwaysTeleportToSeat = false
ConfigSit.AlwaysTeleportOutOfSeat = false

ConfigSit.MaxInteractionDist = 1.8
ConfigSit.MaxDetectionDist = 3.0

ConfigSit.MaxTilt = 20.0

ConfigSit.DefaultKey = 'X'
ConfigSit.DefaultPadAnalogButton = 'RRIGHT_INDEX'

ConfigSit.AddChatSuggestions = false

ConfigSit.ReduceStress = false

ConfigSit.Target = false

ConfigSit.UseTargetingCoords = true

ConfigSit.Targeting = {
    SitIcon = "fas fa-chair",
    LayIcon = "fas fa-bed",
    SitLabel = "S'assoir",
    LayLabel = "Se coucher",
}

ConfigSit.Lang = {

    Occupied = "~r~Cette place est déja occupée !",
    OccupiedLay = "~r~Vous ne pouvez pas vous coucher ici !",
	NoAvailable = "~r~Aucune chaise autour !",
	NoFound = "~r~Aucune place autour !",
    NoBedFound = "~r~Aucun lit autour !",
    TooTilted = "~r~Cette place est trop inclinée !",
    CannotReachSeat = "~r~Vous ne pouvez pas atteindre cette chaise !",
    CannotReachBed = "~r~Vous ne pouvez pas atteindre ce lit !",

    ChatHelpTextSit = "S'assoir sur le siège le plus proche",
    ChatHelpTextLay = "Se coucher sur le siège le plus proche",

	KeyMappingKeyboard = "Se lever d'une chaise/lit",
	KeyMappingController = "Se lever d'une chaise/lit - Touche",

    GetUp = "Appuyez sur %s pour vous lever",
}

ConfigSit.SitTypes = {
    ['default'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        skipGoStraightTask = false,
        teleportIn = false,
        teleportOut = false,
        timeout = 8
    },
    ['chair'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        timeout = 8
    },
    ['chair2'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "PROP_HUMAN_SEAT_ARMCHAIR" },
        timeout = 8
    },
    ['chair3'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "PROP_HUMAN_SEAT_ARMCHAIR", "PROP_HUMAN_SEAT_DECKCHAIR" },
        timeout = 8
    },
    ['barstool'] = {
        scenarios = { "PROP_HUMAN_SEAT_BAR" },
        teleportIn = true,
        timeout = 8
    },
    ['stool'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        teleportIn = true,
        timeout = 8
    },
    ['deck'] = {
        scenarios = { "PROP_HUMAN_SEAT_DECKCHAIR" },
        timeout = 8
    },
    ['sunlounger'] = {
        scenarios = { "PROP_HUMAN_SEAT_SUNLOUNGER" },
        skipGoStraightTask = true,
        timeout = 12
    },
    ['tattoo'] = {
        animation = { dict = "misstattoo_parlour@shop_ig_4", name = "customer_loop", offset = vector4(0.0, 0.0, -0.75, 0.0) },
        timeout = 8
    },
    ['strip_watch'] = {
        scenarios = { "PROP_HUMAN_SEAT_STRIP_WATCH" },
        timeout = 8
    },
    ['diner_booth'] = {
        scenarios = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
        teleportIn = true,
        teleportOut = true,
        timeout = 8,
    },
    ['wall'] = {
        scenarios = { "WORLD_HUMAN_SEAT_WALL" },
        timeout = 8
    },
    ['steps'] = {
        scenarios = { "WORLD_HUMAN_SEAT_STEPS" },
        timeout = 8
    },
    ['ledge'] = {
        scenarios = { "WORLD_HUMAN_SEAT_LEDGE" },
        timeout = 8
    },
}

ConfigSit.LayTypes = {
    ['default'] = {
        animation = { dict = "misslamar1dead_body", name = "dead_idle" },
        exitAnim = true
    },
    ['bed'] = {
        animation = { dict = "misslamar1dead_body", name = "dead_idle" }
    },
    ['lay'] = {
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(-0.1, 0.1, -0.5, 270.0) }
    },
    ['layside'] = {
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(-0.1, 0.1, -0.5, 270.0) }
    },
    ['busstop'] = {
        animation = { dict = "savecouch@", name = "t_sleep_loop_couch", offset = vector4(0.0, 0.0, -0.5, 270.0) }
    },
    ['medical'] = {
        animation = { dict = "anim@gangops@morgue@table@", name = "body_search" }
    },
    ['tattoo'] = {
        animation = { dict = "amb@world_human_sunbathe@male@front@base", name = "base", offset = vector4(0.0, 0.0, 0.0, 180.0) },
        exitAnim = false
    }
}
