local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'merged', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'merged', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('merged/' .. name, cb)
end

local seatbeltOn = false

local function round(n) return math.floor(n + 0.5) end
local function clamp(x, a, b) if x < a then return a elseif x > b then return b else return x end end

CreateThread(function()
    Wait(500)

    SendNUIMessage({
        action = "hud:config",
        scale = 0.75,
        offsetRight = 15,
        offsetBottom = 42
    })
end)

CreateThread(function()
    while true do
        Wait(0)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(5)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
    end
end)

CreateThread(function()
    local last = {
        visible = false,
        speed = -1,
        gear = "",
        fuel = -1,
        engine = nil,
        lights = nil,
        doors = nil,
        belt = nil
    }

    while true do
        local wait = 100
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        local inVeh = veh ~= 0
        if inVeh ~= last.visible then
            last.visible = inVeh
            SendNUIMessage({ action = "hud:update", visible = true })
        end

        if IsRadarEnabled() then
            if inVeh then

                SendNUIMessage({ action = "hud:update", visible = true })

                local spd = round(GetEntitySpeed(veh) * 3.6)

                local gearRaw = GetVehicleCurrentGear(veh) or 0
                local gearStr = tonumber(gearRaw)

                local fuel = clamp((GetVehicleFuelLevel(veh) or 0.0), 0.0, 100.0)

                local engine = GetIsVehicleEngineRunning(veh)

                local _, lightsOn, highBeams = GetVehicleLightsState(veh)
                local lights = (lightsOn == 1) or (highBeams == 1)

                local doorsClosed = true
                for i = 0, 5 do
                    if GetVehicleDoorAngleRatio(veh, i) > 0.1 then
                        doorsClosed = false
                        break
                    end
                end

                local changed =
                    (spd ~= last.speed) or
                    (gearStr ~= last.gear) or
                    (math.abs(fuel - last.fuel) > 0.5) or
                    (engine ~= last.engine) or
                    (lights ~= last.lights) or
                    (doorsClosed ~= last.doors) or
                    (seatbeltOn ~= last.belt)

                if changed then
                    last.speed = spd
                    last.gear = gearStr
                    last.fuel = fuel
                    last.engine = engine
                    last.lights = lights
                    last.doors = doorsClosed
                    last.belt = seatbeltOn

                    SendNUIMessage({
                        action = "hud:update",
                        speed = spd,
                        gear = gearStr,
                        fuel = fuel,
                        status = {
                            engine = engine,
                            lights = lights,
                            doorsClosed = doorsClosed,
                            seatbelt = seatbeltOn
                        },

                        engine = engine,
                        lights = lights,
                        doorsClosed = doorsClosed,
                        seatbelt = seatbeltOn
                    })
                end
            else
                SendNUIMessage({ action = "hud:update", visible = false })
                wait = 200
            end
        else
            SendNUIMessage({ action = "hud:update", visible = false })
            wait = 200
        end

        Wait(wait)
    end
end)
