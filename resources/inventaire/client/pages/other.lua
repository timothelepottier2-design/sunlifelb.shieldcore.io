INVENTORY.UI.Other = {}
INVENTORY.UI.Other.Info = ""
INVENTORY.UI.Other.Alpha = 0
INVENTORY.UI.Other.AlphaFilter = 0
INVENTORY.UI.Other.AlphaCrossBar = 0
INVENTORY.UI.Other.BaseX, INVENTORY.UI.Other.BaseY = 0.5, 0.5
INVENTORY.UI.Other.Filter = "Rechercher"
INVENTORY.UI.Other.PinItem = {}
INVENTORY.UI.Other.InputActive = false
INVENTORY.UI.Other.Min = 1
INVENTORY.UI.Other.Max = 15
INVENTORY.UI.Other.Index = 0
INVENTORY.UI.Other.Page = 0
INVENTORY.UI.Other.FilterSelected = 1
INVENTORY.UI.Other.ItemGrabIndex = 0
INVENTORY.UI.Other.FilterData = {}
INVENTORY.UI.Other.ItemGrabData = {}
INVENTORY.UI.Other.CurrentWeight = "0.0"
INVENTORY.UI.Other.MaxWeight = "50.0"
local max = 10
local canPress = false

function INVENTORY.UI.Other.Draw()
    local baseX, baseY = INVENTORY.Pos.other.x, INVENTORY.Pos.other.y
    INVENTORY.UI.Other.Scroll(baseX, baseY)
    ---Icon
    local w, h = UI.CalculateCorrecteSizeForUI("ui_other_icon", "inventory", "chest", 70, 70)
    UI.DrawSpriteNew("inventory", "chest", baseX, baseY, w, h, 0, 255, 106, 0, INVENTORY.UI.Other.Alpha, {}, function ()

    end)
    if INVENTORY.IsProperty or INVENTORY.IsMailbox then
        UI.DrawTexts(baseX + 0.03, baseY, ""..INVENTORY.UI.Other.Info, false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Other.Alpha)}, UI.font["robmed"], false, false, false)
    elseif INVENTORY.IsPlayer then
        UI.DrawTexts(baseX + 0.03, baseY, GetPlayerName(GetPlayerFromServerId(tonumber(INVENTORY.UI.Other.Info))), false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Other.Alpha)}, UI.font["robmed"], false, false, false)
    else

        UI.DrawTexts(baseX + 0.03, baseY, "Coffre "..INVENTORY.UI.Other.Info, false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Other.Alpha)}, UI.font["robmed"], false, false, false)
    end
     UI.DrawTexts(baseX + 0.03, baseY + 0.03, ""..INVENTORY.UI.Other.CurrentWeight.."kg/"..INVENTORY.UI.Other.MaxWeight.."kg", false, 0.3, {255, 255, 255, math.floor(INVENTORY.UI.Other.Alpha)}, UI.font["robmed"], false, false, false)

    --DRAG AND DROP
    local x, y = UI.ConvertToPixel(581, 431)
    UI.DrawRect( baseX, baseY + h - 0.05 , x, y, 0, 255, 255, 255,0, {}, function (s, h)
        if h then
            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24)  then
                if INVENTORY.UI.Player.ItemGrabIndex ~= 0 and INVENTORY.UI.Other.Info ~= "" then
                    if  INVENTORY.IsVehicle and not INVENTORY.GetVehicleLockNear() then 
                        if INVENTORY.UI.Player.FilterSelected ~= 1 then 
                            INVENTORY.UI.Player.ItemGrabIndex = INVENTORY.UI.Player.ItemGrabIndex
                        end
                        CreateThread(function ()
                            local currentWeight = INVENTORY.UI.Other.CurrentWeight
                            if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                local data = INVENTORY.UI.Player.ItemGrabData
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                            if INVENTORY.UI.InteractItem.Confirm  then
                                                if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                                    if currentWeight + (data.weight * tonumber(INVENTORY.UI.InteractItem.CountInput)) <= INVENTORY.UI.Other.MaxWeight then 
                                                        TriggerServerEvent("inventory:server:CanPutItemVehicle", INVENTORY.UI.Other.Info, data.name,tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas )
                                                    end
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
                       
                         
                        end)
                    end
                    if INVENTORY.IsSociety then 
                        CreateThread(function ()
                            local currentWeight = INVENTORY.UI.Other.CurrentWeight
                            if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                local data = INVENTORY.UI.Player.ItemGrabData
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do

                                        if INVENTORY.UI.InteractItem.Confirm  then
                                            if INVENTORY.UI.InteractItem.CountInput > 0 then 
                                                if currentWeight +( data.weight * tonumber(INVENTORY.UI.InteractItem.CountInput)) <= INVENTORY.UI.Other.MaxWeight then 
                                                    TriggerServerEvent("inventory:server:CanPutItemSociety", INVENTORY.UI.Other.Info, data.name,tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas )
                                                end
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
                       
                         
                        end)
                    end
                    if INVENTORY.IsGang then
                        CreateThread(function()
                            local currentWeight = INVENTORY.UI.Other.CurrentWeight
                            if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                local data = INVENTORY.UI.Player.ItemGrabData
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = data
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                        if INVENTORY.UI.InteractItem.Confirm then
                                            if INVENTORY.UI.InteractItem.CountInput > 0 then
                                                local chestIndex = tonumber(INVENTORY.GangChestIndex)
                                                local qty = tonumber(INVENTORY.UI.InteractItem.CountInput) or 0
                                                if chestIndex and chestIndex > 0 and qty > 0 then
                                                    local itemWeight = tonumber(data and data.weight) or 0
                                                    local projected = (tonumber(currentWeight) or 0) + (itemWeight * qty)
                                                    if projected <= (tonumber(INVENTORY.UI.Other.MaxWeight) or 0) then
                                                        TriggerServerEvent("inventory:server:putGangChestItem", chestIndex, data.name, qty, data.metadatas)
                                                    end
                                                end
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
                        end)
                    end
                    if INVENTORY.IsProperty then
                        CreateThread(function ()
                            local currentWeight = INVENTORY.UI.Other.CurrentWeight
                            if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                local data = INVENTORY.UI.Player.ItemGrabData
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                        if INVENTORY.UI.InteractItem.Confirm  then
                                            if INVENTORY.UI.InteractItem.CountInput > 0 then

                                                if currentWeight +( data.weight * tonumber(INVENTORY.UI.InteractItem.CountInput)) <= INVENTORY.UI.Other.MaxWeight then
                                                    TriggerServerEvent("inventory:server:CanPutItemProperty", INVENTORY.UI.Other.Info, data.name,tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas )
                                                end
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
                        end)
                    end
                    -- Boite aux lettres : depot ouvert a tout le monde (5 kg, pas d'argent).
                    if INVENTORY.IsMailbox then
                        CreateThread(function ()
                            local currentWeight = INVENTORY.UI.Other.CurrentWeight
                            if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                local data = INVENTORY.UI.Player.ItemGrabData
                                if data and (data.name == "money" or data.name == "dirtymoney" or data.name == "black_money") then
                                    ESX.ShowNotification("~r~Impossible de mettre de l'argent dans une boîte aux lettres.")
                                    INVENTORY.UI.InteractItem.Maintain = false
                                    return
                                end
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = data
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                        if INVENTORY.UI.InteractItem.Confirm then
                                            if INVENTORY.UI.InteractItem.CountInput > 0 then
                                                local qty = tonumber(INVENTORY.UI.InteractItem.CountInput) or 0
                                                if currentWeight + ((tonumber(data.weight) or 0) * qty) <= INVENTORY.UI.Other.MaxWeight then
                                                    TriggerServerEvent("inventory:server:CanPutItemMailbox", INVENTORY.MailboxId, data.name, qty, data.metadatas)
                                                else
                                                    ESX.ShowNotification(("~r~Boîte aux lettres pleine (%s kg max)."):format(INVENTORY.UI.Other.MaxWeight))
                                                end
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
                        end)
                    end
                end

            end
        end
    end)


    w, h = UI.ConvertToPixel(90, 90)
    local xSeparator, ySeparator = UI.ConvertToPixel(22, 85)
    local _, ySeparatorLine = UI.ConvertToPixel(22, 22)
    max = 15

    if INVENTORY.UI.Other.FilterSelected == 1 and INVENTORY.UI.Other.FullText == "" or INVENTORY.UI.Other.FullText == "Rechercher" then
        if #INVENTORY.Other > 15 then
            max = #INVENTORY.Other
        end
    else
        if #INVENTORY.UI.Other.FilterData > 15 then
            max = #INVENTORY.UI.Other.FilterData
        end
    end
    max = max + INVENTORY.DiffNextMultiple(max)
    for i = 1, max do
        if INVENTORY.UI.Other.FilterSelected == 1 and INVENTORY.UI.Other.FullText == "" or INVENTORY.UI.Other.FullText == "Rechercher" then
            if i >= INVENTORY.UI.Other.Min and i <= INVENTORY.UI.Other.Max then
                if i - INVENTORY.UI.Other.Min < 5 then
                    if INVENTORY.Other[i] ~= nil then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Other.Min )), (baseY+ ySeparator), i, INVENTORY.Other[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Other.Min)),(baseY+ ySeparator), w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Other.Min >= 5  and i - INVENTORY.UI.Other.Min < 10 then
                    if INVENTORY.Other[i] ~= nil then

                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 5) )), (baseY+ ySeparator) + (h + ySeparatorLine) , i, INVENTORY.Other[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                else
                    if INVENTORY.Other[i] ~= nil then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 10))),(baseY+ ySeparator) + (h + ySeparatorLine) * 2, i, INVENTORY.Other[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 10))), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                end
            end
        else
            if i >= INVENTORY.UI.Other.Min and i <= INVENTORY.UI.Other.Max then
                if i - INVENTORY.UI.Other.Min < 5 then
                    if INVENTORY.UI.Other.FilterData[i] then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Other.Min )), (baseY+ ySeparator), i, INVENTORY.UI.Other.FilterData[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Other.Min )), (baseY+ ySeparator), w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Other.Min >= 5  and i - INVENTORY.UI.Other.Min < 10 then
                    if INVENTORY.UI.Other.FilterData[i] then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 5) )), (baseY+ ySeparator) + (h + ySeparatorLine) , i, INVENTORY.UI.Other.FilterData[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 5))), (baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                else
                    if INVENTORY.UI.Other.FilterData[i] then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 10))), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, i, INVENTORY.UI.Other.FilterData[i], "other")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Other.Min + 10))),(baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {}, function()
                        end)
                    end
                end
            end
        end
    end

  ---SCROLL BAR 
    w, h = UI.ConvertToPixel(4, 314)
    UI.DrawCrossBar("ui_ground_icon", baseX + 0.295, baseY + h/3.65, w, h, { 255, 255, 255, math.floor(INVENTORY.UI.Other.AlphaCrossBar) }, { 255, 106, 0, math.floor(INVENTORY.UI.Other.Alpha) } , max, 15, --[numberafficher]
        INVENTORY.UI.Other.Page ,
        {
            devmod = false,
            noHover = false,
            direction = 3
        }, function(valueUpdated, newValue, valueY)
            if valueUpdated then
                INVENTORY.UI.Other.Page = math.floor(valueY)
                if math.floor((INVENTORY.UI.Other.Page * 15) + 1) < 1 then
                    INVENTORY.UI.Other.Max = 15
                    INVENTORY.UI.Other.Min = 1
                elseif math.floor((INVENTORY.UI.Other.Page * 15) + 15) > max then
                    INVENTORY.UI.Other.Max =  max
                    INVENTORY.UI.Other.Min =  INVENTORY.UI.Other.Max  - 9
                else
                INVENTORY.UI.Other.Max = math.floor((INVENTORY.UI.Other.Page * 15)) + 15
                    INVENTORY.UI.Other.Min = INVENTORY.UI.Other.Max - 9
                end
            end
    end)
    ---SEARCH
    local letter = nil
    if INVENTORY.UI.Other.InputActive then
        letter = UI.ReturnLetter()
    end
    if INVENTORY.UI.Other.InputActive and UI.GetActiveInput() and json.encode(letter) == json.encode("\r") or IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
      
        if canPress then
            UI.DeactivateDetectInput()
            INVENTORY.UI.Other.InputActive = false
            canPress = false
            letter = nil
        end
    end

    w, h = UI.ConvertToPixel(231, 33)
    UI.DrawSpriteNew("inventory", "search_background", baseX + 0.166, baseY+ 0.005, w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {
        NoHover = false,
        NoSelect = false,
    }, function(onSelected, onHovered)
        if onHovered then
        end
        if onSelected then
            if not UI.GetActiveInput() then
                INVENTORY.UI.Other.FullText = ""
                INVENTORY.UI.Other.Filter = ""
                INVENTORY.UI.Other.InputActive = true
                INVENTORY.UI.Player.InputActive = false
                INVENTORY.UI.Ground.InputActive = false
                UI.ActivateDetectInput()
                CreateThread(function ()
                    Wait(500)
                    canPress = true
                end)
            end
        end
    end)

    UI.DrawTexts(baseX + 0.18, baseY + 0.01, INVENTORY.UI.Other.Filter, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Other.AlphaFilter)}, UI.font["robmed"], false, false, false)
    INVENTORY.UI.Other.FullText = INVENTORY.UI.Other.FullText or ""

    -- "\b" : Backspace est gere par HandleBackspaceInput (touche 194), jamais
    -- comme un caractere a ajouter au texte.
    if INVENTORY.UI.Other.InputActive and letter ~= nil and letter ~= "\b" then
        INVENTORY.UI.Other.FullText = INVENTORY.UI.Other.FullText .. letter

        local displayedTextWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Other.Filter, 0, 0.25)
        if displayedTextWidth <= (w  - 0.025) then
            INVENTORY.UI.Other.Filter = INVENTORY.UI.Other.Filter .. letter
        else
            local startIdx = 1
            while INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Other.FullText, startIdx), 0, 0.25) > (w  - 0.025) and startIdx <= #INVENTORY.UI.Other.FullText do
                startIdx = startIdx + 1
            end
            INVENTORY.UI.Other.Filter = string.sub(INVENTORY.UI.Other.FullText, startIdx)
        end
        if INVENTORY.UI.Other.FilterSelected == 1 then
            INVENTORY.UI.Other.FilterData = {}
            for key, value in pairs(INVENTORY.Other) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText)) then    
                    table.insert(INVENTORY.UI.Other.FilterData, value)
                end
            end
        else
            INVENTORY.UI.Other.FilterData = {}
            for key, value in pairs(INVENTORY.Other) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText)) then    
                    table.insert(INVENTORY.UI.Other.FilterData, value)
                end
            end
        end
    end

    INVENTORY.UI.Other.HandleBackspaceInput()

    local i = 0
    w, h = UI.ConvertToPixel(34, 34)
    for key, value in pairs(ConfigShared.Filter) do
        if INVENTORY.UI.Other.FilterSelected == key then
            UI.DrawSpriteNew("inventory", value.spriteHovered, baseX + 0.168 + (w + 13/1920) * i, baseY + h + 0.007, w, h , 0, 255, 106, 0, INVENTORY.UI.Other.Alpha, {
                NoHover = false,
                NoSelect = false,
                CustomHoverTexture = {"inventory", value.spriteHovered}
            }, function(onSelected)
                if onSelected then
                    INVENTORY.UI.Other.FilterSelected = key
                    INVENTORY.UI.Other.Min = 1
                    INVENTORY.UI.Other.Max = 15
                end
            end)
        else
            UI.DrawSpriteNew("inventory", value.sprite, baseX + 0.168 + (w + 13/1920) * i, baseY + h + 0.007, w, h , 0, 255, 106, 0, INVENTORY.UI.Other.Alpha, {
                NoHover = false,
                NoSelect = false,
                CustomHoverTexture = {"inventory", value.spriteHovered}
            }, function(onSelected)
                if onSelected then
                    INVENTORY.UI.Other.FilterSelected = key
                    INVENTORY.UI.Other.FilterData = {}
                    INVENTORY.UI.Other.Min = 1
                    INVENTORY.UI.Other.Max = 15
                    if key ~=  1 then
                        for k, v in pairs(INVENTORY.Other) do
                            if v ~= nil then 
                                if next(v) then 
                                    if value.item[v.name] then
                                        table.insert(INVENTORY.UI.Other.FilterData, v)
                                    end
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

function INVENTORY.UI.Other.HandleBackspaceInput()
    if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
        INVENTORY.UI.Other.RemoveLastCharacter()
        isBackspaceHeld = true
        backspaceHeldTime = GetGameTimer()
    elseif (IsDisabledControlPressed(0, 194) or IsControlPressed(0, 194)) and isBackspaceHeld then
        if (GetGameTimer() - backspaceHeldTime) > (repeatThreshold * 1000) then
            if (GetGameTimer() - backspaceHeldTime) % (repeatRate * 1000) < 50 then
                INVENTORY.UI.Other.RemoveLastCharacter()
            end
        end
    else
        isBackspaceHeld = false
        backspaceHeldTime = 0
    end
end

function INVENTORY.UI.Other.Scroll(baseX, baseY)
    local wRect, hRect = UI.ConvertToPixel(568, 415)
    UI.DrawRect(baseX, baseY, wRect, hRect, 0, 255, 255, 255, 0, {}, function (s, h)
        if h then
            if IsDisabledControlPressed(0, 180) or IsControlPressed(0, 180) then
                if INVENTORY.UI.Other.Max < max then
                    INVENTORY.UI.Other.Min = INVENTORY.UI.Other.Min + 5
                    INVENTORY.UI.Other.Max = INVENTORY.UI.Other.Max + 5
                    INVENTORY.UI.Other.Page = INVENTORY.UI.Other.Page + 1
                    if INVENTORY.UI.Other.Max > max then
                        INVENTORY.UI.Other.Min = max - 9
                        INVENTORY.UI.Other.Max = max
                        INVENTORY.UI.Other.Page = (max/10) - 1
                    end
                end
            end
            if IsDisabledControlPressed(0, 115) or IsControlPressed(0, 115) then
                if INVENTORY.UI.Other.Min > 1 then
                    INVENTORY.UI.Other.Min = INVENTORY.UI.Other.Min - 5

                    INVENTORY.UI.Other.Max = INVENTORY.UI.Other.Max - 5

                    INVENTORY.UI.Other.Page = INVENTORY.UI.Other.Page - 1
                    if INVENTORY.UI.Other.Min < 1 then
                        INVENTORY.UI.Other.Min = 1
                        INVENTORY.UI.Other.Max = 10
                        INVENTORY.UI.Other.Page = 0
                    end
                end
            end
        end
    end)
end


local w, h = UI.ConvertToPixel(231, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.Other.RemoveLastCharacter()
    if string.len(INVENTORY.UI.Other.FullText) > 0 then
        INVENTORY.UI.Other.FullText = string.sub(INVENTORY.UI.Other.FullText, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Other.FullText, 0, 0.25)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.Other.FullText) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Other.FullText, startIdx), 0, 0.25)
            end
            INVENTORY.UI.Other.Filter = string.sub(INVENTORY.UI.Other.FullText, startIdx)
        else
            INVENTORY.UI.Other.Filter = INVENTORY.UI.Other.FullText
        end
        if INVENTORY.UI.Other.FilterSelected == 1 then
            INVENTORY.UI.Other.FilterData = {}
            for key, value in pairs(INVENTORY.Other) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText)) then    
                    table.insert(INVENTORY.UI.Other.FilterData, value)
                end
            end
        else
            INVENTORY.UI.Other.FilterData = {}
            for key, value in pairs(INVENTORY.Other) do
                if string.sub(string.upper(value.label), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) or string.sub(string.upper(value.name), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText) 
                    or (value.metadatas ~= nil and value.metadatas.rename ~= nil and string.sub(string.upper(value.metadatas.rename), 1, string.len(string.upper(INVENTORY.UI.Other.FullText))) == string.upper(INVENTORY.UI.Other.FullText)) then    
                    table.insert(INVENTORY.UI.Other.FilterData, value)
                end
            end
        end
    end
end

RegisterNetEvent("inventory:client:removePin", function (index)
    INVENTORY.UI.Other.PinItem[index] = nil
end)
