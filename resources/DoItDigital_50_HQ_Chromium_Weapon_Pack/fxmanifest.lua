fx_version 'cerulean'
author 'KilluaZoldyck#0099'
games {'gta5'}
description 'Gta V Weapon 50 Chromium Weapon Pack By #DoItDigital'
version '1.0.0'
this_is_a_map 'no'
lua54 'yes'

escrow_ignore {
	'Read ME.txt',
	'weapon_name.lua',
	'EXTRA_FILES/**.*'
}

files{
	'**/weaponcomponents.meta',
	'**/weaponarchetypes.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'

client_script 'weapon_name.lua'
dependency '/assetpacks'