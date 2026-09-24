local Models = nil
local PolyZones = nil
ESX = nil

local metadata = {
	isSitting = false,
	isLaying = false,
	entity = 0,
	poly = false,
	type = nil,
	lastPos = nil,
	targetPos = nil,
	teleportOut = false,
	unregister = false,
	doingTaskGo = false,
	frozen = false,
	plyFrozen = false,
	animation = {},
	scenario = false
}

local sittingScenarios = {
	"WORLD_HUMAN_SEAT_LEDGE", "WORLD_HUMAN_SEAT_LEDGE_EATING", "WORLD_HUMAN_SEAT_STEPS", "WORLD_HUMAN_SEAT_WALL", "WORLD_HUMAN_SEAT_WALL_EATING", "WORLD_HUMAN_SEAT_WALL_TABLET",
	"PROP_HUMAN_SEAT_ARMCHAIR", "PROP_HUMAN_SEAT_BAR", "PROP_HUMAN_SEAT_BENCH", "PROP_HUMAN_SEAT_BENCH_FACILITY", "PROP_HUMAN_SEAT_BENCH_DRINK", "PROP_HUMAN_SEAT_BENCH_DRINK_FACILITY",
	"PROP_HUMAN_SEAT_BENCH_DRINK_BEER", "PROP_HUMAN_SEAT_BENCH_FOOD", "PROP_HUMAN_SEAT_BENCH_FOOD_FACILITY", "PROP_HUMAN_SEAT_BUS_STOP_WAIT", "PROP_HUMAN_SEAT_CHAIR",
	"PROP_HUMAN_SEAT_CHAIR_DRINK", "PROP_HUMAN_SEAT_CHAIR_DRINK_BEER", "PROP_HUMAN_SEAT_CHAIR_FOOD", "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",
	"PROP_HUMAN_SEAT_COMPUTER", "PROP_HUMAN_SEAT_COMPUTER_LOW", "PROP_HUMAN_SEAT_DECKCHAIR", "PROP_HUMAN_SEAT_DECKCHAIR_DRINK", "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS",
	"PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS_PRISON", "PROP_HUMAN_SEAT_SEWING", "PROP_HUMAN_SEAT_STRIP_WATCH", "PROP_HUMAN_SEAT_SUNLOUNGER"
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local function DisplayNativeNotification(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(false, false)
end

local function LoadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

local function GetAmountOfSeats(model)
	return #Models[model].sit.seats
end

local function GetNearbyPeds()
	local handle, ped = FindFirstPed()
	local success = false
	local peds = {}
	repeat
		peds[#peds+1] = ped
		success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)
	return peds
end

local function GetDifference(num1, num2)
	if num1 > num2 then
		return num1 - num2
	else
		return num2 - num1
	end
end

local function HandleLooseEntity(entity)
	if not IsEntityPositionFrozen(entity) then
		if not NetworkGetEntityIsNetworked(entity) then
			print(('^1[NETDIAG][NETREG]^7 %s cl_sit.lua:80 NetworkRegisterEntityAsNetworked(%s)'):format(GetCurrentResourceName(), tostring(entity)))
			NetworkRegisterEntityAsNetworked(entity)
			metadata.unregister = true
		end
		NetworkRequestControlOfEntity(entity)
		FreezeEntityPosition(entity, true)
		metadata.frozen = true
	end
end

local function UnhandleLooseEntity(entity)
	if metadata.frozen then
		FreezeEntityPosition(entity, false)
		if metadata.unregister then
			NetworkUnregisterNetworkedEntity(entity)
			metadata.unregister = false
		end
		metadata.frozen = false
	end
end

local function HeadingToRotation(heading)
    local rotation = heading
    if rotation > 180.0 then
        rotation = 180.0 - GetDifference(rotation, 180.0)
        rotation = rotation*-1
    end
    return rotation
end

local function GetOffsetFromCoordsInWorldCoords(position, rotation, offset)
    local rotX, rotY, rotZ = math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z)
    local matrix = {}

    matrix[1] = {}
    matrix[1][1] = math.cos(rotZ) * math.cos(rotY) - math.sin(rotZ) * math.sin(rotX) * math.sin(rotY)
    matrix[1][2] = math.cos(rotY) * math.sin(rotZ) + math.cos(rotZ) * math.sin(rotX) * math.sin(rotY)
    matrix[1][3] = -math.cos(rotX) * math.sin(rotY)
    matrix[1][4] = 1

    matrix[2] = {}
    matrix[2][1] = -math.cos(rotX) * math.sin(rotZ)
    matrix[2][2] = math.cos(rotZ) * math.cos(rotX)
    matrix[2][3] = math.sin(rotX)
    matrix[2][4] = 1

    matrix[3] = {}
    matrix[3][1] = math.cos(rotZ) * math.sin(rotY) + math.cos(rotY) * math.sin(rotZ) * math.sin(rotX)
    matrix[3][2] = math.sin(rotZ) * math.sin(rotY) - math.cos(rotZ) * math.cos(rotY) * math.sin(rotX)
    matrix[3][3] = math.cos(rotX) * math.cos(rotY)
    matrix[3][4] = 1

    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = position.x, position.y, position.z
    matrix[4][4] = 1

    local x = offset.x * matrix[1][1] + offset.y * matrix[2][1] + offset.z * matrix[3][1] + matrix[4][1]
    local y = offset.x * matrix[1][2] + offset.y * matrix[2][2] + offset.z * matrix[3][2] + matrix[4][2]
    local z = offset.x * matrix[1][3] + offset.y * matrix[2][3] + offset.z * matrix[3][3] + matrix[4][3]

    return vector3(x, y, z)
end

local function IsEntityPlayingAnyLayAnim(entity)
	local checked = {}
	for type, settings in pairs(ConfigSit.LayTypes) do
		local anim = settings.animation
		if not checked[anim.dict] then
			if IsEntityPlayingAnim(entity, anim.dict, anim.name, 3) then
				return true
			else
				checked[anim.dict] = true
			end
		end
	end
	return false
end

local function IsPedSitting(ped)
	local checked = {}
	for index, scenario in pairs(sittingScenarios) do
		if IsPedUsingScenario(ped, scenario) then
			return true
		end
	end
	return false
end

local function IsSeatAvailable(coords, action)
	local playerPed = PlayerPedId()
	for index, ped in pairs(GetNearbyPeds()) do
		if ped ~= playerPed then
			local dist = #(GetEntityCoords(ped)-coords)
			if dist < 1.35 then
				if action == 'sit' then
					if IsEntityPlayingAnyLayAnim(ped) or dist < 0.55 then
						return false
					end
				elseif action == 'lay' then
					if IsEntityPlayingAnyLayAnim(ped) or IsPedSitting(ped) then
						return false
					end
				end
			end
		end
	end
	return true
end

local function SeatSort(a, b)
    return a.dist < b.dist
end

local function SortSeatsByDistance(seatCoords, seatHeading, seatOffsets, raycast)
    local seats = {}
    local coords = GetEntityCoords(PlayerPedId())
	local rotation = vector3(0.0, 0.0, HeadingToRotation(seatHeading))

	if raycast and ConfigSit.Target and ConfigSit.UseTargetingCoords then
		local flag = -1
		local hit, endCoords, entityHit, entityType = false, nil, nil, nil
		if ConfigSit.Target == 'qtarget' then
			hit, endCoords, entityHit, entityType = exports.qtarget:raycast(flag)
		else
			hit, endCoords, entityHit, entityType = exports['qb-target']:RaycastCamera(flag)
		end

		if endCoords and endCoords ~= vector3(0.0, 0.0, 0.0) then
			coords = endCoords
		end
	end

    for k, v in pairs(seatOffsets) do
        seats[k] = {}
        seats[k].coords = GetOffsetFromCoordsInWorldCoords(seatCoords, rotation, v)
        seats[k].dist = #(coords-seats[k].coords)
		seats[k].offset = v
    end
    table.sort(seats, SeatSort)

    return seats
end

local function GetAvailableSeat(seatCoords, seatHeading, seats, raycast)
	local coords = nil
    local offset = nil
	local heading = nil
	local sortedSeats = SortSeatsByDistance(seatCoords, seatHeading, seats, raycast)

	for index, data in pairs(sortedSeats) do
		if IsSeatAvailable(data.coords, 'sit') then
			offset = data.offset
			coords = data.coords
			heading = seatHeading

			heading = heading + offset.w
			if heading > 360.0 then
				heading = heading - 360.0
			end
			break
		end
	end

	return coords, offset, heading
end

local function LeaveSeat(clearTask, clearTaskImmediately, waitIfAttached)
	metadata.isSitting = false
	metadata.isLaying = false
	metadata.scenario = false

	if metadata.plyFrozen then
		SetEntityCollision(PlayerPedId(), true, false)
		FreezeEntityPosition(PlayerPedId(), false)
		metadata.plyFrozen = false
	end

	if metadata.entity ~= 0 then
		UnhandleLooseEntity(metadata.entity)
		metadata.entity = 0
	end

	if clearTask or clearTaskImmediately then
		if waitIfAttached then

			Citizen.CreateThread(function()
				while true do
					if not IsEntityAttachedToAnyPed(PlayerPedId()) then
						break
					end
					Citizen.Wait(200)
				end
				ClearPedTasksImmediately(PlayerPedId())
			end)
		elseif clearTask then
			ClearPedTasks(PlayerPedId())
		else
			ClearPedTasksImmediately(PlayerPedId())
		end
	end
end

local function StopSitting()
	if metadata.lastPos and (ConfigSit.AlwaysTeleportOutOfSeat or ConfigSit.TeleportToLastPosWhenNoRoute or ConfigSit.SitTypes[metadata.type].teleportOut or metadata.teleportOut) then
		ClearPedTasksImmediately(PlayerPedId())
		SetEntityCoords(PlayerPedId(), vector3(metadata.lastPos.x, metadata.lastPos.y, metadata.lastPos.z-0.95))
	end
	LeaveSeat(true, false, false)
end

local function GetScenario(type)
	local list = ConfigSit.SitTypes[type].scenarios
	if not list then return false end

	local scenarios = {}
	local index = 0
	for row, scenario in pairs(list) do
		index = index + 1
		scenarios[index] = scenario
	end
	local random = math.floor(math.random(100, index*100)/100 + 0.5)
	return scenarios[random]
end

local function IsPlayerDoingAnyAction()
	if IsPedUsingScenario(PlayerPedId(), metadata.scenario) or metadata.isSitting or metadata.isLaying then
		return true
	else
		return false
	end
end

local function SitOnSeat(data)
	metadata.entity = data.entity
	metadata.poly = data.poly
	metadata.type = data.sit.type

    local seat = data.sit
	local settings = ConfigSit.SitTypes[seat.type]
	local seatCoords = nil
	local seatHeading = nil

	if not settings then
		print("^3Warning: No settings were set for type^2", seat.type, "^3 in ConfigSit.SitTypes, the default settings were used instead!")
		seat.type = 'default'
		settings = ConfigSit.SitTypes['default']
	end

	if data.entity then
		local rot = GetEntityRotation(data.entity)
		local xRot = rot.x
		local yRot = rot.y

		if xRot < 0.0 then xRot = xRot*-1 end
		if yRot < 0.0 then yRot = yRot*-1 end

		local tilt = xRot + yRot
		if tilt > ConfigSit.MaxTilt then
			ESX.ShowNotification(ConfigSit.Lang.TooTilted)
			return
		end

		seatCoords = GetEntityCoords(data.entity)
		seatHeading = GetEntityHeading(data.entity)
	else
		seatCoords = seat.seats[1].xyz
		seatHeading = 0
	end

	local coords, offset, heading = GetAvailableSeat(seatCoords, seatHeading, seat.seats, data.raycast)
    if coords == nil then
		local model = GetEntityModel(data.entity)
        if model ~= 0 and GetAmountOfSeats(model) ~= 1 then
			ESX.ShowNotification(ConfigSit.Lang.NoAvailable)
        else
            ESX.ShowNotification(ConfigSit.Lang.Occupied)
        end
        return
    end

    if offset == nil or heading == nil then
        ESX.ShowNotification(ConfigSit.Lang.NoAvailable)
		print('^1Error: Either offset or heading was nil!', offset, heading)
        return
    end

	local playerPed = PlayerPedId()
	local lastPos = GetEntityCoords(playerPed)

	metadata.teleportOut = false
	metadata.lastPos = nil
	if ConfigSit.AlwaysTeleportOutOfSeat or settings.teleportOut or seat.teleportOut then
		metadata.teleportOut = true
		metadata.lastPos = lastPos
	end

	if metadata.isSitting or metadata.isLaying then
		if #(coords-lastPos) < 0.2 then
			StopSitting()
			return
		else
			if metadata.teleportOut then
				LeaveSeat(false, true, false)
			else
				LeaveSeat(true, false, false)
				Citizen.Wait(2000)
			end
			metadata.entity = data.entity
		end
	end

	metadata.isLaying = false
	metadata.scenario = GetScenario(seat.type)
	metadata.animation = {}

	ClearPedTasks(playerPed)
	if data.entity ~= 0 then
		HandleLooseEntity(data.entity)
	end

	local timeout = settings.timeout
	local skipGoStraightTask = settings.skipGoStraightTask
	local prevDist = #(coords.xy - GetEntityCoords(playerPed).xy)
	local dist = prevDist
	local teleport = ConfigSit.AlwaysTeleportToSeat or seat.teleportIn or settings.teleportIn
	local breakCounter = 0
	local tick = 0

	if not teleport and not skipGoStraightTask then
		local rotation = HeadingToRotation(heading)
		local gotoCoords = GetOffsetFromCoordsInWorldCoords(coords, vector3(0.0, 0.0, rotation), vector3(0.0, 0.695, 0.0))
		TaskGoStraightToCoord(playerPed, gotoCoords, 1, timeout*500, heading, 0.15)
		metadata.doingTaskGo = true

		while true do
			Citizen.Wait(500)
			if not metadata.doingTaskGo then
				return
			end

			local playerCoords = GetEntityCoords(playerPed)
			dist = #(gotoCoords.xy - playerCoords.xy)
			tick = tick + 1

			if dist < prevDist then
				lastPos = playerCoords
				prevDist = dist
			end

			local diff = GetDifference(dist, prevDist)
			local taskStatus = GetScriptTaskStatus(playerPed, "SCRIPT_TASK_GO_STRAIGHT_TO_COORD")

			if taskStatus == 0 or taskStatus == 7 then
				break
			elseif tick > timeout then
				break
			elseif dist > prevDist+0.1 and dist > 0.85 then
				breakCounter = breakCounter + 1
			elseif diff <= 0.085 and dist < ConfigSit.MaxInteractionDist and dist > 0.05 and tick > 1 then
				breakCounter = breakCounter + 1
			else
				breakCounter = breakCounter - 1
				if breakCounter < 0 then
					breakCounter = 0
				end
			end

			if breakCounter > 2 and seat.type ~= "sunlounger" then
				break
			end
		end
		teleport = dist > 0.5 or false
		tick = 0
	end

	if metadata.scenario then
		metadata.targetPos = coords
		TaskStartScenarioAtPosition(playerPed, metadata.scenario, coords.x, coords.y, coords.z, heading, -1, false, teleport)

		while true do
			Citizen.Wait(500)
			local playerCoords = GetEntityCoords(playerPed)
			dist = #(coords.xy - playerCoords.xy)
			tick = tick + 1

			local taskStatus = GetScriptTaskStatus(playerPed, "SCRIPT_TASK_START_SCENARIO_AT_POSITION")
			if taskStatus == 0 or taskStatus == 7 then
				break
			elseif IsPedUsingScenario(playerPed, metadata.scenario) and dist < 0.40 then
				metadata.isSitting = true
				break
			elseif tick > timeout then
				break
			elseif not IsPedUsingScenario(playerPed, metadata.scenario) then
				break
			end
		end
	else
		local animation = settings.animation
		if animation.offset then
			coords = coords+animation.offset.xyz
			heading = heading+animation.offset.w

			metadata.targetPos = coords
		end

		SetEntityCollision(playerPed, false, false)
		FreezeEntityPosition(playerPed, true)
		SetEntityCoords(playerPed, coords)
		SetEntityHeading(playerPed, heading)

		LoadAnimDict(animation.dict)
		TaskPlayAnim(playerPed, animation.dict, animation.name, 2.0, 2.0, -1, 1, 0, false, false, false)
		RemoveAnimDict(animation.dict)
		metadata.plyFrozen = true
		metadata.isSitting = true
		metadata.animation = animation
	end

	metadata.doingTaskGo = false
	if metadata.isSitting then
		Citizen.Wait(350)
		TriggerEvent('sit:helpTextThread', 'isSitting')
		TriggerEvent('sit:checkThread', 'isSitting')
	elseif dist <= 2.0 then
		TaskStartScenarioAtPosition(playerPed, metadata.scenario, coords.x, coords.y, coords.z, heading, -1, false, true)
		metadata.lastPos = lastPos
		metadata.isSitting = true

		Citizen.Wait(350)
		TriggerEvent('sit:helpTextThread', 'isSitting')
		TriggerEvent('sit:checkThread', 'isSitting')
	else
		LeaveSeat(true, false, false)
	end
end

local function CanPlayerReachSeat(destination, entity)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local start = vector3(coords.x, coords.y, coords.z+0.25)
	local rayHandle = StartShapeTestLosProbe(start, destination, -1, ped, 0)
	while true do
		Citizen.Wait(0)
		local result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
		if result ~= 1 then
			if GetEntityType(entityHit) ~= 1 then
				local dist = #(endCoords-destination)
				if (dist < 0.5 or endCoords.x == 0.0) or entityHit == entity then
					return true
				else
					return false
				end
			else
				rayHandle = StartShapeTestLosProbe(GetEntityCoords(entityHit), destination, -1, entityHit, 0)
			end
		end
	end
end

local function SitOnClosestSeat(entityNum)
	local coords = GetEntityCoords(PlayerPedId())
    local chair = {
		entity = entityNum,
		dist = ConfigSit.MaxDetectionDist
	}

    for model, data in pairs(Models) do
		if data.sit then
			local newChair = GetClosestObjectOfType(coords.x, coords.y, coords.z, ConfigSit.MaxDetectionDist, model, false, true, true)
			if newChair ~= 0 then
				local dist = #(GetEntityCoords(newChair) - coords)
				if dist < chair.dist then
					chair.entity = newChair
					chair.dist = dist
				end
			end
		end
    end

	for group, data in pairs(PolyZones) do
		if data.enabled then
			if not data.radius or (#(data.center.xy - coords.xy) < data.radius) then
				for name, info in pairs(data.polys) do
					if info.sit then
						for indexName, seat in pairs(info.sit.seats) do
							local dist = #(seat.xyz - coords)
							if dist < chair.dist then
								chair.name = name
								chair.group = group
								chair.dist = dist
							end
						end
					end
				end
			end
		end
	end

	if chair.name ~= nil then
		local seat = PolyZones[chair.group].polys[chair.name]
		local destination = seat.poly.center or seat.sit.seats[1].xyz

		if seat.sit.skipSeeCheck or CanPlayerReachSeat(destination, 0) then
			SitOnSeat({entity = 0, poly = chair.name, sit = { type = seat.sit.type, teleportIn = seat.sit.teleportIn, seats = seat.sit.seats }, raycast = false})
		else
			ESX.ShowNotification(ConfigSit.Lang.CannotReachSeat)
		end
	elseif chair.entity ~= 0 then
		if chair.entity then
			local skipSeeCheck = Models[GetEntityModel(chair.entity)].sit.skipSeeCheck
			if skipSeeCheck or CanPlayerReachSeat(GetEntityCoords(chair.entity), chair.entity) then
				SitOnSeat({entity = chair.entity, poly = false, sit = Models[GetEntityModel(chair.entity)].sit, raycast = false})
			else
				ESX.ShowNotification(ConfigSit.Lang.CannotReachSeat)
			end
		else
			ExecuteCommand("lay")
		end
	else
		ESX.ShowNotification(ConfigSit.Lang.NoFound)
	end
end

local function LayDownOnBed(data)
	metadata.isSitting = false
	metadata.plyFrozen = true
	metadata.scenario = false
	metadata.teleportOut = false
	metadata.entity = data.entity
	metadata.type = data.bed.type

    local bed = data.bed
	local bedCoords = nil
	local bedHeading = nil

	if data.entity then
		local rot = GetEntityRotation(data.entity)
		local xRot = rot.x
		local yRot = rot.y

		if xRot < 0.0 then xRot = xRot*-1 end
		if yRot < 0.0 then yRot = yRot*-1 end

		local tilt = xRot + yRot
		if tilt > ConfigSit.MaxTilt then
			ESX.ShowNotification(ConfigSit.Lang.TooTilted)
			return
		end

		bedCoords = GetEntityCoords(data.entity)
		bedHeading = GetEntityHeading(data.entity)
	else
		bedCoords = bed.seats[1].xyz
		bedHeading = 0
	end

	local coords, offset, heading = GetAvailableSeat(bedCoords, bedHeading, bed.seats, data.raycast)
    if coords == nil then
		local model = GetEntityModel(data.entity)
        if ConfigSit.SitTypes[bed.type] and GetAmountOfSeats(model) ~= 1 then
			ESX.ShowNotification(ConfigSit.Lang.NoAvailable)
        else
            ESX.ShowNotification(ConfigSit.Lang.Occupied)
        end
        return
    end

    if offset == nil or heading == nil then
        ESX.ShowNotification(ConfigSit.Lang.NoAvailable)
		print('^1Error: Either offset or heading was nil!', offset, heading)
        return
    end

	if not IsSeatAvailable(coords, 'lay') then
		ESX.ShowNotification(ConfigSit.Lang.OccupiedLay)
		return
	end

	local playerPed = PlayerPedId()
	if ConfigSit.AlwaysTeleportOutOfSeat or ConfigSit.LayTypes[bed.type].teleportOut or bed.teleportOut then
		metadata.teleportOut = true
		metadata.lastPos = GetEntityCoords(playerPed)
	end

	local animation = nil
	if ConfigSit.LayTypes[bed.type] then
		animation = ConfigSit.LayTypes[bed.type].animation
	else
		print("^3Warning: No animation settings were set for type^2", bed.type, "^3 in ConfigSit.LayTypes, the default animation settings were used instead!")
		animation = ConfigSit.LayTypes['default'].animation
	end

	metadata.animation = animation
	if animation.offset then
		coords = GetOffsetFromCoordsInWorldCoords(coords, vector3(0.0, 0.0, HeadingToRotation(heading)), animation.offset.xyz)
		heading = heading+animation.offset.w
		if heading > 360 then
			heading = heading - 360
		end
	end

	LoadAnimDict(animation.dict)
	ClearPedTasksImmediately(playerPed)
	SetEntityCollision(playerPed, false, false)
	FreezeEntityPosition(playerPed, true)
	SetEntityCoords(playerPed, coords)
	SetEntityHeading(playerPed, heading)

	TaskPlayAnim(playerPed, animation.dict, animation.name, 2.0, 2.0, -1, 1, 0, false, false, false)
	RemoveAnimDict(animation.dict)

	metadata.isLaying = true
	metadata.targetPos = coords
	TriggerEvent('sit:helpTextThread', 'isLaying')
	TriggerEvent('sit:checkThread', 'isLaying')
end

local function LayDownOnClosestBed(entityNum)
	local coords = GetEntityCoords(PlayerPedId())
    local bed = {
		entity = entityNum,
		dist = ConfigSit.MaxDetectionDist
	}

	for model, data in pairs(Models) do
		if data.lay then
			local newBed = GetClosestObjectOfType(coords.x, coords.y, coords.z, ConfigSit.MaxDetectionDist, model, false, true, true)
			if newBed ~= 0 then
				local dist = #(GetEntityCoords(newBed) - coords)
				if dist < bed.dist then
					bed.entity = newBed
					bed.dist = dist
				end
			end
		end
    end

	for group, data in pairs(PolyZones) do
		if data.enabled then
			if not data.radius or (#(data.center.xy - coords.xy) < data.radius) then
				for name, info in pairs(data.polys) do
					if info.lay then
						local dist = #(info.lay.seats[1].xyz - coords)
						if dist < bed.dist then
							bed.name = name
							bed.group = group
							bed.dist = dist
						end
					end
				end
			end
		end
	end

	if bed.name ~= nil then
		local seat = PolyZones[bed.group].polys[bed.name]
		local destination = seat.poly.center or seat.sit.seats[1].xyz

		if seat.lay.skipSeeCheck or CanPlayerReachSeat(destination, 0) then
			LayDownOnBed({entity = 0, bed = seat.lay, raycast = false})
		else
			ESX.ShowNotification(ConfigSit.Lang.CannotReachBed)
		end
	elseif bed.entity ~= 0 then
		if bed.entity then
			local skipSeeCheck = Models[GetEntityModel(bed.entity)].lay.skipSeeCheck
			if skipSeeCheck or CanPlayerReachSeat(GetEntityCoords(bed.entity), bed.entity) then
				LayDownOnBed({entity = bed.entity, bed = Models[GetEntityModel(bed.entity)].lay, raycast = false})
			else
				ESX.ShowNotification(ConfigSit.Lang.CannotReachBed)
			end
		end
	else
		ESX.ShowNotification(ConfigSit.Lang.NoBedFound)
	end
end

local function GetUpFromBed()
	local clearTask = true
	metadata.isLaying = false

	if metadata.teleportOut then
		ClearPedTasksImmediately(PlayerPedId())
		SetEntityCoords(PlayerPedId(), vector3(metadata.lastPos.x, metadata.lastPos.y, metadata.lastPos.z-0.95))
		clearTask = false
	elseif ConfigSit.LayTypes[metadata.type].exitAnim ~= false then
		local direction = "m_getout_r"
		if metadata.type ~= "layside" then
			if GetGameplayCamRelativeHeading() < 0 then
				direction = "m_getout_l"
			end
		end

		LoadAnimDict("savem_default@")
		TaskPlayAnim(PlayerPedId(), "savem_default@", direction, 1.0, 1.0, 3000, 0, 0, false, false, false)
		RemoveAnimDict("savem_default@")
		Citizen.Wait(1400)
		clearTask = false
	end
	metadata.animation = {}
	LeaveSeat(clearTask, false, false)
end

local function StopCurrentAction()
	if IsPedUsingScenario(PlayerPedId(), metadata.scenario) or metadata.isSitting then
		StopSitting()
	elseif metadata.isLaying then
		GetUpFromBed()
	elseif metadata.doingTaskGo then
		metadata.doingTaskGo = false
		LeaveSeat(true, false, false)
	end
end

local function SetupBeds()
	local models = {}
    local index = 0
    for model, data in pairs(Models) do
		if data.lay then
			index = index + 1
			models[index] = model
		end
    end

	exports[ConfigSit.Target]:AddTargetModel(models, {
		options = {
			{
				icon = ConfigSit.Targeting.LayIcon,
				label = ConfigSit.Targeting.LayLabel,
				action = function(entity)
					if metadata.isLaying then
						GetUpFromBed()
					else
						local model = GetEntityModel(entity)
						local skipSeeCheck = Models[model].lay.skipSeeCheck
						if skipSeeCheck or CanPlayerReachSeat(GetEntityCoords(entity), entity) then
							LayDownOnBed({entity = entity, bed = Models[model].lay, raycast = true})
						else
							ESX.ShowNotification(ConfigSit.Lang.CannotReachBed)
						end
					end
				end
			},
		},
		distance = ConfigSit.MaxInteractionDist
	})
end

local function SetupSeats()
	local models = {}
	local index = 0
    for model, data in pairs(Models) do
		if data.sit then
			index = index + 1
			models[index] = model
		end
    end

	exports[ConfigSit.Target]:AddTargetModel(models, {
		options = {
			{
				icon = ConfigSit.Targeting.SitIcon,
				label = ConfigSit.Targeting.SitLabel,
				action = function(entity)
					if metadata.isSitting or metadata.isLaying then
						if entity == metadata.entity then
							SitOnSeat({entity = entity, poly = false, sit = Models[GetEntityModel(entity)].sit, raycast = true})
						else
							StopSitting()
						end
					else
						local model = GetEntityModel(entity)
						local skipSeeCheck = Models[model].sit.skipSeeCheck
						if skipSeeCheck or CanPlayerReachSeat(GetEntityCoords(entity), entity) then
							SitOnSeat({entity = entity, poly = false, sit = Models[model].sit, raycast = true})
						else
							ESX.ShowNotification(ConfigSit.Lang.CannotReachSeat)
						end
					end
				end
			},
		},
		distance = ConfigSit.MaxInteractionDist
	})
end

local function SetupPolyZones()

	if ConfigSit.Target then
		for group, data in pairs(PolyZones) do
			if data.enabled then
				for name, info in pairs(data.polys) do

					exports[ConfigSit.Target]:RemoveZone(name)

					if info.poly == nil then
						print("^1Error: PolyZone '"..name.."' could not be generated! (lacks poly specifications)")
					elseif info.lay == nil and info.sit == nil then
						print("^1Error: PolyZone '"..name.."' could not be generated! (no action assinged)")
					else
						local type = 'sit'
						local options = {}

						if info.lay then
							type = 'lay'
							options[#options+1] = {
								icon = ConfigSit.Targeting.LayIcon,
								label = ConfigSit.Targeting.LayLabel,
								action = function()
									if metadata.isLaying then
										GetUpFromBed()
									else
										LayDownOnBed({entity = 0, bed = info.lay, raycast = true})
									end
								end
							}
						end

						if info.sit then
							type = 'sit'
							options[#options+1] = {
								icon = ConfigSit.Targeting.SitIcon,
								label = ConfigSit.Targeting.SitLabel,
								action = function()
									if metadata.isSitting or metadata.isLaying then
										if name == metadata.poly then
											SitOnSeat({entity = 0, poly = name, sit = { type = info.sit.type, teleportIn = info.sit.teleportIn, seats = info.sit.seats}, raycast = true})
										else
											StopSitting()
										end
									else
										local destination = info.poly.center or info.sit.seats[1].xyz
										if info.sit.skipSeeCheck or CanPlayerReachSeat(destination, 0) then
											SitOnSeat({entity = 0, poly = name, sit = { type = info.sit.type, teleportIn = info.sit.teleportIn, seats = info.sit.seats}, raycast = true})
										else
											ESX.ShowNotification(ConfigSit.Lang.CannotReachSeat)
										end
									end
								end
							}
						end

						local minZ = info.poly.minZ or (info.poly.center and info.poly.center.z-(info.poly.height/2)) or info[type].seats[1].z-(info.poly.height/2)
						local maxZ = info.poly.maxZ or (info.poly.center and info.poly.center.z+(info.poly.height/2)) or info[type].seats[1].z+(info.poly.height/2)
						local heading = info.poly.heading or info[type].seats[1].w
						local center = info.poly.center or info[type].seats[1].xyz

						exports[ConfigSit.Target]:AddBoxZone(name, center, info.poly.length, info.poly.width, {
							name = name,
							heading = heading,
							debugPoly = ConfigSit.DebugPoly,
							minZ = minZ,
							maxZ = maxZ,

						}, {
							options = options,
							distance = ConfigSit.MaxInteractionDist
						})
					end
				end
				print("^2Info: PolyZone group '"..group.."' was generated.")
			else
				print("^3Info: PolyZone group '"..group.."' is disabled.")
			end
		end
	end
end

local function SetupLocalization()
	AddTextEntry("sit_getup_keyboard", string.format(ConfigSit.Lang.GetUp, "~INPUT_BA1F4C6D~"))
    AddTextEntry("sit_getup_controller", string.format(ConfigSit.Lang.GetUp, "~INPUT_6ED7AA10~"))
end

Citizen.CreateThread(function()
	Models = GetModels()
	PolyZones = GetPolyZones()

	if ConfigSit.Target then
		SetupBeds()
		SetupSeats()
		SetupPolyZones()
	end

	SetupLocalization()

	if ConfigSit.AddChatSuggestions then
    	TriggerEvent('chat:addSuggestion', '/sit', ConfigSit.Lang.ChatHelpTextSit)
		TriggerEvent('chat:addSuggestion', '/lay', ConfigSit.Lang.ChatHelpTextLay)
	end
end)

RegisterCommand("sit", function(source, args, rawCommand)
	if IsPlayerDoingAnyAction() then
		StopCurrentAction()
	else
    	SitOnClosestSeat()
	end
end, false)

RegisterCommand("lay", function(source, args, rawCommand)
	if IsPlayerDoingAnyAction() then
		StopCurrentAction()
	else
		LayDownOnClosestBed()
	end
end, false)

RegisterKeyMapping('sit', "S'assoir sur une chaise", 'keyboard', '/')

RegisterKeyMapping('getup', ConfigSit.Lang.KeyMappingKeyboard, 'keyboard', ConfigSit.DefaultKey)
RegisterCommand('getup', function()
	StopCurrentAction()
end, false)

RegisterKeyMapping('standup', ConfigSit.Lang.KeyMappingController, 'PAD_ANALOGBUTTON', ConfigSit.DefaultPadAnalogButton)
RegisterCommand('standup', function()
	StopCurrentAction()
end, false)

AddEventHandler('sit:helpTextThread', function(type)
	Citizen.CreateThread(function()
		while metadata[type] do
			if IsUsingKeyboard(1) then
				DisplayHelpTextThisFrame("sit_getup_keyboard")
			else
				DisplayHelpTextThisFrame("sit_getup_controller")
			end
			Citizen.Wait(0)
		end
	end)
end)

AddEventHandler('sit:checkThread', function(type)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(500)
			if not metadata[type] then
				break
			end

			if ConfigSit.ReduceStress then

			end

			local playerPed = PlayerPedId()
			local playerPos = GetEntityCoords(playerPed)
			local distance = #(playerPos.xy - metadata.targetPos.xy)
			local distZ = playerPos.z - metadata.targetPos.z - 1.25
			if distZ > 0.0 then
				distance = distance + distZ
			end

			if distance > 0.5 or (metadata.scenario and not IsPedUsingScenario(playerPed, metadata.scenario) or (metadata.animation and metadata.animation.dict and not IsEntityPlayingAnim(playerPed, metadata.animation.dict, metadata.animation.name, 3))) or IsEntityDead(playerPed) then
				local clearTask = true
				if IsEntityDead(playerPed) then
					clearTask = false
				end

				LeaveSeat(clearTask, false, true)
				break
			end
		end
	end)
end)

if ConfigSit.Debugmode then
	local debugging = true
	local function DrawText3D(coords, text, rgb)
		SetTextColour(rgb.r, rgb.g, rgb.b, 255)
		SetTextScale(0.0, 0.35)
		SetTextFont(4)
		SetTextDropshadow(0, 0, 0, 0, 55)
		SetTextDropShadow()
		SetTextOutline()
		SetTextCentre(true)
		SetTextProportional(1)
		SetTextEdge(2, 0, 0, 0, 150)

		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(text)
		SetDrawOrigin(coords, 0)
		EndTextCommandDisplayText(0.0, 0.0)
		ClearDrawOrigin()
		DrawRect(coords.x, coords.y, 1.0, 1.0, 230, 230, 230, 255)
	end

	local function GetDebugEntities(playerPed)
		local playerCoords = GetEntityCoords(playerPed)
		local handle, entity = FindFirstObject()
		local success = nil
		local objects = {}
		repeat
			local pos = GetEntityCoords(entity)
			local distance = #(playerCoords- pos)
			if distance < 8.0 then
				objects[#objects+1] = {pos = pos, entity = entity}
			end

			success, entity = FindNextObject(handle)
		until not success
		EndFindObject(handle)
		return objects
	end

	local function DebugIsSeatAvailable(coords, action)
		local playerPed = PlayerPedId()
		for index, ped in pairs(GetNearbyPeds()) do
			local dist = #(GetEntityCoords(ped)-coords)
			if dist < 1.35 then
				if action == 'sit' then
					if IsEntityPlayingAnyLayAnim(ped) or dist < 0.55 then
						return false
					end
				elseif action == 'lay' then
					if IsEntityPlayingAnyLayAnim(ped) or IsPedSitting(ped) then
						return false
					end
				end
			end
		end
		return true
	end

	local function StartDebuging()
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local toDisplay = {}
		local sitColor = {r=255, g=255, b=255}
		local layColor = {r=150, g=150, b=150}

		Citizen.CreateThread(function()
			while debugging do
				local globalIndex = 0
				playerPed = PlayerPedId()
				playerCoords = GetEntityCoords(playerPed)
				toDisplay = {}

				local entites = GetDebugEntities(playerPed)
				for k, info in pairs(entites) do
					local model = GetEntityModel(info.entity)
					local data = Models[model]
					if data then
						if data.sit then
							for seatIndex, seat in pairs(data.sit.seats) do
								local subName = "sit: "..model
								if #data.sit.seats > 1 then
									subName = subName.." ("..seatIndex..")"
								end
								local heading = GetEntityHeading(info.entity)
								local coords = GetOffsetFromCoordsInWorldCoords(info.pos, vector3(0.0, 0.0, HeadingToRotation(heading)), seat.xyz)
								local newHeading = heading + seat.w
								if newHeading > 360 then
									newHeading = newHeading - 360
								end

								local color = sitColor
								if not DebugIsSeatAvailable(coords.xyz, 'sit') then
									color = {r=200, g=0, b=0}
								end
								globalIndex = globalIndex + 1
								toDisplay[globalIndex] = { vector4(coords.xyz, newHeading), subName, color}
							end
						end

						if data.lay then
							for seatIndex, seat in pairs(data.lay.seats) do
								local subName = "lay: "..model
								if #data.lay.seats > 1 then
									subName = subName.." ("..seatIndex..")"
								end
								local heading = GetEntityHeading(info.entity)
								local coords = GetOffsetFromCoordsInWorldCoords(info.pos, vector3(0.0, 0.0, HeadingToRotation(heading)), vector3(seat.x, seat.y, seat.z + 0.25))
								local newHeading = heading + seat.w
								if newHeading > 360 then
									newHeading = newHeading - 360
								end

								local color = layColor
								if not DebugIsSeatAvailable(coords.xyz, 'lay') then
									color = {r=200, g=0, b=0}
								end
								globalIndex = globalIndex + 1
								toDisplay[globalIndex] = {vector4(coords.xyz, newHeading), subName, color}
							end
						end
					end
				end

				for group, data in pairs(PolyZones) do
					if data.enabled then
						for name, info in pairs(data.polys) do
							if info.sit then
								for index, coords in pairs(info.sit.seats) do
									if #(playerCoords-coords.xyz) < 8.0 then
										local subName = "sit: "..name
										if #info.sit.seats > 1 then
											subName = subName.." ("..index..")"
										end
										local color = sitColor
										if not DebugIsSeatAvailable(coords.xyz, 'sit') then
											color = {r=200, g=0, b=0}
										end
										globalIndex = globalIndex + 1
										toDisplay[globalIndex] = {coords, subName, color}
									end
								end
							end
							if info.lay then
								for index, coords in pairs(info.lay.seats) do
									if #(playerCoords-coords.xyz) < 8.0 then
										local subName = "lay: "..name
										if #info.lay.seats > 1 then
											subName = subName.." ("..index..")"
										end
										local layCoords = vector4(GetOffsetFromCoordsInWorldCoords(coords, vector3(0.0, 0.0, HeadingToRotation(coords.w)), vector3(0.0, 0.0, 0.25)), coords.w)
										local color = layColor
										if not DebugIsSeatAvailable(layCoords.xyz, 'lay') then
											color = {r=200, g=0, b=0}
										end
										globalIndex = globalIndex + 1
										toDisplay[globalIndex] = {layCoords, subName, color}
									end
								end
							end
						end
					end
				end
				Citizen.Wait(1000)
			end
		end)

		Citizen.CreateThread(function()
			while debugging do
				for index, data in pairs(toDisplay) do
					DrawText3D(data[1].xyz, data[2], data[3])
				end
				Citizen.Wait(0)
			end
		end)

		Citizen.CreateThread(function()
			while debugging do
				for index, data in pairs(toDisplay) do
					if data[1].w ~= nil then
						DrawLine(data[1].xyz, GetOffsetFromCoordsInWorldCoords(data[1].xyz, vector3(0.0, 0.0, HeadingToRotation(data[1].w)), vector3(0.0, 0.50, 0.0)), 255, 0, 0, 200)
						DrawLine(data[1].xyz, GetOffsetFromCoordsInWorldCoords(data[1].xyz, vector3(0.0, 0.0, HeadingToRotation(data[1].w)), vector3(0.0, 0.00, 0.20)), 255, 0, 0, 200)
					end
				end
				Citizen.Wait(0)
			end
		end)
	end

	RegisterKeyMapping('sit:debug', 'sit Debuging', 'keyboard', 'G')
	RegisterCommand('sit:debug', function(source, args, rawCommand)
		debugging = not debugging
		if debugging then
			StartDebuging()
		end
	end, false)

	local function GetAverage(table)
		local sum = 0
		for key, value in pairs(table) do
			sum = sum + value
		end
		return sum / #table
	end

	RegisterCommand('sit:getcenter', function(source, args, rawCommand)
		local group = args[1]
		if PolyZones[group] then
			local xPoints = {}
			local yPoints = {}
			local zPoints = {}

			local index = 0
			for k, v in pairs(PolyZones[group].polys) do
				index = index + 1
				xPoints[index] = (v.poly.center and v.poly.center.x) or (v.sit and v.sit.seats[1].x) or (v.lay and v.lay.seats[1].x)
				yPoints[index] = (v.poly.center and v.poly.center.y) or (v.sit and v.sit.seats[1].y) or (v.lay and v.lay.seats[1].y)
				zPoints[index] = (v.poly.center and v.poly.center.z) or (v.sit and v.sit.seats[1].z) or (v.lay and v.lay.seats[1].z)
			end

			local average = vector3(GetAverage(xPoints), GetAverage(yPoints), GetAverage(zPoints))
			print('average "center":', average)
		else
			print(group, 'is not a valid poly group!')
		end
	end, false)

	RegisterCommand('sit:getfarthestdist', function(source, args, rawCommand)
		local group = args[1]
		if PolyZones[group] and PolyZones[group].center then
			local center = PolyZones[group].center
			local farthest = {
				dist = 0,
				name = 'error'
			}

			for name, data in pairs(PolyZones[group].polys) do
				local pos = data.poly.center or (data.sit and data.sit.seats[1].xyz) or (data.lay and data.lay.seats[1].xyz)
				local distance = #(center-pos)
				if distance > farthest.dist then
					farthest.dist = distance
					farthest.name = name
				end
			end

			print(farthest.name, farthest.dist)
		else
			print(group, 'is not a valid poly group!')
		end
	end, false)

	RegisterCommand('sit:loadGroup', function(source, args, rawCommand)
		local group = args[1]
		if PolyZones[group] and PolyZones[group].center then
			PolyZones[group].enabled = true
			SetupPolyZones()
		else
			print(group, 'is not a valid poly group!')
		end
	end, false)

	RegisterCommand('sit:unloadGroup', function(source, args, rawCommand)
		local group = args[1]
		if PolyZones[group] and PolyZones[group].center then
			PolyZones[group].enabled = false
			for name, info in pairs(PolyZones[group].polys) do
				exports[ConfigSit.Target]:RemoveZone(name)
			end
		else
			print(group, 'is not a valid poly group!')
		end
	end, false)

	StartDebuging()
end

local modelsChairs = {
    'prop_off_chair_05',
	'prop_bench_09',
	'prop_chair_06',
	'prop_off_chair_05',
	'v_ret_gc_chair02',
	'v_club_officechair',
	'prop_chair_04a',
	'prop_table_03_chr',
	'v_serv_ct_chair02',
	'v_ret_fh_chair01',
	'v_corp_offchair',
	'apa_mp_h_din_chair_04',
	'prop_table_03b_chr',
	'prop_table_02_chr',
	'prop_table_04_chr',
	'prop_table_01_chr_a',
	'p_clb_officechair_s',
	'prop_chair_01b',
	'prop_off_chair_03',
	'v_res_mbchair',
	'prop_table_01_chr_b',
	'prop_skid_chair_02',
	'prop_skid_chair_03',
	'prop_skid_chair_01',
	'prop_cs_office_chair',
	'ba_prop_battle_club_chair_01',
	'v_ilev_leath_chr',
	'prop_table_05_chr',
	'v_corp_lazychair',
	'prop_off_chair_04',
	'v_corp_cd_chair',
	'prop_off_chair_01',
	'v_corp_bk_chair3',
	'prop_chair_08',
	'prop_chair_09',
	'prop_rub_couch03',
	'prop_chair_01a',
	'hei_prop_yah_seat_02',
	'p_yacht_chair_01_s',
	'gr_dlc_gr_yacht_props_seat_02',
	'hei_prop_yah_seat_01',
	'prop_yacht_seat_01',
	'prop_yacht_seat_03',
	'v_club_stagechair',
	'prop_chair_02',
	'prop_gc_chair02',
	'prop_table_06_chr',
	'v_ilev_p_easychair',
	'prop_off_chair_04_s',
	'prop_chair_03',
	'v_res_m_l_chair1',
	'prop_waiting_seat_01',
	'v_club_baham_bckt_chr',
	'prop_umpire_01',
	'v_ret_chair_white',
	'prop_chair_04b',
	'ex_prop_offchair_exec_02',
	'ex_prop_offchair_exec_01',
	'ex_prop_offchair_exec_03',
	'v_res_fa_chair02',
	'prop_wheelchair_01',
	'v_ind_ss_chair01',
	'v_ind_ss_chair2',
	'v_ilev_chair02_ped',
	'v_res_jarmchair',
	'v_res_m_armchair',
	'prop_chair_05',
	'prop_ld_farm_chair01',
	'v_58_soloff_gchair2',
	'v_58_soloff_gchair',
	'prop_chair_10',
	'prop_rock_chair_01',
	'prop_chateau_chair_01',
	'prop_old_deck_chair',
	'prop_hobo_seat_01',
	'v_ilev_m_dinechair',
	'prop_rub_carpart_05',
	'imp_prop_impexp_offchair_01a',
	'vw_prop_vw_offchair_03',
	'ba_prop_battle_club_chair_03',
	'ba_prop_battle_club_chair_02',
	'v_res_fa_chair01',
	'hei_prop_heist_off_chair',
	'sf_prop_sf_bench_piano_01a',
	'sf_prop_sf_sofa_chefield_02a',
	'prop_car_seat',
	'prop_off_chair_04b',
	'v_res_fh_dineeamesb',
	'v_res_fh_dineeamesa',
	'v_ret_chair',
	'gr_dlc_gr_yacht_props_table_01',
	'prop_ld_toilet_01',
	'vw_prop_casino_chair_01a',
	'vw_prop_casino_track_chair_01',
	'prop_chair_pile_01',
	'h4_prop_h4_chair_01a',
	'prop_bar_stool_01',
	'v_ret_gc_chair01',
	'v_res_tre_stool_leather',
	'v_club_bahbarstool',
	'apa_mp_h_din_stool_04',
	'v_res_kitchnstool',
	'prop_stool_01',
	'v_med_cor_medstool',
	'v_ret_ta_stool',
	'ba_prop_int_glam_stool',
	'ba_prop_int_edgy_stool',
	'h4_prop_h4_barstool_01a',
	'sf_prop_sf_chair_stool_08a',
	'sf_prop_sf_chair_stool_09a',
	'p_patio_lounger1_s',
	'prop_yacht_lounger',
	'prop_patio_lounger_2',
	'prop_patio_lounger_3',
	'prop_patio_lounger1',
	'gr_dlc_gr_yacht_props_lounger',
	'hei_prop_yah_lounger',
	'prop_patio_lounger1b',
	'prop_bench_11',
	'prop_bench_08',
	'prop_bench_09',
	'prop_bench_02',
	'prop_bench_03',
	'prop_bench_04',
	'prop_bench_05',
	'prop_bench_10',
	'prop_bench_11',
	'prop_bench_07',
	'prop_bench_01a',
	'prop_bench_06',
	'prop_busstop_02',
	'prop_busstop_04',
	'prop_busstop_05',
	'prop_picnictable_01',
	'prop_table_08_chr',
	'prop_ld_bench01',
	'prop_bench_04',
	'v_med_hospseating1',
	'prop_rub_couch04',
	'prop_rub_couch02',
	'v_res_tre_sofa',
	'hei_prop_yah_seat_03',
	'gr_dlc_gr_yacht_props_seat_03',
	'prop_yacht_seat_02',
	'p_yacht_sofa_01_s',
	'prop_wait_bench_01',
	'prop_fib_3b_bench',
	'prop_ld_farm_couch02',
	'prop_ld_farm_couch01',
	'prop_rub_couch01',
	'v_ilev_m_sofa',
	'v_res_m_h_sofa',
	'sf_prop_sf_sofa_chefield_01a',
	'sf_prop_sf_sofa_studio_01a',
	'h4_prop_h4_couch_01a',
	'v_med_bed1',
	'v_med_bed2',
	'v_med_emptybed',
	'v_med_cor_emblmtable',
	'v_res_tt_bed',
	'ex_prop_exec_bed_01',
	'bkr_prop_biker_campbed_01',
	'imp_prop_impexp_campbed_01',
	'imp_prop_impexp_sofabed_01a',
	'prop_t_sofa_02',
	'prop_t_sofa',
	'v_49_motelmp_bed',
	'prop_beach_lilo_01',
	'prop_beach_ring_01',
	'prop_homeles_shelter_01',
	'prop_homeles_shelter_02'
}

CreateThread(function()
	local Sitables = {}
	for _,v in pairs(modelsChairs) do
		local model = GetHashKey(v)
		table.insert(Sitables, model)
	end
	Wait(100)
	exports.ox_target:addModel(Sitables, {
		{
			icon = 'fa-solid fa-chair',
			label = "S'assoir",

			onSelect = function()
				if IsPlayerDoingAnyAction() then
					StopCurrentAction()
				else
					SitOnClosestSeat(model)
				end
			end,

			Distance = 3
		},
	})
end)
