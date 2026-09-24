local driftMode, cooldown, driftThread = false, false, false
local driftSpeedLimit = 150.0
local driftKeyPressed = false

RegisterCommand('+sunlifeDrift', function()
    driftKeyPressed = true
end, false)

RegisterCommand('-sunlifeDrift', function()
    driftKeyPressed = false
end, false)

RegisterKeyMapping('+sunlifeDrift', "Drift : réduire l'adhérence (maintenir)", 'keyboard', 'LSHIFT')

local function cooldownThread(duration)
    cooldown = true

    Citizen.SetTimeout(duration, function()
        cooldown = false
    end)
end

local function driftHandler()
    if driftThread then
        return
    end
    driftThread = true

    Citizen.CreateThread(function()
        local ped = PlayerPedId()

        while driftMode do
            if IsPedInAnyVehicle(ped, false) then
                local currentVehicle = GetVehiclePedIsIn(ped, false)

                if GetPedInVehicleSeat(currentVehicle, -1) == ped then
                    local speedVehicle = GetEntitySpeed(currentVehicle) * 3.6

                    if speedVehicle <= driftSpeedLimit then
                        if driftKeyPressed and not cooldown then
                            SetVehicleReduceGrip(currentVehicle, true)
                        else
                            SetVehicleReduceGrip(currentVehicle, false)
                        end
                    else
                        SetVehicleReduceGrip(currentVehicle, false)
                    end
                end
            end
            Citizen.Wait(10)
        end

        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            SetVehicleReduceGrip(vehicle, false)
        end

        driftThread = false
    end)
end

RegisterCommand("toggleDriftMode", function()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("~r~Vous devez être dans un véhicule pour activer le mode drift.")
        return
    end

    local vipName = getPlayerVipName()
    if vipName == "diamond" or vipName == "platinium" or vipName == "legendary" then
        driftMode = not driftMode
        if driftMode then
            ESX.ShowNotification("~g~Mode Drift Activé")
            cooldownThread(5000)
            driftHandler()
        else
            ESX.ShowNotification("~r~Mode Drift Désactivé")
        end
    else
        ESX.ShowNotification("~r~Vous n'avez pas les permissions nécessaires ! (VIP)")
    end
end)

RegisterKeyMapping('toggleDriftMode', 'Activer le mode drift', 'keyboard', '')
