local radioChannel = 0
local radioNames = {}

--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
---@param localPlyRadioName string the local players name
function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	playMicClicks(enabled)
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	if radioPressed then
		logger.info('[radio] %s joined radio %s while we were talking, adding them to targets', plySource, radioChannel)
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info('[radio] %s joined radio %s', plySource, radioChannel)
	end
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		if radioPressed then
			ExecuteCommand('-radiotalk')
		end
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		radioNames = {}
		radioData = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end
RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({channel, "number"})
	-- si on change/quitte de canal en pleine transmission, on coupe pour ne pas
	-- laisser le micro bloqué sur l'ancien canal.
	if radioPressed and channel ~= radioChannel then
		ExecuteCommand('-radiotalk')
	end
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
	sendUIMessage({
		radioChannel = channel,
		radioEnabled = radioEnabled
	})
end

--- exports setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
exports('setRadioChannel', setRadioChannel)
-- mumble-voip compatability
exports('SetRadioChannel', setRadioChannel)

--- exports removePlayerFromRadio
--- sets the local players current radio channel and updates the server
exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

--- exports addPlayerToRadio
--- sets the local players current radio channel and updates the server
---@param _radio number the channel to set the player to, or 0 to remove them.
exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed.
function isDead()
	if GetResourceState("pma-ambulance") ~= "missing" then
		if LocalPlayer.state.isDead then
			return true
		end
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

-- Initialisation globale (si non défini ailleurs dans le code)
if not gPlayer then
    gPlayer = {}
end

local function isFiring()
    local ped = PlayerPedId()
    return IsPedShooting(ped) or IsControlPressed(0, 24)
end

-- Failsafe micro bloqué : on surveille l'état physique réel de la touche radio.
-- Quand on alt-tab ou qu'un menu NUI (téléphone, inventaire...) vole le focus pendant
-- qu'on tient la touche, le jeu rate parfois le "-radiotalk" -> radioPressed reste bloqué
-- et le micro reste ouvert tout seul. IsRawKeyDown lit le clavier indépendamment du focus,
-- ce qui permet de détecter le relâchement réel et de couper la radio.
local keyNameToVk = {
    LMENU = 0xA4, RMENU = 0xA5,
    LCONTROL = 0xA2, RCONTROL = 0xA3,
    LSHIFT = 0xA0, RSHIFT = 0xA1,
    TAB = 0x09, SPACE = 0x20, CAPITAL = 0x14,
    BACK = 0x08, RETURN = 0x0D, ESCAPE = 0x1B,
    INSERT = 0x2D, DELETE = 0x2E, HOME = 0x24, ["END"] = 0x23,
    PRIOR = 0x21, NEXT = 0x22,
    UP = 0x26, DOWN = 0x28, LEFT = 0x25, RIGHT = 0x27,
    GRAVE = 0xC0,
    MULTIPLY = 0x6A, ADD = 0x6B, SUBTRACT = 0x6D, DECIMAL = 0x6E, DIVIDE = 0x6F,
}
for i = 1, 12 do keyNameToVk['F' .. i] = 0x70 + (i - 1) end
for i = 0, 9 do keyNameToVk['NUMPAD' .. i] = 0x60 + i end

local function resolveRadioKeyVk()
    local key = GetConvar('voice_defaultRadio', 'LMENU'):upper()
    if keyNameToVk[key] then return keyNameToVk[key] end
    if #key == 1 then
        local b = key:byte()
        -- A-Z et 0-9 partagent la même valeur que leur code clavier Windows
        if (b >= 65 and b <= 90) or (b >= 48 and b <= 57) then
            return b
        end
    end
    return nil
end

local radioKeyVk = resolveRadioKeyVk()

RegisterCommand('+radiotalk', function()
    if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end

    -- Failsafe anti micro bloqué : si on reçoit un nouvel appui alors que radioPressed
    -- est encore actif, c'est que le "-radiotalk" précédent a été perdu (alt-tab, NUI,
    -- touche remappée non couverte par le failsafe clavier...). Un + ne se redéclenche
    -- jamais tant qu'on tient la touche, donc on peut couper sans risque.
    if radioPressed then
        logger.info('[radio] +radiotalk reçu alors que la transmission est déjà active, micro bloqué -> on coupe.')
        ExecuteCommand('-radiotalk')
        return
    end

    if isDead() then return end
	if isFiring() then return end

    if not radioPressed and radioEnabled then
        if radioChannel > 0 then
            logger.info('[radio] Start broadcasting, update targets and notify server.')
            playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
            TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
            radioPressed = true
            playMicClicks(true)

			if exports["sunlife"]:GetRadioAnim() == "default" then
				local ped = PlayerPedId()
				local model = `prop_cs_hand_radio`
				RequestAnimDict('anim@male@holding_radio')
				RequestModel(model)
				while not HasAnimDictLoaded('anim@male@holding_radio') or not HasModelLoaded(model) do
					Citizen.Wait(10)
				end

				print(('^2[NETDIAG][OBJET]^7 %s radio.lua:221 CreateObject NETWORKED radio-prop'):format(GetCurrentResourceName()))
				gPlayer.prop = CreateObject(model, 0.0, 0.0, 0.0, true, true, true)
				AttachEntityToEntity(gPlayer.prop, ped, GetPedBoneIndex(ped, 28422), 0.0750, 0.0230, -0.0230, -90.0, 0.0, -59.9999, true, true, false, true, 0, true)

					-- Jouer l'animation
				TaskPlayAnim(ped, "anim@male@holding_radio", "holding_radio_clip", 8.0, 2.0, -1, 50, 0.0, false, false, false)
			end

            Citizen.CreateThread(function()
                TriggerEvent("pma-voice:radioActive", true)
                -- On n'arme le failsafe que si la touche par défaut est bien celle
                -- physiquement enfoncée (sinon le joueur a remappé sa touche, et on
                -- éviterait de couper à tort). On laisse une petite fenêtre d'armement
                -- car la commande peut être traitée une frame avant que IsRawKeyDown
                -- ne voie la touche.
                local watchKey = false
                local armDeadline = GetGameTimer() + 250
                while radioPressed do
                    Wait(0)
                    SetControlNormal(0, 249, 1.0)
                    SetControlNormal(1, 249, 1.0)
                    SetControlNormal(2, 249, 1.0)
                    if radioKeyVk then
                        if not watchKey and GetGameTimer() < armDeadline and IsRawKeyDown(radioKeyVk) then
                            watchKey = true
                        end
                        if watchKey and not IsRawKeyDown(radioKeyVk) then
                            logger.info('[radio] Touche radio relâchée détectée (failsafe), on coupe la transmission.')
                            ExecuteCommand('-radiotalk')
                            break
                        end
                    end
                end
            end)
        end
    end
end, false)

RegisterCommand('-radiotalk', function()
    -- On coupe dès que radioPressed est actif, même si entre temps le joueur a quitté
    -- le canal ou que la radio a été désactivée : sinon l'état reste bloqué en "parle".
    if radioPressed then
        radioPressed = false
        MumbleClearVoiceTargetPlayers(voiceTarget)
        playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
        TriggerEvent("pma-voice:radioActive", false)
        playMicClicks(false)

        local ped = PlayerPedId()
        StopAnimTask(ped, "anim@male@holding_radio", "holding_radio_clip", -4.0)

        if gPlayer.prop then
            DetachEntity(gPlayer.prop, true, true)
            DeleteObject(gPlayer.prop)
            gPlayer.prop = nil -- Nettoyage
        end

        TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
    end
end, false)

if gameVersion == 'fivem' then
    RegisterKeyMapping('+radiotalk', 'Parler dans la radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	if radioPressed and _radioChannel ~= radioChannel then
		ExecuteCommand('-radiotalk')
	end
	radioChannel = _radioChannel
end
RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)
