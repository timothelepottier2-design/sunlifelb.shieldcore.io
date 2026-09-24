local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'dmvschool', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'dmvschool', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('dmvschool/' .. name, cb)
end

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local dmvschool = dmvschool or {}
local cfg = cfg_dmvschool

local ERROR_MAX            = 5
local SPEED_TOLERANCE_KMH  = 5
local SPEED_GRACE_MS       = 1500
local POINT_RADIUS         = 3.0
local TICK_SPEED_MS        = 200
local SHOW_DEBUG           = false

local state = {
    active       = false,
    errors       = 0,
    idx          = 0,
    vehicle      = nil,
    limit        = 0,
    overStartMs  = nil,
    freezeUntil  = 0,
    blipNext     = nil,
	monitorPed   = nil,
}

local CAT_BLIPS = {
    ["car"]   = { sprite = 225, color = 5,  scale = 0.8 },
    ["plane"] = { sprite = 423, color = 5,  scale = 0.8 },
    ["boat"]  = { sprite = 410, color = 5,  scale = 0.8 },
}

local schoolPeds  = {}
local schoolBlips = {}

local MAX_RETURN_DIST = (cfg_dmvschool and cfg_dmvschool.maxReturnDist) or 150.0

function getSchoolPos(catKey)
    catKey = catKey or "car"
    local pedCfg = cfg_dmvschool and cfg_dmvschool.peds and cfg_dmvschool.peds[catKey]
    if pedCfg and pedCfg.pos then
        return vector3(pedCfg.pos.x, pedCfg.pos.y, pedCfg.pos.z), pedCfg.pos.w
    end

    return vector3(227.3754, 373.0699, 106.1142), 0.0
end

function createSchoolBlips()

    for k, b in pairs(schoolBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
        schoolBlips[k] = nil
    end

    if not (cfg_dmvschool and cfg_dmvschool.peds) then return end

    for catKey, pedCfg in pairs(cfg_dmvschool.peds) do
        if pedCfg.pos then
            local style = CAT_BLIPS[catKey] or { sprite = 225, color = 5, scale = 0.8 }
            local b = AddBlipForCoord(pedCfg.pos.x, pedCfg.pos.y, pedCfg.pos.z or 0.0)
            SetBlipSprite(b, style.sprite)
            SetBlipColour(b, style.color)
            SetBlipScale(b, style.scale)
            SetBlipDisplay(b, 4)
            SetBlipAsShortRange(b, true)
            SetBlipHighDetail(b, true)

            local key = "BN_SNL_DMVSCHOOL_" .. catKey
            AddTextEntry(key, pedCfg.blipName or pedCfg.label or "Auto-école")
            BeginTextCommandSetBlipName(key)
            EndTextCommandSetBlipName(b)

            schoolBlips[catKey] = b
        end
    end
end

CreateThread(function()
    createSchoolBlips()
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for k, b in pairs(schoolBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
        schoolBlips[k] = nil
    end
    for k, ped in pairs(schoolPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
        schoolPeds[k] = nil
    end
    if state.monitorPed and DoesEntityExist(state.monitorPed) then
        safeDeletePed(state.monitorPed)
    end
end)

OpenDmv = function(catKey)
    catKey = catKey or "car"
    local catData = cfg_dmvschool.categories[catKey]
    if not catData then return end

    ESX.TriggerServerCallback("prime:dmvschool:getLicences", function(licencesByCat)
        licencesByCat = licencesByCat or {}

        local row = licencesByCat[catKey] or {}
        catData.hasCode  = row.hasCode  or false
        catData.hasDrive = row.gotDrive or false

        local owned = {}
        for k, def in pairs(cfg_dmvschool.categories) do
            local r = licencesByCat[k]
            if r and r.gotDrive then
                owned[#owned + 1] = {
                    key        = k,
                    label      = def.label,
                    nameItem   = def.nameItem,
                    rebuyPrice = def.rebuyPrice or def.drivePrice or 0,
                }
            end
        end

        SendNUIMessage({
            action     = 'openTheory',
            resource   = GetCurrentResourceName(),
            passMark   = 80,
            singleType = catKey,
            type       = catData,
            owned      = owned,
        })
        SetNuiFocus(true, true)
    end)
end

CloseDmv = function()
	SendNUIMessage({
        action   = 'closeTheory',
    })
	SetNuiFocus(false,false)
end

RegisterNUICallback('startTheory', function(data, cb)

    local cat   = data.type
    local price = tonumber(data.price) or 0

    ESX.TriggerServerCallback("prime:dmvschool:payCode", function(ok)
        if not ok then
            cb({ ok = false, reason = "not_enough_money" })
            return
        end

        cb({ ok = true })
    end, cat, price)
end)

RegisterNUICallback('startDrive', function(data, cb)

    local cat   = data.type
    local price = tonumber(data.price) or 0

    ESX.TriggerServerCallback("prime:dmvschool:payDrive", function(ok)
        if not ok then
            cb({ ok = false, reason = "not_enough_money" })
            return
        end

		CloseDmv()
        dmvschool.startDrive(cat)
        cb({ ok = true })
    end, cat, price)
end)

RegisterNUICallback('theoryAnswer', function(data, cb)

	cb(1)
end)

RegisterNUICallback('theoryTimeout', function(data, cb)

	cb(1)
end)

RegisterNUICallback('theoryEnded', function(data, cb)

    if data.passed then
        TriggerServerEvent("prime:dmvschool:code:finish", data, true)
    end
	cb(1)
end)

RegisterNUICallback('buyExisting', function(data, cb)
    local cat = data.type
    ESX.TriggerServerCallback("prime:dmvschool:buyExisting", function(ok, reason)
        cb({ ok = ok, reason = reason })
    end, cat)
end)

RegisterNUICallback('close', function(_, cb)
	SetNuiFocus(false,false)
	cb(1)
end)

function getActiveCategory()
    if not state.catId then return nil end
    return cfg_dmvschool.categories[state.catId]
end

function getCourse()
    local cat = getActiveCategory()
    if not cat or not cat.drive then return nil end
    return cat.drive
end

function getPoint(i)
    local course = getCourse()
    if not course then return nil end
    return course[i]
end

function logDebug(msg)
    if SHOW_DEBUG then print(('[DMV] %s'):format(msg)) end
end

function nowMs()
    return GetGameTimer()
end

function toKmh(speedMetersPerSecond)
    return speedMetersPerSecond * 3.6
end

function getEntitySpeedKmh(ent)
    return toKmh(GetEntitySpeed(ent))
end

function getCoordFromVec(vec)
    return vector3(vec.x, vec.y, vec.z)
end

function distance(a, b)
    return #(a - b)
end

function clearNextPointBlip()
    if state.blipNext and DoesBlipExist(state.blipNext) then
        SetBlipRoute(state.blipNext, false)
        RemoveBlip(state.blipNext)
    end
    state.blipNext = nil
end

function setNextPointBlip()
    clearNextPointBlip()

    local nextPoint = getPoint(state.idx + 1)
    if not nextPoint then return end

    local pos = getCoordFromVec(nextPoint.pos)

    local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 60)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, false)
    local _key = "BN_SNL_DMVSCHOOL_2_" .. tostring(blip)
    AddTextEntry(_key, nextPoint.name or ("Point %d"):format(state.idx + 1))
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(blip)

    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 60)

    state.blipNext = blip
end

function startMarkerThread()
    CreateThread(function()
        while state.active do
            local wait = 500
            local point = getPoint(state.idx + 1)
            if point then
                wait = 0
                local pos = getCoordFromVec(point.pos)
                DrawMarker(
                    point.markerType or 1,
                    pos.x, pos.y, pos.z - (point.markerZOffset or 1.0),
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    (point.markerScale and point.markerScale.x) or 3.5,
                    (point.markerScale and point.markerScale.y) or 3.5,
                    (point.markerScale and point.markerScale.z) or 1.5,
                    255, 200, 0, 100,
                    false, true, 2, nil, nil, false
                )
            end
            Citizen.Wait(wait)
        end
    end)
end

function addError(reason)
    state.errors = state.errors + 1

    if state.errors >= ERROR_MAX then

        if not state.failed then
            state.failed = true
            ESX.ShowNotification(("~r~Trop d’erreurs (%d/%d)\nVotre permis sera refusé à l’arrivée."):format(state.errors, ERROR_MAX))
        else
            ESX.ShowNotification(("~r~Erreur (%d) — déjà recalé"):format(state.errors))
        end
    else
        ESX.ShowNotification(("~r~Erreur (%d/%d)"):format(state.errors, ERROR_MAX))
    end
end

function setFrozen(ent, toggle)
    FreezeEntityPosition(ent, toggle)
    if IsEntityAVehicle(ent) then
        SetVehicleEngineOn(ent, not toggle, true, true)
        SetVehicleUndriveable(ent, toggle)
        if toggle then
            TaskVehicleTempAction(PlayerPedId(), ent, 3, 1000)
        end
    end
end

function doFreeze(ms, message)
    if ms and ms > 0 then
        local veh = state.vehicle
        if veh and DoesEntityExist(veh) then
            ESX.ShowNotification("Marquez l'arrêt...")
            setFrozen(veh, true)
            state.freezeUntil = nowMs() + ms

            CreateThread(function()
                while state.active and nowMs() < state.freezeUntil do
                    DisableControlAction(0, 71, true)
                    DisableControlAction(0, 72, true)
                    DisableControlAction(0, 63, true)
                    DisableControlAction(0, 64, true)
                    Citizen.Wait(0)
                end
                if state.active and veh and DoesEntityExist(veh) then
                    setFrozen(veh, false)
                    ESX.ShowNotification("Vous pouvez repartir")
                end
            end)
        end
    end
end

function setSpeedLimit(kmh)
    state.limit = kmh or 0
    ESX.ShowNotification("~o~Limite de vitesse: "..state.limit)
end

function startSpeedMonitor()
    CreateThread(function()
        state.overStartMs = nil
        while state.active do
            Citizen.Wait(TICK_SPEED_MS)
            if state.vehicle and DoesEntityExist(state.vehicle) and state.limit and state.limit > 0 then
                local speed = getEntitySpeedKmh(state.vehicle)
                local over = speed - (state.limit + SPEED_TOLERANCE_KMH)
                if over > 0.0 then
                    if not state.overStartMs then
                        state.overStartMs = nowMs()
                    else
                        if nowMs() - state.overStartMs >= SPEED_GRACE_MS then
                            addError("Vitesse excessive")
                            state.overStartMs = nowMs() + 5000
                        end
                    end
                else
                    state.overStartMs = nil
                end
            end
        end
    end)
end

function PopupTime(text, time)
    time = time or 2500
	ClearPrints()
	AddTextEntry("NOTIFICATION_POPUP_TIME", text)
	AddTextComponentString("NOTIFICATION_POPUP_TIME")
	BeginTextCommandPrint("NOTIFICATION_POPUP_TIME")
	EndTextCommandPrint(time, 1)
end

function applyPointRules(point)
    if point.freeze and point.freeze > 0 then
        doFreeze(point.freeze, point.message or "Veuillez patienter...")
    end

    if point.message then
        PopupTime(point.message, 2000)
    end

    if point.maxSpeed and point.maxSpeed > 0 then
        setSpeedLimit(point.maxSpeed)
    end
end

function gotoNextPoint()
    state.idx = state.idx + 1
    local point = getPoint(state.idx)
    if not point then
        if state.failed then
            ESX.ShowNotification("~r~Examen terminé — trop d’erreurs, permis refusé.")
            dmvschool.stopDrive(false, "too_many_errors")
        else
            dmvschool.stopDrive(true, "completed")
        end
        return
    end

    applyPointRules(point)
    setNextPointBlip()
end

function startPointWatcher()
    CreateThread(function()
        while state.active do
            Citizen.Wait(100)

            local nextPoint = getPoint(state.idx + 1)
            if nextPoint then
                local target = getCoordFromVec(nextPoint.pos)
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local radius = nextPoint.radius or POINT_RADIUS

                if distance(pos, target) <= radius then
                    gotoNextPoint()
                end
            else

                local currentPoint = getPoint(state.idx)
                if not currentPoint then
                    if state.failed then
                        ESX.ShowNotification("~r~Examen terminé — trop d’erreurs, permis refusé.")
                        dmvschool.stopDrive(false, "too_many_errors")
                    else
                        dmvschool.stopDrive(true, "completed")
                    end
                    break
                end

                local target = getCoordFromVec(currentPoint.pos)
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local radius = currentPoint.radius or POINT_RADIUS

                if distance(pos, target) <= radius then
                    if state.failed then
                        ESX.ShowNotification("~r~Examen terminé — trop d’erreurs, permis refusé.")
                        dmvschool.stopDrive(false, "too_many_errors")
                    else
                        ESX.ShowNotification("~g~Examen terminé, bien joué !")
                        dmvschool.stopDrive(true, "completed")
                    end
                    break
                end
            end
        end
    end)

    CreateThread(function()
        while state.active do
            Citizen.Wait(0)
            DisableControlAction(0, 23, true)
        end
    end)
end

local INSTRUCTOR_MODEL = (cfg_dmvschool.instructor and cfg_dmvschool.instructor.model) or "s_m_m_gaffer_01"

local INSTRUCTOR_SPAWN = vector4(222.24957275391, 367.38223266602, 106.13758087158, 0.0)

function loadModel(model)
    local hash = (type(model) == "string") and GetHashKey(model) or model
    RequestModel(hash)
    local t = GetGameTimer() + 10000
    while not HasModelLoaded(hash) and GetGameTimer() < t do
        Citizen.Wait(0)
    end
    return hash
end

function safeDeletePed(ped)
    if ped and DoesEntityExist(ped) then
        ClearPedTasksImmediately(ped)
        SetEntityAsMissionEntity(ped, true, true)
        DeleteEntity(ped)
    end
end

function spawnInstructorAndSeat(veh)

    ESX.ShowNotification("~o~Veuillez patienter, le moniteur arrive et s'installe...")
    setFrozen(veh, true)

    local hash = loadModel(INSTRUCTOR_MODEL)
    local p = CreatePed(4, hash, INSTRUCTOR_SPAWN.x, INSTRUCTOR_SPAWN.y, INSTRUCTOR_SPAWN.z, INSTRUCTOR_SPAWN.w, false, false)
    if not p or not DoesEntityExist(p) then
        ESX.ShowNotification("~r~Impossible de faire venir le moniteur, réessayez")
        setFrozen(veh, false)
        return false
    end

    state.monitorPed = p
    SetEntityInvincible(p, true)
    SetBlockingOfNonTemporaryEvents(p, true)
    SetPedFleeAttributes(p, 0, false)
    SetPedCombatAttributes(p, 46, true)
    SetPedCanRagdoll(p, false)
    SetEntityAsMissionEntity(p, true, true)

    TaskGoToEntity(p, veh, -1, 6.0, 1.0, 1073741824, 0)
    local t0 = GetGameTimer()
    while DoesEntityExist(p) and (GetGameTimer() - t0) < 15000 do
        Citizen.Wait(250)
        if #(GetEntityCoords(p) - GetEntityCoords(veh)) < 7.0 then break end
    end

    TaskEnterVehicle(p, veh, 10000, 0, 1.0, 1, 0)
    local t1 = GetGameTimer()
    while DoesEntityExist(p) and (GetGameTimer() - t1) < 10000 do
        Citizen.Wait(200)
        if IsPedInVehicle(p, veh, false) then break end
    end

    if not IsPedInVehicle(p, veh, false) then
        TaskWarpPedIntoVehicle(p, veh, 0)
    end

    if IsPedInVehicle(p, veh, false) then
        ESX.ShowNotification("~g~Le moniteur est installé. Vous pouvez commencer.")
        setFrozen(veh, false)
        return true
    else
        ESX.ShowNotification("~r~Le moniteur n'a pas pu monter. Réessayez.")
        setFrozen(veh, false)
        return false
    end
end

local FAIL_TP = vector3(227.3754119873, 373.06988525391, 106.11423492432)

function startExitWatcher()
    CreateThread(function()
        local leftAt = nil
        local lastTpAt = 0

        while state.active do
            Citizen.Wait(200)

            local ped = PlayerPedId()
            local veh = state.vehicle
            if not veh or not DoesEntityExist(veh) then break end

            if not IsPedInVehicle(ped, veh, false) then

                if not leftAt then leftAt = GetGameTimer() end
                if GetGameTimer() - leftAt > 800 and (GetGameTimer() - lastTpAt) > 2500 then

                    local start = state.driveStart
                    if start then
                        ESX.ShowNotification("~o~Vous avez quitté le véhicule. Retour au point de départ.")

                        SetEntityCoords(veh, start.x, start.y, start.z, false, false, false, true)
                        SetEntityHeading(veh, start.a or GetEntityHeading(veh))
                        SetVehicleOnGroundProperly(veh)
                        SetVehicleEngineOn(veh, true, true, false)

                        SetEntityCoords(ped, start.x, start.y, start.z, false, false, false, true)
                        Citizen.Wait(100)
                        SetPedIntoVehicle(ped, veh, -1)

                        if state.monitorPed and DoesEntityExist(state.monitorPed)
                           and not IsPedInVehicle(state.monitorPed, veh, false) then
                            SetPedIntoVehicle(state.monitorPed, veh, 0)
                        end

                        lastTpAt = GetGameTimer()
                        leftAt = nil
                    else

                        ESX.ShowNotification("~r~Vous avez quitté le véhicule.\nExamen échoué.")
                        dmvschool.stopDrive(false, "left_vehicle")
                        break
                    end
                end
            else
                leftAt = nil
            end
        end
    end)
end

dmvschool.startDrive = function(catId)
    local data = cfg_dmvschool.categories[catId]
    if not data then return end
    if state.active then return end

    TriggerServerEvent("prime:dmvschool:drive:start", catId)

    Citizen.Wait(1000)

    local model = GetHashKey(data.driveVehicle)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end

    local spawn = data.driveSpawnPos

    print(('^5[NETDIAG][VEHICLE]^7 %s client.lua:671 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local veh = CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.a, true, false)
    local netId = NetworkGetNetworkIdFromEntity(veh)
    if netId and netId ~= 0 then
        SetNetworkIdCanMigrate(netId, true)
    end
    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetVehicleEngineOn(veh, true, true, false)
    SetEntityAsMissionEntity(veh, true, true)

    state.vehicle = veh
    state.active  = true
    state.errors  = 0
    state.idx     = 0
    state.limit   = 0
    state.overStartMs = nil
    state.freezeUntil = 0
    state.catId = catId
    state.failed = false

    state.driveStart = { x = spawn.x, y = spawn.y, z = spawn.z, a = spawn.a }

    CreateThread(function()
        if catId == "car" then
            local ok = spawnInstructorAndSeat(veh)
            if not ok then

                dmvschool.stopDrive(false, "instructor_failed")
                return
            end
        end

        startSpeedMonitor()
        startPointWatcher()
        startMarkerThread()
        startExitWatcher()

        setNextPointBlip()
        gotoNextPoint()
    end)
end

dmvschool.stopDrive = function(success, reason)
    if not state.active then return end
    state.active = false

    clearNextPointBlip()

    local veh = state.vehicle
    if state.monitorPed and DoesEntityExist(state.monitorPed) then
        if veh and DoesEntityExist(veh) and IsPedInVehicle(state.monitorPed, veh, false) then
            TaskLeaveVehicle(state.monitorPed, veh, 0)
            Citizen.Wait(400)
        end
        safeDeletePed(state.monitorPed)
    end

    local totalErrors = state.errors
    local cat = getActiveCategory()

    if veh and DoesEntityExist(veh) then
        SetVehicleEngineOn(veh, false, false, true)
        Citizen.Wait(250)
        TaskLeaveVehicle(PlayerPedId(), veh, 0)
        Citizen.Wait(500)
        DeleteVehicle(veh)
    end

    local ped = PlayerPedId()
    local schoolPos, schoolHeading = getSchoolPos(state.catId)
    local distFromSchool = #(GetEntityCoords(ped) - schoolPos)

    if reason == "left_vehicle" then

        SetEntityCoords(ped, FAIL_TP.x, FAIL_TP.y, FAIL_TP.z)
    elseif success and distFromSchool > MAX_RETURN_DIST then

        SetEntityCoords(ped, schoolPos.x, schoolPos.y, schoolPos.z)
        if schoolHeading then SetEntityHeading(ped, schoolHeading) end
    elseif cat and cat.returnPos then

        SetEntityCoords(ped, cat.returnPos.x, cat.returnPos.y, cat.returnPos.z)
        if cat.returnPos.a then SetEntityHeading(ped, cat.returnPos.a) end
    end

    TriggerServerEvent("prime:dmvschool:drive:reset")

    TriggerServerEvent("prime:dmvschool:drive:finish", state.catId, success, totalErrors, reason, cat and cat.nameItem)

    state.vehicle = nil
    state.limit   = 0
    state.overStartMs = nil
    state.freezeUntil = 0
    state.blipNext = nil
    state.catId = nil
    state.monitorPed = nil
    state.failed = false
    state.driveStart = nil
end

local SPAWN_DST = (cfg_dmvschool.spawnDistance or 30.0)
local INTERACT_DST = (cfg_dmvschool.dstInteract or 1.5)

local function ensurePedFor(catKey, pedCfg)
    if schoolPeds[catKey] and DoesEntityExist(schoolPeds[catKey]) then return end
    local hash = GetHashKey(pedCfg.model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local t = GetGameTimer() + 5000
        while not HasModelLoaded(hash) and GetGameTimer() < t do
            Citizen.Wait(50)
        end
        if not HasModelLoaded(hash) then return end
    end
    local ped = CreatePed(1, hash, pedCfg.pos.x, pedCfg.pos.y, pedCfg.pos.z - 1.0, pedCfg.pos.w or 0.0, false, false)
    SetEntityHeading(ped, pedCfg.pos.w or 0.0)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    Citizen.Wait(50)
    FreezeEntityPosition(ped, true)
    SetModelAsNoLongerNeeded(hash)
    schoolPeds[catKey] = ped
end

local function despawnPedFor(catKey)
    if schoolPeds[catKey] and DoesEntityExist(schoolPeds[catKey]) then
        DeleteEntity(schoolPeds[catKey])
    end
    schoolPeds[catKey] = nil
end

Citizen.CreateThread(function()
    while true do
        local interval = 1000
        local pCoords = GetEntityCoords(PlayerPedId())

        for catKey, pedCfg in pairs(cfg_dmvschool.peds) do
            local pos = pedCfg.pos
            local dst = #(vector3(pos.x, pos.y, pos.z) - pCoords)

            if dst < SPAWN_DST then
                interval = 0
                ensurePedFor(catKey, pedCfg)

                if dst < INTERACT_DST then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec " .. (pedCfg.label or "l'instructeur"), false)
                    if IsControlJustPressed(0, 38) then
                        OpenDmv(catKey)
                    end
                end
            else
                despawnPedFor(catKey)
            end
        end

        Citizen.Wait(interval)
    end
end)
