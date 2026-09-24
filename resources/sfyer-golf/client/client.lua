-- Variables
PlayerData = {
    States = { isPlaying = false, isInPlayerMode = false, isInFlybyMode = false, arrivedToCurrentHole = false },
    GolfInfos = { golfCourseId = nil, currentHole = 1, hasFinishedHole = false },
    Objects = {
        Ball = {
            ballPosition = vector3(0.0, 0.0, 0.0),
            ballPreviousPosition = vector3(0.0, 0.0, 0.0),
            ballObject = false,
            checkIfBallStopped = true
        },
        Club = {
            currentClubId = 1,
            clubObject = nil
        }
    },
    ui = {
        infos_scaleform = nil,
        golf_scaleform = nil,
        terrainGridActivated = false,
        currentMaterial = 7,
        currentMaterialLabel = nil,
        scoreboardDisplayed = false,
        mobileScoreboardDisplayed = false
    },
    Gameplay = {
        currentIncrement = 2,
        currentPar = 0,
        currentTaskPlaying = "",
        playerRotation = 0.0,
        Swing = { canSwing = true, isSwinging = false, swingPower = 0.0, isMax = false }
    },
    Stats = {}
}
TerrainMaterials = {
    Grass = {
        [930824497] = {
            x_mult = 1.5,
            y_mult = 1.5,
            z_mult = 1.00,
            sfx = "GOLF_BALL_IMPACT_GRASS_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 6,
            ui_label = "Herbe"
        },
        [-461750719] = {
            x_mult = 1.50,
            y_mult = 1.50,
            z_mult = 1.00,
            sfx = "GOLF_BALL_IMPACT_GRASS_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 4,
            ui_label = "Herbe"
        }
    },
    Fairway = {
        [-1286696947] = {
            x_mult = 1.0,
            y_mult = 1.0,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_FAIRWAY_MASTER",
            swingSfx = "GOLF_SWING_FAIRWAY_IRON_MASTER",
            ui_mat = 3,
            ui_label = "Fairway"
        },
        [1333033863] = {
            x_mult = 1.0,
            y_mult = 1.0,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_FAIRWAY_MASTER",
            swingSfx = "GOLF_SWING_FAIRWAY_IRON_MASTER",
            ui_mat = 3,
            ui_label = "Fairway"
        }
    },
    Sand = {
        [-1595148316] = {
            x_mult = 2.0,
            y_mult = 2.0,
            z_mult = 2.0,
            sfx = "GOLF_BALL_IMPACT_SAND_MASTER",
            swingSfx = "GOLF_SWING_SAND_IRON_MASTER",
            ui_mat = 2,
            ui_label = "Bunker"
        }
    },
    Concrete = {
        [-840216541] = {
            x_mult = 0.7,
            y_mult = 0.7,
            z_mult = 0.80,
            sfx = "GOLF_BALL_IMPACT_CONCRETE_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 1
        },
        [510490462] = {
            x_mult = 0.7,
            y_mult = 0.7,
            z_mult = 0.80,
            sfx = "GOLF_BALL_IMPACT_CONCRETE_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 1
        },
        [282940568] = {
            x_mult = 0.7,
            y_mult = 0.7,
            z_mult = 0.80,
            sfx = "GOLF_BALL_IMPACT_CONCRETE_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 1
        },
        [951832588] = {
            x_mult = 0.7,
            y_mult = 0.7,
            z_mult = 0.80,
            sfx = "GOLF_BALL_IMPACT_CONCRETE_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 1
        },
        [1187676648] = {
            x_mult = 0.7,
            y_mult = 0.7,
            z_mult = 0.80,
            sfx = "GOLF_BALL_IMPACT_CONCRETE_MASTER",
            swingSfx = "GOLF_SWING_GRASS_MASTER",
            ui_mat = 1
        }
    },
    Tree = {
        [555004797] = {
            x_mult = 0.45,
            y_mult = 0.45,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_TREE_MASTER",
            swingSfx = nil,
            ui_mat = 1
        },
        [-309121453] = {
            x_mult = 0.45,
            y_mult = 0.45,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_TREE_MASTER",
            swingSfx = nil,
            ui_mat = 1
        },
        [-1915425863] = {
            x_mult = 0.45,
            y_mult = 0.45,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_TREE_MASTER",
            swingSfx = nil,
            ui_mat = 1
        },
        [581794674] = {
            x_mult = 0.45,
            y_mult = 0.45,
            z_mult = 0.60,
            sfx = "GOLF_BALL_IMPACT_TREE_MASTER",
            swingSfx = nil,
            ui_mat = 1
        }
    },
    Leaves = {
        [-309121453] = { x_mult = 10.15, y_mult = 10.15, z_mult = 10.0, sfx = nil, swingSfx = nil, ui_mat = 1 },
        [555004797] = { x_mult = 10.15, y_mult = 10.15, z_mult = 10.00, sfx = nil, swingSfx = nil, ui_mat = 1 },
        [581794674] = { x_mult = 10.15, y_mult = 10.15, z_mult = 10.00, sfx = nil, swingSfx = nil, ui_mat = 1 },
        [-2041329971] = { x_mult = 10.15, y_mult = 10.15, z_mult = 10.0, sfx = nil, swingSfx = nil, ui_mat = 1 },
        [-1885547121] = { x_mult = 10.15, y_mult = 10.15, z_mult = 10.00, sfx = nil, swingSfx = nil, ui_mat = 1 },
        [-1915425863] = { x_mult = 10.15, y_mult = 10.00, z_mult = 10.00, sfx = nil, swingSfx = nil, ui_mat = 1 }
    }
}
ReplaceReasons = {
    outOfBounds = { label = parseText("replace_out_of_bounds") },
    leaves = { label = parseText("replace_leaves") },
    water = { label = parseText("replace_water") }
}

--Initializing blips, polyzone & oxtarget once
CreateThread(
    function()
        CreateGolfPolyzone()
        if Config.activateOxTarget then
            CreateOxTarget()
        end
        CreateMainBlip()
    end
)

-- Threads
CreateThread(
    function()
        while true do
            Wait(0)
            if not Config.activateOxTarget or (Config.activateOxTarget and not Config.OxTargetConfig.mainMarker.activated) then
                for a, b in pairs(Config.GolfCourse) do
                    DrawMarker(
                        Config.MarkersParam.mainMarker.type,
                        b.markerStart.x,
                        b.markerStart.y,
                        b.markerStart.z,
                        Config.MarkersParam.mainMarker.dir,
                        Config.MarkersParam.mainMarker.rot,
                        Config.MarkersParam.mainMarker.scale,
                        Config.MarkersParam.mainMarker.red,
                        Config.MarkersParam.mainMarker.green,
                        Config.MarkersParam.mainMarker.blue,
                        Config.MarkersParam.mainMarker.alpha,
                        Config.MarkersParam.mainMarker.upAndDown,
                        Config.MarkersParam.mainMarker.faceCamera,
                        2,
                        Config.MarkersParam.mainMarker.rotate,
                        Config.MarkersParam.mainMarker.textureDict,
                        Config.MarkersParam.mainMarker.textureName,
                        false
                    )
                    if #(GetEntityCoords(PlayerPedId()) - b.markerStart) < 2.0 then
                        displayHelpText(parseText("start_golf_course") .. " " .. Config.Keys['openMenu'].text, 10)
                        if IsControlJustPressed(0, Config.Keys['openMenu'].key) then
                            TriggerEvent('scriptifyer-golf:client:openMenu')
                        end
                    else
                        if RageUI.Visible(MainMenu) then
                            TriggerEvent('scriptifyer-golf:client:closeMenu')
                        end
                    end
                end
            end
            if PlayerData.States.isPlaying then

                DrawMarker(
                    Config.MarkersParam.holeMarker.type,
                    Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos
                    .x,
                    Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos
                    .y,
                    Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos
                    .z +
                    1,
                    Config.MarkersParam.holeMarker.dir,
                    Config.MarkersParam.holeMarker.rot,
                    Config.MarkersParam.holeMarker.scale,
                    Config.MarkersParam.holeMarker.red,
                    Config.MarkersParam.holeMarker.green,
                    Config.MarkersParam.holeMarker.blue,
                    Config.MarkersParam.holeMarker.alpha,
                    Config.MarkersParam.holeMarker.upAndDown,
                    Config.MarkersParam.holeMarker.faceCamera,
                    2,
                    Config.MarkersParam.holeMarker.rotate,
                    Config.MarkersParam.holeMarker.textureDict,
                    Config.MarkersParam.holeMarker.textureName,
                    false
                )
                if IsControlJustPressed(0, Config.Keys['scoreboard_ig'].key) and not PlayerData.States.isInPlayerMode then
                    PlayerData.ui.mobileScoreboardDisplayed = not PlayerData.ui.mobileScoreboardDisplayed
                    if PlayerData.ui.mobileScoreboardDisplayed then
                        TriggerEvent('scriptifyer-golf:client:enteringMobileScoreboard')
                    else
                        TriggerEvent('scriptifyer-golf:client:exitingMobileScoreboard')
                    end
                    CreateThread(function()
                        while PlayerData.ui.mobileScoreboardDisplayed do
                            Wait(0)
                            DrawScaleformMovieFullscreen(setupScoreboardScaleform(), 255, 255, 255, 255, false)
                        end
                    end)
                end
            end
            if
                PlayerData.States.isPlaying and not PlayerData.States.arrivedToCurrentHole and
                CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil and
                CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId].isPlaying
            then
                showSubtitle(parseText("goto_hole") .. PlayerData.GolfInfos.currentHole, 100)
                if not Config.activateOxTarget or (Config.activateOxTarget and not Config.OxTargetConfig.flyByMode.activated) then
                    DrawMarker(
                        Config.MarkersParam.playingMode.type,
                        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole]
                        .startPos.x,
                        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole]
                        .startPos.y,
                        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole]
                        .startPos.z,
                        Config.MarkersParam.playingMode.dir,
                        Config.MarkersParam.playingMode.rot,
                        Config.MarkersParam.playingMode.scale,
                        Config.MarkersParam.playingMode.red,
                        Config.MarkersParam.playingMode.green,
                        Config.MarkersParam.playingMode.blue,
                        Config.MarkersParam.playingMode.alpha,
                        Config.MarkersParam.playingMode.upAndDown,
                        Config.MarkersParam.playingMode.faceCamera,
                        2,
                        Config.MarkersParam.playingMode.rotate,
                        Config.MarkersParam.playingMode.textureDict,
                        Config.MarkersParam.playingMode.textureName,
                        false
                    )

                    if
                        #(GetEntityCoords(PlayerPedId()) -
                            Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startPos) <
                        2.0
                    then

                        displayHelpText(parseText("enter_player_mode") .. " " .. Config.Keys['playingMode'].text, 10)
                        if IsControlJustPressed(0, Config.Keys['playingMode'].key) then
                            TriggerEvent('scriptifyer-golf:client:initializeBall')
                            Wait(5000)
                        end
                    end
                end
            end
            if
                PlayerData.States.isPlaying and PlayerData.States.arrivedToCurrentHole and
                not PlayerData.States.isInPlayerMode and
                not IsEntityInAir(PlayerData.Objects.Ball.ballObject) and
                IsEntityStopped(GetEntityVelocity(PlayerData.Objects.Ball.ballObject), Config.IsEntityStoppedCeil) and
                CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil and
                CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId].isPlaying
                and (not Config.activateOxTarget or (Config.activateOxTarget and not Config.OxTargetConfig.playingMode.activated))
            then
                DrawMarker(
                        Config.MarkersParam.playingMode.type,
                        PlayerData.Objects.Ball.ballPosition.x,
                        PlayerData.Objects.Ball.ballPosition.y,
                        PlayerData.Objects.Ball.ballPosition.z,
                        Config.MarkersParam.playingMode.dir,
                        Config.MarkersParam.playingMode.rot,
                        Config.MarkersParam.playingMode.scale,
                        Config.MarkersParam.playingMode.red,
                        Config.MarkersParam.playingMode.green,
                        Config.MarkersParam.playingMode.blue,
                        Config.MarkersParam.playingMode.alpha,
                        Config.MarkersParam.playingMode.upAndDown,
                        Config.MarkersParam.playingMode.faceCamera,
                        2,
                        Config.MarkersParam.playingMode.rotate,
                        Config.MarkersParam.playingMode.textureDict,
                        Config.MarkersParam.playingMode.textureName,
                        false
                    )
                if #(GetEntityCoords(PlayerPedId()) - PlayerData.Objects.Ball.ballPosition) < 2.0 then
                    displayHelpText(parseText("enter_player_mode") .. " " .. Config.Keys['playingMode'].text, 10)
                    if IsControlJustPressed(0, Config.Keys['playingMode'].key) then
                        EnterPlayingMode()
                        Wait(100)
                    end
                end
            end
            if PlayerData.States.isInPlayerMode and CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
                PlayerData.ui.infos_scaleform = setupInformationsScaleform()
                DrawScaleformMovieFullscreen(PlayerData.ui.infos_scaleform, 255, 255, 255, 255, 0)
                if IsControlJustPressed(0, Config.Keys['playingMode'].key) then
                    ExitPlayingMode()
                end
                if IsControlJustPressed(0, Config.Keys['switchClub'].key) then
                    if not PlayerData.Gameplay.Swing.isSwinging then
                        if PlayerData.Objects.Club.currentClubId + 1 > #Config.ClubList then
                            PlayerData.Objects.Club.currentClubId = 1
                        else
                            PlayerData.Objects.Club.currentClubId = PlayerData.Objects.Club.currentClubId + 1
                        end
                        SwitchClubModel(PlayerData.Objects.Club.currentClubId)
                    end
                end
                if IsControlJustPressed(0, Config.Keys['rotateLeft'].key) then
                    rotatePlayer(0)
                end
                if IsControlJustPressed(0, Config.Keys['rotateRight'].key) then
                    rotatePlayer(1)
                end
                if IsControlJustPressed(0, Config.Keys['changeIncrement'].key) then
                    ChangeTurnIncrement()
                end
                if IsControlJustPressed(0, Config.Keys['terrainGrid'].key) then
                    PlayerData.ui.terrainGridActivated = not PlayerData.ui.terrainGridActivated
                    DrawTerrainGrid(PlayerData.ui.terrainGridActivated)
                end
                if IsControlJustPressed(0, Config.Keys['scoreboard'].key) then
                    PlayerData.ui.scoreboardDisplayed = not PlayerData.ui.scoreboardDisplayed
                end
                if IsControlJustPressed(0, Config.Keys['swing'].key) then
                    if not PlayerData.Gameplay.Swing.isSwinging and PlayerData.Gameplay.Swing.canSwing then
                        PlayerData.Gameplay.Swing.isSwinging = true
                        PlayerData.Gameplay.currentTaskPlaying = "swing_i"
                        PlaySwingIntroAnim()
                    else
                        PlayerData.Gameplay.currentTaskPlaying = "swing_r"
                        PlayerData.Gameplay.Swing.isSwinging = false
                        PlayerData.Gameplay.Swing.canSwing = false
                        CreateThread(
                            function()
                                PlaySwingReleaseAnim()
                                Wait(200)
                                swingBall()
                            end
                        )
                        if Config.activateOxTarget then
                            DestroyMovingTarget()
                        end

                        Wait(1000)
                        ExitPlayingMode()
                        Wait(1000)
                        PlayerData.Objects.Ball.checkIfBallStopped = false

                    end
                    DisableAllControlActions(true)
                end
                if PlayerData.Gameplay.currentTaskPlaying == "idle" then
                    PlayIdlingAnim()
                end
                local c =
                    GetObjectOffsetFromCoords(
                        GetEntityCoords(PlayerData.Objects.Ball.ballObject),
                        GetEntityHeading(PlayerData.Objects.Ball.ballObject),
                        -2.5,
                        0.0,
                        15.0
                    )
                local d, e = GetGroundZAndNormalFor_3dCoord(c.x, c.y, c.z)
                DrawMarker(
                    3,
                    c.x,
                    c.y,
                    e + 0.2,
                    0,
                    0,
                    0,
                    0.0,
                    180.0,
                    0.0,
                    0.15,
                    0.15,
                    0.15,
                    252,
                    169,
                    3,
                    130,
                    false,
                    true,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
            end
            if PlayerData.States.isInPlayerMode and CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
                PlayerData.ui.golf_scaleform = setupGolfScaleform()
                DrawScaleformMovieFullscreen(PlayerData.ui.golf_scaleform, 255, 255, 255, 255, 0)
            end
            if not PlayerData.Objects.Ball.checkIfBallStopped and CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
                materialId = GetLastMaterialHitByEntity(PlayerData.Objects.Ball.ballObject)
                if materialId ~= 0 then
                    applyGroundForceOnBall(materialId)
                end
                if IsEntityInWater(PlayerData.Objects.Ball.ballObject) then
                    ReplaceBallToPreviousPosition(ReplaceReasons.water)
                end
                if IsEntityInAir(PlayerData.Objects.Ball.ballObject) then
                    ApplyForceToEntity(PlayerData.Objects.Ball.ballObject, 0, GetWindDirection() * GetWindSpeed(), 0.0,
                        0.0, 0.0, 0, false, false, true, false, false)
                end
                if Config.HitLeavesReplaceBall then
                    local shape = StartShapeTestBound(PlayerData.Objects.Ball.ballObject, 256, 4)
                    local _, hit, _2, _3, entity = GetShapeTestResult(shape)
                    if hit ~= 0 then
                        ReplaceBallToPreviousPosition(ReplaceReasons.leaves)
                    end
                end
            end
            if PlayerData.States.isPlaying and CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
                if DoesEntityExist(PlayerData.Objects.Ball.ballObject) then
                    if
                        not IsEntityInAir(PlayerData.Objects.Ball.ballObject) and
                        IsEntityStopped(
                            GetEntityVelocity(PlayerData.Objects.Ball.ballObject),
                            Config.IsEntityStoppedCeil
                        )
                    then
                        if
                            #(PlayerData.Objects.Ball.ballPosition -
                                Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[
                                PlayerData.GolfInfos.currentHole
                                ].holePos) < 0.2
                        then
                            PlayerData.GolfInfos.hasFinishedHole = true
                            TriggerEvent('scriptifyer-golf:client:finishedHole')
                            if
                                #Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes >=
                                PlayerData.GolfInfos.currentHole + 1
                            then
                                SwitchHole(PlayerData.GolfInfos.currentHole + 1)
                            end
                        end
                    end
                    if DoesEntityExist(PlayerData.Objects.Ball.ballObject) and not GolfPolyZone:isPointInside(GetEntityCoords(PlayerData.Objects.Ball.ballObject)) and not PlayerData.GolfInfos.hasFinishedHole then
                        ReplaceBallToPreviousPosition(ReplaceReasons.outOfBounds)
                    end
                end

            end
        end
    end
)
CreateThread(
    function()
        while true do
            Wait(1)
            if
                PlayerData.ui.golf_scaleform ~= nil and PlayerData.States.isInPlayerMode and
                PlayerData.Gameplay.Swing.isSwinging and
                not PlayerData.Gameplay.Swing.isMax
            then
                if PlayerData.Gameplay.Swing.swingPower < 1.0 then
                    PlayerData.Gameplay.Swing.swingPower = PlayerData.Gameplay.Swing.swingPower + 0.01
                else
                    PlayerData.Gameplay.Swing.isMax = true
                    PlayerData.Gameplay.Swing.isSwinging = false
                    PlayerData.ui.golf_scaleform = nil
                    PlayerData.Gameplay.Swing.canSwing = false
                    CreateThread(
                        function()
                            PlaySwingReleaseAnim()
                            Wait(200)
                            swingBall()
                        end
                    )
                    if Config.activateOxTarget then
                        DestroyMovingTarget()
                    end
                    Wait(1000)
                    ExitPlayingMode()
                    Wait(1000)
                    PlayerData.Objects.Ball.checkIfBallStopped = false
                end
            end
            if
                not PlayerData.Objects.Ball.checkIfBallStopped and
                IsEntityStopped(GetEntityVelocity(PlayerData.Objects.Ball.ballObject), Config.IsEntityStoppedCeil) and
                not PlayerData.Gameplay.Swing.isSwinging
            then
                FreezeEntityPosition(PlayerData.Objects.Ball.ballObject, true)
                PlayerData.Objects.Ball.ballPosition = GetEntityCoords(PlayerData.Objects.Ball.ballObject)
                PlayerData.Gameplay.Swing.canSwing = true
                PlayerData.Gameplay.Swing.swingPower = 0.0
                PlayerData.Gameplay.Swing.isMax = false
                PlayerData.Objects.Ball.checkIfBallStopped = true

                if #(PlayerData.Objects.Ball.ballPosition -
                        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[
                        PlayerData.GolfInfos.currentHole
                        ].holePos) < 0.2 then
                    displayBigMessage(parseText('end_turn_finished_hole_title'),
                        parseText('end_turn_finished_hole_message_1') ..
                        PlayerData.GolfInfos.currentHole ..
                        parseText('end_turn_finished_hole_message_2') ..
                        CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId]
                        .score[PlayerData.GolfInfos.currentHole] .. parseText('end_turn_finished_hole_message_3'),
                        Config.displayBigMessageDuration)
                    PlayerData.GolfInfos.hasFinishedHole =true
                    SetNextTurn(true)
                else
                    if Config.activateOxTarget then
                        CreateMovingTarget(1, PlayerData.Objects.Ball.ballPosition, "scriptifyer-golf:client:enterPlayingMode")
                    end
                    if CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId].score[PlayerData.GolfInfos.currentHole] + 1 > Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].maxShot then
                        PlayerData.GolfInfos.hasFinishedHole = true
                        TriggerEvent('scriptifyer-golf:client:finishedHole')
                        SetNextTurn(true)
                        displayBigMessage(parseText('end_turn_finished_hole_title'),
                            parseText('end_turn_finished_hole_message_1') ..
                            PlayerData.GolfInfos.currentHole ..
                            parseText('end_turn_finished_hole_message_2') ..
                            CurrentParties[PlayerOnlineData.Infos.partyId].Data.players
                            [PlayerOnlineData.Infos.localId].score[PlayerData.GolfInfos.currentHole] ..
                            parseText('end_turn_finished_hole_message_3'), Config.displayBigMessageDuration)

                        if #Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes >= PlayerData.GolfInfos.currentHole + 1 then
                            SwitchHole(PlayerData.GolfInfos.currentHole + 1)
                        end
                    else
                        SetNextTurn(false)
                    end
                end
            end
        end
    end
)

-- Functions
function StartGolf(f)
    PlayerData.States.isPlaying = true
    PlayerData.GolfInfos.golfCourseId = f
    PlayerData.GolfInfos.currentHole = 1
    CreateStartAndStopBlip(
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startPos,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos
    )
    TriggerEvent('scriptifyer-golf:client:startingGolf')
    if Config.activateOxTarget and Config.OxTargetConfig.flyByMode.activated then
        CreateMovingTarget(0, Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startPos, "scriptifyer-golf:client:initializeBall")
    end
end

function QuitGolf()
    if DoesEntityExist(PlayerData.Objects.Ball.ballObject) then
        DeleteObject(PlayerData.Objects.Ball.ballObject)
    end
    PlayerData = {
        States = { isPlaying = false, isInPlayerMode = false, isInFlybyMode = false, arrivedToCurrentHole = false },
        GolfInfos = { golfCourseId = nil, currentHole = 1, hasFinishedHole = false },
        Objects = {
            Ball = {
                ballPosition = vector3(0.0, 0.0, 0.0),
                ballPreviousPosition = vector3(0.0, 0.0, 0.0),
                ballObject = false,
                checkIfBallStopped = true
            },
            Club = {
                currentClubId = 1,
                clubObject = nil
            }
        },
        ui = {
            infos_scaleform = nil,
            golf_scaleform = nil,
            terrainGridActivated = false,
            currentMaterial = 7,
            currentMaterialLabel = nil,
            scoreboardDisplayed = false,
            mobileScoreboardDisplayed = false
        },
        Gameplay = {
            currentIncrement = 2,
            currentPar = 0,
            currentTaskPlaying = "",
            playerRotation = 0.0,
            Swing = { canSwing = true, isSwinging = false, swingPower = 0.0, isMax = false }
        },
        Stats = {}
    }
    DeleteProps()
    RemoveAllBlip()
    showSubtitle("", 0)
    TriggerEvent('scriptifyer-golf:client:endingGolf')
    if Config.activateOxTarget then
        DestroyMovingTarget()
    end
end

function SwitchHole(g)
    DeleteProps()
    if Config.activateOxTarget then
        DestroyMovingTarget()
    end
    RemoveAllBlip()
    if DoesEntityExist(PlayerData.Objects.Ball.ballObject) then
        DeleteObject(PlayerData.Objects.Ball.ballObject)
    end
    PlayerData = {
        States = { isPlaying = true, isInPlayerMode = false, isInFlybyMode = false, arrivedToCurrentHole = false },
        GolfInfos = { golfCourseId = PlayerData.GolfInfos.golfCourseId, currentHole = g, hasFinishedHole = true },
        Objects = {
            Ball = {
                ballPosition = vector3(0.0, 0.0, 0.0),
                ballPreviousPosition = vector3(0.0, 0.0, 0.0),
                ballObject = false,
                checkIfBallStopped = true
            },
            Club = {
                currentClubId = 1,
                clubObject = nil
            }
        },
        ui = {
            infos_scaleform = nil,
            golf_scaleform = nil,
            terrainGridActivated = false,
            currentMaterial = 7,
            currentMaterialLabel = nil,
            scoreboardDisplayed = false,
            mobileScoreboardDisplayed = false
        },
        Gameplay = {
            currentIncrement = 2,
            currentPar = 0,
            currentTaskPlaying = "",
            playerRotation = 0.0,
            Swing = { canSwing = true, isSwinging = false, swingPower = 0.0, isMax = false }
        },
        Stats = PlayerData.Stats
    }
    CreateStartAndStopBlip(
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startPos,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos
    )
    if Config.activateOxTarget and Config.OxTargetConfig.flyByMode.activated then
        CreateMovingTarget(0, Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startPos, "scriptifyer-golf:client:initializeBall")
    end
end


-- OLD FlyBy
--[[function CameraFlybyHole(g)
    PlayerData.States.isInFlybyMode = true
    FreezeEntityPosition(PlayerPedId(), true)
    local h = GetEntityCoords(PlayerPedId())
    local i =
        CreateCameraWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        h.x,
        h.y + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.y_retract,
        h.z + 2,
        0.0 + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.originBottomHeading,
        0.0,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.holeCamHeading,
        50.0,
        false,
        2
    )
    SetCamActive(i, true)
    RenderScriptCams(true, false, 1000, true, false, false)
    x_moy =
        (h.x + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.x) / 2 +
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.x_retract
    y_moy =
        (h.y + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.y) / 2 +
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.y_retract
    rot_x_moy =
        (Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.originBottomHeading - 90.0) / 2
    SetCamParams(
        i,
        x_moy,
        y_moy,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.z + 40 +
            Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.z_retract,
        rot_x_moy,
        0.0,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.holeCamHeading,
        62.5,
        5000,
        0,
        0,
        2
    )
    Wait(5000)
    SetCamParams(
        i,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.x,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.y,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos.z + 40,
        -90.0,
        0.0,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.holeCamHeading,
        75.0,
        5000,
        0,
        0,
        2
    )
    Wait(7000)
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(i, false)
    i = nil
    FreezeEntityPosition(PlayerPedId(), false)
    PlayerData.States.isInFlybyMode = false
end]]
function CameraFlybyHole(g)
    PlayerData.States.isInFlybyMode = true
    FreezeEntityPosition(PlayerPedId(), true)

    local flagCoords = Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].holePos
    local flagHeading = GetEntityHeading(PropsList[g]['flag'])
    local flagOffset = GetObjectOffsetFromCoords(flagCoords, flagHeading, 0.0, -5.0, 5.0)
    local playerOffset = GetObjectOffsetFromCoords(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), 2.0,
        0.0, 0.0)
    local middleOffset = (flagCoords + playerOffset) / 2

    local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', flagOffset, -30.0, 0.0, 0.0, 50.0, true, 2)
    local middleCam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA',
        middleOffset.x + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.x_retract,
        middleOffset.y + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.y_retract,
        middleOffset.z + Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].flyByParams.z_retract, 0.0, 0.0,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].startBallHeading + 90.0, 50.0, true, 2)
    local playerRelCam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', playerOffset, 0.0, 0.0,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[g].startBallHeading - 90.0, 50.0, true, 2)

    SetCamActiveWithInterp(middleCam, playerRelCam, 5000, 1000, 1000)
    RenderScriptCams(true, true, 1000, true, false, 0)
    while IsCamInterpolating(middleCam) do
        Wait(1)
    end
    SetCamActiveWithInterp(cam, middleCam, 5000, 1000, 1000)
    RenderScriptCams(true, true, 1000, true, false, 0)
    RenderScriptCams(true, true, 1000, true, false, 0)
    while IsCamInterpolating(cam) do
        Wait(1)
    end
    RenderScriptCams(false, true, 2000, true, false, 0)

    DestroyCam(cam)
    DestroyCam(playerRelCam)

    FreezeEntityPosition(PlayerPedId(), false)
    PlayerData.States.isInFlybyMode = false
end

function EnterPlayingMode()
    exports["sCore"]:setFreecamBypass(true)
    PlayerData.States.isInPlayerMode = true
    TriggerEvent('scriptifyer-golf:client:enteringPlayingMode')
    while PlayerData.States.isInFlybyMode do
        Wait(100)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityRotation(PlayerData.Objects.Ball.ballObject, 0.0, 0.0, 0.0, 0, true)
    SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, true)
    SetEntityHeading(
        PlayerData.Objects.Ball.ballObject,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].startBallHeading
    )
    PlaceObjectOnGroundProperly(PlayerData.Objects.Ball.ballObject)
    drawBlipsLine(GetEntityHeading(PlayerData.Objects.Ball.ballObject),
        GetEntityCoords(PlayerData.Objects.Ball.ballObject),
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos)
    SetMinimapGolfCourse(PlayerData.GolfInfos.currentHole)
    SetRadarZoom(
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].minimapPos.zoomMult
    )
    LockMinimapAngle(
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].minimapPos.angle
    )
    LockMinimapPosition(
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].minimapPos.x,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].minimapPos.y
    )
    Wait(5)


    SwitchClubModel()
    PlayerData.Gameplay.currentTaskPlaying = "idle"
    PlayerData.ui.scoreboardDisplayed = false
    PlayerData.ui.mobileScoreboardDisplayed = false
    exports["sCore"]:setFreecamBypass(false)

end

function ExitPlayingMode()
    DeleteObject(PlayerData.Objects.Club.clubObject)
    deleteBlipsLine()
    SetMinimapGolfCourseOff()
    UnlockMinimapAngle()
    UnlockMinimapPosition()
    SetRadarZoom(0)
    PlayerData.ui.infos_scaleform = nil
    PlayerData.ui.golf_scaleform = nil
    PlayerData.ui.terrainGridActivated = false
    DrawTerrainGrid(false)
    DetachEntity(PlayerPedId(), true, true)
    FreezeEntityPosition(PlayerPedId(), false)
    PlayerData.States.isInPlayerMode = false
    TriggerEvent('scriptifyer-golf:client:exitingPlayingMode')
    EndAllAnim()
end

function SwitchClubModel()
    DeleteObject(PlayerData.Objects.Club.clubObject)
    if not HasModelLoaded(Config.ClubList[PlayerData.Objects.Club.currentClubId].model) then
        RequestModel(Config.ClubList[PlayerData.Objects.Club.currentClubId].model)
        while not HasModelLoaded(Config.ClubList[PlayerData.Objects.Club.currentClubId].model) do
            Wait(5)
        end
    end
    print(('^2[NETDIAG][OBJET]^7 %s client.lua:878 CreateObjectNoOffset NETWORKED golf-club'):format(GetCurrentResourceName()))
    PlayerData.Objects.Club.clubObject =
        CreateObjectNoOffset(
            Config.ClubList[PlayerData.Objects.Club.currentClubId].model,
            GetEntityCoords(PlayerPedId()),
            true,
            true,
            false
        )
    AttachEntityToEntity(
        PlayerData.Objects.Club.clubObject,
        PlayerPedId(),
        GetPedBoneIndex(PlayerPedId(), 28422),
        0.0,
        0.0,
        0.0,
        2.5,
        0.0,
        0.0,
        false,
        false,
        false,
        false,
        2,
        true
    )
    Wait(15)
    AttachEntityToEntity(
        PlayerPedId(),
        PlayerData.Objects.Ball.ballObject,
        0,
        Config.ClubList[PlayerData.Objects.Club.currentClubId].PositionOffset,
        0.0,
        0.0,
        0.0,
        false,
        false,
        false,
        false,
        1,
        true
    )
end

function rotatePlayer(j)
    if j == 0 then
        SetEntityHeading(
            PlayerData.Objects.Ball.ballObject,
            GetEntityHeading(PlayerData.Objects.Ball.ballObject) +
            Config.TurnIncrements[PlayerData.Gameplay.currentIncrement]
        )
        drawBlipsLine(GetEntityHeading(PlayerData.Objects.Ball.ballObject),
            GetEntityCoords(PlayerData.Objects.Ball.ballObject),
            Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos)
    else
        SetEntityHeading(
            PlayerData.Objects.Ball.ballObject,
            GetEntityHeading(PlayerData.Objects.Ball.ballObject) -
            Config.TurnIncrements[PlayerData.Gameplay.currentIncrement]
        )
        drawBlipsLine(GetEntityHeading(PlayerData.Objects.Ball.ballObject),
            GetEntityCoords(PlayerData.Objects.Ball.ballObject),
            Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos)
    end
end

function ChangeTurnIncrement()
    if Config.TurnIncrements[PlayerData.Gameplay.currentIncrement + 1] ~= nil then
        PlayerData.Gameplay.currentIncrement = PlayerData.Gameplay.currentIncrement + 1
    else
        PlayerData.Gameplay.currentIncrement = 1
    end
end

function swingBall()
    if PlayerData.Objects.Ball.ballObject ~= nil then
        if not IsEntityInAir(PlayerData.Objects.Ball.ballObject) then
            DetachEntity(PlayerPedId(), true, true)
            FreezeEntityPosition(PlayerData.Objects.Ball.ballObject, false)
            local k = GetEntityCoords(PlayerData.Objects.Ball.ballObject)
            PlayerData.Objects.Ball.ballPreviousPosition = k
            local c = GetObjectOffsetFromCoords(k, GetEntityHeading(PlayerData.Objects.Ball.ballObject), 15.0, 0.0, 0.0)
            local l = (k - c) / 10
            SetObjectPhysicsParams(
                PlayerData.Objects.Ball.ballObject,
                -1.0,
                -1.0,
                0.0,
                0.0,
                0.01,
                -1.0,
                -1.0,
                -1.0,
                -1.0,
                -1.0,
                -1.0
            )
            local m =
                Config.ClubList[PlayerData.Objects.Club.currentClubId].power * PlayerData.Gameplay.Swing.swingPower
            local n =
                Config.ClubList[PlayerData.Objects.Club.currentClubId].power * PlayerData.Gameplay.Swing.swingPower
            local o = 0.0
            if PlayerData.Objects.Club.currentClubId >= 2 then
                o = Config.ClubList[PlayerData.Objects.Club.currentClubId].power * PlayerData.Gameplay.Swing.swingPower
            end
            local h = GetEntityCoords(PlayerPedId())
            local p = StartShapeTestCapsule(h, h + vector3(0.0, 0.0, -1.0), 1.5, 145, PlayerPedId(), 4)
            local q, r, s, t, materialId = GetShapeTestResultIncludingMaterial(p)
            for a, b in pairs(TerrainMaterials) do
                if b[materialId] ~= nil then
                    RequestScriptAudioBank("GOLF_I", 0)
                    RequestScriptAudioBank("GOLF_2", 0)
                    RequestScriptAudioBank("GOLF_3", 0)
                    PlaySoundFromEntity(-1, b[materialId].swingSfx, PlayerPedId(), 0, true, 0)
                end
            end
            ApplyForceToEntity(
                PlayerData.Objects.Ball.ballObject,
                1,
                l.x * m,
                l.y * n,
                o,
                0.0,
                0.0,
                0.0,
                0,
                false,
                false,
                true,
                false,
                true
            )
            PlayerData.Gameplay.currentPar = PlayerData.Gameplay.currentPar + 1
        end
    end
end

function applyGroundForceOnBall(materialId)
    local u = -3 * GetEntityVelocity(PlayerData.Objects.Ball.ballObject)
    for a, b in pairs(TerrainMaterials) do
        if b[materialId] ~= nil then
            PlayerData.ui.currentMaterial = b[materialId].ui_mat
            PlayerData.ui.currentMaterialLabel = b[materialId].ui_label
            ApplyForceToEntity(
                PlayerData.Objects.Ball.ballObject,
                0,
                u.x * b[materialId].x_mult,
                u.y * b[materialId].y_mult,
                u.z * b[materialId].z_mult,
                0.0,
                0.0,
                0.0,
                0,
                false,
                false,
                true,
                false,
                true
            )
            PlayBallSound(b[materialId])
        end
    end
end

function ReplaceBallToPreviousPosition(v)
    SetEntityCoords(PlayerData.Objects.Ball.ballObject, PlayerData.Objects.Ball.ballPreviousPosition)
    SetEntityVelocity(PlayerData.Objects.Ball.ballObject, 0.0, 0.0, 0.0)
    FreezeEntityPosition(PlayerData.Objects.Ball.ballPosition, true)
    showNotification(v.label, 6, true, true)
end

-- UI Functions

function setupInformationsScaleform()
    local w = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(w) do
        Citizen.Wait(0)
    end
    DrawScaleformMovieFullscreen(w, 255, 255, 255, 0, 0)
    PushScaleformMovieFunction(w, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, Config.Keys['playingMode'].key, true))
    ButtonMessage(parseText("scaleform_quit"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, Config.Keys['switchClub'].key, true))
    ButtonMessage(parseText("switch_club"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, Config.Keys['rotateRight'].key, true))
    ButtonMessage(parseText("scaleform_turn_right"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, Config.Keys['rotateLeft'].key, true))
    ButtonMessage(parseText("scaleform_turn_left"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, Config.Keys['changeIncrement'].key, true))
    ButtonMessage(
        parseText("scaleform_turn_increment") ..
        "(" .. Config.TurnIncrements[PlayerData.Gameplay.currentIncrement] .. ")"
    )
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, Config.Keys['terrainGrid'].key, true))
    ButtonMessage(parseText("terrain_grid"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(6)
    Button(GetControlInstructionalButton(2, Config.Keys['scoreboard'].key, true))
    ButtonMessage(parseText("scoreboard"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(7)
    Button(GetControlInstructionalButton(2, Config.Keys['swing'].key, true))
    ButtonMessage(parseText("swing"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(w, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return w
end

function setupGolfScaleform()
    local w = RequestScaleformMovie("golf")
    local q = RequestScaleformMovie("SC_LEADERBOARD")
    local r = RequestScaleformMovie("mp_mm_card_freemode")
    local s = RequestScaleformMovie("golf_floating_ui")
    local x = RequestStreamedTextureDict("GolfPutting", true)
    while not HasStreamedTextureDictLoaded(x) and not HasScaleformMovieLoaded(w) and not HasScaleformMovieLoaded(q) and
        not HasScaleformMovieLoaded(r) and
        not HasScaleformMovieLoaded(s) do
        Citizen.Wait(0)
    end
    BeginScaleformMovieMethod(w, "SET_HOLE_DISPLAY")
    ScaleformMovieMethodAddParamPlayerNameString(parseText("hole") .. " " .. PlayerData.GolfInfos.currentHole)
    ScaleformMovieMethodAddParamPlayerNameString(
        parseText("par") ..
        " " .. Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].par
    )
    ScaleformMovieMethodAddParamPlayerNameString(
        math.ceil(
            #(GetEntityCoords(PlayerData.Objects.Ball.ballObject) -
                Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole].holePos)
        ) .. " m"
    )
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(w, "SET_SWING_DISPLAY")
    ScaleformMovieMethodAddParamInt(47)
    ScaleformMovieMethodAddParamPlayerNameString(PlayerData.ui.currentMaterialLabel or "")
    ScaleformMovieMethodAddParamInt(PlayerData.ui.currentMaterial)
    ScaleformMovieMethodAddParamPlayerNameString(parseText("wind"))
    local floatDir = 1.0
    if Config.Wind.activated then
        local windDir = GetWindDirection()
        floatDir = (math.atan2(windDir.y, windDir.x) + math.pi / 2) * (180 / math.pi)
    end
    ScaleformMovieMethodAddParamFloat(floatDir)
    ScaleformMovieMethodAddParamPlayerNameString(parseText('club'))
    ScaleformMovieMethodAddParamInt(PlayerData.Objects.Club.currentClubId)
    ScaleformMovieMethodAddParamPlayerNameString(Config.ClubList[PlayerData.Objects.Club.currentClubId].label)
    ScaleformMovieMethodAddParamBool(true)
    ScaleformMovieMethodAddParamPlayerNameString("SPIN")
    ScaleformMovieMethodAddParamFloat(1.0)
    ScaleformMovieMethodAddParamFloat(1.0)
    ScaleformMovieMethodAddParamPlayerNameString(parseText("coup") .. " " .. PlayerData.Gameplay.currentPar + 1)
    EndScaleformMovieMethod()



    if CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil and PlayerData.ui.scoreboardDisplayed then
        BeginScaleformMovieMethod(w, "SET_SCOREBOARD_TITLE")
        ScaleformMovieMethodAddParamPlayerNameString(CurrentParties[PlayerOnlineData.Infos.partyId].Infos.name)
        ScaleformMovieMethodAddParamPlayerNameString(parseText("hole"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("par"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("score"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("holeInOne"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("underPar"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("overPar"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("1st"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("2nd"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("3rd"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("4th"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("5th"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("6th"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("7th"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("8th"))
        ScaleformMovieMethodAddParamPlayerNameString(parseText("9th"))
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(w, "COURSE_PAR")
        for a, b in pairs(Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes) do
            ScaleformMovieMethodAddParamInt(b.par)
        end
        ScaleformMovieMethodAddParamInt(Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].par)
        EndScaleformMovieMethod()
    end
    if CurrentParties[PlayerOnlineData.Infos.partyId] ~= nil then
        for a, b in pairs(CurrentParties[PlayerOnlineData.Infos.partyId].Data.players) do
            BeginScaleformMovieMethod(w, "SET_PLAYERCARD_SLOT")
            ScaleformMovieMethodAddParamInt(b.golfId - 1)
            ScaleformMovieMethodAddParamInt(2)
            ScaleformMovieMethodAddParamPlayerNameString(b.name)
            ScaleformMovieMethodAddParamPlayerNameString("CCCC")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamInt(1)
            ScaleformMovieMethodAddParamInt(b.score[b.currentHole])
            ScaleformMovieMethodAddParamInt(2)
            EndScaleformMovieMethod()
            if PlayerData.ui.scoreboardDisplayed then
                BeginScaleformMovieMethod(w, "SET_SCOREBOARD_SLOT")
                ScaleformMovieMethodAddParamInt(b.golfId - 1)
                if not b.isPlaying then
                    ScaleformMovieMethodAddParamInt(2)
                else
                    ScaleformMovieMethodAddParamInt(1)
                end
                ScaleformMovieMethodAddParamPlayerNameString(b.name)
                ScaleformMovieMethodAddParamPlayerNameString("CCCC")
                ScaleformMovieMethodAddParamPlayerNameString(parseText("readyStr"))
                ScaleformMovieMethodAddParamInt(1)
                ScaleformMovieMethodAddParamInt(calcScore(b.score))
                ScaleformMovieMethodAddParamInt(1)
                ScaleformMovieMethodAddParamInt(b.score[1])
                ScaleformMovieMethodAddParamInt(b.score[2])
                ScaleformMovieMethodAddParamInt(b.score[3])
                ScaleformMovieMethodAddParamInt(b.score[4])
                ScaleformMovieMethodAddParamInt(b.score[5])
                ScaleformMovieMethodAddParamInt(b.score[6])
                ScaleformMovieMethodAddParamInt(b.score[7])
                ScaleformMovieMethodAddParamInt(b.score[8])
                ScaleformMovieMethodAddParamInt(b.score[9])
                EndScaleformMovieMethod()
            end
        end
    end
    BeginScaleformMovieMethod(w, "SET_DISPLAY")
    if PlayerData.ui.scoreboardDisplayed then
        ScaleformMovieMethodAddParamInt(27)
    else
        ScaleformMovieMethodAddParamInt(11)
    end
    EndScaleformMovieMethod()
    if PlayerData.Gameplay.Swing.isSwinging then
        BeginScaleformMovieMethod(w, "SWING_METER_TRANSITION_IN")
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(w, "SWING_METER_POSITION")
        ScaleformMovieMethodAddParamFloat(0.70)
        ScaleformMovieMethodAddParamFloat(0.50)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(w, "SWING_METER_SET_FILL")
        ScaleformMovieMethodAddParamBool(true)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(w, "SWING_METER_SET_MARKER")
        ScaleformMovieMethodAddParamBool(true)
        ScaleformMovieMethodAddParamFloat(PlayerData.Gameplay.Swing.swingPower)
        ScaleformMovieMethodAddParamBool(false)
        EndScaleformMovieMethod()
    else
        BeginScaleformMovieMethod(w, "SWING_METER_TRANSITION_OUT")
        EndScaleformMovieMethod()
    end
    return w
end

function setupScoreboardScaleform()
    local w = RequestScaleformMovie("golf")
    local q = RequestScaleformMovie("SC_LEADERBOARD")
    local x = RequestStreamedTextureDict("GolfPutting", true)
    while not HasStreamedTextureDictLoaded(x) and not HasScaleformMovieLoaded(w) and not HasScaleformMovieLoaded(q) and
        not HasScaleformMovieLoaded(r) and
        not HasScaleformMovieLoaded(s) do
        Citizen.Wait(0)
    end
    BeginScaleformMovieMethod(w, "SET_DISPLAY")
    ScaleformMovieMethodAddParamInt(16)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(w, "SWING_METER_TRANSITION_OUT")
        EndScaleformMovieMethod()

    BeginScaleformMovieMethod(w, "SET_SCOREBOARD_TITLE")
    ScaleformMovieMethodAddParamPlayerNameString(CurrentParties[PlayerOnlineData.Infos.partyId].Infos.name)
    ScaleformMovieMethodAddParamPlayerNameString(parseText("hole"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("par"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("score"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("holeInOne"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("underPar"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("overPar"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("1st"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("2nd"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("3rd"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("4th"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("5th"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("6th"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("7th"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("8th"))
    ScaleformMovieMethodAddParamPlayerNameString(parseText("9th"))
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(w, "COURSE_PAR")
    for a, b in pairs(Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes) do
        ScaleformMovieMethodAddParamInt(b.par)
    end
    ScaleformMovieMethodAddParamInt(Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].par)
    EndScaleformMovieMethod()

    for a, b in pairs(CurrentParties[PlayerOnlineData.Infos.partyId].Data.players) do
        BeginScaleformMovieMethod(w, "SET_SCOREBOARD_SLOT")
        ScaleformMovieMethodAddParamInt(b.golfId - 1)
        if not b.isPlaying then
            ScaleformMovieMethodAddParamInt(2)
        else
            ScaleformMovieMethodAddParamInt(1)
        end
        ScaleformMovieMethodAddParamPlayerNameString(b.name)
        ScaleformMovieMethodAddParamPlayerNameString("CCCC")
        ScaleformMovieMethodAddParamPlayerNameString(parseText("readyStr"))
        ScaleformMovieMethodAddParamInt(1)
        ScaleformMovieMethodAddParamInt(calcScore(b.score))
        ScaleformMovieMethodAddParamInt(1)
        ScaleformMovieMethodAddParamInt(b.score[1])
        ScaleformMovieMethodAddParamInt(b.score[2])
        ScaleformMovieMethodAddParamInt(b.score[3])
        ScaleformMovieMethodAddParamInt(b.score[4])
        ScaleformMovieMethodAddParamInt(b.score[5])
        ScaleformMovieMethodAddParamInt(b.score[6])
        ScaleformMovieMethodAddParamInt(b.score[7])
        ScaleformMovieMethodAddParamInt(b.score[8])
        ScaleformMovieMethodAddParamInt(b.score[9])
        EndScaleformMovieMethod()
    end
    return w
end

function DrawTerrainGrid(y)
    if y then
        local z = GetEntityCoords(PlayerPedId())
        local d, e = GetGroundZAndNormalFor_3dCoord(z.x, z.y, z.z)
        TerraingridActivate(true)
        TerraingridSetParams(z, -1.0, 0.5, 0.0, 200.0, 200.0, -1.0, 350.0, 40.0, e, 0.2)
        TerraingridSetColours(255, 0, 0, 64, 255, 255, 255, 5, 255, 255, 0, 64)
    else
        TerraingridActivate(false)
    end
end

-- Animations

function PlayIdlingAnim()
    LoadAnimDict(PlayerData.Objects.Club.currentClubId, "idle")
    if
        not IsEntityPlayingAnim(
            PlayerPedId(),
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["idle"].animDict,
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["idle"].anim,
            3
        )
    then
        TaskPlayAnim(
            PlayerPedId(),
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["idle"].animDict,
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["idle"].anim,
            8.0,
            -1000.0,
            -1,
            33,
            0.0,
            false,
            false,
            false
        )
    end
end

function PlaySwingIntroAnim()
    LoadAnimDict(PlayerData.Objects.Club.currentClubId, "swing_i")
    ClearPedTasksImmediately(PlayerPedId())
    if
        not IsEntityPlayingAnim(
            PlayerPedId(),
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].animDict,
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].anim,
            3
        )
    then
        TaskPlayAnim(
            PlayerPedId(),
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].animDict,
            Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].anim,
            8.0,
            -1000.0,
            -1,
            33,
            0.0,
            false,
            false,
            false
        )
    end

    CreateThread(
        function()
            while PlayerData.Gameplay.Swing.isSwinging do
                local H = PlayerData.Gameplay.Swing.swingPower
                Wait(0)
                if H > 0.95 then
                    H = 0.95
                end
                SetEntityAnimCurrentTime(
                    PlayerPedId(),
                    Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].animDict,
                    Config.ClubList[PlayerData.Objects.Club.currentClubId].anim["swing_i"].anim,
                    H
                )
            end
        end
    )
end

function PlaySwingReleaseAnim()
    local I = true
    local J = "swing_min"
    if PlayerData.Gameplay.Swing.swingPower > 0.6 then
        J = "swing_max"
    end
    LoadAnimDict(PlayerData.Objects.Club.currentClubId, J)
    local K = Config.ClubList[PlayerData.Objects.Club.currentClubId].anim[J].anim
    ClearPedTasksImmediately(PlayerPedId())
    TaskPlayAnim(
        PlayerPedId(),
        Config.ClubList[PlayerData.Objects.Club.currentClubId].anim[J].animDict,
        K,
        8.0,
        -1,
        -1,
        0,
        1,
        false,
        false,
        false
    )
    CreateThread(
        function()
            while I do
                Wait(1)
                SetEntityAnimCurrentTime(
                    PlayerPedId(),
                    Config.ClubList[PlayerData.Objects.Club.currentClubId].anim[J].animDict,
                    K,
                    0.0
                )
            end
        end
    )
    Wait(150)
    I = false
end

function EndAllAnim()
    ClearPedTasksImmediately(PlayerPedId())
    PlayerData.Gameplay.currentTaskPlaying = ""
end

function PlayBallSound(L)
    if L.sfx ~= nil then
        RequestScriptAudioBank("GOLF_I", 0)
        RequestScriptAudioBank("GOLF_2", 0)
        RequestScriptAudioBank("GOLF_3", 0)
        PlaySoundFromEntity(-1, L.sfx, PlayerData.Objects.Ball.ballObject, 0, true, 0)
        PlaySoundFromCoord(-1, sfx, GetEntityCoords(PlayerData.Objects.Ball.ballObject), 0, true, 40.0, false)
    end
end

AddEventHandler('scriptifyer-golf:client:openMenu', function()
    OpenGolfMenu()
end)

AddEventHandler('scriptifyer-golf:client:closeMenu', function()
    CloseGolfMenu()
end)

AddEventHandler('scriptifyer-golf:client:initializeBall', function()
    PlayerData.GolfInfos.hasFinishedHole = false
    PlayerData.States.arrivedToCurrentHole = true
    PlayerData.ui.mobileScoreboardDisplayed =false
    PlayerData.Objects.Ball.ballPosition =
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole]
        .startPos
    showSubtitle("", 0)
    SpawnProps(PlayerData.GolfInfos.golfCourseId, PlayerData.GolfInfos.currentHole)
    if not HasModelLoaded(Config.Props.ball) then
        RequestModel(Config.Props.ball)
        while not HasModelLoaded(Config.Props.ball) do
            Wait(5)
        end
    end
    print(('^2[NETDIAG][OBJET]^7 %s client.lua:1489 CreateObjectNoOffset NETWORKED golf-ball'):format(GetCurrentResourceName()))
    PlayerData.Objects.Ball.ballObject =
        CreateObjectNoOffset(
            Config.Props.ball,
            PlayerData.Objects.Ball.ballPosition.x,
            PlayerData.Objects.Ball.ballPosition.y,
            PlayerData.Objects.Ball.ballPosition.z,
            true,
            false,
            true
        )
    FreezeEntityPosition(PlayerData.Objects.Ball.ballObject, true)
    SetEntityHasGravity(PlayerData.Objects.Ball.ballObject, true)
    SetEntityRecordsCollisions(PlayerData.Objects.Ball.ballObject, true)
    SetEntityVelocity(PlayerData.Objects.Ball.ballObject, 0.0, 0.0, 0.0)
    PlaceObjectOnGroundProperly(PlayerData.Objects.Ball.ballObject)
    SetEntityHeading(
        PlayerData.Objects.Ball.ballObject,
        Config.GolfCourse[PlayerData.GolfInfos.golfCourseId].holes[PlayerData.GolfInfos.currentHole]
        .startBallHeading
    )
    CreateBallBlip(PlayerData.Objects.Ball.ballObject)
    if Config.FlyByActivated then
        CameraFlybyHole(PlayerData.GolfInfos.currentHole)
    else
        EnterPlayingMode()
    end
    if Config.activateOxTarget then
        DestroyMovingTarget()
        CreateMovingTarget(1, PlayerData.Objects.Ball.ballPosition, "scriptifyer-golf:client:enterPlayingMode")
    end

end)

AddEventHandler('scriptifyer-golf:client:enterPlayingMode', function ()
    EnterPlayingMode()
end)