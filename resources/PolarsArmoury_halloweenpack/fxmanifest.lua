fx_version 'cerulean'
games {'gta5'}
lua54 "yes"
description 'Add-on Halloween weapons'


author 'Polars Armoury'
description 'Made By Polar | https://discord.gg/PjNgP4tAv9'
version '1.0'

files{
	--'meta/weaponcomponents.meta',
	'meta/weaponarchetypes.meta',
	'meta/weaponanimations.meta',
	'meta/pedpersonality.meta',
	'meta/weapons.meta',
}

-- data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'

client_script 'cl_weaponNames.lua'

escrow_ignore {
    "cl_weaponNames",
}
dependency '/assetpacks'