local carWashCoords <const> = {
    vector3(25.0216, -1392.0176, 28.3347),
    vector3(119.2327, 6528.5288, 30.3991),
    vector3(-699.8776, -932.6452, 18.0139),
    vector3(1362.889893, 3592.367920, 34.917553),
    vector3(1182.447998, 2655.012207, 38.408497),
    vector3(1681.690674, 4933.823242, 42.080570),
    vector3(-231.920761, -1334.574341, 30.889486)
}
local price <const> = 1500
local deletNotif = false
local particle, particle2 = nil, nil

local function displayEffects(vehicle, duration)
    local vehCoords = GetEntityCoords(vehicle)

    deletNotif = true

    Citizen.CreateThread(function()
        local remainingTime = duration

        while remainingTime > 0 do
            Wait(1000)
            remainingTime -= 1

            UseParticleFxAssetNextCall("core")
            particle = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", vehCoords.x, vehCoords.y, vehCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

            UseParticleFxAssetNextCall("core")
            particle2 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", vehCoords.x + 2, vehCoords.y, vehCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        end

        deletNotif = false
        WashDecalsFromVehicle(vehicle, 1.0)
        SetVehicleDirtLevel(vehicle, 0.0)
        FreezeEntityPosition(vehicle, false)

        ESX.ShowNotification("~g~Votre véhicule a été lavé avec succès !")

        if particle then
            StopParticleFxLooped(particle, 0)
        end
        if particle2 then
            StopParticleFxLooped(particle2, 0)
        end

        TriggerServerEvent("sCore.removeMoney", price, "money")
    end)
end

local function washAction(vehicle)
    local vehCoords = GetEntityCoords(vehicle)

    ESX.TriggerServerCallback("sCore.checkMoney", function(hasMoney)
        if hasMoney then
            deletNotif = true

            FreezeEntityPosition(vehicle, true)
            loadPtfx()
            displayEffects(vehicle, 10)
        else
            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent liquide")
        end
    end, price, "money")
end

local function markerCarWash(data)
    local ped = PlayerPedId()

    if data.currentDistance < 5.0 and IsPedSittingInAnyVehicle(ped) then
        ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour laver le véhicule au coût de ~o~" ..price.. "$")
        if IsControlJustPressed(0, 38) then
            if deletNotif then
                ESX.ShowNotification("~r~Vous êtes déjà en train de laver votre véhicule !")
                return
            end

            local currentVehicle = GetVehiclePedIsIn(ped, false)

            if GetVehicleDirtLevel(currentVehicle) <= 2 then
                ESX.ShowNotification("~r~Votre véhicule est déja propre !")
                return
            end

            washAction(currentVehicle)
        end
    end
end

local function loadCarWash()
    for i = 1, #carWashCoords do
        lib.points.new({
            coords = carWashCoords[i],
            distance = 10,
            nearby = function(self)
                markerCarWash({coords = self.coords, currentDistance = self.currentDistance})
            end
        })
    end
end

loadCarWash()
