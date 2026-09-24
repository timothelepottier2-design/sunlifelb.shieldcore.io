--[[ IPL Loader
True = Enables MLO
False = Disables MLO
]]

config = {
    ["FortCarson_Arcade"] = true,
    -- GOLD/Standalone
    ["FortCarson_Saloon"] = true,
    ["FortCarson_Laundry"] = true,
    ["FortCarson_Hospital"] = true,
    ["FortCarson_LawyerOffice"] = true,
    ["FortCarson_CarDealer"] = true,
    ["FortCarson_Sheriff"] = true,
    ["FortCarson_Firestation"] = true,
    ["FortCarson_Taxidermist"] = true,
    ["FortCarson_Taxidermist_Warehouse"] = true,
    ["FortCarson_Warehouse"] = true,
    ["FortCarson_PeyoteCasino"] = true,
    ["FortCarson_Bowling"] = true,
    ["FortCarson_YuccaMotelRoom"] = true,
    ["FortCarson_YuccaMotelLobby"] = true,
    ["FortCarson_HolidazeMotelRoom"] = true,
    ["FortCarson_HolidazeMotelLobby"] = true,
    --["FortCarson_DoluBeer"] = true,   | Mods sold by Dolu Store: https://dolu.tebex.io/package/6720232
}

config.entityset = {
    ["Entityset_Fc_Arcade"] = 1,
    --[[
        1 = Classic Style  
        2 = Industrial Style  
        3 = Abandoned Style  
        4 = Create Your Custom  
    ]]
    ["Entityset_Fc_WarehouseBig"] = 1,
    --[[
        1 = Empty Warehouse  
        2 = Empty Warehouse with Furnishings  
        3 = Storage Warehouse  
        4 = Meth Lab  
        5 = Cocaine Lab  
        6 = Weapons Manufacturing  
        7 = Empty Weed Lab  
        8 = Weed Lab (Drying Only)  
        9 = Weed Lab (Drying + Growing - Stage 1)  
        10 = Weed Lab (Drying + Growing - Stage 2)  
        11 = Weed Lab (Drying + Growing - Stage 3)  
        12 = Weed Lab (Drying + Growing - Stage 4)  
    ]]
    ["Entityset_Fc_Taxidermiste_Warehouse"] = 5,
    --[[
        1 = Empty Warehouse
        2 = Meth production workshop
        3 = Weed production workshop - Empty
        4 = Weed production workshop with props
        5 = Poachers Workshop
    ]]
    ["Entityset_Fc_YuccaMotel"] = 1,
    --[[
        0 = Without furniture/Empty Shell
        1 = With furniture
    ]]
    ["Entityset_Fc_HolidazeMotel"] = 1,
    --[[
        0 = Without furniture/Empty Shell
        1 = With furniture
    ]]
}

--[[
    Radius IPL Management
    IPLs will be automatically loaded when the player is within the specified radius
    and unloaded when they move away (unless the player is inside the interior)
]]
config.RadiusIpls = {
    enableNotifications = false, -- Enable debug notifications in console
    pollInterval = 1000,         -- Check interval in milliseconds
    entries = {
        -- Simple entry (without alternative IPL):
        -- { ipl = "int_example_milo_", pos = vector3(0.0, 0.0, 0.0), radius = 100 },

        -- Entry with alternative IPL (optional):
        -- When player is in radius: loads 'ipl', unloads 'alt_ipl'
        -- When player is outside radius: unloads 'ipl', loads 'alt_ipl'
        -- { ipl = "int_example_milo_", alt_ipl = "int_example_blocker", pos = vector3(0.0, 0.0, 0.0), radius = 100 },
        { ipl = "fc_interior_int_bw_saloon_milo_",           alt_ipl = "bw_saloon_blocker",                      pos = vector3(7350.46, 352.0308, 62.0172844),      radius = 95 },
        { ipl = "fc_interior_int_laundry_milo_",             alt_ipl = "laundry_superlab_blocker",               pos = vector3(7387.074, 272.1649, 56.8418922),     radius = 95 },
        { ipl = "fc_interior_int_mediccenter_f0_milo_",      alt_ipl = "fc4_05_blocker_hospital",                pos = vector3(7495.71, 399.876, 60.313),           radius = 95 },
        { ipl = "fc_interior_int_mediccenter_f1_milo_",      alt_ipl = "fc4_05_blocker_hospital",                pos = vector3(7495.71, 399.876, 60.313),           radius = 95 },
        { ipl = "fc_interior_int_mediccenter_carpack_milo_", alt_ipl = "fc4_05_blocker_hospital",                pos = vector3(7513.517, 432.071, 59.121),          radius = 95 },
        { ipl = "fc_interior_int_bettercall_milo_",          alt_ipl = "fc_blocker_bettercall_strm",             pos = vector3(7370.883, 412.5898, 58.575737),      radius = 95 },
        { ipl = "fc_interior_int_cardealer_milo_",           alt_ipl = "fc_blocker_cardealer_strm",              pos = vector3(6946.333, 356.7231, 62.4970627),     radius = 95 },
        { ipl = "int_lv_sheriff_fortcarson_milo_",           alt_ipl = "fc_blocker_sheriff_strm",                pos = vector3(7052.24365, 374.65802, 58.320446),   radius = 95 },
        { ipl = "fc_interior_lv_firestation_milo_",          alt_ipl = "fc_blocker_firestation_strm",            pos = vector3(7454.06641, 486.8966, 59.54898),     radius = 95 },
        { ipl = "int_lv_peyote_milo_",                       alt_ipl = "fc_peyote_blocker_strm",                 pos = vector3(6991.34766, 271.9779, 56.84927),     radius = 150 },
        { ipl = "fc_interior_int_bowl_milo_",                alt_ipl = "fc_bowling_blocker_strm",                pos = vector3(7052.64355, 481.0877, 62.44283),     radius = 90 },
        -- Yucca Motel - Fort Carson
        { ipl = "fc_interior_int_yucca_lobby_milo_",    alt_ipl = "fc_interior_int_yucca_lobby_blocker",    pos = vector3(6957.91357, 431.3845, 58.0838776),   radius = 100 },
        { ipl = "fc_interior_int_yucca_02_milo_",       alt_ipl = "fc_interior_int_yucca_02_blocker",       pos = vector3(6969.80664, 433.865356, 58.4792862), radius = 100 },
        { ipl = "fc_interior_int_yucca_03_milo_",       alt_ipl = "fc_interior_int_yucca_03_blocker",       pos = vector3(6973.64746, 430.0247, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_04_milo_",       alt_ipl = "fc_interior_int_yucca_04_blocker",       pos = vector3(6977.48828, 426.183746, 58.4792862), radius = 100 },
        { ipl = "fc_interior_int_yucca_05_milo_",       alt_ipl = "fc_interior_int_yucca_05_blocker",       pos = vector3(6981.329, 422.343079, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_06_milo_",       alt_ipl = "fc_interior_int_yucca_06_blocker",       pos = vector3(6985.17, 418.502258, 58.4792862),    radius = 100 },
        { ipl = "fc_interior_int_yucca_07_milo_",       alt_ipl = "fc_interior_int_yucca_07_blocker",       pos = vector3(6989.01074, 414.6614, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_08_milo_",       alt_ipl = "fc_interior_int_yucca_08_blocker",       pos = vector3(6992.85156, 410.8206, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_09_milo_",       alt_ipl = "fc_interior_int_yucca_09_blocker",       pos = vector3(6996.69238, 406.979919, 58.4792862), radius = 100 },
        { ipl = "fc_interior_int_yucca_10_milo_",       alt_ipl = "fc_interior_int_yucca_10_blocker",       pos = vector3(7000.533, 403.13916, 58.4792862),    radius = 100 },
        { ipl = "fc_interior_int_yucca_11_milo_",       alt_ipl = "fc_interior_int_yucca_11_blocker",       pos = vector3(7001.037, 393.978546, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_12_milo_",       alt_ipl = "fc_interior_int_yucca_12_blocker",       pos = vector3(6997.518, 390.459747, 58.4792862),   radius = 100 },
        { ipl = "fc_interior_int_yucca_13_milo_",       alt_ipl = "fc_interior_int_yucca_13_blocker",       pos = vector3(6993.67773, 386.618927, 58.4792862), radius = 100 },
        { ipl = "fc_interior_int_yucca_14_milo_",       alt_ipl = "fc_interior_int_yucca_14_blocker",       pos = vector3(6990.19141, 383.132751, 58.4792862), radius = 100 },
        { ipl = "fc_interior_int_yucca_15_milo_",       alt_ipl = "fc_interior_int_yucca_15_blocker",       pos = vector3(6958.804, 432.676056, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_16_milo_",       alt_ipl = "fc_interior_int_yucca_16_blocker",       pos = vector3(6969.80664, 433.865356, 62.1520424), radius = 100 },
        { ipl = "fc_interior_int_yucca_17_milo_",       alt_ipl = "fc_interior_int_yucca_17_blocker",       pos = vector3(6973.64746, 430.0247, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_18_milo_",       alt_ipl = "fc_interior_int_yucca_18_blocker",       pos = vector3(6977.48828, 426.183746, 62.1520424), radius = 100 },
        { ipl = "fc_interior_int_yucca_19_milo_",       alt_ipl = "fc_interior_int_yucca_19_blocker",       pos = vector3(6981.329, 422.343079, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_20_milo_",       alt_ipl = "fc_interior_int_yucca_20_blocker",       pos = vector3(6985.17, 418.502258, 62.1520424),    radius = 100 },
        { ipl = "fc_interior_int_yucca_21_milo_",       alt_ipl = "fc_interior_int_yucca_21_blocker",       pos = vector3(6989.01074, 414.6614, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_22_milo_",       alt_ipl = "fc_interior_int_yucca_22_blocker",       pos = vector3(6992.85156, 410.8206, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_23_milo_",       alt_ipl = "fc_interior_int_yucca_23_blocker",       pos = vector3(6996.69238, 406.979919, 62.1520424), radius = 100 },
        { ipl = "fc_interior_int_yucca_24_milo_",       alt_ipl = "fc_interior_int_yucca_24_blocker",       pos = vector3(7000.533, 403.13916, 62.1520424),    radius = 100 },
        { ipl = "fc_interior_int_yucca_25_milo_",       alt_ipl = "fc_interior_int_yucca_25_blocker",       pos = vector3(7001.037, 393.978546, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_26_milo_",       alt_ipl = "fc_interior_int_yucca_26_blocker",       pos = vector3(6997.518, 390.459747, 62.1520424),   radius = 100 },
        { ipl = "fc_interior_int_yucca_27_milo_",       alt_ipl = "fc_interior_int_yucca_27_blocker",       pos = vector3(6993.67773, 386.618927, 62.1520424), radius = 100 },
        { ipl = "fc_interior_int_yucca_28_milo_",       alt_ipl = "fc_interior_int_yucca_28_blocker",       pos = vector3(6990.19141, 383.132751, 62.1520424), radius = 100 },
        -- Holidaze Motel - Fort Carson
        { ipl = "fc_interior_int_holidaze_lobby_milo_", alt_ipl = "fc_interior_int_holidaze_lobby_blocker", pos = vector3(7080.144, 419.176025, 58.13349),     radius = 90 },
        { ipl = "fc_interior_int_holidaze_01_milo_",    alt_ipl = "fc_interior_int_holidaze_01_blocker",    pos = vector3(7080.778, 427.0723, 58.5327),        radius = 50 },
        { ipl = "fc_interior_int_holidaze_02_milo_",    alt_ipl = "fc_interior_int_holidaze_02_blocker",    pos = vector3(7084.61865, 430.913116, 58.5327),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_03_milo_",    alt_ipl = "fc_interior_int_holidaze_03_blocker",    pos = vector3(7088.45947, 434.7539, 58.5327),      radius = 50 },
        { ipl = "fc_interior_int_holidaze_04_milo_",    alt_ipl = "fc_interior_int_holidaze_04_blocker",    pos = vector3(7092.30029, 438.594727, 58.5327),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_05_milo_",    alt_ipl = "fc_interior_int_holidaze_05_blocker",    pos = vector3(7096.141, 442.4354, 58.5327),        radius = 50 },
        { ipl = "fc_interior_int_holidaze_06_milo_",    alt_ipl = "fc_interior_int_holidaze_06_blocker",    pos = vector3(7103.82275, 450.117249, 58.5327),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_07_milo_",    alt_ipl = "fc_interior_int_holidaze_07_blocker",    pos = vector3(7107.66357, 453.958069, 58.5327),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_08_milo_",    alt_ipl = "fc_interior_int_holidaze_08_blocker",    pos = vector3(7111.50439, 457.798767, 58.5327),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_09_milo_",    alt_ipl = "fc_interior_int_holidaze_09_blocker",    pos = vector3(7121.669, 457.299, 58.5327),         radius = 50 },
        { ipl = "fc_interior_int_holidaze_10_milo_",    alt_ipl = "fc_interior_int_holidaze_10_blocker",    pos = vector3(7126.079, 452.888367, 58.5327),      radius = 50 },
        { ipl = "fc_interior_int_holidaze_11_milo_",    alt_ipl = "fc_interior_int_holidaze_11_blocker",    pos = vector3(7130.49072, 448.4769, 58.5327),      radius = 50 },
        { ipl = "fc_interior_int_holidaze_12_milo_",    alt_ipl = "fc_interior_int_holidaze_12_blocker",    pos = vector3(7080.77832, 427.072327, 61.9655266), radius = 50 },
        { ipl = "fc_interior_int_holidaze_13_milo_",    alt_ipl = "fc_interior_int_holidaze_13_blocker",    pos = vector3(7084.61865, 430.913147, 61.9655266), radius = 50 },
        { ipl = "fc_interior_int_holidaze_14_milo_",    alt_ipl = "fc_interior_int_holidaze_14_blocker",    pos = vector3(7088.46, 434.753967, 61.9655266),    radius = 50 },
        { ipl = "fc_interior_int_holidaze_15_milo_",    alt_ipl = "fc_interior_int_holidaze_15_blocker",    pos = vector3(7092.30029, 438.594757, 61.9655266), radius = 50 },
        { ipl = "fc_interior_int_holidaze_16_milo_",    alt_ipl = "fc_interior_int_holidaze_16_blocker",    pos = vector3(7096.141, 442.435455, 61.9655266),   radius = 50 },
        { ipl = "fc_interior_int_holidaze_17_milo_",    alt_ipl = "fc_interior_int_holidaze_17_blocker",    pos = vector3(7103.823, 450.1173, 61.9655266),     radius = 50 },
        { ipl = "fc_interior_int_holidaze_18_milo_",    alt_ipl = "fc_interior_int_holidaze_18_blocker",    pos = vector3(7107.66357, 453.95813, 61.9655266),  radius = 50 },
        { ipl = "fc_interior_int_holidaze_19_milo_",    alt_ipl = "fc_interior_int_holidaze_19_blocker",    pos = vector3(7111.50439, 457.7988, 61.9655266),   radius = 50 },
        { ipl = "fc_interior_int_holidaze_20_milo_",    alt_ipl = "fc_interior_int_holidaze_20_blocker",    pos = vector3(7121.669, 457.298828, 61.9655266),   radius = 50 },
        { ipl = "fc_interior_int_holidaze_21_milo_",    alt_ipl = "fc_interior_int_holidaze_21_blocker",    pos = vector3(7126.079, 452.8882, 61.9655266),     radius = 50 },
        { ipl = "fc_interior_int_holidaze_22_milo_",    alt_ipl = "fc_interior_int_holidaze_22_blocker",    pos = vector3(7130.49072, 448.476746, 61.9655266), radius = 50 },
    }
}
