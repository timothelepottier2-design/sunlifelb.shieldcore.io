local activeMission = nil
local missionBlip = nil
local missionBoat = nil
local menuOpen = false

local function findMission(id)
    for i = 1, #cfg_gofast_mer.missions do
        if cfg_gofast_mer.missions[i].id == id then
            return cfg_gofast_mer.missions[i]
        end
    end
    return nil
end

local function clearMissionState()
    activeMission = nil

    if missionBlip and DoesBlipExist(missionBlip) then
        RemoveBlip(missionBlip)
    end
    missionBlip = nil

    RemoveTimerBar()
end

local npcPed = nil

CreateThread(function()
    local model = GetHashKey(cfg_gofast_mer.npc.model)
    RequestModel(model)

    local timeoutAt = GetGameTimer() + 10000
    while not HasModelLoaded(model) and GetGameTimer() < timeoutAt do
        Wait(50)
    end
    if not HasModelLoaded(model) then return end

    local p = cfg_gofast_mer.npc.pos
    npcPed = CreatePed(4, model, p.x, p.y, p.z - 0.1, cfg_gofast_mer.npc.heading, false, true)
    SetEntityCoordsNoOffset(npcPed, p.x, p.y, p.z - 0.1, false, false, false)
    SetEntityHeading(npcPed, cfg_gofast_mer.npc.heading)
    SetEntityInvincible(npcPed, true)
    FreezeEntityPosition(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    SetPedCanRagdoll(npcPed, false)
    SetPedCanBeTargetted(npcPed, false)
    SetEntityCanBeDamaged(npcPed, false)
    TaskStartScenarioInPlace(npcPed, cfg_gofast_mer.npc.scenario, 0, true)

    SetModelAsNoLongerNeeded(model)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if npcPed and DoesEntityExist(npcPed) then
        DeleteEntity(npcPed)
    end
    clearMissionState()
end)

CreateThread(function()
    while ESX == nil do
        Wait(100)
    end

    RMenu.Add('gofastmer', 'main', RageUI.CreateMenu("SunLife", "Livraisons maritimes", 1, 100))
    RMenu:Get('gofastmer', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('gofastmer', 'main').EnableMouse = false
    RMenu:Get('gofastmer', 'main').Closed = function()
        menuOpen = false
    end
end)

local function openMenu()
    if menuOpen then return end
    menuOpen = true
    RageUI.Visible(RMenu:Get('gofastmer', 'main'), true)

    CreateThread(function()
        while menuOpen do
            RageUI.IsVisible(RMenu:Get('gofastmer', 'main'), true, true, true, function()
                for i = 1, #cfg_gofast_mer.missions do
                    local m = cfg_gofast_mer.missions[i]

                    local right = ("~o~≈ %s$"):format(ESX.Math.GroupDigits(m.rewardMin))
                    RageUI.ButtonWithStyle(m.label, ("Livraison à %s."):format(m.label), { RightLabel = right }, true, function(_, _, Selected)
                        if Selected then

                            TriggerServerEvent('gofastmer:request', m.id)
                            RageUI.CloseAll()
                            menuOpen = false
                        end
                    end)
                end
            end, function()
            end)

            Wait(0)
        end
    end)
end

CreateThread(function()
    lib.points.new({
        coords = cfg_gofast_mer.npc.pos,
        distance = 10,
        nearby = function(self)

            if ESX == nil or self.currentDistance > 2.0 then return end
            if activeMission then
                ESX.ShowHelpNotification("Vous avez déjà une livraison en cours")
                return
            end
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour prendre une ~o~livraison maritime")
            if IsControlJustPressed(0, 38) and not menuOpen then
                openMenu()
            end
        end
    })
end)

RegisterNetEvent('gofastmer:accepted', function(missionId)
    local mission = findMission(missionId)
    if not mission or activeMission then return end

    local model = GetHashKey(cfg_gofast_mer.boat.model)
    RequestModel(model)

    local timeoutAt = GetGameTimer() + 10000
    while not HasModelLoaded(model) and GetGameTimer() < timeoutAt do
        Wait(50)
    end
    if not HasModelLoaded(model) then
        ESX.ShowNotification("~r~Impossible de charger le bateau.")
        TriggerServerEvent('gofastmer:abort')
        return
    end

    local b = cfg_gofast_mer.boat
    missionBoat = CreateVehicle(model, b.pos.x, b.pos.y, b.pos.z, b.heading, true, false)
    SetModelAsNoLongerNeeded(model)

    if not missionBoat or missionBoat == 0 then
        ESX.ShowNotification("~r~Impossible de faire apparaître le bateau.")
        TriggerServerEvent('gofastmer:abort')
        return
    end

    SetVehicleNumberPlateText(missionBoat, b.plate)
    TaskWarpPedIntoVehicle(PlayerPedId(), missionBoat, -1)

    activeMission = mission

    missionBlip = AddBlipForCoord(mission.pos.x, mission.pos.y, mission.pos.z)
    SetBlipSprite(missionBlip, 427)
    SetBlipColour(missionBlip, 47)
    SetBlipScale(missionBlip, 0.9)
    SetBlipAsShortRange(missionBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Livraison — " .. mission.label)
    EndTextCommandSetBlipName(missionBlip)
    SetBlipRoute(missionBlip, true)
    PulseBlip(missionBlip)

    AddTimerBar("Livraison", { endTime = GetGameTimer() + cfg_gofast_mer.missionTimeoutMs })

    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast maritime", ("Direction ~o~%s~s~. Ne coule pas la marchandise."):format(mission.label), "CHAR_MP_GERALD", 8)

    CreateThread(function()
        while activeMission do
            Wait(500)

            local target = activeMission
            if not target then break end

            local ped = PlayerPedId()
            if #(GetEntityCoords(ped) - target.pos) <= 6.0 then
                local veh = GetVehiclePedIsIn(ped, false)
                if veh ~= 0 and veh == missionBoat then

                    TriggerServerEvent('gofastmer:deliver')
                    Wait(2000)
                else
                    ESX.ShowHelpNotification("Vous devez arriver ~o~à bord du bateau")
                end
            end
        end
    end)
end)

RegisterNetEvent('gofastmer:done', function(reward)
    local boat = missionBoat
    clearMissionState()
    missionBoat = nil

    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast maritime", ("Beau boulot. ~o~%s$~s~ d'argent sale."):format(ESX.Math.GroupDigits(reward)), "CHAR_MP_GERALD", 8)

    if boat and DoesEntityExist(boat) then
        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(boat))
    end
end)

RegisterNetEvent('gofastmer:failed', function(reason)
    clearMissionState()
    missionBoat = nil
    if reason then
        ESX.ShowNotification(reason)
    end
end)
