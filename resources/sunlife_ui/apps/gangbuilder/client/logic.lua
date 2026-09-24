ESX = exports["es_extended"]:getSharedObject()

local gangs = {}
local blips = {}
local debugShowAll = false
local playerGang = false
local playerGangName = nil
local myGang = false

local spriteByPoint = {
    armory = 110,
    chest = 473,
    garage = 357,
    vehicle_store = 357,
    vehicle_retrieve = 357,
    laundering = 500,
    management = 475
}

local markerByPoint = {
    chest = 30,
    vehicle_store = 24,
    armory = 21,
    laundering = 29,
    garage = 36,
    management = 20
}

local scaleByPoint = {
    armory = 0.65,
    chest = 0.55,
    garage = 0.85,
    vehicle_store = 0.80,
    laundering = 0.65,
    management = 0.70
}

local colorByPoint = {
    armory = { 70, 160, 255, 190 },
    chest = { 255, 200, 70, 185 },
    garage = { 120, 255, 120, 175 },
    vehicle_store = { 255, 120, 120, 175 },
    laundering = { 200, 120, 255, 190 },
    management = { 255, 90, 200, 190 }
}

local permByPoint = {
    armory = "armory_access",
    chest = "chest_access",
    garage = "garage_access",
    vehicle_store = "garage_access",
    vehicle_retrieve = "garage_access",
    laundering = "laundering_access",
    management = "management_access"
}

local playerGang = false
local playerGangName = nil

local function clearBlips()
    for i = 1, #blips do
        local b = blips[i]
        if b and DoesBlipExist(b) then
            RemoveBlip(b)
        end
    end
    blips = {}
end

local function addPointBlip(coords, sprite, color, text)
    local b = AddBlipForCoord(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
    SetBlipSprite(b, sprite or 1)
    SetBlipScale(b, 0.75)
    SetBlipColour(b, color or 1)
    SetBlipAsShortRange(b, true)
    local _key = "BN_SNL_GANGBUILDER_LOG_1_" .. tostring(b)
    AddTextEntry(_key, text or "Point")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(b)
    blips[#blips + 1] = b
end

local function getHighestRankId(gang)
    if not gang or type(gang.ranks) ~= "table" or #gang.ranks == 0 then
        return nil
    end

    local maxId = nil
    for i = 1, #gang.ranks do
        local r = gang.ranks[i]
        local id = tonumber(r and r.id)
        if id and (not maxId or id > maxId) then
            maxId = id
        end
    end

    return maxId
end

local function isPlayerHighestGrade()
    if debugShowAll then
        return true
    end

    local gang = myGang
    if not gang and type(gangs) == "table" then
        gang = gangs[1]
    end

    local maxId = getHighestRankId(gang)
    local gr = playerGang and tonumber(playerGang.grade) or nil

    if not maxId or not gr then
        return false
    end

    return gr == maxId
end

local function canSeePoint(pointKey)
    if debugShowAll then
        return true
    end

    if pointKey == "management" then
        return isPlayerHighestGrade()
    end

    if not playerGang or type(playerGang) ~= "table" then
        return false
    end

    if type(playerGang.perms) ~= "table" then
        return false
    end

    local perm = permByPoint[pointKey]
    if not perm then
        return false
    end

    return playerGang.perms[perm] == true
end

local function gangMatchesPlayer(g)
    if debugShowAll then
        return true
    end

    if not playerGangName or playerGangName == "" then
        return false
    end

    if not g or not g.name then
        return false
    end

    return string.lower(g.name) == string.lower(playerGangName)
end

local function applyGangData(data)
    if data == false or type(data) ~= "table" then
        playerGang = false
        playerGangName = nil
        clearBlips()
        return
    end

    playerGang = data
    playerGangName = data.name
    rebuildBlips()
end

function rebuildBlips()
    clearBlips()

    for i = 1, #gangs do
        local g = gangs[i]
        if gangMatchesPlayer(g) then
            local color = tonumber(g.territory_color or 1) or 1
            local gangLabel = tostring(g.name or "Gang")

            if canSeePoint("armory") and g.armory and g.armory.pos then
                addPointBlip(g.armory.pos, spriteByPoint.armory, color, gangLabel .. " - Armurerie")
            end

            if canSeePoint("chest") and type(g.chests) == "table" then
                for j = 1, #g.chests do
                    local c = g.chests[j]
                    if c and c.pos then
                        addPointBlip(c.pos, spriteByPoint.chest, color, gangLabel .. " - Coffre #" .. tostring(j))
                    end
                end
            end

            if canSeePoint("garage") and g.garage and g.garage.pos then
                addPointBlip(g.garage.pos, spriteByPoint.garage, color, gangLabel .. " - Garage")
            end

            if canSeePoint("vehicle_store") and g.vehicle_store and g.vehicle_store.pos then
                addPointBlip(g.vehicle_store.pos, spriteByPoint.vehicle_store, color, gangLabel .. " - Rangement")
            end

            if canSeePoint("laundering") and g.laundering and g.laundering.enabled == true and g.laundering.pos then
                addPointBlip(g.laundering.pos, spriteByPoint.laundering, color, gangLabel .. " - Blanchiment")
            end

            if canSeePoint("management") and g.management and g.management.pos then
                addPointBlip(g.management.pos, spriteByPoint.management, color, gangLabel .. " - Gestion")
            end
        end
    end
end

local function refreshPlayerGang()
    GB_Rpc("gb:mygd", function(data)
        local newName = (type(data) == "table" and data.name) or nil
        local newGrade = (type(data) == "table" and tonumber(data.grade)) or nil

        local oldGrade = (playerGang and tonumber(playerGang.grade)) or nil
        local changed = (newName ~= playerGangName) or (newGrade ~= oldGrade)

        if changed then
            applyGangData(data)
        end
    end)
end

local function setGangs(list)
    if type(list) ~= "table" then
        return
    end
    gangs = list
    rebuildBlips()
end

local function setMyGang(gang)
    myGang = gang
    gangs = {}
    if gang and type(gang) == "table" then
        gangs = { gang }
    end
    rebuildBlips()
end

local function refreshMyBundle()
    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" then
            applyGangData(false)
            setMyGang(false)
            return
        end

        applyGangData(bundle.my)
        setMyGang(bundle.gang)
    end)
end

RegisterNetEvent("gangbuilder:syncGang", function(gang)
    if gang == false then
        applyGangData(false)
        setMyGang(false)
        return
    end
    if type(gang) == "table" then
        setMyGang(gang)
    end
end)

RegisterNetEvent("esx:playerLoaded", function()
    refreshMyBundle()
end)

RegisterNetEvent("gangbuilder:members:updated", function()
    refreshMyBundle()
end)

RegisterNetEvent("esx:setJob", function()
    refreshMyBundle()
end)

CreateThread(function()
    Wait(1500)
    refreshMyBundle()
end)

local function drawMarkerForPoint(p)
    local m = markerByPoint[p.key]
    if not m then
        return
    end

    local pos = p.pos
    local s = scaleByPoint[p.key] or 0.7
    local c = colorByPoint[p.key] or { 255, 255, 255, 180 }

    DrawMarker(
        m,
        pos.x + 0.0, pos.y + 0.0, (pos.z - 0.5) + 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        s, s, s,
        c[1], c[2], c[3], c[4],
        false, true, 2, false, nil, nil, false
    )

    DrawMarker(
        6,
        pos.x + 0.0, pos.y + 0.0, (pos.z - 1.0) + 0.0,
        0.0, 0.0, 0.0,
        -90.0, 0.0, 0.0,
        s * 1.4, s * 1.4, s * 1.4,
        c[1], c[2], c[3], math.min(255, c[4] + 25),
        false, false, 2, false, nil, nil, false
    )
end

local function showHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function addPointsFromGang(g, points)
    if canSeePoint("armory") and g.armory and g.armory.pos then
        points[#points + 1] = { key = "armory", pos = g.armory.pos }
    end

    if canSeePoint("chest") and type(g.chests) == "table" then
        for j = 1, #g.chests do
            local c = g.chests[j]
            if c and c.pos then
                points[#points + 1] = { key = "chest", index = j, pos = c.pos }
            end
        end
    end

    if canSeePoint("garage") and g.garage and g.garage.pos then
        points[#points + 1] = { key = "garage", pos = g.garage.pos }
    end

    if canSeePoint("vehicle_store") and g.vehicle_store and g.vehicle_store.pos then
        points[#points + 1] = { key = "vehicle_store", pos = g.vehicle_store.pos }
    end

    if canSeePoint("vehicle_retrieve") and g.vehicle_retrieve and g.vehicle_retrieve.pos then
        points[#points + 1] = { key = "vehicle_retrieve", pos = g.vehicle_retrieve.pos }
    end

    if canSeePoint("laundering") and g.laundering and g.laundering.enabled == true and g.laundering.pos then
        points[#points + 1] = { key = "laundering", pos = g.laundering.pos }
    end

    if canSeePoint("management") and g.management and g.management.pos then
        points[#points + 1] = { key = "management", pos = g.management.pos }
    end
end

local function pointLabel(p)
    if p.key == "chest" then
        return ("Coffre #%s"):format(tostring(p.index or "?"))
    end
    if p.key == "armory" then
        return "Armurerie"
    end
    if p.key == "garage" then
        return "Garage"
    end
    if p.key == "vehicle_store" then
        return "Rangement vehicule"
    end
    if p.key == "vehicle_retrieve" then
        return "Sortie vehicule"
    end
    if p.key == "laundering" then
        return "Blanchiment"
    end
    if p.key == "management" then
        return "Gestion"
    end
    return tostring(p.key or "Point")
end

function LaunderKeyboardInput(defaultText)
    AddTextEntry("LAUNDER_AMOUNT", "Montant a blanchir")
    DisplayOnscreenKeyboard(1, "LAUNDER_AMOUNT", "", defaultText or "", "", "", "", 64)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    local status = UpdateOnscreenKeyboard()
    if status == 1 then
        local res = GetOnscreenKeyboardResult()
        if res and res ~= "" then
            return res
        end
    end

    return nil
end

CreateThread(function()
    local lastInteractAt = 0

    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)

        for i = 1, #gangs do
            local g = gangs[i]
            if gangMatchesPlayer(g) then
                local points = {}
                addPointsFromGang(g, points)

                for k = 1, #points do
                    local p = points[k]
                    local pos = p.pos
                    local dist = #(pcoords - vector3(pos.x + 0.0, pos.y + 0.0, pos.z + 0.0))

                    if dist < 30.0 then
                        sleep = 0
                        drawMarkerForPoint(p)
                    elseif dist < 80.0 then
                        sleep = 0
                    end

                    if dist < 1.5 then
                        sleep = 0
                        showHelp(("Appuie sur ~INPUT_CONTEXT~ pour intéragir: ~y~%s"):format(pointLabel(p)))

                        if IsControlJustReleased(0, 38) then
                            local now = GetGameTimer()
                            if now - lastInteractAt > 150 then
                                lastInteractAt = now
                                if p.key == "management" then
                                    if OpenGangManagementMenu then
                                        OpenGangManagementMenu()
                                    else
                                        ESX.ShowNotification("~r~Menu gestion non chargé.")
                                    end
                                elseif p.key == "laundering" then
                                    local amount = LaunderKeyboardInput("")

                                    if amount then
                                        ESX.TriggerServerCallback("gangbuilder:launder:cash", function(ok, msg)
                                            if ok then
                                                if Notify then
                                                    Notify("success", msg or "Blanchiment OK")
                                                else
                                                    ESX.ShowNotification(msg or "~g~Blanchiment OK")
                                                end
                                            else
                                                if Notify then
                                                    Notify("error", msg or "Erreur")
                                                else
                                                    ESX.ShowNotification("~r~" .. (msg or "Erreur"))
                                                end
                                            end
                                        end, amount)
                                    end
                                elseif p.key == "chest" then
                                    TriggerServerEvent("inventory:server:openGangChest", tonumber(p.index), true)
                                elseif p.key == "armory" then
                                    OpenGangArmoryMenu()
                                elseif p.key == "garage" then
                                    if OpenGangGarageMenu then
                                        OpenGangGarageMenu()
                                    else
                                        ESX.ShowNotification("~r~Garage non chargé.")
                                    end
                                elseif p.key == "vehicle_store" then
                                    if StoreCurrentGangVehicle then
                                        StoreCurrentGangVehicle()
                                    else
                                        ESX.ShowNotification("~r~Rangement non chargé.")
                                    end
                                elseif p.key == "vehicle_retrieve" then
                                    if OpenGangGarageMenu then
                                        OpenGangGarageMenu()
                                    else
                                        ESX.ShowNotification("~r~Garage non chargé.")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

exports("GetMyGangName", function()
    if type(playerGangName) == "string" and playerGangName ~= "" then
        return playerGangName
    end

    if type(playerGang) == "table" and type(playerGang.name) == "string" and playerGang.name ~= "" then
        return playerGang.name
    end

    if type(myGang) == "table" and type(myGang.name) == "string" and myGang.name ~= "" then
        return myGang.name
    end

    return nil
end)

exports("GetMyGangData", function()
    if type(playerGang) == "table" then
        return playerGang
    end
    return false
end)
