Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

BOBCAT["myClothes"] = {}

RegisterNetEvent("property:sendMyClothes")
AddEventHandler("property:sendMyClothes", function(clothes)
    BOBCAT["myClothes"] = clothes
end)

BOBCAT.openMissions = function()
    RMenu.Add('bobcat', 'main', RageUI.CreateMenu('Bobcat Security', 'Que voulez-vous faire ?', 1, 100))
    RMenu.Add('bobcat', 'one', RageUI.CreateSubMenu(RMenu:Get('bobcat', 'main'), 'Bobcat Security', 'Que voulez-vous faire ?'))
    RMenu.Add('bobcat', 'two', RageUI.CreateSubMenu(RMenu:Get('bobcat', 'main'), 'Bobcat Security', 'Que voulez-vous faire ?'))
    RMenu.Add('bobcat', 'tree', RageUI.CreateSubMenu(RMenu:Get('bobcat', 'main'), 'Bobcat Security', 'Que voulez-vous faire ?'))
    RMenu.Add('bobcat', 'four', RageUI.CreateSubMenu(RMenu:Get('bobcat', 'main'), 'Bobcat Security', 'Que voulez-vous faire ?'))
    RMenu:Get('bobcat', 'main').Closed = function()
        BOBCAT['menuOpenned'] = false

        RMenu:Delete('bobcat', 'main')
        RMenu:Delete('bobcat', 'one')
        RMenu:Delete('bobcat', 'two')
        RMenu:Delete('bobcat', 'tree')
        RMenu:Delete('bobcat', 'four')
    end

    if BOBCAT['menuOpenned'] then
        BOBCAT['menuOpenned'] = false
        return
    else
        RageUI.CloseAll()

        BOBCAT['menuOpenned'] = true
        RageUI.Visible(RMenu:Get('bobcat', 'main'), true)
    end

    for name, menu in pairs(RMenu['bobcat']) do
        RMenu:Get('bobcat', name):SetRectangleBanner(255, 117, 31, 225)
    end

    Citizen.CreateThread(function()
        while BOBCAT['menuOpenned'] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('bobcat', 'main'), true, false, true, function()

                RageUI.ButtonWithStyle("Mission seul", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        players = {}
                    end
                end, RMenu:Get('bobcat', 'one'))

                RageUI.ButtonWithStyle("Mission à 2", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        players = {}
                    end
                end, RMenu:Get('bobcat', 'two'))

                RageUI.ButtonWithStyle("Mission à 3", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        players = {}
                    end
                end, RMenu:Get('bobcat', 'tree'))

                RageUI.ButtonWithStyle("Mission à 4", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        players = {}
                    end
                end, RMenu:Get('bobcat', 'four'))

            end)

            RageUI.IsVisible(RMenu:Get('bobcat', 'one'), true, false, true, function()

                RageUI.Separator(BOBCAT["missions"][1][1].name)
                RageUI.ButtonWithStyle("Récompense", nil, {RightLabel = ESX.Math.GroupDigits(BOBCAT["missions"][1][1].reward).."$"}, true, function(Hovered, Active, Selected) end)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("~g~Commencer la mission", nil, {RightLabel = "~g~→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        BOBCAT['menuOpenned'] = false

                        TriggerServerEvent("bobcat:mission:startSingle")
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('bobcat', 'two'), true, false, true, function()

                RageUI.Separator(BOBCAT["missions"][2][1].name)
                RageUI.ButtonWithStyle("Récompense", nil, {RightLabel = ESX.Math.GroupDigits(BOBCAT["missions"][2][1].reward).."$"}, true, function(Hovered, Active, Selected) end)
                RageUI.Separator("")

                RageUI.ButtonWithStyle("Ajouter un participant (".. 2-#players.." restants)", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            table.insert(players, {
                                serverId = GetPlayerServerId(closestPlayer),
                            })
                            ESX.ShowNotification("~g~Nouveau participant ajouté")
                        else
                            ESX.ShowNotification('~r~Il n\'y a personne autour !')
                        end
                    end
                end)

                if #players == 2 then
                    RageUI.ButtonWithStyle("~g~Commencer la mission", nil, {RightLabel = "~g~→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            BOBCAT['menuOpenned'] = false

                            TriggerServerEvent("bobcat:mission:startMultiple", 2, players)
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('bobcat', 'tree'), true, false, true, function()

                RageUI.Separator(BOBCAT["missions"][3][1].name)
                RageUI.ButtonWithStyle("Récompense", nil, {RightLabel = ESX.Math.GroupDigits(BOBCAT["missions"][3][1].reward).."$"}, true, function(Hovered, Active, Selected) end)
                RageUI.Separator("")

                RageUI.ButtonWithStyle("Ajouter un participant (".. 3-#players.." restants)", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            table.insert(players, {
                                serverId = GetPlayerServerId(closestPlayer),
                            })
                            ESX.ShowNotification("~g~Nouveau participant ajouté")
                        else
                            ESX.ShowNotification('~r~Il n\'y a personne autour !')
                        end
                    end
                end)

                if #players == 3 then
                    RageUI.ButtonWithStyle("~g~Commencer la mission", nil, {RightLabel = "~g~→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            BOBCAT['menuOpenned'] = false

                            TriggerServerEvent("bobcat:mission:startMultiple", 3, players)
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('bobcat', 'four'), true, false, true, function()

                RageUI.Separator(BOBCAT["missions"][4][1].name)
                RageUI.ButtonWithStyle("Récompense", nil, {RightLabel = ESX.Math.GroupDigits(BOBCAT["missions"][4][1].reward).."$"}, true, function(Hovered, Active, Selected) end)
                RageUI.Separator("")

                RageUI.ButtonWithStyle("Ajouter un participant (".. 4-#players.." restants)", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            table.insert(players, {
                                serverId = GetPlayerServerId(closestPlayer),
                            })
                            ESX.ShowNotification("~g~Nouveau participant ajouté")
                        else
                            ESX.ShowNotification('~r~Il n\'y a personne autour !')
                        end
                    end
                end)

                if #players == 4 then
                    RageUI.ButtonWithStyle("~g~Commencer la mission", nil, {RightLabel = "~g~→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            BOBCAT['menuOpenned'] = false

                            TriggerServerEvent("bobcat:mission:startMultiple", 4, players)
                        end
                    end)
                end

            end)

        end
    end)
end

RegisterNetEvent("bobcat:mission:startSingle")
AddEventHandler("bobcat:mission:startSingle", function(randed)
    local randedPoint = BOBCAT["missions"][1][randed]["points"][math.random(1, #BOBCAT["missions"][1][randed]["points"])]

    randedPoint.blip = AddBlipForCoord(randedPoint.pos)

    SetBlipSprite(randedPoint.blip, 67)
    SetBlipScale(randedPoint.blip, 0.8)
    SetBlipColour(randedPoint.blip, 48)
    SetBlipAsShortRange(randedPoint.blip, false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Mission seule')
    EndTextCommandSetBlipName(randedPoint.blip)

    ClearGpsMultiRoute()
    StartGpsMultiRoute(48, true, true)
    AddPointToGpsMultiRoute(randedPoint.pos.x, randedPoint.pos.y, randedPoint.pos.z)
    SetGpsMultiRouteRender(true)

    RequestModel(GetHashKey(BOBCAT["missions"][1][randed]["vehicleHash"]))
    while not HasModelLoaded(GetHashKey(BOBCAT["missions"][1][randed]["vehicleHash"])) do
        Citizen.Wait(100)
    end

    TriggerServerEvent('eye:veh:authorize', GetHashKey(BOBCAT["missions"][1][randed]["vehicleHash"]), 'job')
    print(('^5[NETDIAG][VEHICLE]^7 %s cl_menu.lua:228 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(BOBCAT["missions"][1][randed]["vehicleHash"])))
    local vehicle = CreateVehicle(GetHashKey(BOBCAT["missions"][1][randed]["vehicleHash"]), BOBCAT["missions"][1][randed]["startPoint"]["pos"].x, BOBCAT["missions"][1][randed]["startPoint"]["pos"].y, BOBCAT["missions"][1][randed]["startPoint"]["pos"].z, BOBCAT["missions"][1][randed]["startPoint"]["heading"], true)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleNumberPlateText(vehicle, "BOBCAT")
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

    local dst = #(GetEntityCoords(PlayerPedId()) - randedPoint.pos)
    while dst > 15.0 do
        dst = #(GetEntityCoords(PlayerPedId()) - randedPoint.pos)
        Citizen.Wait(100)
    end

    TriggerServerEvent("bobcat:missions:stopMissionSingle")

    DeleteVehicle(vehicle)

    ClearGpsMultiRoute()
    RemoveBlip(randedPoint.blip)
end)

RegisterNetEvent("bobcat:mission:startMultiple")
AddEventHandler("bobcat:mission:startMultiple", function(amount, randed)
    local randedPoint = BOBCAT["missions"][amount][randed]["points"][math.random(1, #BOBCAT["missions"][amount][randed]["points"])]

    randedPoint.blip = AddBlipForCoord(randedPoint.pos)

    SetBlipSprite(randedPoint.blip, 67)
    SetBlipScale(randedPoint.blip, 0.8)
    SetBlipColour(randedPoint.blip, 48)
    SetBlipAsShortRange(randedPoint.blip, false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Mission accompagnée')
    EndTextCommandSetBlipName(randedPoint.blip)

    ClearGpsMultiRoute()
    StartGpsMultiRoute(48, true, true)
    AddPointToGpsMultiRoute(randedPoint.pos.x, randedPoint.pos.y, randedPoint.pos.z)
    SetGpsMultiRouteRender(true)

    RequestModel(GetHashKey(BOBCAT["missions"][amount][1]["vehicleHash"]))
    while not HasModelLoaded(GetHashKey(BOBCAT["missions"][amount][1]["vehicleHash"])) do
        Citizen.Wait(100)
    end

    TriggerServerEvent('eye:veh:authorize', GetHashKey(BOBCAT["missions"][amount][randed]["vehicleHash"]), 'job')
    print(('^5[NETDIAG][VEHICLE]^7 %s cl_menu.lua:277 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(BOBCAT["missions"][amount][randed]["vehicleHash"])))
    local vehicle = CreateVehicle(GetHashKey(BOBCAT["missions"][amount][randed]["vehicleHash"]), BOBCAT["missions"][amount][randed]["startPoint"]["pos"].x, BOBCAT["missions"][amount][randed]["startPoint"]["pos"].y, BOBCAT["missions"][amount][randed]["startPoint"]["pos"].z, BOBCAT["missions"][amount][randed]["startPoint"]["heading"], true)
    SetVehicleFuelLevel(vehicle, 100.0)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleNumberPlateText(vehicle, "BOBCAT")

    local dst = #(GetEntityCoords(PlayerPedId()) - randedPoint.pos)
    while dst > 15.0 do
        dst = #(GetEntityCoords(PlayerPedId()) - randedPoint.pos)
        Citizen.Wait(100)
    end

    TriggerServerEvent("bobcat:missions:stopMissionMultiple", amount)

    DeleteVehicle(vehicle)
    ClearGpsMultiRoute()
    RemoveBlip(randedPoint.blip)
end)

RegisterNetEvent("bobcat:mission:sendFollowing")
AddEventHandler("bobcat:mission:sendFollowing", function(followingId, vehicleHash)
    local goodvec = nil
    local brock = false
    Citizen.CreateThread(function()
        while true do
            local interval = 1000

            local player = nil
            for k,v in ipairs(GetActivePlayers()) do
                local serverId = GetPlayerServerId(v)
                if serverId == followingId then

                    interval = 0
                    player = GetPlayerPed(v)
                end
            end

            local vehicle = GetVehiclePedIsIn(player, false)
            if GetEntityModel(vehicle) == GetHashKey(vehicleHash) and goodvec == nil then
                print("setted!")
                goodvec = vehicle
            end

            if not IsPedInAnyVehicle(player, false) then
                if goodvec then
                    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(goodvec)) < 10.0 then
                        if not brock then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour exploser le camion")
                            if IsControlJustPressed(0, 38) then
                                FreezeEntityPosition(goodvec, true)

                                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

                                Citizen.Wait(1500)

                                RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
                                while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do
                                    Citizen.Wait(50)
                                end

                                local playerPed = PlayerPedId()
                                local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
                                print(('^2[NETDIAG][OBJET]^7 %s cl_menu.lua:339 CreateObject NETWORKED c4'):format(GetCurrentResourceName()))
                                c4Props = CreateObject(GetHashKey('prop_c4_final_green'), x, y, z+0.2,  true,  true, true)
                                AttachEntityToEntity(c4Props, playerPed, GetPedBoneIndex(playerPed, 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
                                SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
                                Citizen.Wait(0.7 * 1000)
                                FreezeEntityPosition(playerPed, true)
                                TaskPlayAnim(playerPed, 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 63, 0, 0, 0, 0)

                                if lib.progressCircle({
                                    duration = 5500,
                                    useWhileDead = false,
                                    canCancel = false,
                                    label = '⏳ INSTALLATION DU C4 EN COURS...'
                                }) then
                                    ClearPedTasks(playerPed)
                                    DetachEntity(c4Props)
                                    AttachEntityToEntity(c4Props, goodvec, GetEntityBoneIndexByName(goodvec, 'door_pside_r'), -0.7, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                    FreezeEntityPosition(playerPed, false)
                                    Citizen.Wait(500)

                                    if lib.progressCircle({
                                        duration = 5500,
                                        useWhileDead = false,
                                        canCancel = false,
                                        label = '⏳ LIAISON AVEC LA DÉTONATION...'
                                    }) then
                                        local truckPos = GetEntityCoords(goodvec)
                                        SetVehicleDoorBroken(goodvec, 2, false)
                                        SetVehicleDoorBroken(goodvec, 3, false)
                                        SetVehicleDoorOpen(NetworkGetNetworkIdFromEntity(goodvec), 2, true, true)
                                        SetVehicleDoorOpen(NetworkGetNetworkIdFromEntity(goodvec), 3, true, true)
                                        AddExplosion(truckPos.x, truckPos.y, truckPos.z, 'EXPLOSION_TANKER', 2.0, true, false, 2.0)
                                        ApplyForceToEntity(goodvec, 0, truckPos.x, truckPos.y, truckPos.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)

                                        RequestAnimDict('anim@heists@ornate_bank@grab_cash_heels')
                                        while not HasAnimDictLoaded('anim@heists@ornate_bank@grab_cash_heels') do
                                            Citizen.Wait(50)
                                        end

                                        FreezeEntityPosition(goodvec, false)
                                        brock = true
                                    end
                                end
                            end
                        else
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre la récompense du camion")
                            if IsControlJustPressed(0, 38) then
                                FreezeEntityPosition(goodvec, true)

                                local playerPed = PlayerPedId()
                                local pos = GetEntityCoords(playerPed)

                                print(('^2[NETDIAG][OBJET]^7 %s cl_menu.lua:390 CreateObject NETWORKED moneyBag'):format(GetCurrentResourceName()))
                                moneyBag = CreateObject(GetHashKey('prop_cs_heist_bag_02'), pos.x, pos.y,pos.z, true, true, true)
                                AttachEntityToEntity(moneyBag, playerPed, GetPedBoneIndex(playerPed, 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
                                TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
                                FreezeEntityPosition(playerPed, true)

                                local success = lib.progressCircle({
                                    duration = 10000,
                                    label = '⏳ BRAQUAGE EN COURS...',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        car = true,
                                        move = true,
                                        combat = true,
                                    }
                                })

                                if success then
                                    TriggerServerEvent("bobcat:mission:getFromCar", followingId)
                                end

                                DeleteEntity(moneyBag)

                                local radius = 10.0
                                local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
                                local vehs = {}
                                for k,v in pairs(vehicles) do
                                    if GetEntityModel(v) == GetHashKey(vehicleHash) then
                                        table.insert(vehs, NetworkGetNetworkIdFromEntity(v))
                                    end
                                end
                                TriggerServerEvent("DeleteEntityTable", vehs)

                                ClearPedTasks(playerPed)
                                FreezeEntityPosition(playerPed, false)
                                ClearHelp(true)
                            end
                        end
                    end
                end
            else
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(goodvec)) < 100.0 then
                    ESX.ShowHelpNotification("Faites descendre le conducteur pour braquer le camion")
                end
            end

            Citizen.Wait(interval)
        end
    end)
end)
