
local isLoadoutLoaded, isPaused, isPlayerSpawned, isDead = false, false, false, false
local isFirstSpawn = true
local lastLoadout, pickups = {}, {}
local states = {}
states.frozen = false
states.frozenPos = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer

	if Config.EnableHud then
		for k,v in ipairs(xPlayer.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'

			ESX.UI.HUD.RegisterElement('account_' .. v.name, k - 1, 0, accountTpl, {
				money = 0
			})

			ESX.UI.HUD.UpdateElement('account_' .. v.name, {
				money = ESX.Math.GroupDigits(v.money)
			})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if xPlayer.job.grade_label == '' then
			jobTpl = '<div>{{job_label}}</div>'
		end

		ESX.UI.HUD.RegisterElement('job', #xPlayer.accounts, 0, jobTpl, {
			job_label   = '',
			grade_label = ''
		})

		ESX.UI.HUD.UpdateElement('job', {
			job_label   = xPlayer.job.label,
			grade_label = xPlayer.job.grade_label
		})
	else
		TriggerEvent('es:setMoneyDisplay', 0.0)
	end
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

-- =========================================================================
-- RESTAURATION DE LA POSITION A LA CONNEXION
--
-- La Z sauvegardee est la SOURCE DE VERITE. Elle vient de
-- GetEntityCoords(GetPlayerPed(src)) cote SERVEUR (server/functions.lua,
-- _buildPlayerSaveQueries) : c'est donc la position d'un ped qui etait pose
-- sur un sol valide, interieur compris.
--
-- BUG CORRIGE (spawn sur le toit) : la sonde de sol partait de `lp.z + 100.0`.
-- GetGroundZFor_3dCoord descend depuis le point qu'on lui donne et renvoie le
-- PREMIER solide rencontre. Pour une deconnexion en interieur ou au pied d'un
-- immeuble (banque en bas d'une tour, parking, tunnel, sous un pont), ce
-- premier solide est le TOIT du batiment -> le joueur se reconnectait 40 m
-- au-dessus de la ou il s'etait deconnecte.
--
-- Deux aggravants se combinaient :
--   * le placement initial a `lp.z + 50.0` mettait volontairement le joueur
--     en l'air pendant le chargement de la collision ;
--   * le filet de rattrapage (thread 2 s) degelait le ped SANS condition en
--     plein chargement -> chute des 50 m, puis son test `z > lp.z + 10.0`
--     etait vrai et il re-snappait sur le toit.
--
-- MAINTENANT :
--   * placement direct a `lp.z` (le ped est gele, il ne peut pas traverser
--     le sol pendant que la collision charge) ;
--   * la sonde part de `lp.z + 1.0`. Comme le resultat ne peut JAMAIS etre
--     au-dessus du point de depart, remonter sur un toit est devenu
--     mathematiquement impossible ;
--   * le snap n'est accepte que s'il reste proche de la Z sauvegardee, sinon
--     on garde `lp.z` tel quel (interieur MLO non sondable, trou de decor) ;
--   * le filet de rattrapage n'intervient plus qu'apres expiration reelle de
--     la fenetre de spawn.
-- =========================================================================
local _spawnUnfreezeNeeded = false
local _spawnDeadline = 0
-- Snapshot de la position cible : le thread "Last position" plus bas ecrase
-- ESX.PlayerData.lastPosition toutes les secondes des que isPlayerSpawned
-- passe a true. Les filets de rattrapage doivent viser la position d'origine,
-- pas celle ou le joueur s'est retrouve entre-temps.
local _spawnTargetPos = nil

local SPAWN_Z_PROBE_OFFSET   = 1.0  -- depart de la sonde au-dessus de lp.z
local SPAWN_Z_SNAP_TOLERANCE = 3.0  -- ecart max tolere entre le sol trouve et lp.z

local function _resolveSpawnZ(lp)
	local found, groundZ = GetGroundZFor_3dCoord(lp.x, lp.y, lp.z + SPAWN_Z_PROBE_OFFSET, false)
	if found and math.abs(groundZ - lp.z) <= SPAWN_Z_SNAP_TOLERANCE then
		-- Ajustement fin : rattrape les quelques centimetres d'ecart dus a
		-- l'arrondi 0.1 de getLastPosition() cote serveur.
		return groundZ
	end
	-- Sonde inexploitable : la Z sauvegardee reste la meilleure valeur connue.
	return lp.z
end

local function _placeAtLastPosition(ped, lp)
	SetEntityCoords(ped, lp.x, lp.y, _resolveSpawnZ(lp), false, false, false, false)
end

AddEventHandler('playerSpawned', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	if isFirstSpawn and ESX.PlayerData.lastPosition then
		isFirstSpawn = false
		local saved = ESX.PlayerData.lastPosition
		local lp = { x = saved.x, y = saved.y, z = saved.z }
		_spawnTargetPos = lp
		_spawnUnfreezeNeeded = true
		_spawnDeadline = GetGameTimer() + 15000

		local ped = PlayerPedId()
		FreezeEntityPosition(ped, true)
		-- Placement direct a la Z sauvegardee (plus de `+ 50.0`) : le ped est
		-- gele, il ne tombera pas tant que la collision n'est pas chargee.
		SetEntityCoords(ped, lp.x, lp.y, lp.z, false, false, false, false)
		RequestCollisionAtCoord(lp.x, lp.y, lp.z)

		local timeout = GetGameTimer() + 8000
		while not HasCollisionLoadedAroundEntity(PlayerPedId()) and GetGameTimer() < timeout do
			RequestCollisionAtCoord(lp.x, lp.y, lp.z)
			Citizen.Wait(100)
		end

		Citizen.Wait(500)

		-- Collision chargee : on affine, le ped a pu etre pose quelques
		-- centimetres dans le decor.
		local finalPed = PlayerPedId()
		_placeAtLastPosition(finalPed, lp)
		FreezeEntityPosition(finalPed, false)
		_spawnUnfreezeNeeded = false
	else
		isFirstSpawn = false
	end

	isLoadoutLoaded, isPlayerSpawned, isDead = true, true, false
end)

-- Filet de securite : garantit qu'un joueur ne reste jamais gele si la
-- sequence ci-dessus est interrompue (erreur Lua, ped recree par le
-- skinchanger, resource redemarree en pleine session).
--
-- Ne se declenche qu'apres `_spawnDeadline` : avant, ce thread degelait le ped
-- toutes les 2 s en plein chargement de collision, ce qui faisait tomber le
-- joueur et declenchait le re-snap sur le toit.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if _spawnUnfreezeNeeded and GetGameTimer() > _spawnDeadline then
			local lp = _spawnTargetPos
			local ped = PlayerPedId()

			if lp then
				local pCoords = GetEntityCoords(ped)
				-- abs() et plus `> lp.z + 10.0` : on rattrape aussi bien le
				-- joueur reste en l'air que celui passe sous le decor.
				if math.abs(pCoords.z - lp.z) > 10.0 then
					RequestCollisionAtCoord(lp.x, lp.y, lp.z)
					Citizen.Wait(500)
					ped = PlayerPedId()
					_placeAtLastPosition(ped, lp)
				end
			end

			FreezeEntityPosition(ped, false)
			_spawnUnfreezeNeeded = false
		end
	end
end)

-- Le skinchanger remplace le ped (nouveau modele) : le nouveau ped n'herite ni
-- de la position ni du freeze de l'ancien, on reapplique les deux.
--
-- Il ne DEGELE plus et ne clot plus la sequence de spawn : avant, il pouvait
-- rendre la main au joueur alors que la collision n'etait pas encore chargee.
-- C'etait sans consequence visible tant que le ped etait place a `lp.z + 50.0`
-- (il tombait simplement), ca ne l'est plus maintenant qu'on le pose
-- directement a la Z sauvegardee : il traverserait le decor. Le degel reste
-- la responsabilite de la sequence principale (ou du filet de securite).
AddEventHandler('skinchanger:modelLoaded', function()
	if not _spawnUnfreezeNeeded then return end

	Citizen.Wait(1000)
	local lp = _spawnTargetPos
	if not lp or not _spawnUnfreezeNeeded then return end

	RequestCollisionAtCoord(lp.x, lp.y, lp.z)
	Citizen.Wait(500)
	-- La sequence principale a pu se terminer pendant ces attentes : dans ce
	-- cas le joueur a deja la main, on ne le regele surtout pas.
	if not _spawnUnfreezeNeeded then return end

	local ped = PlayerPedId()
	FreezeEntityPosition(ped, true)
	_placeAtLastPosition(ped, lp)
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	isLoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, new)
	if new then 
		table.insert(ESX.PlayerData.inventory, item)
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	else
		for k,v in ipairs(ESX.PlayerData.inventory) do
			local same = exports["inventaire"]:GetSameMetadatas(item.metadatas, v.metadatas)
			if v.name == item.name and same then
				ESX.PlayerData.inventory[k] = item
				ESX.UI.ShowInventoryItemNotification(true, item, count)
				break
			end
		end
	end
end)

RegisterNetEvent('esx:setInventoryItem')
AddEventHandler('esx:setInventoryItem', function(index, item, data)
	if ESX.PlayerData.inventory[index] ~= nil and ESX.PlayerData.inventory[index].name == item then 
		ESX.PlayerData.inventory[index] = data
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, name, metadatas)
	for k,v in pairs(ESX.PlayerData.inventory) do
		if item ==  nil then
			local same = exports["inventaire"]:GetSameMetadatas(metadatas, v.metadatas)
			if v.name == name and same then
				if GetHashKey(name) ~= nil then
					RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
				end
				table.remove(ESX.PlayerData.inventory, k)
				break
			end
		else
			if v.name == item.name then
				local same = exports["inventaire"]:GetSameMetadatas(metadatas, v.metadatas)
				if same then
					if GetHashKey(item.name) ~= nil then
						RemoveWeaponFromPed(PlayerPedId(), GetHashKey(item.name))
					end
					ESX.PlayerData.inventory[k] = item
					break
				end
			end
		end
		
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setRank')
AddEventHandler('esx:setRank', function(rank)
  ESX.PlayerData.rank = rank
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, playerId, type, name, components)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	local entityCoords, forward, pickupObject = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
	local objectCoords = (entityCoords + forward * 1.0)

	if type == 'item_weapon' then
		ESX.Streaming.RequestWeaponAsset(GetHashKey(name))
		pickupObject = CreateWeaponObject(GetHashKey(name), 50, objectCoords, true, 1.0, 0)

		for k,v in ipairs(components) do
			local component = ESX.GetWeaponComponent(name, v)
			GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
		end
	else
		ESX.Game.SpawnLocalObject('prop_money_bag_01', objectCoords, function(obj)
			pickupObject = obj
		end)

		while not pickupObject do
			Citizen.Wait(10)
		end
	end

	SetEntityAsMissionEntity(pickupObject, true, false)
	PlaceObjectOnGroundProperly(pickupObject)
	FreezeEntityPosition(pickupObject, true)

	pickups[pickupId] = {
		id = pickupId,
		obj = pickupObject,
		label = label,
		inRange = false,
		coords = objectCoords
	}
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		local pickupObject = nil

		if pickup.type == 'item_weapon' then
			ESX.Streaming.RequestWeaponAsset(GetHashKey(pickup.name))
			pickupObject = CreateWeaponObject(GetHashKey(pickup.name), 50, pickup.coords.x, pickup.coords.y, pickup.coords.z, true, 1.0, 0)

			for k,componentName in ipairs(pickup.components) do
				local component = ESX.GetWeaponComponent(pickup.name, componentName)
				GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
			end
		else
			ESX.Game.SpawnLocalObject('prop_money_bag_01', pickup.coords, function(obj)
				pickupObject = obj
			end)

			while not pickupObject do
				Citizen.Wait(10)
			end
		end

		SetEntityAsMissionEntity(pickupObject, true, false)
		PlaceObjectOnGroundProperly(pickupObject)
		FreezeEntityPosition(pickupObject, true)

		pickups[pickupId] = {
			id = pickupId,
			obj = pickupObject,
			label = pickup.label,
			inRange = false,
			coords = vector3(pickup.coords.x, pickup.coords.y, pickup.coords.z)
		}
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	ESX.Game.DeleteObject(pickups[id].obj)
	pickups[id] = nil
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
    local playerPed = PlayerPedId()
	
	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
		local vehs = {}
		for k,v in pairs(vehicles) do
			table.insert(vehs, NetworkGetNetworkIdFromEntity(v))
		end
		TriggerServerEvent("DeleteEntityTable", vehs)
	else
		local radius = 1.5
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
		local vehs = {}
		for k,v in pairs(vehicles) do
			table.insert(vehs, NetworkGetNetworkIdFromEntity(v))
		end
		TriggerServerEvent("DeleteEntityTable", vehs)
	end
end)

RegisterNetEvent('esx:deleteObjects')
AddEventHandler('esx:deleteObjects', function(radius)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local objects = {}

	radius = radius + 0.01

	for _, obj in pairs(GetGamePool('CObject')) do
		if #(GetEntityCoords(obj) - coords) <= radius then
			table.insert(objects, NetworkGetNetworkIdFromEntity(obj))
		end
	end

	TriggerServerEvent("DeleteEntityTable", objects)
end)

RegisterNetEvent('esx:deletePeds')
AddEventHandler('esx:deletePeds', function(radius)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local peds = {}

	radius = radius + 0.01

	for _, ped in pairs(GetGamePool('CPed')) do
		if ped ~= playerPed and #(GetEntityCoords(ped) - coords) <= radius then
			table.insert(peds, NetworkGetNetworkIdFromEntity(ped))
		end
	end

	TriggerServerEvent("DeleteEntityTable", peds)
end)

-- Pickups: thread allégé.
-- Avant: Wait(0) systématique avant le for, puis Wait(500) seulement si aucun pickup proche
-- → consomme 1 frame complet à chaque tick même quand `pickups` est vide ou loin.
-- Après: on commence par dormir (Wait(500)), on bascule à Wait(0) UNIQUEMENT quand un pickup
-- est dans le rayon de rendu (< 5m). Pas d'appel à GetClosestPlayer si aucun pickup proche.
Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if next(pickups) then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local needClosest = false

			-- 1er pass: décide si on doit faire Wait(0) (au moins 1 pickup à portée)
			for _, v in pairs(pickups) do
				if #(playerCoords - v.coords) < 5 then
					needClosest = true
					break
				end
			end

			if needClosest then
				sleep = 0
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				for _, v in pairs(pickups) do
					local distance = #(playerCoords - v.coords)
					if distance < 5 then
						local label = v.label
						if distance < 1 then
							if IsControlJustReleased(0, 38) then
								if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not v.inRange then
									v.inRange = true
									local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
									ESX.Streaming.RequestAnimDict(dict)
									TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
									Citizen.Wait(1000)
									TriggerServerEvent('esx:onPickup', v.id)
									PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
								end
							end
							label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
						end
						ESX.Game.Utils.DrawText3D({
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z + 0.25
						}, label, 1.2, 1)
					elseif v.inRange then
						v.inRange = false
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if ESX.PlayerLoaded and isPlayerSpawned then
			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = GetEntityCoords(playerPed, false)
			end
		end

		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)

function GetCurrentWeight()
    local currentWeight = 0
    for i = 1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
            currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
        end
    end
    return currentWeight
end

CreateThread(function()
	while true do
		Wait(1000)
		local playerPed = PlayerPedId()
		local weapon = GetSelectedPedWeapon(playerPed)
		if weapon ~= nil and weapon ~= -1569615261 then
			SetFlashLightKeepOnWhileMoving(true)
		end
	end
end)