local ESX
local previewEntities = {}
local previewCam      = nil
local lastPreviewIdx  = nil
local menuActive      = false
local menuLoopRunning = false
local selectedHash    = nil
local pedEntity       = nil
local vipBlip         = nil

CreateThread(function()
    local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
    if ok and obj then ESX = obj end
    while not ESX do
        TriggerEvent('esx:getShtozaredObjtozect', function(o) ESX = o end)
        Wait(0)
    end
end)

local function stopShowroomCamera()
    if previewCam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(previewCam, false)
        previewCam = nil
    end
end

local function startShowroomCamera()
    if previewCam then return end
    local c  = VipDealer.previewCam.coords
    local sc = VipDealer.showroom.coords
    previewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(previewCam, c.x, c.y, c.z)
    PointCamAtCoord(previewCam, sc.x, sc.y, sc.z + 0.35)
    SetCamFov(previewCam, 48.0)
    SetCamActive(previewCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function pointCameraAtPreviewVehicle(vehicle)
    if not previewCam or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    PointCamAtEntity(previewCam, vehicle, 0.0, 0.0, 0.25, true)
end

local function deletePreviewList()
    for _, veh in pairs(previewEntities) do
        if veh and DoesEntityExist(veh) and ESX and ESX.Game then
            ESX.Game.DeleteVehicle(veh)
        end
    end
    previewEntities = {}
end

local function clearPreviewVehicles()
    deletePreviewList()
end

local function showPreviewVehicle(modelName)
    if not ESX or not ESX.Game then return end
    CreateThread(function()
        local hash = GetHashKey(modelName)
        deletePreviewList()

        local sc = VipDealer.showroom.coords
        ESX.Game.SpawnLocalVehicle(
            hash,
            { x = sc.x, y = sc.y, z = sc.z },
            VipDealer.showroom.heading,
            function(vehicle)
                table.insert(previewEntities, vehicle)
                FreezeEntityPosition(vehicle, true)
                SetVehicleUndriveable(vehicle, true)
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleDirtLevel(vehicle, 0.0)
                SetVehicleNumberPlateText(vehicle, 'SHOW VIP')
                SetModelAsNoLongerNeeded(hash)
                pointCameraAtPreviewVehicle(vehicle)
            end
        )
    end)
end

local function spawnDealerPed()
    local cfg   = VipDealer.ped
    local model = GetHashKey(cfg.model)
    RequestModel(model)
    local t = GetGameTimer()
    while not HasModelLoaded(model) do
        Wait(10)
        if GetGameTimer() - t > 10000 then return end
    end

    pedEntity = CreatePed(4, model, cfg.coords.x, cfg.coords.y, cfg.coords.z - 1.0, cfg.heading, false, true)
    SetEntityAsMissionEntity(pedEntity, true, true)
    FreezeEntityPosition(pedEntity, true)
    SetEntityInvincible(pedEntity, true)
    SetBlockingOfNonTemporaryEvents(pedEntity, true)
    TaskStartScenarioInPlace(pedEntity, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    SetModelAsNoLongerNeeded(model)
end

local function createVipBlip()
    local cfg = VipDealer.ped.coords
    local ui  = VipDealer.UI
    vipBlip = AddBlipForCoord(cfg.x, cfg.y, cfg.z)
    SetBlipSprite(vipBlip, ui.blipSprite or 326)
    SetBlipColour(vipBlip, ui.blipColour or 47)
    SetBlipScale(vipBlip, ui.blipScale or 0.85)
    SetBlipAsShortRange(vipBlip, true)

    local key = 'BN_SUNLIFE_VIPDEALER_1'
    AddTextEntry(key, ui.blipName or 'Concessionnaire VIP')
    BeginTextCommandSetBlipName(key)
    EndTextCommandSetBlipName(vipBlip)
end

local function vipRankLabel(required)
    if required == 'gold'      then return 'VIP Gold'      end
    if required == 'diamond'   then return 'VIP Diamond'   end
    if required == 'platinium' then return 'VIP Platinium' end
    if required == 'legendary' then return 'VIP Legendary' end
    return required or ''
end

local function setupMenus()
    local ui = VipDealer.UI
    if RMenu:Get('vipdealer', 'main') then RMenu:Delete('vipdealer', 'main') end
    if RMenu:Get('vipdealer', 'buy')  then RMenu:Delete('vipdealer', 'buy')  end

    RMenu.Add('vipdealer', 'main', RageUI.CreateMenu(ui.title or 'SUNLIFE', ui.subtitle or 'Concessionnaire VIP', 1, 100))
    RMenu:Get('vipdealer', 'main'):SetRectangleBanner(ui.bannerR, ui.bannerG, ui.bannerB, ui.bannerA or 225)
    RMenu:Get('vipdealer', 'main').EnableMouse = false
    RMenu:Get('vipdealer', 'main').Closed = function()
        menuActive = false
        stopShowroomCamera()
        clearPreviewVehicles()
        lastPreviewIdx = nil
    end

    RMenu.Add('vipdealer', 'buy', RageUI.CreateSubMenu(RMenu:Get('vipdealer', 'main'), ui.title or 'SUNLIFE', 'Achat', 1, 100))
    RMenu:Get('vipdealer', 'buy'):SetRectangleBanner(ui.bannerR, ui.bannerG, ui.bannerB, ui.bannerA or 225)
end

local function openVipDealerMenu()
    if menuActive then
        RageUI.CloseAll()
        menuActive = false
        stopShowroomCamera()
        clearPreviewVehicles()
        lastPreviewIdx = nil
        return
    end

    if menuLoopRunning then return end

    setupMenus()
    menuActive    = true
    selectedHash  = nil
    lastPreviewIdx = nil
    startShowroomCamera()
    RageUI.Visible(RMenu:Get('vipdealer', 'main'), true)

    menuLoopRunning = true
    CreateThread(function()
        while menuActive do
            RageUI.IsVisible(RMenu:Get('vipdealer', 'main'), true, true, true, function()
                RageUI.Separator('Véhicules exclusifs')
                RageUI.Line()

                for i, v in ipairs(VipDealer.vehicles) do
                    local rankSuffix = (v.rank == 'legendary') and '' or ' ou +'
                    RageUI.ButtonWithStyle(
                        firstToUpper(v.name),
                        ('Requis: ~o~%s%s~w~'):format(vipRankLabel(v.rank), rankSuffix),
                        { RightLabel = ESX.Math.GroupDigits(v.price, 2) .. '$' },
                        true,
                        function(Hovered, Active, Selected)
                            if Active or Selected then
                                selectedHash = v.hash
                            end
                            if Active and lastPreviewIdx ~= i then
                                showPreviewVehicle(v.hash)
                                lastPreviewIdx = i
                            end
                        end,
                        RMenu:Get('vipdealer', 'buy')
                    )
                end
            end, function() end)

            RageUI.IsVisible(RMenu:Get('vipdealer', 'buy'), true, true, true, function()
                RageUI.Separator('Modèle: ' .. (selectedHash or '?'))

                RageUI.ButtonWithStyle('Acheter le véhicule', nil, {}, selectedHash ~= nil, function(Hovered, Active, Selected)
                    if Selected and selectedHash then
                        ESX.TriggerServerCallback('sunlife_vipdealer:ifCanBuy', function(canBuy, reason)
                            if not canBuy then
                                if reason == 'money' then
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent.")
                                elseif reason == 'gold' then
                                    ESX.ShowNotification('~r~Vous devez être VIP Gold ou supérieur pour ce véhicule.')
                                elseif reason == 'diamond' then
                                    ESX.ShowNotification('~r~Vous devez être VIP Diamond ou supérieur pour ce véhicule.')
                                elseif reason == 'platinium' then
                                    ESX.ShowNotification('~r~Vous devez être VIP Platinium ou supérieur pour ce véhicule.')
                                elseif reason == 'legendary' then
                                    ESX.ShowNotification('~r~Vous devez être VIP Legendary pour ce véhicule.')
                                else
                                    ESX.ShowNotification('~r~Achat impossible.')
                                end
                                return
                            end

                            local model = GetHashKey(selectedHash)
                            RequestModel(model)
                            local attempts = 0
                            while not HasModelLoaded(model) and attempts < 20 do
                                Wait(250)
                                attempts = attempts + 1
                            end

                            if not HasModelLoaded(model) then
                                ESX.ShowNotification('~r~Erreur de chargement du modèle.')
                                return
                            end

                            ESX.TriggerServerCallback('concess:generatePlate', function(newPlate)
                                if not newPlate or newPlate == '' then
                                    ESX.ShowNotification('~r~Erreur de génération de plaque.')
                                    return
                                end

                                local sp = VipDealer.spawn
                                TriggerServerEvent('eye:veh:authorize', model, 'concess')
                                print(('^5[NETDIAG][VEHICLE]^7 %s client.lua:241 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
                                local vehicle = CreateVehicle(model, sp.coords.x, sp.coords.y, sp.coords.z, sp.heading, true, false)

                                if vehicle and vehicle ~= 0 then
                                    SetVehicleNumberPlateText(vehicle, newPlate)
                                    local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                    actualProps.plate = newPlate
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                                    TriggerServerEvent(
                                        'sunlife_vipdealer:registerVehicle',
                                        actualProps,
                                        GetDisplayNameFromVehicleModel(actualProps.model)
                                    )

                                    RageUI.CloseAll()
                                    menuActive = false
                                    stopShowroomCamera()
                                    clearPreviewVehicles()
                                else
                                    ESX.ShowNotification('~r~Impossible de créer le véhicule.')
                                end
                            end, nil)
                        end, selectedHash)
                    end
                end)
            end, function() end)

            Wait(0)
        end
        menuLoopRunning = false
    end)
end

CreateThread(function()
    while ESX == nil do Wait(100) end
    Wait(500)
    spawnDealerPed()
    createVipBlip()
end)

CreateThread(function()
    while ESX == nil do Wait(100) end

    while true do
        local sleep   = 750
        local ped     = PlayerPedId()
        local p       = GetEntityCoords(ped)
        local npcPos  = VipDealer.ped.coords
        local dist    = #(p - npcPos)
        local ui      = VipDealer.UI

        if dist < (VipDealer.markerDistance or 18.0) then
            sleep = 0
            DrawMarker(
                6,
                npcPos.x, npcPos.y, npcPos.z - 0.65,
                nil, nil, nil,
                -90.0, nil, nil,
                0.5, 0.5, 0.5,
                ui.markerR or 255, ui.markerG or 117, ui.markerB or 31, ui.markerA or 120
            )

            if dist < (VipDealer.interactDistance or 2.4) then
                ESX.ShowHelpNotification('Appuyez sur ~o~[E]~w~ pour le concessionnaire VIP')
                if IsControlJustPressed(0, VipDealer.openKey or 38) then
                    openVipDealerMenu()
                end
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    stopShowroomCamera()
    clearPreviewVehicles()
    if pedEntity and DoesEntityExist(pedEntity) then
        DeleteEntity(pedEntity)
    end
    if vipBlip and DoesBlipExist(vipBlip) then
        RemoveBlip(vipBlip)
    end
end)
