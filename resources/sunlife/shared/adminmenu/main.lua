function canUse(permission, playerRank)
    if playerRank == "user" then
        return false
    end
    if type(AdminMenu.authorizations[permission]) ~= "table" then
        return true
    end
    for _, rank in pairs(AdminMenu.authorizations[permission]) do
        if rank == playerRank then
            return true
        end
    end
    return false
end
