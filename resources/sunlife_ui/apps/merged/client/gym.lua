local Config = GymConfig

local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'merged', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'merged', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('merged/' .. name, cb)
end

local spots = {}
local inSession = false
local nextAllowed = 0
local stats = { strength = 0, speed = 0, stamina = 0 }

local function GetGymStats()
    return {
        strength = stats.strength or 0,
        speed = stats.speed or 0,
        stamina = stats.stamina or 0
    }
end

exports('GetGymStats', GetGymStats)

local function drawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.32, 0.32)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextCentre(1)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local function applyBuffs()
    local pid = PlayerId()
    local melee = Config.Buffs.meleeDamage.base + (Config.Buffs.meleeDamage.max - Config.Buffs.meleeDamage.base) * (stats.strength / Config.Max.strength)
    SetPlayerMeleeWeaponDamageModifier(pid, melee)
    local run = Config.Buffs.runMultiplier.base + (Config.Buffs.runMultiplier.max - Config.Buffs.runMultiplier.base) * (stats.speed / Config.Max.speed)
    SetRunSprintMultiplierForPlayer(pid, run)
    local tick = Config.Buffs.staminaTick.base + (Config.Buffs.staminaTick.max - Config.Buffs.staminaTick.base) * (stats.stamina / Config.Max.stamina)
    return tick
end

CreateThread(function()
    local blip = AddBlipForCoord(-1216.2835693359, -1571.1938476562, 4.6022572517395)
    SetBlipSprite(blip, 546)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 36)
    SetBlipAsShortRange(blip, true)

    AddTextEntry("BN_SUNLIFE_MERGED_GYM_1", "Salle de sport")
    BeginTextCommandSetBlipName("BN_SUNLIFE_MERGED_GYM_1")
    EndTextCommandSetBlipName(blip)
  while true do
    local tick = applyBuffs()
    if tick > 0.0 then
      RestorePlayerStamina(PlayerId(), tick)
    end
    Wait(1000)
  end
end)

RegisterNetEvent('sunlife:gym:setSpots', function(list)
    spots = list or {}
end)

RegisterNetEvent('sunlife:gym:applyStats', function(s)
    stats = s or stats
    local avg = math.floor((stats.strength + stats.speed + stats.stamina) / 3)
    SendNUIMessage({ action = 'gym:set', on = true, label = 'Musculation', percent = avg })
end)

RegisterNetEvent('sunlife:gym:notify', function(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end)

CreateThread(function()
    Wait(3000)
    TriggerServerEvent('sunlife:gym:requestSpots')
    TriggerServerEvent('sunlife:gym:ensureRow')
end)

local function startScenario(ped, sp)
    if sp.type == 'pushups' then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_PUSH_UPS', 0, true)
    elseif sp.type == 'situps' then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SIT_UPS', 0, true)
    else
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS', 0, true)
    end
end

local function stopScenario(ped)
    ClearPedTasksImmediately(ped)
end

local function StartWorkout(sp)
    local ped = PlayerPedId()
    inSession = true
    nextAllowed = GetGameTimer() + Config.SessionMs + Config.CooldownMs
    startScenario(ped, sp)
    local startAt = GetGameTimer()
    while GetGameTimer() - startAt < Config.SessionMs do
        Wait(100)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
    end
    stopScenario(ped)
    inSession = false
    TriggerServerEvent('sunlife:gym:saveGain', Config.Gain)
    TriggerEvent('sunlife:gym:notify', '~o~Séance terminée~s~. Progrès sauvegardé.')
end

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for _, sp in ipairs(spots) do
            local dist = #(pcoords - vector3(sp.pos.x, sp.pos.y, sp.pos.z))
            if dist < 25.0 then
                wait = 0
                DrawMarker(Config.Marker.type, sp.pos.x, sp.pos.y, sp.pos.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a, false, true, 2, false, nil, nil, false)
                if dist <= (sp.radius or 1.6) then
                    drawText3D(sp.pos.x, sp.pos.y, sp.pos.z + 0.2, '~o~' .. (sp.label or 'Workout') .. '~s~\n~w~[E] Commencer')
                    if IsControlJustReleased(0, Config.InteractKey) and not inSession and GetGameTimer() > nextAllowed then
                        StartWorkout(sp)
                    end
                end
            end
        end
        Wait(wait)
    end
end)
