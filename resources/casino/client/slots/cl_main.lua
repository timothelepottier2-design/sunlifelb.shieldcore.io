local NearestSlot = nil
local NearestSlotType = nil
local PlayingSlot = nil
local PlayingSlotType = nil
local TextureDict = nil
local AnimDict = nil
local LeaveAnimation = nil
local SlotScaleForm = nil
local ScreenHandle = nil
local Reels = {}
local InstructionalButtons = nil
local CurrentBet = 0
local IsAnimated = false

AddEventHandler('zCore:onPlayerDeath', function()
	SlotLeave(true)
end)

AddEventHandler("casino:entered", function()
    inCasino = true
end)

AddEventHandler("casino:exited", function()
    inCasino = false
end)

local function isPlayerNearIllegalCasinoSlots()
    if IllegalCasino == nil or IllegalCasino.ZoneCenter == nil then
        return false
    end
    return #(GetEntityCoords(PlayerPedId()) - IllegalCasino.ZoneCenter) < 110.0
end

local function isPlayerNearStandaloneSlots()
    if not ConfigSlots.StandaloneMachines then
        return false
    end
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, machine in ipairs(ConfigSlots.StandaloneMachines) do
        local c = machine.coords
        if #(playerCoords - vector3(c.x, c.y, c.z)) < (machine.detectDistance or 100.0) then
            return true
        end
    end
    return false
end

-- Spawn / despawn des machines placées hors casino (props absents de la map).
local StandaloneObjects = {}
Citizen.CreateThread(function()
    if not ConfigSlots.StandaloneMachines then return end

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, machine in ipairs(ConfigSlots.StandaloneMachines) do
            local c = machine.coords
            local distance = #(playerCoords - vector3(c.x, c.y, c.z))

            if distance < (machine.spawnDistance or 150.0) then
                if not StandaloneObjects[i] or not DoesEntityExist(StandaloneObjects[i]) then
                    local model = ConfigSlots.Machines[machine.machineType].Model
                    RequestModel(model)
                    local timeout = GetGameTimer() + 10000
                    while not HasModelLoaded(model) and GetGameTimer() < timeout do
                        Citizen.Wait(10)
                    end
                    if HasModelLoaded(model) then
                        local obj = CreateObject(model, c.x, c.y, c.z, false, false, false)
                        SetEntityHeading(obj, c.w)
                        FreezeEntityPosition(obj, true)
                        SetModelAsNoLongerNeeded(model)
                        StandaloneObjects[i] = obj
                    end
                end
            elseif StandaloneObjects[i] and DoesEntityExist(StandaloneObjects[i]) then
                DeleteEntity(StandaloneObjects[i])
                StandaloneObjects[i] = nil
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
	while true do
		if inCasino or isPlayerNearIllegalCasinoSlots() or isPlayerNearStandaloneSlots() then
			NearestSlot, NearestSlotType = SlotGetNearest()
		else
			NearestSlot, NearestSlotType = nil, nil
		end
		Citizen.Wait(500)
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for i, obj in pairs(StandaloneObjects) do
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
        StandaloneObjects[i] = nil
    end
end)

function SlotGetNearest()
    local playerCoords = GetEntityCoords(PlayerPedId())
	local nearSlot, nearSlotDistance, nearSlotType
	for id, slotConfig in pairs(ConfigSlots.Machines) do
		local slot = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 2.25, slotConfig.Model, false, false, false)
		if slot ~= 0 and DoesEntityExist(slot) then
			local slotDistance = #(playerCoords - GetEntityCoords(slot))
			if not nearSlot or slotDistance < nearSlotDistance then
				nearSlot = slot
				nearSlotType = id
				nearSlotDistance = slotDistance
			end
		end
	end
    return nearSlot, nearSlotType
end

Citizen.CreateThread(function()
	called = false
	while true do
		local sleepTime = 1000
		if not PlayingSlot and NearestSlot then
			CASINO["nearThing"] = true
			sleepTime = 0

			if not called then
				called = true
				PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)
			end

			ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour jouer à la ~y~Machine à sous')

            local sitPos = GetOffsetFromEntityInWorldCoords(NearestSlot, 0.0, -0.85, 0.65)
            DrawMarker(20, vector3(sitPos.x, sitPos.y, sitPos.z + 0.70), nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 0, 105, 0, 100, false, true)

			if IsControlJustPressed(0, 38) then
				local nearSlot, nearSlotType = SlotGetNearest()
                if nearSlot then
					ESX.TriggerServerCallback("slots:canUse", function(canUse)
						if canUse then
							PlayingSlot, PlayingSlotType = nearSlot, nearSlotType
							SlotStartGame()
						end
					end, tostring(GetEntityCoords(nearSlot)))
                end
			end
		else
			CASINO["nearThing"] = false
			called = false
		end
		Citizen.Wait(sleepTime)
	end
end)

CreateNamedRenderTargetForModel = function(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

function SlotStartGame()
	CASINO["playing"] = true
	Citizen.CreateThread(function()
		SlotSit()
		local slotConfig = ConfigSlots.Machines[PlayingSlotType]
		
		-- Setup instructional buttons
		InstructionalButtons = SetupInstructionalButtons({ {key = 194, label = "Quitter"}, {key = 201, label = "Jouer"}, {key = 203, label = "Miser"}, {key = 204, label = "Miser Max"}, {key = 210, label = "Gains"} })
		
		-- Request scaleform and screen handle
		SlotScaleForm = SlotCreateScaleform()
		ScreenHandle = CreateNamedRenderTargetForModel(slotConfig.Target, slotConfig.Model)
		
		-- Request texture dictionary
		TextureDict = slotConfig.Textures
		RequestStreamedTextureDict(TextureDict)
		
		-- Set slot theme
		SlotSetTheme(SlotScaleForm, slotConfig.Theme)
		
		-- Init last win to 0
		SlotSetLastWin(SlotScaleForm, 0)
		
		-- Init bet to default bet
		CurrentBet = slotConfig.Bet
		SlotSetBet(SlotScaleForm, slotConfig.Bet)
		
		-- Init slot message
		SlotSetMessage(SlotScaleForm, true, PlayingSlotType)
        
        -- For illness
        SetPedCanRagdoll(PlayerPedId(), false)
		
		-- Display Bet One and Max bet
		ESX.ShowHelpNotification('Mise simple: ~y~'..slotConfig.Bet..' jetons\n~s~Mise maximum: ~y~'..slotConfig.Bet*ConfigSlots.MaxBetMultiplier..' jetons', false, false, 5000)

		if not IsAudioSceneActive('dlc_vw_casino_slot_machines_playing') then
			StartAudioScene("dlc_vw_casino_slot_machines_playing")
		end
		
		local defaultRender = GetDefaultScriptRendertargetRenderId()
		
		while PlayingSlot do
			Citizen.Wait(0)
			
			-- Disable controls
            DisableAllControlActions(0)
            
            -- Enable basic control
            EnableControlAction(0, 0, true)   -- changing camera V
            EnableControlAction(0, 1, true)   -- mouse cam
            EnableControlAction(0, 2, true)   -- mouse cam
            EnableControlAction(0, 249, true) -- PTT
            EnableControlAction(0, 20, true)  -- W MultiplayerInfo
			
			-- Instructional Buttons
			-- if not IsAnimated then
				DrawScaleformMovieFullscreen(InstructionalButtons, 255, 255, 255, 255, 0)
			-- end
			
			-- Balance
			-- SlotDrawAdvancedText(1, 'Jetons', GroupDigits(CASINO["myJetons"]))
            SlotDrawAdvancedText(2, 'Mise', tostring(CurrentBet))
            
            -- Camera
            N_0x79c0e43eb9b944e2(518572876)
			
			-- Leave Slot
			if not IsAnimated and IsDisabledControlJustPressed(0, 202) then
				SlotLeave()
				break
			end
			
			-- Rules
			if not IsAnimated and IsDisabledControlJustPressed(0, 210) then
				SlotShowRules()
			end
			
			-- Spin
			if not IsAnimated and IsDisabledControlJustPressed(0, 201) then
				SlotSpinStart()
			end
			
			-- Bet
			if not IsAnimated and IsDisabledControlJustPressed(0, 203) then
				SlotBet()
			end
			
			-- Bet Max
			if not IsAnimated and IsDisabledControlJustPressed(0, 204) then
				SlotBetMax()
			end
			
			-- Draw scaleform
			N_0x32f34ff7f617643b(SlotScaleForm, 1)
			SetTextRenderId(ScreenHandle)
			SetScriptGfxDrawOrder(4)
			SetScriptGfxDrawBehindPausemenu(true)
			DrawScaleformMovie(SlotScaleForm, 0.401, 0.09, 0.805, 0.195, 255, 255, 255, 255, 0)
			SetTextRenderId(defaultRender)
			
			if not IsAnimated then
                SlotPlaySeatAnimation('base_idle')
            end
		end
	end)
end

RegisterNetEvent('slots:spinSlot')
AddEventHandler('slots:spinSlot', function(source, slotType, coords, result, multiplier)
	local slot = GetClosestObjectOfType(coords, 0.5, ConfigSlots.Machines[slotType].Model, false, false, false)
	local slotHeading = GetEntityHeading(slot)
	local slotCoords = GetEntityCoords(slot)
	local slotConfig = ConfigSlots.Machines[slotType]
	local reelResult = {}
	local reelsOffsets = {
		vector3(-0.115, 0.047, 0.906),
		vector3(0.005, 0.047, 0.906),
		vector3(0.125, 0.047, 0.906),
	}
	
	if source == GetPlayerServerId(PlayerId()) then
		Citizen.CreateThread(function()
            Citizen.Wait(1000)
            SlotPlaySeatAnimation('spinning')
            Citizen.Wait(4000)
            SlotSpinEnd(multiplier)
		end)
	end
	
	if not Reels[coords] then
		Reels[coords] = {}
	end
	
	-- Cleanup reels if any
	for _, reel in pairs(Reels[coords]) do
		SetEntityVisible(reel, false, 0)
		DeleteEntity(reel)
	end
	Reels[coords] = {}

	-- Create spinning reels
	RequestModel(slotConfig.ReelsSpinningModel)
	for i, offset in ipairs(reelsOffsets) do
		local reelCoords = GetObjectOffsetFromCoords(slotCoords, slotHeading, offset.x, offset.y, offset.z)
		Reels[coords][i] = CreateObject(slotConfig.ReelsSpinningModel, reelCoords, false, false, false)
		FreezeEntityPosition(Reels[coords][i], true)
		SetEntityCollision(Reels[coords][i], false, false)
		SetEntityRotation(Reels[coords][i], 0.0, 0.0, slotHeading, 2, true)
	end
	SetModelAsNoLongerNeeded(slotConfig.ReelsSpinningModel)
	
	-- PlaySoundFromCoord(soundId, audioName, x, y, z, audioRef, p6, range, p8)

	PlaySoundFromCoord(-1, "spinning", slotCoords, slotConfig.Sounds, false, 20, false)
	PlaySoundFromCoord(-1, "start_spin", slotCoords, slotConfig.Sounds, false, 20, false)
	-- PlaySoundFromCoord(soundId, audioName, x, y, z, audioRef, p6, range, p8)
	
	-- Rotate spinning reels
	Citizen.CreateThread(function()
		local timeout = GetGameTimer() + 5000 -- Spinning animation is 5000ms
		local rotation = 0.0
		while timeout > GetGameTimer() do
			for i, reel in pairs(Reels[coords]) do
				if not reelResult[i] then
					SetEntityRotation(reel, rotation + (i*32), 0.0, slotHeading, 2, true)
				end
				rotation = rotation + 1.0
			end
			Citizen.Wait(0)
		end
	end)
	
	-- Create reels
	Citizen.Wait(5000 - (3 * 500)) -- Spinning animation is 5000ms
	RequestModel(slotConfig.ReelsModel)
	for i, offset in ipairs(reelsOffsets) do
		Citizen.Wait(500)
		DeleteEntity(Reels[coords][i])
		local reelCoords = GetObjectOffsetFromCoords(slotCoords, slotHeading, offset.x, offset.y, offset.z)
		Reels[coords][i] = CreateObject(slotConfig.ReelsModel, reelCoords, false, false, false)
		SetEntityAsNoLongerNeeded(Reels[coords][i])
		FreezeEntityPosition(Reels[coords][i], true)
		SetEntityCollision(Reels[coords][i], false, false)
		reelResult[i] = (360.0/32) * result[i]
		PlaySoundFromCoord(-1, (result[i] % 2) == 0 and "wheel_stop_on_prize" or "wheel_stop_clunk", slotCoords, slotConfig.Sounds, false, 20, false)
		SetEntityRotation(Reels[coords][i], reelResult[i], 0.0, slotHeading, 2, true)
	end
	SetModelAsNoLongerNeeded(slotConfig.ReelsModel)
	
	if multiplier == 0 then
		-- lost
		PlaySoundFromCoord(-1, "no_win", slotCoords, slotConfig.Sounds, false, 20, false)
	elseif multiplier > 5 then
		-- X25 and more
		PlaySoundFromCoord(-1, "jackpot", slotCoords, slotConfig.Sounds, false, 20, false)
	elseif multiplier == 5 then
		-- x5
		PlaySoundFromCoord(-1, "big_win", slotCoords, slotConfig.Sounds, false, 20, false)
	else
		-- x2
		PlaySoundFromCoord(-1, "small_win", slotCoords, slotConfig.Sounds, false, 20, false)
	end
	
end)

RegisterNetEvent('slots:spinSlotFailed')
AddEventHandler('slots:spinSlotFailed', function()
	Citizen.Wait(1500)
	IsAnimated = false
end)

function SlotBet()
	Citizen.CreateThread(function()
		IsAnimated = true

		local amount = getGenericTextInput("Indiquez votre mise")
		amount = tonumber(amount)

		local slotConfig = ConfigSlots.Machines[PlayingSlotType]
		local zezette = slotConfig.Bet*ConfigSlots.MaxBetMultiplier

		print(amount)
		print(zezette)

		if amount > zezette then
			ESX.ShowNotification("Limite de mise atteinte")
		else
			if amount ~= nil then
				CurrentBet = amount
				SlotSetBet(SlotScaleForm, CurrentBet)
			end
		end

		SlotPlaySeatAnimation('press_betone_a')
        Citizen.Wait(750)
		IsAnimated = false
	end)
end

function SlotBetMax()
	Citizen.CreateThread(function()
		IsAnimated = true
		local slotConfig = ConfigSlots.Machines[PlayingSlotType]
		CurrentBet = slotConfig.Bet*ConfigSlots.MaxBetMultiplier
		SlotSetBet(SlotScaleForm, slotConfig.Bet*ConfigSlots.MaxBetMultiplier)
		SlotPlaySeatAnimation('press_betmax_a')
        Citizen.Wait(750)
		IsAnimated = false
	end)
end

function SlotSpinStart()
	IsAnimated = true
	SlotPlaySeatAnimation('press_spin')
	local players = {}
	for _, player in ipairs(GetActivePlayers()) do
		table.insert(players, GetPlayerServerId(player))
	end
	TriggerServerEvent('slots:spinSlot', PlayingSlotType, GetEntityCoords(PlayingSlot), CurrentBet, players) 
end

function SlotSpinEnd(multiplier)
	if multiplier == 0 then
		-- lost
		ESX.ShowHelpNotification('Vous avez perdu '..CurrentBet..' jetons', false, false, 3000)
		SlotSetMessage(SlotScaleForm, false, PlayingSlotType)
		SlotSetLastWin(SlotScaleForm, 0)
		SlotPlaySeatAnimation('lose')
        Citizen.Wait(1250)
	elseif multiplier > 5 then
		-- jackpot
		ESX.ShowHelpNotification('Vous avez gagné '..(CurrentBet*multiplier)..' jetons !!!', false, false, 3000)
		SlotSetMessage(SlotScaleForm, true, PlayingSlotType)
		SlotSetLastWin(SlotScaleForm, CurrentBet*multiplier)
		SlotPlaySeatAnimation('win_big')
        Citizen.Wait(5000)
	else
		-- x2, x5
		ESX.ShowHelpNotification('Vous avez gagné '..(CurrentBet*multiplier)..' jetons !', false, false, 3000)
		SlotSetMessage(SlotScaleForm, true, PlayingSlotType)
		SlotSetLastWin(SlotScaleForm, CurrentBet*multiplier)
		SlotPlaySeatAnimation('win')
        Citizen.Wait(1250)
	end
	IsAnimated = false
end

function SlotShowRules()
	IsAnimated = true
	PlaySoundFrontend(-1, "DLC_VW_RULES", "dlc_vw_table_games_frontend_sounds", true)

	local coords = GetEntityCoords(PlayerPedId())

	RMenu.Add('casino', 'main', RageUI.CreateMenu("Machine à sous", "Liste des règles", 1, 100))
    RMenu:Get('casino', "main").Closed = function()
        CASINO["menuOpenned"] = false

        RMenu:Delete('casino', 'main')
    end

    if CASINO["menuOpenned"] then
        CASINO["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        CASINO["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('casino', 'main'), true)
    end

    CASINO["secretaryData"] = {}

    Citizen.CreateThread(function()
        while CASINO["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                CASINO["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('casino', 'main'), true, true, true, function()

                for i, winning in pairs(ConfigSlots.Machines[PlayingSlotType].Winnings) do
                    RageUI.Button(winning, nil, {RightLabel = '~y~'..ConfigSlots.WinningsMultiplier[i]..'X'}, true, function(Hovered, Active, Selected) end)
                end

            end)

        end
		IsAnimated = false
		InstructionalButtons = SetupInstructionalButtons({ {key = 194, label = "Quitter"}, {key = 201, label = "Jouer"}, {key = 203, label = "Miser"}, {key = 204, label = "Miser Max"}, {key = 210, label = "Gains"} })
    end)
end

function SlotCreateScaleform()
    local scaleform = RequestScaleformMovieInstance("SLOT_MACHINE");
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
	return scaleform
end

function SlotSetTheme(scaleform, theme)
	BeginScaleformMovieMethod(scaleform, 'SET_THEME')
    ScaleformMovieMethodAddParamInt(theme)
    EndScaleformMovieMethod()
end

function SlotSetLastWin(scaleform, amount)
	BeginScaleformMovieMethod(scaleform, 'SET_LAST_WIN')
    ScaleformMovieMethodAddParamInt(amount)
    EndScaleformMovieMethod()
end

function SlotSetBet(scaleform, amount)
	BeginScaleformMovieMethod(scaleform, 'SET_BET')
    ScaleformMovieMethodAddParamInt(amount)
    EndScaleformMovieMethod()
end

function SlotSetMessage(scaleform, winner, slotType)
	local rand = math.random(1, 16)
	if rand < 10 then rand = "0"..rand end
	local message = 'SLOTS_MES'..(not winner and 'N' or 'P')..slotType..rand
	BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')
    BeginTextCommandScaleformString(message)
	EndTextCommandScaleformString()
    EndScaleformMovieMethod()
end

function SlotSit()
	IsAnimated = true
	local playerPed = PlayerPedId()
	TriggerEvent('skinchanger:getSkin', function(skin)
		AnimDict = 'anim_casino_a@amb@casino@games@slots@male'
		if skin.sex == 1 then
			AnimDict = 'anim_casino_a@amb@casino@games@slots@female'
		end
	end)

	RequestAnimDict(AnimDict)
	local slotCoords = GetEntityCoords(PlayingSlot)
	local slotRotation = GetEntityRotation(PlayingSlot)
	local right = GetAnimInitialOffsetPosition(AnimDict, 'enter_right', slotCoords.x, slotCoords.y, slotCoords.z, slotRotation.x, slotRotation.y, slotRotation.z, 0.01, 2)
	local left = GetAnimInitialOffsetPosition(AnimDict, 'enter_left', slotCoords.x, slotCoords.y, slotCoords.z, slotRotation.x, slotRotation.y, slotRotation.z, 0.01, 2)
	
	local playerCoords = GetEntityCoords(playerPed)
	local animData = #(playerCoords - left) < #(playerCoords - right) and {left, 'enter_left', 'exit_left'} or {right, 'enter_right', 'exit_right'}
	local initialCoords = animData[1]
	local animName = animData[2]
	LeaveAnimation = animData[3]
	
	--SlotPlaySeatAnimationSynchronizedTask(animName, 1, 0, true)
    local sitPos = GetOffsetFromEntityInWorldCoords(PlayingSlot, 0.0, -0.85, 0.65)
	TaskStartScenarioAtPosition(playerPed, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', sitPos, GetEntityHeading(PlayingSlot), -1, true, true)
    Citizen.Wait(2000)
	IsAnimated = false
end

function SlotLeave(skipAnim)
	CASINO["playing"] = false

	if LeaveAnimation == nil then
		LeaveAnimation = "exit_left"
	end

	if not skipAnim then
		IsAnimated = true
        ClearPedTasksImmediately(PlayerPedId())
		SlotPlaySeatAnimationSynchronizedTask(LeaveAnimation, 0, 0, true)
		IsAnimated = false
	end
	
	if IsAudioSceneActive('dlc_vw_casino_slot_machines_playing') then
		StopAudioScene('dlc_vw_casino_slot_machines_playing')
	end
	
    SetPedCanRagdoll(PlayerPedId(), true)
        
	RemoveAnimDict(AnimDict)
	SetStreamedTextureDictAsNoLongerNeeded(TextureDict)
	
	SetScaleformMovieAsNoLongerNeeded(SlotScaleForm)
	SlotScaleForm = nil
	
	ReleaseNamedRendertarget(ScreenHandle)
	
	TriggerServerEvent('slots:leaveSlot', tostring(GetEntityCoords(PlayingSlot)))
	PlayingSlot = nil
end

function SlotGetAnims(baseAnim)
	local sceneConfig = ConfigSlots.Scenes[baseAnim]
	local anims = {baseAnim}
	if sceneConfig.Variations then
		anims = {}
		for _, variation in pairs(sceneConfig.Variations) do
			table.insert(anims, baseAnim..'_'..variation)
		end
	end
	return anims
end

function SlotPlaySeatAnimationSynchronizedTask(anim, freezeLastFrame, looped, wait)
	local playerPed = PlayerPedId()
	local sceneConfig = ConfigSlots.Scenes[anim]
	
	local anims = SlotGetAnims(anim)
	
	for _ , variation in pairs(anims) do
		if IsEntityPlayingAnim(playerPed, AnimDict, variation, 3) then
			return
		end
	end
	
	anim = anims[math.random(1, #anims)]
	
	local slotCoords = GetEntityCoords(PlayingSlot)
	local slotRotation = GetEntityRotation(PlayingSlot)
	
	local netTask = NetworkCreateSynchronisedScene(slotCoords.x, slotCoords.y, slotCoords.z, slotRotation.x, slotRotation.y, slotRotation.z, 2, freezeLastFrame, looped, 1.0, 0, 1.0)
	NetworkAddPedToSynchronisedScene(playerPed, netTask, AnimDict, anim, sceneConfig.BlendInSpeed, sceneConfig.BlendOutSpeed, sceneConfig.Duration, sceneConfig.Flag, sceneConfig.PlaybackRate, 0)
	NetworkStartSynchronisedScene(netTask)
    
    if wait then
        Citizen.Wait(math.floor(GetAnimDuration(AnimDict, anim)) * 1000)
    end
end

function SlotPlaySeatAnimation(anim, wait)
    local playerPed = PlayerPedId()
    local sceneConfig = ConfigSlots.Scenes[anim]
    
    local anims = SlotGetAnims(anim)
    
    for _ , variation in pairs(anims) do
        if IsEntityPlayingAnim(playerPed, AnimDict, variation, 3) then
            return
        end
    end
    
    anim = anims[math.random(1, #anims)]
    
    TaskPlayAnim(playerPed, AnimDict, anim, sceneConfig.BlendInSpeed, sceneConfig.BlendOutSpeed, -1, sceneConfig.Flag)
    
    if wait then
        Citizen.Wait(math.floor(GetAnimDuration(AnimDict, anim)) * 1000)
    end
end