-- ════════════════════════════════════════════════════════════════════════════
--  VESPUCCI FIRE STATION — GYM
--  Animated equipment via prompt_anim_core_2 (like MRPD), with the MLO's `gym`
--  entity set as the static fallback when no anim core is installed/running.
--
--  You never touch anim_core for this: this resource detects the core and calls
--  its CreateGymLocation export itself. If the core is absent, the baked `gym`
--  entity set is shown instead. The two are mutually exclusive — you never see
--  both at once, and the gym is never left empty.
-- ════════════════════════════════════════════════════════════════════════════

Config = Config or {}

Config.VFDGym = {
    -- 'auto'   = animated via anim_core if present, else the static `gym` entity set
    -- 'static' = ALWAYS the static entity set; ignore anim_core even if running
    mode  = 'auto',

    debug = false,   -- extra console detail (spawn results, per-apply logging)

    -- ── Static fallback (the baked props inside the MLO) ──────────────────────
    entitySet     = 'gym',                                  -- entity-set name in prompt_vfd.ytyp
    interiorProbe = vec3(-1037.74, -1401.27, 9.167889),    -- point used to resolve the VFD interior
    proximity     = 60.0,                                   -- only touch the set within this many metres

    -- ── Animated gym (anim_core) ─────────────────────────────────────────────
    location          = 'vfd',                             -- anim_core location id (must be unique)
    coords            = vec3(-1049.07, -1411.01, 4.07),    -- render centre (near the equipment)
    renderDistance    = nil,                               -- nil = anim_core default
    requireMembership = false,                             -- public gym (no membership gate)
    blip              = false,                             -- interior gym: no map blip

    -- Equipment spots, keyed by anim_core equipment type. vec4 = x, y, z, heading.
    -- `bench` carries { coords = vec4, bar = vec4 }. Types must exist in the core
    -- (run GetAvailableEquipmentTypes) — an unknown type is reported on boot.
    props = {
        gympullmachine1 = {
            vec4(-1045.2847, -1404.4474, 3.8757, 298.58),
        },
        gympullmachine2 = {
            vec4(-1043.8822, -1404.7869, 3.8738, 211.28),
        },
        leg_press = {
            vec4(-1049.4760, -1419.0105, 3.8795, 183.99),
            vec4(-1051.1013, -1418.6396, 3.8795, 182.80),
            vec4(-1052.7611, -1418.1561, 3.9851, 185.40),
        },
        bench = {
            { coords = vec4(-1050.1002, -1406.0138, 4.1746, 76.10), bar = vec4(-1050.5884, -1406.0386, 4.4719, 76.10) },
            { coords = vec4(-1050.9067, -1409.2012, 4.1828, 75.09), bar = vec4(-1051.3459, -1409.0538, 4.4801, 75.09) },
        },
        gymlatpull = {
            vec4(-1046.3245, -1408.8147, 3.8778, 347.15),
        },
        gymrowpull = {
            vec4(-1047.1803, -1409.8473, 3.8757, 76.04),
        },
        gymbike = {
            vec4(-1051.4113, -1411.7699, 3.9821, 254.97),
            vec4(-1051.6985, -1412.9569, 3.9821, 253.70),
            vec4(-1052.0190, -1414.3840, 3.9821, 253.21),
        },
        vin_chu = {
            vec4(-1049.4293, -1403.9712, 3.9621, 310.02),
        },
        speedbag = {
            vec4(-1047.0187, -1403.7836, 5.470, 76.44),
        },
        gymspeedbag = {
            vec4(-1047.5035, -1419.3612, 3.8992, 293.47),
        },
    },
}
