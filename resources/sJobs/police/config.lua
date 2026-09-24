PoliceConfig = PoliceConfig or {}

PoliceConfig.Enabled              = true
PoliceConfig.ArrestDistance       = 3.0
PoliceConfig.EnableHandcuffTimer  = false
PoliceConfig.HandcuffTimer        = 10 * 60000

PoliceConfig.AllowedJobs = {
    police   = true,
    sheriff  = true,
    marshall = true,
}

PoliceConfig.ArrestKey            = "G"
PoliceConfig.ArrestRequireShift   = true

PoliceConfig.ArrestCooldown       = 4000
