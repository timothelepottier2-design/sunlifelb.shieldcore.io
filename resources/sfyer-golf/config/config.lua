Config = {}

--== Core
Config.Locale = "fr_FR" -- (available: fr_FR, en_US) Locale of the script, you can add more locales in the "./locales" folder (don't forger to start your new locale in fxmanifest if you created it)
Config.DebugMode = false -- Not very useful, activate some debug functions/commands/prints

Config.Props = { -- You can change the props if you want but I recommend to not modify this
    flag = "prop_golfflag",
    ball = "prop_golf_ball"
}

--== UI
Config.displayBigMessageDuration = 300 -- Time of display of message like "It's your turn"
Config.FlyByActivated = true -- Activate the camera fly by

-- OxTARGET Parameters
Config.activateOxTarget = false -- If you have OX Target and you want to get rid of the default markers, set this to true
Config.OxTargetConfig = {
    mainMarker = { -- Activate the target for the main golf maker that opens the menu 
        activated = true,
        boxZone = {
            coords = vector3(-1346.26, 58.33, 55.75),
            size = vector3(0.5, 4.0, 3.25),
            rotation = 4.0,
            debug = Config.DebugMode,
            options = {
                {
                    name = 'scriptifyer-golf:oxtarget:mainMarker',
                    event = 'scriptifyer-golf:client:openMenu',
                    icon = 'fa-solid fa-golf-club',
                    label = parseText('main_menu_desc')
                }
                
            },
        }
    },
    flyByMode = { -- Activate the target for the flyBy mode (start of holes). I don't recommand to activate it because it's just a point in void...
        activated = false,
        size = vector3(0.5,0.5,0.5),
        rotation = 0.0,
        debug = Config.DebugMode,
        options = {
            {
                name = 'scriptifyer-golf:oxtarget:flyByMode',
                icon = 'fa-solid fa-golf-club',
                label = parseText('enter_player_mode_target')
            }
            
        }
    },
    playingMode = { -- Activate the target on the ball for entering the playing mode
        activated = true,
        size = vector3(0.5,0.5,0.5),
        rotation = 0.0,
        debug = Config.DebugMode,
        options = {
            {
                name = 'scriptifyer-golf:oxtarget:enterPlayingMode',
                icon = 'fa-solid fa-golf-club',
                label = parseText('enter_player_mode_target')
            }
            
        }
    },
}

-- Parameters for markers, Please refer to FiveM's Docs if you want to modify this parameter.
Config.MarkersParam = { 
    mainMarker = {
        type = 1,
        dir = vector3(0.0,0.0,0.0),
        rot = vector3(0.0,0.0,0.0),
        scale = vector3(1.0,1.0,1.0),
        red = 252,
        green = 169,
        blue = 3,
        alpha = 175,
        upAndDown = false,
        faceCamera = true,
        rotate = false,
        textureDict = nil,
        textureName = nil
    },
    holeMarker = {
        type = 20,
        dir = vector3(0.0,0.0,0.0),
        rot = vector3(0.0,0.0,0.0),
        scale = vector3(1.0,1.0,1.0),
        red = 252,
        green = 169,
        blue = 3,
        alpha = 175,
        upAndDown = true,
        faceCamera = true,
        rotate = false,
        textureDict = nil,
        textureName = nil
    },
    playingMode = {
        type = 1,
        dir = vector3(0.0,0.0,0.0),
        rot = vector3(0.0,0.0,0.0),
        scale = vector3(1.0,1.0,1.0),
        red = 252,
        green = 169,
        blue = 3,
        alpha = 175,
        upAndDown = false,
        faceCamera = true,
        rotate = false,
        textureDict = nil,
        textureName = nil
    }
}

Config.Blips = {
    mainBlip = {
        sprite = 109,
        scale = 0.7,
        colour = 2,
        shortRange = true
    },
    startPosBlip = {
        sprite = 119,
        scale = 0.7,
        colour = 0,
        shortRange = false
    },
    holeBlip = {
        sprite = 109,
        scale = 0.7,
        colour = 0,
        shortRange = false
    },
    sightBlip = {
        sprite = 57,
        scale = 0.4,
        colour = 0,
        shortRange = false
    },
    ballBlip = {
        sprite = 364,
        scale = 0.7,
        colour = 0,
        shortRange = false
    }
}

Config.IsEntityStoppedCeil = 0.35 -- Threshold below which the ball is considered stopped
Config.HitLeavesReplaceBall = true -- If set to true, the ball will return to previous position if it hitted leaves
Config.Wind = { -- To unactivate wind effect on ball, please set activated to false. I do not recommend to change any parameters here.
    activated = true,
    speed = {
        min = 0.0,
        max = 4.0
    },
    direction = {
        min = -1.0,
        max = 1.0
    },
    UpdateTimeWind = 20000
}
Config.TurnIncrements = {0.5, 1.0, 5.0, 10.0} -- Default one is the second (Config.TurnIncrements[2])

--== Key Mapping
-- Please refer to https://docs.fivem.net/docs/game-references/controls/
Config.Keys = {
    ['openMenu'] = {
        key = 51,
        text = "~INPUT_CONTEXT~"
    },
    ['playingMode'] = {
        key = 51,
        text = "~INPUT_CONTEXT~"
    },
    ['switchClub'] = {
        key = 44,
        text = "~INPUT_COVER~"
    },
    ['rotateLeft'] = {
        key = 34,
        text = "~INPUT_MOVE_LEFT_ONLY~"
    },
    ['rotateRight'] = {
        key = 35,
        text = "~INPUT_MOVE_RIGHT_ONLY~"
    },
    ['changeIncrement'] = {
        key = 70,
        text = "~INPUT_VEH_ATTACK2~"
    },
    ['terrainGrid'] = {
        key = 47,
        text = "~INPUT_DETONATE~"
    },
    ['scoreboard'] = {
        key = 104,
        text = "~INPUT_VEH_SHUFFLE~"
    },
    ['swing'] = {
        key = 24,
        text = "~INPUT_ATTACK~"
    },
    ['scoreboard_ig'] = {
        key = 104,
        text = "~INPUT_VEH_SHUFFLE~"
    },
}

Config.GolfCourse = {
    {
        par = 36,
        markerStart = vector3(-1345.36, 59.48, 54.25),
        holes = {
            { --1
                startPos = vector3(-1369.56, 168.01, 57.01),
                holePos = vector3(-1114.121, 220.7893, 63.81548),
                startBallHeading = 180.0,
                minimapPos = {angle = 90, zoomMult = 920, x = -1240.0, y = 300.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 5.0
                },
                startRotation = 0.0,
                par = 5,
                maxShot = 15,
            },
            { --2
                startPos = vector3(-1107.19, 157.07, 62.04),
                holePos = vector3(-1322.074, 158.7739, 56.7253),
                startBallHeading = -10.0,
                minimapPos = {angle = 90, zoomMult = 850, x = -1220.0, y = 240.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 5.0
                },
                startRotation = 0.0,
                par = 4,
                maxShot = 12,
            },
            { --3
                startPos = vector3(-1311.36, 128.12, 56.61),
                holePos = vector3(-1237.419, 112.987, 56.12542),
                startBallHeading = 141.0,
                minimapPos = {angle = 90, zoomMult = 0.1, x = -1274.5, y = 170.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 0.0
                },
                startRotation = 0.0,
                par = 3,
                maxShot = 9,
            },
            {--4
                startPos = vector3(-1217.39, 107.21, 57.04),
                holePos = vector3(-1096.54, 7.846734, 49.67375),
                startBallHeading = 135.0,
                minimapPos = {angle = 90, zoomMult = 700, x = -1150.0, y = 130.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 5.0
                },
                startRotation = 0.0,
                par = 4,
                maxShot = 12,
            },
            { -- 5
                startPos = vector3(-1095.99, 66.78, 52.78),
                holePos = vector3(-957.3865, -90.41283, 39.19963),
                startBallHeading = 120.0,
                minimapPos = {angle = 225, zoomMult = 900, x = -1095.0, y = -95.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 5.0
                },
                startRotation = 0.0,
                par = 4,
                maxShot = 12,
            },
            { -- 6
                startPos = vector3(-988.4, -105.43, 39.59),
                holePos = vector3(-1103.516, -115.1638, 40.47799),
                startBallHeading = 0.0,
                minimapPos = {angle = 90, zoomMult = 0.4, x = -1051.0, y = -55.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 2.5
                },
                startRotation = 0.0,
                par = 3,
                maxShot = 9,
            },
            { -- 7
                startPos = vector3(-1116.83, -104.05, 40.84),
                holePos = vector3(-1290.632, 2.752214, 49.25432),
                startBallHeading = -59.0,
                minimapPos = {angle = 60, zoomMult = 850, x = -1164.0, y = 40.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 2.0
                },
                startRotation = 0.0,
                par = 4,
                maxShot = 12,
            },
            { -- 8
                startPos = vector3(-1271.76, 37.63, 48.52),
                holePos = vector3(-1034.944, -83.14492, 42.96306),
                startBallHeading = 143.0,
                minimapPos = {angle = 60, zoomMult = 900, x = -1100.0, y = 70.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 0.0
                },
                startRotation = 0.0,
                par = 5,
                maxShot = 15,
            },
            { -- 9
                startPos = vector3(-1138.56, -0.09, 47.98),
                holePos = vector3(-1294.775, 83.50845, 53.84124),
                startBallHeading = -46.0,
                minimapPos = {angle = 45, zoomMult = 800, x = -1135.0, y = 115.0},
                flyByParams = {
                    x_retract = 0.0,
                    y_retract = 0.0,
                    z_retract = 2.0
                },
                startRotation = 0.0,
                par = 4,
                maxShot = 12,
            }
        }
    }
}

Config.ClubList = {
    { -- Putter
        model = "prop_golf_putter_01",
        power = 5.0,
        anim = {
            ["idle"] = {animDict = "mini@golf", anim = "putt_idle_c"},
            ["swing_i"] = {animDict = "mini@golf", anim = "putt_intro_high"},
            ["swing_min"] = {animDict = "mini@golf", anim = "putt_action_low"},
            ["swing_max"] = {animDict = "mini@golf", anim = "putt_action_high"},
        },
        PositionOffset = vector3(0.15,-0.60,1.0),
        RadiusOffset = 0.55,
        label = parseText('club_label_1')
    },
    {-- Pitcher
        model = "prop_golf_pitcher_01",
        power = 10.0,
        anim = {
            ["idle"] = {animDict = "mini@golf", anim = "putt_idle_c"},
            ["swing_i"] = {animDict = "mini@golf", anim = "wedge_swing_intro_high"},
            ["swing_min"] = {animDict = "mini@golf", anim = "wedge_swing_action_low"},
            ["swing_max"] = {animDict = "mini@golf", anim = "wedge_swing_action_high"},
        },
        PositionOffset = vector3(0.3,-0.70,1.0),
        RadiusOffset = 0.55,
        label = parseText('club_label_2')
    }, 
    {-- Iron
        model = "prop_golf_iron_01",
        power = 20.0,
        anim = {
            ["idle"] = {animDict = "mini@golf", anim = "iron_idle_c"},
            ["swing_i"] = {animDict = "mini@golf", anim = "iron_swing_intro_high"},
            ["swing_min"] = {animDict = "mini@golf", anim = "iron_swing_action_low"},
            ["swing_max"] = {animDict = "mini@golf", anim = "iron_swing_action_high"},
        },
        PositionOffset = vector3(0.4,-0.75,1.0),
        RadiusOffset = 0.8,
        label = parseText('club_label_3')
    }, 
    {-- Driver
        model = "prop_golf_wood_01",
        power = 30.0,
        anim = {
            ["idle"] = {animDict = "mini@golf", anim = "wood_idle_c"},
            ["swing_i"] = {animDict = "mini@golf", anim = "wood_swing_intro_high"},
            ["swing_min"] = {animDict = "mini@golf", anim = "wood_swing_action_low"},
            ["swing_max"] = {animDict = "mini@golf", anim = "wood_swing_action_high"},
        },
        PositionOffset = vector3(0.3,-1.0,1.0),
        RadiusOffset = 1.05,
        label = parseText('club_label_4')
    } 
}

Config.Polyzone = {}

Config.Polyzone.poly = {
    vector2(-1366.42, 184.56),
    vector2(-1350.78, 190.17),
    vector2(-1331.84, 192.92),
    vector2(-1271.1, 197.25),
    vector2(-1248.64, 201.61),
    vector2(-1220.45, 211.8),
    vector2(-1164.43, 224.49),
    vector2(-1143.6, 230.34),
    vector2(-1123.71, 237.38),
    vector2(-1116.12, 238.22),
    vector2(-1110.45, 235.89),
    vector2(-1107.23, 229.93),
    vector2(-1089.67, 179.55),
    vector2(-1077.09, 155.05),
    vector2(-1063.3, 134.58),
    vector2(-1010.78, 50.49),
    vector2(-977.59, -6.85),
    vector2(-961.46, -30.61),
    vector2(-941.47, -56.46),
    vector2(-922.81, -86.43),
    vector2(-925.57, -94.76),
    vector2(-944.96, -108.74),
    vector2(-972.66, -122.35),
    vector2(-990.97, -127.47),
    vector2(-1005.91, -132.04),
    vector2(-1024.33, -132.32),
    vector2(-1032.09, -134.1),
    vector2(-1035.49, -137.51),
    vector2(-1048.28, -144.09),
    vector2(-1065.09, -147.51),
    vector2(-1079.44, -144.39),
    vector2(-1105.27, -132.43),
    vector2(-1250.81, -52.86),
    vector2(-1281.64, -39.31),
    vector2(-1297.49, -25.31),
    vector2(-1315.77, 4.91),
    vector2(-1326.36, 19.83),
    vector2(-1331.83, 60.49),
    vector2(-1334.68, 78.67),
    vector2(-1338.97, 83.99),
    vector2(-1342.61, 124.46),
    vector2(-1340.45, 124.46),
    vector2(-1342.93, 149.21),
    vector2(-1403.71, 144.14),
    vector2(-1395.98, 157.92),
    vector2(-1387.47, 168.81),
    vector2(-1381.17, 174.54),
    vector2(-1374.9, 179.07)
}

Config.Polyzone.infos = {
    name = "golf_rockford",
    maxZ = 125.0,
    debugGrid = false,
    gridDivisions = 30
}