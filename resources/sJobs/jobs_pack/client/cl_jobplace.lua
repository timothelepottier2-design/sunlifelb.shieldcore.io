JobsPackBossPeds = JobsPackBossPeds or {}

function JobsPackSpawnBossPed(coords, heading, model, scenario)
    Citizen.CreateThread(function()
        local hash = (type(model) == 'number') and model or GetHashKey(model or `s_m_y_gardener_01`)
        RequestModel(hash)
        local timeout = 0
        while not HasModelLoaded(hash) and timeout < 200 do
            Citizen.Wait(10)
            timeout = timeout + 1
        end
        if not HasModelLoaded(hash) then return end

        local spawnZ = coords.z + 1.0
        local ped = CreatePed(4, hash, coords.x, coords.y, spawnZ, heading or 0.0, false, true)
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, spawnZ, false, false, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdoll(ped, false)
        SetPedDiesWhenInjured(ped, false)
        if scenario then
            TaskStartScenarioInPlace(ped, scenario, 0, true)
        end
        SetModelAsNoLongerNeeded(hash)
        JobsPackBossPeds[#JobsPackBossPeds + 1] = ped
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, ped in ipairs(JobsPackBossPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    JobsPackBossPeds = {}
end)
