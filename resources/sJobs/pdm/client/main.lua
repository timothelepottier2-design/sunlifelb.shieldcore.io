ESX = nil

local OnCataActive = false
local VehiculeRecup = false
local lastcarout = {}
local prevdata = {}
local cache = {}
local firstplaceshowroomsortie = {}
local secondplaceshowroomsortie = {}
local threeplaceshowroomsortie = {}
local fourthplaceshowroomsortie = {}
cache.value = nil
local cacheShowRoom = {}
local OnCataActive2 = false
local cacheName = {}

local SpawnVehShowRoom
local suppauto
local firstToUpper
local MarquerJoueur
local showCar
local openCatalogueMenu
local openCataGens

RegisterNetEvent("spawnVehPresentoire", function (index, name)
    SpawnVehShowRoom(index, name)
end)

RegisterNetEvent("deleteveh", function (index)
    if cacheShowRoom[index] ~= nil then
        DeleteEntity(cacheShowRoom[index])
        cacheShowRoom[index] = nil
        cacheName[index] = nil
    end
end)

RegisterNetEvent("getCache", function (data)
    cacheShowRoom = data
    for i = 1, #cacheShowRoom do
        SpawnVehShowRoom(i, cacheShowRoom[i])
    end
end)

CreateThread(function ()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())

        for key, value in pairs(showroom_pdm) do
            local dst = #(pCoords - value.xyz)

            if dst >= 200 then
                if cacheShowRoom[key] ~= nil then
                    if DoesEntityExist(cacheShowRoom[key]) then
                        DeleteEntity(cacheShowRoom[key])
                        cacheShowRoom[key] = nil
                    end
                end
            else
                if cacheShowRoom[key] == nil then
                    SpawnVehShowRoom(key, cacheName[key])
                end
            end
        end
        Wait(800)
    end
end)

SpawnVehShowRoom = function(index, name)
    local ModelHash = GetHashKey(name)
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Wait(500)
    end
    cacheShowRoom[index] = CreateVehicle(ModelHash, showroom_pdm[index].xyz, showroom_pdm[index].w, false, false)
    SetVehicleNumberPlateText(cacheShowRoom[index], "SHOWVEC")
    SetModelAsNoLongerNeeded(ModelHash)
    FreezeEntityPosition(cacheShowRoom[index], true)
    cacheName[index]  = name
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    TriggerServerEvent("pdm:getCache")

	RMenu.Add('menu', 'Catalogue', RageUI.CreateMenu("SunLife", "PDM Autos", 1, 100))
    RMenu.Add('menu', 'concess_choose', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "PDM Autos", 1, 100))
    RMenu.Add('menu', 'concess_choosecitoyen', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "PDM Autos", 1, 100))
    RMenu:Get('menu', 'Catalogue'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'concess_choose'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'concess_choosecitoyen'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'Catalogue').EnableMouse = false
    RMenu:Get('menu', 'Catalogue').Closed = function()
        suppauto()
    end
    RMenu:Get('menu', 'Catalogue').Closed = function()
		OnCataActive = false
    end

    for k,v in pairs(cfg_catalogue.vehicles) do
        RMenu.Add('menu', v.value, RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "PDM Autos", 1, 100))
        RMenu:Get('menu', v.value):SetRectangleBanner(255, 117, 31, 225)
        RMenu:Get('menu', v.value):SetSubtitle(v.cat_name)
        RMenu:Get('menu', v.value).Closed = function()
            suppauto()
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    Wait(10000)
    TriggerServerEvent("pdm:AddPlayer")
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    ESX.PlayerData.job = job
    if job.name == "pdm" then
        TriggerServerEvent("pdm:AddPlayer")
        print("Employé PDM détecté")
    end
end)

showCar = function(car)
    local car = GetHashKey(car)

    suppauto()

    ESX.Game.SpawnLocalVehicle(car, {x = -36.73, y = -1093.2, z = 27.3}, 142.56, function(vehicle)
        table.insert(lastcarout, vehicle)
        FreezeEntityPosition(vehicle, true)
        SetVehicleUndriveable(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetModelAsNoLongerNeeded(car)
    end)
end

openCatalogueMenu = function()
    local modelname = nil
    if OnCataActive then
        RageUI.CloseAll()
        OnCataActive = false
        return
    else
        OnCataActive = true
        RageUI.Visible(RMenu:Get('menu', 'Catalogue'), true)

        Citizen.CreateThread(function()
            while OnCataActive do
                RageUI.IsVisible(RMenu:Get('menu', 'Catalogue'), true, true, true, function()
                    RageUI.Separator("Catégories")
                    for k,v in pairs(cfg_catalogue.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_catalogue.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()

                        RageUI.Separator("Véhicules")
                        for y,la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2).."$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if prevdata[y] ~= y then
                                        prevdata[y-1] = nil
                                        prevdata[y+1] = nil

                                        showCar(la.hash)

                                        prevdata[y] = y
                                    end
                                end
                                if ESX.PlayerData.job.name == 'pdm' then
                                    if Selected then
                                        cache.value = la.hash
                                        suppauto()
                                        ESX.ShowNotification("~g~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'concess_choose'))
                        end

                    end, function()
                    end)
                end
                    RageUI.IsVisible(RMenu:Get('menu', 'concess_choose'), true, true, true, function()
                        local player, distance = ESX.Game.GetClosestPlayer()

                        RageUI.Separator("Nom du véhicule: " ..cache.value)
                        RageUI.ButtonWithStyle('Sortir le véhicule pour test drive', nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('eye:veh:authorize', cache.value, 'concess')
                                ESX.Game.SpawnVehicle(cache.value, vector3(-14.61, -1085.16, 27.04), 69.31, function(vehicle)
                                    SetVehicleNumberPlateText(vehicle, "TESTD")
                                    RageUI.CloseAll()
                                    OnCataActive = false
                                end)
                            end
                        end)
                        RageUI.ButtonWithStyle('Vendre le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                            if Active then
                                MarquerJoueur()
                            end
                            if Selected then
                                if player ~= -1 and distance <= 3.0 then
                                    local newPlate = GeneratePlate()

                                    local vehicleProps = {
                                        model = cache.value,
                                        plate = newPlate,
                                        position = vector3(-14.61, -1085.16, 27.04),
                                        heading = 69.31
                                    }

                                    TriggerServerEvent('eye:veh:authorize', vehicleProps.model, 'concess')
                                    ESX.Game.SpawnVehicle(vehicleProps.model, vehicleProps.position, vehicleProps.heading, function(vehicle)
                                        if vehicle then
                                            SetVehicleNumberPlateText(vehicle, vehicleProps.plate)
                                            local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                            actualProps.plate = vehicleProps.plate

                                            TriggerServerEvent('concess:giveAutotoId', GetPlayerServerId(player), actualProps, GetDisplayNameFromVehicleModel(actualProps.model), true)

                                            RageUI.CloseAll()
                                            suppauto()
                                            OnCataActive = false
                                        else
                                            print("Erreur : Impossible de générer le véhicule.")
                                        end
                                    end)
                                end
                            end
                        end)
                        RageUI.Separator("Emplacement")
                        for i = 1, #showroom_pdm do
                            if cacheShowRoom[i] then
                                RageUI.ButtonWithStyle("Supprimer véhicule #"..i, nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("pdm:deleteveh", i)
                                    end
                                end)
                            else
                                RageUI.ButtonWithStyle("Emplacement #"..i, nil, {RightLabel = "Libre"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("pdm:spawnVehPresentoire", i , cache.value)
                                    end
                                end)
                            end
                        end
                    end, function()
                    end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

openCataGens = function()
    local modelname = nil
    if OnCataActive then
        RageUI.CloseAll()
        OnCataActive = false
        return
    else
        OnCataActive = true
        RageUI.Visible(RMenu:Get('menu', 'Catalogue'), true)

        Citizen.CreateThread(function()
            while OnCataActive do
                RageUI.IsVisible(RMenu:Get('menu', 'Catalogue'), true, true, true, function()
                    RageUI.Separator("~o~Payez jusqu'à -50% avec le VIP !")
                    RageUI.ButtonWithStyle("Acheter un véhicule boutique", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RageUI.CloseAll()
                            OnCataActive = false
                            ExecuteCommand('menuboutiqueM')
                        end
                    end)
                    RageUI.Separator()
                    for k,v in pairs(cfg_catalogue.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_catalogue.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()

                        RageUI.Separator("Véhicules")
                        for y,la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2).."$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if prevdata[y] ~= y then
                                        prevdata[y-1] = nil
                                        prevdata[y+1] = nil

                                        showCar(la.hash)

                                        prevdata[y] = y
                                    end
                                end
                                if Selected then
                                    cache.value = la.hash
                                    suppauto()
                                    ESX.ShowNotification("~g~Vous avez sélectionné: " ..la.hash)
                                end
                            end, RMenu:Get('menu', 'concess_choosecitoyen'))
                        end

                    end, function()
                    end)
                end
                RageUI.IsVisible(RMenu:Get('menu', 'concess_choosecitoyen'), true, true, true, function()
                    RageUI.Separator("Nom du véhicule: " ..cache.value)

                    RageUI.ButtonWithStyle('Acheter le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('concess:ifHasMoney', function(hasMoney)
                                if not hasMoney then
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent !")
                                    return
                                else
                                    ESX.TriggerServerCallback('pdm:getIfCompanyOpen', function(playerFound)
                                        if playerFound then
                                            ESX.ShowNotification("~r~Vous ne pouvez pas acheter ce véhicule puisqu'un employé de la concession est en service !")
                                        else
                                            if cache.value ~= nil then
                                                local model = GetHashKey(cache.value)
                                                RequestModel(model)

                                                local attempts = 0
                                                while not HasModelLoaded(model) and attempts < 10 do
                                                    Wait(500)
                                                    attempts = attempts + 1
                                                    print("Tentative de chargement : " .. attempts)
                                                end

                                                if HasModelLoaded(model) then
                                                    print("Modèle chargé avec succès.")
                                                    local newPlate = GeneratePlate()
                                                    local vehicleProps = {
                                                        model = model,
                                                        position = vector3(-14.61, -1085.16, 27.04),
                                                        heading = 69.31,
                                                        plate = newPlate
                                                    }

                                                    TriggerServerEvent('eye:veh:authorize', model, 'concess')
                                                    local vehicle = CreateVehicle(model, vehicleProps.position.x, vehicleProps.position.y, vehicleProps.position.z, vehicleProps.heading, true, false)

                                                    if vehicle then
                                                        SetVehicleNumberPlateText(vehicle, vehicleProps.plate)
                                                        local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                                        actualProps.plate = vehicleProps.plate
                                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                                                        TriggerServerEvent('concess:giveAutotoId', GetPlayerServerId(PlayerId()), actualProps, GetDisplayNameFromVehicleModel(actualProps.model), false)

                                                        RageUI.CloseAll()
                                                        OnCataActive = false
                                                        suppauto()
                                                    else
                                                        print("Échec de la création du véhicule.")
                                                        ESX.ShowNotification("~r~Erreur : Impossible de générer le véhicule.")
                                                    end
                                                else
                                                    print("Échec du chargement du modèle.")
                                                    ESX.ShowNotification("~r~Erreur : Le modèle du véhicule n'a pas pu être chargé.")
                                                end
                                            else
                                                ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                                            end
                                        end
                                    end)
                                end
                            end, cache.value)
                        end
                    end)

                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

suppauto = function()
    for k,v in pairs(lastcarout) do
		ESX.Game.DeleteVehicle(v)
		lastcarout[k] = nil
    end
end

local catalogue = {
	{x = -31.23, y = -1097.91, z = 26.37, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catalogue) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catalogue[k].x, catalogue[k].y, catalogue[k].z)
			local dst1 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -42.15, -1101.56, 27.3)
            local dst2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -49.42, -1083.58, 27.3)
            local dst3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -54.87, -1096.93, 27.3)
            local dst4 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -47.3, -1092.11, 27.3)

			if dist <= 3.0 then
				nearThing = true

                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'pdm' then
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de la concession")
                    DrawMarker(6, catalogue[k].x, catalogue[k].y, catalogue[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				    if IsControlJustPressed(1,38) then
                        local playerInService = exports["sJobs"]:inService()

                        if not playerInService then
                            ESX.ShowNotification("~r~Vous devez d'abord être en service !")
                        else
				    	    openCatalogueMenu()
                        end
				    end
                end
			end
		end
		if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

local catagens = {
	{x = -42.87, y = -1090.19, z = 26.37, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catagens) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catagens[k].x, catagens[k].y, catagens[k].z)

			if dist < 10.0 then
				nearThing = true
                DrawMarker(6, catagens[k].x, catagens[k].y, catagens[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au catalogue")
					if IsControlJustPressed(1, 38) then
                        if OnCataActive == false then
                            openCataGens()
                        end
					end
				end
			end
		end
		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("SunLife", "Menu Fourrière", 1, 100))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		OnCataActive = false
    end
end)

firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

MarquerJoueur = function()
    local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local pos = GetEntityCoords(ped)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <= 4.0 then
        DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 117, 31, 225, 0, 1, 2, 1, nil, nil, 0)
    end
end

function DeleteVehicleFromShowroom(place)
    if place == 1 then
        while #firstplaceshowroomsortie > 0 do
            local vehicle = firstplaceshowroomsortie[1]

            ESX.Game.DeleteVehicle(vehicle)
            table.remove(firstplaceshowroomsortie, 1)
        end
    elseif place == 2 then
        while #secondplaceshowroomsortie > 0 do
            local vehiclede = secondplaceshowroomsortie[1]

            ESX.Game.DeleteVehicle(vehiclede)
            table.remove(secondplaceshowroomsortie, 1)
        end
    elseif place == 3 then
        while #threeplaceshowroomsortie > 0 do
            local vehicletr = threeplaceshowroomsortie[1]

            ESX.Game.DeleteVehicle(vehicletr)
            table.remove(threeplaceshowroomsortie, 1)
        end
    elseif place == 4 then
        while #fourthplaceshowroomsortie > 0 do
            local vehicletr = fourthplaceshowroomsortie[1]

            ESX.Game.DeleteVehicle(vehicletr)
            table.remove(fourthplaceshowroomsortie, 1)
        end
    end
end

local rangerpdm = {
	{x = -11.48 , y = -1081.14, z = 26.05, },
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(rangerpdm) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, rangerpdm[k].x, rangerpdm[k].y, rangerpdm[k].z)
            local last_veh = GetVehiclePedIsIn(PlayerPedId(), 1)

			if dist <= 20.0 then
                DrawMarker(6, rangerpdm[k].x, rangerpdm[k].y, rangerpdm[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				nearThing = true
                if dist <= 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ranger un véhicule")
                    if IsControlJustPressed(1,51) then
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId())))
                            ESX.ShowNotification("~g~Votre véhicule a été rangé !")
                        else
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
                        end
                    end
                end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

function ImpoundVehicle(vehicle)
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    if IsPedInAnyVehicle(playerPed, true) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    end
    local entity = vehicle
    carModel = GetEntityModel(entity)
    carName = GetDisplayNameFromVehicleModel(carModel)
    NetworkRequestControlOfEntity(entity)

    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    SetEntityAsMissionEntity(entity, true, true)

    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )

    if (DoesEntityExist(entity)) then
        DeleteEntity(entity)
    end
end
