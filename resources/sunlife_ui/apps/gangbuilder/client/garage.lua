local Config = GangConfig
local ESX = exports["es_extended"]:getSharedObject()

local GarageOpen = false
local GarageMenu = nil

local function isStored(value)
    if value == true or value == 1 then return true end
    if type(value) == "string" then return value == "1" end
    return tonumber(value) == 1
end

local function openGarage()
    if GarageOpen then
        return
    end

    GarageOpen = true

    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or type(bundle.gang) ~= "table" or type(bundle.my) ~= "table" then
            ESX.ShowNotification("~r~Aucun gang.")
            GarageOpen = false
            return
        end

        if bundle.my.perms == nil or bundle.my.perms.garage_access ~= true then
            ESX.ShowNotification("~r~Accès refusé.")
            GarageOpen = false
            return
        end

        local g = bundle.gang
        local spawnPos = g.vehicle_retrieve and g.vehicle_retrieve.pos or nil
        local heading = g.garage and (g.garage.heading or 0.0) or 0.0

        if not spawnPos then
            ESX.ShowNotification("~r~Sortie véhicule non configurée.")
            GarageOpen = false
            return
        end

        RMenu.Add("gb_garage", "main", RageUI.CreateMenu("Garage", tostring(g.name or ""), 1, 100))
        GarageMenu = RMenu:Get("gb_garage", "main")

        if Config and Config.Menu and Config.Menu.banner then
            local b = Config.Menu.banner
            GarageMenu:SetRectangleBanner(b.r or 0, b.g or 0, b.b or 0, b.a or 200)
        end

        RageUI.Visible(GarageMenu, true)

        local vehicles = {}
        GB_DealerRpc("garage:list", function(rows)
            if type(rows) == "table" then
                vehicles = rows
            else
                vehicles = {}
            end
        end)

        CreateThread(function()
            while GarageOpen do
                Wait(0)

                RageUI.IsVisible(GarageMenu, true, true, true, function()

                    RageUI.Separator("Véhicules")

                    if #vehicles == 0 then
                        RageUI.Separator("~c~Aucun véhicule")
                        return
                    end

                    for i = 1, #vehicles do
                        local row = vehicles[i]
                        local stored = isStored(row.stored)
                        local plate = tostring(row.plate or "")
                        local props = json.decode(row.vehicle or "{}") or {}
                        local modelName = tostring(props.modelname or "Vehicule")
                        local rl = stored and "~g~Disponible" or "~r~En fourrière"

                        RageUI.ButtonWithStyle(("%s [%s]"):format(modelName, plate), nil, { RightLabel = rl }, stored, function(_, _, selected)
                            if not stored then
                                return
                            end
                            if selected then
                                GB_DealerRpc("garage:take", function(ok, p)
                                    if not ok then
                                        local msg = (type(p) == "string" and p ~= "") and p or "Impossible."
                                        ESX.ShowNotification("~r~" .. msg)
                                        return
                                    end

                                    local vehProps = type(p) == "table" and p or {}
                                    local toSpawn = vehProps.modelname or vehProps.model
                                    local coords = vector3(spawnPos.x + 0.0, spawnPos.y + 0.0, spawnPos.z + 0.0)

                                    ESX.Game.SpawnVehicle(toSpawn, coords, heading + 0.0, function(vehicle)
                                        if not vehicle or vehicle == 0 then
                                            ESX.ShowNotification("~r~Spawn échoué.")
                                            return
                                        end

                                        ESX.Game.SetVehicleProperties(vehicle, vehProps)
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        SetVehicleEngineOn(vehicle, true, true, false)
                                    end)
                                end, plate)
                            end
                        end)
                    end
                end)

                if GarageMenu and not RageUI.Visible(GarageMenu) then
                    GarageOpen = false
                end
            end

            RageUI.CloseAll()
        end)
    end)
end

function OpenGangGarageMenu()
    openGarage()
end

function StoreCurrentGangVehicle()
    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or type(bundle.my) ~= "table" then
            ESX.ShowNotification("~r~Aucun gang.")
            return
        end

        if bundle.my.perms == nil or bundle.my.perms.garage_access ~= true then
            ESX.ShowNotification("~r~Accès refusé.")
            return
        end

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh == 0 then
            ESX.ShowNotification("~r~Aucun véhicule.")
            return
        end

        if GetPedInVehicleSeat(veh, -1) ~= ped then
            ESX.ShowNotification("~r~Tu dois être conducteur.")
            return
        end

        local props = ESX.Game.GetVehicleProperties(veh)
        local plate = tostring(props.plate or "")

        local modelHash = GetEntityModel(veh)
        local displayName = GetDisplayNameFromVehicleModel(modelHash)
        if type(displayName) == "string" and displayName ~= "" then
            props.modelname = props.modelname or displayName
        end
        if not props.modelname or props.modelname == "" then
            props.modelname = tostring(props.model or "Vehicule")
        end

        GB_DealerRpc("garage:store", function(ok)
            if ok then
                ESX.ShowNotification("~g~Véhicule rangé.")
                DeleteEntity(veh)
            else
                ESX.ShowNotification("~r~Impossible de ranger.")
            end
        end, plate, props)
    end)
end
