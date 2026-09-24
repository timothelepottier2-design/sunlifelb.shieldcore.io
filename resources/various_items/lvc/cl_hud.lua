-- Luxart Vehicle Control - HUD (slim).
-- Pure CSS HUD (no PNG textures). Shows lights/siren/horn/lock state.
-- Auto-hides when not driving an emergency vehicle, when game HUD is hidden,
-- or when the pause menu is open.

HUD = {}

-- Preference joueur (F5 > Options > "Afficher le boitier LVC"), persistee
-- en KVP : "0" = masque, sinon affiche.
local HUD_KVP = 'lvc_hud_visible'

local show_HUD          = GetResourceKvpString(HUD_KVP) ~= '0'   -- master toggle
local HUD_temp_hidden   = false

----------------------------------------------------------------------
-- Auto-hide when out of emergency vehicle / HUD hidden / pause menu.
----------------------------------------------------------------------
CreateThread(function()
    while true do
        local should_hide =
            (not player_is_emerg_driver) or
            (IsHudHidden() == 1)         or
            (IsPauseMenuActive() == 1)

        if show_HUD then
            if should_hide and not HUD_temp_hidden then
                HUD:SetItemState('hud', false)
                HUD_temp_hidden = true
            elseif (not should_hide) and HUD_temp_hidden then
                HUD:SetItemState('hud', true)
                HUD_temp_hidden = false
            end
        end
        -- Le HUD est masque par defaut dans la NUI ; si le joueur l'a
        -- desactive, on ne l'affiche jamais (rien a faire ici).
        Wait(500)
    end
end)

----------------------------------------------------------------------
-- API
----------------------------------------------------------------------
function HUD:SetItemState(item, state)
    SendNUIMessage({
        _type = 'hud:setItemState',
        item  = item,
        state = state,
    })
end

function HUD:SetHudState(state)
    show_HUD = state == true
    SetResourceKvp(HUD_KVP, show_HUD and '1' or '0')
    if show_HUD then
        -- On laisse le thread d'auto-masquage decider (pas d'affichage hors
        -- vehicule d'urgence) : on force juste une reevaluation.
        HUD_temp_hidden = true
    else
        HUD:SetItemState('hud', false)
        HUD_temp_hidden = false
    end
end

function HUD:GetHudState()
    return show_HUD
end

-- Exports pour le menu F5 (sunlife) : afficher / masquer le boitier LVC.
exports('SetLvcHudVisible', function(state) HUD:SetHudState(state == true) end)
exports('GetLvcHudVisible', function() return show_HUD end)

----------------------------------------------------------------------
-- Refresh all HUD items from current state tables (called on vehicle change).
----------------------------------------------------------------------
function HUD:RefreshHudItemStates()
    if not veh then return end

    local siren_active =
        ((state_lxsiren[veh] or 0) > 0) or
        actv_lxsrnmute_temp             or
        ((state_pwrcall[veh] or 0) > 0)

    local horn_active = ((state_airmanu[veh] or 0) > 0)

    HUD:SetItemState('siren',  siren_active)
    HUD:SetItemState('horn',   horn_active)
    HUD:SetItemState('lock',   key_lock)
    HUD:SetItemState('switch', IsVehicleSirenOn(veh))
end

