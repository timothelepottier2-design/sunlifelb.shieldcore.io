local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'gunfight', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'gunfight', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('gunfight/' .. name, cb)
end

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

GUNFIGHT = {
    inZone = false,
    in1v1 = false,
    lobbyUIOpen = false,
    currentLobbyName = nil,
}

IsInGunFightZone = function()
    return GUNFIGHT.inZone or GUNFIGHT.in1v1
end

GUNFIGHT.openLobbyUI = function()
    if GUNFIGHT.lobbyUIOpen then return end
    GUNFIGHT.lobbyUIOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({ type = "openLobby", inZone = GUNFIGHT.inZone, myServerId = GetPlayerServerId(PlayerId()) })
end

GUNFIGHT.closeLobbyUI = function()
    if not GUNFIGHT.lobbyUIOpen then return end
    GUNFIGHT.lobbyUIOpen = false

    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeLobby" })
end

RegisterNUICallback("closeLobby", function(data, cb)
    GUNFIGHT.closeLobbyUI()
    cb("ok")
end)

local _rpcSeq = 0
local _pendingRpc = {}

local function _fastRpc(reqEvent, rspEvent, cb, ...)
    _rpcSeq = _rpcSeq + 1
    local id = _rpcSeq
    _pendingRpc[id] = { cb = cb, rspEvent = rspEvent, expireAt = GetGameTimer() + 10000 }
    TriggerServerEvent(reqEvent, id, ...)
end

local function _registerFastRpcReply(rspEvent)
    RegisterNetEvent(rspEvent, function(id, ...)
        local pending = _pendingRpc[id]
        if not pending or pending.rspEvent ~= rspEvent then return end
        _pendingRpc[id] = nil
        if pending.cb then pending.cb(...) end
    end)
end
_registerFastRpcReply("gunfight:rspLobbiesFast")
_registerFastRpcReply("gunfight:rspClassementFast")
_registerFastRpcReply("gunfight:rspClassementKdFast")

CreateThread(function()
    while true do
        Wait(15000)
        local now = GetGameTimer()
        for id, p in pairs(_pendingRpc) do
            if p.expireAt < now then _pendingRpc[id] = nil end
        end
    end
end)

RegisterNUICallback("getLobbies", function(data, cb)
    _fastRpc("gunfight:reqLobbiesFast", "gunfight:rspLobbiesFast", function(lobbies)
        cb(lobbies)
    end)
end)

RegisterNUICallback("joinLobby", function(data, cb)
    GUNFIGHT.closeLobbyUI()
    exports["sCore"]:setFreecamBypass(true)
    TriggerServerEvent("gunfight:joinLobby", data.lobbyId, data.password)
    cb("ok")
end)

RegisterNUICallback("leaveLobby", function(data, cb)
    GUNFIGHT.closeLobbyUI()
    TriggerServerEvent("gunfight:leave")
    cb("ok")
end)

RegisterNUICallback("createLobby", function(data, cb)
    GUNFIGHT.closeLobbyUI()
    exports["sCore"]:setFreecamBypass(true)
    TriggerServerEvent("gunfight:createLobby", {
        maxPlayers = data.maxPlayers,
        description = data.description,
        password = data.password,
    })
    cb("ok")
end)

RegisterNUICallback("deleteLobby", function(data, cb)
    GUNFIGHT.closeLobbyUI()
    TriggerServerEvent("gunfight:deleteLobby")
    cb("ok")
end)

RegisterNUICallback("getClassement", function(data, cb)
    _fastRpc("gunfight:reqClassementFast", "gunfight:rspClassementFast", function(result)
        cb(result)
    end)
end)

RegisterNUICallback("getClassementKd", function(data, cb)
    _fastRpc("gunfight:reqClassementKdFast", "gunfight:rspClassementKdFast", function(result)
        cb(result)
    end)
end)

RegisterNetEvent("gunfight:wrongPassword")
AddEventHandler("gunfight:wrongPassword", function()
    ESX.ShowNotification("~r~Mot de passe incorrect")
    GUNFIGHT.openLobbyUI()
end)

RegisterNetEvent("gunfight:reset1v1")
AddEventHandler("gunfight:reset1v1", function(imune)
    exports["sCore"]:setFreecamBypass(false)
    GUNFIGHT.in1v1 = false

    if imune then
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        GUNFIGHT.handleSpawn()
    end
end)

function BeginRace(cb)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(3)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(2)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(1)
    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0)
    BeginRaceGo()

    if cb then
        cb()
    end
end

function BeginRaceGo()
	local scaleform = RequestScaleformMovie('COUNTDOWN')

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')

    BeginTextCommandScaleformString('CNTDWN_GO')
    EndTextCommandScaleformString()

    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamInt(255)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 1000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
end

function BeginRaceCount(count)
	local scaleform = RequestScaleformMovie('COUNTDOWN')

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')

    BeginTextCommandScaleformString('NUMBER')
    AddTextComponentInteger(count)
    EndTextCommandScaleformString()

    ScaleformMovieMethodAddParamInt(255)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 1000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
end

RegisterNetEvent("gunfight:start1v1")
AddEventHandler("gunfight:start1v1", function()
    exports["sCore"]:setFreecamBypass(true)
    GUNFIGHT.in1v1 = true

    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
	SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())

    local randedCoords = cfg_gunfight["zone"]["spawnPos"][math.random(1, #cfg_gunfight["zone"]["spawnPos"])]

    SetEntityCoords(PlayerPedId(), randedCoords.pos)
    if randedCoords.heading then SetEntityHeading(PlayerPedId(), randedCoords.heading) end

    Citizen.Wait(0.7 * 1000)

    FreezeEntityPosition(PlayerPedId(), true)

    local timer = GetGameTimer() + 3 * 1000
    Citizen.CreateThread(function()
        BeginRace()
        while timer > GetGameTimer() do
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            ESX.Game.Utils.DrawText3D(vector3(x, y, z + 1.0), "~c~COMMENCE DANS 3 SECONDES...", 1.0)
            Citizen.Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

RegisterNetEvent("gunfight:asked1v1")
AddEventHandler("gunfight:asked1v1", function(sourceId, playerName)
    ESX.ShowNotification("~r~Demande de 1V1 contre ~s~"..playerName.."\n~s~~o~Y pour accepter\n~r~N pour refuser")

    local timer = GetGameTimer() + 5 * 1000
    Citizen.CreateThread(function()
        while timer > GetGameTimer() do
            if IsControlJustPressed(0, 246) then
                timer = 0
                TriggerServerEvent("gunfight:accept1v1", sourceId)
            end

            if IsControlJustPressed(0, 306) then
                timer = 0
                TriggerServerEvent("gunfight:decline1v1", sourceId)
            end

            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("gunfight:sendInfo")
AddEventHandler("gunfight:sendInfo", function(data)
    TriggerEvent("ui:gunfightinfo", {
        toggle = true,
        players = data.playersCount,
        myKills = data.myKills,
        myDeaths = data.myDeaths,
        myKda = data.myKda,
        lobbyName = data.lobbyName,
    })
end)

AddEventHandler('gameEventTriggered', function(name, eventData)
    if name == "CEventNetworkEntityDamage" and (GUNFIGHT.inZone or GUNFIGHT.in1v1) then
        local ped, victim, killer, isFatal, weaponHash = PlayerPedId(), eventData[1], eventData[2], eventData[6] == 1, tonumber(eventData[7])

        if weaponHash == GetHashKey("WEAPON_FALL") and isFatal then
            TriggerEvent("gunfight:gotKilled")
            return
        end

        local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer))
        if ped == victim and isFatal then
            setDcam(killer)

            TriggerServerEvent("gunfight:gotKilled", {
                killerId = killerId,
                in1v1 = GUNFIGHT.in1v1,
            })
        end
    end
end)

GUNFIGHT.handleSpawn = function()
    local waiter = GetGameTimer() + 1.5 * 1000
    Citizen.CreateThread(function()
        while waiter > GetGameTimer() do
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            ESX.Game.Utils.DrawText3D(vector3(x, y, z + 1.0), "~c~IMMUNITÉ DE 2 SECONDES", 1.0)

            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            SetPedMoveRateOverride(PlayerPedId(), 1.25)
            SetEntityAlpha(PlayerPedId(), 100, false)

            Citizen.Wait(0)
        end
        SetPedMoveRateOverride(PlayerPedId(), 1.0)
        ResetEntityAlpha(PlayerPedId())
    end)
end

RegisterNetEvent("gunfight:gotKilled")
AddEventHandler("gunfight:gotKilled", function()
	TriggerEvent("ui:deathscreenHide")
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
	SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())

    local randedCoords = cfg_gunfight["zone"]["spawnPos"][math.random(1, #cfg_gunfight["zone"]["spawnPos"])]

    SetEntityCoords(PlayerPedId(), randedCoords.pos)
    if randedCoords.heading then SetEntityHeading(PlayerPedId(), randedCoords.heading) end
    SetPedArmour(PlayerPedId(), 200)

    GUNFIGHT.handleSpawn()
end)

RegisterNetEvent("gunfight:joined")
AddEventHandler("gunfight:joined", function(lobbyName)
    exports["sCore"]:setFreecamBypass(true)
    local randedCoords = cfg_gunfight["zone"]["spawnPos"][math.random(1, #cfg_gunfight["zone"]["spawnPos"])]

    SetEntityCoords(PlayerPedId(), randedCoords.pos)
    if randedCoords.heading then SetEntityHeading(PlayerPedId(), randedCoords.heading) end

    GUNFIGHT.handleSpawn()
    GUNFIGHT.inZone = true
    GUNFIGHT.currentLobbyName = lobbyName or "Zone Gunfight"

    Citizen.CreateThread(function()
        while GUNFIGHT.inZone do
            local pool = GetGamePool('CVehicle')
            for k,v in pairs(pool) do
                if #(GetEntityCoords(v) - vector3(cfg_gunfight["zone"]["pos"])) < cfg_gunfight["zone"]["radius"] then
                    DeleteEntity(v)
                end
            end

            if #(GetEntityCoords(PlayerPedId()) - vector3(cfg_gunfight["zone"]["pos"])) > cfg_gunfight["zone"]["radius"] - 10 then
                ESX.ShowNotification("~r~Veuillez rester dans la zone de combat\n~s~Si vous voulez la quitter faites ~r~/gunfight")
                randedCoords = cfg_gunfight["zone"]["spawnPos"][math.random(1, #cfg_gunfight["zone"]["spawnPos"])]
                SetEntityCoords(PlayerPedId(), randedCoords.pos)
                if randedCoords.heading then SetEntityHeading(PlayerPedId(), randedCoords.heading) end
            end

            Citizen.Wait(5000)
        end
    end)

    Citizen.CreateThread(function()
        while GUNFIGHT.inZone do
            local pool = GetGamePool('CVehicle')
            for k,v in pairs(pool) do
                if #(GetEntityCoords(v) - vector3(cfg_gunfight["zone"]["pos"])) < cfg_gunfight["zone"]["radius"] then
                    DeleteEntity(v)
                end
            end

            SetPedDropsWeaponsWhenDead(PlayerPedId(), false)
            ClearPedBloodDamage(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearPedLastWeaponDamage(PlayerPedId())
            RemoveDecalsInRange(GetEntityCoords(PlayerPedId()), 100.0)

            Citizen.Wait(500)
        end
    end)
end)

RegisterNetEvent("gunfight:leaved")
AddEventHandler("gunfight:leaved", function()
    GUNFIGHT.inZone = false
    GUNFIGHT.currentLobbyName = nil
    TriggerEvent("ui:gunfightinfo", {
        toggle = false,
    })
    local entry = cfg_gunfight["entry"]
    SetEntityCoords(PlayerPedId(), entry.pos.x, entry.pos.y, entry.pos.z)
    SetPedArmour(PlayerPedId(), 0)
    Citizen.SetTimeout(3000, function()
        exports["sCore"]:setFreecamBypass(false)
    end)
end)

RegisterNetEvent('gunfight:healafterwin')
AddEventHandler('gunfight:healafterwin', function()
	local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
	SetEntityHealth(playerPed, maxHealth)
    SetPedArmour(playerPed, 200)
end)

local entryPed = nil

local function spawnEntryPed()
    if entryPed and DoesEntityExist(entryPed) then return end

    local cfg = cfg_gunfight["entry"]
    local model = joaat(cfg.ped.model)

    RequestModel(model)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(model) do
        Wait(10)
        if GetGameTimer() > timeout then return end
    end

    entryPed = CreatePed(4, model, cfg.pos.x, cfg.pos.y, cfg.pos.z - 1.0, cfg.heading, false, true)
    SetEntityAsMissionEntity(entryPed, true, true)
    FreezeEntityPosition(entryPed, true)
    SetEntityInvincible(entryPed, true)
    SetBlockingOfNonTemporaryEvents(entryPed, true)
    SetPedCanRagdoll(entryPed, false)

    if cfg.ped.scenario and cfg.ped.scenario ~= "" then
        TaskStartScenarioInPlace(entryPed, cfg.ped.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
end

CreateThread(function()
    spawnEntryPed()
end)

Citizen.CreateThread(function()
    while true do
        local nearThing = false
        local cfg = cfg_gunfight["entry"]
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local targetCoords = cfg.pos

        if entryPed and DoesEntityExist(entryPed) then
            targetCoords = GetEntityCoords(entryPed)
        end

        local dist = #(plyCoords - targetCoords)

        if dist < 35.0 then
            nearThing = true
            Draw3DTextH(targetCoords.x, targetCoords.y, targetCoords.z - 0.8, "Zone de tir", 4, 0.2, 0.2)

            if dist < 1.0 then
                ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour accéder à la Zone de tir")
                if IsControlJustPressed(1, 38) then
                    GUNFIGHT.openLobbyUI()
                end
            end
        end

        if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(1500)
        end
    end
end)

AddEventHandler("onResourceStop", function(resName)
    if resName ~= GetCurrentResourceName() then return end
    if entryPed and DoesEntityExist(entryPed) then
        DeleteEntity(entryPed)
    end
    entryPed = nil
end)

Citizen.CreateThread(function()
	local exitPos = cfg_gunfight["zone"]["pos"]
	while true do
		local nearThing = false
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, exitPos.x, exitPos.y, exitPos.z)

		if dist < 35.0 then
			nearThing = true
            DrawMarker(1, exitPos.x, exitPos.y, exitPos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 117, 31, 225, true, false)
            Draw3DTextH(exitPos.x, exitPos.y, exitPos.z - 0.5, "Sortie", 4, 0.2, 0.2)
			if dist < 3.0 then
				ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour sortir de la zone gunfight")
				if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("gunfight:leave")
				end
			end
		end

		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(250)
		end
	end
end)

RegisterCommand("gunfight", function()
    if GUNFIGHT.inZone then
        GUNFIGHT.openLobbyUI()
    end
end)

RegisterCommand("1v1", function(source, args, rawCommand)
    if GUNFIGHT.in1v1 then
        ESX.ShowNotification("~r~Vous êtes déjà en 1v1")
        return
    end

    if not args[1] then
        ESX.ShowNotification("~r~Vous n'avez pas indiqué d'ID")
        return
    end

    TriggerServerEvent("gunfight:1v1", tonumber(args[1]))
end)

Citizen.CreateThread(function()
    while true do
        local isGunfighting = false

        if GUNFIGHT.inZone then
            isGunfighting = true
            local playerPed = PlayerPedId()
            local _, weaponHash = GetCurrentPedWeapon(playerPed, true)

            if weaponHash ~= nil and weaponHash ~= `WEAPON_UNARMED` then
                AddAmmoToPed(playerPed, GetSelectedPedWeapon(playerPed), 50)
            end
        end

        if isGunfighting then
            Citizen.Wait(1000)
        else
            Citizen.Wait(10000)
        end
    end
end)

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function setDcam(ped)
    Citizen.CreateThread(function()
        Wait(200)
        cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(ped), 2.0, 2.0, 2.0, 90.0, true, 2)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        PointCamAtEntity(cam, ped, 0.0, 0.0, 0.0, true)
        AttachCamToEntity(cam, ped, vector3(0.0, 3.0, 1.0), true)

        Citizen.Wait(3.1*1000)
        DestroyCam(cam, false)
        RenderScriptCams(0, 0, 0, 1, 0)
    end)
end

AddEventHandler("playerSpawned", function()
    Wait(4000)
    TriggerServerEvent("gunfight.updatePosition")
end)

RegisterNetEvent("ui:update")
AddEventHandler("ui:update", function(playerCount)
    SendNUIMessage({
        type = "topRight",
        serverId = GetPlayerServerId(PlayerId()),
        onlineCount = playerCount
    })
end)

RegisterNetEvent("ui:gunfightinfo")
AddEventHandler("ui:gunfightinfo", function(info)
    SendNUIMessage({
        type = "gunfightinfo",
        toggle = info.toggle,
        players = info.players,
        myKills = info.myKills,
        myDeaths = info.myDeaths,
        myKda = info.myKda,
        lobbyName = info.lobbyName,
    })
end)
