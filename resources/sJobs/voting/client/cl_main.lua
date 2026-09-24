Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

VOTING_C = {}
VOTING_C.state      = nil
VOTING_C.voteOpen   = false
VOTING_C.adminOpen  = false
VOTING_C.selected   = nil
VOTING_C.busy       = false

local function votingInput(prompt, maxLen)
    local result = nil
    local done   = false
    exports.dialog:openDialog(prompt, function(value)
        result = value
        done   = true
    end)
    local timeout = 0
    while not done and timeout < 30000 do
        Wait(10)
        timeout = timeout + 10
    end
    if result == nil then return nil end
    result = tostring(result)
    result = result:gsub('^%s+', ''):gsub('%s+$', '')
    if result == '' then return nil end
    if maxLen and #result > maxLen then result = result:sub(1, maxLen) end
    return result
end

local function fetchState(cb)
    ESX.TriggerServerCallback('voting:getState', function(data)
        if type(data) == 'table' then
            VOTING_C.state = data
        end
        if cb then cb(VOTING_C.state) end
    end)
end

RegisterNetEvent('voting:stateChanged', function()
    if VOTING_C.voteOpen or VOTING_C.adminOpen then
        fetchState()
    end
end)

Citizen.CreateThread(function()
    RMenu.Add('VOTING', 'vote',  RageUI.CreateMenu("Bureau de Vote", "Élections du Gouvernement", 1, 100))
    RMenu.Add('VOTING', 'admin', RageUI.CreateMenu("Gestion des Élections", "Réservé au staff", 1, 100))
    RMenu.Add('VOTING', 'admin_cand', RageUI.CreateSubMenu(RMenu:Get('VOTING', 'admin'), "Gestion des Élections", "Candidat"))

    for _, name in ipairs({ 'vote', 'admin', 'admin_cand' }) do
        RMenu:Get('VOTING', name):SetRectangleBanner(255, 117, 31, 225)
    end

    RMenu:Get('VOTING', 'vote').Closed  = function() VOTING_C.voteOpen = false end
    RMenu:Get('VOTING', 'admin').Closed = function() VOTING_C.adminOpen = false end
end)

local function renderAdminMenu(parentMenu)
    RageUI.IsVisible(RMenu:Get('VOTING', 'admin'), true, true, true, function()
        local st = VOTING_C.state or {}
        local isOpen = (st.status == 'open')

        RageUI.ButtonWithStyle("Statut", nil, { RightLabel = isOpen and "~g~OUVERT" or "~r~CLÔTURÉ" }, true)

        RageUI.ButtonWithStyle("Titre de l'élection", "Modifier le titre", { RightLabel = tostring(st.title or "") }, true, function(_, _, Selected)
            if Selected then
                local t = votingInput("Titre de l'élection", 32)
                if t then
                    TriggerServerEvent('voting:admin:setTitle', t)
                end
            end
        end)

        RageUI.Separator("Candidats")

        for _, c in ipairs(st.candidates or {}) do
            RageUI.ButtonWithStyle(c.name, "Gérer ce candidat", { RightLabel = (st.showCounts and (tostring(c.votes or 0).." voix") or "→") }, true, function(_, _, Selected)
                if Selected then
                    VOTING_C.selected = { id = c.id, name = c.name, votes = c.votes }
                end
            end, RMenu:Get('VOTING', 'admin_cand'))
        end

        RageUI.ButtonWithStyle("~b~+ Ajouter un candidat", nil, {}, true, function(_, _, Selected)
            if Selected then
                local name = votingInput("Nom du nouveau candidat", 32)
                if name then
                    TriggerServerEvent('voting:admin:add', name)
                end
            end
        end)

        RageUI.Separator("Scrutin")

        if isOpen then
            RageUI.ButtonWithStyle("~r~Clôturer le vote", "Annonce les résultats à tout le serveur", {}, true, function(_, _, Selected)
                if Selected then
                    TriggerServerEvent('voting:admin:close')
                end
            end)
        else
            RageUI.ButtonWithStyle("~g~Ouvrir le vote", "Remet les voix à zéro et lance un nouveau scrutin", {}, true, function(_, _, Selected)
                if Selected then
                    local t = votingInput("Titre du scrutin (laisser vide = titre actuel)", 32)
                    TriggerServerEvent('voting:admin:start', t)
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get('VOTING', 'admin_cand'), true, true, true, function()
        local sel = VOTING_C.selected
        if not sel then return end

        RageUI.Separator("~y~"..tostring(sel.name))

        RageUI.ButtonWithStyle("Renommer", nil, {}, true, function(_, _, Selected)
            if Selected then
                local name = votingInput("Nouveau nom du candidat", 32)
                if name then
                    TriggerServerEvent('voting:admin:setName', sel.id, name)
                    RageUI.GoBack()
                end
            end
        end)

        RageUI.ButtonWithStyle("~r~Supprimer", "Retire ce candidat de l'élection", {}, true, function(_, _, Selected)
            if Selected then
                TriggerServerEvent('voting:admin:remove', sel.id)
                VOTING_C.selected = nil
                RageUI.GoBack()
            end
        end)
    end)
end

local function openVoteMenu()
    if VOTING_C.voteOpen or VOTING_C.busy then return end
    VOTING_C.busy = true

    fetchState(function(state)
        VOTING_C.busy = false
        if type(state) ~= 'table' then
            ESX.ShowNotification("~r~Le système de vote ne répond pas.")
            return
        end

        VOTING_C.voteOpen = true
        RageUI.Visible(RMenu:Get('VOTING', 'vote'), true)

        Citizen.CreateThread(function()
            while true do
                RageUI.IsVisible(RMenu:Get('VOTING', 'vote'), true, true, true, function()
                    local st = VOTING_C.state or {}
                    RageUI.ButtonWithStyle("~y~"..tostring(st.title or "Élections"), nil, {}, true)

                    if st.status ~= 'open' then
                        RageUI.Separator("~r~Aucun vote en cours")

                        if st.candidates and #st.candidates > 0 and st.showCounts then
                            RageUI.Separator("Derniers résultats")
                            for _, c in ipairs(st.candidates) do
                                RageUI.ButtonWithStyle(c.name, nil, { RightLabel = tostring(c.votes or 0).." voix" }, true)
                            end
                        end
                    elseif st.hasVoted then
                        RageUI.Separator("~g~Vous avez déjà voté")
                        RageUI.ButtonWithStyle("Merci pour votre participation !", "Les résultats seront annoncés à la clôture.", {}, true)
                    else
                        RageUI.Separator("Choisissez votre candidat")
                        for _, c in ipairs(st.candidates or {}) do
                            RageUI.ButtonWithStyle(c.name, "Voter pour ce candidat", { RightLabel = "→" }, true, function(_, _, Selected)
                                if Selected then
                                    local candId = c.id
                                    ESX.TriggerServerCallback('voting:castVote', function(ok, msgOrName)
                                        if ok then
                                            ESX.ShowNotification(("~g~Vote enregistré pour ~o~%s~g~ !"):format(tostring(msgOrName)))
                                            fetchState()
                                        else
                                            ESX.ShowNotification("~r~"..tostring(msgOrName or "Vote refusé."))
                                        end
                                    end, candId)
                                end
                            end)
                        end
                    end

                    if st.isAdmin then
                        RageUI.Separator("~o~Staff")
                        RageUI.ButtonWithStyle("~o~Gestion des élections", "Renommer les candidats et lancer un vote", { RightLabel = "→" }, true, function(_, _, Selected)
                            if Selected then
                                RageUI.Visible(RMenu:Get('VOTING', 'admin'), true)
                            end
                        end, RMenu:Get('VOTING', 'admin'))
                    end
                end)

                if (VOTING_C.state or {}).isAdmin then
                    renderAdminMenu()
                end

                if not RageUI.Visible(RMenu:Get('VOTING', 'vote'))
                    and not RageUI.Visible(RMenu:Get('VOTING', 'admin'))
                    and not RageUI.Visible(RMenu:Get('VOTING', 'admin_cand')) then
                    VOTING_C.voteOpen = false
                    break
                end
                Wait(0)
            end
        end)
    end)
end

local function openAdminMenu()
    if VOTING_C.adminOpen or VOTING_C.busy then return end
    VOTING_C.busy = true

    fetchState(function(state)
        VOTING_C.busy = false
        if type(state) ~= 'table' then
            ESX.ShowNotification("~r~Le système de vote ne répond pas.")
            return
        end
        if not state.isAdmin then
            ESX.ShowNotification("~r~Vous n'avez pas accès à la gestion des élections.")
            return
        end

        VOTING_C.adminOpen = true
        RageUI.Visible(RMenu:Get('VOTING', 'admin'), true)

        Citizen.CreateThread(function()
            while VOTING_C.adminOpen do
                renderAdminMenu()

                if not RageUI.Visible(RMenu:Get('VOTING', 'admin'))
                    and not RageUI.Visible(RMenu:Get('VOTING', 'admin_cand')) then
                    VOTING_C.adminOpen = false
                    break
                end
                Wait(0)
            end
        end)
    end)
end

RegisterCommand('election', function()
    openAdminMenu()
end, false)

local function getNearestBoothDistance(pcoords)
    local best = math.huge
    for _, booth in ipairs(cfg_voting.booths) do
        local d = #(pcoords - booth.coords)
        if d < best then best = d end
    end
    return best
end

Citizen.CreateThread(function()
    local m = cfg_voting.marker
    while true do
        local sleep = 1000
        local pcoords = GetEntityCoords(PlayerPedId())

        for _, booth in ipairs(cfg_voting.booths) do
            local dist = #(pcoords - booth.coords)
            if dist <= cfg_voting.drawDistance then
                sleep = 0
                DrawMarker(
                    m.type,
                    booth.coords.x, booth.coords.y, booth.coords.z + m.zOffset,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    m.size.x, m.size.y, m.size.z,
                    m.color.r, m.color.g, m.color.b, m.color.a,
                    m.bobUpAndDown, false, 2, m.rotate, nil, nil, false
                )
            end
        end

        if getNearestBoothDistance(pcoords) <= cfg_voting.interactDistance then
            if not VOTING_C.voteOpen then
                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ~o~voter")
                if IsControlJustPressed(1, 38) then
                    openVoteMenu()
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    AddTextEntry("BN_VOTING", "Bureau de Vote")
    local center = cfg_voting.booths[1] and cfg_voting.booths[1].coords or vec3(-409.5, 1091.0, 329.77)
    local blip = AddBlipForCoord(center.x, center.y, center.z)
    SetBlipSprite(blip, 419)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.85)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("BN_VOTING")
    EndTextCommandSetBlipName(blip)
end)
