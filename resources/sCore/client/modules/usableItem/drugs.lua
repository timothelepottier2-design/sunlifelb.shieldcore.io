local consumePooch = false

RegisterNetEvent("sCore.usableDrugsPooch", function(itemName)
    if not itemName or consumePooch then
        return
    end

    local ped = PlayerPedId()
    if not ped or not DoesEntityExist(ped) or IsEntityDead(ped) then
        return
    end

    consumePooch = true

    local animDict = "amb@world_human_smoking@male@male_a@enter"
    local animName = "enter"
    loadDict(animDict)

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    local result = lib.progressCircle({
        duration = 15000,
        useWhileDead = false,
        canCancel = true,
        label = '🚬 Consommation de produit illicite...',
        disable = {
            car = true,
            move = false,
            combat = true,
        }
    })

    ClearPedTasks(ped)

    if not result then
        ESX.ShowNotification("Vous avez annulé la consommation du pochon.")
        consumePooch = false
        return
    end

    ESX.ShowNotification("~g~Vous avez consommé le pochon de " .. itemName:gsub("_pooch", "") .. " !")
    StartScreenEffect("DrugsTrevorClownsFight", 0, true)

    Citizen.CreateThread(function()
        Wait(78000)
        StopScreenEffect("DrugsTrevorClownsFight")
    end)
    consumePooch = false

    TriggerServerEvent("sCore.removeDrugPooch", itemName)
end)
