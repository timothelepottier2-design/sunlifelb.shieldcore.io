RegisterNetEvent("sJobs.setVehicleUpdate", function(netId, props)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then
        return
    end

    while not NetworkHasControlOfEntity(vehicle) do
        NetworkRequestControlOfEntity(vehicle)
        Wait(0)
    end

    ESX.Game.SetVehicleProperties(vehicle, props)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleDoorShut(vehicle, 4, false, false)
end)

function playAction(scenario, duration, label, cb)
    TaskStartScenarioInPlace(PlayerPedId(), scenario, 0, true)

    local success = lib.progressCircle({
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)

    if IsPedUsingScenario(ped, scenario) or IsPedUsingAnyScenario(ped) then
        ClearPedTasks(ped)
    end

    if success then
        if cb then
            cb()
        end
    else
        ESX.ShowNotification("~r~Action annulée.")
    end
end

local function getClosestVehicle()
    local vehicles = GetGamePool("CVehicle")
    local closestDist, closestVeh

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleDist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
        if not closestVeh or vehicleDist < closestDist then
            closestDist, closestVeh = vehicleDist, vehicle
        end
    end

    return closestDist, closestVeh
end

local function repairVehicle(itemName)
    local groups = {
        bennys = true,
        harmony = true,
        fourriere = true,
        streettuners = true
    }

    local coords = GetEntityCoords(PlayerPedId(), false)
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then return end

    local vehicle
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    else
        local _, closestVeh = getClosestVehicle()
        vehicle = closestVeh
    end

    if not DoesEntityExist(vehicle) then return end

    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) do
        Wait(0)
    end

    playAction('PROP_HUMAN_BUM_BIN', 20000, "🔧 Réparation du véhicule...", function()
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)

        local driver, driverId = nil, nil
        if IsVehicleSeatFree(vehicle, -1) then
            driver = PlayerPedId()
            driverId = PlayerId()
        else
            driver = GetPedInVehicleSeat(vehicle, -1)
            driverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
            local props = ESX.Game.GetVehicleProperties(vehicle)
            TriggerServerEvent("sJobs.setVehicleUpdate", driverId, NetworkGetNetworkIdFromEntity(vehicle), props)
        end
        ESX.ShowNotification('~g~Véhicule réparé avec succès !')

        if not groups[playerJob] and itemName then
            TriggerServerEvent("sJobs.deleteItem", itemName, 1)
        end
    end)
end

local function getVehicleData(vehicle)
    if not DoesEntityExist(vehicle) then
        return nil
    end

    return {
        fuel = Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle),
        engine = GetVehicleEngineHealth(vehicle) / 10,
        body = GetVehicleBodyHealth(vehicle) / 10,
        temp = GetVehicleEngineTemperature(vehicle),
    }
end

local function getVehicleUpgrades(vehicle)
    if not DoesEntityExist(vehicle) then return nil end

    local levels = {
        [0] = "Stock",
        [1] = "Stage 1",
        [2] = "Stage 2",
        [3] = "Stage 3",
        [4] = "Stage 4"
    }

    return {
        engine = levels[GetVehicleMod(vehicle, 11)] or "Stock",
        transmission = levels[GetVehicleMod(vehicle, 13)] or "Stock",
        suspension = levels[GetVehicleMod(vehicle, 15)] or "Stock",
        brakes = levels[GetVehicleMod(vehicle, 12)] or "Stock",
        turbo = IsToggleModOn(vehicle, 18) and "Turbo" or "N/A"
    }
end

local function showVehicleUpgrades(data)
    local vehicle = data.entity
    local upgrades = getVehicleUpgrades(vehicle)
    if not upgrades then return end

    lib.registerContext({
        id = 'vehicle_upgrades',
        title = 'Améliorations du véhicule',
        options = {
            { title = 'Moteur',       icon = 'gear',       description = upgrades.engine },
            { title = 'Transmission', icon = 'gears',      description = upgrades.transmission },
            { title = 'Suspension',   icon = 'list',       description = upgrades.suspension },
            { title = 'Freins',       icon = 'car-side',   description = upgrades.brakes },
            { title = 'Turbo',        icon = 'rocket',     description = upgrades.turbo },
        }
    })

    lib.showContext('vehicle_upgrades')
end

local function showVehicleStat(data)
    local vehicle = data.entity
    local status = getVehicleData(vehicle)
    if not status then
        return
    end

    lib.registerContext({
        id = 'vehicle_status',
        title = 'État du véhicule',
        options = {
            {
                title = 'Essence',
                icon = 'gas-pump',
                description = 'Niveau: ' .. math.ceil(status.fuel) .. '.0% / 100.0%'
            },
            {
                title = 'État moteur',
                icon = 'screwdriver-wrench',
                description = 'Niveau: ' .. math.ceil(status.engine) .. '.0% / 100.0%'
            },
            {
                title = 'État carrosserie',
                icon = 'car',
                description = 'Niveau: ' .. math.ceil(status.body) .. '.0% / 100.0%'
            },
            {
                title = 'Température moteur',
                icon = 'temperature-three-quarters',
                description = 'Temp: ' .. math.ceil(status.temp) .. '° C'
            },
            {
                title = 'Voir les améliorations',
                icon = 'sliders',
                onSelect = function()
                    showVehicleUpgrades(data)
                end
            }
        }
    })

    lib.showContext('vehicle_status')
end

exports.ox_target:addGlobalVehicle({
    {
        name = 'window_tinit',
        icon = 'fa-solid fa-droplet',
        label = 'Vérifier la teinte des fenêtres',
        distance = 2,
        groups = {"police", "sheriff"},
        canInteract = function()
            return inService
        end,
        onSelect = function(data)
            local windowTint = GetVehicleWindowTint(data.entity)
            local tints <const> = {
                [0] = "Les vitres du véhicule ne sont pas teintées.",
                [1] = "Les vitres du véhicule ont une teinte pure noire.",
                [2] = "Les vitres du véhicule ont une teinte foncée.",
                [3] = "Les vitres du véhicule ont une teinte claire.",
                [4] = "Les vitres du véhicule ont une teinte de stock.",
            }

            ESX.ShowNotification("~g~" .. (tints[windowTint] or "Les vitres du véhicule ne sont pas teintées."))
        end
    },
    {
        name = 'checking_plate',
        icon = 'fas fa-search',
        label = 'Analyse de plaque',
        distance = 2,
        groups = {"fourriere", "police", "sheriff"},
        canInteract = function()
            return inService
        end,
        onSelect = function(data)
            local plateEntity = GetVehicleNumberPlateText(data.entity)
            if not plateEntity then
                return
            end

            local input = lib.inputDialog('Analyse de plaque', {
                { type = 'checkbox', label = 'Utiliser la plaque du véhicule ciblé ?', checked = plateEntity ~= nil },
                { type = 'input', label = 'Ou entrer une plaque manuellement', placeholder = '12-XXX' }
            })
            if not input then
                return
            end

            local useTarget = input[1]
            local manualPlate = input[2]
            local plateToCheck = nil

            if useTarget and plateEntity then
                plateToCheck = plateEntity
            elseif manualPlate and manualPlate ~= '' then
                plateToCheck = manualPlate:upper()
            else
                ESX.ShowNotification('Aucune plaque valide fournie.')
                return
            end

            ESX.TriggerServerCallback('sJobs.getPlate', function(owner, found)
                if found then
                    ESX.ShowNotification("Propriétaire trouvé : " .. owner)
                else
                    ESX.ShowNotification("Plaque introuvable !")
                end
            end, plateToCheck)
        end
    },
    {
        name = 'fast_impound',
        icon = 'fas fa-truck-pickup',
        label = 'Fourrière rapide',
        distance = 2,
        groups = {"fourriere", "bennys", "harmony", "hayes", "paletoauto", "pdm", "police", "sheriff", "streettuners"},
        canInteract = function()
            return inService
        end,
        onSelect = function(data)
            DeleteEntity(data.entity)
        end
    },

    {
        name = 'crochete',
        icon = 'fa-solid fa-screwdriver',
        label = 'Crocheter',
        distance = 2,
        groups = {"fourriere", "bennys", "harmony", "hayes", "paletoauto", "pdm", "police", "sheriff", "streettuners"},
        canInteract = function()
            return inService
        end,
        onSelect = function(data)
            playAction("WORLD_HUMAN_WELDING", 5000, "🔧 Crochetage du véhicule...", function()
                SetVehicleDoorsLocked(data.entity, 1)
                SetVehicleDoorsLockedForAllPlayers(data.entity, false)

                ESX.ShowNotification('Le véhicule est ouvert !')
            end)
        end
    },
    {
        name = 'repair',
        icon = 'fa-solid fa-toolbox',
        label = 'Réparer',
        distance = 2,
        canInteract = function(entity, distance, coords, name, bone)
            local vehicleClass = GetVehicleClass(entity)
            if vehicleClass == 13 then
                return false
            end

            local groups = {
                fourriere = true,
                bennys = true,
                harmony = true,
                hayes = true,
                streettuners = true
            }
            if groups[playerJob] then
                return true
            end

            local hasKit = exports["sCore"]:hasItem("kit")
            local hasCaroKit = exports["sCore"]:hasItem("carokit")

            return hasKit or hasCaroKit
        end,
        onSelect = function(data)
            local groups = {
                fourriere = true,
                bennys = true,
                harmony = true,
                hayes = true,
                streettuners = true
            }

            if groups[playerJob] then
                repairVehicle()
            else
                ESX.TriggerServerCallback("sJobs.hasItem", function(hasItem, itemName)
                    if hasItem then
                        repairVehicle(itemName)
                    else
                        ESX.ShowNotification("~r~Vous n'avez pas de kit de réparation ni de Carokit.")
                    end
                end)
            end
        end
    },
    {
        name = 'wash',
        icon = 'fa-solid fa-hand-sparkles',
        label = 'Laver',
        distance = 2,
        groups = {"fourriere", "bennys", "harmony", "hayes", "paletoauto", "pdm", "streettuners"},
        onSelect = function(data)
            playAction('WORLD_HUMAN_MAID_CLEAN', 10000, "🧽 Nettoyage du véhicule...", function()
                SetVehicleDirtLevel(data.entity, 0)

                ESX.ShowNotification('~g~Véhicule nettoyé avec succès !')
            end)
        end
    },
    {
        name = 'performance',
        icon = 'fa-solid fa-gauge-high',
        label = 'Regarder les performances',
        distance = 2,
        groups = {"grotti"},
        onSelect = function(data)
            showVehicleStat(data)
        end
    }
})
