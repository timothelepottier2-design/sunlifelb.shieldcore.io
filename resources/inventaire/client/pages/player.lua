INVENTORY.UI.Player = {}
INVENTORY.UI.Player.Alpha = 0
INVENTORY.UI.Player.AlphaFilter = 0
INVENTORY.UI.Player.AlphaCrossBar = 0
INVENTORY.UI.Player.BaseX, INVENTORY.UI.Player.BaseY = 0.5, 0.5
INVENTORY.UI.Player.Filter = "Rechercher"
INVENTORY.UI.Player.PinItem = {}
INVENTORY.UI.Player.Min = 1
INVENTORY.UI.Player.Max = 25
INVENTORY.UI.Player.Index = 0
INVENTORY.UI.Player.Page = 0
INVENTORY.UI.Player.InputActive = false
INVENTORY.UI.Player.FilterSelected = 1
INVENTORY.UI.Player.ItemGrabIndex = 0
INVENTORY.UI.Player.FilterData = {}
INVENTORY.UI.Player.ItemGrabData = {}
INVENTORY.UI.Player.CurrentWeight = "0.0"
TEST = false
local max = 10
local canPress = false
function INVENTORY.UI.Player.Draw()
    local baseX, baseY = INVENTORY.Pos.player.x, INVENTORY.Pos.player.y
    INVENTORY.UI.Player.Scroll(baseX, baseY)
    ---Icon
    local w, h = UI.CalculateCorrecteSizeForUI("ui_player_icon", "inventory", "player_icon", 70, 70)
    UI.DrawSpriteNew("inventory", "player_icon", baseX, baseY, w, h, 0, 255, 106, 0, INVENTORY.UI.Player.Alpha, {}, function ()

    end)
    if IsControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 200) then
        -- if not INVENTORY.Open then
            TriggerEvent("inventory:client:closeInventory")
        -- else
        --     INVENTORY.Close()
        -- end
    end
    UI.DrawTexts(baseX + 0.03, baseY, "Joueur", false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, UI.font["robmed"], false, false, false)
    UI.DrawTexts(baseX + 0.03, baseY + 0.03, ""..INVENTORY.UI.Player.CurrentWeight.."kg/"..INVENTORY.MaxWeight.."kg", false, 0.3, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, UI.font["robmed"], false, false, false)

    --DRAG AND DROP
    local x, y = UI.ConvertToPixel(581, 1000)
    UI.DrawRect( baseX, baseY + h - 0.05 , x, y, 0, 255, 255, 255,0, {}, function (s, h)
        if h then

            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) and INVENTORY.UI.Other.ItemGrabIndex ~= 0 or INVENTORY.UI.Ground.ItemGrabIndex ~= 0 or INVENTORY.UI.PlayerProx.ItemGrabIndex ~= 0 then
                if INVENTORY.UI.Ground.ItemGrabIndex ~= 0 then
                    if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                        local zeub = INVENTORY.UI.Ground.ItemGrabIndex
                        INVENTORY.UI.InteractItem.NeedConfirmCount = true
                        INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Ground.ItemGrabData
                        CreateThread(function()
                            while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                if INVENTORY.UI.InteractItem.Confirm  then
                                    if INVENTORY.UI.InteractItem.CountInput > 0 then
                                        TriggerServerEvent("inventory:server:takeDrop", INVENTORY.UI.Ground.ItemGrabData.index, tonumber(INVENTORY.UI.InteractItem.CountInput), INVENTORY.UI.Ground.ItemGrabData.indexRandom)
                                        INVENTORY.UI.InteractItem.Confirm = false
                                        INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                    end
                                    break
                                end
                                Wait(100)
                            end
                        end)
                        INVENTORY.UI.InteractItem.Maintain = false
                    end

                end

                if INVENTORY.UI.Other.ItemGrabIndex ~= 0 then
                    if INVENTORY.IsVehicle and not INVENTORY.GetVehicleLockNear() then
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount and INVENTORY.UI.Other.ItemGrabData ~= nil then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Other.ItemGrabData
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm  then
                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                            TriggerServerEvent("inventory:server:CanTakeItemVehicle", INVENTORY.UI.Other.Info, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                            INVENTORY.UI.InteractItem.Confirm = false
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        end
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end

                    end

                    if INVENTORY.IsSociety then
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Other.ItemGrabData
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm  then
                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                            TriggerServerEvent("inventory:server:CanTakeItemSociety", INVENTORY.UI.Other.Info, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                            INVENTORY.UI.InteractItem.Confirm = false
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        end
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end
                        -- CreateThread(function ()
                        --     local number = INVENTORY.InputString("Montant")
                        --     local data = INVENTORY.UI.Other.ItemGrabData
                        --     if number and tonumber(number) and  tonumber(number) <= data.count then
                        --         TriggerServerEvent("inventory:server:CanTakeItemSociety", INVENTORY.UI.Other.Info, data.name, tonumber(number), data.metadatas)
                        --     end
                        -- end)
                    end
                    if INVENTORY.IsGang then
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount and INVENTORY.UI.Other.ItemGrabData ~= nil then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = data
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm then
                                        local qty = tonumber(INVENTORY.UI.InteractItem.CountInput) or 0
                                        local chestIndex = tonumber(INVENTORY.GangChestIndex)
                                        if qty > 0 and chestIndex and chestIndex > 0 then
                                            TriggerServerEvent("inventory:server:takeGangChestItem", chestIndex, data.name, qty, data.metadatas)
                                        end
                                        INVENTORY.UI.InteractItem.Confirm = false
                                        INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end
                    end
                    if INVENTORY.IsPlayer and (ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sheriff" or ESX.PlayerData.job.name == "marshall") then
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Other.ItemGrabData
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm  then
                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 
                                            -- inventaire:server:grabItem", function (id, item, count, metadatas)
                                            TriggerServerEvent("inventaire:server:grabItem", INVENTORY.UI.Other.Info, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                            INVENTORY.UI.InteractItem.Confirm = false
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        end
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end
                    end
                    if INVENTORY.IsProperty then
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Other.ItemGrabData
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm  then
                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                            TriggerServerEvent("inventory:server:CanTakeItemProperty", INVENTORY.UI.Other.Info, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                            INVENTORY.UI.InteractItem.Confirm = false
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        end
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end
                        
                        -- CreateThread(function ()
                        --     local number = INVENTORY.InputString("Montant")
                        --     local data = INVENTORY.UI.Other.ItemGrabData
                        --     if number and tonumber(number) and  tonumber(number) <= data.count then
                        --         TriggerServerEvent("inventory:server:CanTakeItemProperty", INVENTORY.UI.Other.Info, data.name, tonumber(number), data.metadatas)
                        --     end
                        -- end)
                    end
                    -- Boite aux lettres : retrait reserve au locataire / co-proprietaire.
                    if INVENTORY.IsMailbox then
                        if not INVENTORY.MailboxCanWithdraw then
                            ESX.ShowNotification("~r~Seul le locataire de cette propriété peut retirer le courrier.")
                            INVENTORY.UI.InteractItem.Maintain = false
                        elseif not INVENTORY.UI.InteractItem.NeedConfirmCount then
                            local data = INVENTORY.UI.Other.ItemGrabData
                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                            INVENTORY.UI.InteractItem.Data = data
                            CreateThread(function()
                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                    if INVENTORY.UI.InteractItem.Confirm then
                                        if INVENTORY.UI.InteractItem.CountInput > 0 then
                                            TriggerServerEvent("inventory:server:CanTakeItemMailbox", INVENTORY.MailboxId, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                            INVENTORY.UI.InteractItem.Confirm = false
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                        end
                                        break
                                    end
                                    Wait(100)
                                end
                            end)
                            INVENTORY.UI.InteractItem.Maintain = false
                        end
                    end

                end

            end
        end
    end)

    ---List Icon Biatch
    w, h = UI.ConvertToPixel(90, 90)
    local xSeparator, ySeparator = UI.ConvertToPixel(22, 85)
    local _, ySeparatorLine = UI.ConvertToPixel(22, 22)
    for i = 1, 5 do
        INVENTORY.UI.Player.DrawPinItem(baseX, baseY, i)
    end
    max = 25
    if INVENTORY.UI.Player.FilterSelected == 1 and INVENTORY.UI.Player.FullText == "" or INVENTORY.UI.Player.FullText == "Rechercher" then
        if not TEST then 
            TEST = true
            -- INVENTORY.UI.Player.FilterData = {}
            -- for key, value in pairs(INVENTORY.Player) do
            --     if not ConfigShared.Filter[5].item[string.upper(value.name)] and not ESX.IsContribWeapon(string.upper(value.name)) then 
            --         table.insert(INVENTORY.UI.Player.FilterData, value)
            --     end  
            -- end
            -- INVENTORY.Player = INVENTORY.UI.Player.FilterData
        end
        if #INVENTORY.Player > 25 then
            max = #INVENTORY.Player
        end
        
    else
        if #INVENTORY.UI.Player.FilterData > 25 then
            max = #INVENTORY.UI.Player.FilterData
        end
    end
    max = max + INVENTORY.DiffNextMultiple(max)

    for i = 1, max do
        if INVENTORY.UI.Player.FilterSelected == 1 and INVENTORY.UI.Player.FullText == "" or INVENTORY.UI.Player.FullText == "Rechercher" then
            if i >= INVENTORY.UI.Player.Min and i <= INVENTORY.UI.Player.Max then
                if i - INVENTORY.UI.Player.Min < 5 then
                    if INVENTORY.Player[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Player.Min )), (baseY+ ySeparator) + (h + ySeparatorLine), i, INVENTORY.Player[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Player.Min)),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 5 and i - INVENTORY.UI.Player.Min < 10 then
                    if INVENTORY.Player[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 5) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, i, INVENTORY.Player[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 10 and i - INVENTORY.UI.Player.Min < 15 then
                    if INVENTORY.Player[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 10) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 3, i, INVENTORY.Player[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 10))),(baseY+ ySeparator) + (h + ySeparatorLine) * 3, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 15 and i - INVENTORY.UI.Player.Min < 20 then
                    if INVENTORY.Player[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 15) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 4, i, INVENTORY.Player[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 15))),(baseY+ ySeparator) + (h + ySeparatorLine) * 4, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 20 and i - INVENTORY.UI.Player.Min < 25 then
                    if INVENTORY.Player[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 20) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 5, i, INVENTORY.Player[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 20))),(baseY+ ySeparator) + (h + ySeparatorLine) * 5, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                end
            end
        else
            if i >= INVENTORY.UI.Player.Min and i <= INVENTORY.UI.Player.Max then
                if i - INVENTORY.UI.Player.Min < 5 then
                    if INVENTORY.UI.Player.FilterData[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Player.Min )), (baseY+ ySeparator) + (h + ySeparatorLine), i, INVENTORY.UI.Player.FilterData[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Player.Min)),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 5 and i - INVENTORY.UI.Player.Min < 10 then
                    if INVENTORY.UI.Player.FilterData[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 5) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, i, INVENTORY.UI.Player.FilterData[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 10 and i - INVENTORY.UI.Player.Min < 15 then
                    if INVENTORY.UI.Player.FilterData[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 10) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 3, i, INVENTORY.UI.Player.FilterData[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 10))),(baseY+ ySeparator) + (h + ySeparatorLine) * 3, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 15 and i - INVENTORY.UI.Player.Min < 20 then
                    if INVENTORY.UI.Player.FilterData[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 15) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 4, i, INVENTORY.UI.Player.FilterData[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 15))),(baseY+ ySeparator) + (h + ySeparatorLine) * 4, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Player.Min >= 20 and i - INVENTORY.UI.Player.Min < 25 then
                    if INVENTORY.UI.Player.FilterData[i] then
                        INVENTORY.UI.DrawItemPlayer(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 20) )), (baseY+ ySeparator) + (h + ySeparatorLine) * 5, i, INVENTORY.UI.Player.FilterData[i], "player")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Player.Min + 20))),(baseY+ ySeparator) + (h + ySeparatorLine) * 5, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                        end)
                    end
                end
            end
        end
    end

  ---SCROLL BAR 
    w, h = UI.ConvertToPixel(4, 650)
    UI.DrawCrossBar("player", baseX + 0.295, baseY + h/7.5, w, h, { 255, 255, 255, math.floor(INVENTORY.UI.Player.AlphaCrossBar) }, { 255, 106, 0, math.floor(INVENTORY.UI.Player.Alpha)} , max, 25, --[numberafficher]
        INVENTORY.UI.Player.Page ,
        {
            devmod = false,
            noHover = false,
            direction = 3
        }, function(valueUpdated, newValue, valueY)
            if valueUpdated then
                INVENTORY.UI.Player.Page = math.floor(valueY)
                if math.floor((INVENTORY.UI.Player.Page * 25) + 1) < 1 then
                    INVENTORY.UI.Player.Max = 25
                    INVENTORY.UI.Player.Min = 1
                elseif math.floor((INVENTORY.UI.Player.Page * 25) + 25) > max then
                    INVENTORY.UI.Player.Max =  max
                    INVENTORY.UI.Player.Min =  INVENTORY.UI.Player.Max  - 24
                else
                    INVENTORY.UI.Player.Max = math.floor((INVENTORY.UI.Player.Page * 25)) + 25
                    INVENTORY.UI.Player.Min = INVENTORY.UI.Player.Max - 24
                end
            end
    end)
    ---SEARCH
    local letter = nil
    if INVENTORY.UI.Player.InputActive and UI.GetActiveInput() then
        letter = UI.ReturnLetter()
    end
    if INVENTORY.UI.Player.InputActive and UI.GetActiveInput() and json.encode(letter) == json.encode("\r") or IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
        if canPress then
            UI.DeactivateDetectInput()
            INVENTORY.UI.Player.InputActive  = false
            canPress = false
            letter = nil
        end
    end
    w, h = UI.ConvertToPixel(231, 33)
    UI.DrawSpriteNew("inventory", "search_background", baseX + 0.166, baseY+ 0.005, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
        NoHover = false,
        NoSelect = false,
    }, function(onSelected, onHovered)
        if onHovered then
        end
        if onSelected then
            if not UI.GetActiveInput() then
                INVENTORY.UI.Player.FullText = ""
                INVENTORY.UI.Player.Filter = ""
                INVENTORY.UI.Other.InputActive = false
                INVENTORY.UI.Ground.InputActive = false
                INVENTORY.UI.Player.InputActive = true
                UI.ActivateDetectInput()
                CreateThread(function ()
                    Wait(500)
                    canPress = true
                end)
            end
        end
    end)
    UI.DrawTexts(baseX + 0.18, baseY + 0.01,     INVENTORY.UI.Player.Filter, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Player.AlphaFilter)}, UI.font["robmed"], false, false, false)
    INVENTORY.UI.Player.FullText = INVENTORY.UI.Player.FullText or ""

    -- "\b" : Backspace est gere par HandleBackspaceInput (touche 194), jamais
    -- comme un caractere a ajouter au texte.
    if INVENTORY.UI.Player.InputActive and letter ~= nil and letter ~= "\b" then
        INVENTORY.UI.Player.FullText = INVENTORY.UI.Player.FullText .. letter

        local displayedTextWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Player.Filter, 0, 0.25)
        if displayedTextWidth <= (w  - 0.025) then
            INVENTORY.UI.Player.Filter = INVENTORY.UI.Player.Filter .. letter
        else
            local startIdx = 1
            while INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Player.FullText, startIdx), 0, 0.25) > (w  - 0.025) and startIdx <= #INVENTORY.UI.Player.FullText do
                startIdx = startIdx + 1
            end
            INVENTORY.UI.Player.Filter = string.sub(INVENTORY.UI.Player.FullText, startIdx)
        end
        if INVENTORY.UI.Player.FilterSelected == 1 then
            INVENTORY.UI.Player.FilterData = {}
            for key, value in pairs(INVENTORY.Player) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) 
                or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText)) then                    if not ConfigShared.Filter[5].item[string.upper(value.name)] or not ESX.IsContribWeapon(string.upper(value.name)) then 
                        table.insert(INVENTORY.UI.Player.FilterData, value)
                    end
                end
            end
        else
            INVENTORY.UI.Player.FilterData = {}
            for key, value in pairs(INVENTORY.Player) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText)) then                    
                    table.insert(INVENTORY.UI.Player.FilterData, value)
                end
            end
        end
    end

    INVENTORY.UI.Player.HandleBackspaceInput()

    local i = 0
    w, h = UI.ConvertToPixel(34, 34)
    for key, value in pairs(ConfigShared.Filter) do
        if INVENTORY.UI.Player.FilterSelected == key then
            UI.DrawSpriteNew("inventory", value.spriteHovered, baseX + 0.168 + (w + 13/1920) * i, baseY + h + 0.007, w, h , 0, 255, 106, 0, INVENTORY.UI.Player.Alpha, {
                NoHover = false,
                NoSelect = false,
                CustomHoverTexture = {"inventory", value.spriteHovered}
            }, function(onSelected)
                if onSelected then
                    if key == 1 then 
                        ESX.PlayerData = ESX.GetPlayerData()
                        if ConfigShared.Framework == "esx" then
                            INVENTORY.Player = ESX.PlayerData.inventory
                        end
                        INVENTORY.UI.Player.FilterSelected = key
                        INVENTORY.UI.Player.FilterData = {}
                        INVENTORY.UI.Player.Min = 1
                        INVENTORY.UI.Player.Max = 25
                        for k, v in pairs(INVENTORY.Player) do
                            if not ConfigShared.Filter[5].item[string.upper(v.name)] and not ESX.IsContribWeapon(string.upper(v.name)) then 
                                table.insert(INVENTORY.UI.Player.FilterData, v)
                            end
                        end
                        INVENTORY.Player = INVENTORY.UI.Player.FilterData
                    else
                        ESX.PlayerData = ESX.GetPlayerData()
                        if ConfigShared.Framework == "esx" then
                            INVENTORY.Player = ESX.PlayerData.inventory
                        end
                        INVENTORY.UI.Player.FilterSelected = key
                        INVENTORY.UI.Player.Min = 1
                        INVENTORY.UI.Player.Max = 25    
                    end
                end
            end)
        else
            UI.DrawSpriteNew("inventory", value.sprite, baseX + 0.168 + (w + 13/1920) * i, baseY + h + 0.007, w, h , 0, 255, 106, 0, INVENTORY.UI.Player.Alpha, {
                NoHover = false,
                NoSelect = false,
                CustomHoverTexture = {"inventory", value.spriteHovered}
            }, function(onSelected)
                if onSelected then
                    if key == 1 then 
                        ESX.PlayerData = ESX.GetPlayerData()
                        if ConfigShared.Framework == "esx" then
                            INVENTORY.Player = ESX.PlayerData.inventory
                        end
                        INVENTORY.UI.Player.FilterSelected = key
                        INVENTORY.UI.Player.FilterData = {}
                        INVENTORY.UI.Player.Min = 1
                        INVENTORY.UI.Player.Max = 25
                        for k, v in pairs(INVENTORY.Player) do
                            if not ConfigShared.Filter[5].item[string.upper(v.name)] and not ESX.IsContribWeapon(string.upper(v.name)) then 
                                table.insert(INVENTORY.UI.Player.FilterData, v)
                            end
                        end
                        INVENTORY.Player = INVENTORY.UI.Player.FilterData
                    else
                        ESX.PlayerData = ESX.GetPlayerData()
                        if ConfigShared.Framework == "esx" then
                            INVENTORY.Player = ESX.PlayerData.inventory
                        end
                        INVENTORY.UI.Player.FilterSelected = key
                        INVENTORY.UI.Player.FilterData = {}
                        INVENTORY.UI.Player.Min = 1
                        INVENTORY.UI.Player.Max = 25
                        if key ~=  1 then
                            for k, v in pairs(INVENTORY.Player) do
                                if value.item[v.name] then
                                    table.insert(INVENTORY.UI.Player.FilterData, v)
                                end
                            end
                        end
                    end
                  

                end
            end)
        end

        i = i + 1
    end
end
local isBackspaceHeld = false
local backspaceHeldTime = 0
local repeatThreshold = 0.5
local repeatRate = 0.1

function INVENTORY.UI.Player.HandleBackspaceInput()
    if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
        INVENTORY.UI.Player.RemoveLastCharacter()
        isBackspaceHeld = true
        backspaceHeldTime = GetGameTimer()
    elseif (IsDisabledControlPressed(0, 194) or IsControlPressed(0, 194)) and isBackspaceHeld then
        if (GetGameTimer() - backspaceHeldTime) > (repeatThreshold * 1000) then
            if (GetGameTimer() - backspaceHeldTime) % (repeatRate * 1000) < 50 then
                INVENTORY.UI.Player.RemoveLastCharacter()
            end
        end
    else
        isBackspaceHeld = false
        backspaceHeldTime = 0
    end
end
local w, h = UI.ConvertToPixel(90, 90)
local xSeparator, ySeparator = UI.ConvertToPixel(22, 85)
local _, ySeparatorLine = UI.ConvertToPixel(22, 22)

function INVENTORY.UI.Player.DrawPinItem(baseX, baseY, i)

    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - 1)), baseY + ySeparator, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
        NoHover = false
    }, function(onSelected, onHovered)
        if onHovered then
            if IsControlPressed(0, 25) or IsDisabledControlPressed(0, 25) then
                INVENTORY.UI.Player.PinItem[i] = nil
                -- TriggerServerEvent('inventory:server:updateRaccourci', i, nil)
                AddRaccourci(i, nil)
                INVENTORY.UI.Player.ItemGrabIndex = 0
            end
            if not IsDisabledControlPressed(0, 24) and INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
                if INVENTORY.UI.Player.FilterSelected ~= 1 then 
                    INVENTORY.UI.Player.ItemGrabIndex = INVENTORY.UI.Player.ItemGrabIndex
                    INVENTORY.UI.Player.PinItem[i] = INVENTORY.UI.Player.ItemGrabData
                    local table = {
                        name = INVENTORY.UI.Player.ItemGrabData.name,
                        label = INVENTORY.UI.Player.ItemGrabData.label,
                        weight = INVENTORY.UI.Player.ItemGrabData.weight,
                        metadatas = INVENTORY.UI.Player.ItemGrabData.metadatas
                    }
                    -- TriggerServerEvent('inventory:server:updateRaccourci', i, table)
                    AddRaccourci(i, table)

                    INVENTORY.UI.Player.ItemGrabIndex = 0
                else
                    INVENTORY.UI.Player.PinItem[i] = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex]
                    local table = {
                        name = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex].name,
                        label = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex].label,
                        weight = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex].weight,
                        metadatas = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex].metadatas
                    }
                    -- TriggerServerEvent('inventory:server:updateRaccourci', i, table)
                    AddRaccourci(i, table)

                    INVENTORY.UI.Player.ItemGrabIndex = 0
                end
                
            end
        end
    end)

    UI.DrawTexts(baseX + 0.005 + ((w + xSeparator) * (i - 1)) + 0.002, baseY + ySeparator, tostring(i), false, 0.2, {255, 106, 0, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)

    --
    if INVENTORY.UI.Player.PinItem[i] ~= nil  then

        local data = INVENTORY.UI.Player.PinItem[i]
        local sprite, iconDict, iconCustom = ItemIcons.Resolve(data.name)
        UI.DrawTexts(baseX + 0.008 + ((w + xSeparator) * (i - 1)) , baseY + ySeparator + h - 0.02, tostring("x"..data.count), false, 0.2, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)
        if sprite == "box" then
            local x,y = UI.CalculateCorrecteSizeForUI("ui_icon_item"..i, "inventory", "box", 70, 70)
            UI.DrawSpriteNew("inventory", "box", baseX + 0.005 + ((w + xSeparator) * (i - 1)) + (w/2 ), baseY + ySeparator + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
                centerDraw = true,
                NoHover = false
            }, function(onSelected, onHovered)

            end)
            x, y = UI.ConvertToPixel(90, 2)
            UI.DrawRect( baseX + 0.005 + ((w + xSeparator) * (i - 1)), baseY + ySeparator + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function ()

            end)
        elseif iconCustom then
            local x,y = UI.ConvertToPixel(70, 70)
            ItemIcons.Draw(iconDict, sprite, baseX + 0.005 + ((w + xSeparator) * (i - 1)) + (w/2 ), baseY + ySeparator + h/2, x, y, INVENTORY.UI.Player.Alpha)
            x, y = UI.ConvertToPixel(90, 2)
            UI.DrawRect( baseX + 0.005 + ((w + xSeparator) * (i - 1)), baseY + ySeparator + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function ()

            end)
        else
            local x,y = UI.CalculateCorrecteSizeForUI("item_icon"..i, "item_icon", sprite, 70, 70)
            UI.DrawSpriteNew("item_icon", sprite, baseX + 0.005 + ((w + xSeparator) * (i - 1)) + (w/2 ), baseY + ySeparator + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
                centerDraw = true,
                NoHover = false

            }, function(onSelected, onHovered)

            end)
            x, y = UI.ConvertToPixel(90, 2)
            UI.DrawRect( baseX + 0.005 + ((w + xSeparator) * (i - 1)), baseY + ySeparator + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function ()

            end)
        end
    end
end

function INVENTORY.UI.Player.Scroll(baseX, baseY)
    local wRect, hRect = UI.ConvertToPixel(568, 1000)
    UI.DrawRect(baseX, baseY, wRect, hRect, 0, 255, 255, 255, 0, {}, function (s, h)
        if h then
            if IsDisabledControlPressed(0, 180) or IsControlPressed(0, 180) then
                if INVENTORY.UI.Player.Max < max then
                    INVENTORY.UI.Player.Min = INVENTORY.UI.Player.Min + 5
                    INVENTORY.UI.Player.Max = INVENTORY.UI.Player.Max + 5
                    INVENTORY.UI.Player.Page = INVENTORY.UI.Player.Page + 1
                    if INVENTORY.UI.Player.Max > max then
                        INVENTORY.UI.Player.Min = max - 24
                        INVENTORY.UI.Player.Max = max
                        INVENTORY.UI.Player.Page = (max/25) - 1
                    end
                end
            end
            if IsDisabledControlPressed(0, 115) or IsControlPressed(0, 115) then
                if INVENTORY.UI.Player.Min > 1 then
                    INVENTORY.UI.Player.Min = INVENTORY.UI.Player.Min - 5

                    INVENTORY.UI.Player.Max = INVENTORY.UI.Player.Max - 5

                    INVENTORY.UI.Player.Page = INVENTORY.UI.Player.Page - 1
                    if INVENTORY.UI.Player.Min < 1 then
                        INVENTORY.UI.Player.Min = 1
                        INVENTORY.UI.Player.Max = 25
                        INVENTORY.UI.Player.Page = 0
                    end
                end
            end
        end
    end)
end


local w, h = UI.ConvertToPixel(231, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.Player.RemoveLastCharacter()
    if string.len(INVENTORY.UI.Player.FullText) > 0 then
        INVENTORY.UI.Player.FullText = string.sub(INVENTORY.UI.Player.FullText, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Player.FullText, 0, 0.25)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.Player.FullText) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Player.FullText, startIdx), 0, 0.25)
            end
            INVENTORY.UI.Player.Filter = string.sub(INVENTORY.UI.Player.FullText, startIdx)
        else
            INVENTORY.UI.Player.Filter = INVENTORY.UI.Player.FullText
        end
        if INVENTORY.UI.Player.FilterSelected == 1 then
            INVENTORY.UI.Player.FilterData = {}
            for key, value in pairs(INVENTORY.Player) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText)) then                    if not ConfigShared.Filter[5].item[string.upper(value.name)] or not ESX.IsContribWeapon(string.upper(value.name)) then 
                        table.insert(INVENTORY.UI.Player.FilterData, value)
                    end
                end
            end
        else
            INVENTORY.UI.Player.FilterData = {}
            for key, value in pairs(INVENTORY.Player) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Player.FullText))) == string.upper(INVENTORY.UI.Player.FullText)) then
                    table.insert(INVENTORY.UI.Player.FilterData, value)
                end
            end
        end
    end
end

RegisterNetEvent("inventory:client:removePin", function (index)
    INVENTORY.UI.Player.PinItem[index] = nil
end)