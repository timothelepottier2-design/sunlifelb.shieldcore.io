local piggyBackInProgress = false
local piggyBackAnimNamePlaying = ""
local piggyBackAnimDictPlaying = ""
local piggyBackControlFlagPlaying = 0

local function F5_GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

local function F5_GetClosestPlayer(radius)
    local players = F5_GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    if closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function displayHelpNotif()
	while piggyBackInProgress do
		ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour lâcher la personne")
		if IsControlJustPressed(0, 38) then
			piggyBackInProgress = false
			ClearPedSecondaryTask(PlayerPedId())
			DetachEntity(PlayerPedId(), true, false)
			local closestPlayer = F5_GetClosestPlayer(3)
			if closestPlayer and closestPlayer ~= -1 then
				local target = GetPlayerServerId(closestPlayer)
				if target ~= 0 then
					TriggerServerEvent("cmg2_animations:stop", target)
				end
			end
		end
		Wait(0)
	end
end

RegisterCommand("piggyback",function(source, args)
	if not piggyBackInProgress then
		local animLib = 'anim@arena@celeb@flat@paired@no_props@'
		local anim1 = 'piggyback_c_player_a'
		local anim2 = 'piggyback_c_player_b'
		local distans = -0.07
		local distans2 = 0.0
		local height = 0.45
		local spin = 0.0
		local length = 100000
		local controlFlagMe = 49
		local controlFlagTarget = 33
		local animFlagTarget = 1
		local closestPlayer = F5_GetClosestPlayer(3)

		if closestPlayer ~= -1 and closestPlayer ~= nil then
			local target = GetPlayerServerId(closestPlayer)

			TriggerServerEvent('cmg2_animations:requestCarry', target, animLib, anim1, anim2, distans, distans2, height, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget)
			drawNativeNotification("Demande de portage envoyée, en attente de la réponse...")
		else
			drawNativeNotification("Personne n'est proche !")
		end
	else
		piggyBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = F5_GetClosestPlayer(3)
		local target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then
			TriggerServerEvent("cmg2_animations:stop",target)
		end
	end
end,false)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	piggyBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	piggyBackAnimNamePlaying = animation2
	piggyBackAnimDictPlaying = animationLib
	piggyBackControlFlagPlaying = controlFlag
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)
	piggyBackInProgress = true
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	piggyBackAnimNamePlaying = animation
	piggyBackAnimDictPlaying = animationLib
	piggyBackControlFlagPlaying = controlFlag

	Citizen.CreateThread(displayHelpNotif)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	piggyBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('cmg2_animations:askCarry')
AddEventHandler('cmg2_animations:askCarry', function(carrierSrc, carrierName)
	local accepted = lib.alertDialog({
		header = 'Demande de portage',
		content = ('**%s** souhaite vous porter.\n\nAcceptez-vous d\'être porté(e) ?'):format(carrierName or 'Un joueur'),
		centered = true,
		cancel = true,
		labels = {
			confirm = 'Accepter',
			cancel = 'Refuser'
		}
	})

	TriggerServerEvent('cmg2_animations:carryResponse', carrierSrc, accepted == 'confirm')
end)

RegisterNetEvent('cmg2_animations:carryRefused')
AddEventHandler('cmg2_animations:carryRefused', function()
	drawNativeNotification("La personne a refusé d'être portée.")
end)

Citizen.CreateThread(function()
	while true do
		if piggyBackInProgress then
			while not IsEntityPlayingAnim(PlayerPedId(), piggyBackAnimDictPlaying, piggyBackAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), piggyBackAnimDictPlaying, piggyBackAnimNamePlaying, 8.0, -8.0, 100000, piggyBackControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    local ped = PlayerPedId()

	if not piggyBackInProgress then
		return
	end

	local currentVehicle = GetVehiclePedIsIn(ped, false)

	if IsPedInAnyVehicle(ped, true) and GetPedInVehicleSeat(currentVehicle, -1) == ped then
		ESX.ShowNotification("Vous ne pouvez pas porter quelqu'un en tant que conducteur !")

		piggyBackInProgress = false
		ClearPedSecondaryTask(ped)
		DetachEntity(ped, true, false)

		local closestPlayer = F5_GetClosestPlayer(3)
		local target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then
			TriggerServerEvent("cmg2_animations:stop", target)
		end
	end
end)

function isInPiggy()
	return piggyBackInProgress
end
