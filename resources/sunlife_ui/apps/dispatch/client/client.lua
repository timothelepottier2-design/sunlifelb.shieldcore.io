local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'dispatch', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'dispatch', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('dispatch/' .. name, cb)
end

local Config = DispatchConfig or {}

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and obj then
            ESX = obj
        else
            TriggerEvent('esx:getShtozaredObjtozect', function(o) ESX = o end)
        end
        Citizen.Wait(200)
    end
end)

local function getDisplayName()
    if ESX then
        local ok, pd = pcall(function() return ESX.GetPlayerData() end)
        if ok and pd then
            if pd.firstName then
                return (pd.firstName .. ' ' .. (pd.lastName or '')):gsub('%s+$', '')
            end
            if pd.name and pd.name ~= '' then return pd.name end
        end
    end
    return GetPlayerName(PlayerId())
end

lib.callback.register('dispatch:getIdentity', function()
    return { name = getDisplayName(), callsign = nil }
end)

local KVP_MATRICULE = 'dispatch:matricule'
local matricule = GetResourceKvpString(KVP_MATRICULE) or ''

local function sendIdentity()
    TriggerServerEvent('dispatch:setMatricule', matricule)
end

RegisterNetEvent('dispatch:requestIdentity', function()
    sendIdentity()
end)

RegisterNUICallback('panelSetMatricule', function(data, cb)
    local m = tostring((data and data.matricule) or ''):gsub('[^%w%-]', ''):sub(1, 10)
    matricule = m
    if m == '' then
        DeleteResourceKvp(KVP_MATRICULE)
    else
        SetResourceKvp(KVP_MATRICULE, m)
    end
    sendIdentity()
    cb({ ok = true, matricule = m })
end)

local stack = {}
local acceptedCalls = {}
local callPos = {}

local function pushTop(id) table.insert(stack, 1, id) end
local function removeFromStack(id)
    for i = #stack, 1, -1 do
        if stack[i] == id then table.remove(stack, i) break end
    end
end
local function topId() return stack[1] end
local function isAccepted(id) return acceptedCalls[id] == true end
local function markAccepted(id) acceptedCalls[id] = true end

local ARRIVE_DIST = 30.0
local BLIP_MAX_MS = 15 * 60 * 1000

local function createDispatchBlip(coords)
    local x = coords.x or coords[1]
    local y = coords.y or coords[2]
    local z = coords.z or coords[3] or 0.0
    if not (x and y) then return end

    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 161)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Appel Dispatch")
    EndTextCommandSetBlipName(blip)

    CreateThread(function()
        local deadline = GetGameTimer() + BLIP_MAX_MS
        local target = vector3(x + 0.0, y + 0.0, z + 0.0)
        while DoesBlipExist(blip) do
            Wait(1500)
            local p = GetEntityCoords(PlayerPedId())
            if #(p - target) <= ARRIVE_DIST or GetGameTimer() >= deadline then
                if DoesBlipExist(blip) then RemoveBlip(blip) end
                break
            end
        end
    end)
end

local function acceptCall(id)
    if not id or isAccepted(id) then return end
    markAccepted(id)
    TriggerServerEvent('dispatch:agentAccepted', id, getDisplayName())
    if callPos[id] then createDispatchBlip(callPos[id]) end
end

local function refuseCall(id)
    if not id then return end
    TriggerServerEvent('dispatch:agentRefused', id)
end

RegisterCommand('dispatch_accept', function()
    local id = topId()
    if id and not isAccepted(id) then
        acceptCall(id)
        SendNUIMessage({ action = 'dispatch:accept', payload = { id = id } })
    end
end, false)

RegisterCommand('dispatch_refuse', function()
    local id = topId()
    if id then
        SendNUIMessage({ action = 'dispatch:refuse', payload = { id = id } })
        refuseCall(id)
        removeFromStack(id)
    end
end, false)

RegisterKeyMapping('dispatch_accept', 'Accepter un appel dispatch', 'keyboard', 'Y')
RegisterKeyMapping('dispatch_refuse', 'Refuser un appel dispatch', 'keyboard', 'N')

local panelOpen = false

local function getJobName()
    if ESX then
        local ok, pd = pcall(function() return ESX.GetPlayerData() end)
        if ok and pd and pd.job and pd.job.name then return pd.job.name end
    end
    return nil
end

local function canOpenPanel()
    local jobs = Config.PanelJobs
    if not jobs then return true end
    local j = getJobName()
    return j ~= nil and jobs[j] == true
end

local function openPanel()
    if panelOpen then return end
    panelOpen = true
    lib.callback('dispatch:getState', false, function(state, reason)
        if not panelOpen then return end

        if not state then
            panelOpen = false
            if lib and lib.notify then
                local msg = (reason == 'duty')
                    and 'Vous devez être en service pour ouvrir le dispatch.'
                    or 'Accès réservé aux forces de l\'ordre.'
                lib.notify({ title = 'Dispatch', description = msg, type = 'error' })
            end
            return
        end
        state.myMatricule = matricule
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'dispatch:openPanel', payload = state })
    end)
end

local function closePanel()
    if not panelOpen then return end
    panelOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'dispatch:closePanel' })
end

local function togglePanel()
    if panelOpen then
        closePanel()
        return
    end
    if not canOpenPanel() then
        if lib and lib.notify then
            lib.notify({ title = 'Dispatch', description = 'Accès réservé aux forces de l\'ordre.', type = 'error' })
        end
        return
    end
    openPanel()
end

RegisterCommand('dispatch_panel', function() togglePanel() end, false)
RegisterKeyMapping('dispatch_panel', 'Ouvrir le dispatch', 'keyboard', Config.OpenKey or '')

RegisterNetEvent('dispatch:sync', function(state)
    if panelOpen then
        SendNUIMessage({ action = 'dispatch:panelUpdate', payload = state or { calls = {}, units = {} } })
    end
end)

RegisterNUICallback('panelClose', function(_, cb)
    closePanel()
    cb({})
end)

RegisterNUICallback('panelAccept', function(data, cb)
    if data and data.id then acceptCall(data.id) end
    cb({})
end)

RegisterNUICallback('panelRefuse', function(data, cb)
    if data and data.id then refuseCall(data.id) end
    cb({})
end)

RegisterNUICallback('panelSetChannel', function(data, cb)
    TriggerServerEvent('dispatch:setChannel', data and data.channel)
    cb({})
end)

RegisterNetEvent('dispatch:notify', function(msg, typ)
    if lib and lib.notify then
        lib.notify({ title = 'Dispatch', description = msg, type = typ or 'inform' })
    elseif ESX then
        ESX.ShowNotification(msg)
    end
end)

RegisterNUICallback('panelWaypoint', function(data, cb)
    local c = data and data.coords
    if c then
        local x = c.x or c[1]
        local y = c.y or c[2]
        if x and y then SetNewWaypoint(x + 0.0, y + 0.0) end
    end
    cb({})
end)

local seq = 0
local function newId()
    seq = seq + 1
    return ('d_%d_%d'):format(GetGameTimer(), seq)
end

local function _unpackCoords(c)
    if not c then return nil end
    if type(c) == 'vector3' then return c.x, c.y, c.z end
    if type(c) == 'table' then
        local x = c.x or c[1]
        local y = c.y or c[2]
        local z = c.z or c[3] or 0.0
        if x and y then return x, y, z end
    end
    return nil
end

local function coordsToLocationName(coords)
    local x, y, z = _unpackCoords(coords)
    if not x then return nil end

    local zoneCode = GetNameOfZone(x, y, z)
    local zoneLabel = GetLabelText(zoneCode)
    if not zoneLabel or zoneLabel == "NULL" then zoneLabel = zoneCode or "Inconnu" end

    local s1, s2 = GetStreetNameAtCoord(x, y, z)
    local street = s1 and GetStreetNameFromHashKey(s1) or nil
    local cross = (s2 and s2 ~= 0) and GetStreetNameFromHashKey(s2) or nil

    if street and street ~= "" then
        if cross and cross ~= "" then
            return ("%s — %s / %s"):format(zoneLabel, street, cross)
        else
            return ("%s — %s"):format(zoneLabel, street)
        end
    end
    return zoneLabel or "Position inconnue"
end

RegisterNetEvent("dispatch:show")
AddEventHandler("dispatch:show", function(data)
    local id = data.id or newId()
    local locName = data.location or ""
    if data.coords and (not data.location or data.location == "") then
        locName = coordsToLocationName(data.coords) or ""
    end

    pushTop(id)
    callPos[id] = data.coords

    SendNUIMessage({
        action = 'dispatch:add',
        payload = {
            id       = id,
            code     = data.code or "",
            title    = data.title or "",
            message  = data.message or "",
            coords   = data.coords,
            location = locName,
            baseMs   = data.baseMs or (Config.AnnounceMs or 10000),
            urgency  = data.urgency or 1,
            scale    = data.scale or 0.91,
        }
    })
end)

RegisterNetEvent('dispatch:updateAgents', function(id, count)
    SendNUIMessage({
        action = 'dispatch:updateAgents',
        payload = { id = id, count = count }
    })
end)

RegisterNetEvent('dispatch:close', function(id)
    removeFromStack(id)
    SendNUIMessage({ action = 'dispatch:close', payload = { id = id } })
end)

RegisterNUICallback('accept', function(data, cb)
    acceptCall(data.id)
    cb({})
end)
RegisterNUICallback('refuse', function(data, cb)
    refuseCall(data.id)
    removeFromStack(data.id)
    cb({})
end)
RegisterNUICallback('refused', function(data, cb)
    removeFromStack(data.id)
    cb({})
end)
RegisterNUICallback('timeout', function(data, cb)
    removeFromStack(data.id)
    cb({})
end)
RegisterNUICallback('closed', function(data, cb)
    removeFromStack(data.id)
    cb({})
end)

CreateThread(function()
    local tc = Config.TargetCall
    if not tc or not tc.enabled or not tc.models then return end
    while GetResourceState('ox_target') ~= 'started' do Wait(500) end

    local cdMs = (tc.cooldown or 300) * 1000
    local lastCall = 0

    exports.ox_target:addModel(tc.models, {
        {
            name     = 'dispatch_civilian_call',
            label    = tc.label or 'Appeler la police',
            icon     = tc.icon or 'fas fa-phone',
            distance = tc.distance or 2.5,
            onSelect = function()
                local now = GetGameTimer()
                if now - lastCall < cdMs then
                    local remain = math.ceil((cdMs - (now - lastCall)) / 1000)
                    if lib and lib.notify then
                        local m, s = math.floor(remain / 60), remain % 60
                        lib.notify({
                            title       = 'Police',
                            description = ('Patientez encore %s%ds avant de rappeler.'):format(m > 0 and (m .. 'm ') or '', s),
                            type        = 'error',
                        })
                    end
                    return
                end
                lastCall = now

                local coords = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('dispatch:civilianAlert', {
                    x = coords.x, y = coords.y, z = coords.z,
                })
                if lib and lib.notify then
                    lib.notify({
                        title       = 'Police',
                        description = 'Vous avez signalé la situation à la police.',
                        type        = 'success',
                    })
                end
            end,
        },
    })
end)

CreateThread(function()
    local cfg = Config.Phone911
    if not cfg or not cfg.enabled or not cfg.number then return end
    while GetResourceState('lb-phone') ~= 'started' do Wait(500) end

    local ok = exports['lb-phone']:CreateCustomNumber(cfg.number, {
        onCall = function(incomingCall)
            if incomingCall and incomingCall.setName then
                incomingCall.setName(cfg.callName or 'Appel 911')
            end
            TriggerServerEvent('dispatch:phone911')
            if incomingCall and incomingCall.accept then
                incomingCall.accept()
            end
        end,
    })
    if ok == false then
        print('[dispatch] Impossible d\'enregistrer le numéro 911 sur lb-phone')
    end
end)

local KVP_DISPATCH_SOUND = 'dispatch:soundEnabled'
local dispatchSoundEnabled = true

CreateThread(function()
    local v = GetResourceKvpString(KVP_DISPATCH_SOUND)
    if v == nil then
        SetResourceKvp(KVP_DISPATCH_SOUND, '1')
        dispatchSoundEnabled = true
    else
        dispatchSoundEnabled = (v ~= '0')
    end
    SendNUIMessage({ action = 'dispatch:setMuted', payload = { muted = not dispatchSoundEnabled } })
end)

RegisterCommand('dispatch_sound', function(_, args)
    local sub = (args[1] or ''):lower()
    if sub == 'on' or sub == '1' or sub == 'true' then
        dispatchSoundEnabled = true
    elseif sub == 'off' or sub == '0' or sub == 'false' then
        dispatchSoundEnabled = false
    else
        dispatchSoundEnabled = not dispatchSoundEnabled
    end

    SetResourceKvp(KVP_DISPATCH_SOUND, dispatchSoundEnabled and '1' or '0')
    SendNUIMessage({ action = 'dispatch:setMuted', payload = { muted = not dispatchSoundEnabled } })

    if ESX then
        ESX.ShowNotification(('Son dispatch %s'):format(dispatchSoundEnabled and 'activé' or 'désactivé'))
    end
end, false)

CreateThread(function()
    local cfg = Config.Gunshot
    if not cfg or not cfg.enabled then return end

    local ignored = {}
    for _, w in ipairs(cfg.ignoredWeapons or {}) do
        ignored[GetHashKey(w)] = true
    end

    local cooldownMs = (cfg.cooldown or 300) * 1000
    local lastSent   = 0

    local function isIgnoredJob()
        local jobs = cfg.ignoreJobs
        if not jobs then return false end
        local j = getJobName()
        return j ~= nil and jobs[j] == true
    end

    while true do

        local wait = 1500
        local ped  = PlayerPedId()

        if IsPedArmed(ped, 7) then
            wait = 300

            if IsPedShooting(ped) and (GetGameTimer() - lastSent) >= cooldownMs then
                local weapon = GetSelectedPedWeapon(ped)
                if not ignored[weapon] and not isIgnoredJob() then
                    lastSent = GetGameTimer()
                    local c = GetEntityCoords(ped)
                    TriggerServerEvent('dispatch:gunshot', { x = c.x, y = c.y, z = c.z })
                    wait = 2000
                end
            end
        end

        Wait(wait)
    end
end)
