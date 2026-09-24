jobs = {
    {
        metier = "brasserie",
        metierMaj = "Brasserie Pibwasser",
        washMoney = false,
        actionPatron = vector3(413.117, 6539.151, 26.735),
        vestiaire = vector3(424.17, 6472.6, 27.81),
        coffre = vector3(426.3015, 6457.93, 27.80719),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(308.92, 6495.46, 28.45),
            limit = 10,
            item = "malt",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-687.018, 5794.103, 16.350),
            limit = 250,
            itemTraite = "malt",
            item = "bieredequalite",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de malt\n~g~+100 bières",

        },
        vente = {
            zone = vector3(-288.173, 6299.457, 30.512),
            itemVente = "bieredequalite",
            item_required = 100,
            msg = "~r~-1 caisses de bière",

        },
        garage = {
            vehicule = {
                "4rtrd",
                "guardian",
                "toros",
                "bison",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(407.589, 6496.381, 27.04),
            pointDeSpawn = {
                {pos = vector3(409.328, 6488.600, 28.619), heading = 90.9,},
            },
        },
    },
    {
        metier = "tabac",
        metierMaj = "Tabagiste",
        washMoney = false,
        actionPatron = vector3(2898.594, 4404.307, 49.38565),
        vestiaire = vector3(2898.045, 4415.087, 49.38563),
        coffre = vector3(2892.247, 4411.401, 49.38556),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2889.5, 4603.46, 47.08),
            limit = 10,
            item = "tabacbrun",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2874.174, 4416.946, 48.25984),
            limit = 250,
            itemTraite = "tabacbrun",
            item = "cigarette",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de tabac brun\n~g~+100g tabac séché",

        },
        vente = {
            zone = vector3(2340.82, 3124.38, 47.21),
            itemVente = "cigarette",
            item_required = 100,
            msg = "~r~-100 caisses de cigarettes",

        },
        garage = {
            vehicule = {
                "guardian",
                "kamacho",
                "thrax",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2887.692, 4390.722, 49.85821),
            pointDeSpawn = {
                {pos = vector3(2896.934, 4382.009, 50.38143), heading = 286.48,},
            },
        },
    },
    {
        metier = "usinetel",
        metierMaj = "Usine de téléphones",
        washMoney = false,
        actionPatron = vector3(846.2864, -961.8604, 25.62109),
        vestiaire = vector3(847.1468, -931.3798, 25.60102),
        coffre = vector3(846.8688, -951.7261, 24.90102),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(891.194, -889.1207, 25.90981),
            limit = 10,
            item = "pieceelectronique",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(759.4387, -1262.372, 25.40542),
            limit = 250,
            itemTraite = "pieceelectronique",
            item = "tel",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pièces\n~g~+100 téléphones",

        },
        vente = {
            zone = vector3(140.4557, -246.564, 50.60687),
            itemVente = "tel",
            item_required = 100,
            msg = "~r~-100 téléphones",

        },
        garage = {
            vehicule = {
                "rumpo3",
                "mule",
                "10ram",
                "rebla",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(846.0448, -902.6657, 24.32148),
            pointDeSpawn = {
                {pos = vector3(855.7928, -897.3637, 25.39141), heading = 286.48,},
            },
        },
    },
    {
        metier = "diamant",
        metierMaj = "Diamond Company",
        washMoney = false,
        actionPatron = vector3(2707.002, 2777.443, 36.97796),
        vestiaire = vector3(2678.148, 2774.985, 35.99975),
        coffre = vector3(2705.903, 2765.604, 36.13538),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2971.243, 2792.403, 39.47532),
            limit = 10,
            item = "diamantbrut",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2602.269, 2801.249, 32.90307),
            limit = 250,
            itemTraite = "diamantbrut",
            item = "diamanthaute",
            item_required = 100,
            give = 100,
            msg = "~r~-100 diamants bruts\n~g~+100 diamants",

        },
        vente = {
            zone = vector3(-610.3382, -229.5546, 35.95221),
            itemVente = "diamanthaute",
            item_required = 100,
            msg = "~r~-100 diamants",

        },
        garage = {
            vehicule = {
                "burrito2",
                "guardian",
                "Italirsx",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2745.623, 2788.815, 34.50073),
            pointDeSpawn = {
                {pos = vector3(2775.293, 2808.491, 41.49877), heading = 286.48,},
            },
        },
    },
    {
        metier = "sora",
        metierMaj = "Sora",
        washMoney = false,
        actionPatron = vector3(-242.833, -258.6102, 36.74951),
        vestiaire = vector3(-239.4071, -224.3386, 35.61903),
        coffre = vector3(-239.5838, -219.0114, 35.73423),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(326.7772, 841.5115, 192.4476),
            limit = 10,
            item = "plastique",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(398.4263, 793.1347, 187.5586),
            limit = 250,
            itemTraite = "plastique",
            item = "lego",
            item_required = 100,
            give = 100,
            msg = "~r~-100 plastique\n~g~+100 lego",

        },
        vente = {
            zone = vector3(-241.5706, -234.0046, 35.61904),
            itemVente = "lego",
            item_required = 100,
            msg = "~r~-100 plastique",

        },
        garage = {
            vehicule = {
                "guardian",
                "gresleyhellfire",
                "gauntlet4",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-237.0128, -255.952, 38.21755),
            pointDeSpawn = {
                {pos = vector3(-250.0351, -247.9017, 35.61904), heading = 286.48,},
            },
        },
    },
    {
        metier = "ble",
        metierMaj = "Domaine du blé",
        washMoney = false,
        actionPatron = vector3(2931.837, 4624.469, 47.80348),
        vestiaire = vector3(2932.552, 4618.408, 47.80715),
        coffre = vector3(2939.529, 4623.844, 47.80062),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2935.946, 4687.412, 49.90264),
            limit = 10,
            item = "ble",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2337.302, 4858.436, 40.90823),
            limit = 250,
            itemTraite = "ble",
            item = "pain",
            item_required = 100,
            give = 100,
            msg = "~r~-100 blé\n~g~+100 pain",

        },
        vente = {
            zone = vector3(2482.179, 4114.038, 37.15467),
            itemVente = "pain",
            item_required = 100,
            msg = "~r~-100 pain",

        },
        garage = {
            vehicule = {
                "DBToraWBHellcat",
                "durango18",
                "23sprint",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2945.104, 4634.68, 47.60345),
            pointDeSpawn = {
                {pos = vector3(2946.143, 4643.415, 47.62467), heading = 286.48,},
            },
        },
    },
    {
        metier = "mine",
        metierMaj = "Minage Service",
        washMoney = false,
        actionPatron = vector3(224.6149, 2594.547, 44.50674),
        vestiaire = vector3(227.4122, 2582.06, 44.65181),
        coffre = vector3(219.4828, 2580.015, 44.99044),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-596.5368, 2090.815, 130.5027),
            limit = 10,
            item = "pepiteor",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-113.0906, 1881.992, 196.4064),
            limit = 250,
            itemTraite = "pepiteor",
            item = "or",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pépites d'or\n~g~+100 or",

        },
        vente = {
            zone = vector3(820.7736, 2368.83, 51.22555),
            itemVente = "or",
            item_required = 100,
            msg = "~r~-100 or",

        },
        garage = {
            vehicule = {
                "DBToraWBHellcat",
                "durango18",
                "23sprint",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(217.7562, 2602.721, 44.90266),
            pointDeSpawn = {
                {pos = vector3(216.4243, 2612, 46.74685), heading = 286.48,},
            },
        },
    },
    {
        metier = "grill",
        metierMaj = "Grill Express",
        washMoney = false,
        actionPatron = vector3(-385.1835, 270.6884, 85.45765),
        vestiaire = vector3(-370.8927, 277.7184, 85.50187),
        coffre = vector3(-361.5275, 278.2886, 85.50188),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(934.733, -1571.197, 29.55735),
            limit = 10,
            item = "ingredients",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-326.9698, -1348.413, 30.45934),
            limit = 250,
            itemTraite = "ingredients",
            item = "menugrill",
            item_required = 100,
            give = 100,
            msg = "~r~-100 ingrédients\n~g~+100 menu grill",

        },
        vente = {
            zone = vector3(-382.9384, 289.691, 83.85661),
            itemVente = "menugrill",
            item_required = 100,
            msg = "~r~-100 menu grill",

        },
        garage = {
            vehicule = {
                "caracara2",
                "rumpo3",
                "windsor",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-355.3636, 298.3603, 83.82115),
            pointDeSpawn = {
                {pos = vector3(-360.0328, 292.5292, 83.82078), heading = 286.48,},
            },
        },
    },
    {
        metier = "alcool",
        metierMaj = "Domaine d'Alcool",
        washMoney = false,
        actionPatron = vector3(-1878.602, 651.7486, 129.30),
        vestiaire = vector3(-1889.109, 655.6364, 129.30),
        coffre = vector3(-1896.457, 642.4686, 129.30),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1197.124, 2923.763, 39.7528),
            limit = 10,
            item = "orge",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(568.4327, 2671.21, 41.13289),
            limit = 250,
            itemTraite = "orge",
            item = "vodka",
            item_required = 100,
            give = 100,
            msg = "~r~-100 orge\n~g~+100 vodka",

        },
        vente = {
            zone = vector3(-1886.825, 629.1323, 129.09),
            itemVente = "vodka",
            item_required = 100,
            msg = "~r~-100 vodka",

        },
        garage = {
            vehicule = {
                "guardian",
                "gstlight1",
                "tahoe21",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1889.837, 618.7037, 129.0768),
            pointDeSpawn = {
                {pos = vector3(-1896.582, 621.4788, 127.9741), heading = 286.48,},
            },
        },
    },
    {
        metier = "rhum",
        metierMaj = "Rhum&Co",
        washMoney = false,
        actionPatron = vector3(346.4641, 3406.539, 35.60159),
        vestiaire = vector3(322.5699, 3397.624, 35.55516),
        coffre = vector3(361.2335, 3406.246, 35.50355),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-95.1805, 2810.24, 52.40801),
            limit = 10,
            item = "jusdecanne",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(370.4355, 3411.231, 35.50407),
            limit = 250,
            itemTraite = "jusdecanne",
            item = "rhum",
            item_required = 100,
            give = 100,
            msg = "~r~-100 jusdecanne\n~g~+100 rhum",

        },
        vente = {
            zone = vector3(917.5687, 3659.446, 31.60566),
            itemVente = "rhum",
            item_required = 100,
            msg = "~r~-100 rhum",

        },
        garage = {
            vehicule = {
                "patriot",
                "youga3",
                "jackal",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(334.099, 3429.266, 35.30485),
            pointDeSpawn = {
                {pos = vector3(342.042, 3423.523, 36.38955), heading = 286.48,},
            },
        },
    },
    {
        metier = "osmapoliakov",
        metierMaj = "Osmapoliakov",
        washMoney = false,
        actionPatron = vector3(-2952.928, 50.05248, 10.70851),
        vestiaire = vector3(-2963.591, 52.6169, 10.70849),
        coffre = vector3(-2948.136, 57.65768, 10.70851),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-2620.939, 2453.545, 0.352094),
            limit = 10,
            item = "orge",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-2964.108, 64.23968, 10.70845),
            limit = 250,
            itemTraite = "orge",
            item = "whisky",
            item_required = 100,
            give = 100,
            msg = "~r~-100 orge\n~g~+100 whisky",

        },
        vente = {
            zone = vector3(-1235.419, -2326.229, 13.04456),
            itemVente = "whisky",
            item_required = 100,
            msg = "~r~-100 whisky",

        },
        garage = {
            vehicule = {
                "windsor2",
                "rmodm4gts",
                "jackal",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-3021.852, 90.26073, 10.70859),
            pointDeSpawn = {
                {pos = vector3(-3018.134, 101.6215, 11.63415), heading = 286.48,},
            },
        },
    },
        blips_info = {
            actionPatron = { name = "Action Patron" },
        },
    {
        metier = "cbdo",
        metierMaj = "CBDO",
        washMoney = false,
        actionPatron = vector3(-52.41024, 6396.111, 30.57036),
        vestiaire = vector3(-70.22107, 6385.388, 30.57038),
        coffre = vector3(-55.6953, 6393.1, 30.57035),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(201.504, 6474.19, 30.85999),
            limit = 10,
            item = "chanvre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-33.9642, 6419.518, 30.57951),
            limit = 250,
            itemTraite = "chanvre",
            item = "cbd",
            item_required = 100,
            give = 100,
            msg = "~r~-100 chanvre\n~g~+100 cbd",

        },
        vente = {
            zone = vector3(-2221.078, 3482.021, 29.26934),
            itemVente = "cbd",
            item_required = 100,
            msg = "~r~-100 cbd",

        },
        garage = {
            vehicule = {
                "contender",
                "sandking",
                "teslapd",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-52.41024, 6396.111, 30.57036),
            pointDeSpawn = {
                {pos = vector3(-61.17944, 6403.852, 30.57037), heading = 286.48,},
            },
        },
    },
    {
        metier = "organic",
        metierMaj = "OrganicFields",
        washMoney = false,
        actionPatron = vector3(905.5277, 3553.661, 32.90053),
        vestiaire = vector3(915.3448, 3562.811, 32.90418),
        coffre = vector3(915.4467, 3567.427, 32.89474),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2667.041, 4517, 38.75443),
            limit = 10,
            item = "flpavot",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2177.264, 3502.456, 44.49486),
            limit = 250,
            itemTraite = "flpavot",
            item = "gpavot",
            item_required = 100,
            give = 100,
            msg = "~r~-100 fleur de pavot\n~g~+100 graine de pavot",

        },
        vente = {
            zone = vector3(903.6594, 3589.59, 32.30074),
            itemVente = "gpavot",
            item_required = 100,
            msg = "~r~-100 grainde de pavot",

        },
        garage = {
            vehicule = {
                "benson",
                "speedo",
                "golf8r",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(899.4946, 3574.364, 32.60931),
            pointDeSpawn = {
                {pos = vector3(895.0447, 3581.444, 32.48606), heading = 286.48,},
            },
        },
    },
    {
        metier = "electrochoc",
        metierMaj = "Électrochoc",
        washMoney = false,
        actionPatron = vector3(2675.742, 3499.796, 52.40332),
        vestiaire = vector3(2679.508, 3503.001, 52.40411),
        coffre = vector3(2684.947, 3515.462, 52.40384),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1014.59, 2448.494, 43.54802),
            limit = 10,
            item = "cuivre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2361.393, 2520.703, 45.75773),
            limit = 250,
            itemTraite = "cuivre",
            item = "cable",
            item_required = 100,
            give = 100,
            msg = "~r~-100 cuivre\n~g~+100 cables",

        },
        vente = {
            zone = vector3(2753.915, 3470.218, 54.80776),
            itemVente = "cable",
            item_required = 100,
            msg = "~r~-100 de cable",

        },
        garage = {
            vehicule = {
                "guardian",
                "rebla",
                "kalahari",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2681.832, 3507.53, 52.40397),
            pointDeSpawn = {
                {pos = vector3(2670.81, 3523.187, 52.61938), heading = 286.48,},
            },
        },
    },
    {
        metier = "graphitech",
        metierMaj = "GraphiTech",
        washMoney = false,
        actionPatron = vector3(-3209.882, 1144.952, 8.995412),
        vestiaire = vector3(-3214.678, 1149.37, 8.995412),
        coffre = vector3(-3213.887, 1136.245, 8.995411),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-3165.958, 1110.967, 19.85274),
            limit = 10,
            item = "pieceelectronique",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1088.554, 2713.618, 18.16522),
            limit = 20000,
            itemTraite = "pieceelectronique",
            item = "cartegraphique",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pieces electroniques\n~g~+100 cartes graphiques",

        },
        vente = {
            zone = vector3(3476.369, 3666.479, 32.9884),
            itemVente = "cartegraphique",
            item_required = 100,
            msg = "~r~-100 cartes graphiques",

        },
        garage = {
            vehicule = {
                "guardian",
                "gls20",
                "benson",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-3205.05, 1139.371, 8.997338),
            pointDeSpawn = {
                {pos = vector3(-3197.992, 1133.783, 9.905898), heading = 260.03,},
            },
        },
    },
    {
        metier = "gof",
        metierMaj = "Grapeseed O'Neil Farm",
        washMoney = false,
        actionPatron = vector3(-3209.882, 1144.952, 8.995412),
        vestiaire = vector3(-3214.678, 1149.37, 8.995412),
        coffre = vector3(-3213.887, 1136.245, 8.995411),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2497.0336914062, 4878.2104492188, 38.330974578857),
            limit = 10,
            item = "poussedetomate",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2310.5217285156, 4826.7368164062, 39.780429840088),
            limit = 20000,
            itemTraite = "poussedetomate",
            item = "tomate",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pousse de tomate\n~g~+100 tomates",

        },
        vente = {
            zone = vector3(-250.2042388916, -253.04498291016, 36.519077301025),
            itemVente = "tomate",
            item_required = 100,
            msg = "~r~-100 cartes graphiques",

        },
        garage = {
            vehicule = {
                "master2019",
                "speedo",
                "benson",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2419.0895996094, 4988.6474609375, 45.039123535156),
            pointDeSpawn = {
                {pos = vector3(2412.6284179688, 4989.6762695312, 46.239246368408), heading = 135.74865722656,},
            },
        },
    },
    {
        metier = "icebiere",
        metierMaj = "Ice Biere",
        washMoney = false,
        actionPatron = vector3(-37.783657073975, 6419.4233398438, 30.490459442139),
        vestiaire = vector3(-43.161426544189, 6415.396484375, 30.490434646606),
        coffre = vector3(-50.253177642822, 6417.9331054688, 30.490438461304),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(46.798728942871, 6300.982421875, 30.231023788452),
            limit = 10,
            item = "prep_biere",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-65.151031494141, 6447.8110351562, 30.51452827453),
            limit = 250,
            itemTraite = "prep_biere",
            item = "biere",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de préparation de biere \n~g~+100g Biere",

        },
        vente = {
            zone = vector3(541.1123046875, 2658.2729492188, 41.19229888916),
            itemVente = "biere",
            item_required = 100,
            msg = "~r~-100 biere",

        },
        garage = {
            vehicule = {
                "nspeedo",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-32.848365783691, 6421.0922851562, 30.466772079468),
            pointDeSpawn = {
                {pos = vector3(-31.145555496216, 6418.40625, 31.06619644165), heading =  228.89569091797},
            },
        },
    },
    {
        metier = "horlogeriedescamps",
        metierMaj = "Horlogerie Descamps",
        washMoney = false,
        actionPatron = vector3(-317.98385620117, -609.93688964844, 32.558181762695),
        vestiaire = vector3(-292.47094726562, -602.60247802734, 32.558528900146),
        coffre = vector3(-284.03579711914, -602.40045166016, 32.558387756348),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(846.32757568359, -1993.609375, 28.301340103149),
            limit = 10,
            item = "prepmontre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(785.30334472656, -1807.7377929688, 29.875974655151),
            limit = 250,
            itemTraite = "prepmontre",
            item = "montredeluxe",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de Montre desossée \n~g~+100g Montre de luxe",

        },
        vente = {
            zone = vector3(-240.53372192383, -234.7632598877, 35.519077301025),
            itemVente = "montredeluxe",
            item_required = 100,
            msg = "~r~-100 Montre de luxe",

        },
        garage = {
            vehicule = {
                "nspeedo",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-283.91165161133, -611.66455078125, 32.531742095947),
            pointDeSpawn = {
                {pos = vector3(-288.03067016602, -618.166015625, 32.997455596924), heading = 103.4854888916},
            },
        },
    },
    {
        metier = "pop",
        metierMaj = "POP",
        washMoney = false,
        actionPatron = vector3(-1437.71, -871.72, 9.99),
        vestiaire = vector3(-162.53, 254.63, 577.46),
        coffre = vector3(-1430.64, -884.99, 9.98),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-3157.915, 1129.398, 19.94637),
            limit = 10,
            item = "resine",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1083.497, -1255.237, 4.520325),
            limit = 20000,
            itemTraite = "resine",
            item = "figurine",
            item_required = 100,
            give = 100,
            msg = "~r~-100 résine\n~g~+100 figurines",

        },
        vente = {
            zone = vector3(-1306.53, -1312.141, 3.980973),
            itemVente = "figurine",
            item_required = 100,
            msg = "~r~-100 figurines",

        },
        garage = {
            vehicule = {
                "guardian",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1437.21, -881.95, 9.97),
            pointDeSpawn = {
                {pos = vector3(-1438.08, -890.82, 10.82), heading = 155.06770324707,},
            },
        },
    },
    {
        metier = "greenhouse",
        metierMaj = "Greenhouse",
        washMoney = false,
        actionPatron = vector3(-603.924, -782.5034, 24.1172),
        vestiaire = vector3(-162.53, 254.63, 577.46),
        coffre = vector3(-603.8478, -774.8671, 24.11722),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-248.5263, 1040.059, 234.2783),
            limit = 10,
            item = "chanvre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1487.125, -201.7511, 49.49711),
            limit = 20000,
            itemTraite = "chanvre",
            item = "cbd",
            item_required = 100,
            give = 100,
            msg = "~r~-100 chanvre\n~g~+100 cbd",

        },
        vente = {
            zone = vector3(-828.7851, -1264.363, 4.10038),
            itemVente = "cbd",
            item_required = 100,
            msg = "~r~-100 cbd",

        },
        garage = {
            vehicule = {
                "guardian",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-616.6396, -788.295, 24.18893),
            pointDeSpawn = {
                {pos = vector3(-616.9498, -771.9388, 25.41235), heading = 155.06770324707,},
            },
        },
    },
    {
        metier = "orditech",
        metierMaj = "OrdiTech",
        washMoney = false,
        actionPatron = vector3(226.8559, -283.6687, 48.59905),
        vestiaire = vector3(-162.53, 254.63, 577.46),
        coffre = vector3(256.789, -256.9165, 53.13703),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2498.497, -439.8637, 92.0932),
            limit = 10,
            item = "piecespc",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(496.4674, -636.8978, 24.04906),
            limit = 20000,
            itemTraite = "piecespc",
            item = "pcportable",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pièces de PC\n~g~+100 pcportable",

        },
        vente = {
            zone = vector3(847.4488, 513.0717, 125.0193),
            itemVente = "pcportable",
            item_required = 100,
            msg = "~r~-100 pc portables",

        },
        garage = {
            vehicule = {
                "jogger",
                "guardian",
                "buffalo4h",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(223.5916, -292.3667, 46.93918),
            pointDeSpawn = {
                {pos = vector3(213.749, -288.5862, 46.75267), heading = 155.06770324707,},
            },
        },
    },
    {
        metier = "celtic",
        metierMaj = "Celtic Spirits",
        washMoney = false,
        actionPatron = vector3(1243.735, 1869.026, 78.08748),
        vestiaire = vector3(1233.516, 1876.549, 77.97143),
        coffre = vector3(1218.924, 1848.305, 78.05068),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1036.227, 2904.663, 11.19203),
            limit = 10,
            item = "orge",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1263.389, 1925.043, 77.61146),
            limit = 20000,
            itemTraite = "orge",
            item = "whisky",
            item_required = 100,
            give = 100,
            msg = "~r~-100 orge\n~g~+100 whisky",

        },
        vente = {
            zone = vector3(-1510.846, 1494.037, 114.8719),
            itemVente = "whisky",
            item_required = 100,
            msg = "~r~-100 whisky",

        },
        garage = {
            vehicule = {
                "guardian",
                "dubsta",
                "sunrise1",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(223.5916, -292.3667, 46.93918),
            pointDeSpawn = {
                {pos = vector3(213.749, -288.5862, 46.75267), heading = 155.06770324707,},
            },
        },
    },
    {
        metier = "lancaster",
        metierMaj = "Lancaster",
        washMoney = false,
        actionPatron = vector3(-438.57, 7328.56, 5.58),
        vestiaire = vector3(-414.0199, 7356.672, 6.533174),
        coffre = vector3(-441.83, 7355.65, 5.58),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1806.164, 6471.134, 15.88452),
            limit = 10,
            item = "soufre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1775.437, 7027.084, 29.73634),
            limit = 20000,
            itemTraite = "soufre",
            item = "poudrecanon",
            item_required = 100,
            give = 100,
            msg = "~r~-100 soufre\n~g~+100 poudre a canon",

        },
        vente = {
            zone = vector3(-331.0033, 6103.123, 30.56302),
            itemVente = "poudrecanon",
            item_required = 100,
            msg = "~r~-100 poudre a canon",

        },
        garage = {
            vehicule = {
                "aleutianxl",
                "oracle",
                "xa21",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-420.52, 7356.34, 5.59),
            pointDeSpawn = {
                {pos = vector3(-418.06, 7365.29, 6.52), heading = 357.18701171875,},
            },
        },
    },
    {
        metier = "sawmill",
        metierMaj = "Sawmill Company",
        washMoney = false,
        actionPatron = vector3(-535.14, 5296.334, 75.32181),
        vestiaire = vector3(-537.7612, 5288.179, 74.46353),
        coffre = vector3(-552.6734, 5327.327, 72.69963),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-582.5432, 5278.784, 69.3636),
            limit = 10,
            item = "bois",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-471.9565, 5371.157, 79.87742),
            limit = 20000,
            itemTraite = "bois",
            item = "planche",
            item_required = 100,
            give = 100,
            msg = "~r~-100 bois\n~g~+100 planche",

        },
        vente = {
            zone = vector3(-1773.668, 6462.826, 15.89594),
            itemVente = "planche",
            item_required = 100,
            msg = "~r~-100 planche",

        },
        garage = {
            vehicule = {
                "aleutianxl",
                "oracle",
                "xa21",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-568.0891, 5253.235, 69.5875),
            pointDeSpawn = {
                {pos = vector3(-575.4579, 5254.877, 70.46616), heading = 357.18701171875,},
            },
        },
    },
    {
        metier = "bullesor",
        metierMaj = "Bulles d'OR",
        washMoney = false,
        actionPatron = vector3(-289.4463, 303.7186, 89.81835),
        vestiaire = vector3(-276.7713, 303.8262, 89.81835),
        coffre = vector3(-297.188, 303.9789, 89.81835),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1736.9852294922, 1966.0076904297, 120.56273040771),
            limit = 10,
            item = "pinot",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-3165.628, 1113.17, 19.84595),
            limit = 20000,
            itemTraite = "pinot",
            item = "champagne",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pinot\n~g~+100 champagne",

        },
        vente = {
            zone = vector3(-2029.299, -262.4859, 22.48599),
            itemVente = "champagne",
            item_required = 100,
            msg = "~r~-100 champagne",

        },
        garage = {
            vehicule = {
                "aleutianxl",
                "oracle",
                "buffalo4h",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-295.2571, 325.8792, 92.35462),
            pointDeSpawn = {
                {pos = vector3(-279.5186, 318.6749, 92.3544), heading = 357.18701171875,},
            },
        },
    },
    {
        metier = "repetcie",
        metierMaj = "Réparation&Cie",
        washMoney = false,
        actionPatron = vector3(153.00909423828, -3211.6608886719, 5.0045352935791),
        vestiaire = vector3(121.45337677002, -3179.9064941406, 5.0781637191772),
        coffre = vector3(121.69365692139, -3214.9140625, 5.0874091148376),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-688.43011474609, -2455.349609375, 12.994270896912),
            limit = 10,
            item = "piecemetal",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-636.34600830078, -1655.2149658203, 24.925067520142),
            limit = 20000,
            itemTraite = "piecemetal",
            item = "outils",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pièces métalliques\n~g~+100 outils",

        },
        vente = {
            zone = vector3(138.85182189941, -3208.6928710938, 4.9575921058655),
            itemVente = "outils",
            item_required = 100,
            msg = "~r~-100 outils",

        },
        garage = {
            vehicule = {
                "guardian",
                "speedo",
                "outlaw",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(145.00271606445, -3188.6687011719, 4.9575921058655),
            pointDeSpawn = {
                {pos = vector3(145.00271606445, -3188.6687011719, 5.8575921058655), heading = 178.18701171875,},
            },
        },
    },
    {
        metier = "zarevich",
        metierMaj = "Zarevich Spirits",
        washMoney = false,
        actionPatron = vector3(-126.06101989746, 1896.4559326172, 196.43303833008),
        vestiaire = vector3(-112.69139862061, 1882.0316162109, 196.43311462402),
        coffre = vector3(-121.24852752686, 1918.6606445312, 196.43303833008),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-83.999450683594, 1909.8483886719, 195.67171630859),
            limit = 10,
            item = "cereales",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1744.0621337891, 1979.1752929688, 118.12182006836),
            limit = 20000,
            itemTraite = "cereales",
            item = "vodka",
            item_required = 100,
            give = 100,
            msg = "~r~-100 céréales\n~g~+100 vodka",

        },
        vente = {
            zone = vector3(541.07635498047, 2658.7253417969, 41.290933227539),
            itemVente = "vodka",
            item_required = 100,
            msg = "~r~-100 vodka",

        },
        garage = {
            vehicule = {
                "guardian",
                "oraclegts",
                "nspeedo",
                "outlaw",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-127.75356292725, 1921.8055419922, 196.41094360352),
            pointDeSpawn = {
                {pos = vector3(-128.1429901123, 1928.8031005859, 196.05822143555), heading = 357.0,},
            },
        },
    },
    {
        metier = "dumex",
        metierMaj = "Dumex Industries",
        washMoney = false,
        actionPatron = vector3(-1220.3262939453, -1346.0467529297, 3.2532015800476),
        vestiaire = vector3(-1222.2954101562, -1339.4899902344, 3.267712688446),
        coffre = vector3(-1224.2165527344, -1330.9108886719, 3.3410655021667),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1343.8642578125, 731.2880859375, 184.79857788086),
            limit = 10,
            item = "latex",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1414.5693359375, -956.26580810547, 6.3381825447083),
            limit = 20000,
            itemTraite = "latex",
            item = "preservatif",
            item_required = 100,
            give = 100,
            msg = "~r~-100 latex\n~g~+100 preservatif",

        },
        vente = {
            zone = vector3(-1209.3193359375, -1310.2576904297, 3.8453289031982),
            itemVente = "preservatif",
            item_required = 100,
            msg = "~r~-100 preservatif",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "aleutianxl",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1225.7930908203, -1326.3580322266, 3.3020497322083),
            pointDeSpawn = {
                {pos = vector3(-1220.5529785156, -1325.2008056641, 3.5461736679077), heading = 202.59,},
            },
        },
    },
    {
        metier = "forge",
        metierMaj = "Forge Industries",
        washMoney = false,
        actionPatron = vector3(2569.4895019531, 2720.072265625, 42.036080932617),
        vestiaire = vector3(2834.2634277344, 2806.9125976562, 56.501508331299),
        coffre = vector3(2832.1323242188, 2799.9104003906, 56.61033782959),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2952.2680664062, 2748.6372070312, 42.616010284424),
            limit = 10,
            item = "fer",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1414.5693359375, -956.26580810547, 6.3381825447083),
            limit = 20000,
            itemTraite = "fer",
            item = "acier",
            item_required = 100,
            give = 100,
            msg = "~r~-100 fer\n~g~+100 acier",

        },
        vente = {
            zone = vector3(2741.7014160156, 1471.1687011719, 29.891555404663),
            itemVente = "acier",
            item_required = 100,
            msg = "~r~-100 acier",

        },
        garage = {
            vehicule = {
                "scout",
                "nspeedo",
                "argento",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2707.1909179688, 2777.0959472656, 36.978032684326),
            pointDeSpawn = {
                {pos = vector3(2703.1428222656, 2778.7673339844, 37.878032684326), heading = 118.59,},
            },
        },
    },
    {
        metier = "horizon",
        metierMaj = "Pétrole Horizon",
        washMoney = false,
        -- Reprend l'implantation de Globe Oil (entreprise supprimee) : tous les
        -- points ci-dessous sont ceux de l'ancien site, l'ancienne base au nord
        -- de la map est abandonnee.
        actionPatron = vector3(533.99426269531, -1863.5008544922, 24.357458114624),
        vestiaire = vector3(536.55346679688, -1867.3759765625, 24.337400436401),
        coffre = vector3(530.09362792969, -1863.4724121094, 24.359144210815),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(602.21801757812, 2858.0239257812, 39.988952636719),
            limit = 10,
            item = "petrolebrute",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(532.34979248047, -1842.3585205078, 26.325004577637),
            limit = 20000,
            itemTraite = "petrolebrute",
            item = "petroleraffine",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pétrole brut\n~g~+100 pétrole raffiné",

        },
        vente = {
            zone = vector3(-2061.4750976562, -306.34414672852, 12.150290489197),
            itemVente = "petroleraffine",
            item_required = 100,
            msg = "~r~-100 pétrole raffiné",

        },
        garage = {
            vehicule = {
                "imperial",
                "nspeedo",
                "mesaxl",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(562.26641845703, -1834.7791748047, 24.331987380981),
            pointDeSpawn = {
                {pos = vector3(558.02178955078, -1841.7790527344, 24.90775680542), heading = 26.630939483643,},
            },
        },
    },
    {
        metier = "cigarcubain",
        metierMaj = "Cigar Cubain",
        washMoney = false,
        actionPatron = vector3(916.70147705078, 3576.8601074219, 32.662282562256),
        vestiaire = vector3(909.64593505859, 3554.9799804688, 32.917394256592),
        coffre = vector3(905.87756347656, 3586.7177734375, 32.508180236816),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2085.6857910156, 4919.892578125, 40.146463012695),
            limit = 10,
            item = "ligada",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2548.046875, 4656.5444335938, 33.176789855957),
            limit = 20000,
            itemTraite = "ligada",
            item = "cigare",
            item_required = 100,
            give = 100,
            msg = "~r~-100 ligadas\n~g~+100 cigares",

        },
        vente = {
            zone = vector3(1410.3095703125, 3619.5576171875, 33.994485473633),
            itemVente = "cigare",
            item_required = 100,
            msg = "~r~-100 cigares",

        },
        garage = {
            vehicule = {
                "imperial",
                "nspeedo",
                "mesaxl",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(915.07232666016, 3567.3100585938, 32.894479370117),
            pointDeSpawn = {
                {pos = vector3(922.05255126953, 3567.2976074219, 32.788919067383), heading = 270.19,},
            },
        },
    },
    {
        metier = "ron",
        metierMaj = "Ron Petrol",
        washMoney = false,
        actionPatron = vector3(-48.302761077881, -2508.5769042969, 6.4969850540161),
        vestiaire = vector3(-63.17110824585, -2520.0395507812, 6.5009718894958),
        coffre = vector3(-43.746116638184, -2520.2600097656, 6.495631313324),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1715.0173339844, -1714.9825439453, 111.46909484863),
            limit = 10,
            item = "barilvide",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(963.48101806641, -1529.2899169922, 30.138208007812),
            limit = 20000,
            itemTraite = "barilvide",
            item = "barilplein",
            item_required = 100,
            give = 100,
            msg = "~r~-100 barils vides\n~g~+100 barils pleins",

        },
        vente = {
            zone = vector3(308.94122314453, -2758.2473144531, 5.0882392883301),
            itemVente = "barilplein",
            item_required = 100,
            msg = "~r~-100 barils pleins",

        },
        garage = {
            vehicule = {
                "nspeedo",
                "guardian",
                "panto",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-19.642183303833, -2545.8896484375, 6.4853979110718),
            pointDeSpawn = {
                {pos = vector3(-28.581211090088, -2537.8642578125, 6.0099697113037), heading = 57.19,},
            },
        },
    },
    {
        metier = "bikvega",
        metierMaj = "Bik x Vega",
        washMoney = false,
        actionPatron = vector3(-1878.6041259766, -324.08935546875, 48.478398895264),
        vestiaire = vector3(-1822.5699462891, -369.38125610352, 48.487435913086),
        coffre = vector3(-1857.0791015625, -348.23815917969, 48.937760925293),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1268.0627441406, -855.48937988281, 11.348888015747),
            limit = 10,
            item = "cadran",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(866.2080078125, -1060.8251953125, 28.011521911621),
            limit = 20000,
            itemTraite = "cadran",
            item = "montredeluxe",
            item_required = 100,
            give = 100,
            msg = "~r~-100 cadran\n~g~+100 montres de luxe",

        },
        vente = {
            zone = vector3(-621.47686767578, -311.17440795898, 33.898892974854),
            itemVente = "montredeluxe",
            item_required = 100,
            msg = "~r~-100 montres de luxe",

        },
        garage = {
            vehicule = {
                "nspeedo",
                "guardian",
                "buffalo4h",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1876.9010009766, -309.81735229492, 48.339364624023),
            pointDeSpawn = {
                {pos = vector3(-1903.4406738281, -298.83529663086, 49.130916595459), heading = 47.19,},
            },
        },
    },
    {
        metier = "caravane",
        metierMaj = "La Caravane",
        washMoney = false,
        actionPatron = vector3(910.49420166016, -1065.4290771484, 37.0432411193854),
        vestiaire = vector3(-1822.5699462891, -369.38125610352, 48.487435913086),
        coffre = vector3(889.70501708984, -1046.1739501953, 34.270909881592),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(827.44586181641, 2191.4704589844, 51.495977020264),
            limit = 10,
            item = "plastique",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(740.79498291016, 132.67097473145, 79.482591247559),
            limit = 20000,
            itemTraite = "plastique",
            item = "emballageburger",
            item_required = 100,
            give = 100,
            msg = "~r~-100 plastique\n~g~+100 emballage de burger",

        },
        vente = {
            zone = vector3(900.10070800781, -1031.94921875, 34.066335296631),
            itemVente = "emballageburger",
            item_required = 100,
            msg = "~r~-100 emballage de burger",

        },
        garage = {
            vehicule = {
                "nspeedo",
                "guardian",
                "tenfcustom",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(910.50921630859, -1059.6990966797, 31.928594207764),
            pointDeSpawn = {
                {pos = vector3(900.12799072266, -1057.8389892578, 31.92820892334), heading = 88.39,},
            },
        },
    },
    {
        metier = "losfume",
        metierMaj = "Los Fumé",
        washMoney = false,
        actionPatron = vector3(860.31573486328, -172.58567810059, 74.056474304199),
        vestiaire = vector3(909.64593505859, 3554.9799804688, 32.917394256592),
        coffre = vector3(840.26879882812, -181.92462158203, 73.288026428223),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2893.5620117188, 4611.7768554688, 47.147813415527),
            limit = 10,
            item = "ligada",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-323.11947631836, -1400.7059326172, 30.867738342285),
            limit = 20000,
            itemTraite = "ligada",
            item = "cigare",
            item_required = 100,
            give = 100,
            msg = "~r~-100 ligadas\n~g~+100 cigares",

        },
        vente = {
            zone = vector3(1079.0146484375, -772.08697509766, 56.977773284912),
            itemVente = "cigare",
            item_required = 100,
            msg = "~r~-100 cigares",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "mesaxl",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(848.52606201172, -190.88165283203, 71.819886779785),
            pointDeSpawn = {
                {pos = vector3(842.94165039062, -195.28631591797, 72.53694152832), heading = 147.73,},
            },
        },
    },
    {
        metier = "fastwheels",
        metierMaj = "Fast Wheels",
        washMoney = false,
        actionPatron = vector3(1159.0968017578, -1374.6085205078, 33.814023590088),
        vestiaire = vector3(909.64593505859, 3554.9799804688, 32.917394256592),
        coffre = vector3(1165.4388427734, -1347.2749023438, 35.06418762207),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1161.4477539062, -1317.3757324219, 33.842740631104),
            limit = 10,
            item = "caoutchouc",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-539.34490966797, -1677.0842285156, 18.285745239258),
            limit = 20000,
            itemTraite = "caoutchouc",
            item = "pneu",
            item_required = 100,
            give = 100,
            msg = "~r~-100 caoutchouc\n~g~+100 pneu",

        },
        vente = {
            zone = vector3(-204.16900634766, -1356.4887695312, 30.363174057007),
            itemVente = "pneu",
            item_required = 100,
            msg = "~r~-100 pneu",

        },
        garage = {
            vehicule = {
                "jogger",
                "guardian",
                "mule",
                "cliffhanger",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(1130.2084960938, -1304.5670166016, 33.841550445557),
            pointDeSpawn = {
                {pos = vector3(1130.845703125, -1297.9588623047, 34.735343933105), heading = 345.73,},
            },
        },
    },
    {
        metier = "chocolux",
        metierMaj = "Chocolux",
        washMoney = false,
        actionPatron = vector3(304.82409667969, 2820.9895019531, 42.537202453613),
        vestiaire = vector3(306.41561889648, 2896.5825195312, 42.707364654541),
        coffre = vector3(287.38558959961, 2843.6264648438, 43.804193115234),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2526.7658691406, 4355.4482421875, 38.965489959717),
            limit = 10,
            item = "cacao",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(284.04351806641, 2887.8552246094, 42.70595703125),
            limit = 20000,
            itemTraite = "cacao",
            item = "chocolate",
            item_required = 100,
            give = 100,
            msg = "~r~-100 cacao\n~g~+100 chocolat",

        },
        vente = {
            zone = vector3(1171.6658935547, -316.48132324219, 68.278466796875),
            itemVente = "chocolate",
            item_required = 100,
            msg = "~r~-100 chocolat",

        },
        garage = {
            vehicule = {
                "jogger",
                "guardian",
                "mule",
                "f340r",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(296.01327514648, 2864.3117675781, 42.742417907715),
            pointDeSpawn = {
                {pos = vector3(287.00091552734, 2861.9887695312, 43.642417907715), heading = 116.64,},
            },
        },
    },
    {
        metier = "salvora",
        metierMaj = "Salvora",
        washMoney = false,
        actionPatron = vector3(914.05718994141, -2153.7055664062, 29.594709014893),
        vestiaire = vector3(912.35272216797, -2174.283203125, 29.594722366333),
        coffre = vector3(892.37982177734, -2172.0764160156, 31.385938262939),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1523.7629394531, 1727.0832519531, 109.12621459961),
            limit = 10,
            item = "laitvache",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(845.18157958984, -2189.5705566406, 29.402616119385),
            limit = 20000,
            itemTraite = "laitvache",
            item = "fromage",
            item_required = 100,
            give = 100,
            msg = "~r~-100 lait vache\n~g~+100 fromage",

        },
        vente = {
            zone = vector3(378.91613769531, -1253.4696044922, 31.609037017822),
            itemVente = "fromage",
            item_required = 100,
            msg = "~r~-100 fromage",

        },
        garage = {
            vehicule = {
                "trager",
                "f140r",
                "sr8",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(879.91326904297, -2164.8776855469, 31.371602630615),
            pointDeSpawn = {
                {pos = vector3(878.21759033203, -2178.3913574219, 30.519554138184), heading = 174.09,},
            },
        },
    },
    {
        metier = "jnr",
        metierMaj = "JNR Product",
        washMoney = false,
        actionPatron = vector3(747.64489746094, -1805.9860839844, 28.391652679443),
        vestiaire = vector3(746.45837402344, -1766.7595214844, 28.391734695435),
        coffre = vector3(743.88079833984, -1797.4548339844, 28.391652679443),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1284.1062011719, -2559.2314453125, 43.066438293457),
            limit = 10,
            item = "nicotine",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(468.68182373047, -579.95416259766, 27.599677658081),
            limit = 20000,
            itemTraite = "nicotine",
            item = "puff",
            item_required = 100,
            give = 100,
            msg = "~r~-100 nicotine\n~g~+100 puff",

        },
        vente = {
            zone = vector3(-854.123046875, -1094.9106445312, 1.263001537323),
            itemVente = "puff",
            item_required = 100,
            msg = "~r~-100 puff",

        },
        garage = {
            vehicule = {
                "guardian",
                "mesaxl",
                "rhinehart",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(747.20483398438, -1812.2791748047, 28.391622161865),
            pointDeSpawn = {
                {pos = vector3(740.29632568359, -1817.4075927734, 29.291622161865), heading = 184.40,},
            },
        },
    },
    {
        metier = "cbdax",
        metierMaj = "CBDAX",
        washMoney = false,
        actionPatron = vector3(-281.6962890625, -2656.7033691406, 5.50997838974),
        vestiaire = vector3(-260.15646362305, -2657.076171875, 5.4427314758301),
        coffre = vector3(-293.41027832031, -2668.333984375, 5.4939366340637),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-628.345703125, 978.09332275391, 239.63959655762),
            limit = 10,
            item = "chanvre",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1189.5032958984, -3102.9992675781, 4.9467717170715),
            limit = 250,
            itemTraite = "chanvre",
            item = "cbd",
            item_required = 100,
            give = 100,
            msg = "~r~-100 chanvre\n~g~+100 cbd",

        },
        vente = {
            zone = vector3(-294.54315185547, -2691.5205078125, 5.1002956390381),
            itemVente = "cbd",
            item_required = 100,
            msg = "~r~-100 cbd",

        },
        garage = {
            vehicule = {
                "trager",
                "mule",
                "guardian",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-279.31182861328, -2648.3872070312, 5.2461553573608),
            pointDeSpawn = {
                {pos = vector3(-287.08963012695, -2646.9099121094, 6.0400452613831), heading = 44.65,},
            },
        },
    },
    {
        metier = "bucheron",
        metierMaj = "Bucheron",
        washMoney = false,
        actionPatron = vector3(-530.71990966797, 5338.3950195312, 79.362786865234),
        vestiaire = vector3(-516.94976806641, 5331.9204101562, 79.362802124023),
        coffre = vector3(-552.75030517578, 5348.5444335938, 73.843049621582),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-541.361328125, 5378.7397460938, 69.63784942627),
            limit = 10,
            item = "planche",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-508.47857666016, 5269.3671875, 79.710076904297),
            limit = 250,
            itemTraite = "planche",
            item = "bois",
            item_required = 100,
            give = 100,
            msg = "~r~-100 planche\n~g~+100 bois",

        },
        vente = {
            zone = vector3(-1656.5295410156, 3044.5983886719, 30.921666717529),
            itemVente = "bois",
            item_required = 100,
            msg = "~r~-100 bois",

        },
        garage = {
            vehicule = {
                "trager",
                "mule",
                "guardian",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-581.71276855469, 5336.1333007812, 69.314454650879),
            pointDeSpawn = {
                {pos = vector3(-576.62969970703, 5330.7373046875, 69.350633239746), heading = 158.81,},
            },
        },
    },
    {
        metier = "cooper",
        metierMaj = "Cooper Industrie",
        washMoney = false,
        actionPatron = vector3(966.42706298828, -1932.8206787109, 30.230304336548),
        vestiaire = vector3(966.82348632812, -1912.0357666016, 52.657605743408),
        coffre = vector3(974.00177001953, -1937.1184082031, 31.322526550293),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1067.8900146484, -2457.0827636719, 29.247322463989),
            limit = 10,
            item = "minéraux",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(995.19909667969, -1919.8811035156, 30.249950027466),
            limit = 250,
            itemTraite = "minéraux",
            item = "cuivre",
            item_required = 100,
            give = 100,
            msg = "~r~-100 minéraux\n~g~+100 cuivre",

        },
        vente = {
            zone = vector3(1108.9642333984, -778.35046386719, 57.362714385986),
            itemVente = "cuivre",
            item_required = 100,
            msg = "~r~-100 cuivre",

        },
        garage = {
            vehicule = {
                "trager",
                "mule",
                "guardian",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(972.05389404297, -1924.5368652344, 30.322852706909),
            pointDeSpawn = {
                {pos = vector3(973.43719482422, -1919.9282226562, 31.185060501099), heading = 89.15,},
            },
        },
    },
    {
        metier = "whitesky",
        metierMaj = "WhiteSky",
        washMoney = false,
        actionPatron = vector3(472.24505615234, -1310.6138916016, 28.320855712891),
        vestiaire = vector3(495.875, -1340.3231201172, 28.413623428345),
        coffre = vector3(480.25375366211, -1325.2518310547, 28.307496643066),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1525.8760986328, 1666.5518798828, 109.66290435791),
            limit = 10,
            item = "ligada",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(731.25964355469, -561.20819091797, 25.809648132324),
            limit = 20000,
            itemTraite = "ligada",
            item = "cigare",
            item_required = 100,
            give = 100,
            msg = "~r~-100 ligadas\n~g~+100 cigares",

        },
        vente = {
            zone = vector3(619.42486572266, -461.65716552734, 23.859845733643),
            itemVente = "cigare",
            item_required = 100,
            msg = "~r~-100 cigares",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "mesaxl",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(503.08721923828, -1340.4348144531, 28.405828094482),
            pointDeSpawn = {
                {pos = vector3(496.48092651367, -1331.6761474609, 29.336801528931), heading = 33.92,},
            },
        },
    },
    {
        metier = "cielor",
        metierMaj = "Ciel d'Or",
        washMoney = false,
        actionPatron = vector3(2569.510498, 2720.057373, 42.034479),
        coffre = vector3(2566.245605, 2726.589355, 42.324712),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(871.982544, 2342.825684, 50.787664),
            limit = 10,
            item = "pepiteor",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2627.366211, 2820.672363, 32.863592),
            limit = 20000,
            itemTraite = "pepiteor",
            item = "or",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pépite d'or\n~g~+100 or",

        },
        vente = {
            zone = vector3(2985.678223, 3494.979980, 70.481813),
            itemVente = "or",
            item_required = 100,
            msg = "~r~-100 or",

        },
        garage = {
            vehicule = {
                "guardian",
                "benson",
                "aleutianxl",
                "barracuda",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2579.959473, 2726.926270, 41.749139),
            pointDeSpawn = {
                {pos = vector3(2582.914062, 2730.718018, 42.685818), heading = 201.48420715332,},
            },
        },
    },
    {
        metier = "safeshield",
        metierMaj = "SafeShield",
        washMoney = false,
        actionPatron = vector3(2341.2946777344, 3126.2463378906, 47.308724975586),
        coffre = vector3(2348.0844726562, 3138.8706054688, 47.308724975586),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2417.6547851562, 3097.3400878906, 47.252908325195),
            limit = 10,
            item = "kevlar",
            msg = "~g~Récolte en cours...",
        },
        traitement = {
            zone = vector3(2530.3840332031, 2616.8488769531, 37.044850921631),
            limit = 20000,
            itemTraite = "kevlar",
            item = "gilet_farm",
            item_required = 100,
            give = 100,
            msg = "~r~-100 kevlar\n~g~+100 gilets",

        },
        vente = {
            zone = vector3(2465.6218261719, 1589.2254638672, 31.820310211182),
            itemVente = "gilet_farm",
            item_required = 100,
            msg = "~r~-100 gilets",
        },
        garage = {
            vehicule = {
                "nspeedo",
                "imperial",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2341.1938476562, 3138.8576660156, 47.30874786377),
            pointDeSpawn = {
                {pos = vector3(2327.9528808594, 3138.1184082031, 48.155162811279), heading = 82.39,},
            },
        },
    },
    {
        metier = "japanimport",
        metierMaj = "Japan Import",
        washMoney = false,
        actionPatron = vector3(-439.594940, -2796.492432, 7.295934),
        coffre = vector3(-448.745209, -2805.406006, 7.295936),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-453.407532, -2800.610596, 6.000384),
            limit = 10,
            item = "colisjaponais",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1243.843750, -3135.710205, 5.528237),
            limit = 20000,
            itemTraite = "colisjaponais",
            item = "pieceautomobile",
            item_required = 100,
            give = 100,
            msg = "~r~-100 colis japonais\n~g~+100 pièce automobile",

        },
        vente = {
            zone = vector3(207.218857, -1859.109497, 27.161623),
            itemVente = "pieceautomobile",
            item_required = 100,
            msg = "~r~-100 pièce automobile",

        },
        garage = {
            vehicule = {
                "guardian",
                "ssgballer_std",
                "fx3r",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-413.615784, -2799.575195, 6.003304),
            pointDeSpawn = {
                {pos = vector3(-406.509735, -2792.257568, 6.000385), heading = 82.39,},
            },
        },
    },
    {
        metier = "diamondfactory",
        metierMaj = "Diamond Factory",
        washMoney = false,
        actionPatron = vector3(-1238.248291, -337.445221, 36.333780),
        vestiaire = vector3(-1261.117432, -348.491180, 35.932531),
        coffre = vector3(-1248.029541, -342.718903, 36.305154),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1537.356934, 342.458466, 85.570764),
            limit = 10,
            item = "diamantbrut",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-420.918854, 182.660233, 79.576120),
            limit = 250,
            itemTraite = "diamantbrut",
            item = "diamanthaute",
            item_required = 100,
            give = 100,
            msg = "~r~-100 diamants bruts\n~g~+100 diamants",

        },
        vente = {
            zone = vector3(-623.339600, -211.626160, 36.827722),
            itemVente = "diamanthaute",
            item_required = 100,
            msg = "~r~-100 diamants",

        },
        garage = {
            vehicule = {
                "mvolt",
                "trager",
                "mesaxl",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1268.237061, -377.556580, 35.628595),
            pointDeSpawn = {
                {pos = vector3(-1266.032593, -381.723572, 36.366238), heading = 118.8868637085,},
            },
        },
    },
    {
        metier = "maisonsmith",
        metierMaj = "Maison Smith",
        washMoney = false,
        actionPatron = vector3(4903.269043, -4944.361328, 2.495034),
        vestiaire = vector3(4906.085938, -4943.622559, 2.475214),
        coffre = vector3(4908.543945, -4941.058105, 2.503720),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1516.831543, 1704.940674, 109.214532),
            limit = 10,
            item = "bardiere",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(4501.882324, -4547.755859, 3.127834),
            limit = 250,
            itemTraite = "bardiere",
            item = "saucisson",
            item_required = 100,
            give = 100,
            msg = "~r~-100 bardière\n~g~+100 saucissons",

        },
        vente = {
            zone = vector3(4923.575195, -4904.483887, 2.611184),
            itemVente = "saucisson",
            item_required = 100,
            msg = "~r~-100 saucissons",

        },
        garage = {
            vehicule = {
                "mule",
                "gbbisonhf",
                "sanchez",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(4934.130371, -4902.797852, 2.709779),
            pointDeSpawn = {
                {pos = vector3(4928.790527, -4898.731445, 3.596138), heading = 318.89529418945,},
            },
        },
    },
    {
        metier = "royalcafe",
        metierMaj = "Royale Café",
        washMoney = false,
        actionPatron = vector3(-883.296143, -248.592377, 38.882898),
        vestiaire = vector3(-880.296021, -249.848724, 38.886324),
        coffre = vector3(-862.927185, -254.827667, 39.138567),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(313.505402, 6484.638672, 28.525167),
            limit = 10,
            item = "cafeier",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2481.506836, 4116.296387, 37.164697),
            limit = 250,
            itemTraite = "cafeier",
            item = "coffee",
            item_required = 100,
            give = 100,
            msg = "~r~-100 cafeier\n~g~+100 café",

        },
        vente = {
            zone = vector3(-2172.5156, 4281.8896, 48.0823),
            itemVente = "coffee",
            item_required = 100,
            msg = "~r~-100 café",

        },
        garage = {
            vehicule = {
                "mule",
                "gbbisonhf",
                "sanchez",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-851.068359, -252.334869, 38.750806),
            pointDeSpawn = {
                {pos = vector3(-856.987854, -257.992523, 39.534908), heading = 151.79650878906,},
            },
        },
    },
    {
        metier = "ztcwhisky",
        metierMaj = "ZTC Whisky",
        washMoney = false,
        actionPatron = vector3(-1142.614136, -1993.225220, 12.264487),
        vestiaire = vector3(-1132.130249, -1972.082764, 12.260564),
        coffre = vector3(-1122.865845, -2012.524780, 12.288583),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1265.662720, -1903.171631, 37.601461),
            limit = 10,
            item = "orge",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1097.140991, -2234.975342, 29.345520),
            limit = 250,
            itemTraite = "orge",
            item = "whisky",
            item_required = 100,
            give = 100,
            msg = "~r~-100 orge\n~g~+100 whisky",

        },
        vente = {
            zone = vector3(-674.561890, -2390.424805, 12.975429),
            itemVente = "whisky",
            item_required = 100,
            msg = "~r~-100 whisky",

        },
        garage = {
            vehicule = {
                "mule",
                "gbbisonhf",
                "sanchez",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1120.592041, -1984.325439, 12.264847),
            pointDeSpawn = {
                {pos = vector3(-1129.137573, -1991.817017, 13.168385), heading = 222.39471435547,},
            },
        },
    },
    {
        metier = "laviedereve",
        metierMaj = "La vie de reve",
        washMoney = false,
        actionPatron = vector3(1213.265747, -1244.444580, 35.425794),
        vestiaire = vector3(1213.440186, -1251.125977, 35.325771),
        coffre = vector3(1213.597046, -1238.580688, 35.425794),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2671.529297, -673.447388, 40.233816),
            limit = 10,
            item = "cacao",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1193.849976, -1310.921509, 34.187280),
            limit = 20000,
            itemTraite = "cacao",
            item = "chocolate",
            item_required = 100,
            give = 100,
            msg = "~r~-100 cacao\n~g~+100 chocolat",

        },
        vente = {
            zone = vector3(816.006958, -754.652100, 25.827758),
            itemVente = "chocolate",
            item_required = 100,
            msg = "~r~-100 chocolat",

        },
        garage = {
            vehicule = {
                "trager",
                "fx3r",
                "sr8elem",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(1218.503540, -1235.688843, 34.432485),
            pointDeSpawn = {
                {pos = vector3(1220.459595, -1227.639526, 34.692110), heading = 274.06,},
            },
        },
    },
    {
        metier = "ordufleuve",
        metierMaj = "OR du fleuve",
        washMoney = false,
        actionPatron = vector3(1441.153320, -1669.284302, 65.745454),
        vestiaire = vector3(1432.462158, -1682.350342, 63.879129),
        coffre = vector3(1454.564087, -1651.443115, 66.094789),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-205.588104, 2979.952637, 22.946577),
            limit = 10,
            item = "pepiteor",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2682.483643, 2799.222656, 38.858053),
            limit = 20000,
            itemTraite = "pepiteor",
            item = "or",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pepite or\n~g~+100 or",

        },
        vente = {
            zone = vector3(1125.642822, -454.589722, 65.009271),
            itemVente = "or",
            item_required = 100,
            msg = "~r~-100 or",

        },
        garage = {
            vehicule = {
                "rumpo3",
                "everon",
                "SSG_Comet6",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(1454.466919, -1682.132446, 65.135530),
            pointDeSpawn = {
                {pos = vector3(1435.303223, -1676.756470, 64.463966), heading = 27.68,},
            },
        },
    },
        blips_info = {
            actionPatron = { name = "Action Patron" },
        },
    {
        metier = "pixelforge",
        metierMaj = "PixelForge",
        washMoney = false,
        actionPatron = vector3(-3100.009766, 211.862091, 14.070216),
        vestiaire = vector3(-3099.597168, 208.427429, 14.013083),
        coffre = vector3(-3089.118164, 221.303452, 14.068243),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-644.455627, -1743.283447, 23.482671),
            limit = 10,
            item = "platine",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-621.941772, -1641.346680, 24.925113),
            limit = 20000,
            itemTraite = "platine",
            item = "bijouxfarm",
            item_required = 100,
            give = 100,
            msg = "~r~-100 platine\n~g~+100 bijoux",

        },
        vente = {
            zone = vector3(-790.304260, -171.835678, 36.385759),
            itemVente = "bijouxfarm",
            item_required = 100,
            msg = "~r~-100 bijoux",

        },
        garage = {
            vehicule = {
                "imperial",
                "velocita",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-3085.256836, 217.859619, 13.092701),
            pointDeSpawn = {
                {pos = vector3(-3085.256836, 217.859619, 13.992701), heading = 155.00805664062,},
            },
        },
    },
    {
        metier = "grosargent",
        metierMaj = "Gros Argent",
        washMoney = false,
        actionPatron = vector3(864.983765, -1342.679077, 25.417783),
        vestiaire = vector3(865.018433, -1357.694580, 25.430366),
        coffre = vector3(864.643555, -1337.537109, 25.128564),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1090.684326, -2402.254150, 29.682518),
            limit = 10,
            item = "malt",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(858.223938, -1370.048950, 25.217044),
            limit = 250,
            itemTraite = "malt",
            item = "bieredequalite",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de malt\n~g~+100 bières",

        },
        vente = {
            zone = vector3(-1381.018799, -652.415222, 27.782533),
            itemVente = "bieredequalite",
            item_required = 100,
            msg = "~r~-1 caisses de bière",

        },
        garage = {
            vehicule = {
                "nspeedo",
                "ssg_ballerstd",
                "imperial",
                "bison",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(865.895081, -1350.216797, 25.437061),
            pointDeSpawn = {
                {pos = vector3(865.895081, -1350.216797, 26.337061), heading = 271.9866027832,},
            },
        },
    },
    {
        metier = "boostchampi",
        metierMaj = "Boost Champi",
        washMoney = false,
        actionPatron = vector3(-673.401367, 898.432983, 229.245544),
        vestiaire = vector3(-682.000732, 916.399292, 232.190033),
        coffre = vector3(-681.154907, 902.181458, 230.575363),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1087.708130, 2712.613037, 19.076658),
            limit = 10,
            item = "pinot",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(231.631714, 2577.701172, 44.820814),
            limit = 20000,
            itemTraite = "pinot",
            item = "champagne",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pinot\n~g~+100 champagne",

        },
        vente = {
            zone = vector3(-1219.164673, -185.181198, 38.275270),
            itemVente = "champagne",
            item_required = 100,
            msg = "~r~-100 champagne",

        },
        garage = {
            vehicule = {
                "aleutianxl",
                "guardian",
                "nspeedo",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-672.550049, 909.219666, 229.480661),
            pointDeSpawn = {
                {pos = vector3(-665.907593, 913.100220, 229.738785), heading = 229.0617980957,},
            },
        },
    },
    {
        metier = "lsdiamond",
        metierMaj = "LS Diamond",
        washMoney = false,
        actionPatron = vector3(-774.41021728516, -188.41732788086, 36.383668518066),
        vestiaire = vector3(-758.058105, -231.027237, 36.383669),
        coffre = vector3(-759.403564, -209.704956, 36.372007),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-597.795349, 2093.709717, 130.449106),
            limit = 10,
            item = "diamantbrut",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-127.728691, 1925.090698, 196.327127),
            limit = 250,
            itemTraite = "diamantbrut",
            item = "diamanthaute",
            item_required = 100,
            give = 100,
            msg = "~r~-100 diamants bruts\n~g~+100 diamants",

        },
        vente = {
            zone = vector3(-787.050964, -176.153854, 36.383669),
            itemVente = "diamanthaute",
            item_required = 100,
            msg = "~r~-100 diamants",

        },
        garage = {
            vehicule = {
                "burrito2",
                "guardian",
                "Italirsx",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-774.75622558594, -199.98002624512, 36.383668518066),
            pointDeSpawn = {
                {pos = vector3(-778.710083, -201.153381, 37.283691), heading = 29.607950210571,},
            },
        },
    },
    {
        metier = "mogodiamant",
        metierMaj = "Mogo Diamants",
        washMoney = false,
        actionPatron = vector3(-701.237549, -305.089294, 35.783838),
        vestiaire = vector3(-689.206909, -309.612854, 35.317335),
        coffre = vector3(-711.438232, -301.340576, 36.074949),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1530.312256, 1378.006958, 124.256067),
            limit = 10,
            item = "diamantbrut",
            msg = "~g~Récolte en cours...",
        },
        traitement = {
            zone = vector3(-1489.997925, -204.609039, 49.497346),
            limit = 250,
            itemTraite = "diamantbrut",
            item = "diamanthaute",
            item_required = 100,
            give = 100,
            msg = "~r~-100 diamants bruts\n~g~+100 diamants",

        },
        vente = {
            zone = vector3(-603.416992, -240.003799, 35.656713),
            itemVente = "diamanthaute",
            item_required = 100,
            msg = "~r~-100 diamants",

        },
        garage = {
            vehicule = {
                "burrito2",
                "guardian",
                "trager",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-717.965271, -298.682465, 36.053632),
            pointDeSpawn = {
                {pos = vector3(-721.916077, -292.193176, 36.948250), heading = 47.179927825928,},
            },
        },
    },
    {
        metier = "dulex",
        metierMaj = "Dulex",
        washMoney = false,
        actionPatron = vector3(-55.607491, 6392.996582, 30.590343),
        vestiaire = vector3(-58.592316, 6363.661621, 30.590362),
        coffre = vector3(-70.011551, 6385.516602, 30.590362),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-714.565125, 5661.167969, 27.648326),
            limit = 10,
            item = "latex",
            msg = "~g~Récolte en cours...",
        },
        traitement = {
            zone = vector3(-2222.083496, 4231.353027, 46.215032),
            limit = 20000,
            itemTraite = "latex",
            item = "preservatif",
            item_required = 100,
            give = 100,
            msg = "~r~-100 latex\n~g~+100 preservatif",
        },
        vente = {
            zone = vector3(808.000732, 6962.742676, 23.970869),
            itemVente = "preservatif",
            item_required = 100,
            msg = "~r~-100 preservatif",
        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-52.406330, 6396.060547, 30.590389),
            pointDeSpawn = {
                {pos = vector3(-58.096478, 6402.490234, 31.490353), heading = 309.15866088867,},
            },
        },
    },
    {
        metier = "orerable",
        metierMaj = "Or d'érable",
        washMoney = false,
        actionPatron = vector3(58.996666, 6332.996094, 30.473816),
        vestiaire = vector3(109.000740, 6325.175293, 30.488197),
        coffre = vector3(90.757996, 6340.377441, 30.475874),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(263.247223, 6461.472168, 30.286447),
            limit = 10,
            item = "seve",
            msg = "~g~Récolte en cours...",
        },
        traitement = {
            zone = vector3(-2168.532715, 4279.838867, 48.055723),
            limit = 20000,
            itemTraite = "seve",
            item = "siroperable",
            item_required = 100,
            give = 100,
            msg = "~r~-100 sève\n~g~+100 sirop",
        },
        vente = {
            zone = vector3(-195.445099, 6269.847656, 30.592006),
            itemVente = "siroperable",
            item_required = 100,
            msg = "~r~-100 sirop",
        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(93.292572, 6334.688477, 30.575874),
            pointDeSpawn = {
                {pos = vector3(78.265160, 6326.775879, 31.225706), heading = 30.792617797852,},
            },
        },
    },
    {
        metier = "suntabac",
        metierMaj = "Sunlife Tabac",
        washMoney = false,
        actionPatron = vector3(162.555542, -1809.555908, 27.843305),
        vestiaire = vector3(2898.045, 4415.087, 7557.38563),
        coffre = vector3(170.125778, -1799.381836, 27.515592),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(440.535553, 863.626404, 196.166803),
            limit = 10,
            item = "tabacbrun",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-1176.475098, -1374.983032, 4.050217),
            limit = 250,
            itemTraite = "tabacbrun",
            item = "cigarette",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de tabac brun\n~g~+100g tabac séché",

        },
        vente = {
            zone = vector3(-368.986328, 184.952133, 79.348856),
            itemVente = "cigarette",
            item_required = 100,
            msg = "~r~-100 caisses de cigarettes",

        },
        garage = {
            vehicule = {
                "guardian",
                "kamacho",
                "thrax",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(174.063110, -1803.528320, 28.477354),
            pointDeSpawn = {
                {pos = vector3(178.898132, -1809.500122, 29.076504), heading = 322.81,},
            },
        },
    },
    {
        metier = "farmtech",
        metierMaj = "FarmTech",
        washMoney = false,
        actionPatron = vector3(956.122681, -2176.572998, 30.251810),
        vestiaire = vector3(939.674072, -2198.129150, 29.651170),
        coffre = vector3(960.653809, -2185.304199, 29.594446),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2836.818115, 1459.911377, 24.561684),
            limit = 10,
            item = "fer",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1715.673340, -1468.717651, 112.936066),
            limit = 20000,
            itemTraite = "fer",
            item = "acier",
            item_required = 100,
            give = 100,
            msg = "~r~-100 fer\n~g~+100 acier",

        },
        vente = {
            zone = vector3(940.904419, -2164.754150, 30.539267),
            itemVente = "acier",
            item_required = 100,
            msg = "~r~-100 acier",

        },
        garage = {
            vehicule = {
                "scout",
                "nspeedo",
                "argento",
                "mule",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(947.470886, -2197.302002, 30.551569),
            pointDeSpawn = {
                {pos = vector3(945.014587, -2186.122070, 30.561504), heading = 118.59,},
            },
        },
    },
    {
        metier = "viticole",
        metierMaj = "Domaine Viticole",
        washMoney = false,
        actionPatron = vector3(-1875.63, 2060.94, 145.57),
        vestiaire = vector3(-1862.53, 2054.63, 134.46),
        coffre = vector3(-1926.667969, 2041.546265, 139.931848),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-1846.62, 2152.94, 116.75),
            limit = 10,
            item = "raisin",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-53.32, 1903.09, 194.46),
            limit = 250,
            itemTraite = "raisin",
            item = "vine",
            item_required = 100,
            give = 100,
            msg = "~r~-100 raisin\n~g~+100 vin",

        },
        vente = {
            zone = vector3(151.46, -1338.64, 28.2),
            itemVente = "vine",
            item_required = 100,
            msg = "~r~-100 caisses de vin",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-1923.51, 2047.67, 139.83),
            pointDeSpawn = {
                {pos = vector3(-1922.98, 2040.66, 140.73), heading = 260.03,},
            },
        },
    },
    {
        metier = "plushtatalou",
        metierMaj = "FamigilaPlush Del Tata Lou",
        washMoney = false,
        actionPatron = vector3(732.942749, 2523.421143, 72.323816),
        vestiaire = vector3(-1862.53, 2054.63, 533.46),
        coffre = vector3(730.500061, 2531.926270, 72.325342),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(739.932007, 2578.428711, 74.539095),
            limit = 10,
            item = "tissu",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(951.480408, 3611.245605, 31.840822),
            limit = 250,
            itemTraite = "tissu",
            item = "plushtatalou",
            item_required = 100,
            give = 100,
            msg = "~r~-100 tissu\n~g~+100 plush",

        },
        vente = {
            zone = vector3(639.184326, 2775.627197, 41.073022),
            itemVente = "plushtatalou",
            item_required = 100,
            msg = "~r~-100 plush",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(738.940308, 2523.304199, 72.284059),
            pointDeSpawn = {
                {pos = vector3(746.588745, 2522.538818, 73.193031), heading = 182.00,},
            },
        },
    },
    {
        metier = "redwood",
        metierMaj = "Redwood",
        washMoney = false,
        actionPatron = vector3(2899.841309, 4398.836426, 49.636312),
        vestiaire = vector3(2855.850342, 4445.889648, 47.639803),
        coffre = vector3(2890.272217, 4391.638184, 49.851060),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2245.302002, 5034.581055, 43.532098),
            limit = 10,
            item = "tabacbrun",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2898.236816, 4371.247070, 49.891325),
            limit = 250,
            itemTraite = "tabacbrun",
            item = "cigarette",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de tabac brun\n~g~+100g tabac séché",

        },
        vente = {
            zone = vector3(191.550629, 2786.708496, 44.964998),
            itemVente = "cigarette",
            item_required = 100,
            msg = "~r~-100 caisses de cigarettes",
        },
        garage = {
            vehicule = {
                "nspeedo",
                "guardian",
                "kamacho",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2919.913330, 4374.012695, 49.638536),
            pointDeSpawn = {
                {pos = vector3(2918.071777, 4380.198242, 50.353176), heading = 300.40631103516,},
            },
        },
    },
    {
        metier = "vignobledelperro",
        metierMaj = "Vignoble Del Perro",
        washMoney = false,
        actionPatron = vector3(-2090.060547, 7149.333984, 27.971151),
        vestiaire = vector3(-2097.825195, 7153.707520, 32.071077),
        coffre = vector3(-2108.197754, 7147.344238, 28.574840),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(-2341.084229, 7453.693359, 29.522766),
            limit = 10,
            item = "raisin",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(-2091.275146, 7117.147949, 27.699522),
            limit = 250,
            itemTraite = "raisin",
            item = "vine",
            item_required = 100,
            give = 100,
            msg = "~r~-100 raisin\n~g~+100 vin",

        },
        vente = {
            zone = vector3(-2935.270752, 6280.342285, 11.674719),
            itemVente = "vine",
            item_required = 100,
            msg = "~r~-100 caisses de vin",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(-2094.283447, 7163.934082, 28.001516),
            pointDeSpawn = {
                {pos = vector3(-2097.215820, 7168.242676, 29.109606), heading = 72.03,},
            },
        },
    },
    {
        metier = "goldenfry",
        metierMaj = "Golden Fry",
        washMoney = false,
        actionPatron = vector3(2565.044678, 4644.388672, 33.176790),
        vestiaire = vector3(2555.517334, 4651.600098, 33.176790),
        coffre = vector3(2554.173096, 4668.056641, 33.128469),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2528.973389, 4357.584961, 39.365785),
            limit = 10,
            item = "patate",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2620.351807, 4628.759766, 33.201196),
            limit = 250,
            itemTraite = "patate",
            item = "patatelavee",
            item_required = 100,
            give = 100,
            msg = "~r~-100 patate\n~g~+100 patates lavées",

        },
        vente = {
            zone = vector3(-78.334602, 6537.103027, 30.590803),
            itemVente = "patatelavee",
            item_required = 100,
            msg = "~r~-100 patates lavées",

        },
        garage = {
            vehicule = {
                "guardian",
                "nspeedo",
                "trager",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2560.871338, 4673.382812, 33.176824),
            pointDeSpawn = {
                {pos = vector3(2555.260986, 4677.887207, 33.951618), heading = 21.19,},
            },
        },
    },
    {
        metier = "brasseriedeschamps",
        metierMaj = "Brasserie des champs",
        washMoney = false,
        actionPatron = vector3(818.495239, -1396.368042, 25.413650),
        vestiaire = vector3(818.351440, -1374.771362, 25.408197),
        coffre = vector3(838.143921, -1396.466309, 25.410892),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(1451.262695, -1688.589844, 65.426225),
            limit = 10,
            item = "malt",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(1052.608643, -2366.655762, 29.689098),
            limit = 250,
            itemTraite = "malt",
            item = "bieredequalite",
            item_required = 100,
            give = 100,
            msg = "~r~-100g de malt\n~g~+100 bières",

        },
        vente = {
            zone = vector3(824.349792, -1072.378662, 27.273225),
            itemVente = "bieredequalite",
            item_required = 100,
            msg = "~r~-1 caisses de bière",

        },
        garage = {
            vehicule = {
                "trager",
                "guardian",
                "toros",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(838.009155, -1374.899902, 26.308636),
            pointDeSpawn = {
                {pos = vector3(832.596863, -1368.139282, 26.132908), heading = 1.21,},
            },
        },
    },
    {
        metier = "duroymining",
        metierMaj = "Duroy Mining",
        washMoney = false,
        actionPatron = vector3(2834.716064, 2806.964844, 57.401669),
        vestiaire = vector3(2952.846191, 2742.501465, 43.657120),
        coffre = vector3(2832.136963, 2799.929443, 56.610666),
        coffrePatron = true,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone = vector3(2941.081055, 2793.781738, 39.582693),
            limit = 10,
            item = "pepiteor",
            msg = "~g~Récolte en cours...",

        },
        traitement = {
            zone = vector3(2556.796875, 2740.709961, 41.891946),
            limit = 250,
            itemTraite = "pepiteor",
            item = "or",
            item_required = 100,
            give = 100,
            msg = "~r~-100 pépites d'or\n~g~+100 or",

        },
        vente = {
            zone = vector3(-793.135437, -175.792496, 36.383669),
            itemVente = "or",
            item_required = 100,
            msg = "~r~-100 or",

        },
        garage = {
            vehicule = {
                "nspeedo",
                "mesaxl",
            },
            xenon = true,
            fullCustom = true,
            color1 = 0,
            color2 = 0,
            garagePos = vector3(2823.650146, 2798.614258, 56.672197),
            pointDeSpawn = {
                {pos = vector3(2827.814941, 2797.877441, 57.654934), heading = 177.97,},
            },
        },
    },
}
