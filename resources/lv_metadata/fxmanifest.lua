lua54 'yes'
fx_version 'cerulean'
games { 'gta5' }

author 'Las Venturas Team'
description 'Las Venturas Metadata'
version '2.1.0'

this_is_a_map 'yes'
before_level_meta 'data'

replace_level_meta 'meta/gta5'

client_scripts {
  'scripts/cl_bounds.lua',
  'scripts/zone_names.lua',
  'scripts/map.lua',
  'scripts/client.lua',     -- tp tunnel
}

files {
  'lv_timecycle_mods.xml',
	'popzone.ipl',
	'global.gxt2',
  'data.meta',
  'heightmap.dat',
  'meta/gta5.meta',
  --'meta/water.xml',
  'audio/fc_emitter.game.dat151.rel',
  'audio/striphouse_game.dat151.rel'
  --'lasventuras.meta',
  --"zonebind.meta",
}



data_file 'TIMECYCLEMOD_FILE' 'lv_timecycle_mods.xml'
data_file 'AUDIO_GAMEDATA' 'audio/fc_emitter.game.dat'
data_file 'AUDIO_GAMEDATA' 'audio/striphouse_game.dat'
--data_file 'ZONEBIND_FILE' 'zonebind.meta'

escrow_ignore {
  'scripts/cl_bounds.lua',
  'scripts/zone_names.lua',
  'scripts/map.lua',
  'scripts/client.lua',
  'meta/gta5.meta',
  'meta/heightmap.dat'
}
dependency '/assetpacks'