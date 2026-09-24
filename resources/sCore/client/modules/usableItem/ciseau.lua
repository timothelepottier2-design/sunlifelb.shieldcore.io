local useCiseau = false

RegisterNetEvent("sCore.useCiseau", function()
    if exports.sunlife:InZoneSafe() then
        ESX.ShowNotification("Vous ne pouvez pas utiliser des ciseaux ici.")
        return
    end
    if useCiseau then
        ESX.ShowNotification("Vous utilisez déjà des ciseaux.")
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestServerId = lib.getClosestPlayer(playerCoords, 2.0)

    if not closestServerId then
        ESX.ShowNotification("Aucun joueur à proximité.")
        return
    end

    useCiseau = true
    local targetPed = GetPlayerPed(closestServerId)
    local targetCoords = GetEntityCoords(targetPed)

    TaskTurnPedToFaceCoord(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, 1000)
    Wait(1000)
    TaskTurnPedToFaceCoord(targetPed, playerCoords.x, playerCoords.y, playerCoords.z, 1000)
    Wait(1000)

    ExecuteCommand("e mechanic2")
    Wait(1500)

    ClearPedTasksImmediately(playerPed)
    TriggerServerEvent("sCore.applyCiseau", GetPlayerServerId(closestServerId))
    useCiseau = false
end)

RegisterNetEvent("sCore.ciseauEffect", function()
    exports['esx_skin']:GetCachedSkin(function(skin)
        if skin then
            local updatedSkin = skin
            updatedSkin['hair_1'] = 0
            updatedSkin['hair_2'] = 0

            TriggerEvent('skinchanger:loadClothes', skin, updatedSkin)
            TriggerServerEvent('esx_skin:save', updatedSkin)

            ESX.ShowNotification("~g~Vous venez de vous faire couper les cheveux !")
        else
            ESX.ShowNotification("~r~Impossible de modifier la coupe.")
        end
    end)
end)
