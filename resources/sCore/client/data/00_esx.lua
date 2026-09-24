ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect", function(obj)
            ESX = obj
        end)
        Citizen.Wait(200)
    end
end)
