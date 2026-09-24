ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
--ESX.TimeoutCallbacks          = {}

ESX.UI                        = {}
ESX.UI.HUD                    = {}
ESX.UI.HUD.RegisteredElements = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}

--ESX.SetTimeout = function(msec, cb)
--	table.insert(ESX.TimeoutCallbacks, {
--		time = GetGameTimer() + msec,
--		cb   = cb
--	})
--	return #ESX.TimeoutCallbacks
--end
--
--ESX.ClearTimeout = function(i)
--	ESX.TimeoutCallbacks[i] = nil
--end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.ShowNotification = function(msg)
	exports.bulletin:Send(msg)
end

ESX.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    exports.bulletin:SendAdvanced(msg, sender, subject, textureDict)
end

ESX.ShowHelpNotification = function(msg)
	AddTextEntry('esxHelpNotification', msg)
	BeginTextCommandDisplayHelp('esxHelpNotification')
	EndTextCommandDisplayHelp(0, false, true, -1)
end

-- =====================================================================
-- Hot path client : envoie un callback au serveur.
--
-- Optimisations :
--   * TriggerServerEvent localisé (économise le lookup _ENV).
--   * Wrap pcall sur la closure utilisateur dans le handler de réponse :
--     un bug dans une UI ne casse plus tout le système de callback.
--   * Tracking ts d'envoi par requestId pour expirer les callbacks
--     orphelins (resource serveur kill, network drop, etc.) — sinon
--     la table ESX.ServerCallbacks gonfle à chaque rotation 65k.
-- =====================================================================
local _TriggerServerEvent = TriggerServerEvent

-- ts ms d'envoi par requestId. Permet le GC périodique des orphans.
ESX._cbTimestamps = ESX._cbTimestamps or {}
local _cbTs = ESX._cbTimestamps
local CALLBACK_TIMEOUT_MS = 30000

ESX.TriggerServerCallback = function(name, cb, ...)
	local rid = ESX.CurrentRequestId
	ESX.ServerCallbacks[rid] = cb
	_cbTs[rid] = GetGameTimer()

	_TriggerServerEvent('esx:triggerServerCallback', name, rid, ...)

	if rid < 65535 then
		ESX.CurrentRequestId = rid + 1
	else
		ESX.CurrentRequestId = 0
	end
end

ESX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

ESX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(ESX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	ESX.UI.HUD.UpdateElement(name, data)
end

ESX.UI.HUD.RemoveElement = function(name)
	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			table.remove(ESX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

ESX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

ESX.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return mugshot, GetPedheadshotTxdString(mugshot)
end

ESX.Game.Teleport = function(entity, coords, cb)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end

	SetEntityCoords(entity, coords.x, coords.y, coords.z)

	if cb then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		print(('^2[NETDIAG][OBJET]^7 %s functions.lua:316 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb then
			cb(obj)
		end
	end)
end

ESX.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

ESX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		print(('^5[NETDIAG][VEHICLE]^7 %s functions.lua:354 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

ESX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

ESX.Game.GetClosestObject = function(filter, coords)
	local objects = ESX.Game.GetObjects()
	local closestDistance, closestObject = -1, -1
	local filter, coords = filter, coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
					break
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance = #(objectCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestObject = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end

ESX.Game.GetPlayers = function()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

ESX.Game.GetClosestPlayer = function(coords)
	local players, closestDistance, closestPlayer = ESX.Game.GetPlayers(), -1, -1
	local coords, usePlayerPed = coords, false
	local playerPed, playerId = PlayerPedId(), PlayerId()

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

ESX.Game.GetPlayersInArea = function(coords, area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

ESX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

ESX.Game.GetClosestVehicle = function(coords)
	local vehicles        = ESX.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

ESX.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

ESX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.Game.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

ESX.Game.GetClosestPed = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

ESX.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	-- ==========================================================================
	-- Livrée / stickers.
	--
	-- Le slot de mod 48 (`modLivery`) fait foi DÈS QUE le véhicule propose ce
	-- slot. On ne retombe sur l'API "livery" historique que pour les véhicules
	-- qui n'ont aucune variante de mod 48.
	--
	-- Avant : `if GetVehicleLivery(vehicle) ~= -1 then liv = GetVehicleLivery(vehicle) end`
	-- écrasait INCONDITIONNELLEMENT la valeur du slot 48. Sur un véhicule qui
	-- expose les deux API, retirer le sticker donnait bien -1 côté slot 48,
	-- mais GetVehicleLivery renvoyait encore 0 (= première livrée) : on
	-- enregistrait donc 0 en base au lieu de -1, et le sticker réapparaissait
	-- dès que le véhicule était rangé puis ressorti du garage.
	-- ==========================================================================
	local liv = GetVehicleMod(vehicle, 48)
	if GetNumVehicleMods(vehicle, 48) <= 0 then
		local legacyLiv = GetVehicleLivery(vehicle)
		if legacyLiv ~= -1 then
			liv = legacyLiv
		end
	end

    return {
        model             = GetEntityModel(vehicle),

		plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

		fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		dashboardColor    = GetVehicleDashboardColour(vehicle),
		interiorColor     = GetVehicleInteriorColour(vehicle),

		xenonColor = GetVehicleXenonLightsColor(vehicle),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
        modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = liv,
    }
end

ESX.Game.SetVehicleProperties = function(vehicle, props)
	SetVehicleModKit(vehicle, 0)

	-- Style de plaque AVANT le texte : re-poser le texte apres l'index force
	-- le re-rendu de la plaque avec le bon style. Un index negatif (des
	-- centaines de vehicules en base ont -1, valeur renvoyee pour un vehicule
	-- sans plaque) n'est jamais applique : il casserait le rendu.
	if props.plateIndex and tonumber(props.plateIndex) and tonumber(props.plateIndex) >= 0 then
		SetVehicleNumberPlateTextIndex(vehicle, math.floor(tonumber(props.plateIndex)))
	end

	if props.plate then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.bodyHealth then
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
	end

	if props.engineHealth then
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
	end

	if props.fuelLevel then
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
	end

	if props.dirtLevel then
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
	end

	if props.color1 then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.xenonColor then
		SetVehicleXenonLightsColor(vehicle, props.xenonColor)
	end

	if props.modSmokeEnabled then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.dashboardColor then
		--SetVehicleMod(vehicle, 29, props.modDashboard, false)
		SetVehicleDashboardColor(vehicle, props.dashboardColor)
	end

    if props.interiorColor then
		SetVehicleInteriorColor(vehicle, props.interiorColor)
	end

	if props.modDial then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	-- Livrée / stickers : cf. le bloc équivalent dans GetVehicleProperties.
	--
	-- `SetVehicleMod(vehicle, 48, -1)` ne RETIRE pas un mod (le natif attend un
	-- index valide) et `SetVehicleLivery(vehicle, -1)` est invalide. Un véhicule
	-- enregistré "sans sticker" ressortait donc du garage avec sa livrée
	-- précédente. Le retrait doit passer par RemoveVehicleMod.
	if props.modLivery ~= nil then
		if props.modLivery < 0 then
			RemoveVehicleMod(vehicle, 48)
		else
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

ESX.Game.Utils.DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	local cb = ESX.ServerCallbacks[requestId]
	ESX.ServerCallbacks[requestId] = nil
	_cbTs[requestId] = nil
	if not cb then return end
	-- Une exception dans le cb utilisateur ne doit plus casser ce dispatcher
	-- (sinon un seul resource bug peut bloquer toutes les UIs basées sur ESX).
	local ok, err = pcall(cb, ...)
	if not ok then
		print(('[es_extended] [^1ERR^7] callback rid=%s threw: %s'):format(tostring(requestId), tostring(err)))
	end
end)

-- GC périodique des callbacks orphelins (la table peut grossir si le
-- serveur ne répond jamais : resource crash, network drop, exploit).
-- Toutes les 30s, on purge tout cb dont l'envoi date de plus de 30s.
CreateThread(function()
	while true do
		Wait(30000)
		local now = GetGameTimer()
		local cbs = ESX.ServerCallbacks
		for rid, ts in pairs(_cbTs) do
			if (now - ts) > CALLBACK_TIMEOUT_MS then
				cbs[rid] = nil
				_cbTs[rid] = nil
			end
		end
	end
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
	ESX.ShowNotification(msg)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(title, subject, msg, icon, iconType)
	ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType)
end)

-- Paycheck consolide : 1 seul TriggerClientEvent au lieu de 3
-- (esx:showAdvancedNotification + esx:showNotification VIP + XNL_NET:AddPlayerXP).
-- Sur 800 joueurs et un cycle de paie de 6 min, on passe de ~3200
-- TriggerClientEvent serveur->client a ~800 par cycle (-75% d'overhead msgpack
-- + reseau pour la meme experience joueur).
-- _U('bank') / _U('received_paycheck') resolus paresseusement et caches.
-- Avant on payait ce lookup serveur-side a chaque paycheck par joueur.
local _PC_BANK_TITLE
local _PC_RECEIVED_TITLE

RegisterNetEvent('esx:paycheckPaid')
AddEventHandler('esx:paycheckPaid', function(amount, expBonus, vipLabel, isUnemployed)
	if not _PC_BANK_TITLE then
		if _U then
			local okBank, vBank = pcall(_U, 'bank')
			local okPaye, vPaye = pcall(_U, 'received_paycheck')
			_PC_BANK_TITLE = (okBank and vBank) or "Banque"
			_PC_RECEIVED_TITLE = (okPaye and vPaye) or "Paie reçue"
		else
			_PC_BANK_TITLE = "Banque"
			_PC_RECEIVED_TITLE = "Paie reçue"
		end
	end

	local body
	if _U then
		local key = isUnemployed and 'received_help' or 'received_salary'
		local ok, v = pcall(_U, key, amount)
		body = (ok and v) or (isUnemployed
			and ("Aide sociale : " .. tostring(amount) .. "$")
			or  ("Vous avez recu " .. tostring(amount) .. "$"))
	else
		body = (isUnemployed and "Aide sociale : " or "Vous avez recu ") .. tostring(amount) .. "$"
	end
	ESX.ShowAdvancedNotification(_PC_BANK_TITLE, _PC_RECEIVED_TITLE, body, 'CHAR_BANK_MAZE', 9)

	if vipLabel then
		ESX.ShowNotification("~g~Votre VIP vous a permis d'obtenir " .. vipLabel .. "$ supplémentaire !")
	end

	-- Met a jour la barre XP locale (XNL) ET le cache MEXP via l'event existant.
	-- On reutilise XNL_NET:AddPlayerXP en LOCAL pour ne pas dupliquer toute la
	-- logique de progression de niveau (level-up, animations, etc.).
	if expBonus and expBonus > 0 then
		TriggerEvent('XNL_NET:AddPlayerXP', expBonus)
	end
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg)
	ESX.ShowHelpNotification(msg)
end)


-- SetTimeout
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(0)
--		local currTime = GetGameTimer()
--
--		for i=1, #ESX.TimeoutCallbacks, 1 do
--			if ESX.TimeoutCallbacks[i] then
--				if currTime >= ESX.TimeoutCallbacks[i].time then
--					ESX.TimeoutCallbacks[i].cb()
--					ESX.TimeoutCallbacks[i] = nil
--				end
--			end
--		end
--	end
--end)