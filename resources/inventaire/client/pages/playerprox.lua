INVENTORY.UI.PlayerProx = {}
INVENTORY.UI.Player.Alpha = 0
INVENTORY.UI.Player.AlphaFilter = 0
INVENTORY.UI.Player.AlphaCrossBar = 0
INVENTORY.UI.PlayerProx.BaseX, INVENTORY.UI.PlayerProx.BaseY = 0.5, 0.5
INVENTORY.UI.PlayerProx.Filter = "Rechercher"
INVENTORY.UI.PlayerProx.PinItem = {}
INVENTORY.UI.PlayerProx.InputActive = false
INVENTORY.UI.PlayerProx.Min = 1
INVENTORY.UI.PlayerProx.Max = 15
INVENTORY.UI.PlayerProx.Index = 0
INVENTORY.UI.PlayerProx.Page = 0
INVENTORY.UI.PlayerProx.FilterSelected = 1
INVENTORY.UI.PlayerProx.ItemGrabIndex = 0
INVENTORY.UI.PlayerProx.FilterData = {}
INVENTORY.UI.PlayerProx.ItemGrabData = {}
INVENTORY.UI.PlayerProx.CurrentWeight = "0.0"
local max = 10
local canPress = false
function INVENTORY.UI.PlayerProx.Draw()
    local baseX, baseY = INVENTORY.Pos.playerprox.x, INVENTORY.Pos.playerprox.y
    INVENTORY.UI.PlayerProx.Scroll(baseX, baseY)
    ---Icon
    local w, h = UI.CalculateCorrecteSizeForUI("ui_ground_icon", "inventory", "ground", 59, 59)
    UI.DrawSpriteNew("inventory", "ground", baseX, baseY, w, h, 0, 255, 106, 0, INVENTORY.UI.Player.Alpha, {}, function ()

    end)

    UI.DrawTexts(baseX + 0.03, baseY, "Joueur a proximité", false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, UI.font["robmed"], false, false, false)
    -- UI.DrawTexts(baseX + 0.03, baseY + 0.03, "".."10.0".."kg/".."ESX.PlayerData.maxWeight".."kg", false, 0.3, {255, 255, 255, 255}, UI.font["robmed"], false, false, false)
    w, h = UI.ConvertToPixel(33, 15)
    UI.DrawSpriteNew("inventory", "inifinity", baseX + 0.03, baseY + 0.03, w, h, 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function ()

    end)

    local x, y = UI.ConvertToPixel(581, 431)
    UI.DrawRect( baseX, baseY + h - 0.05 , x, y, 0, 255, 255, 255,0, {}, function (s, h)
        if h then
            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then    
                    if INVENTORY.UI.Player.FilterSelected ~= 1 then 
                        INVENTORY.UI.Player.ItemGrabIndex = INVENTORY.UI.Player.ItemGrabIndex
                    end   
                end
            end
        end
    end)

    ---List Icon Biatch
    w, h = UI.ConvertToPixel(90, 90)
    local xSeparator, ySeparator = UI.ConvertToPixel(22, 85)
    local _, ySeparatorLine = UI.ConvertToPixel(22, 22)
    max = 15

    if INVENTORY.PlayerProx == nil then
        INVENTORY.PlayerProx = {}
        INVENTORY.PlayerProx = World.GetPlayersServerIdsInZoneForMug(3.0)
    end
    
    if #INVENTORY.PlayerProx > 15 then
        max = #INVENTORY.PlayerProx
    end
    max = max + INVENTORY.DiffNextMultiple(max)

    for i = 1, max do
        if i >= INVENTORY.UI.PlayerProx.Min and i <= INVENTORY.UI.PlayerProx.Max then
            if i - INVENTORY.UI.PlayerProx.Min < 5 then     
                if INVENTORY.PlayerProx[i] then
                        
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.PlayerProx.Min)),(baseY+ ySeparator), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
                        NoHover = false
                    }, function(s, onHovered)
                        if onHovered then
                            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then
                                    if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                        local data = INVENTORY.UI.Player.ItemGrabData
                                        -- if data.name ~= "money" and INVENTORY.UI.Player.ItemGrabData.name ~= "dirtymoney" then
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                            CreateThread(function()
                                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                                    if INVENTORY.UI.InteractItem.Confirm  then
                                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                                            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(INVENTORY.PlayerProx[i].id)))) <= 5 then 
                                                                ExecuteCommand("me donne x"..tonumber(INVENTORY.UI.InteractItem.CountInput).." "..INVENTORY.UI.InteractItem.Data.label)
                                                                TriggerServerEvent("inventaire:server:giveItem", INVENTORY.PlayerProx[i].id, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                                                INVENTORY.UI.InteractItem.Confirm = false
                                                                INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                                                break
                                                            end
                                                        else
                                                            break
                                                        end
                                                    end
                                                    Wait(100)
                                                end
                                            end)
                                            INVENTORY.UI.InteractItem.Maintain = false
                                        -- end
                                    end
                                end
                            end
                        end
                    end)
                    UI.DrawTexts(baseX + (w/2 + 0.005) + ((w + xSeparator) * (i - INVENTORY.UI.PlayerProx.Min)),(baseY+ (h/2 - 0.014) + ySeparator), tostring(INVENTORY.PlayerProx[i].id), true, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)
                else
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.PlayerProx.Min)),(baseY+ ySeparator), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                    end)
                end
            elseif i - INVENTORY.UI.PlayerProx.Min >= 5  and i - INVENTORY.UI.PlayerProx.Min < 10 then
                if INVENTORY.PlayerProx[i] then     
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.PlayerProx.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
                        NoHover = false
                    },  function(s, onHovered)
                        if onHovered then
                            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then
                                    if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                        local data = INVENTORY.UI.Player.ItemGrabData
                                        -- if data.name ~= "money" and INVENTORY.UI.Player.ItemGrabData.name ~= "dirtymoney" then
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                            CreateThread(function()
                                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                                    if INVENTORY.UI.InteractItem.Confirm  then
                                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                                            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(INVENTORY.PlayerProx[i].id)))) <= 5 then 
                                                                ExecuteCommand("me donne x"..tonumber(INVENTORY.UI.InteractItem.CountInput).." "..INVENTORY.UI.InteractItem.Data.label)
                                                                TriggerServerEvent("inventaire:server:giveItem", INVENTORY.PlayerProx[i].id, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                                                INVENTORY.UI.InteractItem.Confirm = false
                                                                INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                                                break
                                                            end
                                                        else
                                                            break 
                                                        end
                                                    end
                                                    Wait(100)
                                                end
                                            end)
                                            INVENTORY.UI.InteractItem.Maintain = false
                                        -- end
                                    end
                                end
                            end
                        end
                    end)          
                    UI.DrawTexts(baseX + (w/2 + 0.005) + ((w + xSeparator) * (i - INVENTORY.UI.PlayerProx.Min + 5)),(baseY+ (h/2 - 0.014) + ySeparator), tostring(INVENTORY.PlayerProx[i].id), true, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)

                else
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.PlayerProx.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                    end)
                end
            else
                if INVENTORY.PlayerProx[i] then
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.PlayerProx.Min + 10))), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
                        NoHover = false
                    }, function(s, onHovered)
                        if onHovered then
                            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then
                                    if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                                        local data = INVENTORY.UI.Player.ItemGrabData
                                        -- if data.name ~= "money" and INVENTORY.UI.Player.ItemGrabData.name ~= "dirtymoney" then
                                            INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                            INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                            CreateThread(function()
                                                while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                                    if INVENTORY.UI.InteractItem.Confirm  then
                                                        if INVENTORY.UI.InteractItem.CountInput > 0 then 

                                                            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(INVENTORY.PlayerProx[i].id)))) <= 5 then 
                                                                ExecuteCommand("me donne x"..tonumber(INVENTORY.UI.InteractItem.CountInput).." "..INVENTORY.UI.InteractItem.Data.label)
                                                                TriggerServerEvent("inventaire:server:giveItem", INVENTORY.PlayerProx[i].id, data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), data.metadatas)
                                                                INVENTORY.UI.InteractItem.Confirm = false
                                                                INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                                                break
                                                            end
                                                        else
                                                            break 
                                                        end
                                                    end
                                                    Wait(100)
                                                end
                                            end)
                                            INVENTORY.UI.InteractItem.Maintain = false
                                        -- end
                                    end
                                end
                            end
                        end
                    end)
                    UI.DrawTexts(baseX + (w/2 + 0.005) + ((w + xSeparator) * (i - INVENTORY.UI.PlayerProx.Min + 10)),(baseY+ (h/2 - 0.014) + ySeparator), tostring(INVENTORY.PlayerProx[i].id), true, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)

                else
                    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.PlayerProx.Min + 10))), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {}, function()
                    end)
                end
            end
        end
    end

  ---SCROLL BAR 
    w, h = UI.ConvertToPixel(4, 314)
    UI.DrawCrossBar("ui_ground_icon", baseX + 0.295, baseY + h/3.65, w, h, { 255, 255, 255, math.floor(INVENTORY.UI.Player.AlphaCrossBar) }, { 255, 106, 0, math.floor(INVENTORY.UI.Player.Alpha) } , max, 15, --[numberafficher]
        INVENTORY.UI.PlayerProx.Page ,
        {
            devmod = false,
            noHover = false,
            direction = 3
        }, function(valueUpdated, newValue, valueY)
            if valueUpdated then
                INVENTORY.UI.PlayerProx.Page = math.floor(valueY)
                if math.floor((INVENTORY.UI.PlayerProx.Page * 15) + 1) < 1 then
                    INVENTORY.UI.PlayerProx.Max = 15
                    INVENTORY.UI.PlayerProx.Min = 1
                elseif math.floor((INVENTORY.UI.PlayerProx.Page * 15) + 15) > max then
                    INVENTORY.UI.PlayerProx.Max =  max
                    INVENTORY.UI.PlayerProx.Min =  INVENTORY.UI.PlayerProx.Max  - 9
                else
                INVENTORY.UI.PlayerProx.Max = math.floor((INVENTORY.UI.PlayerProx.Page * 15)) + 15
                    INVENTORY.UI.PlayerProx.Min = INVENTORY.UI.PlayerProx.Max - 9
                end
            end
    end)
end
local isBackspaceHeld = false
local backspaceHeldTime = 0
local repeatThreshold = 0.5
local repeatRate = 0.1

function INVENTORY.UI.PlayerProx.HandleBackspaceInput()
    if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
        INVENTORY.UI.PlayerProx.RemoveLastCharacter()
        isBackspaceHeld = true
        backspaceHeldTime = GetGameTimer()
    elseif (IsDisabledControlPressed(0, 194) or IsControlPressed(0, 194)) and isBackspaceHeld then
        if (GetGameTimer() - backspaceHeldTime) > (repeatThreshold * 1000) then
            if (GetGameTimer() - backspaceHeldTime) % (repeatRate * 1000) < 50 then
                INVENTORY.UI.PlayerProx.RemoveLastCharacter()
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

function INVENTORY.UI.PlayerProx.DrawPinItem(baseX, baseY, i)

    UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - 1)), baseY + ySeparator, w, h , 0, 255, 255, 255, INVENTORY.UI.Player.Alpha, {
        NoHover = false
    }, function(onSelected, onHovered)
        if onHovered then
            if IsControlPressed(0, 25) or IsDisabledControlPressed(0, 25) then
                INVENTORY.UI.PlayerProx.PinItem[i] = nil
                INVENTORY.UI.PlayerProx.ItemGrabIndex = 0
            end
            if not IsDisabledControlPressed(0, 24) and INVENTORY.UI.PlayerProx.ItemGrabIndex ~= 0 then
                INVENTORY.UI.PlayerProx.PinItem[i] = INVENTORY.PlayerProx[INVENTORY.UI.PlayerProx.ItemGrabIndex]
                INVENTORY.UI.PlayerProx.ItemGrabIndex = 0
            end
        end
    end)

    UI.DrawTexts(baseX + 0.005 + ((w + xSeparator) * (i - 1)) + 0.002, baseY + ySeparator, tostring(i), false, 0.2, {255, 106, 0, math.floor(INVENTORY.UI.Player.Alpha)}, 0, false, false)

    --
    if INVENTORY.UI.PlayerProx.PinItem[i] ~= nil  then

        local data = INVENTORY.UI.PlayerProx.PinItem[i]
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

function INVENTORY.UI.PlayerProx.Scroll(baseX, baseY)
    local wRect, hRect = UI.ConvertToPixel(568, 415)
    UI.DrawRect(baseX, baseY, wRect, hRect, 0, 255, 255, 255, 0, {}, function (s, h)
        if h then
            if IsDisabledControlPressed(0, 180) or IsControlPressed(0, 180) then
                if INVENTORY.UI.PlayerProx.Max < max then
                    INVENTORY.UI.PlayerProx.Min = INVENTORY.UI.PlayerProx.Min + 5
                    INVENTORY.UI.PlayerProx.Max = INVENTORY.UI.PlayerProx.Max + 5
                    INVENTORY.UI.PlayerProx.Page = INVENTORY.UI.PlayerProx.Page + 1
                    if INVENTORY.UI.PlayerProx.Max > max then
                        INVENTORY.UI.PlayerProx.Min = max - 9
                        INVENTORY.UI.PlayerProx.Max = max
                        INVENTORY.UI.PlayerProx.Page = (max/10) - 1
                    end
                end
            end
            if IsDisabledControlPressed(0, 115) or IsControlPressed(0, 115) then
                if INVENTORY.UI.PlayerProx.Min > 1 then
                    INVENTORY.UI.PlayerProx.Min = INVENTORY.UI.PlayerProx.Min - 5

                    INVENTORY.UI.PlayerProx.Max = INVENTORY.UI.PlayerProx.Max - 5

                    INVENTORY.UI.PlayerProx.Page = INVENTORY.UI.PlayerProx.Page - 1
                    if INVENTORY.UI.PlayerProx.Min < 1 then
                        INVENTORY.UI.PlayerProx.Min = 1
                        INVENTORY.UI.PlayerProx.Max = 10
                        INVENTORY.UI.PlayerProx.Page = 0
                    end
                end
            end
        end
    end)
end


local w, h = UI.ConvertToPixel(231, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.PlayerProx.RemoveLastCharacter()
    if string.len(INVENTORY.UI.PlayerProx.FullText) > 0 then
        INVENTORY.UI.PlayerProx.FullText = string.sub(INVENTORY.UI.PlayerProx.FullText, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.PlayerProx.FullText, 0, 0.25)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.PlayerProx.FullText) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.PlayerProx.FullText, startIdx), 0, 0.25)
            end
            INVENTORY.UI.PlayerProx.Filter = string.sub(INVENTORY.UI.PlayerProx.FullText, startIdx)
        else
            INVENTORY.UI.PlayerProx.Filter = INVENTORY.UI.PlayerProx.FullText
        end
        if INVENTORY.UI.PlayerProx.FilterSelected == 1 then
            INVENTORY.UI.PlayerProx.FilterData = {}
            for key, value in pairs(INVENTORY.PlayerProx) do
                if string.sub(value.label, 1, string.len(INVENTORY.UI.PlayerProx.FullText)) == INVENTORY.UI.PlayerProx.FullText then
                    table.insert(INVENTORY.UI.PlayerProx.FilterData, value)
                end
            end
        else
            INVENTORY.UI.PlayerProx.FilterData = {}
            for key, value in pairs(INVENTORY.PlayerProx) do
                if string.sub(value.label, 1, string.len(INVENTORY.UI.PlayerProx.FullText)) == INVENTORY.UI.PlayerProx.FullText then
                    table.insert(INVENTORY.UI.PlayerProx.FilterData, value)
                end
            end
        end
    end
end

RegisterNetEvent("inventory:client:removePin", function (index)
    INVENTORY.UI.PlayerProx.PinItem[index] = nil
end)