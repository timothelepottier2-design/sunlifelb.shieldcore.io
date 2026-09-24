local startPed = nil
local startBlip = nil
local victimPed
local blip
local mission = nil
local stealing = false

local function loadModel(m)
    local model = joaat(m)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    return model
end

local function notify(title, description, type)
    ESX.ShowNotification(description)
end

local function sound(name, set)
    PlaySoundFrontend(-1, name, set or 'HUD_AWARDS', true)
end

local function makePed(model, v4, frozen)
    local m = loadModel(model)
    local p = CreatePed(4, m, v4.x, v4.y, v4.z - 1.0, v4.w, false, false)
    SetEntityAsMissionEntity(p, true, true)
    SetBlockingOfNonTemporaryEvents(p, true)
    SetEntityInvincible(p, true)
    if frozen then
        FreezeEntityPosition(p, true)
        SetEntityProofs(p, true, true, true, true, true, true, true, true)
    end
    return p
end

local function clearVictim()
    if DoesBlipExist(blip) then RemoveBlip(blip) end
    if victimPed and DoesEntityExist(victimPed) then
        DeleteEntity(victimPed)
    end
    blip = nil
    victimPed = nil
end

local function makeVictimAfraid(ped, ms)
    if not ped or not DoesEntityExist(ped) then return end
    SetBlockingOfNonTemporaryEvents(ped, false)
    ClearPedTasks(ped)
    TaskCower(ped, ms or 4000)
    PlayAmbientSpeech1(ped, 'GENERIC_FRIGHTENED_HIGH', 'SPEECH_PARAMS_SHOUTED')
end

local function makeVictimFlee(ped)
    if not ped or not DoesEntityExist(ped) then return end
    SetBlockingOfNonTemporaryEvents(ped, false)
    ClearPedTasksImmediately(ped)
    SetPedKeepTask(ped, true)
    TaskSmartFleePed(ped, cache.ped, 200.0, -1, true, true)
    PlayAmbientSpeech1(ped, 'GENERIC_FRIGHTENED_HIGH', 'SPEECH_PARAMS_SHOUTED')
end

local function ensureStartPed()
    if startPed and DoesEntityExist(startPed) then return end
    startPed = makePed(cfg_bagsHeist.StartPed.model, cfg_bagsHeist.StartPed.coords, true)
    SetPedDefaultComponentVariation(startPed)
    if not DoesBlipExist(startBlip) then
        startBlip = AddBlipForEntity(startPed)
        SetBlipSprite(startBlip, 280)
        SetBlipColour(startBlip, 2)
        SetBlipScale(startBlip, 0.9)
        SetBlipAsShortRange(startBlip, true)
        AddTextEntry('BN_SUNLIFE_BAGSHEIST_1', 'Contact: Vol de sacs')
        BeginTextCommandSetBlipName('BN_SUNLIFE_BAGSHEIST_1')
        EndTextCommandSetBlipName(startBlip)
    end
    exports.ox_target:addLocalEntity(startPed, {
        {
            icon = 'fa-solid fa-bag-shopping',
            label = 'Démarrer: Vol de sacs',
            onSelect = function()
                if mission then
                    notify('Mission', 'Tu as déjà une mission en cours.', 'inform')
                    return
                end
                TriggerServerEvent('b_sac:requestStart')
                PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
        }
    })
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if startPed and DoesEntityExist(startPed) then DeleteEntity(startPed) end
    if DoesBlipExist(startBlip) then RemoveBlip(startBlip) end
    clearVictim()
end)

CreateThread(function()
    Wait(500)
    ensureStartPed()
end)

RegisterNetEvent('b_sac:begin', function(index, expireAt)
    mission = { index = index, expireAt = expireAt }
    if victimPed and DoesEntityExist(victimPed) then DeleteEntity(victimPed) end
    local v = cfg_bagsHeist.Targets[index]
    victimPed = makePed(cfg_bagsHeist.VictimPedModel, v, false)
    TaskStartScenarioInPlace(victimPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
    exports.ox_target:addLocalEntity(victimPed, {
        {
            icon = 'fa-solid fa-hand',
            label = 'Voler le sac',
            canInteract = function(entity, distance)
                return not stealing and distance <= 2.5 and mission ~= nil
            end,
            onSelect = function()
                if stealing or not mission then return end
                stealing = true
                TaskTurnPedToFaceEntity(victimPed, cache.ped, 1000)
                sound('FocusIn', 'HintCamSounds')
                makeVictimAfraid(victimPed, cfg_bagsHeist.ProgressMs + 1500)
                local ok = lib.progressCircle({
                    duration = cfg_bagsHeist.ProgressMs,
                    position = 'bottom',
                    label = 'Vol du sac en cours...',
                    useWhileDead = false,
                    canCancel = false,
                    disable = {move = true, car = true, combat = true},
                    anim = {dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer'}
                })
                if ok then
                    local pos = GetEntityCoords(victimPed)
                    TriggerServerEvent('b_sac:complete', {x = pos.x, y = pos.y, z = pos.z})
                    exports.ox_target:removeLocalEntity(victimPed)
                    makeVictimFlee(victimPed)
                else
                    stealing = false
                end
            end
        }
    })
    if cfg_bagsHeist.UseWaypoint then
        if DoesBlipExist(blip) then RemoveBlip(blip) end
        blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 514)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 0.9)
        AddTextEntry('BN_SUNLIFE_BAGSHEIST_2', 'Victime potentielle')
        BeginTextCommandSetBlipName('BN_SUNLIFE_BAGSHEIST_2')
        EndTextCommandSetBlipName(blip)
        SetNewWaypoint(v.x, v.y)
        Citizen.SetTimeout(30 * 1000, function()
            if DoesBlipExist(blip) then RemoveBlip(blip) end
        end)
    end
    notify('Mission', 'Trouve la victime et vole le sac.', 'inform')
    sound('CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET')
end)

RegisterNetEvent('b_sac:deny', function(msg)
    stealing = false
    notify('Mission', msg or 'Action impossible.', 'error')
    sound('ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
end)

RegisterNetEvent('b_sac:cooldown', function(seconds)
    notify('Mission', ('Reviens dans %ds.'):format(math.ceil(seconds)), 'warning')
    sound('ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
end)

RegisterNetEvent('b_sac:done', function(item, amount)
    stealing = false
    sound('BASE_JUMP_PASSED')
    notify('Récompense', ('Tu as reçu %dx %s.'):format(amount, item), 'success')
    Citizen.SetTimeout(5 * 1000, function()
        clearVictim()
    end)
    mission = nil
end)

RegisterNetEvent('b_sac:abort', function()
    stealing = false
    clearVictim()
    mission = nil
    notify('Mission', 'Mission expirée.', 'warning')
end)
