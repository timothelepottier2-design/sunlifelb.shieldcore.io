-- ============================================================================
-- Pack "Pazeee New Roleplay Emote V2" - ajout au menu animations.
-- Les .ycd / .ydr / .ytyp du pack doivent etre dans le stream de sunlife.
--
-- Les emotes sont reparties dans les categories existantes du menu :
--   Shared (partagees) / Sits (assis) / Poses / Salutes / Meme / Emotes / PropEmotes
--
-- Options du pack traduites en options dpemotes :
--   Flag 1  -> EmoteLoop            Flag 33 -> EmoteLoop + EmoteMoving
--   Flag 2  -> EmoteLoop (tenir la pose)   Flag 48/50 -> EmoteStuck (haut du corps)
-- ============================================================================

local function D(name) return "pazeee@" .. name .. "@animations" end
local function C(name) return "pazeee@" .. name .. "@clip" end

local PAZEEE = {}

-- 👫 Emotes partagees (4e champ = emote du partenaire)
PAZEEE.Shared = {
    ["pmotoraa"] = { D("motoraa"), C("motoraa"), "Moto imaginaire A (pilote)", "pmotora", AnimationOptions = {} },
    ["pmotora"]  = { D("motora"),  C("motora"),  "Moto imaginaire A (passager)", "pmotoraa", AnimationOptions = {
        EmoteLoop = true, Attachto = true, bone = 11816,
        xPos = 0.5500, yPos = 0.1500, zPos = -0.1200, xRot = 0.000, yRot = 0.000, zRot = -14.000 } },
    ["pmotorb"]  = { D("motorb"),  C("motorb"),  "Moto imaginaire B (pilote)", "pmotorc", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pmotorc"]  = { D("motorc"),  C("motorc"),  "Moto imaginaire B (passager)", "pmotorb", AnimationOptions = {
        EmoteLoop = true, Attachto = true, bone = 24818,
        xPos = 0.3200, yPos = -0.1300, zPos = -0.2800, xRot = 0.000, yRot = 0.000, zRot = -28.000 } },
    ["pholdlega"] = { D("holdlega"), C("holdlega"), "Tenir la jambe A", "pholdlegb", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pholdlegb"] = { D("holdlegb"), C("holdlegb"), "Tenir la jambe B", "pholdlega", AnimationOptions = {
        EmoteLoop = true, Attachto = true, bone = 52301,
        xPos = -0.4100, yPos = -0.1700, zPos = 1.1300, xRot = 0.000, yRot = 0.000, zRot = 0.000 } },
    ["pstucklega"] = { D("stucklega"), C("stucklega"), "Jambe coincee A", "pstucklegb", AnimationOptions = { EmoteLoop = true } },
    ["pstucklegb"] = { D("stucklegb"), C("stucklegb"), "Jambe coincee B", "pstucklega", AnimationOptions = {
        EmoteLoop = true, Attachto = true, bone = 16335,
        xPos = 0.4100, yPos = -0.1700, zPos = 0.1300, xRot = 0.000, yRot = 0.000, zRot = 0.000 } },
    ["pcartcementb"] = { D("cartcementb"), C("cartcementb"), "Brouette B (pousseur)", "pcartcementc", AnimationOptions = {
        EmoteLoop = true, EmoteMoving = true,
        Prop = 'prop_wheelbarrow01a', PropBone = 28422,
        PropPlacement = { 0.8500, 0.62, 0.0, -36.633, -51.309, 60.93 } } },
    ["pcartcementc"] = { D("cartcementc"), C("cartcementc"), "Brouette C (dans la brouette)", "pcartcementb", AnimationOptions = {
        EmoteLoop = true, Attachto = true, bone = 28422,
        xPos = 0.1800, yPos = 0.7100, zPos = -0.0500, xRot = 0.000, yRot = 0.000, zRot = -10.000 } },
    ["pfunnypuncha"] = { D("funnypuncha"), C("funnypuncha"), "Faux coup de poing A", "pfunnypunchb", AnimationOptions = {
        SyncOffsetFront = 1.35, SyncOffsetSide = -0.15, EmoteLoop = true } },
    ["pfunnypunchb"] = { D("funnypunchb"), C("funnypunchb"), "Faux coup de poing B", "pfunnypuncha", AnimationOptions = {
        SyncOffsetFront = 1.35, SyncOffsetSide = -0.15, EmoteLoop = true } },
}

-- 🪑 Assis
PAZEEE.Sits = {
    ["psitgrounda"] = { D("sitgrounda"), C("sitgrounda"), "Assis au sol A", AnimationOptions = { EmoteLoop = true } },
    ["psitgroundb"] = { D("sitgroundb"), C("sitgroundb"), "Assis au sol B", AnimationOptions = { EmoteLoop = true } },
    ["psitgroundc"] = { D("sitgroundc"), C("sitgroundc"), "Assis au sol C", AnimationOptions = { EmoteLoop = true } },
    ["psitgroundd"] = { D("sitgroundd"), C("sitgroundd"), "Assis au sol D", AnimationOptions = { EmoteLoop = true } },
    ["psitgrounde"] = { D("sitgrounde"), C("sitgrounde"), "Assis au sol E", AnimationOptions = { EmoteLoop = true } },
    ["psitgroundf"] = { D("sitgroundf"), C("sitgroundf"), "Assis au sol F (cigarette)", AnimationOptions = {
        EmoteLoop = true, Prop = 'ng_proc_cigarette01a', PropBone = 64097,
        PropPlacement = { 0.0240, 0.010, 0.013, -136.062, -117.953, 1.510 } } },
    ["psitgroundg"] = { D("sitgroundg"), C("sitgroundg"), "Assis au sol G (cigarette)", AnimationOptions = {
        EmoteLoop = true, Prop = 'ng_proc_cigarette01a', PropBone = 64097,
        PropPlacement = { 0.020, 0.0160, -0.004, 90.0, -90.0, 79.99 } } },
    ["psitgroundh"] = { D("sitgroundh"), C("sitgroundh"), "Assis au sol H (telephone)", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_player_phone_02', PropBone = 57005,
        PropPlacement = { 0.1520, 0.07, -0.05, 166.383, 150.432, -3.719 } } },
    ["penjoyviewc"] = { D("enjoyviewc"), C("enjoyviewc"), "Chaise, profiter de la vue A", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_skid_chair_03', PropBone = 14201,
        PropPlacement = { -0.3700, 0.35, -0.14, -77.8344, 44.84, 19.809 } } },
    ["penjoyviewd"] = { D("enjoyviewd"), C("enjoyviewd"), "Chaise, profiter de la vue B", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_skid_chair_03', PropBone = 14201,
        PropPlacement = { -0.3100, 0.35, -0.14, -77.8344, 44.84, 19.809 } } },
    ["pkingchaira"] = { D("kingchaira"), C("kingchaira"), "Trone A", AnimationOptions = {
        EmoteLoop = true, Prop = 'paze_kingchair1', PropBone = 52301,
        PropPlacement = { -0.2300, -1.28, 0.59, -92.2377, 98.943, -28.329 } } },
    ["pkingchairb"] = { D("kingchairb"), C("kingchairb"), "Trone B", AnimationOptions = {
        EmoteLoop = true, Prop = 'paze_kingchair1', PropBone = 57005,
        PropPlacement = { 0.8700, 0.65, -1.81, 84.6822, -112.759, 80.429 } } },
    ["pkingchairc"] = { D("kingchairc"), C("kingchairc"), "Trone C", AnimationOptions = {
        EmoteLoop = true, Prop = 'paze_kingchair1', PropBone = 52301,
        PropPlacement = { 0.4800, -1.76, -0.36, -107.078, 135.068, -4.95 } } },
    ["pkingchaird"] = { D("kingchaird"), C("kingchaird"), "Trone D", AnimationOptions = {
        EmoteLoop = true, Prop = 'paze_kingchair1', PropBone = 14201,
        PropPlacement = { -0.9600, -1.83, -1.0, -112.87, -104.84, -23.328 } } },
    ["pkingchaire"] = { D("kingchaire"), C("kingchaire"), "Trone E", AnimationOptions = {
        EmoteLoop = true, Prop = 'paze_kingchair1', PropBone = 52301,
        PropPlacement = { 0.5600, -1.7, -0.490, -108.37, 93.757, 11.404 } } },
}

-- 🧍 Poses
PAZEEE.Poses = {
    ["parroganta"] = { D("arroganta"), C("arroganta"), "Arrogant A", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["parrogantb"] = { D("arrogantb"), C("arrogantb"), "Arrogant B", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["parrogantc"] = { D("arrogantc"), C("arrogantc"), "Arrogant C", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["parrogantd"] = { D("arrogantd"), C("arrogantd"), "Arrogant D", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["parrogante"] = { D("arrogante"), C("arrogante"), "Arrogant E", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pbravea"] = { D("bravea"), C("bravea"), "Courageux A", AnimationOptions = { EmoteLoop = true } },
    ["pbraveb"] = { D("braveb"), C("braveb"), "Courageux B", AnimationOptions = { EmoteLoop = true } },
    ["pbravec"] = { D("bravec"), C("bravec"), "Courageux C", AnimationOptions = { EmoteLoop = true } },
    ["pbraved"] = { D("braved"), C("braved"), "Courageux D", AnimationOptions = { EmoteLoop = true } },
    ["penjoyviewa"] = { D("enjoyviewa"), C("enjoyviewa"), "Profiter de la vue A", AnimationOptions = { EmoteLoop = true } },
    ["penjoyviewb"] = { D("enjoyviewb"), C("enjoyviewb"), "Profiter de la vue B", AnimationOptions = { EmoteLoop = true } },
    ["pdeadb"] = { D("deadb"), C("deadb"), "Faire le mort (allonge)", AnimationOptions = { EmoteLoop = true } },
}

-- 🫡 Salutations
PAZEEE.Salutes = {
    ["ppalmfistsalutea"] = { D("palmfistsalutea"), C("palmfistsalutea"), "Salut poing-paume A", AnimationOptions = { EmoteStuck = true } },
    ["ppalmfistsaluteb"] = { D("palmfistsaluteb"), C("palmfistsaluteb"), "Salut poing-paume B", AnimationOptions = { EmoteStuck = true } },
    ["pfisthandskya"] = { D("fisthandskya"), C("fisthandskya"), "Poing vers le ciel A", AnimationOptions = { EmoteStuck = true } },
    ["pfisthandskyb"] = { D("fisthandskyb"), C("fisthandskyb"), "Poing vers le ciel B", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
}

-- 🤪 Memes
PAZEEE.Meme = {
    ["pmonkeya"] = { D("monkeya"), C("monkeya"), "Singe A", AnimationOptions = { EmoteLoop = true } },
    ["pmonkeyb"] = { D("monkeyb"), C("monkeyb"), "Singe B", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pmonkeyc"] = { D("monkeyc"), C("monkeyc"), "Singe C", AnimationOptions = {} },
    ["pmonggoa"] = { D("monggoa"), C("monggoa"), "Monggo A", AnimationOptions = { EmoteLoop = true } },
    ["pmonggob"] = { D("monggob"), C("monggob"), "Monggo B", AnimationOptions = { EmoteLoop = true } },
    ["pmonggoc"] = { D("monggoc"), C("monggoc"), "Monggo C", AnimationOptions = { EmoteLoop = true } },
    ["pmonggod"] = { D("monggod"), C("monggod"), "Monggo D", AnimationOptions = { EmoteLoop = true } },
    ["pmonggoe"] = { D("monggoe"), C("monggoe"), "Monggo E", AnimationOptions = { EmoteLoop = true } },
    ["pmonggof"] = { D("monggof"), C("monggof"), "Monggo F", AnimationOptions = { EmoteLoop = true } },
    ["ppoopa"] = { D("poopa"), C("poopa"), "Caca A", AnimationOptions = { EmoteLoop = true } },
    ["ppoopb"] = { D("poopb"), C("poopb"), "Caca B (toilettes)", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_toilet_01', PropBone = 52301,
        PropPlacement = { -0.2900, -0.20, -0.04, -109.955, 93.759, -1.367 } } },
    ["ppoopc"] = { D("poopc"), C("poopc"), "Caca C (toilettes + journal)", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_toilet_01', PropBone = 52301,
        PropPlacement = { -0.3600, -0.240, -0.04, -109.955, 93.759, -1.367 },
        SecondProp = 'prop_cs_newspaper', SecondPropBone = 57005,
        SecondPropPlacement = { 0.1200, 0.280, -0.35, -51.531, -87.427, -33.627 } } },
    ["ppoopd"] = { D("poopd"), C("poopd"), "Caca D (toilettes)", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_toilet_01', PropBone = 52301,
        PropPlacement = { 0.0700, -0.550, -0.14, -109.955, 93.759, -1.367 } } },
    ["pfakeblinda"] = { D("fakeblinda"), C("fakeblinda"), "Faux aveugle", AnimationOptions = {
        EmoteLoop = true, Prop = 'prop_cs_sol_glasses', PropBone = 31086,
        PropPlacement = { 0.050, 0.05, 0.0, -180.0, -90.0, 0.0 },
        SecondProp = 'prop_cs_walking_stick', SecondPropBone = 57005,
        SecondPropPlacement = { 0.110, 0.05, -0.01, -180.0, 90.0, 20.0 } } },
    ["pyappinga"] = { D("yappinga"), C("yappinga"), "Blabla A", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pyappingb"] = { D("yappingb"), C("yappingb"), "Blabla B", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pyappingc"] = { D("yappingc"), C("yappingc"), "Blabla C", AnimationOptions = { EmoteLoop = true } },
    ["pyappingd"] = { D("yappingd"), C("yappingd"), "Blabla D", AnimationOptions = { EmoteLoop = true } },
    ["pgamehanda"] = { D("gamehanda"), C("gamehanda"), "Manette imaginaire A", AnimationOptions = { EmoteStuck = true } },
    ["pgamehandb"] = { D("gamehandb"), C("gamehandb"), "Manette imaginaire B", AnimationOptions = { EmoteStuck = true } },
    ["pinhalea"] = { D("inhalea"), C("inhalea"), "Inspirer / expirer", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pdeadc"] = { D("deadc"), C("deadc"), "Mort, envol", AnimationOptions = { EmoteLoop = true } },
}

-- 🙂 Emotes classiques
PAZEEE.Emotes = {
    ["pcheckpocketsa"] = { D("checkpocketsa"), C("checkpocketsa"), "Fouiller ses poches", AnimationOptions = {} },
    ["pdeada"] = { D("deada"), C("deada"), "Refuser de mourir", AnimationOptions = {} },
    ["pexcusemewalka"] = { D("excusemewalka"), C("excusemewalka"), "Excusez-moi (passer) A", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["pexcusemewalkb"] = { D("excusemewalkb"), C("excusemewalkb"), "Excusez-moi (passer) B", AnimationOptions = { EmoteLoop = true, EmoteMoving = true } },
    ["phideandseeka"] = { D("hideandseeka"), C("hideandseeka"), "Cache-cache A", AnimationOptions = { EmoteLoop = true } },
    ["phideandseekb"] = { D("hideandseekb"), C("hideandseekb"), "Cache-cache B", AnimationOptions = {} },
    ["phideandseekc"] = { D("hideandseekc"), C("hideandseekc"), "Cache-cache C", AnimationOptions = {} },
    ["phideandseekd"] = { D("hideandseekd"), C("hideandseekd"), "Cache-cache D", AnimationOptions = {} },
    ["pmotord"] = { D("motord"), C("motord"), "Moto imaginaire solo D", AnimationOptions = { EmoteLoop = true } },
    ["pmotore"] = { D("motore"), C("motore"), "Moto imaginaire solo E", AnimationOptions = { EmoteLoop = true } },
    ["pmotorf"] = { D("motorf"), C("motorf"), "Moto imaginaire solo F", AnimationOptions = { EmoteLoop = true } },
    ["pmotorg"] = { D("motorg"), C("motorg"), "Moto imaginaire solo G", AnimationOptions = { EmoteLoop = true } },
    ["ppickupa"] = { D("pickupa"), C("pickupa"), "Ramasser A", AnimationOptions = { EmoteLoop = true } },
    ["ppickupb"] = { D("pickupb"), C("pickupb"), "Ramasser B", AnimationOptions = { EmoteLoop = true } },
    ["ppickupc"] = { D("pickupc"), C("pickupc"), "Ramasser C", AnimationOptions = { EmoteLoop = true } },
    ["ppickupd"] = { D("pickupd"), C("pickupd"), "Ramasser D", AnimationOptions = { EmoteLoop = true } },
    ["ppickupe"] = { D("pickupe"), C("pickupe"), "Ramasser E", AnimationOptions = { EmoteLoop = true } },
    ["ppickupf"] = { D("pickupf"), C("pickupf"), "Ramasser F", AnimationOptions = { EmoteLoop = true } },
    ["ppickupg"] = { D("pickupg"), C("pickupg"), "Ramasser G", AnimationOptions = { EmoteLoop = true } },
    ["ppickuph"] = { D("pickuph"), C("pickuph"), "Ramasser H", AnimationOptions = { EmoteLoop = true } },
    ["ppickupi"] = { D("pickupi"), C("pickupi"), "Ramasser I", AnimationOptions = { EmoteLoop = true } },
    ["ppickupj"] = { D("pickupj"), C("pickupj"), "Ramasser J", AnimationOptions = { EmoteLoop = true } },
    ["ppickupk"] = { D("pickupk"), C("pickupk"), "Ramasser K", AnimationOptions = { EmoteLoop = true } },
    ["ppickupl"] = { D("pickupl"), C("pickupl"), "Ramasser L", AnimationOptions = { EmoteLoop = true } },
    ["ppickupm"] = { D("pickupm"), C("pickupm"), "Ramasser M", AnimationOptions = { EmoteLoop = true } },
    ["ppickupn"] = { D("pickupn"), C("pickupn"), "Ramasser N", AnimationOptions = { EmoteLoop = true } },
    ["psada"] = { D("sada"), C("sada"), "Triste A", AnimationOptions = { EmoteLoop = true } },
    ["psadb"] = { D("sadb"), C("sadb"), "Triste B", AnimationOptions = { EmoteLoop = true } },
    ["psadc"] = { D("sadc"), C("sadc"), "Triste C", AnimationOptions = { EmoteLoop = true } },
    ["psadd"] = { D("sadd"), C("sadd"), "Triste D", AnimationOptions = { EmoteLoop = true } },
    ["pteamdisc1a"] = { D("teamdisc1a"), C("teamdisc1a"), "Discussion d'equipe 1A", AnimationOptions = { EmoteLoop = true } },
    ["pteamdisc1b"] = { D("teamdisc1b"), C("teamdisc1b"), "Discussion d'equipe 1B", AnimationOptions = { EmoteLoop = true } },
    ["pteamdisc2a"] = { D("teamdisc2a"), C("teamdisc2a"), "Discussion d'equipe 2A", AnimationOptions = { EmoteLoop = true } },
    ["pteamdisc2b"] = { D("teamdisc2b"), C("teamdisc2b"), "Discussion d'equipe 2B", AnimationOptions = { EmoteLoop = true } },
    ["pteamdisc2c"] = { D("teamdisc2c"), C("teamdisc2c"), "Discussion d'equipe 2C", AnimationOptions = {} },
    ["ptherea"] = { D("therea"), C("therea"), "Montrer la-bas", AnimationOptions = { EmoteLoop = true } },
    ["pwhatsthata"] = { D("whatsthata"), C("whatsthata"), "C'est quoi ca ?", AnimationOptions = {} },
}

-- 📦 Emotes avec objet
PAZEEE.PropEmotes = {
    ["pcheckpocketsb"] = { D("checkpocketsb"), C("checkpocketsb"), "Compter ses billets", AnimationOptions = {
        EmoteStuck = true, Prop = 'bkr_prop_money_sorted_01', PropBone = 57005,
        PropPlacement = { 0.1600, -0.030, -0.03, 9.851, -9.8510, -1.7279 } } },
    ["pegranga"] = { D("egranga"), C("egranga"), "Echasses A", AnimationOptions = {
        EmoteLoop = true, Prop = 'a3d_egrang1', PropBone = 52301,
        PropPlacement = { 0.3100, -0.010, -0.03, -110.7639, 98.637, -5.438 },
        SecondProp = 'a3d_egrang1', SecondPropBone = 14201,
        SecondPropPlacement = { 0.3100, -0.010, 0.03, -112.9874, 88.1588, 0.7813 } } },
    ["pegrangb"] = { D("egrangb"), C("egrangb"), "Echasses B (marcher)", AnimationOptions = {
        EmoteLoop = true, EmoteMoving = true, Prop = 'a3d_egrang1', PropBone = 52301,
        PropPlacement = { 0.3100, -0.010, -0.03, -110.7639, 98.637, -5.438 },
        SecondProp = 'a3d_egrang1', SecondPropBone = 14201,
        SecondPropPlacement = { 0.3100, -0.010, 0.03, -112.9874, 88.1588, 0.7813 } } },
    ["pmastera"] = { D("mastera"), C("mastera"), "Maitre au baton", AnimationOptions = {
        EmoteLoop = true, Prop = 'a3d_egrang1', PropBone = 57005,
        PropPlacement = { 0.0200, -0.26, -0.18, 109.68, 70.768, 25.407 } } },
    ["pcartcementa"] = { D("cartcementa"), C("cartcementa"), "Brouette A (solo)", AnimationOptions = {
        EmoteLoop = true, EmoteMoving = true, Prop = 'prop_wheelbarrow01a', PropBone = 28422,
        PropPlacement = { 0.8500, 0.62, 0.0, -36.633, -51.309, 60.93 } } },
}

-- Injection dans les tables DP (attend que AnimationList.lua soit charge,
-- quel que soit l'ordre de chargement des fichiers).
CreateThread(function()
    while DP == nil or DP.Emotes == nil do Wait(50) end
    local added = 0
    for category, list in pairs(PAZEEE) do
        DP[category] = DP[category] or {}
        for name, data in pairs(list) do
            if DP[category][name] == nil then
                DP[category][name] = data
                added = added + 1
            end
        end
    end
    PAZEEE = nil
    print(("[dpemotes] Pack Pazeee V2 : %d emotes ajoutees au menu"):format(added))
end)
