ESX = ESX or nil

local EnServiceLivreur = false
local MenuLivreur = false
local livraisonBlips = {}
local mission = nil
local missionBlip = nil
local missionVeh = 0
local lastSelect = 0

Config = Config or {}
Config.livreur = {
    boss = vector3(1197.2618408203, -3253.4807128906, 6.0951819419861),
    vehicle = 'speedo',
    spawnPoints = {
        { pos = vector3(1190.8026123047, -3245.9379882812, 6.0287637710571), heading = 89.879386901855 },
        { pos = vector3(1191.0289306641, -3242.7468261719, 6.0287637710571), heading = 89.879386901855 },
        { pos = vector3(1191.0522460938, -3239.759765625, 6.0287637710571), heading = 89.879386901855 },
    },
    deliveries = {},
    blipBoss = { sprite=477, color=46, scale=0.8, name="Livreur" },
}

local extraDeliveryCoords = {
    vector3(-616.48260498047, -776.07092285156, 25.268135070801),
    vector3(-647.47607421875, -414.47421264648, 34.767135620117),
    vector3(-702.85186767578, -192.97332763672, 36.785579681396),
    vector3(-537.02203369141, -41.407482147217, 42.712230682373),
    vector3(-422.29974365234, -32.481029510498, 46.226070404053),
    vector3(-23.507713317871, -229.33460998535, 46.176525115967),
    vector3(380.0002746582, -738.86505126953, 29.292659759521),
    vector3(-591.51263427734, -670.58477783203, 32.252788543701),
    vector3(-1236.0639648438, -1065.4853515625, 8.3368234634399),
    vector3(-1129.7581787109, -1436.2336425781, 4.9498085975647),
    vector3(-1110.107421875, -1476.2622070312, 4.9037885665894),
    vector3(-1097.8572998047, -1576.7537841797, 4.3790345191956),
    vector3(-1023.8110961914, -1520.8546142578, 5.595965385437),
    vector3(-344.26354980469, -1495.7410888672, 30.757219314575),
    vector3(248.94750976562, -1716.0805664062, 29.126781463623),
    vector3(774.52874755859, -1329.7937011719, 26.243274688721),
    vector3(-138.07559204102, 196.5754699707, 90.046409606934),
    vector3(390.25039672852, 112.70665740967, 102.09073638916),
    vector3(-74.843330383301, 209.90322875977, 96.489585876465),
    vector3(-38.75577545166, -67.256988525391, 59.166896820068),
}

for i, coord in ipairs(extraDeliveryCoords) do
    table.insert(Config.livreur.deliveries, {
        id = #Config.livreur.deliveries + 1,
        label = ("Livraison supplémentaire #%d"):format(i),
        dest = coord,
        payout = 300
    })
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    RMenu.Add('livreur', 'main', RageUI.CreateMenu("SunLife", "Livreur", 1, 100))
    RMenu.Add('livreur', 'list', RageUI.CreateSubMenu(RMenu:Get('livreur','main'), "SunLife", "Livraisons"))
    RMenu:Get('livreur', 'main'):SetRectangleBanner(255, 106, 0,140)
    RMenu:Get('livreur', 'list'):SetRectangleBanner(255, 106, 0,140)
    RMenu:Get('livreur', 'main').EnableMouse = false
    RMenu:Get('livreur', 'list').EnableMouse = false
    RMenu:Get('livreur', 'main').Closed = function() MenuLivreur = false end
    RMenu:Get('livreur', 'list').Closed = function() end
end)

local function AddBossBlip()
    local p = Config.livreur.boss
    local blip = AddBlipForCoord(p)
    SetBlipSprite(blip, Config.livreur.blipBoss.sprite)
    SetBlipScale(blip,  Config.livreur.blipBoss.scale)
    SetBlipColour(blip, Config.livreur.blipBoss.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.livreur.blipBoss.name)
    EndTextCommandSetBlipName(blip)
    table.insert(livraisonBlips, blip)
end
AddBossBlip()

JobsPackSpawnBossPed(Config.livreur.boss, 96.23, `s_m_m_postal_01`, "WORLD_HUMAN_CLIPBOARD")

local function LoadModel(model)
    local hash = (type(model) == 'number') and model or GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local i=0
        while not HasModelLoaded(hash) and i<1000 do Citizen.Wait(10); i=i+1 end
    end
    return HasModelLoaded(hash) and hash or nil
end

local function GetFreeSpawn()
    for _,sp in ipairs(Config.livreur.spawnPoints) do
        if not IsAnyVehicleNearPoint(sp.pos.x, sp.pos.y, sp.pos.z, 2.5) then
            return sp
        end
    end
    return nil
end

local function SafeDelVeh(veh)
    if veh ~= 0 and DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
end

local function CleanupLivreur(full)
    if missionBlip and DoesBlipExist(missionBlip) then
        RemoveBlip(missionBlip)
    end
    missionBlip = nil
    mission = nil
    if full and missionVeh ~= 0 then
        SafeDelVeh(missionVeh)
        missionVeh = 0
    end
end

local function StopService(closeMenu)
    EnServiceLivreur = false
    CleanupLivreur(true)
    if closeMenu then RageUI.CloseAll(); MenuLivreur=false end
    ESX.ShowNotification("~g~Fin de service Livreur.")
end

local function openLivreurMenu()
    local coords = GetEntityCoords(PlayerPedId())
    if MenuLivreur then MenuLivreur=false return end
    MenuLivreur=true
    RageUI.Visible(RMenu:Get('livreur','main'), true)

    Citizen.CreateThread(function()
        while MenuLivreur do

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                MenuLivreur = false
            end

            RageUI.IsVisible(RMenu:Get('livreur','main'), true, true, true, function()
                RageUI.ButtonWithStyle(
                    EnServiceLivreur and "~g~En service" or "Prendre son service",
                    "", {RightLabel="→"}, true,
                    function(_,_,Selected)
                        if Selected and not EnServiceLivreur then
                            EnServiceLivreur = true
                            ESX.ShowNotification("~g~Service Livreur commencé !")
                            SetNewWaypoint(Config.livreur.boss.x, Config.livreur.boss.y)
                        end
                    end
                )

                RageUI.ButtonWithStyle("Livraisons disponibles", "", {RightLabel="→"}, EnServiceLivreur, function() end, RMenu:Get('livreur','list'))

                RageUI.ButtonWithStyle("Fin de service", "", {RightLabel="→"}, true, function(_,_,Selected)
                    if Selected then StopService(true) end
                end)
            end)

            RageUI.IsVisible(RMenu:Get('livreur','list'), true, true, true, function()
                if mission then
                    RageUI.Separator(("Mission en cours: ~y~%s~s~ ($%d)"):format(mission.label, mission.payout))
                else
                    RageUI.Separator("Choisissez une mission :")
                    for _,d in ipairs(Config.livreur.deliveries) do
                        RageUI.ButtonWithStyle(("• %s"):format(d.label), ("Rémunération: ~g~$%d"):format(d.payout),
                            {RightLabel="Accepter"}, true, function(_,Active,Selected)
                                if Selected then
                                    if GetGameTimer() - lastSelect < 1200 then return end
                                    lastSelect = GetGameTimer()

                                    if missionVeh == 0 or not DoesEntityExist(missionVeh) then
                                        local sp = GetFreeSpawn()
                                        if not sp then
                                            ESX.ShowNotification("~r~Aucune place de spawn disponible.")
                                            return
                                        end
                                        local mdl = LoadModel(Config.livreur.vehicle)
                                        if not mdl then ESX.ShowNotification("~r~Impossible de charger le véhicule."); return end
                                        TriggerServerEvent('eye:veh:authorize', mdl, 'job')
                                        print(('^5[NETDIAG][VEHICLE]^7 %s cl_livreur.lua:204 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(mdl)))
                                        missionVeh = CreateVehicle(mdl, sp.pos.x, sp.pos.y, sp.pos.z, sp.heading, true, false)
                                        SetEntityAsMissionEntity(missionVeh, true, true)
                                        SetVehicleOnGroundProperly(missionVeh)
                                        SetVehicleNumberPlateText(missionVeh, "LIVR"..math.random(100,999))
                                        SetVehicleDoorsLocked(missionVeh, 1)

                                        TaskWarpPedIntoVehicle(PlayerPedId(), missionVeh, -1)
                                    end

                                    mission = { id=d.id, label=d.label, dest=d.dest, payout=d.payout }

                                    if missionBlip and DoesBlipExist(missionBlip) then RemoveBlip(missionBlip) end
                                    missionBlip = AddBlipForCoord(d.dest)
                                    SetBlipSprite(missionBlip, 280)
                                    SetBlipScale(missionBlip, 0.8)
                                    SetBlipColour(missionBlip, 2)
                                    SetBlipRoute(missionBlip, true)
                                    BeginTextCommandSetBlipName('STRING')
                                    AddTextComponentSubstringPlayerName(("Livraison: %s"):format(d.label))
                                    EndTextCommandSetBlipName(missionBlip)
                                    SetNewWaypoint(d.dest.x, d.dest.y)

                                    TriggerServerEvent('livreur:startMission', d.id)

                                    ESX.ShowNotification(("📦 Mission acceptée: ~y~%s~s~ • Rendez-vous au point de livraison."):format(d.label))
                                    RageUI.GoBack()
                                end
                        end)
                    end
                end
            end)
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    local p = Config.livreur.boss
    while true do
        local near=false
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local d = #(pc - p)

        if d <= 2.0 then
            near=true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au responsable Livreur")
            if IsControlJustPressed(1,51) and not MenuLivreur then
                openLivreurMenu()
            end
        end
        Citizen.Wait(near and 0 or 500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if EnServiceLivreur and mission then
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            local d = #(pc - mission.dest)
            if d <= 30.0 then
                DrawMarker(20, mission.dest.x, mission.dest.y, mission.dest.z+1.0,
                    0,0,0, 0,0,0, 0.7,0.7,0.7, 0,180,60,180, 0,0,2,1,nil,nil,0)

                local inVeh = GetVehiclePedIsIn(ped, false)
                local okVeh = (inVeh ~= 0 and DoesEntityExist(missionVeh) and inVeh == missionVeh)

                if d <= 3.5 then
                    ESX.ShowHelpNotification(okVeh and "Appuyez sur ~b~E~w~ pour livrer" or "~r~Montez dans le van de livraison")
                    if okVeh and IsControlJustPressed(1,51) then

                        TriggerServerEvent('livreur:completeMission', mission.id)
                        ESX.ShowNotification(("~g~Livraison '%s' effectuée !"):format(mission.label))

                        if missionBlip and DoesBlipExist(missionBlip) then RemoveBlip(missionBlip) end
                        missionBlip=nil
                        mission=nil
                        Citizen.Wait(500)
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(600)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        CleanupLivreur(true)
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    if EnServiceLivreur then

        CleanupLivreur(false)
    end
end)
