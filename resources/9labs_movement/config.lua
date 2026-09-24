return {
    -- Framework bridge: 'auto' detects qbx_core, qb-core, es_extended or ox_core; 'standalone' skips framework checks.
    framework = 'es_extended',

    -- Ped models allowed to use both features.
    models = { 'mp_m_freemode_01', 'mp_f_freemode_01' },

    -- Player state bag keys that block both features (ox_inventory sets invBusy/invOpen).
    blockedStates = { 'invBusy', 'invOpen', 'isDead', 'inLaststand', 'isCuffed', 'isHandcuffed' },

    peek = {
        enabled = true,
        mode = 'hold',                 -- 'hold' leans while the key is held, 'toggle' switches on each press
        keys = { left = '', right = '' },   -- defaults, players rebind in Settings > Key Bindings > FiveM
        requireAim = true,             -- lean only while aiming
        allowFirstPerson = false,      -- allow leaning in first person / first person aim
        maxSpeed = 4.5,                -- m/s; moving faster retracts the lean until the player slows down

        camera = {
            enabled = true,            -- shoulder camera that moves with the lean
            reticle = false,           -- draw a small white dot while the shoulder camera is active
            mouseSensitivity = 8.0,
            controllerSpeed = 140.0
        },

        -- Per-weapon profiles. Lookup order: exact weapon name, weapon group, then 'default'.
        -- Missing keys inherit from 'default'.
        --   enabled      allow leaning with this weapon
        --   lean         body lean strength, 0.1 to 1.0
        --   cameraLeft   metres the camera moves out on a left lean
        --   cameraRight  metres the camera moves out on a right lean
        --   clearance    metres of free space needed beside the body before leaning
        weapons = {
            default = { enabled = true, lean = 1.0, cameraLeft = 0.20, cameraRight = 0.30, clearance = 0.42 },
            GROUP_PISTOL = { lean = 1.0, cameraLeft = 0.18, cameraRight = 0.26 },
            GROUP_SMG = { lean = 1.0 },
            GROUP_RIFLE = { lean = 1.0 },
            GROUP_SHOTGUN = { lean = 0.9 },
            GROUP_MG = { lean = 0.75, cameraRight = 0.34, clearance = 0.50 },
            GROUP_SNIPER = { enabled = false },
            GROUP_HEAVY = { enabled = false },
            GROUP_THROWN = { enabled = false },
            GROUP_MELEE = { enabled = false },
            GROUP_UNARMED = { enabled = false }
            -- WEAPON_CARBINERIFLE = { lean = 0.9, cameraRight = 0.28 },
        }
    },

    ledge = {
        enabled = true,
        climbFast = false,             -- pass the launch-force flag to the engine climb
        cooldown = 100,                -- ms between two climbs
        maxReach = 2.0,               -- highest edge above the ped that is still caught (metres)
        minReach = 0.0,                -- lowest edge; negative catches slightly before the edge reaches the hands
        wallDistance = 0.8,            -- how far ahead to look for a wall (metres)
        wallProbeHeight = 0.2,         -- height of the lowest wall probe; lower catches sooner, too low catches kerbs
        angles = { 0.0, -30.0, 30.0 }, -- directions checked relative to where the ped faces (degrees)
        minApproach = 0.25,            -- m/s the ped must move toward the wall; stops catches while dropping down a wall
        noRagdollWhileFalling = true,  -- keep control during long falls so an edge can still be caught
        maxFallSpeed = 9.0,            -- m/s; falling faster than this is never caught
        debugCommands = true           -- /ledgedebug, /ledgeset, /ledgedump for tuning probe values
    },

    -- GTA plays an automatic drop-down/slide when a ped reaches a roof edge instead of letting it run and jump off.
    antiSlide = {
        enabled = true
    }
}
