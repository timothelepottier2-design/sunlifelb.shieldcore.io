local riding = false
local oldCoords = vector3(0,0,0)

local GlobSpeed = 0
local GlobCurAnim = ""
local RandWait = 0
local globTimer = 0

local RideDict = "move_m@jogger"
local RideAnim = "run"

local ROLLER = {}
local player = nil
local isHomme = true
local Attached = false

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
    LoadAnim("move_f@jogger")
    LoadAnim("move_m@jogger")
    LoadAnim("anim@heists@heist_corona@team_idles@female_a")
    while true do
		local wantstoride = false
        local oldCoords = GetEntityCoords(PlayerPedId())
        local oldTimer = GetGameTimer()
        while riding do
            Citizen.Wait(500)
			wantstoride = true
            local currentTimer = GetGameTimer()
            local curCoords = GetEntityCoords(PlayerPedId())
            local dist = Vdist(curCoords,oldCoords)
            oldCoords = curCoords
            
            GlobSpeed = dist
            
            if dist > 0.1 then
                if not IsEntityPlayingAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 3) then
                    RandDeclench = math.random(1,1000)
                    
                    if (currentTimer-oldTimer) > 3000 then
                        globTimer = (currentTimer-oldTimer)
                        oldTimer = currentTimer
                        
                        if not IsEntityPlayingAnim(PlayerPedId(), RideDict, RideAnim, 3) then
                            TaskPlayAnim(PlayerPedId(), RideDict, RideAnim, 1.0, 1.0, 4000, 0, 0, 0, 0, 0)
                            GlobCurAnim = "Riding Forced"
                        end
                    else
                        if RandDeclench > 750 then
                            oldTimer = currentTimer
                            globTimer = (currentTimer-oldTimer)
                            if not IsEntityPlayingAnim(PlayerPedId(), RideDict, RideAnim, 3) then
                                TaskPlayAnim(PlayerPedId(), RideDict, RideAnim, 1.0, 1.0, 4000, 0, 0, 0, 0, 0)
                                GlobCurAnim = "Riding"
                            end
                        else
                            if not IsEntityPlayingAnim(PlayerPedId(), RideDict, RideAnim,3) then
                                TaskPlayAnim(PlayerPedId(), "anim@heists@heist_corona@team_idles@female_a", "idle", 8.0, 8.0, -1, 0, 0, 0, 0, 0)
                                GlobCurAnim = "Idle Riding"
                            end
                        end
                    end
                end
            else
                if IsEntityPlayingAnim(PlayerPedId(), "anim@heists@heist_corona@team_idles@female_a", "idle", 3) then
                    StopAnimTask(PlayerPedId(), "anim@heists@heist_corona@team_idles@female_a", "idle", 1.0)
                end
                
                if IsEntityPlayingAnim(PlayerPedId(), RideDict, RideAnim, 3) then
                    StopAnimTask(PlayerPedId(), RideDict, RideAnim, 1.0)
                end
            end
        end
		if wantstoride then
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
    end
end)

function getSex()
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		isHomme = true 
		RideDict = "move_m@jogger"
		RideAnim = "run"
	elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
		isHomme = false
		RideDict = "move_f@jogger"
		RideAnim = "run"
	end
	return isHomme
end

local CurrentShoes = 0
local CurrentShoesColor = 0

RegisterNetEvent('Rollers:LessGo')
AddEventHandler('Rollers:LessGo', function()
	if IsPedInAnyVehicle(PlayerPedId(), true) then
		ESX.ShowNotification("~r~Vous ne pouvez pas mettre vos rollers dans un véhicule.")
		return
	end

	CurrentShoes = GetPedDrawableVariation(PlayerPedId(), 6)
	CurrentShoesColor = GetPedTextureVariation(PlayerPedId(),6)
	
	LoadAnim("amb@medic@standing@tendtodead@base")
	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@base", "base", 1.0, 1.0, 3500, 0, 0, 0, 0, 0)
	
	TriggerEvent("roller:ride")
	ESX.ShowNotification("~g~Vous venez de mettre vos rollers. Appuyez sur E pour les retirer.")
	
	Citizen.Wait(3000)
	
	if getSex() then
		SetPedComponentVariation(PlayerPedId(), 6, cfg_roller.RollerSlotHomme, cfg_roller.RollerColorHomme, 2)
	else
		SetPedComponentVariation(PlayerPedId(), 6, cfg_roller.RollerSlotFemme, cfg_roller.RollerColorFemme, 2)
	end
	
	TriggerEvent("roller:attach")
	Citizen.Wait(1500)
	TaskPlayAnim(PlayerPedId(), "anim@heists@heist_corona@team_idles@female_a", "idle", 8.0, 8.0, -1, 0, 0, 0, 0, 0)
	riding = true
	while riding == true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 38) then
			riding = false
			Citizen.Wait(1500)
			ROLLER.AttachPlayer(false)
			ROLLER.Attach("pick")
			SetPedComponentVariation(PlayerPedId(),6,CurrentShoes,CurrentShoesColor,2)
		end
	end
end)

RegisterCommand("leave", function()
	riding = false
	Citizen.Wait(1500)
	ROLLER.AttachPlayer(false)
	ROLLER.Attach("pick")
	SetPedComponentVariation(PlayerPedId(),6,CurrentShoes,CurrentShoesColor,2)
end)

RegisterNetEvent("roller:ride")
AddEventHandler("roller:ride", function(id)
	ROLLER.Start()
end)

RegisterNetEvent("roller:attach")
AddEventHandler("roller:attach", function(id)
	ROLLER.AttachPlayer(true)
end)

function ROLLER.Start()
	if DoesEntityExist(ROLLER.Entity) then ROLLER.Clear() end

	ROLLER.Spawn()
	
	while DoesEntityExist(ROLLER.Entity) and DoesEntityExist(ROLLER.Driver) do
		Citizen.Wait(5)
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(ROLLER.Entity), true)

		ROLLER.HandleKeys(distanceCheck)

		if not IsPedInAnyVehicle(ROLLER.Driver) then
			TaskWarpPedIntoVehicle(ROLLER.Driver, ROLLER.Entity, -1)
		end

		if distanceCheck <= cfg_roller.LoseConnectionDistance then
			if not NetworkHasControlOfEntity(ROLLER.Driver) then
				NetworkRequestControlOfEntity(ROLLER.Driver)
			elseif not NetworkHasControlOfEntity(ROLLER.Entity) then
				NetworkRequestControlOfEntity(ROLLER.Entity)
			end
		else
			TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 6, 2500)
		end
	end
end

ROLLER.HandleKeys = function(distanceCheck)
	if not (distanceCheck <= 1.5) then
		if Attached then
		    ROLLER.AttachPlayer(false)
		    riding = false
		end
		if IsControlJustReleased(0, 113) then
			ROLLER.AttachPlayer(false)
			riding = false
		end
	end
	
	if distanceCheck < cfg_roller.LoseConnectionDistance then
		local overSpeed = (GetEntitySpeed(ROLLER.Entity)*3.6) > cfg_roller.MaxSpeedKmh

        TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 1, 1)
		ForceVehicleEngineAudio(ROLLER.Entity, 0)
		
		Citizen.CreateThread(function()
			player = PlayerPedId()
			Citizen.Wait(1)
			SetEntityInvincible(ROLLER.Entity, true)
            StopCurrentPlayingAmbientSpeech(ROLLER.Driver)
            
			if Attached then
				ROLLER.Speed = GetEntitySpeed(ROLLER.Entity) * 3.6
			end
		end)
		
		if Attached then
            if IsControlPressed(0, 71) and not IsControlPressed(0, 72) and not overSpeed then
                TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 9, 1)
            end

            if IsControlPressed(0, 22) and Attached then
                if not IsEntityInAir(ROLLER.Entity) then	
                    local vel = GetEntityVelocity(ROLLER.Entity)
                    TaskPlayAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)
                    local duration = 0
                    local boost = 0
                    while IsControlPressed(0, 22) do
                        Citizen.Wait(10)
                        duration = duration + 10.0
                        if not IsEntityPlayingAnim(PlayerPedId(),"move_crouch_proto", "idle_intro",3) then
                        TaskPlayAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)
                        end
                    end
                    boost = cfg_roller.maxJumpHeigh * duration / 250.0 
                    if boost > cfg_roller.maxJumpHeigh then boost = cfg_roller.maxJumpHeigh end
                    if(Attached) then
                        SetEntityVelocity(ROLLER.Entity, vel.x, vel.y, vel.z + boost)
                    end
                    TaskPlayAnim(PlayerPedId(), "anim@heists@heist_corona@team_idles@female_a", "idle", 1.0, 1.0, 4000, 0, 0, 0, 0, 0)
                end
            end

			if IsControlJustReleased(0, 71) or IsControlJustReleased(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 6, 2500)
			end

			if IsControlPressed(0, 72) and not IsControlPressed(0, 71) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 22, 1)
			end

			if IsControlPressed(0, 64) and IsControlPressed(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 13, 1)
			end

			if IsControlPressed(0, 64) and IsControlPressed(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 14, 1)
			end

			if IsControlPressed(0, 71) and IsControlPressed(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 30, 100)
			end

			if IsControlPressed(0, 63) and IsControlPressed(0, 71) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 7, 1)
			end

			if IsControlPressed(0, 64) and IsControlPressed(0, 71) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 8, 1)
			end

			if IsControlPressed(0, 63) and not IsControlPressed(0, 71) and not IsControlPressed(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 4, 1)
			end

			if IsControlPressed(0, 64) and not IsControlPressed(0, 71) and not IsControlPressed(0, 72) and not overSpeed then
				TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 5, 1)
			end
		end
	end
end

function ROLLER.Spawn()
	ROLLER.LoadModels({ GetHashKey("bmx"), 68070371, GetHashKey("p_defilied_ragdoll_01_s"), "pickup_object", "move_strafe@stealth", "move_crouch_proto"})

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

	print(('^5[NETDIAG][VEHICLE]^7 %s cl_roller.lua:289 CreateVehicle NETWORKED bmx'):format(GetCurrentResourceName()))
	ROLLER.Entity = CreateVehicle(GetHashKey("bmx"), spawnCoords, spawnHeading, true)
	while not DoesEntityExist(ROLLER.Entity) do
		Citizen.Wait(5)
	end

	SetVehicleNumberPlateText(ROLLER.Entity, "BMX")
	SetEntityNoCollisionEntity(ROLLER.Entity, player, false)
	SetEntityCollision(ROLLER.Entity, false, true)
	SetEntityVisible(ROLLER.Entity, false)

	print(('^6[NETDIAG][PED]^7 %s cl_roller.lua:299 CreatePed NETWORKED driver'):format(GetCurrentResourceName()))
	ROLLER.Driver = CreatePed(12, 68070371, spawnCoords, spawnHeading, true, true)

	SetEnableHandcuffs(ROLLER.Driver, true)
	SetEntityInvincible(ROLLER.Driver, true)
	SetEntityVisible(ROLLER.Driver, false)
	FreezeEntityPosition(ROLLER.Driver, true)
	TaskWarpPedIntoVehicle(ROLLER.Driver, ROLLER.Entity, -1)

	while not IsPedInVehicle(ROLLER.Driver, ROLLER.Entity) do
		Citizen.Wait(0)
	end

	ROLLER.Attach("place")
end

function ROLLER.Attach(param)
	if not DoesEntityExist(ROLLER.Entity) then
		return
	end
	
	if param == "place" then
		AttachEntityToEntity(ROLLER.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.3, 70.0, 0.0, 270.0, 0, 0, 0, 0, 2, 1)
		Citizen.Wait(800)
		DetachEntity(ROLLER.Entity, false, true)
		PlaceObjectOnGroundProperly(ROLLER.Entity)
	elseif param == "pick" then
		Citizen.Wait(100)
		AttachEntityToEntity(ROLLER.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 0, 0, 0, 0, 2, 1)
		Citizen.Wait(900)
		ROLLER.Clear()
	end
end

function ROLLER.Clear(models)
	DetachEntity(ROLLER.Entity)
	DeleteVehicle(ROLLER.Entity)
	DeleteEntity(ROLLER.Driver)

	ROLLER.UnloadModels()
	Attach = false
	Attached  = false
	SetPedRagdollOnCollision(player, false)
end

function ROLLER.LoadModels(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not ROLLER.CachedModels then
			ROLLER.CachedModels = {}
		end

		table.insert(ROLLER.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Citizen.Wait(10)
			end    
		end
	end
end

function ROLLER.UnloadModels()
	for modelIndex = 1, #ROLLER.CachedModels do
		local model = ROLLER.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end

ROLLER.AttachPlayer = function(toggle)
	if toggle then
		AttachEntityToEntity(player, ROLLER.Entity, 20, 0.0, 0, 0.70, 0.0, 0.0, 0.0, false, false, false, true, 1, true)
		SetEntityCollision(player, true, true)
	elseif not toggle then
		DetachEntity(player, false, false)
		TaskVehicleTempAction(ROLLER.Driver, ROLLER.Entity, 3, 1)	
	end	
	Attached = toggle
end