local useBrouilleur, onCoyote, radarActive, notif = false, false, false, false
local value = 0
local allowedJobs = {
    police = true,
    ems = true,
    sheriff = true,
    gouv = true,
    doj = true,
    lsfd = true,
    usss = true
}
local radarZone = {
    {x = 223.44, y = -1043.16, z = 28.89},
    {x = 394.152, y = -1049.98, z = 8.85},
    {x = 404.06, y = -954.26, z = 28.87},
    {x = 291.35, y = -854.42, z = 28.70},
    {x = 39.01, y = -768.27, z = 31.15},
    {x = -195.37, y = -891.77, z = 28.8},
    {x = -96.85, y = -1138.96, z = 25.37},
    {x = 149.26, y = -1392.29, z = 28.82},
    {x = -111.43, y = -697.24, z = 34.35},
    {x = 24.84, y = -303.64, z = 46.61},
    {x = 247.21, y = -619.68, z = 41.14},
    {x = -501.92, y = -835.12, z = 30.01},
    {x = -858.42, y = -834.56, z = 18.82},
    {x = -1079.91, y = -761.38, z = 18.881},
    {x = -1536.03, y = -672.69, z = 28.43},
    {x = -794.02, y = -68.65, z = 37.30},
    {x = 765.82, y = -35.08, z = 60.47},
    {x = 1607.71, y = 1069.81, z = 80.78},
}

local function radarHandler()
    if radarActive then
        return
    end
    radarActive = true

    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if not IsPedInAnyVehicle(ped, false) then
                radarActive = false
                break
            end

            local currentVehicle = GetVehiclePedIsIn(ped, false)
            if currentVehicle == 0 or GetPedInVehicleSeat(currentVehicle, -1) ~= ped then
                radarActive = false
                break
            end

            local speedVehicle = GetEntitySpeed(currentVehicle) * 3.6

            if speedVehicle >= 100.0 and not notif then
                local vehCoords = GetEntityCoords(currentVehicle)

                for _, zone in pairs(radarZone) do
                    if #(vehCoords - vector3(zone.x, zone.y, zone.z)) <= 20.0 then
                        local finalVitesse = ESX.Math.Round(speedVehicle, 0)

                        if finalVitesse >= 190.0 then
                            PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
                            PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
                            TriggerServerEvent("sCore.paidRadar", finalVitesse)
                            notif = true
                        end
                        break
                    end
                end
            end

            if notif then
                value = value + 1
                if value > 800 then
                    value = 0
                    notif = false
                end
            end

            Wait(50)
        end
    end)
end

AddEventHandler("sCore.enteredVehicle", function(plate, seat, displayName, netId)
    local playerJob = ESX.PlayerData.job and ESX.PlayerData.job.name

    if allowedJobs[playerJob] or useBrouilleur then
        return
    end

    radarHandler()
end)

RegisterNetEvent("sCore.usableBrouilleur", function()
    useBrouilleur = true
end)

RegisterNetEvent("sCore.usableCoyote", function()
    for _, zone in pairs(radarZone) do
        local zoneRaduis = AddBlipForRadius(zone.x, zone.y, zone.z, 30.0)
		SetBlipSprite(zoneRaduis, 9)
		SetBlipColour(zoneRaduis, 1)
		SetBlipAlpha(zoneRaduis, 80)
		SetBlipAsShortRange(zoneRaduis, 1)
    end
    onCoyote = true
    ESX.ShowNotification("~g~Vous avez activé votre coyote")
end)
