-- DMCA NOTICE:
-- This resource is protected by copyright law.
-- Unauthorized copying, redistribution, resale, or reupload is prohibited.
-- If you are not an authorized customer/license holder, remove this resource immediately.

fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

client_script 'client.lua'

files {

	'dlccustomweaponsounds/darkmatter_sounds.awc',

	'sounds_dat/**/*.dat151.rel',
	'sounds_dat/**/*.dat54.rel',

    "audio/**/*",
    "data/**/*",
    "metas/**/*",

    'data/dat/darkmatter2fx.dat'

}

before_level_meta 'metas/metadat/darkmatter2'

data_file 'AUDIO_WAVEPACK' 'dlccustomweaponsounds'

data_file 'AUDIO_SOUNDDATA' 'sounds_dat/darkmatter_sounds.dat'
data_file 'AUDIO_GAMEDATA' 'sounds_dat/darkmatter_game.dat'

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/*.meta'
data_file 'WEAPON_METADATA_FILE' '**/*.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/*.meta'
data_file 'PED_PERSONALITY_FILE' '**/*.meta'
data_file 'WEAPONINFO_FILE' '**/*.meta'

data_file "DLC_ITYP_REQUEST" "stream/darkmatter/01_animetion/weapons_darkmatter.ytyp"

author 'OMEX Studio <hello@omex.gg>'
version "2.0"

dmca_notice 'This resource is protected by copyright law. Unauthorized redistribution, resale, leaks, or reuploads are prohibited.'
copyright_owner 'OMEX Studio — Operated By ZIRAFLIX DESENVOLVIMENTO DE SOFTWARE LTDA - 47.733.534/0001-90'
support_url 'https://omex.gg'

dependency '/assetpacks'