CreateThread(function()
    local cfg = cfg_activities_hub.blip
    local blip = AddBlipForCoord(cfg.pos.x, cfg.pos.y, cfg.pos.z)

    SetBlipSprite(blip, cfg.sprite or 590)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, cfg.scale or 0.85)
    SetBlipColour(blip, cfg.color or 47)
    SetBlipAsShortRange(blip, true)

    local key = "BN_SUNLIFE_ACTIVITIES_HUB_1"
    AddTextEntry(key, cfg.label or "Diverses Activites")
    BeginTextCommandSetBlipName(key)
    EndTextCommandSetBlipName(blip)
end)
