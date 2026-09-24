JailCellsConfig = {

    stations = {

        lspd = {
            label   = "LSPD",
            center  = vector3(-1125.0, -835.0, 4.87),
            detect_radius = 120.0,
            release = { pos = vector3(-1093.294067, -806.703491, 19.348959), heading = 317.36947631836 },
            slots   = {
                { pos = vector3(-1123.797485, -846.090820, 4.870651), heading = 309.90548706055 },
                { pos = vector3(-1125.877319, -843.343689, 4.870651), heading = 310.173828125    },
                { pos = vector3(-1127.972046, -840.467651, 4.870651), heading = 312.28915405273  },
                { pos = vector3(-1121.825806, -835.639893, 4.870651), heading = 125.03450012207  },
                { pos = vector3(-1119.403198, -838.515991, 4.870651), heading = 127.18167877197  },
                { pos = vector3(-1117.321655, -841.145142, 4.870651), heading = 139.64964294434  },
                { pos = vector3(-1115.392944, -844.099487, 4.870651), heading = 133.74658203125  },
                { pos = vector3(-1130.882080, -831.119873, 4.870651), heading = 36.014156341553  },
                { pos = vector3(-1132.971802, -823.716248, 4.870651), heading = 64.846710205078  },
                { pos = vector3(-1129.290405, -821.154968, 4.870651), heading = 50.245029449463  },
            },
        },

        sheriff = {
            label   = "Shérif",
            center  = vector3(2839.0, 4720.0, 48.62),
            detect_radius = 120.0,
            release = { pos = vector3(2846.679688, 4738.769043, 48.294037), heading = 317.36947631836 },
            slots   = {
                { pos = vector3(2839.696045, 4715.105469, 48.627357), heading = 109.78872680664 },
                { pos = vector3(2839.880371, 4717.885254, 48.627357), heading = 103.34931182861 },
                { pos = vector3(2839.317627, 4720.415039, 48.627357), heading = 103.43998718262 },
                { pos = vector3(2838.822510, 4722.698242, 48.627357), heading = 105.40549468994 },
                { pos = vector3(2838.072510, 4725.007324, 48.627357), heading = 104.18497467041 },
            },
        },

    },

    min_seconds     = 60,
    max_seconds     = 3600,
    default_seconds = 300,

    escape_distance = 6.0,
    escape_check_interval = 1000,

    webhook = "https://discord.com/api/webhooks/1520546526554755293/1zzxEjOQyL8npzNPbAXKtbmHlYm2eHJ9ToSwSPt-BfEDkmj1HK1MD80oYc_TYlmlQtG8",
}
