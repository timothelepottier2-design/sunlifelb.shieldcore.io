fx_version 'cerulean'
game 'gta5'

author 'G&N_s Studio'
description 'Las Venturas - Black_Wood_Saloon'
version '4.0.0'

this_is_a_map 'yes'

dependencies {
    '/gameBuild:2189'
}

data_file 'TIMECYCLEMOD_FILE' 'lv_timecycle_mods_saloon.xml'

files {
    'lv_timecycle_mods_saloon.xml',
}

escrow_ignore {
    'stream/**/*.ytd'
}

dependency '/assetpacks'