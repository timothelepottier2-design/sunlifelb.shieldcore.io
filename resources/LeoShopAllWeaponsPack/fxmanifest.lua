fx_version 'cerulean'
games {'gta5'}
lua54 'yes'
description 'LEO-SHOP'

-- =====================================================================
-- Manifest nettoyé: ne déclare QUE les fichiers .meta réellement présents
-- sur disque (sinon FiveM émet "could not find file" + bloque le data_file).
-- Weapons existantes: 357, akredl, blacksniper, chainsaw, desertpurple,
-- glock17, kinetic, m19, m4beast, m4goldbeast, pumpkinrifle, revoultra,
-- scar17, sig550, specialhammer (sans weaponcomponents), tec9m, tec9mb, tec9mf.
-- =====================================================================

files {
	-- Audio
	'audioconfig/leo_game.dat151.rel',
	'audioconfig/leos_sounds.dat54.rel',

	-- 357
	'**/weaponcomponents357.meta',
	'**/weaponarchetypes357.meta',
	'**/weaponanimations357.meta',
	'**/pedpersonality357.meta',
	'**/weapons357.meta',

	-- akredl
	'**/weaponcomponentsakredl.meta',
	'**/weaponarchetypesakredl.meta',
	'**/weaponanimationsakredl.meta',
	'**/pedpersonalityakredl.meta',
	'**/weaponsakredl.meta',

	-- blacksniper
	'**/weaponcomponentsblacksniper.meta',
	'**/weaponarchetypesblacksniper.meta',
	'**/weaponanimationsblacksniper.meta',
	'**/pedpersonalityblacksniper.meta',
	'**/weaponsblacksniper.meta',

	-- chainsaw
	'**/weaponcomponentschainsaw.meta',
	'**/weaponarchetypeschainsaw.meta',
	'**/weaponanimationschainsaw.meta',
	'**/pedpersonalitychainsaw.meta',
	'**/weaponschainsaw.meta',

	-- desertpurple
	'**/weaponcomponentsdesertpurple.meta',
	'**/weaponarchetypesdesertpurple.meta',
	'**/weaponanimationsdesertpurple.meta',
	'**/pedpersonalitydesertpurple.meta',
	'**/weaponsdesertpurple.meta',

	-- glock17
	'**/weaponcomponentsglock17.meta',
	'**/weaponarchetypesglock17.meta',
	'**/weaponanimationsglock17.meta',
	'**/pedpersonalityglock17.meta',
	'**/weaponsglock17.meta',

	-- kinetic
	'**/weaponcomponentskinetic.meta',
	'**/weaponarchetypeskinetic.meta',
	'**/weaponanimationskinetic.meta',
	'**/pedpersonalitykinetic.meta',
	'**/weaponskinetic.meta',

	-- m19
	'**/weaponcomponentsm19.meta',
	'**/weaponarchetypesm19.meta',
	'**/weaponanimationsm19.meta',
	'**/pedpersonalitym19.meta',
	'**/weaponsm19.meta',

	-- m4beast
	'**/weaponcomponentsm4beast.meta',
	'**/weaponarchetypesm4beast.meta',
	'**/weaponanimationsm4beast.meta',
	'**/pedpersonalitym4beast.meta',
	'**/weaponsm4beast.meta',

	-- m4goldbeast
	'**/weaponcomponentsm4goldbeast.meta',
	'**/weaponarchetypesm4goldbeast.meta',
	'**/weaponanimationsm4goldbeast.meta',
	'**/pedpersonalitym4goldbeast.meta',
	'**/weaponsm4goldbeast.meta',

	-- pumpkinrifle
	'**/weaponcomponentspumpkinrifle.meta',
	'**/weaponarchetypespumpkinrifle.meta',
	'**/weaponanimationspumpkinrifle.meta',
	'**/pedpersonalitypumpkinrifle.meta',
	'**/weaponspumpkinrifle.meta',

	-- revoultra
	'**/weaponcomponentsrevoultra.meta',
	'**/weaponarchetypesrevoultra.meta',
	'**/weaponanimationsrevoultra.meta',
	'**/pedpersonalityrevoultra.meta',
	'**/weaponsrevoultra.meta',

	-- scar17
	'**/weaponcomponentsscar17.meta',
	'**/weaponarchetypesscar17.meta',
	'**/weaponanimationsscar17.meta',
	'**/pedpersonalityscar17.meta',
	'**/weaponsscar17.meta',

	-- sig550
	'**/weaponcomponentssig550.meta',
	'**/weaponarchetypessig550.meta',
	'**/weaponanimationssig550.meta',
	'**/pedpersonalitysig550.meta',
	'**/weaponssig550.meta',

	-- specialhammer (pas de weaponcomponents)
	'**/weaponarchetypesspecialhammer.meta',
	'**/weaponanimationsspecialhammer.meta',
	'**/pedpersonalityspecialhammer.meta',
	'**/weaponsspecialhammer.meta',

	-- tec9m
	'**/weaponcomponentstec9m.meta',
	'**/weaponarchetypestec9m.meta',
	'**/weaponanimationstec9m.meta',
	'**/pedpersonalitytec9m.meta',
	'**/weaponstec9m.meta',

	-- tec9mb
	'**/weaponcomponentstec9mb.meta',
	'**/weaponarchetypestec9mb.meta',
	'**/weaponanimationstec9mb.meta',
	'**/pedpersonalitytec9mb.meta',
	'**/weaponstec9mb.meta',

	-- tec9mf
	'**/weaponcomponentstec9mf.meta',
	'**/weaponarchetypestec9mf.meta',
	'**/weaponanimationstec9mf.meta',
	'**/pedpersonalitytec9mf.meta',
	'**/weaponstec9mf.meta',
}

-- ============================================================
-- data_file declarations (weapons existantes uniquement)
-- ============================================================

data_file 'AUDIO_GAMEDATA' 'audioconfig/leo_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/leos_sounds.dat'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents357.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes357.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations357.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality357.meta'
data_file 'WEAPONINFO_FILE' '**/weapons357.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsakredl.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesakredl.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsakredl.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityakredl.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsakredl.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsblacksniper.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesblacksniper.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsblacksniper.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityblacksniper.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsblacksniper.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentschainsaw.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypeschainsaw.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationschainsaw.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitychainsaw.meta'
data_file 'WEAPONINFO_FILE' '**/weaponschainsaw.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsdesertpurple.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesdesertpurple.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsdesertpurple.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitydesertpurple.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsdesertpurple.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsglock17.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesglock17.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsglock17.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityglock17.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsglock17.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentskinetic.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypeskinetic.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationskinetic.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitykinetic.meta'
data_file 'WEAPONINFO_FILE' '**/weaponskinetic.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsm19.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesm19.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsm19.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitym19.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsm19.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsm4beast.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesm4beast.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsm4beast.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitym4beast.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsm4beast.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsm4goldbeast.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesm4goldbeast.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsm4goldbeast.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitym4goldbeast.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsm4goldbeast.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentspumpkinrifle.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypespumpkinrifle.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationspumpkinrifle.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitypumpkinrifle.meta'
data_file 'WEAPONINFO_FILE' '**/weaponspumpkinrifle.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsrevoultra.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesrevoultra.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsrevoultra.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityrevoultra.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsrevoultra.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsscar17.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesscar17.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsscar17.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityscar17.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsscar17.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentssig550.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypessig550.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationssig550.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitysig550.meta'
data_file 'WEAPONINFO_FILE' '**/weaponssig550.meta'

-- specialhammer: pas de weaponcomponents (fichier absent)
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesspecialhammer.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsspecialhammer.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityspecialhammer.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsspecialhammer.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentstec9m.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypestec9m.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationstec9m.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitytec9m.meta'
data_file 'WEAPONINFO_FILE' '**/weaponstec9m.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentstec9mb.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypestec9mb.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationstec9mb.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitytec9mb.meta'
data_file 'WEAPONINFO_FILE' '**/weaponstec9mb.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentstec9mf.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypestec9mf.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationstec9mf.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitytec9mf.meta'
data_file 'WEAPONINFO_FILE' '**/weaponstec9mf.meta'


client_script 'cl_weaponNames.lua'
escrow_ignore {
	'cl_weaponNames.lua'
}

dependency '/assetpacks'
