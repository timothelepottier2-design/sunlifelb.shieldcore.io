local STATIONS_CFG = CustomFuelStations or {}

local FUEL_DECOR     = "_ANDY_FUEL_DECORE_"
local RENDER_DIST    = 20.0
local INTERACT_DIST  = 2.2
local FILL_DURATION  = 20000
local FILL_PRICE     = 5000
local BLIP_CAT_FUEL  = 42

local ESX = exports['es_extended']:getSharedObject()

local RENDER_DIST_SQ   = RENDER_DIST * RENDER_DIST
local INTERACT_DIST_SQ = INTERACT_DIST * INTERACT_DIST

local points = {}
for i = 1, #STATIONS_CFG do
    points[i] = STATIONS_CFG[i].coords
end
local nbPoints = #points

local isFilling = false

CreateThread(function()
    AddTextEntry("BLIP_CAT_" .. BLIP_CAT_FUEL, "Station essence")
    AddTextEntry("BN_SNL_FUEL_STATION", "Station essence")

    for i = 1, nbPoints do
        local c = points[i]
        local blip = AddBlipForCoord(c.x, c.y, c.z)
        SetBlipSprite(blip, 361)
        SetBlipScale(blip, 0.65)
        SetBlipColour(blip, 2)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        SetBlipCategory(blip, BLIP_CAT_FUEL)
        BeginTextCommandSetBlipName("BN_SNL_FUEL_STATION")
        EndTextCommandSetBlipName(blip)
    end
end)

local function showHelp(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function startFill(veh)
    isFilling = true

    if GetVehicleFuelLevel(veh) >= 99.0 then
        lib.notify({ type = 'inform', description = "Le réservoir est déjà plein." })
        isFilling = false
        return
    end

    local success = lib.progressBar({
        duration = FILL_DURATION,
        label = "⛽ Plein en cours... (" .. FILL_PRICE .. " $)",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    })

    if not success then
        lib.notify({ type = 'error', description = "Ravitaillement annulé." })
        isFilling = false
        return
    end

    ESX.TriggerServerCallback('fuel:payStation', function(paid)
        if paid then
            if DoesEntityExist(veh) then
                SetVehicleFuelLevel(veh, 100.0)
                DecorSetFloat(veh, FUEL_DECOR, 100.0)
            end
            lib.notify({ type = 'success', description = "Le plein est fait, réservoir rempli." })
        else
            lib.notify({ type = 'error', description = "Paiement refusé, plein non effectué." })
        end
        isFilling = false
    end, FILL_PRICE)
end

if nbPoints > 0 then
    CreateThread(function()
        while true do
            local sleep = 1500

            if not isFilling then
                local ped = PlayerPedId()
                local pc = GetEntityCoords(ped)
                local px, py, pz = pc.x, pc.y, pc.z

                local interactStation = nil

                for i = 1, nbPoints do
                    local c = points[i]
                    local dx, dy, dz = px - c.x, py - c.y, pz - c.z
                    local distSq = dx * dx + dy * dy + dz * dz

                    if distSq <= RENDER_DIST_SQ then
                        sleep = 0
                        DrawMarker(
                            1,
                            c.x, c.y, c.z - 0.95,
                            0.0, 0.0, 0.0,
                            0.0, 0.0, 0.0,
                            1.5, 1.5, 1.0,
                            255, 170, 0, 120,
                            false, false, 2, false, nil, nil, false
                        )

                        if distSq <= INTERACT_DIST_SQ then
                            interactStation = c
                        end
                    end
                end

                if interactStation then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                        showHelp("Appuyez sur ~INPUT_CONTEXT~ pour faire le plein (20s)")
                        if IsControlJustPressed(0, 38) then
                            startFill(veh)
                        end
                    else
                        showHelp("Mettez-vous au volant d'un véhicule pour faire le plein")
                    end
                end
            end

            Wait(sleep)
        end
    end)
end
