local blips = {}

CreateThread(function()
    local coords = {
        vector3(-149.44, -258.21, 44.14)
    }

    for _, c in pairs(coords) do
        local blip = AddBlipForCoord(c.x, c.y, c.z)

        SetBlipDisplay(blip, 4)
        SetBlipSprite(blip, 106)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Text.BLIP)
        EndTextCommandSetBlipName(blip)

        table.insert(blips, blip)
    end
end)

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        for _, b in pairs(blips) do
            RemoveBlip(b)
        end
    end
end)
