UIInstructionalButton = setmetatable({}, UIInstructionalButton);

UIInstructionalButton.__index = UIInstructionalButton

function UIInstructionalButton.__constructor(scaleform)
    local _UIInstructionalButton = {
        scaleform = RequestScaleformMovie(scaleform or "INSTRUCTIONAL_BUTTONS"),
        display = false,
        color = { r = 0, g = 0, b = 0, a = 80 },
        items = {};
    }
    return setmetatable(_UIInstructionalButton, UIInstructionalButton);
end

function UIInstructionalButton:Add(name, control)
    self.items[#self.items + 1] = { name = name, control = control }
    self:onRefresh();
end

function UIInstructionalButton:UpdateBackground(r, g, b, a)
    self.color = { r = r, g = g, b = b, a = a };
    self:onRefresh();
    return self.color
end

function UIInstructionalButton:Delete(name, control)
    for key, value in pairs(self.items) do
        if (value.name == name) and (control == nil) then
            self.items[key] = nil;
        elseif (value.name == name) and (value.control == control) then
            self.items[key] = nil;
        end
    end
    self:onRefresh();
end

function UIInstructionalButton:Edit(name, old, control)
    for key, value in pairs(self.items) do
        if (value.name == name) and (control == nil) then
            self.items[key].name = old;
        elseif (value.name == name) and (value.control == control) then
            self.items[key].name = old;
        end
    end
    self:onRefresh();
end

function UIInstructionalButton:Visible(bool)
    self.display = bool;
    return self.display;
end

function UIInstructionalButton:onRefresh()
    PushScaleformMovieFunction(self.scaleform, "CLEAR_ALL")
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.scaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(self.color.r)
    PushScaleformMovieFunctionParameterInt(self.color.g)
    PushScaleformMovieFunctionParameterInt(self.color.b)
    PushScaleformMovieFunctionParameterInt(self.color.a)
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.scaleform, "CREATE_CONTAINER")
    PopScaleformMovieFunction()

    for key, value in pairs(self.items) do
        PushScaleformMovieFunction(self.scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(key)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(1, value.control, 0))
        PushScaleformMovieFunctionParameterString(value.name)
        PopScaleformMovieFunction()
    end

    PushScaleformMovieFunction(self.scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunction()
end

function UIInstructionalButton:onTick()
    if (#self.items > 0) and (self.display) then
        DrawScaleformMovieFullscreen(self.scaleform, 255, 255, 255, 255)
    end
end
