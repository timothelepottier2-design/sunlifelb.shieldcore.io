ESX = nil
local OnMenuGoFast, OnMission, LivraisonStart, cooldowngofast = false, false, false, false

local gofastLocations = {
    entry = {x = 1240.75, y = -438.89, z = 66.75},
    short = {x = 1764.23, y = -1655.98, z = 111.7, model = 2136773105, reward = 16000, car = "rocoto", time = 90000},
    medium = {x = -1133.74, y = 2694.79, z = 18.8, model = 1909141499, reward = 31000, car = "fugitive", time = 300000},
    long = {x = 1685.07, y = 6435.07, z = 32.32, model = -1485523546, reward = 43000, car = "schafter3", time = 600000}
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    for _, menu in ipairs({"menugofast", "selection", "givemission"}) do
        RMenu.Add('menu', menu, RageUI.CreateMenu("SunLife", "Missions de GoFast", 1, 100))
        RMenu:Get('menu', menu):SetRectangleBanner(255, 117, 31, 225)
    end

    RMenu:Get('menu', 'menugofast').EnableMouse = false
    RMenu:Get('menu', 'menugofast').Closed = function()
        OnMenuGoFast = false
    end
end)

function openGoFastMenu()
    if OnMenuGoFast then
        OnMenuGoFast = false
        return
    end

    OnMenuGoFast = true
    RageUI.Visible(RMenu:Get('menu', 'menugofast'), true)

    Citizen.CreateThread(function()
        while OnMenuGoFast do
            RageUI.IsVisible(RMenu:Get('menu', 'menugofast'), true, true, true, function()
                for _, data in pairs({
                    {label = "GoFast Los Santos", key = "short"},
                    {label = "GoFast Sandy Shores", key = "medium"},
                    {label = "GoFast Paleto Bay", key = "long"}
                }) do
                    RageUI.ButtonWithStyle(data.label, nil, {}, true, function(_, _, Selected)
                        if Selected then
                            startGoFast(data.key)
                        end
                    end)
                end
            end)
            Wait(0)
        end
    end)
end

function startGoFast(routeKey)
    if cooldowngofast then
        return ESX.ShowNotification("~r~Vous ne pouvez faire qu'une seule mission toutes les 5 minutes !")
    end
    if OnMission then
        ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "T'es déjà en mission !", "CHAR_MP_GERALD", 8)
        OnMenuGoFast = false
        return RageUI.CloseAll()
    end

    local data = gofastLocations[routeKey]
    spawnCarGoFast(data.car)
    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "Le GPS est configuré pour la livraison !", "CHAR_MP_GERALD", 8)
    OnMenuGoFast = false
    RageUI.CloseAll()
    triggerGoFastRoute(routeKey, data)
end

function spawnCarGoFast(carName)
    local model = GetHashKey(carName)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    TriggerServerEvent('eye:veh:authorize', model, 'mission')
    local vehicle = CreateVehicle(model, 1234.42, -430.8, 67.77, 189.1, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleNumberPlateText(vehicle, 'GOFAST')
end

function spawnScooter()
    local model = GetHashKey("faggio")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local coords = GetEntityCoords(PlayerPedId())
    local scooter = CreateVehicle(model, coords.x + 2.0, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, false)
    SetVehicleNumberPlateText(scooter, "LOC 333")
end

function triggerGoFastRoute(routeKey, data)
    LivraisonStart, OnMission = true, true
    TriggerServerEvent("GoFast:setupPlayerMission")

    local blip = AddBlipForCoord(data.x, data.y, data.z)
    SetBlipSprite(blip, 1)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    PulseBlip(blip)
    SetBlipRoute(blip, true)
    AddTimerBar("Temps restant", {endTime = GetGameTimer() + data.time})

    Citizen.CreateThread(function()
        while LivraisonStart do
            local plyCoords = GetEntityCoords(PlayerPedId())
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, data.x, data.y, data.z)
            if dist <= 4.5 then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                if vehicleProps.model == data.model then
                    SetVehicleDoorOpen(vehicle, 5, false)
                    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "Super ! Prends l'argent !", "CHAR_MP_GERALD", 8)
                    TriggerServerEvent('GoFast:Reward', data.reward)
                    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(vehicle))
                    LivraisonStart, OnMission = false, false
                    spawnScooter()
                else
                    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "C'est pas le véhicule que je t'ai donné !", "CHAR_MP_GERALD", 8)
                end
            end
            Wait(500)
        end
        RemoveTimerBar()
        RemoveBlip(blip)
        SetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false), 10)
    end)

    cooldowngofast = true
    Citizen.SetTimeout(300000, function()
        cooldowngofast = false
    end)
end

Citizen.CreateThread(function()
    while true do
        local dist = Vdist(GetEntityCoords(PlayerPedId()), gofastLocations.entry.x, gofastLocations.entry.y, gofastLocations.entry.z)
        if dist <= 3.0 then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler à Gerald")
            if IsControlJustPressed(1, 51) then
                openGoFastMenu()
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)
