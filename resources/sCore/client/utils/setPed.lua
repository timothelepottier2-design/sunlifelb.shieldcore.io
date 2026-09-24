function setPedToPlayer(player, namePed)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        ESX.ShowNotification("~r~Vous n'avez pas l'autorisation de vous changer en PED.")
        return false
    end

    if (staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour vous changer en PED.")
        return false
    end

    loadModel(namePed)

    SetPlayerModel(player, namePed)
    SetModelAsNoLongerNeeded(namePed)
end
