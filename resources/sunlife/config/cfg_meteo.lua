cfg_meteo = {}

cfg_meteo.CheckInsideZoneInterval = 15000

cfg_meteo.ClothingTemperatureEffect = false

cfg_meteo.TemperatureEffectInterval = 60000

cfg_meteo.PerClothFeeling = 5

cfg_meteo.ConvertFahrenheitToCelsius = true

cfg_meteo.DegreeForWarmthBalance = 0

cfg_meteo.MinimumColdStartLevel = -20

cfg_meteo.MinimumPerspirationStartLevel = 2

cfg_meteo.CriticalColdLevel = -50

cfg_meteo.CriticalPerspirationLevel = 50

cfg_meteo.GiveDamage = false

cfg_meteo.Damage = 0

cfg_meteo.WarmthEffect = false

cfg_meteo.WarmthNotifications = false

cfg_meteo.WarmthEffectInterval = 15000

cfg_meteo.ChangeTimeFadeEffectOnEnter = false

cfg_meteo.ColdWeatherConditions = {
    "THUNDER"
}

cfg_meteo.RealTimeAlways = false

cfg_meteo.PerspirationWeatherConditions = {
    "EXTRASUNNY","CLEAR"
}

cfg_meteo.ClothingFeelings = {
    Cold = {

    },
    Perspiration = {
        [11] = {
            7
        }
    }
}

cfg_meteo.ZoneList = {

}

cfg_meteo.Translation = {
    ["sweating"] = "Vous avez chaud",
    ["cold"] = "Vous avez froid",
    ["hypothermia"] = "Vous êtes en hypothermie",
    ["faint"] = "Vous avez extrêmement chaud",
}
