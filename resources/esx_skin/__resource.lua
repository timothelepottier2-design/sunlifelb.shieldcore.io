
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'

description 'ESX Skin'

version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'