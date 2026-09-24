-- Recharge automatiquement les munitions du WEAPON_HOSE à 100%
local WEAPON_HOSE = `WEAPON_HOSE`

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if GetSelectedPedWeapon(ped) == WEAPON_HOSE then
            sleep = 200

            -- Remplit la réserve de munitions au maximum
            local found, maxAmmo = GetMaxAmmo(ped, WEAPON_HOSE)
            if found and GetAmmoInPedWeapon(ped, WEAPON_HOSE) < maxAmmo then
                SetPedAmmo(ped, WEAPON_HOSE, maxAmmo)
            end

            -- Remplit aussi le chargeur pour éviter tout rechargement
            local maxClip = GetMaxAmmoInClip(ped, WEAPON_HOSE, true)
            if maxClip > 0 then
                local hasClip, ammoInClip = GetAmmoInClip(ped, WEAPON_HOSE)
                if hasClip and ammoInClip < maxClip then
                    SetAmmoInClip(ped, WEAPON_HOSE, maxClip)
                end
            end
        end

        Wait(sleep)
    end
end)
