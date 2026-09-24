fx_version 'cerulean'
lua54 'yes'
game "gta5"

author 'TStudio - mandatory mapdata'
description 'TStudio Mapdata - important for TStudio maps'
version '1.0'

this_is_a_map 'yes'

dependencies { 
    '/server:4960',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 4960.
    '/gameBuild:2545',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2545.
}

data_file 'TIMECYCLEMOD_FILE' 'tstudio_timecycles.xml'

shared_script {
    'config.lua',
}

client_scripts {
    'client/activate_ipl.lua',
    'client/entitysets_loader.lua',
    'client/ipl_blocker.lua',
    'client/privacy_glass.lua',
    'client/utils.lua',
}

server_scripts {
    'server/misc.lua',
    'server/patch_loader.lua',
}

files {
    'tstudio_timecycles.xml',
}

escrow_ignore {
    'stream/*/*.*',
    'locales/*.lua', 
    'config.lua',
}

dependency '/assetpacks'