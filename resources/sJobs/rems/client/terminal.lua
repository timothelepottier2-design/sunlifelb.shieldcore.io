ESX = nil

local OnMedecinActive = false
local curr_pl_billing = nil
local isIllegal = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

    RMenu.Add('menu', 'debut', RageUI.CreateMenu("SunLife", "Médecin", 1, 100))
	RMenu.Add('menu', 'medecin_choose', RageUI.CreateSubMenu(RMenu:Get('menu', 'debut'), "SunLife", "Terminal"))
    RMenu:Get('menu', 'debut'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'medecin_choose'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'debut').EnableMouse = false
    RMenu:Get('menu', 'debut').Closed = function()
		OnMedecinActive = false
    end
    RMenu:Get('menu', 'medecin_choose').Closed = function()
		OnMedecinActive = false
    end
end)

function openMedecinMenu(isIllegal)
    local coords = GetEntityCoords(PlayerPedId())
    if OnMedecinActive then
        OnMedecinActive = false
        return
    else
        OnMedecinActive = true
        RageUI.Visible(RMenu:Get('menu', 'debut'), true)

        Citizen.CreateThread(function()
            while OnMedecinActive do

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                    RageUI.CloseAll()
                    OnMedecinActive = false
                end

                RageUI.IsVisible(RMenu:Get('menu', 'debut'), true, true, true, function()

                    if isIllegal == true then
                        RageUI.ButtonWithStyle("Se soigner", nil, {RightLabel = "~r~5,000$"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
					    		TriggerServerEvent("rems:HealRemoveMoney")
                                RageUI.CloseAll()
                                OnMedecinActive = false
                            end
					    end)
                    else
                        RageUI.ButtonWithStyle("Se soigner", nil, {RightLabel = "~o~5,000$"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
					    		TriggerServerEvent("rems:HealRemoveMoney")
                                RageUI.CloseAll()
                                OnMedecinActive = false
                            end
					    end)
                    end
                    if isIllegal == true then
					    RageUI.ButtonWithStyle("Réanimer quelqu'un", nil, {RightLabel = "~r~500,000$ ~s~(Sans fouille)"}, true, function(Hovered, Active, Selected)
					    end, RMenu:Get('menu', 'medecin_choose'))
                    else
                        RageUI.ButtonWithStyle("Réanimer quelqu'un", nil, {RightLabel = "~o~50,000$ ~s~(Avec fouille)"}, true, function(Hovered, Active, Selected)
					    end, RMenu:Get('menu', 'medecin_choose'))
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'medecin_choose'), true, true, true, function()

                    for _, player in ipairs(GetActivePlayers()) do
                        local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)
                        local coords = GetEntityCoords(GetPlayerPed(player))

                        if dst < 3.0 then
                            RageUI.ButtonWithStyle("Joueur #".._, nil, {RightLabel = curr_pl_billing}, true, function(h, a, s)
                                if a then
                                    DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 0, 255, 33, 100, true, true)
                                    curr_pl_billing = ""
                                else
                                    curr_pl_billing = "🩹"
                                end
                                if s then
                                    TriggerServerEvent('revive:retozviveterminal', GetPlayerServerId(player), isIllegal)
                                    RageUI.CloseAll()
                                    OnMedecinActive = false
                                end
                            end)
                        end
                    end

                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local Medecin = {
	{x = -675.549561, y = 328.913177, z = 82.183740},
    {x = -532.11401367188, y = 7380.5942382812, z = 11.835193634033},
    {x = 4963.7661132812, y = -5103.3256835938, z = 1.9553971290588},
    {x = 7483.563965, y = 390.828735, z = 56.922830}
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(Medecin) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Medecin[k].x, Medecin[k].y, Medecin[k].z)

            if dist <= 2.0 then
                nearThing = true
                DrawMarker(6, Medecin[k].x, Medecin[k].y, Medecin[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au médecin")
				if IsControlJustPressed(1,51) then
                    if OnMedecinActive == false then
                        local isIllegal = false
					    openMedecinMenu(isIllegal)
                    end
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

local MedecinIllegal = {
	{x = -622.19024658203, y = 310.97808837891, z = 82.990572509766, }
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(MedecinIllegal) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, MedecinIllegal[k].x, MedecinIllegal[k].y, MedecinIllegal[k].z)

            if dist <= 2.0 then
                nearThing = true
                DrawMarker(6, MedecinIllegal[k].x, MedecinIllegal[k].y, MedecinIllegal[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au médecin illégal")
				if IsControlJustPressed(1,51) then
                    if OnMedecinActive == false then
                        isIllegal = true
					    openMedecinMenu(isIllegal)
                    end
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

RegisterNetEvent('rems:rewardHealth')
AddEventHandler('rems:rewardHealth', function()
    SetEntityHealth(PlayerPedId(), 200)
    ESX.ShowNotification("Vous avez été ~o~soigné~w~ par le médecin !")
end)
