function handleJammerRemoval(v, removingJammerObject)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed, true)
    local dist = #(playerCoords - v.coords)

    if dist <= 2.0 then
        DrawText3D(v.coords.x, v.coords.y, v.coords.z, "Retirer [E]")
        if IsControlJustReleased(0, 38) and not removingJammerObject then
            TriggerServerEvent('0R-radio:server:DeleteJammerObject', v.id)
            removingJammerObject = false
        end
    end
    return removingJammerObject
end

RegisterNetEvent('0R-radio:client:SetJammerObjects', function(objects)
    -- Avant : reset complet à chaque update + log debug à chaque client. Maintenant : merge.
    if not objects then return end
    for objectId, data in pairs(objects) do
        gSpawnedJammerObjects[objectId] = {
            id = objectId,
            coords = data.coords,
            object = data.object
        }
    end
end)

RegisterNetEvent('0R-radio:client:SpawnJammerObject', function(objectId, model)
    local playerCoords = GetEntityCoords(PlayerPedId(), true)

    gSpawnedJammerObjects[objectId] = {
        id = objectId,
        coords = playerCoords,
        object = nil
    }
end)

Citizen.CreateThread(function()
    if Config.JammerSettings.available then
        local removingJammerObject = false
        while not CoreReady do Citizen.Wait(100) end

        while true do
            local sleep = 500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, true)

            if next(gSpawnedJammerObjects) ~= nil then
                for k, v in pairs(gSpawnedJammerObjects) do
                    local dist = #(playerCoords - v.coords)

                    if dist <= 10.0 then
                        removingJammerObject = handleJammerRemoval(v, removingJammerObject)
                        sleep = 0
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end
end)

Citizen.CreateThread(function()
    if Config.JammerSettings.available then
        while true do
            Citizen.Wait(1000)
            if gPlayer.hasRadio then
                local playerCoords = GetEntityCoords(PlayerPedId(), true)
                gPlayer.inJammerRange = false
                for _, v in pairs(gSpawnedJammerObjects) do
                    if #(playerCoords - v.coords) <= Config.JammerSettings.range then
                        gPlayer.inJammerRange = true
                        break
                    end
                end
                SendReactMessage("setJammerHud", gPlayer.inJammerRange)
            else
                gPlayer.inJammerRange = false
                SendReactMessage("setJammerHud", false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    if Config.JammerSettings.available then
        local sendInfo = true
        while true do
            Citizen.Wait(1000)
            if gPlayer.hasRadio and (gPlayer.channel > 0 or gPlayer.lastChannel > 0) then
                if gPlayer.inJammerRange then
                    if sendInfo then
                        notify(_t("no_signal_disconnected"), "error")
                        sendInfo = false
                    end
                    if gPlayer.channel ~= 0 then
                        gPlayer.lastChannel = gPlayer.channel
                        leaveRadio()
                    end
                else
                    if not sendInfo then
                        notify(_t("no_signal_reconnect"), "success")
                        sendInfo = true
                    end
                    if gPlayer.lastChannel > 0 then
                        connectToRadio(gPlayer.lastChannel)
                        gPlayer.lastChannel = 0
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if playerSpawned then
            gPlayer.hasRadio = hasRadioItem()
        end
    end
end)

--A SUPPRIMER
--Citizen.CreateThread(function()
--    while true do
--        if gPlayer.onRadio and gPlayer.isMenuOpen then
--            TriggerServerEvent("0R-radio:server:SendPlayersInRadioChannel", gPlayer.channel)
--        end
--        Citizen.Wait(3000)
--    end
--end)