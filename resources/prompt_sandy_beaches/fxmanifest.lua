

fx_version 'bodacious'
game 'gta5'
this_is_a_map 'yes'

-- map by---:
author 'prompt'
scriptdeveloper 'Cas.vdv'
description 'Sandy Shores Marina'
version '1.1'

escrow_ignore {
    'stream/unlocked/**',
    '**/*.lua'

}

server_scripts {
    'weather_prop_controllers.lua'
}

data_file "DLC_ITYP_REQUEST" "stream/prompt_sandy_dynamic_weather_props.ytyp"

client_scripts {
    'weather_prop_controller.lua'
}

shared_scripts {
    'config.lua'
}
lua54 'yes'



dependency '/assetpacks'
dependency '/assetpacks'