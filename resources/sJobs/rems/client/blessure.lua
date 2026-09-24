function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

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
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_G19', 'WEAPON_UMP45CMG', 'WEAPON_MP5', 'WEAPON_MP7CMG'}
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
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE', 'WEAPON_MK18B', 'WEAPON_HK416B', 'WEAPON_HEAVYRIFLE'}
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

local CauseHashFall = { -842959696 }
local CauseHashDrown = { -10959621, 1936677264 }
local CauseHashExplosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local CauseHashVehicle = { 133987706, -1553120962 }
local CauseHashVehicleRunOver = { -100946242, 148160082 }

local CauseHashMelee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local CauseHashKnife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060 }
local CauseHashBullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local CauseHashBurn = { 615608432, 883325847, -544306709 }

local function isCauseInList(hash, list)
	if not hash or hash == 0 then return false end
	for _, v in ipairs(list) do
		if v == hash then return true end
	end
	return false
end

function GetCauseOffDeath()
	local DeathReason = "cause inconnue"
	local killerServerId = nil
	if not IsEntityDead(PlayerPedId()) then
		return DeathReason, killerServerId
	end
	Wait(500)
	local playerPed = PlayerPedId()
	local DeathCauseHash = GetPedCauseOfDeath(playerPed)
	local PedKiller = GetPedSourceOfDeath(playerPed)
	local Killer = nil

	if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
		Killer = NetworkGetPlayerIndexFromPed(PedKiller)
	elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
		Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
	end
	if Killer and Killer == PlayerId() then
		return "s'est ~r~suicidée", killerServerId
	end
	if Killer and Killer ~= PlayerId() then
		killerServerId = GetPlayerServerId(Killer)
	end
	if IsEntityAPed(PedKiller) and not IsPedAPlayer(PedKiller) and PedKiller ~= 0 then
		killerServerId = 0
	end

	if isCauseInList(DeathCauseHash, CauseHashFall) then
		DeathReason = "est morte de ~r~chute"
	elseif isCauseInList(DeathCauseHash, CauseHashDrown) then
		DeathReason = "est morte ~r~noyée"
	elseif isCauseInList(DeathCauseHash, CauseHashExplosion) then
		DeathReason = "est morte ~r~d'une explosion"
	elseif isCauseInList(DeathCauseHash, CauseHashVehicle) or isCauseInList(DeathCauseHash, CauseHashVehicleRunOver) then
		DeathReason = "est morte ~r~écrasée par un véhicule"
	elseif isCauseInList(DeathCauseHash, CauseHashMelee) then
		DeathReason = "est morte ~r~de blessures en mêlée"
	elseif isCauseInList(DeathCauseHash, CauseHashKnife) then
		DeathReason = "est morte ~r~d'un coup de couteau"
	elseif isCauseInList(DeathCauseHash, CauseHashBullet) then
		DeathReason = "est morte ~r~pare-balles"
	elseif isCauseInList(DeathCauseHash, CauseHashBurn) then
		DeathReason = "est morte ~r~brûlée"

	elseif IsMelee(DeathCauseHash) then
		DeathReason = "est morte d'un ~r~coup de batte"
	elseif IsTorch(DeathCauseHash) then
		DeathReason = "est morte ~r~brûlée"
	elseif IsKnife(DeathCauseHash) then
		DeathReason = "est morte d'un ~r~coup de couteau"
	elseif IsPistol(DeathCauseHash) or IsSub(DeathCauseHash) or IsRifle(DeathCauseHash) or IsLight(DeathCauseHash) or IsShotgun(DeathCauseHash) or IsSniper(DeathCauseHash) or IsHeavy(DeathCauseHash) or IsMinigun(DeathCauseHash) then
		DeathReason = "est morte ~r~pare-balles"
	elseif IsBomb(DeathCauseHash) then
		DeathReason = "est morte ~r~d'une explosion"
	elseif IsVeh(DeathCauseHash) or IsVK(DeathCauseHash) then
		DeathReason = "est morte ~r~écrasée par un véhicule"

	elseif killerServerId ~= nil or (Killer and Killer ~= PlayerId()) then
		DeathReason = "est morte ~r~pare-balles"

	else
		DeathReason = "est morte de ~r~chute"
	end

	local killer = GetPedSourceOfDeath(playerPed)
	if IsEntityAVehicle(killer) then
		local maxPassengers = GetVehicleMaxNumberOfPassengers(killer)
		for seat = -1, maxPassengers - 1 do
			local passenger = GetPedInVehicleSeat(killer, seat)
			if passenger ~= 0 then
				local pedType = GetPedType(passenger)
				if pedType ~= 28 then
					if seat == -1 then
						DeathReason = "est morte ~r~écrasée par un véhicule"
					end
					break
				end
			end
		end
	end

	local faim, soif = exports["es_extended"]:whatisthisgoingon()
	if faim and soif and (tonumber(faim) <= 0 or tonumber(soif) <= 0) then
		DeathReason = "morte de faim"
	end

	return DeathReason, killerServerId
end
