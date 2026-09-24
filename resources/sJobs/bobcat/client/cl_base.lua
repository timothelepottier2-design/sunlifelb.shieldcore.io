Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = job.grade_name
end)

BOBCAT = {
    ["points"] = {
		["missionPoint"] = {
            {pos = vector3(-664.604858, -2380.067139, 13.034291)},
        },
    },

	["menuOpenned"] = false,

	["missions"] = {
        [1] = {
            {
                name = "Transport de sacs d'argent",
                reward = 200000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(-147.4644, -586.0787, 32.42447)},
                },
            },
			{
                name = "Transport de lingot d'or",
                reward = 250000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(-4.219981, -710.7819, 32.3381)},
                },
            },
            {
                name = "Transport de pièces d'armes",
                reward = 300000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(2543.225, 2581.627, 37.94483)},
                },
            },
        },
        [2] = {
            {
                name = "Transport de médicaments",
                reward = 400000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(587.9368, 2789.509, 42.19179)},
                },
            },
			{
                name = "Transport de lingot d'or",
                reward = 450000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(1726.37, 3714.545, 34.17873)},
                },
            },
            {
                name = "Transport de pièces d'armes",
                reward = 500000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(1208.001, 2718.006, 38.00314)},
                },
            },
        },
        [3] = {
            {
                name = "Transport de médicaments",
                reward = 500000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(587.9368, 2789.509, 42.19179)},
                },
            },
			{
                name = "Transport de lingot d'or",
                reward = 550000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(271.9436, 2854.408, 43.63779)},
                },
            },
            {
                name = "Transport de pièces d'armes",
                reward = 600000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(2553.157, 4672.267, 33.93912)},
                },
            },
        },
        [4] = {
			{
                name = "Transport de sacs d'argent",
                reward = 650000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(1713.085, 4800.446, 41.78166)},
                },
            },
			{
                name = "Transport de lingot d'or",
                reward = 700000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(-118.4633, 6484.082, 31.43759)},
                },
            },
            {
                name = "Transport de pièces d'armes",
                reward = 750000,
                startPoint = {
                    pos = vector3(-670.756409, -2376.724609, 13.814963),
                    heading = 58.42456817627,
                },
                vehicleHash = "stockade2",
                points = {
                    {pos = vector3(-1133.604, 2695.142, 18.8004)},
                },
            },
        },
    },
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k,v in pairs(BOBCAT["points"]["missionPoint"]) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

			if dist <= 3.0 then
				nearThing = true

				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'bobcat' then
					DrawMarker(6, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 100, false, false)
			   		RageUI.Text({
						message = "Appuyez sur [~o~E~w~] pour acceder au menu des missions",
						time_display = 1
					})
					if IsControlJustPressed(0, 38) then
						BOBCAT.openMissions()
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(1000)
		end
	end
end)
