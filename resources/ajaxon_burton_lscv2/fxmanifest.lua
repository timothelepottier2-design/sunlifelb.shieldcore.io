fx_version 'cerulean'
game 'gta5'
author 'Ajaxon'
description 'BurtonLSCV2'
version '2.0.1'
this_is_a_map 'yes'
lua54 'yes'

dependencies { 
    '/server:7290',
    '/gameBuild:2545',
    'ajaxon_mapdata',
}

escrow_ignore {
    'stream/**/*.ytd',
    'stream/**/*.ybn',
    'stream/*/basegame/**/*',
}
dependency '/assetpacks'