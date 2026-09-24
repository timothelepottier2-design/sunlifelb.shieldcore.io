fx_version 'cerulean'
author 'RenosTolis'
games {'gta5'}
description 'Gta V Weapon AR RRT14 GANG'
version '1.0.0' 
lua54 'yes'

escrow_ignore {
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