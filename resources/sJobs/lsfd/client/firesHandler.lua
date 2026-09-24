ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

activeFiresClient = {}
local fireExtinguishingCount = {}
local activeSmokeEffects = {}
local activeFiresPaused = {}
local fireBlips = {}
local maxExtinguishingShots = 10

local fireZones = {
    vector3(0.0, 0.0, 0.0),
}
local fireRadius = 10.0

local function hasProtectiveMask(ped)
    return GetPedDrawableVariation(ped, 1) > 0
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
    TriggerServerEvent("kxFires:sendActiveFires")
end)

local function addFx(fireId, fxHandle)
    if not fxHandle then return end
    activeSmokeEffects[fireId] = activeSmokeEffects[fireId] or {}
    table.insert(activeSmokeEffects[fireId], fxHandle)
end

local function hardKillFire(fireId)
    SendNUIMessage({ action = 'fire:hide' })

    local data = activeFiresClient[fireId]
    if data then
        if data.handles then
            for _, h in ipairs(data.handles) do
                if h then RemoveScriptFire(h) end
            end
        end

        local loc = data.location or GetEntityCoords(PlayerPedId())
        StopFireInRange(loc.x, loc.y, loc.z, 30.0)
        removeFireEffects(fireId)
        RemoveParticleFxInRange(loc, 50.0)

        if fireBlips[fireId] then
            RemoveBlip(fireBlips[fireId])
            fireBlips[fireId] = nil
        end
        activeFiresClient[fireId] = nil
        activeFiresPaused[fireId] = nil
        fireExtinguishingCount[fireId] = nil
    end
end

function loadParticleFx(asset)
    RequestNamedPtfxAsset(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        Wait(10)
    end
end

function createFireEffects(fireId, location)
    loadParticleFx("scr_agencyheistb")
    loadParticleFx("scr_trevor3")

    UseParticleFxAsset("scr_agencyheistb")
    local smokeEffect1 = StartParticleFxLoopedAtCoord(
        "scr_env_agency3b_smoke",
        location.x, location.y, location.z + 1.0,
        0.0, 0.0, 0.0, 1.0,
        false, false, false, false
    )
    addFx(fireId, smokeEffect1)

    UseParticleFxAsset("scr_trevor3")
    local flamePlumeEffect = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        location.x, location.y, location.z + 1.2,
        0.0, 0.0, 0.0, 1.0,
        false, false, false, false
    )
    addFx(fireId, flamePlumeEffect)

    for i = 1, 3 do
        local offsetX = math.random(-2, 2)
        local offsetY = math.random(-2, 2)
        UseParticleFxAsset("scr_agencyheistb")
        local fx = StartParticleFxLoopedAtCoord(
            "scr_env_agency3b_smoke",
            location.x + offsetX, location.y + offsetY, location.z + 1.0,
            0.0, 0.0, 0.0, 1.0,
            false, false, false, false
        )
        addFx(fireId, fx)
    end
end

function removeFireEffects(fireId)
    if activeSmokeEffects[fireId] then
        for _, effect in ipairs(activeSmokeEffects[fireId]) do
            StopParticleFxLooped(effect, false)
            RemoveParticleFx(effect, true)
        end
        activeSmokeEffects[fireId] = nil
    end
end

function displayFireStatus(fireId)
    if activeFiresClient[fireId] then
        if ESX.PlayerData.job.name == "lsfd" then
            local extinguishingCount = fireExtinguishingCount[fireId] or 0
            local maxShots = activeFiresClient[fireId].maxShots or 1
            local extinguishingProgress = (extinguishingCount / maxShots) * 100
            local fireIntensity = 100 - extinguishingProgress
            fireIntensity = math.max(0, math.min(100, fireIntensity))
            extinguishingProgress = math.max(0, math.min(100, extinguishingProgress))
            fireIntensity = math.floor(fireIntensity)
            extinguishingProgress = math.floor(extinguishingProgress)

            SendNUIMessage({ action = 'fire:show' })
            SendNUIMessage({ action = 'fire:update', value = extinguishingProgress })

        else
            local text = "~r~Un incendie est en cours autour de vous"

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.5, 0.5)
            SetTextColour(255, 204, 0, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.5, 0.95)
        end
    end
end

function displayClosestFireStatus()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestFireId = nil
    local closestDistance = math.huge

    for fireId, fireData in pairs(activeFiresClient) do
        local distance = #(playerCoords - fireData.location)
        if distance < closestDistance then
            closestDistance = distance
            closestFireId = fireId
        end
    end

    if closestFireId then
        displayFireStatus(closestFireId)
    else
        SendNUIMessage({ action = 'fire:hide' })
    end
end

local allBlips = {}

local function _spawnNormalFireHandles(location)
    local handles = {}
    local n = math.random(20, 60)
    for i = 1, n do
        local ox = math.random(-5, 5) * 0.5
        local oy = math.random(-5, 5) * 0.5
        handles[#handles + 1] = StartScriptFire(location.x + ox, location.y + oy, location.z - 0.95, 24, false)
    end
    return handles
end

RegisterNetEvent("createFireOnClient")
AddEventHandler("createFireOnClient", function(fireId, location, intensity, maxShots)

    activeFiresClient[fireId] = activeFiresClient[fireId] or {}
    local entry = activeFiresClient[fireId]
    entry.location  = location
    entry.intensity = intensity
    entry.maxShots  = maxShots
    entry.handles   = entry.handles or {}
    entry._gen      = (entry._gen or 0) + 1
    local gen       = entry._gen

    local pcoords = GetEntityCoords(PlayerPedId())
    if #(pcoords - location) <= 150.0 then
        local handles = _spawnNormalFireHandles(location)
        if not activeFiresClient[fireId] or activeFiresClient[fireId]._gen ~= gen then
            for _, h in ipairs(handles) do RemoveScriptFire(h) end
            return
        end
        activeFiresClient[fireId].handles = handles
        createFireEffects(fireId, location)
    else
        activeFiresPaused[fireId] = true
    end

    if (ESX.PlayerData.job.name == "lsfd") then
        if fireBlips[fireId] then
            RemoveBlip(fireBlips[fireId])
            fireBlips[fireId] = nil
        end
        ESX.ShowNotification("~y~Un incendie vient de se lancer à cette position !")

        local blipId = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blipId, 570)
        SetBlipColour(blipId, 66)
        SetBlipScale(blipId, 0.90)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Incendie")
        EndTextCommandSetBlipName(blipId)

        fireBlips[fireId] = blipId
        table.insert(allBlips, blipId)
    end

    Citizen.SetTimeout(180000, function()
        if fireBlips[fireId] then
            RemoveBlip(fireBlips[fireId])
            fireBlips[fireId] = nil
        end
    end)
end)

local function _spawnLargeFireHandles(fireId, location, fireCount, offsetMax)
    if not activeFiresClient[fireId] then return end
    local gen = activeFiresClient[fireId]._gen

    loadParticleFx("scr_agencyheistb")
    loadParticleFx("scr_trevor3")

    local handles = {}
    local tmpFx = {}

    for i = 1, fireCount do
        local ox = math.random(-offsetMax, offsetMax)
        local oy = math.random(-offsetMax, offsetMax)

        handles[#handles + 1] = StartScriptFire(location.x + ox, location.y + oy, location.z - 0.95, 24, false)

        UseParticleFxAsset("scr_agencyheistb")
        tmpFx[#tmpFx + 1] = StartParticleFxLoopedAtCoord(
            "scr_env_agency3b_smoke",
            location.x + ox, location.y + oy, location.z + 1.0,
            0.0, 0.0, 0.0, 1.0, false, false, false, false
        )

        UseParticleFxAsset("scr_trevor3")
        tmpFx[#tmpFx + 1] = StartParticleFxLoopedAtCoord(
            "scr_trev3_trailer_plume",
            location.x + ox, location.y + oy, location.z + 1.0,
            0.0, 0.0, 0.0, 1.0, false, false, false, false
        )
    end

    if not activeFiresClient[fireId] or activeFiresClient[fireId]._gen ~= gen then
        for _, h in ipairs(handles) do RemoveScriptFire(h) end
        for _, fx in ipairs(tmpFx) do
            StopParticleFxLooped(fx, false)
            RemoveParticleFx(fx, true)
        end
        return
    end

    activeFiresClient[fireId].handles  = handles
    activeFiresClient[fireId].deferred = false

    for _, fx in ipairs(tmpFx) do addFx(fireId, fx) end
    createFireEffects(fireId, location)
end

local function _registerLargeFire(fireId, location, intensity, maxShots, opts)
    activeFiresClient[fireId] = activeFiresClient[fireId] or {}
    local entry = activeFiresClient[fireId]
    entry.location  = location
    entry.intensity = intensity
    entry.maxShots  = maxShots
    entry.handles   = entry.handles or {}
    entry.isBig     = true
    entry.isMega    = opts.isMega == true
    entry.deferred  = true
    entry._gen      = (entry._gen or 0) + 1
    local gen       = entry._gen

    Citizen.CreateThread(function()
        while #(GetEntityCoords(PlayerPedId()) - location) > opts.spawnDistance do
            Citizen.Wait(1000)
            if not activeFiresClient[fireId] or (activeFiresClient[fireId]._gen ~= gen) then
                return
            end
        end
        if not activeFiresClient[fireId] or (activeFiresClient[fireId]._gen ~= gen) then return end
        _spawnLargeFireHandles(fireId, location, math.random(opts.fireMin, opts.fireMax), opts.offsetMax)
    end)

    if ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name == "lsfd" then
        if fireBlips[fireId] then RemoveBlip(fireBlips[fireId]); fireBlips[fireId] = nil end
        ESX.ShowNotification(opts.notification)

        local blipId = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blipId, opts.blipSprite)
        SetBlipColour(blipId, opts.blipColour)
        SetBlipScale(blipId, opts.blipScale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(opts.blipName)
        EndTextCommandSetBlipName(blipId)

        fireBlips[fireId] = blipId
        table.insert(allBlips, blipId)
    end

    Citizen.SetTimeout(180000, function()
        if fireBlips[fireId] then RemoveBlip(fireBlips[fireId]); fireBlips[fireId] = nil end
    end)
end

RegisterNetEvent("createBigFireOnClient")
AddEventHandler("createBigFireOnClient", function(fireId, location, intensity, maxShots)
    _registerLargeFire(fireId, location, intensity, maxShots, {
        isMega         = false,
        spawnDistance  = 100.0,
        fireMin        = 1000,
        fireMax        = 1500,
        offsetMax      = 8,
        notification   = "~y~Un gros incendie important vient de se lancer à cette position !",
        blipSprite     = 864,
        blipColour     = 1,
        blipScale      = 1.2,
        blipName       = "Incendie",
    })
end)

RegisterNetEvent("createMegaFireOnClient")
AddEventHandler("createMegaFireOnClient", function(fireId, location, intensity, maxShots)
    _registerLargeFire(fireId, location, intensity, maxShots, {
        isMega         = true,
        spawnDistance  = 120.0,
        fireMin        = 1500,
        fireMax        = 2000,
        offsetMax      = 10,
        notification   = "~r~⚠ MÉGA INCENDIE détecté — Toutes les unités LSFD en intervention !",
        blipSprite     = 436,
        blipColour     = 1,
        blipScale      = 1.6,
        blipName       = "MÉGA INCENDIE",
    })
end)

local lastDamageTime = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local nearFire = false

        for fireId, fireData in pairs(activeFiresClient) do
            if fireData and fireData.location then
                local dist = #(coords - fireData.location)

                if dist < 15.0 then
                    nearFire = true

                    if not fireData.fxActive then
                        StartScreenEffect("DrugsTrevorClownsFight", 0, true)
                        fireData.fxActive = true
                    end

                    if dist < 6.0 and (GetGameTimer() - lastDamageTime) > 1500 then
                        if not hasProtectiveMask(ped) then
                            ApplyDamageToPed(ped, 1, false)
                            lastDamageTime = GetGameTimer()

                            StartScreenEffect("DeathFailOut", 0, false)
                            Citizen.SetTimeout(500, function()
                                StopScreenEffect("DeathFailOut")
                            end)

                            ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.1)
                        end
                    end
                else
                    if fireData.fxActive then
                        StopScreenEffect("DrugsTrevorClownsFight")
                        fireData.fxActive = false
                    end
                end
            end
        end

        if not nearFire then
            StopScreenEffect("DrugsTrevorClownsFight")
        end
    end
end)

RegisterNetEvent("extinguishFireOnClient")
AddEventHandler("extinguishFireOnClient", function(fireId)
    if activeFiresClient[fireId] then
        for _, fireHandle in ipairs(activeFiresClient[fireId].handles) do
            RemoveScriptFire(fireHandle)
        end

        if fireBlips[fireId] then
            RemoveBlip(fireBlips[fireId])
            fireBlips[fireId] = nil
        end

        removeFireEffects(fireId)

        hardKillFire(fireId)

        activeFiresClient[fireId] = nil
        fireExtinguishingCount[fireId] = nil
    end
end)

function isUsingExtinguisher()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    return currentWeapon == GetHashKey("WEAPON_FIREEXTINGUISHER") or currentWeapon == GetHashKey("WEAPON_HOSE")
end

local WATER_CANNON_VEHICLES <const> = {
    [`firetruk`]     = true,
    [`lsfdtruck`]    = true,
    [`lsfdtruck2`]   = true,
    [`hvfdladder`]   = true,
    [`hvfiretruk`]   = true,
    [`hvfdbrush`]    = true,
    [`hvfdalamo`]    = true,
    [`hvfdheavy`]    = true,
    [`hvfdterminus`] = true,
    [`hvfdyosemite`] = true,
    [`hvfdgrang`]    = true,
    [`hvfdscout`]    = true,
}

function isInWaterCannonVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return false, 0 end
    return WATER_CANNON_VEHICLES[GetEntityModel(vehicle)] == true, vehicle
end

function isUsingFireHose()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    local inCannonVeh = isInWaterCannonVehicle()

    if inCannonVeh or (GetVehiclePedIsIn(playerPed, false) ~= 0 and currentWeapon == GetHashKey("WEAPON_HOSE")) then
        return IsControlPressed(1, 25)
    end

    return false
end

function isWaterHittingFire(playerCoords, fireCoords, isBigFire)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    local isHose = currentWeapon == GetHashKey("WEAPON_HOSE")

    local isInFireTruck = vehicle ~= 0 and WATER_CANNON_VEHICLES[GetEntityModel(vehicle)] == true

    local distanceToFire = #(playerCoords - fireCoords)
    local baseMaxDistance = isInFireTruck and 30.0 or 25.0
    if isHose then
        baseMaxDistance = baseMaxDistance + 15.0
    end
    local maxDistance = isBigFire and (baseMaxDistance + 10.0) or baseMaxDistance

    local ignoreEntity = isInFireTruck and vehicle or playerPed
    local rayHandle = StartShapeTestRay(
        playerCoords.x, playerCoords.y, playerCoords.z + 0.5,
        fireCoords.x, fireCoords.y, fireCoords.z + 0.5,
        -1, ignoreEntity, 0
    )
    local _, hit = GetShapeTestResult(rayHandle)

    local isInFireTruckLocal = isInFireTruck
    local forwardVector
    local directionToFire

    if isInFireTruckLocal then
        forwardVector = GetEntityForwardVector(vehicle)
        directionToFire = fireCoords - GetEntityCoords(vehicle)
    else
        forwardVector = GetEntityForwardVector(playerPed)
        directionToFire = fireCoords - playerCoords
    end

    directionToFire = directionToFire / #(directionToFire)

    local dotProduct = forwardVector.x * directionToFire.x + forwardVector.y * directionToFire.y + forwardVector.z * directionToFire.z
    local isLookingAtFire

    if isInFireTruckLocal then
        if isBigFire then
            isLookingAtFire = dotProduct > -0.1
        else
            isLookingAtFire = dotProduct > 0.05
        end
    else
        if isBigFire then
            isLookingAtFire = dotProduct > 0.4
        else
            isLookingAtFire = dotProduct > 0.7
        end
    end

    local isPlayerOnGround = IsPedOnFoot(playerPed)
    local isWithinDistance = distanceToFire <= maxDistance

    return hit and isLookingAtFire and (isPlayerOnGround or isInFireTruckLocal) and isWithinDistance
end

local function isShootControlActive()
    return IsControlPressed(0, 24)
        or IsDisabledControlPressed(0, 24)
end

isUsingWaterCannon = function()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    if currentWeapon ~= GetHashKey("WEAPON_HOSE") then
        return false
    end
    return isShootControlActive()
end

Citizen.CreateThread(function()
    Citizen.SetTimeout(5 * 1000, function()
        TriggerServerEvent("kxFires:sendActiveFires")
    end)

    local gived = 0
    while true do
        local interval = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for fireId, fireData in pairs(activeFiresClient) do
            if #(GetEntityCoords(PlayerPedId()) - fireData.location) < 25.0 then
                interval = 0
            end
        end

        if (isUsingExtinguisher() and IsPedShooting(playerPed) or isUsingFireHose() or isUsingWaterCannon()) then
            for fireId, fireData in pairs(activeFiresClient) do
                local isBigFire = fireData.isBig == true
                if isWaterHittingFire(playerCoords, fireData.location, isBigFire) and GetGameTimer() > gived then
                    gived = GetGameTimer() + 250

                    if not fireExtinguishingCount[fireId] then
                        fireExtinguishingCount[fireId] = 0
                    end

                    if fireExtinguishingCount[fireId] < fireData.maxShots then
                        fireExtinguishingCount[fireId] = fireExtinguishingCount[fireId] + 1
                    end

                    TriggerServerEvent("updateExtinguishingCount", fireId, fireExtinguishingCount[fireId])
                end
            end
        end

        if interval == 0 then
            displayClosestFireStatus()
        else
            SendNUIMessage({ action = 'fire:hide' })
        end

        Citizen.Wait(interval)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for fireId, fireData in pairs(activeFiresClient) do
            local distance = #(playerCoords - fireData.location)
            if distance > 150.0 and not activeFiresPaused[fireId] then
                for _, fireHandle in ipairs(fireData.handles) do
                    RemoveScriptFire(fireHandle)
                end
                removeFireEffects(fireId)
                fireData.handles = {}
                activeFiresPaused[fireId] = true
            elseif distance <= 150.0 and activeFiresPaused[fireId] then
                if fireData.isMega then
                    _spawnLargeFireHandles(fireId, fireData.location, math.random(1500, 2000), 10)
                elseif fireData.isBig then
                    _spawnLargeFireHandles(fireId, fireData.location, math.random(1000, 1500), 8)
                else
                    local handles = _spawnNormalFireHandles(fireData.location)
                    activeFiresClient[fireId].handles = handles
                    createFireEffects(fireId, fireData.location)
                end
                activeFiresPaused[fireId] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(playerPed)
        local extinguisherInHand = false

        if currentWeapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then
            extinguisherInHand = true
            SetPedAmmo(GetPlayerPed(-1), GetHashKey("WEAPON_FIREEXTINGUISHER"), 999)
        end

        if extinguisherInHand then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("syncExtinguishingCount")
AddEventHandler("syncExtinguishingCount", function(fireId, count)
    fireExtinguishingCount[fireId] = count
end)

function isNearFireZone(position)
    for _, zone in ipairs(fireZones) do
        if #(position - zone) < fireRadius then
            return zone
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        local interval = 1000

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local fireZone = isNearFireZone(pos)

        if fireZone then
            interval = 0
        end

        if IsPedShooting(playerPed) then
            local weapon = GetSelectedPedWeapon(playerPed)
            if weapon == GetHashKey("WEAPON_MOLOTOV") then
                local pos = GetEntityCoords(playerPed)
                local fireZone = isNearFireZone(pos)

                if fireZone then
                    TriggerServerEvent("createFireAtPosition", fireZone, math.random(2, 4))
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearFire = false

        for fireId, fireData in pairs(activeFiresClient) do
            if #(playerCoords - fireData.location) < 50.0 then
                nearFire = true
                break
            end
        end
    end
end)

AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then
        Wait(2500)
        TriggerServerEvent('kxFires:sendActiveFires')
    end
end)

AddEventHandler('onClientResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for fireId, _ in pairs(activeFiresClient) do
        hardKillFire(fireId)
    end
    local p = GetEntityCoords(PlayerPedId())
    StopFireInRange(p.x, p.y, p.z, 200.0)
    RemoveParticleFxInRange(p, 500.0)
end)

RegisterNetEvent('esx:playerLoaded', function()
    Wait(1500)
    TriggerServerEvent('kxFires:sendActiveFires')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3 * 60 * 1000)
        TriggerServerEvent("kxFires:sendActiveFires")
    end
end)
