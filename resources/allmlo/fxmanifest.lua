fx_version 'bodacious'
game 'gta5'

this_is_a_map 'yes'

--XML files

data_file 'TIMECYCLEMOD_FILE' 'data/gta_props_fivem/timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'data/playboy/content.xml'
data_file 'TIMECYCLEMOD_FILE' 'data/playboy/setup2.xml'
data_file 'TIMECYCLEMOD_FILE' 'data/burgershot/bs_timecycmod.xml'

--Meta files

data_file 'INTERIOR_PROXY_ORDER_FILE' 'data/grapeseedbunker/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'data/ls_black_white/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'data/unicorn/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'data/tunnelhideout/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'data/hospital/interiorproxies.meta'

data_file 'DLC_ITYP_REQUEST' 'stream/cityhall/fluorine4305_cityholl.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/no_gas_explosion/mads_no_exp_pumps.ytyp'

--All files

files {
	'MINIMAP_LOADER.gfx',
	'data/grapeseedbunker/interiorproxies.meta',
	'data/gta_props_fivem/timecycle_mods_1.xml',
	'data/ls_black_white/interiorproxies.meta',
	'data/mrpd/gabz_mrpd_timecycle.xml',
	'data/unicorn/interiorproxies.meta',
	'data/tunnelhideout/interiorproxies.meta',
	'data/hospital/interiorproxies.meta',
	'data/playboy/content.xml',
	'data/playboy/setup2.xml',
	'data/urgence_floor/gusepe_timecycle_mods_1.xml',
	'data/burgershot/bs_timecycmod.xml'
}

--Client files

client_script {
	"client/cl_roxwood.lua",
    "client/cl_cayo.lua",
	"client/cl_nightclub.lua",
	"client/cl_paletopd.lua",
	"client/cl_sandysheriff.lua",
	"client/gabz_mrpd_entitysets.lua",
	"client/cl_lostmc.lua",
	"client/cl_minimap.lua",
	"client/cl_karting.lua"
}