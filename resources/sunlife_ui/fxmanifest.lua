fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sunlife_ui'
author 'SunLife'
description 'Core UI SUNLIFE'
version '1.0.0'

ui_page 'nui/index.html'

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
    'screenshot-basic',
    'sCore',
}

export 'IsInGunFightZone'

files {
    'nui/index.html',
    'nui/router.js',
    'nui/router.css',

    'apps/bank/client/html/**',
    'apps/boutique/html/**',
    'apps/charcreator/html/**',
    'apps/clothesshop/html/**',
    'apps/dispatch/html/**',
    'apps/dmvschool/html/**',
    'apps/fishing/html/**',
    'apps/garage/html/**',
    'apps/gunfight/hud/**',
    'apps/gunfight/web/**',
    'apps/illtablet/html/**',
    'apps/location/html/**',
    'apps/poltablet/ui/**',
    'apps/quest/html/**',
    'apps/staffui/html/**',
    'apps/weedpots/html/**',
    'apps/merged/html/**',
}

shared_scripts {
    '@ox_lib/init.lua',

    'apps/dispatch/shared/config.lua',
    'apps/dmvschool/shared/cfg_dmvschool.lua',
    'apps/fishing/shared/config.lua',
    'apps/gangbuilder/shared/config.lua',
    'apps/garage/shared/cfg_carGarage.lua',
    'apps/gunfight/shared/cfg_gunfight.lua',
    'apps/gunfight/shared/cfg_interface.lua',
    'apps/illtablet/config_map.lua',
    'apps/illtablet/config_activities.lua',
    'apps/location/shared/cfg_loc.lua',
    'apps/poltablet/config.lua',
    'apps/weedpots/shared/config.lua',
    'apps/merged/shared/cfg_containerheist.lua',
    'apps/merged/shared/cfg_koth.lua',
    'apps/merged/shared/cfg_radiokeeper.lua',
    'apps/merged/shared/config.lua',
}

client_scripts {
    'shared/rageui/RMenu.lua',
    'shared/rageui/menu/RageUI.lua',
    'shared/rageui/menu/Menu.lua',
    'shared/rageui/menu/MenuController.lua',
    'shared/rageui/components/*.lua',
    'shared/rageui/menu/elements/*.lua',
    'shared/rageui/menu/items/*.lua',
    'shared/rageui/menu/panels/*.lua',
    'shared/rageui/menu/windows/*.lua',

    'apps/bank/client/client.lua',

    'apps/boutique/client/client.lua',

    'apps/charcreator/client/cl_starter.lua',
    'apps/charcreator/client/client.lua',

    'apps/clothesshop/client/client.lua',

    'apps/dispatch/client/client.lua',

    'apps/dmvschool/client/client.lua',

    'apps/fishing/client/cl_main.lua',

    'apps/gangbuilder/client/*.lua',

    'apps/garage/client/*.lua',

    'apps/gunfight/configuration.lua',
    'apps/gunfight/client/*.lua',

    'apps/illtablet/cl_main.lua',

    'apps/location/client/client.lua',

    'apps/poltablet/client/main.lua',

    'apps/quest/client/cl_main.lua',

    'apps/staffui/client/cl_main.lua',

    'apps/weedpots/client/client.lua',

    'apps/merged/client/*.lua',
}

server_scripts {
    'sv_gc.lua',
    '@oxmysql/lib/MySQL.lua',

    'apps/bank/server.lua',

    'apps/boutique/server/*.lua',

    'apps/charcreator/server/*.lua',

    'apps/clothesshop/server/*.lua',

    'apps/dispatch/server/*.lua',

    'apps/dmvschool/server/*.lua',

    'apps/fishing/server/*.lua',

    'apps/gangbuilder/server/*.lua',

    'apps/garage/server/*.lua',

    'apps/gunfight/server/*.lua',

    'apps/illtablet/srv_main.lua',

    'apps/location/server/*.lua',

    'apps/poltablet/server/main.lua',

    'apps/quest/server/sv_main.lua',

    'apps/weedpots/server/*.lua',

    'apps/merged/server/*.lua',
}
