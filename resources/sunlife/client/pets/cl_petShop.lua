Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

PETSHOP = {}
PETSHOP.data = {}

PETSHOP.openMyAnimalsMenu = function()
    RMenu.Add('petShop', 'main_menu', RageUI.CreateMenu("SunLife", "Mes animaux", 1, 100))
    RMenu.Add('petShop', 'main_menu_edit', RageUI.CreateSubMenu(RMenu:Get('petShop', 'main_menu'), "SunLife", "Mes animaux"))
    RMenu:Get('petShop', 'main_menu'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('petShop', 'main_menu_edit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('petShop', "main_menu").Closed = function()
        PETSHOP.menuOpenned = false

        RMenu:Delete('petShop', 'main_menu')
    end

    if PETSHOP.menuOpenned then
        PETSHOP.menuOpenned = false
        return
    else
        RageUI.CloseAll()

        PETSHOP.menuOpenned = true
        RageUI.Visible(RMenu:Get('petShop', 'main_menu'), true)
    end

    PETSHOP.itemData = {}

    Citizen.CreateThread(function()
        while PETSHOP.menuOpenned do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('petShop', 'main_menu'), true, true, true, function()

                for k,v in pairs(playerPets) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PETSHOP.itemData = v
                        end
                    end, RMenu:Get('petShop', 'main_menu_edit'))
                end

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('petShop', 'main_menu_edit'), true, true, true, function()

                RageUI.Separator(PETSHOP.itemData.label)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Changer de nom", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                    if s then
                        local result = KeyboardInput("Comment voulez-vous nommer votre animal ?", "", 30, false)

                        if result ~= nil then
                            result = tostring(result)

                            TriggerServerEvent("playerPets:edit", PETSHOP.itemData.id, result)

                            RageUI.GoBack()
                        end
                    end
                end)

                RageUI.ButtonWithStyle("~r~Abandonner", "~r~Attention : cette action est irréversible, l'animal sera définitivement retiré de votre liste.", {RightLabel = "→→→"}, true, function(h, a, s)
                    if s then
                        local confirm = KeyboardInput("Tapez OUI pour confirmer l'abandon de votre animal", "", 3, false)

                        if confirm ~= nil and string.upper(tostring(confirm)) == "OUI" then

                            if DoesEntityExist(PETSHOP.animalEntity) then
                                DeleteEntity(PETSHOP.animalEntity)
                                PETSHOP.animalEntity = nil
                            end

                            TriggerServerEvent("playerPets:abandon", PETSHOP.itemData.id)
                            ESX.ShowNotification("~o~Vous avez abandonné votre animal.")

                            RageUI.GoBack()
                        else
                            ESX.ShowNotification("~r~Abandon annulé.")
                        end
                    end
                end)

                if not DoesEntityExist(PETSHOP.animalEntity) then
                    RageUI.ButtonWithStyle("Faire apparaître", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                        if s then
                            PETSHOP.data.label = PETSHOP.itemData.label
                            PETSHOP.SpawnAnimal(PETSHOP.itemData.hash)
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Faire disparaître", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                        if s then
                            DeleteEntity(PETSHOP.animalEntity)
                            PETSHOP.animalEntity = nil
                        end
                    end)
                    RageUI.Separator("")
                end

                if DoesEntityExist(PETSHOP.animalEntity) then
                    if PETSHOP.data.follow == nil then PETSHOP.data.follow = false end
                    if PETSHOP.data.follow then
                        RageUI.ButtonWithStyle("Ordonner de suivre", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.FollowAnimal()
                                end)
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Ordonner de ne plus suivre", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.FollowAnimal()
                                end)
                            end
                        end)
                    end

                    if PETSHOP.data.stand == nil then PETSHOP.data.stand = false end
                    if PETSHOP.data.stand then
                        RageUI.ButtonWithStyle("Ordonner de se lever", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.SitAnimal()
                                end)
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Ordonner de s'asseoir", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.SitAnimal()
                                end)
                            end
                        end)
                    end

                    if PETSHOP.data.inCar == nil then PETSHOP.data.inCar = true end
                    if PETSHOP.data.inCar then
                        RageUI.ButtonWithStyle("Ordonner de monter dans la voiture", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.CarAnimal()
                                end)
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Ordonner de descendre de la voiture", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                            if s then
                                Citizen.CreateThread(function()
                                    PETSHOP.CarAnimal()
                                end)
                            end
                        end)
                    end
                end

            end, function()
            end)
        end
    end)
end

PETSHOP.openShop = function()
    RMenu.Add('petShop', 'main_menu', RageUI.CreateMenu("SunLife", "Animalerie", 1, 100))
    RMenu:Get('petShop', 'main_menu'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('petShop', "main_menu").Closed = function()
        PETSHOP.menuOpenned = false

        RMenu:Delete('petShop', 'main_menu')
    end

    if PETSHOP.menuOpenned then
        PETSHOP.menuOpenned = false
        return
    else
        RageUI.CloseAll()

        PETSHOP.menuOpenned = true
        RageUI.Visible(RMenu:Get('petShop', 'main_menu'), true)
    end

    PETSHOP.index = 1

    Citizen.CreateThread(function()
        while PETSHOP.menuOpenned do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('petShop', 'main_menu'), true, true, true, function()

                RageUI.List("Mode de paiement", cfg_petShop.payments, PETSHOP.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                    PETSHOP.index = Index
                end)

                RageUI.Separator("")

                for k,v in pairs(cfg_petShop.animals) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = ESX.Math.GroupDigits(v.price).."$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            v.method = PETSHOP.index
                            TriggerServerEvent("petShop:buy", v)
                        end
                    end)
                end

            end, function()
            end)
        end
    end)
end

PETSHOP.SpawnAnimal = function(hash)
    if DoesEntityExist(PETSHOP.animalEntity) then DeleteEntity(PETSHOP.animalEntity) PETSHOP.animalEntity = nil return end

    local model = GetHashKey(hash)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    print(('^6[NETDIAG][PED]^7 %s cl_petShop.lua:232 CreatePed NETWORKED animal model=%s'):format(GetCurrentResourceName(), tostring(model)))
    PETSHOP.animalEntity = CreatePed(4, model, GetEntityCoords(PlayerPedId()), 0.0, true, false)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(PETSHOP.animalEntity), true)
    SetEntityAsMissionEntity(PETSHOP.animalEntity, true, true)
    SetModelAsNoLongerNeeded(model)

    SetEntityHealth(PETSHOP.animalEntity, 100.0)
    SetPedCombatAttributes(PETSHOP.animalEntity, 16, true)
    SetPedCanBeTargetted(PETSHOP.animalEntity, false)

    TaskFollowToOffsetOfEntity(PETSHOP.animalEntity, PlayerPedId(), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
    SetPedKeepTask(PETSHOP.animalEntity, true)
    CanPedRagdoll(PETSHOP.animalEntity, false)

    PETSHOP.animalBlip = AddBlipForEntity(PETSHOP.animalEntity)
    SetBlipSprite(PETSHOP.animalBlip, 273)
    SetBlipColour(PETSHOP.animalBlip, 0)
    SetBlipScale(PETSHOP.animalBlip, 0.8)
    local _key = "BN_SUNLIFE_PETS_1_" .. tostring(PETSHOP.animalBlip)
    AddTextEntry(_key, "Animal de compagnie")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(PETSHOP.animalBlip)

    Citizen.CreateThread(function()
        DrawText3D_Ids = function(coordsx, coordsy, coordsz, text, size)
            local onScreen, x, y = World3dToScreen2d(coordsx, coordsy, coordsz)
            local camCoords      = GetGameplayCamCoords()
            local dist           = GetDistanceBetweenCoords(camCoords, coordsx, coordsy, coordsz, true)
            local size           = size

            if size == nil then
                size = 1
            end

            local scale = (size / dist) * 2
            local fov   = (1 / GetGameplayCamFov()) * 100
            local scale = scale * fov

            if onScreen then
                SetTextScale(0.0 * scale, 0.55 * scale)
                SetTextFont(4)
                SetTextOutline()
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextCentre(1)
                SetTextEntry('STRING')

                AddTextComponentString(text)
                DrawText(x, y)
            end
        end
        while DoesEntityExist(PETSHOP.animalEntity) do

            local dDst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(PETSHOP.animalEntity), false)
            local dCoords = GetEntityCoords(PETSHOP.animalEntity)

            if dDst < 15.0 then
                DrawText3D_Ids(dCoords.x, dCoords.y, dCoords.z + 0.50, PETSHOP.data.label, 1.0)
            end

            Citizen.Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while GetEntityHealth(PETSHOP.animalEntity) > 0 do

            local dDst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(PETSHOP.animalEntity), false)

            if dDst >= 500.0 then
                SetEntityHealth(PETSHOP.animalEntity, 0.0)
                DeleteEntity(PETSHOP.animalEntity)
                PETSHOP.animalEntity = nil
            end

            Citizen.Wait(1000)
        end
        if GetEntityHealth(PETSHOP.animalEntity) < 5 then
            DeleteEntity(PETSHOP.animalEntity)
            PETSHOP.animalEntity = nil
        end
    end)
end

PETSHOP.FollowAnimal = function()
    RequestAnimDict('rcmnigel1c')
    while not HasAnimDictLoaded('rcmnigel1c') do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, 100.0, 48, 0, false, false, false)

    if not PETSHOP.data.follow then
        ClearPedTasks(PETSHOP.animalEntity)
        PETSHOP.data.follow = true
    else
        TaskFollowToOffsetOfEntity(PETSHOP.animalEntity, PlayerPedId(), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
        SetPedKeepTask(PETSHOP.animalEntity, true)
        PETSHOP.data.follow = false
    end
end

PETSHOP.SitAnimal = function()
    if not PETSHOP.data.stand then
        PETSHOP.data.stand = not PETSHOP.data.stand
        RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
        while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
            Wait(0)
        end
        TaskPlayAnim(PETSHOP.animalEntity, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
    else
        PETSHOP.data.stand = not PETSHOP.data.stand
        ClearPedTasks(PETSHOP.animalEntity)
    end
end

PETSHOP.CarAnimal = function()
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(PETSHOP.animalEntity)

    if #(coords - hundcoords) <= 10 then
        if IsPedInAnyVehicle(PETSHOP.animalEntity, false) then
            TaskLeaveVehicle(PETSHOP.animalEntity, GetVehiclePedIsIn(PETSHOP.animalEntity, false), 256)
            PETSHOP.data.inCar = true
        else
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local vehicle, seat = GetVehiclePedIsIn(PlayerPedId(), false), nil

                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                    if IsVehicleSeatFree(vehicle, i) then
                        if seat == nil then
                            seat = i
                        end
                    end
                end

                TaskEnterVehicle(PETSHOP.animalEntity, vehicle, -1, seat, 5.0, 0)
                PETSHOP.data.inCar = false
            else
                ESX.ShowNotification("~r~Vous devez être dans un véhicule pour ceci")
            end
        end
    else
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
    end
end

AddEventHandler("onResourceStop", function()
    DeleteEntity(PETSHOP.animalEntity)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        if isValueInt then
            local isNumber = tonumber(result)
            if isNumber then
                return result
            else
                return nil
            end
        end

        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

Citizen.CreateThread(function()
    TriggerServerEvent("playerPets:get")
    while true do

        local interval = 500

        if #(cfg_petShop.pos - GetEntityCoords(PlayerPedId())) < 2.5 then
            interval = 0

            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu animalerie")

            if IsControlJustPressed(0, 38) then
                PETSHOP.openShop()
            end
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("playerPets:send")
AddEventHandler("playerPets:send", function(data)
    playerPets = data
end)

RegisterNetEvent("playerPets:openMenu")
AddEventHandler("playerPets:openMenu", function()
    PETSHOP.openMyAnimalsMenu()
end)

Citizen.CreateThread(function()
    local blipsanimals = AddBlipForCoord(562.36, 2740.73, 42.76)
    SetBlipSprite (blipsanimals, 273)
    SetBlipDisplay(blipsanimals, 4)
    SetBlipScale(blipsanimals, 0.8)
    SetBlipColour (blipsanimals, 0)
    SetBlipAsShortRange(blipsanimals, true)

    AddTextEntry("BN_SUNLIFE_PETS_2", "Animalerie")
    BeginTextCommandSetBlipName("BN_SUNLIFE_PETS_2")
    EndTextCommandSetBlipName(blipsanimals2)
end)
