CFG_DRUGS = {
    sellPriceMultiplier = 0.8,

    laboratoires = {
        ["weed"] = {
            name = "Laboratoire de weed",
            label = "Weed",
            itemgive = "weed_pooch",
            instanceLevel = 2932822,
            entry = vector3(448.642578, -1786.435791, 28.592466),
            heading = 230.20555114746,
            recolte = vector3(1058.41, -3202.87, -39.05),
            traitement = vector3(1038.38, -3205.85, -38.12),
            exit = vector3(1066.13, -3183.46, -40.10)
        },
        ["coke"] = {
            name = "Laboratoire de coke",
            label = "Coke",
            itemgive = "coke_pooch",
            instanceLevel = 2932823,
            entry = vector3(-458.368866, -2274.730225, 8.515829),
            heading = 90.143112182617,
            recolte = vector3(1092.898, -3197.017, -38.99341),
            traitement = vector3(1099.706, -3194.345, -38.99343),
            exit = vector3(1088.724, -3188.174, -39.99343)
        },
        ["heroine"] = {
            name = "Laboratoire d'héroine",
            label = "Heroine",
            itemgive = "heroine_pooch",
            instanceLevel = 2932824,
            entry = vector3(3725.414551, 4525.196289, 21.570493),
            heading = 343.2473449707,
            recolte = vector3(1092.898, -3197.017, -38.99341),
            traitement = vector3(1099.706, -3194.345, -38.99343),
            exit = vector3(1088.724, -3188.174, -39.99343)
        },
        ["meth"] = {
            name = "Laboratoire de meth",
            label = "Meth",
            itemgive = "meth_pooch",
            instanceLevel = 2932824,
            entry = vector3(859.068909, 2876.948242, 57.982647),
            heading = 5.8715372085571,
            recolte = vector3(1016.941, -3195.9, -38.99311),
            traitement = vector3(1007.857, -3195.181, -38.99311),
            exit = vector3(997.665, -3200.759, -37.35363)
        },
        ["opium"] = {
            name = "Laboratoire d'opium",
            label = "Opium",
            itemgive = "opium_pooch",
            instanceLevel = 2932825,
            entry = vector3(-957.689819, -1566.998535, 4.119041),
            recolte = vector3(1092.898, -3197.017, -38.99341),
            traitement = vector3(1099.706, -3194.345, -38.99343),
            exit = vector3(1088.724, -3188.174, -39.89343)
        },
        ["ketamine"] = {
            name = "Laboratoire de kétamine",
            label = "Kétamine",
            itemgive = "ketamine_pooch",
            instanceLevel = 2932826,
            entry = vector3(7178.790527, -604.660278, 60.050550),
            heading = 84.434753417969,
            recolte = vector3(1092.898, -3197.017, -38.99341),
            traitement = vector3(1099.706, -3194.345, -38.99343),
            exit = vector3(1088.724, -3188.174, -39.89343)
        },
    },

    points = {
        ["badweed_pooch"] = {
            name = "Point de weed de mauvaise qualité",
            label = "Weed de mauvaise qualité",
            itemgive = "badweed_pooch",
            recolte = vector3(-1260.8927, 4486.6260, 9.5028),
            traitement = vector3(-1260.6360, 4493.3779, 9.5028),
            markerInfo = vector3(-1260.8927, 4486.6260, 9.5028),
            markerMessage = "Culture de ~o~weed~s~\nOuvert aux indépendants\nQualité: ~r~Mauvaise",
            public = true,
            blip = 140,
            color = 2,
            scale = 0.5
        },
        ["badcoke_pooch"] = {
            name = "Point de coke de mauvaise qualité",
            label = "Coke",
            itemgive = "badcoke_pooch",
            recolte = vector3(126.5535, -3075.32, 5.940014),
            traitement = vector3(121.6784, -3083.004, 6.002439),
            markerInfo = vector3(126.9008, -3081.988, 5.931577),
            markerMessage = "Repère de la ~p~coke~s~\nOuvert aux indépendants\nQualité: ~r~Mauvaise",
            public = false,
            blip = 0,
            color = 0,
            scale = 0.5
        },
        ["badheroine_pooch"] = {
            name = "Point d'héroine de mauvaise qualité",
            label = "Heroine",
            itemgive = "badheroine_pooch",
            recolte = vector3(1394.337, 3602.429, 38.94196),
            traitement = vector3(1388.585, 3605.431, 38.94188),
            markerInfo = vector3(1391.745, 3613.55, 38.97193),
            markerMessage = "Repère de ~y~l'héroine~s~\nOuvert aux indépendants\nQualité: ~r~Mauvaise",
            public = false,
            blip = 0,
            color = 0,
            scale = 0.5
        },
        ["fentanyl_pooch"] = {
            name = "Point de fentanyl",
            label = "Fentanyl",
            itemgive = "fentanyl_pooch",
            recolte = vector3(1444.639893, 6334.288086, 23.838055),
            traitement = vector3(1441.631836, 6332.592773, 23.931482),
            markerInfo = vector3(1443.135864, 6333.440430, 23.884769),
            markerMessage = "Repère du ~p~fentanyl~s~\nOuvert à tous\nQualité: ~g~Bonne",
            public = true,
            blip = 211,
            color = 1,
            scale = 0.8
        },
    },

    drugstosell = {
        ["dealer1"] = {
            items = {
                {name = "Crack", item = "crack_pooch", price = 500},
                {name = "LSD", item = "lsd_pooch", price = 600},
                {name = "Ecstasy", item = "ecstasy_pooch", price = 800},
                {name = "Weed Green", item = "weed_green", price = 1500},
                {name = "Weed Blue", item = "weed_blu", price = 2000},
                {name = "Weed Purple", item = "weed_purp", price = 2500}
            },
            coords = vector3(-3056.537, 443.4923, 5.411704)
        },
        ["dealer2"] = {
            items = {
                {name = "Weed de mauvaise qualité", item = "badweed_pooch", price = 1100},
                {name = "Coke de mauvaise qualité", item = "badcoke_pooch", price = 1400},
                {name = "Héroine de mauvaise qualité", item = "badheroine_pooch", price = 1900},
                {name = "Weed Green", item = "weed_green", price = 1500},
                {name = "Weed Blue", item = "weed_blu", price = 2000},
                {name = "Weed Purple", item = "weed_purp", price = 2500}
            },
            coords = vector3(1958.592, 3821.028, 31.3535)
        },
        ["dealer3"] = {
            items = {
                {name = "Weed", item = "weed_pooch", price = 1550},
                {name = "Coke", item = "coke_pooch", price = 1800},
                {name = "Héroine", item = "heroine_pooch", price = 2000},
                {name = "Opium", item = "opium_pooch", price = 2300},
                {name = "Meth", item = "meth_pooch", price = 2300},
                {name = "Kétamine", item = "ketamine_pooch", price = 2700},
                {name = "Fentanyl", item = "fentanyl_pooch", price = 2450}
            },
            coords = vector3(5195.379, -5134.896, 2.400856)
        },
    }
}
