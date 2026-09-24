DEATHSCREEN = DEATHSCREEN or {}
DEATHSCREEN.UI = DEATHSCREEN.UI or {}
DEATHSCREEN.BleedoutTimer = 0
DEATHSCREEN.EarlySpawnTimer = 0
DEATHSCREEN.DeathCause = ""

function DEATHSCREEN.UI.ShowNUI()
	deathscreenFocusReleased = false
	SetNuiFocus(true, true)
	local bMin, bSec = secondsToClock(DEATHSCREEN.BleedoutTimer)
	local eMin, eSec = secondsToClock(DEATHSCREEN.EarlySpawnTimer)
	SendNUIMessage({
		type = 'deathscreenShow',
		bleedoutMinutes = bMin,
		bleedoutSeconds = bSec,
		earlySpawnMinutes = eMin,
		earlySpawnSeconds = eSec,
		earlySpawnTimer = DEATHSCREEN.EarlySpawnTimer,
		deathCause = DEATHSCREEN.DeathCause,
		playerServerId = GetPlayerServerId(PlayerId()),
		killerServerId = DEATHSCREEN.KillerServerId,
		emergencyCooldownSeconds = Config.EmergencyButtonCooldown or 150
	})
end

function DEATHSCREEN.UI.UpdateNUI()
	local bMin, bSec = secondsToClock(DEATHSCREEN.BleedoutTimer)
	local eMin, eSec = secondsToClock(DEATHSCREEN.EarlySpawnTimer)
	SendNUIMessage({
		type = 'deathscreenUpdate',
		bleedoutMinutes = bMin,
		bleedoutSeconds = bSec,
		earlySpawnMinutes = eMin,
		earlySpawnSeconds = eSec,
		earlySpawnTimer = DEATHSCREEN.EarlySpawnTimer,
		deathCause = DEATHSCREEN.DeathCause,
		playerServerId = GetPlayerServerId(PlayerId()),
		killerServerId = DEATHSCREEN.KillerServerId
	})
end

function DEATHSCREEN.UI.HideNUI()
	SetNuiFocus(false, false)
	SendNUIMessage({ type = 'deathscreenHide' })
end

local deathscreenFocusReleased = false
RegisterNetEvent('adminmenu:closed')
AddEventHandler('adminmenu:closed', function()
	if deathscreenFocusReleased and IsDead then
		deathscreenFocusReleased = false
		SetNuiFocus(true, true)
	end
end)

RegisterNUICallback('deathscreenAction', function(data, cb)
	cb('ok')
	local action = data and data.action
	if action == 'key_f10' then
		deathscreenFocusReleased = true
		SetNuiFocus(false, false)
		ExecuteCommand('Adminmenu')
	elseif action == 'key_insert' then
		SetNuiFocus(false, false)
		ExecuteCommand('seeid')
		CreateThread(function()
			Wait(5500)
			if IsDead and DEATHSCREEN.UI and DEATHSCREEN.UI.ShowNUI then
				SetNuiFocus(true, true)
			end
		end)
	elseif action == 'hospital' then
		if DEATHSCREEN.EarlySpawnTimer <= 0 then
			TriggerServerEvent("rems:removeItems")

		else
			RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "ERROR")
			if ESX and ESX.ShowNotification then
				ESX.ShowNotification("~r~Vous ne pouvez pas retourner à l'hôpital avant la fin du timer.")
			end
		end
	elseif action == 'emergency' then
		TriggerEvent("AppelemsGetCoords")
	elseif action == 'report' then
		ExecuteCommand('report')
	elseif action == 'cheater' then

		if DEATHSCREEN.KillerServerId and tonumber(DEATHSCREEN.KillerServerId) and tonumber(DEATHSCREEN.KillerServerId) > 0 then
			TriggerServerEvent("antisbire:voteCheater", tonumber(DEATHSCREEN.KillerServerId))
		end
	end
end)
