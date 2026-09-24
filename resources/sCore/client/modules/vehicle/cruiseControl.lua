local isCruiseEnabled = false
local cruiseSpeed = 0.0
local cruiseVehicle = nil

local function IsVehicleCruiseAllowed(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    local class = GetVehicleClass(vehicle)
    if class == 13 or class == 14 or class == 15 or class == 16 or class == 21 then
        return false
    end

    -- Certains véhicules moddés déclarent une mauvaise classe : on vérifie aussi le modèle
    local model = GetEntityModel(vehicle)
    if IsThisModelABoat(model)
        or IsThisModelAJetski(model)
        or IsThisModelAPlane(model)
        or IsThisModelAHeli(model)
        or IsThisModelATrain(model) then
        return false
    end

    -- Filet de sécurité : un bateau n'a pas de roues
    if GetVehicleNumberOfWheels(vehicle) == 0 then
        return false
    end

    return true
end

local function EnableCruiseControl(vehicle)
    if vehicle == 0 then return end
    if not IsVehicleCruiseAllowed(vehicle) then
        ESX.ShowNotification('Ce véhicule ne supporte pas le régulateur')
        return
    end

    local speed = GetEntitySpeed(vehicle)
    if speed < 5.0 then
        ESX.ShowNotification('Vous devez rouler pour activer le régulateur')
        return
    end

    isCruiseEnabled = true
    cruiseVehicle = vehicle
    cruiseSpeed = speed

    SetVehicleMaxSpeed(vehicle, 0.0)
    if ApplyHardSpeedCap then ApplyHardSpeedCap(vehicle) end

    local speedKMH = math.floor(cruiseSpeed * 3.6 + 0.5)
    ESX.ShowNotification('Régulateur de vitesse fixé à ' .. speedKMH .. ' km/h')
end

local function DisableCruiseControl(vehicle)
    if not isCruiseEnabled then return end

    if not vehicle or vehicle == 0 then
        vehicle = cruiseVehicle
    end

    isCruiseEnabled = false
    cruiseSpeed = 0.0
    cruiseVehicle = nil

    if vehicle and vehicle ~= 0 then
        SetVehicleMaxSpeed(vehicle, 0.0)
        if ApplyHardSpeedCap then ApplyHardSpeedCap(vehicle) end
    end

    ESX.ShowNotification('Régulateur de vitesse désactivé')
end

local function ToggleCruiseControl()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if not IsPedInAnyVehicle(ped, false) or GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return
    end

    if not isCruiseEnabled then
        EnableCruiseControl(vehicle)
    else
        DisableCruiseControl(vehicle)
    end
end

CreateThread(function()
    while true do
        if isCruiseEnabled then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)

            if not IsPedInAnyVehicle(ped, false)
                or veh ~= cruiseVehicle
                or GetPedInVehicleSeat(veh, -1) ~= ped
                or not IsVehicleCruiseAllowed(veh)
                or IsControlPressed(0, 72)
                or IsControlPressed(0, 76)
                or IsEntityUpsidedown(veh)
                or HasEntityCollidedWithAnything(veh) then
                DisableCruiseControl(veh)
            else
                local currentSpeed = GetEntitySpeed(veh)

                if currentSpeed < 3.0 then
                    DisableCruiseControl(veh)
                else
                    if not IsControlPressed(0, 71) then
                        if currentSpeed < cruiseSpeed - 0.5 then
                            local steer = math.abs(GetControlNormal(0, 59))
                            if steer < 0.5 and not IsEntityInAir(veh) then
                                local diff = cruiseSpeed - currentSpeed
                                local step = diff
                                if step > 0.7 then
                                    step = 0.7
                                end
                                local target = currentSpeed + step
                                SetVehicleForwardSpeed(veh, target)
                            end
                        end
                    end
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

RegisterCommand('regulateur', function()
    ToggleCruiseControl()
end, false)

RegisterKeyMapping('regulateur', 'Régulateur de vitesse', 'keyboard', 'B')
