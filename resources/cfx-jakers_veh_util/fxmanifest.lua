fx_version 'cerulean'
game 'gta5'

author 'Jakers'
description 'Vehicle Utilities'
version '1.0.2'
lua54 'yes'

shared_script '@ox_lib/init.lua'

shared_scripts {
	'config.lua',
}

client_scripts {
	'client/framework.lua',
	'client/util.lua',
	'client/client.lua',
	'client/towrope.lua',
	'client/exports.lua',
}

server_scripts {
	'server/server.lua',
	'server/towrope.lua',
	'server/exports.lua',
}

escrow_ignore {
    'config.lua',
	'client/framework.lua',
}

lua54 'yes'
dependency '/assetpacks'