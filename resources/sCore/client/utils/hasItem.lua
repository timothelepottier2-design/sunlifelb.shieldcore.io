function hasItem(itemName)
    local inventory = ESX.GetPlayerData().inventory
    if not inventory then return false end

    for _, item in pairs(inventory) do
        if item.name == itemName and item.count and item.count > 0 then
            return true
        end
    end

    return false
end

exports("hasItem", hasItem)
