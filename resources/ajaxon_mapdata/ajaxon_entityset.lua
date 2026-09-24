local interiors = {
    --------------------------------------
    --          BURTON LSC V2           --
    --------------------------------------
    {
        ipl = 'ajaxon_burton_lscv2_milo_',
        coords = { x = -344.962, y = -122.361, z = 41.5921 },
        entitySets = {
        { name = 'office_01', enable = true }, -- office theme
        { name = 'office_02', enable = false },  -- arcade theme
        }
    },

    --------------------------------------
    --        ALDORE HOSPITAL V2        --
    --------------------------------------

    {
        ipl = 'ajaxon_aldore_hospitalv2_00_milo_',
        coords = { x= -484.8572, y= -1033.953, z= 30.76252 },
        entitySets = {
        { name = '00_lobby_wheelchair_elev_off', enable = true },
        { name = '00_lobby_wheelchair_elev', enable = false },
        }
    },

    {
        ipl = 'ajaxon_aldore_hospitalv2_01_milo_',
        coords = { x= -489.301, y= -1005.632, z= 30.1347 },
        entitySets = {
        { name = 'lobby_wheelchair_elev_off', enable = true },
        { name = 'lobby_wheelchair_elev', enable = false },
        { name = 'icu_droffice_frames', enable = true },
        { name = 'icu_private_frames', enable = true },
        { name = 'icu_sickroom_frames', enable = true },
        }
    },

    {
        ipl = 'ajaxon_aldore_hospitalv2_02_milo_',
        coords = { x= -461.4738, y= -1031.59863, z= 30.0722 },
        entitySets = {
        { name = 'hallway_wheelchair_elev_off', enable = true },
        { name = 'hallway_wheelchair_elev', enable = false },
        { name = 'rehab_massage', enable = true },
        { name = 'rehab_treatment_tables', enable = false },
        { name = 'rehab_wall_bars', enable = true },
        { name = 'elev_shaft_cabins', enable = true },
        { name = 'sickroom_curtains', enable = true },
        { name = 'rehab_droffice_frames', enable = true },
        }
    },

    {
        ipl = 'ajaxon_aldore_hospitalv2_garage_milo_',
        coords = { x= -465.7112, y= -1012.26477, z= 20.84202 },
        entitySets = {
        { name = 'garage_safety_corner_strips', enable = true },
        { name = 'garage_safety_poles', enable = true },
        { name = 'garage_bumps', enable = true },
        { name = 'garage_addon_mechanic', enable = true },
        { name = 'garage_addon_door', enable = true },
        { name = 'garage_addon_closed', enable = false },
        { name = 'garage_addon_safety_corner_strips', enable = false },
        { name = 'garage_g_doors', enable = true },
        }
    },


    --------------------------------------
    --         ALDORE HOSPITAL          --
    --------------------------------------
    {
        ipl = 'ajaxon_aldore_hospital_milo_',
        coords = { x= -481.735, y= -1024.37, z= 33.167 },
        entitySets = {
        { name = 'bulletproofglass', enable = true }, -- bulletproof glass
        }
    },


    --------------------------------------
    --             KOI SPA              --
    --------------------------------------
    {
        ipl = 'ajaxon_koi_spa_milo_',
        coords = { x= -1038.17, y= -1481.27, z= 4.30374 },
        entitySets = {
        -- OFFICE
        { name = 'frame_08_a', enable = true },     -- image frame above the sofa
        { name = 'frame_08_b', enable = true },     -- image frame above the desk
        { name = 'office_logo', enable = true },    -- logo

        -- UPSTAIR 
        { name = 'upstair_logo', enable = true },   -- logo
            -- big images
        { name = 'frame_09_a', enable = true }, 
        { name = 'frame_09_b', enable = true },
        { name = 'frame_09_c', enable = true },
            -- small images, first row left to right
        { name = 'frame_09_d', enable = true },
        { name = 'frame_09_e', enable = true },
        { name = 'frame_09_f', enable = true },
        { name = 'frame_09_g', enable = true },
        { name = 'frame_09_h', enable = true },
        { name = 'frame_09_i', enable = true },
            -- small images, second row left to right
        { name = 'frame_09_j', enable = true },
        { name = 'frame_09_k', enable = true },
        { name = 'frame_09_l', enable = true },
        { name = 'frame_09_m', enable = true },
        { name = 'frame_09_n', enable = true },
        { name = 'frame_09_o', enable = true },
            -- horizontal images
        { name = 'frame_10_a', enable = true },
        { name = 'frame_10_b', enable = true },
            -- full sets
        { name = 'weedset', enable = true },        -- WEED equipment
        { name = 'cokeset', enable = false },       -- COKE equipment
        { name = 'gunset', enable = false },        -- GUN equipment
        { name = 'chillset', enable = false },      -- nothing illegal, just a chill area
            -- covers
        { name = 'hide_a', enable = false },        -- FULL cover wall
        { name = 'hide_b', enable = false },        -- cover wall, without covering the door
        }
    },


    --------------------------------------
    --              BUNKER              --
    -- B: Bulletproof | S: Shot through --
    --------------------------------------
    {
        ipl = 'ajaxon_bunker_milo_',
        coords = { x= -1523.99, y= 1951.83, z= 65.4868 },
        entitySets = {
        -- ENTRANCE
        { name = 'ent_gate_01', enable = true },
        { name = 'ent_gate_02', enable = false },
        { name = 'ent_gate_03', enable = false },
        -- MAIN
        { name = 'lights_01a', enable = true },
        { name = 'lights_01b', enable = false },
        { name = 'lights_01c', enable = false },
        { name = 'lights_02', enable = true },
        { name = 'lights_02_plantset', enable = true },
        { name = 'main_vents', enable = true },
        -- GUNROOM
        { name = 'gunroom_gate_01', enable = false },   -- metal | (B)
        { name = 'gunroom_gate_02', enable = true },    -- metal grid with glass | (B)
        { name = 'gunroom_gate_03', enable = false },   -- metal wire | (S)
        { name = 'gunroom_gate_d_01', enable = false }, -- metal | (B)
        { name = 'gunroom_gate_d_02', enable = true },  -- metal grid with glass | (B)
        { name = 'gunroom_gate_d_03', enable = false }, -- metal wire | (S)
        -- SECROOM
        { name = 'sec_screens', enable = true },    -- editable screens | (B)
        -- BAR
        { name = 'bar_logo_01', enable = true },    -- 3 emissive logo on the bar center
        { name = 'bar_logo_02', enable = true },    -- emissive logo on front of the counter
        { name = 'bar_logo_01_b', enable = false },  -- 3 logo on the bar center
        { name = 'bar_logo_02_b', enable = false },  -- logo on front of the counter
        { name = 'stair_lights_01', enable = true },    -- white lights next to the stairs | (B)
        { name = 'stair_lights_02', enable = false },   -- violet blue lights next to the stairs | (B)
        { name = 'stair_lights_03', enable = false },   -- magenta lights next to the stairs | (B)
        { name = 'bar_wineset', enable = false },   -- a wine room in front of the stairs | (B)
        { name = 'bar_stageset_01', enable = false },   -- a stage in front of the stairs with white lights
        { name = 'bar_stageset_02', enable = false },   -- a stage in front of the stairs with violet blue lights
        { name = 'bar_stageset_03', enable = false },   -- a stage in front of the stairs with magenta lights
        { name = 'bar_stageset_i', enable = false },    -- instruments for the stageset
        { name = 'bar_stageset_i_piano', enable = false },  -- only piano for the stageset
        { name = 'bar_normalset', enable = true },  -- siting area in front of the stairs
        -- PLANTER
        { name = 'p_lights_01', enable = true },    -- white lights | (B)
        { name = 'p_lights_02', enable = false },   -- magenta lights | (B)
        { name = 'p_lights_03', enable = false },   -- violet blue lights | (B)
        { name = 'p_plant_cab', enable = true },    -- planted cabbage with frame | (B/S)
        { name = 'p_plant_lett', enable = false },  -- planted lettuce with frame | (B/S)
        { name = 'p_plant_weed', enable = false },  -- planted weed with frame | (B/S)
        -- OFFICE
        { name = 'office_chillset', enable = false },
        { name = 'office_confset', enable = true },
        { name = 'office_confset_proj', enable = true },
        { name = 'office_confset_chairs', enable = true },
        { name = 'office_images_01', enable = false },
        { name = 'office_logo_01', enable = true },
        { name = 'office_logo_01_e', enable = false },
        { name = 'office_logo_02', enable = true },
        { name = 'office_logo_02_e', enable = false },
        { name = 'office_logo_03', enable = true },
        { name = 'office_logo_03_e', enable = false },
            -- big images
        { name = 'office_images_frame_a', enable = true },
        { name = 'office_images_frame_b', enable = true },
        { name = 'office_images_frame_c', enable = true },
            -- small images, first row | left to right
        { name = 'office_images_frame_d', enable = true },
        { name = 'office_images_frame_e', enable = true },
        { name = 'office_images_frame_f', enable = true },
        { name = 'office_images_frame_g', enable = true },
        { name = 'office_images_frame_h', enable = true },
        { name = 'office_images_frame_i', enable = true },
            -- small images, second row | left to right
        { name = 'office_images_frame_j', enable = true },
        { name = 'office_images_frame_k', enable = true },
        { name = 'office_images_frame_l', enable = true },
        { name = 'office_images_frame_m', enable = true },
        { name = 'office_images_frame_n', enable = true },
        { name = 'office_images_frame_o', enable = true },
        }
    },
    --------------------------------------
    --           BUNKER HIDDEN          --
    -- B: Bulletproof | S: Shot through --
    --------------------------------------
    {
    ipl = 'ajaxon_bunker_hidden_milo_',
    coords = { x= -2614.995, y= 998.8069, z= 14.7609558 },
    entitySets = {
    -- REQUIRED!! door for the hidden bunker.
    { name = 'bunker_hidden', enable = true },
    
    -- ENTRANCE
    { name = 'ent_gate_01', enable = true },
    { name = 'ent_gate_02', enable = false },
    { name = 'ent_gate_03', enable = false },
    -- MAIN
    { name = 'lights_01a', enable = true },
    { name = 'lights_01b', enable = false },
    { name = 'lights_01c', enable = false },
    { name = 'lights_02', enable = true },
    { name = 'lights_02_plantset', enable = true },
    { name = 'main_vents', enable = true },
    -- GUNROOM
    { name = 'gunroom_gate_01', enable = false },   -- metal | (B)
    { name = 'gunroom_gate_02', enable = true },    -- metal grid with glass | (B)
    { name = 'gunroom_gate_03', enable = false },   -- metal wire | (S)
    { name = 'gunroom_gate_d_01', enable = false }, -- metal | (B)
    { name = 'gunroom_gate_d_02', enable = true },  -- metal grid with glass | (B)
    { name = 'gunroom_gate_d_03', enable = false }, -- metal wire | (S)
    -- SECROOM
    { name = 'sec_screens', enable = true },    -- editable screens | (B)
    -- BAR
    { name = 'bar_logo_01', enable = true },    -- 3 emissive logo on the bar center
    { name = 'bar_logo_02', enable = true },    -- emissive logo on front of the counter
    { name = 'bar_logo_01_b', enable = false },  -- 3 logo on the bar center
    { name = 'bar_logo_02_b', enable = false },  -- logo on front of the counter
    { name = 'stair_lights_01', enable = true },    -- white lights next to the stairs | (B)
    { name = 'stair_lights_02', enable = false },   -- violet blue lights next to the stairs | (B)
    { name = 'stair_lights_03', enable = false },   -- magenta lights next to the stairs | (B)
    { name = 'bar_wineset', enable = false },   -- a wine room in front of the stairs | (B)
    { name = 'bar_stageset_01', enable = false },   -- a stage in front of the stairs with white lights
    { name = 'bar_stageset_02', enable = false },   -- a stage in front of the stairs with violet blue lights
    { name = 'bar_stageset_03', enable = false },   -- a stage in front of the stairs with magenta lights
    { name = 'bar_stageset_i', enable = false },    -- instruments for the stageset
    { name = 'bar_stageset_i_piano', enable = false },  -- only piano for the stageset
    { name = 'bar_normalset', enable = true },  -- siting area in front of the stairs
    -- PLANTER
    { name = 'p_lights_01', enable = true },    -- white lights | (B)
    { name = 'p_lights_02', enable = false },   -- magenta lights | (B)
    { name = 'p_lights_03', enable = false },   -- violet blue lights | (B)
    { name = 'p_plant_cab', enable = true },    -- planted cabbage with frame | (B/S)
    { name = 'p_plant_lett', enable = false },  -- planted lettuce with frame | (B/S)
    { name = 'p_plant_weed', enable = false },  -- planted weed with frame | (B/S)
    -- OFFICE
    { name = 'office_chillset', enable = false },
    { name = 'office_confset', enable = true },
    { name = 'office_confset_proj', enable = true },
    { name = 'office_confset_chairs', enable = true },
    { name = 'office_images_01', enable = false },
    { name = 'office_logo_01', enable = true },
    { name = 'office_logo_01_e', enable = false },
    { name = 'office_logo_02', enable = true },
    { name = 'office_logo_02_e', enable = false },
    { name = 'office_logo_03', enable = true },
    { name = 'office_logo_03_e', enable = false },
        -- big images
    { name = 'office_images_frame_a', enable = true },
    { name = 'office_images_frame_b', enable = true },
    { name = 'office_images_frame_c', enable = true },
        -- small images, first row | left to right
    { name = 'office_images_frame_d', enable = true },
    { name = 'office_images_frame_e', enable = true },
    { name = 'office_images_frame_f', enable = true },
    { name = 'office_images_frame_g', enable = true },
    { name = 'office_images_frame_h', enable = true },
    { name = 'office_images_frame_i', enable = true },
        -- small images, second row | left to right
    { name = 'office_images_frame_j', enable = true },
    { name = 'office_images_frame_k', enable = true },
    { name = 'office_images_frame_l', enable = true },
    { name = 'office_images_frame_m', enable = true },
    { name = 'office_images_frame_n', enable = true },
    { name = 'office_images_frame_o', enable = true },
    }
    },


    --------------------------------------
    --           COFFEE SHOP            --
    --------------------------------------
    {
        ipl = 'ajaxon_coffee_shop_milo_',
        coords = { x= 183.164, y= -236.166, z= 56.2207 },
        entitySets = {
        -- MAIN
        { name = 'mainset_01', enable = false },

        { name = 'win_counter_01a', enable = false },
        { name = 'win_counter_01a_chair_01a', enable = false },
        { name = 'win_counter_01a_chair_01b', enable = false },

        { name = 'win_counter_01b', enable = false },
        { name = 'win_counter_01b_chair_01a', enable = false },
        { name = 'win_counter_01b_chair_01b', enable = false },

        { name = 'wall_counter_01', enable = false },
        { name = 'wall_counter_01_chair_01a', enable = true },
        { name = 'wall_counter_01_chair_01b', enable = false },

        { name = 'win_sofa_01', enable = false },
        { name = 'win_sofa_01_chair_01a', enable = false },
        { name = 'win_sofa_01_chair_01b', enable = false },

        { name = 'main_counter_01_logo', enable = false },
        { name = 'main_counter_01_logo_e', enable = false },
        { name = 'main_counter_01_shelf', enable = false },

        { name = 'dec_wall_01', enable = false },
        { name = 'dec_wall_01_logo_c', enable = false },
        { name = 'dec_wall_01_logo_c_e', enable = true },
        { name = 'dec_wall_01_logo_t', enable = false },
        { name = 'dec_wall_01_logo_t_e', enable = false },

        { name = 'corner_sofa_01', enable = false },
        { name = 'corner_sofa_01_chair_01a', enable = false },
        { name = 'corner_sofa_01_chair_01b', enable = false },

        { name = 'tableset_01', enable = false },
        { name = 'tableset_01_chair_01a', enable = false },
        { name = 'tableset_01_chair_01b', enable = false },

        { name = 'counter_topshelf_01', enable = false },
        { name = 'counter_topshelf_01_board', enable = false },
        { name = 'counter_topshelf_01_board_e', enable = true },

        { name = 'main_lights_01', enable = false },
        { name = 'counter_lights_01', enable = false },



        { name = 'mainset_02', enable = true },
        { name = 'wood_parquet', enable = true },
        { name = 'concrete_wood_wall', enable = true },

        { name = 'win_counter_02a', enable = true },
        { name = 'win_counter_02a_chair_01a', enable = true },
        { name = 'win_counter_02a_chair_01b', enable = false },

        { name = 'win_counter_02b', enable = false },

        { name = 'wall_counter_02', enable = true },

        { name = 'win_sofa_02', enable = true },
        { name = 'win_sofa_02_chair_02', enable = true },
        { name = 'win_sofa_02_chair_01a', enable = false },
        { name = 'win_sofa_02_chair_01b', enable = false },
        { name = 'win_sofa_02_table_02a', enable = false },
        { name = 'win_sofa_02_table_02b', enable = true },

        { name = 'main_counter_02_dec', enable = true },
        { name = 'main_counter_02_logo', enable = false },
        { name = 'main_counter_02_logo_e', enable = true },

        { name = 'dec_wall_02', enable = true },

        { name = 'corner_sofa_02', enable = true },
        { name = 'corner_sofa_02_table_02a', enable = false },
        { name = 'corner_sofa_02_table_02b', enable = true },
        { name = 'corner_sofa_02_chair_02', enable = true },
        { name = 'corner_sofa_02_chair_01a', enable = false },
        { name = 'corner_sofa_02_chair_01b', enable = false },

        { name = 'tableset_02a', enable = false },
        { name = 'tableset_02b', enable = false },
        { name = 'tableset_02_chair_02', enable = false },
        { name = 'tableset_02_chair_01a', enable = false },
        { name = 'tableset_02_chair_01b', enable = false },

        { name = 'counter_topshelf_02', enable = true },

        { name = 'main_lights_02', enable = true },
        { name = 'main_ceiling_dec_02', enable = true },

        -- RESTROOM
        { name = 'restroom_01', enable = false },
        { name = 'restroom_02', enable = true },
        { name = 'restroom_dec_wall', enable = true },

        --OFFICE
        { name = 'office_posters', enable = true },
        }
    },
}



-- Use the command ( /setint "entityset name" ) to change entitysets live on your server.

-- !! IMPORTANT: This command is only a test, to make the entitysets you change work every time the server is started, you also need to change in this file !! --

RegisterCommand('setint',function(source, args)
    for _, interior in ipairs(interiors) do
        RequestIpl(interior.ipl)
        interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
        if IsValidInterior(interiorID) then
            for __, entitySet in ipairs(interior.entitySets) do
                if entitySet.name == args[1] then
                    if entitySet.enable then
                        DeactivateInteriorEntitySet(interiorID, entitySet.name)
                        entitySet.enable = false
                    else
                        ActivateInteriorEntitySet(interiorID, entitySet.name)
                        entitySet.enable = true
                    end
                end
            end
            RefreshInterior(interiorID)
        end
    end
end)


CreateThread(function()
    for _, interior in ipairs(interiors) do
        if not interior.ipl or not interior.coords or not interior.entitySets then
            print('^5[AJAXON]^7 ^1Error while loading interior.^7')
            return
        end
        RequestIpl(interior.ipl)
        interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
        if IsValidInterior(interiorID) then
            for __, entitySet in ipairs(interior.entitySets) do
                if entitySet.enable then
                    ActivateInteriorEntitySet(interiorID, entitySet.name)
                else
                    DisableInteriorProp(interiorID, entitySet.name)
                end
            end
            RefreshInterior(interiorID)
        end
    end
end)