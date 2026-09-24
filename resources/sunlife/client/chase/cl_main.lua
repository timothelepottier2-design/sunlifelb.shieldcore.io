local hunterCount, preyCount = 0, 0
local role = nil
local inDuel = false
local opponent = nil
local menuOpenned = false
local spawnedVehicle = nil
local leaderboard = {}

local availableVehicles = {
    hunter = {
        { label = "F340R", hash = GetHashKey("f340r") },
        { label = "F440R", hash = GetHashKey("f440r") },
        { label = "F540R", hash = GetHashKey("f540r") },
        { label = "SR8", hash = GetHashKey("sr8") },
        { label = "TailgaterSR", hash = GetHashKey("tailgatersr") },
        { label = "Sent 5", hash = GetHashKey("sent5hyc") },
        { label = "Schafter V12", hash = GetHashKey("schafter3") },
        { label = "Kamacho", hash = GetHashKey("kamacho") },
        { label = "Everon", hash = GetHashKey("everon") },
        { label = "Caracara 4x4", hash = GetHashKey("caracara2") },
    },
    prey = {
        { label = "F340R", hash = GetHashKey("f340r") },
        { label = "F440R", hash = GetHashKey("f440r") },
        { label = "F540R", hash = GetHashKey("f540r") },
        { label = "SR8", hash = GetHashKey("sr8") },
        { label = "TailgaterSR", hash = GetHashKey("tailgatersr") },
        { label = "Sent 5", hash = GetHashKey("sent5hyc") },
        { label = "Schafter V12", hash = GetHashKey("schafter3") },
        { label = "Kamacho", hash = GetHashKey("kamacho") },
        { label = "Everon", hash = GetHashKey("everon") },
        { label = "Caracara 4x4", hash = GetHashKey("caracara2") },
    }
}
local hunterLabels = {}
local preyLabels = {}
Citizen.CreateThread(function()
    for _, v in ipairs(availableVehicles.hunter) do
        table.insert(hunterLabels, v.label)
    end

    for _, v in ipairs(availableVehicles.prey) do
        table.insert(preyLabels, v.label)
    end
end)

function BeginRace(cb)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(3)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(2)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(1)
    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0)
    BeginRaceGo()

    if cb then
        cb()
    end
end

function BeginRaceGo()
	local scaleform = RequestScaleformMovie('COUNTDOWN')

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')

    BeginTextCommandScaleformString('CNTDWN_GO')
    EndTextCommandScaleformString()

    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamInt(255)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 1000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
end

function BeginRaceCount(count)
	local scaleform = RequestScaleformMovie('COUNTDOWN')

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')

    BeginTextCommandScaleformString('NUMBER')
    AddTextComponentInteger(count)
    EndTextCommandScaleformString()

    ScaleformMovieMethodAddParamInt(255)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamInt(30)
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()

    local timeout = GetGameTimer() + 1000
    while GetGameTimer() < timeout do
        Citizen.Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
end

function Draw2DText(x, y, text, scale, colours)
	SetTextFont(4)
	SetTextProportional(7)
	SetTextScale(scale, scale)
	SetTextColour(colours[1], colours[2], colours[3], colours[4])
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextEdge(4, 0, 0, 0, 255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function ShowNativeNotification(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - p)

    local scale = 0.65 / dist
    if scale < 0.25 then scale = 0.25 end
    if scale > 0.6 then scale = 0.6 end

    scale = 0.9

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(1)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function ChaseDraw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local chaseEntryPed = nil

local function spawnChaseEntryPed()
    if chaseEntryPed and DoesEntityExist(chaseEntryPed) then return end

    local cfg = chase.entry
    local model = joaat(cfg.ped.model)

    if not IsModelInCdimage(model) or not IsModelValid(model) then
        return
    end

    RequestModel(model)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(model) do
        Wait(10)
        if GetGameTimer() > timeout then return end
    end

    chaseEntryPed = CreatePed(4, model, cfg.pos.x, cfg.pos.y, cfg.pos.z - 1.0, cfg.heading, false, true)
    if not chaseEntryPed or chaseEntryPed == 0 then
        SetModelAsNoLongerNeeded(model)
        return
    end
    SetEntityAsMissionEntity(chaseEntryPed, true, true)
    FreezeEntityPosition(chaseEntryPed, true)
    SetEntityInvincible(chaseEntryPed, true)
    SetBlockingOfNonTemporaryEvents(chaseEntryPed, true)
    SetPedCanRagdoll(chaseEntryPed, false)

    if cfg.ped.scenario and cfg.ped.scenario ~= "" then
        TaskStartScenarioInPlace(chaseEntryPed, cfg.ped.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
end

CreateThread(function()
    spawnChaseEntryPed()
end)

AddEventHandler("onResourceStop", function(resName)
    if resName ~= GetCurrentResourceName() then return end
    if chaseEntryPed and DoesEntityExist(chaseEntryPed) then
        DeleteEntity(chaseEntryPed)
    end
    chaseEntryPed = nil
end)

Citizen.CreateThread(function()
    while true do
        local interval = 1000
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local cfg = chase.entry
        local targetCoords = cfg.pos

        if chaseEntryPed and DoesEntityExist(chaseEntryPed) then
            targetCoords = GetEntityCoords(chaseEntryPed)
        end

        local dist = #(pCoords - targetCoords)

        if dist < 35.0 then
            interval = 0
            ChaseDraw3DTextH(targetCoords.x, targetCoords.y, targetCoords.z - 0.8, "SunLife Pursuit", 4, 0.2, 0.2)

            if dist < 1.0 then
                ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu de l'activité: SunLife Pursuit")
                if IsControlJustPressed(1, 38) then
                    openChaseMenu()
                end
            end
        end

        Wait(interval)
    end
end)

openChaseMenu = function()
    local selectedHunterIndex = 1
    local selectedPreyIndex = 1

    if RMenu['chase'] then
        for name, menu in pairs(RMenu['chase']) do
            RMenu:Delete('chase', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('chase', 'main', RageUI.CreateMenu("Chasse", "Que voulez-vous faire ?", 1, 100))
    RMenu.Add('chase', 'leaderboard', RageUI.CreateSubMenu(RMenu:Get('chase', 'main'), "Classement", "Top chasseurs et chassés"))
    RMenu:Get('chase', 'main'):SetRectangleBanner(255, 106, 0, 140)
    RMenu:Get('chase', "main").Closed = function()
        menuOpenned = false

        RMenu:Delete('chase', 'main')
        RMenu:Delete('chase', 'leaderboard')
    end

    if menuOpenned then
        menuOpenned = false
        return
    else
        RageUI.CloseAll()

        menuOpenned = true
        RageUI.Visible(RMenu:Get('chase', 'main'), true)
    end

    Citizen.CreateThread(function()
        while menuOpenned do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                menuOpenned = false
            end

            RageUI.IsVisible(RMenu:Get('chase', 'main'), true, true, true, function()

                RageUI.List("~r~Rejoindre comme Chasseur ("..hunterCount..")", hunterLabels, selectedHunterIndex, "Choisissez le véhicule pour chasser la cible.", {}, true, function(Hovered, Active, Selected, Index)
                    selectedHunterIndex = Index
                    if Selected then
                        local selectedVehicle = availableVehicles.hunter[selectedHunterIndex]
                        TriggerServerEvent("duel:addToQueue", "hunter", selectedVehicle.hash)
                    end
                end)

                RageUI.List("~b~Rejoindre comme Chassé ("..preyCount..")", preyLabels, selectedPreyIndex, "Choisissez le véhicule pour fuir le chasseur.", {}, true, function(Hovered, Active, Selected, Index)
                    selectedPreyIndex = Index
                    if Selected then
                        local selectedVehicle = availableVehicles.prey[selectedPreyIndex]
                        TriggerServerEvent("duel:addToQueue", "prey", selectedVehicle.hash)
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('chase', 'leaderboard'), true, true, true, function()

                RageUI.Separator("~r~Top 5 Chasseurs")

                if leaderboard["hunters"] and #leaderboard["hunters"] > 0 then
                    for i, data in ipairs(leaderboard["hunters"]) do
                        RageUI.ButtonWithStyle(i..". "..data.identifier, nil, {RightLabel = data.wins.." 🏆"}, false, function() end)
                    end
                else
                    RageUI.Separator("~c~Aucun chasseur")
                end

                RageUI.Separator("~b~Top 5 Chassés")

                if leaderboard["preys"] and #leaderboard["preys"] > 0 then
                    for i, data in ipairs(leaderboard["preys"]) do
                        RageUI.ButtonWithStyle(i..". "..data.identifier, nil, {RightLabel = data.wins.." 🏆"}, false, function() end)
                    end
                else
                    RageUI.Separator("~c~Aucun chassé")
                end

            end)
        end
    end)
end

RegisterNetEvent("duel:updateQueue", function(hunters, preys)
    hunterCount = hunters
    preyCount = preys
end)

RegisterNetEvent("duel:start", function(_role, myPos, oppPos, preyId, vehicleHash)
    role = _role
    inDuel = true
    opponent = oppPos

    DoScreenFadeOut(500)
    Wait(500)

    local model = vehicleHash
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    TriggerServerEvent('eye:veh:authorize', model, 'chase')
    print(('^5[NETDIAG][VEHICLE]^7 %s cl_main.lua:381 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local veh = CreateVehicle(model, myPos.x, myPos.y, myPos.z, myPos.a, true, false)
    while not DoesEntityExist(veh) do Wait(0) end

    spawnedVehicle = veh

    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleFuelLevel(veh, 100.0)
    SetVehicleNumberPlateText(veh, chase.vehiclePlate)
    SetEntityAsNoLongerNeeded(veh)
    SetVehicleNumberPlateText(veh, "XXXX 000")

    FreezeEntityPosition(spawnedVehicle, true)

    Wait(1000)
    DoScreenFadeIn(1000)

    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)

    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(3)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(2)
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET")
    BeginRaceCount(1)
    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0)
    BeginRaceGo()

    if spawnedVehicle then
        FreezeEntityPosition(spawnedVehicle, false)
    end

    if _role == "hunter" then
        Citizen.CreateThread(function()
            while inDuel do
                local myCoords = GetEntityCoords(PlayerPedId())
                local found = false

                if not IsPedInVehicle(PlayerPedId(), spawnedVehicle, false) then
                    TriggerServerEvent("duel:endMatch", opponent, GetPlayerServerId(PlayerId()))
                    inDuel = false
                    break
                end

                for _, player in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(player) == preyId then
                        local targetPed = GetPlayerPed(player)
                        if DoesEntityExist(targetPed) then
                            local targetCoords = GetEntityCoords(targetPed)
                            local dist = #(myCoords - targetCoords)

                            found = true

                            if dist < 5.0 then
                                TriggerServerEvent("duel:endMatch", GetPlayerServerId(PlayerId()), preyId)
                                inDuel = false
                            elseif dist > 250.0 then
                                TriggerServerEvent("duel:endMatch", preyId, GetPlayerServerId(PlayerId()))
                                inDuel = false
                            end

                            break
                        end
                    end
                end

                if not found then
                    TriggerServerEvent("duel:endMatch", preyId, GetPlayerServerId(PlayerId()))
                    inDuel = false
                end

                Wait(100)
            end
        end)
    end
end)

RegisterNetEvent("duel:finish", function(won)
    inDuel = false
    opponent = nil
    SetEntityCoords(PlayerPedId(), chase.entry.pos.x, chase.entry.pos.y, chase.entry.pos.z)
    if won then
        ShowNativeNotification("~g~Vous avez gagné le duel !")
    else
        ShowNativeNotification("~r~Vous avez perdu le duel")
    end

    DeleteEntity(spawnedVehicle)
    spawnedVehicle = nil
end)

RegisterNetEvent("duel:returnTopWins", function(hunters, preys)
    leaderboard["hunters"] = hunters
    leaderboard["preys"] = preys
end)
