lua54 'yes'
fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Von_Crastenburg_Hotel'
version '1.3.1'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}
this_is_a_map 'yes'

client_scripts {
	'remove_ipl.lua'
}

escrow_ignore {
    'remove_ipl.lua',
    'stream/**/*.ytd',
    'stream/exterior/*.ymap'
}


dependency '/assetpacks'