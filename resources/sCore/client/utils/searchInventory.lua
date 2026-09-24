function searchInventory(items, count)
    local item
    if type(items) == 'string' then
        item, items = items, { items }
    end

    if not ESX or not ESX.PlayerData or not ESX.PlayerData.inventory then
        return item and nil or {}
    end

    local searched = {}
    for i = 1, #items do
        searched[i] = items[i]
    end

    local data = {}
    local inventory = ESX.PlayerData.inventory
    for i = 1, #inventory do
        local e = inventory[i]
        for ii = 1, #searched do
            if e.name == searched[ii] then
                data[table.remove(searched, ii)] = count and e.count or e
                break
            end
        end
        if #searched == 0 then
            break
        end
    end

    return not item and data or data[item]
end

exports('searchInventory', searchInventory)
