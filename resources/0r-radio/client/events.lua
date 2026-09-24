playerSpawned = false
RADIO = {}
RADIO.PlayerList = {}

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    local startTime = GetGameTimer()
    while not CoreReady do 
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    while not playerSpawned do 
        Citizen.Wait(100)
        if GetGameTimer() - startTime > 5000 then
            break
        end
    end
    PlayerData = GetPlayerData()
    gPlayer.hasRadio = hasRadioItem()
    leaveRadio()
    -- Non répliqué : flag local uniquement (évite un statebag client->serveur).
    -- print(('^3[NETDIAG][STATEBAG]^7 %s events.lua:26 LocalPlayer.state:set isLoggedIn (NON-replicated)'):format(GetCurrentResourceName()))
    LocalPlayer.state:set('isLoggedIn', true, false)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    leaveRadio()
    resetPlayer()
end)

AddEventHandler("esx:onPlayerDeath", function()
    gPlayer.isDead = true
    if gPlayer.onRadio then
        gPlayer.lastChannel = 0
        leaveRadio()
        notify(_t("leave_channel"), "error")
        toggleRadio(false)
        SendReactMessage("resetRadio")
    end
end)

AddEventHandler("esx:onPlayerSpawn", function()
    gPlayer.isDead = false
    Wait(1000)
    PlayerData =  GetPlayerData()
    gPlayer.hasRadioItem = hasRadioItem()
    playerSpawned = true
    print("ESX player spawned.")
end)

RegisterNetEvent('rems:revive')
AddEventHandler('rems:revive', function()
    gPlayer.isDead = false
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    Wait(1000)
    PlayerData = xPlayer
    gPlayer.hasRadioItem = hasRadioItem()
    playerSpawned = true
    print("ESX player spawned.")
end)

AddEventHandler("playerSpawned", function()
    Wait(1000)
    PlayerData = GetPlayerData()
    gPlayer.hasRadioItem = hasRadioItem()
    playerSpawned = true
    print("ESX player spawned.")
end)

RegisterNetEvent("0R-radio:client:playerUnLoaded", function()
    Wait(1000)
    resetPlayer()
end)

RegisterNetEvent("esx:affiliateJob", function(job, lastJob)
    PlayerData.job.name = job.name
end)

RegisterNetEvent('0R-radio:use-radio', function()
    if not Config.CheckIsDead() then
        if not playerSpawned then
            playerSpawned = true
        end
        toggleRadio(not gPlayer.isMenuOpen)
        Wait(100)
        if not gHasBootAnimation then
            gHasBootAnimation = true
        end
    end
end)

RegisterNetEvent('0R-radio:use-jammer', function(item)
    if Config.JammerSettings.enable_jobs then
        local jobName = PlayerData.job.name
        if Config.JammerSettings.restricted_jobs[jobName] then
            local closestDistance, _ = checkDistanceForJammers(gSpawnedJammerObjects)
            if closestDistance == -1 then
                Core.Progressbar(_t("jammer_place_object"), 2500, {
                    FreezePlayer = true,
                    animation = {
                        type = "anim",
                        dict = "anim@mp_player_intmenu@key_fob@",
                        lib = "fob_click"
                    },
                    onFinish = function()
                        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
                        TriggerServerEvent("0R-radio:server:SpawnJammerObject", Config.JammerSettings.object)
                    end,
                    onCancel = function()
                        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
                        notify(_t("jammer_cancel_place_object"), "error")
                    end
                })
            else
                notify(_t("jammer_min_distance_error"), "error")
            end
        else
            notify(_t("jammer_restricted_jobs"), "error")
        end
    else
        local closestDistance, _ = checkDistanceForJammers(gSpawnedJammerObjects)
        if closestDistance == -1 then
            TriggerServerEvent("0R-radio:server:SpawnJammerObject", Config.JammerSettings.object)
        else
            notify(_t("jammer_min_distance_error"), "error")
        end
    end
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
    gPlayer.hasRadio = hasRadioItem()
    if not gPlayer.hasRadio then
        leaveRadio()
        resetPlayer()
        SendReactMessage("resetRadio")
        if gPlayer.onRadio then
            notify(_t('leave_channel'), 'error')
        end
    end
end)

RegisterNetEvent('0R-radio:client:SpawnJammerObject', function(objectId, model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local x, y, z = table.unpack(coords + forward * 2)
    print(('^2[NETDIAG][OBJET]^7 %s events.lua:158 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local spawnedObj = CreateObject(model, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    SetEntityInvincible(spawnedObj, true)
    FreezeEntityPosition(spawnedObj, true)
    local spawnedObjData = {
        object = spawnedObj,
        coords = vector3(x, y, z - 0.3),
    }
    TriggerServerEvent('0R-radio:server:SetJammerObject', objectId, spawnedObjData)
end)

-- NB : le handler '0R-radio:client:SetJammerObjects' est defini dans
-- loops.lua (version qui renseigne le champ `id` requis par la logique de
-- suppression). On evite ici un second handler en doublon qui traitait
-- chaque update deux fois avec une structure incoherente.

RegisterNetEvent('0R-radio:client:RemoveJammerObject', function(objectId)
    local obj = gSpawnedJammerObjects[objectId]
    if obj then
        SetEntityInvincible(obj, false)
        FreezeEntityPosition(obj, false)
        NetworkRequestControlOfEntity(obj.object)
        DeleteObject(obj.object)
        gSpawnedJammerObjects[objectId] = nil
    end
end)

-- Liste des membres du channel : fonctionnalite retiree (trop couteuse
-- a 800 joueurs). Plus aucun handler de reception ni callback serveur.
-- La NUI recoit une liste vide depuis connectToRadio/leaveRadio.

RegisterCommand("radio", function()
    if gPlayer.hasRadio then
        toggleRadio(not gPlayer.isMenuOpen)
    end
end)

RegisterKeyMapping("radio", "Sortir la radio", "keyboard", Config.RadioToggleKey)