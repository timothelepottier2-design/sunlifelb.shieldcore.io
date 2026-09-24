ESX = nil

local OnCataActive = false
local VehiculeRecup = false
local lastcarout = {}
local prevdata = {}
local cache = {}
local cacheShowRoom= {}
local cacheName = {}

local SpawnVehShowRoom
local suppauto
local firstToUpper
local MarquerJoueur
local showCar
local openCatalogueMenu
local openCataGens

RegisterNetEvent("spawnVehPresentoirepaletoauto", function (index, name)
    SpawnVehShowRoom(index, name)
end)

CreateThread(function ()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())

        for key, value in pairs(showroom_paleto) do
            local dst = #(pCoords - vector3(value.x, value.y, value.z))

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

RegisterNetEvent("deletevehpaletoauto", function (index)
    if cacheShowRoom[index] ~= nil then
        DeleteEntity(cacheShowRoom[index])
        cacheShowRoom[index] = nil
        cacheName[index] = nil
    end
end)

RegisterNetEvent("getCachepaletoauto", function (data)
    cacheShowRoom = data
    for i = 1, #cacheShowRoom do
        SpawnVehShowRoom(i, cacheShowRoom[i])
    end
end)

SpawnVehShowRoom = function(index, name)
    local ModelHash = GetHashKey(name)
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Wait(500)
    end
    cacheShowRoom[index] = CreateVehicle(ModelHash, showroom_paleto[index].xyz, showroom_paleto[index].w, false, false)
    SetVehicleNumberPlateText(cacheShowRoom[index], "SHOWVEC")
    SetModelAsNoLongerNeeded(ModelHash)
    FreezeEntityPosition(cacheShowRoom[index], true)
    cacheName[index]  = name
end

cache.value = null
local OnCataActive2 = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    TriggerServerEvent("paletoauto:getCache")

	RMenu.Add('menu', 'Catalogue', RageUI.CreateMenu("SunLife", "Paleto Automobiles", 1, 100))

    RMenu.Add('menu', 'paletoauto_choose', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "PALETOAUTO Autos", 1, 100))

    RMenu.Add('menu', 'paletoauto_choosecitoyen', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "Paleto Automobiles", 1, 100))
    RMenu:Get('menu', 'Catalogue'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'paletoauto_choose'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'paletoauto_choosecitoyen'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'Catalogue').EnableMouse = false
    RMenu:Get('menu', 'Catalogue').Closed = function()
        OnCataActive = false
        suppauto()
    end
    RMenu:Get('menu', 'paletoauto_choose').Closed = function()
        suppauto()
    end
    RMenu:Get('menu', 'paletoauto_choosecitoyen').Closed = function()
        suppauto()
    end

    for k,v in pairs(cfg_cataloguepaleto.vehicles) do
        RMenu.Add('menu', v.value, RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "SunLife", "Paleto Automobiles", 1, 100))
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
	TriggerServerEvent("paletoauto:AddPlayer")
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	TriggerServerEvent("paletoauto:AddPlayer")
end)

showCar = function(car)
    local car = GetHashKey(car)

    suppauto()

    ESX.Game.SpawnLocalVehicle(car, {x = -241.56788635254, y = 6210.6186523438, z = 32.063236236572}, 45.118511199951, function(vehicle)
        table.insert(lastcarout, vehicle)
        FreezeEntityPosition(vehicle, true)
        SetVehicleUndriveable(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetModelAsNoLongerNeeded(car)
    end)
end
local inService = false
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
                    if not inService then
                        RageUI.ButtonWithStyle("Prendre son service ", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                inService = true
                                ESX.ShowNotification("Vous avez pris votre service")
								TriggerServerEvent("socore:server:serviceStatut")
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Terminer son service ", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                inService = false
                                ESX.ShowNotification("Service terminé")
								TriggerServerEvent("socore:server:serviceStatut")
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle("Annoncer l'ouverture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("paletoauto:openPaletoauto")
                        end
                    end)
                    RageUI.ButtonWithStyle("Annoncer la fermeture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("paletoauto:closePaletoauto")
                        end
                    end)
                    RageUI.Separator("Catégories")
                    for k,v in pairs(cfg_cataloguepaleto.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_cataloguepaleto.vehicles) do
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
                                if ESX.PlayerData.job.name == 'paletoauto' then
                                    if Selected then
                                        cache.value = la.hash
                                        suppauto()
                                        ESX.ShowNotification("~o~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'paletoauto_choose'))
                        end

                    end, function()
                    end)
                end
                    RageUI.IsVisible(RMenu:Get('menu', 'paletoauto_choose'), true, true, true, function()
                        local player, distance = ESX.Game.GetClosestPlayer()

                        RageUI.Separator("Nom du véhicule: " ..cache.value)
                        RageUI.ButtonWithStyle('Sortir le véhicule pour test drive', nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('eye:veh:authorize', cache.value, 'concess')
                                ESX.Game.SpawnVehicle(cache.value, vector3(-222.7119, 6251.771, 31.49203), 44.30, function(vehicle)
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
                                        position = vector3(-222.7119, 6251.771, 31.49203),
                                        heading = 44.30
                                    }

                                    TriggerServerEvent('eye:veh:authorize', vehicleProps.model, 'concess')
                                    ESX.Game.SpawnVehicle(vehicleProps.model, vehicleProps.position, vehicleProps.heading, function(vehicle)
                                        if vehicle then
                                            SetVehicleNumberPlateText(vehicle, vehicleProps.plate)
                                            local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                            actualProps.plate = vehicleProps.plate

                                            TriggerServerEvent('paletoauto:giveAutotoId', GetPlayerServerId(player), actualProps, GetDisplayNameFromVehicleModel(actualProps.model))

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
                        for i = 1, #showroom_paleto do
                            if cacheShowRoom[i] then
                                RageUI.ButtonWithStyle("Supprimer véhicule #"..i, nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("paletoAuto:deleteveh", i)
                                    end
                                end)
                            else
                                RageUI.ButtonWithStyle("Emplacement #"..i, nil, {RightLabel = "Libre"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("paletoAuto:spawnVehPresentoire", i , cache.value)

                                    end
                                end)
                            end
                        end
                    end, function()
                    end)
                if RageUI.CurrentMenu == nil then
                    OnCataActive = false
                    suppauto()
                end
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local AUTO_BUY_SPAWN <const> = vector3(-222.7119, 6251.771, 31.49203)
local AUTO_BUY_HEADING <const> = 44.30

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
                    for k,v in pairs(cfg_cataloguepaleto.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_cataloguepaleto.vehicles) do
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
                                    ESX.ShowNotification("~o~Vous avez sélectionné: " ..la.hash)
                                end
                            end, RMenu:Get('menu', 'paletoauto_choosecitoyen'))
                        end

                    end, function()
                    end)
                end

                RageUI.IsVisible(RMenu:Get('menu', 'paletoauto_choosecitoyen'), true, true, true, function()
                    RageUI.Separator("Nom du véhicule: " ..tostring(cache.value))

                    RageUI.ButtonWithStyle('Acheter le véhicule', "Disponible uniquement quand aucun employé n'est en service.", {}, true, function(Hovered, Active, Selected)
                        if not Selected then return end

                        if cache.value == nil then
                            ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                            return
                        end

                        ESX.TriggerServerCallback('paletoauto:ifHasMoney', function(hasMoney)
                            if not hasMoney then
                                ESX.ShowNotification("~r~Vous n'avez pas assez d'argent !")
                                return
                            end

                            ESX.TriggerServerCallback('paletoauto:getIfCompanyOpen', function(playerFound)
                                if playerFound then
                                    ESX.ShowNotification("~r~Vous ne pouvez pas acheter ce véhicule puisqu'un employé de la concession est en service !")
                                    return
                                end

                                local model = GetHashKey(cache.value)
                                RequestModel(model)

                                local attempts = 0
                                while not HasModelLoaded(model) and attempts < 10 do
                                    Wait(500)
                                    attempts = attempts + 1
                                end

                                if not HasModelLoaded(model) then
                                    ESX.ShowNotification("~r~Erreur : Le modèle du véhicule n'a pas pu être chargé.")
                                    return
                                end

                                local newPlate = GeneratePlate()

                                TriggerServerEvent('eye:veh:authorize', model, 'concess')
                                local vehicle = CreateVehicle(model, AUTO_BUY_SPAWN.x, AUTO_BUY_SPAWN.y, AUTO_BUY_SPAWN.z, AUTO_BUY_HEADING, true, false)
                                SetModelAsNoLongerNeeded(model)

                                if not vehicle or vehicle == 0 then
                                    ESX.ShowNotification("~r~Erreur : Impossible de générer le véhicule.")
                                    return
                                end

                                SetVehicleNumberPlateText(vehicle, newPlate)
                                local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                actualProps.plate = newPlate
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                                TriggerServerEvent('paletoauto:buyAuto', actualProps, GetDisplayNameFromVehicleModel(actualProps.model))

                                RageUI.CloseAll()
                                OnCataActive = false
                                suppauto()
                            end)
                        end, cache.value)
                    end)
                end, function()
                end)

                if RageUI.CurrentMenu == nil then
                    OnCataActive = false
                    suppauto()
                end
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("SunLife", "Menu Paleto Automobiles", 1, 100))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		OnCataActive = false
    end
end)

suppauto = function()
    for k,v in pairs(lastcarout) do
		ESX.Game.DeleteVehicle(v)
		lastcarout[k] = nil
    end
end

local catalogue = {
	{x = -211.50770568848, y = 6224.6733398438, z = 31.044072723389, },
    {x = -211.50770568848, y = 6224.6733398438, z = 31.044072723389, },
	{x = -218.11053466797, y = 6217.5400390625, z = 31.04408416748, },
    {x = -222.80526733398, y = 6213.0395507812, z = 31.04409942627, },
    {x = -206.032639, y = 6230.938965, z = 31.044082, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catalogue) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catalogue[k].x, catalogue[k].y, catalogue[k].z)

			if dist <= 3.0 then
				nearThing = true

                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'paletoauto' then
                    ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour ouvrir le menu du Paleto Automobiles")
                    DrawMarker(6, catalogue[k].x, catalogue[k].y, catalogue[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
				    if IsControlJustPressed(0,38) then
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
	{x = -235.54096984863, y = 6216.4892578125, z = 30.944082260132, }
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
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~catalogue")
					if IsControlJustPressed(1, 38) then
                        openCataGens()
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

firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

MarquerJoueur = function()
    local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local pos = GetEntityCoords(ped)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <= 4.0 then
        DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 117, 31, 225, 1, 2, 1, nil, nil, 0)
    end
end

local rangerpaletoauto = {
	{x = -246.7126, y = 6222.828, z = 30.757, },
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(rangerpaletoauto) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, rangerpaletoauto[k].x, rangerpaletoauto[k].y, rangerpaletoauto[k].z)
            local last_veh = GetVehiclePedIsIn(PlayerPedId(), 1)

			if dist <= 20.0 then
                DrawMarker(6, rangerpaletoauto[k].x, rangerpaletoauto[k].y, rangerpaletoauto[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false)
				nearThing = true
                if dist <= 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~r~E~w~] pour ranger un ~r~véhicule")
                    if IsControlJustPressed(1,51) then
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId())))
                            ESX.ShowNotification("~o~Votre véhicule a été rangé !")
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
