function getPlayerVipName()
    local vipRanks = {
        legendary = true,
        platinium = true,
        diamond = true,
        gold = true
    }

    if not ESX or not ESX.PlayerData or type(ESX.PlayerData.rank) ~= "table" then
        return nil
    end

    for _, rankInfo in ipairs(ESX.PlayerData.rank) do
        if vipRanks[rankInfo.name] then
            return rankInfo.name
        end
    end

    return nil
end
