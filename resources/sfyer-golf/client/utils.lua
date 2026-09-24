PropsList = {}
BlipsList = {}
mapDebug = false
GolfPolyZone = nil
CurrentScaleform = 47
CurrentScaleform2 = 11
CurrentScaleform3 = 1
TargetList = nil

-- Tee : prop_golf_tee
-- Tee w/ ball : prop_golf_ball_tee
-- Ball : prop_golf_ball
-- Golf Flag : prop_golfflag

-- Props

function SpawnProps(golfCourseId, holeId)
    PropsList[holeId] = {}
    PropsList[holeId]['flag'] = CreateObject(Config.Props.flag, Config.GolfCourse[golfCourseId].holes[holeId].holePos.x, Config.GolfCourse[golfCourseId].holes[holeId].holePos.y, Config.GolfCourse[golfCourseId].holes[holeId].holePos.z, false, true, false)
    SetEntityCompletelyDisableCollision(PropsList[holeId]['flag'], true, true)
end

function DeleteProps()
    for k,v in pairs(PropsList) do
        DeleteObject(v['flag'])
    end
end


-- Utils UI 

function showNotification(message, color, isFlash, saveToBrief)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(color)
    EndTextCommandThefeedPostTicker(isFlash, saveToBrief)
end

function showAdvancedNotification(message, color, sender, subject, textureDict, iconType, saveToBrief)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(color)
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
    EndTextCommandThefeedPostTicker(false, saveToBrief)
end

function showSubtitle(message, duration)
    BeginTextCommandPrint('STRING')
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

function keyboard(title, inputLength, originalText)
    AddTextEntry('keyboard_title', title)
    DisplayOnscreenKeyboard(1, 'keyboard_title', '', originalText, '', '', '', inputLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard ~= 2 do
        Wait(0)
    end 

    if UpdateOnscreenKeyboard() == 1 then
        local result = GetOnscreenKeyboardResult()
        Wait(0)
        return result
    else
        Wait(0)
        return nil
    end
end

function displayHelpText(text, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, duration)
end

function displayThreeLineHelpText(line1, line2, line3, duration)
    BeginTextCommandDisplayHelp("THREESTRINGS")

    AddTextComponentSubstringPlayerName(line1)
    AddTextComponentSubstringPlayerName(line2)
    AddTextComponentSubstringPlayerName(line3)

    EndTextCommandDisplayHelp(0, false, false, duration)
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function displayBigMessage(title, message, duration)
    local scaleform = RequestScaleformMovie("mp_big_message_freemode") -- The scaleform you want to use
    while not HasScaleformMovieLoaded(scaleform) do -- Ensure the scaleform is actually loaded before using
      Citizen.Wait(0)
    end
  
    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE") -- The function you want to call from the AS file
    PushScaleformMovieMethodParameterString(title) -- bigTxt
    PushScaleformMovieMethodParameterString(message) -- msgText
    PushScaleformMovieMethodParameterInt(5) -- colId
    EndScaleformMovieMethod() -- Finish off the scaleform, it returns no data, so doesnt need "EndScaleformMovieMethodReturn"
    
    CreateThread(function ()
        local time = 0
        while time <= duration do
            Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255) -- Draw the scaleform fullscreen
            time = time + 1
        end
    end)
end

--== Math helps

function GetHeadDirection(ped)
    local yaw = math.rad(GetEntityHeading(ped))
    local y = math.cos(yaw)
    local x = -math.sin(yaw)
    return vector2(x, y)
end

function SetEntityHeadingLookAt(ped, target) 
    local pos = GetEntityCoords(ped)
    local targetPos = GetEntityCoords(target)
    local dir = targetPos - pos
    local yaw = math.atan(-dir.x, dir.y)
    SetEntityHeading(ped, math.deg(yaw))
end

function SetEntityHeadingLookAtWithCoords(pedId, pedCoords, targetCoords) 
    local dir = targetCoords - pedCoords
    local yaw = math.atan(-dir.x, dir.y)
    SetEntityHeading(pedId, math.deg(yaw))
end

function IsEntityStopped(vector, ceil)
    if Vmag(vector) < ceil then
        return true
    else
        return false
    end
end

function calcScore(table)
    local result = 0
    for k,v in pairs(table) do
        result = result + v
    end
    return result
end
-- Anim Utils

function LoadAnimDict(clubId, animId)
    if not HasAnimDictLoaded(Config.ClubList[clubId].anim[animId].animDict) then
        RequestAnimDict(Config.ClubList[clubId].anim[animId].animDict)
        while not HasAnimDictLoaded(Config.ClubList[clubId].anim[animId].animDict) do
            Wait(2)
        end
    end
end

-- Blips

function CreateBallBlip(ballEntity)

    BlipsList['ball'] = AddBlipForEntity(ballEntity)
    SetBlipSprite(BlipsList['ball'], Config.Blips.ballBlip.sprite)
    SetBlipScale(BlipsList['ball'], Config.Blips.ballBlip.scale)
    SetBlipColour(BlipsList['ball'], Config.Blips.ballBlip.colour)
    SetBlipAsShortRange(BlipsList['ball'], Config.Blips.ballBlip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(parseText('ball_blip'))
    EndTextCommandSetBlipName(BlipsList['ball'])
end

function CreateMainBlip()
    local blip = AddBlipForCoord(Config.GolfCourse[1].markerStart)
    SetBlipSprite(blip, Config.Blips.mainBlip.sprite)
    SetBlipScale(blip, Config.Blips.mainBlip.scale)
    SetBlipColour(blip, Config.Blips.mainBlip.colour)
    SetBlipAsShortRange(blip, Config.Blips.mainBlip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(parseText('golf_main_blip'))
    EndTextCommandSetBlipName(blip)
end

function RemoveAllBlip()
    RemoveBlip(BlipsList['start_pos'])
    RemoveBlip(BlipsList['flag'])
    RemoveBlip(BlipsList['ball'])
end

function CreateStartAndStopBlip(startPos, holePos)
    BlipsList['start_pos'] = AddBlipForCoord(startPos)
    SetBlipSprite(BlipsList['start_pos'], Config.Blips.startPosBlip.sprite)
    SetBlipScale(BlipsList['start_pos'], Config.Blips.startPosBlip.scale)
    SetBlipColour(BlipsList['start_pos'], Config.Blips.startPosBlip.colour)
    SetBlipAsShortRange(BlipsList['start_pos'], Config.Blips.startPosBlip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(parseText('start_pos_blip'))
    EndTextCommandSetBlipName(BlipsList['start_pos'])
    BlipsList['flag'] = AddBlipForCoord(holePos)
    SetBlipSprite(BlipsList['flag'], Config.Blips.holeBlip.sprite)
    SetBlipScale(BlipsList['flag'], Config.Blips.holeBlip.scale)
    SetBlipColour(BlipsList['flag'], Config.Blips.holeBlip.colour)
    SetBlipAsShortRange(BlipsList['flag'], Config.Blips.holeBlip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(parseText('hole_pos_blip'))
    EndTextCommandSetBlipName(BlipsList['flag'])
end


function drawBlipsLine(heading, ballPostion, flagPosition)
    if BlipsList['line'] ~= nil then
        for k,v in pairs(BlipsList['line']) do
            if DoesBlipExist(v) then
                RemoveBlip(v)
            end
        end
    end
    BlipsList['line'] = {}
    local nBlips = 8
    local radiusIncrement = math.floor(Vmag(flagPosition - ballPostion))/ nBlips
    for i = 1, nBlips do
        local x = ballPostion.x + (radiusIncrement * i) * math.cos(math.rad(heading - 180))
        local y = ballPostion.y + (radiusIncrement * i) * math.sin(math.rad(heading - 180))
        BlipsList['line'][i] = AddBlipForCoord(x, y, 50.0)
        SetBlipSprite(BlipsList['line'][i], Config.Blips.sightBlip.sprite)
        SetBlipScale(BlipsList['line'][i], Config.Blips.sightBlip.scale)
        SetBlipColour(BlipsList['line'][i], Config.Blips.sightBlip.colour)
        SetBlipAsShortRange(BlipsList['line'][i], Config.Blips.sightBlip.shortRange)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(parseText('aiming'))
        EndTextCommandSetBlipName(BlipsList['line'][i])
    end


end

function deleteBlipsLine()
    if BlipsList['line'] ~= nil then
        for k,v in pairs(BlipsList['line']) do
            if DoesBlipExist(v) then
                RemoveBlip(v)
            end
        end
    end
    BlipsList['line'] = nil
end

-- Debug
if Config.DebugMode then
    RegisterCommand("golfdebug", function (source, args)
        if args[1] == "switchHole"  then
            SwitchHole(tonumber(args[2]))
        elseif args[1] == "join" then
            StartGolf(tonumber(args[2]))
        elseif args[1] == "playerMode" then
            if args[2] == "1" then
                EnterPlayingMode()
            elseif args[2] == "0" then
                ExitPlayingMode()
            end
        elseif args[1] == "switchClub" then
            if PlayerData.isInPlayerMode then
                SwitchClubModel(tonumber(args[2]))
            end
        elseif args[1] == "map" then
            mapDebug = not mapDebug
            if mapDebug then
                SetMinimapGolfCourse(tonumber(args[2]))
                SetRadarZoom(Config.GolfCourse[1].holes[tonumber(args[2])].minimapPos.zoomMult)
                LockMinimapAngle(Config.GolfCourse[1].holes[tonumber(args[2])].minimapPos.angle)
                LockMinimapPosition(Config.GolfCourse[1].holes[tonumber(args[2])].minimapPos.x, Config.GolfCourse[1].holes[tonumber(args[2])].minimapPos.y)
                CreateThread(function ()
                    while mapDebug do
                        Wait(0)
                        DrawScaleformMovieFullscreen(setupGolfScaleform(), 255, 255, 255, 255, 0)
                    end
                end)
            else
                SetMinimapGolfCourseOff()
                SetRadarZoom(0)
                UnlockMinimapAngle()
                UnlockMinimapPosition()
            end
        elseif args[1] == 'sf' then
            CurrentScaleform = tonumber(args[2])
        elseif args[1] == 'sf2' then
            CurrentScaleform2 = tonumber(args[2])
        elseif args[1] == 'sf3' then
            CurrentScaleform3 = tonumber(args[2])
        elseif args[1] == "trail" then
            InitializeGolfTrail()
        end
    end, false)
    
    function dump(o)
        if type(o) == 'table' then
           local s = '{ '
           for k,v in pairs(o) do
              if type(k) ~= 'number' then k = '"'..k..'"' end
              s = s .. '['..k..'] = ' .. dump(v) .. ','
           end
           return s .. '} '
        else
           return tostring(o)
        end
     end 
end


-- Controls

function DisableAllControlActions(state)
    DisableControlAction(0, Config.Keys['playingMode'], state) -- F
    DisableControlAction(0, Config.Keys['switchClub'], state) -- A
    DisableControlAction(0, Config.Keys['rotateLeft'], state) -- Q
    DisableControlAction(0, Config.Keys['changeIncrement'], state) -- D
    DisableControlAction(0, Config.Keys['terrainGrid'], state) -- G
    DisableControlAction(0, Config.Keys['scoreboard'], state) -- H
    DisableControlAction(0, Config.Keys['swing'], state) -- GAUCHE
end

-- Polyzone

function CreateGolfPolyzone()
    GolfPolyZone = PolyZone:Create(Config.Polyzone.poly, Config.Polyzone.infos)
end

-- OxTarget

function CreateOxTarget()
    exports.ox_target:addBoxZone(Config.OxTargetConfig.mainMarker.boxZone)
end

function CreateMovingTarget(type, coords, event) -- 0 : flyby, 1 : playing mode
    data = Config.OxTargetConfig.flyByMode
    if type == 1 then
        data = Config.OxTargetConfig.playingMode
    end

    data.options[1].event = event
    data.coords = coords
    TargetList = exports.ox_target:addBoxZone(data)
end

function DestroyMovingTarget()
    exports.ox_target:removeZone(TargetList)
    TargetList = nil
end