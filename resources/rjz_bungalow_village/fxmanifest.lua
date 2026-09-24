fx_version 'cerulean'
game 'gta5'

this_is_a_map 'yes'

files {		
	"audio/*.dat151.rel"
}

data_file "AUDIO_GAMEDATA" "audio/rjz_bungalow_village_game.dat"
data_file "AUDIO_GAMEDATA" "audio/rojizo_bungalowdoors_game.dat"

data_file "DLC_ITYP_REQUEST" "stream/ext/metadata/rjz_bv_ext.ytyp"
data_file "DLC_ITYP_REQUEST" "stream/int/metadata/rjz_bungalow_models.ytyp"

escrow_ignore {
  'minimap/minimap_1_6.ydd',
  'minimap/minimap_2_6.ydd',
  'stream/ext/models/rjz_bv_ext_housenumber.ydd'
}
dependency '/assetpacks'