local Config = WeedConfig

local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'weedpots', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'weedpots', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('weedpots/' .. name, cb)
end

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect", function(obj)
            ESX = obj
        end)
        Wait(0)
    end
end)

local PlacementBlacklist = {
    { coords = vector3(440.20, -981.20, 30.69), radius = 30.0 },
    { coords = vector3(1853.20, 3688.60, 34.26), radius = 40.0 },
}

local function isPlacementBlacklisted(coords)
    for i = 1, #PlacementBlacklist do
        local z = PlacementBlacklist[i]
        if #(coords - z.coords) <= (z.radius or 0.0) then
            return true, i
        end
    end
    return false, nil
end

print(IsModelInCdimage(joaat("bam_prop_weed_green_01_a")))
print(IsModelValid(joaat("bam_prop_weed_green_01_a")))

local Plants = {}
local Spawned = {}
local PlayerLoaded = false

local placing = false
local lastGroundZ = nil
local smoothZ = nil
local placeDistance = 1.6

local function loadAnim(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function rotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function placementPoint()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)

    local x = pcoords.x + forward.x * placeDistance
    local y = pcoords.y + forward.y * placeDistance
    local z = pcoords.z + 1.0

    local found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
    if found then
        return vector3(x, y, groundZ)
    end

    return vector3(x, y, pcoords.z)
end

local function startPlacement(variant, item)
    if placing then
        return
    end
    placing = true

    local model = Config.Variants[variant] and Config.Variants[variant][1] or Config.Variants[Config.DefaultVariant][1]
    local hash = ensureModel(model)

    local ghost = CreateObjectNoOffset(hash, 0.0, 0.0, 0.0, false, false, false)
    SetEntityVisible(ghost, true, false)
    ResetEntityAlpha(ghost)
    SetEntityAlpha(ghost, 180, false)
    SetEntityLodDist(ghost, 250)

    lib.showTextUI("[E] Placer | [BACKSPACE] Annuler | Molette: distance")

    while placing do
        Wait(0)

        local hitCoords = placementPoint()

        local blocked = false
        local isBlocked = isPlacementBlacklisted(hitCoords)
        if isBlocked then
            blocked = true
        end

        DrawMarker(
            2,
            hitCoords.x, hitCoords.y, hitCoords.z + 0.2,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            0.25, 0.25, 0.25,
            255, 255, 255, 200,
            false, false, 2, nil, nil, false
        )

        local targetZ = hitCoords.z

        SetEntityCoordsNoOffset(ghost, hitCoords.x, hitCoords.y, hitCoords.z, false, false, false)
        PlaceObjectOnGroundProperly(ghost)
        SetEntityHeading(ghost, GetEntityHeading(ped))

        if IsControlJustPressed(0, 241) then
            placeDistance = math.min(3.0, placeDistance + 0.15)
        end

        if IsControlJustPressed(0, 242) then
            placeDistance = math.max(0.8, placeDistance - 0.15)
        end

        if IsControlJustPressed(0, 177) then
            placing = false
            smoothZ = nil
            break
        end

        if IsControlJustPressed(0, 38) and hitCoords then
            if blocked then
                lib.notify({ type = "error", description = "Impossible de poser ici." })
            else
                local ped = PlayerPedId()

                lib.hideTextUI()

                loadAnim("amb@world_human_gardener_plant@male@base")
                TaskPlayAnim(ped, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)

                local ok = lib.progressBar({
                    duration = 3500,
                    label = "Placement du pot...",
                    useWhileDead = false,
                    canCancel = true,
                    disable = { move = true, car = true, combat = true }
                })

                ClearPedTasks(ped)

                if ok then
                    local coords = GetEntityCoords(ghost)
                    local heading = GetEntityHeading(ped)
                    TriggerServerEvent("bam_weedpots:server:placePlant", {
                        coords = { x = coords.x, y = coords.y, z = coords.z },
                        heading = heading,
                        variant = variant,
                        item = item
                    })
                else
                    lib.notify({ type = "error", description = "Annulé." })
                end

                placing = false
                break
            end
        end
    end

    lib.hideTextUI()
    deleteEntitySafe(ghost)
end

RegisterNetEvent("bam_weedpots:client:startPlacement", function(payload)
    if type(payload) ~= "table" then
        startPlacement(Config.DefaultVariant, nil)
        return
    end
    startPlacement(payload.variant or Config.DefaultVariant, payload.item)
end)

local function modelFor(variant, stage)
    local v = Config.Variants[variant]
    if not v then
        v = Config.Variants[Config.DefaultVariant]
    end
    return v[stage]
end

local function dist(a, b)
    return #(a - b)
end

function ensureModel(model)
    local hash = joaat(model)

    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        print(("^1[WeedPots]^7 Model invalid: %s (%s)"):format(model, hash))
        return nil
    end

    RequestModel(hash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() > timeout then
            print(("^1[WeedPots]^7 Model load timeout: %s (%s)"):format(model, hash))
            return nil
        end
    end

    return hash
end

function deleteEntitySafe(ent)
    if ent and DoesEntityExist(ent) then
        DeleteEntity(ent)
    end
end

local function spawnPlant(id, p)
    if Spawned[id] then
        return
    end

    local model = modelFor(p.variant, p.stage)
    local hash = ensureModel(model)
    if not hash then
        return
    end

    local obj = CreateObject(hash, p.coords.x, p.coords.y, p.coords.z, false, false, false)
    if not obj or obj == 0 then
        print("^1[WeedPots]^7 CreateObject failed (spawnPlant)")
        return
    end

    SetEntityHeading(obj, p.heading or 0.0)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetEntityLodDist(obj, 250)

    Spawned[id] = obj

    exports.ox_target:addLocalEntity(obj, {
        {
            name = ("bam_weedpots_water_%d"):format(id),
            label = "Arroser",
            icon = "fa-solid fa-droplet",
            distance = Config.TargetDistance,
            onSelect = function()
                local ped = PlayerPedId()

                loadAnim("amb@world_human_gardener_plant@male@idle_a")
                TaskPlayAnim(ped, "amb@world_human_gardener_plant@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false)

                local ok = lib.progressBar({
                    duration = 4500,
                    label = "Arrosage...",
                    useWhileDead = false,
                    canCancel = true,
                    disable = { move = true, car = true, combat = true }
                })

                ClearPedTasks(ped)

                if ok then
                    TriggerServerEvent("bam_weedpots:server:waterPlant", id)
                end
            end
        },
        {
            name = ("bam_weedpots_harvest_%d"):format(id),
            label = "Récolter",
            icon = "fa-solid fa-scissors",
            distance = Config.TargetDistance,
            canInteract = function()
                local pp = Plants[id]
                return pp and pp.stage == 3
            end,
            onSelect = function()
                TriggerServerEvent("bam_weedpots:server:harvestPlant", id)
            end
        },
        {
            name = ("bam_weedpots_remove_%d"):format(id),
            label = "Retirer",
            icon = "fa-solid fa-trash",
            distance = Config.TargetDistance,
            onSelect = function()
                TriggerServerEvent("bam_weedpots:server:removePlant", id)
            end
        }
    })
end

local function despawnPlant(id)
    local ent = Spawned[id]
    if not ent then
        return
    end
    exports.ox_target:removeLocalEntity(ent)
    deleteEntitySafe(ent)
    Spawned[id] = nil
end

local function refreshPlantEntity(id, p)
    local ent = Spawned[id]
    if not ent then
        return
    end

    local wantedModel = modelFor(p.variant, p.stage)
    local currentModel = GetEntityModel(ent)

    if currentModel ~= joaat(wantedModel) then
        despawnPlant(id)
        spawnPlant(id, p)
    end
end

local SYNC_CELL_SIZE = 300
local SYNC_RANGE = 110.0
local SYNC_RANGE_SQ = SYNC_RANGE * SYNC_RANGE

local function normalizePlant(p)
    if not p or not p.coords then return end
    local c = p.coords
    if type(c) ~= "vector3" then
        p.coords = vector3(c.x or 0.0, c.y or 0.0, c.z or 0.0)
    end
end

local function syncCellKey(x, y)
    local cx = math.floor(x / SYNC_CELL_SIZE)
    local cy = math.floor(y / SYNC_CELL_SIZE)
    return cx * 100000 + cy
end

RegisterNetEvent("bam_weedpots:client:syncAll", function(plants)
    plants = plants or {}
    local t = mono()
    local syncedIds = {}

    for id, p in pairs(plants) do
        id = tonumber(id) or id
        if type(p) == "table" then
            normalizePlant(p)
            p._syncMono = t
            Plants[id] = p
            syncedIds[id] = true
        end
    end

    local pc = GetEntityCoords(PlayerPedId())
    local pruneRsq = (SYNC_RANGE * 2) * (SYNC_RANGE * 2)
    for id, p in pairs(Plants) do
        local c = p.coords
        if c then
            local dx, dy, dz = pc.x - c.x, pc.y - c.y, pc.z - c.z
            local rsq = dx*dx + dy*dy + dz*dz
            if rsq >= pruneRsq or (rsq < SYNC_RANGE_SQ and not syncedIds[id]) then
                Plants[id] = nil
                despawnPlant(id)
            end
        end
    end
end)

RegisterNetEvent("bam_weedpots:client:upsertPlant", function(p)
    if not p or not p.id then
        return
    end
    normalizePlant(p)
    p._syncMono = mono()
    Plants[p.id] = p
    refreshPlantEntity(p.id, p)
end)

RegisterNetEvent("bam_weedpots:client:syncDiff", function(upsert, remove)
    if type(upsert) == "table" then
        local t = mono()
        for id, p in pairs(upsert) do
            id = tonumber(id) or id
            if type(p) == "table" then
                normalizePlant(p)
                p._syncMono = t
                Plants[id] = p
                refreshPlantEntity(id, p)
            end
        end
    end

    if type(remove) == "table" then
        for i = 1, #remove do
            local id = tonumber(remove[i])
            if id then
                Plants[id] = nil
                despawnPlant(id)
            end
        end
    end
end)

RegisterNetEvent("bam_weedpots:client:upsertPlants", function(list)
    if type(list) ~= "table" then return end
    local m = mono()
    for i = 1, #list do
        local p = list[i]
        if p and p.id then
            normalizePlant(p)
            p._syncMono = m
            Plants[p.id] = p
            refreshPlantEntity(p.id, p)
        end
    end
end)

RegisterNetEvent("bam_weedpots:client:removePlant", function(id)
    id = tonumber(id)
    if not id then
        return
    end
    Plants[id] = nil
    despawnPlant(id)
end)

RegisterNetEvent("bam_weedpots:client:reward", function(item, amount)
    lib.notify({ type = "inform", description = ("Récompense: %s x%d"):format(item, amount) })
end)

local REQUEST_ALL_LOCAL_THROTTLE_MS = 15000
local _lastRequestAllMs = 0

local function sendRequestAll(initial)
    local nowMs = GetGameTimer()
    if not initial and (nowMs - _lastRequestAllMs) < REQUEST_ALL_LOCAL_THROTTLE_MS then
        return
    end
    _lastRequestAllMs = nowMs

    if initial then

        TriggerServerEvent("bam_weedpots:server:requestAll", nil)
        return
    end

    local knownIds = {}
    local n = 0
    for id in pairs(Plants) do
        n = n + 1
        knownIds[n] = id
    end
    TriggerServerEvent("bam_weedpots:server:requestAll", knownIds)
end

CreateThread(function()
    Wait(1000 + math.random(0, 3000))
    sendRequestAll(true)

    local pc = GetEntityCoords(PlayerPedId())
    local lastCell = syncCellKey(pc.x, pc.y)

    local fallbackMs = 360000 + math.random(0, 180000)

    while true do
        Wait(10000)

        local pc = GetEntityCoords(PlayerPedId())
        local cell = syncCellKey(pc.x, pc.y)
        if cell ~= lastCell then
            lastCell = cell
            sendRequestAll(false)
        end

        fallbackMs = fallbackMs - 10000
        if fallbackMs <= 0 then
            fallbackMs = 360000 + math.random(0, 180000)
            sendRequestAll(false)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(750)

        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)

        for id, p in pairs(Plants) do
            local d = dist(pc, p.coords)
            if d <= Config.SpawnDistance then
                spawnPlant(id, p)
            elseif d >= Config.DespawnDistance then
                despawnPlant(id)
            end
        end

        for id, ent in pairs(Spawned) do
            if not Plants[id] then
                despawnPlant(id)
            end
        end
    end
end)

function mono()
    return math.floor(GetGameTimer() / 1000)
end

local function screenFromWorld(coords)
    local onScreen, sx, sy = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then
        return nil
    end
    return sx * 100.0, sy * 100.0
end

local function getClosestPlant(maxDist)
    local ped = PlayerPedId()
    local pc = GetEntityCoords(ped)

    local bestId = nil
    local best = nil
    local bestDist = maxDist or 2.5

    for id, p in pairs(Plants) do
        local d = #(pc - p.coords)
        if d <= bestDist then
            bestDist = d
            bestId = id
            best = p
        end
    end

    return bestId, best, bestDist
end

local function sendHud(payload)
    SendNUIMessage({
        type = "weedpot_hud",
        payload = payload
    })
end

CreateThread(function()
    AnimpostfxStop("DrugsMichaelAliensFight")
    StopGameplayCamShaking(true)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    local showing = false

    while true do
        local interval = 350

        local id, p = getClosestPlant(2.25)

        if not id or not p then
            if showing then
                showing = false
                sendHud({ show = false })
            end
            Wait(interval)
        else
            local zOffset = 1.05
            if p.stage == 2 then
                zOffset = 1.25
            elseif p.stage == 3 then
                zOffset = 1.45
            end

            local x, y = screenFromWorld(vector3(p.coords.x, p.coords.y, p.coords.z + zOffset))

            if not x or not y then
                if showing then
                    showing = false
                    sendHud({ show = false })
                end
                Wait(interval)
            else
                showing = true
                interval = 0

                local st = tonumber(p.serverTime) or 0
                if st > 0 then
                    local base = tonumber(p._syncMono) or mono()
                    st = st + (mono() - base)
                end

                sendHud({
                    show = true,
                    x = x,
                    y = y,
                    brand = "CULTIVATION",
                    title = "POT DE WEED",
                    variant = p.variant,
                    stage = p.stage,
                    water = p.water or 0,
                    maxWater = Config.MaxWater,
                    needWater = Config.WaterRequiredToGrow,
                    nextStageAt = p.nextStageAt or 0,
                    serverTime = st,
                    minWaterToGrow = math.floor(Config.MaxWater * (Config.MinWaterPctToGrow or 0.50)),
                })

                Wait(interval)
            end
        end
    end
end)

RegisterNetEvent("bam_weedpots:client:useWeed", function(variant)
    local fx = Config.DrugEffects and Config.DrugEffects[variant] or nil
    if not fx then
        return
    end

    local ped = PlayerPedId()
    local dur = tonumber(fx.duration) or 90
    local endAt = GetGameTimer() + (dur * 1000)

    AnimpostfxPlay("DrugsMichaelAliensFight", 10000, true)
    ShakeGameplayCam("DRUNK_SHAKE", 0.25)

    local armor = tonumber(fx.armor) or 0
    if armor > 0 then

        pcall(function() exports['antisbire']:armorGrace(3000) end)
        SetPedArmour(ped, math.min(100, GetPedArmour(ped) + armor))
    end

    local heal = tonumber(fx.heal) or 0
    if heal > 0 then
        SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + heal))
    end

    CreateThread(function()
        while GetGameTimer() < endAt do
            Wait(0)
            SetPedMoveRateOverride(PlayerPedId(), tonumber(fx.speedMult) or 1.0)
        end
    end)

    CreateThread(function()
        while GetGameTimer() < endAt do
            Wait(1000)

            SetPedMoveRateOverride(PlayerPedId(), tonumber(fx.speedMult) or 1.0)

            if math.random() < (tonumber(fx.nauseaChance) or 0.0) then
                SetPedToRagdoll(ped, 1200, 1200, 0, false, false, false)
            end
        end
        SetPedMoveRateOverride(PlayerPedId(), 1.0)
        AnimpostfxStop("DrugsMichaelAliensFight")
        StopGameplayCamShaking(true)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end)
end)

local PotsMenuOpen = false
local PotsList = {}
local PotsLoading = false
local PotsSelected = nil
local PotsBlip = nil
local PotsDeleteArmed = nil
local PotsDeleteArmedAt = 0

local STAGE_LABELS = {
    [1] = "Pousse",
    [2] = "Croissance",
    [3] = "~o~Prêt à récolter",
}

local function clearPotsBlip()
    if PotsBlip and DoesBlipExist(PotsBlip) then
        RemoveBlip(PotsBlip)
    end
    PotsBlip = nil
end

local function fmtDuration(seconds)
    seconds = math.floor(tonumber(seconds) or 0)
    if seconds <= 0 then
        return "prêt"
    end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if h > 0 then
        return ("%dh%02d"):format(h, m)
    end
    if m > 0 then
        return ("%d min"):format(m)
    end
    return ("%d s"):format(seconds)
end

local function fetchPots(cb)
    if PotsLoading then return end
    PotsLoading = true

    ESX.TriggerServerCallback("bam_weedpots:getMyPlants", function(list)
        PotsLoading = false

        if type(list) == "table" then
            PotsList = list
        end
        if cb then cb() end
    end)
end

local function markPotOnGps(p)
    clearPotsBlip()

    SetNewWaypoint(p.x + 0.0, p.y + 0.0)

    PotsBlip = AddBlipForCoord(p.x + 0.0, p.y + 0.0, p.z + 0.0)
    SetBlipSprite(PotsBlip, 496)
    SetBlipColour(PotsBlip, 2)
    SetBlipScale(PotsBlip, 0.85)
    SetBlipAsShortRange(PotsBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(("Pot #%d - %s"):format(p.id, tostring(p.label)))
    EndTextCommandSetBlipName(PotsBlip)

    lib.notify({ type = "success", description = ("GPS réglé sur le pot #%d."):format(p.id) })
end

local function openPotsMenu()
    if PotsMenuOpen then
        return
    end
    PotsMenuOpen = true
    PotsSelected = nil
    PotsDeleteArmed = nil

    RMenu.Add("snl_potsweed", "main", RageUI.CreateMenu("SunLife", "Mes pots de weed", 1, 100))
    RMenu.Add("snl_potsweed", "actions", RageUI.CreateSubMenu(RMenu:Get("snl_potsweed", "main"), "SunLife", "Actions sur le pot"))

    RMenu:Get("snl_potsweed", "main"):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get("snl_potsweed", "actions"):SetRectangleBanner(255, 117, 31, 225)

    fetchPots()
    RageUI.Visible(RMenu:Get("snl_potsweed", "main"), true)

    CreateThread(function()
        while PotsMenuOpen do
            Wait(0)

            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)

            RageUI.IsVisible(RMenu:Get("snl_potsweed", "main"), true, true, true, function()
                if PotsLoading and #PotsList == 0 then
                    RageUI.Separator("~y~Chargement...")
                    return
                end

                RageUI.Separator(("Pots plantés: ~o~%d~s~ / %d"):format(#PotsList, Config.MaxPlantsPerPlayer))

                if #PotsList == 0 then
                    RageUI.Separator("~c~Aucun pot planté")
                    return
                end

                for i = 1, #PotsList do
                    local p = PotsList[i]
                    local d = #(pc - vector3(p.x, p.y, p.z))

                    local stageTxt = STAGE_LABELS[p.stage] or ("Stade " .. tostring(p.stage))
                    local remaining = (p.stage or 1) < 3
                        and (" ~s~| Prochain stade: ~o~" .. fmtDuration((p.nextStageAt or 0) - (p.serverTime or 0)))
                        or ""

                    local desc = ("Stade: ~o~%s~s~ | Eau: ~b~%d%%~s~%s~s~\nDistance: ~o~%d m"):format(
                        stageTxt, math.floor(((p.water or 0) / (p.maxWater or 100)) * 100), remaining, math.floor(d)
                    )

                    RageUI.ButtonWithStyle(("~o~#%d~s~ %s"):format(p.id, tostring(p.label)), desc, { RightLabel = "→→" }, true, function(_, _, selected)
                        if selected then
                            PotsSelected = p
                            PotsDeleteArmed = nil
                        end
                    end, RMenu:Get("snl_potsweed", "actions"))
                end
            end)

            RageUI.IsVisible(RMenu:Get("snl_potsweed", "actions"), true, true, true, function()
                local p = PotsSelected
                if not p then
                    RageUI.Separator("~r~Aucun pot sélectionné")
                    return
                end

                RageUI.Separator(("Pot ~o~#%d~s~ - %s"):format(p.id, tostring(p.label)))

                RageUI.ButtonWithStyle("Voir sur le GPS", "Place un point de passage sur ce pot.", { RightLabel = "📍" }, true, function(_, _, selected)
                    if selected then
                        markPotOnGps(p)
                    end
                end)

                local armed = PotsDeleteArmed == p.id and (GetGameTimer() - PotsDeleteArmedAt) < 5000

                RageUI.ButtonWithStyle(
                    armed and "~r~Confirmer la suppression" or "~r~Supprimer le pot",
                    armed and "~o~Appuyez à nouveau pour confirmer (5 s)." or "Retire le pot ; la graine revient dans ton inventaire.",
                    { RightLabel = armed and "~r~✔" or "🗑" }, true,
                    function(_, _, selected)
                        if not selected then return end

                        if not armed then
                            PotsDeleteArmed = p.id
                            PotsDeleteArmedAt = GetGameTimer()
                            return
                        end

                        PotsDeleteArmed = nil
                        TriggerServerEvent("bam_weedpots:server:removePlant", p.id)

                        PotsSelected = nil
                        RageUI.GoBack()
                        SetTimeout(700, function()
                            if PotsMenuOpen then fetchPots() end
                        end)
                    end
                )
            end)

            if not RageUI.Visible(RMenu:Get("snl_potsweed", "main")) and not RageUI.Visible(RMenu:Get("snl_potsweed", "actions")) then
                PotsMenuOpen = false
            end
        end

        RageUI.CloseAll()
    end)
end

RegisterCommand("potsweed", function()
    if ESX == nil then return end
    openPotsMenu()
end, false)

TriggerEvent("chat:addSuggestion", "/potsweed", "Affiche la liste de tes pots de weed (GPS / suppression)")

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        clearPotsBlip()
    end
end)
