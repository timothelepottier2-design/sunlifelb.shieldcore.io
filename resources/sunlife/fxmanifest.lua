fx_version 'adamant'

games { 'gta5' };
lua54 'yes'

ui_page 'ui/sound_script/index.html'
file 'ui/sound_script/index.html'
file 'ui/sound_script/sounds/*.ogg'
file 'ui/sound_script/sounds/*.mp3'
file 'ui/sound_script/sounds/*.wav'
file 'ui/sound_script/script.js'
file 'ui/sound_script/style.css'
file 'html/pubs/billboard.html'
file 'ui/tattoo/ui.html'
file 'ui/tattoo/css/*.css'
file 'ui/tattoo/js/*.js'
file 'ui/tattoo/images/*'

file 'ui/afk/afk.css'
file 'ui/afk/afk.js'
file 'ui/afk/logo.png'
file 'meta/vms_overlays.xml'
file 'meta/shop_tattoo.meta'

data_file 'PED_OVERLAY_FILE' 'meta/vms_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'meta/shop_tattoo.meta'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/adminmenu/*.lua',
}

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
    "src/client/menu/windows/*.lua",
    "src/client/ContextUI/components/*.lua",
    "src/client/ContextUI/ContextUI.lua",
}

client_scripts {
    "config/**.lua",
    "client/**/**.lua"
}

server_scripts {
    "sv_gc.lua",
    "@oxmysql/lib/MySQL.lua",
    "config/**.lua",
    "server/**/**.lua",
    "server/meteo/timezone.js"
}

export 'isInPiggy'

export 'getAFKStatus'

export 'getExp'

export 'NoClip'
export 'PlayerNoClipStatus'
export 'getStaffMod'
export 'inJail'
export 'GetStaffInService'
export 'addPlayerLog'
export 'calculatePlayerScore'
export 'getPlayerInStaffMod'
export 'localPlayers'

export 'isInBarber'
export 'reloadPlayerTattoos'
export 'reloadPlayerTattoosByBarber'
export 'GetHairFadesList'
