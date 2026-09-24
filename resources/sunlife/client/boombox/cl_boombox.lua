local BB = {}
    BB.inAction = false
    BB.isPlaying = false
    BB.bModel = "prop_boombox_01"
    BB.bAnimDict = "missheistdocksprep1hold_cellphone"
    BB.bAnimName = "hold_cellphone"
    BB.netID = nil
    BB.sound = exports.xsound
    BB.isAsked = false
    BB.currentLink = nil
    BB.currentVolume = 0.35
    BB.callback = nil
    BB.isPause = false
    BB.currentColorWaiting = "~s~"
    BB.itemId = nil
    BB.args = {}
    BB.showHelp = true
    BB.entity = nil
    local curr = {}
    curr.args = {}

RegisterNetEvent("item:useBoombox")
AddEventHandler("item:useBoombox", function()
    TriggerServerEvent("boombox:checkRank")

    while BB.callback == nil do Wait(0) end

    if BB.callback then
        BB.useBoombox()
    else
        ESX.ShowNotification("~r~Vous devez avoir un grade VIP pour utiliser une enceinte")
    end
end)

RegisterNetEvent("boombox:callback")
AddEventHandler("boombox:callback", function(cb)
    BB.callback = cb
end)

BB.useBoombox = function()
    RageUI.CloseAll()
    inventory_open = false

    RequestModel(GetHashKey(BB.bModel))
    while not HasModelLoaded(GetHashKey(BB.bModel)) do
        Citizen.Wait(100)
    end

    while not HasAnimDictLoaded(BB.bAnimDict) do
        RequestAnimDict(BB.bAnimDict)
        Citizen.Wait(100)
    end

    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    print(('^2[NETDIAG][OBJET]^7 %s cl_boombox.lua:55 CreateObject NETWORKED boombox=%s'):format(GetCurrentResourceName(), tostring(BB.bModel)))
    BB.entity = CreateObject(GetHashKey(BB.bModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)

    Citizen.Wait(1000)

    local netid = ObjToNet(BB.entity)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    AttachEntityToEntity(BB.entity, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 57005), 0.30, 0, 0, 0, 260.0, 60.0, true, true, false, true, 1, true)
    TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
    TaskPlayAnim(GetPlayerPed(PlayerId()), BB.bAnimDict, BB.bAnimName, 1.0, -1, -1, 50, 0, 0, 0, 0)

    BB.netID = netid
    BB.inAction = true

    BB.itemId = curr.itemId
    BB.args = curr.args

    if curr.args["volume"] ~= nil then
        BB.currentVolume = ESX.Math.Round(tonumber(curr.args["volume"]), 2)
    end

    Citizen.CreateThread(function()
        while BB.inAction do

            if not BB.isPlaying then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_FRONTEND_RRIGHT~ pour ranger l'enceinte\nAppuyez sur ~INPUT_THROW_GRENADE~ pour définir une musique")
            else
                if not BB.isPause then
                    if BB.showHelp then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_FRONTEND_RRIGHT~ pour ranger l'enceinte\nAppuyez sur ~INPUT_VEH_DUCK~ pour cacher le menu\nAppuyez sur ~INPUT_THROW_GRENADE~ pour définir une musique\n\nAppuyez sur ~INPUT_MP_TEXT_CHAT_TEAM~ pour mettre la musique sur pause\n"..BB.currentColorWaiting.."Appuyez sur ~INPUT_CONTEXT~ pour synchroniser la musique avec tout le monde~s~\nAppuyez sur ~INPUT_FRONTEND_RIGHT_AXIS_Y~ ("..BB.currentVolume.."%) pour régler le volume")
                    else
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_VEH_DUCK~ pour afficher le menu de l'enceinte")
                    end
                else
                    if BB.showHelp then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_FRONTEND_RRIGHT~ pour ranger l'enceinte\nAppuyez sur ~INPUT_VEH_DUCK~ pour cacher le menu\nAppuyez sur ~INPUT_THROW_GRENADE~ pour définir une musique\n\nAppuyez sur ~INPUT_MP_TEXT_CHAT_TEAM~ pour mettre la musique sur lecture\n"..BB.currentColorWaiting.."Appuyez sur ~INPUT_CONTEXT~ pour synchroniser la musique avec tout le monde~s~\nAppuyez sur ~INPUT_FRONTEND_RIGHT_AXIS_Y~ ("..BB.currentVolume.."%) pour régler le volume")
                    else
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_VEH_DUCK~ pour afficher le menu de l'enceinte")
                    end
                end
            end

            if IsControlJustPressed(0, 73) then
                BB.showHelp = not BB.showHelp
            end

            if BB.showHelp then
                if IsControlJustPressed(0, 194) then
                    BB.removeBoombox()
                end

                if IsControlJustPressed(0, 58) then
                    if not BB.isAsked then
                        BB.controlBoombox()
                        BB.isAsked = true
                    end
                end

                if IsControlJustPressed(0, 246) then
                    if not BB.isAsked then
                        BB.isPause = not BB.isPause
                        BB.isAsked = true
                    end
                end

                if IsControlJustPressed(0, 38) then
                    if not BB.isAsked then
                        BB.syncBoombox()
                        BB.isAsked = true
                    end
                end

                if IsControlJustPressed(0, 14) then
                    BB.volumeBooxbox("less")
                end

                if IsControlJustPressed(0, 15) then
                    BB.volumeBooxbox("more")
                end
            end

            Citizen.Wait(0)
        end
    end)
end

BB.volumeBooxbox = function(v)
    if v == "more" then
        if BB.currentVolume + 0.05 < 1.05 then
            BB.currentVolume = ESX.Math.Round(BB.currentVolume + 0.05, 2)
            BB.needEditArgs = true
        end
    end

    if v == "less" then
        if BB.currentVolume - 0.05 > -0.05 then
            BB.currentVolume = ESX.Math.Round(BB.currentVolume - 0.05, 2)
            BB.needEditArgs = true
        end
    end

    BB.args["volume"] = ESX.Math.Round(BB.currentVolume, 2)
    BB.args["volume"] = ESX.Math.Round(BB.args["volume"], 2)
end

BB.syncBoombox = function()
    local musicId = "music_id_" .. PlayerPedId()
    playersInArea = {}

    for _, player in ipairs(GetActivePlayers()) do
        local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

        if dst < 50.0 then
            table.insert(playersInArea, GetPlayerServerId(player))
        end
    end

    TriggerServerEvent("boombox:soundStatus", "sync", musicId, { position = GetEntityCoords(PlayerPedId()), link = BB.currentLink, time = BB.sound:getTimeStamp(musicId) }, playersInArea)

    BB.currentColorWaiting = "~c~"

    Citizen.SetTimeout(5000, function()
        BB.isAsked = false
        BB.currentColorWaiting = "~s~"
    end)
end

BB.controlBoombox = function()
    local musicId = "music_id_" .. PlayerPedId()
    local i = nil

    exports.dialog:openDialog("Indiquez le lien YouTube de votre musique", function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)

    BB.isAsked = false
    BB.isPlaying = false

    Citizen.Wait(1500)

    if string.len(i) > 3 then
        playersInArea = {}

        for _, player in ipairs(GetActivePlayers()) do
            local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

            if dst < 50.0 then
                table.insert(playersInArea, GetPlayerServerId(player))
            end
        end

        BB.currentLink = i
        TriggerServerEvent("boombox:soundStatus", "play", musicId, { position = GetEntityCoords(PlayerPedId()), link = BB.currentLink, time = 0, volume = BB.currentVolume }, playersInArea)

        if not BB.isPlaying then
            BB.isPlaying = true
            Citizen.CreateThread(function()
                while BB.isPlaying do

                    if not BB.isPause then
                        playersInArea = {}

                        for _, player in ipairs(GetActivePlayers()) do
                            local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                            if dst < 50.0 then
                                table.insert(playersInArea, GetPlayerServerId(player))
                            end
                        end

                        TriggerServerEvent("boombox:soundStatus", "position", musicId, { position = GetEntityCoords(PlayerPedId()), link = BB.currentLink, volume = BB.currentVolume, inVehicle = IsPedInAnyVehicle(PlayerPedId(), false), entity = PlayerPedId() }, playersInArea)
                    else
                        TriggerServerEvent("boombox:soundStatus", "pause", musicId, { position = GetEntityCoords(PlayerPedId()), link = BB.currentLink }, playersInArea)
                    end

                    BB.isAsked = false

                    Citizen.Wait(1000)
                end
            end)

            Citizen.CreateThread(function()
                while BB.isPlaying do

                    if BB.needEditArgs then
                        TriggerServerEvent("boombox:soundStatus", "volume", musicId, { position = GetEntityCoords(PlayerPedId()), link = BB.currentLink, volume = BB.currentVolume }, playersInArea)

                        BB.needEditArgs = false
                    end

                    Citizen.Wait(1000)
                end
            end)

            Citizen.CreateThread(function()
                while BB.isPlaying do

                    HideHudComponentThisFrame(16)
                    HideHudComponentThisFrame(19)

                    Citizen.Wait(0)
                end
            end)
        end
    end
end

BB.removeBoombox = function()
    BB.inAction = false
    BB.isPlaying = false
    BB.isAsked = false

    ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
    DetachEntity(NetToObj(BB.netID), 1, 1)
    DeleteEntity(NetToObj(BB.netID))
    BB.netID = nil

    local musicId = "music_id_" .. PlayerPedId()
    playersInArea = {}

    for _, player in ipairs(GetActivePlayers()) do
        local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

        if dst < 50.0 then
            table.insert(playersInArea, GetPlayerServerId(player))
        end
    end

    TriggerServerEvent("boombox:soundStatus", "stop", musicId, {}, playersInArea)
end

local loadedThread = false
RegisterNetEvent("boombox:soundStatus")
AddEventHandler("boombox:soundStatus", function(type, musicId, data)
    if type == "position" then
        if BB.sound:soundExists(musicId) then
            BB.sound:Position(musicId, data.position)
        else
            BB.sound:PlayUrlPos(musicId, data.link, data.volume, data.position, false)
            BB.sound:Distance(musicId, 20)
        end

        if BB.sound:isPaused(musicId) then
            BB.sound:Resume(musicId)
        end

        local owner = nil
        for _,i in ipairs(GetActivePlayers()) do
            if GetPlayerName(i) == data.ownerName then
                owner = GetPlayerPed(i)
            end
        end

        if data.inVehicle then
            if not loadedThread then
                loadedThread = true
                Citizen.CreateThread(function()
                    while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(owner)) < 500.0 do

                        if BB.sound:soundExists(musicId) then
                            BB.sound:Position(musicId, GetEntityCoords(owner))
                        end

                        Citizen.Wait(0)
                    end
                    loadedThread = false
                end)
            end
        end
    end

    if type == "play" then
        BB.sound:PlayUrlPos(musicId, data.link, data.volume, data.position, false)
        BB.sound:Distance(musicId, 20)
    end

    if type == "stop" then
        BB.sound:Destroy(musicId)
    end

    if type == "pause" then
        if not BB.sound:isPaused(musicId) then
            BB.sound:Pause(musicId)
        end
    end

    if type == "sync" then
        BB.sound:setTimeStamp(musicId, data.time)
    end

    if type == "volume" then
        BB.sound:setVolume(musicId, data.volume)
    end
end)
