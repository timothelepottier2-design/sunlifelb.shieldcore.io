TELEPORTS = {
    ["lastCalled"] = 0,
    ["teleportsList"] = {
        {
            name = "Entrée casino",
            text3d = "Entrée casino",
            type = 1,
            pos = vector3(935.82, 47.0, 81.1),
            teleportPoint = vector3(1089.72, 206.11, -49.0),
            interactMessage = "ENTRER DANS LE CASINO",
        },
        {
            name = "Sortie casino",
            text3d = "Sortie casino",
            type = 1,
            pos = vector3(1089.72, 206.11, -49.0),
            teleportPoint = vector3(935.82, 47.0, 81.1),
            interactMessage = "SORTIR DU CASINO",
        },
    },
}

Citizen.CreateThread(function()
    while true do
        local interval = 1000

        for k,v in pairs(TELEPORTS["teleportsList"]) do
            if #(GetEntityCoords(PlayerPedId()) - v.pos) < 100.0 then
                interval = 0
                DrawMarker(6, v.pos.x, v.pos.y, v.pos.z - 0.95, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 117, 31, 225)
            end

            if #(GetEntityCoords(PlayerPedId()) - v.pos) < 10.0 then
                if v.text3d then
                    DrawText3D(vector3(v.pos.x, v.pos.y, v.pos.z - 0.50), v.text3d, 1.0, 255, 6)
                end
            end

            if #(GetEntityCoords(PlayerPedId()) - v.pos) < 2.0 then

                if not v.called then
                    v.called = true
                    PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)
                end

                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vous téléporter")
                
                if IsControlJustPressed(0, 38) and GetGameTimer() > TELEPORTS["lastCalled"] then
                    TELEPORTS["lastCalled"] = GetGameTimer() + 500

                    if v.type == 1 then
                        exports["sCore"]:setFreecamBypass(true)
                        Wait(1000)
                        TELEPORTS.TeleportPlayer(v.teleportPoint)
                        Wait(3000)
                        exports["sCore"]:setFreecamBypass(false)
                    end
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

Teleport = function(entity, coords, collisionCb)
	if DoesEntityExist(entity) then
		SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
			SetGameplayCamRelativeHeading(0.0)
		elseif type(coords) == 'vector4' then
			SetEntityHeading(entity, coords.w)
			SetGameplayCamRelativeHeading(0.0)
		end

		if collisionCb then
			collisionCb()
		end

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		local timeout = GetGameTimer() + 60000
		while not HasCollisionLoadedAroundEntity(entity) and GetGameTimer() < timeout do
			Citizen.Wait(0)
		end
	end
end

TELEPORTS.TeleportPlayer = function(teleportCoords, cb)
	DoScreenFadeOut(800)
	Citizen.Wait(800)

	local playerPed = PlayerPedId()
	Teleport(playerPed, teleportCoords, cb)

	DoScreenFadeIn(800)
end