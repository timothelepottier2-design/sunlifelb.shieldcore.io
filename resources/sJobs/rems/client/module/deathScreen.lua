DEATHSCREEN = DEATHSCREEN or {}
DEATHSCREEN.UI = DEATHSCREEN.UI or {}

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.7)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local s = tonumber(seconds) or 0
	if s <= 0 then
		return 0, 0
	end
	local mins = math.floor(s / 60)
	local secs = math.floor(s % 60)
	return mins, secs
end

local _pendingHospitalTimerCb = nil

RegisterNetEvent('rems:hospitalTimerResult', function(hospitalReturnSeconds, autoRespawnAtEnd)
	local cb = _pendingHospitalTimerCb
	_pendingHospitalTimerCb = nil
	if cb then
		cb(hospitalReturnSeconds, autoRespawnAtEnd)
	end
end)

function StartDeathTimer(deathCause, killerServerId)

	if DEATHSCREEN.UI and DEATHSCREEN.UI.HideNUI then
		DEATHSCREEN.UI.HideNUI()
	end

	DEATHSCREEN.DeathCause = deathCause or ""
	DEATHSCREEN.KillerServerId = killerServerId
	DEATHSCREEN.AutoRespawnAtEnd = false

	_pendingHospitalTimerCb = function(hospitalReturnSeconds, autoRespawnAtEnd)
		local earlySpawnTimer = math.floor(hospitalReturnSeconds)
		DEATHSCREEN.EarlySpawnTimer = earlySpawnTimer
		DEATHSCREEN.BleedoutTimer = earlySpawnTimer
		DEATHSCREEN.AutoRespawnAtEnd = autoRespawnAtEnd

		Citizen.CreateThread(function()
			while earlySpawnTimer > 0 and IsDead do
				Citizen.Wait(1000)
				if earlySpawnTimer > 0 then
					earlySpawnTimer = earlySpawnTimer - 1
					DEATHSCREEN.EarlySpawnTimer = earlySpawnTimer
					DEATHSCREEN.BleedoutTimer = earlySpawnTimer
				end
			end

			if IsDead and DEATHSCREEN.AutoRespawnAtEnd then
				TriggerServerEvent("rems:removeItems")
			end
		end)

		Citizen.CreateThread(function()
			Wait(300)
			if not IsDead then return end
			if DEATHSCREEN.UI.ShowNUI then
				DEATHSCREEN.UI.ShowNUI()
			end
			local lastUpdate = 0
			local deathStartTime = GetGameTimer()
			local autoCallEmsDone = false
			while IsDead do
				Wait(0)
				DisableControlAction(0, 249, true)

				EnableControlAction(0, 57, true)
				EnableControlAction(0, 121, true)
				EnableControlAction(2, 57, true)
				EnableControlAction(2, 121, true)
				local now = GetGameTimer()

				if not autoCallEmsDone and (now - deathStartTime) >= 30000 then
					autoCallEmsDone = true
					TriggerEvent("AppelemsGetCoords")
				end
				if now - lastUpdate >= 500 then
					lastUpdate = now
					if DEATHSCREEN.UI.UpdateNUI then
						DEATHSCREEN.UI.UpdateNUI()
					end
				end
			end
			if DEATHSCREEN.UI.HideNUI then
				DEATHSCREEN.UI.HideNUI()
			end
		end)
	end

	TriggerServerEvent('rems:requestHospitalTimer')
end
