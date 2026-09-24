local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
enService = false
local EMSOpen = false

local lib1_char_a, lib2_char_a, lib1_char_b, lib2_char_b, anim_start, anim_pump, anim_success = 'mini@cpr@char_a@cpr_def', 'mini@cpr@char_a@cpr_str', 'mini@cpr@char_b@cpr_def', 'mini@cpr@char_b@cpr_str', 'cpr_intro', 'cpr_pumpchest', 'cpr_success'

Citizen.CreateThread(function()
	RequestAnimDict(lib1_char_a)
	RequestAnimDict(lib2_char_a)
	RequestAnimDict(lib1_char_b)
	RequestAnimDict(lib2_char_b)
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'emsmenu', RageUI.CreateMenu("SunLife", "Menu EMS", 1, 100))
	RMenu.Add('menu', 'actionsems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "SunLife", "Menu EMS"))
	RMenu.Add('menu', 'facturationems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "SunLife", "Menu EMS"))
	RMenu.Add('menu', 'serviceems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "SunLife", "Menu EMS"))
	RMenu.Add('menu', 'annoncesems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "SunLife", "Menu EMS"))
    RMenu:Get('menu', 'emsmenu'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'actionsems'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'facturationems'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'serviceems'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'annoncesems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'emsmenu').EnableMouse = false
    RMenu:Get('menu', 'emsmenu').Closed = function()
		EmsOpen = false
    end
end)

function OpenMobileAmbulanceActionsMenu()
    if EmsOpen then
        EmsOpen = false
        return
    else
        EmsOpen = true
        RageUI.Visible(RMenu:Get('menu', 'emsmenu'), true)

        Citizen.CreateThread(function()
            while EmsOpen do
				DisableControlAction(0, 167)
                RageUI.IsVisible(RMenu:Get('menu', 'emsmenu'), true, true, true, function()
					RageUI.Separator(("Statut: %s"):format(enService and "~g~EN SERVICE" or "~r~HORS SERVICE"))

					if not enService then
						RageUI.ButtonWithStyle("Prise de service", "Prenez votre service pour débloquer les outils EMS et recevoir les réanimations.", { RightLabel = "~r~HORS SERVICE" }, true, function(Hovered, Active, Selected)
							if Selected then
								enService = true
								ESX.ShowNotification("Prise de service, vous allez maintenant recevoir les demandes de réanimation")
								TriggerServerEvent("EMS:AddPlayer")
								TriggerServerEvent("socore:server:serviceStatut")
							end
						end)
					else
						RageUI.ButtonWithStyle("Fin de service", "Terminez votre service.", { RightLabel = "~g~EN SERVICE" }, true, function(Hovered, Active, Selected)
							if Selected then
								enService = false
								ESX.ShowNotification("Service terminé")
								TriggerServerEvent("EMS:RemovePlayer")
								TriggerServerEvent("socore:server:serviceStatut")
							end
						end)

						RageUI.ButtonWithStyle("Intéractions Citoyen", nil, { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'actionsems'))
						RageUI.ButtonWithStyle("Facturation", nil, { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'facturationems'))
						RageUI.ButtonWithStyle("Annonces", nil, { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'annoncesems'))

						RageUI.ButtonWithStyle("Appeler la fourrière", "Signale votre position aux agents de la fourrière en service.", { RightLabel = "🚛" }, true, function(Hovered, Active, Selected)
							if Selected then
								TriggerServerEvent("sJobs.callFourriere")
								RageUI.CloseAll()
								EmsOpen = false
							end
						end)

					RageUI.ButtonWithStyle("Appels", nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
							if Selected then
								RageUI.CloseAll()
								EmsOpen = false
								EMSCallsClosed = false
								TriggerEvent("rEMS:openTheEmsMenu")
							end
						end)
					end
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'emscallsmenu'), true, true, true, function()
					RageUI.ButtonWithStyle("Vider les appels sur le GPS", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ESX.ShowNotification("Vous avez vidé tous les appels actifs sur votre gps.")
							enService = false
                        end
					end)
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'actionsems'), true, true, true, function()

					RageUI.ButtonWithStyle("Réanimation", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local oPlayerId = GetPlayerServerId(closestPlayer)
								local playerPed = PlayerPedId()
								ESX.ShowNotification(_U('revive_inprogress'))
								TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

								TriggerServerEvent("ambulance:requestCPR", oPlayerId, GetEntityHeading(closestPlayerPed), GetEntityCoords(closestPlayerPed), GetEntityForwardVector(closestPlayerPed))

								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								local cpr = true

								Citizen.CreateThread(function()
									while cpr do
										Citizen.Wait(0)
										DisableAllControlActions(0)
										EnableControlAction(0, 1, true)
									end
								end)

								SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
								Wait(2000)
								TaskPlayAnim(playerPed, lib1_char_a, anim_start, 8.0, 8.0, -1, 0, 0, false, false, false)
								Citizen.Wait(15800 - 900)
								for i=1, 15, 1 do
									Citizen.Wait(900)
									TaskPlayAnim(playerPed, lib2_char_a, anim_pump, 8.0, 8.0, -1, 0, 0, false, false, false)
								end

								cpr = false
								TaskPlayAnim(playerPed, lib2_char_a, anim_success, 8.0, 8.0, -1, 0, 0, false, false, false)
								Citizen.Wait(23000)
								TriggerServerEvent('rems:emsRevive', oPlayerId, GetEntityCoords(PlayerPedId()))
								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								rea = false
								TriggerEvent("zeub")
								RemoveBlip(emsBlip)
								RemoveBlip(emsBlip2)
								local oPlayer = GetPlayerFromServerId(oPlayerId)
								local oPed = GetPlayerPed(oPlayer)
								local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
								SetEntityCoords(oPed, offset, 0)
							end
						end
					end)
					RageUI.ButtonWithStyle("Chirurgie", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local oPlayerId = GetPlayerServerId(closestPlayer)
								local playerPed = PlayerPedId()
								ESX.ShowNotification(_U('revive_inprogress'))
								TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

								TriggerServerEvent("ambulance:requestCPR", oPlayerId, GetEntityHeading(closestPlayerPed), GetEntityCoords(closestPlayerPed), GetEntityForwardVector(closestPlayerPed))

								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								local cpr = true

								Citizen.CreateThread(function()
									while cpr do
										Citizen.Wait(0)
										DisableAllControlActions(0)
										EnableControlAction(0, 1, true)
									end
								end)

								SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)

								Wait(2000)
								TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "player_search", 8.0, 8.0, -1, 1, 0, false, false, false)

								Citizen.Wait(20000)

								for i = 1, 4 do
									TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "player_search", 8.0, 8.0, -1, 1, 0, false, false, false)
									Citizen.Wait(10000)
								end

								cpr = false
								TaskPlayAnim(playerPed, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
								Citizen.Wait(30000)

								TriggerServerEvent('rems:emsRevive', oPlayerId, GetEntityCoords(PlayerPedId()))
								TriggerServerEvent('rems:givePlatre', oPlayerId, 10, true)
								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								rea = false
								TriggerEvent("zeub")
								RemoveBlip(emsBlip)
								RemoveBlip(emsBlip2)
								local oPlayer = GetPlayerFromServerId(oPlayerId)
								local oPed = GetPlayerPed(oPlayer)
								local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
								SetEntityCoords(oPed, offset, 0)
							end
						end
					end)

					RageUI.ButtonWithStyle("Ajouter un platre", "Ajoutera un platre à la personne la plus proche pendant 10 minutes", {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								local oPlayerId = GetPlayerServerId(closestPlayer)
								local time = 10
								ESX.ShowNotification(("Vous avez donné un plâtre de %s minutes à l'ID %s"):format(10, oPlayerId))
								TriggerServerEvent("rems:givePlatre", oPlayerId, 10, false)
							end
						end
					end)

					RageUI.ButtonWithStyle("Soigner des blessures mineures", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)

										if health > 0 then
											local playerPed = PlayerPedId()

											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)

											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
							end
						end
					end)

					RageUI.ButtonWithStyle("Soigner des blessures graves", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)

										if health > 0 then
											local playerPed = PlayerPedId()

											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)

											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							end
						end
					end)

					RageUI.ButtonWithStyle("Sortir une chaise roulante", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local ped = PlayerPedId()
							local PlayerCoords = GetEntityCoords(ped)
							ESX.Game.SpawnVehicle("wheelchair", PlayerCoords, 180.0, function(vehicle)
								SetVehicleNumberPlateText(vehicle, "WHEELC")
							end)
						end
					end)

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'facturationems'), true, true, true, function()
                    RageUI.ButtonWithStyle("Envoyer une facture", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
							TriggerEvent("sCore.sendBill", "society_ems")
							RageUI.CloseAll()
                        	EmsOpen = false
                        end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'serviceems'), true, true, true, function()
                    RageUI.ButtonWithStyle("Prise/Fin de service", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if not enService then
								enService = true
								ESX.ShowNotification("Prise de service, vous allez maintenant recevoir les demandes de réanimation")
								TriggerServerEvent("EMS:AddPlayer")
								TriggerServerEvent("socore:server:serviceStatut")
							else
								ESX.ShowNotification("Service terminé")
								TriggerServerEvent("EMS:RemovePlayer")
								TriggerServerEvent("socore:server:serviceStatut")
								enService = false
							end
                        end
					end)

					RageUI.ButtonWithStyle("Vider les appels sur le GPS", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ESX.ShowNotification("Vous avez vidé tous les appels actifs sur votre gps.")
							enService = false
                        end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'annoncesems'), true, true, true, function()

                    RageUI.ButtonWithStyle("EMS disponible", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent('AnnounceEMSOuvert')
                        end
					end)
					RageUI.ButtonWithStyle("EMS indisponible", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent('AnnounceEMSFerme')
                        end
					end)
                end, function()
				end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

			if
				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ems' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local job = ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name

		if job == 'ems' and not IsDead then
			sleep = 0
			if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end
		end

		Citizen.Wait(sleep)
	end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

RegisterNetEvent('rems:rItems')
AddEventHandler('rems:rItems', function()
	ESX.PlayerData = ESX.GetPlayerData()

	for i = 1, #ESX.PlayerData.inventory do
		if ESX.PlayerData.inventory[i].count > 0 then
			local inventory = ESX.PlayerData.inventory[i].name
			local count = ESX.PlayerData.inventory[i].count
			if string.match(inventory, "WEAPON") then
				TriggerServerEvent("rems:removeItems", inventory, count)
			end
		end
	end
	TriggerServerEvent("rems:sendReaplog")
end)

local brancard = {
	{x = -674.438171, y = 358.220428, z = 76.874963,}
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(brancard) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, brancard[k].x, brancard[k].y, brancard[k].z)

			if dist <= 3.0 then
				nearThing = true
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ems' then
					DrawMarker(6, brancard[k].x, brancard[k].y, brancard[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
					ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour sortir un brancard")
					if IsControlJustPressed(1, 51) then
						TriggerEvent("ARPF-EMS:spawnStr")
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(1500)
		end
	end
end)

RegisterNetEvent("rems:platre")
AddEventHandler("rems:platre", function(time)
    ESX.ShowNotification("Vous avez un plâtre pendant les "..time.." prochaines minutes.")
    local duration = time * 60 * 1000
    local endTime = GetGameTimer() + duration
    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            local playerPed = PlayerPedId()
            local tshirtIndex = GetPedDrawableVariation(playerPed, 8)
			local sex = GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01")
			if sex then
				SetPedComponentVariation(playerPed, 8, 394, 0, 2)
			else
				SetPedComponentVariation(playerPed, 5, 259, 0, 2)
			end

			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
			SetEntityInvincible(playerPed, false)
            SetPlayerInvincible(PlayerId(), false)

            Citizen.Wait(1000)
        end
		ESX.ShowNotification("~g~Vous n'avez plus de platre")
        local playerPed = PlayerPedId()
        SetPedComponentVariation(playerPed, 8, 15, 0, 2)
    end)
end)

RegisterNetEvent("rems:reset")
AddEventHandler("rems:reset", function()
	local playerPed = PlayerPedId()
	SetPedComponentVariation(playerPed, 8, 15, 0, 2)
end)

Citizen.CreateThread(function()
	Citizen.Wait(5 * 1000)
	TriggerServerEvent("rems:infoPlatre")
end)
