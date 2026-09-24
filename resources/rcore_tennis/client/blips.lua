-- Blips pour tous les courts de tennis définis dans TennisCourts (config.lua)
-- Une seule entrée GXT partagée pour les N courts (évite la saturation du slot "STRING").

Citizen.CreateThread(function()
    AddTextEntry("RGB_TENNIS", "Court de tennis")

    for _, court in pairs(TennisCourts) do
        if court and court.courtCenter then
            local blip = AddBlipForCoord(court.courtCenter.x, court.courtCenter.y, court.courtCenter.z)
            SetBlipSprite(blip, 122)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("RGB_TENNIS")
            EndTextCommandSetBlipName(blip)
        end
    end
end)
