-- Some parts here are pretty ugly, i know. Will to a refractor to this lib someday.
UI = {}
UI.cooldown = false
UI.font = {}
UI.AnimatedFrames = {}
UI.Input = false
UI.InputLastLetter = nil
UI.InputPressed = false
UI.InputPressedTable = {}
UI.pages = {
    ["u_inventory"] = {
        label = "u_inventory",
        active = false,
        lockControls = true,
        showCursor = true,
        drawFunction = function()
            INVENTORY.UI.Main.Draw()
        end,
    },
}
UI.lockedControls = {
    {}
}
UI.fontToLoad = {
    {"robmed", "Roboto-Medium"},
    {"robbold", "robbold"},
}


local DrawSprite = DrawSprite
local DrawRect = DrawRect

function UI.IsAnySubMenuActive()
    for k,v in pairs(UI.pages) do
        if v.active then
            return true
        end
    end
    return false
end

function UI.GetControl()
    local x, y = 0, 0
    local resX, resY = GetActiveScreenResolution()
    if GetPauseMenuState() ~= 0 then
        EnableAllControlActions(0)
        x, y =  GetNuiCursorPosition()
        x = x/resX
        y = y/resY
    else
        x = GetControlNormal(0, 239)
        y = GetControlNormal(0, 240)
    end
    return vector2(x, y)
end

function UI.IsActive(page)
    if UI.pages[page] then
        return UI.pages[page].active
    end
end

function UI.SetPageActive(page)
    if UI.pages[page] then
        UI.pages[page].active = true
    end
end

function UI.SetPageInactive(page)
    if UI.pages[page] then
        UI.pages[page].active = false
    end
end

function UI.EnableControlsForPage(page)
    if UI.pages[page] then
        UI.pages[page].showCursor = true
        UI.pages[page].lockControls = true
    end
end

function UI.DisableControlsForPage(page)
    if UI.pages[page] then
        UI.pages[page].showCursor = false
        UI.pages[page].lockControls = false
    end
end

function UI.GetPageStatus(page)
    if UI.pages[page] then
        return UI.pages[page].active
    end
    return false
end

function UI.SetFullscreenLoaderActive(status)
    if status then
        SendNUIMessage({
            type    = 'toggleLoaderOn',
        })
    else
        SendNUIMessage({
            type    = 'toggleLoaderOff',
        })
    end
end

function UI.ForceStopIntro()
    SendNUIMessage({
        type    = 'stopIntro',
    })
end




-- Duplicate, need to be removed
function UI.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end

function UI.ConvertToPixel(x, y)
    return (x / 1920), (y / 1080)
end

function UI.ConvertToRes(x, y)
    return (x * 1920), (y * 1080)
end

function UI.LoadStreamDict(dict)
    -- if HasStreamedTextureDictLoaded(dict) then
    --     SetStreamedTextureDictAsNoLongerNeeded(dict)
    --     while HasStreamedTextureDictLoaded(dict) do
    --         SetStreamedTextureDictAsNoLongerNeeded(dict)
    --         print("Waiting unload before load for", dict)
    --         Wait(1)
    --     end
    -- end
    while not HasStreamedTextureDictLoaded(dict) do
        RequestStreamedTextureDict(dict, 1)
        print("Loading dict ", dict)
        Wait(100)
    end
    print("Dict loaded! ", dict)
end

function UI.LoadFont(font)
    RegisterFontFile(font[1]) -- the name of your .gfx, without .gfx
    local fontId = RegisterFontId(font[2]) -- the name from the .xml
    UI.font[font[2]] = fontId
end
local w, h = UI.ConvertToPixel(9 , 9)
function UI.DrawSlider(name, screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if UI.InputPressedTable[name] == nil then
        UI.InputPressedTable[name] = false
    end
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    if value > max then
        value = max
    end

    if value < 0 then
        value = 0
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])

    local progressWidth = (value/max) * width
    local progressHeight = height

    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value/max) * height
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value/max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3], progressColor[4])

    local test = vector2(progressWidth, height) / 2.0
    UI.DrawSpriteNew("inventory", "point", pos[1] + test[1], pos[2] + 0.0005, ((height + h) * 1080) /1920, height + h, 0, progressColor[1], progressColor[2], progressColor[3], progressColor[4], {
        centerDraw = true
    } , function ()
        
    end)
    if settings.noHover == false then
        if UI.isMouseOnButton({x = UI.GetControl().x , y = UI.GetControl().y}, {x = screenX, y = screenY}, width, height) or UI.InputPressedTable[name] then
            SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) then
                UI.InputPressedTable[name] = true
                UI.InputPressed = true
                local mouse = UI.GetControl().x
                local size = ((mouse - screenX) * max) / width
                newValue = size

                --print(newValue)
                valueUpdated = true
            else
                UI.InputPressedTable[name] = false
                UI.InputPressed = false
            end
        else
            SetMouseCursorSprite(1)
        end
    end

    if newValue > max then
        newValue = max
    end

    if newValue < 0 then
        newValue = 0
    end

    cb(valueUpdated, newValue)
end



UI.HoveredCache = {}

function UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
    local uniqueID = textureDict .. textureName .. screenX .. screenY
    if UI.HoveredCache[uniqueID] == nil then
        UI.HoveredCache[uniqueID] = false
        return false, uniqueID
    else
        return UI.HoveredCache[uniqueID], uniqueID
    end
end

function UI.SetHoveredStatus(uniqueID, status)
    if UI.HoveredCache[uniqueID] ~= nil then
        UI.HoveredCache[uniqueID] = status
    end
end

function UI.DrawProgressBar(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width + 0.005, height + 00.005, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height

    if settings.direction == 1 then     -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3],
        progressColor[4])

    if settings.noHover == false then
        if UI.isMouseOnButton({ x = UI.GetControl().x, y = UI.GetControl().y },
                { x = screenX, y = screenY }, width, height) then
            SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) then
                local mouse = UI.GetControl().x
                local size = ((mouse - screenX) * max) / width
                newValue = size

                --print(newValue)
                valueUpdated = true
            end
        else
            SetMouseCursorSprite(1)
        end
    end

    cb(valueUpdated, newValue)
end

function UI.DrawSpriteNew(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false
    local pos
    if alpha <= 0 and not settings.drawEvenIfAlpha0 ~= nil and settings.drawEvenIfAlpha0 == false then
        return
    else
        alpha = math.floor(alpha)
    end

    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, true)
    else

        if settings.devmod ~= nil and settings.devmod == true then
            local x = UI.GetControl().x
            local y = UI.GetControl().y

            screenX = x
            screenY = y

            if IsControlJustReleased(0, 38) then
                TriggerEvent("addToCopy", x..", "..y)
            end
        end


        if settings.centerDraw ~= nil and settings.centerDraw == true then
            pos = vector2(screenX, screenY)
        else
            pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
        end

        -- if Sheets.IsSpriteAnimated(textureDict, textureName) then
        --     textureName = textureName..Sheets.GetActualFrame(textureDict, textureName)
        -- end

        if settings.Draw3d ~= nil then
            SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
            pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
        end

        if settings.NoHover ~= nil and settings.NoHover == true then
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        else
            if settings.Draw3d ~= nil then
                _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
            end
            if UI.isMouseOnButton({x = UI.GetControl().x , y = UI.GetControl().y}, {x = screenX, y = screenY}, width, height) then
                onHovered = true
                local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
                if not aleadyHovered then
                    UI.SetHoveredStatus(spriteUniqueId, true)
                    if settings.sounds ~= nil and settings.sounds.hover ~= nil then
                        PlaySoundFrontend(-1, settings.sounds.hover[1], settings.sounds.hover[2], 1)
                    end
                end
                if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                    if settings.CustomHoverTexture[3] ~= nil and settings.CustomHoverTexture[4] ~= nil then
                        local x,y = UI.ConvertToPixel(settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                        width = x
                        height = y
                    end
                    if settings.CustomHoverTexture[5] ~= nil then
                        DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height, heading, settings.CustomHoverTexture[5][1], settings.CustomHoverTexture[5][2], settings.CustomHoverTexture[5][3], alpha)

                    else
                        DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
                    end
                else
                    DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
                end
            else
                onHovered = false
                local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
                if aleadyHovered then
                    UI.SetHoveredStatus(spriteUniqueId, false)
                end
                DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            end
        end


        if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
            if UI.isMouseOnButton({x = UI.GetControl().x , y = UI.GetControl().y}, {x = screenX, y = screenY}, width, height) then
                SetMouseCursorSprite(4)
                onHovered = true
                if UI.HandleControl() then
                    local audioId
                    CreateThread(function()
                        audioId = GetSoundId()
                        PlaySoundFrontend(audioId, "HUD_FRONTEND_DEFAULT_SOUNDSET", "SELECT")
                        audioId = nil
                    end)
                    onSelected = true
                end
            else
                SetMouseCursorSprite(1)
            end
        end

        if settings.Draw3d ~= nil then
            ClearDrawOrigin()
        end
    end


    cb(onSelected, onHovered, pos)
end


function UI.DrawRect(screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false

    alpha = math.floor(alpha)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y

        screenX = x
        screenY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    local pos
    if settings.centerDraw ~= nil and settings.centerDraw == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end

    -- if Sheets.IsSpriteAnimated(textureDict, textureName) then
    --     textureName = textureName..Sheets.GetActualFrame(textureDict, textureName)
    -- end

    if settings.Draw3d ~= nil then
        SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
        pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
    end

    if settings.NoHover ~= nil and settings.NoHover == true then
        --DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        --print(pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        if alpha >= 0 then
            DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
        end

    else
        if settings.Draw3d ~= nil then
            _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
        end
        if UI.isMouseOnButton({x = UI.GetControl().x , y = UI.GetControl().y}, {x = screenX, y = screenY}, width, height) then
            onHovered = true
            local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered("RECT", "RECT", screenX, screenY)
            if not aleadyHovered then
                UI.SetHoveredStatus(spriteUniqueId, true)
            end
            if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                if alpha >= 0 then
                    DrawRect(pos[1], pos[2], width, height, settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                end
            else
                if alpha >= 0 then
                    DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
                end

            end
        else
            onHovered = false
            local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered("RECT", "RECT", screenX, screenY)
            if aleadyHovered then
                UI.SetHoveredStatus(spriteUniqueId, false)
            end
            if alpha >= 0 then
                DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
            end

        end
    end


    if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
        if UI.isMouseOnButton({x = UI.GetControl().x , y = UI.GetControl().y}, {x = screenX, y = screenY}, width, height) then
            SetMouseCursorSprite(4)
            onHovered = true
            if UI.HandleControl() then
                --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                onSelected = true
            end
        else
            SetMouseCursorSprite(1)
        end
    end

    if settings.Draw3d ~= nil then
        ClearDrawOrigin()
    end

    cb(onSelected, onHovered, pos)
end

-- Position = mouse pos
function UI.isMouseOnButton(position, buttonPos, Width, Heigh)
   -- print(position, buttonPos, Width, Heigh)
    if not UI.InputPressed then 
	    return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + Width and position.y < buttonPos.y + Heigh
    else
        return false
    end
end



function UI.HandleCooldown()
    if not UI.cooldown then
        UI.cooldown = true
        Citizen.CreateThread(function()
            Wait(150)
            UI.cooldown = false
        end)
    end
end

local clickControl = {24, 176, 18, 69, 92, 106, 122, 135, 142, 144, 223, 229, 237, 257, 329, 346}
function UI.HandleControl()
    for k,v in pairs(clickControl) do
        -- if not UI.cooldown then
            if IsControlJustPressed(0, v) or IsDisabledControlJustPressed(0, v) then
                UI.HandleCooldown()
                return true
            end
        -- end
    end
    return false
end


function UI.DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod, shadow)
    if rgb[4] >= 0 then
        if devmod then
            local x2 = UI.GetControl().x
            local y2 = UI.GetControl().y

            x = x2
            y = y2

            if IsControlJustReleased(0, 38) then
                TriggerEvent("addToCopy", x..", "..y)
            end
        end

        if shadow == nil then
            shadow = false
        end

        if rightJustify ~= 0 and rightJustify ~= false then
            SetTextJustification(2)
            SetTextWrap(0.0, x)
        end

        SetTextFont(font)
        SetTextScale(scale, scale)
        if shadow ~= nil and shadow == true then
            SetTextDropshadow(1, 255, 255, 255, 100)
            --SetTextDropShadow()
        end
        SetTextColour(rgb[1], rgb[2], rgb[3], math.floor(rgb[4]))
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x,y)
    end

end

function UI.DrawTextsNoLimitOld(x, y, center, scale, rgb, font, rightJustify, devmod, shadow, entry)
    -- if text == nil then
    --     return
    -- end

    if devmod then
        local x2 = UI.GetControl().x
        local y2 = UI.GetControl().y
        x = x2
        y = y2

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if shadow == nil then
        shadow = false
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)
    if shadow ~= nil and shadow == true then
        SetTextDropshadow(1, 0, 0, 0, 100)
        --SetTextDropShadow()
    end
    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry(entry)
    SetTextCentre(center)
    --AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

local entrys = {}
function UI.DrawTextsNoLimit(x, y, text, center, scale, rgb, font, rightJustify, devmod, shadow, entry)
    if text == nil then
        return
    end
    if entrys[entry] == nil then
        entrys[entry] = text
        AddTextEntry(entry, text)
    else
        if entrys[entry] ~= text then
            entrys[entry] = text
            AddTextEntry(entry, text)
        end
    end
    
    if devmod then
        local x2 = UI.GetControl().x
        local y2 = UI.GetControl().y
        x = x2
        y = y2

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if shadow == nil then
        shadow = false
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)
    if shadow ~= nil and shadow == true then
        SetTextDropshadow(1, 0, 0, 0, 100)
        --SetTextDropShadow()
    end
    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry(entry)
    SetTextCentre(center)
    --AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function UI.Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY, alpha)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*15
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, alpha or 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function UI.Draw3DTextNoDownsize(x,y,z,textInput,fontId,scaleX,scaleY, alpha)
    local dontDrawHowOfScreen = false
    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(x,y,z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetFinalRenderedCamCoord().xy - vector2(x,y))
        local fov = (scaleX / GetGameplayCamFov()) * 100
        local scale = ((scaleX / dist) * 2) * fov
        if scale > 1 then
            scale = 1
        end

        SetDrawOrigin(x,y,z, 0)
        SetTextScale(scaleX * scale, scaleY * scale)
        SetTextFont(fontId)
        SetTextColour(250, 250, 250, alpha or 255)		-- You can change the text color here
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(textInput)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
    return draw

end


-- pos.xyz
-- textureDict
-- textureName
-- x
-- y
-- width
-- height
-- heading
-- r
-- g
-- b
-- a
function UI.DrawSprite3d(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        --print(get, x, y)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = ((1 / dist) * 2) * fov
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            (data.x or 0) * scale,
            (data.y or 0) * scale,
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

function UI.DrawSprite3dNoDownSize(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local scale = 1
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            data.x or (0 * scale),
            data.y or (0 * scale),
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw

end

function UI.CalculateNextScalablePosition(targetPosition, actualPosition, speed)
    if targetPosition > actualPosition then
        local dist = targetPosition - actualPosition
        if dist < 0.0001 then
            return targetPosition
        end
    else
        local dist = actualPosition - targetPosition
        if dist < 0.0001 then
            return targetPosition
        end
    end

    return actualPosition + ((targetPosition - actualPosition) * (speed * Utils.TimeFrame))
end

function UI.CalculateLinearScalablePosition(targetPosition, actualPosition, speed)
    if targetPosition > actualPosition then
        local dist = targetPosition - actualPosition
        if dist < 0.0001 then
            return targetPosition
        end
    else
        local dist = actualPosition - targetPosition
        if dist < 0.0001 then
            return targetPosition
        end
    end

    if targetPosition > actualPosition then
        if actualPosition + (speed * Utils.TimeFrame) > targetPosition then
            return targetPosition
        else
            return actualPosition + (speed * Utils.TimeFrame)
        end
    else
        if actualPosition - (speed * Utils.TimeFrame) < targetPosition then
            return targetPosition
        else
            return actualPosition - (speed * Utils.TimeFrame)
        end
    end
end

local posX = 0.1328125
local posY = 0.7740740776062
local posX2 = 0.1328125
local posY2 = 0.7740740776062
local width, height = UI.ConvertToPixel(150, 150)
local tw, th = UI.ConvertToRes(width, height)
local CircleX = (0.17254584624767 * 1920) + 0.17254584624767 / tw
local CircleY = (0.84311106872559 * 1080) + 0.84311106872559 / th
local CircleX2 = (0.17254584624767 * 1920) + 0.17254584624767 / tw
local CircleY2 = (0.84311106872559 * 1080) + 0.84311106872559 / th
-- 0.16614584624767, 0.83611106872559
local save = false
-- 0.16666667163372, 0.83518517017365

function UI.DrawGridHorizontal(screenX, screenY, settings, cb)
    local onSelected = false
    local onPositionChange = false
    local X = screenX
    local Y = screenY

    local gridX = (posX * 1920) + posX2 / tw
    local gridY = (posY * 1080) + posY2 / th


    ---DevMode
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y

        posX2 = x
        posY2 = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if settings.grid == nil then
        settings.grid = 'default'
    end
    if settings.grid == "default" then
        UI.DrawSpriteNew("pause_menu_pages_char_mom_dad", "nose_grid", posX2, posY2, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    elseif settings.grid == "horizontal" then
        UI.DrawSpriteNew("charcreator", "horizontal_grid", posX2, posY2, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    end

    local w, h = UI.ConvertToPixel(20, 20)

    if UI.isMouseOnButton({ x = UI.GetControl().x, y = UI.GetControl().y }, { x = gridX / 1920, y =
            gridY / 1080 }, width, height) then
        if IsDisabledControlPressed(0, 24) or IsControlPressed(0, 24) then
            onPositionChange = true
            if settings.grid ~= "horizontal" then
                CircleX2 = (UI.GetControl().x * 1920) + posX2 / tw
                CircleY2 = (UI.GetControl().y * 1080) + posY2 / th
                X = ((CircleX2 / 1920) / width) - (posX2 / width)
                Y = ((CircleY2 / 1080) / height) - (posY2 / height)
            else
                CircleX2 = (UI.GetControl().x * 1920) + posX2 / tw
                -- CircleY = (UI.GetControl().y * 1080) + posY / th
                X = ((CircleX2 / 1920) / width) - (posX2 / width)
                -- Y = ((CircleY / 1080) / height) - (posY / height)
            end
        end
        -- Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
    else
        onPositionChange = false
    end

    UI.DrawSpriteNew("mpinventory", "in_world_circle", CircleX2 / 1920 - w / 2, CircleY2 / 1080 - h / 2, w, h, 0,
        255, 255, 255, 255, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false
        }, function(onSelected, onHovered)
            if onSelected then
            end
        end)


    --Text
    if settings.grid ~= "horizontal" then
        UI.DrawTexts(0.17135417461395, 0.74814814329147, settings.text.up, true, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
        UI.DrawTexts(0.17187501490116, 0.92407405376434, settings.text.down, true, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
        UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, false, false)
        UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
    else
        UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, false, false)
        UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
    end


    cb(onPositionChange, math.round(X, 2), math.round(Y, 2))
end
function UI.DrawGrid(screenX, screenY, settings, cb)
    local onSelected = false
    local onPositionChange = false
    local X = screenX
    local Y = screenY

    local gridX = (posX * 1920) + posX / tw
    local gridY = (posY * 1080) + posY / th


    ---DevMode
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y

        posX = x
        posY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if settings.grid == nil then
        settings.grid = 'default'
    end
    if settings.grid == "default" then
        UI.DrawSpriteNew("pause_menu_pages_char_mom_dad", "nose_grid", posX, posY, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    elseif settings.grid == "horizontal" then
        UI.DrawSpriteNew("charcreator", "horizontal_grid", posX, posY, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    end

    local w, h = UI.ConvertToPixel(20, 20)

    if UI.isMouseOnButton({ x = UI.GetControl().x, y = UI.GetControl().y }, { x = gridX / 1920, y =
            gridY / 1080 }, width, height) then
        if IsDisabledControlPressed(0, 24) or IsControlPressed(0, 24) then
            onPositionChange = true
            if settings.grid ~= "horizontal" then
                CircleX = (UI.GetControl().x * 1920) + posX / tw
                CircleY = (UI.GetControl().y * 1080) + posY / th
                X = ((CircleX / 1920) / width) - (posX / width)
                Y = ((CircleY / 1080) / height) - (posY / height)
            else
                CircleX = (UI.GetControl().x * 1920) + posX / tw
                -- CircleY = (UI.GetControl().y * 1080) + posY / th
                X = ((CircleX / 1920) / width) - (posX / width)
                -- Y = ((CircleY / 1080) / height) - (posY / height)
            end
        end
        -- Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
    else
        onPositionChange = false
    end

    UI.DrawSpriteNew("mpinventory", "in_world_circle", CircleX / 1920 - w / 2, CircleY / 1080 - h / 2, w, h, 0,
        255, 255, 255, 255, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false
        }, function(onSelected, onHovered)
            if onSelected then
            end
        end)


    --Text
    if settings.grid ~= "horizontal" then
        UI.DrawTexts(0.17135417461395, 0.74814814329147, settings.text.up, true, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
        UI.DrawTexts(0.17187501490116, 0.92407405376434, settings.text.down, true, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
        UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, false, false)
        UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
    else
        UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, false, false)
        UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            ConfigShared.Font, true, false)
    end


    cb(onPositionChange, math.round(X, 2), math.round(Y, 2))
end

function UI.DrawCrossBar(name, screenX, screenY, width, height, backgroundColor, progressColor, max, seeNumber, actualPage, settings, cb)
    local value = 1
    if UI.InputPressedTable[name] == nil then 
        UI.InputPressedTable[name] = false
    end
    if settings.devmod ~= nil and settings.devmod == true then
        local x = UI.GetControl().x
        local y = UI.GetControl().y


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end
    if max < seeNumber then
        actualPage = 0
    end
    max = max / seeNumber
    if value > max then
        value = max
    end
   
    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value
    if actualPage < 0 then
        actualPage = 0
    end
    if actualPage  > max - 1 then
        actualPage = max - 1
    end
    
    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height
    local crossPos
    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
        local longueur = screenX + ((actualPage / max) * width)

        crossPos = (vector2(longueur, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left ---pas fonctionnel total
        ---minimum = 1
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
        local longueur = screenX + (((actualPage - 0.5) / max) * (width))
        crossPos = vector2(longueur, pos[2]) - vector2(((actualPage / max) * (width)), 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * height
        local longueur = screenY + (((actualPage * 2.0) / max) * (height / 2.0))
        crossPos = vector2(pos[1], longueur) + vector2(0.0, progressHeight / 2.0)
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    local newValueY = screenY + (((actualPage * 2.0) / max) * (height / 2.0))
    if settings.noHover == false then
        if UI.isMouseOnButton({ x = UI.GetControl().x, y = UI.GetControl().y }, { x = screenX, y = screenY }, width, height) or UI.InputPressedTable[name] then
            SetMouseCursorSprite(5)
            if IsDisabledControlPressed(0, 24) then
                UI.InputPressed = true
                UI.InputPressedTable[name] = true
                local mouse = UI.GetControl().x
                local mouseY = UI.GetControl().y
                local size = ((mouse - screenX) * max) / width
                local sizeY = ((mouseY - screenY) * max) / height
                progressWidth = width
                progressHeight = (value / max) * height
                local longueur = screenY + (((actualPage * 2.0) / max) * (height / 2.0))
                newValue = size
                newValueY = sizeY
                valueUpdated = true
            else
                UI.InputPressedTable[name] = false
                UI.InputPressed = false
            end
        else
            SetMouseCursorSprite(1)
        end
    end
    DrawRect(crossPos[1], crossPos[2], progressWidth, progressHeight, progressColor[1], progressColor[2],
        progressColor[3],
        progressColor[4])

    cb(valueUpdated, newValue, newValueY)
end


UI.CacheSize = {}
function UI.CalculateCorrecteSizeForUI(ui_name, dict, sprite, maxX, maxY)
    if UI.CacheSize[ui_name] == nil then
        UI.CacheSize[ui_name] = {}
    end

    if UI.CacheSize[ui_name][dict..sprite] == nil then
        if HasStreamedTextureDictLoaded(dict) then
            local data = GetTextureResolution(dict, sprite)
            local x,y = UI.ConvertToPixel(data.x, data.y)
            UI.CacheSize[ui_name][dict..sprite] = {}
            UI.CacheSize[ui_name][dict..sprite].size = {x, y}
            UI.CacheSize[ui_name][dict..sprite].resizeDone = false
            local maxXsize, maxYsize = UI.ConvertToPixel(maxX, maxY)
            UI.CacheSize[ui_name][dict..sprite].maxSize = {maxXsize, maxYsize}
        else
            RequestStreamedTextureDict(dict, false)
        end
    end

    if UI.CacheSize[ui_name][dict..sprite] ~= nil then
        local self = UI.CacheSize[ui_name][dict..sprite]
        if not UI.CacheSize[ui_name][dict..sprite].resizeDone then
            if UI.CacheSize[ui_name][dict..sprite].size[1] > self.maxSize[1] then
                UI.CacheSize[ui_name][dict..sprite].size[1] = UI.CacheSize[ui_name][dict..sprite].size[1] / 1.1
                UI.CacheSize[ui_name][dict..sprite].size[2] = UI.CacheSize[ui_name][dict..sprite].size[2] / 1.1
            end
        
            if UI.CacheSize[ui_name][dict..sprite].size[2] > self.maxSize[2] then
                UI.CacheSize[ui_name][dict..sprite].size[2] = UI.CacheSize[ui_name][dict..sprite].size[2] / 1.1
                UI.CacheSize[ui_name][dict..sprite].size[1] = UI.CacheSize[ui_name][dict..sprite].size[1] / 1.1
            end
    
            if UI.CacheSize[ui_name][dict..sprite].size[1] <= self.maxSize[1] and UI.CacheSize[ui_name][dict..sprite].size[2] <= self.maxSize[2] then
                UI.CacheSize[ui_name][dict..sprite].resizeDone = true
            end
        end
    else
        return 0, 0, false
    end


    return UI.CacheSize[ui_name][dict..sprite].size[1], UI.CacheSize[ui_name][dict..sprite].size[2], UI.CacheSize[ui_name][dict..sprite].resizeDone
end

-- function UI.ConvertToPixel(x, y)
--     return (x * 1920), (y * 1080)
-- end
function UI.GetActiveInput()
    return UI.Input
end

function UI.ActivateDetectInput()
    UI.Input = true
    -- true, true = curseur visible ET clavier envoyé au NUI (sinon les lettres ne s'écrivent pas)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true, true)
end

function UI.DeactivateDetectInput()
    UI.Input = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end




-- Définissez une variable au niveau supérieur pour stocker la dernière lettre
local lastLetter = nil
local letterProcessed = true  -- Un indicateur pour savoir si la lettre a été traitée

function UI.ReturnLetter()
    if not letterProcessed then
        letterProcessed = true
        return lastLetter
    else
        return nil
    end
end

RegisterNUICallback('keyInfo', function (data, cb)
    if letterProcessed then
        lastLetter = data.message
        letterProcessed = false
    end
    if cb then cb('ok') end
end)



FADE_UI = {}
FADE_UI.Alpha = 0
FADE_UI.IsScreenFaded = false
FADE_UI.DoingFade = false
FADE_UI.IsUIAlreadyActive = false


function FADE_UI.DoFadeOut(camNames, cam_param)
    FADE_UI.DoingFade = true
    FADE_UI.IsScreenFaded = true
    FADE_UI.RunFadeLogic()
    while FADE_UI.Alpha < 255 do
        if cam_param ~= nil then
            Cam.dof(camNames[1], cam_param.cam1.dof[1], cam_param.cam1.dof[2], cam_param.cam1.dof[3])
            Cam.dof(camNames[2], cam_param.cam2.dof[1], cam_param.cam2.dof[2], cam_param.cam2.dof[3])
        end
        FADE_UI.Alpha = FADE_UI.Alpha + 2
        Wait(1)
    end
    FADE_UI.Alpha = 255
    FADE_UI.DoingFade = false
end

function FADE_UI.DoFadeIn(camNames, cam_param)
    FADE_UI.DoingFade = true
    while FADE_UI.Alpha > 0 do
        if cam_param ~= nil then
            Cam.dof(camNames[1], cam_param.cam1.dof[1], cam_param.cam1.dof[2], cam_param.cam1.dof[3])
            Cam.dof(camNames[2], cam_param.cam2.dof[1], cam_param.cam2.dof[2], cam_param.cam2.dof[3])
        end
        FADE_UI.Alpha = FADE_UI.Alpha - 2
        Wait(1)
    end
    FADE_UI.Alpha = 0
    FADE_UI.IsScreenFaded = false
    FADE_UI.DoingFade = false
end

function FADE_UI.DrawFade()
    SetScriptGfxDrawOrder(100)
    DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, FADE_UI.Alpha)
    SetScriptGfxDrawOrder(0)
end 

function FADE_UI.RunFadeLogic()
    if FADE_UI.IsUIAlreadyActive then
        return
    end
    Citizen.CreateThread(function()
        FADE_UI.IsUIAlreadyActive = true
        while FADE_UI.Alpha > 0 do
            FADE_UI.DrawFade()
    
            if FADE_UI.Alpha > 0 then
                Wait(1)
            else
                Wait(100)
            end
        end
        FADE_UI.IsUIAlreadyActive = false
    end)
end

UI.dictToLoadFirst = {
    { "inventory" },

}

UI.dictToLoad = { -- Maybe used in the futur
    { "item_icon" }
}

for k,v in pairs(UI.fontToLoad) do
    UI.LoadFont(v)
    print(v[1], v[2], "Loaded.")
end

for k, v in pairs(UI.dictToLoad) do
    UI.LoadStreamDict(v[1])
end

exports('GetNativeDraw', function()
    print("SoCore: GetNativeDraw called")
    return UI
end)