local function targetIsDead(targetId)
    local playerId = GetPlayerFromServerId(targetId)
    if playerId == -1 then
        return false
    end
    local ped = GetPlayerPed(playerId)
    if ped == 0 then
        return false
    end
    return IsEntityDead(ped) or IsPedFatallyInjured(ped)
end

RegisterCommand("cinv", function(source, args)
    local valid, msg = canUseStaffCommand()
    if not valid then
        if msg then
            ESX.ShowNotification(msg)
        end
        return
    end

    if not args[1] then
        ESX.ShowNotification("~r~Command invalide, utilisez : /cinv [id / license]")
        return
    end

    TriggerServerEvent("sCore.clearInv", args[1])
end)

local isFreeze = false

RegisterNetEvent("sCore.freezeTarget", function()
    local ped = PlayerPedId()
    isFreeze = not isFreeze

    SetEntityCollision(ped, not isFreeze)
    FreezeEntityPosition(ped, isFreeze)
    SetPlayerInvincible(PlayerId(), isFreeze)

    if isFreeze then
        ESX.ShowNotification("~r~Vous êtes freeze par un membre du staff.")
    else
        ESX.ShowNotification("~g~Vous n'êtes plus freeze grâce à un membre du staff.")
    end
end)

RegisterCommand("freeze", function(source, args)
    local valid, msg = canUseStaffCommand()
    if not valid then
        if msg then
            ESX.ShowNotification(msg)
        end
        return
    end

    if not args[1] then
        ESX.ShowNotification("~r~Command invalide, utilisez : /freeze [id]")
        return
    end

    TriggerServerEvent("sCore.freezePlayer", args[1])
end)

RegisterCommand("annonce", function(source, args, rawCommand)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        return
    end
    if (staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour utiliser cette commande")
        return
    end

    local targetJob = args[1]
    if not targetJob then
        ESX.ShowNotification("~r~Command invalide, utilisez : /annonce [all/job] [message]")
        return
    end

    local message = table.concat(args, " ", 2)
    if message == nil or message == "" then
        ESX.ShowNotification("~r~Command invalide, utilisez : /annonce [all/job] [message]")
        return
    end
    TriggerServerEvent("sCore.sendAnnouncement", targetJob, message)
end)

RegisterCommand("kick", function(source, args)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "mod" and staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        return
    end

    if (staffRank == "mod" or staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour utiliser cette commande")
        return
    end

    if not args[1] then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /kick [id] [raison]")
        return
    end

    local targetId = tonumber(args[1])
    local reason = table.concat(args, " ", 2)

    if not reason or reason:gsub("%s+", "") == "" then
        reason = "Aucune raison fournie"
    end

    TriggerServerEvent("sCore.kickPlayer", targetId, reason)
end)

RegisterCommand("tp", function(source, args)
    if not args[1] or not args[2] or not args[3] then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /tp [x][y][z]")
        return
    end

    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    teleportToCoords(x, y, z)
end)

RegisterCommand("dv", function(source, args)
    local valid, msg = canUseStaffCommand()
    if not valid then
        if msg then
            ESX.ShowNotification(msg)
        end
        return
    end

    if not args[1] then
        args[1] = tonumber(3)
    end

    TriggerEvent('esx:deleteVehicle', args[1])

    TriggerServerEvent('sCore.logDeleteVehicle', tonumber(args[1]) or 3)
end)

RegisterCommand("job", function(source, args)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        return
    end

    if (staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour utiliser cette commande")
        return
    end

    if not args[1] or not args[2] or not args[3] then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /job [id] [job] [grade]")
        return
    end

    TriggerServerEvent("sCore.updateJobPlayer", args[1], args[2], args[3])
end)

RegisterCommand("gitem", function(source, args)
    local staffRank = exports.sCore:staffRank()

    if staffRank ~= "superadmin" then
        return
    end

    if not args[1] or not args[2] or not args[3] then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /gitem [id] [item] [quantité]")
        return
    end

    local targetId = tonumber(args[1])
    local quantity = tonumber(args[3])
    local itemName = args[2]

    TriggerServerEvent("sCore.giveItemPlayer", targetId, itemName, quantity)
end)

RegisterCommand("revive", function(source, args)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "help" and staffRank ~= "test" and staffRank ~= "mod" and staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        return
    end

    if (staffRank == "help" or staffRank == "test" or staffRank == "mod" or staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour utiliser cette commande")
        return
    end

    if not args[1] then
        args[1] = GetPlayerServerId(PlayerId())
    end

    local targetId = tonumber(args[1])
    if not targetId or GetPlayerFromServerId(targetId) == -1 then
        ESX.ShowNotification("~r~ID invalide ou joueur déconnecté.")
        return
    end

    if not targetIsDead(targetId) then
        ESX.ShowNotification("~r~Le joueur n'est pas mort.")
        return
    end

    TriggerServerEvent("sCore.updateHealthPlayer", targetId)
end)

RegisterCommand("revivezone", function(source, args)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "test" and staffRank ~= "mod" and staffRank ~= "admin" and staffRank ~= "gerant" and staffRank ~= "superadmin" then
        return
    end

    if (staffRank == "test" or staffRank == "mod" or staffRank == "admin" or staffRank == "gerant") and not staffMode then
        ESX.ShowNotification("~r~Vous devez être en mode staff pour utiliser cette commande")
        return
    end

    local radius = tonumber(args[1])
    if not radius then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /revivezone [raduis]")
        return
    end

    if radius <= 0 or radius > 30 then
        ESX.ShowNotification("~r~Le rayon doit être un nombre entre 1 et 30 mètres.")
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local players = lib.getNearbyPlayers(coords, radius, true)
    local revived = 0

    for i = 1, #players do
        local id = GetPlayerServerId(players[i].id)
        if id ~= GetPlayerServerId(PlayerId()) and targetIsDead(id) then
            TriggerServerEvent("sCore.updateHealthPlayer", id)
            revived = revived + 1
        end
    end

    ESX.ShowNotification(("~g~%d joueur(s) ont été réanimé(s) dans un rayon de %sm."):format(revived, radius))
end)

RegisterCommand("level", function(source, args)
    local staffRank = exports.sCore:staffRank()
    local staffMode = exports.sunlife:getStaffMod()

    if staffRank ~= "superadmin" then
        return
    end

    if not args[1] or not args[2] then
        ESX.ShowNotification("~r~Commande invalide, utilisez : /level [id] [rank]")
        return
    end

    local targetId = tonumber(args[1])
    local rank = tonumber(args[2])
    if not targetId or not rank or rank < 1 then
        ESX.ShowNotification("~r~Le niveau doit être supérieur ou égal à 1")
        return
    end

    TriggerServerEvent("sCore.setLevelXp", targetId, rank)
    ESX.ShowNotification(("~g~Vous avez mis le niveau de l'id %s à %d."):format(tonumber(targetId), rank))
end)
