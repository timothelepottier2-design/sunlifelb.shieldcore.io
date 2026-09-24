local function DisableDisplayControlActions()
    DisableControlAction(0, 24, true) -- INPUT_ATTACK (clic gauche)
    DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
    DisableControlAction(0, 1, true) -- INPUT_LOOK_LR
    DisableControlAction(0, 2, true) -- INPUT_LOOK_UD
    DisableControlAction(0, 25, true) -- Disable aiming (Right Mouse Button)
    DisableControlAction(0, 24, true) -- Disable attack (Left Mouse Button)
    DisableControlAction(0, 142, true) -- Disable melee attack alternate
    DisableControlAction(0, 257, true) -- Disable attack 2
    DisableControlAction(0, 140, true) -- Disable melee attack light
    DisableControlAction(0, 141, true) -- Disable melee attack heavy
    DisableControlAction(0, 37, true) -- Disable weapon wheel (Tab)
    DisablePlayerFiring(PlayerPedId(), true) -- Disable firing
end

--function removeRadioProp()
--    local radioProp = gPlayer.prop
--    if not radioProp then return end
--    DetachEntity(radioProp, false, false)
--    DeleteEntity(radioProp)
--    gPlayer.prop = nil
--end

function resetPlayer()
    --if gPlayer.prop then removeRadioProp() end
    gPlayer = {
        hasRadio = false,
        isMenuOpen = false,
        onRadio = false,
        channel = 0,
        volume = 50,
        prop = nil,
        lastChannel = 0
    }
    SetNuiFocus(false, false)
    if Config.AllowMovement then
        SetNuiFocusKeepInput(false)
    end
end

local function toggleRadioAnimation(pState)
    if pState then
        --local model = `prop_cs_hand_radio`
        --loadModel(model)
        --gPlayer.prop = CreateObject(model, 0.0, 0.0, 0.0, true, true, true)
        local ped = PlayerPedId()
        --SetEntityCollision(gPlayer.prop, false, false)
        --AttachEntityToEntity(gPlayer.prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true,
        --    false, true, 0, true)
        --SetModelAsNoLongerNeeded(model)
        local dict = getRadioDict(ped)
        loadAnimDict(dict)
        TaskPlayAnim(ped, dict, 'cellphone_text_in', 4.0, -1, -1, 50, 0, false, false, false)
        RemoveAnimDict(dict)
    else
        local ped = PlayerPedId()
        local dict = getRadioDict(ped)
        StopAnimTask(ped, dict, 'cellphone_text_in', 1.0)
        Wait(100)
        loadAnimDict(dict)
        TaskPlayAnim(ped, dict, 'cellphone_text_out', 7.0, -1, -1, 50, 0, false, false, false)
        Wait(200)
        StopAnimTask(ped, dict, 'cellphone_text_out', 1.0)
        RemoveAnimDict(dict)
        --removeRadioProp()
    end
end

local function isPlayerVehicleSetHorizontalRadio()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if playerVeh and (IsThisModelACar(GetEntityModel(playerVeh)) or IsThisModelAHeli(GetEntityModel(playerVeh)) or IsThisModelAPlane(GetEntityModel(playerVeh)) or IsThisModelABoat(GetEntityModel(playerVeh))) then
        SendReactMessage("setHorizontal", true)
    else
        SendReactMessage("setHorizontal", false)
    end
end

CreateThread(function()
    while true do
        isPlayerVehicleSetHorizontalRadio()
        Wait(500)
    end
end)

function toggleRadio(toggle)
    toggleRadioAnimation(toggle)
    SetNuiFocus(toggle, toggle)
    if Config.AllowMovement then
        SetNuiFocusKeepInput(toggle)
    end
    gPlayer.isMenuOpen = toggle
    SendReactMessage("setRadioVisible", toggle)
    isPlayerVehicleSetHorizontalRadio()
    local themes = Config.RadioThemes
    local theme = "theme1"
    for i = 1, #themes do
        if PlayerData.job.name == themes[i].job then
            theme = themes[i].theme
            break
        end
    end
    SendReactMessage("setTheme", theme)
    if Config.AllowMovement then
        CreateThread(function()
            while gPlayer.isMenuOpen do
                DisableDisplayControlActions()
                Citizen.Wait(1)
            end
        end)
    end
end

local function leavePMAVoiceRadio()
    exports["pma-voice"]:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end

function leaveRadio()
    -- Liste des membres retiree : on vide juste l'affichage NUI, plus
    -- aucun event serveur (la voix reste geree par pma-voice).
    RADIO.PlayerList = {}
    SendReactMessage("setPlayersInRadioChannel", {})
    leavePMAVoiceRadio()
    gPlayer.onRadio = false
    gPlayer.channel = 0
end

local function connectToPMAVoiceRadio(channel)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    exports["pma-voice"]:setRadioChannel(channel)
end

function connectToRadio(channel)
    connectToPMAVoiceRadio(channel)
    -- Liste des membres retiree : on affiche une liste vide cote NUI,
    -- aucun appel serveur (anti-hitch a grande echelle).
    RADIO.PlayerList = {}
    SendReactMessage("setPlayersInRadioChannel", {})
    gPlayer.onRadio = true
    gPlayer.channel = channel
end

local function setVolumePMAVoiceRadio(value)
    exports["pma-voice"]:setRadioVolume(value)
end

function checkPlayerMute(playerId)
    return exports["pma-voice"]:isPlayerMuted(playerId)
end

function ThreadUpdateGameTime()
    while true do
        Wait(1000)
        if gPlayer.isMenuOpen then
            SendReactMessage('setGameTime', CalculateTimeToDisplay())
        end
    end
end

function ThreadCheckAndResetRadio()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn and gPlayer.onRadio then
            if not gPlayer.hasRadio or gPlayer.isDead then
                gPlayer.lastChannel = 0
                leaveRadio()
                notify(_t('leave_channel'), 'error')
                toggleRadio(false)
                SendReactMessage("resetRadio")
            end
        end
    end
end

function checkDistanceForJammers(jammers)
    local closestDistance = -1
    local closestJammer = nil
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for objectId, jammerData in pairs(jammers) do
        local distance = #(playerCoords - jammerData.coords)

        if distance < Config.JammerSettings.min_distance_between_jammers then
            closestDistance = distance
            closestJammer = jammerData
            break
        end
    end
    return closestDistance, closestJammer
end

-- NUI'
RegisterNUICallback('joinRadio', function(channel, cb)
    local rchannel = tonumber(channel)
    if rchannel then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if not gPlayer.inJammerRange then
                if Config.RestrictedChannels[rchannel] then
                    local onduty = PlayerData.job.onduty or true
                    if Config.RestrictedChannels[rchannel][PlayerData.job.name] and onduty then
                        connectToRadio(rchannel)
                        notify(_t('connected_to') .. channel .. '.00 MHz', 'success')
                        local retData = { status = true, connected = true, newChannel = gPlayer.channel }
                        cb(retData)
                        return
                    else
                        notify(_t('restricted_channel'), 'error')
                    end
                else
                    connectToRadio(rchannel)
                    notify(_t('connected_to') .. channel .. '.00 MHz', 'success')
                    local retData = { status = true, connected = true, newChannel = gPlayer.channel }
                    cb(retData)
                    return
                end
            else
                notify(_t('no_signal'), 'error')
            end
        else
            notify(_t('invalid_frequency'), 'error')
        end
    else
        notify(_t('invalid_frequency'), 'error')
    end
    cb({ status = false })
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    if gPlayer.onRadio then
        notify(_t('leave_channel'), 'error')
    end
    gPlayer.lastChannel = 0
    leaveRadio()
    cb({ status = true })
end)

RegisterNUICallback("volumeUp", function(_, cb)
    if gPlayer.volume <= 95 then
        gPlayer.volume = gPlayer.volume + 5
        setVolumePMAVoiceRadio(gPlayer.volume)
        local retData = { status = true, newVolume = gPlayer.volume }
        cb(retData)
        return
    end
    cb({ status = false })
end)

RegisterNUICallback("volumeDown", function(_, cb)
    if gPlayer.volume >= 10 then
        gPlayer.volume = gPlayer.volume - 5
        setVolumePMAVoiceRadio(gPlayer.volume)
        local retData = { status = true, newVolume = gPlayer.volume }
        cb(retData)
        return
    end
    cb({ status = false })
end)

RegisterNUICallback('poweredOff', function(_, cb)
    if gPlayer.onRadio then
        notify(_t('leave_channel'), 'error')
    end
    gPlayer.lastChannel = 0
    leaveRadio()
    toggleRadio(false)
    Wait(100)
    gHasBootAnimation = false
    cb({ status = true })
end)

RegisterNUICallback("getServerVoiceSystem", function(_, cb)
    cb(Config.VoiceSystem)
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleRadio(false)
    cb('ok')
end)

RegisterNUICallback('getHasBootAnimation', function(_, cb)
    cb(gHasBootAnimation)
end)

RegisterNUICallback("setKeepInput", function(data, cb)
    if Config.AllowMovement then
        SetNuiFocusKeepInput(data.keepInput)
    end
    cb("ok")
end)
