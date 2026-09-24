local Config = GangConfig
ESX = exports["es_extended"]:getSharedObject()

GangBuilderManagementOpen = false
GangBuilderManagementMenusReady = false
GangBuilderManagementMembers = {}
GangBuilderManagementGang = nil
GangBuilderManagementSelectedMember = nil
GangBuilderManagementRankIndex = 1
GangBuilderManagementLastRefresh = 0
GangBuilderManagementProgress = nil
GangBuilderManagementProgressLast = 0

GangBuilderManagementWebhooks = {}
GangBuilderManagementWebhookKeys = {
    { key = "member_connect", label = "Connexion des membres" },
    { key = "member_disconnect", label = "Déconnexion des membres" },
    { key = "laundering", label = "Blanchiment" },
    { key = "chest_take", label = "Coffre - Prise" },
    { key = "chest_deposit", label = "Coffre - Dépôt" },
    { key = "armory_buy", label = "Armurerie - Achat" }
}
GangBuilderManagementWebhookStatus = {}

local function toInt(v, default)
    local n = tonumber(v)
    if not n then
        return default or 0
    end
    return n
end

local function GetClosestPlayerServerId(maxDist)
    local players = GetActivePlayers()
    local me = PlayerPedId()
    local myCoords = GetEntityCoords(me)
    local best = nil
    local bestD = maxDist or 3.0

    for i = 1, #players do
        local p = players[i]
        local ped = GetPlayerPed(p)
        if ped ~= me then
            local c = GetEntityCoords(ped)
            local d = #(myCoords - c)
            if d < bestD then
                bestD = d
                best = GetPlayerServerId(p)
            end
        end
    end

    return best
end

function GangBuilderManagementRefreshProgress(cb)
    ESX.TriggerServerCallback("gangbuilder:management:getProgress", function(ok, data)
        if ok and type(data) == "table" then
            GangBuilderManagementProgress = data
            GangBuilderManagementProgressLast = GetGameTimer()
            if cb then cb(true) end
            return
        end
        GangBuilderManagementProgress = nil
        if cb then cb(false) end
    end)
end

function GangBuilderKeyboardInput(title, defaultText, maxLen)
    return exports["sJobs"]:KeyboardInput(title, defaultText, maxLen)
end

function GangBuilderManagementRefreshWebhooks(cb)
    ESX.TriggerServerCallback("gangbuilder:management:getWebhooks", function(data)
        if type(data) ~= "table" then
            GangBuilderManagementWebhooks = {}
            if cb then cb(false) end
            return
        end

        GangBuilderManagementWebhooks = data
        if cb then cb(true) end
    end)
end

function GangBuilderManagementSetWebhook(keyName, url, cb)
    ESX.TriggerServerCallback("gangbuilder:management:setWebhook", function(ok, msg)
        if not ok then
            if msg and msg ~= "" then
                ESX.ShowNotification("~r~" .. tostring(msg))
            else
                ESX.ShowNotification("~r~Erreur.")
            end
            if cb then cb(false) end
            return
        end

        ESX.ShowNotification("~g~Webhook mis à jour.")
        GangBuilderManagementRefreshWebhooks()
        if cb then cb(true) end
    end, keyName, url)
end

function GangBuilderWebhookRightLabel(isSet)
    if isSet == true then
        return "~g~Défini"
    end
    return "~r~Non défini"
end

function GangBuilderWebhookDesc(keyName)
    if keyName == "member_connect" then
        return "Log quand un membre du gang se connecte."
    end
    if keyName == "member_disconnect" then
        return "Log quand un membre du gang se déconnecte."
    end
    if keyName == "laundering" then
        return "Log pour chaque blanchiment (si activé)."
    end
    if keyName == "chest_take" then
        return "Log quand un membre prend un item dans le coffre."
    end
    if keyName == "chest_deposit" then
        return "Log quand un membre dépose un item dans le coffre."
    end
    if keyName == "armory_buy" then
        return "Log quand un membre achète une arme."
    end
    return ""
end

function GangBuilderApplyManagementMenuStyle()
    applyMenuStyle("gangb_mgmt", {
        "main",
        "members",
        "member_edit",
        "webhooks",
        "activities"
    })
end

function GangBuilderEnsureManagementMenus()
    if GangBuilderManagementMenusReady then
        return
    end

    RMenu.Add("gangb_mgmt", "main", RageUI.CreateMenu(Config.Menu.title, "Gestion du gang", 1, 100))
    RMenu.Add("gangb_mgmt", "members", RageUI.CreateSubMenu(RMenu:Get("gangb_mgmt", "main"), Config.Menu.title, "Liste des membres"))
    RMenu.Add("gangb_mgmt", "member_edit", RageUI.CreateSubMenu(RMenu:Get("gangb_mgmt", "members"), Config.Menu.title, "Modifier un membre"))
    RMenu.Add("gangb_mgmt", "webhooks", RageUI.CreateSubMenu(RMenu:Get("gangb_mgmt", "main"), Config.Menu.title, "Webhooks"))
    RMenu.Add("gangb_mgmt", "activities", RageUI.CreateSubMenu(RMenu:Get("gangb_mgmt", "main"), Config.Menu.title, "Activités du groupe"))

    local m = RMenu:Get("gangb_mgmt", "main")
    m.Closed = function()
        GangBuilderManagementOpen = false
        RageUI.CloseAll()
        RMenu:Delete("gangb_mgmt", "main")
        RMenu:Delete("gangb_mgmt", "members")
        RMenu:Delete("gangb_mgmt", "member_edit")
        RMenu:Delete("gangb_mgmt", "webhooks")
        RMenu:Delete("gangb_mgmt", "activities")
        GangBuilderManagementMenusReady = false
        GangBuilderManagementSelectedMember = nil
        GangBuilderManagementGang = nil
        GangBuilderManagementMembers = {}
        GangBuilderManagementRankIndex = 1
    end

    GangBuilderApplyManagementMenuStyle()

    GangBuilderManagementMenusReady = true
end

function GangBuilderGetHighestRankId(gang)
    if not gang or type(gang.ranks) ~= "table" or #gang.ranks == 0 then
        return nil
    end

    local maxId = nil
    for i = 1, #gang.ranks do
        local r = gang.ranks[i]
        local id = tonumber(r and r.id)
        if id and (not maxId or id > maxId) then
            maxId = id
        end
    end

    return maxId
end

function GangBuilderBuildRankOptions(gang)
    local labels = {}
    local ids = {}

    if not gang or type(gang.ranks) ~= "table" then
        return labels, ids
    end

    local tmp = {}
    for i = 1, #gang.ranks do
        local r = gang.ranks[i]
        local id = tonumber(r and r.id)
        local label = tostring(r and r.label or "")
        if id and label ~= "" then
            tmp[#tmp + 1] = { id = id, label = label }
        end
    end

    table.sort(tmp, function(a, b)
        return a.id < b.id
    end)

    for i = 1, #tmp do
        ids[i] = tmp[i].id
        labels[i] = ("%d - %s"):format(tmp[i].id, tmp[i].label)
    end

    return labels, ids
end

function GangBuilderFindRankIndexById(rankIds, id)
    id = tonumber(id)
    if not id or type(rankIds) ~= "table" then
        return 1
    end

    for i = 1, #rankIds do
        if tonumber(rankIds[i]) == id then
            return i
        end
    end

    return 1
end

function GangBuilderSortMembers(list)
    if type(list) ~= "table" then
        return {}
    end

    table.sort(list, function(a, b)
        local ao = a and a.online == true
        local bo = b and b.online == true

        if ao ~= bo then
            return ao
        end

        local an = tostring(a and (a.name or a.license or "") or "")
        local bn = tostring(b and (b.name or b.license or "") or "")

        return string.lower(an) < string.lower(bn)
    end)

    return list
end

function GangBuilderRefreshManagementData(cb)
    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" then
            GangBuilderManagementGang = nil
            GangBuilderManagementMembers = {}
            if cb then
                cb(false)
            end
            return
        end

        GangBuilderManagementGang = bundle.gang
        GangBuilderManagementRefreshProgress()

        GB_Rpc("gb:gm", function(members)
            if type(members) ~= "table" then
                members = {}
            end

            GangBuilderManagementMembers = GangBuilderSortMembers(members)
            GangBuilderManagementLastRefresh = GetGameTimer()

            if cb then
                cb(true)
            end
        end)
    end)
end

function GangBuilderManagementSendMessageToAll()
    if not GangBuilderManagementGang or not GangBuilderManagementGang.name then
        ESX.ShowNotification("~r~Aucun gang.")
        return
    end

    local gangName = tostring(GangBuilderManagementGang.name)
    local msg = GangBuilderKeyboardInput(("Message à tous (%s)"):format(gangName), "", 180)
    if msg == nil then
        return
    end

    msg = tostring(msg):gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "" then
        ESX.ShowNotification("~r~Message vide.")
        return
    end

    TriggerServerEvent("gangbuilder:management:messageAll", msg)
    ESX.ShowNotification("~g~Envoi en cours...")
end

function OpenGangManagementMenu()
    if GangBuilderManagementOpen then
        return
    end

    GangBuilderEnsureManagementMenus()
    GangBuilderManagementOpen = true

    GangBuilderRefreshManagementData(function(ok)
        if not ok then
            ESX.ShowNotification("~r~Impossible de récupérer le gang.")
            GangBuilderManagementOpen = false
            RageUI.CloseAll()
            return
        end

        RageUI.Visible(RMenu:Get("gangb_mgmt", "main"), true)
    end)

    CreateThread(function()
        local memberRankLabels = {}
        local memberRankIds = {}

        while GangBuilderManagementOpen do
            Wait(0)

            RageUI.IsVisible(RMenu:Get("gangb_mgmt", "main"), true, true, true, function()
                if not GangBuilderManagementGang then
                    RageUI.Separator("~r~Aucun gang")
                    return
                end

                local gangName = tostring(GangBuilderManagementGang.name or "Gang")
                RageUI.Separator(("Gang: %s"):format(gangName))

                local p = GangBuilderManagementProgress
                if p and type(p) == "table" then
                    local lvl = tonumber(p.level) or 1
                    local xp = tonumber(p.xp) or 0
                    local nextXp = tonumber(p.next_xp) or 0
                    if nextXp > 0 then
                        RageUI.Separator(("Niveau: %d | XP: %d / %d"):format(lvl, xp, nextXp))
                    else
                        RageUI.Separator(("Niveau: %d | XP: %d"):format(lvl, xp))
                    end
                else
                    RageUI.Separator("Niveau: ~c~?~s~ | XP: ~c~?~s~")
                end

                RageUI.ButtonWithStyle(
                    "Recruter le joueur le plus proche",
                    "Invite le joueur le plus proche à rejoindre le gang",
                    { RightLabel = "→" },
                    true,
                    function(_, _, selected)
                        if selected then
                            local sid = GetClosestPlayerServerId(3.0)
                            if sid then
                                TriggerServerEvent("gangbuilder:management:recruit:request", sid)
                            else
                                ESX.ShowNotification("~r~Personne à proximité.")
                            end
                        end
                    end
                )

                RageUI.ButtonWithStyle("Liste des membres", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        GangBuilderRefreshManagementData()
                    end
                end, RMenu:Get("gangb_mgmt", "members"))

                RageUI.ButtonWithStyle("Liste des webhooks", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        GangBuilderManagementRefreshWebhooks()
                    end
                end, RMenu:Get("gangb_mgmt", "webhooks"))

                RageUI.ButtonWithStyle("Activités du groupe", "~c~Bientôt disponible", { RightLabel = "→" }, true, function() end, RMenu:Get("gangb_mgmt", "activities"))

                RageUI.ButtonWithStyle("Envoyer un message à tous les membres", nil, { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        GangBuilderManagementSendMessageToAll()
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get("gangb_mgmt", "members"), true, true, true, function()
                if not GangBuilderManagementGang then
                    RageUI.Separator("~r~Aucun gang")
                    return
                end

                local now = GetGameTimer()
                if now - (GangBuilderManagementLastRefresh or 0) > 30000 then
                    GangBuilderRefreshManagementData()
                end

                if type(GangBuilderManagementMembers) ~= "table" or #GangBuilderManagementMembers == 0 then
                    RageUI.Separator("Aucun membre")
                    return
                end

                RageUI.Separator(("Membres: %d"):format(#GangBuilderManagementMembers))

                for i = 1, #GangBuilderManagementMembers do
                    local mm = GangBuilderManagementMembers[i]
                    local name = tostring(mm.name or mm.license or "Inconnu")
                    local online = mm.online == true
                    local rl = tostring(mm.rank_label or ("Grade " .. tostring(mm.rank_id or "?")))
                    if online then
                        rl = "~g~En ligne~s~ | " .. rl
                    else
                        rl = "~c~Hors ligne~s~ | " .. rl
                    end

                    RageUI.ButtonWithStyle(name, nil, { RightLabel = rl .. " →" }, true, function(_, _, selected)
                        if selected then
                            GangBuilderManagementSelectedMember = mm
                            memberRankLabels, memberRankIds = GangBuilderBuildRankOptions(GangBuilderManagementGang)
                            GangBuilderManagementRankIndex = GangBuilderFindRankIndexById(memberRankIds, mm.rank_id)
                        end
                    end, RMenu:Get("gangb_mgmt", "member_edit"))
                end
            end)

            RageUI.IsVisible(RMenu:Get("gangb_mgmt", "member_edit"), true, true, true, function()
                local mm = GangBuilderManagementSelectedMember
                if not mm then
                    RageUI.Separator("~r~Aucun membre sélectionné")
                    return
                end

                local displayName = tostring(mm.name or mm.license or "Inconnu")
                RageUI.Separator(displayName)

                if type(memberRankLabels) ~= "table" or #memberRankLabels == 0 then
                    RageUI.Separator("~r~Aucun rang")
                    return
                end

                RageUI.List("Rang", memberRankLabels, GangBuilderManagementRankIndex, nil, {}, true, function(_, _, selected, index)
                    GangBuilderManagementRankIndex = index

                    if selected then
                        local newRankId = memberRankIds[index]
                        if not newRankId then
                            ESX.ShowNotification("~r~Rang invalide.")
                            return
                        end

                        TriggerServerEvent("gangbuilder:management:setMemberRank", mm.license, tonumber(newRankId))
                        ESX.ShowNotification("~g~Demande envoyée.")
                        GangBuilderRefreshManagementData()
                        RageUI.GoBack()
                    end
                end)

                if GangBuilderManagementSelectedMember.online then
                    RageUI.ButtonWithStyle("Envoyer un message", nil, { RightLabel = "→" }, true, function(_, _, selected)
                        if selected then
                            local msg = GangBuilderKeyboardInput(("Message a %s"):format(tostring(displayName)), "", 180)
                            if msg == nil then
                                return
                            end

                            msg = tostring(msg):gsub("^%s+", ""):gsub("%s+$", "")
                            if msg == "" then
                                ESX.ShowNotification("~r~Message vide.")
                                return
                            end

                            TriggerServerEvent("gangbuilder:management:messageMember", tostring(mm.license), msg)
                            ESX.ShowNotification("~g~Message envoyé.")
                        end
                    end)
                end

                RageUI.ButtonWithStyle("~r~Kick du gang", "~r~Retire le membre du gang", { RightLabel = "→" }, true, function(_, _, selected)
                    if selected then
                        TriggerServerEvent("gangbuilder:management:kickMember", mm.license)
                        ESX.ShowNotification("~g~Demande envoyée.")
                        GangBuilderRefreshManagementData()
                        RageUI.GoBack()
                    end
                end)
            end)

            RageUI.IsVisible(RMenu:Get("gangb_mgmt", "webhooks"), true, true, true, function()
                if not GangBuilderManagementGang then
                    RageUI.Separator("~r~Aucun gang")
                    return
                end

                RageUI.Separator("Configurer les webhooks du gang")

                if type(GangBuilderManagementWebhooks) ~= "table" then
                    GangBuilderManagementWebhooks = {}
                end

                for i = 1, #GangBuilderManagementWebhookKeys do
                    local item = GangBuilderManagementWebhookKeys[i]
                    local keyName = item.key
                    local label = item.label
                    local isSet = (GangBuilderManagementWebhooks[keyName] == true)

                    RageUI.ButtonWithStyle(label, GangBuilderWebhookDesc(keyName), { RightLabel = GangBuilderWebhookRightLabel(isSet) .. " →" }, true, function(_, _, selected)
                        if selected then

                            local input = GangBuilderKeyboardInput(("Webhook: %s"):format(label), "", 256)
                            if input == nil then
                                return
                            end

                            input = tostring(input):gsub("^%s+", ""):gsub("%s+$", "")

                            if input == "" then
                                GangBuilderManagementSetWebhook(keyName, "")
                                return
                            end

                            GangBuilderManagementSetWebhook(keyName, input)
                        end
                    end)
                end

                RageUI.Separator("~c~Astuce: laisse le champ vide pour supprimer le webhook.")
            end)

            RageUI.IsVisible(RMenu:Get("gangb_mgmt", "activities"), true, true, true, function()
                RageUI.Separator("Activités du groupe")

                if not GangBuilderManagementGang then
                    RageUI.Separator("~r~Aucun gang")
                    return
                end

                if GangBuilderManagementLastRefresh == 0 or (GetGameTimer() - GangBuilderManagementLastRefresh) > 10000 then
                    GangBuilderManagementLastRefresh = GetGameTimer()
                    ESX.TriggerServerCallback("gangbuilder:activities:getCooldowns", function(cds)
                        if type(cds) ~= "table" then
                            return
                        end
                        GangBuilderManagementWebhookStatus = GangBuilderManagementWebhookStatus or {}
                        GangBuilderManagementWebhookStatus.dangerous_delivery = tonumber(cds.dangerous_delivery or 0) or 0
                        GangBuilderManagementWebhookStatus.hitman = tonumber(cds.hitman or 0) or 0
                    end)
                end

                local cdDangerous = toInt(GangBuilderManagementWebhookStatus and GangBuilderManagementWebhookStatus.dangerous_delivery, 0)
                local cdHitman = toInt(GangBuilderManagementWebhookStatus and GangBuilderManagementWebhookStatus.hitman, 0)

                local canDangerous = (cdDangerous <= 0)
                local canHitman = (cdHitman <= 0)

                local rl1 = cdDangerous > 0 and ("~r~%ds~s~ →"):format(cdDangerous) or "→"
                local rl2 = cdHitman > 0 and ("~r~%ds~s~ →"):format(cdHitman) or "→"

                RageUI.ButtonWithStyle("Livraison dangereuse", "Lance une mission d'interception (annonce aux autres gangs).", { RightLabel = rl1 }, canDangerous, function(_, _, selected)
                    if selected then
                        TriggerServerEvent("gangbuilder:activities:startDangerousDelivery")
                    end
                end)

                RageUI.ButtonWithStyle("Tueur à gage", "Déplace le groupe sur une zone, puis embuscade: 8 à 16 assaillants à éliminer.", { RightLabel = rl2 }, canHitman, function(_, _, selected)
                    if selected then
                        TriggerServerEvent("gangbuilder:activities:startHitman")
                    end
                end)
            end)
        end
    end)
end

RegisterNetEvent("gangbuilder:management:open", function()
    OpenGangManagementMenu()
end)

RegisterNetEvent("gangbuilder:management:refetch", function()
    if GangBuilderManagementOpen then
        GangBuilderRefreshManagementData()
    end
end)

RegisterNetEvent("gangbuilder:client:recruit:invite", function(gangName, fromId, token)
    local accept = false
    local fromName = GetPlayerName(GetPlayerFromServerId(fromId)) or ("ID " .. tostring(fromId))

    ESX.ShowNotification(("~y~Recrutement~s~\n%s t'invite dans ~b~%s~s~\n~g~Y~s~ accepter / ~r~N~s~ refuser"):format(fromName, tostring(gangName)))

    CreateThread(function()
        local start = GetGameTimer()
        while (GetGameTimer() - start) < 15000 do
            Wait(0)

            if IsControlJustPressed(0, 246) then
                accept = true
                break
            end

            if IsControlJustPressed(0, 249) then
                break
            end
        end

        TriggerServerEvent("gangbuilder:management:recruit:respond", token, accept)
    end)
end)
