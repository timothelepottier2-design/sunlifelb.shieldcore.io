local nitroEnabled, nitroThread, usedNitro = false, false, false

local function nitroHandler(vipName)
    if nitroThread then
        return
    end
    nitroThread = true

    local cooldownByRank = {
        legendary = 5 * 60 * 1000,
        platinium = 10 * 60 * 1000
    }

    Citizen.CreateThread(function()
        while nitroEnabled do
            local ped = PlayerPedId()

            if IsPedInAnyVehicle(ped, false) and IsControlJustPressed(0, 21) and not usedNitro then
                local currentVehicle = GetVehiclePedIsIn(ped, false)
                usedNitro = true

                pcall(function() exports['antisbire']:speedBoostGrace(7000) end)

                SetVehicleBoostActive(currentVehicle, 1, 0)
                SetVehicleForwardSpeed(currentVehicle, 70.0)
                StartScreenEffect("RaceTurbo", 0, 0)

                local cooldown = cooldownByRank[vipName] or (5 * 60 * 1000)

                Citizen.SetTimeout(5000, function()
                    if DoesEntityExist(currentVehicle) then
                        SetVehicleBoostActive(currentVehicle, 0, 0)
                    end
                    StopScreenEffect("RaceTurbo")
                    ESX.ShowNotification(("Prochain nitro disponible dans %d minutes !"):format(cooldown / 60000))
                end)

                Citizen.SetTimeout(5000 + cooldown, function()
                    usedNitro = false
                end)
            end

            Citizen.Wait(0)
        end

        StopScreenEffect("RaceTurbo")
        nitroThread = false
    end)
end

RegisterCommand("+toggleNitro", function()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("~r~Vous devez être dans un véhicule pour activer le nitro.")
        return
    end

    local vipName = getPlayerVipName()
    if vipName == "platinium" or vipName == "legendary" then
        nitroEnabled = not nitroEnabled

        if nitroEnabled then
            ESX.ShowNotification('~g~Nitro activé!')
            nitroHandler(vipName)
        else
    	    ESX.ShowNotification('~r~Nitro désactivé!')
        end
    else
        ESX.ShowNotification("~r~Vous n'avez pas les permissions nécessaires ! (VIP)")
    end
end)

RegisterKeyMapping('+toggleNitro', 'Activer/Désactiver Nitro', 'keyboard', '')
