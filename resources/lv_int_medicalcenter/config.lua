ELEVATOR_MENU_TITLE = "Elevator"
ELEVATOR_MENU_DESCRIPTION = "The world fastest elevator!"
MARKER_NOTIFICATION = "Press ~INPUT_CONTEXT~ to access ~b~elevator menu"

ZONES = {
    --fortcarson Medical Center--
    ['fortcarson_mainfloor_01'] = {
        label = "Main floor",
        coords = vec4(7493.580, 383.398, 57.821, 138.659),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_upperfloor_01'
        }
    },
    ['fortcarson_upperfloor_01'] = {
        label = "Upper floor",
        coords = vec4(7493.805, 383.640, 61.827, 130.456),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_mainfloor_01'
        }
    },
    ['fortcarson_mainfloor_02'] = {
        label = "Main floor",
        coords = vec4(7495.613, 381.566, 57.821, 135.062),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_upperfloor_02'
        }
    },
    ['fortcarson_upperfloor_02'] = {
        label = "Upper floor",
        coords = vec4(7495.613, 381.566, 61.827, 135.062),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_mainfloor_02'
        }
    },
    ['fortcarson_corridor_01'] = {
        label = "Main corridor floor",
        coords = vec4(7479.447, 402.034, 57.821, 224.716),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_corridorupper_01',
        }
    },
    ['fortcarson_corridorupper_01'] = {
        label = "Upper corridor floor",
        coords = vec4(7479.447, 402.034, 61.827, 224.716),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_corridor_01',
        }
    },
    ['fortcarson_corridor_02'] = {
        label = "Main corridor floor",
        coords = vec4(7481.405, 403.946, 57.821, 227.977),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_corridorupper_02'
        }
    },
    ['fortcarson_corridorupper_02'] = {
        label = "Upper corridor floor",
        coords = vec4(7481.405, 403.946, 61.827, 227.977),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_corridor_02'
        }
    },
    ['fortcarson_corridorgarage'] = {
        label = "Garage access by corridor",
        coords = vec4(7506.702, 406.394, 57.815, 311.787),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_garage'
        }
    },
    ['fortcarson_garage'] = {
        label = "Garage access",
        coords = vec4(7509.068, 426.686, 57.807, 152.152),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fortcarson_corridorgarage'
        }
    }
}