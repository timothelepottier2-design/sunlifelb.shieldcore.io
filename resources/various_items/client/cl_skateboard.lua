
local skateboard, Dir, customCam, Attached, overSpeed = {}, {}, nil, false, nil

local function configureSkateboard(entity)
	for k, v in pairs({
		["fSteeringLock"] = 20.0,
		["fDriveInertia"] = 0.15,
		["fMass"] = 250.0,
		["fPercentSubmerged"] = 105.0,
		["fDriveBiasFront"] = 0.0,
		["fInitialDriveForce"] = 1.40,
		["fInitialDriveMaxFlatVel"] = 250.0,
		["fTractionCurveMax"] = 3.2,
		["fTractionCurveMin"] = 3.12,
		["fTractionCurveLateral"] = 22.5,
		["fTractionSpringDeltaMax"] = 0.1,
		["fLowSpeedTractionLossMult"] = 0.7,
		["fCamberStiffnesss"] = 0.0,
		["fTractionBiasFront"] = 0.478,
		["fTractionLossMult"] = 0.0,
		["fSuspensionForce"] = 1.2,
		["fSuspensionReboundDamp"] = 1.7,
		["fSuspensionUpperLimit"] = 0.1,
		["fSuspensionLowerLimit"] = -0.3,
		["fSuspensionRaise"] = 0.0,
		["fSuspensionBiasFront"] = 0.5,
		["fAntiRollBarForce"] = 0.0,
		["fAntiRollBarBiasFront"] = 0.65,
		["fBrakeForce"] = 0.53 }) do
		SetVehicleHandlingFloat(entity, "CHandlingData", k, v)
	end
end

local TextTargets = {}
local Keys = {
    [322] = "ESC", [288] = "F1", [289] = "F2", [170] = "F3", [166] = "F5",
    [167] = "F6", [168] = "F7", [169] = "F8", [56] = "F9", [57] = "F10",
    [243] = "~", [157] = "1", [158] = "2", [160] = "3", [164] = "4",  [165] = "5", [159] = "6", [161] = "7", [162] = "8", [163] = "9", [84] = "-", [83] = "=",  [177] = "BACKSPACE", [37] = "TAB",
    [44] = "Q", [32] = "W", [38] = "E", [45] = "R", [245] = "T", [246] = "Y", [303] = "U", [199] = "P",
    [39] = "[",  [40] = "]", [18] = "ENTER", [137] = "CAPS",
    [34] = "A", [8] = "S", [9] = "D", [23] = "F", [47] = "G",
    [74] = "H", [311] = "K", [182] = "L", [21] = "LEFTSHIFT",
    [20] = "Z", [73] = "X", [26] = "C", [0] = "V",  [29] = "B", [249] = "N",
    [244] = "M", [82] = ",", [81] = "."
}

local function makeFakeSkateboard(Ped, remove) -- The animation for picking up and placing the board
	local prop = makeProp({ prop = "v_res_skateboard", coords = vec4(0,0,0,0), false, true})
	if GetEntityModel(Ped) == `a_c_cat_01` then
		SetPedCanRagdoll(PlayerPedId(), false)
		AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 31086), 0.18, -0.14, 0.0, -87.0, -100.0, 1.0, true, true, false, false, 1, true)
	else
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 57005), 0.3, 0.08, 0.09, -86.0, -60.0, 50.0, true, true, false, false, 1, true)
		playAnim("pickup_object", "pickup_low", -1, 0)
	end
	if remove then
		DeleteVehicle(skateboard.Bike)
		destroyProp(skateboard.Skate)
		DeletePed(skateboard.Driver)
	end
	Wait(900)
	destroyProp(prop)
end

RegisterNetEvent("jim-skateboard:PickPlace", function()
	local Ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(Ped) then
		if DoesEntityExist(skateboard.Bike) then
			removeEntityTarget(skateboard.Skate)
			removeEntityTarget(skateboard.Driver)
			removeEntityTarget(skateboard.Bike)
			Attached = false
			Wait(100)
			stopTempCam()
			makeFakeSkateboard(Ped, true)
			TriggerServerEvent("skateboard:manageSkate", 1)
			skateboard = {}
			Dir = {}
		else
			local pedCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -40.5)
			skateboard.Bike = makeVeh("triBike3", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0))
			skateboard.Skate = makeProp({ prop = "v_res_skateboard", coords = vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0) }, 1, 1)
			while not DoesEntityExist(skateboard.Bike) or not DoesEntityExist(skateboard.Skate) do Wait(5) end

			SetEntityNoCollisionEntity(skateboard.Bike, Ped, false)
			SetEntityNoCollisionEntity(skateboard.Skate, Ped, false)

			Wait(500)

			configureSkateboard(skateboard.Bike)

			SetEntityCompletelyDisableCollision(skateboard.Bike, true, true)
			SetEntityCompletelyDisableCollision(skateboard.Skate, true, true)

			SetEntityVisible(skateboard.Bike, Config.System.Debug, 0)

			AttachEntityToEntity(skateboard.Skate, skateboard.Bike, GetPedBoneIndex(Ped, 28422), 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

			skateboard.Driver = ClonePed(Ped, false, false, true)
			SetEntityCoords(skateboard.Driver, pedCoords.x, pedCoords.y, pedCoords.z, true)
			while not DoesEntityExist(skateboard.Driver) do Wait(0) end
			SetEntityNoCollisionEntity(skateboard.Driver, Ped, false)
			SetEntityCompletelyDisableCollision(skateboard.Driver, true, true)

			SetEnableHandcuffs(skateboard.Driver, true)
			SetEntityInvincible(skateboard.Driver, true)
			FreezeEntityPosition(skateboard.Driver, true)

			while not IsPedSittingInAnyVehicle(skateboard.Driver) do
				SetEntityVisible(skateboard.Driver, Config.System.Debug, 0)
				TaskWarpPedIntoVehicle(skateboard.Driver, skateboard.Bike, -1)
				Wait(10)
			end

			local options = {
				{ action = function() TriggerEvent("jim-skateboard:GetOn", { board = skateboard.Skate }) end,
					icon = "fas fa-car", label = "Utiliser", board = skateboard.Skate },
				{ action = function() TriggerEvent("jim-skateboard:PickPlace", { board = skateboard.Skate }) end,
					icon = "fas fa-hand-holding", label ="Récupérer", board = skateboard.Skate },
			}
			createEntityTarget(skateboard.Skate, options, 2.5)
			createEntityTarget(skateboard.Driver, options, 2.5)
			createEntityTarget(skateboard.Bike, options, 2.5)

			makeFakeSkateboard(Ped)

			DisableCamCollisionForEntity(skateboard.Bike)
			DisableCamCollisionForEntity(skateboard.Skate)
			DisableCamCollisionForEntity(skateboard.Driver)
			SetVehicleDoorsLocked(skateboard.Bike, 10)

			SetEntityCoords(skateboard.Bike, GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, 1.5))
			SetEntityHeading(skateboard.Bike, GetEntityHeading(PlayerPedId())+90)
			TriggerServerEvent("skateboard:manageSkate", 2)
			Dir = {}
		end
	end
end)

RegisterKeyMapping('skategetoff', 'Skateboard: Sortir du skateboard', 'keyboard', 'G')
RegisterCommand('skategetoff', function()
	if Attached then
		if not IsEntityInAir(skateboard.Bike) then
			stopTempCam()
			DetachEntity(PlayerPedId(), false, false)
			TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 100)
			Attached = false
			Dir = {}
			ClearPedTasks(PlayerPedId())
		end
	end
end)

RegisterKeyMapping('+skateforward', 'Skateboard: En avant', 'keyboard', 'W')
RegisterCommand('+skateforward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.forward then
				Dir.forward = true
				while Dir.forward do
					if not Dir.right and not Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 9, 0.1) end
					if Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 7, 0.1) end
					if Dir.right then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 8, 0.1) end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skateforward', function() if Attached then Dir.forward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

RegisterKeyMapping('+skatebackward', 'Skateboard: En arrière', 'keyboard', 'S')
RegisterCommand('+skatebackward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.backward then
				Dir.backward = true
				while Dir.backward do
					if Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 13, 0.1)
					elseif Dir.right then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 14, 0.1)
					elseif not Dir.right and not Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 22, 0.1)
					end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skatebackward', function() if Attached then Dir.backward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

RegisterKeyMapping('+skateleft', 'Skateboard: Gauche', 'keyboard', 'A')
RegisterCommand('+skateleft', function() if Attached and not overSpeed then Dir.left = true end end)
RegisterCommand('-skateleft', function() if Attached then	Dir.left = nil end end)

RegisterKeyMapping('+skateright', 'Skateboard: Droite', 'keyboard', 'D')
RegisterCommand('+skateright', function() if Attached and not overSpeed then Dir.right = true end end)
RegisterCommand('-skateright', function() if Attached then Dir.right = nil end end)

RegisterKeyMapping('skatejump', 'Skateboard: Sauter', 'keyboard', 'SPACE')
RegisterCommand('skatejump', function() local Ped = PlayerPedId()
	if Attached then
		if not IsEntityInAir(skateboard.Bike) then
			local vel = GetEntityVelocity(skateboard.Bike)
			if GetEntityModel(Ped) == `a_c_cat_01` then
				playAnim("creatures@cat@move", "idle_dwn", -1, 1)
			else
				playAnim("move_crouch_proto", "idle_intro", -1, 1)
			end
			local duration = 0
			local boost = 0
			while IsControlPressed(0, 22) do
				Wait(10)
				duration = duration + 10.0
			end
			boost = 6.0 * duration / 250.0
			if boost > 6.0 then boost = 6.0 end

			SetEntityVelocity(skateboard.Bike, vel.x, vel.y, vel.z + boost)
			if GetEntityModel(Ped) == `a_c_cat_01` then
				stopAnim("move_crouch_proto", "idle_dwn")
				playAnim("creatures@cat@move", "idle_upp", -1, 1)
			else
				stopAnim("move_crouch_proto", "idle_intro")
				playAnim("move_strafe@stealth", "idle", -1, 1)
			end
		end
	end
end)

local toggleCam = false
local flipCam = false

RegisterKeyMapping('skatecam', 'Skateboard: Verouiller/Déverouiller', 'keyboard', 'H')
RegisterCommand('skatecam', function()
	if Attached then
		toggleCam = not toggleCam
		updateCamLoc()
	end
end)

RegisterKeyMapping('+flipcam', 'Skateboard: Retourner la caméra', 'keyboard', 'C')
RegisterCommand('+flipcam', function()
	if Attached then
		AttachCamToEntity(customCam, skateboard.Bike, 0.25, 2.0, 1.5, true)
		flipCam = true
	end
end)

RegisterCommand('-flipcam', function()
	if Attached then
		AttachCamToEntity(customCam, skateboard.Bike, 0.25, -2.0, 1.0, true)
		flipCam = false
	end
end)

function updateCamLoc()
	CreateThread(function()
		while toggleCam and Attached do
			local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, flipCam and -5.0 or 5.0, 0.0)
			if customCam == nil then
				customCam = createTempCam(coord, coord)
				AttachCamToEntity(customCam, skateboard.Bike, 0.25, -2.0, 1.0, true)
				startTempCam(customCam)
			end
			PointCamAtCoord(customCam, coord.x, coord.y, coord.z)
			Wait(0)
		end
		RenderScriptCams(false, true, 500, true, true)
		DestroyAllCams()
		customCam = nil
	end)
end

RegisterNetEvent("jim-skateboard:GetOn", function() local Ped = PlayerPedId()
	if GetEntityModel(Ped) == `a_c_cat_01` then
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.10, -0.78, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		playAnim("creatures@cat@move", "idle_upp", -1, 1)
	else
		playAnim("move_strafe@stealth", "idle", -1, 1)
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
	end
	SetEntityCollision(Ped, true, true)
	Attached = true
	updateCamLoc()
	drawText(nil, {
		(Config.System.drawText == "gta" and "[G]").." - Descendre",
		(Config.System.drawText == "gta" and "[H]") .." - Verouiller/Déverouiller la caméra",
	}, "w")
	CreateThread(function()
		while Attached do
			StopCurrentPlayingAmbientSpeech(skateboard.Driver)
			overSpeed = (GetEntitySpeed(skateboard.Bike)*3.6) > 90
			local x, y, z = table.unpack(GetEntityRotation(skateboard.Bike))
			if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1)
				Attached = false
				Dir = {}
				if GetEntityModel(Ped) ~= `a_c_cat_01` then stopAnim("move_strafe@stealth", "idle") end
				SetPedToRagdoll(Ped, 5000, 4000, 0, true, true, false)
			end

			if not DoesEntityExist(skateboard.Bike) or GetPedInVehicleSeat(skateboard.Bike, -1) ~= skateboard.Driver then
				removeEntityTarget(skateboard.Skate)
				removeEntityTarget(skateboard.Bike)
				removeEntityTarget(skateboard.Driver)
				Attached = false
				Wait(100)
				makeFakeSkateboard(Ped, true)
				TriggerServerEvent("skateboard:manageSkate", 1)
				skateboard = {}
				Dir = {}
			end
			if not IsEntityAttachedToEntity(Ped, skateboard.Bike) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 6, 2000)
				Attached = false
				Dir = {}
				if GetEntityModel(Ped) == `a_c_cat_01` then
					stopAnim("creatures@cat@move", "idle_upp")
					stopAnim("creatures@cat@move", "idle_dwn")
				else
					stopAnim("move_strafe@stealth", "idle")
				end
			end
			Wait(1000)
		end
		hideText()
	end)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	hideText()
	if DoesEntityExist(skateboard.Bike) then
		DeleteVehicle(skateboard.Bike)
	end
end)

--------------------------------------------------------------------

local targetEntities = {}
function createEntityTarget(entity, opts, dist)
    targetEntities[#targetEntities+1] = entity
    if GetResourceState('ox_target'):find("start") then
        local options = {}
        for i = 1, #opts do
            options[i] = {
                icon = opts[i].icon,
                label = opts[i].label,
                item = opts[i].item or nil,
                groups = opts[i].job or opts[i].gang,
                onSelect = opts[i].action,
                canInteract = function(_, distance)
                    return distance < dist and true or false
                end
            }
        end
        exports['ox_target']:addLocalEntity(entity, options)
    end
end

function removeEntityTarget(entity)
    if GetResourceState('ox_target'):find("start") then exports['ox_target']:removeLocalEntity(entity, nil) end
end

function destroyProp(entity)
	if entity then
		if IsEntityAttachedToEntity(entity, PlayerPedId()) then
			SetEntityAsMissionEntity(entity)
			DetachEntity(entity, true, true)
		end
		DeleteObject(entity)
	end
end

function loadAnimDict(animDict)
	if not DoesAnimDictExist(animDict) then return
	else
		while not HasAnimDictLoaded(animDict) do RequestAnimDict(animDict) Wait(5) end
	end
end

function unloadAnimDict(animDict)
	RemoveAnimDict(animDict)
end

function playAnim(animDict, animName, duration, flag, ped)
	loadAnimDict(animDict)
	TaskPlayAnim(ped and ped or PlayerPedId(), animDict, animName, 8.0, -8.0, duration or 30000, flag or 50, 1, false, false, false)
end

function stopAnim(animDict, animName, ped)
	StopAnimTask(ped or PlayerPedId(), animDict, animName, 0.5)
	StopAnimTask(ped or PlayerPedId(), animName, animDict, 0.5)
	unloadAnimDict(animDict)
end

function startTempCam(cam)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 1000, true, true)
end

function stopTempCam()
	CreateThread(function()
		Wait(1000)
		RenderScriptCams(false, true, 500, true, true)
		DestroyAllCams()
	end)
end

local time = 500
function loadModel(model)
	if not IsModelValid(model) then return
	else
		if not HasModelLoaded(model) then
			while not HasModelLoaded(model) and time > 0 do time = 1 RequestModel(model) Wait(0) end
			if not HasModelLoaded(model) then end
		end
		time = 500
	end
end

function unloadModel(model)
	SetModelAsNoLongerNeeded(model)
end

local Props = {}

function makeVeh(model, coords)
	loadModel(model)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(veh), true)
	Wait(100)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
	SetVehicleModKit(veh, 0)
	SetVehicleOnGroundProperly(veh)
	unloadModel(model)
    return veh
end

function makeProp(data, freeze, synced)
    loadModel(data.prop)
    local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z-1.03, synced and synced or false, synced and synced or false, false)
    SetEntityHeading(prop, data.coords.w + 180.0)
    FreezeEntityPosition(prop, freeze and freeze or 0)
	unloadModel(data.prop)
	Props[#Props+1] = prop
	return prop
end

function createTempCam(ent, coords)
	local cam = nil
	local camCoords = nil
	if type(ent) ~= "vector3" then
		camCoords = GetOffsetFromEntityInWorldCoords(ent, 1.2, -0.3, 0.8)
	else
		camCoords = ent
	end
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords.x, camCoords.y, camCoords.z+0.5, 1.0, 0.0, 0.0, 60.00, false, 0)
	PointCamAtCoord(cam, coords)
	return cam
end

function drawText(image, input, style) local text = ""
	for k, v in pairs(input) do
		input[k] = v.."   \n"
	end
	exports['ox_lib']:showTextUI(table.concat(input), { icon = "fas fa-hand-holding", position = 'left-center' })
end

function hideText()
    exports['ox_lib']:hideTextUI()
end