local ESX = exports['es_extended']:getSharedObject()
local Active = {}
local ScreenFXCount = {}
local State = {run=1.0, swim=1.0, melee=1.0, clipset=nil, clipprio=0, timecycle=nil, tcs=1.0}
local StartIndex = 0
local RunMaintainer = {active=false}

local function maybeStartRunMaintainer()
    if RunMaintainer.active then return end
    if State.run and State.run ~= 1.0 then
        RunMaintainer.active = true
        CreateThread(function()
            while RunMaintainer.active and State.run and State.run ~= 1.0 and next(Active) ~= nil do
                SetPedMoveRateOverride(PlayerPedId(), State.run)
                Wait(0)
            end
            RunMaintainer.active = false
        end)
    end
end

local function loadAnimSet(dict)
    RequestAnimSet(dict)
    while not HasAnimSetLoaded(dict) do
        Wait(0)
    end
end

local function applyShared()
    SetPedMoveRateOverride(PlayerPedId(), State.run)
    SetSwimMultiplierForPlayer(PlayerId(), State.swim)
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), State.melee)
    local ped = PlayerPedId()
    if State.clipset then
        loadAnimSet(State.clipset)
        SetPedMovementClipset(ped, State.clipset, 0.25)
        SetPedIsDrunk(ped, true)
    else
        ResetPedMovementClipset(ped, 0.25)
        SetPedIsDrunk(ped, false)
    end
    if State.timecycle then
        SetTimecycleModifier(State.timecycle)
        SetTimecycleModifierStrength(State.tcs or 1.0)
    else
        ClearTimecycleModifier()
    end
end

local function recomputeShared()
    local run, swim, melee = 1.0, 1.0, 1.0
    local clip, prio = nil, 0
    local tc, tcs, last = nil, 1.0, -1
    for name, eff in pairs(Active) do
        if eff.run and eff.run > run then run = eff.run end
        if eff.swim and eff.swim > swim then swim = eff.swim end
        if eff.melee and eff.melee > melee then melee = eff.melee end
        if eff.clipset and (eff.clipprio or 0) > prio then
            clip = eff.clipset
            prio = eff.clipprio or 0
        end
        if eff.timecycle and (eff.started or 0) > last then
            tc = eff.timecycle
            tcs = eff.tcs or 1.0
            last = eff.started or 0
        end
    end
    State.run, State.swim, State.melee = run, swim, melee
    State.clipset, State.clipprio = clip, prio
    State.timecycle, State.tcs = tc, tcs
    applyShared()
    if State.run and State.run ~= 1.0 and next(Active) ~= nil then
        maybeStartRunMaintainer()
    else
        RunMaintainer.active = false
    end
end

local function startFX(name)
    ScreenFXCount[name] = (ScreenFXCount[name] or 0) + 1
    StartScreenEffect(name, 0, true)
end

local function stopFX(name)
    local c = (ScreenFXCount[name] or 0)
    if c <= 1 then
        ScreenFXCount[name] = nil
        StopScreenEffect(name)
    else
        ScreenFXCount[name] = c - 1
    end
end

local function now()
    return GetGameTimer()
end

local function notify(msg)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(msg)
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

local function fmtDuration(ms)
    local s = math.floor(ms / 1000)
    local m = math.floor(s / 60)
    local r = s - m * 60
    return string.format("%dm%02ds", m, r)
end

local Info = {
    weed_pooch = {title="Weed", desc="Détente, légère euphorie, petits soins aléatoires"},
    badweed_pooch = {title="Mauvaise weed", desc="Désorientation, risques de chute"},
    coke_pooch = {title="Cocaïne", desc="Sprint et nage boostés, endurance régénérée"},
    badcoke_pooch = {title="Cocaïne coupée", desc="Vision floue, petites pertes de vie, risque de blackout"},
    crack_pooch = {title="Crack", desc="Accélération brutale, fin de trip chaotique possible"},
    lsd_pooch = {title="LSD", desc="Hallucinations, démarche instable"},
    ecstasy_pooch = {title="Ecstasy", desc="Léger boost global, stamina et petits soins"},
    heroine_pooch = {title="Héroïne", desc="Sédation, démarche lourde, risques de chute"},
    badheroine_pooch = {title="Héroïne coupée", desc="Perte de vie, vision trouble, blackout possible"},
    meth_pooch = {title="Méthamphétamine", desc="Sprint, mêlée et nage boostés, stamina"},
    opium_pooch = {title="Opium", desc="Relâchement, vision douce"},
    ketamine_pooch = {title="Kétamine", desc="Dissociation, chutes et blackout possibles"},
    fentanyl_pooch = {title="Fentanyl", desc="Sédation forte, perte de vie et blackout"}
}

local function notifyEffect(item, data)
    local i = Info[item]
    if not i then return end
    notify(("~b~%s~s~\nDurée: %s\nEffets: %s"):format(i.title, fmtDuration(data.duration or 0), i.desc))
end

local function startEffect(item, data)
    if Active[item] then
        Active[item].ends = now() + data.duration
        notifyEffect(item, data)
        return
    end
    StartIndex = StartIndex + 1
    local ped = PlayerPedId()
    Active[item] = {
        name=item,
        run=data.run,
        swim=data.swim,
        melee=data.melee,
        clipset=data.clipset,
        clipprio=data.clipprio,
        timecycle=data.timecycle,
        tcs=data.tcs,
        started=StartIndex,
        ends=now() + data.duration,
        tick=data.tick,
        ft=data.ft,
        onend=data.onend,
        fxs=data.fxs or {}
    }
    for _, fx in ipairs(Active[item].fxs) do
        startFX(fx)
    end
    if data.onstart then data.onstart(ped) end
    recomputeShared()
    notifyEffect(item, data)
    maybeStartRunMaintainer()
    CreateThread(function()
        while Active[item] and now() < Active[item].ends do
            if Active[item].ft then Active[item].ft(PlayerPedId()) end
            if Active[item].tick and Active[item].tick > 0 then
                Wait(Active[item].tick)
            else
                Wait(500)
            end
        end
        if not Active[item] then return end
        local fxlist = Active[item].fxs
        local onend = Active[item].onend
        Active[item] = nil
        for _, fx in ipairs(fxlist) do
            stopFX(fx)
        end
        if onend then onend(PlayerPedId()) end
        recomputeShared()
    end)
end

local function randomRagdoll(p, chance, tmin, tmax)
    if math.random() < chance then
        SetPedToRagdoll(p, math.random(tmin, tmax), math.random(tmin, tmax), 0, false, false, false)
    end
end

local function healSmall(p, amount)
    local h = GetEntityHealth(p)
    SetEntityHealth(p, math.min(200, h + amount))
end

local function damageSmall(p, amount)
    local h = GetEntityHealth(p)
    SetEntityHealth(p, math.max(100, h - amount))
end

local function blackout(ms)
    DoScreenFadeOut(500)
    Wait(ms)
    DoScreenFadeIn(800)
end

local function crashSlow(ms)
    local old = {clip=State.clipset, pr=State.clipprio, tc=State.timecycle}
    State.clipset = "move_m@drunk@verydrunk"
    State.clipprio = 99
    State.timecycle = "drug_drive_blend01"
    State.tcs = 1.0
    applyShared()
    Wait(ms)
    State.clipset = old.clip
    State.clipprio = old.pr
    State.timecycle = old.tc
    applyShared()
end

local Items = {}

Items["weed_pooch"] = function()
    local d = {
        duration=180000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@slightlydrunk",
        clipprio=1,
        timecycle="Barry1_Stoned",
        tcs=0.8,
        fxs={"SuccessMichael"},
        tick=2000,
        ft=function(p)
            if math.random(100) < 5 then healSmall(p, 1) end
        end
    }
    startEffect("weed_pooch", d)
end

Items["badweed_pooch"] = function()
    local d = {
        duration=120000,
        clipset="move_m@drunk@verydrunk",
        clipprio=2,
        timecycle="drug_drive_blend01",
        tcs=1.0,
        fxs={"ChopVision"},
        tick=2000,
        ft=function(p)
            if math.random(100) < 15 then randomRagdoll(p, 1.0, 800, 1400) end
        end
    }
    startEffect("badweed_pooch", d)
end

Items["coke_pooch"] = function()
    local d = {
        duration=120000,
        run=1.49,
        swim=1.3,
        melee=1.1,
        timecycle="spectator5",
        tcs=0.6,
        fxs={"DrugsTrevorClownsFight"},
        tick=1500,
        ft=function(p)
            RestorePlayerStamina(PlayerId(), 1.0)
        end,
        onend=function(p)
            crashSlow(15000)
        end
    }
    startEffect("coke_pooch", d)
end

Items["badcoke_pooch"] = function()
    local d = {
        duration=90000,
        run=1.1,
        swim=1.0,
        melee=1.0,
        timecycle="hud_def_blur",
        tcs=0.7,
        fxs={"DrugsTrevorClownsFight"},
        tick=1000,
        ft=function(p)
            damageSmall(p, 1)
            if math.random(100) < 8 then blackout(1200) end
        end
    }
    startEffect("badcoke_pooch", d)
end

Items["crack_pooch"] = function()
    local d = {
        duration=100000,
        run=1.35,
        swim=1.2,
        melee=1.0,
        timecycle="spectator5",
        tcs=0.8,
        fxs={"HeistLocate"},
        tick=1000,
        ft=function(p)
            RestorePlayerStamina(PlayerId(), 1.0)
        end,
        onend=function(p)
            if math.random(100) < 50 then crashSlow(8000) end
        end
    }
    startEffect("crack_pooch", d)
end

Items["lsd_pooch"] = function()
    local d = {
        duration=180000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@verydrunk",
        clipprio=3,
        timecycle="DrugsMichaelAliensFight",
        tcs=1.0,
        fxs={"DrugsMichaelAliensFight"},
        tick=1200,
        ft=function(p)
            if math.random(100) < 12 then randomRagdoll(p, 1.0, 600, 1200) end
        end
    }
    startEffect("lsd_pooch", d)
end

Items["ecstasy_pooch"] = function()
    local d = {
        duration=180000,
        run=1.1,
        swim=1.1,
        melee=1.0,
        timecycle="spectator6",
        tcs=0.7,
        fxs={"HeistCelebPass"},
        tick=1500,
        ft=function(p)
            RestorePlayerStamina(PlayerId(), 1.0)
            if math.random(100) < 10 then healSmall(p, 1) end
        end
    }
    startEffect("ecstasy_pooch", d)
end

Items["heroine_pooch"] = function()
    local d = {
        duration=240000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@verydrunk",
        clipprio=3,
        timecycle="drug_drive_blend01",
        tcs=1.0,
        fxs={"DrugsDrivingIn"},
        tick=2000,
        ft=function(p)
            if math.random(100) < 6 then randomRagdoll(p, 1.0, 1000, 1600) end
        end
    }
    startEffect("heroine_pooch", d)
end

Items["badheroine_pooch"] = function()
    local d = {
        duration=90000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@verydrunk",
        clipprio=4,
        timecycle="hud_def_blur",
        tcs=1.0,
        fxs={"DeathFailOut"},
        tick=900,
        ft=function(p)
            damageSmall(p, 2)
            if math.random(100) < 18 then blackout(1500) end
        end
    }
    startEffect("badheroine_pooch", d)
end

Items["meth_pooch"] = function()
    local d = {
        duration=240000,
        run=1.35,
        swim=1.2,
        melee=1.35,
        timecycle="spectator4",
        tcs=0.7,
        fxs={"Rampage"},
        tick=1200,
        ft=function(p)
            RestorePlayerStamina(PlayerId(), 1.0)
        end
    }
    startEffect("meth_pooch", d)
end

Items["opium_pooch"] = function()
    local d = {
        duration=240000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@slightlydrunk",
        clipprio=2,
        timecycle="Barry1_Stoned",
        tcs=0.9,
        fxs={"HeistLocate"},
        tick=2000
    }
    startEffect("opium_pooch", d)
end

Items["ketamine_pooch"] = function()
    local d = {
        duration=120000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@verydrunk",
        clipprio=4,
        timecycle="drug_drive_blend01",
        tcs=1.0,
        fxs={"DrugsTransitionOut"},
        tick=1000,
        ft=function(p)
            if math.random(100) < 20 then randomRagdoll(p, 1.0, 700, 1300) end
            if math.random(100) < 10 then blackout(800) end
        end
    }
    startEffect("ketamine_pooch", d)
end

Items["fentanyl_pooch"] = function()
    local d = {
        duration=60000,
        run=1.0,
        swim=1.0,
        melee=1.0,
        clipset="move_m@drunk@verydrunk",
        clipprio=5,
        timecycle="hud_def_blur",
        tcs=1.0,
        fxs={"DrugsDrivingIn"},
        tick=700,
        ft=function(p)
            damageSmall(p, 3)
            if math.random(100) < 25 then blackout(1200) end
        end
    }
    startEffect("fentanyl_pooch", d)
end

RegisterNetEvent('bigfoda:drugs:use', function(item)
    local fn = Items[item]
    if fn then fn() end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Active) do
        Active[k] = nil
    end
    for fx, _ in pairs(ScreenFXCount) do
        StopScreenEffect(fx)
        ScreenFXCount[fx] = nil
    end
    State = {run=1.0, swim=1.0, melee=1.0, clipset=nil, clipprio=0, timecycle=nil, tcs=1.0}
    RunMaintainer.active = false
    applyShared()
end)
