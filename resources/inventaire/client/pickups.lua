local manualEnabled = false
local autoToggle = true
local shown = false

local drops = {}
local spawned = {}
local occlusion = {}
local maxDist = 50.0            -- portée LOD / props
local interactDist = 2.0        -- portée pour ramasser (touche E)
local showDist = 4.5            -- portée d’affichage de l’interface
local maxTags = 20
local nearestId = nil

-- ANIM config
local pickupAnimDict      = "pickup_object"
local pickupAnimName      = "pickup_low"
local pickupAnimDuration  = 900           -- ms
local isPicking           = false

local Models = {
    default = "prop_cs_cardbox_01",
    money = "prop_money_bag_01",
    dirtymoney = "prop_money_bag_01",
    WEAPON_PETROLCAN = "prop_ld_jerrycan_01"
}

local Icons = {
    default = "box",
    money = "money",
    dirtymoney = "money",
    WEAPON_PETROLCAN = "fuel"
}

local nextSpawnAt, nextUiAt, nextInputAt = 0, 0, 0
local lastNearAny = false

local function setShown(v)
    if shown == v then return end
    shown = v
    SetNuiFocus(false, false)
    SendNUIMessage({action = v and "pickup:show" or "pickup:hide"})
    if v then nextUiAt = 0 end -- force premier draw
end

local function iconFor(item)  return Icons[item] or Icons.default end
local function modelFor(item) return Models[item] or Models.default end

local function loadModel(name)
    local hash = GetHashKey(name)
    if not IsModelValid(hash) then return nil end
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local t = GetGameTimer()
        while not HasModelLoaded(hash) and GetGameTimer() - t < 5000 do
            Wait(0)
        end
    end
    if not HasModelLoaded(hash) then return nil end
    return hash
end

local function spawnObj(d)
    if spawned[d.id] then return end
    local hash = loadModel(modelFor(d.name))
    if not hash then return end
    local obj = CreateObjectNoOffset(hash, d.coords.x, d.coords.y, d.coords.z, false, false, false)
    if obj and obj ~= 0 then
        SetEntityCollision(obj, false, true)
        SetEntityAsMissionEntity(obj, true, false)
        FreezeEntityPosition(obj, true)
        PlaceObjectOnGroundProperly(obj)
        spawned[d.id] = obj
    end
end

local function removeObj(id)
    local obj = spawned[id]
    if obj and DoesEntityExist(obj) then DeleteObject(obj) end
    spawned[id] = nil
end

local function hasLOS(from, to)
    local key = to.x .. ":" .. to.y .. ":" .. to.z
    local t = GetGameTimer()
    local c = occlusion[key]
    if c and t - c.t < 300 then return c.ok end
    local handle = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, 1|16|256|4, PlayerPedId(), 7)
    local _, hit = GetShapeTestResult(handle)
    local ok = hit == 0
    occlusion[key] = {ok=ok, t=t}
    return ok
end

local function clamp01(x) if x < 0 then return 0 end if x > 1 then return 1 end return x end
local function scaleFromDist(d)
    local s = 1.0 - clamp01((d - 5.0) / (maxDist - 5.0))
    if s < 0.6 then s = 0.6 end
    if s > 1.0 then s = 1.0 end
    return s
end

-- ============ ANIM helpers ============
local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local t0 = GetGameTimer()
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() - t0 > 3000 then return false end
        Wait(0)
    end
    return true
end

local function disableControlsTick()
    -- désactive déplacement/attaque/saut pendant l’anim
    DisableControlAction(0, 21, true)   -- sprint
    DisableControlAction(0, 22, true)   -- jump
    DisableControlAction(0, 24, true)   -- attack
    DisableControlAction(0, 25, true)   -- aim
    DisableControlAction(0, 140, true)  -- melee
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 30, true)   -- move L/R
    DisableControlAction(0, 31, true)   -- move F/B
    DisableControlAction(0, 44, true)   -- cover
    DisableControlAction(0, 23, true)   -- enter vehicle
    DisableControlAction(0, 75, true)   -- exit vehicle
end

local function playPickupAnimation(targetCoords, ms)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then return end

    -- tourner vers l’objet
    if targetCoords then
        TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 300)
        Wait(150)
    end

    if not loadAnimDict(pickupAnimDict) then return end

    TaskPlayAnim(ped, pickupAnimDict, pickupAnimName, 4.0, -4.0, ms or pickupAnimDuration, 49, 0.0, false, false, false)

    local tEnd = GetGameTimer() + (ms or pickupAnimDuration)
    while GetGameTimer() < tEnd do
        disableControlsTick()
        if IsPedRagdoll(ped) or IsPedInParachuteFreeFall(ped) then break end
        Wait(0)
    end

    ClearPedTasks(ped)
end
-- =====================================

-- sync réseau
RegisterNetEvent("drop:syncAll", function(list)
    drops = {}
    for _, d in ipairs(list or {}) do
        local id = tostring(d.random)
        drops[id] = {id=id, name=d.name, label=d.label or d.name, count=d.count or 1, coords=vector3(d.coords.x, d.coords.y, d.coords.z)}
    end
    local now = GetGameTimer()
    nextSpawnAt, nextUiAt = now, now
end)

RegisterNetEvent("drop:add", function(d)
    local id = tostring(d.random)
    drops[id] = {id=id, name=d.name, label=d.label or d.name, count=d.count or 1, coords=vector3(d.coords.x, d.coords.y, d.coords.z)}
    local now = GetGameTimer()
    nextSpawnAt, nextUiAt = now, now
end)

RegisterNetEvent("drop:update", function(d)
    local id = tostring(d.random)
    if drops[id] then
        drops[id].count = d.count or drops[id].count
        nextUiAt = GetGameTimer()
    end
end)

RegisterNetEvent("drop:remove", function(random)
    local id = tostring(random)
    drops[id] = nil
    removeObj(id)
    SendNUIMessage({action="pickup:remove", id=id})
    if nearestId == id then nearestId = nil end
    nextUiAt = GetGameTimer()
end)

CreateThread(function()
    TriggerServerEvent("drop:requestAll")
end)

-- pass props
local function runSpawnPass()
    local ped = PlayerPedId()
    local p = GetEntityCoords(ped)
    local md = maxDist * maxDist
    for id, d in pairs(drops) do
        local c = d.coords
        local dx, dy, dz = p.x - c.x, p.y - c.y, p.z - c.z
        local dd2 = dx*dx + dy*dy + dz*dz
        if dd2 <= md then
            if not spawned[id] then spawnObj(d) end
        else
            if spawned[id] then removeObj(id) end
        end
    end
end

-- pass UI
local function runUiPass()
    local ped = PlayerPedId()
    local cam = GetGameplayCamCoord()
    local p = GetEntityCoords(ped)
    local md = maxDist * maxDist
    local list = {}
    local bestId, bestDist = nil, 1e9

    for _, d in pairs(drops) do
        local c = d.coords
        local dx, dy, dz = p.x - c.x, p.y - c.y, p.z - c.z
        local dd2 = dx*dx + dy*dy + dz*dz
        if dd2 <= md then
            local dd = math.sqrt(dd2)
            if dd < bestDist then bestDist, bestId = dd, d.id end
            local on, sx, sy = GetScreenCoordFromWorldCoord(c.x, c.y, c.z + 0.1)
            if on and hasLOS(cam, c + vector3(0.0,0.0,0.2)) then
                list[#list+1] = {
                    id = d.id, x = sx, y = sy, label = d.label, count = d.count,
                    icon = iconFor(d.name), scale = scaleFromDist(dd), dist = dd
                }
            end
        end
    end

    local nearAny = (bestId ~= nil and bestDist <= showDist)
    nearestId = (bestId and bestDist <= interactDist) and bestId or nil

    table.sort(list, function(a,b) return a.dist < b.dist end)
    if #list > maxTags then
        local t = {}
        for i=1,maxTags do t[i]=list[i] end
        list = t
    end
    for i=1,#list do list[i].near = (list[i].id == nearestId) end

    if autoToggle then setShown(nearAny) else setShown(manualEnabled) end
    if shown then SendNUIMessage({action="pickup:batch", items=list}) end
    lastNearAny = nearAny
end

-- pass input (✅ anim incluse)
local function runInputPass()
    if isPicking then return end
    if nearestId and IsControlJustPressed(0, 38) then
        local id = nearestId
        local d  = drops[id]
        if not d then return end
        isPicking = true
        CreateThread(function()
            -- double-check distance avant et pendant
            local ped = PlayerPedId()
            local p = GetEntityCoords(ped)
            if #(p - d.coords) > interactDist + 0.5 then isPicking=false return end

            playPickupAnimation(d.coords, pickupAnimDuration)

            -- si l’objet existe encore, on demande le pickup serveur
            if drops[id] then
                local take = tonumber(d.count) or 1
                TriggerServerEvent("inventory:server:takeDrop", 0, take, id)
            end

            isPicking = false
        end)
    end
end

-- scheduler
CreateThread(function()
    while true do
        local now = GetGameTimer()

        if now >= nextSpawnAt then
            runSpawnPass()
            nextSpawnAt = now + (lastNearAny and 350 or 1200)
        end

        if shown then
            runUiPass()
        elseif now >= nextUiAt then
            runUiPass()
            nextUiAt = now + 250
        end

        if shown and nearestId then
            runInputPass()
        elseif now >= nextInputAt then
            runInputPass()
            nextInputAt = now + (nearestId and 25 or 150)
        end

        if shown then
            Wait(0)
        else
            local nextTick = math.min(nextSpawnAt - now, nextUiAt - now, nextInputAt - now)
            if nextTick < 5 then nextTick = 5 end
            if nextTick > 250 then nextTick = 250 end
            Wait(nextTick)
        end
    end
end)

RegisterNetEvent("pickup_ui:enable", function(state)
    manualEnabled = state and true or false
    if not autoToggle then setShown(manualEnabled) end
    nextUiAt = GetGameTimer()
end)