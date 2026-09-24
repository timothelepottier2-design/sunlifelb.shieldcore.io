local Extra = false

RMenu.Add('menu', 'extra', RageUI.CreateMenu("SunLife", "Menu Extra", 1, 100))
RMenu:Get('menu', 'extra'):SetRectangleBanner(255, 117, 31, 225)
RMenu:Get('menu', 'extra').Closed = function()
    Extra = false
end;

-- ============================================================================
-- Sauvegarde.
--
-- Les extras / livrees / vitres n'etaient poses que sur l'entite locale : rien
-- n'etait ecrit en base, donc tout repartait a zero au premier passage par le
-- garage. On collecte l'etat a la fermeture du menu et le serveur le fait
-- persister (server/extra/srv_extra.lua).
-- ============================================================================

-- 0..20 et non 0..12 comme ESX.Game.GetVehicleProperties : le menu expose
-- jusqu'a l'extra 20, et ESX.Game.SetVehicleProperties reapplique au respawn
-- n'importe quel id present dans la table (il itere en pairs).
local function CollectExtras(veh)
	local extras = {}
	for i = 0, 20 do
		if DoesExtraExist(veh, i) then
			extras[tostring(i)] = IsVehicleExtraTurnedOn(veh, i) == 1
		end
	end
	return extras
end

-- Meme regle que ESX.Game.GetVehicleProperties : le slot de mod 48 fait foi des
-- que le vehicule le propose, sinon on retombe sur l'API livery historique.
local function CollectLivery(veh)
	local liv = GetVehicleMod(veh, 48)
	if GetNumVehicleMods(veh, 48) <= 0 then
		local legacy = GetVehicleLivery(veh)
		if legacy ~= -1 then
			liv = legacy
		end
	end
	return liv
end

local function SaveExtraChanges(veh)
	if not veh or veh == 0 or not DoesEntityExist(veh) then return end

	TriggerServerEvent('sunlife:extra:save', {
		plate      = GetVehicleNumberPlateText(veh),
		model      = GetEntityModel(veh),
		extras     = CollectExtras(veh),
		modLivery  = CollectLivery(veh),
		windowTint = GetVehicleWindowTint(veh),
	})
end

function AddMenuExtra()
	local coords = GetEntityCoords(PlayerPedId())

	if Extra then
		RageUI.CloseAll()
		Extra = false
		return
	end

	-- Capture du vehicule a l'ouverture : a la fermeture le joueur peut en etre
	-- sorti, et c'est bien celui-ci qu'il faut sauvegarder.
	local menuVeh = GetVehiclePedIsIn(PlayerPedId(), false)
	if menuVeh == 0 then
		ESX.ShowNotification("~r~Vous devez être dans un véhicule.")
		return
	end

	Extra = true
	local dirty = false

	RageUI.Visible(RMenu:Get('menu', 'extra'), true)

	SetVehicleModKit(menuVeh, 0)

	Citizen.CreateThread(function()
		while Extra do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
				RageUI.CloseAll()
				Extra = false
			end

			RageUI.IsVisible(RMenu:Get('menu', 'extra'), true, true, true, function()
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					RageUI.Separator("~r~Vous devez être dans un véhicule")
					return
				end

				local veh = GetVehiclePedIsIn(PlayerPedId(), false)

				SetVehicleModKit(veh, 0)

				for i = 1, 20 do
					if DoesExtraExist(veh, i) then
						RageUI.Checkbox("Extra " .. i, "Permet d'ajouter des extras", IsVehicleExtraTurnedOn(veh, i), { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
						end, function()
							SetVehicleExtra(veh, i, false)
							dirty = true
						end, function()
							SetVehicleExtra(veh, i, true)
							dirty = true
						end)
					end
				end

				RageUI.Separator()

				local liveryCount = GetVehicleLiveryCount(veh)

				if liveryCount > 0 then
					for i = -1, liveryCount - 1, 1 do
						local modName = (i == -1) and 'Livrée de base' or 'Livrée ' .. i
						RageUI.ButtonWithStyle(modName, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							-- Selected et non Active : sur Active la livree
							-- changeait a chaque frame ou la ligne etait
							-- simplement survolee au clavier.
							if Selected then
								SetVehicleLivery(veh, i)
								dirty = true
							end
						end)
					end
				end

				local modLiveryCount = GetNumVehicleMods(veh, 48)

				if modLiveryCount > 0 then
					for i = 0, modLiveryCount - 1, 1 do
						local modName = GetModTextLabel(veh, 48, i)
						modName = GetLabelText(modName)
						if modName == 'NULL' then modName = 'Livrée Custom ' .. i end

						RageUI.ButtonWithStyle(modName, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if Selected then
								SetVehicleMod(veh, 48, i, false)
								dirty = true
							end
						end)
					end
				end

				RageUI.Separator()

				RageUI.ButtonWithStyle("Retirer les vitres teintées", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
					if Selected then
						SetVehicleWindowTint(veh, 0)
						dirty = true
					end
				end)
			end, function()
			end)

			Wait(0)
		end

		-- Sortie du menu, quel que soit le chemin (touche, ESC, eloignement) :
		-- c'est ici qu'on persiste.
		if dirty then
			SaveExtraChanges(menuVeh)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		local nearThing = false
		local allowed = false

		for k in pairs(ConfigExtra.positions) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ConfigExtra.positions[k].x, ConfigExtra.positions[k].y, ConfigExtra.positions[k].z)

			if dist <= 7.0 then
				for i, j in pairs(ConfigExtra.jobs) do
					if j == ESX.PlayerData.job.name then
						allowed = true
					end
				end

				if allowed == true then
					nearThing = true
					DrawMarker(6, ConfigExtra.positions[k].x, ConfigExtra.positions[k].y, ConfigExtra.positions[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
					ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour ouvrir le menu des extras de véhicules")
					if IsControlJustPressed(1,51) then
						if Extra == false then
							if IsPedInAnyVehicle(PlayerPedId(), false) then
								local moteurveh = math.floor(GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) / 10)
								if moteurveh < 85 then
									ESX.ShowNotification("~r~Vous ne pouvez pas modifier un véhicule lorsque celui-ci n'est pas en bon état ! Visitez un mécano dès aujourd'hui.")
								else
									AddMenuExtra()
								end
							else
								ESX.ShowNotification("~r~Vous devez être dans un véhicule.")
							end
						end
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
