local vehicleDamageThread = nil
local inVehicle = false
local data = {
    damageFactorEngine = 3.5,
    damageFactorBody = 3.0,
    damageFactorPetrolTank = 16.0,
    engineSafeGuard = 100.0,
    cascadingFailureThreshold = 200.0,
    degradingFailureThreshold = 500.0,
    degradingHealthSpeedFactor = 4.0,
    cascadingFailureSpeedFactor = 3.0,
    maxDamagePerTick = 150.0,
    compatibilityMode = false,
}

local classResistance = {
    [8]  = 0.45,
    [13] = 0.45,
}

local defaultResistance = 1.0

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    if inVehicle then
        return
    end

    inVehicle = true
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local vehicleClass = GetVehicleClass(vehicle)
    local resistance = classResistance[vehicleClass] or defaultResistance

    local healthEngineLast = GetVehicleEngineHealth(vehicle)
    local healthBodyLast = GetVehicleBodyHealth(vehicle)
    local healthPetrolTankLast = GetVehiclePetrolTankHealth(vehicle)

    local displayNotif = false

    vehicleDamageThread = Citizen.CreateThread(function()
        while inVehicle and IsPedInAnyVehicle(ped, false) do
            local healthEngineCurrent = GetVehicleEngineHealth(vehicle)
            local healthBodyCurrent = GetVehicleBodyHealth(vehicle)
            local healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)

            local deltaEngine = (healthEngineLast - healthEngineCurrent) * data.damageFactorEngine * 0.25
            local deltaBody = (healthBodyLast - healthBodyCurrent) * data.damageFactorBody * 0.25
            local deltaTank = (healthPetrolTankLast - healthPetrolTankCurrent) * data.damageFactorPetrolTank * 0.25

            local damageToApply = math.max(deltaEngine, deltaBody, deltaTank) * resistance

            if damageToApply > data.maxDamagePerTick then
                damageToApply = data.maxDamagePerTick
            end

            if damageToApply > 0 then
                if damageToApply > (healthEngineCurrent - data.engineSafeGuard) then
                    damageToApply = damageToApply * 0.7
                end

                if damageToApply > healthEngineCurrent then
                    damageToApply = healthEngineCurrent - (data.cascadingFailureThreshold / 5)
                end

                local newEngineHealth = healthEngineLast - damageToApply

                if newEngineHealth > data.cascadingFailureThreshold and newEngineHealth < data.degradingFailureThreshold then
                    newEngineHealth = newEngineHealth - (0.038 * data.degradingHealthSpeedFactor)
                end

                if newEngineHealth < data.cascadingFailureThreshold then
                    newEngineHealth = newEngineHealth - (0.1 * data.cascadingFailureSpeedFactor)
                end

                if newEngineHealth < data.engineSafeGuard then
                    newEngineHealth = data.engineSafeGuard
                end

                if not data.compatibilityMode and healthPetrolTankCurrent < 750 then
                    healthPetrolTankCurrent = 750.0
                end

                SetVehicleEngineHealth(vehicle, newEngineHealth)
            end

            if healthEngineCurrent <= data.engineSafeGuard then
                SetVehicleUndriveable(vehicle, true)
                if not displayNotif then
                    ESX.ShowNotification("~r~Le véhicule est en panne. Faites-le réparer !")
                    displayNotif = true
                end
            else
                SetVehicleUndriveable(vehicle, false)
                displayNotif = false
            end

            healthEngineLast = GetVehicleEngineHealth(vehicle)
            healthBodyLast = GetVehicleBodyHealth(vehicle)
            healthPetrolTankLast = GetVehiclePetrolTankHealth(vehicle)

            Citizen.Wait(100)
        end

        inVehicle = false
        vehicleDamageThread = nil
    end)
end)

AddEventHandler("sCore.exitedVehicle", function(plate, seat, displayName, netId)
    inVehicle = false
end)
