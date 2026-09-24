DispatchConfig = DispatchConfig or {}

DispatchConfig.MaxCalls = 10

DispatchConfig.KeepCalls = 15

DispatchConfig.AnnounceMs = 10000

DispatchConfig.OpenKey = ''

DispatchConfig.PanelJobs = {
    police  = true,
    sheriff = true,
}

DispatchConfig.Codes = {
    ['10-90'] = { label = 'Braquage en cours',         urgency = 3 },
    ['10-15'] = { label = 'Vol de véhicule',           urgency = 2 },
    ['10-14'] = { label = 'Vol / larcin',              urgency = 2 },
    ['10-31'] = { label = 'Cambriolage',               urgency = 2 },
    ['10-71'] = { label = 'Coups de feu',              urgency = 3 },
    ['10-80'] = { label = 'Course-poursuite',          urgency = 3 },
    ['10-50'] = { label = 'Accident de la route',      urgency = 1 },
    ['10-66'] = { label = 'Activité suspecte',         urgency = 1 },
    ['10-99'] = { label = 'Agent en détresse',         urgency = 3 },
    ['10-20'] = { label = 'Demande de renfort',        urgency = 2 },
    ['10-91'] = { label = 'Trouble à l\'ordre public', urgency = 1 },
    ['10-32'] = { label = 'Vente de stupéfiants',      urgency = 2 },
}

DispatchConfig.ChannelGroups = {
    { id = 'common', label = 'Canaux communs', emoji = '📡' },
    { id = 'lspd',   label = 'Canaux LSPD',    emoji = '🚓' },
    { id = 'bcso',   label = 'Canaux BCSO',    emoji = '🚔' },
}

DispatchConfig.Channels = {

    { id = 'operation', label = 'Opération',  emoji = '🛡️', group = 'common' },
    { id = 'scu',       label = 'SCU',        emoji = '🚨', max = 4, group = 'common' },

    { id = 'lincoln01', label = 'LINCOLN 01', emoji = '🔒', locked = true, max = 1, group = 'lspd' },
    { id = 'adam01',    label = 'ADAM-01',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'adam02',    label = 'ADAM-02',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'adam03',    label = 'ADAM-03',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'adam04',    label = 'ADAM-04',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'adam05',    label = 'ADAM-05',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'adam06',    label = 'ADAM-06',    emoji = '🚓', max = 2, group = 'lspd' },
    { id = 'tango01',   label = 'TANGO-01',   emoji = '🚓', max = 3, group = 'lspd' },
    { id = 'tango02',   label = 'TANGO-02',   emoji = '🔒🚓', locked = true, max = 3, group = 'lspd' },
    { id = 'tango03',   label = 'TANGO-03',   emoji = '🔒🚓', locked = true, max = 3, group = 'lspd' },
    { id = 'tango04',   label = 'TANGO-04',   emoji = '🔒🚓', locked = true, max = 3, group = 'lspd' },
    { id = 'tango05',   label = 'TANGO-05',   emoji = '🔒🚓', locked = true, max = 3, group = 'lspd' },
    { id = 'david01',   label = 'DAVID-01',   emoji = '🔒🚓', locked = true, max = 4, group = 'lspd' },
    { id = 'td',        label = 'TD',         emoji = '🔒', locked = true, group = 'lspd' },
    { id = 'henry',     label = 'HENRY',      emoji = '🔒', locked = true, group = 'lspd' },
    { id = 'marie01',   label = 'MARIE-01',   emoji = '🔒', locked = true, group = 'lspd' },
    { id = 'cu',        label = 'CU',         emoji = '🔒', locked = true, group = 'lspd' },

    { id = 'bcso_lincoln01', label = 'LINCOLN-01', emoji = '🚔', max = 1, group = 'bcso' },
    { id = 'bcso_lincoln02', label = 'LINCOLN-02', emoji = '🚔', max = 1, group = 'bcso' },
    { id = 'bcso_adam01',    label = 'ADAM-01',    emoji = '🚔', max = 2, group = 'bcso' },
    { id = 'bcso_adam02',    label = 'ADAM-02',    emoji = '🚔', max = 2, group = 'bcso' },
    { id = 'bcso_adam03',    label = 'ADAM-03',    emoji = '🚔', max = 2, group = 'bcso' },
    { id = 'bcso_tango01',   label = 'TANGO-01',   emoji = '🚔', max = 3, group = 'bcso' },
    { id = 'bcso_tango02',   label = 'TANGO-02',   emoji = '🚔', max = 3, group = 'bcso' },
    { id = 'bcso_tangoplus', label = 'TANGO+1',    emoji = '🚔', max = 4, group = 'bcso' },

    { id = 'bcso_sierra',    label = 'SIERRA (T.D.)',        emoji = '🎯',  group = 'bcso' },
    { id = 'bcso_mary',      label = 'MARY (Motorisée)',     emoji = '🏍️', max = 2, group = 'bcso' },
    { id = 'bcso_nora',      label = 'NORA (Undercover MCD)',emoji = '🕵️', group = 'bcso' },
    { id = 'bcso_henry',     label = 'HENRY (Héliportée)',   emoji = '🚁', max = 2, group = 'bcso' },
    { id = 'bcso_william',   label = 'WILLIAM (Nautique)',   emoji = '🚤', max = 2, group = 'bcso' },
    { id = 'bcso_victor',    label = 'VICTOR (Cycliste)',    emoji = '🚲', max = 2, group = 'bcso' },
    { id = 'bcso_david',     label = 'DAVID (S.W.A.T.)',     emoji = '🔒', locked = true, max = 4, group = 'bcso' },
    { id = 'bcso_charlie',   label = 'CHARLIE (K-9)',        emoji = '🐕', max = 2, group = 'bcso' },
}

DispatchConfig.ChannelsLockEnforced = false

DispatchConfig.TargetCall = {
    enabled  = true,
    models   = { 1158960338, 1281992692 },
    label    = 'Appeler la police',
    icon     = 'fas fa-phone',
    distance = 2.5,
    cooldown = 300,
    code     = '10-66',
    title    = 'Signalement civil',
    urgency  = 2,
    message  = 'Un civil signale une activité suspecte.',
}

DispatchConfig.Phone911 = {
    enabled  = true,
    number   = '911',
    callName = 'Appel 911',
    cooldown = 60,
    code     = '10-66',
    title    = 'Appel 911',
    urgency  = 2,
    message  = 'Appel 911 reçu d\'un civil.',
}

DispatchConfig.Gunshot = {
    enabled  = true,

    cooldown = 300,
    scope    = 'global',

    code     = '10-71',
    title    = 'Coups de feu',
    urgency  = 3,
    message  = 'Des coups de feu ont été signalés dans le secteur.',

    ignoreJobs = {
        police  = true,
        sheriff = true,
    },

    ignoredWeapons = {
        'WEAPON_UNARMED',
        'WEAPON_STUNGUN', 'WEAPON_STUNGUN_MP',
        'WEAPON_FIREEXTINGUISHER', 'WEAPON_MFIREEXTINGUISHER', 'WEAPON_HOSE',
        'WEAPON_PETROLCAN', 'WEAPON_FERTILIZERCAN', 'WEAPON_HAZARDCAN',
        'WEAPON_FIREWORK', 'WEAPON_SNOWBALL', 'WEAPON_BALL',
        'WEAPON_FLAREGUN', 'WEAPON_FLARE',
    },
}

DispatchConfig.DutyJobs = {
    police  = 'LSPD',
    sheriff = 'BCSO',
}
