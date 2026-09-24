ConfigSlots = {}

ConfigSlots.WinningsMultiplier = {2, 5, 15, 10, 15, 30, 20, 10, 50}

ConfigSlots.MaxBetMultiplier = 50

ConfigSlots.ChipsValue = 5
ConfigSlots.CasinoPercentage = 0.05

ConfigSlots.Machines = {
	[1] = {
		Theme              = 6,
		Model              = `vw_prop_casino_slot_01a`,
		ReelsModel         = `vw_prop_casino_slot_01a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_01b_reels`,
		Target             = 'machine_01a',
		Textures           = 'CasinoUI_Slots_Angel',
		Sounds             = 'dlc_vw_casino_slot_machine_ak_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Etoile',
			'2 Etoiles',
			'3 Etoiles',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Synthés'
		},
	},
	[2] = {
		Theme              = 2,
		Model              = `vw_prop_casino_slot_02a`,
		ReelsModel         = `vw_prop_casino_slot_02a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_02b_reels`,
		Target             = 'machine_02a',
		Sounds             = 'dlc_vw_casino_slot_machine_ir_npc_sounds',
		Textures           = 'CasinoUI_Slots_Impotent',
		Bet                = 25,
		Winnings           = {
			'1 Eclair',
			'2 Eclairs',
			'3 Eclairs',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Super-Héros'
		},
	},
	[3] = {
		Theme              = 3,
		Model              = `vw_prop_casino_slot_03a`,
		ReelsModel         = `vw_prop_casino_slot_03a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_03b_reels`,
		Target             = 'machine_03a',
		Sounds             = 'dlc_vw_casino_slot_machine_rsr_npc_sounds',
		Textures           = 'CasinoUI_Slots_Ranger',
		Bet                = 25,
		Winnings           = {
			'1 Bière',
			'2 Bières',
			'3 Bières',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Insignes'
		},
	},
	[4] = {
		Theme              = 7,
		Model              = `vw_prop_casino_slot_04a`,
		ReelsModel         = `vw_prop_casino_slot_04a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_04b_reels`,
		Target             = 'machine_04a',
		Sounds             = 'dlc_vw_casino_slot_machine_fs_npc_sounds',
		Textures           = 'CasinoUI_Slots_Fame',
		Bet                = 5,
		Winnings           = {
			'1 Micro',
			'2 Micros',
			'3 Micros',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Superstars'
		},
	},
	[5] = {
		Theme              = 4,
		Model              = `vw_prop_casino_slot_05a`,
		ReelsModel         = `vw_prop_casino_slot_05a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_05b_reels`,
		Target             = 'machine_05a',
		Textures           = 'CasinoUI_Slots_Deity',
		Sounds             = 'dlc_vw_casino_slot_machine_ds_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Ankh',
			'2 Ankhs',
			'3 Ankhs',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Pharaons'
		},
	},
	[6] = {
		Theme              = 5,
		Model              = `vw_prop_casino_slot_06a`,
		ReelsModel         = `vw_prop_casino_slot_06a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_06b_reels`,
		Target             = 'machine_06a',
		Textures           = 'CasinoUI_Slots_Knife',
		Sounds             = 'dlc_vw_casino_slot_machine_kd_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Couteau',
			'2 Couteaux',
			'3 Couteaux',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Tronçonneuses'
		},
	},
	[7] = {
		Theme              = 1,
		Model              = `vw_prop_casino_slot_07a`,
		ReelsModel         = `vw_prop_casino_slot_07a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_07b_reels`,
		Target             = 'machine_07a',
		Textures           = 'CasinoUI_Slots_Diamond',
		Sounds             = 'dlc_vw_casino_slot_machine_td_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Diamant',
			'2 Diamants',
			'3 Diamants',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Trios de Diamants'
		},
	},
	[8] = {
		Theme              = 8,
		Model              = `vw_prop_casino_slot_08a`,
		ReelsModel         = `vw_prop_casino_slot_08a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_08b_reels`,
		Target             = 'machine_08a',
		Textures           = 'CasinoUI_Slots_Evacuator',
		Sounds             = 'dlc_vw_casino_slot_machine_hz_npc_sounds',
		Bet                = 5,
		Winnings           = {
			'1 Soldat',
			'2 Soldats',
			'3 Soldats',
			'3 Grenades',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Roquettes'
		},
	},
	--- Casino illégal (props map : hashes fournis ; reels = thème 01 si modèle différent, à valider en jeu)
	[9] = {
		Theme              = 6,
		Model              = 161343630,
		ReelsModel         = `vw_prop_casino_slot_01a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_01b_reels`,
		Target             = 'machine_01a',
		Textures           = 'CasinoUI_Slots_Angel',
		Sounds             = 'dlc_vw_casino_slot_machine_ak_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Etoile',
			'2 Etoiles',
			'3 Etoiles',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Synthés'
		},
	},
	-- Illégal : prop 342677078 @ vector4(-12645.219726562, 2591.9790039062, 2.1932380199432, 122.37172698975) (remplace -690643519 @ -12645.219726562, 2591.9790039062, …)
	[10] = {
		Theme              = 2,
		Model              = -690643519,
		ReelsModel         = `vw_prop_casino_slot_02a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_02b_reels`,
		Target             = 'machine_02a',
		Sounds             = 'dlc_vw_casino_slot_machine_ir_npc_sounds',
		Textures           = 'CasinoUI_Slots_Impotent',
		Bet                = 25,
		Winnings           = {
			'1 Eclair',
			'2 Eclairs',
			'3 Eclairs',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Super-Héros'
		},
	},
	[11] = {
		Theme              = 3,
		Model              = -1519644200,
		ReelsModel         = `vw_prop_casino_slot_03a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_03b_reels`,
		Target             = 'machine_03a',
		Sounds             = 'dlc_vw_casino_slot_machine_rsr_npc_sounds',
		Textures           = 'CasinoUI_Slots_Ranger',
		Bet                = 25,
		Winnings           = {
			'1 Bière',
			'2 Bières',
			'3 Bières',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Insignes'
		},
	},
	[12] = {
		Theme              = 7,
		Model              = 207578973,
		ReelsModel         = `vw_prop_casino_slot_04a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_04b_reels`,
		Target             = 'machine_04a',
		Sounds             = 'dlc_vw_casino_slot_machine_fs_npc_sounds',
		Textures           = 'CasinoUI_Slots_Fame',
		Bet                = 5,
		Winnings           = {
			'1 Micro',
			'2 Micros',
			'3 Micros',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Superstars'
		},
	},
	[13] = {
		Theme              = 4,
		Model              = 1096374064,
		ReelsModel         = `vw_prop_casino_slot_05a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_05b_reels`,
		Target             = 'machine_05a',
		Textures           = 'CasinoUI_Slots_Deity',
		Sounds             = 'dlc_vw_casino_slot_machine_ds_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Ankh',
			'2 Ankhs',
			'3 Ankhs',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Pharaons'
		},
	},
	-- Machine ajoutée hors casino (placée via ConfigSlots.StandaloneMachines).
	-- Réutilise les rouleaux / textures / sons du thème 01a.
	[14] = {
		Theme              = 6,
		Model              = -502549171,
		ReelsModel         = `vw_prop_casino_slot_01a_reels`,
		ReelsSpinningModel = `vw_prop_casino_slot_01b_reels`,
		Target             = 'machine_01a',
		Textures           = 'CasinoUI_Slots_Angel',
		Sounds             = 'dlc_vw_casino_slot_machine_ak_npc_sounds',
		Bet                = 100,
		Winnings           = {
			'1 Etoile',
			'2 Etoiles',
			'3 Etoiles',
			'3 Cerises',
			'3 Prunes',
			'3 Pastèques',
			'3 Cloches',
			'3 Septs',
			'3 Synthés'
		},
	},
}

-- Machines à faire apparaître hors du casino (props non présents sur la map).
-- Le client les spawn à l'approche et active la détection autour d'elles.
-- machineType = index dans ConfigSlots.Machines ci-dessus.
ConfigSlots.StandaloneMachines = {
	{
		machineType   = 14,
		coords        = vector4(6984.912109375, 252.70550537109376, 56.84926986694336, 135.00001525878907),
		spawnDistance = 150.0,
		detectDistance = 100.0,
	},
}

--ConfigSlots.SpritePositions = { 0.0, 22.5,  45.0, 67.5, 90.0, 112.5, 135.0, 157.5, 180.0, 202.5, 225.0, 247.5, 270.0, 292.5, 315.0, 337.5}

ConfigSlots.Scenes = {
	['enter_right'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Duration      = 13,
		Flag          = 16,
		PlaybackRate  = 2.0,
	},
	['enter_left'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Duration      = 13,
		Flag          = 16,
		PlaybackRate  = 2.0,
	},
	['exit_left'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Duration      = 13,
		Flag          = 16,
		PlaybackRate  = 1000.0,
	},
	['exit_right'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Duration      = 13,
		Flag          = 16,
		PlaybackRate  = 1000.0,
	},
	['press_spin'] = {
		BlendInSpeed  = 8.0,
		BlendOutSpeed = -4.0,
		Flag          = 50,
        Variations    = {'a', 'b'}
	},
	['press_betone_a'] = {
		BlendInSpeed  = 4.0,
		BlendOutSpeed = -8.0,
		Flag          = 50,
	},
	['press_betmax_a'] = {
		BlendInSpeed  = 4.0,
		BlendOutSpeed = -8.0,
		Flag          = 50,
	},
	['spinning'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Flag          = 51,
		Variations    = {'a', 'b', 'c'}
	},
	['win'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Flag          = 50,
		Variations    = {'a', 'b', 'c', 'd', 'e', 'f', 'g'}
	},
	['win_big'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Flag          = 50,
		Variations    = {'b'}
	},
	['lose'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Flag          = 50,
		Variations    = {'a', 'b', 'c', 'd', 'e', 'f'}
	},
	['base_idle'] = {
		BlendInSpeed  = 2.0,
		BlendOutSpeed = -1.5,
		Flag          = 51,
		Variations    = {'a', 'b', 'c', 'd', 'e', 'f'}
	},
}
