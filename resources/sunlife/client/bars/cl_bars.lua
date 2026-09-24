ESX = nil
local playerJob = nil
local MenuOpened = false
local serviceon = false
local JobsList = {}

local EnAction = false

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    while ESX.PlayerData.job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData.job = job
    print("[DEBUG] Job mis à jour : " .. job.name)

    playerJob = ESX.PlayerData.job.name
    playerJob_grade = ESX.PlayerData.job.grade

    for k, v in pairs(jobs) do
        if ESX.PlayerData.job.name == v.metier then
            JobsList = {}
            JobsList = v
        end
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    RMenu.Add('menu', 'grill', RageUI.CreateMenu("SunLife", "Grill", 1, 100))
    RMenu.Add('menu', 'bar', RageUI.CreateMenu("SunLife", "Bar", 1, 100))
    RMenu.Add('menu', 'craft', RageUI.CreateMenu("SunLife", "Craft", 1, 100))
    RMenu.Add('menu', 'itemsShop', RageUI.CreateMenu("SunLife", "Shop", 1, 100))
    RMenu.Add('menu', 'garage', RageUI.CreateMenu("SunLife", "Garage", 1, 100))
    RMenu.Add('menu', 'f6', RageUI.CreateMenu("SunLife", "Menu", 1, 100))
    RMenu:Get('menu', 'grill'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'bar'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'craft'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'itemsShop'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'garage'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'f6'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'grill').EnableMouse = false
    RMenu:Get('menu', 'bar').EnableMouse = false
    RMenu:Get('menu', 'craft').EnableMouse = false
    RMenu:Get('menu', 'itemsShop').EnableMouse = false
    RMenu:Get('menu', 'garage').EnableMouse = false
    RMenu:Get('menu', 'f6').EnableMouse = false
    RMenu:Get('menu', 'grill').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'bar').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'craft').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'itemsShop').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'garage').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'f6').Closed = function()
        MenuOpened = false
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    playerJob = ESX.PlayerData.job.name
    playerJob_grade = ESX.PlayerData.job.grade

    for k, v in pairs(jobs) do
        if playerJob == v.metier then
            JobsList = v
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

    playerJob = ESX.PlayerData.job.name
    playerJob_grade = ESX.PlayerData.job.grade
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    ESX.PlayerData.job = job

    playerJob = ESX.PlayerData.job.name
    playerJob_grade = ESX.PlayerData.job.grade
end)

local open = false

function OpenBrBuilderVehicleMenu()
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'garage'), true)
    CreateThread(function ()
        while MenuOpened do
            RageUI.IsVisible(RMenu:Get('menu', 'garage'), true, true, true, function()
                local model = GetEntityModel(LastVeh)
                local displaytext = GetDisplayNameFromVehicleModel(model)
                local plate = GetVehicleNumberPlateText(LastVeh)
                if plate ~= nil then
                    RageUI.ButtonWithStyle("Ranger votre "..displaytext.." ["..plate.."]", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(LastVeh))
                        end
                    end)
                end
                RageUI.Separator("Véhicules")
                for k,v in pairs(voiture) do
                    local displaytext = GetDisplayNameFromVehicleModel(GetHashKey(v))
                    RageUI.ButtonWithStyle(displaytext, nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TrySpawnVehBars(v)
                            RageUI.CloseAll()
                            MenuOpened = false
                        end
                    end)
                end
            end, function()
            end)
            Wait(1)
        end
    end)
end

function OpenBrBuilderCraftMenu(items, metier)
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'craft'), true)

    CreateThread(function ()
        while MenuOpened do

            RageUI.IsVisible(RMenu:Get('menu', 'craft'), true, true, true, function()

                for k,v in pairs(items) do
                    RageUI.ButtonWithStyle(capitalizeFirstLetter(v.name), v.need.." secondes pour le craft", {RightLabel = ESX.Math.GroupDigits(v.need).." ingrédients pour x"..v.count}, true, function(Hovered, Active, Selected)
                        if Selected and not EnAction then

                            RageUI.CloseAll()
                            MenuOpened = false
                            ESX.TriggerServerCallback("brbuilder:craft", function(good)
                                if good then
                                    local ped = PlayerPedId()

                                    EnAction = true
                                    local success = lib.progressCircle({
                                        duration = v.need * 1000,
                                        label = '⏳ Craft en cours...',
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            car = true,
                                            move = true,
                                            combat = true,
                                        }
                                    })
                                    EnAction = false
                                    if success then
                                        ESX.TriggerServerCallback("brbuilder:getNeeds", function(needsCount)
                                            needs = needsCount
                                        end)
                                    else
                                        ESX.ShowNotification("~r~Craft annulé.")
                                    end
                                end
                            end, v)
                        end
                    end)
                end
            end, function()
            end)
            Wait(1)
        end
    end)
end
function OpenItemsShop(items)
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'itemsShop'), true)

    CreateThread(function ()
        while MenuOpened do

            RageUI.IsVisible(RMenu:Get('menu', 'itemsShop'), true, true, true, function()

                for k,v in pairs(items) do
                    RageUI.ButtonWithStyle(capitalizeFirstLetter(v.name), v.need, {RightLabel = v.price.." $"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("brbuilder:recupItem", v.item, v.price)
                        end
                    end)
                end
            end, function()
            end)
            Wait(1)
        end
    end)
end

function OpenBrBuilderBarMenu(metier)
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'bar'), true)
    CreateThread(function ()
        while MenuOpened do

            RageUI.IsVisible(RMenu:Get('menu', 'bar'), true, true, true, function()

                for k,v in pairs(item) do
                    RageUI.ButtonWithStyle(capitalizeFirstLetter(v.name), nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) and not EnAction then

                            EnAction = true
                            RageUI.CloseAll()
                            MenuOpened = false
                            ExecuteCommand("e bartender")
                            local done = lib.progressCircle({
                                duration = 15000,
                                useWhileDead = false,
                                canCancel = true,
                                label = '⌛ Préparation en cours...',
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                }
                            })
                            if done then
                                TriggerServerEvent("brbuilder:giveItem", v.item, metier)
                            end
                            EnAction = false
                        end
                    end)
                end
            end, function()
            end)
            Wait(1)
        end
    end)
end

function OpenBrBuilderGrillMenu(metier)
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'grill'), true)
    CreateThread(function ()
        while MenuOpened do

            RageUI.IsVisible(RMenu:Get('menu', 'grill'), true, true, true, function()

                for k,v in pairs(item) do
                    RageUI.ButtonWithStyle(capitalizeFirstLetter(v.name), nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) and not EnAction then

                            EnAction = true
                            RageUI.CloseAll()
                            MenuOpened = false
                            ExecuteCommand("e bartender")
                            local done = lib.progressCircle({
                                duration = 15000,
                                useWhileDead = false,
                                canCancel = true,
                                label = '⌛ Préparation en cours...',
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                }
                            })
                            if done then
                                TriggerServerEvent("brbuilder:giveItem", v.item, metier)
                            end
                            EnAction = false
                        end
                    end)
                end
            end, function()
            end)
            Wait(1)
        end
    end)
end

function OpenBrBuilderF6Menu()
    MenuOpened = true
    RageUI.Visible(RMenu:Get('menu', 'f6'), true)
    CreateThread(function ()
        while MenuOpened do

            RageUI.IsVisible(RMenu:Get('menu', 'f6'), true, true, true, function()
                if serviceon then
                    RageUI.ButtonWithStyle("~r~Fin de service", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent("brbuilder:RemovePlayer")

                            serviceon = false
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~g~Prise de service", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent("brbuilder:AddPlayer")

                            serviceon = true
                        end
                    end)
                end

                if serviceon then
                    RageUI.ButtonWithStyle("Facturation", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local job = ESX.PlayerData.job.name
                            TriggerEvent("sCore.sendBill", "society_" ..job)
                            RageUI.CloseAll()
                            MenuOpened = false
                        end
                    end)

                    RageUI.ButtonWithStyle("Annoncer l'ouverture", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent("brbuilder:annonce", 1)
                            serviceon = true
                        end
                    end)

                    RageUI.ButtonWithStyle("Annoncer la fermeture", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent("brbuilder:annonce", 2)
                            serviceon = true
                        end
                    end)
                end

            end, function()
            end)
            Wait(1)
        end
    end)

end

Citizen.CreateThread(function()
    while ESX == nil do Wait(1) end
    local attente = 150
    while JobsList.metier == nil do Wait(10000) end
    while true do
        Wait(attente)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local DansUneZone = false
        for k,v in pairs(JobsList) do

            if not DansUneZone and not EnAction then
                if JobsList.garage_on ~= false then
                    local dst_garage = GetDistanceBetweenCoords(pCoords, JobsList.garage.garage_coords, true)
                    if dst_garage <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.garage.garage_coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.garage.garage_coords.x, JobsList.garage.garage_coords.y, JobsList.garage.garage_coords.z - 1.0, "Garage "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if dst_garage <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    OpenBarsGarageMenu(JobsList.garage.vehicles, JobsList.garage.garage_spawn)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.ranger_on ~= false then
                    local dst_ranger = GetDistanceBetweenCoords(pCoords, JobsList.ranger_coords, true)
                    if dst_ranger <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.ranger_coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.ranger_coords.x, JobsList.ranger_coords.y, JobsList.ranger_coords.z - 1.0, "Rangement véhicule "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if dst_ranger <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId())))
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.coffre_on ~= false then
                    local ds_coffre = GetDistanceBetweenCoords(pCoords, JobsList.coffre_coords, true)
                    if ds_coffre <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.coffre_coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.coffre_coords.x, JobsList.coffre_coords.y, JobsList.coffre_coords.z - 1.0, "Coffre "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_coffre <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    TriggerEvent("coffres:openCoffre", JobsList.metier)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.vestiaire_on ~= false then
                    local ds_vestiaire = GetDistanceBetweenCoords(pCoords, JobsList.vestiaire_coords, true)
                    if ds_vestiaire <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.vestiaire_coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.vestiaire_coords.x, JobsList.vestiaire_coords.y, JobsList.vestiaire_coords.z - 1.0, "Vestiaire "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_vestiaire <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    TriggerEvent("snl_clothesshop:openVestiaire")
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.bar_on ~= false then
                    local ds_bar = GetDistanceBetweenCoords(pCoords, JobsList.bar.coords, true)
                    if ds_bar <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.bar.coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.bar.coords.x, JobsList.bar.coords.y, JobsList.bar.coords.z - 1.0, JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_bar <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    OpenBarMenu(JobsList.bar.items, JobsList.metier)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.craft and JobsList.craft.enabled then
                    local ds_bar = GetDistanceBetweenCoords(pCoords, JobsList.craft.pos, true)
                    if ds_bar <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.craft.pos, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.craft.pos.x, JobsList.craft.pos.y, JobsList.craft.pos.z - 1.0, JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_bar <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    OpenCraftMenu(JobsList.craft.items)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.shop and JobsList.shop.enabled then
                    local ds_bar = GetDistanceBetweenCoords(pCoords, JobsList.shop.pos, true)
                    if ds_bar <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.shop.pos, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.shop.pos.x, JobsList.shop.pos.y, JobsList.shop.pos.z - 1.0, JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_bar <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    OpenItemsShop(JobsList.shop.items)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.grill_on ~= false then
                    local ds_grill = GetDistanceBetweenCoords(pCoords, JobsList.grill.coords, true)
                    if ds_grill <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.grill.coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.grill.coords.x, JobsList.grill.coords.y, JobsList.grill.coords.z - 1.0, "Grill "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_grill <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    OpenGrillMenu(JobsList.grill.items, JobsList.metier)
                                end
                            end
                        end
                    end
                end
            end

            if not DansUneZone and not EnAction then
                if JobsList.bossmenu_on ~= false and playerJob_grade >= 3 then
                    local ds_bossmenu = GetDistanceBetweenCoords(pCoords, JobsList.bossmenu_coords, true)
                    if ds_bossmenu <= 3.0 then
                        DansUneZone = true
                        DrawMarker(25, JobsList.bossmenu_coords, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                        Draw3DTextH(JobsList.bossmenu_coords.x, JobsList.bossmenu_coords.y, JobsList.bossmenu_coords.z - 1.0, "Gestion de la société "..JobsList.colorBase..""..JobsList.metierLabel, 4, 0.1, 0.1)
                        if ds_bossmenu <= 1.5 then
                            if IsControlJustReleased(1, 38) then
                                if MenuOpened == false then
                                    TriggerEvent('esx_society:openBosstozMenu', JobsList.metier, function(data, menu)
                                    end)
                                end
                            end
                        end
                    end
                end
            end

            if DansUneZone then
                attente = 0
            else
                attente = 1000
            end
        end
    end
end)

RegisterCommand("OpenBrBuilderF6Menu", function()
    ESX.PlayerData = ESX.GetPlayerData()
    for k,v in pairs(jobs) do

        if playerJob == v.metier then
            isBarsEmployee = true

            RageUI.CloseAll()
            MenuOpened = false

            OpenBrBuilderF6Menu()
        end
    end
end, false)

RegisterKeyMapping("OpenBrBuilderF6Menu", "Ouvrir le menu F6 société", "keyboard", "F6")

function OpenBarsGarageMenu(vehs, spawn)
    if not IsPedInAnyVehicle(PlayerPedId(), 0) then
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 1)
    else
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 0)
    end
    voiture = vehs
    garage_spawn = spawn
    OpenBrBuilderVehicleMenu()
end

function OpenBarMenu(items, metier)
    if not IsPedInAnyVehicle(PlayerPedId(), 0) then
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 1)
    else
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 0)
    end
    item = items
    OpenBrBuilderBarMenu(metier)
end

function OpenCraftMenu(items)
    OpenBrBuilderCraftMenu(items)
end

function OpenGrillMenu(items, metier)
    if not IsPedInAnyVehicle(PlayerPedId(), 0) then
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 1)
    else
        LastVeh = GetVehiclePedIsIn(PlayerPedId(), 0)
    end
    item = items
    OpenBrBuilderGrillMenu(metier)
end

function OpenPatronMenu(metier)
    if playerJob_grade == 3 then
        TriggerEvent('esx_society:openBosstozMenu', metier, function(data, menu)
            menu.close()
        end, {wash = false})
    end
end

function GroupDigits(value)
	if value == nil then return 0 end
	local left,num,right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)', '%1'.." "):reverse())
end

function capitalizeFirstLetter(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function LookingForAPlaceBars()
    local found = false
    local pos = nil
    local heading = nil
    for k,v in pairs(garage_spawn) do
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

local barsPlate = {
    ["beachclub"] = "BEA-",
    ["kebab"] = "KEB-",
    ["ltdsud"] = "LTD-",
    ["unicorn"] = "UNI-",
    ["bahamas"] = "BAH-",
    ["galaxy"] = "GLX-",
    ["tequilala"] = "TEQ-",
    ["yellowjack"] = "YEL-",
    ["burgershot"] = "BGS-",
    ["izakaya"] = "IZA-",
    ["uwu"] = "UWU-",
    ["blackwoods"] = "BLC-",
}

local function generateBarsPlate(playerJob)
    local prefix = barsPlate[playerJob]
    if not prefix then
        return nil
    end

    local randomPlate = string.format("%03d", math.random(1, 999))
    local plate = prefix .. randomPlate
    return plate:upper()
end

function TrySpawnVehBars(veh, x, cust, c1, c2, curr_plate, tin)
    local pos, heading = LookingForAPlaceBars()
    ESX.PlayerData = ESX.GetPlayerData()
    local jobName = ESX.PlayerData.job and ESX.PlayerData.job.name

    if pos then
        local model = GetHashKey(veh)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(1) end

        TriggerServerEvent('eye:veh:authorize', model, 'job')
        print(('^5[NETDIAG][VEHICLE]^7 %s cl_bars.lua:686 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
        local vehicle = CreateVehicle(model, pos, heading, true, false)

        local plate = generateBarsPlate(jobName)

        SetVehicleNumberPlateText(vehicle, plate)
        SetEntityHeading(vehicle, heading)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

        local NetId = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(NetId, true)

        ESX.ShowNotification("Véhicule sorti !", 1, 0, 60)
    else
        ESX.ShowNotification("Aucune place de disponible", 1, 0, 130)
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(jobs) do
        local brblips = AddBlipForCoord(v.blips.coords)
        SetBlipSprite(brblips, v.blips.blipSprite)
        SetBlipColour(brblips, v.blips.colorBlip)
        SetBlipScale(brblips, 0.8)
        SetBlipAsShortRange(brblips, true)
        local _key = "BN_SUNLIFE_BARS_1_" .. tostring(brblips)
        AddTextEntry(_key, v.metierLabel)
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(brblips)
    end
    Wait(0)
end)

AddEventHandler('gameEventTriggered', function(name, args)
	if name == 'CEventNetworkEntityDamage' then
		if args[7] == GetHashKey('WEAPON_BEANBAG') and args[1] == PlayerPedId() then
			ClearEntityLastDamageEntity(PlayerPedId())
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)

			local time = GetGameTimer() + 7 * 1000
			Citizen.CreateThread(function()
				while time > GetGameTimer() do
					SetPedToRagdoll(PlayerPedId(), 100, 100, 0)
					Citizen.Wait(0)
				end
			end)

			Citizen.Wait(4000)
			SetTransitionTimecycleModifier("hud_def_desat_Trevor", 2.5)
			Citizen.Wait(3000)
			SetTransitionTimecycleModifier('default', 2.5)
			Citizen.Wait(500)
			ClearTimecycleModifier()
			StopGameplayCamShaking()
		end
	end
end)
