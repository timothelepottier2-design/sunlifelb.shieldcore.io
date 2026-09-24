local T = DBalloonT

local placedNetId = nil
local placedEntity = nil
local hasBalloonInHand
local cleanupBalloonObj
local playSmokeAnim
local startDrugFx
local stopDrugFx
local making = false
local balloonUses = 0
local syncedBalloons = {}
local balloonEntities = {}
local balloonModes = {}
local smoking = false
local drugFxUntil = 0
local drugFxThreadRunning = false
local instrScaleform = nil
local carryingTank = false
local carriedEntity = nil
local toggleCarryTank
local puffTimes = {}
local ragdollUntil = 0
local removeBalloonEntity
local forcePutAwayBalloon

local function Notify(msg, t)
    msg = tostring(msg or '')
    t = t or 'inform'

    if DBalloonConfig.UseOxNotify then
        return lib.notify({ title = 'Bonbonne', description = msg, type = t })
    end

    local fw = (DBalloonConfig.Framework or 'standalone'):lower()

    if fw == 'esx' then
        TriggerEvent('esx:showNotification', msg)
    elseif fw == 'qb' or fw == 'qbox' then
        local core = exports['qb-core'] and exports['qb-core']:GetCoreObject() or nil
        if core and core.Functions and core.Functions.Notify then
            local qbType = (t == 'error' and 'error') or (t == 'success' and 'success') or 'primary'
            core.Functions.Notify(msg, qbType)
        else
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(msg)
            EndTextCommandThefeedPostTicker(false, true)
        end
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

local function sfPushString(str)
    BeginTextCommandScaleformString('STRING')
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandScaleformString()
end

local function sfPushControl(control)
    sfPushString(GetControlInstructionalButton(0, control, true))
end

local function EnsureInstructional()
    if instrScaleform and HasScaleformMovieLoaded(instrScaleform) then
        return instrScaleform
    end

    instrScaleform = RequestScaleformMovie('instructional_buttons')
    local t = GetGameTimer() + 5000
    while not HasScaleformMovieLoaded(instrScaleform) do
        Wait(0)
        if GetGameTimer() > t then
            instrScaleform = nil
            return nil
        end
    end

    return instrScaleform
end

local function BuildInstructional(buttons)
    local sf = EnsureInstructional()
    if not sf then return end

    BeginScaleformMovieMethod(sf, 'CLEAR_ALL')
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(sf, 'TOGGLE_MOUSE_BUTTONS')
    ScaleformMovieMethodAddParamBool(false)
    EndScaleformMovieMethod()

    for i, b in ipairs(buttons) do
        BeginScaleformMovieMethod(sf, 'SET_DATA_SLOT')
        ScaleformMovieMethodAddParamInt(i - 1)
        sfPushControl(b.control)
        sfPushString(b.text or '')
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(sf, 'DRAW_INSTRUCTIONAL_BUTTONS')
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(sf, 'SET_BACKGROUND_COLOUR')
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()
end

local function DrawInstructional()
    if instrScaleform and HasScaleformMovieLoaded(instrScaleform) then
        DrawScaleformMovieFullscreen(instrScaleform, 255, 255, 255, 255, 0)
    end
end

local function ReleaseInstructional()
    if instrScaleform then
        SetScaleformMovieAsNoLongerNeeded(instrScaleform)
        instrScaleform = nil
    end
end

local function EnsureNetControl(ent, timeoutMs)
    if not ent or not DoesEntityExist(ent) then return false end
    if NetworkHasControlOfEntity(ent) then return true end

    timeoutMs = timeoutMs or 1500
    local deadline = GetGameTimer() + timeoutMs

    NetworkRequestControlOfEntity(ent)
    local nextReq = GetGameTimer() + 150

    while not NetworkHasControlOfEntity(ent) do
        if GetGameTimer() > deadline then return false end
        if GetGameTimer() >= nextReq then
            NetworkRequestControlOfEntity(ent)
            nextReq = GetGameTimer() + 150
        end
        Wait(25)
    end

    return true
end

local function loadModel(model)
    local hash = type(model) == 'number' and model or GetHashKey(model)

    if not IsModelInCdimage(hash) then
        print(('[DBalloon] Model not in cdimage: %s (hash=%s)'):format(tostring(model), tostring(hash)))
        return nil
    end

    RequestModel(hash)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) do
        Wait(10)
        if GetGameTimer() > timeout then
            print(('[DBalloon] Model load timeout: %s (hash=%s)'):format(tostring(model), tostring(hash)))
            return nil
        end
    end

    return hash
end

local function getGroundCoordsForModel(x, y, z, modelHash)
    local groundZ = z

    for i = 1, 20 do
        local checkZ = z + 2.0 - (i * 0.5)
        local found, gz = GetGroundZFor_3dCoord(x, y, checkZ, false)
        if found then
            groundZ = gz
            break
        end
    end

    local minDim = GetModelDimensions(modelHash)
    local offset = DBalloonConfig.PropGroundOffset or 0.0

    return vector3(x, y, groundZ - minDim.z + offset)
end

local function canUseOxTarget()
    if not DBalloonConfig.UseOxTarget then return false end
    return GetResourceState('ox_target') == 'started'
end

local function clearLocalProp()
    if placedEntity and DoesEntityExist(placedEntity) then
        SetEntityAsMissionEntity(placedEntity, true, true)
        DeleteEntity(placedEntity)
    end
    placedEntity = nil
    placedNetId = nil
end

local function registerPuffAndMaybeRagdoll()
    local now = GetGameTimer()
    local window = DBalloonConfig.RagdollWindow or (60 * 1000)
    local needed = DBalloonConfig.RagdollPuffCount or 3

    local kept = {}
    for _, t in ipairs(puffTimes) do
        if (now - t) <= window then
            kept[#kept + 1] = t
        end
    end
    kept[#kept + 1] = now
    puffTimes = kept

    if #puffTimes >= needed then
        puffTimes = {}

        local duration = DBalloonConfig.RagdollDuration or (20 * 1000)
        local ped = PlayerPedId()
        ragdollUntil = now + duration

        SetPedToRagdoll(ped, duration, duration, 0, false, false, false)

        CreateThread(function()
            while GetGameTimer() < ragdollUntil do
                Wait(250)
                local p = PlayerPedId()
                if not IsPedRagdoll(p) then
                    SetPedToRagdoll(p, 1000, 1000, 0, false, false, false)
                end
            end
        end)
    end
end

local function balloonForceStopReason()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, true) then return 'vehicle' end

    if IsPedArmed(ped, 7) then return 'weapon' end
    return nil
end

local function smokeBalloonOnce()
    if smoking then return end
    if not hasBalloonInHand() then return end

    if balloonForceStopReason() then return end

    smoking = true
    local ped = PlayerPedId()

    playSmokeAnim(ped)
    startDrugFx()
    SendNUIMessage({ action = 'dballoon:audio:play', id = 'suction', volume = 0.15 })

    local duration = DBalloonConfig.SmokeTime or 2500
    local start = GetGameTimer()

    while (GetGameTimer() - start) < duration do
        Wait(0)

        if balloonForceStopReason() then
            stopDrugFx()
            SendNUIMessage({ action = 'dballoon:audio:stop', id = 'suction' })
            ClearPedSecondaryTask(ped)
            smoking = false
            if forcePutAwayBalloon then forcePutAwayBalloon('balloon_removed') end
            return
        end

        if IsControlJustPressed(0, 73) then
            stopDrugFx()
            SendNUIMessage({ action = 'dballoon:audio:stop', id = 'suction' })
            ClearPedSecondaryTask(ped)
            smoking = false
            return
        end
    end

    ClearPedSecondaryTask(ped)

    balloonUses = balloonUses + 1
    registerPuffAndMaybeRagdoll()

    if balloonUses >= 3 then
        cleanupBalloonObj()
        balloonUses = 0
        TriggerServerEvent('DBalloon:returnEmptyBalloon')
        Notify(T('balloon_finished'), 'success')
    else
        Notify(T('puff_progress', { count = balloonUses }), 'inform')
    end

    SendNUIMessage({ action = 'dballoon:audio:stop', id = 'suction' })

    smoking = false
end

local function loadClipset(clip)
    RequestAnimSet(clip)
    local t = GetGameTimer() + 5000
    while not HasAnimSetLoaded(clip) do
        Wait(10)
        if GetGameTimer() > t then return false end
    end
    return true
end

local function applyDrugMovement(ped)
    if not DBalloonConfig.DrugDrunkWalk then return end
    local clip = 'move_m@drunk@verydrunk'
    if loadClipset(clip) then
        SetPedMovementClipset(ped, clip, 1.0)
        SetPedStrafeClipset(ped, clip)
        SetPedMaxMoveBlendRatio(ped, 1.0)
    end
end

local function clearDrugMovement(ped)
    ResetPedMovementClipset(ped, 0.0)
    ResetPedStrafeClipset(ped)
    ResetPedWeaponMovementClipset(ped)
end

local function isOurBalloonProp(ent)
    if not ent or not DoesEntityExist(ent) then return false end
    local st = Entity(ent).state
    return st and st.dballoon == true
end

local function addTargetToEntity(ent)
    if not canUseOxTarget() then return end
    if not ent or not DoesEntityExist(ent) then return end

    exports.ox_target:addLocalEntity(ent, {
        {
            name = 'dballoon_carry',
            icon = 'fa-solid fa-hand',
            label = T('action_carry'),
            distance = DBalloonConfig.InteractDistance,
            onSelect = function() TriggerEvent('DBalloon:carryTank', ent) end
        },
        {
            name = 'dballoon_make',
            icon = 'fa-solid fa-wind',
            label = T('action_make'),
            distance = DBalloonConfig.InteractDistance,
            onSelect = function() TriggerEvent('DBalloon:makeBalloon', ent) end
        },
        {
            name = 'dballoon_pickup',
            icon = 'fa-solid fa-box',
            label = T('action_pickup'),
            distance = DBalloonConfig.InteractDistance,
            onSelect = function()
                local netId = NetworkGetNetworkIdFromEntity(ent)
                clearLocalProp()
                TriggerServerEvent('DBalloon:pickupProp', netId)
            end
        }
    })
end

local function removeTargetFromEntity(ent)
    if not canUseOxTarget() then return end
    if not ent then return end
    pcall(function() exports.ox_target:removeLocalEntity(ent) end)
end

local function placeProp()

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)

    local place = vector3(
        coords.x + forward.x * DBalloonConfig.PlaceDistance,
        coords.y + forward.y * DBalloonConfig.PlaceDistance,
        coords.z
    )

    local modelHash = loadModel(DBalloonConfig.PropModel)
    if not modelHash then
        Notify(T('invalid_model', { model = tostring(DBalloonConfig.PropModel) }), "error")
        return false
    end

    local heading = GetEntityHeading(ped)
    local groundPlace = getGroundCoordsForModel(place.x, place.y, place.z, modelHash)

    print(('^2[NETDIAG][OBJET]^7 %s cl_main.lua:422 CreateObject NETWORKED dballoon model=%s'):format(GetCurrentResourceName(), tostring(modelHash)))
    local obj = CreateObject(modelHash, groundPlace.x, groundPlace.y, groundPlace.z, true, true, false)
    if not obj or obj == 0 then
        Notify(T('cant_create_prop'), "error")
        return false
    end

    SetEntityAsMissionEntity(obj, true, true)
    SetEntityCoordsNoOffset(obj, groundPlace.x, groundPlace.y, groundPlace.z, false, false, false)

    if DBalloonConfig.PlaceHeadingFromPlayer then
        SetEntityHeading(obj, heading)
    end

    if DBalloonConfig.FreezeProp then
        FreezeEntityPosition(obj, true)
    end

    -- print(('^3[NETDIAG][STATEBAG]^7 %s cl_main.lua:443 Entity(%s).state:set dballoon (NON-replicated)'):format(GetCurrentResourceName(), tostring(obj)))
    Entity(obj).state:set('dballoon', true, false)

    SetModelAsNoLongerNeeded(modelHash)

    placedEntity = obj
    placedNetId = NetworkGetNetworkIdFromEntity(obj)

    addTargetToEntity(obj)

    Notify(T('tank_placed'), 'success')
    return true
end

local function playUseTankAnim(ped)
    local dict = 'mp_car_bomb'
    local anim = 'car_bomb_mechanic'

    RequestAnimDict(dict)
    local t = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        if GetGameTimer() > t then return false end
    end

    ClearPedSecondaryTask(ped)
    FreezeEntityPosition(ped, true)
    SetEntityVelocity(ped, 0.0, 0.0, 0.0)

    local duration = 1200
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, 0, 0.0, false, false, false)

    Wait(duration)

    FreezeEntityPosition(ped, false)
    RemoveAnimDict(dict)

    return true
end

RegisterNetEvent('DBalloon:clientPlaceProp', function(uses)
    local ped = PlayerPedId()

    playUseTankAnim(ped)
    local ok = placeProp()

    local u = tonumber(uses) or DBalloonConfig.TankMaxUses
    if ok and placedEntity and DoesEntityExist(placedEntity) and placedNetId then

        TriggerServerEvent('DBalloon:registerTank', placedNetId, u)
        Notify(T('tank_status', { uses = u, max = DBalloonConfig.TankMaxUses }), 'inform')
    else

        TriggerServerEvent('DBalloon:placeFailed')
    end
end)

local clearingBalloonProp = false

cleanupBalloonObj = function()

    local cur = LocalPlayer.state.dballoon_prop
    if not clearingBalloonProp and cur ~= nil and cur ~= false then
        clearingBalloonProp = true
        TriggerServerEvent('DBalloon:setPropMode', false)
    end

    if removeBalloonEntity then
        removeBalloonEntity(GetPlayerServerId(PlayerId()))
    end
end

forcePutAwayBalloon = function(notifyKey)
    if not hasBalloonInHand() then return end

    local ped = PlayerPedId()

    smoking = false
    ClearPedSecondaryTask(ped)
    StopAnimTask(ped, 'mp_player_int_uppersmoke', 'mp_player_int_smoke_enter', 2.0)
    SendNUIMessage({ action = 'dballoon:audio:stop', id = 'suction' })

    cleanupBalloonObj()
    balloonUses = 0

    if notifyKey then Notify(T(notifyKey), 'inform') end
end

hasBalloonInHand = function()
    local info = LocalPlayer.state.dballoon_prop
    return type(info) == 'table' and info.mode == 'hand'
end

startDrugFx = function()
    local dur = DBalloonConfig.DrugEffectDuration or (60 * 1000)
    drugFxUntil = GetGameTimer() + dur

    if drugFxThreadRunning then return end
    drugFxThreadRunning = true

    StartScreenEffect('DrugsMichaelAliensFightIn', 0, true)
    ShakeGameplayCam('DRUNK_SHAKE', 0.35)
    SetTimecycleModifier('spectator5')
    SetTimecycleModifierStrength(0.6)

    applyDrugMovement(PlayerPedId())

    CreateThread(function()
        while true do
            Wait(200)

            if GetGameTimer() >= (drugFxUntil or 0) then
                break
            end

            if DBalloonConfig.DrugDrivingEnabled then
                local pedNow = PlayerPedId()
                if IsPedInAnyVehicle(pedNow, false) then
                    local veh = GetVehiclePedIsIn(pedNow, false)
                    if GetPedInVehicleSeat(veh, -1) == pedNow then
                        SetDriveTaskDrivingStyle(pedNow, DBalloonConfig.DrugDrivingStyle or 786603)
                        ShakeGameplayCam('DRUNK_SHAKE', DBalloonConfig.DrugDriveShake or 0.35)

                        local jitter = DBalloonConfig.DrugSteerJitter or 0.0
                        if jitter > 0.0 then
                            SetVehicleSteeringScale(veh, 1.0 - (jitter * 2.0))
                            TaskVehicleTempAction(pedNow, veh, 11, 1)
                        end
                    end
                end
            end
        end

        local pedEnd = PlayerPedId()

        StopScreenEffect('DrugsMichaelAliensFightIn')
        ShakeGameplayCam('DRUNK_SHAKE', 0.0)
        ClearTimecycleModifier()
        clearDrugMovement(pedEnd)

        drugFxThreadRunning = false
        drugFxUntil = 0
    end)
end

stopDrugFx = function()
    drugFxUntil = 0

    StopScreenEffect('DrugsMichaelAliensFightIn')
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    ClearTimecycleModifier()
    clearDrugMovement(PlayerPedId())

    drugFxThreadRunning = false
end

playSmokeAnim = function(ped)
    local dict = 'mp_player_int_uppersmoke'
    local anim = 'mp_player_int_smoke_enter'

    RequestAnimDict(dict)
    local t = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        if GetGameTimer() > t then return false end
    end

    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, 1600, 48, 0.0, false, false, false)
    RemoveAnimDict(dict)

    return true
end

local function requestAnimDict(dict)
    RequestAnimDict(dict)
    local t = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        if GetGameTimer() > t then return false end
    end
    return true
end

local function attachTankToArm(tank, ped)
    if not tank or not DoesEntityExist(tank) then return end

    if not EnsureNetControl(tank, 2000) then
        Notify(T('no_net_control'), "error")
        return
    end

    local bone = GetPedBoneIndex(ped, 28422)

    SetEntityAsMissionEntity(tank, true, true)
    SetEntityCollision(tank, false, false)
    FreezeEntityPosition(tank, false)

    AttachEntityToEntity(tank, ped, bone, 0.03, -0.30, -0.06, -90.0, 0.0, 0.0, false, true, false, false, 2, true)
end

local function detachTankToGround(tank, ped)
    if not tank or not DoesEntityExist(tank) then return end

    StopAnimTask(ped, 'move_weapon@jerrycan@generic', 'idle', 8.0)
    ClearPedSecondaryTask(ped)
    ClearPedTasks(ped)
    ClearPedTasksImmediately(ped)

    if not EnsureNetControl(tank, 2000) then
        Notify(T('no_net_control_retry'), "error")
        return
    end

    DetachEntity(tank, true, true)
    Wait(0)

    SetEntityAsMissionEntity(tank, true, true)
    SetEntityCollision(tank, true, true)
    SetEntityInvincible(tank, false)
    FreezeEntityPosition(tank, false)
    ActivatePhysics(tank)
    SetEntityDynamic(tank, true)

    local p = GetEntityCoords(ped)
    local f = GetEntityForwardVector(ped)
    local modelHash = GetEntityModel(tank)
    local gx = p.x + f.x * 0.7
    local gy = p.y + f.y * 0.7
    local groundPlace = getGroundCoordsForModel(gx, gy, p.z, modelHash)

    SetEntityCoordsNoOffset(tank, groundPlace.x, groundPlace.y, groundPlace.z, false, false, false)
    SetEntityHeading(tank, GetEntityHeading(ped))
    Wait(0)

    if DBalloonConfig.FreezeProp then
        FreezeEntityPosition(tank, true)
    end
end

local function playCarryAnim(ped, enable)
    local dict = 'move_weapon@jerrycan@generic'
    local anim = 'idle'

    if not enable then
        StopAnimTask(ped, dict, anim, 1.0)
        ClearPedSecondaryTask(ped)
        return
    end

    if not requestAnimDict(dict) then return false end

    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, -1, 51, 0.0, false, false, false)
    return true
end

toggleCarryTank = function(tank)
    if not tank or not DoesEntityExist(tank) then
        Notify(T('tank_not_found'), "error")
        return
    end

    local ped = PlayerPedId()

    if making or smoking then return end

    if carryingTank and carriedEntity == tank then
        detachTankToGround(tank, PlayerPedId())
        carryingTank = false
        carriedEntity = nil
        Notify(T('carry_stop'), "inform")
        return
    end

    if carryingTank and carriedEntity and DoesEntityExist(carriedEntity) then
        playCarryAnim(ped, false)
        detachTankToGround(carriedEntity, ped)
        carryingTank = false
        carriedEntity = nil
    end

    TaskTurnPedToFaceEntity(ped, tank, 600)
    Wait(250)

    playCarryAnim(ped, true)
    attachTankToArm(tank, ped)

    carryingTank = true
    carriedEntity = tank

    Notify(T('carry_start'), "success")
end

local function attachBalloonToTank(balloon, tank)
    FreezeEntityPosition(balloon, false)
    SetEntityCollision(balloon, false, false)
    SetEntityInvincible(balloon, true)

    AttachEntityToEntity(balloon, tank, 0, 0.0, 0.0, 0.64, 0.0, 0.0, 0.0, false, true, false, false, 2, true)
end

local function attachBalloonToLeftHand(balloon, ped)
    FreezeEntityPosition(balloon, false)
    SetEntityCollision(balloon, false, false)
    SetEntityInvincible(balloon, true)

    AttachEntityToEntity(balloon, ped, GetPedBoneIndex(ped, 18905), 0.14, 0.02, 0.00, 0.0, -90.0, 75.0, false, true, false, false, 2, true)
end

local SYNC_RENDER_DIST = 60.0

local function sanitizeBalloonInfo(value)
    if type(value) ~= 'table' then return nil end

    local allowedModel = DBalloonConfig.BalloonPropModel or 'ballonblue'
    if value.model ~= allowedModel then return nil end

    if value.mode == 'hand' then
        return { model = allowedModel, mode = 'hand' }
    end

    if value.mode == 'tank' then
        local tankNetId = tonumber(value.tank)
        if not tankNetId then return nil end
        return { model = allowedModel, mode = 'tank', tank = tankNetId }
    end

    return nil
end

removeBalloonEntity = function(serverId)
    local ent = balloonEntities[serverId]
    if ent and DoesEntityExist(ent) then

        DetachEntity(ent, true, true)
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
        if DoesEntityExist(ent) then DeleteObject(ent) end
    end
    balloonEntities[serverId] = nil
    balloonModes[serverId] = nil
end

local function ensureBalloonEntity(serverId, ped, info)
    local ent = balloonEntities[serverId]

    if ent and DoesEntityExist(ent) and balloonModes[serverId] ~= info.mode then
        removeBalloonEntity(serverId)
        ent = nil
    end

    if ent and DoesEntityExist(ent) then return end

    local hash = loadModel(info.model)
    if not hash then return end

    local coords = GetEntityCoords(ped)
    local obj = CreateObject(hash, coords.x, coords.y, coords.z + 1.0, false, false, false)
    SetModelAsNoLongerNeeded(hash)

    if not obj or obj == 0 then return end

    SetEntityCollision(obj, false, false)
    SetEntityCompletelyDisableCollision(obj, false, false)

    if info.mode == 'tank' then
        local tank = info.tank and NetworkGetEntityFromNetworkId(info.tank) or 0
        if not tank or tank == 0 or not DoesEntityExist(tank) then

            DeleteEntity(obj)
            return
        end

        local tankModel = DBalloonConfig.PropModel
        local tankHash = type(tankModel) == 'number' and tankModel or GetHashKey(tankModel)
        if GetEntityModel(tank) ~= tankHash then
            DeleteEntity(obj)
            return
        end
        attachBalloonToTank(obj, tank)
    else
        attachBalloonToLeftHand(obj, ped)
    end

    balloonEntities[serverId] = obj
    balloonModes[serverId] = info.mode
end

local function pedForServerId(serverId)
    local ply = GetPlayerFromServerId(serverId)
    if ply == -1 then return 0 end
    return GetPlayerPed(ply)
end

AddStateBagChangeHandler('dballoon_prop', nil, function(bagName, _, value)
    local serverId = tonumber((bagName:gsub('player:', '')), 10)
    if not serverId then return end

    if serverId == GetPlayerServerId(PlayerId()) and (value == nil or value == false) then
        clearingBalloonProp = false
    end

    local info = sanitizeBalloonInfo(value)
    if not info then
        syncedBalloons[serverId] = nil
        removeBalloonEntity(serverId)
        return
    end

    if serverId == GetPlayerServerId(PlayerId()) then
        clearingBalloonProp = false
    end

    syncedBalloons[serverId] = info

    local ped = pedForServerId(serverId)
    if ped ~= 0 and DoesEntityExist(ped) then
        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(ped)) <= SYNC_RENDER_DIST then
            ensureBalloonEntity(serverId, ped, info)
        end
    end
end)

CreateThread(function()
    while true do
        local hasAny = false
        local myCoords = GetEntityCoords(PlayerPedId())

        for serverId, info in pairs(syncedBalloons) do
            hasAny = true
            local ped = pedForServerId(serverId)

            if ped ~= 0 and DoesEntityExist(ped)
                and #(myCoords - GetEntityCoords(ped)) <= SYNC_RENDER_DIST then
                ensureBalloonEntity(serverId, ped, info)
            else
                removeBalloonEntity(serverId)
            end
        end

        for serverId in pairs(balloonEntities) do
            if not syncedBalloons[serverId] then
                removeBalloonEntity(serverId)
            end
        end

        Wait(hasAny and 750 or 1500)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if hasBalloonInHand() then
            sleep = 250
            if balloonForceStopReason() then
                forcePutAwayBalloon('balloon_removed')
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('DBalloon:makeBalloon', function(entity)
    if making then return end
    if not entity or not DoesEntityExist(entity) then return end

    local st = Entity(entity).state
    if not st or st.dballoon ~= true then
        Notify(T('not_our_tank'), "error")
        return
    end

    local ped = PlayerPedId()
    if #(GetEntityCoords(ped) - GetEntityCoords(entity)) > (DBalloonConfig.InteractDistance or 2.0) then
        Notify(T('too_far'), "error")
        return
    end

    TriggerServerEvent('DBalloon:requestMakeBalloon', NetworkGetNetworkIdFromEntity(entity))
end)

RegisterNetEvent('DBalloon:startMakeBalloon', function(tankNetId)
    if making then return end
    making = true

    local ped = PlayerPedId()
    local tank = NetworkGetEntityFromNetworkId(tankNetId)

    if not tank or not DoesEntityExist(tank) then
        making = false
        Notify(T('tank_not_found'), "error")
        return
    end

    if #(GetEntityCoords(ped) - GetEntityCoords(tank)) > (DBalloonConfig.InteractDistance or 2.0) then
        making = false
        Notify(T('too_far'), "error")
        return
    end

    local balloonModel = DBalloonConfig.BalloonPropModel or 'ballonblue'
    local balloonHash = loadModel(balloonModel)
    if not balloonHash then
        making = false
        Notify(T('invalid_model', { model = tostring(balloonModel) }), "error")
        return
    end

    SetModelAsNoLongerNeeded(balloonHash)

    local duration = DBalloonConfig.FillTime or 5000

    local dict, anim = 'mp_car_bomb', 'car_bomb_mechanic'
    if requestAnimDict(dict) then
        FreezeEntityPosition(ped, true)
        SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, 0, 0.0, false, false, false)
    end

    local start = GetGameTimer()

    SendNUIMessage({ action = 'dballoon:audio:play', id = 'inflate', volume = 0.1 })

    while (GetGameTimer() - start) < duration do
        Wait(0)

        if IsControlJustPressed(0, 73) then
            SendNUIMessage({ action = 'dballoon:audio:stop', id = 'inflate' })
            StopAnimTask(ped, dict, anim, 2.0)
            FreezeEntityPosition(ped, false)
            making = false
            cleanupBalloonObj()
            Notify(T('fill_cancel'), "error")
            return
        end
    end

    SendNUIMessage({ action = 'dballoon:audio:stop', id = 'inflate' })

    StopAnimTask(ped, dict, anim, 2.0)
    FreezeEntityPosition(ped, false)

    TriggerServerEvent('DBalloon:setPropMode', 'hand')
    balloonUses = 0

    making = false
end)

RegisterNetEvent('DBalloon:carryTank', function(entity)
    if not entity or not DoesEntityExist(entity) then return end
    if not isOurBalloonProp(entity) then
        Notify(T('not_our_tank'), "error")
        return
    end

    local ped = PlayerPedId()
    if #(GetEntityCoords(ped) - GetEntityCoords(entity)) > (DBalloonConfig.InteractDistance or 2.0) then
        Notify(T('too_far'), "error")
        return
    end

    toggleCarryTank(entity)
end)

RegisterNetEvent('DBalloon:updateTankUses', function(netId, uses)

    Notify(T('tank_status', { uses = uses, max = DBalloonConfig.TankMaxUses }), "inform")
end)

RegisterNetEvent('DBalloon:breakTank', function(netId)
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end

    if carriedEntity and DoesEntityExist(carriedEntity) and NetworkGetNetworkIdFromEntity(carriedEntity) == netId then
        carryingTank = false
        carriedEntity = nil
        ClearPedTasks(PlayerPedId())
    end

    if placedEntity and DoesEntityExist(placedEntity) and NetworkGetNetworkIdFromEntity(placedEntity) == netId then
        placedEntity = nil
        placedNetId = nil
    end
end)

CreateThread(function()
    local key = 38
    local removeKey = 47
    local showing = false
    local lastMode = nil

    while true do
        local sleep = 500
        local mode = nil

        if not smoking and not making then
            if carryingTank and carriedEntity and DoesEntityExist(carriedEntity) then
                mode = 'poser'
            elseif hasBalloonInHand() then
                mode = 'taffer'
            elseif (not canUseOxTarget()) and placedEntity and DoesEntityExist(placedEntity) then
                local pc = GetEntityCoords(PlayerPedId())
                if #(pc - GetEntityCoords(placedEntity)) <= (DBalloonConfig.InteractDistance or 2.0) then
                    mode = 'prendre'
                end
            end
        end

        if mode then
            sleep = 0

            if (not showing) or (lastMode ~= mode) then
                if mode == 'poser' then
                    BuildInstructional({ { control = key, text = T('instr_place') } })
                elseif mode == 'taffer' then
                    BuildInstructional({
                        { control = key, text = T('instr_smoke') },
                        { control = removeKey, text = T('instr_remove') },
                    })
                else
                    BuildInstructional({ { control = key, text = T('action_carry') } })
                end
                showing = true
                lastMode = mode
            end

            DrawInstructional()

            if IsControlJustPressed(0, key) then
                if mode == 'poser' then
                    if carriedEntity and DoesEntityExist(carriedEntity) and toggleCarryTank then
                        toggleCarryTank(carriedEntity)
                    end
                elseif mode == 'taffer' then
                    smokeBalloonOnce()
                else
                    TriggerEvent('DBalloon:carryTank', placedEntity)
                end
            end

            if mode == 'taffer' and IsControlJustPressed(0, removeKey) then
                cleanupBalloonObj()
                balloonUses = 0
                Notify(T('balloon_removed'), 'inform')
            end
        elseif showing then
            ReleaseInstructional()
            showing = false
            lastMode = nil
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end

    SendNUIMessage({ action = 'dballoon:audio:stop', id = 'inflate' })
    SendNUIMessage({ action = 'dballoon:audio:stop', id = 'suction' })
    ReleaseInstructional()
    stopDrugFx()
    cleanupBalloonObj()
    balloonUses = 0
    smoking = false
    making = false
    puffTimes = {}
    ragdollUntil = 0

    for serverId in pairs(balloonEntities) do
        local ent = balloonEntities[serverId]
        if ent and DoesEntityExist(ent) then
            DetachEntity(ent, true, true)
            DeleteEntity(ent)
            if DoesEntityExist(ent) then DeleteObject(ent) end
        end
    end
    balloonEntities = {}
    balloonModes = {}
    syncedBalloons = {}

    if placedEntity and DoesEntityExist(placedEntity) then
        removeTargetFromEntity(placedEntity)
        clearLocalProp()
    end
end)

RegisterNetEvent('DBalloon:useFromFramework', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        Notify(T('cant_use_in_vehicle'), 'error')
        return
    end

    TriggerServerEvent('DBalloon:useItem')
end)

RegisterNetEvent('DBalloon:frameworkNotify', function(msg, t)
    Notify(msg, t)
end)

exports('UsePropaneBalloon', function(data, slot)
    TriggerServerEvent('DBalloon:useItem', slot)
end)
