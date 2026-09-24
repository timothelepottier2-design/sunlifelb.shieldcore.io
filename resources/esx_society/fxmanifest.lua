fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'ESX Society - UI NUI + gestion avancée (adapté à ce serveur)'
version '2.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'client/main.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/style.css',
	'ui/script.js'
}

dependencies {
	'es_extended',
	'oxmysql',
	'cron'
}
