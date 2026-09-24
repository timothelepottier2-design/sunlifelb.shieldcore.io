local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'charcreator', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'charcreator', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('charcreator/' .. name, cb)
end

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local RES_NAME = GetCurrentResourceName()

local CHAR_CREATOR_POS = vector3(-894.438782, -372.117249, 83.177873)
local CHAR_CREATOR_HEADING = 117.41445922852
local SPAWN_AFTER_CREATOR = vector3(-1194.314331, -176.312271, 38.424688)
local SPAWN_AFTER_CREATOR_HEADING = 150.11642456055

local POST_CREATOR_BLIP_COORDS = vector3(232.468964, 366.915405, 106.099197)
local postCreatorBlip = nil

local function addPostCreatorBlip()
    if postCreatorBlip and DoesBlipExist(postCreatorBlip) then return end

    AddTextEntry("BN_SNL_CC_AUTOECOLE", "Auto-école")

    postCreatorBlip = AddBlipForCoord(POST_CREATOR_BLIP_COORDS.x, POST_CREATOR_BLIP_COORDS.y, POST_CREATOR_BLIP_COORDS.z)
    SetBlipSprite(postCreatorBlip, 545)
    SetBlipColour(postCreatorBlip, 47)
    SetBlipScale(postCreatorBlip, 0.95)
    SetBlipAsShortRange(postCreatorBlip, false)

    SetBlipRoute(postCreatorBlip, true)
    SetBlipRouteColour(postCreatorBlip, 47)

    BeginTextCommandSetBlipName("BN_SNL_CC_AUTOECOLE")
    EndTextCommandSetBlipName(postCreatorBlip)
end

local open = false
local cam, camMode

local headingLock, freezeThread

local cam = nil
local camPositions = {

    [1] = { 0.9,  0.65,  0.65 },
    [2] = { 2.0,   0.0,   0.0 },
    [3] = { 1.0,  -0.9,  -0.9 },
}

local isDraggingCam = false
local dragLastX, dragLastY = 0.0, 0.0
local camAngleX = 0.0
local camAngleY = 0.0
local camDistance = 2.0
local camTarget = nil
local lastMouseMoveTime = 0
local dragTimeoutMs = 500
local defaultFov = 50.0

function ResetAllCharacteristics(gender)
    local isFemale = tostring(gender) == 'female'
    local sexModel = isFemale and 'mp_f_freemode_01' or 'mp_m_freemode_01'

    TriggerEvent('skinchanger:change', 'skin', 0)
    TriggerEvent('skinchanger:change', 'face', 0)

    local base = {
        sex = sexModel,
        face = 0, skin = 0,
        mom = 21, dad = 0,
        face_md_weight = 50.0, skin_md_weight = 50.0,
        hair_1 = 0, hair_2 = 0, hair_color_1 = 0, hair_color_2 = 0,
        eyebrows_1 = 0, eyebrows_2 = 0.0, eyebrows_3 = 0,
        beard_1 = 0, beard_2 = 0.0, beard_3 = 0, beard_4 = 0,
        chest_1 = 0, chest_2 = 0.0, chest_3 = 0,
        age_1 = 0, age_2 = 0.0,
        complexion_1 = 0, complexion_2 = 0.0,
        sun_1 = 0, sun_2 = 0.0,
        moles_1 = 0, moles_2 = 0.0,
        bodyb_1 = 0, bodyb_2 = 0.0, bodyb_3 = 0, bodyb_4 = 0.0,
        makeup_1 = 0, makeup_2 = 0.0, makeup_3 = 0, makeup_4 = 0,
        lipstick_1 = 0, lipstick_2 = 0.0, lipstick_3 = 0, lipstick_4 = 0,
        blush_1 = 0, blush_2 = 0.0, blush_3 = 0,
        eye_color = 0,
        tshirt_1 = 15, tshirt_2 = 0,
        torso_1 = 15, torso_2 = 0,
        arms = 15, arms_2 = 0,
        pants_1 = isFemale and 15 or 21, pants_2 = 0,
        shoes_1 = isFemale and 35 or 34, shoes_2 = 0,
        bproof_1 = 0, bproof_2 = 0,
        bags_1 = 0, bags_2 = 0,
        chain_1 = 0, chain_2 = 0,
        decals_1 = 0, decals_2 = 0,
        mask_1 = 0, mask_2 = 0,
        watches_1 = -1, watches_2 = 0,
        bracelets_1 = -1, bracelets_2 = 0,
        glasses_1 = -1, glasses_2 = -1,
        helmet_1 = -1, helmet_2 = 0,
        ears_1 = -1, ears_2 = 0
    }
    for k, v in pairs(base) do
        TriggerEvent('skinchanger:change', k, v)
    end
    local faceFeatures = {
        'nose_1','nose_2','nose_3','nose_4','nose_5','nose_6',
        'eyebrows_5','eyebrows_6',
        'cheeks_1','cheeks_2','cheeks_3',
        'eye_squint',
        'lip_thickness',
        'jaw_1','jaw_2',
        'chin_1','chin_2','chin_3','chin_4',
        'neck_thickness',
        'chin_width','chin_height','chin_hole','chin_lenght'
    }
    for _, k in ipairs(faceFeatures) do
        TriggerEvent('skinchanger:change', k, 0)
    end
end

local function _resetAllScriptCams()
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    Wait(0)
end

local function _applyCamPosition(targetCam)
    local offsetX = camDistance * math.cos(math.rad(camAngleY)) * math.sin(math.rad(camAngleX))
    local offsetY = camDistance * math.cos(math.rad(camAngleY)) * math.cos(math.rad(camAngleX))
    local offsetZ = camDistance * math.sin(math.rad(camAngleY))

    SetCamCoord(targetCam, camTarget.x + offsetX, camTarget.y - offsetY, camTarget.z + offsetZ)
    PointCamAtCoord(targetCam, camTarget.x, camTarget.y, camTarget.z)
end

local function _spawnCamAt(index)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local pos = camPositions[index]; if not pos then return end

    camTarget   = vector3(coords.x, coords.y, coords.z + pos[3])
    camDistance = pos[1]
    camAngleX   = heading + 180.0
    camAngleY   = 0.0

    if not cam then
        _resetAllScriptCams()
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        _applyCamPosition(cam)
        SetCamFov(cam, defaultFov)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
    else
        local newCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        _applyCamPosition(newCam)
        SetCamFov(newCam, defaultFov)
        SetCamActiveWithInterp(newCam, cam, 1000, true, true)
        cam = newCam
    end
end

local function startDragCam(distance)
    if not camTarget then camTarget = GetEntityCoords(PlayerPedId()) end
    if distance then camDistance = distance end
    isDraggingCam = true
    dragLastX = GetControlNormal(0, 239)
    dragLastY = GetControlNormal(0, 240)
    lastMouseMoveTime = GetGameTimer()
end

local function updateDragCam()
    if not cam or not isDraggingCam then return end

    local mouseX = GetControlNormal(0, 239)
    local mouseY = GetControlNormal(0, 240)
    local dx = (mouseX - dragLastX) * 180.0
    local dy = (mouseY - dragLastY) * 90.0

    if math.abs(dx) > 0.001 or math.abs(dy) > 0.001 then
        lastMouseMoveTime = GetGameTimer()
    end
    if not IsDisabledControlPressed(0, 24) then
        lastMouseMoveTime = 0
    end

    dragLastX, dragLastY = mouseX, mouseY

    camAngleX = camAngleX - dx
    camAngleY = math.max(-89.0, math.min(89.0, camAngleY + dy))

    _applyCamPosition(cam)
    SetCamFov(cam, defaultFov)
end

local function stopDragCam()
    isDraggingCam = false
end

local camDragThread
local function startCamDragThread()
    if camDragThread then return end
    camDragThread = true
    CreateThread(function()
        while open do

            if IsDisabledControlPressed(0, 24) then
                if not isDraggingCam then startDragCam() end
                updateDragCam()
            else
                if isDraggingCam then stopDragCam() end
            end
            Wait(0)
        end
        stopDragCam()
        camDragThread = nil
    end)
end

function destroyCam()
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
end

function setCam(mode)

    local idx = 1
    if mode == 'body'  then idx = 2
    elseif mode == 'shoes' then idx = 3
    end
    _spawnCamAt(idx)
    startCamDragThread()
end

local WearsData = {
    ["casual1"] = {
        [GetHashKey("mp_m_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 171, ['torso_2'] = 0,
            ['arms'] = 1,
            ['pants_1'] = 0, ['pants_2'] = 1,
            ['shoes_1'] = 8, ['shoes_2'] = 2,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
        },
        [GetHashKey("mp_f_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 2, ['tshirt_2'] = 0,
            ['torso_1'] = 78, ['torso_2'] = 7,
            ['arms'] = 5,
            ['pants_1'] = 74, ['pants_2'] = 1,
            ['shoes_1'] = 11, ['shoes_2'] = 3,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = -1,
        },
    },
    ["business1"] = {
        [GetHashKey("mp_m_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 31, ['tshirt_2'] = 0,
            ['torso_1'] = 32, ['torso_2'] = 0,
            ['arms'] = 12,
            ['pants_1'] = 10, ['pants_2'] = 0,
            ['shoes_1'] = 10, ['shoes_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
        },
        [GetHashKey("mp_f_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 2, ['tshirt_2'] = 0,
            ['torso_1'] = 105, ['torso_2'] = 2,
            ['arms'] = 0,
            ['pants_1'] = 65, ['pants_2'] = 2,
            ['shoes_1'] = 6, ['shoes_2'] = 1,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = -1,
        },
    },
    ["street1"] = {
        [GetHashKey("mp_m_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 5, ['torso_2'] = 0,
            ['arms'] = 5,
            ['pants_1'] = 16, ['pants_2'] = 2,
            ['shoes_1'] = 5, ['shoes_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
        },
        [GetHashKey("mp_f_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 2, ['tshirt_2'] = 0,
            ['torso_1'] = 169, ['torso_2'] = 0,
            ['arms'] = 4,
            ['pants_1'] = 25, ['pants_2'] = 0,
            ['shoes_1'] = 1, ['shoes_2'] = 1,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = -1,
        },
    },
    ["sport1"] = {
        [GetHashKey("mp_m_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 354, ['torso_2'] = 17,
            ['arms'] = 0,
            ['pants_1'] = 17, ['pants_2'] = 2,
            ['shoes_1'] = 6, ['shoes_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = 0,
        },
        [GetHashKey("mp_f_freemode_01")] = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 57, ['tshirt_2'] = 0,
            ['torso_1'] = 373, ['torso_2'] = 8,
            ['arms'] = 0,
            ['pants_1'] = 14, ['pants_2'] = 9,
            ['shoes_1'] = 1, ['shoes_2'] = 1,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['glasses_1'] = -1, ['glasses_2'] = -1,
        },
    },
}

function startFreezeThread()
    if freezeThread then return end
    freezeThread = true
    CreateThread(function()
        local lastCheck = 0
        while open do
            local ped = PlayerPedId()

    		FreezeEntityPosition(PlayerPedId(), true)

            DisableControlAction(0, 30,  true)
            DisableControlAction(0, 31,  true)
            DisableControlAction(0, 32,  true)
            DisableControlAction(0, 33,  true)
            DisableControlAction(0, 34,  true)
            DisableControlAction(0, 35,  true)
            DisableControlAction(0, 21,  true)
            DisableControlAction(0, 22,  true)
            DisableControlAction(0, 23,  true)
            DisableControlAction(0, 24,  true)
            DisableControlAction(0, 25,  true)
            DisableControlAction(0, 37,  true)
            DisableControlAction(0, 44,  true)
            DisableControlAction(0, 45,  true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 1,   true)
            DisableControlAction(0, 2,   true)
            DisableControlAction(0, 106, true)

            if headingLock then SetEntityHeading(ped, headingLock) end

            local now = GetGameTimer()
            if now - lastCheck > 500 then
                if not IsEntityPlayingAnim(ped, FREEZE_DICT, FREEZE_NAME, 3) then
                    playFrozenIdle(ped)
                else

                    SetEntityAnimSpeed(ped, FREEZE_DICT, FREEZE_NAME, 0.0)
                end
                lastCheck = now
            end

            Wait(0)
        end
    	FreezeEntityPosition(PlayerPedId(), false)
        freezeThread = nil
    end)
end

function lockFace(ped, on)
    if on then
        SetPedCanPlayAmbientAnims(ped, false)
        SetPedCanPlayAmbientBaseAnims(ped, false)
        SetPedCanPlayGestureAnims(ped, false)
        SetPedCanHeadIk(ped, false)
        SetPedCanTorsoIk(ped, false)
        SetPedCanUseAutoConversationLookat(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local dict = IsPedModel(ped, `mp_f_freemode_01`) and "facials@gen_female@base" or "facials@gen_male@base"
        SetFacialIdleAnimOverride(ped, "mood_dead", dict)
    else
        ClearFacialIdleAnimOverride(ped)
        TaskClearLookAt(ped)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanPlayAmbientBaseAnims(ped, true)
        SetPedCanPlayGestureAnims(ped, true)
        SetPedCanHeadIk(ped, true)
        SetPedCanTorsoIk(ped, true)
        SetPedCanUseAutoConversationLookat(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, false)
    end
end

local FREEZE_DICT = "anim@heists@heist_corona@team_idles@male_a"
local FREEZE_NAME = "idle"

function playFrozenIdle(ped)
    RequestAnimDict(FREEZE_DICT)
    while not HasAnimDictLoaded(FREEZE_DICT) do Wait(0) end

    TaskPlayAnim(ped, FREEZE_DICT, FREEZE_NAME, 0.0, 0.0, -1, 1, 0.0, false, false, false)
    Wait(50)

    SetEntityAnimCurrentTime(ped, FREEZE_DICT, FREEZE_NAME, 0.0)
    SetEntityAnimSpeed(ped, FREEZE_DICT, FREEZE_NAME, 0.0)
end

function setFocus(on)
    open = on
    SetNuiFocus(on, on)
    SetNuiFocusKeepInput(false)
    DisplayRadar(not on)

    local ped = PlayerPedId()
    if on then
        FreezeEntityPosition(ped, true)
        headingLock = GetEntityHeading(ped)

        ClearPedTasksImmediately(ped)
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        SetPedCanRagdoll(ped, false)

        lockFace(ped, true)
        startFreezeThread()

        startCamDragThread()
    else
        headingLock = nil
        lockFace(ped, false)
        SetPedCanRagdoll(ped, true)
        FreezeEntityPosition(ped, false)
    end
end

function ResetCreationSkin(gender)
    local isFemale = (tostring(gender) == 'female')
    local sexModel = isFemale and 'mp_f_freemode_01' or 'mp_m_freemode_01'

    TriggerEvent('skinchanger:change', 'skin', 0)
    TriggerEvent('skinchanger:change', 'face', 0)

    local base = {

        sex = sexModel,

        face = 0, skin = 0,
        mom = 21, dad = 0,
        face_md_weight = 50.0,
        skin_md_weight = 50.0,

        hair_1 = 0, hair_2 = 0,
        hair_color_1 = 0, hair_color_2 = 0,

        eyebrows_1 = 0, eyebrows_2 = 0.0, eyebrows_3 = 0,
        beard_1 = 0,    beard_2 = 0.0,    beard_3 = 0, beard_4 = 0,
        chest_1 = 0,    chest_2 = 0.0,    chest_3 = 0,

        age_1 = 0,        age_2 = 0.0,
        complexion_1 = 0, complexion_2 = 0.0,
        sun_1 = 0,        sun_2 = 0.0,
        moles_1 = 0,      moles_2 = 0.0,
        bodyb_1 = 0,      bodyb_2 = 0.0,
        bodyb_3 = 0,      bodyb_4 = 0.0,
        makeup_1 = 0,     makeup_2 = 0.0,   makeup_3 = 0, makeup_4 = 0,
        lipstick_1 = 0,   lipstick_2 = 0.0, lipstick_3 = 0, lipstick_4 = 0,
        blush_1 = 0,      blush_2 = 0.0,    blush_3 = 0,
        eye_color = 0,

        tshirt_1 = 15, tshirt_2 = 0,
        torso_1  = 15, torso_2  = 0,
        arms     = 15, arms_2    = 0,
        pants_1  = isFemale and 15 or 21, pants_2 = 0,
        shoes_1  = isFemale and 35 or 34, shoes_2 = 0,
        bproof_1 = 0, bproof_2 = 0,
        bags_1   = 0, bags_2   = 0,
        chain_1  = 0, chain_2  = 0,
        decals_1 = 0, decals_2 = 0,
        mask_1   = 0, mask_2   = 0,

        watches_1 = -1, watches_2 = 0,
        bracelets_1 = -1, bracelets_2 = 0,
        glasses_1 = -1, glasses_2 = -1,
        helmet_1 = -1, helmet_2 = 0,
        ears_1 = -1, ears_2 = 0,
    }

    local faceFeatures = {
        'nose_1','nose_2','nose_3','nose_4','nose_5','nose_6',
        'eyebrows_5','eyebrows_6',
        'cheeks_1','cheeks_2','cheeks_3',
        'eye_squint',
        'lip_thickness',
        'jaw_1','jaw_2',
        'chin_1','chin_2','chin_3','chin_4',
        'neck_thickness',

        'chin_width','chin_height','chin_hole','chin_lenght'
    }

    for k,v in pairs(base) do
        TriggerEvent('skinchanger:change', k, v)
    end
    for _,k in ipairs(faceFeatures) do
        TriggerEvent('skinchanger:change', k, 0)
    end
end

RegisterNetEvent('cc:openCreator', function()
    TriggerServerEvent("creator:start")
    DisplayRadar(false)
    ExecuteCommand("disableHud")
    TriggerEvent("statushud:all:hide")

    ResetAllCharacteristics('male')

    SetEntityCoords(PlayerPedId(), CHAR_CREATOR_POS.x, CHAR_CREATOR_POS.y, CHAR_CREATOR_POS.z, false, false, false, false)
    SetEntityHeading(PlayerPedId(), CHAR_CREATOR_HEADING)
    FreezeEntityPosition(PlayerPedId(), true)

    setFocus(true)
    setCam('head')

    SendNUIMessage({ action = 'openCreator' })
    SetNuiFocus(true, true)
end)

function updateSkin(mutator)
	TriggerEvent('skinchanger:getSkin', function(skin)
		mutator(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

function pctToOverlay(op)
	op = math.floor((tonumber(op) or 0) / 100.0 + 0.5)
	if op < 0 then op = 0 end
	if op > 100 then op = 100 end
	return op
end

function clampi(v, a, b)
	v = tonumber(v) or a
	if v < a then v = a end
	if v > b then v = b end
	return math.floor(v + 0.5)
end

RegisterNUICallback('closeUI', function(_, cb)
    setFocus(false)
    destroyCam()
    cb({ ok = true })
end)

RegisterNUICallback('setCamera', function(data, cb)
	local mode = (data and data.mode) or 'head'
	setCam(mode)
	cb({ ok = true })
end)

RegisterNUICallback('skinChange', function(data, cb)
	local action = data and data.action or nil

	if action == 'sex' then
		local g = tostring(data.gender or 'male')
		if g == 'female' then
			TriggerEvent("skinchanger:change", "sex", "mp_f_freemode_01")
			TriggerEvent("skinchanger:change", "glasses_1", -1)
			TriggerEvent("skinchanger:change", "glasses_2", -1)
		else
			TriggerEvent("skinchanger:change", "sex", "mp_m_freemode_01")
		end
	end

	if action == "parent_mom" then
		TriggerEvent("skinchanger:change", "mom", data.id)
	end
	if action == "parent_dad" then
		TriggerEvent("skinchanger:change", "dad", data.id)
	end

	if action == "blend" then
		local faceMix = (data.faceMix or 50)/1.0
		local skinMix = (data.skinMix or 50)/1.0
		TriggerEvent("skinchanger:change", "face_md_weight", faceMix)
		TriggerEvent("skinchanger:change", "skin_md_weight", skinMix)
	end

	if action == "hair" then
		if data.style     then TriggerEvent("skinchanger:change", "hair_1",      data.style) end
		if data.primary   then TriggerEvent("skinchanger:change", "hair_color_1",data.primary) end
		if data.secondary then TriggerEvent("skinchanger:change", "hair_color_2",data.secondary) end
	end

	if action == "brows" then
		if data.style   then TriggerEvent("skinchanger:change", "eyebrows_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "eyebrows_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "eyebrows_3", data.primary) end
	end

	if action == "beard" then
		if data.style   then TriggerEvent("skinchanger:change", "beard_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "beard_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "beard_3", data.primary) end
	end

	if action == "chest" then

        TriggerEvent('skinchanger:getSkin', function(skin)

            TriggerEvent('skinchanger:change', 'tshirt_1', 15)
            TriggerEvent('skinchanger:change', 'tshirt_2', 0)

            TriggerEvent('skinchanger:change', 'torso_1', 15)
            TriggerEvent('skinchanger:change', 'torso_2', 0)

            if skin.sex == 0 then
                TriggerEvent('skinchanger:change', 'arms', 15)
            else
                TriggerEvent('skinchanger:change', 'arms', 15)
            end
            TriggerEvent('skinchanger:change', 'arms_2', 0)

            for _,k in ipairs({'bproof_1','bproof_2','bags_1','bags_2','decals_1','decals_2'}) do
                TriggerEvent('skinchanger:change', k, 0)
            end
        end)

		if data.style   then TriggerEvent("skinchanger:change", "chest_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "chest_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "chest_3", data.primary) end
	end

	if action == "eyes" then
        TriggerEvent("skinchanger:change", "eye_color", data.color)
	end

	if action == "aging" then
		if data.style   then TriggerEvent("skinchanger:change", "age_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "age_2", tonumber(data.opacity) / 10.0) end
	end

	if action == "complexion" then
		if data.style   then TriggerEvent("skinchanger:change", "complexion_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "complexion_2", tonumber(data.opacity) / 10.0) end
	end

	if action == "sunDamage" then
		if data.style   then TriggerEvent("skinchanger:change", "sun_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "sun_2", tonumber(data.opacity) / 10.0) end
	end

	if action == "moles" then
		if data.style   then TriggerEvent("skinchanger:change", "moles_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "moles_2", tonumber(data.opacity) / 10.0) end
	end

	if action == "bodyBlemishes" then
		if data.style   then TriggerEvent("skinchanger:change", "bodyb_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "bodyb_2", tonumber(data.opacity) / 10.0) end
	end

	if action == "bodyBlemishes2" then
		if data.style   then TriggerEvent("skinchanger:change", "bodyb_3", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "bodyb_4", tonumber(data.opacity) / 10.0) end
	end

	if action == "makeup" then
		if data.style   then TriggerEvent("skinchanger:change", "makeup_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "makeup_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "makeup_3", data.primary) end
		if data.secondary then TriggerEvent("skinchanger:change", "makeup_4", data.secondary) end
	end

	if action == "lipstick" then
		if data.style   then TriggerEvent("skinchanger:change", "lipstick_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "lipstick_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "lipstick_3", data.primary) end
		if data.secondary then TriggerEvent("skinchanger:change", "lipstick_4", data.secondary) end
	end

	if action == "blush" then
		if data.style   then TriggerEvent("skinchanger:change", "blush_1", data.style) end
		if data.opacity ~= nil then TriggerEvent("skinchanger:change", "blush_2", tonumber(data.opacity) / 10.0) end
		if data.primary then TriggerEvent("skinchanger:change", "blush_3", data.primary) end
	end

	if action == "faceFeature" then
		if data.index == 0 then TriggerEvent("skinchanger:change", "nose_1", (data.scale * 10)) end
		if data.index == 1 then TriggerEvent("skinchanger:change", "nose_2", (data.scale * 10)) end
		if data.index == 2 then TriggerEvent("skinchanger:change", "nose_3", (data.scale * 10)) end
		if data.index == 3 then TriggerEvent("skinchanger:change", "nose_4", (data.scale * 10)) end
		if data.index == 4 then TriggerEvent("skinchanger:change", "nose_5", (data.scale * 10)) end
		if data.index == 5 then TriggerEvent("skinchanger:change", "nose_6", (data.scale * 10)) end

		if data.index == 6 then TriggerEvent("skinchanger:change", "eyebrows_5", (data.scale * 10)) end
		if data.index == 7 then TriggerEvent("skinchanger:change", "eyebrows_6", (data.scale * 10)) end

		if data.index == 8 then TriggerEvent("skinchanger:change", "cheeks_1", (data.scale * 10)) end
		if data.index == 9 then TriggerEvent("skinchanger:change", "cheeks_2", (data.scale * 10)) end
		if data.index == 10 then TriggerEvent("skinchanger:change", "cheeks_3", (data.scale * 10)) end

		if data.index == 11 then TriggerEvent("skinchanger:change", "eye_squint", (data.scale * 10)) end

		if data.index == 12 then TriggerEvent("skinchanger:change", "lip_thickness", (data.scale * 10)) end
		if data.index == 13 then TriggerEvent("skinchanger:change", "jaw_1", (data.scale * 10)) end
		if data.index == 14 then TriggerEvent("skinchanger:change", "jaw_2", (data.scale * 10)) end
		if data.index == 15 then TriggerEvent("skinchanger:change", "chin_1", (data.scale * 10)) end
		if data.index == 16 then TriggerEvent("skinchanger:change", "chin_3", (data.scale * 10)) end
		if data.index == 17 then TriggerEvent("skinchanger:change", "chin_4", (data.scale * 10)) end
		if data.index == 18 then TriggerEvent("skinchanger:change", "chin_2", (data.scale * 10)) end
		if data.index == 19 then TriggerEvent("skinchanger:change", "neck_thickness", (data.scale * 10)) end
	end
end)

RegisterNUICallback('createCharacter', function(payload, cb)
    DoScreenFadeOut(0)
    while not IsScreenFadedOut() do Wait(0) end

    TriggerServerEvent("creator:finish", {
        prenom  = payload.firstName,
        nom     = payload.lastName,
        age     = payload.birth,
        taille  = payload.height,
        sexe    = payload.gender == "male" and "Homme" or "Femme",
        spawnId = payload.confirmation.spawn.id,
    })

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)

    setFocus(false)
    destroyCam()

    if GetResourceState('sCore') == 'started' then
        exports["sCore"]:setFreecamBypass(true)
    end

    cb({ ok = true })
end)

local function applyOutfitFromWears(outfitId)
    if type(outfitId) ~= "string" or outfitId == "" then
        print("^1[Creator] outfitId invalide^0")
        return false
    end

    local data = WearsData[outfitId]
    if not data then
        print(("^1[Creator] WearsData introuvable pour '%s'^0"):format(outfitId))
        return false
    end

    local ped   = PlayerPedId()
    local model = GetEntityModel(ped)

    local set = data[model]
    if not set then
        if IsPedModel(ped, `mp_f_freemode_01`) then
            set = data[GetHashKey("mp_f_freemode_01")]
        else
            set = data[GetHashKey("mp_m_freemode_01")]
        end
    end

    if not set then
        print(("^1[Creator] Aucun mapping tenue pour le modèle %s^0"):format(tostring(model)))
        return false
    end

    updateSkin(function(skin)
        for k, v in pairs(set) do
            skin[k] = v
        end
    end)

    return true
end

RegisterNUICallback('outfitSelected', function(data, cb)
    local outfitId = data and data.id and tostring(data.id) or nil
    local ok = false
    if outfitId then
        ok = applyOutfitFromWears(outfitId)
        if ok then
            print(("[Creator] Tenue appliquée: %s"):format(outfitId))
        end
    end
    cb({ ok = ok })
end)

AddEventHandler('onResourceStop', function(res)
	if res ~= RES_NAME then return end
	destroyCam()
	markers = {}
	pathMarkerBatchIndex = 0
	if open then setFocus(false) end
	if postCreatorBlip and DoesBlipExist(postCreatorBlip) then
		RemoveBlip(postCreatorBlip)
		postCreatorBlip = nil
	end
end)

local baseCoords = SPAWN_AFTER_CREATOR

Citizen.CreateThread(function()
    while true do
        local running = false

        if #(GetEntityCoords(PlayerPedId()) - baseCoords) < 30.0 then
            running = true
            ESX.Game.Utils.DrawText3D(vector3(baseCoords.x, baseCoords.y, baseCoords.z + 0.80), "Bienvenue sur SunLifeRP !", 1.5, 4)
            ESX.Game.Utils.DrawText3D(vector3(baseCoords.x, baseCoords.y, baseCoords.z + 0.60), "Discord SunLifeRP: discord.gg/sunliferpfa", 1.5, 4)
        end

        if running then
            Citizen.Wait(0)
        else
            Citizen.Wait(2500)
        end
    end
end)

local markers = {}

local PATH_MARKER_ACTIVATE_DIST = 2.0
local PATH_MARKERS_CENTER = SPAWN_AFTER_CREATOR
local PATH_MARKERS_RADIUS = 120.0

local pathMarkerBatches = {
    {
        { pos = vector3(-1194.789062, -177.062607, 39.324688), heading = 147.52755737305 },
        { pos = vector3(-1195.370239, -177.961349, 39.324688), heading = 149.91186523438 },
        { pos = vector3(-1196.076782, -178.983719, 39.324711), heading = 130.97297668457 },
        { pos = vector3(-1196.788940, -179.632706, 39.324745), heading = 134.68949890137 },
        { pos = vector3(-1197.722900, -180.561234, 39.324806), heading = 134.75801086426 },
        { pos = vector3(-1198.687622, -181.521561, 39.324886), heading = 134.51345825195 },
        { pos = vector3(-1199.702515, -182.466080, 39.324917), heading = 133.41836547852 },
        { pos = vector3(-1200.527100, -183.307693, 39.324917), heading = 136.79325866699 },
        { pos = vector3(-1201.403809, -184.255966, 39.324917), heading = 137.24203491211 },
    },
    {
        { pos = vector3(-1201.355469, -185.921097, 39.324890), heading = 172.50891113281 },
        { pos = vector3(-1201.616699, -187.250259, 39.324883), heading = 161.87858581543 },
        { pos = vector3(-1202.064453, -188.449875, 39.324783), heading = 159.2017364502 },
        { pos = vector3(-1202.602295, -189.677917, 39.324787), heading = 155.33740234375 },
        { pos = vector3(-1203.223511, -190.980072, 39.324867), heading = 153.62860107422 },
        { pos = vector3(-1203.889282, -192.166748, 39.324928), heading = 149.30364990234 },
        { pos = vector3(-1204.648682, -193.305206, 39.324928), heading = 140.80389404297 },
        { pos = vector3(-1205.545532, -194.281998, 39.324932), heading = 134.44052124023 },
        { pos = vector3(-1206.374878, -194.995575, 39.324932), heading = 124.00173950195 },
        { pos = vector3(-1207.240234, -195.537949, 39.324932), heading = 116.92783355713 },
    },
    {
        { pos = vector3(-1208.210449, -194.948242, 39.324932), heading = 49.898635864258 },
        { pos = vector3(-1208.974487, -194.341049, 39.324932), heading = 52.540714263916 },
        { pos = vector3(-1209.784302, -193.723892, 39.324932), heading = 53.284355163574 },
        { pos = vector3(-1210.543335, -193.166870, 39.324924), heading = 54.040477752686 },
        { pos = vector3(-1211.436890, -192.531845, 39.324886), heading = 56.607849121094 },
        { pos = vector3(-1212.258423, -192.026352, 39.324833), heading = 57.612083435059 },
        { pos = vector3(-1213.210571, -191.445648, 39.325390), heading = 60.763366699219 },
        { pos = vector3(-1214.131836, -190.952515, 39.325390), heading = 62.703285217285 },
        { pos = vector3(-1215.006958, -190.501312, 39.321625), heading = 62.900062561035 },
    },
}

local pathMarkerBatchIndex = 0

local function appendPathBatch(batchIdx)
    local batch = pathMarkerBatches[batchIdx]
    if not batch then return end
    for _, point in ipairs(batch) do
        table.insert(markers, { pos = point.pos, heading = point.heading })
    end
end

local function advancePathBatchIfEmpty()
    if #markers > 0 then return end
    local nextIdx = pathMarkerBatchIndex + 1
    if nextIdx > #pathMarkerBatches then
        pathMarkerBatchIndex = 0
        return
    end
    pathMarkerBatchIndex = nextIdx
    appendPathBatch(pathMarkerBatchIndex)
end

function createPathMarkers()
    markers = {}
    pathMarkerBatchIndex = 1
    appendPathBatch(1)
end

RegisterNetEvent("creator:setup3d")
AddEventHandler("creator:setup3d", function()
    if GetResourceState('sCore') == 'started' then
        exports["sCore"]:setFreecamBypass(true)
    end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end

    local ped = PlayerPedId()
    SetEntityCoords(ped, SPAWN_AFTER_CREATOR.x, SPAWN_AFTER_CREATOR.y, SPAWN_AFTER_CREATOR.z, false, false, false, false)
    SetEntityHeading(ped, SPAWN_AFTER_CREATOR_HEADING)
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)
    createPathMarkers()

    if GetResourceState('sCore') == 'started' then
        exports["sCore"]:setFreecamBypass(false)
    end

    DisplayRadar(true)
    ExecuteCommand("enableHud")
    TriggerEvent("statushud:all:show")

    DoScreenFadeIn(3000)
    while not IsScreenFadedIn() do Wait(0) end
    ShowQuestCompletedScaleform("Bienvenue sur le serveur !", "Vous êtes au parfait endroit pour développer un RP incroyable !", 5)

    addPostCreatorBlip()
end)

RegisterNetEvent("core:register")
AddEventHandler("core:register", function()
    TriggerEvent("cc:openCreator")
end)

RegisterNetEvent("core:creator")
AddEventHandler("core:creator", function()
    TriggerEvent("cc:openCreator")
end)

RegisterCommand('adminregister', function(source, args, rawCommand)
    ESX.TriggerServerCallback("sunlife:tryAdminRegister", function(allowed)
        if allowed then
            local target = tonumber(args[1])
            if target ~= nil then
                TriggerServerEvent("creator:giveRegister", target)
            end
        end
    end)
end)

function ShowQuestCompletedScaleform(title, msg, sec)
    sec = sec or 5.0
    local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

    BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
    PushScaleformMovieMethodParameterString(title)
    PushScaleformMovieMethodParameterString(msg)
    EndScaleformMovieMethod()

    PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)

    local startTime = GetGameTimer()
    local duration = sec * 1000

    while GetGameTimer() - startTime < duration do
        Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function drawMarkers()
    for i, marker in ipairs(markers) do

        DrawMarker(20, marker.pos.x, marker.pos.y, marker.pos.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, marker.heading, 1.0, 1.0, 0.5, 255, 106, 0, 200, false, true, 2, nil, nil, false)
    end
end

function removeNearbyMarkers()
    local playerPos = GetEntityCoords(PlayerPedId())
    for i = 1, #markers do
        if #(playerPos - markers[i].pos) < PATH_MARKER_ACTIVATE_DIST then
            table.remove(markers, i)
            advancePathBatchIfEmpty()
            break
        end
    end
end

CreateThread(function()
    while true do
        local interval = 1000

        if #(GetEntityCoords(PlayerPedId()) - PATH_MARKERS_CENTER) < PATH_MARKERS_RADIUS then
            interval = 0
            drawMarkers()
            removeNearbyMarkers()
        end

        Wait(interval)
    end
end)
