local opened = false

local AFK_ZONE_POS = vector3(-1620.916260, -848.248535, 10.131706)
local AFK_ZONE_MAX_DIST = 50.0

local function notifyError(msg)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({ type = 'error', description = msg })
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

-- === BLUR UTILS ===
local function ApplyUICycleBlur(on)
    if on then
        -- petit fondu d’activation
        SetTransitionTimecycleModifier("hud_def_blur", 0.30)  -- smooth in
        SetTimecycleModifier("hud_def_blur")
        SetTimecycleModifierStrength(1.0)
    else
        -- petit fondu de sortie puis clear
        SetTransitionTimecycleModifier("hud_def_blur", 0.0)   -- fade out quickly
        ClearTimecycleModifier()
    end
end

-- Bloque l'ouverture du menu pause natif (ESC / P) sans SetPauseMenuActive(false) en boucle :
-- cette boucle fermait aussi le Rockstar Editor et le menu carte, qui reposent sur le même
-- système frontend que le menu pause. On désactive simplement les touches tant qu'aucun
-- menu frontend (pause, carte, éditeur) n'est déjà ouvert.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not IsPauseMenuActive() then
            DisableControlAction(0, 199, true) -- INPUT_FRONTEND_PAUSE (P)
            DisableControlAction(0, 200, true) -- INPUT_FRONTEND_PAUSE_ALTERNATE (ESC)
        end
    end
end)

-- functions
function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SetNuiFocusKeepInput(false)
    DisableIdleCamera(bool)
    SetCursorLocation(0.5, 0.5)

    -- BLUR ON/OFF
    ApplyUICycleBlur(bool)

    DisplayRadar(false)
    ExecuteCommand("ToggleHUDF")

    SendNUIMessage({
        type = "ui",
        status = bool,
    })
    opened = bool
end

function close()
    SetDisplay(false)

    -- BLUR OFF (double sécurité si jamais)
    ApplyUICycleBlur(false)

    DisplayRadar(true)
    ExecuteCommand("ToggleHUDT")
    TriggerEvent("statushud:all:show")
    opened = false
end

-- callbacks
RegisterNUICallback("close", function(data)
	print("Closing pause menu", data)
    close()
end)

RegisterNUICallback("zoneafk", function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    local dist = #(coords - AFK_ZONE_POS)

    if dist > AFK_ZONE_MAX_DIST then
        notifyError("Vous devez être proche de la zone AFK pour y accéder.")
        if cb then cb('ok') end
        return
    end

    close()
    TriggerEvent("afk:enteringAFKZone")
    if cb then cb('ok') end
end)

RegisterNUICallback("quit", function(data)
    close()
    RestartGame()
end)

RegisterNUICallback("map", function(data)
    close()
    ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE", true, 0)
end)

RegisterNUICallback("settings", function(data)
    close()
    ActivateFrontendMenu('FE_MENU_VERSION_LANDING_MENU', 0, 1)
end)

-- commands
RegisterCommand('closepause', function ()
    SetDisplay(false)
end)

RegisterKeyMapping("openesc", "Apri impostazioni", "keyboard", "ESCAPE")

RegisterCommand('openesc', function ()
    if not IsPauseMenuActive() and not IsNuiFocused() then
        TriggerEvent("statushud:all:hide")
        SetDisplay(true)
    end
end)

-- Failsafe: si le resource stop, on nettoie le timecycle
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        ClearTimecycleModifier()
    end
end)