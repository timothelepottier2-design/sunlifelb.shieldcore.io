ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('coffres:openCoffre')
AddEventHandler('coffres:openCoffre', function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    local myjob = ESX.PlayerData.job.name
    local gangData = exports['sunlife_ui']:GetMyGangData()
    local gangName = exports['sunlife_ui']:GetMyGangName()

    if myjob == job then
        myjob = string.gsub(myjob, " ", "")
        TriggerServerEvent("inventory:server:openSociety", myjob)
    elseif gangName and gangName == job then
        local cleanName = string.gsub(gangName, " ", "")
        TriggerServerEvent("inventory:server:openSociety", cleanName)
    elseif gangData and tostring(gangData.id) == tostring(job) then
        local cleanName = string.gsub(gangData.name or "", " ", "")
        TriggerServerEvent("inventory:server:openSociety", cleanName)
    else
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce coffre !")
    end
end)
