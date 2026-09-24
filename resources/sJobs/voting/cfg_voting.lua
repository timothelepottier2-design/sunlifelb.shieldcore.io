cfg_voting = {}

cfg_voting.adminGroups = {
    ['superadmin'] = true,
    ['owner']      = true,
}

cfg_voting.defaultTitle = "Élections du Gouvernement"

cfg_voting.defaultCandidates = {
    "Candidat 1",
    "Candidat 2",
}

cfg_voting.marker = {
    type        = 20,
    size        = vec3(0.35, 0.35, 0.25),
    color       = { r = 255, g = 117, b = 31, a = 200 },
    zOffset     = 1.15,
    bobUpAndDown = true,
    rotate      = true,
}

cfg_voting.drawDistance     = 15.0
cfg_voting.interactDistance = 1.2

cfg_voting.serverCheckDistance = 4.0

cfg_voting.booths = {
    { coords = vec3(-412.862183, 1089.707520, 328.772430), heading = 168.53221130371 },
    { coords = vec3(-411.611420, 1089.410156, 328.772369), heading = 165.21296691895 },
    { coords = vec3(-410.365723, 1089.037476, 328.772400), heading = 165.07281494141 },
    { coords = vec3(-409.109436, 1088.729858, 328.772400), heading = 167.56166076660 },
    { coords = vec3(-407.874237, 1088.309082, 328.776489), heading = 165.43151855469 },
    { coords = vec3(-406.603333, 1092.571045, 328.772125), heading = 346.81710815430 },
    { coords = vec3(-407.831543, 1092.811646, 328.772125), heading = 345.94039916992 },
    { coords = vec3(-409.089325, 1093.154053, 328.772125), heading = 347.42138671875 },
    { coords = vec3(-410.342926, 1093.531250, 328.772125), heading = 347.25338745117 },
    { coords = vec3(-411.613678, 1093.900879, 328.772186), heading = 348.72784423828 },
}
