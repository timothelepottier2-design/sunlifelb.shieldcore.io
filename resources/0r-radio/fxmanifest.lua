 

fx_version('cerulean')
game('gta5')
lua54 'yes'
description = 'Radio Script, QB Framework, pma-voice and saltychat.'
version = '1.1.0'
client_scripts {'client/*.lua'}
server_scripts {'server/*.lua'}
shared_scripts {'shared/*.lua'}
ui_page 'web/build/index.html'
files {'locales/**/*', 'web/**'}
escrow_ignore {
	'client/main.lua',
	'client/utils.lua',
	'client/functions.lua',
	'client/loops.lua',
	'client/events.lua',
	'server/server.lua',
	'shared/config.lua',
	'shared/locales.lua',
	'locales/en.lua'
}
dependency '/assetpacks'
dependency '/assetpacks'