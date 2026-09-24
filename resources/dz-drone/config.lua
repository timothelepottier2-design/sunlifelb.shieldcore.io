Config = {}

-- QBCore Framework
Config.Framework = "esx" -- Set you framework "qbcore" or "esx" or "" if you use standalone framework and use /drone 1 or 2 command to use the Drone
Config.QBCoreName = "qb-core" -- You QBCore script name must be correct to work (only if you use QBCore Framework)

-- ESX Framework
Config.IsESXLegacy = false -- Set it true is you're using esx legacy (only if you use ESX Framework)
Config.ESXLegacyName = "es_extended" -- You ESX Legacy script name must be correct to work (only if you use ESX Legacy Framework)
Config.SQL = "oxmysql" -- Set the SQL to "oxmysql" or "mysql-async" depends on what you use on you ESX framework

-- Drone Controls
Config.Controls = { -- FiveM Controls: https://docs.fivem.net/docs/game-references/controls/
	Forward			= 32,	-- W for Qwerty / Z for Azerty
	Backward		= 33,	-- S
	Left			= 34,	-- A for Qwerty / Q for Azerty
	Right			= 35,	-- D
	Up				= 51,	-- E
	Down			= 52,	-- Q for Qwerty / A for Azerty
	Stop			= 22,	-- Space
	ZoomOut			= 16,	-- Mouse Scroll Whell Down
	ZoomIn			= 17,	-- Mouse Scroll Whell Up
	Nightvision		= 140,	-- R
	Heatvision		= 75,	-- F
	Spotlight		= 47,	-- G
	ReleaseDrone	= 168,	-- F7
	Scanner			= 24,	-- Left Mouse Button
	Cancel			= 200,	-- ESC
}

Config.SyncDroneSound = false -- if you set it to "true" you may experience a little performance issue, test it
Config.DroneInitAnimations = true -- drone initiation animations (requested by customer)

-- Drone Scanner
Config.ScannerRange = 50.0
Config.ScannerIgnoreMask = false

-- Drone Text Font
Config.TextFont = 4 -- Text font type
Config.TextCustomFont = { -- This option for servers that use custom fonts or other languages - Used Natives: RegisterFontFile(FontName) / RegisterFontId(FontName)
	UseCustomFont = false, -- Set to "true" to enable using custom font
	FontName = '', -- Custom font file name
}

-- Drone Transition
Config.Transition = {
	['direction']       	= 'Direction',
	['height']          	= 'Hauteur',
	['camera']          	= 'Camera',
	['zoom']            	= 'Zoom',
	['nightvision']     	= 'Vision nocturne',
	['heatvision']      	= 'Vision thermique',
	['spotlight']       	= 'Projecteur',
	['scan_player']     	= 'Scanner le lecteur',
	['cancel']          	= 'Annuler',
	['cant_use_drone']  	= 'Vous ne pouvez pas utiliser le drone',
	
	['release_drone']  		= 'Lançer le drone',
	['reconnect_drone']  	= 'Se reconnecter au drone',
	
	['scan_searching']  	= 'Recherche...',
	['scan_searching_db']	= 'Recherche en base de donnée...',
	['scan_unknown']		= 'Inconnue',
	['scan_not_recognized']	= 'La cible ne peut pas être reconnue',
}
Config.UseDroneInVehicle = false

-- This two commands are made for servers that want to toggle ON/OFF the Instructional Buttons or Cam Scaleforms - Default is ON
Config.DroneCamScaleforms = "dronecamscaleforms"
Config.DroneInstructionalButtons = "droneinstructionalbuttons"