local function DisableSubmix()
    if IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
        ExecuteCommand('e c')
    end
    TriggerServerEvent('megaphone:applySubmix', false)
end

local usingMegaphone = false

RegisterNetEvent('megaphone:use')
AddEventHandler('megaphone:use', function()
    if usingMegaphone then
        DisableSubmix()
    end
    usingMegaphone = not usingMegaphone
    CreateThread(function()
        if usingMegaphone then
            TriggerServerEvent('megaphone:applySubmix', true)
        end
        while usingMegaphone do
            if not IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
                ExecuteCommand('e megaphone')
            end
            Wait(100)
        end
    end)
end)

local data = {
    [GetHashKey('default')] = 1,
    [GetHashKey('freq_low')] = 300.0,
    [GetHashKey('freq_hi')] = 5000.0,
    [GetHashKey('rm_mod_freq')] = 0.0,
    [GetHashKey('rm_mix')] = 0.2,
    [GetHashKey('fudge')] = 0.0,
    [GetHashKey('o_freq_lo')] = 550.0,
    [GetHashKey('o_freq_hi')] = 0.0,
}

local filter

CreateThread(function()
    filter = CreateAudioSubmix("Megaphone")
    SetAudioSubmixEffectRadioFx(filter, 0)
    for hash, value in pairs(data) do
        SetAudioSubmixEffectParamInt(filter, 0, hash, 1)
    end
    AddAudioSubmixOutput(filter, 0)
end)

RegisterNetEvent('megaphone:updateSubmixStatus', function(state, source)
    if state then

            MumbleSetVolumeOverrideByServerId(source, 0.90)

        MumbleSetSubmixForServerId(source, filter)
        print(Config.ForcedProximity)
        exports['pma-voice']:overrideProximityRange(40.0, false)
    else
        MumbleSetSubmixForServerId(source, -1)

            MumbleSetVolumeOverrideByServerId(source, -1.0)

        exports['pma-voice']:clearProximityOverride()
        MumbleClearVoiceTargetPlayers(1.0)
    end
end)
