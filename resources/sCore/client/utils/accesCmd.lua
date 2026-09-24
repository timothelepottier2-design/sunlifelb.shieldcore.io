function canUseStaffCommand()
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank == "user" then
        return false, nil
    end

    if staffRank ~= "superadmin" and not staffMode then
        return false, "~r~Vous devez être en mode staff pour utiliser cette commande"
    end

    return true, nil
end
