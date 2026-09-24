local posWeaponAmmu = {
    vector3(15.4945, -1104.6957, 28.1051),
    vector3(816.6265, -2157.2361, 27.9269)
}

local function markerSystem(data)
    if data.currentDistance < 3.0 then
        if data.type == "vote" then

        elseif data.type == "gestion" then
            if playerJob == "doj" then
                DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour acceder au menu de ~o~gestion")
                if IsControlJustPressed(0, 38) then
                    menuGestion()
                end
            end
        elseif data.type == "weaponAmmu" then
            if playerJob == "ammu" then
                DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de ~o~l'armurerie")
                if IsControlJustPressed(0, 38) then
                    menuWeapon()
                end
            end
        elseif data.type == "catalogue" then
            DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de ~o~catalogue")
            if IsControlJustPressed(0, 38) then
                openMenuStockOccas("catalogue")
            end
        end
    end
end

local function initGestionSystem()

    lib.points.new({
        coords = vector3(-535.3212, -191.1108, 42.3659),
        distance = 10,
        nearby = function(self)
            markerSystem({
                coords = self.coords,
                currentDistance = self.currentDistance,
                type = "gestion"
            })
        end
    })
    lib.points.new({
        coords = vector3(-925.1293, -2043.0830, 8.5064),
        distance = 10,
        nearby = function(self)
            markerSystem({
                coords = self.coords,
                currentDistance = self.currentDistance,
                type = "catalogue"
            })
        end
    })
    for i = 1, #posWeaponAmmu do
        lib.points.new({
            coords = posWeaponAmmu[i],
            distance = 10,
            nearby = function(self)
                markerSystem({
                    coords = self.coords,
                    currentDistance = self.currentDistance,
                    type = "weaponAmmu"
                })
            end
        })
    end
end

Citizen.CreateThread(function()
    initGestionSystem()
end)

local dataCameleon <const> = {
    { rarity = "rare", label = "Anodized Red Pearl" },
    { rarity = "rare", label = "Anodized Wine Pearl" },
    { rarity = "legendary", label = "Anodized Purple Pearl" },
    { rarity = "legendary", label = "Anodized Blue Pearl" },
    { rarity = "rare", label = "Anodized Green Pearl" },
    { rarity = "commun", label = "Anodized Lime Pearl" },
    { rarity = "rare", label = "Anodized Copper Pearl" },
    { rarity = "commun", label = "Anodized Bronze Pearl" },
    { rarity = "rare", label = "Anodized Champagne Pearl" },
    { rarity = "legendary", label = "Anodized Gold Pearl" },
    { rarity = "rare", label = "Green/Blue Flip" },
    { rarity = "commun", label = "Green/Red Flip" },
    { rarity = "rare", label = "Green/Brown Flip" },
    { rarity = "legendary", label = "Green/Turquoise Flip" },
    { rarity = "rare", label = "Green/Purple Flip" },
    { rarity = "legendary", label = "Teal/Purple Flip" },
    { rarity = "rare", label = "Turquoise/Red Flip" },
    { rarity = "legendary", label = "Turquoise/Purple Flip" },
    { rarity = "legendary", label = "Cyan/Purple Flip" },
    { rarity = "legendary", label = "Blue/Pink Flip" },
    { rarity = "legendary", label = "Blue/Green Flip" },
    { rarity = "legendary", label = "Purple/Red Flip" },
    { rarity = "legendary", label = "Purple/Green Flip" },
    { rarity = "rare", label = "Magenta/Green Flip" },
    { rarity = "rare", label = "Magenta/Yellow Flip" },
    { rarity = "commun", label = "Burgundy/Green Flip" },
    { rarity = "legendary", label = "Magenta/Cyan Flip" },
    { rarity = "rare", label = "Copper/Purple Flip" },
    { rarity = "legendary", label = "Magenta/Orange Flip" },
    { rarity = "rare", label = "Red/Orange Flip" },
    { rarity = "legendary", label = "Orange/Purple Flip" },
    { rarity = "commun", label = "Orange/Blue Flip" },
    { rarity = "legendary", label = "White/Purple Flip" },
    { rarity = "legendary", label = "Red/Rainbow Flip" },
    { rarity = "legendary", label = "Blue/Rainbow Flip" },
    { rarity = "commun", label = "Dark Green Pearl" },
    { rarity = "rare", label = "Dark Teal Pearl" },
    { rarity = "legendary", label = "Dark Blue Pearl" },
    { rarity = "legendary", label = "Dark Purple Pearl" },
    { rarity = "rare", label = "Oil Slick Pearl" },
    { rarity = "commun", label = "Light Green Pearl" },
    { rarity = "commun", label = "Light Blue Pearl" },
    { rarity = "legendary", label = "Light Purple Pearl" },
    { rarity = "legendary", label = "Light Pink Pearl" },
    { rarity = "legendary", label = "Off White Pearl" },
    { rarity = "legendary", label = "Cute Pink Pearl" },
    { rarity = "legendary", label = "Baby Yellow Pearl" },
    { rarity = "legendary", label = "Baby Green Pearl" },
    { rarity = "legendary", label = "Baby Blue Pearl" },
    { rarity = "legendary", label = "Cream Pearl" },
    { rarity = "legendary", label = "White Prismatic Pearl" },
    { rarity = "legendary", label = "Graphite Prismatic Pearl" },
    { rarity = "legendary", label = "Blue Prismatic Pearl" },
    { rarity = "legendary", label = "Purple Prismatic Pearl" },
    { rarity = "rare", label = "Hot Pink Prismatic Pearl" },
    { rarity = "legendary", label = "Red Prismatic Pearl" },
    { rarity = "legendary", label = "Green Prismatic Pearl" },
    { rarity = "legendary", label = "Black Prismatic Pearl" },
    { rarity = "legendary", label = "Oil Spill Prismatic Pearl" },
    { rarity = "rare", label = "Rainbow Prismatic Pearl" },
    { rarity = "legendary", label = "Black Holographic Pearl" },
    { rarity = "legendary", label = "White Holographic Pearl"},
}
local dataKits <const> = {
    vector3(-350.3799, -168.5379, 38.99129),
    vector3(-337.69744873047, -1257.9654541016, 29.703771209717),
    vector3(21.7596, 6456.825, 30.42505),
    vector3(59.832305908203, 6497.7299804688, 31.012845611572),
    vector3(695.48266601562, 152.96829223633, 80.771560668945),
}
local openCameleon, openKits = false

CreateThread(function()
	RMenu.Add('customCameleon', 'cameleon', RageUI.CreateMenu("Sunlife", "Menu Caméléon", 1, 100))
    RMenu:Get('customCameleon', 'cameleon').EnableMouse = false
	RMenu:Get('customCameleon', 'cameleon'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('customCameleon', 'cameleon').Closed = function()
		openCameleon = false
        RageUI.Visible(RMenu:Get('customCameleon', 'cameleon'), false)
    end

    RMenu.Add('mecanoKits', 'kits', RageUI.CreateMenu("Sunlife", "Kits Mécano", 1, 100))
    RMenu:Get('mecanoKits', 'kits'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('mecanoKits', 'kits').EnableMouse = false
    RMenu:Get('mecanoKits', 'kits').Closed = function()
		openKits = false
    end
end)

local function menuCameleon(type)
    if openCameleon then
        return
    else
        openCameleon = true
        RageUI.Visible(RMenu:Get('customCameleon', 'cameleon'), true)

        Citizen.CreateThread(function()
            while openCameleon do

                local ped = PlayerPedId()
                local currentVeh = GetVehiclePedIsIn(ped, false)

                if currentVeh == 0 or GetPedInVehicleSeat(currentVeh, -1) ~= ped then
                    openCameleon = false
                    RageUI.CloseAll()
                    TriggerServerEvent("sJobs.paintRefund")
                    ESX.ShowNotification("~r~Vous devez rester au volant.\n~s~Votre bombe de peinture vous a été rendue.")
                    break
                end

                RageUI.IsVisible(RMenu:Get('customCameleon', 'cameleon'), true, true, true, function()
                    local i = 161

                    for _, value in pairs(dataCameleon) do
                        if value.rarity == type then
                            RageUI.ButtonWithStyle(value.label, nil, {RightLabel = "→→→"}, true, function(_, _, Selected)
                                if Selected then
                                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                                    if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                                        local success = lib.progressBar({
                                            duration = 5000,
                                            label = "Application de la peinture...",
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                move = true,
                                                car = true,
                                                combat = true
                                            }
                                        })
                                        if success then

                                            pcall(function()
                                                exports['antisbire']:vehModGrace(15000)
                                            end)

                                            local oldColor1, oldColor2 = GetVehicleColours(vehicle)

                                            SetVehicleModKit(vehicle, 0)
                                            SetVehicleColours(vehicle, i, i)

                                            local newColor1 = GetVehicleColours(vehicle)

                                            openCameleon = false
                                            RageUI.CloseAll()

                                            if newColor1 ~= i then

                                                SetVehicleColours(vehicle, oldColor1, oldColor2)
                                                TriggerServerEvent("sJobs.paintRefund")
                                                ESX.ShowNotification("~r~Cette teinte n'est pas disponible sur ce serveur.\n~s~Votre bombe de peinture vous a été rendue.")
                                                return
                                            end

                                            local myProps = ESX.Game.GetVehicleProperties(vehicle)
                                            myProps.color2 = i
                                            myProps.color1 = i
                                            ESX.Game.SetVehicleProperties(vehicle, myProps)
                                            local myCar = ESX.Game.GetVehicleProperties(vehicle)
                                            TriggerServerEvent('custommenu:refreshOwnedVehicle', myCar)
                                            TriggerServerEvent("sJobs.paintApplied")
                                            ESX.ShowNotification("~o~Peinture appliquée avec succès !")
                                        else

                                            TriggerServerEvent("sJobs.paintRefund")
                                            ESX.ShowNotification("Action annulée, votre bombe vous a été rendue.")
                                        end
                                    else
                                        openCameleon = false
                                        RageUI.CloseAll()
                                        TriggerServerEvent("sJobs.paintRefund")
                                        ESX.ShowNotification("~r~Vous devez être au volant du véhicule.\n~s~Votre bombe de peinture vous a été rendue.")
                                    end
                                end
                            end)
                        end
                        i = i + 1
                    end
                end, function()
                end)
                Wait(0)
            end
        end)
    end
end

RegisterNetEvent("cJobs_custom.bombePeinture", function(type)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        TriggerServerEvent("sJobs.paintRefund")
        ESX.ShowNotification("~r~Vous devez être au volant d'un véhicule.\n~s~Votre bombe de peinture vous a été rendue.")
        return
    end

    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) do
        Wait(0)
    end

    menuCameleon(type)
end)
