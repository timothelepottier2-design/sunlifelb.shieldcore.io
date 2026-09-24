local chance <const> = 0.4

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        local wait = 1500

        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            if IsPedOnFoot(ped) and not IsPedSwimming(ped) and not IsPedRagdoll(ped) then
                if (IsPedRunning(ped) or IsPedSprinting(ped)) and IsPedJumping(ped) then
                    wait = 200

                    if math.random() < chance then
                        Wait(600)
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                        SetPedToRagdoll(ped, 5000, 1, 2)
                        wait = 1500
                    end
                end
            end
        else
            ped = PlayerPedId()
        end

        Wait(wait)
    end
end)
