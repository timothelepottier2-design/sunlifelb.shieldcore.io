local events = {
	'HCheat:TempDisableDetection',
 	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'lester:vendita',
 	'mellotrainer:adminTempBan',
 	'esx_truckerjob:pay',
 	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
 	'AdminMenu:giveDirtyMoney',
 	'esx-qalle-jail:jailPlayer',
 	'kickAllPlayer',
 	'esx_gopostaljob:pay',
 	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
 	'lscustoms:payGarage',
 	'vrp_slotmachine:server:2',
	'dmv:success',
 	'esx_drugs:startHarvestCoke',
 	'esx_drugs:startHarvestMeth',
 	'esx_drugs:startHarvestWeed',
 	'esx_drugs:startHarvestOpium',
 	'ReviveAll',
 	'es_admin:all',
 	'adminmenu:allowall',
 	'es_admin:teleportUser',
 	'es_admin:quick',
 	'esx_vehicleshop:setVehicleOwned',
 	'esx_jobs:caution',
 	'KorioZ-PersonalMenu:Weapon_addAmmoToPedS',
 	'KorioZ-PersonalMenu:Admin_BringS',
 	'KorioZ-PersonalMenu:Admin_giveCash',
 	'KorioZ-PersonalMenu:Admin_giveBank',
 	'KorioZ-PersonalMenu:Admin_giveDirtyMoney',
 	'KorioZ-PersonalMenu:Boss_promouvoirplayer',
 	'KorioZ-PersonalMenu:Boss_destituerplayer',
 	'KorioZ-PersonalMenu:Boss_recruterplayer',
 	'KorioZ-PersonalMenu:Boss_virerplayer',
	'redst0nia:checking',
	'bank:deposit"',
	'Banca:deposit',
	'esx_vehicleshop:setVehicleOwned',
	'esx_carthief:pay',
	'esx_pizza:pay',
	'esx_ranger:pay',
	'esx_garbagejob:pay',
	'esx_truckerjob:pay',
	'AdminMenu:giveBank',
	'AdminMenu:giveCash',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx:giveInventoryItem',
	'NB:recruterplayer',
	'esx_jailer:sendToJail',
	'esx_jail:sendToJail',
	'esx-qalle-jail:jailPlayer',
	'LegacyFuel:PayFuel',
	'esx_dmvschool:pay',
	'CheckHandcuff',
	'cuffServer',
	'cuffGranted',
	'police:cuffGranted',
	'esx_handcuffs:cuffing',
	'esx_policejob:handcuff',
	'bank:withdraw',
	'dmv:success',
	'esx_skin:responseSaveSkin',
	'esx_dmvschool:addLicense',
	'esx_society:openBossMenu',
	'esx_jobs:caution',
	'esx_tankerjob:pay',
	'esx_vehicletrunk:giveDirty',
	'AdminMenu:giveDirtyMoney',
	'esx_moneywash:deposit',
	'mission:completed',
	'truckerJob:success',
	'DiscordBot:playerDied',
	'esx_ambulancejob:revive',
	'hentailover:xdlol',
	'antilynx8:anticheat',
	'antilynxr6:detection',
	'esx:getSharedObject',
	'esx_society:getOnlinePlayers',
	'antilynx8r4a:anticheat',
	'antilynxr4:detect',
	'js:jailuser',
	'ynx8:anticheat',
	'lynx8:anticheat',
	'adminmenu:allowall',
	'adminmenu:setsalary',
	'ljail:jailplayer',
	'h:xd',
	'adminmenu:setsalary',
	'bank:transfer',
	'paycheck:bonus',
	'paycheck:salary',
	'HCheat:TempDisableDetection',
	'esx-qalle-hunting:reward',
	'esx-qalle-hunting:sell',
	'esx_mecanojob:onNPCJobCompleted',
	'BsCuff:Cuff696999',
	'veh_SR:CheckMoneyForVeh',
	'esx_carthief:alertcops',
	'esx_society:putVehicleInGarage',
	'RS_MISSION:GetPay',
	'RS_MISSION:GetPayBlack',
	'lester:vendita',
	'barbershop:pay',
}

local Animals = {
    [GetHashKey("a_c_rat")] = true,
}

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent("AC:Sync")
end)

Citizen.CreateThread(function()
	while ESX == nil do
		if GetResourceState('es_extended') == 'started' then
			local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
			if ok and obj then ESX = obj end
		end
		if ESX == nil then
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do Wait(100) end
	while true do
		Citizen.Wait(3000)
		local count = 0
		local peds = ESX.Game.GetPeds(ignoreList)
		for i=1, #peds, 1 do
			local model = GetEntityModel(peds[i])
			if model == -1920001264 then
				count = count + 1
				SetEntityAsNoLongerNeeded(peds[i])
				DeleteEntity(peds[i])
			end
		end
	end
end)

for i=1, #events, 1 do
	AddEventHandler(events[i], function()

		TriggerServerEvent('AC:UltraSync', events[i])
	end)
end

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
	[tostring(GetHashKey('WEAPON_MK18B'))] = 'MK18B',
	[tostring(GetHashKey('WEAPON_MILITARYRIFLE'))] = 'Fusil Militaire',
	[tostring(GetHashKey('WEAPON_HK416B'))] = 'HK416',
	[tostring(GetHashKey('WEAPON_G19'))] = 'Glock 19',
	[tostring(GetHashKey('WEAPON_MP5'))] = 'MP5',
	[tostring(GetHashKey('WEAPON_MP7CMG'))] = 'MP7',
	[tostring(GetHashKey('WEAPON_DILDOCMG'))] = 'Dildo',
	[tostring(GetHashKey('WEAPON_KATANA'))] = 'Katana',
	[tostring(GetHashKey('WEAPON_GUITARCMG'))] = 'Guitare',
	[tostring(GetHashKey('WEAPON_FIREAXECMG'))] = 'Hache',
	[tostring(GetHashKey('WEAPON_BREAD'))] = 'Baguette',
	[tostring(GetHashKey('WEAPON_SPECTREAQ'))] = 'Spectre',
	[tostring(GetHashKey('WEAPON_AQAK'))] = 'Vandal',
	[tostring(GetHashKey('WEAPON_DESERTNIKE'))] = 'Desert Eagle (N Edition)',
	[tostring(GetHashKey('WEAPON_REDL'))] = 'REDL',
	[tostring(GetHashKey('WEAPON_M4_STORMBORN'))] = 'M4 Stormborn',
	[tostring(GetHashKey('WEAPON_REDLINE_FANG'))] = 'Redline Fang',
	[tostring(GetHashKey('WEAPON_HKUSP'))] = 'HKUSP',
	[tostring(GetHashKey('WEAPON_SLR15'))] = 'SLR15',
	[tostring(GetHashKey('WEAPON_XM7_6_8'))] = 'XM7',
	[tostring(GetHashKey('WEAPON_TAR21'))] = 'SAR',
	[tostring(GetHashKey('WEAPON_M133V3'))] = 'M133',
	[tostring(GetHashKey('WEAPON_P20_ASIIMOV'))] = 'P20 Orange',
	[tostring(GetHashKey('WEAPON_M4ASIIMOV'))] = 'M4 Orange',
	[tostring(GetHashKey('WEAPON_M4A1_SPIKESHINE'))] = 'M4A1 SpikeShine',
	[tostring(GetHashKey('WEAPON_MINISMG_SPIKESHINE'))] = 'SMG SpikeShine',
	[tostring(GetHashKey('WEAPON_FAMAS'))] = 'Famas',
	[tostring(GetHashKey('WEAPON_FAMASC'))] = 'Famas Custom',
	[tostring(GetHashKey('WEAPON_PUMPKIN'))] = 'AK Citrouille',
	[tostring(GetHashKey('WEAPON_357'))] = '357',
	[tostring(GetHashKey('WEAPON_CARROTKNIFE'))] = 'Carotte',
	[tostring(GetHashKey('WEAPON_REVOLVERULTRA'))] = 'Revolver Ultra',
	[tostring(GetHashKey('WEAPON_SIG550'))] = 'Sig-550',
	[tostring(GetHashKey('WEAPON_M4BEAST'))] = 'M4 Beast',
	[tostring(GetHashKey('WEAPON_TEC9MF'))] = 'Tec 9 Custom',
	[tostring(GetHashKey('WEAPON_SCAR17'))] = 'Scar 17',
	[tostring(GetHashKey('WEAPON_SLIMAQ'))] = 'Slimaq',
	[tostring(GetHashKey('WEAPON_BATAQ'))] = 'Bataq',
	[tostring(GetHashKey('WEAPON_DEMHAMMER'))] = 'Marteau halloween',
	[tostring(GetHashKey('WEAPON_CHAINSAW'))] = 'Tronconneuse halloween',
	[tostring(GetHashKey('WEAPON_SLICE'))] = 'Fourche halloween',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Fusil Double Action',
	[tostring(GetHashKey('WEAPON_CANDYKNIFE'))] = 'Couteau Noel',
	[tostring(GetHashKey('WEAPON_DESERTSANTA'))] = 'Desert Eagle Noel',
	[tostring(GetHashKey('WEAPON_HATMAS'))] = 'Fusil Assault Noel',
	[tostring(GetHashKey('WEAPON_SANTAS'))] = 'Santa Noel',
	[tostring(GetHashKey('WEAPON_XMASRIFLE'))] = 'Fusil Assault Hiver',
	[tostring(GetHashKey('WEAPON_PISTOLXMAS'))] = 'Pistolet Hiver',
	[tostring(GetHashKey('WEAPON_SNOWXMAS'))] = 'Hache Hiver',
	[tostring(GetHashKey('WEAPON_M4LOVER'))] = 'M4 Lover',
	[tostring(GetHashKey('WEAPON_PBLACKVAL'))] = 'Black Val',
	[tostring(GetHashKey('WEAPON_WOLFKNIFE'))] = 'Couteau Loup',
	[tostring(GetHashKey('WEAPON_WOLFVERN'))] = 'Pistolet Loup',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLELS'))] = 'AK Rustique',
	[tostring(GetHashKey('WEAPON_AKCARROT'))] = 'AK Carotte',
	[tostring(GetHashKey('WEAPON_CARROTSMG'))] = 'SMG Carotte',
	[tostring(GetHashKey('WEAPON_CARROTSWORD'))] = 'Épée Carotte',
	[tostring(GetHashKey('WEAPON_CARROTTEC'))] = 'Tec Carotte',
	[tostring(GetHashKey('WEAPON_REVOCARROT'))] = 'Revolver Carotte',
	[tostring(GetHashKey('WEAPON_PATRIOTKNIFE'))] = 'Couteau Patriote',
	[tostring(GetHashKey('WEAPON_PISTOLPATRIOT'))] = 'Pistolet Patriote',
	[tostring(GetHashKey('WEAPON_PATRIOT'))] = 'Fusil Patriote',
	[tostring(GetHashKey('WEAPON_PF940'))] = 'PF940',
	[tostring(GetHashKey('WEAPON_FRYINPAN'))] = 'Poêle',
	[tostring(GetHashKey('WEAPON_HFAP'))] = 'HFAP',
	[tostring(GetHashKey('WEAPON_UMP45'))] = 'UMP45 Custom',
	[tostring(GetHashKey('WEAPON_GK47'))] = 'GK-47',
	[tostring(GetHashKey('WEAPON_A15RC'))] = 'A15RC',
	[tostring(GetHashKey('WEAPON_AK47_NIGHTWISH'))] = 'AK-47 NightWish',
	[tostring(GetHashKey('WEAPON_BAS_P_RED'))] = 'P-RED',
	[tostring(GetHashKey('WEAPON_CZ75'))] = 'CZ75',
	[tostring(GetHashKey('WEAPON_SFTANA'))] = 'SFTANA',
	[tostring(GetHashKey('WEAPON_M4_T_NEON'))] = 'M4 Neon',
	[tostring(GetHashKey('WEAPON_SIGSPEARXM7'))] = 'Sig Spear XM7',
	[tostring(GetHashKey('WEAPON_SIGMXCVIRTUS'))] = 'Sig MCX Virtus',
	[tostring(GetHashKey('WEAPON_BRICK'))] = 'Brick',
	[tostring(GetHashKey('WEAPON_BRICK2'))] = 'Brick 2',
	[tostring(GetHashKey('WEAPON_AK_SHORTSTOCK_CHR'))] = 'Shortstock',
	[tostring(GetHashKey('WEAPON_COMBAT_PISTOL_CHROMIUM'))] = 'Pistolet Chromium',
	[tostring(GetHashKey('WEAPON_GROZA_CHROMIUM'))] = 'Groza Chromium',
	[tostring(GetHashKey('WEAPON_MP7_CHROMIUM'))] = 'M7 Chromium',
	[tostring(GetHashKey('WEAPON_VIOLET_VENGANGE_CHR'))] = 'Vengeance Violette',
	[tostring(GetHashKey('WEAPON_BULLPUP_SMG'))] = 'Bullpup SMG',
	[tostring(GetHashKey('WEAPON_AK_47_RED_CHROMIUM'))] = 'Fusil Assaut Chromium Rouge',
	[tostring(GetHashKey('WEAPON_SCARSC'))] = 'Scapu Assaut',
	[tostring(GetHashKey('WEAPON_MACHINE_PISTOL_RED_CHR'))] = 'Pistolet Mitrailleur Chromium Rouge',
	[tostring(GetHashKey('WEAPON_COMBATHP'))] = 'HP de Combat',
	[tostring(GetHashKey('WEAPON_NVRIFLE_PURPLE'))] = 'NV Assaut Violet',
	[tostring(GetHashKey('WEAPON_MP9'))] = 'MP9',
	[tostring(GetHashKey('WEAPON_EXTENDEDSMG'))] = 'SMG Halloween',
	[tostring(GetHashKey('WEAPON_GOLDSMG'))] = 'SMG Gold',
	[tostring(GetHashKey('WEAPON_VECTOR'))] = 'Vortex',
	[tostring(GetHashKey('WEAPON_M415'))] = 'M415',
	[tostring(GetHashKey('WEAPON_AXE'))] = 'Hache',
	[tostring(GetHashKey('WEAPON_BARBEDBAT'))] = 'Bat cloutée',
	[tostring(GetHashKey('WEAPON_BATON'))] = 'Bâton',
	[tostring(GetHashKey('WEAPON_BLACKKATANA'))] = 'Katana noir',
	[tostring(GetHashKey('WEAPON_BLUEZK'))] = 'ZK bleu',
	[tostring(GetHashKey('WEAPON_BROWNMACHETE'))] = 'Machette marron',
	[tostring(GetHashKey('WEAPON_BUTCHER'))] = 'Couteau de boucher',
	[tostring(GetHashKey('WEAPON_CHAIR'))] = 'Chaise',
	[tostring(GetHashKey('WEAPON_CRUTCH'))] = 'Béquille',
	[tostring(GetHashKey('WEAPON_DILDO'))] = 'Dildo',
	[tostring(GetHashKey('WEAPON_EGUITAR'))] = 'Guitare électrique',
	[tostring(GetHashKey('WEAPON_GUITAR'))] = 'Guitare',
	[tostring(GetHashKey('WEAPON_HUNTERKNIFE'))] = 'Couteau de chasse',
	[tostring(GetHashKey('WEAPON_ICECLIMBER'))] = 'Piolet',
	[tostring(GetHashKey('WEAPON_KITCHENKNIFE'))] = 'Couteau de cuisine',
	[tostring(GetHashKey('WEAPON_KUKRI'))] = 'Kukri',
	[tostring(GetHashKey('WEAPON_LONGMACHETE'))] = 'Longue machette',
	[tostring(GetHashKey('WEAPON_MACE'))] = 'Masse',
	[tostring(GetHashKey('WEAPON_PICKAXE'))] = 'Pioche',
	[tostring(GetHashKey('WEAPON_PINKZK'))] = 'ZK rose',
	[tostring(GetHashKey('WEAPON_PITCHFORK'))] = 'Fourche',
	[tostring(GetHashKey('WEAPON_REDZK'))] = 'ZK rouge',
	[tostring(GetHashKey('WEAPON_SCIFISWORD'))] = 'Épée sci-fi',
	[tostring(GetHashKey('WEAPON_SCIMITAR'))] = 'Cimeterre',
	[tostring(GetHashKey('WEAPON_SCREWDRIVER'))] = 'Tournevis',
	[tostring(GetHashKey('WEAPON_SCYTHE'))] = 'Faux',
	[tostring(GetHashKey('WEAPON_SHOVEL'))] = 'Pelle',
	[tostring(GetHashKey('WEAPON_SLEDGEHAMMER'))] = 'Marteau de démolition',
	[tostring(GetHashKey('WEAPON_SPIKEDKNUCKLES'))] = 'Poings américains cloutés',
	[tostring(GetHashKey('WEAPON_SPIKEYBAT'))] = 'Bat à pointes',
	[tostring(GetHashKey('WEAPON_STOPSIGN'))] = 'Panneau stop',
	[tostring(GetHashKey('WEAPON_TACAXE'))] = 'Hache tactique',
	[tostring(GetHashKey('WEAPON_TACCLEAVER'))] = 'Couperet tactique',
	[tostring(GetHashKey('WEAPON_TACTICALHATCHET'))] = 'Hachette tactique',
	[tostring(GetHashKey('WEAPON_THORSHAMMER'))] = 'Marteau de Thor',
	[tostring(GetHashKey('WEAPON_TWOHBATTLEAXE'))] = 'Hache de bataille à deux mains',
	[tostring(GetHashKey('WEAPON_WCLAWS'))] = 'Griffes de combat',
	[tostring(GetHashKey('WEAPON_ZK'))] = 'ZK',
	[tostring(GetHashKey('WEAPON_KS1'))] = 'KS1',
	[tostring(GetHashKey('WEAPON_KNIFEVALEN'))] = 'Couteau St-Valentin',
	[tostring(GetHashKey('WEAPON_BATCANDY'))] = 'Batte St-Valentin',
	[tostring(GetHashKey('WEAPON_PKISS'))] = 'Pistolet St-Valentin',
	[tostring(GetHashKey('WEAPON_CZ_SCORPION_EVO_CHR'))] = 'Scorpion Evo',
	[tostring(GetHashKey('WEAPON_SS2_2'))] = 'SS2',
	[tostring(GetHashKey('WEAPON_VERESK'))] = 'Veresk',
	[tostring(GetHashKey('WEAPON_SPS_21_SG_CHR'))] = 'SPS 21',
	[tostring(GetHashKey('WEAPON_TR_88_CHR'))] = 'T88',
	[tostring(GetHashKey('WEAPON_M270D_CHR'))] = '270D',
	[tostring(GetHashKey('WEAPON_DMRSNIPER'))] = 'DMRSNiper',
	[tostring(GetHashKey('WEAPON_GAU_5A_FEM'))] = 'Gau5A',
	[tostring(GetHashKey('WEAPON_HOWA_T20_CHR'))] = 'HowaT20',
	[tostring(GetHashKey('WEAPON_COMBAT_SG_CHR'))] = 'CombatSG',
	[tostring(GetHashKey('WEAPON_SPX_7_CHR'))] = 'SPX7',
	[tostring(GetHashKey('WEAPON_SR_3M_CHR'))] = 'SR-3M',
	[tostring(GetHashKey('WEAPON_HK2002M_CHR'))] = 'HK200',
	[tostring(GetHashKey('WEAPON_SYS_PISTOL_CHR'))] = 'Pistolet SYS',
	[tostring(GetHashKey('WEAPON_SHOTGUN_CHROMIUM'))] = 'Shotgun Chromium',
	[tostring(GetHashKey('WEAPON_HX_15_CHR'))] = 'HX-15',
	[tostring(GetHashKey('WEAPON_BONECLUB'))] = 'Massue en os',
	[tostring(GetHashKey('WEAPON_BUCKET'))] = 'Seau',
	[tostring(GetHashKey('WEAPON_COFFIN'))] = 'Cercueil',
	[tostring(GetHashKey('WEAPON_DEATHNOTE'))] = 'Death Note',
	[tostring(GetHashKey('WEAPON_HELLFIRESWORD'))] = 'Épée infernale',
	[tostring(GetHashKey('WEAPON_INFERNO'))] = 'Inferno',
	[tostring(GetHashKey('WEAPON_PUMPKIN'))] = 'Citrouille',
	[tostring(GetHashKey('WEAPON_PUMPKINBAT'))] = 'Batte citrouille',
	[tostring(GetHashKey('WEAPON_ARM'))] = 'Bras de squelette',
	[tostring(GetHashKey('WEAPON_LEG'))] = 'Jambe de squelette',
	[tostring(GetHashKey('WEAPON_STAKE'))] = 'Pieu',
	[tostring(GetHashKey('WEAPON_TRIPLEBLADEDSCYTHE'))] = 'Faux triple lame',
	[tostring(GetHashKey('WEAPON_VOODOO'))] = 'Poupée vaudou',
	[tostring(GetHashKey('WEAPON_WITCHBROOM'))] = 'Balai de sorcière',
	[tostring(GetHashKey('WEAPON_SOULSCYTHE'))] = 'Faux des âmes',
	[tostring(GetHashKey('WEAPON_GRAVESTONE'))] = 'Pierre tombale',
	[tostring(GetHashKey('WEAPON_KITTBOWYAXE'))] = 'Hache démoniaque',
	[tostring(GetHashKey('WEAPON_DIRTYSYRINGE'))] = 'Seringue sale',
	[tostring(GetHashKey('WEAPON_BIGSPOON'))] = 'Grande cuillère',
	[tostring(GetHashKey('WEAPON_JABSAW'))] = 'Scie médicale',
	[tostring(GetHashKey('WEAPON_TELESCOPE'))] = 'Télescope',
	[tostring(GetHashKey('WEAPON_MEATSKEWER'))] = 'Brochette de viande',
	[tostring(GetHashKey('WEAPON_SWORDFISH'))] = 'Poisson-épée',
	[tostring(GetHashKey('WEAPON_LOBSTER'))] = 'Homard',
	[tostring(GetHashKey('WEAPON_PLIERS'))] = 'Pince',
	[tostring(GetHashKey('WEAPON_HANDDRILL'))] = 'Perceuse manuelle',
	[tostring(GetHashKey('WEAPON_TWISTEDSPEAR'))] = 'Lance tordue',
	[tostring(GetHashKey('WEAPON_SNAKEKNIFE'))] = 'Couteau serpent',
	[tostring(GetHashKey('WEAPON_CRUTCHKNIFE'))] = 'Béquille affûtée',
	[tostring(GetHashKey('WEAPON_SHARPARROW'))] = 'Flèche tranchante',
	[tostring(GetHashKey('WEAPON_95SIGN'))] = 'Panneau 95',
	[tostring(GetHashKey('WEAPON_ASSASINGUN'))] = 'Arme d’assassin',
	[tostring(GetHashKey('WEAPON_BAGUETTE'))] = 'Baguette',
	[tostring(GetHashKey('WEAPON_BANANA'))] = 'Banane',
	[tostring(GetHashKey('WEAPON_BIKE'))] = 'Vélo',
	[tostring(GetHashKey('WEAPON_BONE'))] = 'Os',
	[tostring(GetHashKey('WEAPON_BONESWORD'))] = 'Épée en os',
	[tostring(GetHashKey('WEAPON_BUTTPLUG'))] = 'Butt plug',
	[tostring(GetHashKey('WEAPON_CACTUS'))] = 'Cactus',
	[tostring(GetHashKey('WEAPON_CAMSHAFT'))] = 'Arbre à cames',
	[tostring(GetHashKey('WEAPON_CARJACK'))] = 'Cric de voiture',
	[tostring(GetHashKey('WEAPON_CONE'))] = 'Cône de signalisation',
	[tostring(GetHashKey('WEAPON_CROSSSPANNER'))] = 'Clé en croix',
	[tostring(GetHashKey('WEAPON_CUCUMBER'))] = 'Concombre',
	[tostring(GetHashKey('WEAPON_DISABLEDSIGN'))] = 'Panneau handicapé',
	[tostring(GetHashKey('WEAPON_ELDERSWAND'))] = 'Baguette magique',
	[tostring(GetHashKey('WEAPON_MFIREEXTINGUISHER'))] = 'Extincteur modifié',
	[tostring(GetHashKey('WEAPON_FISHINGROD'))] = 'Canne à pêche',
	[tostring(GetHashKey('WEAPON_GASCYLINDER'))] = 'Bouteille de gaz',
	[tostring(GetHashKey('WEAPON_HOCKEYFSTICK'))] = 'Crosse de hockey',
	[tostring(GetHashKey('WEAPON_HORN'))] = 'Corne',
	[tostring(GetHashKey('WEAPON_JDBOTTLE'))] = 'Bouteille de whisky',
	[tostring(GetHashKey('WEAPON_KEYBOARD'))] = 'Clavier',
	[tostring(GetHashKey('WEAPON_KITCHENFORK'))] = 'Fourchette de cuisine',
	[tostring(GetHashKey('WEAPON_LACROSSESTICK'))] = 'Bâton de lacrosse',
	[tostring(GetHashKey('WEAPON_LADDER'))] = 'Échelle',
	[tostring(GetHashKey('WEAPON_MAILBOX'))] = 'Boîte aux lettres',
	[tostring(GetHashKey('WEAPON_MIC'))] = 'Micro',
	[tostring(GetHashKey('WEAPON_NOPARKINGSIGN'))] = 'Panneau stationnement interdit',
	[tostring(GetHashKey('WEAPON_PEN'))] = 'Stylo',
	[tostring(GetHashKey('WEAPON_PENCIL'))] = 'Crayon',
	[tostring(GetHashKey('WEAPON_PROSLEG'))] = 'Jambe prothétique',
	[tostring(GetHashKey('WEAPON_ROLLINGPIN'))] = 'Rouleau à pâtisserie',
	[tostring(GetHashKey('WEAPON_RONABOTTLE'))] = 'Bouteille de bière',
	[tostring(GetHashKey('WEAPON_ROUTE66SIGN'))] = 'Panneau Route 66',
	[tostring(GetHashKey('WEAPON_SCOOTER'))] = 'Trottinette',
	[tostring(GetHashKey('WEAPON_SHOCKABSORBER'))] = 'Amortisseur',
	[tostring(GetHashKey('WEAPON_SKULLBAT'))] = 'Batte crâne',
	[tostring(GetHashKey('WEAPON_SPARTANSWORD'))] = 'Épée spartiate',
	[tostring(GetHashKey('WEAPON_SPATULA'))] = 'Spatule',
	[tostring(GetHashKey('WEAPON_STEPLADDER'))] = 'Escabeau',
	[tostring(GetHashKey('WEAPON_STREETLIGHT'))] = 'Lampadaire',
	[tostring(GetHashKey('WEAPON_TOASTER'))] = 'Grille-pain',
	[tostring(GetHashKey('WEAPON_VACUUM'))] = 'Aspirateur',
	[tostring(GetHashKey('WEAPON_WRONGWAYSIGN'))] = 'Panneau sens interdit',
	[tostring(GetHashKey('WEAPON_YARI'))] = 'Lance japonaise',
	[tostring(GetHashKey('WEAPON_BLACKBELT'))] = 'Ceinture noire',
	[tostring(GetHashKey('WEAPON_BENTFORK'))] = 'Fourchette tordue',
	[tostring(GetHashKey('WEAPON_BLACKBACKPACK'))] = 'Sac à dos noir',
	[tostring(GetHashKey('WEAPON_BRCHICKEN'))] = 'Poulet rôti',
	[tostring(GetHashKey('WEAPON_DOORBARS'))] = 'Barre de porte',
	[tostring(GetHashKey('WEAPON_EARBUDBLADE'))] = 'Couteau écouteur',
	[tostring(GetHashKey('WEAPON_HONEYDIPPER'))] = 'Cuillère à miel',
	[tostring(GetHashKey('WEAPON_KETTLE'))] = 'Bouilloire',
	[tostring(GetHashKey('WEAPON_LEATHERBRIEFCASE'))] = 'Mallette en cuir',
	[tostring(GetHashKey('WEAPON_MAKESHIFTKNIFE'))] = 'Couteau de fortune',
	[tostring(GetHashKey('WEAPON_MEASURINGCUP'))] = 'Verre doseur',
	[tostring(GetHashKey('WEAPON_MODDEDNIGHTSTICK'))] = 'Matraque modifiée',
	[tostring(GetHashKey('WEAPON_TRAYRACK'))] = 'Porte-plateaux',
	[tostring(GetHashKey('WEAPON_POKER'))] = 'Tisonnier',
	[tostring(GetHashKey('WEAPON_PRISONKEY'))] = 'Clé de prison',
	[tostring(GetHashKey('WEAPON_PRISTOI'))] = 'Toilette de prison',
	[tostring(GetHashKey('WEAPON_REDBACKPACK'))] = 'Sac à dos rouge',
	[tostring(GetHashKey('WEAPON_RULER'))] = 'Règle',
	[tostring(GetHashKey('WEAPON_SHIV'))] = 'Lame artisanale',
	[tostring(GetHashKey('WEAPON_SOLIDOOR'))] = 'Porte solide',
	[tostring(GetHashKey('WEAPON_TEAPOT'))] = 'Théière',
	[tostring(GetHashKey('WEAPON_VIOBACKPACK'))] = 'Sac à dos violet',
	[tostring(GetHashKey('WEAPON_PEELER'))] = 'Éplucheur',
	[tostring(GetHashKey('WEAPON_G36'))] = 'G36',
	[tostring(GetHashKey('WEAPON_G3_2'))] = 'G-3',
	[tostring(GetHashKey('WEAPON_L85_CHR'))] = 'L85',
	[tostring(GetHashKey('WEAPON_VX_SCORPION_CHR'))] = 'VX Scorpion',
	[tostring(GetHashKey('WEAPON_R90_CHR'))] = 'R90',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLECUPID'))] = 'AK Cupidon',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2_DARKMATTER'))] = 'AK MK2 Darkmatter',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2_DARKMATTER'))] = 'Carabine MK2 Darkmatter',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2_DARKMATTER'))] = 'Carabine Spéciale MK2 Darkmatter',
	[tostring(GetHashKey('WEAPON_MICROSMG_DARKMATTER'))] = 'SMG Darkmatter',
	[tostring(GetHashKey('WEAPON_REVOLVER_MK2_DARKMATTER'))] = 'Revolver MK2 Darkmatter',
	[tostring(GetHashKey('WEAPON_KNUCKLE_DARKMATTER'))] = 'Poing américain Darkmatter',
	[tostring(GetHashKey('WEAPON_M249'))] = 'M249',
	[tostring(GetHashKey('WEAPON_MK14'))] = 'MK14',
	[tostring(GetHashKey('WEAPON_RRT14_GANG'))] = 'RRT14 Gang',
	[tostring(GetHashKey('WEAPON_P320_GANG'))] = 'P320 Gang',
}

weaponsMelee = {
    "weapon_dagger",
	"WEAPON_KNIFEVALEN",
    "weapon_bat",
    "weapon_bottle",
    "weapon_crowbar",
    "weapon_unarmed",
    "weapon_flashlight",
    "weapon_golfclub",
    "weapon_hammer",
    "weapon_hatchet",
    "weapon_knuckle",
    "weapon_knife",
    "weapon_machete",
    "weapon_switchblade",
    "weapon_nightstick",
    "weapon_wrench",
    "weapon_battleaxe",
    "weapon_poolcue",
    "weapon_stone_hatchet",
    "weapon_katana",
    "weapon_machette_ballas",
    "weapon_machette_vagos",
    "weapon_machette_families",
    "WEAPON_PEPPERSPRAY",
    "WEAPON_ANTIDOTE",
	"WEAPON_BATAQ",
	"WEAPON_CHAINSAW",
	"WEAPON_SLICE",
	"WEAPON_DEMHAMMER",
	"WEAPON_KARAMBIT",
	"WEAPON_CANDYCANE",
	"WEAPON_CANDYKNIFE",
	"WEAPON_CARROTSWORD",
	"WEAPON_PATRIOTKNIFE",
	"WEAPON_FRYINPAN",
    "WEAPON_AXE",
    "WEAPON_BARBEDBAT",
    "WEAPON_BATON",
    "WEAPON_BLACKKATANA",
    "WEAPON_BLUEZK",
    "WEAPON_BROWNMACHETE",
    "WEAPON_BUTCHER",
    "WEAPON_CHAIR",
    "WEAPON_CRUTCH",
    "WEAPON_DILDO",
    "WEAPON_EGUITAR",
    "WEAPON_GUITAR",
    "WEAPON_HUNTERKNIFE",
    "WEAPON_ICECLIMBER",
    "WEAPON_KITCHENKNIFE",
    "WEAPON_KUKRI",
    "WEAPON_LONGMACHETE",
    "WEAPON_MACE",
    "WEAPON_PICKAXE",
    "WEAPON_PINKZK",
    "WEAPON_PITCHFORK",
    "WEAPON_REDZK",
    "WEAPON_SCIFISWORD",
    "WEAPON_SCIMITAR",
    "WEAPON_SCREWDRIVER",
    "WEAPON_SCYTHE",
    "WEAPON_SHOVEL",
    "WEAPON_SLEDGEHAMMER",
    "WEAPON_SPIKEDKNUCKLES",
    "WEAPON_SPIKEYBAT",
    "WEAPON_STOPSIGN",
    "WEAPON_TACAXE",
    "WEAPON_TACCLEAVER",
    "WEAPON_TACTICALHATCHET",
    "WEAPON_THORSHAMMER",
    "WEAPON_TWOHBATTLEAXE",
    "WEAPON_WCLAWS",
    "WEAPON_ZK",
	"WEAPON_BATCANDY",
	"WEAPON_KNIFEVALEN",
	"WEAPON_DILDOCMG",
	"WEAPON_BONECLUB",
	"WEAPON_BUCKET",
	"WEAPON_COFFIN",
	"WEAPON_DEATHNOTE",
	"WEAPON_HELLFIRESWORD",
	"WEAPON_INFERNO",
	"WEAPON_PUMPKIN",
	"WEAPON_PUMPKINBAT",
	"WEAPON_ARM",
	"WEAPON_LEG",
	"WEAPON_STAKE",
	"WEAPON_TRIPLEBLADEDSCYTHE",
	"WEAPON_VOODOO",
	"WEAPON_WITCHBROOM",
	"WEAPON_SOULSCYTHE",
	"WEAPON_GRAVESTONE",
	"WEAPON_KITTBOWYAXE",
	"WEAPON_CUCUMBER",
}

AddEventHandler("esx:onPlayerDeath", function (data)
	local DeathReason, Killer, DeathCauseHash, Weapon
	DeathCauseHash = data.deathCause
	local PedKiller = data.killedByPlayer
	PedKiller2 = GetPedSourceOfDeath(PlayerPedId())

	Weapon = WeaponNames[tostring(DeathCauseHash)]
	if PedKiller and IsEntityAPed(PedKiller2) and IsPedAPlayer(PedKiller2) then
		Killer = NetworkGetPlayerIndexFromPed(PedKiller2)
	elseif PedKiller and IsEntityAVehicle(PedKiller2) and IsEntityAPed(GetPedInVehicleSeat(PedKiller2, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller2, -1)) then
		Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller2, -1))
	end

	if (Killer == PlayerId()) then
		DeathReason = 'A commis un suicide'
	elseif (Killer == nil) then
		DeathReason = 'A commis un suicide ou écraser par un pnj'
	else

		local list = ESX.GetWeaponList()
		for key, value in pairs(list) do
			if GetHashKey(value.nameItem) == DeathCauseHash then
				DeathReason = "mort par une arme"
			end
		end
		if IsMelee(DeathCauseHash) then
			DeathReason = 'assassiné'
		elseif IsTorch(DeathCauseHash) then
			DeathReason = 'brûlé'
		elseif IsKnife(DeathCauseHash) then
			DeathReason = 'poignardé'
		elseif IsPistol(DeathCauseHash) then
			DeathReason = 'abattu par pistolet'
		elseif IsSub(DeathCauseHash) then
			DeathReason = 'mitraillé'
		elseif IsRifle(DeathCauseHash) then
			DeathReason = 'abattu par fusil'
		elseif IsLight(DeathCauseHash) then
			DeathReason = 'mitraillé par une mitrailleuse'
		elseif IsShotgun(DeathCauseHash) then
			DeathReason = 'pulvérisé'
		elseif IsSniper(DeathCauseHash) then
			DeathReason = 'tiré par un sniper'
		elseif IsHeavy(DeathCauseHash) then
			DeathReason = 'anéanti'
		elseif IsMinigun(DeathCauseHash) then
			DeathReason = 'haché'
		elseif IsBomb(DeathCauseHash) then
			DeathReason = 'bombardé'
		elseif IsVeh(DeathCauseHash) then
			DeathReason = 'écrasé par un véhicule'
		elseif IsVK(DeathCauseHash) then
			DeathReason = 'aplati'
		else
			DeathReason = 'tué par une arme ou quelque choses de similaire'
		end

	end
	local playerPed = PlayerPedId()
	local causeOfDeath = GetPedCauseOfDeath(playerPed)
	local killer = GetPedSourceOfDeath(playerPed)
	if IsEntityAVehicle(killer) then
		local vehicleModel = GetEntityModel(killer)
		local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
		local plate = GetVehicleNumberPlateText(killer)
		local maxPassengers = GetVehicleMaxNumberOfPassengers(killer)

		for seat = -1, maxPassengers - 1 do
			local passenger = GetPedInVehicleSeat(killer, seat)
			if passenger ~= 0 then
				local pedType = GetPedType(passenger)
				if pedType ~= 28 then
					local passengerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
					if seat == -1 then
						DeathReason = "Conducteur du véhicule ("..plate..") " .. seat .. ": Player ID " .. passengerServerId.." Name :"..GetPlayerName(GetPlayerFromServerId(passengerServerId))
						Killer = GetPlayerFromServerId(passengerServerId)
					end
				end
			end
		end
	end
	local faim, soif = exports["es_extended"]:whatisthisgoingon()

	if faim and soif and( tonumber(faim) <= 0 or tonumber(soif) <= 0 )then
		DeathReason = "mort de soif ou de faim (faim = "..faim.." soif = "..soif..")"
	end
	if (Killer == PlayerId()) or Killer == nil then
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 80.811371, -393.119751, 39.907251, true) >= 120 then
			TriggerServerEvent('catcher:addKill', DeathReason, Weapon, GetPlayerServerId(PlayerId()))
		end
	else
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 80.811371, -393.119751, 39.907251, true) >= 120 then
			TriggerServerEvent('catcher:addKill', DeathReason, Weapon, GetPlayerServerId(Killer))
		end
	end
	Killer = nil
	DeathReason = nil
	DeathCauseHash = nil
	Weapon = nil
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function ()
    while true do
        for a,q in pairs(GetActivePlayers()) do
            if Animals[GetEntityModel(GetPlayerPed(q))] then

            end
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        local isArmed = false

        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)

        local melee = (GetWeapontypeGroup(currentWeapon) == GetHashKey("GROUP_MELEE"))

        if not melee then
            for k,v in pairs(weaponsMelee) do
                if currentWeapon == GetHashKey(v) then
                    melee = true
                    break
                end
            end
        end

        if not melee and IsPedArmed(ped, 7) then
            isArmed = true
            SetPlayerLockon(PlayerId(), false)
        else
            SetPlayerLockon(PlayerId(), true)
        end

        if isArmed then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

local whitelistedRL = {
    [GetHashKey("WEAPON_SNSPISTOL")]     = true,
    [GetHashKey("WEAPON_PISTOL")]        = true,
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL50")]       = true,
    [GetHashKey("WEAPON_REVOLVER")]      = true,
    [GetHashKey("WEAPON_APPISTOL")]      = true,
    [GetHashKey("WEAPON_STUNGUN")]       = true,
    [GetHashKey("WEAPON_COMBATPISTOL")]  = true,
    [GetHashKey("WEAPON_HEAVYPISTOL")]   = true,
    [GetHashKey("WEAPON_G19")]         = true,
    [GetHashKey("WEAPON_DOUBLEACTION")]  = true,
    [GetHashKey("WEAPON_GADGETPISTOL")]  = true,
    [GetHashKey("WEAPON_CERAMICPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL50")]      = true,
    [GetHashKey("WEAPON_PISTOL_MK2")]    = true,
	[GetHashKey("WEAPON_MINISMG")]    = true,
	[GetHashKey("WEAPON_MACHINEPISTOL")]    = true,
	[GetHashKey("WEAPON_MICROSMG")]    = true,
	[GetHashKey("WEAPON_MACHINE_PISTOL_RED_CHR")]    = true,
	[GetHashKey("WEAPON_EXTENDEDSMG")]    = true,
	[GetHashKey("WEAPON_MP9")]    = true,
	[GetHashKey("WEAPON_AK_SHORTSTOCK_CHR")]    = true,
	[GetHashKey("WEAPON_PISTOLXM3")]    = true,
	[GetHashKey("WEAPON_TECPISTOL")]    = true,
	[GetHashKey("WEAPON_FLAREGUN")]    = true,
	[GetHashKey("WEAPON_357")]    = true,
	[GetHashKey("WEAPON_PISTOLXMAS")]    = true,
	[GetHashKey("WEAPON_PF940")]    = true,
	[GetHashKey("WEAPON_MP7_CHROMIUM")]    = true,
	[GetHashKey("WEAPON_VECTOR")]    = true,
	[GetHashKey("WEAPON_SB4S")]    = true,
	[GetHashKey("WEAPON_HKUSP")]    = true,
	[GetHashKey("WEAPON_WOLFKNIFE")]    = true,
}

Citizen.CreateThread(function()
    local lastDropsAt = 0
    while true do
        local isArmed = false
		local playerCoords = GetEntityCoords(PlayerPedId())
        local distanceToCenter = #(playerCoords - vector3(5367.2231445312, -1106.7100830078, 355.20947265625))

		-- Le scan complet du pool de peds (FindFirstPed) est couteux : on le
		-- limite a une fois par seconde au lieu de chaque frame (source de
		-- hitch / script deadloop quand le joueur est arme).
		local nowMs = GetGameTimer()
		if nowMs - lastDropsAt > 1000 then
			lastDropsAt = nowMs
			SetPedConfigFlag(PlayerPedId(), 149, true)
			SetPedConfigFlag(PlayerPedId(), 438, true)
			SetWeaponDrops()
		end

        if IsPedArmed(PlayerPedId(), 6) and distanceToCenter > 120.0 then
            isArmed = true

			DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)

            if IsControlPressed(0, 25) then
                local hash = GetSelectedPedWeapon(PlayerPedId())
                if not whitelistedRL[hash] then
                    if GetSelectedPedWeapon(PlayerPedId()) == hash then
                        DisableControlAction(0, 22)
                    end
                end
            end
        end

        if isArmed then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        SetPedCanBeDraggedOut(PlayerPedId(), false)
        SetEntityProofs(PlayerPedId(), false, true, true, true, false, false, false, true)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		if GetPedStealthMovement(PlayerPedId()) then
        	SetPedStealthMovement(PlayerPedId(), 0)
    	end
        Citizen.Wait(0)
    end
end)

CreateThread(function()
    while true do
        Wait(100)
        local selfPed = PlayerPedId()
        for k,v in pairs(GetGamePool('CPed')) do
            if v ~= selfPed then
                if GetIsTaskActive(v, 165) then
                    ClearPedTasksImmediately(v)
                    DeleteEntity(v)
                end
            end
        end
    end
end)

local BLOCKED = {
    [-276744698] = true,
    [4018222598] = true,
}

for _, m in ipairs({ "player_zero", "player_one", "player_two", "player_null" }) do
    BLOCKED[GetHashKey(m)] = true
end

CreateThread(function()
    while true do
        Wait(500) -- Régler si crash

        local pools = {
            GetGamePool("CObject"),
            GetGamePool("CVehicle"),
            GetGamePool("CPed"),
        }

        for _, list in ipairs(pools) do
            for _, ent in ipairs(list) do
                if DoesEntityExist(ent) and BLOCKED[GetEntityModel(ent)] then
                    SetEntityAsMissionEntity(ent, true, true)
                    DeleteEntity(ent)
                    if DoesEntityExist(ent) then
                        SetEntityVisible(ent, false, false)
                        SetEntityAlpha(ent, 0, false)
                        SetEntityCollision(ent, false, false)
                    end
                end
            end
        end
    end
end)

-- Classes de vehicules exclues des protections "prise de controle" de vehicule
-- (evite aussi les boucles de re-teleportation/ejection sources de deadloop) :
-- 14 = bateaux, 15 = helicopteres, 16 = avions.
local VEH_TAKEOVER_SKIP_CLASS = { [14] = true, [15] = true, [16] = true }

Citizen.CreateThread(function()
    local _PlayerPedId            = PlayerPedId
    local _IsPedInAnyVehicle      = IsPedInAnyVehicle
    local _GetVehTryingToEnter    = GetVehiclePedIsTryingToEnter
    local _GetSeatTryingToEnter   = GetSeatPedIsTryingToEnter
    local _GetPedInVehicleSeat    = GetPedInVehicleSeat
    local _DoesEntityExist        = DoesEntityExist
    local _IsEntityDead           = IsEntityDead
    local _ClearPedTasksImmediately = ClearPedTasksImmediately

    local lastNotif = 0

    while true do
        local sleep = 300
        local ped = _PlayerPedId()

        if not _IsPedInAnyVehicle(ped, false) then
            local veh = _GetVehTryingToEnter(ped)
            if veh and veh ~= 0 and _DoesEntityExist(veh)
               and not VEH_TAKEOVER_SKIP_CLASS[GetVehicleClass(veh)] then
                if _GetSeatTryingToEnter(ped) == -1 then
                    local driver = _GetPedInVehicleSeat(veh, -1)
                    if driver and driver ~= 0 and driver ~= ped
                       and _DoesEntityExist(driver) and not _IsEntityDead(driver) then
                        sleep = 0
                        _ClearPedTasksImmediately(ped)

                        local now = GetGameTimer()
                        if ESX and ESX.ShowNotification and (now - lastNotif) > 2000 then
                            lastNotif = now
                            ESX.ShowNotification("~r~Ce véhicule a déjà un conducteur.")
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local _PlayerPedId            = PlayerPedId
    local _GetVehiclePedIsIn      = GetVehiclePedIsIn
    local _GetPedInVehicleSeat    = GetPedInVehicleSeat
    local _IsPedBeingJacked       = IsPedBeingJacked
    local _SetPedIntoVehicle      = SetPedIntoVehicle
    local _SetPedCanBeDraggedOut  = SetPedCanBeDraggedOut
    local _ClearPedTasksImmediately = ClearPedTasksImmediately
    local _DoesEntityExist        = DoesEntityExist
    local _GetEntityCoords        = GetEntityCoords
    local _IsControlPressed       = IsControlPressed
    local _IsDisabledControlPressed = IsDisabledControlPressed
    local _GetGameTimer           = GetGameTimer

    local myVeh        = 0
    local seatedAt     = 0
    local armed        = false
    local exitPressedAt = 0
    local EXIT_GRACE_MS   = 1500
    local RECLAIM_DIST_SQ = 12.0 * 12.0
    -- Grace d'armement : la protection anti-descente ne s'active que
    -- ARM_DELAY_MS apres etre monte conducteur. Evite de combattre les
    -- scripts legitimes qui re-seatent/deplacent le joueur a la montee
    -- (et l'ejection "vehicule verrouille" du thread ci-dessous).
    local ARM_DELAY_MS    = 3000

    while true do
        local sleep = 250
        local ped = _PlayerPedId()
        local veh = _GetVehiclePedIsIn(ped, false)
        local now = _GetGameTimer()

        if _IsControlPressed(0, 75) or _IsDisabledControlPressed(0, 75) then
            exitPressedAt = now
        end

        if veh ~= 0 and _GetPedInVehicleSeat(veh, -1) == ped
           and not VEH_TAKEOVER_SKIP_CLASS[GetVehicleClass(veh)] then
            if veh ~= myVeh then
                myVeh = veh
                seatedAt = now
                armed = false
            end

            if not armed and (now - seatedAt) >= ARM_DELAY_MS then
                armed = true
            end

            if armed then
                sleep = 0
                _SetPedCanBeDraggedOut(ped, false)

                if _IsPedBeingJacked(ped) then
                    _ClearPedTasksImmediately(ped)
                    TriggerEvent('antisbire:vehEnterGrace', 3000)
                    _SetPedIntoVehicle(ped, veh, -1)
                end
            else
                sleep = 100
                _SetPedCanBeDraggedOut(ped, true)
            end
        elseif myVeh ~= 0 and _DoesEntityExist(myVeh) then
            -- Reclaim uniquement si la protection etait armee au moment
            -- de la descente (pas pendant la grace de montee).
            if armed and (now - exitPressedAt) > EXIT_GRACE_MS then
                local pc = _GetEntityCoords(ped)
                local vc = _GetEntityCoords(myVeh)
                local dx, dy, dz = vc.x - pc.x, vc.y - pc.y, vc.z - pc.z
                if (dx*dx + dy*dy + dz*dz) <= RECLAIM_DIST_SQ then
                    sleep = 0
                    TriggerEvent('antisbire:vehEnterGrace', 3000)
                    _SetPedIntoVehicle(ped, myVeh, -1)
                else
                    myVeh = 0
                    armed = false
                end
            else
                myVeh = 0
                armed = false
            end
        end

        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local _PlayerPedId            = PlayerPedId
    local _GetVehiclePedIsIn      = GetVehiclePedIsIn
    local _GetVehTryingToEnter    = GetVehiclePedIsTryingToEnter
    local _GetVehicleDoorLockStatus = GetVehicleDoorLockStatus
    local _DoesEntityExist        = DoesEntityExist
    local _TaskLeaveVehicle       = TaskLeaveVehicle
    local _ClearPedTasksImmediately = ClearPedTasksImmediately
    local _GetGameTimer           = GetGameTimer

    Citizen.Wait(10000)

    local prevVeh     = 0
    local lastEnterAt = 0
    local ENTER_GRACE_MS = 1200

    while true do
        local sleep = 250
        local ped = _PlayerPedId()
        local now = _GetGameTimer()

        if _GetVehTryingToEnter(ped) ~= 0 then
            lastEnterAt = now
        end

        local veh = _GetVehiclePedIsIn(ped, false)
        local ejecting = false

        if veh ~= 0 and veh ~= prevVeh
           and not VEH_TAKEOVER_SKIP_CLASS[GetVehicleClass(veh)] then
            local lockStatus = _GetVehicleDoorLockStatus(veh)
            if lockStatus and lockStatus >= 2 and (now - lastEnterAt) > ENTER_GRACE_MS then
                ejecting = true
                sleep = 0
                _ClearPedTasksImmediately(ped)
                _TaskLeaveVehicle(ped, veh, 16)
            end
        end

        if not ejecting then
            prevVeh = veh
        end

        Citizen.Wait(sleep)
    end
end)

local repairedVehicles = {}

local function GetVehicleTyreIndexes(vehicle)
    local wheels = GetVehicleNumberOfWheels(vehicle)

    if wheels == 2 then
        return {0, 4}
    elseif wheels == 4 then
        return {0, 1, 4, 5}
    elseif wheels == 6 then
        return {0, 1, 2, 3, 4, 5}
    else
        return {0, 1, 4, 5}
    end
end

local function CountBurstTyres(vehicle)
    local count = 0
    local tyreIndexes = GetVehicleTyreIndexes(vehicle)

    for _, tyre in ipairs(tyreIndexes) do
        if IsVehicleTyreBurst(vehicle, tyre, false) or IsVehicleTyreBurst(vehicle, tyre, true) then
            count += 1
        end
    end

    return count
end

local function FixAllTyres(vehicle)
    if not DoesEntityExist(vehicle) then return end

    local tyreIndexes = GetVehicleTyreIndexes(vehicle)

    for _, tyre in ipairs(tyreIndexes) do
        SetVehicleTyreFixed(vehicle, tyre)
    end

    Wait(150)

    if not DoesEntityExist(vehicle) then return end

    for _, tyre in ipairs(tyreIndexes) do
        SetVehicleTyreFixed(vehicle, tyre)
    end
end

CreateThread(function()
    while true do
        Wait(500)

        local vehicles = GetGamePool("CVehicle")
        local now = GetGameTimer()

        for _, vehicle in pairs(vehicles) do
            if DoesEntityExist(vehicle) and NetworkGetEntityIsNetworked(vehicle) then
                local netId = NetworkGetNetworkIdFromEntity(vehicle)

                if netId and netId ~= 0 then
                    local burstCount = CountBurstTyres(vehicle)

                    if burstCount >= 4 then
                        if not repairedVehicles[netId] or now - repairedVehicles[netId] > 8000 then
                            repairedVehicles[netId] = now

                            CreateThread(function()
                                FixAllTyres(vehicle)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

do
    local DEBUG_SWAP = false
    local DETECTION_WINDOW = 10000
    local MAX_SWAPS = 3
    local STARTUP_DELAY = 10000

    local swapTimes = {}
    local lastVehicle = 0
    local triggered = false

    local function CountRecentSwaps(now)
        local fresh = {}

        for i = 1, #swapTimes do
            if now - swapTimes[i] <= DETECTION_WINDOW then
                fresh[#fresh + 1] = swapTimes[i]
            end
        end

        swapTimes = fresh
        return #swapTimes
    end

    local previewSources = {}

    AddEventHandler("SUNAC:SetVehiclePreview", function(source, state)
        if not source then
            return
        end

        previewSources[source] = state == true or nil
        swapTimes = {}
    end)

    Citizen.CreateThread(function()
        Citizen.Wait(STARTUP_DELAY)

        while true do
            Citizen.Wait(0)

            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if vehicle == 0 then
                lastVehicle = 0
            elseif vehicle ~= lastVehicle then
                lastVehicle = vehicle

                if not next(previewSources) then
                    local now = GetGameTimer()
                    swapTimes[#swapTimes + 1] = now

                    local count = CountRecentSwaps(now)
                    if count >= MAX_SWAPS and not triggered then
                        if DEBUG_SWAP then
                            swapTimes = {}
                        else
                            triggered = true
                            TriggerServerEvent("ddd213h32ne87adsy9asd")
                        end
                    end
                end
            end
        end
    end)
end

local AC_FC_CHECK_MS    = 5000
local AC_FC_MAX_DIST    = 50.0
local AC_FC_MAX_DIST_SQ = AC_FC_MAX_DIST * AC_FC_MAX_DIST
local AC_FC_WINDOW      = 15000
local AC_FC_THRESHOLD   = 3
local AC_FC_FREEZE_MS   = 10000
-- Un saut de position superieur a AC_FC_TP_DIST entre deux echantillons est
-- considere comme un teleport (rea hopital, tp admin...) : on ignore la
-- detection freecam pendant AC_FC_TP_GRACE_MS pour eviter les faux positifs.
local AC_FC_TP_DIST     = 300.0
local AC_FC_TP_DIST_SQ  = AC_FC_TP_DIST * AC_FC_TP_DIST
local AC_FC_TP_GRACE_MS = 8000

CreateThread(function()
    local hits = {}
    local lastX, lastY, lastZ, hasLast = 0.0, 0.0, 0.0, false
    local graceUntil = 0

    while true do
        Wait(AC_FC_CHECK_MS)

        local ped = PlayerPedId()
        if ped and ped ~= 0 and DoesEntityExist(ped) and not IsEntityDead(ped) then
            local pc  = GetEntityCoords(ped)
            local now = GetGameTimer()

            -- Teleport : gros saut de position depuis le dernier echantillon.
            if hasLast then
                local ddx, ddy, ddz = pc.x - lastX, pc.y - lastY, pc.z - lastZ
                if (ddx * ddx + ddy * ddy + ddz * ddz) > AC_FC_TP_DIST_SQ then
                    graceUntil = now + AC_FC_TP_GRACE_MS
                    hits = {}
                end
            end
            lastX, lastY, lastZ, hasLast = pc.x, pc.y, pc.z, true

            -- Transition en cours (fondu ecran / switch joueur) : on ignore et
            -- on reset, car la camera peut etre loin du ped temporairement.
            local inTransition = now < graceUntil
                or IsScreenFadedOut() or IsScreenFadingOut() or IsScreenFadingIn()
                or IsPlayerSwitchInProgress()

            if inTransition then
                hits = {}
            else
                local cam = GetGameplayCamCoord()
                local dx, dy, dz = cam.x - pc.x, cam.y - pc.y, cam.z - pc.z

                local detected = IsGameplayCamRendering()
                    and (dx * dx + dy * dy + dz * dz) > AC_FC_MAX_DIST_SQ

                if detected then
                    local kept = {}
                    for i = 1, #hits do
                        if (now - hits[i]) <= AC_FC_WINDOW then kept[#kept + 1] = hits[i] end
                    end
                    hits = kept
                    hits[#hits + 1] = now

                    if #hits >= AC_FC_THRESHOLD then
                        hits = {}
                        FreezeEntityPosition(ped, true)
                        Wait(AC_FC_FREEZE_MS)

                        if DoesEntityExist(ped) then FreezeEntityPosition(ped, false) end
                        local cur = PlayerPedId()
                        if cur and cur ~= 0 and cur ~= ped then FreezeEntityPosition(cur, false) end
                        hasLast = false
                    end
                end
            end
        else
            hasLast = false
        end
    end
end)

local AC_VEHMOD_EVENT     = "qv83_mkz1p9"
-- Doit refleter EXACTEMENT la liste des jobs autorises a ouvrir le menu de
-- customisation (sJobs/mechanics/client/customs.lua). Un job qui peut tuner
-- mais absent d'ici voit ses modifications annulees au tick suivant et se fait
-- remonter comme modeur. `streettuners` et `mayans` manquaient.
local AC_VEHMOD_ALLOWED   = {
    bennys = true, lscustom = true, hayes = true, harmony = true,
    streettuners = true, mayans = true,
}
local AC_VEHMOD_SETTLE_MS = 5000
local AC_VEHMOD_POLL_MS   = 2000
local AC_VEHMOD_JOB       = nil
local AC_NC_GROUP         = nil

local AC_NC_STAFF    = { superadmin = true, help = true, test = true, mod = true, admin = true, gerant = true, _dev = true }
local AC_NC_IS_STAFF = false
local function acIsStaff()
    if AC_NC_IS_STAFF then return true end
    if AC_NC_GROUP and AC_NC_STAFF[AC_NC_GROUP] then return true end
    return false
end

CreateThread(function()
    local esx
    while esx == nil do
        if GetResourceState('es_extended') == 'started' then
            local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
            if ok and obj then esx = obj end
        end
        if esx == nil then Wait(500) end
    end
    if esx.GetPlayerData then
        local pd = esx.GetPlayerData()
        if pd and pd.job and pd.job.name then AC_VEHMOD_JOB = pd.job.name end
        if pd and pd.group then AC_NC_GROUP = pd.group end
    end
end)

RegisterNetEvent('esx:setJob', function(job)
    if job and job.name then AC_VEHMOD_JOB = job.name end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    if xPlayer and xPlayer.job and xPlayer.job.name then AC_VEHMOD_JOB = xPlayer.job.name end
    if xPlayer and xPlayer.group then AC_NC_GROUP = xPlayer.group end
end)

RegisterNetEvent('esx:setGroup', function(group)
    if group then AC_NC_GROUP = group end
end)

-- Fenêtre pendant laquelle une modification de tuning est LÉGITIME et ne doit
-- ni être annulée ni remontée. Utilisée par les scripts qui repeignent ou
-- retunent un véhicule hors d'un garage mécano : bombes de peinture VIP
-- (sJobs/client/gestion.lua), etc. Sans ça le guard remet la peinture d'origine
-- au tick suivant ET signale le joueur.
local _acVehModGraceUntil = 0

local function _acVehModGrace(ms)
    local until_ = GetGameTimer() + (tonumber(ms) or 15000)
    if until_ > _acVehModGraceUntil then _acVehModGraceUntil = until_ end
end

exports('vehModGrace', _acVehModGrace)
RegisterNetEvent('antisbire:vehModGrace', function(ms)
    ms = tonumber(ms)
    if ms and ms <= 0 then
        _acVehModGraceUntil = 0
        return
    end
    _acVehModGrace(ms)
end)

local function _acCaptureProps(veh)
    SetVehicleModKit(veh, 0)
    local props = {}
    props.color1, props.color2 = GetVehicleColours(veh)
    props.pearlescent, props.wheelColor = GetVehicleExtraColours(veh)
    props.windowTint = GetVehicleWindowTint(veh)
    props.wheelType = GetVehicleWheelType(veh)

    props.primaryCustom = GetIsVehiclePrimaryColourCustom(veh)
    props.pr, props.pg, props.pb = GetVehicleCustomPrimaryColour(veh)
    props.secondaryCustom = GetIsVehicleSecondaryColourCustom(veh)
    props.sr, props.sg, props.sb = GetVehicleCustomSecondaryColour(veh)

    props.mods = {}
    for m = 0, 49 do
        props.mods[m] = GetVehicleMod(veh, m)
    end
    props.wheelVariation = GetVehicleModVariation(veh, 23)

    props.turbo   = IsToggleModOn(veh, 18)
    props.smokeOn = IsToggleModOn(veh, 20)
    props.xenon   = IsToggleModOn(veh, 22)
    props.livery  = GetVehicleLivery(veh)

    props.neonR, props.neonG, props.neonB = GetVehicleNeonLightsColour(veh)
    props.neon = {}
    for i = 0, 3 do props.neon[i] = IsVehicleNeonLightEnabled(veh, i) end

    props.smokeR, props.smokeG, props.smokeB = GetVehicleTyreSmokeColor(veh)
    props.plateIndex = GetVehicleNumberPlateTextIndex(veh)
    props.plateText  = GetVehicleNumberPlateText(veh)
    return props
end

local function _acSigFromProps(props)
    local t, n = {}, 0
    local function add(v) n = n + 1; t[n] = v end
    add(props.color1); add(props.color2); add(props.pearlescent); add(props.wheelColor)
    add(props.windowTint); add(props.wheelType)
    add(props.primaryCustom and 1 or 0)
    add(props.pr); add(props.pg); add(props.pb)
    add(props.secondaryCustom and 1 or 0)
    add(props.sr); add(props.sg); add(props.sb)
    for m = 0, 49 do add(props.mods[m]) end
    add(props.turbo and 1 or 0); add(props.smokeOn and 1 or 0); add(props.xenon and 1 or 0)
    add(props.livery)
    add(props.neonR); add(props.neonG); add(props.neonB)
    for i = 0, 3 do add(props.neon[i] and 1 or 0) end
    add(props.smokeR); add(props.smokeG); add(props.smokeB)
    add(props.plateIndex)
    add(props.plateText or "")
    return table.concat(t, ",")
end

local function _acApplyProps(veh, props)
    SetVehicleModKit(veh, 0)
    SetVehicleWheelType(veh, props.wheelType)
    SetVehicleColours(veh, props.color1, props.color2)
    SetVehicleExtraColours(veh, props.pearlescent, props.wheelColor)
    SetVehicleWindowTint(veh, props.windowTint)
    if props.primaryCustom then
        SetVehicleCustomPrimaryColour(veh, props.pr, props.pg, props.pb)
    end
    if props.secondaryCustom then
        SetVehicleCustomSecondaryColour(veh, props.sr, props.sg, props.sb)
    end
    for m = 0, 49 do
        if m == 23 or m == 24 then
            SetVehicleMod(veh, m, props.mods[m], props.wheelVariation)
        else
            SetVehicleMod(veh, m, props.mods[m], false)
        end
    end
    ToggleVehicleMod(veh, 18, props.turbo)
    ToggleVehicleMod(veh, 20, props.smokeOn)
    ToggleVehicleMod(veh, 22, props.xenon)
    SetVehicleLivery(veh, props.livery)
    SetVehicleNeonLightsColour(veh, props.neonR, props.neonG, props.neonB)
    for i = 0, 3 do SetVehicleNeonLightEnabled(veh, i, props.neon[i]) end
    SetVehicleTyreSmokeColor(veh, props.smokeR, props.smokeG, props.smokeB)
    SetVehicleNumberPlateTextIndex(veh, props.plateIndex)
    if props.plateText then
        SetVehicleNumberPlateText(veh, props.plateText)
    end
end

CreateThread(function()
    local lastVeh   = 0
    local baseProps = nil
    local baseSig   = nil
    local settleAt  = 0

    while true do
        Wait(AC_VEHMOD_POLL_MS)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then
            lastVeh   = 0
            baseProps = nil
            baseSig   = nil
        elseif AC_VEHMOD_ALLOWED[AC_VEHMOD_JOB or ""] or acIsStaff() then

            lastVeh   = veh
            baseProps = _acCaptureProps(veh)
            baseSig   = _acSigFromProps(baseProps)
            settleAt  = GetGameTimer() + AC_VEHMOD_SETTLE_MS
        else
            local now = GetGameTimer()
            if veh ~= lastVeh then
                lastVeh   = veh
                baseProps = _acCaptureProps(veh)
                baseSig   = _acSigFromProps(baseProps)
                settleAt  = now + AC_VEHMOD_SETTLE_MS
            else
                local props = _acCaptureProps(veh)
                local sig   = _acSigFromProps(props)
                -- Pendant une grâce, on RE-BASELINE au lieu de comparer : le
                -- tuning appliqué devient la nouvelle référence, donc il
                -- survit à la fin de la fenêtre au lieu d'être annulé au tick
                -- suivant.
                if now < settleAt or now < _acVehModGraceUntil then
                    baseProps = props
                    baseSig   = sig
                elseif baseSig and sig ~= baseSig then
                    _acApplyProps(veh, baseProps)
                    local netId = VehToNet(veh)
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                    local plate = GetVehicleNumberPlateText(veh)
                    TriggerServerEvent(AC_VEHMOD_EVENT, netId, model, plate)
                end
            end
        end
    end
end)

local AC_ENG_EVENT     = "hf29_qm7xrz"
local AC_ENG_POLL_MS   = 1000
local AC_ENG_HIGH      = 800.0
local AC_ENG_LOW       = 200.0
local AC_ENG_WINDOW_MS = 5000
local AC_ENG_BODY_MIN  = 700.0

CreateThread(function()
    local lastVeh    = 0
    local hadHigh    = false
    local lastHighAt = 0

    while true do
        Wait(AC_ENG_POLL_MS)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then
            lastVeh = 0
            hadHigh = false
        else
            local now = GetGameTimer()
            if veh ~= lastVeh then
                lastVeh    = veh
                hadHigh    = false
                lastHighAt = 0
            end

            local eng = GetVehicleEngineHealth(veh)
            if eng >= AC_ENG_HIGH then
                lastHighAt = now
                hadHigh    = true
            elseif hadHigh and eng < AC_ENG_LOW and (now - lastHighAt) <= AC_ENG_WINDOW_MS then
                if GetVehicleBodyHealth(veh) >= AC_ENG_BODY_MIN then
                    SetVehicleFixed(veh)
                    SetVehicleEngineHealth(veh, 1000.0)
                    SetVehiclePetrolTankHealth(veh, 1000.0)
                    SetVehicleUndriveable(veh, false)
                    lastHighAt = now
                    hadHigh    = true

                    local netId = VehToNet(veh)
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                    TriggerServerEvent(AC_ENG_EVENT, netId, model, math.floor(eng))
                else
                    hadHigh = false
                end
            end
        end
    end
end)

local AC_NC_STAFF_RESOLVED = false

RegisterNetEvent('antisbire:nc:staffResult', function(v)
    if v == true then AC_NC_IS_STAFF = true end
    AC_NC_STAFF_RESOLVED = true
end)

-- Le serveur push le statut staff de lui-meme (esx:playerLoaded et
-- onResourceStart). On n'envoie qu'UNE requete de secours par session si
-- rien n'est arrive ; le serveur re-essaie de son cote jusqu'a pouvoir
-- repondre, donc inutile de re-demander en boucle.
CreateThread(function()
    Wait(15000)
    if not AC_NC_STAFF_RESOLVED then
        TriggerServerEvent('antisbire:nc:amIStaff')
    end
end)

local AC_SJ_EVENT      = "zt61_k9wxq4"
local AC_SJ_FOOT_VZ    = 8.0
local AC_SJ_VEH_VZ     = 20.0
local AC_SJ_REPORT_MS  = 5000

local AC_SB_EVENT        = "wq47_hp2mzx"
local AC_SB_FOOT_MAX     = 12.0
local AC_SB_TP_DIST      = 25.0

local AC_SB_TP_VZ        = 5.0
local AC_SB_REPORT_MS    = 5000
local AC_SB_VEH_EXIT_MS  = 1500
local AC_SB_VEH_KMH_JUMP = 100.0
local AC_SB_VEH_WIN_MS   = 500

-- Fenetre d'aveuglement apres un evenement physique legitime (collision,
-- vol/atterrissage). Le moteur transfere la quantite de mouvement sur la
-- frame de contact ET sur les quelques frames suivantes : mesurer un "gain de
-- vitesse" pendant cette periode revient a mesurer la physique du jeu, pas un
-- cheat.
local AC_SB_VEH_SETTLE_MS = 1200

local _acSbGraceUntil = 0

local function _acSpeedBoostGrace(ms)
    local until_ = GetGameTimer() + (tonumber(ms) or 6000)
    if until_ > _acSbGraceUntil then _acSbGraceUntil = until_ end
end

exports('speedBoostGrace', _acSpeedBoostGrace)
RegisterNetEvent('antisbire:speedBoostGrace', function(ms) _acSpeedBoostGrace(ms) end)

local _acTpGraceUntil = 0

-- Plafond de la grace : elle desactive TOUTE la detection noclip. Sans borne,
-- un simple TriggerEvent('antisbire:noclipGrace', 99999999) cote client suffit
-- a l'eteindre pour la session. Un appel legitime demande quelques secondes.
local AC_NC_GRACE_MAX_MS = 30000

local function _acNoclipGrace(ms)
    ms = tonumber(ms) or 4000
    if ms > AC_NC_GRACE_MAX_MS then ms = AC_NC_GRACE_MAX_MS end

    local until_ = GetGameTimer() + ms
    if until_ > _acTpGraceUntil then _acTpGraceUntil = until_ end
end

exports('noclipGrace', _acNoclipGrace)
RegisterNetEvent('antisbire:noclipGrace', function(ms)
    ms = tonumber(ms)
    if ms and ms <= 0 then
        _acTpGraceUntil = 0
        return
    end
    _acNoclipGrace(ms)
end)

CreateThread(function()
    local lastSjReport = 0
    local lastSbReport = 0
    local lastSbKick   = 0
    local lastInVehAt  = 0
    local sbLastX, sbLastY, sbLastZ, sbLastT = nil, nil, nil, 0
    local sbVehBaseKmh, sbVehBaseT = 0.0, 0
    local sbVehNoiseUntil = 0

    while true do
        Wait(0)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local now = GetGameTimer()
        local staff = acIsStaff()

        local sjBlocked, sjInVeh = false, false
        local sbBlocked = false
        local sbKick    = false

        if veh ~= 0 then
            lastInVehAt = now
            sbLastX = nil
            if not staff and GetPedInVehicleSeat(veh, -1) == ped then
                local vel = GetEntityVelocity(veh)

                if vel.z > AC_SJ_VEH_VZ then
                    SetEntityVelocity(veh, vel.x, vel.y, AC_SJ_VEH_VZ)
                    sjBlocked, sjInVeh = true, true
                end

                -- Vitesse HORIZONTALE et non GetEntitySpeed (norme 3D).
                --
                -- GetEntitySpeed inclut la composante verticale : une chute,
                -- un saut de rampe ou un atterrissage faisaient donc grimper
                -- la "vitesse" de plusieurs dizaines de km/h sans que le
                -- vehicule avance plus vite. Un speed hack, lui, est
                -- horizontal.
                local kmh = math.sqrt(vel.x * vel.x + vel.y * vel.y) * 3.6

                -- Aveuglement sur les evenements physiques legitimes.
                -- Se faire percuter, exploser, retomber d'un saut : le moteur
                -- transfere la quantite de mouvement en UNE frame, ce qui
                -- produit exactement la signature recherchee (+100 km/h en
                -- moins de 500 ms). C'est la principale source de faux
                -- positifs sur un serveur RP, ou les collisions violentes
                -- (course-poursuite, PIT, accident) sont du jeu normal.
                if HasEntityCollidedWithAnything(veh) or IsEntityInAir(veh) then
                    sbVehNoiseUntil = now + AC_SB_VEH_SETTLE_MS
                end

                if now < _acSbGraceUntil or now < sbVehNoiseUntil then
                    sbVehBaseKmh, sbVehBaseT = kmh, now
                elseif sbVehBaseT ~= 0 and (now - sbVehBaseT) <= AC_SB_VEH_WIN_MS and kmh >= sbVehBaseKmh then
                    if (kmh - sbVehBaseKmh) >= AC_SB_VEH_KMH_JUMP then
                        sbKick = true
                        sbVehBaseKmh, sbVehBaseT = kmh, now
                    end
                else
                    sbVehBaseKmh, sbVehBaseT = kmh, now
                end
            else
                sbVehBaseT = 0
            end
        elseif not staff and not IsPedRagdoll(ped) then
            sbVehBaseT = 0
            local vel = GetEntityVelocity(ped)
            if vel.z > AC_SJ_FOOT_VZ then
                SetEntityVelocity(ped, vel.x, vel.y, AC_SJ_FOOT_VZ)
                sjBlocked = true
            end

            local pos = GetEntityCoords(ped)

            if now >= _acTpGraceUntil and (now - lastInVehAt) > AC_SB_VEH_EXIT_MS and sbLastX then
                local ddx = pos.x - sbLastX
                local ddy = pos.y - sbLastY
                local ddz = pos.z - (sbLastZ or pos.z)
                local dist = math.sqrt(ddx * ddx + ddy * ddy)
                local dt = (now - sbLastT) / 1000.0

                if math.abs(ddz) <= AC_SB_TP_VZ
                   and dist <= AC_SB_TP_DIST and dt > 0.0 and (dist / dt) > AC_SB_FOOT_MAX then
                    local allowed = AC_SB_FOOT_MAX * dt
                    local scale = allowed / dist
                    local nx = sbLastX + ddx * scale
                    local ny = sbLastY + ddy * scale
                    SetEntityCoordsNoOffset(ped, nx, ny, pos.z, false, false, false)
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    SetPedMoveRateOverride(ped, 1.0)
                    pos = vector3(nx, ny, pos.z)
                    sbBlocked = true
                end
            end
            sbLastX, sbLastY, sbLastZ, sbLastT = pos.x, pos.y, pos.z, now
        else
            sbVehBaseT = 0
            sbLastX = nil
        end

        if sjBlocked and (now - lastSjReport) >= AC_SJ_REPORT_MS then
            lastSjReport = now
            TriggerServerEvent(AC_SJ_EVENT, sjInVeh)
        end
        if sbKick and (now - lastSbKick) >= AC_SB_REPORT_MS then
            lastSbKick = now
            TriggerServerEvent(AC_SB_EVENT, true, true)
        elseif sbBlocked and (now - lastSbReport) >= AC_SB_REPORT_MS then
            lastSbReport = now
            TriggerServerEvent(AC_SB_EVENT, false, false)
        end
    end
end)

local AC_NC_SAMPLE_MS    = 100
-- ~47 km/h : sprint vanilla ~7.15 m/s ; pire cas legit du serveur = farm
-- caisse jobs_pack (move rate x2.10) cumule au buff gym (x1.18) ~12.4 m/s.
-- Au-dela, sans chute (cf. AC_NC_FALL_DZ), anormal. Le clamp speed-boost a
-- pied (AC_SB_FOOT_MAX = 12) borne deja l'horizontal de son cote.
local AC_NC_MIN_HSPEED   = 13.0
local AC_NC_MAX_HSPEED   = 150.0
local AC_NC_FALL_DZ      = -8.0
local AC_NC_UP_MAX       = 15.0
local AC_NC_VEH_GRACE_MS = 3000
local AC_NC_VEH_NEAR     = 3.0
local AC_NC_HOLD_MS      = 10000

-- Certains vehicules du serveur montent a ~400 km/h (~111 m/s) : seuil a
-- 150 m/s (540 km/h) pour garder une vraie marge avant de flagger.
local AC_NC_VEH_MIN_SPEED  = 150.0
local AC_NC_VEH_TP_SPEED   = 300.0
local AC_NC_VEH_TICKS      = 2
local AC_NC_VEH_SKIP_CLASS = { [14] = true, [15] = true, [16] = true, [21] = true }

local AC_NC_FOOT_TICKS     = 2

-- Safezones : anti-noclip totalement inactif dedans.
-- La zone AFK (sunlife/afkfarm) applique SetPedMoveRateOverride 2.50 en
-- continu (~18 m/s en sprint), il FAUT l'exclure.
local AC_NC_SAFEZONES = {
    -- Interieur zone AFK (garage casino, recall du script a -1266.8/-3021.9/-49.5)
    { x = -1267.06, y = -3017.74, z = -49.49, r2 = 100.0 * 100.0 },
    -- Ancienne safezone (reprise de l'ancienne version serveur)
    { x = -1975.2670898438, y = -2033.1165771484, z = 1771.8686523438, r2 = 110.0 * 110.0 },
}

-- Report d'offense au serveur (log Discord uniquement, l'enforcement est
-- fait ici meme). Rate-limite cote client pour ne jamais spammer.
local AC_NC_REPORT_EVENT = "gj36_wrn5te"
local AC_NC_REPORT_MS    = 30000
local _acNcLastReport    = 0

local function _acNcReport(inVeh, speed)
    local now = GetGameTimer()
    if (now - _acNcLastReport) < AC_NC_REPORT_MS then return end
    _acNcLastReport = now
    TriggerServerEvent(AC_NC_REPORT_EVENT, inVeh == true, math.floor(tonumber(speed) or 0))
end

-- Enforcement du hold.
--
-- SetEntityCoordsNoOffset seul ne bloque rien : le menu noclip repositionne le
-- ped a CHAQUE frame lui aussi. On se retrouve donc a se disputer la position
-- avec le cheat selon l'ordre de tick des resources -> le joueur avance par
-- a-coups au lieu d'etre bloque. Ici on ne corrige plus la position, on coupe
-- ce qui produit le mouvement : collision remise, velocite a zero, entite
-- gelee, controles desactives, joueur rendu inerte.
local AC_NC_HOLD_MULT_MAX = 3        -- escalade du blocage x1 -> x3 sur recidive
local AC_NC_HOLD_RECID_MS = 120000   -- fenetre de recidive
local AC_NC_HOLD_OVERLAY  = true     -- ecran noir + message pendant le blocage

local _acNcHeldEnts = {}

local function _acNcHoldMark(ent)
    if ent and ent ~= 0 and DoesEntityExist(ent) then
        _acNcHeldEnts[ent] = true
    end
end

local function _acNcHoldApply(ped, x, y, z)
    local veh = GetVehiclePedIsIn(ped, false)
    local ent = (veh ~= 0) and veh or ped

    _acNcHoldMark(ent)
    _acNcHoldMark(ped)

    -- Le noclip coupe la collision et pousse une position/velocite par frame.
    SetEntityCollision(ent, true, true)
    SetEntityVelocity(ent, 0.0, 0.0, 0.0)
    SetEntityCoordsNoOffset(ent, x, y, z, false, false, false)
    FreezeEntityPosition(ent, true)

    if veh == 0 then
        SetPedMoveRateOverride(ped, 1.0)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end

    -- Plus aucune entree ne doit atteindre le jeu pendant le blocage.
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
    SetPlayerControl(PlayerId(), false, 0)

    -- SetPlayerControl(false) rend le joueur invincible : sinon declencher
    -- volontairement un blocage servirait a encaisser une fusillade.
    SetEntityInvincible(ped, false)
end

local function _acNcHoldRelease()
    for ent in pairs(_acNcHeldEnts) do
        if DoesEntityExist(ent) then
            FreezeEntityPosition(ent, false)
        end
        _acNcHeldEnts[ent] = nil
    end

    local ped = PlayerPedId()
    if ped and ped ~= 0 and DoesEntityExist(ped) then
        FreezeEntityPosition(ped, false)
    end

    SetPlayerControl(PlayerId(), true, 0)
end

local function _acNcHoldOverlay(remainMs)
    if not AC_NC_HOLD_OVERLAY then return end

    -- Pas de fond noir plein ecran : seulement le texte, avec contour et
    -- ombre pour rester lisible sur n'importe quel decor.
    SetTextFont(4)
    SetTextScale(0.0, 0.80)
    SetTextColour(255, 60, 60, 255)
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("ANTI-CHEAT")
    DrawText(0.5, 0.43)

    SetTextFont(4)
    SetTextScale(0.0, 0.45)
    SetTextColour(230, 230, 230, 255)
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(("Deplacement invalide detecte - blocage %ds"):format(math.ceil(remainMs / 1000)))
    DrawText(0.5, 0.50)
end

-- Filet de securite : un restart de la ressource pendant un blocage ne doit
-- jamais laisser le joueur gele ou sans controles.
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    _acNcHoldRelease()
end)

CreateThread(function()
    local lx, ly, lz, lt = nil, nil, nil, 0
    local lastVehAt = 0
    local anchorX, anchorY, anchorZ, anchorUntil = nil, nil, nil, 0
    local vehHit = 0
    local vehAnchorX, vehAnchorY, vehAnchorZ = 0.0, 0.0, 0.0
    local footHit = 0
    local footAnchorX, footAnchorY, footAnchorZ = 0.0, 0.0, 0.0
    local holdMult, lastHoldAt = 1, 0

    -- Recidiver dans la fenetre allonge le blocage (10s -> 20s -> 30s).
    local function nextHoldUntil(now)
        if (now - lastHoldAt) <= AC_NC_HOLD_RECID_MS then
            holdMult = math.min(holdMult + 1, AC_NC_HOLD_MULT_MAX)
        else
            holdMult = 1
        end
        lastHoldAt = now
        return now + (AC_NC_HOLD_MS * holdMult)
    end

    Wait(5000)

    while true do
        local holding = anchorUntil > GetGameTimer()
        Wait(holding and 0 or AC_NC_SAMPLE_MS)

        local ped = PlayerPedId()
        local now = GetGameTimer()

        if anchorUntil > now then

            if ped == 0 or acIsStaff() or now < _acTpGraceUntil or IsEntityDead(ped) then
                anchorUntil = 0
                _acNcHoldRelease()
                lx, ly, lz, lt = nil, nil, nil, 0
            else
                _acNcHoldApply(ped, anchorX, anchorY, anchorZ)
                _acNcHoldOverlay(anchorUntil - now)
            end
        else
            if next(_acNcHeldEnts) ~= nil then
                _acNcHoldRelease()
                lx, ly, lz, lt = nil, nil, nil, 0
            end

            local veh = GetVehiclePedIsIn(ped, false)
            local inVeh = veh ~= 0
            if inVeh then lastVehAt = now end

            local p = GetEntityCoords(ped)

            local skip = acIsStaff() or ped == 0 or IsEntityDead(ped) or now < _acTpGraceUntil
            if inVeh then
                if GetPedInVehicleSeat(veh, -1) ~= ped or AC_NC_VEH_SKIP_CLASS[GetVehicleClass(veh)] then
                    skip = true
                end
            else
                -- Attache a une entite : zipline, script de portage, remorquage...
                if IsPedRagdoll(ped) or GetPedParachuteState(ped) ~= -1
                    or GetEntityAttachedTo(ped) ~= 0 then
                    skip = true
                end
            end

            -- Safezones (zone AFK...) : aucune detection dedans.
            if not skip then
                for i = 1, #AC_NC_SAFEZONES do
                    local zn = AC_NC_SAFEZONES[i]
                    local zx, zy, zz = p.x - zn.x, p.y - zn.y, p.z - zn.z
                    if (zx * zx + zy * zy + zz * zz) <= zn.r2 then
                        skip = true
                        break
                    end
                end
            end

            if skip then
                lx, ly, lz, lt = p.x, p.y, p.z, now
                vehHit = 0
                footHit = 0
            else
                if lx and lt ~= 0 then
                    local dt = (now - lt) / 1000.0
                    if dt > 0.0 then
                        local ddx, ddy, ddz = p.x - lx, p.y - ly, p.z - lz

                        if inVeh then
                            footHit = 0
                            local sp = math.sqrt(ddx * ddx + ddy * ddy + ddz * ddz) / dt
                            if sp > AC_NC_VEH_TP_SPEED then
                                vehHit = 0
                                lx, ly, lz, lt = p.x, p.y, p.z, now
                            elseif sp >= AC_NC_VEH_MIN_SPEED then
                                if vehHit == 0 then
                                    vehAnchorX, vehAnchorY, vehAnchorZ = lx, ly, lz
                                end
                                vehHit = vehHit + 1
                                if vehHit >= AC_NC_VEH_TICKS then
                                    vehHit = 0
                                    anchorX, anchorY, anchorZ = vehAnchorX, vehAnchorY, vehAnchorZ
                                    anchorUntil = nextHoldUntil(now)
                                    _acNcHoldApply(ped, anchorX, anchorY, anchorZ)
                                    _acNcReport(true, sp)
                                else
                                    lx, ly, lz, lt = p.x, p.y, p.z, now
                                end
                            else
                                vehHit = 0
                                lx, ly, lz, lt = p.x, p.y, p.z, now
                            end
                        else
                            local hs = math.sqrt(ddx * ddx + ddy * ddy) / dt
                            local vs = ddz / dt

                            if hs > AC_NC_MAX_HSPEED then
                                footHit = 0
                                lx, ly, lz, lt = p.x, p.y, p.z, now
                            elseif (now - lastVehAt) > AC_NC_VEH_GRACE_MS
                                and (((hs >= AC_NC_MIN_HSPEED) and (vs > AC_NC_FALL_DZ)) or (vs >= AC_NC_UP_MAX)) then
                                if GetClosestVehicle(p.x, p.y, p.z, AC_NC_VEH_NEAR, 0, 70) ~= 0 then
                                    footHit = 0
                                    lx, ly, lz, lt = p.x, p.y, p.z, now
                                else

                                    if footHit == 0 then
                                        footAnchorX, footAnchorY, footAnchorZ = lx, ly, lz
                                    end
                                    footHit = footHit + 1
                                    if footHit >= AC_NC_FOOT_TICKS then
                                        footHit = 0
                                        anchorX, anchorY, anchorZ = footAnchorX, footAnchorY, footAnchorZ
                                        anchorUntil = nextHoldUntil(now)
                                        _acNcHoldApply(ped, anchorX, anchorY, anchorZ)
                                        _acNcReport(false, hs)
                                    else
                                        lx, ly, lz, lt = p.x, p.y, p.z, now
                                    end
                                end
                            else
                                footHit = 0
                                lx, ly, lz, lt = p.x, p.y, p.z, now
                            end
                        end
                    end
                else
                    lx, ly, lz, lt = p.x, p.y, p.z, now
                end
            end
        end
    end
end)

local AC_ARM_EVENT     = "px74_bz3vak"
local AC_ARM_POLL_MS   = 500
local AC_ARM_MIN_ADD   = 10
local AC_ARM_GRACE_MS  = 2500
local AC_ARM_SPAWN_MS  = 8000

local _acArmorGraceUntil = 0

local function _acArmorGrace(ms)
    local until_ = GetGameTimer() + (tonumber(ms) or 5000)
    if until_ > _acArmorGraceUntil then _acArmorGraceUntil = until_ end
end

exports('armorGrace', _acArmorGrace)
RegisterNetEvent('antisbire:armorGrace', function(ms) _acArmorGrace(ms) end)

AddEventHandler('playerSpawned', function()
    _acArmorGrace(AC_ARM_SPAWN_MS)
end)

local function _acUsingGilet()
    local ok, res = pcall(function() return exports['sCore']:UsingGilet() end)
    return ok and res == true
end

CreateThread(function()
    local lastArmor = GetPedArmour(PlayerPedId())

    while true do
        Wait(AC_ARM_POLL_MS)

        local ped = PlayerPedId()

        if _acUsingGilet() then
            _acArmorGrace(AC_ARM_GRACE_MS)
        end

        local armor = GetPedArmour(ped)

        if (armor - lastArmor) >= AC_ARM_MIN_ADD and GetGameTimer() > _acArmorGraceUntil then
            SetPedArmour(ped, math.floor(lastArmor))
            TriggerServerEvent(AC_ARM_EVENT, math.floor(lastArmor), math.floor(armor))
            armor = GetPedArmour(ped)
        end

        lastArmor = armor
    end
end)

-- Remontee de l'heure murale du PC au premier spawn. Le serveur la compare a
-- l'heure du fuseau horaire de l'IP (server/log.lua > antisbire:tzReport).
-- os.date("*t") lit l'horloge locale de la machine, telle qu'elle est affichee
-- par Windows : c'est bien la valeur que l'on veut confronter a la geoloc.
local TZ_REPORT_EVENT = "antisbire:tzReport"
local TZ_REPORT_DELAY = 10000

local _tzReported = false

AddEventHandler('playerSpawned', function()
    -- playerSpawned se redeclenche a chaque respawn : une seule remontee suffit.
    if _tzReported then return end
    _tzReported = true

    CreateThread(function()
        Wait(TZ_REPORT_DELAY)

        local ok, t = pcall(os.date, "*t")
        if not ok or type(t) ~= "table" or not t.hour or not t.min then return end

        TriggerServerEvent(TZ_REPORT_EVENT, (t.hour * 60) + t.min)
    end)
end)