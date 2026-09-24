function teleportToCoords(x, y, z)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        ESX.ShowNotification("~r~Vous n'avez pas l'autorisation de vous téléporter.")
        return false
    end

    if (staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour vous téléporter.")
        return false
    end

    if not x or not y or not z then
        ESX.ShowNotification("~r~Coordonnées invalides.")
        return false
    end

    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
    return true
end
