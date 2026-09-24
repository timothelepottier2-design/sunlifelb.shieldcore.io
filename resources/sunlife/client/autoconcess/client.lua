local ESX
local PreviewVeh
local ActiveShop
local inConcess = false
local savedPos
local savedHeading
local Blips = {}

local function blipSpriteForType(t)
    if t == 'boat' then return 427 end
    if t == 'aircraft' then return 16 end
    return 225
end

CreateThread(function()
    for _, shop in ipairs(AutoConcess.Shops) do
        local blip = AddBlipForCoord(shop.open.x, shop.open.y, shop.open.z)
        SetBlipSprite(blip, shop.blipSprite or blipSpriteForType(shop.type))
        SetBlipColour(blip, shop.blipColor or 47)
        SetBlipScale(blip, shop.blipScale or 0.8)
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SUNLIFE_AUTOCONCESS_1_" .. tostring(blip)
        AddTextEntry(_key, shop.title or "Concession")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
        Blips[#Blips+1] = blip
    end
end)

CreateThread(function()
    local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
    if ok and obj then ESX = obj end
    while not ESX do
        TriggerEvent('esx:getShtozaredObjtozect', function(o) ESX = o end)
        Wait(0)
    end
end)

local function fmt(n)
    local s = tostring(math.floor(n or 0))
    local k
    while true do
        s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1 %2")
        if k == 0 then break end
    end
    return s
end

local function loadModel(name)
    local hash = type(name) == 'number' and name or GetHashKey(name)
    if not IsModelInCdimage(hash) then return false end
    RequestModel(hash)
    local t = GetGameTimer() + 10000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(0) end
    return HasModelLoaded(hash) and hash or false
end

local function clearPreview()
    if PreviewVeh and DoesEntityExist(PreviewVeh) then
        SetEntityAsMissionEntity(PreviewVeh, true, true)
        DeleteEntity(PreviewVeh)
    end
    PreviewVeh = nil
end

local function warpIntoPreview()
    if not PreviewVeh or not DoesEntityExist(PreviewVeh) then return end
    local ped = PlayerPedId()
    if not savedPos then
        savedPos = GetEntityCoords(ped)
        savedHeading = GetEntityHeading(ped)
    end
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
    SetEntityInvincible(ped, true)
    TaskWarpPedIntoVehicle(ped, PreviewVeh, -1)
end

local function restorePlayer()
    local ped = PlayerPedId()
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    SetEntityInvincible(ped, false)
    ClearPedTasksImmediately(ped)
    if savedPos then
        SetEntityCoordsNoOffset(ped, savedPos.x, savedPos.y, savedPos.z, false, false, false)
        if savedHeading then SetEntityHeading(ped, savedHeading) end
    end
    savedPos, savedHeading = nil, nil
end

local function spawnPreview(shop, model)
    clearPreview()
    local hash = loadModel(model)
    if not hash then return end
    local pos = shop.preview
    local veh = CreateVehicle(hash, pos.x, pos.y, pos.z, pos.w, false, false)
    if not veh or veh == 0 then return end
    SetEntityHeading(veh, pos.w)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleDoorsLocked(veh, 2)
    SetEntityInvincible(veh, true)
    SetVehicleStrong(veh, true)
    SetEntityCollision(veh, false, false)
    FreezeEntityPosition(veh, true)
    SetVehicleOnGroundProperly(veh)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleEngineOn(veh, false, true, false)
    PreviewVeh = veh
    if inConcess then warpIntoPreview() end
end

-- Le detecteur "changement de vehicule" d'antisbire (client/main.lua, event
-- SUNAC:SetVehiclePreview) kick au 3e handle de vehicule different en 10 s.
-- Ici chaque survol du catalogue recree le vehicule de preview et y re-warp
-- le joueur : il faut se declarer comme preview pendant toute la session.
local PREVIEW_SOURCE = 'sunlife_autoconcess'

local function setPreviewExempt(state)
    TriggerEvent('SUNAC:SetVehiclePreview', PREVIEW_SOURCE, state == true)
end

local function openRageMenu(shop, items)
    ActiveShop = shop
    inConcess = true
    setPreviewExempt(true)
    if RMenu:Get('kx_concess', 'main') then RMenu:Delete('kx_concess', 'main') end
    RMenu.Add('kx_concess', 'main', RageUI.CreateMenu(shop.title or 'Concession', 'Catalogue', 1, 100))
    RMenu:Get('kx_concess', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('kx_concess', 'main'):SetPosition(1340, 200)
    local displayed
    if items[1] and items[1].model then
        spawnPreview(shop, items[1].model)
        displayed = items[1].model
    end
    RageUI.Visible(RMenu:Get('kx_concess', 'main'), true)
    CreateThread(function()
        while inConcess do
            RageUI.IsVisible(RMenu:Get('kx_concess', 'main'), true, false, true, function()
                for i=1, #items do
                    local it = items[i]
                    RageUI.ButtonWithStyle(it.name, nil, {RightLabel = ('$%s'):format(fmt(it.price))}, true, function(Hovered, Active, Selected)
                        if Active and displayed ~= it.model then
                            spawnPreview(shop, it.model)
                            displayed = it.model
                        end
                        if Selected then
                            TriggerServerEvent('kx_concess:buy', it.uid)
                        end
                    end)
                end
            end)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 71, true)
            DisableControlAction(0, 72, true)
            DisableControlAction(0, 59, true)
            DisableControlAction(0, 60, true)
            if not RageUI.Visible(RMenu:Get('kx_concess', 'main')) then
                inConcess = false
                RMenu:Delete('kx_concess', 'main')
                restorePlayer()
                clearPreview()
                ActiveShop = nil
                -- Le detecteur re-scrute des la levee de l'exemption ; le ped
                -- est deja hors du vehicule ici, donc pas de swap comptabilise.
                setPreviewExempt(false)
            end
            Wait(0)
        end
    end)
end

local function requestCatalog(shop)
    ESX.TriggerServerCallback('kx_concess:getCatalog', function(items)
        if not items or #items == 0 then
            ESX.ShowNotification('Aucun véhicule disponible.')
            return
        end
        openRageMenu(shop, items)
    end)
end

CreateThread(function()
    while true do
        local wait = 750
        local ped = PlayerPedId()
        local p = GetEntityCoords(ped)
        local farDist = AutoConcess.MarkerFarDistance or 90.0

        for _, shop in ipairs(AutoConcess.Shops) do
            local dist = #(p - shop.open)
            if dist < farDist then
                wait = 0
                DrawMarker(23, shop.open.x - 0.95, shop.open.y, shop.open.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 2.5, 255, 106, 0, 100, false, false)
            end
            if dist < 20.0 then
                wait = 0
                SetTextComponentFormat('STRING')
                AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir ' .. (shop.title or 'la concession'))
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustReleased(0, AutoConcess.OpenKey) then
                    requestCatalog(shop)
                end
            end
        end

        Wait(wait)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    restorePlayer()
    clearPreview()
    setPreviewExempt(false)
    if RMenu and RMenu:Get('kx_concess', 'main') then RMenu:Delete('kx_concess', 'main') end
    for _, b in ipairs(Blips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    Blips = {}
end)

RegisterNetEvent('kx_concess:purchaseResult', function(ok, msg)
    if msg and ESX then ESX.ShowNotification(msg) end
end)
