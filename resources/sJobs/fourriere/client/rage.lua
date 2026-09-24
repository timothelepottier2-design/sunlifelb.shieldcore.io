ESX = nil

local FourriereOpen = false
local action = false
local OnMenuActive = false
local EnAction = false
local SpawnVehicule = {coords = vector3(451.5693359375, -1153.4914550781, 29.418937683105)}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local filter = 1
local citizen = nil

local canAnnounce = true

local FOURRIERE_ANNONCE_GRADES_BLOQUES = {
	["recrue"] = true,
	["recrues"] = true,
	["stagiaire"] = true,
}

local function canUseAnnonces()
	local pdata = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
	local grade = pdata and pdata.job and pdata.job.grade_name
	if not grade then return false end
	return not FOURRIERE_ANNONCE_GRADES_BLOQUES[tostring(grade):lower()]
end

local fourriereAnnonces = {
	{
		label = "Ouverture de la fourrière",
		icon  = "~g~●",
		text  = "La fourrière est désormais ouverte ! Nos équipes sont disponibles pour l'enlèvement et la restitution de vos véhicules.",
	},
	{
		label = "Fermeture de la fourrière",
		icon  = "~r~●",
		text  = "La fourrière est désormais fermée, repassez plus tard !",
	},
	{
		label = "Recrutement",
		icon  = "~y~●",
		text  = "La fourrière recrute ! Présentez-vous directement sur place avec votre CV pour rejoindre nos équipes.",
		bossOnly = true, -- reserve au patron (verifie aussi cote serveur)
	},
}

local function isFourriereBoss()
	local pdata = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
	local grade = pdata and pdata.job and pdata.job.grade_name
	return grade ~= nil and tostring(grade):lower() == "boss"
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	RMenu.Add('fourriere', 'main', RageUI.CreateMenu("SUNLIFE", "Menu Fourrière", 1, 100))
	RMenu.Add('fourriere', 'auto', RageUI.CreateMenu("SUNLIFE", "Menu Fourrière", 1, 100))
	RMenu.Add('fourriere', 'interactions', RageUI.CreateSubMenu(RMenu:Get('fourriere', 'main'), "SUNLIFE", "Menu Fourrière"))
	RMenu.Add('fourriere', 'annonces', RageUI.CreateSubMenu(RMenu:Get('fourriere', 'main'), "SUNLIFE", "Menu Fourrière"))
	RMenu:Get('fourriere', 'main'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('fourriere', 'auto'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('fourriere', 'interactions'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('fourriere', 'annonces'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('fourriere', 'main').EnableMouse = false
    RMenu:Get('fourriere', 'main').Closed = function()
		FourriereOpen = false
    end
	RMenu:Get('fourriere', 'auto').Closed = function()
		FourriereOpen = false
    end
end)

local FOURRIERE_CALL_BLIP_MS = 300000
local fourriereCallBlips = {}

local function addFourriereCallBlip(coords, caller)
	local blip = AddBlipForCoord(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
	SetBlipSprite(blip, 477)
	SetBlipColour(blip, 47)
	SetBlipScale(blip, 0.9)
	SetBlipAsShortRange(blip, false)
	SetBlipFlashes(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(("Appel %s"):format(tostring(caller)))
	EndTextCommandSetBlipName(blip)

	fourriereCallBlips[#fourriereCallBlips + 1] = blip

	Citizen.SetTimeout(FOURRIERE_CALL_BLIP_MS, function()
		if DoesBlipExist(blip) then RemoveBlip(blip) end
		for i = #fourriereCallBlips, 1, -1 do
			if fourriereCallBlips[i] == blip then
				table.remove(fourriereCallBlips, i)
				break
			end
		end
	end)
end

RegisterNetEvent("sJobs.fourriereCall", function(data)
	if type(data) ~= "table" or type(data.coords) ~= "table" then return end

	if not ESX or not ESX.ShowAdvancedNotification then return end

	local caller = tostring(data.caller or "Services")

	PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", true)
	ESX.ShowAdvancedNotification(
		"Fourrière",
		"~o~Demande d'enlèvement",
		("La ~b~%s~s~ demande une intervention. Un point GPS a été ajouté."):format(caller),
		"CHAR_CALL911",
		8
	)

	addFourriereCallBlip(data.coords, caller)
	SetNewWaypoint(data.coords.x + 0.0, data.coords.y + 0.0)
end)

AddEventHandler("onResourceStop", function(res)
	if res ~= GetCurrentResourceName() then return end
	for i = 1, #fourriereCallBlips do
		if DoesBlipExist(fourriereCallBlips[i]) then RemoveBlip(fourriereCallBlips[i]) end
	end
end)

function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

local impoundedVehicles = {}
local myimpoundedVehicles = {}

local impoundMenuFilterIdx = 1

RegisterNetEvent("impound:callback")
AddEventHandler("impound:callback", function(cb)
	impoundCallback = cb
end)

RegisterNetEvent("myimpound:callback")
AddEventHandler("myimpound:callback", function(cb)
	myimpoundCallback = cb
end)

RegisterNetEvent("impound:hourcallback")
AddEventHandler("impound:hourcallback", function(cb)
	hourCallback = cb
end)

function autoRetrait()
	if FourriereOpen then
        FourriereOpen = false
        return
    else
        FourriereOpen = true
        RageUI.Visible(RMenu:Get('fourriere', 'auto'), true)

		ESX.TriggerServerCallback('impound:getmyVehicles', function(data)
			myimpoundedVehicles = data
		end)

        Citizen.CreateThread(function()
            while FourriereOpen do
				RageUI.IsVisible(RMenu:Get('fourriere', 'auto'), true, true, true, function()
					RageUI.Separator("Vos véhicules saisis")
					for k,v in pairs(myimpoundedVehicles) do
						RageUI.ButtonWithStyle(v.plate, nil, { RightLabel = "70,000 $" },true, function(Hovered, Active, Selected)
							if Selected then
								RageUI.CloseAll()
								FourriereOpen = false
								TriggerServerEvent("impound:moveup", v.plate)

								myimpoundCallback = nil
								while not myimpoundCallback do Citizen.Wait(100) end

								if myimpoundCallback == 'can_spawn' then
									RequestModel(v.vehicle.model)
									while not HasModelLoaded(v.vehicle.model) do
										Citizen.Wait(100)
									end
									TriggerServerEvent('eye:veh:authorize', v.vehicle.model, 'fourriere')
									print(('^5[NETDIAG][VEHICLE]^7 %s rage.lua:108 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(v.vehicle.model)))
									local vehicle = CreateVehicle(v.vehicle.model, Config.CitizenImpoundedVehicleSpawn, 270.42108154297, true, false)
									ESX.Game.SetVehicleProperties(vehicle, v.vehicle)
									SetVehicleNumberPlateText(vehicle, v.plate)
									TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								end
							end
						end)
					end
				end, function()
				end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function openFOURMenu()
	local coords = GetEntityCoords(PlayerPedId())

    if FourriereOpen then
        FourriereOpen = false
        return
    else
        FourriereOpen = true
        RageUI.Visible(RMenu:Get('fourriere', 'main'), true)

        Citizen.CreateThread(function()
            while FourriereOpen do

				RageUI.IsVisible(RMenu:Get('fourriere', 'main'), true, true, true, function()

					if not inService then
						RageUI.ButtonWithStyle("Prendre son service", "Vous serez joignable par les citoyens.", { RightLabel = "~r~Hors service" }, true, function(_, _, Selected)
							if Selected then
								inService = true
								ESX.ShowNotification("~g~Vous avez pris votre service")
								TriggerServerEvent("sJobs.service", "on")
							end
						end)
					else
						RageUI.ButtonWithStyle("Prendre sa fin de service", nil, { RightLabel = "~g~En service" }, true, function(_, _, Selected)
							if Selected then
								inService = false
								ESX.ShowNotification("~r~Vous avez terminé votre service")
								TriggerServerEvent("sJobs.service", "off")
							end
						end)
					end

                    RageUI.ButtonWithStyle("Intéractions Véhicules", nil, { RightLabel = "→" },true, function()
					end, RMenu:Get('fourriere', 'interactions'))

					local annoncesOk = canUseAnnonces()
					RageUI.ButtonWithStyle(
						"Annonces Entreprise",
						annoncesOk and "Diffuser une annonce à tout le serveur" or "~r~Réservé à la direction de la fourrière.",
						{ RightLabel = annoncesOk and "→" or "~r~🔒" },
						annoncesOk,
						function()
						end,
						annoncesOk and RMenu:Get('fourriere', 'annonces') or nil
					)

					RageUI.ButtonWithStyle("Facturation", "Facturer le joueur le plus proche", { RightLabel = "~g~$" }, true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.CloseAll()
							FourriereOpen = false

							TriggerEvent("sCore.sendBill", "society_fourriere")
						end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('fourriere', 'annonces'), true, true, true, function()

					if not canUseAnnonces() then
						RageUI.Separator("~r~Réservé à la direction")
						return
					end

					RageUI.Separator("↓ ~y~Annonces publiques~s~ ↓")

					local isBoss = isFourriereBoss()
					for _, annonce in ipairs(fourriereAnnonces) do
						-- L'annonce de recrutement n'est proposee qu'au patron.
						local allowed = (not annonce.bossOnly) or isBoss
						local desc = allowed and annonce.text or "~r~Réservé au patron de la fourrière."
						RageUI.ButtonWithStyle(annonce.label, desc, { RightLabel = allowed and annonce.icon or "~r~🔒" }, allowed, function(Hovered, Active, Selected)
							if Selected and not allowed then return end
							if Selected then
								if not canAnnounce then
									ESX.ShowNotification("~r~Veuillez patienter avant de refaire une annonce.")
									return
								end

								local pdata = ESX.GetPlayerData()
								if not pdata or not pdata.job or pdata.job.name ~= 'fourriere' then
									ESX.ShowNotification("~r~Vous ne faites plus partie de la fourrière.")
									RageUI.CloseAll()
									FourriereOpen = false
									return
								end

								canAnnounce = false
								TriggerServerEvent("sJobs.announce", annonce.text, pdata.job.name)
								RageUI.CloseAll()
								FourriereOpen = false
								Citizen.SetTimeout(5000, function()
									canAnnounce = true
								end)
							end
						end)
					end
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('fourriere', 'interactions'), true, true, true, function()

					local elements  = {}
					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local vehicle   = ESX.Game.GetVehicleInDirection()

						local dst = GetDistanceBetweenCoords(Config.ImpoundedVehicleSpawn, GetEntityCoords(PlayerPedId()), true)

						RageUI.ButtonWithStyle("Mettre un véhicule en fourrière", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local invehicle = GetVehiclePedIsIn(PlayerPedId(), false)

								if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
									RageUI.CloseAll()
									FourriereOpen = false

									local vehicleProps = ESX.Game.GetVehicleProperties(invehicle)

									TriggerServerEvent("impound:check", vehicleProps)
									impoundCallback = nil
									while not impoundCallback do Citizen.Wait(100) end
									if impoundCallback == 'can_delete' then
										DeleteEntity(invehicle)
									end
									TriggerServerEvent("fourriere:vente")
									RageUI.CloseAll()
									FourriereOpen = false
								else
									ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
									RageUI.CloseAll()
									FourriereOpen = false
								end
							end
						end)

					local canPick = inService
					RageUI.ButtonWithStyle(
						"Crochetage du véhicule",
						canPick and "Déverrouille le véhicule le plus proche." or "~r~Vous devez être en service.",
						{ RightLabel = canPick and "🔧" or "~r~🔒" },
						canPick,
						function(Hovered, Active, Selected)
							if not Selected then return end

							local target, targetDist = ESX.Game.GetClosestVehicle()
							if not target or target == 0 or not DoesEntityExist(target) or (targetDist or 999.0) > 5.0 then
								ESX.ShowNotification("~r~Aucun véhicule à proximité.")
								return
							end

							RageUI.CloseAll()
							FourriereOpen = false

							NetworkRequestControlOfEntity(target)

							playAction("WORLD_HUMAN_WELDING", 5000, "🔧 Crochetage du véhicule...", function()
								if not DoesEntityExist(target) then return end
								SetVehicleDoorsLocked(target, 1)
								SetVehicleDoorsLockedForAllPlayers(target, false)
								ESX.ShowNotification("~g~Le véhicule est ouvert !")
							end)
						end
					)
                end, function()
				end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterCommand("fourriereMenu", function()
	if not (ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name == 'fourriere') then return end
	if FourriereOpen == false then
		openFOURMenu()
	end
end, false)

RegisterKeyMapping("fourriereMenu", "Ouvrir le menu Fourrière", "keyboard", "F6")

Citizen.CreateThread(function()
	RMenu.Add('fourriere', 'principal', RageUI.CreateMenu("SUNLIFE", "Menu Fourrière", 1, 100))
	RMenu:Get('fourriere', 'principal'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('fourriere', 'principal').EnableMouse = false
    RMenu:Get('fourriere', 'principal').Closed = function()
		OnMenuActive = false
    end
end)

local myvehicles = {
	{x = 460.71209716797, y = -1158.2111816406, z = 28.518937683105, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(myvehicles) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, myvehicles[k].x, myvehicles[k].y, myvehicles[k].z)

			if dist <= 3.0 then
				nearThing = true
				DrawMarker(6, myvehicles[k].x, myvehicles[k].y, myvehicles[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 117, 31, 225)
				ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour ouvrir le menu de la fourrière")
				if IsControlJustPressed(1,51) then
					if FourriereOpen == false then
						autoRetrait()
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	RMenu.Add('fourriere', 'depot2', RageUI.CreateMenu("SUNLIFE", "Menu Fourrière", 1, 100))
	RMenu.Add('fourriere', 'depot3', RageUI.CreateSubMenu(RMenu:Get('fourriere', 'depot2'), "SUNLIFE", "Menu Fourrière"))
	RMenu.Add('fourriere', 'impounded_vehicles', RageUI.CreateSubMenu(RMenu:Get('fourriere', 'depot2'), "SUNLIFE", "Menu Fourrière"))
    RMenu:Get('fourriere', 'depot2'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('fourriere', 'depot3'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('fourriere', 'impounded_vehicles'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('fourriere', 'depot2').EnableMouse = false
    RMenu:Get('fourriere', 'depot2').Closed = function()
		OnDepotActive = false
    end
end)

function OpenDepotVehicule()
	local coords = GetEntityCoords(PlayerPedId())

    if OnDepotActive then
        OnDepotActive = false
        return
    else
        OnDepotActive = true
        RageUI.Visible(RMenu:Get('fourriere', 'depot2'), true)

        Citizen.CreateThread(function()
            while OnDepotActive do

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
					RageUI.CloseAll()
					OnDepotActive = false
				end

                RageUI.IsVisible(RMenu:Get('fourriere', 'depot2'), true, true, true, function()

					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local vehicle   = ESX.Game.GetVehicleInDirection()

                    RageUI.ButtonWithStyle("Mettre un véhicule en fourrière", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
								RageUI.CloseAll()
								OnDepotActive = false

								local found = nil
								for k,v in pairs(GetGamePool('CVehicle')) do
									if #(GetEntityCoords(v) - vector3(412.431152, -1148.348633, 28.697088)) < 10.0 and not found then
										found = v
									end
								end

								if not found then ESX.ShowNotification("~r~Aucun véhicule à proximité") return end

								local vehicleProps = ESX.Game.GetVehicleProperties(found)

								TriggerServerEvent("impound:check", vehicleProps)

								impoundCallback = nil
								while not impoundCallback do Citizen.Wait(100) end
								if impoundCallback == 'can_delete' then DeleteEntity(found) end
								TriggerServerEvent("fourriere:vente")
							else
								ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
							end
						end
					end)

					RageUI.ButtonWithStyle("Voir les véhicules en fourrière", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
						if Selected then
							impoundMenuFilterIdx = filter
							ESX.TriggerServerCallback('impound:getVehicles', function(data)
								impoundedVehicles = data
							end, filterArray[filter])
						end
					end, RMenu:Get('fourriere', 'impounded_vehicles'))

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('fourriere', 'impounded_vehicles'), true, true, true, function()

					RageUI.List("Filtre de Plaque:", filterArray, filter, nil, {}, true, function(_, _, _, i)
						if i ~= impoundMenuFilterIdx then
							impoundMenuFilterIdx = i
							filter = i
							ESX.TriggerServerCallback('impound:getVehicles', function(data)
								impoundedVehicles = data
							end, filterArray[i])
						end
					end)
					RageUI.Separator("↓ ~y~Véhicules~s~ ↓")
					for k,v in pairs(impoundedVehicles) do
						RageUI.ButtonWithStyle(v.plate, "Ce véhicule a été mis en fourrière le "..v.date, {RightLabel = string.upper(GetDisplayNameFromVehicleModel(v.vehicle.model))},true, function()end)
					end

				end, function()
                end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local depotvehicule = {
	{x = 412.34359741211, y = -1147.7996826172, z = 28.518935775757, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(depotvehicule) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, depotvehicule[k].x, depotvehicule[k].y, depotvehicule[k].z)

			if dist <= 2.0 then
				nearThing = true
				if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'fourriere') then
					DrawMarker(6, depotvehicule[k].x, depotvehicule[k].y, depotvehicule[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 117, 31, 225)
					ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au menu de gestion des véhicules de la fourrière")
					if IsControlJustPressed(1,51) then
						if FourriereOpen == false then
							OpenDepotVehicule()
						end
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

local function isFourriereEmployee()
	local pdata = ESX.GetPlayerData()
	return pdata ~= nil and pdata.job ~= nil and pdata.job.name == 'fourriere'
end

local function deleteImpoundedVehicle(vehicle)
	if not DoesEntityExist(vehicle) then return end
	if not NetworkHasControlOfEntity(vehicle) then
		local tries = 0
		while not NetworkHasControlOfEntity(vehicle) and tries < 20 do
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(25)
			tries = tries + 1
		end
	end
	SetEntityAsMissionEntity(vehicle, true, true)
	DeleteVehicle(vehicle)
	if DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
end

local impoundBusy = false

local function impoundTargetedVehicle(entity)
	if impoundBusy then return end
	if not entity or not DoesEntityExist(entity) or not IsEntityAVehicle(entity) then
		ESX.ShowNotification("~r~Aucun véhicule valide ciblé.")
		return
	end
	if not isFourriereEmployee() then return end

	impoundBusy = true

	local vehicleProps = ESX.Game.GetVehicleProperties(entity)
	if not vehicleProps or not vehicleProps.plate or vehicleProps.plate == '' then
		ESX.ShowNotification("~r~Impossible de récupérer les informations du véhicule.")
		impoundBusy = false
		return
	end

	impoundCallback = nil
	TriggerServerEvent("impound:check", vehicleProps)

	local timeout = 0
	while impoundCallback == nil and timeout < 50 do
		Citizen.Wait(100)
		timeout = timeout + 1
	end

	if impoundCallback == 'can_delete' then
		deleteImpoundedVehicle(entity)
	end

	impoundCallback = nil
	impoundBusy = false
end

Citizen.CreateThread(function()
	while GetResourceState('ox_target') ~= 'started' do
		Citizen.Wait(500)
	end

	exports.ox_target:addGlobalVehicle({
		{
			name = 'fourriere_impound',
			icon = 'fa-solid fa-truck-ramp-box',
			label = 'Mettre en fourrière',
			distance = 3.0,
			groups = { 'fourriere' },
			canInteract = function(entity)
				return entity ~= nil and DoesEntityExist(entity) and isFourriereEmployee()
			end,
			onSelect = function(data)
				impoundTargetedVehicle(data.entity)
			end
		}
	})
end)
