local inNoClip = false
local saveentity = 0
local devOption = false
local isInSpectate = false

function ForceDeactivateNoclip()
    if inNoClip then
        inNoClip = false
        SetEnabled(false)
        devOption = false
        SetNoClipAttributes(GetPlayerPed(-1), false)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            SetEntityCoordsNoOffset(PlayerPedId(), pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
        end
    end
end

function ToogleNoClip()
    if inNoClip then
        inNoClip = false
        SetEnabled(false)
        SetNoClipAttributes(GetPlayerPed(-1), false)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            SetEntityCoordsNoOffset(PlayerPedId(), pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
        end
        return
    else
        inNoClip = true
        SetEnabled(true)
        Citizen.CreateThread(function()
            while inNoClip do
                CameraLoop()
                SetNoClipAttributes(PlayerPedId(), true)
                Wait(1)
            end
        end)
    end
end

function SetNoClipAttributes(ped, status)
    if status then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)

    else
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, true)
    end
end

local INPUT_SPRINT = 21
local INPUT_CHARACTER_WHEEL = 19
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_COVER = 44
local INPUT_MULTIPLAYER_INFO = 20
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30

_internal_camera = nil
local _internal_isFrozen = false

local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil

local settings = {

    fov = 45.0,

    mouseSensitivityX = 6.5,
    mouseSensitivityY = 6.5,

    normalMoveMultiplier = 1,
    fastMoveMultiplier = 10,
    slowMoveMultiplier = 0.1,

    enableEasing = false,
    easingDuration = 1000
}

local function IsFreecamFrozen()
    return _internal_isFrozen
end

local function SetFreecamFrozen(frozen)
    local frozen = frozen == true
    _internal_isFrozen = frozen
end

local function GetFreecamPosition()
    return _internal_pos
end

local function SetFreecamPosition(x, y, z)
    local pos = vector3(x, y, z)
    SetCamCoord(_internal_camera, pos)

    _internal_pos = pos
end

local function GetFreecamRotation()
    return _internal_rot
end

local function SetFreecamRotation(x, y, z)
    local x = Clamp(x, -90.0, 90.0)
    local y = y % 360
    local z = z % 360
    local rot = vector3(x, y, z)
    local vecX, vecY, vecZ = EulerToMatrix(x, y, z)

    LockMinimapAngle(math.floor(z))
    SetCamRot(_internal_camera, rot)

    _internal_rot = rot
    _internal_vecX = vecX
    _internal_vecY = vecY
    _internal_vecZ = vecZ
end

local function GetFreecamFov()
    return _internal_fov
end

local function SetFreecamFov(fov)
    local fov = Clamp(fov, 0.0, 90.0)
    SetCamFov(_internal_camera, fov)
    _internal_fov = fov
end

local function GetFreecamMatrix()
    return _internal_vecX, _internal_vecY, _internal_vecZ, _internal_pos
end

local function GetFreecamTarget(distance)
    local target = _internal_pos + (_internal_vecY * distance)
    return target
end

local function IsFreecamEnabled()
    return IsCamActive(_internal_camera) == 1
end

local controls = { 12, 13, 14, 15, 16, 17, 18, 19, 50, 85, 96, 97, 99, 115, 180, 181, 198, 261, 262 }
local function LockControls()
    for k, v in pairs(controls) do
        DisableControlAction(0, v, true)
    end
    EnableControlAction(0, 166, true)
end

local function SetFreecamEnabled(enable)
    if enable == IsFreecamEnabled() then
        return
    end

    if enable then
        local pos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot()

        _internal_camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetFreecamFov(settings.fov)
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)
    else
        DestroyCam(_internal_camera)
        ClearFocus()
        UnlockMinimapPosition()
        UnlockMinimapAngle()
    end
    RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

function IsEnabled()
    return IsFreecamEnabled()
end

function SetEnabled(enable)
    return SetFreecamEnabled(enable)
end

function IsFrozen()
    return IsFreecamFrozen()
end

function SetFrozen(frozen)
    return SetFreecamFrozen(frozen)
end

function GetFov()
    return GetFreecamFov()
end

function SetFov(fov)
    return SetFreecamFov(fov)
end

function GetTarget(distance)
    return { table.unpack(GetFreecamTarget(distance)) }
end

function GetPosition()
    return { table.unpack(GetFreecamPosition()) }
end

function SetPosition(x, y, z)
    return SetFreecamPosition(x, y, z)
end

function GetRotation()
    return { table.unpack(GetFreecamRotation()) }
end

function SetRotation(x, y, z)
    return SetFreecamRotation(x, y, z)
end

function GetPitch()
    return GetFreecamRotation().x
end

function GetRoll()
    return GetFreecamRotation().y
end

function GetYaw()
    return GetFreecamRotation().z
end

function GetSpeedMultiplier()
    if IsDisabledControlPressed(0, 180) then
        if settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.5
        elseif settings.normalMoveMultiplier > 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.1
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.01
        end
    elseif IsDisabledControlPressed(0, 181) then
        if settings.normalMoveMultiplier < 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.01
        elseif settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.5
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.1
        end
    end

    if settings.normalMoveMultiplier < 0 then
        settings.normalMoveMultiplier = 0
    end

    return settings.normalMoveMultiplier
end

function CameraLoop()
    if not IsFreecamEnabled() or IsPauseMenuActive() then
        return
    end
    if not IsFreecamFrozen() then
        local vecX, vecY = GetFreecamMatrix()
        local vecZ = vector3(0, 0, 1)
        local pos = GetFreecamPosition()
        local rot = GetFreecamRotation()

        local frameMultiplier = GetFrameTime() * 60
        local speedMultiplier = GetSpeedMultiplier() * frameMultiplier

        local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
        local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)

        local moveWS = GetDisabledControlNormal(0, INPUT_MOVE_UD)
        local moveAD = GetDisabledControlNormal(0, INPUT_MOVE_LR)
        local moveQZ = GetDisabledControlNormalBetween(0, INPUT_COVER, INPUT_MULTIPLAYER_INFO)

        local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
        local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
        local rotY = 0.0

        if not isInSpectate and not KEYBOARDACTIVE then
            pos = pos + (vecX * moveAD * speedMultiplier)
            pos = pos + (vecY * -moveWS * speedMultiplier)
            pos = pos + (vecZ * moveQZ * speedMultiplier)
        end

        if #(pos - GetEntityCoords(GetPlayerPed(-1))) > 20.0 then
            pos = GetEntityCoords(GetPlayerPed(-1))
        end

        rot = vector3(rotX, rotY, rotZ)
        if IsControlJustPressed(0, 38) then
            if devOption then
                devOption = false
            else
                devOption = true
            end
        end

        if devOption then
            UpdateEntityLooking()
        end
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)

        LockControls()
        ClearFocus()
        SetEntityCoordsNoOffset(GetPlayerPed(-1), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
    end
end

function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
    local normal1 = GetDisabledControlNormal(inputGroup, control1)
    local normal2 = GetDisabledControlNormal(inputGroup, control2)
    return normal1 - normal2
end

function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)

    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)

    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end

local function DrawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")

    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

local function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

local function RayCastGamePlayCamera(distance, ignoreEntity)
    if ignoreEntity == nil then ignoreEntity = -1 end
    local cameraRotation = GetCamRot(_internal_camera, 2)
    local cameraCoord = GetCamCoord(_internal_camera)
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x
        , destination.y, destination.z, -1, ignoreEntity, 1))
    return b, c, e
end

function UpdateEntityLooking()
    local hit, pos, entity = RayCastGamePlayCamera(3000, PlayerPedId())

    if hit then
        local pos = GetEntityCoords(entity)
        local entityType = GetEntityType(entity)

        local LiseretColor = { 255, 117, 31 }
        local baseX = 0.85
        local baseY = 0.25
        local baseWidth = 0.15
        local baseHeight = 0.03

        DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3],
            255)
        DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170)

        if entityType == 0 then
            DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~r~Inconnue", true, 0.35, { 255, 255, 255, 255 }, 6, 0)
            SetEntityDrawOutline(saveentity, false)
        else
            if entity ~= saveentity then
                SetEntityDrawOutline(saveentity, false)
                saveentity = entity
            end

            local model = GetEntityModel(entity)
            local entity = entity
            local haveDeleteEntity = false
            local heading = GetEntityHeading(entity)
            local coords = GetEntityCoords(entity)

            if entityType ~= 1 then
                SetEntityDrawOutline(entity, true)
                SetEntityDrawOutlineColor(255, 117, 31, 140)
            end

            if entityType == 1 then
                if IsPedAPlayer(entity) then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~o~Joueur", true, 0.35, { 255, 255, 255, 255 }, 6, 0)
                    haveDeleteEntity = true
                else
                    print("Ped")
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~o~Ped", true, 0.35, { 255, 255, 255, 255 }, 6, 0)
                    haveDeleteEntity = false
                end
            elseif entityType == 2 then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~o~Véhicule", true, 0.35, { 255, 255, 255, 255 }, 6, 0)
                haveDeleteEntity = true
            elseif entityType == 3 then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~o~Objet", true, 0.35, { 255, 255, 255, 255 }, 6, 0)
                haveDeleteEntity = true
            end

            if haveDeleteEntity then
                print("haveDeleteEntity : " ..json.encode(haveDeleteEntity))
                print("model : " ..json.encode(model))
                print("model : " ..json.encode(heading))
                print("model : " ..json.encode(coords))
                DrawRect(baseX, baseY + (0.016 * 2), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.016 * 2) - 0.013, "Modèle: " .. model, true, 0.35, { 255, 255, 255, 255 }, 6
                    , 0)

                DrawRect(baseX, baseY + (0.0215 * 3), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.0215 * 3) - 0.013, "Heading: " .. heading, true, 0.35, { 255, 255, 255, 255 }
                    , 6, 0)

                DrawRect(baseX, baseY + (0.0236 * 4), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.0236 * 4) - 0.013, "Pos: " .. tostring(coords), true, 0.35,
                    { 255, 255, 255, 255 }, 6, 0)

                if entityType == 1 then
                    DrawRect(baseX, baseY + (0.0253 * 5), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0253 * 5) - 0.013, "Touche X = Revive le joueur", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    if IsControlJustReleased(0, 73) then
                        local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

                        TriggerServerEvent("adminmenu:revive", playerServerId)
                    end

                    DrawRect(baseX, baseY + (0.0264 * 6), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0264 * 6) - 0.013, "Touche C = Profil staff du joueur", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    if IsControlJustReleased(0, 26) then
                        local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

                        TriggerEvent("adminmenu:openPlayerProfile", playerServerId)
                    end
                elseif entityType == 2 or entityType == 3 then
                    DrawRect(baseX, baseY + (0.0253 * 5), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0253 * 5) - 0.013, "Touche X = Delete entité", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    if IsControlJustReleased(0, 73) then
                        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
                        DeleteEntity(entity)
                        SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
                    end
                end

                if entityType  == 2 then
                    DrawRect(baseX, baseY + (0.0264 * 6), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0264 * 6) - 0.013, "Touche R = Réparer véhicule", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    if IsControlJustReleased(0, 45) then
                        local driver, driverId = nil, nil
                        driver = GetPedInVehicleSeat(entity, -1)
                        local vehicle = entity
                        NetworkRequestControlOfEntity(entity)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                        SetVehicleUndriveable(vehicle, false)
                        SetVehicleEngineOn(vehicle, true, true)
                        SetVehicleEngineHealth(vehicle, 700.0)
                        SetVehiclePetrolTankHealth(vehicle, 700.0)
                        SetVehicleEngineHealth(vehicle, 1000.0)
                        SetVehiclePetrolTankHealth(vehicle, 1000.0)
                        SetVehicleDoorShut(vehicle, 4, false, false)
                        if driver ~= nil then
                            driverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
                            TriggerServerEvent('cn5:repairVehicle', driverId)
                        end
                    end
                end

                if IsControlJustPressed(0, 38) then
                    TriggerEvent("addToCopy",
                        "{hash = " ..
                        model .. ", pos = vector4(" .. coords.x .. ", " .. coords.y ..
                        ", " .. coords.z .. ", " .. heading .. ")},")
                end
            end
        end
    end
end

AddEventHandler("adminmenu:getCamera", function (cb)
    cb(_internal_camera)
end)

AddEventHandler("adminmenu:client:SetSpectateStatus", function(stats, pos, id)
    isInSpectate = stats
    idSpectate = id
    if stats then
        if pos ~= nil then
            SetFreecamPosition(pos.x, pos.y, pos.z)
        end
    end
end)
