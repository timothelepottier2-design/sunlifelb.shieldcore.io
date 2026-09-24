INVENTORY.UI.Ground = {}
INVENTORY.UI.Ground.Alpha = 0
INVENTORY.UI.Ground.AlphaFilter = 0
INVENTORY.UI.Ground.AlphaCrossBar = 0
INVENTORY.UI.Ground.BaseX, INVENTORY.UI.Ground.BaseY = 0.5, 0.5
INVENTORY.UI.Ground.Filter = "Rechercher"
INVENTORY.UI.Ground.PinItem = {}
INVENTORY.UI.Ground.InputActive = false
INVENTORY.UI.Ground.Min = 1
INVENTORY.UI.Ground.Max = 15
INVENTORY.UI.Ground.Index = 0
INVENTORY.UI.Ground.Page = 0
INVENTORY.UI.Ground.FilterSelected = 1
INVENTORY.UI.Ground.ItemGrabIndex = 0
INVENTORY.UI.Ground.FilterData = {}
INVENTORY.UI.Ground.ItemGrabData = {}
INVENTORY.UI.Ground.CurrentWeight = "0.0"
local max = 10
local canPress = false
local xSeparator, ySeparator = UI.ConvertToPixel(22, 85)
local _, ySeparatorLine = UI.ConvertToPixel(22, 22)
local ziziX, ziziY = UI.ConvertToPixel(540, 314)
local wSlide, hSlide =  UI.ConvertToPixel(4, 314)
function INVENTORY.UI.Ground.Draw()
    local baseX, baseY = INVENTORY.Pos.ground.x, INVENTORY.Pos.ground.y
    if #DROP.Near > 0 then
        INVENTORY.UI.Ground.Scroll(baseX, baseY)
    end
    --Icon
    local sizeX, sizeY = UI.CalculateCorrecteSizeForUI("ui_ground_icon", "inventory", "ground", 70, 70)
    UI.DrawSpriteNew("inventory", "ground", baseX, baseY, sizeX, sizeY, 0, 255, 106, 0, INVENTORY.UI.Ground.Alpha, {}, function ()

    end)

    UI.DrawTexts(baseX + 0.03, baseY, "Proximité", false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Ground.Alpha)}, UI.font["robmed"], false, false, false)
    -- UI.DrawTexts(baseX + 0.03, baseY + 0.03, "".."10.0".."kg/".."ESX.PlayerData.maxWeight".."kg", false, 0.3, {255, 255, 255, 255}, UI.font["robmed"], false, false, false)
    local w, h = UI.ConvertToPixel(33, 15)
    UI.DrawSpriteNew("inventory", "inifinity", baseX + 0.03, baseY + 0.03, w, h, 0, 255, 255, 255, INVENTORY.UI.Ground.Alpha, {}, function ()

    end)

    local x, y = UI.ConvertToPixel(581, 431)
    UI.DrawRect( baseX, baseY + h - 0.05 , x, y, 0, 255, 255, 255,0, {}, function (s, h)
        if h then
            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then
                    if INVENTORY.UI.Player.FilterSelected ~= 1 then 
                        INVENTORY.UI.Player.ItemGrabIndex = INVENTORY.UI.Player.ItemGrabIndex
                    end
                    if IsPedInAnyVehicle(PlayerPedId(), false) or IsPedInAnyVehicle(PlayerPedId(), true) then
                    else
                        if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                            local data = INVENTORY.UI.Player.ItemGrabData
                            -- if data.name ~= "money" and INVENTORY.UI.Player.ItemGrabData.name ~= "dirtymoney" then
                                INVENTORY.UI.InteractItem.NeedConfirmCount = true
                                INVENTORY.UI.InteractItem.Data = INVENTORY.UI.Player.ItemGrabData
                                CreateThread(function()
                                    while INVENTORY.UI.InteractItem.NeedConfirmCount do
                                            if INVENTORY.UI.InteractItem.Confirm  then
                                                if INVENTORY.UI.InteractItem.CountInput > 0 then 
                                                    ExecuteCommand("e c")
                                                    Citizen.Wait(100)
                                                    ExecuteCommand("e pickup")
                                                    ExecuteCommand("me pose x"..tonumber(INVENTORY.UI.InteractItem.CountInput).." "..INVENTORY.UI.InteractItem.Data.label)
                                                    TriggerServerEvent("inventory:server:dropItem", INVENTORY.UI.InteractItem.Data.name, tonumber(INVENTORY.UI.InteractItem.CountInput), INVENTORY.UI.InteractItem.Data.metadatas)
                                                    INVENTORY.UI.InteractItem.Confirm = false
                                                    INVENTORY.UI.InteractItem.NeedConfirmCount = false
                                                end
                                                break
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
        end
    end)

    --List Icon Biatch

    max = 200
    INVENTORY.Ground = {}
    if #DROP.Near == 0 then
        UI.DrawSpriteNew("inventory", "fake", baseX + 0.005,(baseY+ ySeparator), ziziX, ziziY , 0, 255, 255, 255, INVENTORY.UI.Ground.Alpha, {}, function()
        end)    
    else
        w, h = UI.ConvertToPixel(90, 90)

        for key, value in pairs(DROP.Near) do
            -- body
            value.index = key
            table.insert(INVENTORY.Ground, value)
        end
        
        if #INVENTORY.Ground > 15 then
            max = #INVENTORY.Ground
        end
        max = max + INVENTORY.DiffNextMultiple(max)

        for i = 1, max do
            if i >= INVENTORY.UI.Ground.Min and i <= INVENTORY.UI.Ground.Max then
                if i - INVENTORY.UI.Ground.Min < 5 then     
                    if INVENTORY.Ground[i] then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Ground.Min )), (baseY+ ySeparator), i, INVENTORY.Ground[i], "ground")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - INVENTORY.UI.Ground.Min)),(baseY+ ySeparator), w, h , 0, 255, 255, 255, INVENTORY.UI.Ground.Alpha, {}, function()
                        end)
                    end
                elseif i - INVENTORY.UI.Ground.Min >= 5  and i - INVENTORY.UI.Ground.Min < 10 then
                    if INVENTORY.Ground[i] then     
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Ground.Min + 5) )), (baseY+ ySeparator) + (h + ySeparatorLine) , i, INVENTORY.Ground[i], "ground")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Ground.Min + 5))),(baseY+ ySeparator) + (h + ySeparatorLine), w, h , 0, 255, 255, 255, INVENTORY.UI.Ground.Alpha, {}, function()
                        end)
                    end
                else
                    if INVENTORY.Ground[i] then
                        INVENTORY.UI.DrawItem(baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Ground.Min + 10))),(baseY+ ySeparator) + (h + ySeparatorLine) * 2, i, INVENTORY.Ground[i], "ground")
                    else
                        UI.DrawSpriteNew("inventory", "background_item", baseX + 0.005 + ((w + xSeparator) * (i - (INVENTORY.UI.Ground.Min + 10))), (baseY+ ySeparator) + (h + ySeparatorLine) * 2, w, h , 0, 255, 255, 255, INVENTORY.UI.Ground.Alpha, {}, function()
                        end)
                    end
                end
            end
        end
    end

  ---SCROLL BAR 
    UI.DrawCrossBar("ui_ground_icon", baseX + 0.295, baseY + hSlide/3.65, wSlide, hSlide, { 255, 255, 255, math.floor(INVENTORY.UI.Ground.AlphaCrossBar) }, { 255, 106, 0, math.floor(INVENTORY.UI.Ground.Alpha) } , max, 15, --[numberafficher]
        INVENTORY.UI.Ground.Page ,
        {
            devmod = false,
            noHover = false,
            direction = 3
        }, function(valueUpdated, newValue, valueY)
            if valueUpdated then
                INVENTORY.UI.Ground.Page = math.floor(valueY)
                if math.floor((INVENTORY.UI.Ground.Page * 15) + 1) < 1 then
                    INVENTORY.UI.Ground.Max = 15
                    INVENTORY.UI.Ground.Min = 1
                elseif math.floor((INVENTORY.UI.Ground.Page * 15) + 15) > max then
                    INVENTORY.UI.Ground.Max =  max
                    INVENTORY.UI.Ground.Min =  INVENTORY.UI.Ground.Max  - 9
                else
                INVENTORY.UI.Ground.Max = math.floor((INVENTORY.UI.Ground.Page * 15)) + 15
                    INVENTORY.UI.Ground.Min = INVENTORY.UI.Ground.Max - 9
                end
            end
    end)
end

function INVENTORY.UI.Ground.Scroll(baseX, baseY)
    local wRect, hRect = UI.ConvertToPixel(568, 415)
    UI.DrawRect(baseX, baseY, wRect, hRect, 0, 255, 255, 255, 0, {}, function (s, h)
        if h then
            if IsDisabledControlPressed(0, 180) or IsControlPressed(0, 180) then
                if INVENTORY.UI.Ground.Max < max then
                    INVENTORY.UI.Ground.Min = INVENTORY.UI.Ground.Min + 5
                    INVENTORY.UI.Ground.Max = INVENTORY.UI.Ground.Max + 5
                    INVENTORY.UI.Ground.Page = INVENTORY.UI.Ground.Page + 1
                    if INVENTORY.UI.Ground.Max > max then
                        INVENTORY.UI.Ground.Min = max - 9
                        INVENTORY.UI.Ground.Max = max
                        INVENTORY.UI.Ground.Page = (max/10) - 1
                    end
                end
            end
            if IsDisabledControlPressed(0, 115) or IsControlPressed(0, 115) then
                if INVENTORY.UI.Ground.Min > 1 then
                    INVENTORY.UI.Ground.Min = INVENTORY.UI.Ground.Min - 5

                    INVENTORY.UI.Ground.Max = INVENTORY.UI.Ground.Max - 5

                    INVENTORY.UI.Ground.Page = INVENTORY.UI.Ground.Page - 1
                    if INVENTORY.UI.Ground.Min < 1 then
                        INVENTORY.UI.Ground.Min = 1
                        INVENTORY.UI.Ground.Max = 10
                        INVENTORY.UI.Ground.Page = 0
                    end
                end
            end
        end
    end)
end


local w, h = UI.ConvertToPixel(231, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.Ground.RemoveLastCharacter()
    if string.len(INVENTORY.UI.Ground.FullText) > 0 then
        INVENTORY.UI.Ground.FullText = string.sub(INVENTORY.UI.Ground.FullText, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Ground.FullText, 0, 0.25)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.Ground.FullText) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Ground.FullText, startIdx), 0, 0.25)
            end
            INVENTORY.UI.Ground.Filter = string.sub(INVENTORY.UI.Ground.FullText, startIdx)
        else
            INVENTORY.UI.Ground.Filter = INVENTORY.UI.Ground.FullText
        end
        if INVENTORY.UI.Ground.FilterSelected == 1 then
            INVENTORY.UI.Ground.FilterData = {}
            for key, value in pairs(INVENTORY.Ground) do
                if string.sub(value.label, 1, string.len(INVENTORY.UI.Ground.FullText)) == INVENTORY.UI.Ground.FullText then
                    table.insert(INVENTORY.UI.Ground.FilterData, value)
                end
            end
        else
            INVENTORY.UI.Ground.FilterData = {}
            for key, value in pairs(INVENTORY.Ground) do
                if string.sub(value.label, 1, string.len(INVENTORY.UI.Ground.FullText)) == INVENTORY.UI.Ground.FullText then
                    table.insert(INVENTORY.UI.Ground.FilterData, value)
                end
            end
        end
    end
end

RegisterNetEvent("inventory:client:removePin", function (index)
    INVENTORY.UI.Ground.PinItem[index] = nil
end)
