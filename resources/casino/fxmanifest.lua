
fx_version 'adamant'
games { 'gta5' };
lua54 'yes'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

}

client_scripts {
	"client/casino/*.lua",
    "client/casino/3poker/*.lua",
    "client/casino/blackjack/*.lua",
    "client/casino/roulette/*.lua",
    "client/slots/config.lua",
    "client/slots/cl_main.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/casino/*.lua",
    --"server/casino/files/*.json",
}