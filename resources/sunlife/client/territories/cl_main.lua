ESX = exports["es_extended"]:getSharedObject()

TERRITORIES = TERRITORIES or {}
TERRITORIES.showMap = false
TERRITORIES.whiteZones = {
    vector3(1348.1, 3563.74, 35.0),
    vector3(1678.51, 4798.83, 41.86),
    vector3(-140.62, 6323.61, 31.6),
}
TERRITORIES.Gang = false
TERRITORIES.GangReady = false

local _gbPending = {}
local _gbSeq = 0

RegisterNetEvent("gb:dealer:rpc:reply")
AddEventHandler("gb:dealer:rpc:reply", function(reqId, ...)

    local cb = _gbPending[reqId]
    if not cb then return end
    _gbPending[reqId] = nil
    cb(...)
end)

local function _gbRpc(op, cb, ...)
    _gbSeq = _gbSeq + 1
    local reqId = "snl_terr_" .. _gbSeq
    _gbPending[reqId] = cb or function() end
    TriggerServerEvent("gb:dealer:rpc", reqId, op, ...)
end

local _terrPending = {}
local _terrSeq = 0

RegisterNetEvent("snl:terr:rpc:reply")
AddEventHandler("snl:terr:rpc:reply", function(reqId, ...)
    local cb = _terrPending[reqId]
    if not cb then return end
    _terrPending[reqId] = nil
    cb(...)
end)

local function _terrRpc(op, cb, ...)
    _terrSeq = _terrSeq + 1
    local reqId = _terrSeq
    _terrPending[reqId] = cb or function() end
    TriggerServerEvent("snl:terr:rpc", reqId, op, ...)
end

local _refreshMyGangInFlight = false

local function refreshMyGang()
    if _refreshMyGangInFlight then return end
    _refreshMyGangInFlight = true

    _gbRpc("gb:mygd", function(data)
        _refreshMyGangInFlight = false
        if data and type(data) == "table" and data.name and data.name ~= "" then
            TERRITORIES.Gang = data
        else
            TERRITORIES.Gang = false
        end
        TERRITORIES.GangReady = true
    end)
end

RegisterNetEvent("gangbuilder:syncGang")
AddEventHandler("gangbuilder:syncGang", function(gang)
    if gang and type(gang) == "table" and gang.name then
        TERRITORIES.Gang = gang
    else
        TERRITORIES.Gang = false
    end
    TERRITORIES.GangReady = true
end)

AddEventHandler("onClientResourceStart", function(resName)
    if resName ~= GetCurrentResourceName() then return end
    refreshMyGang()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    refreshMyGang()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

TERRITORIES.isIllegalPlayer = function()
    if TERRITORIES.GangReady ~= true then
        refreshMyGang()
        return false
    end

    if TERRITORIES.Gang and TERRITORIES.Gang.name and TERRITORIES.Gang.name ~= "" then
        return true
    end

    return false
end

TERRITORIES.PopupTime = function(text, time)
    time = time or 2500
    ClearPrints()
    AddTextEntry("NOTIFICATION_POPUP_TIME", text)
    AddTextComponentString("NOTIFICATION_POPUP_TIME")
    BeginTextCommandPrint("NOTIFICATION_POPUP_TIME")
    EndTextCommandPrint(time, 1)
end

Citizen.CreateThread(function()
    for k, v in pairs(cfg_territorys["allTerritorys"]) do
        v.zone = PolyZone:Create(v.poly, {
            name = v.name,
            minZ = 0.0,
            maxZ = 1500.0,
        })
    end
end)

TERRITORIES.isInCoords = function(coords)
    local inPoint = false

    for k, v in pairs(cfg_territorys["allTerritorys"]) do
        if v.zone:isPointInside(coords) then
            inPoint = v
        end
    end

    if not inPoint then
        for k, v in pairs(TERRITORIES.whiteZones) do
            if #(coords - v) < 150.0 then
                inPoint = { name = "white" }
            end
        end
    end

    return inPoint
end

TERRITORIES.isIn = function()
    return TERRITORIES.isInCoords(GetEntityCoords(PlayerPedId()))
end

TERRITORIES.toggleMap = function(toggle)
    TERRITORIES.showMap = toggle == true

    if TERRITORIES.showMap then
        for k, v in pairs(cfg_territorys["allTerritorys"]) do
            if DoesBlipExist(v.blip) then
                RemoveBlip(v.blip)
            end

            v.color = tonumber(v.color)
            v.blip = AddBlipForArea(v.location, v.width, v.height)
            SetBlipColour(v.blip, (v.color or 1))
            SetBlipAlpha(v.blip, 125)
            SetBlipHighDetail(v.blip, true)
            SetBlipRotation(v.blip, (v.heading or 0.0))
            SetBlipDisplay(v.blip, 4)
            SetBlipAsShortRange(v.blip, true)
        end

        TriggerServerEvent("territories:getMap")
    else
        for k, v in pairs(cfg_territorys["allTerritorys"]) do
            if DoesBlipExist(v.blip) then
                RemoveBlip(v.blip)
            end
            if DoesBlipExist(v.blipFirst) then
                RemoveBlip(v.blipFirst)
            end
        end
    end
end

RegisterNetEvent("territories:updateMap")
AddEventHandler("territories:updateMap", function(data)
    if TERRITORIES.showMap ~= true then
        return
    end

    for k, v in pairs(cfg_territorys["allTerritorys"]) do
        if DoesBlipExist(v.blip) then
            RemoveBlip(v.blip)
        end

        if DoesBlipExist(v.blipFirst) then
            RemoveBlip(v.blipFirst)
        end

        if data[v.name] and data[v.name].owner ~= nil and data[v.name].owner ~= false then
            data[v.name].color = tonumber(data[v.name].color)

            AddTextEntry('BBBB' .. k, 'Territoire de ' .. tostring(data[v.name].owner))

            v.blipFirst = AddBlipForCoord(v.location)
            SetBlipSprite(v.blipFirst, 630)
            SetBlipDisplay(v.blipFirst, 3)
            SetBlipColour(v.blipFirst, data[v.name] and data[v.name].color or 39)
            SetBlipScale(v.blipFirst, 0.75)
            SetBlipAsShortRange(v.blipFirst, true)

            BeginTextCommandSetBlipName('BBBB' .. k)
            EndTextCommandSetBlipName(v.blipFirst)
        end

        v.blip = AddBlipForArea(v.location, v.width, v.height)
        SetBlipColour(v.blip, data[v.name] and data[v.name].color or 39)
        SetBlipAlpha(v.blip, 175)
        SetBlipHighDetail(v.blip, true)
        SetBlipRotation(v.blip, (v.heading or 0.0))
        SetBlipDisplay(v.blip, 3)
        SetBlipAsShortRange(v.blip, true)
    end
end)

exports("SetTerritorieMap", function(toggle)
    TERRITORIES.toggleMap(toggle)
end)

Citizen.CreateThread(function()
    local currentZone = nil

    while true do
        local interval = 30000

        if TERRITORIES.isIllegalPlayer() then
            local coords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(cfg_territorys["allTerritorys"]) do
                if v.zone:isPointInside(coords) and currentZone ~= v.name then
                    currentZone = v.name

                    _terrRpc("getData", function(rep)
                        if v.name and rep and rep[v.name] and rep[v.name].owner then
                            TERRITORIES.PopupTime("~r~Vous êtes dans le territoire de '~s~" .. tostring(rep[v.name].owner) .. "~r~'", 5000)
                        end
                    end)
                end
            end
        end

        Citizen.Wait(interval)
    end
end)
