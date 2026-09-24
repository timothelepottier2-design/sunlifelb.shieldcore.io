local isUsingEMSIt = false

local FirstSpawn, PlayerLoaded = true, false

IsDead = false
ESX = nil
Nombreinter = 0
ReaFaite = false
local cam = nil
local angleY = 0.0
local angleZ = 0.0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Normal()
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	if ESX and ESX.PlayerData then
		ESX.PlayerData.job = job
	end
end)

AddEventHandler('playerSpawned', function()
	IsDead = false
	if FirstSpawn then
		exports.spawnmanager:setAutoSpawn(false)
		FirstSpawn = false
		Wait(10000)
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
			if isDead and Config.AntiCombatLog then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end
				ESX.ShowNotification(_U('combatlog_message'))
				SetEntityHealth(PlayerPedId(), 0)
			end
		end)
	end
end)

exports("IsDead", function ()
	return IsDead
end)

function OnPlayerDeath()
	if exports.sunlife_ui:IsInGunFightZone() then return end
	IsDead = true
	ExecuteCommand('closepause')
	SetFrontendActive(false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
	local reason, killerServerId = GetCauseOffDeath()
	StartDeathTimer(reason, killerServerId)
	TriggerServerEvent("ambulance:addLastDeathCause", reason)

end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	if itemName == 'medikit' then
		local libAnim = 'anim@heists@narcotics@funding@gang_idle'
        local anim = 'gang_chatting_idle01'
		local playerPed = PlayerPedId()
		local coordsPed = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(PlayerPedId(), false) then
			ESX.ShowNotification("Vous avez fait tombé votre kit de soins dans le véhicule et il est tombé au sol. Il est inutilisable...")
			return
		end

		isUsingEMSIt = true

    		local success = lib.progressCircle({
        		duration = 10000,
        		label = '⌛ Ajout du kit de soins...',
                useWhileDead = false,
                canCancel = false,
        		disable = {
            		car = true,
            		move = true,
            		combat = true,
        		},
        		anim = {
            		dict = libAnim,
            		clip = anim,
        		},
    		})

    		if success then
        		TriggerEvent('esx_ambulancejob:heal', 'big', true)

        		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsPed, true) > 1.0 then
            		ESX.ShowNotification("Vous n'avez pas pu mettre ce kit de soins car vous avez bougé.")
        		else
            		SetPedArmour(pPed, 200)
            		ESX.ShowNotification('~o~Vous avez utilisé un kit de soins !')
        		end
    		end

		isUsingEMSIt = false
	elseif itemName == 'bandage' then
		local libAnim, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
		local playerPed = PlayerPedId()
		local coordsPed = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(PlayerPedId(), false) then
			ESX.ShowNotification("Vous avez fait tombé votre bandage dans le véhicule et il s'est infecté, vous ne pouvez donc plus l'utiliser...")
			return
		end

		isUsingEMSIt = true

    		local success = lib.progressCircle({
        		duration = 10000,
        		label = '⌛ Ajout du bandage...',
        		useWhileDead = false,
        		canCancel = false,
        		disable = {
            		car = true,
            		move = true,
            		combat = true,
        		},
        		anim = {
            		dict = libAnim,
            		clip = anim,
        		},
    		})

    		if success then
        		local pedCoords = GetEntityCoords(PlayerPedId())

        		if GetDistanceBetweenCoords(pedCoords, coordsPed, true) > 1.0 then
            		ESX.ShowNotification("Vous n'avez pas pu mettre ce bandage car vous avez bougé.")
        		else
            		TriggerEvent('esx_ambulancejob:heal', 'small', true)
            		ESX.ShowNotification('~o~Vous avez utilisé un bandage !')
        		end
    		end

		isUsingEMSIt = false
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.402, 0.845)

			if IsControlPressed(0, 47) then
				TriggerEvent("AppelemsGetCoords")

				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if IsDead then
						StartDistressSignal()
					end
				end)

				break
			end
		end
	end)
end

RegisterNetEvent('esx_ambulancejob:notif')
AddEventHandler('esx_ambulancejob:notif', function()
	Nombreinter = Nombreinter - 1
	if Nombreinter < 0 then
		Nombreinter = 0
	end
	ReaFaite = true
	ESX.ShowAdvancedNotification('EMS INFO', 'EMS CENTRAL', 'Réanimation effectué.\n~o~150$~w~ Ajouté au coffre entreprise.\n~o~'..Nombreinter..' intervention en cours.', 'CHAR_MP_MORS_MUTUAL', 3)
end)

function Normal()
	local playerPed = PlayerPedId()
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	SetPedMotionBlur(playerPed, false)
end

local litRea = {
    vector3(-659.079956, 359.491547, 82.851221),
    vector3(-662.263977, 359.855621, 82.854715),
    vector3(-656.158142, 359.278595, 82.853654),
    vector3(-653.110535, 359.054199, 82.854692),
}

local litReaNord = {
	vector3(-252.332153, 6312.379883, 33.080753),
	vector3(-254.167023, 6314.006348, 32.754475),
}

local litReaCayo = {
	vector3(4956.4936523438, -5103.400390625, 4.062029838562),
	vector3(4952.7895507812, -5098.3012695312, 4.0620365142822),
}

local litReaVenturas = {
	{ coords = vector3(7494.396973, 396.531219, 62.162563), heading = 353.01654052734 },
	{ coords = vector3(7497.522949, 399.641602, 62.122334), heading = 353.01654052734 },
	{ coords = vector3(7500.500488, 402.811340, 62.049873), heading = 353.01654052734 },
}

local TempsRestant = 0
function AfterDeath(temps)
	TempsRestant = 10000
	local pPed = PlayerPedId()
	if DEATHSCREEN and DEATHSCREEN.UI and DEATHSCREEN.UI.HideNUI then
		DEATHSCREEN.UI.HideNUI()
	end
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	RespawnPed(pPed, GetEntityCoords(pPed), 252.0)
	RemoveAllPedWeapons(pPed, 1)
	TriggerEvent("status:refresh", 100, 100)
	TriggerServerEvent("ems:removeappel", GetPlayerServerId(PlayerId()))

	local lit = litRea[math.random(1,#litRea)]
	local litnord = litReaNord[math.random(1,#litReaNord)]
	local litcayo = litReaCayo[math.random(1,#litReaCayo)]
	local litventuras = litReaVenturas[math.random(1,#litReaVenturas)]
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 6875.147461, -546.440857, 57.257523, true) <= 3000.0 then
		SetEntityCoords(pPed, litventuras.coords, 0.0, 0.0, 0.0, 0)
		SetEntityHeading(pPed, litventuras.heading)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 4929.001953125, -5277.1782226562, 4.9025950431824, true) <= 800 then
		SetEntityCoords(pPed, litcayo, 0.0, 0.0, 0.0, 0)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 755.57, 4899.1, 0, true) <= 2500 then
		SetEntityCoords(pPed, litnord, 0.0, 0.0, 0.0, 0)
	else
		SetEntityCoords(pPed, lit, 0.0, 0.0, 0.0, 0)
	end

	if GetHashKey("mp_m_freemode_01") == GetEntityModel(pPed) then
		TriggerEvent("skinchanger:change", 'tshirt_1', 5)
		TriggerEvent("skinchanger:change", 'tshirt_2', 0)
		TriggerEvent("skinchanger:change", 'mask_1', 0)
		TriggerEvent("skinchanger:change", 'glasses_1', 0)
		TriggerEvent("skinchanger:change", 'helmet_1', -1)
		TriggerEvent("skinchanger:change", 'bags_1', 0)
		TriggerEvent("skinchanger:change", 'torso_1', 5)
		TriggerEvent("skinchanger:change", 'torso_2', 0)
		TriggerEvent("skinchanger:change", 'pants_1', 5)
		TriggerEvent("skinchanger:change", 'pants_2', 0)
		TriggerEvent("skinchanger:change", 'arms', 5)
		TriggerEvent("skinchanger:change", 'arms_2', 0)
		TriggerEvent("skinchanger:change", 'shoes_1', 6)
		TriggerEvent("skinchanger:change", 'shoes_2',0)
	end
	StopScreenEffect('DeathFailOut')
	FreezeEntityPosition(pPed, 0)
	DoScreenFadeIn(2500)
	DisplayRadar(true)
	ExecuteCommand("ToggleHUDT")
	RequestAnimSet("move_injured_generic")
	while not HasAnimSetLoaded("move_injured_generic") do
		Citizen.Wait(0)
	end
	IsDead = false
	TriggerServerEvent('ambulance:RemoveLastDeathCause')
	SetPedMovementClipset(pPed, "move_injured_generic", true)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	EnableAllControlActions(0)

end

function Timeur(temps)
	TempsRestant = temps*60*1000
	Citizen.CreateThread(function()
		while TempsRestant > 0 do
			Wait(0)
			TempsRestant = TempsRestant - 10
		end
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
end

RegisterNetEvent('rEMS:Reanimation')
AddEventHandler('rEMS:Reanimation', function(coords)
	local pPed = PlayerPedId()

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(pPed, formattedCoords, 0.0)
		TriggerEvent("status:refresh", 100, 100)
		TriggerServerEvent("ems:removeappel", GetPlayerServerId(PlayerId()))
		TriggerServerEvent('ambulance:RemoveLastDeathCause')

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		DisplayRadar(true)
		ExecuteCommand("ToggleHUDT")

		ESX.ShowAdvancedNotification('Sécurité sociale', '~o~Information.', 'Vous avez été réanimé, ~o~'..string.format(Config.ReviveReward / 2)..'~w~$ vous ont été déduits automatiquement.', 'CHAR_MP_MORS_MUTUAL', 3)
		TriggerServerEvent("snl_quest:triggerComplete", "get_revived")
	end)
end)

RegisterNetEvent('rems:staffRevive')
AddEventHandler('rems:staffRevive', function()

	Nombreinter = Nombreinter - 1
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)
		TriggerEvent("status:refresh", 100, 100)
		TriggerServerEvent("ems:removeappel", GetPlayerServerId(PlayerId()))
		TriggerServerEvent('ambulance:RemoveLastDeathCause')

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		DisplayRadar(true)
		ExecuteCommand("ToggleHUDT")
	end)
end)

RegisterNetEvent('rems:removeItemsDone')
AddEventHandler('rems:removeItemsDone', function()
	IsDead = false
	RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "SELECT")
	if exports["pma-voice"] then
		exports["pma-voice"]:setVoiceProperty("voiceEnable", true)
		exports['pma-voice']:resetProximityCheck()
	end
	AfterDeath()
end)

RegisterNetEvent('rems:emsRevive')
AddEventHandler('rems:emsRevive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)
		TriggerEvent("status:refresh", 100, 100)
		TriggerServerEvent("ems:removeappel", GetPlayerServerId(PlayerId()))
		TriggerServerEvent('ambulance:RemoveLastDeathCause')

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		DisplayRadar(true)
		ExecuteCommand("ToggleHUDT")

		ESX.ShowNotification('~o~Votre Santé\n~s~Tu as été réanimé par un medecin !')
		TriggerServerEvent("snl_quest:triggerComplete", "get_revived")
	end)
end)

function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
		SetBlipNameToPlayerName(blip, id)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 69)
		SetBlipShrink(blip, true)
		SetBlipShowCone(blip, true)
		ShowFriendIndicatorOnBlip(blip, true)

		table.insert(blipsEMS, blip)
	end
end

RegisterNetEvent('EMS:updateBlip')
AddEventHandler('EMS:updateBlip', function()
	blipsEMS = {}
end)

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)

    cam = nil
end

function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    DisableFirstPersonCamThisFrame()

    local newPos = ProcessNewPosition()

    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0

    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0

    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end

    local pCoords = GetEntityCoords(PlayerPedId())

    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (2.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (2.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (2.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = 2.5
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 2.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return pos
end

function isUsingEMSItem()
	return isUsingEMSIt
end
