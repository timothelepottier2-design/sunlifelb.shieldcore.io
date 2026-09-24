local ESX = exports["es_extended"]:getSharedObject()

local SpawnedPeds = {}

local function ensureModel(model)
    local hash = joaat(model)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        return nil
    end
    RequestModel(hash)
    local timeout = GetGameTimer() + 8000
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() > timeout then
            return nil
        end
    end
    return hash
end

local function spawnNpcForPoint(p)
    if not p.npc or not p.npc.model or not p.npc.coords then
        return
    end

    if SpawnedPeds[p.id] and DoesEntityExist(SpawnedPeds[p.id]) then
        return
    end

    local hash = ensureModel(p.npc.model)
    if not hash then
        return
    end

    local ped = CreatePed(4, hash, p.npc.coords.x, p.npc.coords.y, p.npc.coords.z - 1.0, p.npc.heading or 0.0, false, true)
    if not ped or ped == 0 then
        return
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetPedCanRagdoll(ped, false)

    if p.npc.scenario and p.npc.scenario ~= "" then
        TaskStartScenarioInPlace(ped, p.npc.scenario, 0, true)
    end

    SpawnedPeds[p.id] = ped

    exports.ox_target:addLocalEntity(ped, {
        {
            name = ("bam_parajumps_npc_%s"):format(p.id),
            icon = "fa-solid fa-parachute-box",
            label = ("%s ($%d)"):format(p.label, p.price),
            distance = 2.0,
            onSelect = function()
                TriggerServerEvent("bam_parajumps:server:buyJump", p.id)
            end
        }
    })
end

local function createBlips()
    for i = 1, #cfg_basejump.JumpPoints do
        local p = cfg_basejump.JumpPoints[i]
        if p.blip then
            local c = (p.npc and p.npc.coords) and p.npc.coords or p.enter
            local b = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(b, p.blip.sprite or 94)
            SetBlipScale(b, p.blip.scale or 0.85)
            SetBlipColour(b, p.blip.color or 2)
            SetBlipAsShortRange(b, true)
            local _key = "BN_SUNLIFE_BASEJUMP_1_" .. tostring(i)
            AddTextEntry(_key, p.label or "Saut Parachute")
            BeginTextCommandSetBlipName(_key)
            EndTextCommandSetBlipName(b)
        end
    end
end

local function giveParachute(ped)
    GiveWeaponToPed(ped, joaat("GADGET_PARACHUTE"), 1, false, true)
    SetPedGadget(ped, joaat("GADGET_PARACHUTE"), true)
end

local function doJump(p)
    local ped = PlayerPedId()

    DoScreenFadeOut(450)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    ClearPedTasksImmediately(ped)
    SetEntityCoordsNoOffset(ped, p.spawn.x, p.spawn.y, p.spawn.z, false, false, false)
    SetEntityHeading(ped, p.spawnHeading or 0.0)
    FreezeEntityPosition(ped, true)

    Wait(250)

    giveParachute(ped)

    FreezeEntityPosition(ped, false)
    DoScreenFadeIn(450)

    Wait(650)

    if not IsPedInAnyVehicle(ped, false) and not IsPedRagdoll(ped) then
        ForcePedToOpenParachute(ped)
    end
end

RegisterNetEvent("bam_parajumps:client:startJump", function(point)
    if type(point) ~= "table" or not point.spawn or not point.enter then
        return
    end
    doJump(point)
    TriggerServerEvent("snl_quest:triggerComplete", "parachute_jump")
end)

CreateThread(function()
    Wait(500)
    createBlips()

    for i = 1, #cfg_basejump.JumpPoints do
        spawnNpcForPoint(cfg_basejump.JumpPoints[i])
    end
end)
