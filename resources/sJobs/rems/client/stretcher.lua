strNames = { 'v_med_bed1', 'v_med_bed2','fernocot'}
strHashes = {}
animDict = 'missfbi5ig_0'
animName = 'lyinginpain_loop_steve'
isOnstr = false

local strTable = {}

local STRETCHER_SEARCH_RADIUS = 7.0
local STRETCHER_PICKUP_MAX_DIST = 2.5

Citizen.CreateThread(function()
    for k,v in ipairs(strNames) do
        table.insert( strHashes, GetHashKey(v))
    end
end)

local open = false
RegisterNetEvent("ARPF-EMS:opendoors")
AddEventHandler("ARPF-EMS:opendoors", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedCoords)
    if open == false then
        open = true
        SetVehicleDoorOpen(veh, 2, false, false)
        Citizen.Wait(1000)
        SetVehicleDoorOpen(veh, 3, false, false)
    elseif open == true then
        open = false
        SetVehicleDoorShut(veh, 2, false)
        SetVehicleDoorShut(veh, 3, false)
    end
end)

local incar = false
RegisterNetEvent("ARPF-EMS:togglestrincar")
AddEventHandler("ARPF-EMS:togglestrincar", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedCoords)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, STRETCHER_SEARCH_RADIUS, GetHashKey("fernocot"), false)

    local stretcherInVeh = false
    if DoesEntityExist(closestObject) and closestObject ~= 0 and DoesEntityExist(veh) then
        if IsEntityAttachedToAnyVehicle(closestObject) or IsEntityAttachedToEntity(closestObject, veh) then
            stretcherInVeh = true
        end
    end

    if stretcherInVeh then
        StretcheroutCar()
    else
        StreachertoCar()
    end
end)

-- Rangement d'une entite (brancard / fauteuil roulant) : delegue au serveur,
-- qui peut supprimer l'entite meme si ce client n'en a pas le controle.
function StoreEmsEntity(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        ESX.ShowNotification("~y~Rien à ranger ici.")
        return
    end
    if not NetworkGetEntityIsNetworked(entity) then
        -- Entite locale (jamais le cas normalement) : on supprime nous-memes.
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
        return
    end
    local ped = PlayerPedId()
    if IsEntityAttachedToEntity(entity, ped) then
        DetachEntity(entity, true, true)
        ClearPedTasks(ped)
    end
    if IsEntityAttachedToEntity(ped, entity) then
        DetachEntity(ped, true, true)
        ClearPedTasks(ped)
    end
    TriggerServerEvent("rems:storeEntity", NetworkGetNetworkIdFromEntity(entity))
end

RegisterNetEvent("ARPF-EMS:deletestr")
AddEventHandler("ARPF-EMS:deletestr", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, STRETCHER_SEARCH_RADIUS, GetHashKey("fernocot"), false)
    StoreEmsEntity(closestObject)
end)

-- Le serveur va supprimer cette entite : si on y est attache (on la pousse
-- ou on est allonge dessus), on se detache d'abord pour ne pas rester
-- bloque en animation.
RegisterNetEvent("rems:entityStored")
AddEventHandler("rems:entityStored", function(netId)
    if not NetworkDoesNetworkIdExist(netId) then return end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return end
    local ped = PlayerPedId()
    if IsEntityAttachedToEntity(ent, ped) then
        DetachEntity(ent, true, true)
        ClearPedTasks(ped)
        SetPedMoveRateOverride(ped, 1.0)
    end
    if IsEntityAttachedToEntity(ped, ent) then
        DetachEntity(ped, true, true)
        ClearPedTasks(ped)
    end
end)

function StreachertoCar()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedCoords)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 3.0, GetHashKey("fernocot"), false)

    if not DoesEntityExist(closestObject) or closestObject == 0 then return end
    if GetVehiclePedIsIn(ped, false) ~= 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then return end

    NetworkRequestControlOfEntity(closestObject)

    if IsEntityAttachedToEntity(closestObject, ped) then
        DetachEntity(closestObject, true, true)
        ClearPedTasks(ped)
        Citizen.Wait(150)
    end

    SetEntityCollision(closestObject, false, false)
    incar = true
    AttachEntityToEntity(closestObject, veh, 0, 0.0, -1.6, -0.15, 0.0, 0.0, 90.0, false, false, true, false, 2, true)
    FreezeEntityPosition(closestObject, true)
end

function StretcheroutCar()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedCoords)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, STRETCHER_SEARCH_RADIUS, GetHashKey("fernocot"), false)

    if not DoesEntityExist(closestObject) or closestObject == 0 then return end
    if GetVehiclePedIsIn(ped, false) ~= 0 or not DoesEntityExist(veh) or not IsEntityAVehicle(veh) then return end

    incar = false
    DetachEntity(closestObject, true, true)
    Citizen.Wait(50)
    local coords = GetEntityCoords(closestObject, false)
    SetEntityCoords(closestObject, coords.x - 3.0, coords.y, coords.z, false, false, false, false)
    PlaceObjectOnGroundProperly(closestObject)
    SetEntityCollision(closestObject, true, true)
end

RegisterNetEvent("ARPF-EMS:spawnStr")
AddEventHandler("ARPF-EMS:spawnStr", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey("fernocot"), false)

    if closestObject == 0 then
        LoadModel('fernocot')
        print(('^2[NETDIAG][OBJET]^7 %s stretcher.lua:118 CreateObject NETWORKED fernocot'):format(GetCurrentResourceName()))
        local str = CreateObject(GetHashKey('fernocot'), -679.07659912109, 332.25115966797, 77.122634887695, true)
    else
	    ESX.ShowNotification("Un brancard est déja sur zone !")
    end
end)

RegisterNetEvent("ARPF-EMS:stretcherSync")
AddEventHandler("ARPF-EMS:stretcherSync", function(tableUpdate)
	strTable = tableUpdate
end)

local changed = false
local _lastStretcherSync = 0
Citizen.CreateThreadNow(function()
	while true do
		TableID = 0
		local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 5.0, GetHashKey("fernocot"), false)
        local ambuNear = false
        if DoesEntityExist(closestObject) then
            ambuNear = true
            local strCoords = GetEntityCoords(closestObject)
            for i,v in ipairs(strTable) do
			 	local strobj = v['obj']
				if strobj == closestObject then
					TableID = i
				elseif strobj ~= closestObject and TableID <= 0 then
					TableID = -1
				end
			end
			if TableID == -1 then
				local now = GetGameTimer()
				if now - _lastStretcherSync > 2000 then
					_lastStretcherSync = now
					local attachedToWhat = GetEntityAttachedTo(closestObject) and not nil or "none"
					local state = 2
					local tableNum = -1
					local what = attachedToWhat
					local sync = false
					TriggerServerEvent("ARPF-EMS:server:stretcherSync",state,tableNum,what,sync)
				end
			elseif TableID > 0 then
			end

			for k,u in pairs(strTable) do
        		local strobj = strTable[k]['obj']
        		if DoesEntityExist(strobj) then
        		 	local pedCoords = GetEntityCoords(ped)
					local strCoords = GetEntityCoords(closestObject)
					local distances = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, strCoords.x, strCoords.y, strCoords.z, true)
        			local attachedToWhat = GetEntityAttachedTo(strobj) and not nil or "none"
		        if 	distances < 5 then
		        	if IsEntityAttachedToAnyPed(strobj) or IsEntityAttachedToAnyVehicle(strobj) or IsEntityAttachedToAnyObject(strobj) then
						if attachedToWhat ~= v['to'] then
							v['to'] = attachedToWhat
							local changed = true
						end
					else
						if attachedToWhat == v['to'] then
							local change = false
						end
					end
				end
        	end
        	end
        end

        if ambuNear then
            Citizen.Wait(100)
        else
            Citizen.Wait(1000)
        end
	end
end)

RegisterNetEvent("ARPF-EMS:pushstreacherss")
AddEventHandler("ARPF-EMS:pushstreacherss", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, STRETCHER_SEARCH_RADIUS, GetHashKey("fernocot"), false)

    if not DoesEntityExist(closestObject) or closestObject == 0 then
        ESX.ShowNotification("~y~Aucun brancard à proximité")
        return
    end

    local strCoords = GetEntityCoords(closestObject)
    local distToStretcher = #(pedCoords - strCoords)

    if IsEntityAttachedToAnyVehicle(closestObject) then
        if GetVehiclePedIsIn(ped, false) ~= 0 then
            ESX.ShowNotification("~y~Sortez de l'ambulance pour sortir ou pousser le brancard")
            return
        end
        local veh = GetEntityAttachedTo(closestObject)
        if DoesEntityExist(veh) and IsEntityAVehicle(veh) then
            local vehCoords = GetEntityCoords(veh)
            if #(pedCoords - vehCoords) <= 6.0 then
                TriggerEvent("ARPF-EMS:togglestrincar")
            else
                ESX.ShowNotification("~y~Approchez-vous de l'arrière de l'ambulance pour sortir le brancard")
            end
        end
        return
    end

    local strVecForward = GetEntityForwardVector(closestObject)
    local pickupCoords = strCoords + strVecForward * 0.3
    if #(pedCoords - pickupCoords) <= STRETCHER_PICKUP_MAX_DIST then
        PickUp(closestObject)
    else
        ESX.ShowNotification(("~y~Approchez-vous du brancard (~s~%d m~y~)"):format(math.ceil(distToStretcher)))
    end
end)

RegisterNetEvent("ARPF-EMS:getintostretcher")
AddEventHandler("ARPF-EMS:getintostretcher", function()
    local pP = PlayerPedId()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestObject = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, STRETCHER_SEARCH_RADIUS, GetHashKey("fernocot"), false)

    if DoesEntityExist(closestObject) then
        local strCoords = GetEntityCoords(closestObject)
        local strVecForward = GetEntityForwardVector(closestObject)
        local sitCoords = (strCoords + strVecForward * - 0.5)
        local pickupCoords = (strCoords + strVecForward * 0.3)

        if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 2.0 then
            TriggerEvent('sit', closestObject)
        end
    end
end)

function revivePed(ped)
    local playerPos = GetEntityCoords(ped, true)
    NetworkResurrectLocalPlayer(playerPos, true, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
end

local inBedDicts = "anim@gangops@morgue@table@"
local inBedAnims = "ko_front"

RegisterNetEvent('sit')
AddEventHandler('sit', function(strObject)
    local closestPlayer, closestPlayerDist = GetClosestPlayer()
    local playPed = PlayerPedId()

    if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), inBedDicts, inBedAnims, 3) then
            ESX.ShowNotification("Quelqu'un utilise déja le brancard !")
            return
        end
    end

    LoadAnim(inBedDicts)
    if IsPedDeadOrDying(playPed) then
        revivePed(playPed)
        AttachEntityToEntity(PlayerPedId(), strObject, 0, 0, 0.0, 2.1, 0.0, 0.0, 270.0, 0.0, false, false, false, false, 2, true)
        local heading = GetEntityHeading(strObject)
        wasdead = true
        while IsEntityAttachedToEntity(PlayerPedId(), strObject) do
            Citizen.Wait(0)

            if IsPedDeadOrDying(PlayerPedId()) then
                DetachEntity(PlayerPedId(), true, true)
            end

            if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 3) then
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
            end

            if IsControlPressed(0, 32) then
                PlaceObjectOnGroundProperly(strObject)
            end

            if IsControlJustPressed(0, 73) then
                TriggerEvent("unsit", strObject)
            end
        end
    elseif not IsPedDeadOrDying(playPed) then
        AttachEntityToEntity(PlayerPedId(), strObject, 0, 0, 0.0, 2.1, 0.0, 0.0, 270.0, 0.0, false, false, false, false, 2, true)
        local heading = GetEntityHeading(strObject)
        wasdead = false
        while IsEntityAttachedToEntity(PlayerPedId(), strObject) do
            Citizen.Wait(0)

            DrawGenericTextThisFrame()
            SetTextEntry("STRING")
            AddTextComponentString("Appuyez sur ~o~X~s~ pour sortir du lit")
            DrawText(0.5, 0.92)

            if IsPedDeadOrDying(PlayerPedId()) then
                DetachEntity(PlayerPedId(), true, true)
            end

            if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 3) then
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
            end

            if IsControlPressed(0, 32) then
                PlaceObjectOnGroundProperly(strObject)
            elseif IsControlJustPressed(0, 73) then
                TriggerEvent("unsit", strObject)
            end
        end
    end
end)

RegisterNetEvent('unsit')
AddEventHandler('unsit', function(strObject)
    if wasdead == true then
        pedss = PlayerPedId()
        DetachEntity(PlayerPedId(), true, true)
        local x, y, z = table.unpack(GetEntityCoords(strObject) + GetEntityForwardVector(strObject) * - 0.7)
        SetEntityCoords(PlayerPedId(), x,y,z)
        hels = GetEntityHealth(pedss)
        SetEntityHealth(pedss, hels -200)
        wasdead = false
    elseif wasdead == false then
        DetachEntity(PlayerPedId(), true, true)
        local x, y, z = table.unpack(GetEntityCoords(strObject) + GetEntityForwardVector(strObject) * - 0.7)
        SetEntityCoords(PlayerPedId(), x,y,z)
    end
end)

function PickUp(strObject)
    local closestPlayer, closestPlayerDist = GetClosestPlayer()

    if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
            ESX.ShowNotification("Quelqu'un pousse déja le brancard !")
            return
        end
    end

    NetworkRequestControlOfEntity(strObject)

    LoadAnim("anim@heists@box_carry@")
    local pedid = PlayerPedId()
    AttachEntityToEntity(strObject, pedid, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.9, -1.43, 180.0, 170.0, 90.0, 0.0, false, false, true, false, 2, true)

    while IsEntityAttachedToEntity(strObject, pedid) do
        Citizen.Wait(0)

        DrawGenericTextThisFrame()
        SetTextEntry("STRING")
        AddTextComponentString("Appuyez sur ~o~X~s~ pour arrêter de pousser le lit")
        DrawText(0.5, 0.92)

		SetPedMoveRateOverride(PlayerPedId(), 0.75)
		DisableControlAction(0, 22, true)

        if not IsEntityPlayingAnim(pedid, 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(pedid, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        if IsPedDeadOrDying(pedid) or IsControlJustPressed(0, 73) then
            local dropCoords = GetOffsetFromEntityInWorldCoords(pedid, 0.0, 1.2, 0.0)
            DetachEntity(strObject, true, true)
            SetEntityCoords(strObject, dropCoords.x, dropCoords.y, dropCoords.z, false, false, false, false)
            PlaceObjectOnGroundProperly(strObject)
            SetEntityCollision(strObject, true, true)
            break
        end
    end
    ClearPedTasks(pedid)
    SetPedMoveRateOverride(pedid, 1.0)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 1.2)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function GetPlayers()
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetVehicles()
	local vehicles = {}
	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end
	return vehicles
end

function GetClosestVehicle(coords)
	local vehicles = GetVehicles()
	local closestDistance = -1
	local closestVehicle = -1
	coords = coords or GetEntityCoords(PlayerPedId())

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle, closestDistance
end

function IsCarryingStretcher()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.5, GetHashKey("fernocot"), false)
	if not DoesEntityExist(obj) or obj == 0 then return false end
	return IsEntityAttachedToEntity(obj, ped)
end

Citizen.CreateThread(function()
	if GetResourceState('ox_target') ~= 'started' then return end
	exports.ox_target:addGlobalPlayer({
		{
			name = 'rems_put_on_stretcher',
			icon = 'fas fa-bed',
			label = 'Mettre sur le brancard',
			canInteract = function(entity, distance, coords, name, bone)
				if entity == PlayerPedId() then return false end
				if not IsPedAPlayer(entity) then return false end
				if distance > 3.0 then return false end
				return IsCarryingStretcher()
			end,
			onSelect = function(data)
				local targetPed = data.entity
				local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
				if targetServerId and targetServerId > 0 then
					TriggerServerEvent('ems:bringPpToStretch', targetServerId)
				end
			end
		}
	})
end)
