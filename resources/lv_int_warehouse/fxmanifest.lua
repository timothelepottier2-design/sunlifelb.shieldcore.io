fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'G&N_s Studio'
description 'Fort Carson - Warehouse'
version '2.0.0'

this_is_a_map 'yes'

shared_script 'entityset/config.lua'
client_script 'entityset/main.lua'

dependencies {
    'lv_interior'
}

data_file 'AUDIO_GAMEDATA' 'audio/warehouse1_game.dat'
data_file 'TIMECYCLEMOD_FILE' 'gn_warehouse_timecycles.xml'

files {
    'audio/warehouse1_game.dat151.rel',
    'gn_warehouse_timecycles.xml'
}
escrow_ignore {
    'entityset/config.lua',
    'entityset/main.lua',
    'stream/**/*.ytd'
}

dependency '/assetpacks'