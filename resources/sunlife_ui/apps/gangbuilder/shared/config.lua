GangConfig = {}

GangConfig.Command = "gangb"
GangConfig.PropsCommand = "propsgang"
GangConfig.PropsMaxPerGang = 20
GangConfig.PropsMaxDistanceFromHQ = 100.0
GangConfig.PropsStaffClearCommand = "clearprops"
GangConfig.PropsStaffClearRadius = 50.0

GangConfig.PropsModels = {
    { label = "Barrière de chantier", model = "prop_barrier_work01a" },
    { label = "Barrière", model = "prop_barrier_work06a" },
    { label = "Cône", model = "prop_roadcone02a" },
    { label = "Cône (grand)", model = "prop_roadcone02b" },
    { label = "Panneau stop", model = "prop_roadpole_01a" },
    { label = "Poteau", model = "prop_mp_cone_01" },
    { label = "Caisse en bois", model = "prop_box_wood01a" },
    { label = "Caisse", model = "prop_box_ammo01a" },
    { label = "Palette", model = "prop_pallet_01a" },
    { label = "Baril", model = "prop_barrel_01a" },
    { label = "Sac de sable", model = "prop_sandbag_01" },
    { label = "Grille", model = "prop_fnclink_03e" },
    { label = "Barrière métal", model = "prop_mp_barrier_02" },
    { label = "Luminaire", model = "prop_streetlight_01" },
    { label = "Poubelle", model = "prop_bin_01a" },
    { label = "Chaise pliante", model = "prop_chair_01a" },
    { label = "Table", model = "prop_table_01" },
    { label = "Parasol", model = "prop_parasol_01" },
    { label = "Feux tricolores", model = "prop_traffic_01a" },
    { label = "Panneau affichage", model = "prop_news_disp_02a" },
    { label = "Chaise", model = "bkr_prop_weed_chair_01a"},
    { label = "Sac pour arme", model = "prop_gun_case_01"},
    { label = "Prop meth", model = "bkr_prop_meth_pseudoephedrine"},
    { label = "Sac de meth ouvert", model = "bkr_prop_meth_openbag_01a"},
    { label = "Gros sac de meth", model = "bkr_prop_meth_bigbag_04a"},
    { label = "Gros sac de weed", model = "bkr_prop_weed_bigbag_03a"},
    { label = "Weed plante", model = "bkr_prop_weed_01_small_01a"},
    { label = "Weed", model = "bkr_prop_weed_dry_02b"},
    { label = "Table de weed", model = "bkr_prop_weed_table_01a"},
    { label = "Cash", model = "hei_prop_cash_crate_half_full"},
    { label = "Valise de cash", model = "prop_cash_case_02"},
    { label = "Petite pile de cash", model = "prop_cash_crate_01"},
    { label = "Poubelle", model = "prop_cs_dumpster_01a"},
    { label = "Canapé", model = "v_tre_sofa_mess_c_s"},
    { label = "Canapé 2", model = "v_res_tre_sofa_mess_a"},
    { label = "Pile de cash", model = "bkr_prop_bkr_cashpile_04"},
    { label = "Pile de cash 2", model = "bkr_prop_bkr_cashpile_05"},
    { label = "Block de coke", model = "bkr_prop_coke_block_01a"},
    { label = "Coke en bouteille", model = "bkr_prop_coke_bottle_01a"},
    { label = "Coke coupé", model = "bkr_prop_coke_cut_01"},
    { label = "Bol de coke", model = "bkr_prop_coke_fullmetalbowl_02"},
}

GangConfig.AllowedGroups = {
    "admin",
    "gerant",
    "superadmin",
    "mod",
}

GangConfig.LvIdCard = {

    adminGroups = { "admin", "superadmin" },

    item = "carte_lasventuras",
    itemLabel = "Carte d'identité Las Venturas",
    itemWeight = 1,

    adminPoint = vector3(7064.765625, 360.040314, 58.306995),
    createPoint = vector3(7059.602539, 354.401001, 58.306973),

    interactDist = 1.5,
    drawDist = 25.0,

    adminMarkerColor = { 90, 160, 255, 190 },
    createMarkerColor = { 255, 180, 40, 190 },
}

GangConfig.Types = {
    "Orga",
    "Mafia",
    "Gang",
    "MC",
}

GangConfig.Activities = {
    DangerousDelivery = {
        enabled = true,
        cooldown = 1800,
        pickup_radius = 3.0,
        dropoff_radius = 3.0,
        announce_other_gangs_on_start = true,
        announce_other_gangs_on_pickup = true,

        reward_xp = 250,
        reward_dirtymoney = 65000,
        reward_mode = "starter",

        pickup_points = {
            vector3(-697.11779785156, -1386.0784912109, 5.3435873985291),
            vector3(-866.34088134766, -1275.6481933594, 5.1501789093018),
            vector3(-1328.4571533203, -1150.4479980469, 4.3812050819397),
            vector3(-1234.1405029297, -1427.6719970703, 4.3253412246704),
            vector3(-1040.6116943359, -1591.7470703125, 4.9293403625488),
            vector3(-786.71990966797, -800.97631835938, 20.623149871826),
            vector3(242.60832214355, -302.91320800781, 49.645683288574),
            vector3(492.37124633789, -96.087585449219, 66.441116333008),
            vector3(181.19158935547, -1639.1090087891, 29.291763305664),
            vector3(132.08877563477, -1770.7965087891, 29.565402984619),
            vector3(540.57788085938, -1945.18359375, 24.985107421875),
            vector3(977.53784179688, -2220.6550292969, 31.54663848877),
        },
        dropoff_points = {
            vector3(1718.1685791016, -1468.3802490234, 112.90840911865),
            vector3(2456.4548339844, -397.17111206055, 92.992736816406),
            vector3(2544.6772460938, 383.69659423828, 108.61707305908),
            vector3(2738.9382324219, 1465.8094482422, 30.791555404663),
            vector3(2335.9694824219, 2603.1040039062, 46.620403289795),
            vector3(2362.7666015625, 3132.5153808594, 48.208751678467),
            vector3(904.193359375, 3587.765625, 33.341110229492),
            vector3(388.4270324707, 3586.474609375, 33.292247772217),
            vector3(-1101.1193847656, 2725.4299316406, 18.800413131714),
            vector3(-2307.3576660156, 3429.9560546875, 31.044258117676),
            vector3(-1556.8548583984, 5382.2778320312, 4.1043186187744),
            vector3(-176.34037780762, 6552.8608398438, 11.098004341125),
            vector3(586.21331787109, 7221.80859375, 4.5673389434814),
            vector3(360.73843383789, 7554.576171875, 4.5673322677612),
            vector3(90.031723022461, 7811.2456054688, 6.4134135246277),
            vector3(-633.08673095703, 6919.8081054688, 24.323762893677),
            vector3(-114.84846496582, 6208.6166992188, 32.382663726807),
        }
    },

    Hitman = {
        enabled = true,
        cooldown = 1800,
        trigger_radius = 35.0,
        spawn_radius = 18.0,
        ped_min = 8,
        ped_max = 16,

        reward_xp = 350,
        reward_dirtymoney = 70000,
        reward_mode = "starter",

        ped_models = {
            "g_m_m_armgoon_01",
            "g_m_y_mexgang_01",
            "g_m_y_ballasout_01",
        },

        weapon = "WEAPON_PISTOL",
        points = {
            vector3(-1735.5517578125, 157.49108886719, 65.371055603027),
            vector3(-1673.4990234375, -901.15759277344, 9.3846836090088),
            vector3(-742.46246337891, -2028.1981201172, 9.9047365188599),
            vector3(-403.53472900391, -2720.4104003906, 7.0002183914185),
            vector3(1374.421875, -738.88665771484, 68.232688903809),
            vector3(1117.2537841797, 3055.6984863281, 41.90784072876),
            vector3(344.23721313477, 3560.3220214844, 34.303993225098),
            vector3(2026.0812988281, 4896.6748046875, 42.702602386475),
            vector3(1941.0825195312, 4728.9169921875, 41.13529586792),
            vector3(-3250.2272949219, 1210.2680664062, 3.5014312267303)
        }
    }
}

GangConfig.AvailableWeapons = {
    { label = "Tablette illégale", item = "tablette_illegale", price = 100000 },
    { label = "Pistolet", item = "WEAPON_PISTOL", price = 780000 },
    { label = "G19", item = "WEAPON_G19", price = 910000 },
    { label = "Pistolet Calibre .50", item = "WEAPON_PISTOL50", price = 1105000 },
    { label = "Pistolet Vintage", item = "WEAPON_VINTAGEPISTOL", price = 1300000 },
    { label = "Pistolet de Machinerie", item = "WEAPON_APPISTOL", price = 2400000 },

    { label = "Micro SMG", item = "WEAPON_MICROSMG", price = 3575000 },
    { label = "U45", item = "WEAPON_UMP45CMG", price = 1430000 },
    { label = "M7", item = "WEAPON_MP7CMG", price = 1326000 },
    { label = "Pistolet de Machinerie", item = "WEAPON_MACHINEPISTOL", price = 1300000 },
    { label = "Scorpion", item = "WEAPON_MINISMG", price = 1625000 },

    { label = "Fusil d'Assaut", item = "WEAPON_ASSAULTRIFLE", price = 4875000 },
    { label = "Fusil Avancé", item = "WEAPON_ADVANCEDRIFLE", price = 5362500 },
    { label = "Fusil Bullpup", item = "WEAPON_BULLPUPRIFLE", price = 5362500 },
    { label = "Fusil Compacte", item = "WEAPON_COMPACTRIFLE", price = 3575000 },
    { label = "M18", item = "WEAPON_MK18B", price = 5460000 },
    { label = "Fusil Militaire", item = "WEAPON_MILITARYRIFLE", price = 5590000 },
    { label = "Fusil Lourd", item = "WEAPON_HEAVYRIFLE", price = 5590000 },

    { label = "Canon scié", item = "WEAPON_SAWNOFFSHOTGUN", price = 2860000 },

    { label = "Gusenberg", item = "WEAPON_GUSENBERG", price = 4420000 },

    { label = "Couteau", item = "WEAPON_KNIFE", price = 41600 },
    { label = "Batte", item = "WEAPON_BAT", price = 41600 },
    { label = "Bouteille", item = "WEAPON_BOTTLE", price = 41600 },
    { label = "Clé à molette", item = "WEAPON_WRENCH", price = 41600 },
    { label = "Pied de biche", item = "WEAPON_CROWBAR", price = 41600 },
    { label = "Club de Golf", item = "WEAPON_GOLFCLUB", price = 41600 },
    { label = "Hachette", item = "WEAPON_HATCHET", price = 41600 },
    { label = "Poing Américain", item = "WEAPON_KNUCKLE", price = 41600 },
    { label = "Dague", item = "WEAPON_DAGGER", price = 41600 },
    { label = "Machette", item = "WEAPON_MACHETE", price = 41600 },
    { label = "Couteau à Crant d'Arrêt", item = "WEAPON_SWITCHBLADE", price = 41600 },
    { label = "Queue de billard", item = "WEAPON_POOLCUE", price = 41600 },

    { label = "Tablette illégale", item = "tablet", price = 100000 },
}

GangConfig.RankPermissions = {
    { key = "chest_access", label = "Accès au coffre" },
    { key = "chest_take", label = "Prendre dans le coffre" },
    { key = "chest_deposit", label = "Déposer dans le coffre" },
    { key = "garage_access", label = "Accès au garage" },
    { key = "armory_access", label = "Accès à l'armurerie" },
    { key = "laundering_access", label = "Accès au blanchiment" },
    { key = "props_access", label = "Placer / retirer les props du gang" },
}

GangConfig.ChestCapacities = {
    { label = "Petit (500KG)", weight = 500.0 },
    { label = "Moyen (1000KG)", weight = 1000.0 },
    { label = "Grand (1500KG)", weight = 1500.0 },
    { label = "Très grand (2000KG)", weight = 2000.0 },
}

GangConfig.Menu = {
    title = "GangBuilder",
    subtitle = "Gestion des gangs",
    banner = { r = 25, g = 25, b = 25, a = 200 },
}

GangConfig.VehicleDealerships = {
    {
        label = "Concession illégale",
        pos = { x = 6951.122070, y = 366.916656, z = 57.136930 },
        openDist = 2.0
    },
}

GangConfig.DealershipPreview = {
    veh = { x = 6953.916016, y = 369.163239, z = 58.036930, h = 44.076763153076 },
}

GangConfig.DealershipCatalogs = {

    COMMON = {
        label = "Catalogue commun",
        vehicles = {
            {model = "elegy", label = "Elegy", price = 70000},
            {model = "elegy4", label = "Elegy 4", price = 75000},
            {model = "everonb", label = "Everon B", price = 60000},
            {model = "jogger", label = "Jogger", price = 50000},
            {model = "sunrise1", label = "Sunrise", price = 105000},
            {model = "scheisser", label = "Scheisser", price = 95000},
            {model = "kuruma", label = "Kuruma", price = 75000},
            {model = "jugular", label = "Jugular", price = 95000},
            {model = "bf400", label = "BF400", price = 65000},
            {model = "enduro", label = "Enduro", price = 45000},
            {model = "manchez", label = "Manchez", price = 55000},
        }
    },

    MC = {
        label = "MC",
        inherit = "COMMON",
        vehicles = {
            {model = "avarus", label = "Avarus", price = 85000},
            {model = "chimera", label = "Chimera", price = 65000},
            {model = "cliffhanger", label = "Cliffhanger", price = 95000},
            {model = "daemon", label = "Daemon", price = 80000},
            {model = "daemon2", label = "Daemon 2", price = 90000},
            {model = "gargoyle", label = "Gargoyle", price = 75000},
            {model = "hexer", label = "Hexer", price = 70000},
            {model = "innovation", label = "Innovation", price = 80000},
            {model = "nightblade", label = "Nightblade", price = 75000},
            {model = "ratbike", label = "Ratbike", price = 45000},
            {model = "rrocket", label = "Rocket", price = 105000},
            {model = "kamacho", label = "Kamacho", price = 105000},
            {model = "sanctus", label = "Sanctus", price = 110000},
            {model = "sovereign", label = "Sovereign", price = 105000},
            {model = "wolfsbane", label = "Wolfsbane", price = 85000},
            {model = "zombiea", label = "Zombie A", price = 105000},
            {model = "zombieb", label = "Zombie B", price = 110000},
        }
    },

    Mafia = {
        label = "Mafia",
        inherit = "COMMON",
        vehicles = {
            {model = "argento", label = "Argento", price = 90000},
            {model = "asteropers", label = "Asteropers", price = 105000},
            {model = "ccadeesv", label = "Ccadee SV", price = 150000},
            {model = "ccadefxt", label = "Ccade FXT", price = 105000},
            {model = "buffalo4h", label = "Buffalo 4", price = 95000},
            {model = "draftGPR", label = "Draft GPR", price = 65000},
            {model = "dubsta22", label = "Dubsta 22", price = 95000},
            {model = "hellion", label = "Hellion", price = 100000},
            {model = "hellenstorm", label = "Hellenstorm", price = 120000},
            {model = "howitzer", label = "Howitzer", price = 80000},
            {model = "komodafr", label = "Komoda FR", price = 95000},
            {model = "mesaxl", label = "Mesa XL", price = 100000},
            {model = "oraclelwb", label = "Oracle LWB", price = 75000},
            {model = "baller4", label = "Baller 4", price = 95000},
            {model = "schafter3rs", label = "Schafter 3RS", price = 90000},
            {model = "aleutianxl", label = "Aleutian XL", price = 150000},
            {model = "scout", label = "Scout", price = 110000},
            {model = "revolter", label = "Revolter", price = 90000},
            {model = "manchez2", label = "Manchez 2", price = 65000},
        }
    },

    Gang = {
        label = "Street Gang",
        inherit = "COMMON",
        vehicles = {
            {model = "arias", label = "Arias", price = 35000},
            {model = "cararv", label = "Cararv", price = 75000},
            {model = "gauntletstx", label = "Gauntlet STX", price = 65000},
            {model = "gauntletc", label = "Gauntlet C", price = 70000},
            {model = "gauntletctx", label = "Gauntlet CTX", price = 75000},
            {model = "gresleyh", label = "Gresleyh", price = 85000},
            {model = "gstghell1", label = "Gstghell", price = 95000},
            {model = "remustwo", label = "Remus Two", price = 55000},
            {model = "spritzer", label = "Spritzer", price = 105000},
            {model = "jd_oraclev12", label = "Oracle V12", price = 75000},
            {model = "ariant", label = "Ariant", price = 65000},
            {model = "vamos", label = "Vamos", price = 55000},
            {model = "sultan2", label = "Sultan 2", price = 95000},
            {model = "sultan3", label = "Sultan 3", price = 105000},
            {model = "futo", label = "Futo", price = 75000},
            {model = "oracle", label = "Oracle", price = 80000},
            {model = "caracara2", label = "Caracara", price = 100000},
            {model = "scharmann", label = "Scharmann", price = 105000},
            {model = "moonbeam2", label = "Moonbeam", price = 45000},
            {model = "kamacho", label = "Kamacho", price = 105000},
        },
    },

    Orga = {
        label = "Organisation",
        inherit = "COMMON",
        vehicles = {
            {model = "argento", label = "Argento", price = 90000},
            {model = "asteropers", label = "Asteropers", price = 105000},
            {model = "ccadeesv", label = "Ccadee SV", price = 150000},
            {model = "ccadefxt", label = "Ccade FXT", price = 105000},
            {model = "buffalo4h", label = "Buffalo 4", price = 95000},
            {model = "draftGPR", label = "Draft GPR", price = 65000},
            {model = "dubsta22", label = "Dubsta 22", price = 95000},
            {model = "hellion", label = "Hellion", price = 100000},
            {model = "hellenstorm", label = "Hellenstorm", price = 120000},
            {model = "howitzer", label = "Howitzer", price = 80000},
            {model = "komodafr", label = "Komoda FR", price = 95000},
            {model = "mesaxl", label = "Mesa XL", price = 100000},
            {model = "oraclelwb", label = "Oracle LWB", price = 75000},
            {model = "baller4", label = "Baller 4", price = 95000},
            {model = "schafter3rs", label = "Schafter 3RS", price = 90000},
            {model = "aleutianxl", label = "Aleutian XL", price = 150000},
            {model = "scout", label = "Scout", price = 110000},
            {model = "revolter", label = "Revolter", price = 90000},
            {model = "manchez2", label = "Manchez 2", price = 65000},
        }
    }
}

GangConfig.GangImpounds = {
    {
        label = "Fourrière illégale",
        pos = { x = -470.324036, y = -1718.148804, z = 18.689140 },
        openDist = 2.0,
        blip = {
            sprite = 67,
            color = 1,
            scale = 0.8
        }
    }
}
