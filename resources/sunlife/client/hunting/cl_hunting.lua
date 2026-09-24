local huntingZones = {
    {
        name = "Chasse Cayo Perico",
        center = vector3(4848.76, -4622.7, 15.47),
        radius = 230.0,
        blipColor = 1,
        blipSprite = 141,
        maxAnimalsInZone = 15,
        animals = {
            {model = "a_c_panther", chance = 15},
            {model = "a_c_rhesus", chance = 10},
            {model = "a_c_hen", chance = 15},
            {model = "a_c_chickenhawk", chance = 10},
            {model = "a_c_boar", chance = 50},
        }
    },
    {
        name = "Zone de Chasse LS",
        center = vector3(-1543.32, 4634.24, 25.33),
        radius = 280.0,
        blipColor = 2,
        blipSprite = 141,
        maxAnimalsInZone = 15,
        animals = {
            { model = "a_c_boar", chance = 30 },
            { model = "a_c_mtlion", chance = 10 },
            { model = "a_c_rabbit_01", chance = 20 },
            { model = "a_c_seagull", chance = 10 },
        }
    },
    {
        name = "Zone de Chasse Las Venturas",
        center = vector3(8179.503418, -1521.410767, 19.030460),
        radius = 150.0,
        blipColor = 44,
        blipSprite = 141,
        maxAnimalsInZone = 15,
        animals = {
            {model = "alligatorprp", chance = 20},
            {model = "a_c_rhesus", chance = 80},
        }
    }
}

local HUNTING_SELL_PRICE_MULTIPLIER = 0.8

local huntingObjects = {
    items2buy = {
        {model = "clippompe", name = "Munitions de chasse", money = 5000},
        {model = "WEAPON_KNIFE", name = "Couteau", money = 25000},
        {model = "WEAPON_MUSKET", name = "Mousquet", money = 150000},
    },
    items4sale = {
        {model = "viande", name = "Viande", money = 2500},
        {model = "peaulapin", name = "Peau de lapin", money = 2500},
        {model = "peaurat", name = "Peau de rat", money = 2500},
        {model = "peausanglier", name = "Peau de sanglier", money = 4000},
        {model = "peaupuma", name = "Peau de puma", money = 5000},
        {model = "plume", name = "Plume", money = 5000},
        {model = "plumeaigle", name = "Plume d'aigle", money = 10000},
        {model = "peaupanther", name = "Peau de panthère", money = 10000},
        {model = "peausinge", name = "Peau de singe", money = 12500},
        {model = "peaucrocodile", name = "Peau de crocodile", money = 15500},
    }
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local HUNTING_EVENT_CONVAR = 'slf_hu_ev'

local function _sendAnimalSkinned(animalName)
    local ev = GetConvar(HUNTING_EVENT_CONVAR, '')

    if ev == '' then return end
    TriggerServerEvent(ev, animalName)
end

local animals = {}
local isInHuntingZone = false
local OnGoingHuntSession = false
local activeZone = nil
local closestDeadAnimal = nil
local animalSpawnDistance = 75
local weaponGiven = false
local OnChasseActive = false

local currentTarget = nil
local huntKillCount = 0
local huntTotalTargets = 10
local huntActive = false
local huntRouteBlip = nil

Citizen.CreateThread(function()
	RMenu.Add('menu', 'chasse', RageUI.CreateMenu("SunLife", "Chasse", 1, 100))
    RMenu:Get('menu', 'chasse'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'chasse').EnableMouse = false
    RMenu:Get('menu', 'chasse').Closed = function()
		OnChasseActive = false
    end
end)

local chasseNPCs = {
    { pos = vector3(-1491.312256, 4981.442383, 63.313492), heading = 78.532005310059, label = "Chasse Paleto" },
    { pos = vector3(8041.298340, -1465.262451, 21.000149), heading = 54.799343109131, label = "Chasse Las Venturas" },
    { pos = vector3(4705.290527, -4467.895020, 6.438461), heading = 73.910736083984, label = "Chasse Cayo" },
}

local spawnedNPCs = {}
local hasHuntingLicense = false

Citizen.CreateThread(function()
    while not ESX do Wait(100) end

    for _, npc in ipairs(chasseNPCs) do
        local model = GetHashKey("s_m_y_ranger_01")
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(50) end

        local ped = CreatePed(4, model, npc.pos.x, npc.pos.y, npc.pos.z - 1.0, npc.heading, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

        table.insert(spawnedNPCs, ped)

        local blip = AddBlipForCoord(npc.pos)
        SetBlipSprite(blip, 141)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 25)
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SUNLIFE_HUNTING_1_" .. tostring(blip)
        AddTextEntry(_key, npc.label)
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('hunting:licenseStatus')
AddEventHandler('hunting:licenseStatus', function(has)
    hasHuntingLicense = has
end)

Citizen.CreateThread(function()
    while true do
        local nearThing = false
        local plyCoords = GetEntityCoords(PlayerPedId(), false)

        for _, npc in ipairs(chasseNPCs) do
            local dist = #(plyCoords - npc.pos)
            if dist <= 3.0 then
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler avec le ~o~chasseur")
                if IsControlJustPressed(1, 51) then
                    if not OnChasseActive then
                        openChasseMenu()
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

function openChasseMenu()
    if OnChasseActive then
        OnChasseActive = false
        return
    else
        OnChasseActive = true
        RageUI.Visible(RMenu:Get('menu', 'chasse'), true)

        Citizen.CreateThread(function()
            while OnChasseActive do
                RageUI.IsVisible(RMenu:Get('menu', 'chasse'), true, true, true, function()

                    if not hasHuntingLicense then
                        RageUI.ButtonWithStyle("~o~Acheter le permis de chasse", nil, {RightLabel = "~g~50,000$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("hunting:buyLicense")
                                RageUI.CloseAll()
                                OnChasseActive = false
                            end
                        end)
                        RageUI.Separator("~r~Permis requis pour chasser")
                    else
                        RageUI.Separator("~g~Permis de chasse ✓")
                    end

                    RageUI.Separator("Objets à acheter")

                    for k,v in pairs(huntingObjects.items2buy) do
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.money.. "$"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                TriggerServerEvent("hunting:buyObject", v.model)
                                RageUI.CloseAll()
                                OnChasseActive = false
                            end
                        end)
                    end

                    RageUI.Separator("Objets à revendre")

                    for k, v in pairs(huntingObjects.items4sale) do
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = math.floor(v.money * HUNTING_SELL_PRICE_MULTIPLIER) .. "$"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local quantityCount = KeyboardInput("Indiquez la quantité en vente", "", 30)
                                quantityCount = tonumber(quantityCount)

                                if quantityCount == nil or quantityCount <= 0 or quantityCount > 50 then
                                    ESX.ShowNotification("Vous ne pouvez pas en vendre autant !")
                                    return
                                else
                                    TriggerServerEvent("hunting:sellAnimal", v.model, quantityCount)
                                end
                            end
                        end)
                    end

                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function CreateHuntingBlip(zone)
	local blip = AddBlipForCoord(zone.center)

	SetBlipSprite(blip, zone.blipSprite)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, zone.blipColor)
	SetBlipScale(blip, 0.8)

	SetBlipAsShortRange(blip, true)
	local _key = "BN_SUNLIFE_HUNTING_2_" .. tostring(blip)
	AddTextEntry(_key, zone.name)
	BeginTextCommandSetBlipName(_key)
	EndTextCommandSetBlipName(blip)

    local areaBlip = AddBlipForRadius(zone.center.x, zone.center.y, zone.center.z, zone.radius)
    SetBlipColour(areaBlip, zone.blipColor)
    SetBlipAlpha(areaBlip, 128)
    SetBlipAsShortRange(areaBlip, true)

    return blip
end

function CreateHuntingBlips()
    for _, zone in ipairs(huntingZones) do
        CreateHuntingBlip(zone)
    end
end

function IsPlayerInHuntingZone(zone)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - zone.center)
    return distance <= zone.radius
end

function GetRandomAnimalForZone(zone)
    local totalChance = 0

    for _, animal in ipairs(zone.animals) do
        totalChance = totalChance + animal.chance
    end

    local randomChance = math.random(1, totalChance)
    local cumulativeChance = 0

    for _, animal in ipairs(zone.animals) do
        cumulativeChance = cumulativeChance + animal.chance
        if randomChance <= cumulativeChance then
            return GetHashKey(animal.model), animal.model
        end
    end
end

function GetSafeZCoord(x, y, z)
    local retval, groundZ = GetGroundZFor_3dCoord(x, y, z + 100.0, false)
    if not retval then
        retval, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000.0, false)
    end
    if not retval then
        groundZ = z
    end
    return groundZ
end

function SpawnAnimalInZone(zone)
    if not isInHuntingZone or #animals >= zone.maxAnimalsInZone then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local spawnOffset = vector3(
        math.random(-animalSpawnDistance, animalSpawnDistance),
        math.random(-animalSpawnDistance, animalSpawnDistance),
        0.0
    )

    local spawnCoords = zone.center + spawnOffset
    local groundZ = GetSafeZCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)

    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)

    local animalModel, animalName = GetRandomAnimalForZone(zone)
    RequestModel(animalModel)
    while not HasModelLoaded(animalModel) do
        Wait(100)
    end

    print(('^6[NETDIAG][PED]^7 %s cl_hunting.lua:325 CreatePed NETWORKED animal'):format(GetCurrentResourceName()))
    local animal = CreatePed(28, animalModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    SetEntityAsMissionEntity(animal, true, true)
    TaskWanderStandard(animal, 1.0, 10)

    local blip = AddBlipForEntity(animal)

	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.8)

	SetBlipAsShortRange(blip, true)
	local _key = "BN_SUNLIFE_HUNTING_3_" .. tostring(blip)
	AddTextEntry(_key, "Animal")
	BeginTextCommandSetBlipName(_key)
	EndTextCommandSetBlipName(blip)

    table.insert(animals, { entity = animal, name = animalName, blip = blip })
end

local animalLabels = {
    ["a_c_boar"] = "Sanglier",
    ["a_c_mtlion"] = "Puma",
    ["a_c_rabbit_01"] = "Lapin",
    ["a_c_seagull"] = "Mouette",
    ["a_c_panther"] = "Panthère",
    ["a_c_rhesus"] = "Singe",
    ["a_c_hen"] = "Poule",
    ["a_c_chickenhawk"] = "Aigle",
    ["alligatorprp"] = "Crocodile",
}

function SpawnNextTarget(zone)
    if not huntActive or not zone then return end
    if huntKillCount >= huntTotalTargets then
        ESX.ShowAdvancedNotification("Chef - Chasse", "~o~SunLife", "~g~Bravo ! Vous avez terminé votre session de chasse (" .. huntTotalTargets .. "/" .. huntTotalTargets .. ") !", "CHAR_MP_RAY_LAVOY", 8)
        CleanupCurrentTarget()
        huntActive = false
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local minDist, maxDist = 40, animalSpawnDistance
    local angle = math.random() * 2 * math.pi
    local dist = math.random(minDist, maxDist)
    local spawnCoords = vector3(
        playerCoords.x + math.cos(angle) * dist,
        playerCoords.y + math.sin(angle) * dist,
        playerCoords.z
    )

    local inZone = #(spawnCoords - zone.center) <= zone.radius
    if not inZone then
        spawnCoords = zone.center + vector3(math.random(-animalSpawnDistance, animalSpawnDistance), math.random(-animalSpawnDistance, animalSpawnDistance), 0.0)
    end

    local groundZ = GetSafeZCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)

    local animalModel, animalName = GetRandomAnimalForZone(zone)
    RequestModel(animalModel)
    while not HasModelLoaded(animalModel) do Wait(100) end

    print(('^6[NETDIAG][PED]^7 %s cl_hunting.lua:388 CreatePed NETWORKED animal'):format(GetCurrentResourceName()))
    local animal = CreatePed(28, animalModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, math.random(0, 360) + 0.0, true, false)
    SetEntityAsMissionEntity(animal, true, true)
    TaskWanderStandard(animal, 1.0, 10)

    local blip = AddBlipForEntity(animal)
    SetBlipSprite(blip, 141)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, false)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    local label = animalLabels[animalName] or "Animal"
    local _key = "BN_SUNLIFE_HUNTING_4_" .. tostring(blip)
    AddTextEntry(_key, "Cible " .. (huntKillCount + 1) .. "/" .. huntTotalTargets .. " - " .. label)
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(blip)

    currentTarget = { entity = animal, name = animalName, blip = blip, number = huntKillCount + 1 }

    ESX.ShowAdvancedNotification("Chef - Chasse", "~o~Cible " .. currentTarget.number .. "/" .. huntTotalTargets, "Traquez le ~o~" .. label .. "~s~ ! Suivez le GPS.", "CHAR_MP_RAY_LAVOY", 8)
end

function CleanupCurrentTarget()
    if currentTarget then
        if DoesEntityExist(currentTarget.entity) then
            DeleteEntity(currentTarget.entity)
        end
        if currentTarget.blip then
            RemoveBlip(currentTarget.blip)
        end
        currentTarget = nil
    end
end

function RemoveDistantAnimals(zone)
    for i = #animals, 1, -1 do
        local animal = animals[i]
        if DoesEntityExist(animal.entity) then
            local animalCoords = GetEntityCoords(animal.entity)
            local distance = #(animalCoords - zone.center)
            if distance > zone.radius * 1.2 then
                DeleteEntity(animal.entity)
                RemoveBlip(animal.blip)
                table.remove(animals, i)
                SpawnAnimalInZone(zone)
            end
        end
    end
end

function GetClosestDeadAnimal(playerCoords)
    local closestAnimal = nil
    local minDistance = 1000.0

    for _, animal in ipairs(animals) do
        if DoesEntityExist(animal.entity) and IsEntityDead(animal.entity) then
            local animalCoords = GetEntityCoords(animal.entity)
            local distance = #(playerCoords - animalCoords)
            if distance < minDistance then
                minDistance = distance
                closestAnimal = animal.entity
            end
        end
    end

    return closestAnimal
end

Citizen.CreateThread(function()
    CreateHuntingBlips()
    while true do
        Citizen.Wait(1000)

        isInHuntingZone = false
        for _, zone in ipairs(huntingZones) do
            if IsPlayerInHuntingZone(zone) then
                isInHuntingZone = true
                activeZone = zone
                break
            end
        end

        if isInHuntingZone and not OnGoingHuntSession then
            if not hasHuntingLicense then
                ESX.ShowNotification("~r~Vous devez posséder un permis de chasse ! Parlez à un chasseur.")
                Citizen.Wait(10000)
            else
                OnGoingHuntSession = true
                huntActive = true
                huntKillCount = 0

                ESX.ShowAdvancedNotification("Chef - Zone de chasse", "~o~SunLife", "Bienvenue en zone de chasse ! Votre première cible va apparaître. Suivez le GPS.", "CHAR_MP_RAY_LAVOY", 8)
                Citizen.Wait(3000)
                SpawnNextTarget(activeZone)
            end

        elseif not isInHuntingZone and OnGoingHuntSession then
            OnGoingHuntSession = false
            huntActive = false
            huntKillCount = 0
            CleanupCurrentTarget()

            for _, animal in ipairs(animals) do
                if DoesEntityExist(animal.entity) then
                    DeleteEntity(animal.entity)
                    RemoveBlip(animal.blip)
                end
            end
            animals = {}
            activeZone = nil
        end

        if OnGoingHuntSession and currentTarget then
            if not DoesEntityExist(currentTarget.entity) then
                CleanupCurrentTarget()
                Citizen.Wait(2000)
                SpawnNextTarget(activeZone)
            else
                local animalCoords = GetEntityCoords(currentTarget.entity)
                if #(animalCoords - activeZone.center) > activeZone.radius * 1.3 then
                    CleanupCurrentTarget()
                    ESX.ShowNotification("~o~L'animal s'est enfui trop loin ! Une nouvelle cible apparaît...")
                    Citizen.Wait(2000)
                    SpawnNextTarget(activeZone)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if huntActive and currentTarget and DoesEntityExist(currentTarget.entity) then
            local animalCoords = GetEntityCoords(currentTarget.entity)
            DrawMarker(2, animalCoords.x, animalCoords.y, animalCoords.z + 1.3, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.35, 0.35, 0.35, 255, 50, 50, 200, true, false, 2, false, nil, nil, false)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local interval = 1000

        if huntActive and currentTarget and DoesEntityExist(currentTarget.entity) then
            if IsEntityDead(currentTarget.entity) then
                local playerCoords = GetEntityCoords(PlayerPedId())
                local animalCoords = GetEntityCoords(currentTarget.entity)
                local dist = #(playerCoords - animalCoords)

                if dist < 2.5 then
                    interval = 0
                    local label = animalLabels[currentTarget.name] or "Animal"
                    ESX.ShowHelpNotification("Appuyez sur ~o~[E]~s~ pour dépecer le ~o~" .. label .. "~s~ (" .. currentTarget.number .. "/" .. huntTotalTargets .. ")")

                    if IsControlJustPressed(0, 38) then
                        local playerPed = PlayerPedId()
                        local currentWeapon = GetSelectedPedWeapon(playerPed)

                        if currentWeapon ~= GetHashKey("WEAPON_KNIFE") then
                            ESX.ShowNotification("~r~Vous devez avoir un couteau en main pour dépecer un animal.")
                        else
                            RequestAnimDict("amb@medic@standing@kneel@base")
                            while not HasAnimDictLoaded("amb@medic@standing@kneel@base") do
                                Citizen.Wait(10)
                            end
                            TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base", "base", 8.0, -8.0, 5000, 1, 0, false, false, false)
                            Citizen.Wait(5000)
                            ClearPedTasks(playerPed)

                            local animalName = currentTarget.name
                            _sendAnimalSkinned(animalName)

                            CleanupCurrentTarget()
                            huntKillCount = huntKillCount + 1

                            ESX.ShowNotification("~g~Animal dépecé ! (" .. huntKillCount .. "/" .. huntTotalTargets .. ")")

                            Citizen.Wait(3000)
                            SpawnNextTarget(activeZone)
                        end
                    end
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

function KeyboardInput(one, two, max)
    local i = nil

    exports.dialog:openDialog(one, function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)

    return i
end
