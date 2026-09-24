fx_version 'cerulean'
games {'gta5'}
lua54 'yes'
description 'Leo-Shop'

-- =====================================================================
-- Manifest nettoyé: ne déclare QUE les fichiers .meta réellement présents
-- sur disque (sinon FiveM émet "could not find file" + bloque le data_file).
-- Weapons existantes: assault, mcx, wolfknife (sans weaponcomponents), wolfvern.
-- =====================================================================

files {
	-- assault
	'**/weaponcomponentsassault.meta',
	'**/weaponarchetypesassault.meta',
	'**/weaponanimationsassault.meta',
	'**/pedpersonalityassault.meta',
	'**/weaponsassault.meta',

	-- mcx
	'**/weaponcomponentsmcx.meta',
	'**/weaponarchetypesmcx.meta',
	'**/weaponanimationsmcx.meta',
	'**/pedpersonalitymcx.meta',
	'**/weaponsmcx.meta',

	-- wolfknife (pas de weaponcomponents)
	'**/weaponarchetypeswolfknife.meta',
	'**/weaponanimationswolfknife.meta',
	'**/pedpersonalitywolfknife.meta',
	'**/weaponswolfknife.meta',

	-- wolfvern
	'**/weaponcomponentswolfvern.meta',
	'**/weaponarchetypeswolfvern.meta',
	'**/weaponanimationswolfvern.meta',
	'**/pedpersonalitywolfvern.meta',
	'**/weaponswolfvern.meta',
}

-- ============================================================
-- data_file declarations (weapons existantes uniquement)
-- ============================================================

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsassault.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesassault.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsassault.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalityassault.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsassault.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentsmcx.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypesmcx.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationsmcx.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitymcx.meta'
data_file 'WEAPONINFO_FILE' '**/weaponsmcx.meta'

-- wolfknife: pas de weaponcomponents (fichier absent)
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypeswolfknife.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationswolfknife.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitywolfknife.meta'
data_file 'WEAPONINFO_FILE' '**/weaponswolfknife.meta'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponentswolfvern.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypeswolfvern.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimationswolfvern.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonalitywolfvern.meta'
data_file 'WEAPONINFO_FILE' '**/weaponswolfvern.meta'


client_script 'cl_weaponNames.lua'
escrow_ignore {
	'cl_weaponNames.lua'
}
dependency '/assetpacks'
