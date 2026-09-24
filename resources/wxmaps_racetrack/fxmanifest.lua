fx_version 'cerulean'
games {'gta5'}

author 'wolvezx - wxmaps team'
description 'GrandSenoraRaceway, for support join our discord https://discord.gg/sSR2M8c78v'
version '1.0.0'

this_is_a_map "yes"

files {
	'audio/wx_racetrack_audio.dat151.rel',
    'data/gtxd.meta',
	'data/sp_manifest.ymt'
}

client_scripts {
--    'racetrack_entitysets.lua'
      'client.lua'
}

escrow_ignore {
	'stream/TXDs/*',
	'stream/GTA/*',
}

data_file 'AUDIO_GAMEDATA' 'audio/wx_racetrack_audio.dat151'
data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'
data_file 'SCENARIO_POINTS_OVERRIDE_FILE' 'data/sp_manifest.ymt'

--dependency 'wxmaps_commons'
dependency '/assetpacks'