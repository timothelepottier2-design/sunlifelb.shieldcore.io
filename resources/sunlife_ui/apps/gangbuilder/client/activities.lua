ESX = exports["es_extended"]:getSharedObject()

local ActivityState = nil
local CooldownLeft = 0
local ActivityBlip = nil
local ActivityBlipStage = nil

local function toVec3(t)
    if type(t) ~= "table" then
        return nil
    end
    if type(t.x) ~= "number" or type(t.y) ~= "number" or type(t.z) ~= "number" then
        return nil
    end
    return vector3(t.x, t.y, t.z)
end

local function removeActivityBlip()
    if ActivityBlip and DoesBlipExist(ActivityBlip) then
        RemoveBlip(ActivityBlip)
    end
    ActivityBlip = nil
    ActivityBlipStage = nil
end

local function ensureActivityBlip(coords, stage)
    if not coords then
        removeActivityBlip()
        return
    end

    if ActivityBlip and DoesBlipExist(ActivityBlip) and ActivityBlipStage == stage then
        SetBlipCoords(ActivityBlip, coords.x, coords.y, coords.z)
        return
    end

    removeActivityBlip()

    ActivityBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(ActivityBlip, 478)
    SetBlipScale(ActivityBlip, 0.85)
    SetBlipColour(ActivityBlip, stage == "pickup" and 1 or 5)
    SetBlipAsShortRange(ActivityBlip, false)
    SetBlipRoute(ActivityBlip, true)
    SetBlipRouteColour(ActivityBlip, stage == "pickup" and 1 or 5)

    local _key = "BN_SNL_GANGBUILDER_ACT_1_" .. tostring(ActivityBlip)
    AddTextEntry(_key, stage == "pickup" and "Pickup colis" or "Livraison colis")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(ActivityBlip)

    ActivityBlipStage = stage
end

local function updateActivityBlipFromState()
    if not ActivityState or ActivityState.activity ~= "dangerous_delivery" then
        removeActivityBlip()
        return
    end

    if ActivityState.finished == true then
        removeActivityBlip()
        return
    end

    if ActivityState.picked_up == true then
        ensureActivityBlip(toVec3(ActivityState.dropoff), "dropoff")
    else
        ensureActivityBlip(toVec3(ActivityState.pickup), "pickup")
    end
end

local function refreshState()
    ESX.TriggerServerCallback("gangbuilder:activities:getState", function(data)
        if type(data) ~= "table" then
            ActivityState = nil
            CooldownLeft = 0
            return
        end
        ActivityState = data.state
        CooldownLeft = tonumber(data.cooldown_left) or 0
        updateActivityBlipFromState()
    end)
end

RegisterNetEvent("gangbuilder:activities:sync", function(payload)
    if type(payload) ~= "table" then
        return
    end
    ActivityState = payload.state
    CooldownLeft = tonumber(payload.cooldown_left) or 0
    updateActivityBlipFromState()
end)

RegisterNetEvent("gangbuilder:members:updated", function()
    refreshState()
end)

CreateThread(function()
    Wait(1500)
    refreshState()
end)

CreateThread(function()
    while true do
        Wait(0)

        if not ActivityState or ActivityState.activity ~= "dangerous_delivery" then
            Wait(500)
        else
            local ped = PlayerPedId()
            local p = GetEntityCoords(ped)

            local pickup = toVec3(ActivityState.pickup)
            local dropoff = toVec3(ActivityState.dropoff)

            if ActivityState.picked_up ~= true and pickup then
                local d = #(p - pickup)
                if d < 25.0 then
                    DrawMarker(1, pickup.x, pickup.y, pickup.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 1.0, 255, 255, 255, 180, false, false, 2, false, nil, nil, false)
                end
                if d < 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer le colis")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("gangbuilder:activities:pickupDangerousDelivery", { x = p.x, y = p.y, z = p.z })
                        Wait(800)
                    end
                end
            elseif ActivityState.picked_up == true and ActivityState.finished ~= true and dropoff then
                local d = #(p - dropoff)
                if d < 25.0 then
                    DrawMarker(1, dropoff.x, dropoff.y, dropoff.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 1.0, 255, 255, 255, 180, false, false, 2, false, nil, nil, false)
                end
                if d < 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour livrer le colis")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("gangbuilder:activities:completeDangerousDelivery", { x = p.x, y = p.y, z = p.z })
                        Wait(800)
                    end
                end
            else
                Wait(300)
            end
        end
    end
end)

exports("GangBuilderGetActivityState", function()
    return ActivityState, CooldownLeft
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then
        return
    end
    removeActivityBlip()
end)
