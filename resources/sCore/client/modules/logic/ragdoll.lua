local canRagdoll = false

RegisterCommand("ragdoll", function()
    local ped = PlayerPedId()

    if not canRagdoll then
        canRagdoll = true
        Citizen.CreateThread(function()
            while canRagdoll do
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                Citizen.Wait(0)
            end
        end)
    else
        canRagdoll = false
    end
end)

RegisterKeyMapping('ragdoll', "Ragdoll", 'keyboard', "")
