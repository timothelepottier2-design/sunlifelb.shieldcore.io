ESX = nil

local VehiculeRecup = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local spawnedKart = nil
local spawnedF1 = nil

function spawnKart()
	print("Spawning Kart...")

    if spawnedKart then
        DeleteVehicle(spawnedKart)
        spawnedKart = nil
    end

    local model = GetHashKey("veto2")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    TriggerServerEvent('eye:veh:authorize', model, 'location')
    print(('^5[NETDIAG][VEHICLE]^7 %s lockart.lua:30 CreateVehicle NETWORKED (kart) model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local veh = CreateVehicle(model, -155.53338623047, -2140.2521972656, 16.705060958862, 207.52156066895, true, false)
    SetVehicleNumberPlateText(veh, "KART")
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    ESX.ShowNotification("Kart spawn avec succès !")
    spawnedKart = veh
    if GetResourceState('sunlife_ui') == 'started' then TriggerServerEvent("snl_quest:triggerComplete", "rent_kart") end
end

function spawnF1()
    if spawnedF1 then
        DeleteVehicle(spawnedF1)
        spawnedF1 = nil
    end

    local model = GetHashKey("openwheel1")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    TriggerServerEvent('eye:veh:authorize', model, 'location')
    print(('^5[NETDIAG][VEHICLE]^7 %s lockart.lua:51 CreateVehicle NETWORKED (F1) model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local veh = CreateVehicle(model, -5779.5844726562, -8689.35546875, 55.744194030762, 269.43307495117, true, false)
    SetVehicleNumberPlateText(veh, "F1")
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    ESX.ShowNotification("F1 spawn avec succès !")
    spawnedF1 = veh
    if GetResourceState('sunlife_ui') == 'started' then TriggerServerEvent("snl_quest:triggerComplete", "rent_kart") end
end

local positionkarting = {
	{x = -154.2045, y = -2151.526, z = 15.80507, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(positionkarting) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, positionkarting[k].x, positionkarting[k].y, positionkarting[k].z)

			if dist <= 3.0 then
				nearThing = true

				ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] louer un karting")
				DrawMarker(6, positionkarting[k].x, positionkarting[k].y, positionkarting[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				if IsControlJustPressed(1,51) then
					spawnKart()
				end
			end
		end
		if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

local positionf1 = {
	{x = -5781.9760742188, y = -8695.041015625, z = 54.861600494385, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(positionf1) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, positionf1[k].x, positionf1[k].y, positionf1[k].z)

			if dist <= 3.0 then
				nearThing = true

				ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] louer une F1")
				DrawMarker(6, positionf1[k].x, positionf1[k].y, positionf1[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				if IsControlJustPressed(1,51) then
					spawnF1()
				end
			end
		end
		if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

Citizen.CreateThread(function()
	local karting = AddBlipForCoord(-153.0161, -2146.492, 15.80506)
	SetBlipSprite (karting, 596)
	SetBlipDisplay(karting, 4)
	SetBlipScale(karting, 0.8)
	SetBlipColour (karting, 1)
	SetBlipAsShortRange(karting, true)
	AddTextEntry("BN_SUNLIFE_KARTING_1", "Karting")
	BeginTextCommandSetBlipName("BN_SUNLIFE_KARTING_1")
	EndTextCommandSetBlipName(karting)
end)
