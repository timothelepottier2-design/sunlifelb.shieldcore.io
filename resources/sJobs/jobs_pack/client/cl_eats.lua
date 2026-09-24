ESX = ESX or nil

local EnServicePizza = false
local MenuPizza = false
local pizzaBlips = {}
local bossBlip = nil

local scoot = 0
local currentIdx = nil
local lastIdx = nil
local targetBlip = nil
local lastAction = 0

Config = Config or {}
Config.pizza = {
    boss = vector3(-296.32568359375, -1342.5970458984, 30.300100326538),
    scooter = 'faggio2',
    spawnPoints = {
        { pos = vector3(-290.92163085938, -1345.0516357422, 31.22286605835), heading = 194.87692260742 },
    },

    deliveries = Config.pizzaDeliveries or {},
    blipBoss = { sprite=120, color=1, scale=0.7, name="SunLifeEATS" },
    arriveRadius = 65.0,

    interactRadius = 15.0,
    mustBeOnScooter = true,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    RMenu.Add('pizza', 'main', RageUI.CreateMenu("SunLife", "Livreur de pizza", 1, 100))
    RMenu:Get('pizza','main'):SetRectangleBanner(255, 106, 0,140)
    RMenu:Get('pizza','main').EnableMouse = false
    RMenu:Get('pizza','main').Closed = function() MenuPizza=false end

    local p = Config.pizza.boss
    bossBlip = AddBlipForCoord(p)
    SetBlipSprite(bossBlip, Config.pizza.blipBoss.sprite)
    SetBlipScale(bossBlip,  Config.pizza.blipBoss.scale)
    SetBlipColour(bossBlip, Config.pizza.blipBoss.color)
    SetBlipAsShortRange(bossBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.pizza.blipBoss.name)
    EndTextCommandSetBlipName(bossBlip)

    JobsPackSpawnBossPed(Config.pizza.boss, 274.02, `s_m_m_linecook`, "WORLD_HUMAN_CLIPBOARD")
end)

local function LoadModel(model)
    local hash = (type(model)=='number') and model or GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local i=0
        while not HasModelLoaded(hash) and i<1000 do Citizen.Wait(10) i=i+1 end
    end
    return HasModelLoaded(hash) and hash or nil
end

local function SafeDelVeh(veh)
    if veh ~= 0 and DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
        if DoesEntityExist(veh) then DeleteEntity(veh) end
    end
end

local function GetFreeSpawn()
    for _,sp in ipairs(Config.pizza.spawnPoints) do
        if not IsAnyVehicleNearPoint(sp.pos.x, sp.pos.y, sp.pos.z, 2.0) then
            return sp
        end
    end
    return nil
end

local function CleanupPizza(full)
    if targetBlip and DoesBlipExist(targetBlip) then RemoveBlip(targetBlip) end
    targetBlip = nil
    currentIdx = nil
    if full and scoot ~= 0 then
        SafeDelVeh(scoot)
        scoot = 0
    end
end

local function SpawnScooterIfNeeded()
    if scoot ~= 0 and DoesEntityExist(scoot) then return true end
    local sp = GetFreeSpawn()
    if not sp then
        ESX.ShowNotification("~r~Aucune place de spawn dispo.")
        return false
    end
    local mdl = LoadModel(Config.pizza.scooter)
    if not mdl then
        ESX.ShowNotification("~r~Impossible de charger le scooter.")
        return false
    end
    TriggerServerEvent('eye:veh:authorize', mdl, 'job')
    print(('^5[NETDIAG][VEHICLE]^7 %s cl_eats.lua:121 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(mdl)))
    scoot = CreateVehicle(mdl, sp.pos.x, sp.pos.y, sp.pos.z, sp.heading, true, false)
    SetEntityAsMissionEntity(scoot, true, true)
    SetVehicleOnGroundProperly(scoot)
    SetVehicleNumberPlateText(scoot, "PIZ"..math.random(100,999))
    SetVehicleDoorsLocked(scoot, 1)
    TaskWarpPedIntoVehicle(PlayerPedId(), scoot, -1)
    return true
end

local function PickRandomIndex()
    if #Config.pizza.deliveries == 0 then return nil end
    local idx
    if #Config.pizza.deliveries == 1 then
        idx = 1
    else
        repeat
            idx = math.random(1, #Config.pizza.deliveries)
        until idx ~= lastIdx
    end
    lastIdx = idx
    return idx
end

local _deliveryLabels = {}
local function DeliveryLabel(idx, d)
    local cached = _deliveryLabels[idx]
    if cached then return cached end

    local label
    local streetHash = GetStreetNameAtCoord(d.x, d.y, d.z)
    if streetHash and streetHash ~= 0 then
        local street = GetStreetNameFromHashKey(streetHash)
        if street and street ~= '' and street ~= 'NULL' then
            label = street
        end
    end

    local zone = GetLabelText(GetNameOfZone(d.x, d.y, d.z))
    if zone and zone ~= '' and zone ~= 'NULL' then
        label = label and (zone .. " - " .. label) or zone
    end

    label = label or ("Point #" .. idx)
    _deliveryLabels[idx] = label
    return label
end

local function SetDeliveryBlip(idx)
    local d = Config.pizza.deliveries[idx]
    if targetBlip and DoesBlipExist(targetBlip) then RemoveBlip(targetBlip) end
    targetBlip = AddBlipForCoord(d.x, d.y, d.z)
    SetBlipSprite(targetBlip, 280)
    SetBlipScale(targetBlip, 0.8)
    SetBlipColour(targetBlip, 1)
    SetBlipRoute(targetBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(("Livraison: %s"):format(DeliveryLabel(idx, d)))
    EndTextCommandSetBlipName(targetBlip)
    SetNewWaypoint(d.x, d.y)
end

local function NextDelivery()
    if not EnServicePizza then return end
    if scoot == 0 or not DoesEntityExist(scoot) then
        ESX.ShowNotification("~r~Sortez d'abord votre scooter.")
        return
    end

    local idx = PickRandomIndex()
    if not idx then
        ESX.ShowNotification("~r~Aucune destination dispo.")
        return
    end
    currentIdx = idx
    SetDeliveryBlip(idx)

    TriggerServerEvent('pizza:setMission', idx)
    ESX.ShowNotification("📍 Nouvelle livraison assignée. Suivez le GPS.")
end

local function OpenPizzaMenu()
    if MenuPizza then MenuPizza=false return end
    MenuPizza=true
    RageUI.Visible(RMenu:Get('pizza','main'), true)

    Citizen.CreateThread(function()
        while MenuPizza do
            RageUI.IsVisible(RMenu:Get('pizza','main'), true, true, true, function()

                RageUI.ButtonWithStyle(
                    EnServicePizza and "~g~En service" or "Prendre son service",
                    "", {RightLabel="→"}, true,
                    function(_,_,Selected)
                        if Selected and not EnServicePizza then
                            EnServicePizza = true
                            ESX.ShowNotification("~g~Service pizza commencé !")

                        end
                    end
                )

                RageUI.ButtonWithStyle("Sortir le scooter", "Faggio livré par le patron.",
                    {RightLabel="→"}, EnServicePizza, function(_,_,Selected)
                        if Selected then
                            if SpawnScooterIfNeeded() then
                                if not currentIdx then NextDelivery() end
                            end
                        end
                    end
                )

                RageUI.ButtonWithStyle("Nouvelle livraison", "Assigne une destination aléatoire.",
                    {RightLabel="→"}, EnServicePizza, function(_,_,Selected)
                        if Selected then
                            NextDelivery()
                        end
                    end
                )

                RageUI.ButtonWithStyle("Fin de service", "", {RightLabel="→"}, true, function(_,_,Selected)
                    if Selected then
                        EnServicePizza = false
                        CleanupPizza(true)
                        ESX.ShowNotification("~g~Fin de service pizza.")
                        RageUI.CloseAll()
                        MenuPizza=false
                    end
                end)
            end)

            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    local p = Config.pizza.boss
    while true do
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local d = #(pc - p)
        local near=false

        if d <= 2.0 then
            near=true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au patron pizza")
            if IsControlJustPressed(1,51) and not MenuPizza then
                OpenPizzaMenu()
            end
        end

        Citizen.Wait(near and 0 or 500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if EnServicePizza and currentIdx then
            local ped = PlayerPedId()
            local d = Config.pizza.deliveries[currentIdx]
            local my = GetEntityCoords(ped)
            local dist = #(my - vector3(d.x,d.y,d.z))

            if dist <= Config.pizza.arriveRadius then
                DrawMarker(20, d.x, d.y, d.z+1.0, 0,0,0, 0,0,0, 0.7,0.7,0.7, 255,140,0,180, 0,0,2,1,nil,nil,0)
                if dist <= Config.pizza.interactRadius then
                    local okVeh = true
                    if Config.pizza.mustBeOnScooter then
                        local veh = GetVehiclePedIsIn(ped, false)
                        okVeh = (veh ~= 0 and DoesEntityExist(scoot) and veh == scoot)
                    end

                    ESX.ShowHelpNotification(okVeh and "Appuyez sur ~b~E~w~ pour livrer la pizza" or "~r~Rejoignez le point avec votre scooter")
                    if okVeh and IsControlJustPressed(1,51) and (GetGameTimer()-lastAction>1000) then
                        lastAction = GetGameTimer()

                        TriggerServerEvent('pizza:complete', currentIdx)

                    end
                end
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(600)
        end
    end
end)

RegisterNetEvent('pizza:confirmed', function()

    if targetBlip and DoesBlipExist(targetBlip) then RemoveBlip(targetBlip) end
    targetBlip=nil
    currentIdx=nil

    Citizen.SetTimeout(500, function()
        if EnServicePizza then NextDelivery() end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        CleanupPizza(true)
        if bossBlip and DoesBlipExist(bossBlip) then RemoveBlip(bossBlip) end
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    if EnServicePizza then

        if targetBlip and DoesBlipExist(targetBlip) then RemoveBlip(targetBlip) end
        targetBlip=nil
        currentIdx=nil
    end
end)
