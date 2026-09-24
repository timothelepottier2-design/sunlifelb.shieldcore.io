K9 = {}
K9.data = {}
dogEntity, searchType = nil, nil
local dogBlip = nil
local dogModel <const> = GetHashKey("a_c_shepherd")

local function loadDogModel()
    RequestModel(dogModel)
    while not HasModelLoaded(dogModel) do
        Wait(500)
    end
end

local function removeDog()
    if DoesEntityExist(dogEntity) then
        DeleteEntity(dogEntity)
        dogEntity = nil
    end

    if DoesBlipExist(dogBlip) then
        RemoveBlip(dogBlip)
        dogBlip = nil
    end
end

function spawnDog()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    if DoesEntityExist(dogEntity) then
        removeDog()
    else
        loadDogModel()

        print(('^6[NETDIAG][PED]^7 %s k9.lua:35 CreatePed NETWORKED dog'):format(GetCurrentResourceName()))
        dogEntity = CreatePed(4, dogModel, playerCoords, 0.0, true, false)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(dogEntity), true)
        SetEntityAsMissionEntity(dogEntity, true, true)
        SetModelAsNoLongerNeeded(dogModel)

        SetEntityHealth(dogEntity, 100.0)
        TaskFollowToOffsetOfEntity(dogEntity, ped, 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
        SetPedKeepTask(dogEntity, true)
        CanPedRagdoll(dogEntity, false)

        dogBlip = AddBlipForEntity(dogEntity)
        SetBlipSprite(dogBlip, 273)
        SetBlipColour(dogBlip, 0)
        SetBlipScale(dogBlip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Chien de police")
        EndTextCommandSetBlipName(dogBlip)

        Citizen.CreateThread(function()
            while DoesEntityExist(dogEntity) and GetEntityHealth(dogEntity) > 0 do
                local distance = #(GetEntityCoords(ped) - GetEntityCoords(dogEntity))

                if distance >= 500.0 then
                    removeDog()
                end

                SetEntityInvincible(dogEntity, true)
                Wait(1000)
            end

            removeDog()
        end)
    end
end

function followDog()
    local ped = PlayerPedId()

    RequestAnimDict('rcmnigel1c')
    while not HasAnimDictLoaded('rcmnigel1c') do
        Wait(0)
    end

    TaskPlayAnim(ped, 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, 100.0, 48, 0, false, false, false)

    if not K9.data.follow then
        ClearPedTasks(dogEntity)
        K9.data.follow = true
    else
        TaskFollowToOffsetOfEntity(dogEntity, ped, 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
        SetPedKeepTask(dogEntity, true)
        K9.data.follow = false
    end
end

function sitDog()
    if not K9.data.stand then
        K9.data.stand = not K9.data.stand

        RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
        while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
            Wait(0)
        end

        TaskPlayAnim(dogEntity, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
    else
        K9.data.stand = not K9.data.stand
        ClearPedTasks(dogEntity)
    end
end

function carDog()
    local ped = PlayerPedId()
    local dogCoords = GetEntityCoords(dogEntity)
    local distance = #(GetEntityCoords(ped) - dogCoords)

    if distance > 10 then
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
        return
    end

    if IsPedInAnyVehicle(dogEntity, false) then
        TaskLeaveVehicle(dogEntity, GetVehiclePedIsIn(dogEntity, false), 256)
        K9.data.inCar = false
        return
    end

    if not IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("~r~Vous devez être dans un véhicule pour faire monter le chien")
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then
        return
    end

    local seat = nil
    for i = 0, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) - 1 do
        if IsVehicleSeatFree(vehicle, i) then
            seat = i
            break
        end
    end

    if seat then
        TaskEnterVehicle(dogEntity, vehicle, -1, seat, 5.0, 0)
        K9.data.inCar = true
    else
        ESX.ShowNotification("~r~Aucune place libre dans le véhicule pour le chien")
    end
end

function searchPlayer(playerTarget, searchType)
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(dogEntity)
    local dist = #(coords - hundcoords)

    if dist > 5 then
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
        return
    end

    ClearPedTasksImmediately(dogEntity)
    TaskFollowToOffsetOfEntity(dogEntity, GetPlayerPed(playerTarget), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
    TriggerServerEvent('sJobs.k9Search', GetPlayerServerId(playerTarget), searchType, dogEntity)

    Citizen.CreateThread(function()
        Citizen.Wait(5000)
        ClearPedTasks(dogEntity)
        K9.data.follow = true
    end)
end

AddEventHandler("onResourceStop", function()
    DeleteEntity(dogEntity)
end)
