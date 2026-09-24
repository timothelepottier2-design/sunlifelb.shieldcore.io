Config = {}

ConfigMenuProps = {
    enableVipAccess = true,

    limit_props_job = 30,
    job_props_access = {
        ems = {
            props = {
                {label = "Trousse de secours", object = "prop_ld_health_pack", isFreeze = false},
                {label = "Sac médical", object = "prop_mk_bomb_01", isFreeze = false},
                {label = "Chaise roulante", object = "prop_wheelchair_01", isFreeze = false},
                {label = "Brancard", object = "fernocot", isFreeze = false},
                {label = "Sac EMS", object = "prop_ld_bomb", isFreeze = false},
                {label = "Machine Cardiaque", object = "prop_ld_purse_01", isFreeze = false},
                {label = "Lit", object = "v_med_bed1", isFreeze = false},
                {label = "Lit 2", object = "v_med_bed2", isFreeze = false},
                {label = "Lit 3", object = "v_med_emptybed", isFreeze = false},
                {label = "Lit 4", object = "v_med_cor_emblmtable", isFreeze = false},
                {label = "Comptoir", object = "v_med_bench1", isFreeze = true},
                {label = "Comptoir 2", object = "v_med_bench2", isFreeze = true},
                {label = "Comptoir 3", object = "v_med_benchcentr", isFreeze = true},
                {label = "Set Table EMS", object = "v_med_benchset1", isFreeze = false},
                {label = "Poubelle", object = "v_med_bin", isFreeze = false},
                {label = "Bouteilles 1", object = "v_med_bottles1", isFreeze = false},
                {label = "Bouteilles 2", object = "v_med_bottles2", isFreeze = false},
                {label = "Bouteilles 3", object = "v_med_bottles3", isFreeze = false},
                {label = "Centrifugeuse 1", object = "v_med_centrifuge1", isFreeze = true},
                {label = "Centrifugeuse 2", object = "v_med_centrifuge2", isFreeze = true},
                {label = "Frigo", object = "v_med_cooler", isFreeze = true},
                {label = "Table d'autopsy", object = "v_med_cor_autopsytbl", isFreeze = true},
                {label = "Panier a linge", object = "v_med_cor_cembin", isFreeze = false},
                {label = "Chariot 1", object = "v_med_cor_cemtrolly", isFreeze = false},
                {label = "Chariot 2", object = "v_med_cor_cemtrolly2", isFreeze = false},
                {label = "Chariot 3", object = "v_med_trolley", isFreeze = false},
                {label = "Chariot 4", object = "v_med_trolley2", isFreeze = false},
                {label = "Chaise", object = "v_med_cor_medstool", isFreeze = false},
                {label = "Mini Frigo", object = "v_med_cor_minifridge", isFreeze = true},
                {label = "Étagère", object = "v_med_cor_shelfrack", isFreeze = false},
                {label = "TV", object = "v_med_cor_tvstand", isFreeze = true},
                {label = "Unité EMS", object = "v_med_cor_unita", isFreeze = false},
                {label = "Unité murale", object = "v_med_cor_wallunita", isFreeze = false},
                {label = "Unité murale 2", object = "v_med_cor_wallunitb", isFreeze = false},
                {label = "Table", object = "v_med_cor_wheelbench", isFreeze = false},
                {label = "Gazebo", object = "prop_gazebo_01", isFreeze = false},
                {label = "Gazebo 2", object = "prop_gazebo_03", isFreeze = false}
            }
        },
        police = {
            props = {
                {label = "Barrière Lourde", object = "prop_mp_barrier_02b", isFreeze = true},
                {label = "Terre-Plein (Petit)", object = "prop_mp_barrier_01b", isFreeze = false},
                {label = "Barrière de Chantier", object = "prop_barrier_work05", isFreeze = false},
                {label = "Cône de Signalisation", object = "prop_parking_sign_1", isFreeze = false},
                {label = "Séparateur de Voies (Type 1)", object = "prop_trafficdiv_01", isFreeze = false},
                {label = "Séparateur de Voies (Type 2", object = "prop_trafficdiv_02", isFreeze = false},
                {label = "Tonnelle", object = "prop_gazebo_02", isFreeze = false},
                {label = "Pupitre", object = "prop_lectern_01", isFreeze = false},
                {label = "Drapeau SAPD", object = "prop_flag_sapd_s", isFreeze = false},
                {label = "Cible", object = "prop_range_target_01", isFreeze = false},
                {label = "Cible 2", object = "prop_range_target_02", isFreeze = false},
                {label = "Cible 3", object = "prop_range_target_03", isFreeze = false},
                {label = "Lumières", object = "prop_worklight_03b", isFreeze = true},
                {label = "Lampe", object = "prop_warninglight_01", isFreeze = true},
                {label = "Panneau STOP", object = "prop_sign_road_01a", isFreeze = true},
                {label = "Barrière Automatique", object = "prop_sec_barier_03a", isFreeze = true},
            }
        },
        sheriff = {
            props = {
                {label = "Barrière Lourde", object = "prop_mp_barrier_02b", isFreeze = true},
                {label = "Terre-Plein (Petit)", object = "prop_mp_barrier_01b", isFreeze = false},
                {label = "Barrière de Chantier", object = "prop_barrier_work05", isFreeze = false},
                {label = "Cône de Signalisation", object = "prop_parking_sign_1", isFreeze = false},
                {label = "Séparateur de Voies (Type 1)", object = "prop_trafficdiv_01", isFreeze = false},
                {label = "Séparateur de Voies (Type 2", object = "prop_trafficdiv_02", isFreeze = false},
                {label = "Tonnelle", object = "prop_gazebo_02", isFreeze = false},
                {label = "Pupitre", object = "prop_lectern_01", isFreeze = false},
                {label = "Drapeau", object = "prop_flag_sapd_s", isFreeze = false},
                {label = "Drapeau Sheriff", object = "prop_flag_sheriff_s", isFreeze = false},
                {label = "Cible", object = "prop_range_target_01", isFreeze = false},
                {label = "Cible 2", object = "prop_range_target_02", isFreeze = false},
                {label = "Cible 3", object = "prop_range_target_03", isFreeze = false},
                {label = "Lumières", object = "prop_worklight_03b", isFreeze = true},
                {label = "Lampe", object = "prop_warninglight_01", isFreeze = true},
                {label = "Panneau STOP", object = "prop_sign_road_01a", isFreeze = true},
                {label = "Barrière Automatique", object = "prop_sec_barier_03a", isFreeze = true},
            }
        },
        lsfd = {
            props = {
                {label = "Trousse de secours", object = "prop_ld_health_pack", isFreeze = false},
                {label = "Cône de signalisation", object = "prop_roadcone02a", isFreeze = false},
                {label = "Barrière de chantier", object = "prop_barrier_work06a", isFreeze = true},
                {label = "Balise lumineuse", object = "prop_air_conelight", isFreeze = true},
            }
        },
        fourriere = {
            props = {
                {label = "Barrière Flottante", object = "prop_barrier_wat_03a", isFreeze = false},
                {label = "Barrière de Chantier", object = "prop_barrier_work04a", isFreeze = true},
                {label = "Barrière de Chantier (Petite)", object = "prop_barrier_work01d", isFreeze = true},
                {label = "Barrière de Chantier Blanche", object = "prop_barrier_work01a", isFreeze = true},
                {label = "Cône de Signalisation", object = "prop_roadcone01b", isFreeze = false},
                {label = "Cône de Signalisation (Petit)", object = "prop_mp_cone_04", isFreeze = false},
                {label = "Caisse à Outils", object = "prop_toolchest_03", isFreeze = false},
                {label = "Barrière Métallique", object = "prop_mp_barrier_02", isFreeze = true},
                {label = "Séparateur de Voies (Type 1)", object = "prop_trafficdiv_01", isFreeze = true},
                {label = "Séparateur de Voies (Type 2)", object = "prop_trafficdiv_02", isFreeze = true}
            }
        },
        bahamas = {
            props = {
                {label = "Remorque de Restauration", object = "prop_food_van_02", isFreeze = true},
                {label = "Menu de Boissons", object = "prop_drinkmenu", isFreeze = true},
                {label = "Parasol Pliant", object = "prop_parasol_01_down", isFreeze = true},
                {label = "Chaise", object = "prop_chateau_chair_01", isFreeze = true},
                {label = "Table", object = "prop_chateau_table_01", isFreeze = true},
                {label = "Poubelle", object = "prop_food_bin_01", isFreeze = true},
                {label = "Comptoir de Voiturier", object = "prop_valet_04", isFreeze = true}
            }
        },
        unicorn = {
            props = {
                {label = "Remorque de Restauration", object = "prop_food_van_02", isFreeze = true},
                {label = "Menu de Boissons", object = "prop_drinkmenu", isFreeze = true},
                {label = "Parasol Pliant", object = "prop_parasol_01_down", isFreeze = true},
                {label = "Chaise", object = "prop_chateau_chair_01", isFreeze = true},
                {label = "Table", object = "prop_chateau_table_01", isFreeze = true},
                {label = "Poubelle", object = "prop_food_bin_01", isFreeze = true},
                {label = "Comptoir de Voiturier", object = "prop_valet_04", isFreeze = true}
            }
        },
        galaxy = {
            props = {
                {label = "Remorque de Restauration", object = "prop_food_van_02", isFreeze = true},
                {label = "Menu de Boissons", object = "prop_drinkmenu", isFreeze = true},
                {label = "Parasol Pliant", object = "prop_parasol_01_down", isFreeze = true},
                {label = "Chaise", object = "prop_chateau_chair_01", isFreeze = true},
                {label = "Table", object = "prop_chateau_table_01", isFreeze = true},
                {label = "Poubelle", object = "prop_food_bin_01", isFreeze = true},
                {label = "Comptoir de Voiturier", object = "prop_valet_04", isFreeze = true}
            }
        },
        yellowjack = {
            props = {
                {label = "Remorque de Restauration", object = "prop_food_van_02", isFreeze = true},
                {label = "Menu de Boissons", object = "prop_drinkmenu", isFreeze = true},
                {label = "Parasol Pliant", object = "prop_parasol_01_down", isFreeze = true},
                {label = "Chaise", object = "prop_chateau_chair_01", isFreeze = true},
                {label = "Table", object = "prop_chateau_table_01", isFreeze = true},
                {label = "Poubelle", object = "prop_food_bin_01", isFreeze = true},
                {label = "Comptoir de Voiturier", object = "prop_valet_04", isFreeze = true}
            }
        },
        tequilala = {
            props = {
                {label = "Remorque de Restauration", object = "prop_food_van_02", isFreeze = true},
                {label = "Menu de Boissons", object = "prop_drinkmenu", isFreeze = true},
                {label = "Parasol Pliant", object = "prop_parasol_01_down", isFreeze = true},
                {label = "Chaise", object = "prop_chateau_chair_01", isFreeze = true},
                {label = "Table", object = "prop_chateau_table_01", isFreeze = true},
                {label = "Poubelle", object = "prop_food_bin_01", isFreeze = true},
                {label = "Comptoir de Voiturier", object = "prop_valet_04", isFreeze = true}
            }
        },
    },
    vip_props_access = {
        props = {
            {label = "Chaise Pliante", object = "prop_skid_chair_02", isFreeze = false},
            {label = "Outils", object = "prop_cs_trolley_01", isFreeze = false},
            {label = "Outils mecano", object = "prop_carcreeper", isFreeze = true},
            {label = "Sac", object = "prop_cs_heist_bag_02", isFreeze = false},
            {label = "Télévision", object = "prop_tv_flat_01", isFreeze = true},
            {label = "Télévision 2", object = "prop_tv_flat_michael", isFreeze = true},
            {label = "Télévision 3", object = "prop_trev_tv_01", isFreeze = true},
            {label = "Fond vert", object = "prop_ld_greenscreen_01", isFreeze = true},
            {label = "Banc en bois simple", object = "prop_bench_01c", isFreeze = true},
            {label = "Petite table en bois", object = "prop_table_03", isFreeze = false},
            {label = "Chaise en bois", object = "prop_chair_05", isFreeze = false},
            {label = "Poubelle de rue", object = "prop_bin_04a", isFreeze = false},
            {label = "Valise noire", object = "prop_suitcase_01c", isFreeze = false},
            {label = "Sac à main posé au sol", object = "prop_ld_handbag_s", isFreeze = false},
            {label = "Parasol de plage", object = "prop_beach_parasol_02", isFreeze = false},
            {label = "Planche de surf", object = "prop_surf_board_01", isFreeze = false},
            {label = "Feu de camp de plage", object = "prop_beach_fire", isFreeze = true},
            {label = "Sac de plage bleu", object = "prop_beach_bag_01a", isFreeze = false},
            {label = "Matelas gonflable bleu", object = "prop_beach_lilo_01", isFreeze = false},
            {label = "Château de sable", object = "prop_beach_sandcas_01", isFreeze = true},
            {label = "Ballon de volley de plage", object = "prop_beach_volball01", isFreeze = false},
            {label = "Chaise", object = "bkr_prop_weed_chair_01a", isFreeze = false},
            {label = "Sac pour arme", object = "prop_gun_case_01", isFreeze = false},
            {label = "Prop meth", object = "bkr_prop_meth_pseudoephedrine", isFreeze = false},
            {label = "Sac de meth ouvert", object = "bkr_prop_meth_openbag_01a", isFreeze = false},
            {label = "Gros sac de meth", object = "bkr_prop_meth_bigbag_04a", isFreeze = false},
            {label = "Gros sac de weed", object = "bkr_prop_weed_bigbag_03a", isFreeze = false},
            {label = "Weed plante", object = "bkr_prop_weed_01_small_01a", isFreeze = false},
            {label = "Weed", object = "bkr_prop_weed_dry_02b", isFreeze = false},
            {label = "Table de weed", object = "bkr_prop_weed_table_01a", isFreeze = false},
            {label = "Cash", object = "hei_prop_cash_crate_half_full", isFreeze = false},
            {label = "Valise de cash", object = "prop_cash_case_02", isFreeze = false},
            {label = "Petite pile de cash", object = "prop_cash_crate_01", isFreeze = false},
            {label = "Poubelle", object = "prop_cs_dumpster_01a", isFreeze = false},
            {label = "Canapé", object = "v_tre_sofa_mess_c_s", isFreeze = true},
            {label = "Canapé 2", object = "v_res_tre_sofa_mess_a", isFreeze = true},
            {label = "Pile de cash", object = "bkr_prop_bkr_cashpile_04", isFreeze = false},
            {label = "Pile de cash 2", object = "bkr_prop_bkr_cashpile_05", isFreeze = false},
            {label = "Block de coke", object = "bkr_prop_coke_block_01a", isFreeze = false},
            {label = "Coke en bouteille", object = "bkr_prop_coke_bottle_01a", isFreeze = false},
            {label = "Coke coupé", object = "bkr_prop_coke_cut_01", isFreeze = false},
            {label = "Bol de coke", object = "bkr_prop_coke_fullmetalbowl_02", isFreeze = false},
            {label = "Chaise clip", object = "prop_sol_chair", isFreeze = false},
            {label = "Carton rempli d'objets", object = "prop_cs_cardbox_01", isFreeze = false},
            {label = "Grande caisse en bois", object = "prop_crate_11a", isFreeze = false},
            {label = "Mallette pour armes", object = "prop_gun_case_01", isFreeze = false},
            {label = "Petit sac en papier", object = "prop_paper_bag_small", isFreeze = false},
            {label = "Mallette pleine d'argent", object = "prop_cash_case_02", isFreeze = false},
            {label = "Brûleur de drogue", object = "prop_drug_burner", isFreeze = false},
            {label = "Barrière de rue", object = "prop_mp_barrier_01", isFreeze = false},
            {label = "Chaussette roulée", object = "prop_rolled_sock_02", isFreeze = false}
        },
        limits = {
            ["gold"] = 30,
            ["diamond"] = 30,
            ["platinium"] = 30,
            ["legendary"] = 30
        }
    },
    limit_props_staff = 30,
    staff_props_access = {
        props = {
            {label = "Cône Gonflable", object = "prop_inflategate_01", isFreeze = true},
            {label = "Arche Gonflable", object = "prop_inflatearch_01", isFreeze = true},
            {label = "Portail de Départ", object = "prop_start_gate_01", isFreeze = true},
            {label = "Mur de Pneus (Court)", object = "prop_tyre_wall_01b", isFreeze = true},
            {label = "Mur de Pneus (Long)", object = "prop_tyre_wall_03b", isFreeze = true},
            {label = "Gradins", object = "prop_bleachers_05_cr", isFreeze = true},
            {label = "Conteneur Train", object = "prop_rub_railwreck_2", isFreeze = true},
            {label = "Conteneur Cassé", object = "prop_rub_cont_01b", isFreeze = true},
            {label = "Conteneur Métallique", object = "prop_container_03b", isFreeze = true},
            {label = "Clôture de Chantier", object = "prop_fncconstruc_ld", isFreeze = true},
            {label = "Mur de Métal", object = "prop_rub_scrap_05", isFreeze = true},
            {label = "Table de Pique-Nique", object = "prop_picnictable_02", isFreeze = true},
            {label = "Haut-Parleur", object = "prop_speaker_01", isFreeze = false},
            {label = "Distributeur de Boissons", object = "prop_vend_soda_01", isFreeze = true}
        },
    },
    staff_rank_access = {
        "superadmin",
        "admin",
        "gerant"
    }
}
