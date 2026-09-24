fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '9Labs'
description '9LABS movement: directional peeking and ledge grabs'
version '1.0.1'

shared_script '@ox_lib/init.lua'
client_script 'client/bundle.lua'

files {
    'config.lua',
    'client/bridge.lua',
    'locales/*.json'
}

dependencies { 'ox_lib' }

escrow_ignore {
    'config.lua',
    'client/bridge.lua',
    'locales/*.json'
}

dependency '/assetpacks'