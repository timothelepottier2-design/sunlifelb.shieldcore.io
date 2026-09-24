local Player = PlayerPedId()
local ped = PlayerPedId()
local holstered = true
local blocked = false
local currWeapon = nil
local isPolice = false

local weapons_list = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_SPECTREAQ',
	'WEAPON_AQAK',
    'WEAPON_DESERTNIKE',
    'WEAPON_REDL',
    'WEAPON_M4_STORMBORN',
    'WEAPON_REDLINE_FANG',
    'WEAPON_M133V3',
    'WEAPON_TAR21',
    'WEAPON_MP9',
    'WEAPON_P20_ASIIMOV',
    'WEAPON_M4ASIIMOV',
    'WEAPON_M4A1_SPIKESHINE',
    'WEAPON_MINISMG_SPIKESHINE',
    'WEAPON_FAMASC',
    'WEAPON_PATRIOTKNIFE',
    'WEAPON_PISTOLPATRIOT',
    'WEAPON_PATRIOT',
    'WEAPON_FAMAS',
    'WEAPON_M4BEAST',
    'WEAPON_TEC9MF',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_STUNGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_GLOCK',
	'WEAPON_GADGETPISTOL',
	'WEAPON_SCAR17FM',
    'WEAPON_SLIMAQ',
    'WEAPON_BATAQ',
    'WEAPON_SPECTREAQ',
	'WEAPON_TACTICALRIFLE',
	'WEAPON_HEAVYRIFLE',
	'WEAPON_MK18B',
    'WEAPON_MILITARYRIFLE',
    'WEAPON_HK416A',
    'WEAPON_MP5',
    'WEAPON_MP7',
    'WEAPON_G19',
    'WEAPON_BEANBAG',
    'WEAPON_UMP45CMG',
    'WEAPON_DILDOCMG',
    'WEAPON_BREAD',
    'WEAPON_EXTENDEDSMG',
    'WEAPON_GOLDSMG',
    'WEAPON_GUITARCMG',
    'WEAPON_KATANA',
    'WEAPON_FIREAXECMG',
    'WEAPON_DEMHAMMER',
    'WEAPON_CHAINSAW',
    'WEAPON_SLICE',
    'WEAPON_PUMPKIN',
    'WEAPON_357',
    'WEAPON_CANDYKNIFE',
    'WEAPON_DESERTSANTA',
    'WEAPON_HATMAS',
    'WEAPON_SANTAS',
    'WEAPON_XMASRIFLE',
    'WEAPON_PISTOLXMAS',
    'WEAPON_SNOWXMAS',
    'WEAPON_CARROTKNIFE',
    'WEAPON_REVOLVERULTRA',
    'WEAPON_SIG550',
    'WEAPON_M4LOVER',
    'WEAPON_PBLACKVAL',
    'WEAPON_WOLFKNIFE',
    'WEAPON_WOLFVERN',
    'WEAPON_ASSAULTRIFLELS',
    'WEAPON_AKCARROT',
    'WEAPON_CARROTSMG',
    'WEAPON_CARROTSWORD',
    'WEAPON_CARROTTEC',
    'WEAPON_REVOCARROT',
    'WEAPON_FRYINPAN',
    'WEAPON_HFAP',
    'WEAPON_UMP45',
    'WEAPON_GK47',
    'WEAPON_A15RC',
    'WEAPON_AK47_NIGHTWISH',
    'WEAPON_BAS_P_RED',
    'WEAPON_CZ75',
    'WEAPON_SFTANA',
    'WEAPON_M4_T_NEON',
    'WEAPON_BRICK',
    'WEAPON_BRICK2',
    'WEAPON_AK_SHORTSTOCK_CHR',
    'WEAPON_COMBAT_PISTOL_CHROMIUM',
    'WEAPON_GROZA_CHROMIUM',
    'WEAPON_MP7_CHROMIUM',
    'WEAPON_VIOLET_VENGANGE_CHR',
    'WEAPON_BULLPUP_SMG',
    'WEAPON_AK_47_RED_CHROMIUM',
    'WEAPON_SCARSC',
    'WEAPON_MACHINE_PISTOL_RED_CHR',
    'WEAPON_COMBATHP',
    'WEAPON_NVRIFLE_PURPLE',
    'WEAPON_VECTOR',
    'WEAPON_M415',
    'WEAPON_AXE',
    'WEAPON_BARBEDBAT',
    'WEAPON_BATON',
    'WEAPON_BLACKKATANA',
    'WEAPON_BLUEZK',
    'WEAPON_BROWNMACHETE',
    'WEAPON_BUTCHER',
    'WEAPON_CHAIR',
    'WEAPON_CRUTCH',
    'WEAPON_DILDO',
    'WEAPON_EGUITAR',
    'WEAPON_GUITAR',
    'WEAPON_HUNTERKNIFE',
    'WEAPON_ICECLIMBER',
    'WEAPON_KITCHENKNIFE',
    'WEAPON_KUKRI',
    'WEAPON_LONGMACHETE',
    'WEAPON_MACE',
    'WEAPON_PICKAXE',
    'WEAPON_PINKZK',
    'WEAPON_PITCHFORK',
    'WEAPON_REDZK',
    'WEAPON_SCIFISWORD',
    'WEAPON_SCIMITAR',
    'WEAPON_SCREWDRIVER',
    'WEAPON_SCYTHE',
    'WEAPON_SHOVEL',
    'WEAPON_SLEDGEHAMMER',
    'WEAPON_SPIKEDKNUCKLES',
    'WEAPON_SPIKEYBAT',
    'WEAPON_STOPSIGN',
    'WEAPON_TACAXE',
    'WEAPON_TACCLEAVER',
    'WEAPON_TACTICALHATCHET',
    'WEAPON_THORSHAMMER',
    'WEAPON_TWOHBATTLEAXE',
    'WEAPON_WCLAWS',
    'WEAPON_ZK',
    'WEAPON_KS1',
    'WEAPON_HKUSP',
    'WEAPON_SLR15',
    'WEAPON_XM7_6_8',
    'WEAPON_PKISS',
    'WEAPON_BATCANDY',
    'WEAPON_KNIFEVALEN',
    'WEAPON_CZ_SCORPION_EVO_CHR',
    'WEAPON_SS2_2',
    'WEAPON_VERESK',
    'WEAPON_MLTM4R_CHR',
    'WEAPON_SPS_21_SG_CHR',
    'WEAPON_TR_88_CHR',
    'WEAPON_M270D_CHR',
    'WEAPON_DMRSNIPER',
    'WEAPON_GAU_5A_FEM',
    'WEAPON_HOWA_T20_CHR',
    'WEAPON_COMBAT_SG_CHR',
    'WEAPON_SPX_7_CHR',
    'WEAPON_SR_3M_CHR',
    'WEAPON_HK2002M_CHR',
    'WEAPON_SYS_PISTOL_CHR',
    'WEAPON_BONECLUB',
    'WEAPON_BUCKET',
    'WEAPON_COFFIN',
    'WEAPON_DEATHNOTE',
    'WEAPON_HELLFIRESWORD',
    'WEAPON_INFERNO',
    'WEAPON_PUMPKIN',
    'WEAPON_PUMPKINBAT',
    'WEAPON_ARM',
    'WEAPON_LEG',
    'WEAPON_STAKE',
    'WEAPON_TRIPLEBLADEDSCYTHE',
    'WEAPON_VOODOO',
    'WEAPON_WITCHBROOM',
    'WEAPON_SOULSCYTHE',
    'WEAPON_GRAVESTONE',
    'WEAPON_KITTBOWYAXE',
    'WEAPON_DIRTYSYRINGE',
    'WEAPON_BIGSPOON',
    'WEAPON_JABSAW',
    'WEAPON_TELESCOPE',
    'WEAPON_MEATSKEWER',
    'WEAPON_SWORDFISH',
    'WEAPON_LOBSTER',
    'WEAPON_PLIERS',
    'WEAPON_HANDDRILL',
    'WEAPON_TWISTEDSPEAR',
    'WEAPON_SNAKEKNIFE',
    'WEAPON_CRUTCHKNIFE',
    'WEAPON_SHARPARROW',
    'WEAPON_95SIGN',
    'WEAPON_ASSASINGUN',
    'WEAPON_BAGUETTE',
    'WEAPON_BANANA',
    'WEAPON_BIKE',
    'WEAPON_BONE',
    'WEAPON_BONESWORD',
    'WEAPON_BUTTPLUG',
    'WEAPON_CACTUS',
    'WEAPON_CAMSHAFT',
    'WEAPON_CARJACK',
    'WEAPON_CONE',
    'WEAPON_CROSSSPANNER',
    'WEAPON_CUCUMBER',
    'WEAPON_DISABLEDSIGN',
    'WEAPON_ELDERSWAND',
    'WEAPON_MFIREEXTINGUISHER',
    'WEAPON_FISHINGROD',
    'WEAPON_GASCYLINDER',
    'WEAPON_HOCKEYFSTICK',
    'WEAPON_HORN',
    'WEAPON_JDBOTTLE',
    'WEAPON_KEYBOARD',
    'WEAPON_KITCHENFORK',
    'WEAPON_LACROSSESTICK',
    'WEAPON_LADDER',
    'WEAPON_MAILBOX',
    'WEAPON_MIC',
    'WEAPON_NOPARKINGSIGN',
    'WEAPON_PEN',
    'WEAPON_PENCIL',
    'WEAPON_PROSLEG',
    'WEAPON_ROLLINGPIN',
    'WEAPON_RONABOTTLE',
    'WEAPON_ROUTE66SIGN',
    'WEAPON_SCOOTER',
    'WEAPON_SHOCKABSORBER',
    'WEAPON_SKULLBAT',
    'WEAPON_SPARTANSWORD',
    'WEAPON_SPATULA',
    'WEAPON_STEPLADDER',
    'WEAPON_STREETLIGHT',
    'WEAPON_TOASTER',
    'WEAPON_VACUUM',
    'WEAPON_WRONGWAYSIGN',
    'WEAPON_YARI',
    'WEAPON_BLACKBELT',
    'WEAPON_BENTFORK',
    'WEAPON_BLACKBACKPACK',
    'WEAPON_BRCHICKEN',
    'WEAPON_DOORBARS',
    'WEAPON_EARBUDBLADE',
    'WEAPON_HONEYDIPPER',
    'WEAPON_KETTLE',
    'WEAPON_LEATHERBRIEFCASE',
    'WEAPON_MAKESHIFTKNIFE',
    'WEAPON_MEASURINGCUP',
    'WEAPON_MODDEDNIGHTSTICK',
    'WEAPON_TRAYRACK',
    'WEAPON_POKER',
    'WEAPON_PRISONKEY',
    'WEAPON_PRISTOI',
    'WEAPON_REDBACKPACK',
    'WEAPON_RULER',
    'WEAPON_SHIV',
    'WEAPON_SOLIDOOR',
    'WEAPON_TEAPOT',
    'WEAPON_VIOBACKPACK',
    'WEAPON_PEELER',
    'WEAPON_G36',
    'WEAPON_G3_2',
    'WEAPON_L85_CHR',
    'WEAPON_R90_CHR',
    'WEAPON_VX_SCORPION_CHR',
    'WEAPON_ASSAULTRIFLECUPID',
    'WEAPON_ASSAULTRIFLE_MK2_DARKMATTER',
    'WEAPON_CARBINERIFLE_MK2_DARKMATTER',
    'WEAPON_SPECIALCARBINE_MK2_DARKMATTER',
    'WEAPON_MICROSMG_DARKMATTER',
    'WEAPON_REVOLVER_MK2_DARKMATTER',
    'WEAPON_KNUCKLE_DARKMATTER',
    'WEAPON_M249',
    'WEAPON_MK14',
    'WEAPON_RRT14_GANG',
    'WEAPON_P320_GANG',
}

function CheckWeapon()
	for i = 1, #weapons_list do
		if GetHashKey(weapons_list[i]) == GetSelectedPedWeapon(PlayerPedId()) then
			return true
		end
	end
	return false
end

CreateThread(function()
	local lastUpdate = 0
    while true do
		Player = PlayerPedId()
		ped = PlayerPedId()

		if GetGameTimer() > lastUpdate then
			lastUpdate = GetGameTimer() + 15 * 1000
			playerHolsterAnim = GetResourceKvpString("HolsterAnim")
		end

        if currWeapon ~= GetSelectedPedWeapon(PlayerPedId()) then
            currWeapon = GetSelectedPedWeapon(PlayerPedId())

            holstered = true
            blocked = false
        end

		if playerHolsterAnim == nil then playerHolsterAnim = "SideHolsterAnimation" end

        if playerHolsterAnim == "SideHolsterAnimation" then
            loadAnimDict("rcmjosh4")
            loadAnimDict("reaction@intimidation@cop@unarmed")
            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            blocked   = true
                            SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
                            TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                            SetEntityAnimSpeed(ped, "reaction@intimidation@cop@unarmed", "intro", 2.0)

                            Citizen.Wait(50)
                            SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
                            TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                            SetEntityAnimSpeed(ped, "rcmjosh4", "josh_leadout_cop2", 2.0)
                            Citizen.Wait(200)
                            ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(50)
                    else
                        if not holstered then
                                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                                    Citizen.Wait(500)
                                TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                                    Citizen.Wait(60)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif playerHolsterAnim == "BackHolsterAnimation" then
            loadAnimDict("reaction@intimidation@1h")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                SetEntityAnimSpeed(ped, "reaction@intimidation@1h", "intro", 2.0)
                                    Citizen.Wait(300)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(2000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        end
        Citizen.Wait(40)
    end
end)

CreateThread(function()
    while true do
        if playerHolsterAnim == "FrontHolsterAnimation" then
            loadAnimDict("combat@combat_reactions@pistol_1h_gang")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                            blocked   = true
                            TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                            SetEntityAnimSpeed(ped, "combat@combat_reactions@pistol_1h_gang", "0", 2.0)
                            Citizen.Wait(300)
                            ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(1000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif playerHolsterAnim == "AgressiveFrontHolsterAnimation" then
            loadAnimDict("combat@combat_reactions@pistol_1h_hillbilly")
            loadAnimDict("combat@combat_reactions@pistol_1h_gang")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_hillbilly", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                SetEntityAnimSpeed(ped, "combat@combat_reactions@pistol_1h_hillbilly", "0", 2.0)
                                    Citizen.Wait(300)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(1000)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                    Citizen.Wait(50)
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        elseif playerHolsterAnim == "SideLegHolsterAnimation" then
            loadAnimDict("reaction@male_stand@big_variations@d")

            if not IsPedInAnyVehicle(ped, false) then
                if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
                    if CheckWeapon(ped) then
                        if holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                            blocked   = true
                                TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
                                SetEntityAnimSpeed(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", 2.0)
                                    Citizen.Wait(250)
                                ClearPedTasks(ped)
                            holstered = false
                        else
                            blocked = false
                        end
                        Citizen.Wait(40)
                    else
                        if not holstered then
                            pos = GetEntityCoords(ped, true)
		                    rot = GetEntityHeading(ped)
                                TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
                                    Citizen.Wait(500)
                                ClearPedTasks(ped)
                            holstered = true
                        end
                        Citizen.Wait(40)
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
                Citizen.Wait(50)
            else
                holstered = true
            end
        end
        Citizen.Wait(250)
    end
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)

        Citizen.Wait(1)
    end
end
