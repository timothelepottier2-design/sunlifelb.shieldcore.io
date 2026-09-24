local buttonSeat <const> = {[157] = -1, [158] = 0, [160] = 1, [164] = 2, [165] = 3, [159] = 4, [161] = 5, [162] = 6, [163] = 7}
local threadActive, blockShuffle = false, true
local shiftKey <const> = 21

local function seatLoop()
    local ped = PlayerPedId()

    Citizen.CreateThread(function()
        while true do
            if not IsPedInAnyVehicle(ped, false) then
                threadActive = false
                break
            end

            local currentVehicle = GetVehiclePedIsIn(ped, false)
            if currentVehicle == 0 then
                threadActive = false
                break
            end

            DisablePlayerVehicleRewards(PlayerId())

            for key, seat in pairs(buttonSeat) do
                if IsControlPressed(0, shiftKey) and IsDisabledControlJustPressed(1, key) then
                    if IsVehicleSeatFree(currentVehicle, seat) then
                        if GetEntitySpeed(currentVehicle) * 3.6 > 15 then
                            ESX.ShowNotification("~r~Vous devez ralentir !")
                        else
                            SetPedIntoVehicle(ped, currentVehicle, seat)
                            blockShuffle = (seat == 0)
                            Citizen.Wait(2000)
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end
        threadActive = false
        return
    end)
end

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    if not threadActive then
        threadActive = true
        seatLoop()
    end
end)
