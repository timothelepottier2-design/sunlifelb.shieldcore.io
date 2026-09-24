fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'G&Ns Studio'
description 'Las Venturas IPL Loader'
version '2.1.0'

client_scripts {
    'config.lua',
    'client/ipl_config.lua',
    'client/entityset_config.lua',
    'client/main.lua'
}

escrow_ignore {
    'config.lua',
    'entityset_config.lua'
}
dependency '/assetpacks'