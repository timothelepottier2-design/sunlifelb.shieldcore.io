fx_version "cerulean"
games { 'gta5' }
lua54 'yes'

author 'G&N_s Studio'
description 'Fort Carson - Medical Center'
version '1.0.0'

this_is_a_map 'yes'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'lv_interior'
}

client_scripts {
  'config.lua',

  'lib/rageui/RageUI.lua',
  'lib/rageui/Menu.lua',
  'lib/rageui/MenuController.lua',
  'lib/rageui/components/*.lua',
  'lib/rageui/elements/*.lua',
  'lib/rageui/items/*.lua',

  'client/client.lua',
  'client/menu.lua'
}

data_file 'AUDIO_GAMEDATA' 'audio/dualmedic.game.dat'

files {
    'audio/dualmedic.game.dat151.rel'
}

escrow_ignore {
  'stream/**/*.ytd',
  'config.lua',
  'lib/rageui/RageUI.lua',
  'lib/rageui/Menu.lua',
  'lib/rageui/MenuController.lua',
  'lib/rageui/components/*.lua',
  'lib/rageui/elements/*.lua',
  'lib/rageui/items/*.lua',
  'client/client.lua',
  'client/menu.lua'
}

dependency '/assetpacks'