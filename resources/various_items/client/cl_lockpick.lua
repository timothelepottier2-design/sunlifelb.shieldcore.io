ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('various_items:useLockpick')
AddEventHandler('various_items:useLockpick', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			SetVehicleAlarm(vehicle, true)
			StartVehicleAlarm(vehicle)

            RequestAnimDict("mp_arresting")
            while (not HasAnimDictLoaded("mp_arresting")) do Citizen.Wait(0) end
            TaskPlayAnim(playerPed, "mp_arresting", "a_uncuff", 1.0 ,-1.0 , 5500, 0, 1, true, true, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification("Véhicule ouvert !")
			end)
		end
	end
end)