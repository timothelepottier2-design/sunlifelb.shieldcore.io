local isDrag = false
local draggerId = nil
local dragThread = false

local function dragLoop()
    if dragThread then
        return
    end
    dragThread = true

    Citizen.CreateThread(function()
        while isDrag do
            local ped = PlayerPedId()

            if isCuff and draggerId then
                local draggerPed = GetPlayerPed(GetPlayerFromServerId(draggerId))

                if DoesEntityExist(draggerPed) then
                    if not IsEntityAttachedToEntity(ped, draggerPed) then
                        AttachEntityToEntity(ped, draggerPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)
                    end
                else
                    DetachEntity(ped, true, false)
                    isDrag = false
                    draggerId = nil
                end
            else
                DetachEntity(ped, true, false)
            end

            Wait(250)
        end

        DetachEntity(PlayerPedId(), true, false)
        dragThread = false
    end)
end

RegisterNetEvent("sCore.mainDrag", function(sourceId)
    isDrag = not isDrag
    draggerId = sourceId

    if isDrag then
        dragLoop()
    else
        DetachEntity(PlayerPedId(), true, false)
        draggerId = nil
    end
end)
