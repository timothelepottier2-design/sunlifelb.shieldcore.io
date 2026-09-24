local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'garage', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'garage', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('garage/' .. name, cb)
end

ESX = nil
local playerJob = nil
local gTable = {}
local EnAction = false

PRIME = {}
PRIME.Nui = {}
local previewVehicle = {}
local previewCam = nil
local lastPreviewPlate = nil
uiVisible = false

local orbitYaw, orbitPitch, orbitRadius = 0.0, 10.0, 6.0
local ORBIT_MIN_PITCH, ORBIT_MAX_PITCH = -75.0, 75.0
local ORBIT_MIN_RADIUS, ORBIT_MAX_RADIUS = 2.0, 25.0
local orbitPivot = nil

local CAM_MIN_GROUND_CLEARANCE = 0.65
local CAM_COLLISION_PAD        = 0.22
local CAM_RAY_FLAGS            = 511

local function camRaycast(pivot, to)
    local ignore = previewVehicle and previewVehicle[1] or 0
    local handle = StartExpensiveSynchronousShapeTestLosProbe(
        pivot.x, pivot.y, pivot.z,
        to.x,    to.y,    to.z,
        CAM_RAY_FLAGS, ignore, 7
    )
    local _, hit, hitPos, _, _ = GetShapeTestResult(handle)
    return hit == 1, hitPos
end

local function clampf(v, a, b) return math.max(a, math.min(b, v)) end
local function wrapYaw(a) a = a % 360.0; if a < 0.0 then a = a + 360.0 end; return a end

local function setCamFromOrbit()
    if not previewCam or not DoesCamExist(previewCam) or not orbitPivot then return end

    local ry = math.rad(orbitYaw)
    local rp = math.rad(orbitPitch)
    local cx = orbitPivot.x + orbitRadius * math.cos(rp) * math.cos(ry)
    local cy = orbitPivot.y + orbitRadius * math.cos(rp) * math.sin(ry)
    local cz = orbitPivot.z + orbitRadius * math.sin(rp)

    do

        local probeZ = math.max(cz, orbitPivot.z) + 100.0
        local found, gz = GetGroundZFor_3dCoord(cx, cy, probeZ, false)
        if found then
            local minZ = gz + CAM_MIN_GROUND_CLEARANCE
            if cz < minZ then
                cz = minZ
            end
        end
    end

    do
        local hit, hitPos = camRaycast(orbitPivot, vector3(cx, cy, cz))
        if hit and hitPos then
            local dx = hitPos.x - orbitPivot.x
            local dy = hitPos.y - orbitPivot.y
            local dz = hitPos.z - orbitPivot.z
            local hitDist = math.sqrt(dx*dx + dy*dy + dz*dz)

            local newRadius = clampf(hitDist - CAM_COLLISION_PAD, ORBIT_MIN_RADIUS, ORBIT_MAX_RADIUS)

            if newRadius < orbitRadius then
                orbitRadius = newRadius

                cx = orbitPivot.x + orbitRadius * math.cos(rp) * math.cos(ry)
                cy = orbitPivot.y + orbitRadius * math.cos(rp) * math.sin(ry)
                cz = orbitPivot.z + orbitRadius * math.sin(rp)

                local probeZ = math.max(cz, orbitPivot.z) + 100.0
                local found, gz = GetGroundZFor_3dCoord(cx, cy, probeZ, false)
                if found then
                    local minZ = gz + CAM_MIN_GROUND_CLEARANCE
                    if cz < minZ then cz = minZ end
                end
            end
        end
    end

    SetCamCoord(previewCam, cx, cy, cz)
    PointCamAtCoord(previewCam, orbitPivot.x, orbitPivot.y, orbitPivot.z)
end

local function initOrbitFromCurrentCam(pivot)
    orbitPivot = pivot
    local camPos = GetCamCoord(previewCam)
    local dx, dy, dz = camPos.x - pivot.x, camPos.y - pivot.y, camPos.z - pivot.z
    local r = math.sqrt(dx*dx + dy*dy + dz*dz)
    if r < 0.001 then r = 6.0 end
    orbitRadius = clampf(r, ORBIT_MIN_RADIUS, ORBIT_MAX_RADIUS)
    orbitYaw   = math.deg(math.atan2(dy, dx))
    orbitPitch = math.deg(math.asin(dz / r))
    orbitPitch = clampf(orbitPitch, ORBIT_MIN_PITCH, ORBIT_MAX_PITCH)
    setCamFromOrbit()
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    playerJob = ESX.GetPlayerData().job.name

    ESX.PlayerData = ESX.GetPlayerData()
end)

local BLIP_CAT_PARKING = 60

Citizen.CreateThread(function()

    AddTextEntry("BLIP_CAT_" .. BLIP_CAT_PARKING, "Parking")

    AddTextEntry("BN_SNL_PARKING", "Parking")

    for _, info in pairs(garage) do
        if info.blip == true and not info.assurance then
            info.blip = AddBlipForCoord(info.garagePos)
            SetBlipSprite(info.blip, 357)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.8)
            SetBlipColour(info.blip, 47)
            SetBlipAsShortRange(info.blip, true)
            SetBlipCategory(info.blip, BLIP_CAT_PARKING)
            BeginTextCommandSetBlipName("BN_SNL_PARKING")
            EndTextCommandSetBlipName(info.blip)
        end
    end
end)

GetClosestGarage = function()
    local pCoords = GetEntityCoords(PlayerPedId())
    local closest = nil
    local closestDist = 100.0
    for k, v in pairs(garage) do
        local dist = #(pCoords - v.garagePos)
        if dist < closestDist then
            closestDist = dist
            closest = v
        end
    end
    return closest
end

function GetMaxGarageSlots()
    local ranks = ESX.PlayerData and ESX.PlayerData.rank or {}
    local maxVec = 80
    for _, rankInfo in ipairs(ranks) do
        local name = rankInfo.name and string.lower(tostring(rankInfo.name)) or ""
        if name == "legendary" then
            return 500
        elseif name == "platinium" then
            maxVec = math.max(maxVec, 300)
        elseif name == "diamond" then
            maxVec = math.max(maxVec, 200)
        elseif name == "gold" then
            maxVec = math.max(maxVec, 120)
        end
    end
    return maxVec
end

Citizen.CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local DansUneZone = false
        for k, v in pairs(garage) do
            gTable = v

            if not DansUneZone and not EnAction and not uiVisible and not v.assurance then
                local dst_garage = GetDistanceBetweenCoords(pCoords, gTable.garagePos, true)
                if dst_garage <= 10.0 then
                    DansUneZone = true
                    DrawMarker(23, gTable.garagePos.x, gTable.garagePos.y, gTable.garagePos.z - 0.95, nil, nil, nil, nil,
                        nil, nil, 2.5, 2.5, 2.5, 255, 117, 31, 225, false, false)
                    DrawMarker(36, gTable.garagePos.x, gTable.garagePos.y, gTable.garagePos.z, nil, nil, nil, 0, nil, nil,
                        0.9, 0.9, 0.9, 255, 117, 31, 225, false, false)
                    if dst_garage <= 3.0 then
                        ESX.ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour ouvrir le garage '~y~" ..
                            gTable.name .. "~s~'")
                        if IsControlJustReleased(1, 38) then
                            OpenGarage(nil, v.mosley)
                        end
                    end
                end
            end
        end

        if DansUneZone then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)

local function IsModelAllowedForGarage(modelHash, garageType)
    if not modelHash or not garageType then return false end

    if type(modelHash) == "string" then
        modelHash = GetHashKey(modelHash)
    else
        modelHash = tonumber(modelHash) or modelHash
    end
    garageType = string.lower(tostring(garageType))

    if garageType == "voiture" then
        return IsThisModelACar(modelHash) or IsThisModelABicycle(modelHash) or IsThisModelABike(modelHash) or IsThisModelAQuadbike(modelHash)
    elseif garageType == "boat" then
        return IsThisModelABoat(modelHash) or IsThisModelAJetski(modelHash) or IsThisModelASubmersible(modelHash) or (modelHash == GetHashKey("avisa"))
    elseif garageType == "helico" or garageType == "heli" then
        return IsThisModelAHeli(modelHash) or IsThisModelAPlane(modelHash)
    end

    return false
end

GetRealName = function(model)
    if allVehiclesNames[model] then
        return allVehiclesNames[model]
    end
    return "CARNOUTFOUND"
end

function GetRealName(displayName)
    displayName = displayName:lower():gsub("[_%-]", "")

    if allVehiclesNames[displayName] then
        return allVehiclesNames[displayName]
    end

    for k, v in pairs(allVehiclesNames) do
        local cleanKey = k:lower():gsub("[_%-]", "")
        if cleanKey:find(displayName, 1, true) or displayName:find(cleanKey, 1, true) then
            return v
        end
    end

    return displayName
end

function IsFavoriteVehicle(plate)
    if not plate then return false end
    return GetResourceKvpInt("garage_favorite_" .. plate) == 1
end

RepointOnVehicle = function(data)
    local plate = data

    if lastPreviewPlate ~= nil and lastPreviewPlate == plate then
        return cb(true)
    end

    lastPreviewPlate = plate

    if previewVehicle then
        for k,v in pairs(previewVehicle) do
            DeleteEntity(v)
        end
        previewVehicle = {}
    end

    local closeGarage = GetClosestGarage()
    if not closeGarage then print("erreur de garage") return end
    if not closeGarage.camInfos then print("aucune configuration de caméra effecutée sur ce garage, vous devez faire les coords, les rotations et fov de la caméra") return end

    ESX.TriggerServerCallback("prime:garage:getInfos", function(infos)
        if infos then
            local model = infos.vehicle.model
            if not IsModelAllowedForGarage(model, closeGarage.type) then return end

            local closeGarage = GetClosestGarage()
            if not closeGarage then print("erreur de garage") return end
            if not closeGarage.camInfos then print("aucune configuration de caméra effecutée sur ce garage, vous devez faire les coords, les rotations et fov de la caméra") return end

            local coords = closeGarage.camInfos.vehicleCoords
            local heading = closeGarage.camInfos.vehicleHeading

            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end

            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
            SetVehicleDoorsLocked(veh, 4)
            SetVehicleEngineOn(veh, true, true, false)
            SetVehicleLights(veh, 2)
            FreezeEntityPosition(veh, true)
            SetEntityInvincible(veh, true)
            SetEntityCollision(veh, false, false)

            ESX.Game.SetVehicleProperties(veh, infos.vehicle)
            setupOrbitForVehicle(veh, infos.vehicle.model)

            table.insert(previewVehicle, veh)
        end
    end, plate, closeGarage.type)
end

local _genericVehicleNames = {
    [""] = true, ["voiture"] = true, ["vehicule"] = true, ["véhicule"] = true,
    ["car"] = true, ["vehicle"] = true, ["auto"] = true,
}

local function _prettyVehicleName(model, displayNameTok)
    local nameTok  = displayNameTok or GetDisplayNameFromVehicleModel(model)
    local nameText = GetLabelText(nameTok)
    if not nameText or nameText == "" or nameText == "NULL" then
        nameText = nameTok
    end

    local makeTok  = GetMakeNameFromVehicleModel(model)
    local makeText = nil
    if makeTok and makeTok ~= "" and makeTok ~= "NULL" then
        makeText = GetLabelText(makeTok)
        if not makeText or makeText == "" or makeText == "NULL" then
            makeText = makeTok
        end
    end

    if makeText and makeText ~= "" then
        return makeText .. " " .. nameText
    end
    return nameText
end

local function _buildNuiVehicles(slimList, garageType)
    local out = {}
    if not slimList then return out end
    for k, v in pairs(slimList) do
        local model = v and v.props and v.props.model
        if model and IsModelAllowedForGarage(model, garageType) then
            local displayName = GetDisplayNameFromVehicleModel(model)
            if displayName:lower() == "CARNOTFOUND" or not IsModelValid(model) then
                print("CARNOTFOUND >", model, v.plate)
            else

                local pretty = _prettyVehicleName(model, displayName)
                local custom = v.name and tostring(v.name) or ""
                local label  = pretty
                if custom ~= "" and not _genericVehicleNames[custom:lower()]
                   and custom:lower() ~= pretty:lower() then
                    label = custom
                end

                out[#out + 1] = {
                    model = displayName:lower(),
                    label = label,
                    plate = v.plate,
                    favorite = IsFavoriteVehicle(tostring(v.plate)),
                    category = v.boutique == 1 and "boutique" or "concessionnaires",
                    state = (v.state == 1 or v.state == true),
                    performance = {
                        vitesseMax = ESX.Math.Round(GetVehicleModelEstimatedMaxSpeed(model)),
                        acceleration = ESX.Math.Round(GetVehicleModelAcceleration(model)),
                        frein = ESX.Math.Round(GetVehicleModelMaxBrakingMaxMods(model)),
                        traction = ESX.Math.Round(GetVehicleModelMaxTraction(model)),
                    },
                }
            end
        end
    end
    return out
end

local _currentOpenType = nil

OpenGarage = function(assuranceToggled, mosleyToggled)
    DisplayRadar(false)
    ExecuteCommand("disableHud")

    local closeGarage = GetClosestGarage()
    if not closeGarage then print("erreur de garage") return end
    if not closeGarage.camInfos then print("aucune configuration de caméra effecutée sur ce garage, vous devez faire les coords, les rotations et fov de la caméra") return end

    _currentOpenType = closeGarage.type

    ESX.TriggerServerCallback("zGarage:fetchPlayerVehicles", function(data, status)

        local vehicles = _buildNuiVehicles(data, closeGarage.type)

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openGarage",
            assuranceMenu = assuranceToggled,
            mosley = mosleyToggled,
            data = {
                vehicles = vehicles,
                maxSlots = GetMaxGarageSlots and GetMaxGarageSlots() or 80
            }
        })

        if vehicles[1] and vehicles[1].plate then
            RepointOnVehicle(vehicles[1].plate)
        end

        if previewCam then
            RenderScriptCams(false, true, 0, true, true)
            DestroyCam(previewCam, false)
            previewCam = nil
        end

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, closeGarage.camInfos.coords)
        SetCamRot(cam, closeGarage.camInfos.rotation.x, closeGarage.camInfos.rotation.y, closeGarage.camInfos.rotation.z, 2)

        camPitch = closeGarage.camInfos.rotation.x or 0.0
        camYaw   = closeGarage.camInfos.rotation.z or 0.0

        local baseFov = closeGarage.camInfos.fov or 30.0
        SetCamFov(cam, baseFov)

        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1000, true, true)
        previewCam = cam

        uiVisible = true
    end, closeGarage.type)
end

RegisterNetEvent('garage:vehiclesPushed', function(slim, vtype)
    if not uiVisible then return end
    if not _currentOpenType then return end

    local match = (vtype == _currentOpenType) or (vtype == "other" and _currentOpenType ~= "voiture")
    if not match then return end

    local vehicles = _buildNuiVehicles(slim, _currentOpenType)
    SendNUIMessage({
        action = "updateVehicles",
        data = { vehicles = vehicles }
    })
    if vehicles[1] and vehicles[1].plate then
        RepointOnVehicle(vehicles[1].plate)
    end
end)

CloseGarage = function()
    SendNUIMessage({ action = "closeGarage" })
    SetNuiFocus(false, false)

    if previewVehicle then
        for k,v in pairs(previewVehicle) do
            DeleteEntity(v)
        end
        previewVehicle = {}
    end

    if previewCam then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(previewCam, false)
        previewCam = nil
    end
    lastPreviewPlate = nil

    DisplayRadar(true)
    ExecuteCommand("enableHud")

    uiVisible = false
    _currentOpenType = nil
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)

    if previewVehicle then
        for k,v in pairs(previewVehicle) do
            DeleteEntity(v)
        end
        previewVehicle = {}
    end

    if previewCam then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(previewCam, false)
        previewCam = nil
    end
    lastPreviewPlate = nil

    DisplayRadar(true)
    ExecuteCommand("enableHud")

    uiVisible = false
    _currentOpenType = nil

    cb('ok')
end)

RegisterNUICallback('toggleFavorite', function(data, cb)
    local plate = data.plate
    if not plate or type(plate) ~= "string" then
        return cb({ success = false })
    end

    local key = "garage_favorite_" .. plate
    local current = GetResourceKvpInt(key)

    if current == 1 then
        DeleteResourceKvp(key)
    else
        SetResourceKvpInt(key, 1)
    end

    cb('ok')
end)

RegisterNUICallback('selectVehicle', function(data, cb)
    local plate = data.plate

    if lastPreviewPlate ~= nil and lastPreviewPlate == plate then
        return cb(true)
    end

    lastPreviewPlate = plate

    if previewVehicle then
        for k,v in pairs(previewVehicle) do
            DeleteEntity(v)
        end
        previewVehicle = {}
    end

    local closeGarage = GetClosestGarage()
    if not closeGarage.camInfos then print("aucune configuration de caméra effecutée sur ce garage, vous devez faire les coords, les rotations et fov de la caméra") return end
    if not closeGarage then print("erreur de garage") return end

    ESX.TriggerServerCallback("prime:garage:getInfos", function(infos)
        if infos then
            local model = infos.vehicle.model
            if not IsModelAllowedForGarage(model, closeGarage.type) then return cb(true) end

            SendNUIMessage({
                action  = 'insurancePrice',
                isAssur = infos.assurance,
                plate = plate,
                text    = tostring(150000).."$",
            })

            local coords = closeGarage.camInfos.vehicleCoords
            local heading = closeGarage.camInfos.vehicleHeading

            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end

            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

            SetVehicleDoorsLocked(veh, 4)
            SetVehicleEngineOn(veh, true, true, false)
            FreezeEntityPosition(veh, true)
            SetEntityInvincible(veh, true)
            SetEntityCollision(veh, false, false)

            ESX.Game.SetVehicleProperties(veh, infos.vehicle)

            setupOrbitForVehicle(veh, infos.vehicle.model)

            local minDim, maxDim = GetModelDimensions(infos.vehicle.model)
            local width = maxDim.x - minDim.x
            local length = maxDim.y - minDim.y

            local baseFov = closeGarage.camInfos.fov or 30.0
            local scaleFactor = ((width + length) / 2)

            local dynamicFov = math.max(10.0, math.min(60.0, baseFov + scaleFactor * 5.5))

            local currentFov = GetCamFov(previewCam)
            local duration = 250
            local startTime = GetGameTimer()

            Citizen.CreateThread(function()
                while true do
                    local now = GetGameTimer()
                    local elapsed = now - startTime
                    local progress = elapsed / duration

                    if progress >= 1.0 then
                        SetCamFov(previewCam, dynamicFov)
                        break
                    end

                    local interpolatedFov = currentFov + (dynamicFov - currentFov) * progress
                    SetCamFov(previewCam, interpolatedFov)

                    Wait(0)
                end
            end)

            SetCamActive(previewCam, true)
            RenderScriptCams(true, true, 1000, true, true)

            StartVehicleHorn(veh, 150, GetHashKey("NORMAL"), false)
            Citizen.SetTimeout(300, function()
                StartVehicleHorn(veh, 150, GetHashKey("NORMAL"), false)
            end)

            Citizen.CreateThread(function()
                local a = 2
                for i=1, 5 do
                    SetVehicleLights(veh, a)
                    if a == 2 then
                        a = 4
                    else
                        a = 2
                    end
                    Citizen.Wait(250)
                end
            end)

            table.insert(previewVehicle, veh)
        end
    end, plate, closeGarage.type)

    cb('ok')
end)

local function GetStateCbForGarage(gType)
    gType = gType and string.lower(gType) or ""
    if gType == "voiture" then
        return "zGarage:getstate"
    end
    return "zGarage:getstate2"
end

RegisterNUICallback('spawnVehicle', function(data, cb)
    local plate = data.plate
    local closeGarage = GetClosestGarage()
    ESX.TriggerServerCallback("prime:garage:getInfos", function(vehicleInfos)
        if not vehicleInfos then
            cb({ success = false, message = "Impossible de récupérer les informations du véhicule" })
            return
        end

        local vehicleProps = vehicleInfos.vehicle
        local spawnpoint, heading = LookingForGaragePublicPlace(closeGarage.spawner.pointDeSpawn)

        print(spawnpoint, heading)

        if not IsModelAllowedForGarage(vehicleProps.model, closeGarage.type) then
            cb({ success = false, message = "Véhicule non compatible avec ce garage" })
            return
        end

        if not spawnpoint or not heading then
            cb({ success = false, message = "Aucun point de spawn disponible" })
            return
        end

        ESX.TriggerServerCallback("zGarage:canGetVehicleOut", function(canGetOut)
            if not canGetOut then
                cb({ success = false, message = "Ce véhicule est déjà sorti" })
                return
            end

            local stateCb = GetStateCbForGarage(closeGarage.type)
            ESX.TriggerServerCallback(stateCb, function(state)
                if not state then
                    cb({ success = false, message = "Impossible de récupérer l'état du véhicule" })
                    return
                end

                TriggerServerEvent('eye:veh:authorize', vehicleProps.model, 'garage')
                ESX.Game.SpawnVehicle(vehicleProps.model, spawnpoint, heading, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleEngineOn(vehicle, true, true, false)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetModelAsNoLongerNeeded(vehicleProps.model)
                    if vehicleProps.model == GetHashKey("pe208") then
                        SetVehicleEngineHealth(vehicle, 1000.0)
                        SetVehicleBodyHealth(vehicle, 1000.0)
                    end
                    CloseGarage()
                    TriggerServerEvent('zgg:logsortie', GetPlayerServerId(PlayerId()), vehicleProps.plate)
                end)
            end, plate)
        end, plate)
    end, plate, closeGarage.type)
end)

RegisterNUICallback('abandonVehicle', function(data, cb)
    local closeGarage = GetClosestGarage()
    ESX.TriggerServerCallback("prime:garage:trash", function(trashed, vehiclesRefreshed)
        if trashed then
            Citizen.Wait(1000)
            local vehicles = {}
            for k,v in pairs(vehiclesRefreshed) do
                local model = v.props and v.props.model
                if model and closeGarage and IsModelAllowedForGarage(model, closeGarage.type) then
                    table.insert(vehicles, {
                        model = GetDisplayNameFromVehicleModel(v.props.model):lower(),
                        label = GetDisplayNameFromVehicleModel(v.props.model),
                        plate = v.plate,
                        favorite = IsFavoriteVehicle(tostring(v.plate)),
                        category = v.boutique == 1 and "boutique" or "concessionnaires",
                        performance = {
                            vitesseMax = ESX.Math.Round(GetVehicleModelEstimatedMaxSpeed(v.props.model)),
                            acceleration = ESX.Math.Round(GetVehicleModelAcceleration(v.props.model)),
                            frein = ESX.Math.Round(GetVehicleModelMaxBrakingMaxMods(v.props.model)),
                            traction = ESX.Math.Round(GetVehicleModelMaxTraction(v.props.model)),
                        },
                    })
                end
            end

            SendNUIMessage({
                action = "garage:vehicles",
                data = vehicles
            })

            if vehicles[1] and vehicles[1].plate then
                RepointOnVehicle(vehicles[1].plate)
            end

            cb({ success = true })
        else
            cb({ success = false, message = "Impossible d’abandonner le véhicule" })
        end
    end, data)
    cb('ok')
end)

function setupOrbitForVehicle(veh, modelHash)

    local minDim, maxDim = GetModelDimensions(modelHash)
    local zCenterLocal = (minDim.z + maxDim.z) * 0.5
    local piv = GetOffsetFromEntityInWorldCoords(veh, 0.0, 0.0, zCenterLocal)
    local pivot = vector3(piv.x, piv.y, piv.z)

    initOrbitFromCurrentCam(pivot)

    local width  = maxDim.x - minDim.x
    local length = maxDim.y - minDim.y
    orbitRadius = clampf(2.2 + 0.7 * math.max(width, length), ORBIT_MIN_RADIUS, ORBIT_MAX_RADIUS)

    setCamFromOrbit()
end

RegisterNUICallback('cameraLook', function(data, cb)
    if not previewCam or not DoesCamExist(previewCam) or not orbitPivot then
        if cb then cb({ ok = false }) end
        return
    end

    local dyaw    = tonumber(data and data.yawDelta)    or 0.0
    local dpitch  = tonumber(data and data.pitchDelta)  or 0.0
    local dzoom   = tonumber(data and data.zoomDelta)   or 0.0

    orbitYaw   = wrapYaw(orbitYaw - dyaw)
    orbitPitch = clampf(orbitPitch - dpitch, ORBIT_MIN_PITCH, ORBIT_MAX_PITCH)

    if dzoom ~= 0.0 then
        orbitRadius = clampf(orbitRadius + dzoom, ORBIT_MIN_RADIUS, ORBIT_MAX_RADIUS)
    end

    setCamFromOrbit()
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('repairVehicle', function(data, cb)
    ESX.TriggerServerCallback("prime:garage:repair", function(repaired)
        if repaired then
            cb({ success = true })
        else
            cb({ success = false, message = "Impossible de réparer le véhicule" })
        end
    end, data)
end)

RegisterNUICallback('giveVehicle', function(data, cb)
    data.serverId = data.target
    ESX.TriggerServerCallback("prime:garage:give", function(gived)
        if gived then
            cb({ success = true })
        else
            cb({ success = false, message = "Impossible de donner le véhicule" })
        end
    end, data)
    cb('ok')
end)

RegisterNUICallback('duplicateKeys', function(data, cb)
    ESX.TriggerServerCallback("garage:server:buykey", function(buyedKey)
        if buyedKey then
            cb({ success = true })
        else
            cb({ success = false, message = "Impossible de faire un double de clés sur le véhicule" })
        end
    end, data.plate)
    cb('ok')
end)

local cooldown = 0
RegisterNUICallback('takescreenshot', function(data, cb)
    if cooldown > GetGameTimer() then return end
    cooldown = GetGameTimer() + 2000
    ESX.TriggerServerCallback("garage:server:takescreenshot", function(d)
        exports['screenshot-basic']:requestScreenshotUpload(d, 'files[]', {encoding = "png", quality = 1.0}, function(data)
            local resp = json.decode(data)
            if resp and resp.attachments and #resp.attachments > 0 then
                local image_url = resp.attachments[1].url
                SendNUIMessage({action = "sendUrl", url = image_url})
            end
        end)
    end)
    cb('ok')
end)

RegisterNUICallback('renameVehicle', function(data, cb)
    TriggerServerEvent("zGarage:rename", data.plate, data.newName)
    cb('ok')
end)

RegisterNUICallback('setwebhook', function(data, cb)
    TriggerServerEvent('garage:setWebhookCoffre', data.plate, data.url)
    cb('ok')
end)

RegisterNetEvent("garage:insurance:success")
AddEventHandler("garage:insurance:success", function(data)
    SendNUIMessage({
        action  = 'insureResult',
        plate   = data.plate,
        ok      = true,
        insured = true,
        price   = data.amount,
        currency= data.currency,
        error   = err
    })
end)

RegisterNetEvent('garage:client:usePlaquePerso')
AddEventHandler('garage:client:usePlaquePerso', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if veh == 0 or not DoesEntityExist(veh) then
        ESX.ShowNotification("~r~Aucun véhicule proche")
        return
    end

    AddTextEntry('GARAGE_PLATE_INPUT', "Nouvelle plaque (max 8, lettres/chiffres)")
    DisplayOnscreenKeyboard(1, "GARAGE_PLATE_INPUT", "", "", "", "", "", 8)

    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 1 then
        ESX.ShowNotification("~r~Annulé")
        return
    end

    local result = GetOnscreenKeyboardResult()
    if type(result) ~= "string" then
        ESX.ShowNotification("~r~Plaque invalide")
        return
    end

    local newPlate = result:gsub("%s+", "")
    newPlate = string.upper(newPlate)

    local len = string.len(newPlate)
    if len < 1 or len > 8 then
        ESX.ShowNotification("~r~Max 8 caractères")
        return
    end

    if not newPlate:match("^[A-Z0-9]+$") then
        ESX.ShowNotification("~r~Seulement lettres et chiffres")
        return
    end

    local vehNet = VehToNet(veh)
    TriggerServerEvent('garage:server:applyNewPlate', vehNet, newPlate)
end)
