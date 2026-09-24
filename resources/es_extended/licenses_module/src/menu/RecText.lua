--[[
    CODE FROM https://github.com/PABLO-1610/fl_labs/blob/main/client/animations.lua
    F*UCKING DUMPER ILY
--]]

function RageUI.drawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x,y)
end

local baseX = 0.085
local baseY = 0.10
local baseWidth = 0.15
local baseHeight = 0.03
function RageUI.advancedDesc(title, color, components)
    if not RageUI.CurrentMenu then
        DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.025, color[1], color[2], color[3], 255)
        DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 0, 0, 0, 170)
        RageUI.drawTexts(baseX - 0.0395, baseY - (0.043) - 0.013, title, false, 0.35, { 255, 255, 255, 255 }, 2, 0)

        for k, v in pairs(components) do
            DrawRect(baseX, (baseY - 0.043) + (0.030 * (k)), baseWidth, baseHeight, 0, 0, 0, 150)
            RageUI.drawTexts(baseX - 0.073, baseY - (0.043) + (0.030 * (k)) - 0.013, v[1], false, 0.35, v[2] or { 255, 255, 255, 255 }, 4, 0)
        end
    end
end