local spectateData = {
    toggle = false,
    targetPlayer = 0,
    targetPed = 0
}

RegisterNetEvent("spectate:starting")
AddEventHandler("spectate:starting", function(targetId, targetPedId)
    spectateData = {
        toggle = true,
        targetPlayer = targetId,
        targetPed = NetworkGetEntityFromNetworkId(targetPedId)
    }

    if DoesEntityExist(spectateData.targetPed) then
        NetworkSetInSpectatorMode(true, spectateData.targetPed)
        ESX.ShowNotification("Vous êtes en mode spectateur")
    else
        TriggerServerEvent("spectate:teleportToTarget", targetId)
    end
end)

RegisterNetEvent("spectate:stop")
AddEventHandler("spectate:stop", function()
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, spectateData.targetPed)
        SetEntityCoords(PlayerPedId(), GetEntityCoords(spectateData.targetPed))
    end
    spectateData = { toggle = false, targetPlayer = 0, targetPed = 0 }
    ESX.ShowNotification("Vous avez quitté le mode spectateur")
end)

UTILS = {}

GetUtils = function()
    return UTILS
end

UTILS.isInSpectate = function()
    return SPECTATE["spectating"]
end
