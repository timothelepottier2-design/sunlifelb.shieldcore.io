local Config = PolConfig

local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'poltablet', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'poltablet', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('poltablet/' .. name, cb)
end

local tabletOpen = false
local tabletEntity = nil
local headshotHandle = nil
local animDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local animName = "base"
local animFlag = 1 | 8 | 16 | 32 | 1048576
local boneIndex = 28422

local function HasTabletItem()
    if not Config.Item or not Config.Item.Require then
        return true
    end

    if GetResourceState("es_extended") == "started" then
        local ESX = exports["es_extended"]:getSharedObject()
        local inv = ESX.GetPlayerData().inventory or {}
        for _, item in ipairs(inv) do
            if item.name == Config.Item.Name and (not item.count or item.count > 0) then
                return true
            end
        end
        return false
    end

    if GetResourceState("qb-core") == "started" then
        local has = exports["qb-inventory"] or exports["ox_inventory"]
        if has and has.HasItem then
            return has:HasItem(Config.Item.Name)
        end
    end
    return true
end

local function IsPoliceJob()
    if not Config.AllowedJobs or #Config.AllowedJobs == 0 then
        return true
    end
    if GetResourceState("es_extended") == "started" then
        local ESX = exports["es_extended"]:getSharedObject()
        local job = ESX.GetPlayerData().job
        if job and job.name then
            for _, j in ipairs(Config.AllowedJobs) do
                if job.name == j then return true end
            end
        end
        return false
    end
    if GetResourceState("qb-core") == "started" then
        local QBCore = exports["qb-core"]:GetCoreObject()
        local job = QBCore.Functions.GetPlayerData().job
        if job and job.name then
            for _, j in ipairs(Config.AllowedJobs) do
                if job.name == j then return true end
            end
        end
        return false
    end
    return true
end

local function LoadModel(modelHash)
    if not IsModelValid(modelHash) then return false end
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
            Wait(10)
        end
    end
    return HasModelLoaded(modelHash)
end

local function DeleteTabletObject()
    if tabletEntity and DoesEntityExist(tabletEntity) then
        DeleteEntity(tabletEntity)
        tabletEntity = nil
    end
end

local function PlayTabletAnim(play)
    local ped = PlayerPedId()
    if play then
        RequestAnimDict(animDict)
        local timeout = GetGameTimer() + 3000
        while not HasAnimDictLoaded(animDict) and GetGameTimer() < timeout do
            Wait(10)
        end
        if HasAnimDictLoaded(animDict) then
            TaskPlayAnim(ped, animDict, animName, 8.0, -4.0, -1, animFlag, 0, false, false, false)
        end
    else
        ClearPedTasks(ped)
        RemoveAnimDict(animDict)
    end
end

local function CreateTabletObject()
    local ped = PlayerPedId()
    if not LoadModel(Config.TabletModel) then return end
    local coords = GetEntityCoords(ped)
    print(('^2[NETDIAG][OBJET]^7 %s main.lua:118 CreateObject NETWORKED tablet'):format(GetCurrentResourceName()))
    tabletEntity = CreateObject(Config.TabletModel, coords.x, coords.y, coords.z - 5.0, true, true, false)
    while not DoesEntityExist(tabletEntity) do Wait(10) end
    SetEntityVisible(tabletEntity, false, false)
    AttachEntityToEntity(tabletEntity, ped, GetPedBoneIndex(ped, boneIndex),
        Config.TabletOffset.x, Config.TabletOffset.y, Config.TabletOffset.z,
        Config.TabletRotation.x, Config.TabletRotation.y, Config.TabletRotation.z,
        true, true, false, true, 1, true)
    Wait(400)
    SetEntityVisible(tabletEntity, true, false)
    SetModelAsNoLongerNeeded(Config.TabletModel)
end

function ToggleTablet(open)
    if open == tabletOpen then return end
    if open then
        if not HasTabletItem() then return end
        if not IsPoliceJob() then return end
        if IsNuiFocused() then return end
        tabletOpen = true
        PlayTabletAnim(true)
        CreateTabletObject()
        SetNuiFocus(true, true)
        TriggerServerEvent("SNL_PolTablet:server:getPlayerInfo")

        CreateThread(function()
            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end
            if headshotHandle and IsPedheadshotValid(headshotHandle) then
                UnregisterPedheadshot(headshotHandle)
                headshotHandle = nil
            end
            headshotHandle = RegisterPedheadshot(ped)
            local timeout = GetGameTimer() + 5000
            while (not IsPedheadshotReady(headshotHandle) or not IsPedheadshotValid(headshotHandle)) and GetGameTimer() < timeout do
                Wait(50)
            end
            if tabletOpen and IsPedheadshotValid(headshotHandle) then
                local txd = GetPedheadshotTxdString(headshotHandle)
                local mugshotUrl = ("https://nui-img/%s/%s"):format(txd, txd)
                SendNUIMessage({ action = "updateMugshot", mugshot = mugshotUrl })
            elseif headshotHandle and IsPedheadshotValid(headshotHandle) then
                UnregisterPedheadshot(headshotHandle)
                headshotHandle = nil
            end
        end)
    else
        tabletOpen = false
        if headshotHandle and IsPedheadshotValid(headshotHandle) then
            UnregisterPedheadshot(headshotHandle)
            headshotHandle = nil
        end
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "close" })
        PlayTabletAnim(false)
        DeleteTabletObject()
    end
end

local function TryOpenTablet()
    if not HasTabletItem() then return end
    if not IsPoliceJob() then return end
    ToggleTablet(not tabletOpen)
end

RegisterCommand(Config.OpenCommand or "SNL_PolTablet:open", function()
    TryOpenTablet()
end, false)
RegisterKeyMapping(Config.OpenCommand or "SNL_PolTablet:open", "Ouvrir la tablette police", "keyboard", Config.OpenKeyDefault or "")

RegisterNetEvent("SNL_PolTablet:client:useTablet", function()
    if not IsPoliceJob() then return end
    if tabletOpen then return end
    ToggleTablet(true)
end)

local function GetMapControlPoints()
    local pts = Config.MapControlPoints or {}
    local out = {}
    for _, p in ipairs(pts) do
        if type(p.gameX) == "number" and type(p.gameY) == "number" and type(p.px) == "number" and type(p.py) == "number" then
            out[#out + 1] = { gameX = p.gameX, gameY = p.gameY, px = p.px, py = p.py }
        end
    end
    return out
end

RegisterNetEvent("SNL_PolTablet:client:receivePlayerInfo", function(playerInfo, cachedAgents)
    if not tabletOpen then return end
    local bounds = Config.MapBounds or { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }
    local imgSize = Config.MapImageSize or { width = 2048, height = 2048 }
    SendNUIMessage({
        action = "open",
        frameColor = Config.FrameColor or "#0a0a0a",
        resourceName = GetCurrentResourceName(),
        player = playerInfo or {},
        mapBounds = bounds,
        mapImageSize = imgSize,
        mapControlPoints = GetMapControlPoints(),
        mapYFlipped = Config.MapYFlipped == true,
        mapLinear = Config.MapLinear ~= false,
        mapSwapXY = Config.MapSwapXY == true,
        onDuty = playerInfo and playerInfo.on_duty == true
    })

    if (Config.EnableMapAgents ~= false) and cachedAgents and #cachedAgents > 0 then
        local scaleX = Config.MapCoordScaleX or 1
        local scaleY = Config.MapCoordScaleY or 1
        local list = {}
        for _, a in ipairs(cachedAgents) do
            list[#list + 1] = { source = a.source, gameX = a.x * scaleX, gameY = a.y * scaleY, label = a.name, grade = a.grade }
        end
        SendNUIMessage({
            action = "updateMapAgents",
            agents = list,
            bounds = bounds,
            mapImageSize = imgSize,
            mapControlPoints = GetMapControlPoints(),
            mapYFlipped = Config.MapYFlipped == true,
            mapLinear = Config.MapLinear ~= false,
            mapSwapXY = Config.MapSwapXY == true
        })
    end
end)

RegisterNetEvent("SNL_PolTablet:client:receiveAgentPositions", function(agents)
    if not tabletOpen then return end
    local bounds = Config.MapBounds or { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }
    local scaleX = Config.MapCoordScaleX or 1
    local scaleY = Config.MapCoordScaleY or 1
    local list = {}
    for _, a in ipairs(agents or {}) do
        list[#list + 1] = { source = a.source, gameX = a.x * scaleX, gameY = a.y * scaleY, label = a.name, grade = a.grade }
    end
    local imgSize = Config.MapImageSize or { width = 2048, height = 2048 }
    SendNUIMessage({
        action = "updateMapAgents",
        agents = list,
        bounds = bounds,
        mapImageSize = imgSize,
        mapControlPoints = GetMapControlPoints(),
        mapYFlipped = Config.MapYFlipped == true,
        mapLinear = Config.MapLinear ~= false,
        mapSwapXY = Config.MapSwapXY == true
    })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveDutyState", function(onDuty)
    if not tabletOpen then return end
    SendNUIMessage({ action = "updateDutyState", onDuty = onDuty })
    if onDuty then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local myName = GetPlayerName(PlayerId()) or "Moi"
        local scaleX = Config.MapCoordScaleX or 1
        local scaleY = Config.MapCoordScaleY or 1
        local imgSize = Config.MapImageSize or { width = 2048, height = 2048 }
        local bounds = Config.MapBounds or { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }
        SendNUIMessage({
            action = "updateMapAgents",
            agents = {{ source = GetPlayerServerId(PlayerId()), gameX = coords.x * scaleX, gameY = coords.y * scaleY, label = myName }},
            bounds = bounds,
            mapImageSize = imgSize,
            mapControlPoints = GetMapControlPoints(),
            mapYFlipped = Config.MapYFlipped == true,
            mapLinear = Config.MapLinear ~= false,
            mapSwapXY = Config.MapSwapXY == true
        })
        CreateThread(function()
            Wait(1000)
            if tabletOpen then
                TriggerServerEvent("SNL_PolTablet:server:requestAgentPositions")
            end
        end)
    else
        local imgSize = Config.MapImageSize or { width = 2048, height = 2048 }
        local bounds = Config.MapBounds or { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }
        SendNUIMessage({
            action = "updateMapAgents",
            agents = {},
            bounds = bounds,
            mapImageSize = imgSize,
            mapControlPoints = GetMapControlPoints(),
            mapYFlipped = Config.MapYFlipped == true,
            mapLinear = Config.MapLinear ~= false,
            mapSwapXY = Config.MapSwapXY == true
        })
        CreateThread(function()
            Wait(1000)
            if tabletOpen then
                TriggerServerEvent("SNL_PolTablet:server:requestAgentPositions")
            end
        end)
    end
end)

RegisterNUICallback("close", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:tabletClosed")
    ToggleTablet(false)
    cb("ok")
end)

RegisterNUICallback("toggleDuty", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:setOnDuty")
    cb("ok")
end)

RegisterNUICallback("getConfig", function(_, cb)
    cb({ frameColor = Config.FrameColor or "#0a0a0a", backgroundColor = Config.BackgroundColor or "#1c1b22" })
end)

RegisterNUICallback("setProfileImage", function(data, cb)
    local url = type(data) == "table" and (data.url or data.profileImageUrl) or nil
    TriggerServerEvent("SNL_PolTablet:server:setProfileImage", url)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:profileImageSaved", function(result)
    if not tabletOpen then return end
    SendNUIMessage({ action = "profileImageSaved", success = result.success, url = result.url })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveCitizenSearch", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveCitizenSearch", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveWantedCitizens", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveWantedCitizens", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveCitizenProfile", function(profile)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveCitizenProfile", profile = profile or {} })
end)

RegisterNUICallback("searchCitizens", function(data, cb)
    local q = type(data) == "table" and (data.query or data.q or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:searchCitizens", q)
    cb("ok")
end)

RegisterNUICallback("getWantedCitizens", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:getWantedCitizens")
    cb("ok")
end)

RegisterNUICallback("getCitizenProfile", function(data, cb)
    local id = type(data) == "table" and (data.identifier or data.id) or nil
    if not id then cb(nil) return end
    TriggerServerEvent("SNL_PolTablet:server:getCitizenProfile", id)
    cb("ok")
end)

RegisterNUICallback("citizenSetWaypoint", function(data, cb)
    local x = type(data) == "table" and data.x or nil
    local y = type(data) == "table" and data.y or nil
    if x and y then
        SetNewWaypoint(tonumber(x) + 0.0, tonumber(y) + 0.0)
    end
    cb("ok")
end)

RegisterNUICallback("propertyGPS", function(data, cb)
    local d = type(data) == "table" and data or {}
    local propX = d.x
    local propY = d.y
    local propName = d.propertyName
    local hasCoords = propX ~= nil and propY ~= nil

    if hasCoords then
        SetNewWaypoint(tonumber(propX) + 0.0, tonumber(propY) + 0.0)
        cb({ ok = true, action = "waypoint" })
    else
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local px, py, pz = coords.x, coords.y, coords.z
        SetNewWaypoint(px + 0.0, py + 0.0)
        if propName and propName ~= "" then
            TriggerServerEvent("SNL_PolTablet:server:savePropertyCoords", propName, px, py, pz)
        end
        cb({ ok = true, action = "pinned", x = px, y = py, z = pz })
    end
end)

RegisterNUICallback("citizenAddWarrant", function(data, cb)
    local id = type(data) == "table" and data.identifier or nil
    local reason = type(data) == "table" and (data.reason or data.motif) or ""
    if id then TriggerServerEvent("SNL_PolTablet:server:citizenAddWarrant", id, reason) end
    cb("ok")
end)

RegisterNUICallback("citizenAddCasier", function(data, cb)
    local id = type(data) == "table" and data.identifier or nil
    local entry = type(data) == "table" and (data.entry or data.texte) or ""
    if id then TriggerServerEvent("SNL_PolTablet:server:citizenAddCasier", id, entry) end
    cb("ok")
end)

RegisterNUICallback("citizenCreateReport", function(data, cb)
    local id = type(data) == "table" and data.identifier or nil
    local content = type(data) == "table" and (data.content or data.texte) or ""
    if id then TriggerServerEvent("SNL_PolTablet:server:citizenCreateReport", id, content) end
    cb("ok")
end)

RegisterNUICallback("citizenToggleRedList", function(data, cb)
    local id = type(data) == "table" and data.identifier or nil
    if id then TriggerServerEvent("SNL_PolTablet:server:citizenToggleRedList", id) end
    cb("ok")
end)

RegisterNUICallback("setCitizenPhoto", function(data, cb)
    local id = type(data) == "table" and data.identifier or nil
    local url = type(data) == "table" and (data.url or "") or ""
    if id then TriggerServerEvent("SNL_PolTablet:server:setCitizenPhoto", id, url) end
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:citizenPhotoSaved", function(result)
    if not tabletOpen then return end
    SendNUIMessage({ action = "citizenPhotoSaved", success = result.success, identifier = result.identifier, url = result.url })
end)

RegisterNUICallback("getPlayerPosition", function(_, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    cb({ x = coords.x, y = coords.y, z = coords.z })
end)

RegisterNUICallback("savePropertyCoords", function(data, cb)
    local name = type(data) == "table" and data.propertyName or nil
    local x = type(data) == "table" and data.x or nil
    local y = type(data) == "table" and data.y or nil
    local z = type(data) == "table" and data.z or nil
    if name and x and y then
        TriggerServerEvent("SNL_PolTablet:server:savePropertyCoords", name, x, y, z)
    end
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:propertyCoordsSaved", function(result)
    if not tabletOpen then return end
    SendNUIMessage({ action = "propertyCoordsSaved", success = result.success, propertyName = result.propertyName, x = result.x, y = result.y })
end)

RegisterNUICallback("citizenEmitVehicleSearch", function(data, cb)
    local plate = type(data) == "table" and (data.plate or data.plaque) or nil
    if plate then TriggerServerEvent("SNL_PolTablet:server:emitVehicleSearch", plate) end
    cb("ok")
end)

RegisterNUICallback("searchVehicleByPlate", function(data, cb)
    local plate = type(data) == "table" and (data.plate or data.plaque or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:searchVehicleByPlate", plate)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:vehicleSearchByPlateResult", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "vehicleSearchByPlateResult", list = list or {} })
end)

RegisterNUICallback("suggestVehicleByPlate", function(data, cb)
    local partial = type(data) == "table" and (data.partial or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:suggestVehicleByPlate", partial)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:vehicleSuggestResult", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "vehicleSuggestResult", list = list or {} })
end)

RegisterNUICallback("searchWarrants", function(data, cb)
    local q = type(data) == "table" and (data.query or data.q or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:searchWarrants", q)
    cb("ok")
end)

RegisterNUICallback("createWarrant", function(data, cb)
    local d = type(data) == "table" and data or {}
    local id = d.identifier or d.target_identifier
    local reason = d.reason or d.motif or ""
    local description = d.description or ""
    local images = type(d.images) == "table" and json.encode(d.images) or (type(d.images) == "string" and d.images or "[]")
    if id then TriggerServerEvent("SNL_PolTablet:server:createWarrant", id, reason, description, images) end
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:warrantsSearchResult", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "warrantsSearchResult", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:warrantCreated", function(success)
    if not tabletOpen then return end
    SendNUIMessage({ action = "warrantCreated", success = success })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveActiveWarrants", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveActiveWarrants", list = list or {} })
end)

RegisterNUICallback("getRecentCasiers", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:getRecentCasiers")
    cb("ok")
end)

RegisterNUICallback("searchCasiers", function(data, cb)
    local q = type(data) == "table" and (data.query or data.q or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:searchCasiers", q)
    cb("ok")
end)

RegisterNUICallback("createFullCasier", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:createFullCasier", data)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:receiveRecentCasiers", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveRecentCasiers", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveCasiersSearch", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveCasiersSearch", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:casierCreated", function(success)
    if not tabletOpen then return end
    SendNUIMessage({ action = "casierCreated", success = success })
end)

RegisterNUICallback("getRecentReports", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:getRecentReports")
    cb("ok")
end)

RegisterNUICallback("searchReports", function(data, cb)
    local q = type(data) == "table" and (data.query or data.q or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:searchReports", q)
    cb("ok")
end)

RegisterNUICallback("createFullReport", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:createFullReport", data)
    cb("ok")
end)

RegisterNUICallback("editReport", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:editReport", data)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:receiveRecentReports", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveRecentReports", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:receiveReportsSearch", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveReportsSearch", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:reportCreated", function(success)
    if not tabletOpen then return end
    SendNUIMessage({ action = "reportCreated", success = success })
end)

RegisterNetEvent("SNL_PolTablet:client:reportEdited", function(success)
    if not tabletOpen then return end
    SendNUIMessage({ action = "reportEdited", success = success })
end)

RegisterNUICallback("getActiveWarrants", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:getActiveWarrants")
    cb("ok")
end)

RegisterNUICallback("getWantedVehicles", function(_, cb)
    TriggerServerEvent("SNL_PolTablet:server:getWantedVehicles")
    cb("ok")
end)

RegisterNUICallback("addWantedVehicle", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:addWantedVehicle", data)
    cb("ok")
end)

RegisterNUICallback("removeWantedVehicle", function(data, cb)
    local plate = type(data) == "table" and (data.plate or "") or ""
    TriggerServerEvent("SNL_PolTablet:server:removeWantedVehicle", plate)
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:receiveWantedVehicles", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "receiveWantedVehicles", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:wantedVehicleAdded", function(data)
    if not tabletOpen then return end
    SendNUIMessage({ action = "wantedVehicleAdded", plate = data and data.plate or "" })
end)

RegisterNetEvent("SNL_PolTablet:client:wantedVehicleRemoved", function(data)
    if not tabletOpen then return end
    SendNUIMessage({ action = "wantedVehicleRemoved", plate = data and data.plate or "" })
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    local id = type(data) == "table" and tonumber(data.id) or nil
    if id then TriggerServerEvent("SNL_PolTablet:server:deleteWarrant", id) end
    cb("ok")
end)

RegisterNUICallback("deleteCasier", function(data, cb)
    local id = type(data) == "table" and tonumber(data.id) or nil
    if id then TriggerServerEvent("SNL_PolTablet:server:deleteCasier", id) end
    cb("ok")
end)

RegisterNUICallback("editCasier", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:editCasier", data)
    cb("ok")
end)

RegisterNUICallback("editWarrant", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:editWarrant", data)
    cb("ok")
end)

RegisterNUICallback("deleteReport", function(data, cb)
    local id = type(data) == "table" and tonumber(data.id) or nil
    if id then TriggerServerEvent("SNL_PolTablet:server:deleteReport", id) end
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:deleteResult", function(result)
    if not tabletOpen then return end
    SendNUIMessage({ action = "deleteResult", success = result.success, reason = result.reason, type = result.type, remaining = result.remaining })
end)

RegisterNetEvent("SNL_PolTablet:client:editResult", function(result)
    if not tabletOpen then return end
    SendNUIMessage({ action = "editResult", success = result.success, reason = result.reason, type = result.type })
end)

RegisterNUICallback("createAlert", function(data, cb)
    local d = type(data) == "table" and data or {}
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("SNL_PolTablet:server:createAlert", {
        reason = d.reason or "",
        urgency = d.urgency or "low",
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb("ok")
end)

RegisterNUICallback("getAlerts", function(data, cb)
    TriggerServerEvent("SNL_PolTablet:server:getAlerts")
    cb("ok")
end)

RegisterNUICallback("requestAgentPositions", function(data, cb)
    if tabletOpen then
        TriggerServerEvent("SNL_PolTablet:server:requestAgentPositions")
    end
    cb("ok")
end)

RegisterNUICallback("alertGPS", function(data, cb)
    local d = type(data) == "table" and data or {}
    local x = tonumber(d.x)
    local y = tonumber(d.y)
    if x and y then
        CreateThread(function()
            Wait(0)
            SetNewWaypoint(x + 0.0, y + 0.0)
        end)
    end
    cb("ok")
end)

local function DoTakeScreenshot(cb)
    local baseUrl = Config.Fivemanage and Config.Fivemanage.UploadUrl or "https://api.fivemanage.com/api/v2/image"
    local apiKey = Config.Fivemanage and Config.Fivemanage.ApiKey or ""
    if not apiKey or apiKey == "" then
        cb({ success = false, error = "Fivemanage.ApiKey non configurée" })
        return
    end
    if GetResourceState("screenshot-basic") ~= "started" then
        cb({ success = false, error = "screenshot-basic non démarré" })
        return
    end
    local url = baseUrl .. (baseUrl:find("?") and "&" or "?") .. "apiKey=" .. apiKey
    local opts = { encoding = "png" }
    exports["screenshot-basic"]:requestScreenshotUpload(url, "file", opts, function(response)
        local ok, resp = pcall(json.decode, response)
        if not ok or not resp then
            cb({ success = false, error = "Réponse invalide" })
            return
        end
        local imgUrl = resp.url or (resp.data and resp.data.url)
        if imgUrl and imgUrl ~= "" then
            cb({ success = true, url = imgUrl })
        else
            local err = resp.message or resp.error or resp.msg or (resp.data and resp.data.error)
            cb({ success = false, error = err and tostring(err) or "URL non reçue" })
        end
    end)
end

RegisterNUICallback("takePhoto", function(_, cb)
    DoTakeScreenshot(cb)
end)

RegisterNUICallback("startPhotoMode", function(_, cb)
    cb("ok")
    if not tabletOpen then return end
    local savedCamMode = GetFollowPedCamViewMode()
    SetFollowPedCamViewMode(4)
    SendNUIMessage({ action = "hideForCamera" })
    SetNuiFocus(false, false)
    CreateThread(function()
        local capturing = false
        while tabletOpen and not capturing do
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            if IsControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 24) then
                capturing = true
                SendNUIMessage({ action = "captureTriggered" })
                local exitDelay = (Config.PhotoExitDelayMs or 200)
                DoTakeScreenshot(function(result)
                    if exitDelay > 0 then
                        SendNUIMessage({ action = "photoUploadComplete", result = result })
                    else
                        SetFollowPedCamViewMode(savedCamMode)
                        SetNuiFocus(true, true)
                        SendNUIMessage({ action = "showAfterCamera", result = result })
                    end
                end)
                if exitDelay > 0 then
                    CreateThread(function()
                        Wait(exitDelay)
                        SetFollowPedCamViewMode(savedCamMode)
                        SetNuiFocus(true, true)
                        SendNUIMessage({ action = "showAfterCamera", result = nil })
                    end)
                end
                break
            elseif IsControlJustPressed(0, 322) then
                SetFollowPedCamViewMode(savedCamMode)
                SetNuiFocus(true, true)
                SendNUIMessage({ action = "cancelCamera" })
                break
            end
            Wait(0)
        end
        if not capturing then
            SetFollowPedCamViewMode(savedCamMode)
        end
    end)
end)

RegisterNUICallback("panicButton", function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("SNL_PolTablet:server:createAlert", {
        reason = "⚠ PANIC BUTTON",
        urgency = "high",
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
    cb("ok")
end)

RegisterNetEvent("SNL_PolTablet:client:alertsList", function(list)
    if not tabletOpen then return end
    SendNUIMessage({ action = "alertsList", list = list or {} })
end)

RegisterNetEvent("SNL_PolTablet:client:newAlert", function(alert)
    if not tabletOpen then return end
    SendNUIMessage({ action = "newAlert", alert = alert })
end)

RegisterNetEvent("SNL_PolTablet:client:civilianPanicNotify", function(alert)
    if type(alert) ~= "table" then return end
    local x = tonumber(alert.x) or 0
    local y = tonumber(alert.y) or 0

    local who = alert.author_name or "Civil inconnu"
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(string.format("~r~🚨 PANIC CIVIL — %s~s~\n~y~Position GPS marquée", who))
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(string.format("🚨 PANIC CIVIL — %s", who))
        EndTextCommandThefeedPostTicker(true, true)
    end

    if x ~= 0 or y ~= 0 then
        SetNewWaypoint(x + 0.0, y + 0.0)
    end

    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
    Wait(150)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)

    if tabletOpen then
        SendNUIMessage({
            action = "panicAlert",
            playerName = who,
            coords = { x = x, y = y, gameX = x, gameY = y }
        })
    end
end)

RegisterNetEvent("SNL_PolTablet:client:panicResult", function(res)
    if type(res) ~= "table" then return end
    if res.ok then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification("~g~🚨 Panic envoyé. Les forces de l'ordre sont prévenues.")
        end
    else
        if res.reason == "cooldown" then
            if ESX and ESX.ShowNotification then
                ESX.ShowNotification("~o~Panic indisponible (cooldown 5 min).")
            end
        elseif res.reason == "invalid_pos" then
            if ESX and ESX.ShowNotification then
                ESX.ShowNotification("~r~Panic refusé : position invalide.")
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(200)
        if tabletOpen and IsNuiFocused() then
            if IsControlJustReleased(0, 322) then
                ToggleTablet(false)
            end
        end
    end
end)

OnResourceStop(GetCurrentResourceName(), function()
    if headshotHandle and IsPedheadshotValid(headshotHandle) then
        UnregisterPedheadshot(headshotHandle)
        headshotHandle = nil
    end
    if tabletOpen then
        SetNuiFocus(false, false)
        PlayTabletAnim(false)
        DeleteTabletObject()
    end
end)
