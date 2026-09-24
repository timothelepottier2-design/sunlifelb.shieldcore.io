local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'illtablet', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'illtablet', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('illtablet/' .. name, cb)
end

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end
end)

local _terrPending = {}
local _terrSeq = 0

RegisterNetEvent("snl:terr:rpc:reply")
AddEventHandler("snl:terr:rpc:reply", function(reqId, ...)
    local cb = _terrPending[reqId]
    if not cb then return end
    _terrPending[reqId] = nil
    cb(...)
end)

local function TerrRpc(op, cb, ...)
    _terrSeq = _terrSeq + 1
    local reqId = "ill_terr_" .. _terrSeq
    _terrPending[reqId] = cb or function() end
    TriggerServerEvent("snl:terr:rpc", reqId, op, ...)
end

local function GetTabletMapControlPoints()
    local pts = (TabletMap and TabletMap.ControlPoints) or {}
    local out = {}
    for _, p in ipairs(pts) do
        if type(p.gameX) == "number" and type(p.gameY) == "number" and type(p.px) == "number" and type(p.py) == "number" then
            out[#out + 1] = { gameX = p.gameX, gameY = p.gameY, px = p.px, py = p.py }
        end
    end
    return out
end

local function BuildTabletMapNuiPayload()
    local TM = TabletMap or {}
    local bounds = TM.Bounds or { minX = -4000, maxX = 4000, minY = -4000, maxY = 4000 }
    local imgSize = TM.ImageSize or { width = 2048, height = 2048 }
    return {
        resourceName = GetCurrentResourceName(),
        mapAssetResource = (TM.MapAssetResource and tostring(TM.MapAssetResource)) or "SNL_PolTablet",
        mapBounds = bounds,
        mapImageSize = imgSize,
        mapControlPoints = GetTabletMapControlPoints(),
        mapYFlipped = TM.YFlipped == true,
        mapLinear = TM.Linear ~= false,
        mapSwapXY = TM.SwapXY == true,
    }
end

local isTabletOpen = false
local playerOnQuest = false
local blip = nil
local activityBlip = nil
local currentQuestNPC = nil
local npcEntity = nil

local lastRankingsTime = 0
local lastGroupsTime = 0
local lastMapTime = 0
local lastKothTime = 0
local CALLBACK_COOLDOWN = 5000

local function BuildActivitiesNuiPayload()
    local out = {}
    for _, act in ipairs(TabletActivities or {}) do
        out[#out + 1] = {
            id = act.id,
            name = act.name,
            description = act.description or "",
            image = act.image or "",
        }
    end
    return out
end

local objectsByGroup = {
    [1] = {
        {name = "Batte", price = 65000, sprite = "WEAPON_BAT"},
        {name = "Bouteille cassé", price = 65000, sprite = "WEAPON_BOTTLE"},
        {name = "Poing américain", price = 65000, sprite = "WEAPON_KNUCKLE"},
        {name = "Couteau", price = 65000, sprite = "WEAPON_KNIFE"},
        {name = "Machette", price = 65000, sprite = "WEAPON_MACHETE"},
        {name = "Clé à molette", price = 65000, sprite = "WEAPON_WRENCH"},
        {name = "Queue de billard", price = 65000, sprite = "WEAPON_POOLCUE"},
        {name = "Dague antique", price = 65000, sprite = "WEAPON_DAGGER"},
        {name = "Pied de biche", price = 65000, sprite = "WEAPON_CROWBAR"},
        {name = "Club de golf", price = 65000, sprite = "WEAPON_GOLFCLUB"},
        {name = "Hachette", price = 65000, sprite = "WEAPON_HATCHET"},
        {name = "Crant d'arrêt", price = 65000, sprite = "WEAPON_SWITCHBLADE"},
        {name = "Hache de combat", price = 65000, sprite = "WEAPON_BATTLEAXE"},
        {name = "Marteau", price = 65000, sprite = "WEAPON_HAMMER"},
        {name = "Lampe de poche", price = 65000, sprite = "WEAPON_FLASHLIGHT"},
    },
    [2] = {
        {name = "Traqueur", price = 100000, sprite = "traqueur"},
        {name = "Lockpick", price = 7000, sprite = "lockpick"},
        {name = "Sac poubelle", price = 5000, sprite = "sacp"},
        {name = "Flashlight", price = 5000, sprite = "flashlight"},
        {name = "Poigné", price = 16000, sprite = "grip"},
        {name = "Jumelles", price = 20000, sprite = "jumelles"},
        {name = "Silencieux", price = 40000, sprite = "silencieux"},
        {name = "Pince Fleeca", price = 75000, sprite = "bankfleeca"},
        {name = "Clé Musée", price = 30000, sprite = "keymuseum"},
        {name = "Clé Bobcat", price = 1500000, sprite = "bankbobcat"},
        {name = "Clé Banque Pacific", price = 350000, sprite = "bankpacific"},
        {name = "Clé Banque Paleto", price = 150000, sprite = "bankpaleto"},
        {name = "Unité de piratage", price = 5200, sprite = "hackingunit"},
        {name = "Pain de c4", price = 9000, sprite = "c4_bank"},
        {name = "Raspberry", price = 9000, sprite = "raspberry"},
        {name = "Charge Thermique", price = 17000, sprite = "thermal_charge"},
        {name = "Chalumeau", price = 25000, sprite = "blowtorch"},
        {name = "Menottes", price = 10000, sprite = "menotte"},
        {name = "Désinfectant", price = 35000, sprite = "desinfectant"},
        {name = "Skin digital MK2", price = 235000, sprite = "digital"},
        {name = "Skin squelette MK2", price = 235000, sprite = "skull"},
        {name = "Skin perseus MK2", price = 235000, sprite = "perseus"},
        {name = "Skin patriotic MK2", price = 235000, sprite = "patriotic"},
        {name = "Skin sessanta MK2", price = 235000, sprite = "sessanta"},
        {name = "Skin leopard MK2", price = 235000, sprite = "leopard"},
    },
    [3] = {
        {name = "Mun Pistolet", price = 2000, sprite = "clippistol"},
        {name = "Mun Revolver", price = 2000, sprite = "cliprevolver"},
        {name = "Mun SMG", price = 2000, sprite = "clipsmg"},
        {name = "Mun Pompe", price = 5000, sprite = "clippompe"},
        {name = "Mun Fusil", price = 5000, sprite = "clipfusil"},
    },
}

local questNPCs = {
    { coords = vector3(575.8477, -1635.8312, 25.9887), heading = 51.0, model = "ig_lamardavis" },
    { coords = vector3(539.5377, -1944.8313, 24.9851), heading = 306.0, model = "ig_lamardavis" },
    { coords = vector3(753.7730, -3192.9238, 6.0732), heading = 263.0, model = "ig_lamardavis" },
    { coords = vector3(270.7795, -3055.8271, 5.8474), heading = 330.0, model = "ig_lamardavis" },
    { coords = vector3(-458.1075, -2274.4365, 8.5158), heading = 279.0, model = "ig_lamardavis" },
    { coords = vector3(-1016.1346, -1907.3175, 14.4752), heading = 354.0, model = "ig_lamardavis" },
    { coords = vector3(-630.7487, -1727.8036, 24.0824), heading = 105.0, model = "ig_lamardavis" },
    { coords = vector3(-1139.9543, -433.3123, 35.9689), heading = 279.0, model = "ig_lamardavis" },
    { coords = vector3(-444.7004, 344.0906, 105.2865), heading = 3.0, model = "ig_lamardavis" },
    { coords = vector3(414.9391, -216.6278, 59.9105), heading = 329.0, model = "ig_lamardavis" },
    { coords = vector3(-34.1085, -319.8000, 46.4246), heading = 354.0, model = "ig_lamardavis" },
    { coords = vector3(-601.7255, -1142.0668, 25.8581), heading = 270.0, model = "ig_lamardavis" },
    { coords = vector3(-1109.8130, -1453.6572, 5.0699), heading = 295.0, model = "ig_lamardavis" },
    { coords = vector3(-3416.3406, 966.7654, 8.3467), heading = 278.0, model = "ig_lamardavis" },
    { coords = vector3(173.8690, 2778.4128, 46.0773), heading = 272.0, model = "ig_lamardavis" },
    { coords = vector3(402.9625, 2583.7393, 43.5196), heading = 128.0, model = "ig_lamardavis" },
    { coords = vector3(1546.7577, 3701.5503, 35.0896), heading = 109.0, model = "ig_lamardavis" },
    { coords = vector3(1682.7837, 3287.6313, 41.1465), heading = 215.0, model = "ig_lamardavis" },
    { coords = vector3(2327.2773, 2530.5647, 46.6677), heading = 166.0, model = "ig_lamardavis" },
    { coords = vector3(2309.4731, 4885.1938, 41.8082), heading = 48.0, model = "ig_lamardavis" },
    { coords = vector3(1638.2363, 4879.2251, 42.0345), heading = 100.0, model = "ig_lamardavis" },
    { coords = vector3(97.7575, 3682.6448, 39.7313), heading = 6.0, model = "ig_lamardavis" },
}

local function GroupDigits(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ","):reverse())
end

local function GetDirtyMoney()

    local pd = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if pd then ESX.PlayerData = pd end

    local dirty = 0
    if pd and type(pd.inventory) == "table" then
        for _, value in pairs(pd.inventory) do
            if value.name == "dirtymoney" then
                dirty = tonumber(value.count) or 0
            end
        end
    end
    return GroupDigits(tostring(dirty)) .. "$"
end

local territoryZones = {
    { name = "Mirrors Parks #1", poly = { {x=1399.53,y=-642.02}, {x=1399.18,y=-840.26}, {x=1199.32,y=-841.97}, {x=1199.52,y=-641.72} } },
    { name = "Mirrors Parks #2", poly = { {x=1199.32,y=-841.97}, {x=999.33,y=-840.73}, {x=999.53,y=-641.42}, {x=1199.52,y=-641.72} } },
    { name = "Mirrors Parks #3", poly = { {x=1399.53,y=-642.02}, {x=1199.52,y=-641.72}, {x=1199.29,y=-442.18}, {x=1399.94,y=-441.63} } },
    { name = "Mirrors Parks #4", poly = { {x=1199.29,y=-442.18}, {x=1199.52,y=-641.72}, {x=999.53,y=-641.42}, {x=999.71,y=-442.08} } },
    { name = "Mirrors Parks #5", poly = { {x=999.71,y=-442.08}, {x=998.87,y=-715.97}, {x=859.01,y=-716.55}, {x=859.2,y=-442.17} } },
    { name = "Mirrors Parks #6", poly = { {x=999.71,y=-442.08}, {x=1399.94,y=-441.63}, {x=1399.87,y=-317.15}, {x=999.79,y=-318.33} } },
    { name = "Wardogs #1", poly = { {x=1089.46,y=-2250.39}, {x=889.77,y=-2250.96}, {x=888.28,y=-2548.6}, {x=1090.63,y=-2549.73} } },
    { name = "Wardogs #2", poly = { {x=889.7,y=-2250.96}, {x=740.23,y=-2249.31}, {x=740.42,y=-2550.3}, {x=889.7,y=-2547.53} } },
    { name = "Wardogs #3", poly = { {x=889.92,y=-2250.38}, {x=1088.72,y=-2249.16}, {x=1088.76,y=-1949.16}, {x=890.77,y=-1950.89} } },
    { name = "Wardogs #4", poly = { {x=889.73,y=-2248.3}, {x=739.72,y=-2249.43}, {x=737.68,y=-1950.75}, {x=888.65,y=-1950.23} } },
    { name = "Wardogs #5", poly = { {x=1089.34,y=-1949.69}, {x=1088.96,y=-1765.61}, {x=740.2,y=-1766.21}, {x=738.73,y=-1950.34} } },
    { name = "Lucky Plucker #1", poly = { {x=212.81,y=-1574.83}, {x=85.97,y=-1729.58}, {x=-67.31,y=-1599.6}, {x=59.37,y=-1447.75} } },
    { name = "Lucky Plucker #2", poly = { {x=60.27,y=-1446.59}, {x=138.97,y=-1350.04}, {x=293.9,y=-1479.36}, {x=212.81,y=-1574.83} } },
    { name = "Aéroport #1", poly = { {x=-876.6,y=-2699.43}, {x=-1092.14,y=-2576.35}, {x=-1167.55,y=-2704.46}, {x=-950.38,y=-2830.18} } },
    { name = "Aéroport #2", poly = { {x=-876.6,y=-2699.43}, {x=-1092.14,y=-2576.35}, {x=-1017.53,y=-2445.21}, {x=-801.07,y=-2570.59} } },
    { name = "Aéroport #3", poly = { {x=-1017.53,y=-2445.21}, {x=-801.07,y=-2570.59}, {x=-726.81,y=-2439.71}, {x=-942.7,y=-2314.32} } },
    { name = "Plage #1", poly = { {x=-1315.66,y=-1161.27}, {x=-1441.4,y=-946.72}, {x=-1656.34,y=-1071.53}, {x=-1531.33,y=-1287.26} } },
    { name = "Plage #2", poly = { {x=-1326.35,y=-1167.96}, {x=-1543.54,y=-1293.37}, {x=-1417.4,y=-1509.73}, {x=-1200.33,y=-1384.39} } },
    { name = "Plage #3", poly = { {x=-1030.78,y=-1688.0}, {x=-1245.82,y=-1814.69}, {x=-1420.11,y=-1512.61}, {x=-1204.26,y=-1389.14} } },
    { name = "Vinewood #1", poly = { {x=82.74,y=-148.03}, {x=-104.55,y=-78.59}, {x=16.33,y=248.8}, {x=203.44,y=180.42} } },
    { name = "Vinewood #2", poly = { {x=237.55,y=-204.48}, {x=83.05,y=-148.6}, {x=202.96,y=177.22}, {x=357.9,y=124.12} } },
    { name = "Vinewood #3", poly = { {x=85.44,y=435.27}, {x=13.94,y=244.39}, {x=202.8,y=179.97}, {x=272.48,y=366.86} } },
    { name = "Vinewood #4", poly = { {x=358.51,y=123.94}, {x=204.0,y=180.37}, {x=272.5,y=367.83}, {x=427.96,y=311.33} } },
    { name = "Sandy Shores #1", poly = { {x=2074.58,y=3712.29}, {x=1900.08,y=4015.42}, {x=1726.82,y=3914.04}, {x=1903.61,y=3611.32} } },
    { name = "Sandy Shores #2", poly = { {x=1726.82,y=3914.04}, {x=1903.61,y=3611.32}, {x=1730.85,y=3511.13}, {x=1555.56,y=3813.73} } },
    { name = "Grapeseed #1", poly = { {x=1801.96,y=4570.27}, {x=1601.15,y=4570.25}, {x=1600.65,y=4769.68}, {x=1801.34,y=4771.34} } },
    { name = "Grapeseed #2", poly = { {x=1600.65,y=4769.68}, {x=1801.34,y=4771.34}, {x=1799.83,y=4969.51}, {x=1602.38,y=4969.5} } },
    { name = "Paleto bays #1", poly = { {x=168.17,y=6520.54}, {x=-8.94,y=6694.42}, {x=-148.76,y=6553.76}, {x=27.09,y=6378.75} } },
    { name = "Paleto bays #2", poly = { {x=-148.76,y=6553.76}, {x=27.09,y=6378.75}, {x=-114.46,y=6235.62}, {x=-289.9,y=6412.35} } },
    { name = "Paleto bays #3", poly = { {x=-114.46,y=6235.62}, {x=-289.9,y=6412.35}, {x=-433.11,y=6273.4}, {x=-256.93,y=6096.28} } },
    { name = "Cayo Perico #1", poly = { {x=5106.42,y=-5197.16}, {x=4964.7,y=-5334.14}, {x=4791.61,y=-5165.46}, {x=4931.36,y=-5025.64} } },
    { name = "Del Perro #1", poly = { {x=-1622.798828125,y=-421.42172241211}, {x=-1530.3114013672,y=-297.59323120117}, {x=-1359.5999755859,y=-453.90240478516}, {x=-1455.3208007812,y=-532.68695068359} } },
    { name = "Del Perro #2", poly = { {x=-1530.3114013672,y=-297.59323120117}, {x=-1416.6346435547,y=-173.45867919922}, {x=-1243.1746826172,y=-352.92910766602}, {x=-1359.5999755859,y=-453.90240478516} } },
    { name = "West LS #1", poly = { {x=-3126.5029296875,y=703.51898193359}, {x=-3028.7622070312,y=736.41040039062}, {x=-3011.0346679688,y=240.50212097168}, {x=-3112.2331542969,y=232.27864074707} } },
    { name = "West LS #2", poly = { {x=-3189.8093261719,y=1353.5150146484}, {x=-3077.8615722656,y=1313.8233642578}, {x=-3135.6806640625,y=917.13757324219}, {x=-3229.5747070312,y=908.19366455078} } },
    { name = "Grapeseed #3", poly = { {x=1789.7048339844,y=4957.0190429688}, {x=1953.3820800781,y=4982.611328125}, {x=1964.5959472656,y=4824.9643554688}, {x=1805.7926025391,y=4804.4340820312} } },
    { name = "Grapeseed #4", poly = { {x=1805.7926025391,y=4804.4340820312}, {x=1964.5959472656,y=4824.9643554688}, {x=2000.8994140625,y=4610.7241210938}, {x=1804.5657958984,y=4586.2939453122} } },
    { name = "Port #1", poly = { {x=869.04248046875,y=-2902.0502929688}, {x=1135.7409667969,y=-2910.837890625}, {x=1136.2574462891,y=-3015.7563476562}, {x=874.64801025391,y=-3009.9423828125} } },
    { name = "Port #2", poly = { {x=460.07995605469,y=-2945.7087402344}, {x=662.70562744141,y=-2945.8757324219}, {x=658.77447509766,y=-3017.9279785156}, {x=459.01052856445,y=-3022.2583007812} } },
    { name = "Usine #1", poly = { {x=2681.4372558594,y=1719.3726806641}, {x=2837.8073730469,y=1719.8211669922}, {x=2820.3693847656,y=1479.6048583984}, {x=2679.810546875,y=1492.3587646484} } },
}

local UI_READY_TIMEOUT = 7000
local uiReady = false
local openSeq = 0

local CloseTablet

local function OpenTablet()
    if isTabletOpen then return end

    if ESX == nil then return end

    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then
        ESX.ShowNotification("Vous ne pouvez pas utiliser votre tablette en voiture.")
        return
    end

    local okMoney, dirtyMoney = pcall(GetDirtyMoney)
    if not okMoney then dirtyMoney = "0$" end
    local mapNui = BuildTabletMapNuiPayload()

    isTabletOpen = true
    uiReady = false
    openSeq = openSeq + 1
    local mySeq = openSeq

    DisplayRadar(false)
    SetNuiFocus(true, true)
    ExecuteCommand("e tablet")

    SetTimeout(UI_READY_TIMEOUT, function()
        if isTabletOpen and not uiReady and openSeq == mySeq then
            CloseTablet()
            ESX.ShowNotification("~r~La tablette n'a pas pu s'ouvrir.~w~ Reessayez dans un instant.")
        end
    end)

    SendNUIMessage({
        type = "open",
        items = objectsByGroup,
        dirtyMoney = dirtyMoney,
        activities = BuildActivitiesNuiPayload(),
        resourceName = mapNui.resourceName,
        mapAssetResource = mapNui.mapAssetResource,
        mapBounds = mapNui.mapBounds,
        mapImageSize = mapNui.mapImageSize,
        mapControlPoints = mapNui.mapControlPoints,
        mapYFlipped = mapNui.mapYFlipped,
        mapLinear = mapNui.mapLinear,
        mapSwapXY = mapNui.mapSwapXY,
    })
end

CloseTablet = function()
    if not isTabletOpen then return end

    isTabletOpen = false
    uiReady = false
    DisplayRadar(true)
    SetNuiFocus(false, false)
    ExecuteCommand("e stop")

    SendNUIMessage({ type = "close" })
end

RegisterNetEvent("tablet:toggle")
AddEventHandler("tablet:toggle", function()
    if isTabletOpen then
        CloseTablet()
    else
        OpenTablet()
    end
end)

RegisterNUICallback("uiReady", function(_, cb)
    uiReady = true
    cb("ok")
end)

RegisterNUICallback("close", function(_, cb)
    CloseTablet()
    cb("ok")
end)

RegisterNUICallback("buyItem", function(data, cb)
    local sprite = data.sprite
    local quantity = tonumber(data.quantity) or 1
    local itemName = data.name

    if quantity <= 0 then
        cb("ok")
        return
    end

    if playerOnQuest then
        ESX.ShowNotification("Vous avez déjà une commande en cours.")
        cb("ok")
        return
    end

    CloseTablet()

    playerOnQuest = true

    local npcIndex = math.random(1, #questNPCs)
    currentQuestNPC = questNPCs[npcIndex]

    ESX.ShowNotification("Vous avez commandé " .. quantity .. "x " .. itemName .. ". Rendez-vous auprès du PNJ pour le récupérer.")

    blip = AddBlipForCoord(currentQuestNPC.coords.x, currentQuestNPC.coords.y, currentQuestNPC.coords.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, false)
    AddTextEntry("BN_SNL_ILLTABLET_1", "Récupérez votre commande")
    BeginTextCommandSetBlipName("BN_SNL_ILLTABLET_1")
    EndTextCommandSetBlipName(blip)

    Citizen.CreateThread(function()
        while playerOnQuest do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - currentQuestNPC.coords)
            local near = false

            if distance < 50.0 and not npcEntity then
                SpawnNPC(currentQuestNPC)
            elseif distance > 50.0 and npcEntity then
                DeleteEntity(npcEntity)
                npcEntity = nil
            end

            if distance < 2.0 then
                near = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer votre commande.")
                if IsControlJustPressed(0, 38) then
                    CompleteQuest(sprite, quantity)
                end
            end

            if near then
                Citizen.Wait(0)
            else
                Citizen.Wait(500)
            end
        end
    end)

    cb("ok")
end)

local rankingsPending = false
local groupsPending = false
local mapPending = false
local kothPending = false

RegisterNUICallback("getRankings", function(_, cb)
    cb("ok")
    if rankingsPending then return end
    local now = GetGameTimer()
    if now - lastRankingsTime < CALLBACK_COOLDOWN then return end
    lastRankingsTime = now
    rankingsPending = true
    ESX.TriggerServerCallback("tablet:getRankings", function(data)
        rankingsPending = false
        if data then
            SendNUIMessage({
                type = "rankingsData",
                rankingXP = data.rankingXP,
                rankingTerritories = data.rankingTerritories,
            })
        end
    end)
end)

RegisterNUICallback("getKothRankings", function(_, cb)
    cb("ok")
    if kothPending then return end
    local now = GetGameTimer()
    if now - lastKothTime < CALLBACK_COOLDOWN then return end
    lastKothTime = now
    kothPending = true

    local handled = false
    SetTimeout(8000, function()
        if not handled then
            handled = true
            kothPending = false
            SendNUIMessage({ type = "kothRankingsData", rankings = {} })
        end
    end)

    ESX.TriggerServerCallback("tablet:getKothRankings", function(data)
        if handled then return end
        handled = true
        kothPending = false
        SendNUIMessage({
            type = "kothRankingsData",
            rankings = data or {},
        })
    end)
end)

RegisterNUICallback("getGroupsOnline", function(_, cb)
    cb("ok")
    if groupsPending then return end
    local now = GetGameTimer()
    if now - lastGroupsTime < CALLBACK_COOLDOWN then return end
    lastGroupsTime = now
    groupsPending = true
    ESX.TriggerServerCallback("tablet:getGroupsOnline", function(data)
        groupsPending = false
        if data then
            SendNUIMessage({
                type = "groupsOnlineData",
                groups = data,
            })
        end
    end)
end)

RegisterNUICallback("getMapData", function(_, cb)
    cb("ok")
    if mapPending then return end
    local now = GetGameTimer()
    if now - lastMapTime < CALLBACK_COOLDOWN then return end
    lastMapTime = now
    mapPending = true

    local sent = false
    local function sendMap(territories)
        if sent then return end
        sent = true
        mapPending = false
        local mapNui = BuildTabletMapNuiPayload()
        SendNUIMessage({
            type = "mapData",
            zones = territoryZones,
            territories = territories or {},
            resourceName = mapNui.resourceName,
            mapAssetResource = mapNui.mapAssetResource,
            mapBounds = mapNui.mapBounds,
            mapImageSize = mapNui.mapImageSize,
            mapControlPoints = mapNui.mapControlPoints,
            mapYFlipped = mapNui.mapYFlipped,
            mapLinear = mapNui.mapLinear,
            mapSwapXY = mapNui.mapSwapXY,
        })
    end

    SetTimeout(8000, function() sendMap({}) end)

    TerrRpc("getData", function(territories)
        sendMap(territories)
    end)
end)

function SpawnNPC(npc)
    RequestModel(npc.model)
    while not HasModelLoaded(npc.model) do
        Citizen.Wait(100)
    end

    npcEntity = CreatePed(4, GetHashKey(npc.model), npc.coords.x, npc.coords.y, npc.coords.z - 1.0, npc.heading, false, true)
    SetEntityInvincible(npcEntity, true)
    SetBlockingOfNonTemporaryEvents(npcEntity, true)
    FreezeEntityPosition(npcEntity, true)
end

function CompleteQuest(sprite, quantity)
    TriggerServerEvent("tablet:buyItem", sprite, quantity)

    playerOnQuest = false
    currentQuestNPC = nil

    if npcEntity then
        DeleteEntity(npcEntity)
        npcEntity = nil
    end

    if blip then
        RemoveBlip(blip)
        blip = nil
    end
end

RegisterNUICallback("locateActivity", function(data, cb)
    cb("ok")
    local actId = data.id
    if not actId then return end

    local activity = nil
    for _, act in ipairs(TabletActivities or {}) do
        if act.id == actId then
            activity = act
            break
        end
    end

    if not activity or not activity.coords then
        ESX.ShowNotification("~r~Activité introuvable.")
        return
    end

    if activityBlip then
        RemoveBlip(activityBlip)
        activityBlip = nil
    end

    CloseTablet()

    activityBlip = AddBlipForCoord(activity.coords.x, activity.coords.y, activity.coords.z)
    SetBlipSprite(activityBlip, 1)
    SetBlipColour(activityBlip, 5)
    SetBlipScale(activityBlip, 0.9)
    SetBlipAsShortRange(activityBlip, false)
    SetBlipRoute(activityBlip, true)
    SetBlipRouteColour(activityBlip, 5)
    local _key = "BN_SNL_ILLTABLET_2_" .. tostring(activityBlip)
    AddTextEntry(_key, activity.name)
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(activityBlip)

    ESX.ShowNotification("~g~GPS~w~ mis à jour : " .. activity.name)

    Citizen.CreateThread(function()
        while activityBlip do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - activity.coords)
            if dist < 30.0 then
                if activityBlip then
                    RemoveBlip(activityBlip)
                    activityBlip = nil
                end
                ESX.ShowNotification("Vous êtes arrivé à l'activité.")
                break
            end
            Citizen.Wait(2000)
        end
    end)
end)
