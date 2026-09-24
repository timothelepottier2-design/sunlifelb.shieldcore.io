Config                            = Config or {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 3500
Config.AntiCombatLog              = true
Config.LoadIpl                    = true
Config.ReviveCount                = 1000

Config.Locale                     = 'fr'

local second = 1000
local minute = 60 * second

Config.BleedoutTimer              = 8 * minute

Config.HospitalReturnMinutes = {
	default   = 8,
	gold      = 8,
	diamond   = 7,
	platinum  = 6,
	platinium = 6,
	legendary = 5
}

Config.PlatreMinutesByVIP = {
	default   = 15,
	gold      = 12,
	diamond   = 9,
	platinum  = 7,
	platinium = 7,
	legendary = 5
}

Config.EmergencyButtonCooldown    = 2.5 * 60

Config.EnablePlayerManagement     = true
