fx_version 'cerulean'
description 'Car'
author 'discord.gg/dccars'
game 'gta5'
files {
	'data/carcols.meta',
	'data/carvariations.meta',
	'data/dlctext.meta',
	'data/handling.meta',
	'data/vehicles.meta',
	'data/*.meta',
	"audioconfig/*.dat151.rel",
	"audioconfig/*.dat54.rel",
	"audioconfig/*.dat10.rel",
	"sfx/**/*.awc"
}
data_file 'DLCTEXT_FILE' 'data/dlctext.meta'
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
data_file "AUDIO_SYNTHDATA" "audioconfig/camls3v8_amp.dat"
data_file "AUDIO_GAMEDATA" "audioconfig/camls3v8_game.dat"
data_file "AUDIO_SOUNDDATA" "audioconfig/camls3v8_sounds.dat"
data_file "AUDIO_WAVEPACK" "sfx/dlc_camls3v8"

lua54 'yes'
dependency '/assetpacks'
dependency '/assetpacks'