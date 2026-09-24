PolConfig = {}

PolConfig.FrameColor = "#0a0a0a"
PolConfig.BackgroundColor = "#1c1b22"

PolConfig.OpenCommand = "SNL_PolTablet:open"
PolConfig.OpenKeyDefault = ""

PolConfig.TabletModel = `prop_cs_tablet`
PolConfig.TabletOffset = vector3(0.05, -0.005, -0.04)
PolConfig.TabletRotation = vector3(0.0, 180.0, 0.0)

PolConfig.Item = {}
PolConfig.Item.Require = true
PolConfig.Item.Name = "tablette"

PolConfig.AllowedJobs = {"police", "sheriff", "marshall", "doj"}

PolConfig.MapBounds = { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }

PolConfig.MapImageSize = { width = 2048, height = 2048 }

PolConfig.MapControlPoints = {
    { name = "Del Perro P",           gameX = -1664.296753,  gameY = -730.573975,   px = 667, py = 1505 },
    { name = "Port of South LS L",    gameX = -35.808758,    gameY = -2594.004639,  px = 938, py = 1806 },
    { name = "East Los Santos L",     gameX = 1114.065796,   gameY = -1624.873901,  px = 1122, py = 1650 },
    { name = "Tongva Hills G",        gameX = -2369.704102,  gameY = 1965.001099,   px = 535, py = 1053 },
    { name = "Grand Senora Desert S", gameX = 1375.828369,   gameY = 2940.208984,   px = 1167, py = 893 },
    { name = "Mount Gordo M",         gameX = 2571.816895,   gameY = 6006.600098,   px = 1360, py = 390 },
    { name = "Paleto Bay O",          gameX = 152.140533,    gameY = 6794.188477,   px = 965, py = 263 },
}

PolConfig.MapLinear = true
PolConfig.MapYFlipped = false
PolConfig.MapSwapXY = false
PolConfig.EnableMapAgents = true

PolConfig.MapAgentCacheIntervalSec = 30

PolConfig.Profiles = {}
PolConfig.Profiles.Tables = {
    Users = "users",
    OwnedVehicles = "owned_vehicles",
    OwnedProperty = "owned_property",
}
PolConfig.Profiles.MaxSearchResults = 50
PolConfig.Profiles.CacheRefreshMinutes = 5

PolConfig.Profiles = {}
PolConfig.Profiles.Framework = "esx"
PolConfig.Profiles.Tables = {}
PolConfig.Profiles.Tables.Users = "users"
PolConfig.Profiles.Tables.OwnedVehicles = "owned_vehicles"
PolConfig.Profiles.Tables.OwnedProperty = "owned_property"
PolConfig.Profiles.CacheRefreshMin = 5
PolConfig.Profiles.MaxSearchResults = 50

PolConfig.Fivemanage = {}
PolConfig.Fivemanage.AllowedDomains = { "fivemanage.com", "r2.fivemanage.com", "fmfile.com" }

PolConfig.Fivemanage.ApiKey = "SCz75Qcl87AN0w6bsfIcrY7R5MiaJBXM"

PolConfig.Fivemanage.UploadUrl = "https://api.fivemanage.com/api/v2/image"

PolConfig.PhotoExitDelayMs = 200
