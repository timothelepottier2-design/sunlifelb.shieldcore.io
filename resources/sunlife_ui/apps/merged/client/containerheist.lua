ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local containers = {}
local collisions = {}
local locks = {}
local clientContainer = {}
local clientLock = {}
local rndContainer = nil
local startped
local containersBlip
local weaponBox
local guardPeds = {}
local zoneIds = {}
local crateTargetAdded = false
local crateTargetName = nil
local runActive = false
local runFinished = false
local setupToken = 0

local siteCenter = nil

local BLIP_CAT_ACTIVITE_ILLEGALE <const> = 43

local cooldownEnd = 0
local serverTimeAtSync = 0
local gameTimerAtSync = 0

local function getCooldownRemaining()
    if cooldownEnd == 0 then return 0 end
    local elapsed = (GetGameTimer() - gameTimerAtSync) / 1000
    return math.max(0, math.ceil(cooldownEnd - serverTimeAtSync - elapsed))
end

RegisterNetEvent('jomidar-ammorobbery:cl:cooldownEnd')
AddEventHandler('jomidar-ammorobbery:cl:cooldownEnd', function(endTimestamp, serverNow)
    cooldownEnd = endTimestamp or 0
    serverTimeAtSync = serverNow or 0
    gameTimerAtSync = GetGameTimer()
end)

local function RegisterNetEntity(ent)

end

local function rot(h, off)
    local r = h * 0.017453292519943
    local s = math.sin(r)
    local c = math.cos(r)
    return vector3(off.x * c - off.y * s, off.x * s + off.y * c, off.z)
end

local function add(a, b)
    return vector3(a.x + b.x, a.y + b.y, a.z + b.z)
end

local function mul(v, m)
    return vector3(v.x * m, v.y * m, v.z * m)
end

local function buildContainersForSite(site)
    local h = site.center.w
    local r = h * 0.017453292519943
    local f = vector3(math.sin(r), math.cos(r), 0.0)
    local s = vector3(math.cos(r), -math.sin(r), 0.0)
    local rowA = vector3(site.center.x, site.center.y, site.center.z)
    local rowB = add(rowA, mul(f, -site.rowSpacing))
    local lockOff = vector3(0.0, -1.85, 1.10)
    local targetOff = vector3(0.0, -2.10, 1.00)
    local boxOff = vector3(0.0, 1.00, 0.20)
    local t = {}
    for i=-1,1 do
        local pos = add(rowA, mul(s, site.colSpacing * i))
        local hd = h
        local model = cfg_containers.ContainerModels.rowA[i+2]
        local lpos = add(pos, rot(hd, lockOff))
        local toff = add(pos, rot(hd, targetOff))
        local bpos = add(pos, rot(hd, boxOff))
        t[#t+1] = {pos=pos, heading=hd, lock={pos=lpos, taken=false}, box=vector4(bpos.x, bpos.y, bpos.z, hd), containerModel=model, target=toff}
    end
    for i=-1,1 do
        local pos = add(rowB, mul(s, site.colSpacing * i))
        local hd = (h + 180.0) % 360.0
        local model = cfg_containers.ContainerModels.rowB[i+2]
        local lpos = add(pos, rot(hd, lockOff))
        local toff = add(pos, rot(hd, targetOff))
        local bpos = add(pos, rot(hd, boxOff))
        t[#t+1] = {pos=pos, heading=hd, lock={pos=lpos, taken=false}, box=vector4(bpos.x, bpos.y, bpos.z, hd), containerModel=model, target=toff}
    end
    return t, vector3(site.center.x, site.center.y, site.center.z)
end

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
end

local function loadPtfxAsset(asset)
    RequestNamedPtfxAsset(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        Wait(1)
    end
end

local function Notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) else TriggerEvent('esx:showNotification', msg) end
end

local function Progress(ms, text, cb)
    Wait(ms)
    if cb then cb() end
end

local function deleteLocalEntity(ent)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
        DeleteObject(ent)
    end
end

local function cleanupAllLocal()

    runActive   = false
    runFinished = false
    siteCenter  = nil
    local list = cfg_containers['containers'] or {}
    local count = #list
    for i = 1, math.max(count, 6) do
        deleteLocalEntity(containers[i]) containers[i] = nil
        deleteLocalEntity(locks[i]) locks[i] = nil
        deleteLocalEntity(collisions[i]) collisions[i] = nil
        if zoneIds[i] and exports.ox_target and exports.ox_target.removeZone then
            pcall(function() exports.ox_target:removeZone(zoneIds[i]) end)
            zoneIds[i] = nil
        end
        if list[i] and list[i].lock then list[i].lock.taken = false end
        deleteLocalEntity(clientContainer[i]) clientContainer[i] = nil
        deleteLocalEntity(clientLock[i]) clientLock[i] = nil
    end
    if weaponBox then
        if exports.ox_target and exports.ox_target.removeLocalEntity then
            pcall(function() exports.ox_target:removeLocalEntity(weaponBox) end)
        end
        deleteLocalEntity(weaponBox)
        weaponBox = nil
    end
    if containersBlip and DoesBlipExist(containersBlip) then
        RemoveBlip(containersBlip)
        containersBlip = nil
    end
    for i = #guardPeds, 1, -1 do
        if guardPeds[i] then
            if guardPeds[i].blip then RemoveBlip(guardPeds[i].blip) end
            deleteLocalEntity(guardPeds[i].ped)
        end
        table.remove(guardPeds, i)
    end
    crateTargetAdded = false
    rndContainer = nil
end

CreateThread(function()
    RequestModel(cfg_containers.PedModel)
    while not HasModelLoaded(cfg_containers.PedModel) do
        Wait(1)
    end
    startped = CreatePed(2, cfg_containers.PedModel, cfg_containers.StartPedLoc.x, cfg_containers.StartPedLoc.y, cfg_containers.StartPedLoc.z-1, cfg_containers.StartPedLoc.w, false, false)
    SetPedFleeAttributes(startped, 0, 0)
    SetPedDiesWhenInjured(startped, false)
    TaskStartScenarioInPlace(startped, cfg_containers.StartPedAnimation, 0, true)
    SetPedKeepTask(startped, true)
    SetBlockingOfNonTemporaryEvents(startped, true)
    SetEntityInvincible(startped, true)
    FreezeEntityPosition(startped, true)

    local startBlip = AddBlipForEntity(startped)
    AddTextEntry("BLIP_CAT_" .. BLIP_CAT_ACTIVITE_ILLEGALE, "Activité illégale")
    SetBlipSprite(startBlip, 280)
    SetBlipColour(startBlip, 1)
    SetBlipScale(startBlip, 0.9)
    SetBlipAsShortRange(startBlip, true)
    SetBlipCategory(startBlip, BLIP_CAT_ACTIVITE_ILLEGALE)
    AddTextEntry("BN_CONTAINERHEIST_INFORMATEUR", "Informateur conteneur")
    BeginTextCommandSetBlipName("BN_CONTAINERHEIST_INFORMATEUR")
    EndTextCommandSetBlipName(startBlip)

    Wait(100)
    TriggerServerEvent('jomidar-ammorobbery:sv:getCooldown')
end)

local KEY_E_A = 38
local KEY_E_B = 51

local startInFlight = false

local START_PED_INTERACT_DIST <const> = 2.8

local startPedNagAt = 0
local function canStartPedNag()
    local t = GetGameTimer()
    if startPedNagAt > 0 and (t - startPedNagAt) < 3500 then return false end
    startPedNagAt = t
    return true
end

local function formatCooldownWait(secs)
    secs = math.max(0, math.ceil(tonumber(secs) or 0))
    if secs <= 0 then
        return '~o~Braquage en cooldown. Réessaie un peu plus tard~s~.'
    end
    if secs < 60 then
        return ('~o~Braquage en cooldown. Attends ~w~%d s~o~ pour relancer.~s~'):format(secs)
    end
    local m = math.floor(secs / 60)
    local s = secs % 60
    if s == 0 then
        return ('~o~Braquage en cooldown. Reviens dans ~w~%d min~o~.~s~'):format(m)
    end
    return ('~o~Braquage en cooldown. Reviens dans ~w~%d min %d s~o~.~s~'):format(m, s)
end

local function isPressE()

    if IsControlJustPressed(0, KEY_E_A) or IsControlJustPressed(0, KEY_E_B) then return true end
    if IsDisabledControlJustPressed(0, KEY_E_A) or IsDisabledControlJustPressed(0, KEY_E_B) then return true end
    return false
end

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if startped and DoesEntityExist(startped) then
            local d = #(coords - GetEntityCoords(startped))

            if d <= 6.0 then
                sleep = 0
            end
            if d <= START_PED_INTERACT_DIST then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentString("~INPUT_CONTEXT~ Trouver un conteneur à braquer")
                EndTextCommandDisplayHelp(0, 0, 1, -1)
                if isPressE() then
                    if startInFlight and canStartPedNag() then
                        Notify("~o~Lancement de la mission en cours, patiente…~s~")
                    elseif runActive and canStartPedNag() then
                        Notify("~o~Termine d'abord le braquage en cours, puis reviens.~s~")
                    elseif not startInFlight and not runActive and getCooldownRemaining() > 0 then
                        if canStartPedNag() then
                            Notify(formatCooldownWait(getCooldownRemaining()))
                        end
                    elseif not startInFlight and not runActive then
                        startInFlight = true
                        Notify("~y~Recherche d'un conteneur en cours...")
                        TriggerEvent('jomidar-ammorobbery:cl:start')

                        SetTimeout(5000, function()
                            startInFlight = false
                        end)
                    end
                    Wait(250)
                end
            end
        end

        if sleep == 0 then
            Wait(0)
            goto continue
        end

        do
            local rndCont = rndContainer and cfg_containers['containers'] and cfg_containers['containers'][rndContainer]
            local containerOpened = rndCont and rndCont.lock and rndCont.lock.taken
            if crateTargetAdded and containerOpened and weaponBox and DoesEntityExist(weaponBox) then
                local d = #(coords - GetEntityCoords(weaponBox))

                if d <= 6.0 then sleep = 0 end
                if d <= 1.5 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentString("~INPUT_CONTEXT~ Ouvrir la caisse")
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                    if isPressE() then
                        openCrate()
                        Wait(250)
                    end
                end
            end
        end

        if sleep == 0 then
            Wait(0)
            goto continue
        end

        if cfg_containers['containers'] and #cfg_containers['containers'] > 0 then
            for k, v in pairs(cfg_containers['containers']) do
                local t = v.target
                if t and not v.lock.taken
                   and containers[k] and DoesEntityExist(containers[k])
                   and locks[k]      and DoesEntityExist(locks[k]) then
                    local d = #(coords - vector3(t.x, t.y, t.z))
                    if d <= 6.0 then sleep = 0 end
                    if d <= 1.5 then
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentString("~INPUT_CONTEXT~ Ouvrir le conteneur")
                        EndTextCommandDisplayHelp(0, 0, 1, -1)
                        if isPressE() then
                            OpenContainer(k)
                            Wait(250)
                        end
                        break
                    end
                end
            end
        end

        ::continue::
        Wait(sleep)
    end
end)

RegisterNetEvent('jomidar-ammorobbery:cl:clear')
AddEventHandler('jomidar-ammorobbery:cl:clear', function()
    cleanupAllLocal()
end)

RegisterNetEvent('jomidar-ammorobbery:cl:start')
AddEventHandler('jomidar-ammorobbery:cl:start', function()
    local remaining = getCooldownRemaining()
    if remaining > 0 then
        Notify(formatCooldownWait(remaining))
        startInFlight = false
        return
    end

    ESX.TriggerServerCallback('jomidar-ammorobbery:sv:coolc', function(isCooldown, remainingSec)
        if isCooldown then
            TriggerServerEvent('jomidar-ammorobbery:sv:getCooldown')

            local secs = (remainingSec and remainingSec > 0) and remainingSec or getCooldownRemaining()
            Notify(formatCooldownWait(secs))
            startInFlight = false
            return
        end
        TriggerServerEvent('jomidar-ammorobbery:sv:ClearSync')
    end)
end)

RegisterNetEvent('jomidar-ammorobbery:cl:clearDone')
AddEventHandler('jomidar-ammorobbery:cl:clearDone', function()
    startInFlight = false
    SetupContainers()
end)

function SetupContainers()
    setupToken = setupToken + 1
    local myToken = setupToken

    cleanupAllLocal()

    runActive = true
    runFinished = false

    local site = cfg_containers.Sites[math.random(1, #cfg_containers.Sites)]
    cfg_containers['containers'], siteCenter = buildContainersForSite(site)
    if DoesBlipExist(containersBlip) then
        RemoveBlip(containersBlip)
    end
    containersBlip = AddBlipForCoord(siteCenter.x, siteCenter.y, siteCenter.z)
    SetBlipSprite(containersBlip, 677)
    SetBlipColour(containersBlip, 1)
    SetBlipScale(containersBlip, 0.7)
    SetBlipCategory(containersBlip, BLIP_CAT_ACTIVITE_ILLEGALE)
    SetBlipRoute(containersBlip, true)
    SetBlipRouteColour(containersBlip, 1)
    AddTextEntry("BN_CONTAINERHEIST_CIBLE", "Conteneurs")
    BeginTextCommandSetBlipName("BN_CONTAINERHEIST_CIBLE")
    EndTextCommandSetBlipName(containersBlip)
    Notify('~r~Allez chercher les conteneurs marqués sur votre GPS')
    local playerPed = PlayerPedId()
    while #(GetEntityCoords(playerPed) - siteCenter) > 100.0 do
        if myToken ~= setupToken then return end
        Wait(1000)
    end
    rndContainer = math.random(1, #cfg_containers['containers'])
    if rndContainer == 1 then
        Notify('~r~Trouvez le conteneur S8B5')
    elseif rndContainer == 2 then
        Notify('~r~Trouvez le conteneur 8E7T')
    elseif rndContainer == 3 then
        Notify('~r~Trouvez le conteneur S92H')
    elseif rndContainer == 4 then
        Notify('~r~Trouvez le conteneur 9C0B')
    elseif rndContainer == 5 then
        Notify('~r~Trouvez le conteneur B09W')
    else
        Notify('~r~Trouvez le conteneur 0B06')
    end

    for k, v in pairs(cfg_containers['containers']) do
        if myToken ~= setupToken then return end
        loadModel(v.containerModel)

        containers[k] = CreateObject(GetHashKey(v.containerModel), v.pos, false, false, false)
        PlaceObjectOnGroundProperly(containers[k])
        SetEntityHeading(containers[k], v.heading)
        FreezeEntityPosition(containers[k], true)
        collisions[k] = CreateObject(GetHashKey('prop_ld_container'), v.pos, false, false, false)
        PlaceObjectOnGroundProperly(collisions[k])
        SetEntityHeading(collisions[k], v.heading)
        SetEntityVisible(collisions[k], false)
        FreezeEntityPosition(collisions[k], true)
        locks[k] = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), v.lock.pos, false, false, false)
        PlaceObjectOnGroundProperly(locks[k])
        SetEntityHeading(locks[k], v.heading)
        FreezeEntityPosition(locks[k], true)
        zoneIds[k] = nil
        Wait(50)
    end

    local boxData = cfg_containers['containers'][rndContainer].box
    weaponBox = CreateObject(GetHashKey("ex_prop_crate_ammo_sc"), vector3(boxData.x, boxData.y, boxData.z), false, false, false)
    PlaceObjectOnGroundProperly(weaponBox)
    SetEntityHeading(weaponBox, boxData.w)
    FreezeEntityPosition(weaponBox, true)

    crateTargetAdded = false
    TriggerServerEvent("jomidar-ammorobbery:sv:synctarget")

    CreateThread(function()
        Wait(15 * 60 * 1000)
        if myToken ~= setupToken then return end
        cleanupAllLocal()
    end)
end

function OpenContainer(index)
    local coords = cfg_containers['containers'][index].pos

    TriggerServerEvent("sJobs.alerteCitoyens", coords, "Un conteneur a été cambriolé", "both")

    local ped = PlayerPedId()
    local sceneObject = containers[index]
    local lockObject  = locks[index]
    if not (sceneObject and DoesEntityExist(sceneObject)) then
        Notify("Conteneur introuvable")
        return
    end
    if not (lockObject and DoesEntityExist(lockObject)) then
        Notify("Serrure introuvable")
        return
    end

    if cfg_containers['containers'][index].lock then
        cfg_containers['containers'][index].lock.taken = true
    end

    local place = GetOffsetFromEntityInWorldCoords(sceneObject, 0.0, -1.0, 0.0)
    SetEntityCoordsNoOffset(ped, place.x, place.y, place.z)
    SetEntityHeading(ped, GetEntityHeading(sceneObject))

    local animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    loadAnimDict(animDict)
    loadPtfxAsset('scr_tn_tr')

    for i = 1, #ContainerAnimation['objects'] do
        loadModel(ContainerAnimation['objects'][i])
    end

    ContainerAnimation['sceneObjects'][1] = CreateObject(GetHashKey(ContainerAnimation['objects'][1]), place, false, false, false)
    ContainerAnimation['sceneObjects'][2] = CreateObject(GetHashKey(ContainerAnimation['objects'][2]), place, false, false, false)

    local scene = CreateSynchronizedScene(GetEntityCoords(sceneObject), GetEntityRotation(sceneObject), 2, true, false, 1065353216, 0, 1065353216)
    TaskSynchronizedScene(ped, scene, animDict, ContainerAnimation['animations'][1][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
    PlaySynchronizedEntityAnim(sceneObject, scene, ContainerAnimation['animations'][1][2], animDict, 1.0, -1.0, 0, 1148846080)
    PlaySynchronizedEntityAnim(lockObject,  scene, ContainerAnimation['animations'][1][3], animDict, 1.0, -1.0, 0, 1148846080)
    PlaySynchronizedEntityAnim(ContainerAnimation['sceneObjects'][1], scene, ContainerAnimation['animations'][1][4], animDict, 1.0, -1.0, 0, 1148846080)
    PlaySynchronizedEntityAnim(ContainerAnimation['sceneObjects'][2], scene, ContainerAnimation['animations'][1][5], animDict, 1.0, -1.0, 0, 1148846080)

    Wait(4000)
    UseParticleFxAssetNextCall('scr_tn_tr')
    local sparks = StartParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", ContainerAnimation['sceneObjects'][1], 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
    Wait(1000)
    StopParticleFxLooped(sparks, 1)

    local ad = GetAnimDuration(animDict, 'action')
    if ad and ad > 0 then
        Wait(math.max(0, math.floor(ad * 1000 - 5000)))
    end

    local boxCoords = nil
    if rndContainer == index then
        local box = cfg_containers['containers'][rndContainer].box
        boxCoords = vector3(box.x, box.y, box.z)
    end
    TriggerServerEvent('jomidar-ammorobbery:sv:containerOpened', index, boxCoords)

    DeleteObject(ContainerAnimation['sceneObjects'][1])
    DeleteObject(ContainerAnimation['sceneObjects'][2])
    ClearPedTasks(ped)

    do
        local c = GetEntityCoords(sceneObject)
        local r = GetEntityRotation(sceneObject)
        local holdScene = CreateSynchronizedScene(c, r, 2, true, false, 1065353216, 0, 1065353216)
        PlaySynchronizedEntityAnim(sceneObject, holdScene, ContainerAnimation['animations'][1][2], animDict, 1.0, -1.0, 0, 1148846080)
        PlaySynchronizedEntityAnim(lockObject,  holdScene, ContainerAnimation['animations'][1][3], animDict, 1.0, -1.0, 0, 1148846080)
        ForceEntityAiAndAnimationUpdate(sceneObject)
        ForceEntityAiAndAnimationUpdate(lockObject)
        SetSynchronizedScenePhase(holdScene, 0.99)
        SetEntityCollision(sceneObject, false, true)
        FreezeEntityPosition(sceneObject, true)
        FreezeEntityPosition(lockObject, true)
    end

    if rndContainer == index then
        SpawnGuards(index)
        if containersBlip and DoesBlipExist(containersBlip) then
            RemoveBlip(containersBlip)
            containersBlip = nil
        end
    end
end

local function groundAt(v)
    local found, z = GetGroundZFor_3dCoord(v.x, v.y, v.z + 50.0, true)
    if found then return vector3(v.x, v.y, z) end
    return v
end

local GUARD_MODELS = {
    "g_m_m_chigoon_01",
    "g_m_y_lost_01",
    "g_m_y_strpunk_01",
    "g_m_m_chemwork_01",
}

local GUARD_LOADOUTS = {
    { weapon = "WEAPON_PISTOL",      ammo = 60 },
    { weapon = "WEAPON_PISTOL",      ammo = 60 },
    { weapon = "WEAPON_MICROSMG",    ammo = 90 },
    { weapon = "WEAPON_PUMPSHOTGUN", ammo = 30 },
}

function SpawnGuards(containerIndex)
    for i = #guardPeds, 1, -1 do
        if DoesEntityExist(guardPeds[i].ped) then
            RemoveBlip(guardPeds[i].blip)
            DeleteEntity(guardPeds[i].ped)
        end
        table.remove(guardPeds, i)
    end
    local base = cfg_containers['containers'][containerIndex]
    if not base then return end
    local pos = base.pos
    local hd  = base.heading
    for idx, off in ipairs(cfg_containers.GuardOffsets) do
        local w = add(pos, rot(hd, off.pos))
        w = groundAt(w)
        local modelName = GUARD_MODELS[((idx - 1) % #GUARD_MODELS) + 1]
        local model = GetHashKey(modelName)
        RequestModel(model)
        local mtimeout = GetGameTimer() + 5000
        while not HasModelLoaded(model) and GetGameTimer() < mtimeout do
            Wait(10)
        end
        if not HasModelLoaded(model) then goto skip end

        local ped = CreatePed(4, model, w.x, w.y, w.z, (hd + (off.h or 0.0)) % 360.0, false, false)

        local loadout = GUARD_LOADOUTS[((idx - 1) % #GUARD_LOADOUTS) + 1]
        GiveWeaponToPed(ped, GetHashKey(loadout.weapon), loadout.ammo, false, true)

        SetEntityAsMissionEntity(ped, true, true)

        SetPedCombatAbility(ped, 1)
        SetPedCombatRange(ped, 1)
        SetPedCombatMovement(ped, 1)
        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAttributes(ped, 5, true)
        SetPedCombatAttributes(ped, 1424, true)
        SetPedAccuracy(ped, 25)
        SetPedShootRate(ped, 60)
        SetPedFleeAttributes(ped, 0, false)

        SetPedMaxHealth(ped, 150)
        SetEntityHealth(ped, 150)

        SetPedArmour(ped, 0)

        SetPedSuffersCriticalHits(ped, true)

        SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
        TaskCombatPed(ped, PlayerPedId(), 0, 16)

        local blip = AddBlipForEntity(ped)
        SetBlipAsFriendly(blip, false)
        SetBlipCategory(blip, BLIP_CAT_ACTIVITE_ILLEGALE)
        table.insert(guardPeds, { ped = ped, blip = blip })

        SetModelAsNoLongerNeeded(model)
        ::skip::
    end
end

Citizen.CreateThread(function()
    AddRelationshipGroup("GUARDS")
    AddRelationshipGroup("PLAYER")
    SetRelationshipBetweenGroups(5, GetHashKey("GUARDS"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("GUARDS"))
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        for i = #guardPeds, 1, -1 do
            if IsPedDeadOrDying(guardPeds[i].ped, true) then
                RemoveBlip(guardPeds[i].blip)
                table.remove(guardPeds, i)
            end
        end
    end
end)

RegisterNetEvent('jomidar-ammorobbery:cl:lockSync')
AddEventHandler('jomidar-ammorobbery:cl:lockSync', function(index)
    if cfg_containers['containers'] and cfg_containers['containers'][index] then
        cfg_containers['containers'][index]['lock']['taken'] = true
    end
end)

RegisterNetEvent('jomidar-ammorobbery:cl:containerSync')
AddEventHandler('jomidar-ammorobbery:cl:containerSync', function(coords, rotation, index)
    if not (cfg_containers['containers'] and cfg_containers['containers'][index]) then return end
    local animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    loadAnimDict(animDict)
    clientContainer[index] = CreateObject(GetHashKey(cfg_containers['containers'][index].containerModel), coords, false, false, false)
    clientLock[index]      = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), coords, false, false, false)
    local clientScene = CreateSynchronizedScene(coords, rotation, 2, true, false, 1065353216, 0, 1065353216)
    PlaySynchronizedEntityAnim(clientContainer[index], clientScene, ContainerAnimation['animations'][1][2], animDict, 1.0, -1.0, 0, 1148846080)
    ForceEntityAiAndAnimationUpdate(clientContainer[index])
    PlaySynchronizedEntityAnim(clientLock[index], clientScene, ContainerAnimation['animations'][1][3], animDict, 1.0, -1.0, 0, 1148846080)
    ForceEntityAiAndAnimationUpdate(clientLock[index])
    SetSynchronizedScenePhase(clientScene, 0.99)
    SetEntityCollision(clientContainer[index], false, true)
    FreezeEntityPosition(clientContainer[index], true)
end)

RegisterNetEvent('jomidar-ammorobbery:cl:objectSync')
AddEventHandler('jomidar-ammorobbery:cl:objectSync', function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and entity ~= 0 then
        DeleteEntity(entity)
        DeleteObject(entity)
    end
end)

RegisterNetEvent('jomidar-ammorobbery:cl:objectSyncBatch')
AddEventHandler('jomidar-ammorobbery:cl:objectSyncBatch', function(ids)
    if type(ids) ~= "table" then return end
    for i = 1, #ids do
        local entity = NetworkGetEntityFromNetworkId(ids[i])
        if entity and entity ~= 0 then
            DeleteEntity(entity)
            DeleteObject(entity)
        end
    end
end)

RegisterNetEvent('jomidar-ammorobbery:cl:targetsync')
AddEventHandler('jomidar-ammorobbery:cl:targetsync', function()
    if crateTargetAdded then return end
    crateTargetAdded = true
end)

local crateOpening = false
function openCrate()
    if crateOpening then return end
    crateOpening = true

    local ped = PlayerPedId()

    local ok = lib.progressBar({
        duration   = 10000,
        label      = 'Ouverture de la caisse...',
        useWhileDead = false,
        canCancel  = true,
        distance   = 2.0,
        disable    = { move = true, car = true, combat = true },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
            flag = 49,
        },
    })

    crateOpening = false

    if ok == false then
        Notify('~r~Ouverture annulée.')
        ClearPedTasks(ped)
        return
    end

    TriggerServerEvent('Jommidar-ammorobbery:AddItem')
end

RegisterNetEvent('jomidar-ammorobbery:cl:missionEnd')
AddEventHandler('jomidar-ammorobbery:cl:missionEnd', function()
    cleanupAllLocal()
end)

local CLEANUP_DEFER_DISTANCE <const> = 200.0
local CLEANUP_DEFER_TIMEOUT  <const> = 10 * 60 * 1000

RegisterNetEvent('jomidar-ammorobbery:cl:runFinishedDeferred')
AddEventHandler('jomidar-ammorobbery:cl:runFinishedDeferred', function()
    if runFinished then return end
    runFinished = true

    runActive = false

    if not siteCenter then
        cleanupAllLocal()
        runFinished = false
        return
    end

    local center     = siteCenter
    local startedAt  = GetGameTimer()
    local startToken = setupToken

    CreateThread(function()
        while runFinished and setupToken == startToken do
            local d = #(GetEntityCoords(PlayerPedId()) - center)
            if d > CLEANUP_DEFER_DISTANCE then
                cleanupAllLocal()
                runFinished = false
                return
            end
            if GetGameTimer() - startedAt > CLEANUP_DEFER_TIMEOUT then
                cleanupAllLocal()
                runFinished = false
                return
            end
            Wait(2000)
        end
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        cleanupAllLocal()
    end
end)
