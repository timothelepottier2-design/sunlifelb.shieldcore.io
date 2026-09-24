Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

	RMenu.Add('entreprises', 'main', RageUI.CreateMenu("SunLife", "Garage", 1, 100))
    RMenu.Add('entreprises', 'vehicles', RageUI.CreateSubMenu(RMenu:Get('entreprises', 'main'), "SunLife", "Garage"))
    RMenu:Get('entreprises', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('entreprises', 'vehicles'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('entreprises', 'main').EnableMouse = false
    RMenu:Get('entreprises', 'main').Closed = function()
		OnGarageActive = false
    end
end)

local voiture = {}
local pointDeSpawn = {}
local LastVeh = nil
local x = nil
local cust = nil
local c1, c2 = nil, nil

function OpenGarageMenu(vehs, spawn, xenon, fullCustom, color1, color2, pearlescentColor)
    if not IsPedInAnyVehicle(PlayerPedId(), 0) then
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 1)
    else
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 0)
    end
    voiture = vehs
    pointDeSpawn = spawn
    x = xenon
    cust = fullCustom
    c1 = color1
    c2 = color2
    nacr = pearlescentColor
    openEntreprisesGarage()
end

function openEntreprisesGarage()
    if OnGarageActive then
        OnGarageActive = false
        return
    else
        OnGarageActive = true
        RageUI.Visible(RMenu:Get('entreprises', 'main'), true)

        Citizen.CreateThread(function()
            while OnGarageActive do
                RageUI.IsVisible(RMenu:Get('entreprises', 'main'), true, true, true, function()
                    local model = GetEntityModel(LastVeh)
                    local displaytext = GetDisplayNameFromVehicleModel(model)
                    local nameLastVeh = GetLabelText(displaytext)
                    local plate = GetVehicleNumberPlateText(LastVeh)
                    if plate ~= nil then
                        RageUI.ButtonWithStyle("Ranger votre ~g~"..nameLastVeh.." ~b~["..plate.."]", nil, { RightLabel = "" },true, function(Hovered, Active, Selected)
                            if (Selected) then
                                TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(LastVeh))
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle("Véhicules", nil, { RightLabel = "" },true, function()
                    end, RMenu:Get('entreprises', 'vehicles'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('entreprises', 'vehicles'), true, true, true, function()
                    RageUI.Separator("Véhicules")
                    for k,v in pairs(voiture) do
                        local displaytext = GetDisplayNameFromVehicleModel(GetHashKey(v))
                        local name = GetLabelText(displaytext)
                        RageUI.ButtonWithStyle(name, nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TrySpawnVeh(v, c1, c2)
                            end
                        end)
                    end
                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function LookingForAPlace()
    local found = false
    local pos = nil
    local heading = nil
    for k,v in pairs(pointDeSpawn) do
        if ESX.Game.IsSpawnPointClear(v.pos, 3.0) then
            found = true
            pos = v.pos
            heading = v.heading
        end
    end
    if not found then
        return false
    else
        return pos, heading
    end
end

function TrySpawnVeh(veh, c1, c2)
    local pos, heading = LookingForAPlace()
    local pPed = PlayerPedId()
    if pos then
        local model = GetHashKey(veh)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(1) end
        TriggerServerEvent('eye:veh:authorize', model, 'farm')
        print(('^5[NETDIAG][VEHICLE]^7 %s cl_garage.lua:113 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
        local veh = CreateVehicle(model, pos, heading, 1, 0)
        local plate = generateFarmPlate()
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, heading)
        SetEntityAsMissionEntity(veh, 1, 1)
        local NetId = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdCanMigrate(NetId, 1)
        TaskWarpPedIntoVehicle(pPed, veh, -1)

        ESX.ShowNotification("Véhicule sorti !", 1, 0, 60)
    else
        ESX.ShowNotification("Aucune place de disponible", 1, 0, 130)
    end
end

function generateFarmPlate()
    local plateNumber = "FARM-" .. string.format("%03d", math.random(1, 999))
    return plateNumber
end
