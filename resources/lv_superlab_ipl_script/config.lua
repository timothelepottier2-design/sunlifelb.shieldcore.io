Config = {}

-- Easy config
FortCarson_lab = true

-- Configuration pour les superlabs
Config.Superlabs = {
    LosSantos = {
        Enabled = FortCarson_lab,
        ipl = "fc_interior_int_superlab_milo_",
        mlo = "int_gn_superlab",
        pos = {7387.073, 268.575134, 53.3618546},
        EntitySet = {
            On = "with_access",
            Off = "without_access"
        },
        Laundry = {
            mlo = "int_gn_laundry",
            pos = {7387.074, 272.1649, 56.8418922},
            EntitySet = {
                On = "with_superlab_access",
                Off = "without_superlab_access"
            }
        }
    }
}

