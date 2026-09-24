Citizen.CreateThread(function()

    local pickupRemove <const> = {
        'PICKUP_WEAPON_CARBINERIFLE',
        'PICKUP_WEAPON_PISTOL',
        'PICKUP_WEAPON_PUMPSHOTGUN'
    }
    for _, pickup in pairs(pickupRemove) do
        RemoveAllPickupsOfType(GetHashKey(pickup))
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        DisableControlAction(0, 37, true)
        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)

    end
end)
