local inBmx = false

local function attachPlayerToBMX(bmx, position, animDict, animClip)
    if inBmx then
        return
    end

    inBmx = true
    local ped = PlayerPedId()

    loadDict(animDict)
    AttachEntityToEntity(ped, bmx, GetEntityBoneIndexByName(bmx, "chassis"), position.x, position.y, position.z, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, animDict, animClip, 8.0, 8.0, -1, 1, 1, 0, 0, 0)

    CreateThread(function()
        while inBmx do
            Wait(0)
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour descendre du BMX")
            if IsControlJustPressed(0, 38) then
                detachPlayerFromBMX()
                break
            end
        end
    end)
end

function detachPlayerFromBMX()
    if not inBmx then
        return
    end

    local ped = PlayerPedId()
    inBmx = false
    DetachEntity(ped)
    ClearPedTasks(ped)
end

exports.ox_target:addModel("fernocot", {
    {
        name = 'use_brancard',
        icon = 'fa-solid fa-ambulance',
        label = 'Utiliser le brancard',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            return ESX.PlayerData.job and ESX.PlayerData.job.name == "ems"
        end,
        onSelect = function(data)
            ExecuteCommand("pushstr")
        end
    },
    {
        name = 'delete_brancard',
        icon = 'fa-solid fa-box-archive',
        label = 'Ranger le brancard',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            return ESX.PlayerData.job and ESX.PlayerData.job.name == "ems"
        end,
        onSelect = function(data)
            -- Suppression cote serveur (sJobs/rems) : marche meme si le
            -- brancard a ete pose par un autre EMS.
            TriggerServerEvent("rems:storeEntity", NetworkGetNetworkIdFromEntity(data.entity))
        end
    },
})

-- Fauteuil roulant (vehicule "wheelchair" sorti par le menu EMS).
exports.ox_target:addModel("wheelchair", {
    {
        name = 'store_wheelchair',
        icon = 'fa-solid fa-box-archive',
        label = 'Ranger le fauteuil roulant',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            if not (ESX.PlayerData.job and ESX.PlayerData.job.name == "ems") then return false end
            return GetPedInVehicleSeat(entity, -1) == 0
        end,
        onSelect = function(data)
            TriggerServerEvent("rems:storeEntity", NetworkGetNetworkIdFromEntity(data.entity))
        end
    },
})

exports.ox_target:addModel("bmx", {
    {
        name = 'front_bmx',
        icon = 'fas fa-bicycle',
        label = 'Monter sur le guidon',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            local driver = GetPedInVehicleSeat(entity, -1)
            return driver ~= 0
        end,
        onSelect = function(data)
            if GetEntityModel(data.entity) == 1131912276 then
                attachPlayerToBMX(data.entity, vec3(0.05, 1.028, 1.001), 'timetable@ron@ig_5_p3', 'ig_5_p3_base')
            end
        end
    },
    {
        name = 'behing_bmx',
        icon = 'fas fa-bicycle',
        label = 'Monter sur les cales',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            local driver = GetPedInVehicleSeat(entity, -1)
            return driver ~= 0
        end,
        onSelect = function(data)
            if GetEntityModel(data.entity) == 1131912276 then
               attachPlayerToBMX(data.entity, vec3(0.0, -0.528, 1.001), 'anim@amb@clubhouse@bar@drink@idle_a', 'idle_a_bartender')
            end
        end
    },
})
