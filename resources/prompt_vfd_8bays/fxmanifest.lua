fx_version 'bodacious'
game 'gta5'
this_is_a_map 'yes'
author 'Prompt Studio'
version '1.1.0'

-- all interior audio (occlusion + reverb + doors + emitters) comes from the shared prompt_audio resource
data_file 'GTXD_PARENTING_DATA' 'data/gtxd.meta'


files {
  'data/gtxd.meta'
}

-- Gym: animated equipment via anim_core, static `gym` entity set as fallback.
shared_script 'gym/config.lua'
server_script 'gym/server.lua'
client_script 'gym/client.lua'

escrow_ignore {
    'stream/unlocked/**',
    'gym/**'
}
dependency '/assetpacks'