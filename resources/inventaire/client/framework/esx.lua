ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()

    while INVENTORY.Player == nil do
        ESX.PlayerData = ESX.GetPlayerData()

        INVENTORY.Player = ESX.PlayerData.inventory
        Wait(100)
    end
    -- TriggerServerEvent("inventory:server:loadraccourci")
    TriggerServerEvent("inventory:server:getActive")
    TriggerServerEvent("inventory:server:getOutfit")
end)
