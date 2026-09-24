fx_version 'cerulean'
games {'gta5'}
lua54 "yes"
description 'Add-on Melee weapons V3'


author 'Polars Armoury'
description 'Made By Polar | https://discord.gg/PjNgP4tAv9'
version '1.0'


shared_script "@ox_lib/init.lua"
shared_script "@es_extended/imports.lua"
shared_script "config.lua"
client_script "client.lua"
client_script "cl_weaponNames.lua"
server_script "server.lua"


files{
--	'meta/weaponcomponents.meta',
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


escrow_ignore {
    "cl_weaponNames",
	"config.lua"
}
dependency '/assetpacks'