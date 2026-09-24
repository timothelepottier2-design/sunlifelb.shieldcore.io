fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_script {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
	'src/client/RMenu.lua',
    'src/client/menu/RageUI.lua',
    'src/client/menu/Menu.lua',
    'src/client/menu/MenuController.lua',
    'src/client/components/*.lua',
    'src/client/menu/elements/*.lua',
    'src/client/menu/items/*.lua',
    'src/client/menu/panels/*.lua',
    'src/client/menu/windows/*.lua',
   	'client/**/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/**/*.lua',
}

dependencies {
    'ox_target'
}
