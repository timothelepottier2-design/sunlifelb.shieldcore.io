fx_version "cerulean"
games { 'gta5' }

author 'Las Venturas Team'
description 'LV Interior - Main'
version '2.1.0'

-- dependencies {
--   'lv_ipl_loader'
-- }

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/gn_collection/medical_assets/ytyp/nels_medical_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gn_collection/medical_assets/ytyp/gn_medical_assets.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gn_collection/ytyp/gn_assets_collection.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gn_burgershot_timecycle.xml'
data_file 'AUDIO_GAMEDATA' 'audio/gn_illegaldlc_game.dat'

files {
  'gn_burgershot_timecycle.xml',
  'audio/gn_illegaldlc_game.dat151.rel'
}
dependency '/assetpacks'