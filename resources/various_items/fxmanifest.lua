
fx_version 'cerulean'
game { 'gta5' }

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	-- LVC settings + siren tone definitions (must load before LVC client/server scripts).
	'lvc/SETTINGS.lua',
	'lvc/SIRENS.lua',
}

client_scripts {
	"config/*.lua",
	"client/*.lua",
	"client/photomode/*.lua",
	-- LVC (Luxart Vehicle Control) — siren / horn / HUD.
	-- Load order matters: cl_utils -> cl_hud -> cl_audio -> cl_lvc.
	"lvc/cl_utils.lua",
	"lvc/cl_hud.lua",
	"lvc/cl_audio.lua",
	"lvc/cl_lvc.lua",
	-- Radar avant (utilise les globales veh / player_is_emerg_driver de cl_lvc).
	"lvc/cl_radar.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"config/*.lua",
	"server/*.lua",
	"server/photomode/*.lua",
	"rand.js",
	-- LVC server relay.
	"lvc/sv_lvc.lua",
}

--Boombox + Cahier + LVC NUI:

ui_page('html/index.html')

files {
    'html/index.html',
    'html/app.js',
    'html/cahier.js',
    'html/cahier.css',
    'html/lvc.js',
    'html/lvc.css',
    'html/fonts/*.woff2',
    'html/fonts/*.woff',
    'html/sounds/*.ogg',
    'html/sounds/**/*.ogg',
}

export 'UsingGilet'
-- LVC : afficher / masquer le boitier (F5 > Options).
export 'SetLvcHudVisible'
export 'GetLvcHudVisible'
