local Config = RadioKeeperConfig
local ESX, QBCore = nil, nil
local hasESX  = GetResourceState('es_extended') == 'started'
local hasQB   = GetResourceState('qb-core') == 'started'
if hasESX then

  pcall(function() TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end) end)

  if not ESX then pcall(function() ESX = exports['es_extended']:getSharedObject() end) end
elseif hasQB then
  QBCore = exports['qb-core']:GetCoreObject()
end

local function notify(msg, typ)
  typ = typ or 'info'
  if GetResourceState('okokNotify') == 'started' then
    exports['okokNotify']:Alert(Config.NotifyTag, msg, 3500, typ)
    return
  end
  if GetResourceState('mythic_notify') == 'started' then
    exports['mythic_notify']:SendAlert(typ, msg, 3500)
    return
  end
  if ESX and ESX.ShowNotification then
    ESX.ShowNotification(msg)
    return
  end
  if QBCore and QBCore.Functions and QBCore.Functions.Notify then
    QBCore.Functions.Notify(msg, typ, 3500)
    return
  end

  TriggerEvent('chat:addMessage', { args = { '^3[Radio]', msg } })
end

local playerJobName = nil
local function refreshJob()
  if ESX and ESX.GetPlayerData then
    local x = ESX.GetPlayerData()
    playerJobName = x and x.job and string.lower(x.job.name) or nil
    return
  end
  if QBCore and QBCore.Functions.GetPlayerData then
    local x = QBCore.Functions.GetPlayerData()
    playerJobName = x and x.job and string.lower(x.job.name) or nil
    return
  end

  playerJobName = nil
end

if hasESX then
  AddEventHandler('esx:playerLoaded', refreshJob)
  AddEventHandler('esx:setJob', refreshJob)
elseif hasQB then
  RegisterNetEvent('QBCore:Client:OnPlayerLoaded', refreshJob)
  RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job) refreshJob() end)
else

end
CreateThread(refreshJob)

local function canUseRestricted(freq)
  if tonumber(freq) and freq > Config.RestrictedMax then return true end
  if not playerJobName then return false end
  return Config.AllowedJobs[playerJobName] == true
end

local function safeSetRadioEnabled(b)
  pcall(function() exports['pma-voice']:setVoiceProperty('radioEnabled', b and true or false) end)
end
local function safeSetRadioChannel(ch)
  ch = tonumber(ch) or 0
  pcall(function() exports['pma-voice']:setRadioChannel(ch) end)
end

local function tryGetRadioChannel()
  if not Config.TryGetChannelExport then return nil end
  local ok, res = pcall(function()
    if exports['pma-voice'].getRadioChannel then
      return exports['pma-voice']:getRadioChannel()
    end
    if exports['pma-voice'].GetRadioChannel then
      return exports['pma-voice']:GetRadioChannel()
    end
    return nil
  end)
  if ok then return tonumber(res) end
  return nil
end

local waterState = {
  wasInWater = false,
  hadRadio   = false,
  savedChannel = 0,
}
local lastKnownChannel = 0

RegisterNetEvent('radio-water:rememberChannel', function(ch)
  ch = tonumber(ch) or 0
  lastKnownChannel = ch
end)

RegisterNetEvent('pma-voice:client:radioChannel', function(ch)
  lastKnownChannel = tonumber(ch) or lastKnownChannel
end)

RegisterNetEvent('pma-voice:radioActive', function(active)

end)

CreateThread(function()
  while true do
    Wait(Config.PollMs)

    local ped = PlayerPedId()
    local inWater = IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) or IsEntityInWater(ped)

    if inWater and not waterState.wasInWater then
      waterState.wasInWater = true

      local ch = tryGetRadioChannel() or lastKnownChannel or 0
      waterState.hadRadio = (tonumber(ch) or 0) > 0
      waterState.savedChannel = ch

      if waterState.hadRadio then
        safeSetRadioEnabled(false)
        safeSetRadioChannel(0)
        notify("~b~Votre radio grésille et s'éteint en entrant dans l'eau.", 'info')
      end
    end

    if not inWater and waterState.wasInWater then
      waterState.wasInWater = false

      if waterState.hadRadio then
        local target = tonumber(waterState.savedChannel or 0) or 0

        if target > 0 then
          if target <= Config.RestrictedMax and not canUseRestricted(target) then
            notify("~r~Fréquence réservée : reconnexion automatique annulée.", 'error')

            safeSetRadioEnabled(false)
            safeSetRadioChannel(0)
          else
            safeSetRadioEnabled(true)
            safeSetRadioChannel(target)
            lastKnownChannel = target
            notify(("~g~Vous sortez de l'eau, radio réactivée sur %s.00 MHz."):format(tostring(target)), 'success')
          end
        else

          safeSetRadioEnabled(true)
          notify("~g~Vous sortez de l'eau, votre radio se réactive.", 'success')
        end
      end

      waterState.hadRadio = false
      waterState.savedChannel = 0
    end
  end
end)
