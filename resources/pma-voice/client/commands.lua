local wasProximityDisabledFromOverride = false
disableProximityCycle = false

Citizen.CreateThread(function()
	while ESX == nil do
	  	TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
	  	Citizen.Wait(0)
	end
end)

RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		-- print(('^3[NETDIAG][STATEBAG]^7 %s commands.lua:19 LocalPlayer.state:set voiceIntent (replicated)'):format(GetCurrentResourceName()))
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)

-- TODO: Better implementation of this?
RegisterCommand('vol', function(_, args)
	if not args[1] then return end
	setVolume(tonumber(args[1]))
end)

exports('setAllowProximityCycleState', function(state)
	type_check({state, "boolean"})
	disableProximityCycle = state
end)

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(proximityRange + 0.0)
	-- print(('^3[NETDIAG][STATEBAG]^7 %s commands.lua:37 LocalPlayer.state:set proximity (replicated)'):format(GetCurrentResourceName()))
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	sendUIMessage({
		-- JS expects this value to be - 1, "custom" voice is on the last index
		voiceMode = isCustom and #Cfg.voiceModes or mode - 1
	})
end

exports("overrideProximityRange", function(range, disableCycle)
	type_check({range, "number"})
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

-- Declenche par l'anti-triche serveur quand une portee de proximite anormale
-- est detectee : on remet le joueur sur une portee legitime.
RegisterNetEvent('pma-voice:resetProximity', function()
	mode = GetConvarInt('voice_defaultVoiceMode', 2)
	disableProximityCycle = false
	wasProximityDisabledFromOverride = false
	MumbleSetTalkerProximity(Cfg.voiceModes[mode][1] + 0.0)
	setProximityState(Cfg.voiceModes[mode][1], false)
end)

RegisterCommand('cycleproximity', function()
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode + 1
	local coords = GetEntityCoords(PlayerPedId())

	if newMode <= #Cfg.voiceModes then
		mode = newMode
	else
		mode = 1
	end

	if mode == 1 then
		ESX.ShowNotification("~o~Vous chuchotez")
	elseif mode == 2 then
		ESX.ShowNotification("~o~Vous parlez normalement")
	elseif mode == 3 then
		ESX.ShowNotification("~o~Vous criez")
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
	Citizen.CreateThread(function()
		local i = 0
		while i < 15 do
			Citizen.Wait(0)
			i = i + 1
			DrawMarker(1, GetEntityCoords(PlayerPedId()) - vector3(0, 0, 0.9), 0, 0, 0, 0, 0, 0, Cfg.voiceModes[mode][1] * 2.0, Cfg.voiceModes[mode][1] * 2.0, 0.8001, 255, 117, 31, 225, 0,0, 0,0)
		end
	end)
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('cycleproximity', 'Proximité de la voix', 'keyboard', GetConvar('voice_defaultCycle', 'F11'))
end