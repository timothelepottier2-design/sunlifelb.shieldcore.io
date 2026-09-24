fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Fort Carson Fire Deparmtent'
version '1.0.2'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'lv_interior'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/audio_firestation_game.dat'
data_file 'AUDIO_GAMEDATA' 'audio/int_firestation_game.dat'
data_file 'TIMECYCLEMOD_FILE' 'gn_fire_timecycle.xml'

files {
  'audio/audio_firestation_game.dat151.rel',
  'audio/int_firestation_game.dat151.rel',
  'gn_fire_timecycle.xml'
}

escrow_ignore {
  'stream/replace/*.ydr',
  'stream/replace/*.ybn',
  'stream/replace/*.ymap',
  'stream/replace/*.ydd',
  'stream/unlock_file/*.ytd',
  'stream/unlock_file/*.ydr'
}
dependency '/assetpacks'