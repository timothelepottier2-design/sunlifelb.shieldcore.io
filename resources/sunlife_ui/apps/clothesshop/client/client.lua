local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'clothesshop', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'clothesshop', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('clothesshop/' .. name, cb)
end

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect", function(obj)
            ESX = obj
        end)
        Wait(0)
    end
end)

local RES_NAME = GetCurrentResourceName()

local _csPending = {}
local _csSeq = 0

RegisterNetEvent("snl:cs:rpc:reply")
AddEventHandler("snl:cs:rpc:reply", function(reqId, ...)
    local cb = _csPending[reqId]
    if not cb then return end
    _csPending[reqId] = nil
    cb(...)
end)

local function CS_Rpc(op, cb, ...)
    _csSeq = _csSeq + 1
    local reqId = _csSeq
    _csPending[reqId] = cb or function() end
    TriggerServerEvent("snl:cs:rpc", reqId, op, ...)
end

local function IsPlayerVip()
    ESX.PlayerData = ESX.GetPlayerData()
    local ranks = ESX.PlayerData.rank
    local hasDiamond = false

    if ranks then
        for _, rankInfo in ipairs(ranks) do
            if rankInfo.name == "diamond" or rankInfo.name == "platinium" or rankInfo.name == "legendary" then
                hasDiamond = true
            end
        end
    end

    return hasDiamond
end

local VIP_NPCS = {
    {name = "Skin homme", model = "mp_m_freemode_01"},
    {name = "Skin femme", model = "mp_f_freemode_01"},
    {name = "Pompier", model = "s_m_y_fireman_01"},
    {name = "Gros sac", model = "a_m_m_afriamer_01"},
    {name = "Gros + Chauve", model = "a_m_m_genfat_01"},
    {name = "Dealer congolais", model = "a_m_y_downtown_01"},
    {name = "Statue", model = "s_m_m_strperf_01"},
    {name = "Clochard", model = "a_m_o_tramp_01"},
    {name = "Fermier", model = "a_m_m_hillbilly_01"},
    {name = "Le daron à Salim", model = "a_m_m_genfat_02"},
    {name = "La daronne à Yassine", model = "a_f_m_fatcult_01"},
    {name = "Danseur fou", model = "a_m_y_breakdance_01"},
    {name = "Vigile", model = "s_m_m_bouncer_01"},
    {name = "Peu de pudeur", model = "a_f_m_beach_01"},
    {name = "Muscu pour compenser autre chose", model = "u_m_y_babyd"},
    {name = "Désolé ça va vous couter plus cher", model = "s_m_m_autoshop_02"},
    {name = "50cent de wish", model = "ig_claypain"},
    {name = "Non je deal pas", model = "s_m_y_dealer_01"},
    {name = "Homme malade", model = "u_m_o_filmnoir"},
    {name = "Pas de commentaires", model = "a_m_m_tranvest_01"},
    {name = "Danseuse", model = "s_f_y_stripperlite"},
    {name = "Scientifique", model = "s_m_m_scientist_01"},
    {name = "Agent de sécurité", model = "s_m_m_security_01"},
    {name = "Ranger", model = "u_m_y_rsranger_01"},
    {name = "Homme qui fête", model = "u_m_m_partytarget"},
    {name = "Mamie", model = "a_f_m_eastsa_02"},
    {name = "Juif", model = "a_m_y_hasjew_01"},
    {name = "Bosseur de l'usine", model = "s_m_y_factory_01"},
    {name = "BusinessMan", model = "s_m_m_highsec_04"},
    {name = "Pug", model = "a_c_pug"},
    {name = "Lapin", model = "a_c_rabbit_01"},
    {name = "Chat", model = "a_c_cat_01"}
}

local function SetVipPedModel(modelName)
    if type(modelName) ~= "string" or modelName == "" then
        return false
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local hash = GetHashKey(modelName)

    RequestModel(hash)
    local i = 0
    while not HasModelLoaded(hash) and i < 500 do
        Wait(10)
        i = i + 1
    end

    if not HasModelLoaded(hash) then
        return false
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)

    local newPed = PlayerPedId()
    SetEntityCoordsNoOffset(newPed, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(newPed, heading)
    SetPedDefaultComponentVariation(newPed)
    SetCurrentPedWeapon(newPed, `WEAPON_UNARMED`, true)

    return true
end

local uiOpen = false

local wardrobeUiOpen = false
local payCb = nil
local baseSkin = nil

local vipPedActive = false

local function isClothesNuiActive()
    return (uiOpen or wardrobeUiOpen) and ESX ~= nil
end
local CHANGE_KEYS = {
    tshirt_1 = true, tshirt_2 = true,
    torso_1 = true, torso_2 = true,
    arms = true, arms_2 = true,
    decals_1 = true, decals_2 = true,
    pants_1 = true, pants_2 = true,
    shoes_1 = true, shoes_2 = true,
    mask_1 = true, mask_2 = true,
    ears_1 = true, ears_2 = true,
    bags_1 = true, bags_2 = true,
    helmet_1 = true, helmet_2 = true,
    bproof_1 = true, bproof_2 = true,
    watches_1 = true, watches_2 = true,
    chain_1 = true, chain_2 = true,
    glasses_1 = true, glasses_2 = true,
    bracelets_1 = true, bracelets_2 = true,
}
local cam = nil
local camTarget = nil
local isDraggingCam = false
local dragLastX, dragLastY = 0.0, 0.0
local camAngleX = 0.0
local camAngleY = 0.0
local camDistance = 2.0
local defaultFov = 50.0
local headingLock = nil
local freezeThread = nil
local camDragThread = nil

local camPositions = {
    head = { 0.9, 0.65, 0.65 },
    body = { 2.0, 0.0, 0.0 },
    shoes = { 1.0, -0.9, -0.9 }
}

local FREEZE_DICT = "anim@heists@heist_corona@team_idles@male_a"
local FREEZE_NAME = "idle"

local CAT_MAP = {
    tshirt = { drawable = "tshirt_1", texture = "tshirt_2" },
    torso = { drawable = "torso_1", texture = "torso_2" },
    arms = { drawable = "arms", texture = "arms_2" },
    pants = { drawable = "pants_1", texture = "pants_2" },
    shoes = { drawable = "shoes_1", texture = "shoes_2" },
    mask = { drawable = "mask_1", texture = "mask_2" },
    chain = { drawable = "chain_1", texture = "chain_2" },
    bags = { drawable = "bags_1", texture = "bags_2" },
    bproof = { drawable = "bproof_1", texture = "bproof_2" },
    decals = { drawable = "decals_1", texture = "decals_2" },
    helmet = { drawable = "helmet_1", texture = "helmet_2" },
    glasses = { drawable = "glasses_1", texture = "glasses_2" },
    watches = { drawable = "watches_1", texture = "watches_2" },
    bracelets = { drawable = "bracelets_1", texture = "bracelets_2" },
    ears = { drawable = "ears_1", texture = "ears_2" }
}

local CLOTH_KEYS = {
    "tshirt_1", "tshirt_2",
    "torso_1", "torso_2",
    "arms", "arms_2",
    "pants_1", "pants_2",
    "shoes_1", "shoes_2",
    "mask_1", "mask_2",
    "chain_1", "chain_2",
    "bags_1", "bags_2",
    "bproof_1", "bproof_2",
    "decals_1", "decals_2",
    "helmet_1", "helmet_2",
    "glasses_1", "glasses_2",
    "watches_1", "watches_2",
    "bracelets_1", "bracelets_2",
    "ears_1", "ears_2"
}

local COMP_ID = {
    tshirt = 8,
    torso = 11,
    arms = 3,
    pants = 4,
    shoes = 6,
    mask = 1,
    chain = 7,
    bags = 5,
    bproof = 9,
    decals = 10
}

local PROP_ID = {
    helmet = 0,
    glasses = 1,
    ears = 2,
    watches = 6,
    bracelets = 7
}

local function getMaxDrawable(ped, catId)
    local comp = COMP_ID[catId]
    if comp ~= nil then
        local n = GetNumberOfPedDrawableVariations(ped, comp)
        return math.max(n - 1, 0)
    end

    local prop = PROP_ID[catId]
    if prop ~= nil then
        local n = GetNumberOfPedPropDrawableVariations(ped, prop)
        return math.max(n - 1, 0)
    end

    return 0
end

local function getMaxTexture(ped, catId, drawable)
    drawable = tonumber(drawable) or 0

    local comp = COMP_ID[catId]
    if comp ~= nil then
        local n = GetNumberOfPedTextureVariations(ped, comp, drawable)
        return math.max(n - 1, 0)
    end

    local prop = PROP_ID[catId]
    if prop ~= nil then
        local n = GetNumberOfPedPropTextureVariations(ped, prop, drawable)
        return math.max(n - 1, 0)
    end

    return 0
end

RegisterNUICallback("getLimits", function(_, cb)
    local ped = PlayerPedId()
    local out = {}

    for catId, _ in pairs(CAT_MAP) do
        out[catId] = {
            rangeD = getMaxDrawable(ped, catId),
            rangeT = 0
        }
    end

    cb({ ok = true, limits = out })
end)

RegisterNUICallback("getTextureMax", function(data, cb)
    local ped = PlayerPedId()
    local catId = data and data.catId or nil
    local drawable = data and data.drawable or 0
    if not catId then
        cb({ ok = false, max = 0 })
        return
    end
    cb({ ok = true, max = getMaxTexture(ped, catId, drawable) })
end)

local PROP_DRAWABLE_KEYS = {
    helmet_1 = true,
    glasses_1 = true,
    ears_1 = true,
    watches_1 = true,
    bracelets_1 = true
}

local function buildValuesFromSkin(skin)
    local out = {}
    for catId, map in pairs(CAT_MAP) do
        local dDefault = 0
        if map.drawable and PROP_DRAWABLE_KEYS[map.drawable] then
            dDefault = -1
        end

        local d = dDefault
        local t = 0

        if map.drawable and skin[map.drawable] ~= nil then
            d = tonumber(skin[map.drawable]) or dDefault
        end
        if map.texture and skin[map.texture] ~= nil then
            t = tonumber(skin[map.texture]) or 0
        end

        out[catId] = { d = d, t = t }
    end
    return out
end

local function deepCopy(t)
    if t == nil then return nil end
    local s = json.encode(t)
    if not s then return nil end
    return json.decode(s)
end

local function clampDrawable(key, v)
    local min = 0
    if key and PROP_DRAWABLE_KEYS[key] then
        min = -1
    end

    v = tonumber(v)
    if v == nil then v = min end
    if v < min then v = min end
    if v > 65535 then v = 65535 end
    return math.floor(v + 0.5)
end

local function clampTexture(v)
    v = tonumber(v)
    if v == nil then v = 0 end
    if v < 0 then v = 0 end
    if v > 65535 then v = 65535 end
    return math.floor(v + 0.5)
end

local function applyOne(drawableKey, textureKey, drawable, texture)
    drawable = clampDrawable(drawableKey, drawable)

    if drawable == -1 then
        if drawableKey then
            TriggerEvent("skinchanger:change", drawableKey, -1)
        end
        if textureKey then
            TriggerEvent("skinchanger:change", textureKey, 0)
        end
        return
    end

    texture = clampTexture(texture)

    if drawableKey then
        TriggerEvent("skinchanger:change", drawableKey, drawable)
    end
    if textureKey then
        TriggerEvent("skinchanger:change", textureKey, texture)
    end
end

local function applyValues(values)
    if type(values) ~= "table" then return end
    for catId, st in pairs(values) do
        local m = CAT_MAP[catId]
        if m and type(st) == "table" then
            local d = tonumber(st.d) or 0
            local t = tonumber(st.t) or 0
            applyOne(m.drawable, m.texture, d, t)
        end
    end
end

local function buildOutfitFromSkin(skin)
    local o = {}
    for i = 1, #CLOTH_KEYS do
        local k = CLOTH_KEYS[i]
        o[k] = skin[k]
    end
    return o
end

local function buildMetaFromSkin(skin, keys)
    local out = {}
    for i = 1, #keys do
        local k = keys[i]
        out[k] = skin[k]
    end
    return out
end

local function pushItemToServerStorage(itemCat)
    if not itemCat then return end

    TriggerEvent("skinchanger:getSkin", function(newSkin)
        if itemCat == "pants" then
            TriggerServerEvent("clothshop:server:add", "pants", { rename = "Pantalon", data = buildMetaFromSkin(newSkin, { "pants_1", "pants_2" }) })
            return
        end
        if itemCat == "shoes" then
            TriggerServerEvent("clothshop:server:add", "shoes", { rename = "Chaussure", data = buildMetaFromSkin(newSkin, { "shoes_1", "shoes_2" }) })
            return
        end
        if itemCat == "mask" then
            TriggerServerEvent("clothshop:server:add", "mask", { rename = "Masque", data = buildMetaFromSkin(newSkin, { "mask_1", "mask_2" }) })
            return
        end
        if itemCat == "bags" then
            TriggerServerEvent("clothshop:server:add", "bag", { rename = "Sac", data = buildMetaFromSkin(newSkin, { "bags_1", "bags_2" }) })
            return
        end
        if itemCat == "bproof" then
            TriggerServerEvent("clothshop:server:add", "bproof", { rename = "Gilet pare-balles", data = buildMetaFromSkin(newSkin, { "bproof_1", "bproof_2" }) })
            return
        end
        if itemCat == "glasses" then
            TriggerServerEvent("clothshop:server:add", "glasses", { rename = "Lunettes", data = buildMetaFromSkin(newSkin, { "glasses_1", "glasses_2" }) })
            return
        end
        if itemCat == "chain" then
            TriggerServerEvent("clothshop:server:add", "chain", { rename = "Chaîne", data = buildMetaFromSkin(newSkin, { "chain_1", "chain_2" }) })
            return
        end
        if itemCat == "helmet" then
            TriggerServerEvent("clothshop:server:add", "helmet", { rename = "Casque", data = buildMetaFromSkin(newSkin, { "helmet_1", "helmet_2" }) })
            return
        end
        if itemCat == "watches" then
            TriggerServerEvent("clothshop:server:add", "watch", { rename = "Montre", data = buildMetaFromSkin(newSkin, { "watches_1", "watches_2" }) })
            return
        end
        if itemCat == "bracelets" then
            TriggerServerEvent("clothshop:server:add", "bracelets", { rename = "Bracelet", data = buildMetaFromSkin(newSkin, { "bracelets_1", "bracelets_2" }) })
            return
        end
        if itemCat == "ears" then
            TriggerServerEvent("clothshop:server:add", "ears", { rename = "Access. oreille", data = buildMetaFromSkin(newSkin, { "ears_1", "ears_2" }) })
            return
        end
        if itemCat == "tshirt" or itemCat == "torso" or itemCat == "arms" or itemCat == "decals" then
            TriggerServerEvent("clothshop:server:addUp", {
                rename = "Haut",
                data = buildMetaFromSkin(newSkin, { "tshirt_1", "tshirt_2", "torso_1", "torso_2", "arms", "arms_2", "decals_1", "decals_2" })
            })
            return
        end
    end)
end

local function saveSkinToDB()
    TriggerEvent("skinchanger:getSkin", function(skin)
        TriggerServerEvent("esx_skin:save", skin)
    end)
end

local function waitPayCallback(timeoutMs)
    local t = GetGameTimer()
    while payCb == nil and (GetGameTimer() - t) < (timeoutMs or 8000) do
        Wait(50)
    end
    return payCb
end

local function restoreBaseSkin()
    if not baseSkin then return end
    TriggerEvent("skinchanger:loadSkin", baseSkin)
end

local function resetAllScriptCams()
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    Wait(0)
end

local function applyCamPosition(targetCam)
    local offsetX = camDistance * math.cos(math.rad(camAngleY)) * math.sin(math.rad(camAngleX))
    local offsetY = camDistance * math.cos(math.rad(camAngleY)) * math.cos(math.rad(camAngleX))
    local offsetZ = camDistance * math.sin(math.rad(camAngleY))
    SetCamCoord(targetCam, camTarget.x + offsetX, camTarget.y - offsetY, camTarget.z + offsetZ)
    PointCamAtCoord(targetCam, camTarget.x, camTarget.y, camTarget.z)
end

local function spawnCam(mode)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local pos = camPositions[mode] or camPositions.body

    camTarget = vector3(coords.x, coords.y, coords.z + pos[3])
    camDistance = pos[1]
    camAngleX = heading + 180.0
    camAngleY = 0.0

    if not cam then
        resetAllScriptCams()
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        applyCamPosition(cam)
        SetCamFov(cam, defaultFov)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
    else
        local newCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        applyCamPosition(newCam)
        SetCamFov(newCam, defaultFov)
        SetCamActiveWithInterp(newCam, cam, 250, true, true)
        cam = newCam
    end
end

local function startDragCam()
    if not camTarget then camTarget = GetEntityCoords(PlayerPedId()) end
    isDraggingCam = true
    dragLastX = GetControlNormal(0, 239)
    dragLastY = GetControlNormal(0, 240)
end

local function updateDragCam()
    if not cam or not isDraggingCam then return end
    local mouseX = GetControlNormal(0, 239)
    local mouseY = GetControlNormal(0, 240)
    local dx = (mouseX - dragLastX) * 180.0
    local dy = (mouseY - dragLastY) * 90.0
    dragLastX, dragLastY = mouseX, mouseY
    camAngleX = camAngleX - dx
    camAngleY = math.max(-89.0, math.min(89.0, camAngleY + dy))
    applyCamPosition(cam)
    SetCamFov(cam, defaultFov)
end

local function stopDragCam()
    isDraggingCam = false
end

local function startCamDragThread()
    if camDragThread then return end
    camDragThread = true
    CreateThread(function()
        while uiOpen do
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

local function destroyCam()
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
end

local function playFrozenIdle(ped)
    RequestAnimDict(FREEZE_DICT)
    while not HasAnimDictLoaded(FREEZE_DICT) do
        Wait(0)
    end
    TaskPlayAnim(ped, FREEZE_DICT, FREEZE_NAME, 0.0, 0.0, -1, 1, 0.0, false, false, false)
    Wait(50)
    SetEntityAnimCurrentTime(ped, FREEZE_DICT, FREEZE_NAME, 0.0)
    SetEntityAnimSpeed(ped, FREEZE_DICT, FREEZE_NAME, 0.0)
end

local function lockFace(ped, on)

end

local function startFreezeThread()
    if freezeThread then return end
    freezeThread = true
    CreateThread(function()
        local lastCheck = 0
        while uiOpen do
            local ped = PlayerPedId()

            FreezeEntityPosition(ped, true)

            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 106, true)

            if headingLock then
                SetEntityHeading(ped, headingLock)
            end

            local now = GetGameTimer()
            if now - lastCheck > 500 then
                if not IsEntityPlayingAnim(ped, FREEZE_DICT, FREEZE_NAME, 3) then

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

local function setFocus(state)
    uiOpen = state and true or false
    SetNuiFocus(uiOpen, uiOpen)
    SetNuiFocusKeepInput(false)
    DisplayRadar(not uiOpen)

    local ped = PlayerPedId()

    if uiOpen then
        FreezeEntityPosition(ped, true)
        headingLock = GetEntityHeading(ped)
        ClearPedTasksImmediately(ped)
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        SetPedCanRagdoll(ped, false)
        lockFace(ped, true)
        startFreezeThread()
        startCamDragThread()

        DisplayRadar(false)
        ExecuteCommand("disableHud")
        TriggerEvent("statushud:all:hide")

    else
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        NetworkSetEntityInvisibleToNetwork(ped, false)

        headingLock = nil
        lockFace(ped, false)

        ClearPedTasksImmediately(ped)
        ClearPedSecondaryTask(ped)

        SetPedCanRagdoll(ped, true)
        FreezeEntityPosition(ped, false)

        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)

        DisplayRadar(true)
        ExecuteCommand("enableHud")
        TriggerEvent("statushud:all:show")

        ForcePedMotionState(ped, `MotionState_Walk`, false, 0, true)

        SetTimeout(50, function()
            FreezeEntityPosition(ped, false)
            ClearPedTasks(ped)
        end)
    end
end

local function getSexFromSkin(skin)
    if skin and skin.sex ~= nil and tonumber(skin.sex) == 1 then
        return "female"
    end
    return "male"
end

local function refreshOutfitsToNui()
    if not isClothesNuiActive() then return end
    CS_Rpc("outfits:get", function(rows)
        SendNUIMessage({
            action = "outfits:set",
            outfits = rows or {}
        })
    end)
end

local function openUI(defaultCat)
    if uiOpen then return end

    wardrobeUiOpen = false
    payCb = nil
    baseSkin = nil
    vipPedActive = false

    TriggerEvent("skinchanger:getSkin", function(skin)
        baseSkin = deepCopy(skin)
        local sex = getSexFromSkin(skin)
        local initValues = buildValuesFromSkin(skin)

        setFocus(true)

        local vip = false
        pcall(function() vip = IsPlayerVip() end)

        SendNUIMessage({
            action = "openClotheshop",
            sex = sex,
            defaultCat = defaultCat or "tshirt",
            values = initValues,
            isVip = vip,
            vipNpcs = vip and VIP_NPCS or {}
        })

        spawnCam("body")

        SetTimeout(150, function()
            refreshOutfitsToNui()
        end)
    end)
end

RegisterNUICallback("vipPedSelect", function(data, cb)
    if not IsPlayerVip() then
        cb({ ok = false })
        return
    end

    local model = data and data.model and tostring(data.model) or ""
    local ok = SetVipPedModel(model)
    if ok then

        vipPedActive = true
    end
    cb({ ok = ok })
end)

local function closeUI(restore)
    if not uiOpen and not wardrobeUiOpen then return end

    SendNUIMessage({ action = "closeClotheshop" })

    if uiOpen then
        setFocus(false)
        destroyCam()
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        wardrobeUiOpen = false
    end

    FreezeEntityPosition(PlayerPedId(), false)

    if restore and not vipPedActive then
        restoreBaseSkin()
    end

    baseSkin = nil
    payCb = nil
    vipPedActive = false
end

RegisterNUICallback("vipPedConfirm", function(_, cb)
    vipPedActive = true
    closeUI(false)
    cb({ ok = true })
end)

RegisterNetEvent("clotheshop:openClotheshop")
AddEventHandler("clotheshop:openClotheshop", function(defaultCat)
    openUI(defaultCat)
end)

RegisterNetEvent("clotheshop:callback")
AddEventHandler("clotheshop:callback", function(cb)
    payCb = cb
end)

RegisterNUICallback("closeUI", function(_, cb)
    closeUI(true)
    cb({ ok = true })
end)

RegisterNUICallback("setCamera", function(data, cb)
    local mode = (data and data.mode) or "body"
    if mode ~= "head" and mode ~= "body" and mode ~= "shoes" then
        mode = "body"
    end
    spawnCam(mode)
    startCamDragThread()
    cb({ ok = true })
end)

RegisterNUICallback("skinChange", function(data, cb)
    if not uiOpen then
        cb({ ok = false })
        return
    end

    local drawableKey = data and data.drawableKey or nil
    local textureKey = data and data.textureKey or nil
    local drawable = data and data.drawable or 0
    local texture = data and data.texture or 0

    applyOne(drawableKey, textureKey, drawable, texture)
    cb({ ok = true })
end)

RegisterNUICallback("skinPreview", function(data, cb)
    if not uiOpen then
        cb({ ok = false })
        return
    end

    local drawableKey = data and data.drawableKey or nil
    local textureKey = data and data.textureKey or nil
    local drawable = data and data.drawable or 0
    local texture = data and data.texture or 0

    applyOne(drawableKey, textureKey, drawable, texture)
    cb({ ok = true })
end)

RegisterNUICallback("outfitsGet", function(_, cb)
    if not isClothesNuiActive() then
        cb({ ok = false, outfits = {} })
        return
    end

    CS_Rpc("outfits:get", function(rows)
        cb({ ok = true, outfits = rows or {} })
    end)
end)

RegisterNUICallback("outfitsSave", function(data, cb)
    if not isClothesNuiActive() then
        cb({ ok = false })
        return
    end

    local name = tostring((data and data.name) or "")
    name = name:gsub("[\r\n\t]", " "):sub(1, 64)
    if name == "" then
        cb({ ok = false })
        return
    end

    TriggerEvent("skinchanger:getSkin", function(skin)
        local outfit = buildOutfitFromSkin(skin)
        CS_Rpc("outfits:save", function(ok, reason)
            if ok then
                refreshOutfitsToNui()
            elseif reason == "limit" then
                local msg = "~r~Vous avez atteint la limite de 25 tenues sauvegardées."
                if ESX and ESX.ShowNotification then
                    ESX.ShowNotification(msg)
                else
                    TriggerEvent("esx:showNotification", msg)
                end
            end
            cb({ ok = ok and true or false, reason = reason })
        end, name, outfit)
    end)
end)

RegisterNUICallback("outfitsRename", function(data, cb)
    if not isClothesNuiActive() then
        cb({ ok = false })
        return
    end

    local id = tonumber(data and data.id)
    local name = tostring((data and data.name) or "")
    name = name:gsub("[\r\n\t]", " "):sub(1, 64)

    if not id or id <= 0 or name == "" then
        cb({ ok = false })
        return
    end

    CS_Rpc("outfits:rename", function(ok)
        if ok then
            refreshOutfitsToNui()
        end
        cb({ ok = ok and true or false })
    end, id, name)
end)

RegisterNUICallback("outfitsDelete", function(data, cb)
    if not isClothesNuiActive() then
        cb({ ok = false })
        return
    end

    local id = tonumber(data and data.id)
    if not id or id <= 0 then
        cb({ ok = false })
        return
    end

    CS_Rpc("outfits:delete", function(ok)
        if ok then
            refreshOutfitsToNui()
        end
        cb({ ok = ok and true or false })
    end, id)
end)

RegisterNUICallback("outfitsLoad", function(data, cb)
    if not isClothesNuiActive() then
        cb({ ok = false })
        return
    end

    local id = tonumber(data and data.id)
    if not id or id <= 0 then
        cb({ ok = false })
        return
    end

    CS_Rpc("outfits:load", function(ok, skin)
        if not ok or type(skin) ~= "table" then
            cb({ ok = false })
            return
        end

        local clothes = {}
        for k, v in pairs(skin) do
            if CHANGE_KEYS[k] then
                clothes[k] = v
            end
        end

        TriggerEvent("skinchanger:getSkin", function(curSkin)
            TriggerEvent("skinchanger:loadClothes", curSkin, clothes)
            saveSkinToDB()
            cb({ ok = true })
        end)
    end, id)
end)

RegisterNUICallback("payClotheshop", function(data, cb)
    if not uiOpen then
        cb({ ok = false })
        return
    end

    local method = data and data.method or "cash"
    local total = tonumber(data and data.total) or 0
    local values = data and data.values or nil
    local itemOnly = data and data.itemOnly and true or false
    local itemCat = data and data.itemCat or nil
    local outfitName = data and data.outfitName or nil

    if total <= 0 then
        cb({ ok = false })
        return
    end

    if values then
        applyValues(values)
    end

    payCb = nil
    TriggerServerEvent("clotheshop:pay", total, method, itemOnly, itemCat)

    local res = waitPayCallback(8000)

    if res ~= "can_buy" then
        restoreBaseSkin()
        cb({ ok = false, reason = "cant_buy" })
        return
    end

    saveSkinToDB()

    if itemOnly then
        pushItemToServerStorage(itemCat)
    else
        TriggerEvent("skinchanger:getSkin", function(newSkin)
            local outfit = {}
            for k, _ in pairs(CHANGE_KEYS) do
                outfit[k] = newSkin[k]
            end

            local name = tostring(outfitName or "Tenue")
            TriggerServerEvent("clotheshop:saveClothes", name, outfit)
        end)
    end

    cb({ ok = true })
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= RES_NAME then return end
    destroyCam()
    if uiOpen or wardrobeUiOpen then
        closeUI(false)
    end
end)

CreateThread(function()
    while true do
        if uiOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 36, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            Wait(0)
        else
            Wait(250)
        end
    end
end)

local clotheshops = {
    vector3(423.22268676758, -800.81176757812, 28.49342918396),
    vector3(77.648490905762, -1398.3321533203, 28.378427505493),
    vector3(-825.73181152344, -1078.2236328125, 10.330401420593),
    vector3(-1192.9029541016, -774.93121337891, 16.329011917114),
    vector3(121.5486831665, -217.99000549316, 53.557655334473),
    vector3(1690.8974609375, 4827.9189453125, 41.065380096436),
    vector3(620.08636474609, 2759.3217773438, 41.088218688965),
    vector3(-1104.052734375, 2705.3447265625, 18.110151290894),
    vector3(-3174.0808105469, 1049.5626220703, 19.863349914551),
    vector3(7.3645577430725, 6517.7827148438, 30.880138397217),
    vector3(1191.2204589844, 2707.9565429688, 37.224899291992),
    vector3(-711.18353271484, -150.35595703125, 36.415191650391),
    vector3(-164.43942260742, -305.75686645508, 38.733337402344),
    vector3(7348.331055, 411.692719, 57.053400)
}

CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect", function(obj)
            ESX = obj
        end)
        Wait(0)
    end

    for _, shopPos in ipairs(clotheshops) do
        local blip = AddBlipForCoord(shopPos.x, shopPos.y, shopPos.z)
        SetBlipSprite(blip, 73)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 47)
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SNL_CLOTHESSHOP_1_" .. tostring(blip)
        AddTextEntry(_key, "Magasin de vêtements")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleepTime = 1000

        if uiOpen then
            Wait(500)
            goto continue
        end

        for _, shopPos in ipairs(clotheshops) do
            local dist = #(playerCoords - shopPos)
            if dist < 10.0 then

                sleepTime = 0
                DrawMarker(6, shopPos.x, shopPos.y, shopPos.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 106, 0, 140, false, false, 2, false, nil, nil, false)

                if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au magasin de vêtements")
                    if IsControlJustReleased(0, 38) then
                        openUI("tshirt")
                    end
                end
            end
        end

        ::continue::

        Wait(sleepTime)
    end
end)

local saveshops = {
    vector3(-161.51434326172, -296.66833496094, 38.733337402344),
    vector3(72.004089355469, -1398.8272705078, 28.3709),
    vector3(-829.16412353516, -1073.6274414062, 10.3238),
    vector3(-1192.2593994141, -767.91540527344, 16.319562911987),
    vector3(124.99120330811, -224.32699584961, 53.55770111084),
    vector3(1696.4553222656, 4829.0708007812, 41.0631),
    vector3(614.67962646484, 2763.3999023438, 41.088256835938),
    vector3(-1108.0754394531, 2709.2165527344, 18.1079),
    vector3(11.343503952026, 6513.8276367188, 30.8778),
    vector3(1190.8953857422, 2713.685546875, 37.2226),
    vector3(-706.46246337891, -158.73582458496, 36.415237426758),
    vector3(428.95108032227, -800.43060302734, 28.4911),
    vector3(1104.0811, 196.4669, -50.4401),
    vector3(-3170.865234375, 1044.369140625, 19.863214492798),
    vector3(7345.019043, 408.679047, 57.053400)
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false
        local ped = PlayerPedId()
        local plyCoords = GetEntityCoords(ped)

        for k, v in pairs(saveshops) do
            local dist = #(plyCoords - vector3(v.x, v.y, v.z))

            if dist < 10.0 then
                nearThing = true
                DrawMarker(6, v.x, v.y, v.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 106, 0, 140, false, false, 2, false, nil, nil, false)

                if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le vestiaire")
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("snl_clothesshop:openVestiaire")
                    end
                end
            end
        end

        if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(250)
        end
    end
end)

RegisterNetEvent("snl_clothesshop:openVestiaire")
AddEventHandler("snl_clothesshop:openVestiaire", function()
    if uiOpen then return end

    payCb = nil
    baseSkin = nil
    vipPedActive = false

    TriggerEvent("skinchanger:getSkin", function(skin)
        baseSkin = deepCopy(skin)

        local sex = getSexFromSkin(skin)
        local initValues = buildValuesFromSkin(skin)

        setFocus(true)

        local vip = false
        pcall(function() vip = IsPlayerVip() end)

        SendNUIMessage({
            action = "openVestiaire",
            sex = sex,
            values = initValues,
            isVip = vip,
            vipNpcs = vip and VIP_NPCS or {}
        })

        spawnCam("body")
    end)
end)

RegisterNUICallback("rotateHeading", function(data, cb)
    if not uiOpen then
        cb({ ok = false })
        return
    end

    local ped = PlayerPedId()
    local dir = tonumber(data and data.dir) or 0
    local step = tonumber(data and data.step) or 2.0

    if headingLock == nil then
        headingLock = GetEntityHeading(ped)
    end

    headingLock = headingLock + (dir * step)

    if headingLock >= 360.0 then headingLock = headingLock - 360.0 end
    if headingLock < 0.0 then headingLock = headingLock + 360.0 end

    SetEntityHeading(ped, headingLock)

    cb({ ok = true, heading = headingLock })
end)

RegisterNetEvent("clotheshop:openWardrobeUI")
AddEventHandler("clotheshop:openWardrobeUI", function()
    wardrobeUiOpen = true
    vipPedActive = false

    local ped = PlayerPedId()
    SetEntityHeading(ped, 297.7296)
    FreezeEntityPosition(ped, true)

    TriggerEvent("skinchanger:getSkin", function(skin)
        local vip = IsPlayerVip()

        SendNUIMessage({
            action = "openWardrobe",
            sex = (skin.sex == 1 and "female" or "male"),
            defaultCat = "tshirt",
            values = SkinToValues(skin),
            isVip = vip,
            vipNpcs = vip and VIP_NPCS or {}
        })

        SetNuiFocus(true, true)
    end)
end)

local previewBaseSkin = nil

RegisterNUICallback("lockerGet", function(data, cb)
    if ESX == nil then
        cb({ ok = false, items = {} })
        return
    end
    ESX.TriggerServerCallback("clotheshop:getClothes", function(list)
        local out = {}
        if type(list) == "table" then
            for i = 1, #list do
                out[#out + 1] = {
                    id = list[i].id,
                    label = list[i].label
                }
            end
        end
        cb({ ok = true, items = out })
    end)
end)

RegisterNUICallback("lockerSave", function(data, cb)

    payCb = nil
    TriggerServerEvent("clotheshop:pay2", false)

    CreateThread(function()
        local waited = 0
        while payCb == nil and waited < 5000 do
            Wait(50)
            waited = waited + 50
        end

        if payCb ~= "can_buy" then
            cb({ ok = false, reason = "cant_buy" })
            payCb = nil
            return
        end

        local name = tostring(data.name or "")
        if name == "" then
            cb({ ok = false, reason = "bad_name" })
            payCb = nil
            return
        end

        TriggerEvent("skinchanger:getSkin", function(skin)
            TriggerServerEvent("esx_skin:save", skin)
            local outfit = buildOutfitFromSkin(skin)
            TriggerServerEvent("clotheshop:saveClothes", name, outfit)
            payCb = nil
            cb({ ok = true })
        end)
    end)
end)

RegisterNUICallback("lockerRename", function(data, cb)
    local id = tonumber(data.id)
    local name = tostring(data.name or "")
    if not id or name == "" then
        cb({ ok = false })
        return
    end
    TriggerServerEvent("clotheshop:renameClothes", id, name)
    cb({ ok = true })
end)

RegisterNUICallback("lockerDelete", function(data, cb)
    local id = tonumber(data.id)
    if not id then
        cb({ ok = false })
        return
    end
    TriggerServerEvent("clotheshop:deleteClothes", id)
    cb({ ok = true })
end)

RegisterNUICallback("lockerPreview", function(data, cb)
    local id = tonumber(data and data.id)
    if not id then
        cb({ ok = false })
        return
    end

    if ESX == nil then
        cb({ ok = false })
        return
    end

    ESX.TriggerServerCallback("clotheshop:getOutfitTenue", function(ok, decoded)
        CreateThread(function()
            if not ok or type(decoded) ~= "table" then
                cb({ ok = false })
                return
            end

            local payload = decoded
            if type(decoded.data) == "table" and decoded.tshirt_1 == nil and decoded.torso_1 == nil and decoded.pants_1 == nil then
                payload = decoded.data
            end

            local clothes = {}
            for k, v in pairs(payload) do
                if CHANGE_KEYS[k] then
                    clothes[k] = v
                end
            end

            if next(clothes) == nil then
                cb({ ok = false })
                return
            end

            if previewBaseSkin == nil then
                local captured = nil
                TriggerEvent("skinchanger:getSkin", function(skin)
                    captured = skin
                end)
                local t = 0
                while captured == nil and t < 3000 do
                    Wait(5)
                    t = t + 5
                end
                previewBaseSkin = captured and deepCopy(captured) or nil
            end

            if previewBaseSkin == nil then
                cb({ ok = false })
                return
            end

            local base = deepCopy(previewBaseSkin)
            TriggerEvent("skinchanger:loadClothes", base, clothes)

            cb({ ok = true })
        end)
    end, id)
end)

RegisterNUICallback("lockerStopPreview", function(data, cb)
    if previewBaseSkin ~= nil then
        TriggerEvent("skinchanger:loadSkin", deepCopy(previewBaseSkin))
        previewBaseSkin = nil
    end
    cb({ ok = true })
end)

RegisterNUICallback("lockerBuy", function(data, cb)
    local id = tonumber(data.id)
    if not id then
        cb({ ok = false })
        return
    end

    TriggerServerEvent("clotheshop:payOutfit", id)
    cb({ ok = true })
end)
