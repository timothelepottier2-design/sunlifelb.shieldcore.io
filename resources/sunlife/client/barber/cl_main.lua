-- ============================================================
-- Barber client (mergé depuis vms_barber, ESX + esx_skin uniquement)
-- ============================================================

local Config    = BarberConfig
local TRANSLATE = BarberT

local ESX = exports['es_extended']:getSharedObject()

-- État runtime partagé entre cl_main et cl_rageui
BarberState = BarberState or {}
BarberState.PlayerData       = {}
BarberState.cam              = nil
BarberState.heading          = 0.0
BarberState.Ped              = nil
BarberState.barberId         = nil
BarberState.chairId          = nil
BarberState.CURRENT_BARBER   = nil
BarberState.CURRENT_CHAIR    = nil
BarberState.CURRENT_FADES    = nil
BarberState.Character_Temp_Tattoos = {}
BarberState.currentTattoos   = {}

local function notify(message, ttype)
    local data = { message = message, type = ttype or 'info' }
    TriggerEvent('esx:showNotification', message)
end

-- Sync au chargement / job
RegisterNetEvent(Config.PlayerLoaded, function(playerData)
    BarberState.PlayerData = playerData or ESX.GetPlayerData()
end)

RegisterNetEvent(Config.JobUpdated, function(job)
    BarberState.PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    while not ESX do Citizen.Wait(200) end
    if ESX.IsPlayerLoaded() then
        BarberState.PlayerData = ESX.GetPlayerData()
    end
end)

-- Blips
Citizen.CreateThread(function()
    for _, v in pairs(Config.Barbers) do
        local blip = AddBlipForCoord(v.position)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TRANSLATE("blip.barber"))
        EndTextCommandSetBlipName(blip)
    end
end)

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local function loadPedModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(5)
    end
end

function Barber_LoadAnimDict(dict) loadAnimDict(dict) end

function Barber_UnloadPlayerProps()
    local myPed = PlayerPedId()
    SetPedComponentVariation(myPed, 1, -1, 0, 2)
    ClearPedProp(myPed, 0)
    ClearPedProp(myPed, 1)
end

-- Thread principal : markers + accès aux chaises (pas de target system)
Citizen.CreateThread(function()
    while true do
        local sleep    = 2000
        local myPed    = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        for k, v in pairs(Config.Barbers) do
            for k2, v2 in pairs(v.Chairs) do
                local distance = #(myCoords - v2.position)
                if distance < Config.DistanceView then
                    sleep = 2
                    local marker = v2.taken and Config.Markers['TakenSeat'] or Config.Markers['FreeSeat']
                    local color  = v2.taken and v.takeSitMarker.TakenColor or v.takeSitMarker.FreeColor
                    DrawMarker(marker.id, v2.position.x, v2.position.y, v2.position.z + 0.75,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        marker.size, color[1], color[2], color[3], color[4],
                        marker.bobUpAndDown, false, false, marker.rotate)
                end
                if distance < Config.DistanceAccess and not BarberState.CURRENT_CHAIR then
                    ESX.ShowHelpNotification(TRANSLATE("help.take_a_sit"))
                    if IsControlJustPressed(0, 38) and not v2.taken then
                        BarberState.barberId, BarberState.chairId = k, k2
                        TriggerServerEvent("rg_barber:sv:takeChair", k, k2, true)
                        readyCutHair(v2)
                        createBarber(v, v2)
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

function readyCutHair(v2)
    local myPed = PlayerPedId()
    BarberState.CURRENT_CHAIR = v2

    TaskPedSlideToCoord(myPed, v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z, v2.chairCoord.w)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    FreezeEntityPosition(myPed, true)
    Citizen.Wait(100)
    SetEntityCoords(myPed, v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z)
    SetEntityHeading(myPed, v2.chairCoord.w)

    loadAnimDict(Config.ChairSittingAnim[1])
    TaskPlayAnim(myPed, Config.ChairSittingAnim[1], Config.ChairSittingAnim[2], 1.0, 1.0, -1, 2, 0, false, false, false)

    Citizen.Wait(100)
    SetEntityHeading(myPed, v2.chairCoord.w)
    Citizen.Wait(1300)
    SetEntityHeading(myPed, v2.chairCoord.w)
    DoScreenFadeIn(5000)
end

function createBarber(v, v2)
    BarberState.CURRENT_FADES  = nil
    BarberState.CURRENT_BARBER = v

    if v.barber then
        Citizen.CreateThread(function()
            local barber = GetHashKey(v.barber)
            loadPedModel(barber)
            print(('^6[NETDIAG][PED]^7 %s cl_main.lua:152 CreatePed NETWORKED barber'):format(GetCurrentResourceName()))
            BarberState.Ped = CreatePed(1, barber, v.barberSpawnPos.x, v.barberSpawnPos.y, v.barberSpawnPos.z, v.barberSpawnPos.w, true, true)
            SetEntityHeading(BarberState.Ped, v.barberSpawnPos.w)
            SetBlockingOfNonTemporaryEvents(BarberState.Ped, true)
            TaskPedSlideToCoord(BarberState.Ped, v2.position.x, v2.position.y, v2.position.z, v2.position.w, 1.0)
            Citizen.Wait(5000)
            TaskPedSlideToCoord(BarberState.Ped, v2.barberPos.x, v2.barberPos.y, v2.barberPos.z, v2.barberPos.w, 1.0)
            Citizen.Wait(1000)
            SetEntityCoords(BarberState.Ped, v2.barberPos.x, v2.barberPos.y, v2.barberPos.z)
            SetEntityHeading(BarberState.Ped, v2.barberPos.w)
            FreezeEntityPosition(BarberState.Ped, true)
        end)
    end

    Barber_RefreshValues()
    local data = {}
    local components, maxVals = Barber_GetMaxValues()
    for i = 1, #components do
        data[components[i].name] = {
            value = components[i].value,
            min   = components[i].min,
        }
        for k, val in pairs(maxVals) do
            if k == components[i].name then
                data[k].max = val
                break
            end
        end
    end

    -- Recharge les tatouages courants (intégration avec le tattooshop)
    if Config.UseTattoshopHairFades and Tattoo_ReloadPlayerTattoos then
        Tattoo_ReloadPlayerTattoos()
    end

    TriggerEvent('skinchanger:getData', function(comp)
        for _, c in pairs(comp) do
            if data[c.name] then
                data[c.name].value = tonumber(c.value)
            end
        end
    end)

    if Config.UseTattoshopHairFades and Tattoo_GetHairFadesList then
        BarberState.CURRENT_FADES = Tattoo_GetHairFadesList()
        for k, fade in pairs(BarberState.CURRENT_FADES) do
            if fade.hasTattoo then
                BarberState.Character_Temp_Tattoos[tostring(k)] = true
            end
        end
    end

    Barber_UnloadPlayerProps()
    OpenBarberRageMenu({
        data       = data,
        Makeup     = Config.CanMakeup,
        CustomNames = Config.CustomNames,
        prices     = v.prices,
        hairFades  = BarberState.CURRENT_FADES,
        tempTattoos = BarberState.Character_Temp_Tattoos,
    })
end

-- Rayon (mètres) et angle de rotation appliqué à chaque frame quand on
-- maintient une touche. Ajustables au besoin pour la vitesse de rotation.
local BARBER_CAM_RADIUS   = 0.7
local BARBER_CAM_ROT_STEP = 1.5

-- État de maintien des touches de rotation (A = gauche, E = droite), alimenté
-- par les commandes +/- de RegisterKeyMapping. Les touches sont rebindables
-- par le joueur dans les paramètres FiveM (section Key Bindings).
local barberRotLeft, barberRotRight = false, false

RegisterKeyMapping('+barberCamLeft',  'Coiffeur : tourner la caméra à gauche', 'keyboard', 'A')
RegisterKeyMapping('+barberCamRight', 'Coiffeur : tourner la caméra à droite', 'keyboard', 'E')
RegisterCommand('+barberCamLeft',  function() barberRotLeft  = true  end, false)
RegisterCommand('-barberCamLeft',  function() barberRotLeft  = false end, false)
RegisterCommand('+barberCamRight', function() barberRotRight = true  end, false)
RegisterCommand('-barberCamRight', function() barberRotRight = false end, false)

function Barber_CreateCam()
    if not DoesCamExist(BarberState.cam) then
        BarberState.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = PlayerPedId()
    -- L'angle d'orbite part du heading du perso : la caméra est donc face au
    -- visage à l'ouverture, puis les touches A/E font tourner autour de la tête.
    BarberState.heading = GetEntityHeading(playerPed)
    SetCamActive(BarberState.cam, true)
    RenderScriptCams(true, true, 500, true, true)
    Barber_ChangeCam(playerPed)

    -- Thread de rotation : tourne la caméra autour de la tête tant que la cam
    -- existe, via les touches A (gauche) et E (droite).
    Citizen.CreateThread(function()
        while BarberState.cam do
            Citizen.Wait(0)
            local rotated = false
            if barberRotLeft then
                BarberState.heading = BarberState.heading + BARBER_CAM_ROT_STEP
                rotated = true
            elseif barberRotRight then
                BarberState.heading = BarberState.heading - BARBER_CAM_ROT_STEP
                rotated = true
            end
            if rotated then
                if BarberState.heading >= 360.0 then BarberState.heading = BarberState.heading - 360.0 end
                if BarberState.heading < 0.0 then BarberState.heading = BarberState.heading + 360.0 end
                Barber_ChangeCam(PlayerPedId())
            end
        end
    end)
end

function Barber_DeleteCam()
    if not BarberState.cam then return end
    SetCamActive(BarberState.cam, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(BarberState.cam, true)
    BarberState.cam = nil
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)

    if BarberState.Ped then
        DeletePed(BarberState.Ped)
        BarberState.Ped = nil
    end

    if BarberState.barberId and BarberState.chairId then
        TriggerServerEvent("rg_barber:sv:takeChair", BarberState.barberId, BarberState.chairId, false)
    end

    BarberState.heading        = 0.0
    BarberState.barberId       = nil
    BarberState.chairId        = nil
    BarberState.CURRENT_CHAIR  = nil
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())

    if Config.UseTattoshopHairFades and Tattoo_ReloadPlayerTattoos then
        Tattoo_ReloadPlayerTattoos()
    end
end

function Barber_ChangeCam(ped)
    if not BarberState.cam then return end
    -- Position de la tête (bone SKEL_Head = 31086) : centre de l'orbite.
    local headCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 31086))
    -- Orbite horizontale autour de la tête selon BarberState.heading. À l'angle
    -- initial (= heading du perso) la caméra se place devant le visage, comme
    -- avant ; les flèches gauche/droite font ensuite le tour de la tête.
    local rad  = math.rad(BarberState.heading)
    local camX = headCoords.x - math.sin(rad) * BARBER_CAM_RADIUS
    local camY = headCoords.y + math.cos(rad) * BARBER_CAM_RADIUS
    SetCamFov(BarberState.cam, 50.0)
    SetCamCoord(BarberState.cam, vec(camX, camY, headCoords.z))
    PointCamAtPedBone(BarberState.cam, ped, 31086)
end

-- Sync de l'état "chaise prise" envoyé par le serveur
RegisterNetEvent("rg_barber:cl:takeChair", function(barberId, chairId, toggle)
    if Config.Barbers[barberId] and Config.Barbers[barberId].Chairs[chairId] then
        Config.Barbers[barberId].Chairs[chairId].taken = toggle
    end
end)
