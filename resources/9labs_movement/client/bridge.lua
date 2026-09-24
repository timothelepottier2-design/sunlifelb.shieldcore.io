local settings = require 'shared.settings'
local Bridge = { framework = 'standalone' }
local core, esx
local cached, cachedAt = true, 0

---@return string
local function detect()
    local wanted = settings.framework
    if wanted and wanted ~= 'auto' then return wanted end
    if GetResourceState('qbx_core') == 'started' then return 'qbx' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    if GetResourceState('ox_core') == 'started' then return 'ox' end
    return 'standalone'
end

Bridge.framework = detect()

if Bridge.framework == 'qb' then
    pcall(function() core = exports['qb-core']:GetCoreObject() end)
elseif Bridge.framework == 'esx' then
    pcall(function() esx = exports.es_extended:getSharedObject() end)
end

---@return table?
local function metadata()
    if Bridge.framework == 'qbx' then
        local ok, data = pcall(function() return exports.qbx_core:GetPlayerData() end)
        return ok and type(data) == 'table' and data.metadata or nil
    end
    if Bridge.framework == 'qb' and core then
        local data = core.Functions.GetPlayerData()
        return type(data) == 'table' and data.metadata or nil
    end
end

---@return boolean
function Bridge.isLoaded()
    local framework = Bridge.framework
    if framework == 'qbx' or framework == 'qb' then return LocalPlayer.state.isLoggedIn == true end
    if framework == 'esx' then return esx ~= nil and esx.IsPlayerLoaded() == true end
    return true
end

---@return boolean
function Bridge.isDead()
    local framework = Bridge.framework
    if framework == 'qbx' and GetResourceState('qbx_medical') == 'started' then
        local ok, dead = pcall(function()
            return exports.qbx_medical:IsDead() or exports.qbx_medical:IsLaststand()
        end)
        if ok and dead then return true end
    end
    if framework == 'esx' then
        return esx ~= nil and esx.PlayerData ~= nil and esx.PlayerData.dead == true
    end
    if framework == 'ox' then return LocalPlayer.state.isDead == true end
    local meta = metadata()
    if meta and (meta.isdead or meta.inlaststand) then return true end
    return false
end

---@return boolean
function Bridge.isCuffed()
    local meta = metadata()
    return meta ~= nil and meta.ishandcuffed == true
end

---@param ped integer
---@return boolean
function Bridge.canPeek(ped)
    local now = GetGameTimer()
    if now - cachedAt < 100 then return cached end
    cachedAt = now
    cached = Bridge.isLoaded() and not Bridge.isDead() and not Bridge.isCuffed()
    return cached
end

---@param side integer
function Bridge.onPeekChanged(side)
end

return Bridge
