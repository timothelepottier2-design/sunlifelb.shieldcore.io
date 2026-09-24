fx_version 'cerulean'
games {'gta5'}

author "Scriptifyer - Hugoo"
description "Golf game for playing fun with your friends."
version "1.0.5"

--RageUI
client_scripts {
    "./src/RageUI/RageUI.lua",
    "./src/RageUI/Menu.lua",
    "./src/RageUI/MenuController.lua",

    "./src/RageUI/components/Audio.lua",
    "./src/RageUI/components/Graphics.lua",
    "./src/RageUI/components/Keys.lua",
    "./src/RageUI/components/Util.lua",
    "./src/RageUI/components/Visual.lua",

    "./src/RageUI/elements/ItemsBadge.lua",
    "./src/RageUI/elements/ItemsColour.lua",
    "./src/RageUI/elements/PanelColour.lua",

    "./src/RageUI/items/Items.lua",
    "./src/RageUI/items/Panels.lua"
}


shared_scripts {
    "locales/locale.lua",
    "locales/fr_FR.lua",
    "locales/en_US.lua",
	'config/config.lua',
}

client_scripts {
    '@sunlife/client/PolyZone/client.lua',
    'client/utils.lua',
    'client/events.lua',
    'client/sync.lua',
    'client/menu.lua',
	'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

escrow_ignore {
    'client/*.lua',
    'server/*.lua',
    'src/**/*.lua',
    'config/*.lua',
    'locales/*.lua'
}

lua54 'yes'
dependency '/assetpacks'