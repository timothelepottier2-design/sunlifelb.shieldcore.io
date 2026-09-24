RegisterNetEvent("sCore.spawnBmx", function()
    local modelHash = GetHashKey("bmx")

    if not loadModel(modelHash) then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    print(('^5[NETDIAG][VEHICLE]^7 %s bmx.lua:10 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(modelHash)))
    local entity = CreateVehicle(modelHash, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)

    SetVehicleNumberPlateText(entity, "BMX")
    SetPedIntoVehicle(playerPed, entity, -1)
    SetModelAsNoLongerNeeded(modelHash)

    exports.ox_target:addLocalEntity(entity, {
        {
            name = 'take_bmx',
            icon = 'fa-solid fa-bicycle',
            label = 'Récupérer votre BMX',
            onSelect = function(data)
                loadDict("anim@mp_snowball")
                TaskPlayAnim(PlayerPedId(), "anim@mp_snowball", "pickup_snowball", 8.0, -8.0, -1, 48, 0, false, false, false)

                exports.ox_target:removeLocalEntity(entity, {
                    'take_bmx'
                })
                if DoesEntityExist(entity) then
                    DeleteEntity(entity)
                end
                TriggerServerEvent('sCore.takeBmx')
            end
        }
    })
end)
