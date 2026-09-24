local PARACHUTE_HASH = `GADGET_PARACHUTE`

RegisterNetEvent("sCore.usableParachute", function()
    local ped = PlayerPedId()
    if not ped or ped == 0 or IsPedDeadOrDying(ped, true) then
        return
    end

    GiveWeaponToPed(ped, PARACHUTE_HASH, 1, false, false)
    SetPedGadget(ped, PARACHUTE_HASH, true)
end)
