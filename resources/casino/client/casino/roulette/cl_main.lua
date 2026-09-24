ROULETTE = {
    ["timeRemain"] = 0,
    ["sittingScene"] = nil,
    ["chairData"] = nil,
    ["selectedChairId"] = nil,
    ["selectedRoulette"] = nil,
    ["roulettes"] = {},
    ["nearRoulette"] = false,
    ["currentBet"] = 0,
    ["lastCalled"] = 0,
    ["aimingAtBet"] = -1,
    ["lastAimedBet"] = -1,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

SlotDrawAdvancedText = function(index, leftText, rightText)
	-- Rectangle
	DrawRect(0.933, 0.965 - (index * 0.036), 0.104, 0.032, 0, 0, 0, 150)
	-- Left Text
	SetTextFont(0)
	SetTextJustification(1)
	SetTextScale(0.29, 0.29)
	SetTextColour(255, 255, 255, 200)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(leftText)
	EndTextCommandDisplayText(0.933 - 0.048, 0.965 - (index * 0.036) - 0.012)
	-- Right Text
	SetTextFont(0)
	SetTextJustification(2)
	SetTextWrap(0, 0.933 + 0.048)
	SetTextScale(0.464, 0.464)
	SetTextColour(255, 255, 255, 200)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(rightText)
	EndTextCommandDisplayText(0.933 + 0.048, 0.965 - (index * 0.036) - 0.018)
end

DrawText3D = function(coords, text, size, a, font, dropShadow)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	local opacity = a or 255
	local font = font or 4

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, opacity)
		SetTextDropshadow(1, 1, 1, 1, 255)
		SetTextCentre(1)
		SetTextEntry('STRING')

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

SetupInstructionalButtons = function(buttons)
	local scaleform = RequestScaleformMovie("instructional_buttons")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
    
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)
    
	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	local i = 0
	for _, button in pairs(buttons) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(i)
		PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, button.key, true))
		BeginTextCommandScaleformString("STRING")
		AddTextComponentScaleform(button.label)
		EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		i = i + 1
	end

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(70)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

ROULETTE.createTable = function(index, data)
    local self = {}

    self.index = index
    self.data = data

    cfg_roulette.DebugMsg(string.format('Rulett table creating.. %s', self.index))

    if data.usemap then
        -- Le prop de table est fourni par le mapping : on récupère l'objet existant au lieu
        -- d'en créer un (sinon table en double). On ne touche pas à son heading.
        local mapModel = data.mapModel or `vw_prop_casino_roulette_01b`
        local existing = GetClosestObjectOfType(data.position.x, data.position.y, data.position.z, 5.0, mapModel, false, false, false)
        if existing == 0 or not DoesEntityExist(existing) then
            -- Prop pas encore streamé (joueur trop loin) : on réessaiera plus tard.
            return false
        end
        self.tableObject = existing
    else
        RequestModel(GetHashKey('vw_prop_casino_roulette_01'))
        while not HasModelLoaded(GetHashKey('vw_prop_casino_roulette_01')) do
            Citizen.Wait(1)
        end

        self.tableObject = CreateObject(GetHashKey('vw_prop_casino_roulette_01'), data.position, false)
        SetEntityHeading(self.tableObject, data.rot)
    end

    RequestModel(GetHashKey('S_F_Y_Casino_01'))
    while not HasModelLoaded(GetHashKey('S_F_Y_Casino_01')) do
        Citizen.Wait(1)
    end

    local pedOffset = GetObjectOffsetFromCoords(data.position.x, data.position.y, data.position.z, data.rot, 0.0, 0.7, 1.0)
    self.ped = CreatePed(2, GetHashKey('S_F_Y_Casino_01'), pedOffset, data.rot + 180.0, false, true)

    SetEntityCanBeDamaged(self.ped, 0)
    SetPedAsEnemy(self.ped, 0)
    SetBlockingOfNonTemporaryEvents(self.ped, 1)
    SetPedResetFlag(self.ped, 249, 1)
    SetPedConfigFlag(self.ped, 185, true)
    SetPedConfigFlag(self.ped, 108, true)
    SetPedCanEvasiveDive(self.ped, 0)
    SetPedCanRagdollFromPlayerImpact(self.ped, 0)
    SetPedConfigFlag(self.ped, 208, true)

    SetPedVoiceGroup(self.ped, 'S_M_Y_Casino_01_WHITE_01')
    addRandomClothes(self.ped)

    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 2, 0, true, true, true)

    self.numbersData = {}
    self.betData = {}
    self.hoverObjects = {}
    self.betObjects = {}
    self.ballObject = nil

    self.rouletteCamera = nil
    self.cameraMode = 1

    self.enableCamera = function(state)
        if state then
            self.speakPed('MINIGAME_DEALER_GREET')
            DisplayRadar(false)
            TriggerEvent("hud:toggle", "hunger")
            TriggerEvent("hud:toggle", "mic")
            TriggerEvent("hud:toggle", "coords")

            casinoNuiUpdateGame(self.index, self.ido, self.statusz)

            cfg_roulette.DebugMsg('creating camera..')
            local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
            self.rouletteCamera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', self.data.position.x, self.data.position.y, self.data.position.z + 2.0, rot.x, rot.y, rot.z, 80.0, true, 2)
            SetCamActive(self.rouletteCamera, true)
            RenderScriptCams(true, 900, 900, true, false)
            cfg_roulette.DebugMsg('camera setted active.')

            ROULETTE["selectedRoulette"] = self.index
            self.betRenderState(true)

            playRouletteIdle()

            Citizen.CreateThread(function()
                while ROULETTE["selectedRoulette"] ~= nil do
                    Citizen.Wait(1000)

                    if ROULETTE["lastCalled"] ~= nil then
                        ROULETTE["lastCalled"] = ROULETTE["lastCalled"] - 1
                        if ROULETTE["lastCalled"] < 1 then
                            cfg_roulette.DebugMsg('start idle')
                            ROULETTE["lastCalled"] = nil
                            playRouletteIdle()
                        end
                    end
                end
            end)

            Citizen.CreateThread(function()
                while ROULETTE["selectedRoulette"] ~= nil do
                    Citizen.Wait(1)

                    if self.betObjects then
                        for i = 1, #self.betObjects, 1 do
                            local bet = self.betObjects[i]
                            if DoesEntityExist(bet.obj) then
                                local coords = GetEntityCoords(bet.obj)
                                if bet.playerSrc == GetPlayerServerId(PlayerId()) then
                                    DrawText3D(vector3(coords.x, coords.y, coords.z), string.format('~w~%s', ESX.Math.GroupDigits(bet.betAmount)), 0.30, 255, 6)
                                end
                            end
                        end
                    end
                end
            end)

            Citizen.CreateThread(function()
                while ROULETTE["selectedRoulette"] ~= nil do
                    Citizen.Wait(125)

                    if IsDisabledControlPressed(0, 172) then
                        ROULETTE["currentBet"] = ROULETTE["currentBet"] + 10
                        changeBetAmount(ROULETTE["currentBet"])
                    elseif IsDisabledControlPressed(0, 173) then
                        if ROULETTE["currentBet"] > 0 then
                            ROULETTE["currentBet"] = ROULETTE["currentBet"] - 10

                            if ROULETTE["currentBet"] < 0 then
                                ROULETTE["currentBet"] = 0
                            end

                            changeBetAmount(ROULETTE["currentBet"])
                        end
                    end
                end
            end)

            Citizen.CreateThread(function()
                InstructionalButtons = SetupInstructionalButtons({ {key = 194, label = "Quitter"}, {key = 193, label = "Miser"}, {key = 46, label = "Changer de caméra"}, {key = 18, label = "Placer une mise"} })
                while ROULETTE["selectedRoulette"] ~= nil do
                    Citizen.Wait(0)
                    DisableAllControlActions(0)

                    EnableControlAction(0, 249, true)

                    DrawScaleformMovieFullscreen(InstructionalButtons, 255, 255, 255, 255, 0)

                    CASINO["playing"] = true

                    if ROULETTE["timeRemain"] > 0 then
                        SlotDrawAdvancedText(1, 'Temps', (ROULETTE["timeRemain"] < 10 and "00:0" or "00:") .. tostring(math.floor(ROULETTE["timeRemain"])))
                        if cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]].maxBet then
                            SlotDrawAdvancedText(2, 'Mise min', ESX.Math.GroupDigits(cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]].minBet))
                            SlotDrawAdvancedText(3, 'Mise max', ESX.Math.GroupDigits(cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]].maxBet))

                            if ROULETTE["currentBet"] then
                                SlotDrawAdvancedText(4, 'Mise', ESX.Math.GroupDigits(ROULETTE["currentBet"]))
                            end

                            local total = 0
                            for i = 1, #self.betObjects, 1 do
                                local bet = self.betObjects[i]
                                if DoesEntityExist(bet.obj) then
                                    local coords = GetEntityCoords(bet.obj)
                                    if bet.playerSrc == GetPlayerServerId(PlayerId()) then
                                        total = total + bet.betAmount
                                    end
                                end
                            end

                            if total then
                                SlotDrawAdvancedText(5, 'Mise totale', ESX.Math.GroupDigits(total))
                            end

                            if ROULETTE["myJetons"] then
                                SlotDrawAdvancedText(6, 'Jetons', ESX.Math.GroupDigits(ROULETTE["myJetons"]))
                            end
                        end
                    else
                        SlotDrawAdvancedText(1, 'Partie en cours...', '')
                    end

                    if IsDisabledControlJustPressed(0, 177) then
                        self.enableCamera(false)
                        PlaySoundFrontend(-1, 'FocusOut', 'HintCamSounds', false)
                    end

                    if IsDisabledControlJustPressed(0, 38) then
                        self.changeKameraMode()
                        PlaySoundFrontend(-1, 'FocusIn', 'HintCamSounds', false)
                    end

                    if IsDisabledControlJustPressed(0, 22) then --Custom Bet [space]
                        local tmpInput = getGenericTextInput("Indiquez votre mise")
                        if tonumber(tmpInput) then
                            tmpInput = tonumber(tmpInput)
                            if tmpInput > 0 then
                                changeBetAmount(tmpInput)
                            end
                        end
                    end
                end
            end)

            Citizen.Wait(1500)
        else
            CASINO["playing"] = false
            
            TriggerServerEvent('casino:rulett:notUsing', ROULETTE["selectedRoulette"])

            if DoesCamExist(self.rouletteCamera) then
                DestroyCam(self.rouletteCamera, false)
            end

            RenderScriptCams(false, 900, 900, true, false)
            self.betRenderState(false)
            cfg_roulette.DebugMsg('camera deleted.')
            ROULETTE["selectedRoulette"] = nil
            self.speakPed('MINIGAME_DEALER_LEAVE_NEUTRAL_GAME')

            NetworkStopSynchronisedScene(ROULETTE["sittingScene"])

            local endingDict = 'anim_casino_b@amb@casino@games@shared@player@'
            RequestAnimDict(endingDict)
            while not HasAnimDictLoaded(endingDict) do
                Citizen.Wait(1)
            end

            local whichAnim = nil
            if ROULETTE["selectedChairId"] == 1 then
                whichAnim = 'sit_exit_left'
            elseif ROULETTE["selectedChairId"] == 2 then
                whichAnim = 'sit_exit_right'
            elseif ROULETTE["selectedChairId"] == 3 then
                whichAnim = ({'sit_exit_left', 'sit_exit_right'})[math.random(1, 2)]
            elseif ROULETTE["selectedChairId"] == 4 then
                whichAnim = 'sit_exit_left'
            end

            TaskPlayAnim(PlayerPedId(), endingDict, whichAnim, 1.0, 1.0, 2500, 0)
            SetPlayerControl(PlayerId(), 0, 0)
            Citizen.Wait(3600)
            SetPlayerControl(PlayerId(), 1, 0)

            DisplayRadar(true)
            TriggerEvent("hud:toggle", "hunger")
            TriggerEvent("hud:toggle", "mic")
            TriggerEvent("hud:toggle", "coords")
        end
    end

    self.changeKameraMode = function()
        if DoesCamExist(self.rouletteCamera) then
            if self.cameraMode == 1 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                self.cameraMode = 2
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, -1.45, -0.15, 1.45)
                SetCamCoord(self.rouletteCamera, camOffset)
                SetCamRot(self.rouletteCamera, -25.0, 0.0, self.data.rot + 270.0, 2)
                SetCamFov(self.rouletteCamera, 40.0)
                ShakeCam(self.rouletteCamera, 'HAND_SHAKE', 0.3)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 2 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                self.cameraMode = 3
                local camOffset = GetOffsetFromEntityInWorldCoords(self.tableObject, 1.45, -0.15, 2.15)
                SetCamCoord(self.rouletteCamera, camOffset)
                SetCamRot(self.rouletteCamera, -58.0, 0.0, self.data.rot + 90.0, 2)
                ShakeCam(self.rouletteCamera, 'HAND_SHAKE', 0.3)
                SetCamFov(self.rouletteCamera, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 3 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                self.cameraMode = 4
                local camOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rouletteCamera, camOffset + vector3(0.0, 0.0, 0.5))
                SetCamRot(self.rouletteCamera, rot, 2)
                StopCamShaking(self.rouletteCamera, false)
                SetCamFov(self.rouletteCamera, 80.0)
                DoScreenFadeIn(200)
            elseif self.cameraMode == 4 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                self.cameraMode = 1
                local rot = vector3(270.0, -90.0, self.data.rot + 270.0)
                SetCamCoord(self.rouletteCamera, self.data.position + vector3(0.0, 0.0, 2.0))
                SetCamRot(self.rouletteCamera, rot, 2)
                SetCamFov(self.rouletteCamera, 80.0)
                StopCamShaking(self.rouletteCamera, false)
                DoScreenFadeIn(200)
            end
        end
    end

    self.loadTableData = function()
        cfg_roulette.DebugMsg('Table data creating, loading..')
        self.numbersData = {}
        self.betData = {}
        local e = 1
        for i = 0, 11, 1 do
            for j = 0, 2, 1 do
                table.insert(self.numbersData, {
                    name = e + 1,
                    hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                    hoverObject = 'vw_prop_vw_marker_02a'
                })

                local offset = nil
                if j == 0 then
                    offset = 0.155
                elseif j == 1 then
                    offset = 0.171
                elseif j == 2 then
                    offset = 0.192
                end

                table.insert(self.betData, {
                    betId = e,
                    name = e + 1,
                    pos = GetOffsetFromEntityInWorldCoords(self.tableObject, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                    objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.081 * i - 0.057, 0.167 * j - 0.192, 0.9448),
                    hoverNumbers = {e}
                })

                e = e + 1
            end
        end
        table.insert(self.numbersData, {
            name = 'Zero',
            hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
            hoverObject = 'vw_prop_vw_marker_01a'
        })
        table.insert(self.betData, {
            betId = #self.betData,
            name = 'Zero',
            pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
            objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.137, -0.148, 0.9448),
            hoverNumbers = {#self.numbersData}
        })
        table.insert(
            self.numbersData,
            {
                name = 'Double Zero',
                hoverPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverObject = 'vw_prop_vw_marker_01a'
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'Double Zero',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.133, 0.107, 0.9448),
                hoverNumbers = {#self.numbersData}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'RED',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.3, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'BLACK',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.5, -0.4, 0.9448),
                hoverNumbers = {0, 2, 4, 6, 8, 9, 11, 13, 15, 18, 20, 22, 24, 26, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'EVEN',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.15, -0.4, 0.9448),
                hoverNumbers = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = 'ODD',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.65, -0.4, 0.9448),
                hoverNumbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1to18',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, -0.02, -0.4, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '19to36',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.78, -0.4, 0.9448),
                hoverNumbers = {19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '1st 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.05, -0.3, 0.9448),
                hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2nd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.4, -0.3, 0.9448),
                hoverNumbers = {13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '3rd 12',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.75, -0.3, 0.9448),
                hoverNumbers = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, -0.15, 0.9448),
                hoverNumbers = {1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.0, 0.9448),
                hoverNumbers = {2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35}
            }
        )
        table.insert(
            self.betData,
            {
                betId = #self.betData,
                name = '2to1',
                pos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(self.tableObject, 0.91, 0.15, 0.9448),
                hoverNumbers = {3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36}
            }
        )

        cfg_roulette.DebugMsg('Table data successfully created..')
    end

    self.speakPed = function(speakName)
        PlayAmbientSpeech1(self.ped, speakName, 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR', 1)
    end

    self.createBetObjects = function(bets)
        for i = 1, #self.betObjects, 1 do
            if DoesEntityExist(self.betObjects[i].obj) then
                DeleteObject(self.betObjects[i].obj)
            end
        end

        self.betObjects = {}

        local existBetId = {}

        for i = 1, #bets, 1 do
            local t = self.betData[bets[i].betId]

            if existBetId[bets[i].betId] == nil then
                existBetId[bets[i].betId] = 0
            else
                existBetId[bets[i].betId] = existBetId[bets[i].betId] + 1
            end

            if t ~= nil then
                local betModelObject = getBetObjectType(bets[i].betAmount)

                if betModelObject ~= nil then
                    RequestModel(betModelObject)
                    while not HasModelLoaded(betModelObject) do
                        Citizen.Wait(0)
                    end

                    local obj = CreateObject(betModelObject, t.objectPos.x, t.objectPos.y, t.objectPos.z + (existBetId[bets[i].betId] * 0.0081), false)
                    SetEntityHeading(obj, self.data.rot)
                    table.insert(self.betObjects, {
                        obj = obj,
                        betAmount = bets[i].betAmount,
                        playerSrc = bets[i].playerSrc
                    })
                end
            end
        end
    end

    self.hoverNumbers = function(hoveredNumbers)
        for i = 1, #self.hoverObjects, 1 do
            if DoesEntityExist(self.hoverObjects[i]) then
                DeleteObject(self.hoverObjects[i])
            end
        end

        self.hoverObjects = {}

        for i = 1, #hoveredNumbers, 1 do
            local t = self.numbersData[hoveredNumbers[i]]
            if t ~= nil then
                RequestModel(GetHashKey(t.hoverObject))
                while not HasModelLoaded(GetHashKey(t.hoverObject)) do
                    Citizen.Wait(1)
                end

                local obj = CreateObject(GetHashKey(t.hoverObject), t.hoverPos, false)
                SetEntityHeading(obj, self.data.rot)

                table.insert(self.hoverObjects, obj)
            end
        end
    end

    self.betRenderState = function(state)
        enabledBetRender = state

        cfg_roulette.DebugMsg('Bet rendering turned: %s', enabledBetRender)

        if state then
            Citizen.CreateThread(function()
                while enabledBetRender do
                    Citizen.Wait(8)

                    if ROULETTE["aimingAtBet"] ~= -1 and ROULETTE["lastAimedBet"] ~= ROULETTE["aimingAtBet"] then
                        cfg_roulette.DebugMsg('aimed at different bet.')
                        ROULETTE["lastAimedBet"] = ROULETTE["aimingAtBet"]
                        local bettingData = self.betData[ROULETTE["aimingAtBet"]]
                        if bettingData ~= nil then
                            self.hoverNumbers(bettingData.hoverNumbers)
                        else
                            self.hoverNumbers({})
                        end
                    end

                    if ROULETTE["aimingAtBet"] == -1 and ROULETTE["lastAimedBet"] ~= -1 then
                        self.hoverNumbers({})
                    end
                end
            end)

            Citizen.CreateThread(function()
                while enabledBetRender do
                    Citizen.Wait(0)

                    ShowCursorThisFrame()

                    local e = ROULETTE["roulettes"][ROULETTE["selectedRoulette"]]
                    if e ~= nil then
                        local cx, cy = GetNuiCursorPosition()
                        local rx, ry = GetActiveScreenResolution()

                        local n = 30 -- this is for the cursor point, how much to tolerate in range, increasing it you will find it easier to click on the bets.

                        local foundBet = false

                        for i = 1, #self.betData, 1 do
                            local bettingData = self.betData[i]
                            local onScreen, screenX, screenY = World3dToScreen2d(bettingData.pos.x, bettingData.pos.y, bettingData.pos.z)
                            local l = math.sqrt(math.pow(screenX * rx - cx, 2) + math.pow(screenY * ry - cy, 2))
                            if l < n then
                                ROULETTE["aimingAtBet"] = i
                                foundBet = true

                                if IsDisabledControlJustPressed(0, 24) then
                                    if ROULETTE["currentBet"] > 0 then
                                        if cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]] ~= nil then
                                            if ROULETTE["currentBet"] >= cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]].minBet and ROULETTE["currentBet"] <= cfg_roulette.RulettTables[ROULETTE["selectedRoulette"]].maxBet then
                                                PlaySoundFrontend(-1, 'DLC_VW_BET_DOWN', 'dlc_vw_table_games_frontend_sounds', true)
                                                TriggerServerEvent('casino:taskBetRulett', ROULETTE["selectedRoulette"], ROULETTE["aimingAtBet"], ROULETTE["currentBet"])
                                            else
                                                ESX.ShowNotification("~r~Mise invalide")
                                            end
                                        end
                                    else
                                        ESX.ShowNotification("~r~Mise invalide")
                                    end
                                end
                            end
                        end

                        if not foundBet then
                            ROULETTE["aimingAtBet"] = -1
                        end
                    end
                end
            end)
        end
    end

    function GetExitBallSoundForResult(result)
        return 'dlc_vw_roulette_exit_'..result
    end

    function GetWinSpeechForResult(result)
        if result == 37 then result = '00' end
        return 'MINIGAME_ROULETTE_BALL_'..cfg_roulette.rouletteSzamok[result]
    end

    self.spinRulett = function(tickRate)
        cfg_roulette.DebugMsg(self.index)
        if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
            cfg_roulette.DebugMsg('spinRulett event 1')

            self.speakPed('MINIGAME_DEALER_CLOSED_BETS')
            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'no_more_bets', 3.0, 3.0, -1, 0, 0, true, true, true)

            Citizen.Wait(1500)

            if DoesEntityExist(self.ballObject) then
                DeleteObject(self.ballObject)
            end

            TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'spin_wheel', 3.0, 3.0, -1, 0, 0, true, true, true)

            RequestModel(GetHashKey('vw_prop_roulette_ball'))
            while not HasModelLoaded(GetHashKey('vw_prop_roulette_ball')) do
                Citizen.Wait(1)
            end

            local ballOffset = GetWorldPositionOfEntityBone(self.tableObject, GetEntityBoneIndexByName(self.tableObject, 'Roulette_Wheel'))

            cfg_roulette.DebugMsg('spinRulett event 2')

            local LIB = 'anim_casino_b@amb@casino@games@roulette@table'
            RequestAnimDict(LIB)
            while not HasAnimDictLoaded(LIB) do
                Citizen.Wait(1)
            end

            Citizen.Wait(3000)

            self.ballObject = CreateObject(GetHashKey('vw_prop_roulette_ball'), ballOffset, false)
            SetEntityHeading(self.ballObject, self.data.rot)
            SetEntityCoordsNoOffset(self.ballObject, ballOffset, false, false, false)
            local h = GetEntityRotation(self.ballObject)
            SetEntityRotation(self.ballObject, h.x, h.y, h.z + 90.0, 2, false)

            if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                cfg_roulette.DebugMsg('spinRulett event 3')

                local soundId = GetSoundId()
                PlaySoundFromEntity(soundId, 'DLC_VW_ROULETTE_BALL_LOOP', self.ballObject, 'dlc_vw_table_games_sounds', false, 0)

                PlayEntityAnim(self.ballObject, 'intro_ball', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.ballObject, 'loop_ball', LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(self.tableObject, 'intro_wheel', LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(self.tableObject, 'loop_wheel', LIB, 1000.0, false, true, false, 0, 136704)

                StopSound(soundId)
                PlaySoundFromEntity(soundId, GetExitBallSoundForResult(tickRate), self.ballObject, 'dlc_vw_table_games_roulette_exit_sounds', false, 0)

                PlayEntityAnim(self.ballObject, string.format('exit_%s_ball', tickRate), LIB, 1000.0, false, true, false, 0, 136704)
                PlayEntityAnim(self.tableObject, string.format('exit_%s_wheel', tickRate), LIB, 1000.0, false, true, false, 0, 136704)

                Citizen.Wait(11e3)

                PlayAmbientSpeech1(self.ped, GetWinSpeechForResult(tickRate), 'SPEECH_PARAMS_FORCE_NORMAL_CLEAR')

                if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone1', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Citizen.Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone2', 3.0, 3.0, -1, 0, 0, true, true, true)
                    Citizen.Wait(1500)
                    TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'clear_chips_zone3', 3.0, 3.0, -1, 0, 0, true, true, true)

                    Citizen.Wait(2000)
                    if DoesEntityExist(self.tableObject) and DoesEntityExist(self.ped) then
                        TaskPlayAnim(self.ped, 'anim_casino_b@amb@casino@games@roulette@dealer_female', 'idle', 3.0, 3.0, -1, 0, 0, true, true, true)
                    end

                    cfg_roulette.DebugMsg('spinRulett event ending')

                    if DoesEntityExist(self.ballObject) then
                        DeleteObject(self.ballObject)
                    end
                end
            end
        end
    end

    self.loadTableData()
    cfg_roulette.DebugMsg(string.format('Rulett table created %s id', self.index))
    ROULETTE["roulettes"][self.index] = self
    return true
end

function changeBetAmount(amount)
    ROULETTE["currentBet"] = amount
    PlaySoundFrontend(-1, 'DLC_VW_BET_HIGHLIGHT', 'dlc_vw_table_games_frontend_sounds', true)
end

function getGenericTextInput(type)
    if type == nil then
        type = ''
    end
    AddTextEntry('FMMC_MPM_NA', tostring(type))
    DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', tostring(type), '', '', '', '', 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            return result
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        ROULETTE["nearRoulette"] = false
        for k, v in pairs(cfg_roulette.RulettTables) do
            if #(playerCoords - cfg_roulette.RulettTables[k].position) < 100.0 then
                ROULETTE["nearRoulette"] = true
            end
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while not ROULETTE["nearRoulette"] do
        Citizen.Wait(0)
    end

    RequestAnimDict('anim_casino_b@amb@casino@games@roulette@table')
    RequestAnimDict('anim_casino_b@amb@casino@games@roulette@dealer_female')
    RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
    RequestAnimDict('anim_casino_b@amb@casino@games@roulette@player')

    -- createTable renvoie false pour les tables "usemap" tant que le prop du mapping
    -- n'est pas encore streamé. On réessaie jusqu'à ce que toutes soient créées.
    local created = {}
    while true do
        for rulettIndex, data in pairs(cfg_roulette.RulettTables) do
            if not created[rulettIndex] then
                if ROULETTE.createTable(rulettIndex, data) then
                    created[rulettIndex] = true
                end
            end
        end

        local allDone = true
        for rulettIndex in pairs(cfg_roulette.RulettTables) do
            if not created[rulettIndex] then
                allDone = false
                break
            end
        end
        if allDone then
            break
        end

        Citizen.Wait(1000)
    end

    cfg_roulette.DebugMsg('Casino rulett loaded.')
end)

-- Les tables "usemap" pointent vers un prop streamé par le mapping : son handle change
-- quand on s'éloigne puis revient. On garde la référence à jour pour ne pas casser la table.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        for rulettIndex, data in pairs(cfg_roulette.RulettTables) do
            if data.usemap then
                local t = ROULETTE["roulettes"][rulettIndex]
                if t and not (t.tableObject and DoesEntityExist(t.tableObject)) then
                    local mapModel = data.mapModel or `vw_prop_casino_roulette_01b`
                    local existing = GetClosestObjectOfType(data.position.x, data.position.y, data.position.z, 5.0, mapModel, false, false, false)
                    if existing ~= 0 and DoesEntityExist(existing) then
                        t.tableObject = existing
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local letSleep = true

        local playerpos = GetEntityCoords(PlayerPedId())

        if ROULETTE["nearRoulette"] and ROULETTE["selectedRoulette"] == nil then
            for k, v in pairs(ROULETTE["roulettes"]) do
                if DoesEntityExist(v.tableObject) then
                    local objcoords = GetEntityCoords(v.tableObject)
                    local dist = Vdist(playerpos, objcoords)
                    if dist < 4.0 then
                        -- CASINO["nearThing"] = true
                        letSleep = false

                        local closestChairData = getClosestChairData(v.tableObject)
                        if closestChairData == nil then
                            break
                        end

                        DrawMarker(20, closestChairData.position + vector3(0.0, 0.0, 1.0), nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)

                        ESX.ShowHelpNotification("Appuyez sur E pour jouer à la roulette")

                        if not v.called then
                            v.called = true
                            PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)
                        end

                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('server_remote:rulett:taskSitDown', k, closestChairData)
                        end
                        
                        break
                    else
                        v.called = false
                        -- CASINO["nearThing"] = false
                    end
                end
            end
        end

        if letSleep then
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('client_callback:rulett:taskSitDown')
AddEventHandler('client_callback:rulett:taskSitDown', function(rulettIndex, chairData)
    ROULETTE["selectedChairId"] = chairData.chairId
    ROULETTE["chairData"] = chairData
    ROULETTE["sittingScene"] = NetworkCreateSynchronisedScene(chairData.position, chairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
    RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
    while not HasAnimDictLoaded('anim_casino_b@amb@casino@games@shared@player@') do
        Citizen.Wait(1)
    end

    local randomSit = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ROULETTE["sittingScene"], 'anim_casino_b@amb@casino@games@shared@player@', randomSit, 2.0, -2.0, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(ROULETTE["sittingScene"])
    SetPlayerControl(PlayerId(), 0, 0)
    startRulett(rulettIndex, chairData.chairId)
    Citizen.Wait(4000)
    SetPlayerControl(PlayerId(), 1, 0)
end)

function startRulett(index, chairId)
    if ROULETTE["roulettes"][index] then
        TriggerServerEvent('casino:taskStartRoulette', index, chairId)
    end
end

RegisterNetEvent('client:casino:openRulett')
AddEventHandler('client:casino:openRulett', function(rulettIndex)
    if ROULETTE["roulettes"][rulettIndex] ~= nil then
        Citizen.Wait(4000)
        ROULETTE["roulettes"][rulettIndex].enableCamera(true)
    end
end)

RegisterNetEvent('casino:rulett:startSpin')
AddEventHandler('casino:rulett:startSpin', function(rulettIndex, tickRate)
    if ROULETTE["roulettes"][rulettIndex] ~= nil then
        cfg_roulette.DebugMsg(string.format('rulett table index: %s, tickrate: %s', rulettIndex, tickRate))
        ROULETTE["roulettes"][rulettIndex].spinRulett(tickRate)

        if ROULETTE["selectedRoulette"] == rulettIndex then
            cfg_roulette.DebugMsg('impartial anim play')
            playImpartial()
        end
    end
end)

RegisterNetEvent('client:rulett:updateStatusz')
AddEventHandler('client:rulett:updateStatusz', function(rulettIndex, ido, statusz)
    if ROULETTE["roulettes"][rulettIndex] ~= nil then
        ROULETTE["roulettes"][rulettIndex].ido = ido
        ROULETTE["roulettes"][rulettIndex].statusz = statusz
        casinoNuiUpdateGame(rulettIndex, ido, statusz)
    end
end)

RegisterNetEvent('client:rulett:updateTableBets')
AddEventHandler('client:rulett:updateTableBets', function(rulettIndex, bets)
    if ROULETTE["roulettes"][rulettIndex] ~= nil then
        ROULETTE["roulettes"][rulettIndex].createBetObjects(bets)
    end
end)

function casinoNuiUpdateGame(rulettIndex, ido, statusz)
    if ROULETTE["selectedRoulette"] == rulettIndex then
        if not statusz then
            ROULETTE["timeRemain"] = ido
        else
            ROULETTE["timeRemain"] = 0
        end
    end
end

RegisterNetEvent('casino:nui:updateChips')
AddEventHandler('casino:nui:updateChips', function(amount)
    ROULETTE["myJetons"] = amount
end)

function getClosestChairData(tableObject)
    local localPlayer = PlayerPedId()
    local playerpos = GetEntityCoords(localPlayer)
    if DoesEntityExist(tableObject) then
        local chairs = {'Chair_Base_01', 'Chair_Base_02', 'Chair_Base_03', 'Chair_Base_04'}
        for i = 1, #chairs, 1 do
            local objcoords = GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i]))
            local dist = Vdist(playerpos, objcoords)
            if dist < 1.7 then
                return {
                    position = objcoords,
                    rotation = GetWorldRotationOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i])),
                    chairId = cfg_roulette.ChairIds[chairs[i]]
                }
            end
        end
    end
end

function getBetObjectType(betAmount)
    if betAmount < 10 then
        return GetHashKey('vw_prop_vw_coin_01a')
    elseif betAmount >= 10 and betAmount < 50 then
        return GetHashKey('vw_prop_chip_10dollar_x1')
    elseif betAmount >= 50 and betAmount < 100 then
        return GetHashKey('vw_prop_chip_50dollar_x1')
    elseif betAmount >= 100 and betAmount < 500 then
        return GetHashKey('vw_prop_chip_100dollar_x1')
    elseif betAmount >= 500 and betAmount < 1000 then
        return GetHashKey('vw_prop_chip_500dollar_x1')
    elseif betAmount >= 1000 and betAmount < 5000 then
        return GetHashKey('vw_prop_chip_1kdollar_x1')
    elseif betAmount >= 5000 then
        return GetHashKey('vw_prop_plaq_10kdollar_x1')
    elseif betAmount >= 10000 and betAmount < 25000 then
        return GetHashKey('vw_prop_vw_chips_pile_01a')
    elseif betAmount >= 25000 and betAmount < 50000 then
        return GetHashKey('vw_prop_vw_chips_pile_02a')
    elseif betAmount >= 50000 then
        return GetHashKey('vw_prop_vw_chips_pile_03a')
    end
end

RegisterNetEvent('client:rulett:playBetAnim')
AddEventHandler('client:rulett:playBetAnim', function(chairId)
    local sex = 0

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    local rot = ROULETTE["chairData"].rotation

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@play@v01', chairId, chairId)
    if sex == 1 then
        L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@play@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Citizen.Wait(1)
    end

    if ROULETTE["chairData"] ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(ROULETTE["chairData"].position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene( PlayerPedId(), currentScene, L, ({'place_bet_zone1', 'place_bet_zone2', 'place_bet_zone3'})[math.random(1, 3)], 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        ROULETTE["lastCalled"] = 8
    end
end)

RegisterNetEvent('client:rulett:playWinAnim')
AddEventHandler('client:rulett:playWinAnim', function(chairId)
    local rot = ROULETTE["chairData"].rotation

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Citizen.Wait(1)
    end

    if ROULETTE["chairData"] ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(ROULETTE["chairData"].position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, 'reaction_great', 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        ROULETTE["lastCalled"] = 8
    end
end)

RegisterNetEvent('client:rulett:playLossAnim')
AddEventHandler('client:rulett:playLossAnim', function(chairId)
    local rot = ROULETTE["chairData"].rotation

    if chairId == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairId == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairId == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairId == 1 then
        chairId = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', chairId, chairId)
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Citizen.Wait(1)
    end

    if ROULETTE["chairData"] ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(ROULETTE["chairData"].position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene( PlayerPedId(), currentScene, L, ({'reaction_bad_var01', 'reaction_bad_var02', 'reaction_terrible'})[math.random(1, 3)], 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        ROULETTE["lastCalled"] = 8
    end
end)

function playImpartial()
    local rot = ROULETTE["chairData"].rotation

    if ROULETTE["selectedChairId"] == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif ROULETTE["selectedChairId"] == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif ROULETTE["selectedChairId"] == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif ROULETTE["selectedChairId"] == 1 then
        ROULETTE["selectedChairId"] = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01', ROULETTE["selectedChairId"], ROULETTE["selectedChairId"])

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01', ROULETTE["selectedChairId"], ROULETTE["selectedChairId"])
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Citizen.Wait(1)
    end

    if ROULETTE["chairData"] ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(ROULETTE["chairData"].position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, ({'reaction_impartial_var01', 'reaction_impartial_var02', 'reaction_impartial_var03'})[math.random(1, 3)], 4.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)

        ROULETTE["lastCalled"] = 8
    end
end

function playRouletteIdle()
    local rot = ROULETTE["chairData"].rotation

    if ROULETTE["selectedChairId"] == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif ROULETTE["selectedChairId"] == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif ROULETTE["selectedChairId"] == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif ROULETTE["selectedChairId"] == 1 then
        ROULETTE["selectedChairId"] = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@idles', ROULETTE["selectedChairId"], ROULETTE["selectedChairId"])

    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        sex = 1
    end

    if sex == 1 then
        local L = string.format('anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@idles', ROULETTE["selectedChairId"], ROULETTE["selectedChairId"])
    end

    RequestAnimDict(L)
    while not HasAnimDictLoaded(L) do
        Citizen.Wait(1)
    end

    if ROULETTE["chairData"] ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(ROULETTE["chairData"].position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, L, ({'idle_a', 'idle_b', 'idle_c', 'idle_d'})[math.random(1, 4)], 1.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)
    end
end

function addRandomClothes(entity)
    SetPedDefaultComponentVariation(entity)
    SetPedComponentVariation(entity, 0, 2, 1, 0)
    SetPedComponentVariation(entity, 1, 0, 0, 0)
    SetPedComponentVariation(entity, 2, 2, 1, 0)
    SetPedComponentVariation(entity, 3, 3, 3, 0)
    SetPedComponentVariation(entity, 4, 1, 0, 0)
    SetPedComponentVariation(entity, 6, 1, 0, 0)
    SetPedComponentVariation(entity, 7, 2, 0, 0)
    SetPedComponentVariation(entity, 8, 3, 0, 0)
    SetPedComponentVariation(entity, 10, 0, 0, 0)
    SetPedComponentVariation(entity, 11, 0, 0, 0)
    SetPedVoiceGroup(entity, `S_F_Y_Casino_01_ASIAN_02`)
end