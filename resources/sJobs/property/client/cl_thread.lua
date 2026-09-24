minimizedPropertys, minimizedBuildings, minimizedDeletePoints = {}, {}, {}

Citizen.CreateThread(function()
    Citizen.SetTimeout(5000, function()
        TriggerServerEvent("property:getMinimized")
    end)

    local lastCalled = 0
    while true do
        local interval = 2500
        local playerCoords = GetEntityCoords(PlayerPedId())

        local function handleInteraction(target, type, callback)
            local dst = GetDistanceBetweenCoords(playerCoords, target, true)

            if dst < 10.0 then
                interval = 0
                DrawMarker(6, target.x, target.y, target.z - 0.95, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 117, 31, 225)
            end

            if dst < 2.5 then
                local notificationText = "Appuyez sur ~INPUT_CONTEXT~ pour interagir avec " .. type
                ESX.ShowHelpNotification(notificationText, true)

                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    lastCalled = GetGameTimer() + 500
                    callback()
                end
            end
        end

        for _, v in pairs(minimizedPropertys) do
            if not v.building then
                handleInteraction(v.door, "la propriété", function()
                    PROPERTY["propertyName"] = v.name
                    PROPERTY["handleMenu"](v)
                end)
            end
        end

        for _, v in pairs(minimizedBuildings) do
            if v.building then
                handleInteraction(vector3(v.door.x, v.door.y, v.door.z), "le building", function()
                    PROPERTY["propertyName"] = v.name
                    PROPERTY["handleMenu"](v)
                end)
            end
        end

        for _, v in pairs(minimizedDeletePoints) do
            if v.owner == playerUUID then
                handleInteraction(vector3(v.pos.x, v.pos.y, v.pos.z), "le rangement véhicule", function()
                    DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                end)
            end
        end

        Citizen.Wait(interval)
    end
end)

Citizen.CreateThread(function()
    local called = {}
    while true do
        local interval = 1000

        if PROPERTY["inProperty"] then
            interval = 0

            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 50.0 then
                DrawMarker(6, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z - 0.95, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 117, 31, 225)
            end

            if entryDst < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec la propriété", true)

                if IsControlJustPressed(0, 38) then
                    PROPERTY["exitMenu"]()
                end
            else
                called['entry'] = nil
            end

            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 50.0 then
                DrawMarker(6, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z - 0.95, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 117, 31, 225)
            end

            if entryDst < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le coffre de propriété", true)

                if IsControlJustPressed(0, 38) then
                    PROPERTY["chestMenu"]()
                end
            else
                called['chest'] = nil
            end
        end

        if PROPERTY["inGarage"] then
            interval = 0

            local gCfg = PROPERTY["garages"] and PROPERTY["garages"][PROPERTY["garageInterior"]]
            if not gCfg or not gCfg.entry then
                if not PROPERTY["_garageCfgWarned"] then
                    PROPERTY["_garageCfgWarned"] = true
                    print(("[GARAGE-DBG] Config garage introuvable cote client : garageInterior=%s (type %s), #garages=%s")
                        :format(tostring(PROPERTY["garageInterior"]), type(PROPERTY["garageInterior"]),
                                tostring(PROPERTY["garages"] and #PROPERTY["garages"] or "nil")))
                end
            else
                local entryDst = GetDistanceBetweenCoords(vector3(gCfg.entry.x, gCfg.entry.y, gCfg.entry.z), GetEntityCoords(PlayerPedId()), true)
                if entryDst < 50.0 then
                    DrawMarker(6, gCfg.entry.x, gCfg.entry.y, gCfg.entry.z - 0.95, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 255, 117, 31, 225)
                end

                if entryDst < 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le garage", true)

                    if IsControlJustPressed(0, 38) then
                        PROPERTY["garageMenu"]()
                    end
                else
                    called['entry'] = nil
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

PROPERTY.isNearPoint = function()
    local near = false

    for k,v in pairs(minimizedPropertys) do
        if not v.building then
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.door, true)
            if dst < 2.5 then
                near = true
            end
        end
    end

    for k,v in pairs(minimizedBuildings) do
        if v.building then
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.door, true)
            if dst < 2.5 then
                near = true
            end
        end
    end

    if PROPERTY["propertyId"] then
        if PROPERTY["interiors"][PROPERTY["propertyId"]] then
            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 2.0 then
                near = true
            end
        end
    end

    if PROPERTY["garageInterior"] then
        local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["garages"][PROPERTY["garageInterior"]].entry.x, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.y, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.z), GetEntityCoords(PlayerPedId()), true)
        if entryDst < 2.0 then
            near = true
        end
    end

    return near
end

Citizen.CreateThread(function()
    Citizen.SetTimeout(15 * 1000, function()
        TriggerServerEvent("property:checkLast")
    end)
end)

local sortir = false
local encour = false

Citizen.CreateThread(function ()
	while true do
        local interval = 1000

        for k,v in pairs(PROPERTY["showers"]) do
            if #(GetEntityCoords(PlayerPedId()) - v.pos) < 2.0 then
                interval = 0

                if not encour then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre une douche")

                    if IsControlJustPressed(0, 38) then
                        exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
                            if skin.sex == "mp_m_freemode_01" then
								local clothesSkin = {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 15, ['tshirt_2'] = 15,
                                    ['torso_1'] = 15, ['torso_2'] = 0,
                                    ['arms'] = 15,
                                    ['pants_1'] = 61, ['pants_2'] = 6,
                                    ['shoes_1'] = 34, ['shoes_2'] = 0,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0,
                                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                                    ["decals_1"] = -1, ["decals_2"] = 0,
                                    ['chain_1'] = 0, ['chain_2'] = 0,
                                    ['glasses_1'] = 0, ['glasses_2'] = 0
								}
								TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
							else
								local clothesSkinfemale = {
									['bags_1'] = 0, ['bags_2'] = 0,
									['tshirt_1'] = 15, ['tshirt_2'] = 15,
									['torso_1'] = 15, ['torso_2'] = 0,
									['arms'] = 15,
									['pants_1'] = 61, ['pants_2'] = 6,
									['shoes_1'] = 34, ['shoes_2'] = 0,
									['mask_1'] = 0, ['mask_2'] = 0,
									['bproof_1'] = 0,
									['helmet_1'] = -1, ['helmet_2'] = 0,
									["decals_1"] = -1, ["decals_2"] = 0,
									['chain_1'] = 0, ['chain_2'] = 0,
									['glasses_1'] = 0, ['glasses_2'] = 0
								}
								TriggerEvent('skinchanger:loadClothes', skin, clothesSkinfemale)
							end
						end)

                        local coords = GetEntityCoords(PlayerPedId())
						encour = true
						FreezeEntityPosition((PlayerPedId()), true)
						if not HasNamedPtfxAssetLoaded("core") then
							RequestNamedPtfxAsset("core")
							while not HasNamedPtfxAssetLoaded("core") do
								Wait(1)
							end
						end
						TaskStartScenarioInPlace((PlayerPedId()), "PROP_HUMAN_STAND_IMPATIENT", 0, true)
						UseParticleFxAssetNextCall("core")
                        particles = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        UseParticleFxAssetNextCall("core")
                        Citizen.Wait(3000)
                        particles2 = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        UseParticleFxAssetNextCall("core")
                        Citizen.Wait(3000)
                        particles3 = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        UseParticleFxAssetNextCall("core")
                        Citizen.Wait(3000)
                        particles4 = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                        UseParticleFxAssetNextCall("core")
                        Citizen.Wait(3000)
                        particles5 = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z +1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
						timer = 8
						sortir = true

                        Citizen.CreateThread(function()
                            while timer > 0 do
								timer = timer - 1

                                Citizen.Wait(1000)
                            end

                            encour = false
							FreezeEntityPosition((PlayerPedId()), false)
							ESX.ShowNotification("~g~Vous êtes tout propre !")
							ClearPedTasksImmediately(PlayerPedId())

                            exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)

							StopParticleFxLooped(particles, 0) StopParticleFxLooped(particles2, 0) StopParticleFxLooped(particles3, 0) StopParticleFxLooped(particles4, 0) StopParticleFxLooped(particles5, 0)
							sortir = false
                        end)
                    end
                end
            end
        end

        Citizen.Wait(interval)
	end
end)
