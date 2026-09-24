fx_version 'cerulean'
game 'gta5'
author 'Ajaxon'
description 'Mapdata'
this_is_a_map 'yes'
lua54 'yes'
replace_level_meta 'gta5'

dependencies { 
    '/server:7290',
    '/gameBuild:2545',
}

files {
    'ajaxon_timecycle.xml',
    'gta5.meta',
    'doortuning.ymt',
    'ajaxon_game.dat151.rel',
}

data_file 'TIMECYCLEMOD_FILE' 'ajaxon_timecycle.xml'
data_file 'AUDIO_GAMEDATA' 'ajaxon_game.dat'

client_script {
    'ajaxon_entityset.lua',
}

escrow_ignore {
    'ajaxon_entityset.lua',
}

dependency '/assetpacks'