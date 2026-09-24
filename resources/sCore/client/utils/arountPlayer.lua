function GetAroundPlayers()
    local players = lib.getNearbyPlayers(GetEntityCoords(PlayerPedId()), 10, true)
    local data = {}
    for i = 1, #players do
        table.insert(data, GetPlayerServerId(players[i].id))
    end
    return data
end
