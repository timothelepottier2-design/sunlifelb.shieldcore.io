local Config    = TattooConfig
local TRANSLATE = TattooT

local ESX = exports['es_extended']:getSharedObject()

TattooState = TattooState or {}
TattooState.PlayerData       = {}
TattooState.cam              = nil
TattooState.Ped              = nil
TattooState.barberId         = nil
TattooState.chairId          = nil
TattooState.CURRENT_TATTOOSHOP = nil
TattooState.CURRENT_CHAIR    = nil
TattooState.myGender         = nil

TattooState.currentTattoos       = {}
TattooState.tempTattoos          = {}
TattooState.tempTattoosTotal     = 0
TattooState.clientTempTattoos    = {}
TattooState.clientTempTattoosTotal = 0

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function requestPedModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
end

local SeatStreamDistance = 50.0

local function despawnSeats()
    for _, v in pairs(TattooConfig.SeatSpawnsList) do
        if v.obj and DoesEntityExist(v.obj) then DeleteEntity(v.obj) end
        v.obj = nil
    end
end

Citizen.CreateThread(function()
    local object = TattooConfig.SeatObject
    if not tonumber(object) then object = GetHashKey(object) end

    while true do
        local sleep     = 3000
        local myCoords  = GetEntityCoords(PlayerPedId())

        for _, v in pairs(TattooConfig.SeatSpawnsList) do
            local dist = #(myCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist < SeatStreamDistance then
                sleep = 1500
                if not v.obj or not DoesEntityExist(v.obj) then
                    if not HasModelLoaded(object) then
                        RequestModel(object)
                        while not HasModelLoaded(object) do Citizen.Wait(0) end
                    end
                    v.obj = CreateObject(object, v.coords.x, v.coords.y, v.coords.z, false, false, true)
                    SetEntityAsMissionEntity(v.obj, true, true)
                    FreezeEntityPosition(v.obj, true)
                    SetEntityHeading(v.obj, v.coords.w)
                    SetModelAsNoLongerNeeded(object)
                end
            elseif v.obj and DoesEntityExist(v.obj) then
                DeleteEntity(v.obj)
                v.obj = nil
            end
        end

        Citizen.Wait(sleep)
    end
end)

local function loadPlayerTattoos()
    ESX.TriggerServerCallback('rg_tattoo:requestPlayerTattoos', function(tattooList)
        if not tattooList then return end
        local clean = {}
        for _, v in pairs(tattooList) do
            if v and v.collection and v.texture
                and TattooConfig.TattooList[v.collection]
                and TattooConfig.TattooList[v.collection][v.texture] then
                TattooConfig.TattooList[v.collection][v.texture].hasTattoo = true
                clean[#clean + 1] = v
            end
        end
        TattooState.currentTattoos = clean
        Tattoo_ReloadPlayerTattoos()
    end)
end

local function fetchGender(cb)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin and skin.sex then
            TattooState.myGender = (skin.sex == "mp_m_freemode_01" or skin.sex == 0) and 0 or 1
        end
        if cb then cb() end
    end)
end

AddEventHandler('skinchanger:modelLoaded', function()
    ESX.TriggerServerCallback('rg_tattoo:requestPlayerTattoos', function(tattooList)
        if not tattooList then return end
        local clean = {}
        for _, v in pairs(tattooList) do
            if v and v.collection and v.texture
                and TattooConfig.TattooList[v.collection]
                and TattooConfig.TattooList[v.collection][v.texture] then
                local entry = TattooConfig.TattooList[v.collection][v.texture]
                entry.hasTattoo = true
                ApplyPedOverlay(PlayerPedId(),
                    GetHashKey(v.collection),
                    TattooState.myGender == 0
                        and GetHashKey(entry.nameHashMale)
                        or  GetHashKey(entry.nameHashFemale))
                clean[#clean + 1] = v
            end
        end
        TattooState.currentTattoos = clean
    end)
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    while not ESX do Citizen.Wait(200) end
    if ESX.IsPlayerLoaded() then
        fetchGender(loadPlayerTattoos)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    despawnSeats()
end)

local REMOTE_SCAN_MS      = 2000
local REAPPLY_INTERVAL_MS = 30000
local REMOTE_CACHE_TTL_MS = 600000

local RemoteTattoos = {}
local RemoteApplied = {}
local remoteStampSeq = 0
local remoteFetchInFlight = false

local MALE_MODEL = `mp_m_freemode_01`

local function applyTattoosToRemotePed(ped, list)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end

    ClearPedDecorations(ped)

    local isMale = GetEntityModel(ped) == MALE_MODEL

    for i = 1, #list do
        local v = list[i]
        if v and v.collection and v.texture
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.texture] then
            local entry = TattooConfig.TattooList[v.collection][v.texture]
            local nameHash = isMale and entry.nameHashMale or entry.nameHashFemale
            if nameHash then
                ApplyPedOverlay(ped, GetHashKey(v.collection), GetHashKey(nameHash))
            end
        end
    end

    return true
end

RegisterNetEvent('rg_tattoo:tattoosChanged', function(serverId, list)
    serverId = tonumber(serverId)
    if not serverId or serverId == GetPlayerServerId(PlayerId()) then return end

    remoteStampSeq = remoteStampSeq + 1
    RemoteTattoos[serverId] = {
        list   = type(list) == 'table' and list or {},
        stamp  = remoteStampSeq,
        seenAt = GetGameTimer(),
    }
end)

Citizen.CreateThread(function()

    if not TattooConfig.ForceRemoteTattooSync then return end

    while true do
        Citizen.Wait(REMOTE_SCAN_MS)

        local myId = GetPlayerServerId(PlayerId())
        local now = GetGameTimer()
        local players = GetActivePlayers()
        local unknown, unknownCount = {}, 0

        for i = 1, #players do
            local pid = players[i]
            local sid = GetPlayerServerId(pid)

            if sid ~= myId and sid > 0 then
                local data = RemoteTattoos[sid]

                if not data then
                    unknownCount = unknownCount + 1
                    unknown[unknownCount] = sid
                else
                    data.seenAt = now

                    local ped = GetPlayerPed(pid)
                    if ped and ped ~= 0 and DoesEntityExist(ped) then
                        local applied = RemoteApplied[sid]
                        local changed = not applied
                            or applied.ped ~= ped
                            or applied.stamp ~= data.stamp

                        local stale = changed
                            or (#data.list > 0 and (now - applied.at) >= REAPPLY_INTERVAL_MS)

                        if stale and applyTattoosToRemotePed(ped, data.list) then
                            RemoteApplied[sid] = { ped = ped, stamp = data.stamp, at = now }
                        end
                    end
                end
            end
        end

        if unknownCount > 0 and not remoteFetchInFlight then
            remoteFetchInFlight = true
            ESX.TriggerServerCallback('rg_tattoo:getTattoosOfMany', function(map)
                remoteFetchInFlight = false
                if type(map) ~= 'table' then return end
                local at = GetGameTimer()
                for sidStr, list in pairs(map) do
                    local sid = tonumber(sidStr)
                    if sid and type(list) == 'table' then
                        remoteStampSeq = remoteStampSeq + 1
                        RemoteTattoos[sid] = { list = list, stamp = remoteStampSeq, seenAt = at }
                    end
                end
            end, unknown)
        end

        for sid, data in pairs(RemoteTattoos) do
            if (now - (data.seenAt or 0)) > REMOTE_CACHE_TTL_MS then
                RemoteTattoos[sid] = nil
                RemoteApplied[sid] = nil
            end
        end
    end
end)

RegisterNetEvent(Config.PlayerLoaded, function(playerData)
    TattooState.PlayerData = playerData or ESX.GetPlayerData()
    fetchGender(loadPlayerTattoos)
end)

RegisterNetEvent(Config.JobUpdated, function(job)
    TattooState.PlayerData.job = job
end)

RegisterNetEvent(Config.PlayerLogout, function()
    TattooState.myGender = nil
    TattooState.currentTattoos = {}
    despawnSeats()
end)

Citizen.CreateThread(function()
    for _, v in pairs(TattooConfig.Tattooshops) do
        local blip = AddBlipForCoord(v.position)
        SetBlipSprite(blip, TattooConfig.Blip.Sprite)
        SetBlipDisplay(blip, TattooConfig.Blip.Display)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, TattooConfig.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TRANSLATE("blip.tattoo"))
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep    = 2000
        local myPed    = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        for k, v in pairs(TattooConfig.Tattooshops) do
            for k2, v2 in pairs(v.Chairs) do
                local distance = #(myCoords - v2.position)
                if distance < TattooConfig.DistanceView then
                    sleep = 2
                    local marker = v2.taken and TattooConfig.Markers['TakenSeat'] or TattooConfig.Markers['FreeSeat']
                    local color  = v2.taken and v.takeSitMarker.TakenColor or v.takeSitMarker.FreeColor
                    DrawMarker(marker.id, v2.position.x, v2.position.y, v2.position.z + 0.75,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        marker.size, color[1], color[2], color[3], color[4],
                        marker.bobUpAndDown, false, false, marker.rotate)
                end
                if distance < TattooConfig.DistanceAccess and not TattooState.CURRENT_CHAIR then
                    ESX.ShowHelpNotification(TRANSLATE("help.take_a_sit"))
                    if IsControlJustPressed(0, 38) and not v2.taken then
                        TattooState.barberId, TattooState.chairId = k, k2
                        readyToTattooing(v2)
                        createTattooPed(v, v2)
                        TriggerServerEvent("rg_tattoo:sv:takeChair", k, k2, true)
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

function readyToTattooing(v2)
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do Citizen.Wait(0) end
    TattooState.tempTattoosTotal = 0
    TattooState.tempTattoos      = {}
    TattooState.CURRENT_CHAIR    = v2
    SetEntityCoords(PlayerPedId(), v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z)
    SetEntityHeading(PlayerPedId(), v2.chairCoord.w)
    local myPed = PlayerPedId()
    loadAnimDict(TattooConfig.LiesAnims.backAnimDict)
    TaskPlayAnim(myPed, TattooConfig.LiesAnims.backAnimDict, TattooConfig.LiesAnims.backAnim, 8.0, 8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(400)
    DoScreenFadeIn(200)
end

function createTattooPed(v, v2)
    local isFemale = false
    TattooState.CURRENT_TATTOOSHOP = v

    if v.pedModel then
        local pedModel = GetHashKey(v.pedModel)
        requestPedModel(pedModel)
        print(('^6[NETDIAG][PED]^7 %s cl_main.lua:242 CreatePed NETWORKED tattoo'):format(GetCurrentResourceName()))
        TattooState.Ped = CreatePed(1, pedModel, v.tattooPedSpawnPos.x, v.tattooPedSpawnPos.y, v.tattooPedSpawnPos.z, v.tattooPedSpawnPos.w, true, true)
        SetEntityHeading(TattooState.Ped, v.tattooPedSpawnPos.w)
        SetBlockingOfNonTemporaryEvents(TattooState.Ped, true)
        TaskPedSlideToCoord(TattooState.Ped, v2.position.x, v2.position.y, v2.position.z, v2.position.w, 1.0)
        SetEntityCoords(TattooState.Ped, v2.tattooerPos.x, v2.tattooerPos.y, v2.tattooerPos.z)
        SetEntityHeading(TattooState.Ped, v2.tattooerPos.w)
        ClearPedTasks(TattooState.Ped)
        FreezeEntityPosition(TattooState.Ped, true)
    end

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin.sex == 0 or skin.sex == "mp_m_freemode_01" then
            TriggerEvent('skinchanger:loadClothes', skin, TattooConfig.ClothesOff["male"])
        else
            isFemale = true
            TriggerEvent('skinchanger:loadClothes', skin, TattooConfig.ClothesOff["female"])
        end
        CreateSkinCam(isFemale)
    end)
end

function CreateSkinCam(isFemale)
    if not DoesCamExist(TattooState.cam) then
        TattooState.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    SetCamActive(TattooState.cam, true)
    RenderScriptCams(true, true, 1500, true, true)
    SetCamCoord(TattooState.cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), TattooConfig.StartingCam[1]))
    PointCamAtCoord(TattooState.cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), TattooConfig.StartingCam[2]))

    if OpenTattooRageMenu then
        OpenTattooRageMenu(isFemale, TattooState.CURRENT_TATTOOSHOP and TattooState.CURRENT_TATTOOSHOP.categories)
    end
end

function DeleteSkinCam()
    if TattooState.cam then
        SetCamActive(TattooState.cam, false)
        RenderScriptCams(false, true, 500, true, true)
        TattooState.cam = nil
    end
    if TattooState.Ped then
        DeletePed(TattooState.Ped)
        TattooState.Ped = nil
    end
    if TattooState.barberId and TattooState.chairId then
        TriggerServerEvent("rg_tattoo:sv:takeChair", TattooState.barberId, TattooState.chairId, false)
    end
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    TattooState.tempTattoosTotal = 0
    TattooState.tempTattoos      = {}
    TattooState.barberId         = nil
    TattooState.chairId          = nil
    TattooState.CURRENT_CHAIR    = nil
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        Tattoo_ReloadPlayerTattoos()
    end)
end

RegisterNetEvent("rg_tattoo:cl:takeChair", function(barberId, chairId, toggle)
    if TattooConfig.Tattooshops[barberId] and TattooConfig.Tattooshops[barberId].Chairs[chairId] then
        TattooConfig.Tattooshops[barberId].Chairs[chairId].taken = toggle
    end
end)

RegisterNetEvent("rg_tattoo:cl:notification", function(message)
    ESX.ShowNotification(message)
end)

RegisterNetEvent("rg_tattoo:cl:loadPlayerSkin", function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

RegisterNetEvent('rg_tattoo:barberFadesChanges', function(list)
    if not list or not next(list) then return end

    local collection = TattooConfig.HairFadesCollection
    for tattooId, _ in pairs(list) do
        local id = tonumber(tattooId)
        if TattooConfig.TattooList[collection] and TattooConfig.TattooList[collection][id] then
            if TattooConfig.TattooList[collection][id].hasTattoo then
                for k, v in pairs(TattooState.currentTattoos) do
                    if v.collection == collection and v.texture == id then
                        table.remove(TattooState.currentTattoos, k)
                    end
                end
                TattooConfig.TattooList[collection][id].hasTattoo = false
            else
                TattooState.currentTattoos[#TattooState.currentTattoos + 1] = { collection = collection, texture = id }
                TattooConfig.TattooList[collection][id].hasTattoo = true
            end
        end
    end

    TriggerServerEvent('rg_tattoo:updateBarberFades', TattooState.currentTattoos)
    Tattoo_ReloadPlayerTattoos()
end)

function Tattoo_ReloadPlayerTattoos(cb)
    ClearPedDecorations(PlayerPedId())
    for _, v in pairs(TattooState.currentTattoos) do
        if v and v.collection and v.texture
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.texture]
            and not TattooState.tempTattoos[v.collection .. ":" .. v.texture] then
            local entry = TattooConfig.TattooList[v.collection][v.texture]
            ApplyPedOverlay(PlayerPedId(),
                GetHashKey(v.collection),
                TattooState.myGender == 0
                    and GetHashKey(entry.nameHashMale)
                    or  GetHashKey(entry.nameHashFemale))
        end
    end

    for _, v in pairs(TattooState.tempTattoos) do
        if v and v.type == "add" and v.collection and v.id
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.id] then
            local entry = TattooConfig.TattooList[v.collection][v.id]
            ApplyPedOverlay(PlayerPedId(),
                GetHashKey(v.collection),
                TattooState.myGender == 0
                    and GetHashKey(entry.nameHashMale)
                    or  GetHashKey(entry.nameHashFemale))
        end
    end

    if cb then cb() end
end

function Tattoo_ReloadPlayerTattoosByBarber(list, cb)
    local collection = TattooConfig.HairFadesCollection
    ClearPedDecorations(PlayerPedId())
    for _, v in pairs(TattooState.currentTattoos) do
        if v and v.collection and v.texture
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.texture]
            and not (v.collection == collection and list and list[tostring(v.texture)] ~= nil) then
            local entry = TattooConfig.TattooList[v.collection][v.texture]
            ApplyPedOverlay(PlayerPedId(),
                GetHashKey(v.collection),
                TattooState.myGender == 0
                    and GetHashKey(entry.nameHashMale)
                    or  GetHashKey(entry.nameHashFemale))
        end
    end
    if list and next(list) and TattooConfig.TattooList[collection] then
        for k, v in pairs(list) do
            local id = tonumber(k)
            if v and id and TattooConfig.TattooList[collection][id] then
                local entry = TattooConfig.TattooList[collection][id]
                ApplyPedOverlay(PlayerPedId(),
                    GetHashKey(collection),
                    TattooState.myGender == 0
                        and GetHashKey(entry.nameHashMale)
                        or  GetHashKey(entry.nameHashFemale))
            end
        end
    end
    if cb then cb() end
end

function Tattoo_GetHairFadesList()
    if not TattooConfig or not TattooConfig.TattooList then
        return {}
    end
    return TattooConfig.TattooList[TattooConfig.HairFadesCollection] or {}
end

local function selectedCamera(collection, id)
    local selectedTattoo = TattooConfig.TattooList[collection][id]
    if not selectedTattoo then return end
    local myPed = PlayerPedId()

    if selectedTattoo.anim == "FRONT" then
        SetEntityHeading(myPed, TattooConfig.Tattooshops[TattooState.barberId].pedHeadingToChair)
        loadAnimDict(TattooConfig.LiesAnims.frontAnimDict)
        TaskPlayAnim(myPed, TattooConfig.LiesAnims.frontAnimDict, TattooConfig.LiesAnims.frontAnim, 3.0, 3.0, -1, 1, 0, false, false, false)
    elseif selectedTattoo.anim == "BACK" then
        SetEntityHeading(myPed, TattooConfig.Tattooshops[TattooState.barberId].pedHeadingToChairBack)
        loadAnimDict(TattooConfig.LiesAnims.backAnimDict)
        TaskPlayAnim(myPed, TattooConfig.LiesAnims.backAnimDict, TattooConfig.LiesAnims.backAnim, 3.0, 3.0, -1, 1, 0, false, false, false)
    end

    if type(selectedTattoo.camera) == 'string' then
        SetCamCoord(TattooState.cam,    GetOffsetFromEntityInWorldCoords(myPed, TattooConfig.TattoosCameras[selectedTattoo.camera][1]))
        PointCamAtCoord(TattooState.cam, GetOffsetFromEntityInWorldCoords(myPed, TattooConfig.TattoosCameras[selectedTattoo.camera][2]))
    else
        SetCamCoord(TattooState.cam,    GetOffsetFromEntityInWorldCoords(myPed, selectedTattoo.camera[1]))
        PointCamAtCoord(TattooState.cam, GetOffsetFromEntityInWorldCoords(myPed, selectedTattoo.camera[2]))
    end
end

function Tattoo_DrawTattoo(current, collection)
    local id = current + 1
    ClearPedDecorations(PlayerPedId())
    selectedCamera(collection, id)

    for _, v in pairs(TattooState.currentTattoos) do
        if v and v.collection and v.texture
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.texture]
            and not TattooState.tempTattoos[v.collection .. ":" .. v.texture] then
            local entry = TattooConfig.TattooList[v.collection][v.texture]
            ApplyPedOverlay(PlayerPedId(),
                GetHashKey(v.collection),
                TattooState.myGender == 0
                    and GetHashKey(entry.nameHashMale)
                    or  GetHashKey(entry.nameHashFemale))
        end
    end

    for _, v in pairs(TattooState.tempTattoos) do
        if v and v.type == "add" and v.collection and v.id
            and TattooConfig.TattooList[v.collection]
            and TattooConfig.TattooList[v.collection][v.id] then
            local entry = TattooConfig.TattooList[v.collection][v.id]
            ApplyPedOverlay(PlayerPedId(),
                GetHashKey(v.collection),
                TattooState.myGender == 0
                    and GetHashKey(entry.nameHashMale)
                    or  GetHashKey(entry.nameHashFemale))
        end
    end

    Citizen.Wait(50)

    if TattooConfig.TattooList[collection] and TattooConfig.TattooList[collection][id] then
        local entry = TattooConfig.TattooList[collection][id]
        ApplyPedOverlay(PlayerPedId(),
            GetHashKey(collection),
            TattooState.myGender == 0
                and GetHashKey(entry.nameHashMale)
                or  GetHashKey(entry.nameHashFemale))
    end
end

exports('reloadPlayerTattoos',          function() Tattoo_ReloadPlayerTattoos() end)
exports('reloadPlayerTattoosByBarber',  function(list, cb) Tattoo_ReloadPlayerTattoosByBarber(list, cb) end)
exports('GetHairFadesList',             function() return Tattoo_GetHairFadesList() end)
