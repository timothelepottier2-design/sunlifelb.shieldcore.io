local onlinePlayers, forceDraw = {}, false
local licensesWl = {
    ['license:6efefa2d215f21e69ebdafb83870b300d1dbf89b'] = true,
    ['license:d14397b6f21326c162530e2ac1be04963a6d9132'] = true,
    ['license:6244938216a461e7dee3f8e86f451c3a1d11b9cf'] = true,
    ['license:5028e1b02d936912e3deb6bfe4015989d5205996'] = true,
    ['license:96237d11181ff77fa34e7fffb6c2e9aecb09483d'] = true,
    ['license:2f642f4426307ef9e921090b371192d062337163'] = true,
}

Citizen.CreateThread(function()
    TriggerServerEvent("tgiann-showid:add-id")
    while true do
        local forceIT = false

        if forceDraw then
            forceIT = true
            for k, v in pairs(GetNeareastPlayers()) do
                local x, y, z = table.unpack(v.coords)
                if not licensesWl[string.lower(v.topText)] or v.playerId == GetPlayerServerId(PlayerId()) then
                    Draw3DText(x, y, z + 1.1, v.playerId, 1.6)

                end
            end
        end

        if forceIT then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterCommand("seeid", function()
    if not forceDraw then
        forceDraw = not forceDraw
        Citizen.Wait(5000)
        forceDraw = false
    end
end, false)
RegisterKeyMapping('seeid', 'ID Joueur', 'keyboard', 'INSERT')

RegisterNetEvent('tgiann-showid:client:add-id')
AddEventHandler('tgiann-showid:client:add-id', function(identifier, playerSource)
    if playerSource then
        onlinePlayers[playerSource] = identifier
    else
        onlinePlayers = identifier
    end
end)

RegisterCommand('id', function()
    if not forceDraw then
        forceDraw = not forceDraw
        Citizen.Wait(5000)
        forceDraw = false
    end
end)

function Draw3DText(x, y, z, text, newScale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = newScale * (1 / dist) * (1 / GetGameplayCamFov()) * 100
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players_clean = {}
    local playerCoords = GetEntityCoords(playerPed)

    local players, _ = GetPlayersInArea(playerCoords, 10)
    for i = 1, #players, 1 do
        local playerServerId = GetPlayerServerId(players[i])
        local player = GetPlayerFromServerId(playerServerId)
        local ped = GetPlayerPed(player)
        if IsEntityVisible(ped) then
            for x, identifier in pairs(onlinePlayers) do
                if x == tostring(playerServerId) then
                    table.insert(players_clean, {topText = identifier:upper(), playerId = playerServerId, coords = GetEntityCoords(ped)})
                end
            end
        end
    end

    return players_clean
end

function GetPlayersInArea(coords, area)
	local players, playersInArea = GetPlayers(), {}
	local coords = vector3(coords.x, coords.y, coords.z)
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)

		if #(coords - targetCoords) <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end
