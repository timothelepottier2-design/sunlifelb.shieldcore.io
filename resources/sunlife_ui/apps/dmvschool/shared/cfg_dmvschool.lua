cfg_dmvschool = {

    dstInteract = 4.0,

    spawnDistance = 30.0,

    peds = {
        ["car"] = {
            pos      = vector4(232.830627, 368.956390, 106.099197, 159.3473815918),
            model    = "s_m_m_movprem_01",
            label    = "Josh — Permis voiture",
            blipName = "Auto-école (voiture)",
        },
        ["plane"] = {
            pos      = vector4(-1154.779663, -2715.027832, 19.887335, 297.13824462891),
            model    = "s_m_m_pilot_01",
            label    = "Instructeur — Permis avion (PPL)",
            blipName = "École de pilotage (PPL)",
        },
        ["boat"] = {
            pos      = vector4(-712.149292, -1298.740234, 5.105102, 50.354961395264),
            model    = "s_m_y_dockwork_01",
            label    = "Instructeur — Permis bateau (côtier)",
            blipName = "École nautique (côtier)",
        },
    },

    ped = {
        pos = vector4(232.830627, 368.956390, 106.099197, 159.3473815918),
        dstInteract = 4.0,
        model = "s_m_m_movprem_01",
        label = "Josh auto-école",
    },

    categories = {
        ["car"] = {
            label = "Voiture",
            nameItem = "permisauto",
            codePrice = 500,
            drivePrice = 1500,

            rebuyPrice = 750,
            driveVehicle = "npdsblista",
            driveSpawnPos = {x = 217.12, y = 382.65, z = 106.64, a = 167.0},
            questions = {
                {
                    imageUrl = "https://i.ibb.co/9Pm56b4/Question-1.png",
                    question = "Que devez-vous faire si un feu est rouge ?",
                    answers = {
                        "Accélérer pour passer",
                        "S'arrêter avant la ligne",
                        "Klaxonner et passer",
                        "Continuer si personne n'arrive"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/VWTs2z8V/Question-2.png",
                    question = "Que signifie un panneau STOP ?",
                    answers = {
                        "Ralentir légèrement",
                        "S'arrêter complètement",
                        "Passer rapidement",
                        "Céder le passage uniquement"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/HfQc3L5f/Question-3.png",
                    question = "Vous voyez un piéton traverser, que faites-vous ?",
                    answers = {
                        "Klaxonner pour l’avertir",
                        "Le contourner par la gauche",
                        "Accélérer pour passer avant",
                        "Le laisser passer"
                    },
                    correctAnswer = 4,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/C3S0GfXC/Question-4.png",
                    question = "Quelle est la vitesse maximale en ville ?",
                    answers = {
                        "50 km/h",
                        "80 km/h",
                        "90 km/h",
                        "120 km/h"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/4ZB3vSDw/Question-5.png",
                    question = "Si votre véhicule est en panne au milieu de la route, que devez-vous faire ?",
                    answers = {
                        "Laisser le véhicule et partir",
                        "Appeler un dépanneur",
                        "Attendre qu'il redémarre tout seul",
                        "Le pousser jusqu'à un garage"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/Fq5VkqNN/Question-6.png",
                    question = "Une voiture de police active ses sirènes derrière vous, que faites-vous ?",
                    answers = {
                        "Accélérer pour ne pas gêner",
                        "Rester au milieu de la route",
                        "Vous ranger sur le côté",
                        "Freiner brusquement"
                    },
                    correctAnswer = 3,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/Y77N72DZ/Question-7.png",
                    question = "À un carrefour sans panneau, qui passe en premier ?",
                    answers = {
                        "Celui qui vient de la droite",
                        "Celui qui vient de la gauche",
                        "Celui qui arrive le plus vite",
                        "Celui qui klaxonne"
                    },
                    correctAnswer = 1,
                    time = 30
                }
            },
            drive = {
                {
                    pos = vector3(212.42559814453, 362.06799316406, 106.0754776001),

                    freeze = 3500,
                    message = "Faites attention à la priorité en sortant du parking !",

                    maxSpeed = 60,
                },
                {
                    pos = vector3(76.59156036377, 328.85437011719, 112.23633575439),

                    freeze = 3500,
                    message = "Prenez garde au panneau STOP",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(36.094131469727, 279.31948852539, 109.53572845459),

                    freeze = nil,
                    message = "Continuez votre route en tenant la limite de vitesse fixée à 80km/h",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(-125.22867584229, 261.83978271484, 96.273323059082),

                    freeze = nil,
                    message = "Continuez votre route en tenant la limite de vitesse fixée à 80km/h",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(-199.88677978516, 261.61517333984, 92.150657653809),

                    freeze = nil,
                    message = "Continuez votre route en tenant la limite de vitesse fixée à 80km/h",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(-228.35781860352, 145.81707763672, 70.286407470703),

                    freeze = nil,
                    message = "Prenez compte du feu si il est rouge ou non pour marquer l'arrêt",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(-250.21266174316, -22.17449760437, 49.591312408447),

                    freeze = 3500,
                    message = "Régime de priorité à droite à prendre en compte",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(-103.74583435059, -106.6717376709, 57.633457183838),

                    freeze = 1000,
                    message = "Prenez compte du feu si il est rouge ou non pour marquer l'arrêt",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(50.487327575684, -156.0677947998, 55.142417907715),

                    freeze = 3500,
                    message = "Régime de priorité à droite à prendre en compte",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(122.81114959717, -43.290920257568, 67.501167297363),

                    freeze = 3500,
                    message = "Prenez garde au panneau STOP",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(260.93411254883, -79.038131713867, 70.038986206055),

                    freeze = nil,
                    message = "Continuez votre route",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(355.82803344727, 108.80686950684, 102.72936248779),

                    freeze = 1000,
                    message = "Prenez garde au panneau STOP",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(412.42010498047, 278.16201782227, 103.07130432129),

                    freeze = 1000,
                    message = "Régime de priorité à droite à prendre en compte",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(277.92819213867, 336.86083984375, 105.53247070312),

                    freeze = 1000,
                    message = "Prenez garde au panneau STOP et allez vous garer à l'auto-école",

                    maxSpeed = 80,
                },
                {
                    pos = vector3(216.13282775879, 372.15536499023, 106.37260437012),

                    freeze = 0,
                    message = "Fin du test de conduite, calcul des erreurs...",

                    maxSpeed = 80,
                },
            }
        },

        ["plane"] = {
            label = "Avion",
            nameItem = "permisaircraft",
            codePrice = 1000,
            drivePrice = 5000,
            rebuyPrice = 2500,
            -- velum2 est blacklist dans antisbire (VEH_GUARD.Blacklist) et la
            -- blacklist est testee AVANT l'autorisation serveur -> l'avion etait
            -- supprime des sa creation. velum (concession aerien) est autorise.
            driveVehicle = "velum",
            driveSpawnPos = {x = -1248.0, y = -3335.0, z = 13.0, a = 330.0},
            questions = {
                {
                    imageUrl = "https://i.ibb.co/cSDH4Wpd/Question-1.png",
                    question = "Quelle est la première étape avant de décoller avec un avion ?",
                    answers = {
                        "Allumer les feux de position et vérifier les instruments",
                        "Monter directement dans l’avion et décoller",
                        "Mettre la radio à fond pour l’ambiance",
                        "Appeler la tour de contrôle pour commander un café"
                    },
                    correctAnswer = 1,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/xKhJ9N6q/Question-2.png",
                    question = "À quoi sert une piste d’atterrissage ?",
                    answers = {
                        "À faire décoller et atterrir les avions",
                        "À garer les voitures",
                        "À décorer l’aéroport",
                        "À organiser des courses de motos"
                    },
                    correctAnswer = 1,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/207n4Zbz/Question-3.png",
                    question = "À quoi sert le transpondeur d’un avion ?",
                    answers = {
                        "Diffuser de la musique en vol",
                        "Identifier l’appareil auprès du contrôle aérien",
                        "Faire clignoter les phares pour les autres joueurs",
                        "Booster la vitesse de l’avion comme un turbo"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/TDf7351g/Question-4.png",
                    question = "En cas de panne moteur en vol, quelle est la bonne réaction ?",
                    answers = {
                        "Crier et sauter de l’avion",
                        "Appeler le mécano",
                        "Garder son calme et tenter un atterrissage d’urgence",
                        "Redémarrer l'avion"
                    },
                    correctAnswer = 3,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/rG5Y3qXt/Question-5.png",
                    question = "Dans un aéroport, où doit-on circuler avec son avion avant le décollage ?",
                    answers = {
                        "Sur la piste d’atterrissage en marche arrière",
                        "Directement dans les airs, pas besoin de piste",
                        "Dans le parking des voitures",
                        "Sur les voies de roulage (taxiways)"
                    },
                    correctAnswer = 4,
                    time = 30
                },
            },
            drive = {
                {
                    pos = vector3(-1286.6318359375, -3172.2333984375, 13.686752891541),

                    freeze = 3500,
                    message = "Dirigez-vous vers la piste de décollage",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1647.5080566406, -2964.1433105469, 47.491887664795),

                    freeze = nil,
                    message = "Vous êtes autorisé au décollage, dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-2310.7204589844, -2589.0932617188, 182.47118530273),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-2662.3513183594, -2846.9167480469, 224.2852722168),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-2241.3454589844, -3488.9282226562, 216.9159942627),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1565.1640625, -3829.0200195312, 200.54818115234),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-759.17736816406, -4176.1977539062, 117.71598968506),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-313.48745727539, -4046.1860351562, 77.086213684082),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-725.96862792969, -3495.4162597656, 41.912522888184),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1100.6976318359, -3279.3422851562, 13.675206756592),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1242.8579101562, -3196.8735351562, 13.680995559692),

                    freeze = nil,
                    message = "Atterissage autorisé !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1342.0849609375, -3176.5302734375, 13.684012031555),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
                {
                    pos = vector3(-1376.2523193359, -3235.5390625, 13.683983421326),

                    freeze = nil,
                    message = "Dirigez-vous vers le prochain point !",

                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,

                    maxSpeed = 300,
                },
            }
        },

        ["boat"] = {
            label = "Bateau",
            nameItem = "permisbateau",
            codePrice = 800,
            drivePrice = 3000,
            rebuyPrice = 1500,
            driveVehicle = "dinghy",
            driveSpawnPos = {x = -751.0, y = -1379.0, z = 0.2, a = 180.0},
            questions = {
                {
                    imageUrl = "https://i.ibb.co/6cfp8PgN/Question-1.png",
                    question = "Avant de quitter le port, que doit faire le capitaine ?",
                    answers = {
                        "Klaxonner trois fois pour prévenir",
                        "Vérifier qu’il a du carburant et que le moteur fonctionne",
                        "Demander au vendeur de poissons la permission",
                        "Mettre la musique à fond sur le yacht"
                    },
                    correctAnswer = 2,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/Y7c3cG6J/Question-2.png",
                    question = "Quelle est la règle de priorité en mer ?",
                    answers = {
                        "Le plus gros bateau a toujours la priorité",
                        "Celui qui va le plus vite passe en premier",
                        "Les bateaux à voile ont priorité sur les bateaux à moteur",
                        "C’est à celui qui crie le plus fort d’avoir la priorité"
                    },
                    correctAnswer = 3,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/MxQY1FKt/Question-3.png",
                    question = "Que doit-on toujours avoir à bord d’un bateau ?",
                    answers = {
                        "Une caisse de champagne",
                        "Un parachute",
                        "Des gilets de sauvetage",
                        "Un extincteur pour les poissons"
                    },
                    correctAnswer = 3,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/G3n7MTm6/Question-4.png",
                    question = "En cas de brouillard, que doit faire le pilote du bateau ?",
                    answers = {
                        "Accélérer pour sortir du brouillard plus vite",
                        "Couper le moteur et attendre que ça passe",
                        "Utiliser le klaxon en continu",
                        "Mettre les feux et réduire la vitesse"
                    },
                    correctAnswer = 4,
                    time = 30
                },
                {
                    imageUrl = "https://i.ibb.co/Rph78w17/Question-5.png",
                    question = "Où est-il interdit de naviguer avec un bateau ?",
                    answers = {
                        "Dans les zones de baignade",
                        "À l’intérieur du commissariat",
                        "Dans les airs",
                        "Sur les routes"
                    },
                    correctAnswer = 1,
                    time = 30
                },
            },
            drive = {
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-751.02398681641, -1379.8958740234, 0.11780068278313), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-787.0829, -1423.5476, -0.5685), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-824.7780, -1461.2562, -0.5644), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-868.1689, -1566.9301, -0.5935), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1036.3783, -1737.1748, -0.5498), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1218.4122, -1916.0828, -0.6094), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1444.2313, -2068.0303, -0.5081), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1712.2368, -2281.8254, -0.7031), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1962.1141, -2576.0640, -1.2863), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-2312.3000, -2494.2002, -0.7993), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-2744.8831, -2164.9790, -1.0643), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-2451.3079, -1790.1796, -0.9288), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-2077.6582, -1557.8888, -0.4509), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1692.8433, -1677.5653, -0.9752), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1451.5298, -1849.5697, -0.3396), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1350.6730, -1938.4805, -1.3476), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1264.5834, -1954.4896, -0.6255), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-1104.7245, -1801.7377, -0.6455), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-872.7456, -1567.1460, -0.7046), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-812.2610, -1445.0616, -0.7185), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
                {
                    markerScale = {x = 10.0, y = 10.0, z = 10.0},
                    radius = 25.0,
                    pos = vector3(-711.0381, -1335.4469, -0.6163), freeze = nil, message = "Dirigez-vous vers le prochain point !", maxSpeed = 200 },
            }
        }
    }
}
