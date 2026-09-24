DRUGTERRAIN = {
    ["spawnedPeds"] = {},
    ["groupPeds"] = {},
    ["allBlips"] = {},
    ["started"] = false,
    ["group"] = false,
    ["nearPed"] = false,
    ["loadedThreads"] = false,
    ["currentPed"] = nil,
    ["currentDrug"] = nil,
    ["loading"] = false,
}

local maxNPCs = 20
local spawnDelay = 500
local spawnRadius = 100
local totalNPCsSpawned = 0
local interactedPeds = {}

local situationChances = {
    accept = 700,
    refuse = 200,
    callPolice = 70,
    attack = 30
}
local influenceCoords = vector3(4945.14, -5192.93, 2.5)
local influenceRadius = 100.0

DrawSub = function(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

function adjustChancesBasedOnProximity(playerCoords, situationChances)
    local distance = #(playerCoords - influenceCoords)

    if distance <= influenceRadius then

        situationChances.attack = 100
        situationChances.refuse = 300
        situationChances.callPolice = 50
        situationChances.accept = 550
    else

        situationChances.attack = 30
        situationChances.refuse = 400
        situationChances.callPolice = 70
        situationChances.accept = 500
    end
end

function getOutcomeBasedOnChance(chances)
    local totalChance = 0
    local randomValue = math.random(1, 1000)

    for outcome, chance in pairs(chances) do
        totalChance = totalChance + chance
        if randomValue <= totalChance then
            return outcome
        end
    end
    return nil
end

DRUGTERRAIN.spawnNPC = function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnX, spawnY, spawnZ
    local foundSafeCoord, safeCoords
    local isInTerritory = false
    local maxAttempts = 10
    local isRoxwood = false

    local distToRoxwood = #(playerCoords - vector3(-1144.31, 7901.0, playerCoords.z))
    if distToRoxwood < 3500.0 then
        isRoxwood = true
    end

    for i = 1, maxAttempts do
        local rx, ry = math.random(-spawnRadius, spawnRadius), math.random(-spawnRadius, spawnRadius)
        spawnX = playerCoords.x + rx
        spawnY = playerCoords.y + ry

        if isRoxwood then
            spawnZ = playerCoords.z + 5.0
        else
            spawnZ = playerCoords.z + 1000.0
            foundSafeCoord, safeCoords = GetSafeCoordForPed(spawnX, spawnY, playerCoords.z, true, 16)
            if foundSafeCoord then
                spawnX, spawnY, spawnZ = safeCoords.x, safeCoords.y, safeCoords.z
            end
        end

        if TERRITORIES.isInCoords(vector3(spawnX, spawnY, spawnZ)) then
            isInTerritory = true
            break
        end
    end

    if not isInTerritory then
        print("Impossible de trouver une position dans un territoire valide après " .. maxAttempts .. " tentatives.")
        return
    end

    if not isRoxwood then
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ + 100.0, 0)
        if foundGround then
            spawnZ = groundZ
        else
            spawnZ = playerCoords.z
        end
    end

    local choosedPed = DRUGTERRAIN.getPed()
    if not HasModelLoaded(GetHashKey(choosedPed)) then
        RequestModel(GetHashKey(choosedPed))
        while not HasModelLoaded(GetHashKey(choosedPed)) do
            Citizen.Wait(100)
        end
    end

    local ped = CreatePed(1, choosedPed, spawnX, spawnY, spawnZ, math.random(0, 360), false, true)
    SetEntityVisible(ped, false, 0)
    SetEntityInvincible(ped, true)

    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)

    Citizen.CreateThread(function()
        while not HasCollisionLoadedAroundEntity(ped) do
            Citizen.Wait(0)
        end
        SetEntityVisible(ped, true, 0)

        while IsEntityInAir(ped) do
            Citizen.Wait(500)
        end

        SetEntityInvincible(ped, false)
    end)

    if not DecorIsRegisteredAsType("canBeRacketed", 2) then
        DecorRegister("canBeRacketed", 2)
    end
    DecorSetBool(ped, "canBeRacketed", false)

    table.insert(DRUGTERRAIN["spawnedPeds"], ped)
    TaskWanderStandard(ped, 10.0, 10)

    Citizen.CreateThread(function()
        local lastPosition = GetEntityCoords(ped)
        local freezeTimer = 0

        while DoesEntityExist(ped) and not interactedPeds[ped] do
            local pedCoords = GetEntityCoords(ped)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - pedCoords)
            local inTerritory = TERRITORIES.isInCoords(pedCoords)

            if distance > spawnRadius or not inTerritory then
                if DoesEntityExist(ped) then DeleteEntity(ped) end
                DRUGTERRAIN.spawnNPC()
                return
            end

            if #(pedCoords - lastPosition) < 1.0 then
                freezeTimer = freezeTimer + 1
            else
                freezeTimer = 0
            end

            if freezeTimer > 3 then
                if DoesEntityExist(ped) then DeleteEntity(ped) end
                DRUGTERRAIN.spawnNPC()
                return
            end

            lastPosition = pedCoords
            Citizen.Wait(5000)
        end
    end)

    return ped
end

DrawText3DDrug = function(coords, text, size, a, font, dropShadow)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	local opacity = a or 255
	local font = font or 4

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, opacity)
		SetTextDropshadow(1, 1, 1, 1, 255)
		SetTextCentre(1)
		SetTextEntry('STRING')

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

DRUGTERRAIN.handleInteraction = function(ped)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local distance = #(playerCoords - pedCoords)
    local data = TERRITORIES.isIn()

    if IsPedInAnyVehicle(PlayerPedId(), false) then return end

    if interactedPeds[ped] then
        ESX.ShowNotification("~r~Vous avez déjà interagi avec ce PNJ.")
        return
    end

    if distance < 2.0 then

        interactedPeds[ped] = true

        ClearPedTasks(ped)

        adjustChancesBasedOnProximity(GetEntityCoords(PlayerPedId()), situationChances)

        local outcome = getOutcomeBasedOnChance(situationChances)

        if outcome == "accept" then
            Citizen.CreateThread(function()

                if not HasAnimDictLoaded("mp_common") then
                    RequestAnimDict("mp_common")
                    while not HasAnimDictLoaded("mp_common") do
                        Citizen.Wait(10)
                    end
                end

                TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 3000, 49, 0, false, false, false)
                TaskPlayAnim(ped, "mp_common", "givetake1_b", 8.0, -8.0, 3000, 49, 0, false, false, false)
            end)

            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["sayYes"][math.random(1, #cfg_drugTerrain["randomPhrases"]["sayYes"])], 2500)
            Citizen.Wait(1000)
            DRUGTERRAIN["loading"] = true
            local choosedTime = math.random(1000, 2500)
            TriggerEvent("core:drawBar", choosedTime, "⏳ Transaction en cours...")
            Citizen.Wait(choosedTime)
            DRUGTERRAIN["loading"] = false

            TriggerServerEvent("drugTerrain:accept", {
                drug = DRUGTERRAIN["currentDrug"],
                territorie = data,
            })

        elseif outcome == "refuse" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["sayNo"][math.random(1, #cfg_drugTerrain["randomPhrases"]["sayNo"])], 2500)
            Citizen.Wait(1000)

        elseif outcome == "callPolice" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["callPolice"][math.random(1, #cfg_drugTerrain["randomPhrases"]["callPolice"])], 2500)
            Citizen.Wait(1000)

            local coords = GetEntityCoords(PlayerPedId())
			local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 755.57, 4899.1, 0, true) <= 3000 then
                TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "sheriff")
            else
                TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "police")
            end

        elseif outcome == "attack" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["attack"][math.random(1, #cfg_drugTerrain["randomPhrases"]["attack"])], 2500)
            Citizen.Wait(1000)
        end

        if outcome ~= "attack" then
            TaskSmartFleePed(ped, playerPed, 100.0, -1, false, false)

            Citizen.SetTimeout(15000, function()
                if DoesEntityExist(ped) then
                    DeleteEntity(ped)

                    Citizen.Wait(2000)
                    DRUGTERRAIN.spawnNPC()
                end
            end)
        end
    end
end

DRUGTERRAIN.spawnNPCs = function()
    Citizen.CreateThread(function()
        for i = 1, maxNPCs do
            if DRUGTERRAIN["started"] then

                local ped = DRUGTERRAIN.spawnNPC()

                Citizen.Wait(spawnDelay)
            else
                break
            end
        end
    end)
end

DRUGTERRAIN.onClose = function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    TriggerServerEvent("drugTerrain:removeFromSellers")

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    ESX.ShowNotification("~r~Vous venez de fermer votre terrain de drogue")
end

RegisterNetEvent("DRUGTERRAIN.onOpen")
AddEventHandler("DRUGTERRAIN.onOpen", function()
    DRUGTERRAIN.onOpen()
end)

RegisterNetEvent("DRUGTERRAIN.forceClose")
AddEventHandler("DRUGTERRAIN.forceClose", function()
    DRUGTERRAIN.forceClose()
end)

DRUGTERRAIN.onOpen = function(first, data)
    local founded = TERRITORIES.isIn()
    if not founded then
        ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans cette zone")
        return
    end

    DRUGTERRAIN["started"] = true

    if first then
        ESX.ShowNotification("~y~Vous venez d'ouvrir votre terrain de drogue")
    end

    DRUGTERRAIN.spawnNPCs()

    Citizen.CreateThread(function()
        while DRUGTERRAIN["started"] do
            local interval = 500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            founded = TERRITORIES.isIn()
            if not founded then
                DRUGTERRAIN.forceClose()
                return
            end

            for _, ped in pairs(DRUGTERRAIN["spawnedPeds"]) do
                if DoesEntityExist(ped) and not interactedPeds[ped] then

                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(playerCoords - pedCoords)

                    if distance < 5.5 then
                        interval = 0

                        local x,y,z = table.unpack(GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0))
                        DrawText3DDrug(vector3(x, y, z + 0.40), "~y~[E]", 1.0)
                    end

                    if distance < 2.5 then

                        if IsControlJustReleased(0, 38) then
                            DRUGTERRAIN.handleInteraction(ped)
                        end
                    end
                end
            end

            Citizen.Wait(interval)
        end
    end)
end

local lastCalled = 0
DRUGTERRAIN.handle = function(terrainData)
    if DRUGTERRAIN["loading"] then return end

    DRUGTERRAIN["currentDrug"] = terrainData.drug

    Citizen.CreateThread(function()
        if DRUGTERRAIN["started"] then
            DRUGTERRAIN.onClose()
            return
        end

        local founded = TERRITORIES.isIn()
        if not founded then
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans cette zone")
            return
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans un véhicule")
            return
        end

        if GetGameTimer() > lastCalled then
            DRUGTERRAIN.onOpen(true, founded)
            lastCalled = GetGameTimer() + 5 * 1000
        end
    end)

    if not DRUGTERRAIN["loadedThreads"] then
        DRUGTERRAIN["loadedThreads"] = true
        Citizen.CreateThread(function()
            while true do

                Citizen.Wait(15 * 1000)
            end
        end)
    end
end

DRUGTERRAIN.getPed = function()
    math.randomseed(GetGameTimer())
    return cfg_drugTerrain["allPeds"][math.random(1, #cfg_drugTerrain["allPeds"])]
end

DRUGTERRAIN.forceClose = function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    for _,blip in pairs(DRUGTERRAIN["allBlips"]) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end

RegisterNetEvent("drugTerrain:cancelAll")
AddEventHandler("drugTerrain:cancelAll", function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
end)

RegisterNetEvent("drugTerrain:sendRentability")
AddEventHandler("drugTerrain:sendRentability", function(list)
    RequestStreamedTextureDict("assetsalynia", 1)
    while not HasStreamedTextureDictLoaded("assetsalynia") do
        Wait(0)
    end

    for k, v in pairs(cfg_drugTerrain["allPoints"]) do
        if DoesBlipExist(v.blip) then
            RemoveBlip(v.blip)
        end

        v.blip = AddBlipForCoord(v.pos)
        SetBlipSprite(v.blip, v.sprite)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.8)
        SetBlipColour(v.blip, cfg_drugTerrain["blipsColors"][list[k].rentability])
        SetBlipAsShortRange(v.blip, true)
        local _key = "BN_SUNLIFE_DRUGTERRAIN_1_" .. tostring(k)
        AddTextEntry(_key, "Points fréquentés")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(v.blip)
    end
end)
