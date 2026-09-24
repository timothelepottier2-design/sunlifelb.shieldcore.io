local function notify(msg)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(msg)
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

RegisterCommand("dbg_clear_tc", function()
    ClearTimecycleModifier()
    SetTimecycleModifierStrength(1.0)
    if ClearExtraTimecycleModifier then ClearExtraTimecycleModifier() end
    SetTransitionTimecycleModifier("default", 0.0)
    notify("[debug] TimecycleModifier nettoye.")
end, false)

RegisterCommand("dbg_clear_fx", function()
    StopAllScreenEffects()

    local fxList = {
        "DrugsMichaelAliensFight", "DrugsMichaelAliensFightIn", "DrugsMichaelAliensFightOut",
        "DrugsTrevorClownsFight", "DrugsTrevorClownsFightIn", "DrugsTrevorClownsFightOut",
        "MenuMGIn", "MenuMGOut", "MenuMGHeistIn", "MenuMGHeistOut",
        "DeathFailOut", "HeistCelebToast", "HeistLocate",
        "ChopVision", "DrugsDrivingIn", "DrugsDrivingOut",
        "Rampage", "RampageOut", "DrugsTransitionOut", "BarryFadeOut",
        "REDMIST_blend", "SuccessMichael", "SuccessTrevor", "SuccessFranklin",
    }
    for _, fx in ipairs(fxList) do
        StopScreenEffect(fx)
        if AnimpostfxStop then AnimpostfxStop(fx) end
    end
    notify("[debug] ScreenEffects stoppes.")
end, false)

RegisterCommand("dbg_fade_in", function()
    DoScreenFadeIn(0)
    notify("[debug] DoScreenFadeIn force.")
end, false)

RegisterCommand("dbg_reset_lights", function()
    SetArtificialLightsState(false)
    SetArtificialLightsStateAffectsVehicles(true)
    SetNightvision(false)
    SetSeethrough(false)
    notify("[debug] Eclairage / nightvision reinitialise.")
end, false)

RegisterCommand("dbg_reset_misc", function()
    local p = PlayerPedId()
    SetPedMotionBlur(p, false)
    ResetScenarioTypesEnabled()
    ClearPedTasks(p)
    ResetPedMovementClipset(p, 0.5)
    DisplayHud(true)
    DisplayRadar(true)
    notify("[debug] Misc HUD/camera/clipset reinitialise.")
end, false)

RegisterCommand("dbg_clear_all", function()
    ClearTimecycleModifier()
    SetTimecycleModifierStrength(1.0)
    if ClearExtraTimecycleModifier then ClearExtraTimecycleModifier() end
    SetTransitionTimecycleModifier("default", 0.0)
    StopAllScreenEffects()
    DoScreenFadeIn(0)
    SetArtificialLightsState(false)
    SetArtificialLightsStateAffectsVehicles(true)
    SetNightvision(false)
    SetSeethrough(false)
    SetPedMotionBlur(PlayerPedId(), false)
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(PlayerPedId(), 0.5)
    DisplayHud(true)
    DisplayRadar(true)
    notify("[debug] CLEAR ALL : tous les effets visuels reinitialises.")
end, false)
