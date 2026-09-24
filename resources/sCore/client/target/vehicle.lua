local truckStatus, pushCar = false, false
local lerpCurrentAngle = 0.0
local tireIndexes = {
    wheel_lf = 0,
    wheel_lr = 4,
    wheel_rf = 1,
    wheel_rr = 5
}
local allowedWeapons <const> = {
    "WEAPON_KNIFE",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_SWITCHBLADE"
}

local function GetDriverOfVehicle(vehicle)
    local dPed = GetPedInVehicleSeat(vehicle, -1)
    for a = 0, 255 do
        if dPed == GetPlayerPed(a) then
            return a
        end
    end
    return -1
end

local function slashTireAtIndex(vehicle, tireIndex)
    local ped = PlayerPedId()
    local animDict = "melee@knife@streamed_core_fps"
    local animName = "ground_attack_on_spot"

    loadDict(animDict)
    local animDuration = GetAnimDuration(animDict, animName)
    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)

    Citizen.Wait((animDuration / 2) * 1000)

    local driverOfVehicle = GetDriverOfVehicle(vehicle)
    local driverServer = GetPlayerServerId(driverOfVehicle)

    if driverServer == 0 then
        SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
    else
        TriggerServerEvent("sCore.displaySlashTire", driverServer, tireIndex)
    end

    Citizen.Wait((animDuration / 2) * 1000)
    ClearPedTasksImmediately(ped)
end

local function isHoldingAllowedWeapon()
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)

    for _, weapon in ipairs(allowedWeapons) do
        if GetHashKey(weapon) == currentWeapon then
            return true
        end
    end
    return false
end

local function stopPushCar(playerPed)
    DetachEntity(playerPed, false, false)
    StopAnimTask(playerPed, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
    pushCar = false
end

local function pushVehicle(vehicle)
    if pushCar then
        return
    end

    local playerPed = PlayerPedId()
    local vehicleCoords = GetEntityCoords(vehicle)
    local dimensions = GetModelDimensions(GetEntityModel(vehicle))
    local isInFront = #(vehicleCoords + GetEntityForwardVector(vehicle)) > #(vehicleCoords - GetEntityForwardVector(vehicle))
    NetworkRequestControlOfEntity(vehicle)
    AttachEntityToEntity(playerPed, vehicle, GetPedBoneIndex(playerPed, 6286), 0.0, isInFront and -dimensions.y + 0.1 or dimensions.y - 0.3, dimensions.z + 1.0, 0.0, 0.0, isInFront and 180.0 or 0.0, false, false, true, false, true)

    loadDict('missfinale_c2ig_11')
    TaskPlayAnim(playerPed, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
    pushCar = true

    Citizen.CreateThread(function()
        while pushCar do
            local speed = GetFrameTime() * 50

            if IsDisabledControlPressed(0, 34) then
                lerpCurrentAngle = math.min(lerpCurrentAngle + speed, 15.0)
            elseif IsDisabledControlPressed(0, 9) then
                lerpCurrentAngle = math.max(lerpCurrentAngle - speed, -15.0)
            else
                lerpCurrentAngle = lerpCurrentAngle > 0 and math.max(lerpCurrentAngle - speed, 0.0) or math.min(lerpCurrentAngle + speed, 0.0)
            end

            SetVehicleSteeringAngle(vehicle, lerpCurrentAngle)

            if isInFront then
                SetVehicleForwardSpeed(vehicle, -1.0)
            else
                SetVehicleForwardSpeed(vehicle, 1.0)
            end
            if HasEntityCollidedWithAnything(vehicle) then
                SetVehicleOnGroundProperly(vehicle)
            end

            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour arrêter")
            if IsControlJustPressed(0, 38) then
                stopPushCar(playerPed)
            end
            Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("sCore.slashTire", function(tireIndex)
    local plyPed = GetPlayerPed(PlayerId())
    local vehicle = GetVehiclePedIsIn(plyPed, false)

    SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
end)

RegisterNetEvent('sCore.animTrunck', function(netId)
    if not netId then
        return
    end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity then
        return
    end
    if not DoesEntityExist(entity) then
        return
    end

    Wait(150)
    SetVehicleDoorShut(entity, 5)
    AttachEntityToEntity(PlayerPedId(), entity, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    loadDict('timetable@floyd@cryingonbed@base')
    TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(300)
    SetEntityVisible(PlayerPedId(), false)
    truckStatus = true

    while DoesEntityExist(entity) and truckStatus do
        SetEntityCollision(PlayerPedId(), false, false)
        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir du coffre")

        if IsControlJustReleased(1,51) then
            TriggerServerEvent('sCore.exitTrunck')
        end
        if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 3) then
            loadDict('timetable@floyd@cryingonbed@base')
            TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
        end
        Wait(0)
    end

    SetEntityCollision(PlayerPedId(), true, true)
    DetachEntity(PlayerPedId(), true, true)
    ClearPedTasks(PlayerPedId())
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('sCore.deleteNotif', function()
    truckStatus = false
end)

exports.ox_target:addGlobalVehicle({
    {
        name = 'out_handcuff',
        icon = 'fa-solid fa-person-walking-arrow-right',
        label = 'Sortir la personne',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 2.0 then
                local targetPed = GetPlayerPed(closestPlayer)
                if IsPedInAnyVehicle(targetPed, false) then
                    local targetVehicle = GetVehiclePedIsIn(targetPed, false)
                    return targetVehicle == entity
                end
            end
            return false
        end,
        onSelect = function(data)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 2.0 then
                TriggerServerEvent("sCore.outVehicle", GetPlayerServerId(closestPlayer))
            end
        end
    },
    {
        name = 'hide_trunk',
        icon = 'fa-solid fa-car',
        label = 'Se cacher dans le coffre',
        bones = 'boot',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then
                return
            end
            if IsVehicleDoorDamaged(entity, 5) then
                return
            end
            return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
        end,
        onSelect = function(data)
            TriggerServerEvent('sCore.enterTrunck', NetworkGetNetworkIdFromEntity(data.entity))
        end
    },
    {
        name = 'push_car',
        icon = 'fa-solid fa-hands-holding',
        label = 'Pousser le véhicule',
        bones = 'boot',
        distance = 5.0,
        canInteract = function(entity, distance, coords, name, boneId)
            return IsVehicleSeatFree(entity, -1)
        end,
        onSelect = function(data)
            pushVehicle(data.entity)
        end
    },
})

for bone, index in pairs(tireIndexes) do
    exports.ox_target:addGlobalVehicle({
        name = 'slash_tire_' .. bone,
        label = 'Crever le pneu',
        icon = 'fa-regular fa-circle-dot',
        bones = { bone },
        distance = 2.0,
        canInteract = function(entity, distance, coords, name, boneId)
            return isHoldingAllowedWeapon() and not IsVehicleTyreBurst(entity, index, false)
        end,
        onSelect = function(data)
            slashTireAtIndex(data.entity, index)
        end
    })
end
