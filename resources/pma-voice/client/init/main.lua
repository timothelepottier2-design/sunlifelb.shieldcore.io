local mutedPlayers = {}

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 30) / 100,
	['phone'] = GetConvarInt('voice_defaultPhoneVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}

--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			-- print(('^3[NETDIAG][STATEBAG]^7 %s main.lua:25 LocalPlayer.state:set %s (replicated)'):format(GetCurrentResourceName(), tostring(volumeType)))
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		-- _ is here to not mess with global 'type' function
		for _type, vol in pairs(volumes) do
			volumes[_type] = volume
			-- print(('^3[NETDIAG][STATEBAG]^7 %s main.lua:34 LocalPlayer.state:set %s (replicated)'):format(GetCurrentResourceName(), tostring(_type)))
			LocalPlayer.state:set(_type, volume, true)
		end
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'phone')
end)
exports('getCallVolume', function()
	return volumes['phone']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	SetAudioSubmixEffectParamInt(radioEffectId, 0, `default`, 1)
	AddAudioSubmixOutput(radioEffectId, 0)

	phoneEffectId = CreateAudioSubmix('Phone')
	SetAudioSubmixEffectRadioFx(phoneEffectId, 1)
	SetAudioSubmixEffectParamInt(phoneEffectId, 1, `default`, 1)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_low`, 300.0)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_hi`, 6000.0)
	AddAudioSubmixOutput(phoneEffectId, 1)
end

local submixFunctions = {
	['radio'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, radioEffectId)
	end,
	['phone'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, phoneEffectId)
	end
}

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				submixFunctions[moduleType](plySource)
			else
				MumbleSetSubmixForServerId(plySource, -1)
			end
		end
	else
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					MumbleSetSubmixForServerId(plySource, -1)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click. 
function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and volumes["radio"] or 0.05)
	})
end

--- check if player is muted
exports('isPlayerMuted', function(source)
	return mutedPlayers[source]
end)

--- getter for mutedPlayers
exports('getMutedPlayers', function()
	return mutedPlayers
end)

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)

-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)


if gameVersion == 'fivem' then
	-- Failsafe anti micro bloqué pour la touche "parler" (N / INPUT_PUSH_TO_TALK).
	-- Bug connu de FiveM : quand un NUI ou un alt-tab vole le focus pendant qu'on tient
	-- la touche, le jeu rate le relâchement et l'état "appuyé" du contrôle 249 reste
	-- figé -> le joueur parle en continu même touche relâchée. On surveille donc l'état
	-- physique réel de la touche (IsRawKeyDown lit le clavier indépendamment du focus)
	-- et si le contrôle reste "appuyé" alors que la touche est relâchée, on force le
	-- contrôle à 0 jusqu'à ce que le jeu se resynchronise ou que le joueur rappuie.
	local PTT_CONTROL = 249 -- INPUT_PUSH_TO_TALK

	local pttNameToVk = {
		LMENU = 0xA4, RMENU = 0xA5,
		LCONTROL = 0xA2, RCONTROL = 0xA3,
		LSHIFT = 0xA0, RSHIFT = 0xA1,
		TAB = 0x09, SPACE = 0x20, CAPITAL = 0x14,
		BACK = 0x08, RETURN = 0x0D,
		INSERT = 0x2D, DELETE = 0x2E, HOME = 0x24, ["END"] = 0x23,
		PRIOR = 0x21, NEXT = 0x22,
		UP = 0x26, DOWN = 0x28, LEFT = 0x25, RIGHT = 0x27,
		GRAVE = 0xC0,
		MULTIPLY = 0x6A, ADD = 0x6B, SUBTRACT = 0x6D, DECIMAL = 0x6E, DIVIDE = 0x6F,
	}
	for i = 1, 12 do pttNameToVk['F' .. i] = 0x70 + (i - 1) end
	for i = 0, 9 do pttNameToVk['NUMPAD' .. i] = 0x60 + i end

	-- Résout la touche clavier réellement assignée au push-to-talk dans les
	-- paramètres du joueur (et pas seulement la touche par défaut N).
	local function resolvePttVk()
		local btn = GetControlInstructionalButton(0, PTT_CONTROL, true)
		local key = btn and btn:match('^t_(.+)$')
		if not key then return nil end -- touche non clavier (manette, souris...), on ne surveille pas
		key = key:upper()
		if pttNameToVk[key] then return pttNameToVk[key] end
		if #key == 1 then
			local b = key:byte()
			if (b >= 65 and b <= 90) or (b >= 48 and b <= 57) then
				return b
			end
		end
		return nil
	end

	CreateThread(function()
		local watchedVk = nil -- touche surveillée pour l'appui en cours
		local stuckSince = nil
		while true do
			Wait(50)
			if radioPressed then
				-- la radio force volontairement le contrôle 249 pendant la transmission,
				-- on ne doit pas interpréter ça comme un micro bloqué.
				watchedVk, stuckSince = nil, nil
			else
				local pressed = IsControlPressed(0, PTT_CONTROL) or IsDisabledControlPressed(0, PTT_CONTROL)
				if not pressed then
					watchedVk, stuckSince = nil, nil
				elseif not watchedVk then
					-- le contrôle vient d'être appuyé : on ne s'arme que si la touche
					-- clavier correspondante est bien physiquement enfoncée (sinon
					-- l'appui vient d'une manette ou d'une touche qu'on ne sait pas lire).
					local vk = resolvePttVk()
					if vk and IsRawKeyDown(vk) then
						watchedVk = vk
					end
				elseif IsRawKeyDown(watchedVk) then
					stuckSince = nil
				else
					-- contrôle toujours "appuyé" mais touche physiquement relâchée :
					-- on confirme pendant 150ms pour éviter un faux positif de frame.
					stuckSince = stuckSince or GetGameTimer()
					if GetGameTimer() - stuckSince > 150 then
						logger.info('[main] Touche "parler" relâchée mais contrôle figé (micro bloqué), on force la coupure.')
						local vk = watchedVk
						watchedVk, stuckSince = nil, nil
						while not IsRawKeyDown(vk) and not radioPressed do
							-- dès que le jeu voit à nouveau la touche relâchée, c'est resynchronisé
							if not IsControlPressed(0, PTT_CONTROL) and not IsDisabledControlPressed(0, PTT_CONTROL) then
								break
							end
							SetControlNormal(0, PTT_CONTROL, 0.0)
							SetControlNormal(1, PTT_CONTROL, 0.0)
							SetControlNormal(2, PTT_CONTROL, 0.0)
							Wait(0)
						end
						logger.info('[main] Micro "parler" débloqué.')
					end
				end
			end
		end
	end)
end

if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(400)
		if MumbleIsPlayerTalking(PlayerId()) then
			enabled = true
			TriggerEvent("UI:PlayerTalking", enabled)
		else
			enabled = false
			TriggerEvent("UI:PlayerTalking", enabled)
		end
	end
end)