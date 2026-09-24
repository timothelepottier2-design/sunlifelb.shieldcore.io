ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
end)

local civilitems = {
    {nom = "BBQ", prop = "prop_bbq_2"},
    {nom = "BEER", prop = "prop_beer_neon_01"},
    {nom = "BEER2", prop = "prop_beer_box_01"},
    {nom = "Chaise", prop = "apa_mp_h_din_chair_12"},
    {nom = "Outils", prop = "prop_cs_trolley_01"},
    {nom = "Outils mecano", prop = "prop_carcreeper"},
    {nom = "Sac", prop = "prop_cs_heist_bag_02"},
    {nom = "Table", prop = "apa_mp_h_din_table_06"},
    {nom = "Meuble TV", prop = "hei_heist_str_avunitl_03"},
    {nom = "Ecran", prop = "hei_prop_hei_bank_mon"},
    {nom = "Chaise exterieure", prop = "hei_prop_hei_skid_chair"},
    {nom = "Laptop", prop = "hei_prop_hst_laptop"},
    {nom = "Chaise riche", prop = "p_armchair_01_s"},
    {nom = "Lit double pauvre", prop = "p_lestersbed_s"},
    {nom = "Lit double riche", prop = "p_mbbed_s"},
    {nom = "Canape riche", prop = "p_lev_sofa_s"},
    {nom = "Sofa", prop = "p_res_sofa_l_s"},
    {nom = "Safe", prop = "p_v_43_safe_s"},
    {nom = "Air Hockey", prop = "prop_airhockey_01"},
    {nom = "Arcade", prop = "prop_arcade_01"},
    {nom = "Altere", prop = "prop_barbell_01"},
    {nom = "Basket", prop = "prop_bball_arcade_01"},
    {nom = "Tombe", prop = "prop_coffin_01"},
    {nom = "Dildo", prop = "prop_cs_dildo_01"},
    {nom = "Tv stand", prop = "prop_cs_tv_stand"},
    {nom = "Jeu de flechettes", prop = "prop_dart_bd_cab_01"},
    {nom = "Coffre", prop = "prop_devin_box_01"},
    {nom = "Plante", prop = "prop_fbibombplant"},
    {nom = "Armoire", prop = "prop_fbibombfile"},
    {nom = "Bijoux", prop = "prop_jewel_pickup_new_01"},
    {nom = "Jukebox", prop = "prop_jukebox_02"},
    {nom = "Micro-ondes", prop = "prop_micro_02"},
    {nom = "Billard", prop = "prop_pooltable_02"},
    {nom = "Speaker", prop = "prop_speaker_07"},
    {nom = "Telescope", prop = "prop_t_telescope_01b"},
    {nom = "Table de tennis", prop = "prop_table_tennis"},
    {nom = "TV", prop = "prop_tv_flat_02b"},

    {nom = "Chien volant", prop = "sc_pet_dog_fly"},
}

local lspditems = {
    {nom = "Cone", prop = "prop_roadcone02a"},
    {nom = "Barrière", prop = "prop_barrier_work05"},
    {nom = "Gros carton", prop = "prop_boxpile_07d"},
    {nom = "Gazebo", prop = "prop_gazebo_02"},
    {nom = "Barrière en bêton", prop = "prop_mp_barrier_01"},
    {nom = "Grande barrière en bêton", prop = "prop_mp_barrier_01b"},
    {nom = "Barricade de signalisation", prop = "prop_barrier_wat_03b"},
    {nom = "Grand cône de signalisation", prop = "prop_mp_arrow_barrier_01"},

    {nom = "Tente forensic", prop = "bzzz_prop_forensic_tent"},
    {nom = "Tente forensic (petite)", prop = "bzzz_prop_forensic_tent_small"},
    {nom = "Barrière forensic 1", prop = "bzzz_prop_forensic_barrier01"},
    {nom = "Barrière forensic 2", prop = "bzzz_prop_forensic_barrier02"},
    {nom = "Barrière forensic 3", prop = "bzzz_prop_forensic_barrier03"},
    {nom = "Barrière forensic 4", prop = "bzzz_prop_forensic_barrier04"},
    {nom = "Barrière forensic 5", prop = "bzzz_prop_forensic_barrier05"},

    {nom = "Pupitre A", prop = "bzzz_props_lectern_a"},
    {nom = "Pupitre B", prop = "bzzz_props_lectern_b"},
    {nom = "Pupitre C", prop = "bzzz_props_lectern_c"},

    {nom = "Carton Cop A", prop = "bzzz_police_cardboard_cop_a"},
    {nom = "Carton Cop B", prop = "bzzz_police_cardboard_cop_b"},
    {nom = "Carton Cop CZ", prop = "bzzz_police_cardboard_cop_cz"},
    {nom = "Carton Sheriff A", prop = "bzzz_police_cardboard_sheriff_a"},
    {nom = "Carton Sheriff B", prop = "bzzz_police_cardboard_sheriff_b"},
    {nom = "Carton Véhicule FIB", prop = "bzzz_vehicle_cardboard_fib"},
    {nom = "Carton Véhicule FIB 2", prop = "bzzz_vehicle_cardboard_fib2"},
    {nom = "Carton Véhicule Police", prop = "bzzz_vehicle_cardboard_police"},
    {nom = "Carton Véhicule Police 2", prop = "bzzz_vehicle_cardboard_police2"},
    {nom = "Carton Véhicule Police 3", prop = "bzzz_vehicle_cardboard_police3"},
    {nom = "Carton Véhicule Police 4", prop = "bzzz_vehicle_cardboard_police4"},
    {nom = "Carton Véhicule Police T", prop = "bzzz_vehicle_cardboard_policet"},
    {nom = "Carton Véhicule Pranger", prop = "bzzz_vehicle_cardboard_pranger"},
    {nom = "Carton Véhicule Sheriff", prop = "bzzz_vehicle_cardboard_sheriff"},
    {nom = "Carton Véhicule Sheriff 2", prop = "bzzz_vehicle_cardboard_sheriff2"},

    {nom = "Cône bleu", prop = "bzzz_police_props_cone_blue"},
    {nom = "Cône bleu (animé)", prop = "bzzz_police_props_cone_blue_anim"},
    {nom = "Cône rouge", prop = "bzzz_police_props_cone_red"},
    {nom = "Cône rouge (animé)", prop = "bzzz_police_props_cone_red_anim"},
    {nom = "Numéro A", prop = "bzzz_police_props_number_a"},
    {nom = "Numéro B", prop = "bzzz_police_props_number_b"},
    {nom = "Numéro C", prop = "bzzz_police_props_number_c"},
    {nom = "Numéro D", prop = "bzzz_police_props_number_d"},
    {nom = "Numéro E", prop = "bzzz_police_props_number_e"},
    {nom = "Route fermée", prop = "bzzz_police_props_roadclosed_a"},
    {nom = "Écran A", prop = "bzzz_police_props_screen_a"},
    {nom = "Écran B", prop = "bzzz_police_props_screen_b"},
    {nom = "Écran C", prop = "bzzz_police_props_screen_c"},
    {nom = "Panneau A", prop = "bzzz_police_props_sign_a"},
    {nom = "Panneau B", prop = "bzzz_police_props_sign_b"},
    {nom = "Panneau C", prop = "bzzz_police_props_sign_c"},
}

local emsitems = {
    {nom = "Brancard", prop = "fernocot"},
    {nom = "Sac médical", prop = "prop_med_bag_01b"},
    {nom = "Station médicale", prop = "prop_medstation_03"},
    {nom = "Sac EMS", prop = "prop_ld_bomb"},
    {nom = "Machine Cardiaque", prop = "prop_ld_purse_01"},
    {nom = "Lit", prop = "v_med_bed1"},
    {nom = "Lit 2", prop = "v_med_bed2"},
    {nom = "Lit 3", prop = "v_med_emptybed"},
    {nom = "Lit 4", prop = "v_med_cor_emblmtable"},
    {nom = "Comptoir", prop = "v_med_bench1"},
    {nom = "Comptoir 2", prop = "v_med_bench2"},
    {nom = "Comptoir 3", prop = "v_med_benchcentr"},
    {nom = "Set Table EMS", prop = "v_med_benchset1"},
    {nom = "Poubelle", prop = "v_med_bin"},
    {nom = "Bouteilles 1", prop = "v_med_bottles1"},
    {nom = "Bouteilles 2", prop = "v_med_bottles2"},
    {nom = "Bouteilles 3", prop = "v_med_bottles3"},
    {nom = "Centrifugeuse 1", prop = "v_med_centrifuge1"},
    {nom = "Centrifugeuse 2", prop = "v_med_centrifuge2"},
    {nom = "Frigo", prop = "v_med_cooler"},
    {nom = "Table d'autopsy", prop = "v_med_cor_autopsytbl"},
    {nom = "Panier a linge", prop = "v_med_cor_cembin"},
    {nom = "Chariot 1", prop = "v_med_cor_cemtrolly"},
    {nom = "Chariot 2", prop = "v_med_cor_cemtrolly2"},
    {nom = "Chariot 3", prop = "v_med_trolley"},
    {nom = "Chariot 4", prop = "v_med_trolley2"},
    {nom = "Chaise", prop = "v_med_cor_medstool"},
    {nom = "Mini Frigo", prop = "v_med_cor_minifridge"},
    {nom = "Étagère", prop = "v_med_cor_shelfrack"},
    {nom = "TV", prop = "v_med_cor_tvstand"},
    {nom = "Unité EMS", prop = "v_med_cor_unita"},
    {nom = "Unité murale", prop = "v_med_cor_wallunita"},
    {nom = "Unité murale 2", prop = "v_med_cor_wallunitb"},
    {nom = "Table", prop = "v_med_cor_wheelbench"},
    {nom = "Gazebo", prop = "prop_gazebo_01"},
    {nom = "Gazebo 2", prop = "prop_gazebo_03"},
}

local gangitems = {
    {nom = "Chaise", prop = "bkr_prop_weed_chair_01a"},
    {nom = "Sac pour arme", prop = "prop_gun_case_01"},
    {nom = "Prop meth", prop = "bkr_prop_meth_pseudoephedrine"},
    {nom = "Sac de meth ouvert", propTable = "bkr_prop_meth_openbag_01a"},
    {nom = "Gros sac de meth", prop = "bkr_prop_meth_bigbag_04a"},
    {nom = "Gros sac de weed", prop = "bkr_prop_weed_bigbag_03a"},
    {nom = "Weed plante", prop = "bkr_prop_weed_01_small_01a"},
    {nom = "Weed", prop = "bkr_prop_weed_dry_02b"},
    {nom = "Table de weed", prop = "bkr_prop_weed_table_01a"},
    {nom = "Cash", prop = "hei_prop_cash_crate_half_full"},
    {nom = "Valise de cash", prop = "prop_cash_case_02"},
    {nom = "Petite pile de cash", prop = "prop_cash_crate_01"},
    {nom = "Poubelle", prop = "prop_cs_dumpster_01a"},
    {nom = "Canapé", prop = "v_tre_sofa_mess_c_s"},
    {nom = "Canapé 2", prop = "v_res_tre_sofa_mess_a"},
    {nom = "Pile de cash", prop = "bkr_prop_bkr_cashpile_04"},
    {nom = "Pile de cash 2", prop = "bkr_prop_bkr_cashpile_05"},
    {nom = "Block de coke", prop = "bkr_prop_coke_block_01a"},
    {nom = "Coke en bouteille", prop = "bkr_prop_coke_bottle_01a"},
    {nom = "Coke coupé", prop = "bkr_prop_coke_cut_01"},
    {nom = "Bol de coke", prop = "bkr_prop_coke_fullmetalbowl_02"},
}

Citizen.CreateThread(function()
	RMenu.Add('menu', 'propsmenu', RageUI.CreateMenu("Sunlife", "Menu Props", 1, 100))
    RMenu.Add('menu', 'civilitems', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Menu Props"))
    RMenu.Add('menu', 'emsitems', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Menu Props"))
    RMenu.Add('menu', 'lspditems', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Menu Props"))
    RMenu.Add('menu', 'gangitems', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Menu Props"))
    RMenu.Add('menu', 'objectlist', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Menu Props"))
    RMenu.Add('menu', 'saveobjectlist', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Sauvegarder un objet"))
    RMenu.Add('menu', 'savedpropslist', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Mes props sauvegardés"))
    RMenu.Add('menu', 'deletesavedpropslist', RageUI.CreateSubMenu(RMenu:Get('menu', 'propsmenu'), "Sunlife", "Supprimer un prop sauvegardé"))
	RMenu:Get('menu', 'propsmenu'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'civilitems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'emsitems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'lspditems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'gangitems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'objectlist'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'saveobjectlist'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'savedpropslist'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'deletesavedpropslist'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'propsmenu').EnableMouse = false
    RMenu:Get('menu', 'propsmenu').Closed = function()
		PropsOpen = false
    end
end)

object = {}

function openPropsMenu()
    if PropsOpen then
        PropsOpen = false
        return
    else
        PropsOpen = true
        RageUI.Visible(RMenu:Get('menu', 'propsmenu'), true)

        Citizen.CreateThread(function()
            while PropsOpen do
                Wait(0)
                RageUI.IsVisible(RMenu:Get('menu', 'propsmenu'), true, true, true, function()
                    RageUI.ButtonWithStyle("Civil", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'civilitems'))
                    RageUI.ButtonWithStyle("LSPD", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'lspditems'))
                    RageUI.ButtonWithStyle("EMS", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'emsitems'))
                    RageUI.ButtonWithStyle("Gang", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'gangitems'))
                    RageUI.ButtonWithStyle("Supprimer un objet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'objectlist'))
                    RageUI.ButtonWithStyle("Sauvegarder un objet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'saveobjectlist'))
                    RageUI.ButtonWithStyle("Mes props sauvegardés", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("props:loadConfigs")
                        end
                    end, RMenu:Get('menu', 'savedpropslist'))
                    RageUI.ButtonWithStyle("Supprimer un prop sauvegardé", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("props:loadConfigs")
                        end
                    end, RMenu:Get('menu', 'deletesavedpropslist'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'civilitems'), true, true, true, function()
                    for k,v in pairs(civilitems) do
                        RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                SpawnObj(v.prop)
                            end
                        end)
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'lspditems'), true, true, true, function()
                    for k,v in pairs(lspditems) do
                        RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                SpawnObj(v.prop)
                            end
                        end)
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'emsitems'), true, true, true, function()
                    for k,v in pairs(emsitems) do
                        RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                SpawnObj(v.prop)
                            end
                        end)
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'gangitems'), true, true, true, function()
                    for k,v in pairs(gangitems) do
                        RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                SpawnObj(v.prop)
                            end
                        end)
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'objectlist'), true, true, true, function()
                    for i = #object, 1, -1 do
                        if not DoesEntityExist(NetworkGetEntityFromNetworkId(object[i])) then
                            table.remove(object, i)
                        end
                    end
                    for k, netId in ipairs(object) do
                        local entity = NetworkGetEntityFromNetworkId(netId)
                        if DoesEntityExist(entity) then
                            local objNetId = netId
                            RageUI.ButtonWithStyle("Objet: "..GoodName(GetEntityModel(entity)).." ["..netId.."]", nil, {RightLabel = "Supprimer"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    local ObjCoords = GetEntityCoords(entity)
                                    DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                                end
                                if Selected then
                                    RemoveObj(objNetId)
                                end
                            end)
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'savedpropslist'), true, true, true, function()
                    local savedProps = GetSavedPropsConfigs()
                    if #savedProps == 0 then
                        RageUI.ButtonWithStyle("~c~Aucun prop sauvegardé", nil, {}, false, function() end)
                    else
                        for _, config in ipairs(savedProps) do
                            local cfg = config
                            local label = (cfg.name and cfg.name ~= "" and cfg.name) or ("Prop #" .. (cfg.id or "?"))
                            RageUI.ButtonWithStyle(label, nil, {RightLabel = "Placer →"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PlaceSavedPropAtPosition(cfg)
                                end
                            end)
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'deletesavedpropslist'), true, true, true, function()
                    local savedProps = GetSavedPropsConfigs()
                    if #savedProps == 0 then
                        RageUI.ButtonWithStyle("~c~Aucun prop sauvegardé", nil, {}, false, function() end)
                    else
                        for _, config in ipairs(savedProps) do
                            local cfg = config
                            local label = (cfg.name and cfg.name ~= "" and cfg.name) or ("Prop #" .. (cfg.id or "?"))
                            RageUI.ButtonWithStyle(label, nil, {RightLabel = "~r~Supprimer"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    DeleteSavedProp(cfg.id)
                                end
                            end)
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'saveobjectlist'), true, true, true, function()
                    for k, netId in ipairs(object) do
                        local entity = NetworkGetEntityFromNetworkId(netId)
                        if not DoesEntityExist(entity) then goto continue end
                        local objNetId = netId
                        local defaultName = GoodName(GetEntityModel(entity))
                        RageUI.ButtonWithStyle("Sauvegarder: "..defaultName.." ["..netId.."]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Active then
                                local ObjCoords = GetEntityCoords(entity)
                                DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                            end
                            if Selected then
                                local input = lib.inputDialog('Sauvegarder le prop', {
                                    {type = 'input', label = 'Nom du prop', description = 'Donnez un nom à votre prop', required = true, default = tostring(defaultName)}
                                })
                                if input and input[1] and input[1] ~= '' then
                                    SavePropToConfig(objNetId, input[1])
                                end
                            end
                        end)
                        ::continue::
                    end
                end, function()
                end)
            end
        end, function()
        end, 1)
    end
end

RegisterNetEvent('props:openMenu')
AddEventHandler('props:openMenu', function()
    openPropsMenu()
end)

RegisterCommand("props", function()
    openPropsMenu()
end)

RegisterKeyMapping('props', 'Ouvrir le menu Props', 'keyboard', 'F9')
