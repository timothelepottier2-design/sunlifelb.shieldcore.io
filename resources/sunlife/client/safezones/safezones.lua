local zones = {
	{ ['x'] = -321.27, ['y'] = -888.52, ['z'] = 31.07},
	{ ['x'] = -675.9964, ['y'] = 319.4065, ['z'] = 82.18317 },
	{ ['x'] = -1388.812, ['y'] = -602.4538, ['z'] = 29.46681 },
	{ ['x'] = 231.1, ['y'] = -794.27, ['z'] = 30.59 },
	{ ['x'] = -192.31, ['y'] = -1188.91, ['z'] = 21.85 },
	{ ['x'] = -1417.44, ['y'] = -445.92, ['z'] = 35.91 },
	{ ['x'] = -201.42, ['y'] = -1325.21, ['z'] = 30.91 },
	{ ['x'] = 48.519477844238, ['y'] = 6513.1474609375, ['z'] = 31.01283416748 },
	{ ['x'] = 1114.24, ['y'] = 238.64, ['z'] = -49.84 },
	{ ['x'] = -1392.57, ['y'] = -614.0895, ['z'] = 31.17713 },
	{ ['x'] = 803.3502, ['y'] = -752.8791, ['z'] = 26.78086 },
	{ ['x'] = -919.4249, ['y'] = -2035.355, ['z'] = 9.571888 },
	{ ['x'] = -344.6982, ['y'] = -132.2122, ['z'] = 38.09126 },
	{ ['x'] = -829.672607, ['y'] = -798.754761, ['z'] = 20.644390 },
	{ ['x'] = 129.7641, ['y'] = -1300.098, ['z'] = 28.30769 },
	{ ['x'] = -1266.8, ['y'] = -3011.354, ['z'] = -47.01814 },
	{ ['x'] = -240.46846008301, ['y'] = 6211.1748046875, ['z'] = 32.066986083984 },
	{ ['x'] = -774.32525634766, ['y'] = -228.81816101074, ['z'] = 36.573204040527 },
	{ ['x'] = -40.5335, ['y'] = -1095.1333, ['z'] = 27.2744 },
	{ ['x'] = 1687.958252, ['y'] = 2522.106934, ['z'] = 45.564846 },
	{ ['x'] = 928.5335, ['y'] = 54.1333, ['z'] = 81.2744 },
	{ ['x'] = -2174.948486, ['y'] = -366.583527, ['z'] = 13.148614 },
	{ ['x'] = 3850.768799, ['y'] = 37.069344,   ['z'] = 21.099392 },
	{ ['x'] = 3941.442139, ['y'] = 36.020210,   ['z'] = 23.875767 },
	{ ['x'] = 4044.653320, ['y'] = 25.157255,   ['z'] = 20.381504 },
	{ ['x'] = -1615.701416, ['y'] = -853.653015,   ['z'] = 10.111926 },
	{ ['x'] = 3969.195801, ['y'] = 26.720921,   ['z'] = 23.587288 },
	{ ['x'] = 9.900731, ['y'] = -1099.000244,   ['z'] = 29.033287 },
	{ ['x'] = -1249.182617, ['y'] = -279.367096,   ['z'] = 37.690506 },
	{ ['x'] = -826.338135, ['y'] = -113.016678,   ['z'] = 37.166294 }, -- Turko Kebab
	{ ['x'] = -581.225708, ['y'] = -1062.719116,  ['z'] = 22.005825 }, -- Uwu Café
	{ ['x'] = 423.22268676758, ['y'] = -800.81176757812, ['z'] = 28.49342918396 },
	{ ['x'] = 77.648490905762, ['y'] = -1398.3321533203, ['z'] = 28.378427505493 },
	{ ['x'] = -825.73181152344, ['y'] = -1078.2236328125, ['z'] = 10.330401420593 },
	{ ['x'] = -1192.9029541016, ['y'] = -774.93121337891, ['z'] = 16.329011917114 },
	{ ['x'] = 121.5486831665, ['y'] = -217.99000549316, ['z'] = 53.557655334473 },
	{ ['x'] = 1690.8974609375, ['y'] = 4827.9189453125, ['z'] = 41.065380096436 },
	{ ['x'] = 620.08636474609, ['y'] = 2759.3217773438, ['z'] = 41.088218688965 },
	{ ['x'] = -1104.052734375, ['y'] = 2705.3447265625, ['z'] = 18.110151290894 },
	{ ['x'] = -3174.0808105469, ['y'] = 1049.5626220703, ['z'] = 19.863349914551 },
	{ ['x'] = 7.3645577430725, ['y'] = 6517.7827148438, ['z'] = 30.880138397217 },
	{ ['x'] = 1191.2204589844, ['y'] = 2707.9565429688, ['z'] = 37.224899291992 },
	{ ['x'] = -711.18353271484, ['y'] = -150.35595703125, ['z'] = 36.415191650391 },
	{ ['x'] = -164.43942260742, ['y'] = -305.75686645508, ['z'] = 38.733337402344 },
	{ ['x'] = 7348.331055, ['y'] = 411.692719, ['z'] = 57.053400 },
	{ ['x'] = -422.7724609375, ['y'] = 1134.0544433594, ['z'] = 325.85467529297 },
}

local notifIn = false
local notifOut = false
local closestZone = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
end)

local function isLSFD()
    local jobName = ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
    return jobName == 'lsfd'
end

AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData = ESX.PlayerData or {}
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	for k,v in pairs(exports["sunlife_ui"]:GetAllGarages()) do
		table.insert(zones, { ['x'] = v.x, ['y'] = v.y, ['z'] = v.z })
	end

	while true do
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
		local nearThing = false

		if dist <= 50.0 then
			nearThing = true
			if not notifIn then

				ESX.ShowNotification("Vous entrez en zone safe ! Le port du masque est interdit comme dans tous les lieux publics.")

				if isLSFD() then

					NetworkSetFriendlyFireOption(true)
					SetEntityInvincible(PlayerPedId(), false)
				else

					NetworkSetFriendlyFireOption(false)
					ClearPlayerWantedLevel(PlayerId())
					SetEntityInvincible(PlayerPedId(), true)
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
				end

				TriggerEvent("UI:ShowSafe")
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				ESX.ShowNotification("Vous sortez de la zone safe !")
				NetworkSetFriendlyFireOption(true)
				SetEntityInvincible(PlayerPedId(), false)
				TriggerEvent("UI:HideSafe")
				notifOut = true
				notifIn = false
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
		if notifIn then
			if not isLSFD() then
				DisableControlAction(2, 37, true)
				DisablePlayerFiring(player, true)
				DisableControlAction(0, 106, true)
				DisableControlAction(0, 64, true)
				SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)

				if IsDisabledControlJustPressed(2, 37) or IsDisabledControlJustPressed(0, 106) then
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
				end
			end
		end
	end
end)

exports("InZoneSafe", function()
	local player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(player, true))
	local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	local nearThing = false

	if dist <= 50.0 then
		return true
	else
		return false
	end
end)
