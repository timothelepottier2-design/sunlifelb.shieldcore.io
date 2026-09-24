LICENSES = {
    ["myLicenses"] = {},
}

Citizen.CreateThread(function()
    Citizen.Wait(5 * 1000)
    TriggerServerEvent("licenses:get")
end)

RegisterNetEvent("licenses:send")
AddEventHandler("licenses:send", function(licenses)
    LICENSES["myLicenses"] = licenses
end)

function SelectNumber(text)
	local i = nil

	exports.dialog:openDialog(text, function(value)
		i = value
	end)
	while i == nil do Wait(1) end
	i = tostring(i)
	
	return i
end
local menu = {
	['openned'] = false,
}

CreateMenu = function()
	RMenu.Add('llicenses', 'main', RageUI.CreateMenu('SunLife', 'Auto-École', 1, 100))
	RMenu.Add('llicenses', 'second', RageUI.CreateSubMenu(RMenu:Get('llicenses', 'main'), 'SunLife', 'François'))
	RMenu:Get('llicenses', 'main').Closed = function()
		menu['openned'] = false

		RMenu:Delete('llicenses', 'main')
		RMenu:Delete('llicenses', 'second')
	end
	
	if menu['openned'] then
		menu['openned'] = false
		return
	else
		RageUI.CloseAll()

		menu['openned'] = true
		RageUI.Visible(RMenu:Get('llicenses', 'main'), true)
	end

	RMenu:Get('llicenses', 'main'):SetRectangleBanner(255, 117, 31, 225)


	local elements = {}
	local player = ESX.GetPlayerData()
	table.insert(elements, {label = "Carte d'identité", price = 5000, value = 'id_card'})
    table.insert(elements, {label = "Permis de pêche", price = 10000, value = 'peche'})
	table.insert(elements, {label = "Permis de chasse", price = 20000, value = 'chasse'})
    table.insert(elements, {label = "Permis bateau", price = 50000, value = 'bateau'})
	table.insert(elements, {label = "Permis aéronefs ", price = 450000, value = 'aeronef'})


	if player.job.name == "police" then
		table.insert(elements, {label = "Badge lspd", price = 10000, value = 'lspd'})
	end
	if player.job.name == "sheriff" then 
		table.insert(elements, {label = "Badge BCSO", price = 10000, value = 'sheriff'})
	end
	if player.job.name == "ambulance" or player.job.name == "ems" then
		table.insert(elements, {label = "Badge EMS", price = 10000, value = 'ems'})
	end
	if player.job.name == "bobcat" then
		table.insert(elements, {label = "Badge Bobcat Security", price = 10000, value = 'bobcat'})
	end
	if player.job.name == "lsfd" then
		table.insert(elements, {label = "Badge LSFD", price = 10000, value = 'lsfd'})
	end
	if player.job.name == "gouv" then
		table.insert(elements, {label = "Badge Gouvernement", price = 10000, value = 'gouv'})
	end
	local coords = GetEntityCoords(PlayerPedId())

	Citizen.CreateThread(function()
		while menu['openned'] do
			Wait(1)

			if #(coords - GetEntityCoords(PlayerPedId())) > 5.0 then
				RageUI.CloseAll()
				menu['openned'] = false
			end

			RageUI.IsVisible(RMenu:Get('llicenses', 'main'), true, false, true, function()
				
				for k,v in pairs(elements) do
					RageUI.Button(v.label, nil, {RightLabel = v.price ~= nil and ESX.Math.GroupDigits(v.price).."$"}, true, function(Hovered, Active, Selected)
						if Selected then

							if v.value == "sheriff" then
								local input = SelectNumber("Matricule")
								if tonumber(input) then 
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										if link then
											TriggerServerEvent("licenses:groszeub", "sheriff", v.price, tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
                                	
								end
							end

							if v.value == "ems" then
								local input = SelectNumber("Matricule")
								if tonumber(input) then 
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										if link then
											TriggerServerEvent("licenses:groszeub", "ems", v.price, tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
                                	
								end
							end
							if v.value == "lspd" then
								local input = SelectNumber("Matricule")
								print(input)
								if tonumber(input) then
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										print(link)
										if link then
											TriggerServerEvent("licenses:groszeub", "lspd", v.price,  tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
								end
							end
							-- Bobcat Security et LSFD : meme parcours que les autres
							-- badges (matricule saisi puis mugshot). Le serveur
							-- revalide le job et le prix.
							if v.value == "bobcat" or v.value == "lsfd" or v.value == "gouv" then
								local input = SelectNumber("Matricule")
								if tonumber(input) then
									RageUI.CloseAll()
									menu['openned'] = false
									local badge = v.value
									TriggerEvent("inventory:getMugshot", function (link)
										if link then
											TriggerServerEvent("licenses:groszeub", badge, v.price, tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
								end
							end
							if v.value == "id_card" then
								TriggerEvent("inventory:getMugshot", function (link)
									if link then
										TriggerServerEvent("licenses:groszeub", "idcard", v.price, 0, link)
									else
										ESX.ShowNotification("Erreur lors de la prise de photo")
									end
								end)
								RageUI.CloseAll()
								menu['openned'] = false
							end
							if v.value == "bateau" then
								TriggerEvent("inventory:getMugshot", function (link)
									if link then
										TriggerServerEvent("licenses:groszeub", "drive_boat", v.price, 0, link)
									else
										ESX.ShowNotification("Erreur lors de la prise de photo")
									end
								end)
								RageUI.CloseAll()
								menu['openned'] = false
							end

							if v.value == "chasse" then
                                TriggerServerEvent("licenses:groszeub", "chasse", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

							if v.value == "peche" then
                                TriggerServerEvent("licenses:groszeub", "peche", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

                            if v.value == "aeronef" then
								TriggerEvent("inventory:getMugshot", function (link)
									if link then
										TriggerServerEvent("licenses:groszeub", "drive_plane", v.price, 0, link)
									else
										ESX.ShowNotification("Erreur lors de la prise de photo")
									end
								end)
								RageUI.CloseAll()
								menu['openned'] = false
							end

						end
					end)
				end

			end)

		end
	end)
end
RegisterNetEvent('licenseshehehehehtakephoto', function (licensesName)
    TriggerEvent("inventory:getMugshot", function (link)
		if link then
			TriggerServerEvent("licenses:groszeub", licensesName, 0, 0, link)
		else
			ESX.ShowNotification("Erreur lors de la prise de photo")
		end
	end)
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-473.051331, 1107.877441, 326.607056)
	SetBlipSprite(blip, 498)
	SetBlipScale(blip, 0.85)
	SetBlipColour(blip, 3)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Service des Cartes & Permis")
	EndTextCommandSetBlipName(blip)
end)

local secretairePos = {
	{x = -434.586243, y = 1098.233154, z = 328.866571, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(secretairePos) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, secretairePos[k].x, secretairePos[k].y, secretairePos[k].z)

			if dist < 10.0 then
				nearThing = true
				DrawMarker(6, secretairePos[k].x, secretairePos[k].y, secretairePos[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				if dist < 1.5 then
					ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler au secrétaire")
					if IsControlJustPressed(1, 38) then
						CreateMenu()
					end
				end
			end
		end
		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(250)
		end
	end
end)