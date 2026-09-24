PlayerProps = {}
PlayerParticles = {}
PtfxNotif = false

anim_list_food = {
    ["beer3"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_c", "Beer 3", AnimationOptions = {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.06, 0.0, 15.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["blue_ice"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vodka shot", AnimationOptions = {
        Prop = 'prop_daiquiri',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["vodka_shot"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vodka shot", AnimationOptions = {
        Prop = 'prop_cocktail_glass',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["champagne"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Champagne", AnimationOptions = {
        Prop = 'prop_drink_champ',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["beer4"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_a", "Beer 4", AnimationOptions = {
        Prop = 'prop_beer_pissh',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.05, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["whiskey"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions = {
        Prop = 'prop_drink_whisky',
        PropBone = 28422,
        PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["vodka"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Vodka", AnimationOptions = {
        Prop = 'prop_vodka_bottle',
        PropBone = 28422,
        PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["coffee"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee", AnimationOptions =
    {
        Prop = 'p_amb_coffeecup_01',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["beer"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Beer", AnimationOptions =
    {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["heineken"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Heineken", AnimationOptions =
    {
        Prop = 'prop_beer_logopen',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["guitar"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar", AnimationOptions =
    {
        Prop = 'prop_acc_guitar_01',
        PropBone = 24818,
        PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["guitarelectric"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar Electric", AnimationOptions = {
        Prop = 'prop_el_guitar_01',
        PropBone = 24818,
        PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["smoke2"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_c", "Smoke 2", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["smoke3"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_b", "Smoke 3", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true, }},
    ["smoke4"] = {"amb@world_human_smoking@female@idle_a", "idle_b", "Smoke 4", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["bong"] = {"anim@safehouse@bong", "bong_stage3", "Bong", AnimationOptions = {
        Prop = 'hei_heist_sh_bong_01',
        PropBone = 18905,
        PropPlacement = {0.10,-0.25,0.0,95.0,190.0,180.0},
    }},
    ["guitarelectric2"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar Electric 2", AnimationOptions = {
        Prop = 'prop_el_guitar_03',
        PropBone = 24818,
        PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["wine"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Wine", AnimationOptions = {
        Prop = 'prop_drink_redwine',
        PropBone = 18905,
        PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["book"] = {"cellphone@", "cellphone_text_read_base", "Book", AnimationOptions = {
        Prop = 'prop_novel_01',
        PropBone = 6286,
        PropPlacement = {0.15, 0.03, -0.065, 0.0, 180.0, 90.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["donut"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions = {
        Prop = 'prop_amb_donut',
        PropBone = 18905,
        PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
        EmoteMoving = true,
    }},
    ["cup"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Cup", AnimationOptions = {
        Prop = 'prop_plastic_cup_02',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["flute"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Flute", AnimationOptions = {
        Prop = 'prop_champ_flute',
        PropBone = 18905,
        PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
        EmoteMoving = true,
        EmoteLoop = true
    }},
    ["soda"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Soda", AnimationOptions = {
        Prop = 'prop_ecola_can',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["sprunk"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Sprunk", AnimationOptions = {
        Prop = 'ng_proc_sodacan_01b',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["jus_orange"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Jus d'orange", AnimationOptions = {
        Prop = 'prop_cs_script_bottle_01',
        PropBone = 28422,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["chips"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Chips", AnimationOptions = {
        Prop = 'ng_proc_food_chips01b',
        PropBone = 18905,
        PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
        EmoteMoving = true,
    }},
    ["cacahuete"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Cacahuete", AnimationOptions = {
        Prop = 'v_ret_ml_chips3',
        PropBone = 18905,
        PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
        EmoteMoving = true,
    }},
    ["flammekueche"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Flammekueche", AnimationOptions = {
        Prop = 'ng_proc_food_burg02a',
        PropBone = 18905,
        PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
        EmoteMoving = true,
    }},
    ["sandwich"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions = {
        Prop = 'prop_sandwich_01',
        PropBone = 18905,
        PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
        EmoteMoving = true,
    }},
}

anim_list_action = {
    ["pee"] = {"misscarsteal2peeing", "peeing_loop", "Pee", AnimationOptions = {
        EmoteStuck = true,
        PtfxAsset = "scr_amb_chop",
        PtfxName = "ent_anim_dog_peeing",
        PtfxNoProp = true,
        PtfxPlacement = {-0.05, 0.3, 0.0, 0.0, 90.0, 90.0, 1.0},
        PtfxInfo = "",
        PtfxWait = 3000,
    }},
}

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function PtfxThis(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        RequestNamedPtfxAsset(asset)
        Wait(10)
    end
    UseParticleFxAssetNextCall(asset)
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    print(('^2[NETDIAG][OBJET]^7 %s cl_animations.lua:242 CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(prop1)))
    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2, true, true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)

    return prop
end

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

function DestroyAllProps()
    for _,v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = PlayerPedId()
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
    for a,b in pairs(PlayerParticles) do
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end
