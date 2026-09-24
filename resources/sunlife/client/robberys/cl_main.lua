ROBBERYS = {
    robbing = false,
    currentRobId = nil,

    activeRaid = {
        active = false,

        timerActive = false,
        timerEndAt = 0,
        timerTotal = 0,
        timerDone = false,

        doorsToOpen = {},
        lootSpots = {},
    },

    timerActive = false,
    timerEnd = 0,
    timerTotal = 0,
}

local function _format_mmss(msLeft)
    local totalSec = math.max(0, math.floor(msLeft / 1000))
    local minutes = totalSec // 60
    local seconds = totalSec % 60
    return string.format("%02d:%02d", minutes, seconds)
end

local function Raid_StopTimerBar()
    ROBBERYS.activeRaid.timerActive = false
    ROBBERYS.activeRaid.timerEndAt = 0
    ROBBERYS.activeRaid.timerTotal = 0
end

local function Raid_OpenVaultDoors()
    if not ROBBERYS.activeRaid.doorsToOpen then return end
    if #ROBBERYS.activeRaid.doorsToOpen <= 0 then return end

    TriggerServerEvent("robberys:syncDoors", ROBBERYS.activeRaid.doorsToOpen)

    for _, doorData in pairs(ROBBERYS.activeRaid.doorsToOpen) do
        local doorEntity = GetClosestObjectOfType(
            doorData.objCoords.x,
            doorData.objCoords.y,
            doorData.objCoords.z,
            1.0,
            doorData.objName,
            false, false, false
        )
        if doorEntity then
            if not NetworkHasControlOfEntity(doorEntity) then
                NetworkRequestControlOfEntity(doorEntity)
            end
            FreezeEntityPosition(doorEntity, false)
            if doorData.objNewHeading then
                SetEntityHeading(doorEntity, doorData.objNewHeading)
            end
        end
    end
end

local function Raid_LockVaultDoors()
    if not ROBBERYS.activeRaid.doorsToOpen then return end
    if #ROBBERYS.activeRaid.doorsToOpen <= 0 then return end

    for _, doorData in ipairs(ROBBERYS.activeRaid.doorsToOpen) do
        local doorEntity = GetClosestObjectOfType(
            doorData.objCoords.x,
            doorData.objCoords.y,
            doorData.objCoords.z,
            1.0,
            doorData.objName,
            false, false, false
        )
        if doorEntity then
            if not NetworkHasControlOfEntity(doorEntity) then
                NetworkRequestControlOfEntity(doorEntity)
            end
            if doorData.objYaw then
                SetEntityHeading(doorEntity, doorData.objYaw)
            end
            FreezeEntityPosition(doorEntity, true)
        end
    end
end

local function Raid_StartTimerBar(durationMs, robberyLabel)
    ROBBERYS.activeRaid.timerActive = true
    ROBBERYS.activeRaid.timerDone = false
    ROBBERYS.activeRaid.timerTotal = durationMs
    ROBBERYS.activeRaid.timerEndAt = GetGameTimer() + durationMs

    Citizen.CreateThread(function()
        local alreadyAnnouncedOpen = false

        local function measureText(txt, scale, font)
            SetTextFont(font)
            SetTextScale(scale, scale)

            BeginTextCommandWidth("STRING")
            AddTextComponentString(txt)
            local width = EndTextCommandGetWidth(font)
            local height = GetTextScaleHeight(scale, font)
            return width, height
        end

        while ROBBERYS.activeRaid.active
        and ROBBERYS.robbing
        and ROBBERYS.activeRaid.timerActive do

            Citizen.Wait(0)

            local now = GetGameTimer()
            local left = ROBBERYS.activeRaid.timerEndAt - now
            local total = ROBBERYS.activeRaid.timerTotal

            if left <= 0 then
                ROBBERYS.activeRaid.timerActive = false
                ROBBERYS.activeRaid.timerDone = true

                Raid_StopTimerBar()
                Raid_OpenVaultDoors()

                if not alreadyAnnouncedOpen then
                    alreadyAnnouncedOpen = true
                    lib.notify({
                        title = 'Coffre ouvert',
                        description = "Coffre percé ! Prenez le butin !",
                        type = 'success',
                        position = 'top',
                        duration = 8000,
                    })
                end
                break
            end

            local pct = left / total
            if pct < 0.0 then pct = 0.0 end
            if pct > 1.0 then pct = 1.0 end

            local baseX = 0.90
            local barY  = 0.90
            local w     = 0.16
            local h     = 0.020
            local leftX = baseX - (w / 2.0)

            local timeTxt   = _format_mmss(left)
            local timeScale = 0.40
            local timeFont  = 0

            local timeW, timeH = measureText(timeTxt, timeScale, timeFont)

            local timeTextX = baseX - (timeW / 2.0)
            local timeTextY = barY - (h / 2.0) - (timeH / 2.0) - 0.020

            SetTextFont(timeFont)
            SetTextScale(timeScale, timeScale)
            SetTextColour(255, 255, 255, 255)

            SetTextCentre(false)

            BeginTextCommandDisplayText("STRING")
            AddTextComponentString(timeTxt)
            EndTextCommandDisplayText(timeTextX, timeTextY)

            DrawRect(
                baseX,
                barY,
                w,
                h,
                0, 0, 0, 180
            )

            local fillW = w * pct
            local fillCenterX = leftX + (fillW / 2.0)

            DrawRect(
                fillCenterX,
                barY,
                fillW,
                h * 0.6,
                200, 40, 40, 220
            )

            if robberyLabel then
                local raidScale = 0.40
                local raidFont  = 0

                local raidW, raidH = measureText(robberyLabel, raidScale, raidFont)

                local raidTextX = baseX - (raidW / 2.0)
                local raidTextY = barY + (h / 2.0) + 0.010

                SetTextFont(raidFont)
                SetTextScale(raidScale, raidScale)
                SetTextColour(255, 255, 255, 200)

                SetTextCentre(false)

                BeginTextCommandDisplayText("STRING")
                AddTextComponentString(robberyLabel)
                EndTextCommandDisplayText(raidTextX, raidTextY)
            end
        end
    end)
end

local function PlayLootSequenceForStep(step)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityHeading(PlayerPedId(), step.heading or GetEntityHeading(PlayerPedId()))

    if step.IsGettinCash == true then
        local playerPed = PlayerPedId()
        local animDict = 'anim@heists@ornate_bank@grab_cash_heels'
        local animName = 'grab'

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
        Citizen.Wait(7000)
        ClearPedTasks(playerPed)

    elseif step.IsDrilling == true then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local prop_name = 'hei_prop_heist_drill'
        local boneIndex = GetPedBoneIndex(playerPed, 57005)

        TriggerEvent("sound:play", "drill", 0.5)

        RequestAnimDict('anim@heists@fleeca_bank@drilling')
        RequestModel(GetHashKey(prop_name))
        while (not HasAnimDictLoaded('anim@heists@fleeca_bank@drilling')) or (not HasModelLoaded(GetHashKey(prop_name))) do
            Citizen.Wait(0)
        end

        PlaySoundFrontend(-1, "Drill", "Bank_Heist_Sounds", 0)

        print(('^2[NETDIAG][OBJET]^7 %s cl_main.lua:253 CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(prop_name)))
        local prop = CreateObject(GetHashKey(prop_name), coords.x, coords.y, coords.z, true, true, true)
        AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.0, -0.05, 100.0, 280.0, 180.0, true, true, false, true, 1, true)

        TaskPlayAnim(playerPed, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
        Citizen.Wait(7000)

        StopAnimTask(playerPed, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 1.0)
        DeleteObject(prop)
        RemoveAnimDict('anim@heists@fleeca_bank@drilling')
        SetModelAsNoLongerNeeded(GetHashKey(prop_name))

    elseif step.IsCrackingGlass == true then
        local playerPed = PlayerPedId()
        local animDict = 'missheist_jewel'
        local animName = 'smash_case'

        PlaySoundFrontend(-1, "Glass_Smash", "", 0)

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, animDict, animName, 3.0, 1.0, -1, 2, 0, false, false, false)
        Citizen.Wait(7000)
        ClearPedTasks(playerPed)

    elseif step.OpenSafe == true then
        local playerPed = PlayerPedId()
        RequestAnimDict('mini@safe_cracking')
        while not HasAnimDictLoaded('mini@safe_cracking') do
            Citizen.Wait(0)
        end
        TaskPlayAnim(playerPed, 'mini@safe_cracking', 'idle_base', 8.0, -8.0, -1, 32, 0, false, false, false)
        Citizen.Wait(7000)
        ClearPedTasks(playerPed)

    elseif step.TraficCables == true then
        local playerPed = PlayerPedId()
        local animDict = 'amb@prop_human_movie_bulb@base'
        local animName = 'base'

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
        Citizen.Wait(7000)
        ClearPedTasks(playerPed)
    end

    PlaySoundFrontend(-1, "ROBBERY_MONEY_TOTAL", "HUD_FRONTEND_CUSTOM_SOUNDSET", 0)

    FreezeEntityPosition(PlayerPedId(), false)
end

ROBBERYS.startUnified = function(robId)
    if not robId then return end

    local robberyInfo = nil
    local robberyLabel = "Braquage"
    for name, data in pairs(cfg_robberys["list"]) do
        if data.id == robId then
            robberyInfo = data
            robberyLabel = name
            break
        end
    end

    if not robberyInfo then
        print("[ROBBERYS.startUnified] Braquage introuvable, ID:", robId)
        return
    end

    lib.notify({
        title = 'Braquage lancé',
        description = "Le courant vient de sauter. Accédez à la salle forte.",
        type = 'success',
        position = 'top',
        duration = 8000,
    })

    ROBBERYS.robbing = true
    ROBBERYS.currentRobId = robId

    ROBBERYS.activeRaid.active = true
    ROBBERYS.activeRaid.timerDone = false
    ROBBERYS.activeRaid.timerActive = false
    ROBBERYS.activeRaid.timerEndAt = 0
    ROBBERYS.activeRaid.timerTotal = 0

    ROBBERYS.activeRaid.doorsToOpen = {}
    ROBBERYS.activeRaid.lootSpots = {}

    for idx, step in ipairs(robberyInfo.steps) do
        if step.doors then
            for _, doorData in ipairs(step.doors) do
                table.insert(ROBBERYS.activeRaid.doorsToOpen, doorData)
            end
        end
    end

    Raid_LockVaultDoors()

    for idx, step in ipairs(robberyInfo.steps) do
        if step.reward then
            table.insert(ROBBERYS.activeRaid.lootSpots, {
                stepIndex = idx,
                stepRef = step,
                done = false,
            })
        end
    end

    Raid_StartTimerBar(8 * 60 * 1000, robberyLabel)

    Citizen.CreateThread(function()
        local finishedNotified = false

        while ROBBERYS.activeRaid.active and ROBBERYS.robbing do
            local wait = 1000
            local pedCoords = GetEntityCoords(PlayerPedId())

            local allLooted = true

            if not ROBBERYS.activeRaid.timerDone then
                for _, doorData in ipairs(ROBBERYS.activeRaid.doorsToOpen) do
                    local doorPos = vector3(
                        doorData.objCoords.x,
                        doorData.objCoords.y,
                        doorData.objCoords.z
                    )

                    local distDoor = #(pedCoords - doorPos)
                    if distDoor < 15.0 then
                        wait = 0
                        if distDoor < 1.8 then
                            ESX.ShowHelpNotification("Le coffre est en train d'être percé... Patientez, les portes vont s'ouvrir.")
                        end
                    end
                end
            end

            for k, lootData in ipairs(ROBBERYS.activeRaid.lootSpots) do
                if not lootData.done then
                    allLooted = false

                    local step = lootData.stepRef
                    local dist = #(pedCoords - step.pos)

                    if dist < 15.0 then
                        wait = 0

                        DrawMarker(
                            0,
                            step.pos.x, step.pos.y, step.pos.z,
                            0.0,0.0,0.0,
                            0.0,0.0,0.0,
                            1.0,1.0,1.0,
                            255,225,0,100,
                            false,false,2,
                            nil,nil,false
                        )

                        if dist < (step.dst or 1.5) then
                            if not ROBBERYS.activeRaid.timerDone then
                                ESX.ShowHelpNotification("Le coffre est en train d'être percé... Patientez.")
                            else
                                ESX.ShowHelpNotification("~INPUT_CONTEXT~ » Récupérer le butin: "..(step.name or "Coffre"))
                                if IsControlJustPressed(0, 38) then
                                    PlayLootSequenceForStep(step)

                                    TriggerServerEvent(
                                        "robberys:rewardStep",
                                        robId,
                                        lootData.stepIndex
                                    )

                                    lootData.done = true

                                    lib.notify({
                                        title = 'Butin récupéré',
                                        description = "Passez au coffre suivant !",
                                        type = 'success',
                                        position = 'top',
                                        duration = 6000,
                                    })
                                end
                            end
                        end
                    end
                end
            end

            if allLooted and not finishedNotified and ROBBERYS.activeRaid.timerDone then
                finishedNotified = true

                lib.notify({
                    title = 'Braquage terminé',
                    description = "Tout a été vidé. Dégagez de là.",
                    type = 'success',
                    position = 'top',
                    duration = 8000,
                })

                TriggerServerEvent("robberys:finish", robId)

                ROBBERYS.activeRaid.active = false
                ROBBERYS.robbing = false
            end

            Citizen.Wait(wait)
        end
    end)
end

ROBBERYS.handleWaiter = function(durationMs)
    local endTime = GetGameTimer() + durationMs
    ROBBERYS.timerActive = true
    ROBBERYS.timerEnd = endTime
    ROBBERYS.timerTotal = durationMs

    Citizen.CreateThread(function()
        while ROBBERYS.robbing do
            Citizen.Wait(0)

            local now = GetGameTimer()
            local timeLeft = endTime - now

            if timeLeft <= 0 then
                lib.notify({
                    title = 'Braquage en cours',
                    description = "Le temps est écoulé, vous n'avez pas été assez rapide!",
                    type = 'error',
                    position = 'top',
                    duration = 10000,
                })

                ROBBERYS.robbing = false
                ROBBERYS.timerActive = false
                if ROBBERYS.currentRobId then
                    cfg_robberys.resetLocks(ROBBERYS.currentRobId)
                    cfg_robberys.resetLocksDoors(ROBBERYS.currentRobId)
                end
                break
            end

            if ROBBERYS.timerActive then
                local pct = timeLeft / ROBBERYS.timerTotal
                if pct < 0 then pct = 0 end

                local barW = 0.15
                local barH = 0.02
                local barXLeft = 0.80
                local barXCenter = barXLeft + (barW / 2.0)
                local barY = 0.90

                DrawRect(barXCenter, barY, barW, barH, 0, 0, 0, 150)

                local fillW = barW * pct
                local fillCenter = barXLeft + (fillW / 2.0)
                DrawRect(fillCenter, barY, fillW, barH * 0.6, 200, 50, 50, 200)

                local secondsLeft = math.floor(timeLeft / 1000)
                local minutes = math.floor(secondsLeft / 60)
                local seconds = secondsLeft % 60
                local timeText = string.format("%02d:%02d", minutes, seconds)

                SetTextFont(0)
                SetTextProportional(0)
                SetTextScale(0.35, 0.35)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(timeText)
                DrawText(barXLeft, barY - barH * 1.2)
            end
        end
    end)
end

RegisterNetEvent("robberys:syncFinish")
AddEventHandler("robberys:syncFinish", function(robId)
    cfg_robberys.resetLocksDoors(robId)
end)

RegisterNetEvent("robberys:syncDoors")
AddEventHandler("robberys:syncDoors", function(doors)
    for _, doorData in pairs(doors) do
        local doorEntity = GetClosestObjectOfType(
            doorData.objCoords.x,
            doorData.objCoords.y,
            doorData.objCoords.z,
            1.0,
            doorData.objName,
            false, false, false
        )
        if doorEntity then
            if not NetworkHasControlOfEntity(doorEntity) then
                NetworkRequestControlOfEntity(doorEntity)
            end
            FreezeEntityPosition(doorEntity, false)
            if doorData.objNewHeading then
                SetEntityHeading(doorEntity, doorData.objNewHeading)
            end
        end
    end
end)

local cooldown = false
Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local pedCoords = GetEntityCoords(PlayerPedId())

        for _, v in pairs(cfg_robberys["list"]) do
            if #(pedCoords - v.startPos) < (v.dstInteract or 2.0) and not ROBBERYS.robbing then
                wait = 0
                DrawMarker(1,
                    v.startPos.x, v.startPos.y, v.startPos.z - 1.0,
                    0.0,0.0,0.0, 0.0,0.0,0.0,
                    3.0,3.0,0.5,
                    120,0,0,100
                )
                ESX.ShowHelpNotification(v.helpNotification or "Appuyez sur ~INPUT_CONTEXT~ pour braquer")

                if IsControlJustPressed(0, 38) then
                    if not cooldown then
                        ESX.TriggerServerCallback("robberys:canRob", function(canRob)
                            if canRob then
                                ROBBERYS.startUnified(v.id)
                                cooldown = true
                                SetTimeout(5000, function()
                                    cooldown = false
                                end)
                            else
                                ESX.ShowNotification("~r~Conditions non remplies.")
                            end
                        end, v.id)
                    else
                        ESX.ShowNotification("~r~Veuillez patienter..")
                    end
                end
            end
        end

        Citizen.Wait(wait)
    end
end)
