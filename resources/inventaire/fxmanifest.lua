fx_version "cerulean"
game "gta5"
lua54 "yes"

escrow_ignore {
    "config/*.lua",
    'server/**/*.lua',
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/cagoule.html",
    "web/img/cagoule.png",
    -- Visuels des badges rendus en DUI (cf. permis.lua, ensureBadgeArt).
    "web/badge_bobcat.html",
    "web/badge_lsfd.html",
    "web/badge_gouv.html",
    -- Icones d'items absentes de item_icon.ytd (cf. client/lib/_item_icons.lua).
    "web/img/items/desinfectant.png",
    "web/img/items/permisbobcat.png",
    "web/img/items/permisgouv.png"
}

client_scripts {
    "config/*.lua",
    "client/**/*.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "config/*.lua",
    "server/*.lua",
}

dependencies {
    '/assetpacks',
}