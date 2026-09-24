ConfigAirdrop = {}
math.randomseed(GetGameTimer())

ConfigAirdrop.DropDownTime = 2 * 60 * 1000
ConfigAirdrop.DropWaitTime = 60

ConfigAirdrop.PlayersCheck = false
ConfigAirdrop.HowPlayers = 30

ConfigAirdrop.CaseProp = "ex_prop_adv_case_sm"
ConfigAirdrop.ParachuteProp = "p_cargo_chute_s"
ConfigAirdrop.Coords = {
    {x = -2230.9372558594, y = 2418.3537597656, z = 12.176334381104},
    {x = 3899.4807128906, y = -4715.5209960938, z = 6.5947694778442},
    {x = -307.73977661133, y = 3791.4096679688, z =  67.658248901367},
}

ConfigAirdrop.DropComingMessage = {
    {"Dans 10 minutes,"},
    {"un airdrop est en train d'arriver"}
}

ConfigAirdrop.DropCome = {
    ["title"] = "AirDrop",
    ["msg"] = "Un AirDrop est arrivé !",
    ["showSeconds"] = 5
}

ConfigAirdrop.GiveDropItemsCount = 1
ConfigAirdrop.Items = {
    ["item"] = {
        ["WEAPON_ASSAULTRIFLE"] = 0.80,
        ["WEAPON_PISTOL"] = 0.50,
        ["WEAPON_COMPACTRIFLE"] = 0.30,
        ["WEAPON_ADVANCEDRIFLE"] = 0.20,
        ["WEAPON_MINISMG"] = 0.05,
        ["WEAPON_MICROSMG"] = 0.05,
        ["WEAPON_COMBATPDW"] = 0.05,
    },
}

ConfigAirdrop.TotalRarity = 2
