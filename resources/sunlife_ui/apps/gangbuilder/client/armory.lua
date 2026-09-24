local Config = GangConfig
ESX = exports["es_extended"]:getSharedObject()

GangBuilderArmoryOpen = false
GangBuilderArmoryMenusReady = false
GangBuilderArmoryGangName = nil
GangBuilderArmoryWeapons = {}
GangBuilderArmoryLastRefresh = 0
GangBuilderArmorySelected = nil

function GangBuilderApplyArmoryMenuStyle()
    applyMenuStyle("gangb_armory", {
        "main",
        "weapons",
        "weapon_buy"
    })
end

function GangBuilderEnsureArmoryMenus()
    if GangBuilderArmoryMenusReady then
        return
    end

    RMenu.Add("gangb_armory", "main", RageUI.CreateMenu(Config.Menu.title, "Armurerie du gang", 1, 100))
    RMenu.Add("gangb_armory", "weapons", RageUI.CreateSubMenu(RMenu:Get("gangb_armory", "main"), Config.Menu.title, "Armes disponibles"))
    RMenu.Add("gangb_armory", "weapon_buy", RageUI.CreateSubMenu(RMenu:Get("gangb_armory", "weapons"), Config.Menu.title, "Acheter une arme"))

    local m = RMenu:Get("gangb_armory", "main")
    m.Closed = function()
        GangBuilderArmoryOpen = false
        RageUI.CloseAll()
        RMenu:Delete("gangb_armory", "main")
        RMenu:Delete("gangb_armory", "weapons")
        RMenu:Delete("gangb_armory", "weapon_buy")
        GangBuilderArmoryMenusReady = false
        GangBuilderArmoryGangName = nil
        GangBuilderArmoryWeapons = {}
        GangBuilderArmorySelected = nil
        GangBuilderArmoryLastRefresh = 0
    end

    GangBuilderApplyArmoryMenuStyle()

    GangBuilderArmoryMenusReady = true
end

function GangBuilderArmorySortWeapons(list)
    if type(list) ~= "table" then
        return {}
    end

    table.sort(list, function(a, b)
        local an = tostring(a and (a.label or a.item or "") or "")
        local bn = tostring(b and (b.label or b.item or "") or "")
        return string.lower(an) < string.lower(bn)
    end)

    return list
end

function GangBuilderArmoryRefresh(cb)
    ESX.TriggerServerCallback("gangbuilder:armory:get", function(ok, payloadOrMsg)
        if not ok then
            GangBuilderArmoryGangName = nil
            GangBuilderArmoryWeapons = {}
            GangBuilderArmorySelected = nil
            if cb then
                cb(false, payloadOrMsg)
            end
            return
        end

        local payload = payloadOrMsg
        GangBuilderArmoryGangName = tostring(payload.gang_name or "Gang")
        GangBuilderArmoryWeapons = GangBuilderArmorySortWeapons(payload.weapons or {})
        GangBuilderArmoryLastRefresh = GetGameTimer()

        if cb then
            cb(true)
        end
    end)
end

function GangBuilderArmoryBuySelected()
    local w = GangBuilderArmorySelected
    if not w or type(w) ~= "table" then
        ESX.ShowNotification("~r~Aucune arme sélectionnée.")
        return
    end

    local item = tostring(w.item or "")
    if item == "" then
        ESX.ShowNotification("~r~Arme invalide.")
        return
    end

    ESX.TriggerServerCallback("gangbuilder:armory:buy", function(ok, msg)
        if ok then
            ESX.ShowNotification("~g~" .. tostring(msg or "Achat effectué."))
        else
            ESX.ShowNotification("~r~" .. tostring(msg or "Erreur."))
        end
    end, item)
end

function OpenGangArmoryMenu()
    if GangBuilderArmoryOpen then
        return
    end

    GangBuilderEnsureArmoryMenus()
    GangBuilderArmoryOpen = true

    GangBuilderArmoryRefresh(function(ok, msg)
        if not ok then
            ESX.ShowNotification("~r~" .. tostring(msg or "Accès refusé."))
            GangBuilderArmoryOpen = false
            RageUI.CloseAll()
            return
        end

        RageUI.Visible(RMenu:Get("gangb_armory", "main"), true)
    end)

    CreateThread(function()
        while GangBuilderArmoryOpen do
            Wait(0)

            RageUI.IsVisible(RMenu:Get("gangb_armory", "main"), true, true, true, function()
                local name = tostring(GangBuilderArmoryGangName or "Gang")
                RageUI.Separator(("Gang: %s"):format(name))

                RageUI.ButtonWithStyle("Voir les armes", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        GangBuilderArmoryRefresh(function(ok, msg)
                            if not ok then
                                ESX.ShowNotification("~r~" .. tostring(msg or "Erreur."))
                            end
                        end)
                    end
                end, RMenu:Get("gangb_armory", "weapons"))

            end)

            RageUI.IsVisible(RMenu:Get("gangb_armory", "weapons"), true, true, true, function()
                local now = GetGameTimer()
                if now - (GangBuilderArmoryLastRefresh or 0) > 30000 then
                    GangBuilderArmoryRefresh()
                end

                if type(GangBuilderArmoryWeapons) ~= "table" or #GangBuilderArmoryWeapons == 0 then
                    RageUI.Separator("Aucune arme disponible")
                    return
                end

                RageUI.Separator(("Armes: %d"):format(#GangBuilderArmoryWeapons))

                for i = 1, #GangBuilderArmoryWeapons do
                    local w = GangBuilderArmoryWeapons[i]
                    local label = tostring(w.label or w.item or "Arme")
                    local price = tonumber(w.price) or 0
                    local right = ("~r~%d$~s~ sale →"):format(price)

                    RageUI.ButtonWithStyle(label, "Acheter avec de l'argent sale", { RightLabel = right }, true, function(_, _, selected)
                        if selected then
                            GangBuilderArmorySelected = w
                        end
                    end, RMenu:Get("gangb_armory", "weapon_buy"))
                end
            end)

            RageUI.IsVisible(RMenu:Get("gangb_armory", "weapon_buy"), true, true, true, function()
                local w = GangBuilderArmorySelected
                if not w then
                    RageUI.Separator("~r~Aucune arme sélectionnée")
                    return
                end

                local label = tostring(w.label or w.item or "Arme")
                local price = tonumber(w.price) or 0

                RageUI.Separator(label)
                RageUI.Separator(("Prix: ~r~%d$~s~ (sale)"):format(price))

                RageUI.ButtonWithStyle("Confirmer l'achat", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        GangBuilderArmoryBuySelected()
                        RageUI.GoBack()
                    end
                end)

                RageUI.ButtonWithStyle("Annuler", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        RageUI.GoBack()
                    end
                end)
            end)
        end
    end)
end

RegisterNetEvent("gangbuilder:armory:open", function()
    OpenGangArmoryMenu()
end)
