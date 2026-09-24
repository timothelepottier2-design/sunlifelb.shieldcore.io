local Config = GangConfig
ESX = exports["es_extended"]:getSharedObject()

local HitmanState = nil
local HitmanCooldowns = { dangerous_delivery = 0, hitman = 0 }

local HitmanBlip = nil
local SpawnedNetIds = {}
local ReportedDead = {}
local SpawnRequested = false
local PedBlips = {}

local function clearPedBlips()
    for nid, blip in pairs(PedBlips) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    PedBlips = {}
end

local function ensurePedBlipForNetId(nid)
    nid = tonumber(nid)
    if not nid or nid <= 0 then
        return
    end

    if PedBlips[nid] and DoesBlipExist(PedBlips[nid]) then
        return
    end

    local ent = NetworkGetEntityFromNetworkId(nid)
    if not ent or not DoesEntityExist(ent) then
        return
    end

    local blip = AddBlipForEntity(ent)
    if not blip or blip == 0 then
        return
    end

    SetBlipSprite(blip, 432)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)

    local _key = "BN_SNL_GANGBUILDER_HIT_1_" .. tostring(blip)
    AddTextEntry(_key, "Assaillant")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(blip)

    PedBlips[nid] = blip
end

local function removePedBlipForNetId(nid)
    nid = tonumber(nid)
    if not nid or nid <= 0 then
        return
    end

    local blip = PedBlips[nid]
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
    PedBlips[nid] = nil
end

local function vecToTable(v)
    if type(v) == "vector3" then
        return { x = v.x, y = v.y, z = v.z }
    end
    if type(v) == "table" and type(v.x) == "number" and type(v.y) == "number" and type(v.z) == "number" then
        return { x = v.x, y = v.y, z = v.z }
    end
    return nil
end

local function dist(a, b)
    if not a or not b then
        return 999999.0
    end
    local ax, ay, az = tonumber(a.x), tonumber(a.y), tonumber(a.z)
    local bx, by, bz = tonumber(b.x), tonumber(b.y), tonumber(b.z)
    if not ax or not ay or not az or not bx or not by or not bz then
        return 999999.0
    end
    local dx = ax - bx
    local dy = ay - by
    local dz = az - bz
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function ensureBlip(pos)
    if not pos then
        return
    end

    if HitmanBlip and DoesBlipExist(HitmanBlip) then
        SetBlipCoords(HitmanBlip, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
        return
    end

    HitmanBlip = AddBlipForCoord(pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
    SetBlipSprite(HitmanBlip, 303)
    SetBlipScale(HitmanBlip, 0.9)
    SetBlipColour(HitmanBlip, 1)
    SetBlipAsShortRange(HitmanBlip, false)
    local _key = "BN_SNL_GANGBUILDER_HIT_2_" .. tostring(HitmanBlip)
    AddTextEntry(_key, "Tueur à gage")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(HitmanBlip)
end

local function clearBlip()
    if HitmanBlip and DoesBlipExist(HitmanBlip) then
        RemoveBlip(HitmanBlip)
    end
    HitmanBlip = nil
end

local function getIsStarter(st)
    if not st then
        return false
    end
    local mySid = GetPlayerServerId(PlayerId())
    return tonumber(st.starter_src) == tonumber(mySid)
end

local function requestModel(model)
    local h = GetHashKey(model)
    if not IsModelInCdimage(h) then
        return nil
    end
    RequestModel(h)
    local t = GetGameTimer() + 7000
    while not HasModelLoaded(h) and GetGameTimer() < t do
        Wait(0)
    end
    if not HasModelLoaded(h) then
        return nil
    end
    return h
end

local function setupRelations()
    local enemy = GetHashKey("GB_HITMAN_ENEMY")
    AddRelationshipGroup("GB_HITMAN_ENEMY")
    SetRelationshipBetweenGroups(5, enemy, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), enemy)
    return enemy
end

RegisterNetEvent("gangbuilder:activities:sync", function(payload)
    if type(payload) ~= "table" then
        return
    end

    if type(payload.cooldowns) == "table" then
        HitmanCooldowns.dangerous_delivery = tonumber(payload.cooldowns.dangerous_delivery or 0) or 0
        HitmanCooldowns.hitman = tonumber(payload.cooldowns.hitman or 0) or 0
    end

    local st = payload.state
    HitmanState = st

    if not st or type(st) ~= "table" then
        SpawnRequested = false
        clearBlip()
        clearPedBlips()
        return
    end

    if st.activity ~= "hitman" or st.finished == true then
        SpawnRequested = false
        clearBlip()
        clearPedBlips()
        return
    end

    local loc = vecToTable(st.location)
    if loc then
        ensureBlip(loc)
    end

    if type(st.ped_netids) == "table" then
        for i = 1, #st.ped_netids do
            local nid = tonumber(st.ped_netids[i])
            if nid then
                local killed = false
                if type(st.ped_killed) == "table" then
                    killed = (st.ped_killed[nid] == true)
                end

                if killed then
                    removePedBlipForNetId(nid)
                else
                    ensurePedBlipForNetId(nid)
                end
            end
        end
    end
end)

RegisterNetEvent("gangbuilder:activities:hitmanPedKilledRelay", function(payload)
    if type(payload) ~= "table" then
        return
    end
    local nid = tonumber(payload.nid)
    if not nid then
        return
    end

    if type(HitmanState) == "table" then
        if type(HitmanState.ped_killed) == "table" then
            HitmanState.ped_killed[nid] = true
        end
        local killed = tonumber(payload.killed)
        if killed then
            HitmanState.peds_killed = killed
        end
    end

    removePedBlipForNetId(nid)
end)

RegisterNetEvent("gangbuilder:activities:hitmanSpawnPeds", function(data)
    if type(data) ~= "table" then
        return
    end

    local loc = vecToTable(data.location)
    if not loc then
        return
    end

    local count = tonumber(data.count) or 10
    if count < 1 then
        count = 1
    end
    if count > 32 then
        count = 32
    end

    local radius = tonumber(data.spawn_radius) or 18.0
    local models = type(data.ped_models) == "table" and data.ped_models or {}
    local weapon = tostring(data.weapon or "WEAPON_PISTOL")

    SpawnedNetIds = {}
    ReportedDead = {}

    local enemyGroup = setupRelations()

    for i = 1, count do
        local model = models[math.random(1, #models)] or "g_m_y_mexgoon_01"
        local mh = requestModel(model)
        if mh then
            local ang = math.random() * 6.283185307
            local r = math.random() * radius
            local x = loc.x + math.cos(ang) * r
            local y = loc.y + math.sin(ang) * r
            local z = loc.z

            print(('^6[NETDIAG][PED]^7 %s hitman.lua:268 CreatePed NETWORKED hitman-ped model=%s'):format(GetCurrentResourceName(), tostring(mh)))
            local ped = CreatePed(4, mh, x + 0.0, y + 0.0, z + 0.0, math.random(0, 359) + 0.0, true, true)
            if DoesEntityExist(ped) then
                print(('^6[NETDIAG][PED]^7 %s hitman.lua:270 NetworkRegisterEntityAsNetworked(ped)'):format(GetCurrentResourceName()))
                NetworkRegisterEntityAsNetworked(ped)
                local nid = NetworkGetNetworkIdFromEntity(ped)

                SetNetworkIdCanMigrate(nid, true)

                SetEntityAsMissionEntity(ped, true, true)
                SetPedRelationshipGroupHash(ped, enemyGroup)

                GiveWeaponToPed(ped, GetHashKey(weapon), 250, false, true)
                SetCurrentPedWeapon(ped, GetHashKey(weapon), true)

                SetPedAlertness(ped, 3)
                SetPedCombatAbility(ped, 2)
                SetPedCombatRange(ped, 2)
                SetPedCombatMovement(ped, 2)
                SetPedAccuracy(ped, 30)
                SetPedArmour(ped, 25)
                SetPedCanSwitchWeapon(ped, true)

                TaskCombatHatedTargetsAroundPed(ped, 60.0)

                SpawnedNetIds[#SpawnedNetIds + 1] = nid
                ensurePedBlipForNetId(nid)
                ReportedDead[nid] = false
            end

            SetModelAsNoLongerNeeded(mh)
        end
    end

    TriggerServerEvent("gangbuilder:activities:hitmanPedsSpawned", SpawnedNetIds)
end)

CreateThread(function()
    while true do
        Wait(500)

        if not HitmanState or type(HitmanState) ~= "table" then
            goto continue
        end

        if HitmanState.activity ~= "hitman" or HitmanState.finished == true then
            goto continue
        end

        local isStarter = getIsStarter(HitmanState)
        local loc = vecToTable(HitmanState.location)
        if isStarter and loc and SpawnRequested == false and HitmanState.spawned ~= true then
            local p = GetEntityCoords(PlayerPedId())
            local d = dist({ x = p.x, y = p.y, z = p.z }, loc)
            local tr = tonumber((Config and Config.Activities and Config.Activities.Hitman and Config.Activities.Hitman.trigger_radius) or 35.0) or 35.0
            if d <= tr then
                SpawnRequested = true
                TriggerServerEvent("gangbuilder:activities:hitmanArrived", { x = p.x, y = p.y, z = p.z })
            end
        end

        ::continue::
    end
end)

CreateThread(function()
    while true do
        Wait(350)

        if type(SpawnedNetIds) ~= "table" or #SpawnedNetIds == 0 then
            goto continue
        end

        for i = 1, #SpawnedNetIds do
            local nid = tonumber(SpawnedNetIds[i])
            if nid and ReportedDead[nid] == false then
                local ent = NetworkGetEntityFromNetworkId(nid)
                if ent and DoesEntityExist(ent) then
                    if IsEntityDead(ent) then
                        ReportedDead[nid] = true
                        removePedBlipForNetId(nid)
                        TriggerServerEvent("gangbuilder:activities:hitmanPedKilled", nid)
                    end
                else
                    ReportedDead[nid] = true
                    removePedBlipForNetId(nid)
                    TriggerServerEvent("gangbuilder:activities:hitmanPedKilled", nid)
                end
            end
        end

        ::continue::
    end
end)
