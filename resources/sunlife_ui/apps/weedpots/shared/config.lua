WeedConfig = {}

WeedConfig.TargetDistance = 2.0
WeedConfig.SpawnDistance = 80.0
WeedConfig.DespawnDistance = 95.0
WeedConfig.MaxPlantsPerPlayer = 20

WeedConfig.WaterPerUse = 35
WeedConfig.MaxWater = 100
WeedConfig.WaterRequiredToGrow = 60

WeedConfig.PlaceItem = "weed_pot"
WeedConfig.WaterItem = "watering_can"
WeedConfig.HarvestRewardItem = "weed"
WeedConfig.HarvestRewardAmount = { min = 8, max = 14 }

WeedConfig.HarvestItemWeight = 0.01

WeedConfig.WaterItemLabel = "Arrosoir"
WeedConfig.ItemWeight = 0.5

WeedConfig.WaterDecayPerMinute = 2
WeedConfig.MinWaterPctToGrow = 0.30

WeedConfig.AuthorizedPoliceJobs = {
    police = true,
    sheriff = true
}

WeedConfig.Variants = {
    green = { "bam_prop_weed_green_01_a", "bam_prop_weed_green_01_b", "bam_prop_weed_green_01_c" },
    blu = { "bam_prop_weed_blu_01_a", "bam_prop_weed_blu_01_b", "bam_prop_weed_blu_01_c" },
    purp = { "bam_prop_weed_purp_01_a", "bam_prop_weed_purp_01_b", "bam_prop_weed_purp_01_c" }
}

WeedConfig.DefaultVariant = "green"

WeedConfig.PotItems = {
    green = { name = "weed_pot_green", label = "Graine (Green)" },
    blu = { name = "weed_pot_blu", label = "Graine (Blue)" },
    purp = { name = "weed_pot_purp", label = "Graine (Purple)" }
}

WeedConfig.HarvestItemWeight = 0.01

WeedConfig.HarvestRewards = {
    green = { name = "weed_green", label = "Weed Green" },
    blu = { name = "weed_blu", label = "Weed Blue" },
    purp = { name = "weed_purp", label = "Weed Purple" }
}

WeedConfig.PotBalance = {
    green = {
        waterRequiredToStart = 50,
        minWaterPctToGrow = 0.20,
        waterDecayPerMinute = 1,
        stageMinutes = { [1] = 18, [2] = 26 },
        harvest = { min = 20, max = 36 }
    },
    blu = {
        waterRequiredToStart = 60,
        minWaterPctToGrow = 0.30,
        waterDecayPerMinute = 2,
        stageMinutes = { [1] = 25, [2] = 35 },
        harvest = { min = 14, max = 24 }
    },
    purp = {
        waterRequiredToStart = 70,
        minWaterPctToGrow = 0.50,
        waterDecayPerMinute = 3,
        stageMinutes = { [1] = 35, [2] = 50 },
        harvest = { min = 8, max = 19 }
    }
}

WeedConfig.DrugEffects = {
    green = {
        duration = 90,
        speedMult = 1.05,
        armor = 5,
        heal = 6,
        nauseaChance = 0.05
    },
    blu = {
        duration = 140,
        speedMult = 1.10,
        armor = 10,
        heal = 10,
        nauseaChance = 0.12
    },
    purp = {
        duration = 180,
        speedMult = 1.50,
        armor = 60,
        heal = 60,
        nauseaChance = 0.05
    }
}
