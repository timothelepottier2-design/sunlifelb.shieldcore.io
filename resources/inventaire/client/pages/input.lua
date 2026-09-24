INVENTORY.UI.Input = {}
INVENTORY.UI.Input.NeedConfirmCount = false
INVENTORY.UI.Input.InputActive = false
INVENTORY.UI.Input.Filter = "ID du joueur"
INVENTORY.UI.Input.FullText = ""
INVENTORY.UI.Input.Number = false
local canPress = false
function INVENTORY.UI.InputDraw()
    SetScriptGfxDrawOrder(8)
    local w, h = UI.ConvertToPixel(583, 40)

    local baseX, baseY = 0.5 - w/2, 0.5- h/2
    
    local letter = nil
    if INVENTORY.UI.Input.InputActive and UI.GetActiveInput() then
        letter = UI.ReturnLetter()
    end

    if INVENTORY.UI.Input.InputActive and json.encode(letter) == json.encode("\r") then
        UI.DeactivateDetectInput()
        INVENTORY.UI.Input.InputActive = false
        letter = nil
    end
    -- if INVENTORY.UI.Input.InputActive and letter ~= nil then
    --     if INVENTORY.UI.Input.Filter == "Id du joueur" or INVENTORY.UI.Input.Filter == "Nouveau nom de l'item"  then
    --         INVENTORY.UI.Input.Filter = letter
    --     else
    --         INVENTORY.UI.Input.Filter = INVENTORY.UI.Input.Filter ..letter
    --     end
    -- end
    local can = true
    if INVENTORY.UI.Input.Number then
        if not tonumber(letter) then
            can = false
        end
    end
    if INVENTORY.UI.Input.InputActive and letter ~= nil then
        if letter == "\b" then
            -- Deja traite par HandleBackspaceInput (touche 194) plus bas : le
            -- traiter ici aussi effacait deux caracteres par appui.
        elseif can then
            if INVENTORY.UI.Input.Filter == "ID du joueur" or INVENTORY.UI.Input.Filter == "Nouveau nom de l'item"  then
                INVENTORY.UI.Input.Filter = ""
                INVENTORY.UI.Input.FullText = letter
                local displayedTextWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Input.Filter, 0, 0.30)
                if displayedTextWidth <= (w  - 0.025) then
                    INVENTORY.UI.Input.Filter = INVENTORY.UI.Input.Filter .. letter
                else
                    local startIdx = 1
                    while INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Input.FullText, startIdx), 0, 0.30) > (w  - 0.025) and startIdx <= #INVENTORY.UI.Input.FullText do
                        startIdx = startIdx + 1
                    end
                    INVENTORY.UI.Input.Filter = string.sub(INVENTORY.UI.Input.FullText, startIdx)
                end
            else
                INVENTORY.UI.Input.FullText = INVENTORY.UI.Input.FullText .. letter

                local displayedTextWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Input.Filter, 0, 0.30)
                if displayedTextWidth <= (w  - 0.025) then
                    INVENTORY.UI.Input.Filter = INVENTORY.UI.Input.Filter .. letter
                else
                    local startIdx = 1
                    while INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Input.FullText, startIdx), 0, 0.30) > (w  - 0.025) and startIdx <= #INVENTORY.UI.Input.FullText do
                        startIdx = startIdx + 1
                    end
                    INVENTORY.UI.Input.Filter = string.sub(INVENTORY.UI.Input.FullText, startIdx)
                end
            end
        end
    end
    UI.DrawSpriteNew("inventory", "input_background", baseX , baseY, w, h , 0, 255, 255, 255, INVENTORY.UI.Other.Alpha, {
        NoHover = false,
        NoSelect = false,
    }, function(onSelected, onHovered)
        if onHovered then
        end
        if onSelected then
            -- if not UI.GetActiveInput() then
            --     INVENTORY.UI.Other.FullText = ""
            --     INVENTORY.UI.Other.Filter = ""
            --     INVENTORY.UI.Other.InputActive = true
            --     INVENTORY.UI.Input.InputActive = false
            --     INVENTORY.UI.Ground.InputActive = false
            --     UI.ActivateDetectInput()
            --     CreateThread(function ()
            --         Wait(500)
            --         canPress = true
            --     end)
            -- end
        end
    end)
    UI.DrawTexts(baseX + 0.01, baseY + 0.007, INVENTORY.UI.Input.Filter, false, 0.30, {255, 255, 255, math.floor(INVENTORY.UI.Player.AlphaFilter)}, UI.font["robmed"], false, false, false)
    -- Ne pas écraser FullText par le placeholder : garder le texte saisi pour Renommer / ID joueur
    if INVENTORY.UI.Input.Filter == "Nouveau nom de l'item" or INVENTORY.UI.Input.Filter == "ID du joueur" then
        INVENTORY.UI.Input.FullText = INVENTORY.UI.Input.Filter
    else
        INVENTORY.UI.Input.FullText = INVENTORY.UI.Input.Filter or ""
    end
    INVENTORY.UI.Input.HandleBackspaceInput()
    SetScriptGfxDrawOrder(7)
end

local isBackspaceHeld = false
local backspaceHeldTime = 0
local repeatThreshold = 0.5
local repeatRate = 0.1

function INVENTORY.UI.Input.HandleBackspaceInput()
    if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
        INVENTORY.UI.Input.RemoveLastCharacter()
        isBackspaceHeld = true
        backspaceHeldTime = GetGameTimer()
    elseif (IsDisabledControlPressed(0, 194) or IsControlPressed(0, 194)) and isBackspaceHeld then
        if (GetGameTimer() - backspaceHeldTime) > (repeatThreshold * 1000) then
            if (GetGameTimer() - backspaceHeldTime) % (repeatRate * 1000) < 50 then
                INVENTORY.UI.Input.RemoveLastCharacter()
            end
        end
    else
        isBackspaceHeld = false
        backspaceHeldTime = 0
    end
end

local w, h = UI.ConvertToPixel(583, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.Input.RemoveLastCharacter()
    if string.len(INVENTORY.UI.Input.FullText) > 0 then
        INVENTORY.UI.Input.FullText = string.sub(INVENTORY.UI.Input.FullText, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.Input.FullText, 0, 0.30)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.Input.FullText) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.Input.FullText, startIdx), 0, 0.30)
            end
            INVENTORY.UI.Input.Filter = string.sub(INVENTORY.UI.Input.FullText, startIdx)
        else
            INVENTORY.UI.Input.Filter = INVENTORY.UI.Input.FullText
        end
    end
end


