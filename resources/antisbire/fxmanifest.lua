fx_version 'adamant'
game 'gta5'

dependency 'screenshot-basic'

files {
	'data/loadouts.meta',
	'whitelist_licenses.json',
    'blocked_isp.json'
}

client_scripts {
	'client/main.lua',
	'client/veh_enter.lua',
	'client/dmg.lua',
	'client/noclip_ss.lua',
	'client/test_spawn.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/main.lua",
	"server/weapons.lua",
	"server/names.lua",
	"sv_config.lua",
	"server/props.lua",
	"server/log.lua",
	"server/noclip.lua",
	"server/statebag.lua",
}

data_file 'LOADOUTS_FILE' 'data/loadouts.meta'
