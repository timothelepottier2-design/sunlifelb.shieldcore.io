function GetUserInput(windowTitle, defaultText, maxInputLength)

  local resourceName = string.upper(GetCurrentResourceName())
  local textEntry = resourceName .. "_WINDOW_TITLE"
  if windowTitle == nil then
    windowTitle = "Enter:"
  end
  AddTextEntry(textEntry, windowTitle)

  DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
  Wait(0)

  while true do
    local keyboardStatus = UpdateOnscreenKeyboard();
    if keyboardStatus == 3 then
      return nil
    elseif keyboardStatus == 2 then
      return nil
    elseif keyboardStatus == 1 then
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

function handleArrowInput(center, heading)
  delta = 0.05

  if IsDisabledControlPressed(0, 36) then
    delta = 0.01
  end

  if IsDisabledControlPressed(0, 172) then
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x, center.y + delta), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end

  if IsDisabledControlPressed(0, 173) then
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x, center.y - delta), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end

  if IsDisabledControlPressed(0, 174) then
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x - delta, center.y), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end

  if IsDisabledControlPressed(0, 175) then
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x + delta, center.y), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end

  return center
end

function disableControlKeyInput()
  Citizen.CreateThread(function()
    while drawZone do
      DisableControlAction(0, 36, true)
      DisableControlAction(0, 19, true)
      DisableControlAction(0, 20, true)
      DisableControlAction(0, 21, true)
      DisableControlAction(0, 81, true)
      DisableControlAction(0, 99, true)
      DisableControlAction(0, 172, true)
      DisableControlAction(0, 173, true)
      DisableControlAction(0, 174, true)
      DisableControlAction(0, 175, true)
      Wait(0)
    end
  end)
end
