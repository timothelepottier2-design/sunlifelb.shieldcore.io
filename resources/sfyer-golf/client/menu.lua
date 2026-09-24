---@diagnostic disable: unused-local, undefined-global, missing-parameter
MainMenu = RageUI.CreateMenu(parseText('main_menu_title'), parseText('main_menu_desc'), nil, nil, "shopui_title_golfshop", "shopui_title_golfshop")

PartiesList = RageUI.CreateSubMenu(MainMenu, parseText('parties_list_menu_title'), parseText('parties_list_menu_desc'), nil, nil, "shopui_title_golfshop", "shopui_title_golfshop")
CreateParty = RageUI.CreateSubMenu(MainMenu, parseText('create_party_menu_title'), parseText('create_party_menu_desc'), nil, nil, "shopui_title_golfshop", "shopui_title_golfshop")

CurrentPartyFocus = RageUI.CreateSubMenu(MainMenu, parseText('current_party_menu_title'), parseText('current_party_menu_desc'), nil, nil, "shopui_title_golfshop", "shopui_title_golfshop")
CreatePartyFocus = RageUI.CreateSubMenu(CreateParty, parseText('create_party_focus_menu_title'), parseText('create_party_focus_menu_desc'), nil, nil, "shopui_title_golfshop", "shopui_title_golfshop")

function RageUI.PoolMenus:Golf()
    MainMenu:IsVisible(function ()
        local itemDisabled = false
        if IsPlayerInvolvedInGolfParty() then
            itemDisabled = true
        end
        Items:AddButton(
            parseText('party_list'),
            parseText('party_list_desc'),
            { IsDisabled = itemDisabled, RightLabel = ">>" },
            function(onSelected, onActive)
            end,
            PartiesList
        )
        Items:AddButton(
            parseText('create_party'),
            parseText('create_party_desc'),
            { IsDisabled = itemDisabled, RightLabel = ">>" },
            function(onSelected, onActive)
            end,
            CreateParty
        )
        if PlayerOnlineData.States.isInParty then
            Items:AddSeparator(parseText('in_progress_party_sep'))
            Items:AddButton(
            CurrentParties[PlayerOnlineData.Infos.partyId].Infos.name,
            "",
            { IsDisabled = false, RightLabel = ">>" },
            function(onSelected, onActive)
            end,
            CurrentPartyFocus
        )
        end
    end)
    CurrentPartyFocus:IsVisible(function ()
        if CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
            Items:AddButton(
            parseText('party_name') .. CurrentParties[PlayerOnlineData.Infos.partyId].Infos.name,
            parseText('party_name_desc'),
            { IsDisabled = false },
            function (onSelected, onActive)
                
            end
            ) 
            Items:AddButton(
                parseText('owner_name') .. CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[CurrentParties[PlayerOnlineData.Infos.partyId].Infos.ownerId.localId].name,
                parseText('owner_name_desc'),
                { IsDisabled = false },
                function (onSelected, onActive)   
                end
            )
            Items:AddButton(
                parseText('players_num') .. CurrentParties[PlayerOnlineData.Infos.partyId].Infos.nPlayers .. "/" .. CurrentParties[PlayerOnlineData.Infos.partyId].Infos.maxPlayers,
                parseText('players_num_desc'),
                { IsDisabled = false },
                function (onSelected, onActive)
                end
            )
            if CurrentParties[PlayerOnlineData.Infos.partyId].States.currentGolfState == 1 and CurrentParties[PlayerOnlineData.Infos.partyId].Infos.ownerId.localId == PlayerOnlineData.Infos.localId then
                Items:AddButton(
                    parseText('start_golf'),
                    parseText('start_golf_desc'),
                    {
                        IsDisabled = false,
                        RightBadge = RageUI.BadgeStyle.Tick,
                        Color = { BackgroundColor = { 34, 110, 22, 180 } }
                    },
                    function(onSelected, onActive)
                        if onSelected then
                            TriggerServerEvent('scriptifyer-golf:server:startGolfParty')
                        end
                    end
                )
            elseif (CurrentParties[PlayerOnlineData.Infos.partyId].States.currentGolfState == 2 or CurrentParties[PlayerOnlineData.Infos.partyId].States.currentGolfState == 3) and CurrentParties[PlayerOnlineData.Infos.partyId].Infos.ownerId.localId == PlayerOnlineData.Infos.localId then
                Items:AddButton(
                    parseText('stop_party'),
                    parseText('stop_party_desc'),
                    {
                        IsDisabled = false,
                        RightBadge = RageUI.BadgeStyle.Alert,
                        Color = { BackgroundColor = { 115, 16, 16, 180 } }
                    },
                    function(onSelected, onActive)
                        if onSelected then
                            UnregisterPlayerFromParty()
                            StopCurrentParty(PlayerOnlineData.Infos.partyId)
                        end
                    end,
                    MainMenu
                )
            elseif not CurrentParties[PlayerOnlineData.Infos.partyId].Infos.ownerId.localId == PlayerOnlineData.Infos.localId then
                Items:AddButton(
                    parseText('quit_party'),
                    parseText('quit_party_desc'),
                    {
                        IsDisabled = false,
                        RightBadge = RageUI.BadgeStyle.Alert,
                        Color = { BackgroundColor = { 115, 16, 16, 180 } }
                    },
                    function(onSelected, onActive)
                        if onSelected then
                            RageUI.CloseAll()
                            QuitParty()
                        end
                    end
                )
            end
        end
        
    end)
    PartiesList:IsVisible(function ()
        for k,v in pairs(CurrentParties) do
            if not v.isSolo and v.States.currentGolfState == 1 then
                Items:AddButton(
                    v.Infos.name,
                    v.Data.players[v.Infos.ownerId.localId].name,
                    { IsDisabled = false, RightLabel = v.Infos.nPlayers .. "/" .. v.Infos.maxPlayers },
                    function(onSelected, onActive)
                        if onSelected then
                            if v.Infos.nPlayers < v.Infos.maxPlayers then
                                if v.Infos.password ~= "" then
                                    local result = keyboard(parseText('password'), 25, "")
                                    if result == nil or result ~= v.Infos.password then
                                        return
                                    end
                                end
                                local result = keyboard(parseText('name_keyboard'), 25, "")
                                if result == nil then
                                    return
                                end
                                JoinParty(k, result)
                            else
                                showNotification(parseText('party_full'), 6, true, false)
                            end
                        end
                    end
                )
            end
        end 
    end)
    CreateParty:IsVisible(function ()
        local itemDisabled = false
        if IsPlayerInvolvedInGolfParty() then
            itemDisabled = true
        end
        Items:AddButton(
            parseText('start_solo_party'),
            parseText('start_solo_party_desc'),
            { IsDisabled = itemDisabled, RightLabel = ">>" },
            function(onSelected, onActive)
                if onSelected then
                    local result = keyboard(parseText('name_keyboard'), 25, "")
                    if result == nil or result == "" then
                        return
                    end
                    SetCreateData(parseText('solo_party'), 1, true, {name = result, localId = PlayerOnlineData.Infos.localId, isPlaying = true, score = {0, 0, 0, 0, 0, 0, 0, 0, 0}, currentHole = 1, golfId = 1, reversedIndex = 1 }, {[1] = PlayerOnlineData.Infos.localId})
                    RegisterNewParty(CreateData)
                    RegisterPlayerInsideAParty(PlayerOnlineData.Infos.localId) 
                    ResetCreateData()
                    RageUI.CloseAll()
                    RageUI.Visible(CurrentPartyFocus, true)
                end
                
            end
        )
        Items:AddButton(
            parseText('start_multi_party'),
            parseText('start_multi_party_desc'),
            { IsDisabled = itemDisabled, RightLabel = ">>" },
            function(onSelected, onActive)
            end,
            CreatePartyFocus
        )
    end)
    CreatePartyFocus:IsVisible(function ()
        Items:AddButton(
            parseText('party_name') .. CreateData.Infos.name,
            parseText('party_name_desc'),
            { IsDisabled = itemDisabled },
            function(onSelected, onActive)
                if onSelected then
                    local result = keyboard(parseText('party_name_keyboard'), 25, CreateData.Infos.name)
                    if result == nil or result == "" then
                        return
                    end
                    CreateData.Infos.name = result
                end
                
            end
        )
        Items:AddButton(
            parseText('players_max') .. CreateData.Infos.maxPlayers,
            parseText('players_max_desc'),
            { IsDisabled = itemDisabled },
            function(onSelected, onActive)
                if onSelected then
                    local result = keyboard(parseText('players_max'), 25, CreateData.Infos.maxPlayers)
                    if result == nil or tonumber(result) == nil or tonumber(result) > 4 then
                        return
                    end
                    CreateData.Infos.maxPlayers = tonumber(result)
                end           
            end
        )
        Items:AddButton(
            parseText('password') .. CreateData.Infos.password,
            parseText('password_desc'),
            { IsDisabled = itemDisabled },
            function(onSelected, onActive)
                if onSelected then
                    local result = keyboard(parseText('password'), 25, CreateData.Infos.password)
                    if result == nil then
                        return
                    end
                    CreateData.Infos.password = result
                end           
            end
        )
        Items:AddButton(
            parseText('create_golf'),
            parseText('create_golf_desc'),
            {
                IsDisabled = false,
                RightBadge = RageUI.BadgeStyle.Tick,
                Color = { BackgroundColor = { 34, 110, 22, 180 } }
            },
            function(onSelected, onActive)
                if onSelected then
                    if CreateData.Infos.name ~= "" and CreateData.Infos.maxPlayers ~= nil and CreateData.Infos.maxPlayers > 0 then
                        local result = keyboard(parseText('name_keyboard'), 25, "")
                        if result == nil or result == "" then
                            return
                        end
                        CreateData.Data.players[PlayerOnlineData.Infos.localId] = {name = result, localId = PlayerOnlineData.Infos.localId, isPlaying = true, score = {0, 0, 0, 0, 0, 0, 0, 0, 0}, currentHole = 1, golfId = 1, reversedIndex = 1 }
                        CreateData.Data.reversedPlayers = {[1] = PlayerOnlineData.Infos.localId}
                        RegisterNewParty(CreateData)
                        RegisterPlayerInsideAParty(PlayerOnlineData.Infos.localId) 
                        ResetCreateData()
                        RageUI.CloseAll()
                        RageUI.Visible(CurrentPartyFocus, true)
                    end
                    
                end
            end
        )
    end)
end

function OpenGolfMenu()
    RageUI.Visible(MainMenu, true)
end

function CloseGolfMenu()
    RageUI.Visible(MainMenu, false)
end