Citizen.CreateThread(function()
    SetDiscordAppId(1527896170083520592)
    SetRichPresence(GetPlayerName(PlayerId()).. " [" ..GetPlayerServerId(PlayerId()).. "]")

    SetDiscordRichPresenceAsset('logo')
    SetDiscordRichPresenceAssetText('SunLife RP')

    SetDiscordRichPresenceAction(0, "🧡 Nous soutenir 🧡", "https://sunliferp.com")
    SetDiscordRichPresenceAction(1, "🧡 discord.gg/sunliferpfa 🧡", "https://discord.gg/sunliferpfa")
end)
