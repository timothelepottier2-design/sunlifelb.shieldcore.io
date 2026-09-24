QBCore = nil
ESX = nil

local framework = Config.Framework or 'auto'

if framework == 'qbcore' or (framework == 'auto' and GetResourceState('qb-core') == 'started') then
    QBCore = exports['qb-core']:GetCoreObject()
elseif framework == 'esx' or (framework == 'auto' and GetResourceState('es_extended') == 'started') then
    ESX = exports['es_extended']:getSharedObject()
end

fw = {}

fw.GetVehicleJobs = function(vehicle)
    if not DoesEntityExist(vehicle) then return nil end
    local vehicleModel = GetEntityModel(vehicle)
    local vehicleConfig = Config.RampSModels[vehicleModel]
    
    if vehicleConfig and vehicleConfig.Jobs ~= nil then
        return vehicleConfig.Jobs
    end
    
    return Config.Jobs
end

fw.HasRequiredJob = function(requiredJobs)
    if not requiredJobs then return true end
    
    local playerJob = nil
    
    if QBCore then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job then
            playerJob = PlayerData.job.name
        end
    elseif ESX then
        local PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.job then
            playerJob = PlayerData.job.name
        end
    else
        return true
    end
    
    if not playerJob then return false end
    
    if type(requiredJobs) == 'table' then
        for _, job in pairs(requiredJobs) do
            if job == playerJob then
                return true
            end
        end
        return false
    else
        return requiredJobs == playerJob
    end
end

fw.Notify = function(params)
    local notifySystem = Config.NotificationSystem or 'auto'
    if notifySystem == 'ox_lib' or (notifySystem == 'auto' and GetResourceState('ox_lib') == 'started') then
        lib.notify({
            title = params.title or 'Ramps',
            description = params.message,
            type = params.type or 'inform',
            duration = params.duration or 5000,
        })
    elseif notifySystem == 'esx' or (notifySystem == 'auto' and ESX) then
        local notifyType = params.type == 'error' and 'error' or (params.type == 'success' and 'success' or 'info')
        ESX.ShowNotification(params.message, notifyType, params.duration or 5000)
    elseif notifySystem == 'qbcore' or (notifySystem == 'auto' and QBCore) then
        QBCore.Functions.Notify(params.message, 'primary', 5000)
    else
        SetNotificationTextEntry('STRING')
        AddTextComponentString(params.message)
        DrawNotification(false, false)
    end
end

if ESX then
    RegisterNetEvent('esx:setJob', function(job)
        ESX.PlayerData.job = job
    end)
    
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
    end)
end
