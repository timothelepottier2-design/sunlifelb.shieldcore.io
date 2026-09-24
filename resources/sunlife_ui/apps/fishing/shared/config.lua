FishingConfig = {}

FishingConfig.UseESXNotification = true

FishingConfig.FishingKey = 23

FishingConfig.FishingRodItem = "canne"

FishingConfig.FishingPrimeRankNames = { "legendary", "platinium" }

FishingConfig.FishingAutoToggleKey = 303
FishingConfig.FishingAutoToggleKeyLabel = "U"

FishingConfig.FishingDebugPrimeRank = false

FishingConfig.Minigame = {
    baseDuration = 8000,
    baseDecayPerTick = 2.0,
    baseGainPerPress = 16.0,
    tickInterval = 100
}

FishingConfig.FishingXP = {
    catchBase = 15,
    perKg = 5,
    perDifficulty = 10,
    perSellDollar = 0.04
}

FishingConfig.FishingZones = {
    {
        name = "plage_debutant",
        label = "Zone de pêche",
        coords = vector3(-1804.7080, -1244.6612, 8.6193),
        radius = 35.0,
        difficultyMultiplier = 1.0,
        illegal = false,
        minLevel = 1,
        fishes = {
            {item = "fish_sardine", label = "Sardine", minWeight = 0.2, maxWeight = 0.6, baseDifficulty = 0.8, chance = 45, price = 882, rarity = 1, catchXP = 15, sellXP = 5},
            {item = "fish_perche", label = "Perche", minWeight = 0.5, maxWeight = 1.2, baseDifficulty = 0.9, chance = 30, price = 1103, rarity = 1, catchXP = 18, sellXP = 6},
            {item = "fish_bar", label = "Bar", minWeight = 1.0, maxWeight = 3.0, baseDifficulty = 1.0, chance = 25, price = 2205, rarity = 2, catchXP = 25, sellXP = 10}
        }
    },
    {
        name = "cote_intermediaire",
        label = "Zone de pêche",
        coords = vector3(3373.8735351562, 5183.439453125, 1.4664993286133),
        radius = 40.0,
        difficultyMultiplier = 1.2,
        illegal = false,
        minLevel = 5,
        fishes = {
            {item = "fish_bar", label = "Bar", minWeight = 1.5, maxWeight = 4.0, baseDifficulty = 1.1, chance = 35, price = 1103, rarity = 2, catchXP = 28, sellXP = 11},
            {item = "fish_dorade", label = "Dorade", minWeight = 1.0, maxWeight = 2.5, baseDifficulty = 1.2, chance = 30, price = 1544, rarity = 2, catchXP = 30, sellXP = 12},
            {item = "fish_truite", label = "Truite", minWeight = 0.8, maxWeight = 2.0, baseDifficulty = 1.1, chance = 20, price = 1544, rarity = 2, catchXP = 27, sellXP = 11},
            {item = "fish_sole", label = "Sole", minWeight = 0.7, maxWeight = 1.8, baseDifficulty = 1.2, chance = 15, price = 1764, rarity = 2, catchXP = 32, sellXP = 13}
        }
    },
    {
        name = "large_confirme",
        label = "Zone de pêche",
        coords = vector3(-1614.9276123047, 5260.126953125, 3.9741010665894),
        radius = 55.0,
        difficultyMultiplier = 1.4,
        illegal = false,
        minLevel = 10,
        fishes = {
            {item = "fish_thon", label = "Thon", minWeight = 5.0, maxWeight = 15.0, baseDifficulty = 1.1, chance = 40, price = 3308, rarity = 3, catchXP = 40, sellXP = 18},
            {item = "fish_dorade_royale", label = "Dorade royale", minWeight = 2.0, maxWeight = 4.0, baseDifficulty = 1.1, chance = 25, price = 3528, rarity = 3, catchXP = 45, sellXP = 20},
            {item = "fish_lotte", label = "Lotte", minWeight = 3.0, maxWeight = 6.0, baseDifficulty = 1.2, chance = 20, price = 3528, rarity = 3, catchXP = 50, sellXP = 22},
            {item = "fish_silure", label = "Silure", minWeight = 10.0, maxWeight = 25.0, baseDifficulty = 1.1, chance = 15, price = 4190, rarity = 3, catchXP = 55, sellXP = 24}
        }
    },
    {
    name = "jetee_nord_illegal",
    label = "Zone de pêche",
    coords = vector3(1694.8364257812, 40.450218200684, 161.76741027832),
    radius = 30.0,
    difficultyMultiplier = 1.5,
    illegal = true,
    minLevel = 13,
    fishes = {
        {item = "fish_thon_rouge", label = "Thon rouge", minWeight = 8.0, maxWeight = 20.0, baseDifficulty = 1.1, chance = 40, price = 2646, rarity = 4, catchXP = 70, sellXP = 30},
        {item = "fish_espadon", label = "Espadon", minWeight = 12.0, maxWeight = 35.0, baseDifficulty = 1.0, chance = 35, price = 1764, rarity = 4, catchXP = 80, sellXP = 35},
        {item = "fish_marlin_bleu", label = "Marlin bleu", minWeight = 15.0, maxWeight = 40.0, baseDifficulty = 1.2, chance = 25, price = 3087, rarity = 4, catchXP = 90, sellXP = 40}
    }
},
{
    name = "epave_requins",
    label = "Zone de pêche",
    coords = vector3(3574.8991699219, 7743.533203125, -0.80170297622681),
    radius = 45.0,
    difficultyMultiplier = 1.8,
    illegal = true,
    minLevel = 17,
    fishes = {
        {item = "fish_requin", label = "Requin", minWeight = 80.0, maxWeight = 150.0, baseDifficulty = 1.2, chance = 50, price = 3969, rarity = 5, catchXP = 110, sellXP = 50},
        {item = "fish_requin_blanc", label = "Requin blanc", minWeight = 150.0, maxWeight = 300.0, baseDifficulty = 1.5, chance = 30, price = 6615, rarity = 5, catchXP = 140, sellXP = 65},
        {item = "fish_poisson_scie", label = "Poisson-scie", minWeight = 60.0, maxWeight = 200.0, baseDifficulty = 1.3, chance = 20, price = 6174, rarity = 5, catchXP = 125, sellXP = 58}
    }
},
{
    name = "fosse_abyssale",
    label = "Zone de pêche",
    coords = vector3(5947.329590, -434.597321, 27.078203),
    radius = 55.0,
    difficultyMultiplier = 2.0,
    illegal = true,
    minLevel = 25,
    fishes = {
        {item = "fish_calmar_geant", label = "Calmar géant", minWeight = 100.0, maxWeight = 250.0, baseDifficulty = 1.2, chance = 40, price = 8379, rarity = 5, catchXP = 160, sellXP = 75},
        {item = "fish_poisson_abyssal", label = "Poisson abyssal", minWeight = 20.0, maxWeight = 80.0, baseDifficulty = 1.3, chance = 35, price = 9702, rarity = 5, catchXP = 170, sellXP = 80},
        {item = "fish_coelacanthe_geant", label = "Cœlacanthe géant", minWeight = 40.0, maxWeight = 120.0, baseDifficulty = 1.1, chance = 25, price = 6174, rarity = 5, catchXP = 190, sellXP = 90}
    }
}

}

FishingConfig.FishVendors = {
    {
        id = "vendor_plage_sud",
        label = "Poissonnier",
        coords = vector3(-1500.8615722656, -934.54608154297, 10.173578262329),
        heading = 139.53800964355,
        pedModel = "s_m_m_fisherman_01",
        type = "legal",
        accepts = {
            "fish_sardine",
            "fish_perche",
            "fish_truite",
            "fish_carpe"
        },
        priceMultiplier = 1.0
    },
    {
        id = "vendor_jetee_nord",
        label = "Grossiste",
        coords = vector3(2455.3330078125, 4058.4401855469, 38.064716339111),
        heading = 246.9647064209,
        pedModel = "s_m_m_dockwork_01",
        type = "legal",
        accepts = {
            "fish_bar",
            "fish_dorade",
            "fish_truite",
            "fish_sole",
            "fish_dorade_royale",
            "fish_lotte",
            "fish_thon",
            "fish_silure"
        },
        priceMultiplier = 1.15
    },
    {
        id = "vendor_illegal_large",
        label = "Repreneur douteux",
        coords = vector3(7390.854492, 293.085175, 58.208885),
        heading = 132.9292755127,
        pedModel = "g_m_y_mexgoon_02",
        type = "illegal",
        accepts = {
            "fish_thon_rouge",
            "fish_espadon",
            "fish_marlin_bleu",
            "fish_requin",
            "fish_requin_blanc",
            "fish_poisson_scie",
            "fish_calmar_geant",
            "fish_coelacanthe_geant",
            "fish_poisson_abyssal",
            "fish_raie_manta"
        },
        priceMultiplier = 1.4
    }
}

FishingConfig.IllegalFish = {
    fish_thon_rouge = true,
    fish_espadon = true,
    fish_marlin_bleu = true,
    fish_requin = true,
    fish_requin_blanc = true,
    fish_poisson_scie = true,
    fish_calmar_geant = true,
    fish_coelacanthe_geant = true,
    fish_poisson_abyssal = true,
    fish_raie_manta = true
}
