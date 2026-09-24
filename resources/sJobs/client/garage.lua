local currentMarkers = {}

vehicleSociety = {
    ["bobcat"] = {
        position = {
            {marker = vec3(-671.104675, -2392.461670, 13.044756), spawn = vec4(-677.291443, -2387.833008, 13.821475, 51.426315307617)},
        },
        vehicles = {
            {name = "stockade2", label = "Stockade"},
            {name = "b4bike", label = "Moto"},
            {name = "b4bike2", label = "Moto 2"},
            {name = "b4scout2", label = "Scout"},
            {name = "b4buffalo3", label = "Buffalo"}
        },
    },
    ["doj"] = {
        position = {
            {marker = vec3(-573.0569, -251.8132, 34.8460), spawn = vec4(-579.0017, -248.0716, 35.8138, 30.6111)},
        },
        vehicles = {
            {name = "vstretch", label = "Stretch V"},
            {name = "ccadeesv", label = "CCADEESV"},
            {name = "b4bikedoj", label = "Moto"},
            {name = "b4buffalo3doj", label = "Buffalo"},
            {name = "b4scout2doj", label = "Scout"}
        },
    },

    ["usss"] = {
        position = {
            {marker = vec3(64.296989, -750.515808, 43.328519), spawn = vec4(55.778858, -745.514465, 44.155510, 339.39385986328)},
        },
        vehicles = {
            {name = "stretch", label = "Stretch"},
            {name = "ccadeesv", label = "CCADEESV"}
        },
    },
    ["gouv"] = {
        position = {
            {marker = vec3(-401.337982, 1192.099609, 324.741876), spawn = vec4(-390.565369, 1189.514282, 325.641205, 95.704383850098)},
        },
        vehicles = {
            {name = "stretch", label = "Stretch"},
            {name = "ccadeesv", label = "CCADEESV"}
        },
    },
    ["elysian"] = {
        position = {
            {marker = vec3(-112.9090, -2513.3804, 5.0911), spawn = vec4(-112.2368, -2520.7136, 5.3926, 234.7651)},
        },
        vehicles = {
            {name = "gbvoyager", label = "Voyager"}
        },
    },
    ["fourriere"] = {
        position = {
            {marker = vec3(483.03723144531, -1157.6206054688, 28.518966293335), spawn = vec4(472.62609863281, -1162.5537109375, 29.418962478638, 87.705139160156)},
        },
        vehicles = {
            {name = "vrunnerrc", label = "Runner VC"},
            {name = "towtruck", label = "Towtruck"},
            {name = "flatbed3", label = "Flatbed"},
        },
    },
    ["lsfd"] = {
        position = {
            {marker = vec3(-1030.6414, -1376.1058, 3.9680), spawn = vec4(-1054.140015, -1363.352295, 4.973586, 342.29)},
        },
        vehicles = {
            {name = "firetruk", label = "Camion de pompier"},
            {name = "lsfdtruck2", label = "Camion de pompier 2"},
            {name = "hvfdladder", label = "Camion de pompier 3"},
            {name = "hvfiretruk", label = "Camion de pompier 4"},
            {name = "hvfdambulance", label = "Ambulance LSFD"},
            {name = "hvfdterminus", label = "Terminus LSFD"},
            {name = "hvfdbrush", label = "Brush LSFD"},
            {name = "hvfdalamo", label = "Alamo LSFD"},
            {name = "hvfdgrang", label = "Granger LSFD"},
            {name = "hvfdheavy", label = "Heavy LSFD"},
            {name = "hvfdscout", label = "Scout LSFD"},
            {name = "hvfdyosemite", label = "Yosemite LSFD"},

            {name = "hvfdswift", label = "Hélicoptère LSFD",
                spawn = vec4(-1039.408569, -1440.675903, 9.501683, 74.542427062988)},
            {name = "hvsafrboat", label = "Bateau LSFD",
                spawn = vec4(-999.59826660156, -1398.1081542969, -0.3999317586422, 26.201753616333)},
        },
    },
    ["hayes"] = {
        position = {
            {marker = vec3(-355.8805, -156.5064, 37.9912), spawn = vec4(-357.7384, -159.4577, 38.2142, 27.0813)},
        },
        vehicles = {
            {name = "tampa2", label = "Tampa"},
            {name = "specter2", label = "Specter"},
            {name = "guardian", label = "Guardian"}
        },
    },
    ["harmony"] = {
        position = {
            {marker = vec3(49.671097, 6518.202148, 31.012935), spawn = vec4(56.467449, 6527.250488, 31.912933, 327.14584350586)},
        },
        vehicles = {
            {name = "servicevan", label = "Van de service"},
            {name = "flatbed", label = "Flatbed"},
            {name = "slamvan3", label = "Slamvan"},
            {name = "towtruck", label = "Towtruck"},
            {name = "burrito3", label = "Burrito"}
        },
    },
    ["police"] = {
        position = {
            {marker = vec3(-1102.755859, -829.465698, 4.129837), spawn = vec4(-1098.533691, -822.095337, 4.870630, 216.96197509766)},
        },
        vehicles = {
            {name = "bcpd10", label = "Cruiser 1"},
            {name = "polstanierp", label = "Cruiser 2"},
            {name = "poltorencep", label = "Cruiser 3"},
            {name = "hazard2", label = "Hazard"},
            {name = "polbikeb2", label = "Moto"},
            {name = "polbuffalop", label = "Buffalo 2020"},
            {name = "polbuffalop2", label = "Buffalo 2015"},
            {name = "bufsxtrafpol", label = "Buffalo Undercover"},
            {name = "polalamop2", label = "Alamo"},
            {name = "umkalamo", label = "Alamo Undercover"},
            {name = "polcarap", label = "Caracara"},
            {name = "polgauntletp", label = "Gauntlet"},
            {name = "polscoutp", label = "Scout"},
            {name = "polstalkerp", label = "Lansstalker"},
            {name = "swatinsur", label = "Bearcat"},
            {name = "swatstoc", label = "Swat"},
            {name = "inaugural2", label = "Swat Granger"},
            {name = "swatvanr2", label = "Van"},
            {name = "coach2", label = "Bus"},
            {name = "command", label = "Poste de commande", spawn = vec4(-1051.337891, -854.675720, 4.590057, 227.47203063965)},
            {name = "polmav", label = "Hélicoptère"},
            {name = "policejpheli", label = "Helicoptère 2"},
            {name = "jcon", label = "J-Con Flyer"},
            {name = "segway", label = "Segway"},

            {name = "predator", label = "Predator",
                spawn = vec4(-1161.098755, -858.141418, -0.489231, 124.2855682373)},
            {name = "gwarden7", label = "Warden 1",
                spawn = vec4(-1161.098755, -858.141418, -0.489231, 124.2855682373)},
            {name = "gwarden8", label = "Warden 2",
                spawn = vec4(-1161.098755, -858.141418, -0.489231, 124.2855682373)},
        },
    },
    ["sheriff"] = {
        position = {
            {marker = vec3(2811.2971, 4762.0142, 46.3670), spawn = vec4(2832.0808, 4770.0127, 47.1718, 15.3452)},
        },
        vehicles = {
            {name = "bcpd10", label = "Cruiser 1"},
            {name = "polstanierp", label = "Cruiser 2"},
            {name = "poltorencep", label = "Cruiser 3"},
            {name = "hazard2", label = "Hazard"},
            {name = "polbikeb2", label = "Moto"},
            {name = "polbuffalop", label = "Buffalo 2020"},
            {name = "polbuffalop2", label = "Buffalo 2015"},
            {name = "bufsxtrafpol", label = "Buffalo Undercover"},
            {name = "polalamop2", label = "Alamo"},
            {name = "umkalamo", label = "Alamo Undercover"},
            {name = "polcarap", label = "Caracara"},
            {name = "polgauntletp", label = "Gauntlet"},
            {name = "polscoutp", label = "Scout"},
            {name = "polstalkerp", label = "Lansstalker"},
            {name = "swatinsur", label = "Bearcat"},
            {name = "swatstoc", label = "Swat"},
            {name = "inaugural2", label = "Swat Granger"},
            {name = "swatvanr2", label = "Van"},
            {name = "coach2", label = "Bus"},
            {name = "command", label = "Poste de commande"},
            {name = "polmav", label = "Hélicoptère"},
            {name = "policejpheli", label = "Helicoptère 2"},
            {name = "lfcargobob", label = "Hélico Cargo"},
            {name = "jcon", label = "J-Con Flyer"},
            {name = "segway", label = "Segway"},
        },
    },
    ["immo"] = {
        position = {
            {marker = vec3(-716.8990, 273.9307, 83.6864), spawn = vec4(-712.5167, 274.9038, 84.3901, 293.7315)},
        },
        vehicles = {
            {name = "rebla", label = "Véhicule de service"}
        },
    },
    ["ems"] = {
        position = {
            {marker = vec3(-674.218018, 351.888855, 76.807138), spawn = vec4(-675.456482, 346.623993, 77.707138, 84.308708190918)},
            {marker = vec3(7467.834961, 374.552002, 56.925089), spawn = vec4(7463.493164, 385.902069, 57.825195, 47.456405639648)},
        },
        vehicles = {
            {name = "hvemsbuff4", label = "Buffalo 4"},
            {name = "hvemsgrang", label = "Granger 2"},
            {name = "hvemsscout", label = "Scout"},
            {name = "sandbulance", label = "Ambulance"},
            {name = "jcon", label = "J-Con Flyer"}
        },
    },
    ["grotti"] = {
        position = {
            {marker = vec3(-954.4088, -2060.6992, 8.5064), spawn = vec4(-960.3380, -2061.9287, 8.8990, 138.8624)},
        },
        vehicles = {
            {name = "guardian", label = "Guardian"}
        },
    },
    ["studio"] = {
        position = {
            {marker = vec3(496.3513, -103.5545, 60.3306), spawn = vec4(504.1645, -103.3130, 62.6331, 253.4683)},
        },
        vehicles = {
            {name = "patriot2", label = "Patriot Limo"},
            {name = "stretch", label = "Stretch"},
            {name = "pbus2", label = "Party Bus"}
        },
    },
    ["taxi"] = {
        position = {
            {marker = vec3(-1245.2827, -264.8265, 36.6969), spawn = vec4(-1236.8002, -275.3842, 37.7215, 303.8407)},
        },
        vehicles = {
            {name = "taxi", label = "Taxi"},
            {name = "nkomnisegttaxi", label = "Taxi Omnis GT"}
        },
    },
    ["weazle"] = {
        position = {
            {marker = vec3(-559.1684, -942.2167, 22.8468), spawn = vec4(-555.7059, -929.3653, 23.8623, 270.7003)},
        },
        vehicles = {
            {name = "newsvan", label = "Van Weazel News"},
            {name = "newsheli", label = "Hélicoptère Weazle News"},
            {name = "rebla", label = "Véhicule d'observation"}
        },
    }
}
local onGarageOpen = false

Citizen.CreateThread(function()
    RMenu.Add('garage', 'principal', RageUI.CreateMenu("SunLife", "Garage Société", 1, 100))
    RMenu.Add('garage', 'vehicles2', RageUI.CreateSubMenu(RMenu:Get('garage', 'principal'), "SunLife", "Garage Société"))
    RMenu:Get('garage', 'principal'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('garage', 'vehicles2'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('garage', 'principal').EnableMouse = false
    RMenu:Get('garage', 'principal').Closed = function()
        onGarageOpen = false
    end
end)

RegisterNetEvent("sJobs.setLivery", function(netId, livery, mods, custom)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) and livery then
        SetVehicleLivery(vehicle, livery)
    end

    if mods then
        SetVehicleMod(vehicle, 48, 1, false)
    end

    if custom then
        ESX.Game.SetVehicleProperties(vehicle, {
            modEngine = 3,
            modBrakes = 3,
            modTransmission = 3,
            modSuspension = 3,
            modTurbo = true
        })
    end
end)

local function menuGarageSociety(data)
    if onGarageOpen then
        return
    else
        onGarageOpen = true
        RageUI.Visible(RMenu:Get('garage', 'principal'), true)

        local selectedSpawn = nil
        local playerCoords = GetEntityCoords(PlayerPedId())

        for job, garage in pairs(vehicleSociety) do
            if data.playerJob == job then
                for _, position in ipairs(garage.position) do
                    if #(playerCoords - position.marker) < 100.0 then
                        selectedSpawn = position.spawn
                        break
                    end
                end
                break
            end
        end

        Citizen.CreateThread(function()
            while onGarageOpen do
                RageUI.IsVisible(RMenu:Get('garage', 'principal'), true, true, true, function()
                    RageUI.ButtonWithStyle("Véhicules", nil, { RightLabel = "En Stock: ~g~Oui ~w~→" }, true, function()
                    end, RMenu:Get('garage', 'vehicles2'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('garage', 'vehicles2'), true, true, true, function()
                    for job, garage in pairs(vehicleSociety) do
                        if data.playerJob == job then
                            for _, vehicle in ipairs(garage.vehicles) do
                                RageUI.ButtonWithStyle(vehicle.label, nil, {}, true, function(_, _, Selected)
                                    if Selected then
                                        local spawnPoint = vehicle.spawn or selectedSpawn
                                        if spawnPoint then
                                            TriggerServerEvent("sJobs.vehicleGarage", vehicle.name, vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z), spawnPoint.w)
                                        else
                                            ESX.ShowNotification("~r~Aucune position de spawn détectée.")
                                        end
                                        RageUI.CloseAll()
                                        onGarageOpen = false
                                    end
                                end)
                            end
                            break
                        end
                    end
                end, function()
				end)

                if not RageUI.Visible(RMenu:Get('garage', 'principal')) and
                   not RageUI.Visible(RMenu:Get('garage', 'vehicles2')) then
                    onGarageOpen = false
                    break
                end
                Wait(0)
            end
        end)
    end
end

local function garageSociety(data)
    DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
    if data.currentDistance < 1.5 then
        ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour acceder au ~o~garage")
        if IsControlJustPressed(1, 38) then
            menuGarageSociety(data)
        end
    end
end

local function deleteVehicle(data)
    if data.currentDistance < 3.0 and IsPedInAnyVehicle(PlayerPedId(), false) then
        ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ranger un ~o~véhicule")
        if IsControlJustPressed(1, 38) then
            TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId())))
        end
    end
end

function initGarageSociety(playerJob)
    for key, point in pairs(currentMarkers) do
        point:remove()
        currentMarkers[key] = nil
    end

    if vehicleSociety[playerJob] then
        for _, v in ipairs(vehicleSociety[playerJob].position) do
            local point = lib.points.new({
                coords = v.marker,
                distance = 10,
                nearby = function(self)
                    garageSociety({coords = self.coords, currentDistance = self.currentDistance, playerJob = playerJob})
                end
            })

            currentMarkers[v.marker] = point
        end

        for _, v in ipairs(vehicleSociety[playerJob].position) do
            local point = lib.points.new({
                coords = v.spawn,
                distance = 10,
                nearby = function(self)
                    deleteVehicle({coords = self.coords, currentDistance = self.currentDistance, playerJob = playerJob})
                end
            })

            currentMarkers[v.spawn] = point
        end

        local helicoPositions = {
            vector3(-1052.4919, -1436.1133, 9.5017),
            vector3(-999.5983,  -1398.1082, -0.3999),
            vector3(-1161.0988, -858.1414,  -0.4892),
            vector3(-686.6273, 321.8864, 140.0343),
            vector3(7490.450195, 321.158569, 57.825130),
            vector3(480.2731, -986.8239, 44.8335),
            vector3(2751.5950, 4851.2422, 47.2548),
            vector3(-582.8694, -930.1042, 37.2129),
            vector3(4882.3306, -5282.2046, 8.4193),
            vector3(-445.6113, 7136.4072, 21.5913)
        }
        for _, pos in ipairs(helicoPositions) do
            local point = lib.points.new({
                coords = pos,
                distance = 10,
                nearby = function(self)
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        deleteVehicle({coords = self.coords, currentDistance = self.currentDistance, playerJob = playerJob})
                    end
                end
            })

            currentMarkers[pos] = point
        end
    end
end

local dojJconNpc = {
    pedModel = `s_m_m_fiboffice_01`,
    coords = vec4(-458.219421, 1135.732422, 325.904816, 166.10787963867),
}

CreateThread(function()
    local model = dojJconNpc.pedModel
    RequestModel(model)
    local timeoutAt = GetGameTimer() + 10000
    while not HasModelLoaded(model) and GetGameTimer() < timeoutAt do
        Wait(50)
    end
    if not HasModelLoaded(model) then return end

    local c = dojJconNpc.coords
    local ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(model)

    lib.points.new({
        coords = vec3(c.x, c.y, c.z),
        distance = 10,
        nearby = function(self)
            if self.currentDistance < 2.0 and playerJob == "gouv" then
                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour sortir le ~o~J-Con")
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("sJobs.vehicleGarage", "jcon", vec3(c.x, c.y, c.z), c.w)
                end
            end
        end
    })
end)
