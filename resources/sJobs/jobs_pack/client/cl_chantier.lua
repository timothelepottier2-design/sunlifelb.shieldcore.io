ESX = nil
local AuTaff = false
local chantier = false
local servicetaken = false
chantierblips = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

    RMenu.Add('menu', 'chantier', RageUI.CreateMenu("SunLife", "Chantier", 1, 100))
    RMenu:Get('menu', 'chantier'):SetRectangleBanner(255, 106, 0, 140)
    RMenu:Get('menu', 'chantier').EnableMouse = false
    RMenu:Get('menu', 'chantier').Closed = function()
		chantier = false
    end
end)

function openChantierMenu()
    if chantier then
        chantier = false
        return
    else
        chantier = true
        RageUI.Visible(RMenu:Get('menu', 'chantier'), true)

        Citizen.CreateThread(function()
            while chantier do
                RageUI.IsVisible(RMenu:Get('menu', 'chantier'), true, true, true, function()
                    RageUI.ButtonWithStyle("Prendre son service", "", { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if servicetaken == false then
                                servicetaken = true
                                AuTaff = true
                                RageUI.CloseAll()
                                chantier = false
                                StartChantier()
                            else
                                ESX.ShowNotification("~r~Vous êtes déja en service !")
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Prendre sa fin de service", "", { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if servicetaken == true then
                                servicetaken = false
                                exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
							    	TriggerEvent('skinchanger:loadSkin', skin)
							    end)
                                RageUI.CloseAll()
                                chantier = false
                                for i, blip in pairs(chantierblips) do
                                    RemoveBlip(blip)
                                end
                            else
                                ESX.ShowNotification("~r~Vous n'êtes pas en service !")
                            end
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

local chantierPlace = {
	{x = -924.69, y = 380.97, z = 78.25, }
}

JobsPackSpawnBossPed(chantierPlace[1], 0.0, `s_m_y_construct_01`, "WORLD_HUMAN_CLIPBOARD")

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(chantierPlace) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chantierPlace[k].x, chantierPlace[k].y, chantierPlace[k].z)

            if dist <= 2.0 then
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le chef du chantier.")
				if IsControlJustPressed(1,51) then
                    if chantier == false then
					    openChantierMenu()
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

function StartChantier()
    if servicetaken == true then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local model = GetEntityModel(PlayerPedId())
            if model == GetHashKey("mp_m_freemode_01") then
                clothesSkin = {
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 59, ['tshirt_2'] = 0,
                    ['torso_1'] = 56, ['torso_2'] = 0,
                    ['arms'] = 30,
                    ['pants_1'] = 31, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bproof_1'] = 0, ['bproof_2'] = 0,
                    ['helmet_1'] = 0, ['helmet_2'] = 0,
                }
            else
                clothesSkin = {
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 36, ['tshirt_2'] = 1,
                    ['torso_1'] = 23, ['torso_2'] = 0,
                    ['arms'] = 0, ['arms_2'] = 0,
                    ['pants_1'] = 45, ['pants_2'] = 1,
                    ['shoes_1'] = 66, ['shoes_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                    ['bproof_1'] = 0,
                    ['chain_1'] = 0,
                }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
        ESX.ShowNotification("Tu es en service !")
        StartTravailleChantier()
    end
end

function StartTravailleChantier()
    while AuTaff do
        ESX.ShowNotification("Nouvelle tâche !")
        Wait(1)
        local random = math.random(1,#Config.chantierPos)
        local count = 1
        local nearThing = false
        for k,v in pairs(Config.chantierPos) do
            count = count + 1
            if count == random and AuTaff then
                local EnAction = false
                local pPed = PlayerPedId()
                local pCoords = GetEntityCoords(pPed)
                local dstToMarker = GetDistanceBetweenCoords(v.pos, pCoords, true)
                local blip = AddBlipForCoord(v.pos)
                SetBlipSprite(blip, 402)
                SetBlipColour(blip, 5)
                SetBlipScale(blip, 0.8)
                table.insert(chantierblips, blip)
                while not EnAction and AuTaff do
                    pCoords = GetEntityCoords(pPed)
                    dstToMarker = GetDistanceBetweenCoords(v.pos, pCoords, true)
                    if dstToMarker <= 20.0 then
                        DrawMarker(20, v.pos.x, v.pos.y, v.pos.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0)
                        nearThing = true
                        if dstToMarker <= 3.0 and AuTaff then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour travailler")
                            if IsControlJustPressed(1, 51) and dstToMarker <= 3.0 then
                                TriggerServerEvent("jobs:setupPlayerMission")
                                for i, blip in pairs(chantierblips) do
                                    RemoveBlip(blip)
                                end
                                EnAction = true
                                SetEntityCoords(pPed, v.pos, 0.0, 0.0, 0.0, 0)
                                SetEntityHeading(pPed, v.Heading)
                                TaskStartScenarioInPlace(pPed, v.scenario, 0, true)
                                TriggerEvent("core:drawBar", 10000, "⌛ Travail en cours...")
                                Wait(10000)
                                ClearPedTasksImmediately(PlayerPedId())
                                SJobsTriggerPay("chantier")
                                break
                            end
                        end
                    end
                    if nearThing then
                        Wait(0)
                    else
                        Wait(250)
                    end
                end
                if DoesBlipExist(blip) then
                    for i, blip in pairs(chantierblips) do
                        RemoveBlip(blip)
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
	local chantierblips = AddBlipForCoord(-924.81, 381.77, 79.11)
	SetBlipSprite(chantierblips, 175)
	SetBlipScale(chantierblips, 0.8)
	SetBlipColour(chantierblips, 47)
	SetBlipAsShortRange(chantierblips, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Chantier')
	EndTextCommandSetBlipName(chantierblips)
end)
