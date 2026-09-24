local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
IsInAnimation = false
local MostRecentChosenAnimation = ""
local MostRecentChosenDict = ""
local MovementType = 0
local PlayerGender = "male"
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local PtfxNotif = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
local AnimationThreadStatus = false
local CanCancel = true
local InExitEmote = false
local lasteCommand = nil
IsInAnimation = false

local WeaponHolsterCooldown = 5000
local lastArmedTimer = 0

Citizen.CreateThread(function()
    while true do
        if IsPedArmed(PlayerPedId(), 7) then
            lastArmedTimer = GetGameTimer()
        end
        Citizen.Wait(250)
    end
end)

exports("getIsInAnimation", function()
    return lasteCommand
end)
Citizen.CreateThread(function()
    local favWalk = GetResourceKvpString("favoriteWalk")
    local ped = PlayerPedId()
	if favWalk then
		RequestDemarcheThing(favWalk)
		SetPedMovementClipset(ped, favWalk, 0.2)
		RemoveAnimSet(favWalk)
	end

	local haveFavorite = GetResourceKvpString("favoritehumor")
	if haveFavorite then
		EmoteMenuStart(tostring(haveFavorite), "expression")
	end

    while true do
        if PtfxPrompt then
            if not PtfxNotif then
                SimpleNotify(PtfxInfo)
                PtfxNotif = true
            end
            if IsControlPressed(0, 47) then
                PtfxStart()
                Wait(PtfxWait)
                PtfxStopDP()
            end
        end

        if CFGDPEMOTES.EnableXtoCancel then if IsControlPressed(0, 73) then print("50?") EmoteCancel() end end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', { { name = "emotename", help = "dance, camera, sit or any valid emote." } })
    TriggerEvent('chat:addSuggestion', '/emote', 'Play an emote', { { name = "emotename", help = "dance, camera, sit or any valid emote." } })
    if CFGDPEMOTES.SqlKeybinding then
        TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', { { name = "key", help = "num4, num5, num6, num7. num8, num9. Numpad 4-9!" }, { name = "emotename", help = "dance, camera, sit or any valid emote." } })
        TriggerEvent('chat:addSuggestion', '/emotebinds', 'Check your currently bound emotes.')
    end
    TriggerEvent('chat:addSuggestion', '/emotemenu', 'Open dpemotes menu (F5) by default.')
    TriggerEvent('chat:addSuggestion', '/emotes', 'List available emotes.')
    TriggerEvent('chat:addSuggestion', '/walk', 'Set your walkingstyle.', { { name = "style", help = "/walks for a list of valid styles" } })
    TriggerEvent('chat:addSuggestion', '/walks', 'List available walking styles.')
end)

RegisterCommand('e', function(source, args, raw)
    EmoteCommandStart(source, args, raw)
end)
RegisterCommand('emote', function(source, args, raw) EmoteCommandStart(source, args, raw) end)

local adjustActive = false
RegisterCommand('adjust', function()
    if adjustActive then return end

    local animdata = exports.sunlife:getCurrentEmoteTT()
    if not animdata or not animdata[1] or not animdata[2] then
        ESX.ShowNotification("~r~Vous ne faites pas d'animation actuellement !")
        return
    end
    if not IsEntityPlayingAnim(PlayerPedId(), animdata[1], animdata[2], 3) then
        ESX.ShowNotification("~r~Vous ne faites pas d'animation actuellement !")
        return
    end

    local movementFlag = 0
    if animdata.AnimationOptions then
        if animdata.AnimationOptions.EmoteLoop then
            movementFlag = 1
            if animdata.AnimationOptions.EmoteMoving then movementFlag = 51 end
        elseif animdata.AnimationOptions.EmoteMoving then
            movementFlag = 51
        elseif animdata.AnimationOptions.EmoteStuck then
            movementFlag = 50
        end
    end

    local emoteCmd = nil
    for _, tabledata in pairs(DP) do
        for command, emotedata in pairs(tabledata) do
            if emotedata == animdata then
                emoteCmd = command
                break
            end
        end
        if emoteCmd then break end
    end
    if not emoteCmd and animdata[4] then emoteCmd = animdata[4] end
    if not emoteCmd then
        ESX.ShowNotification("~r~Impossible d'identifier l'animation.")
        return
    end

    adjustActive = true
    local ped = PlayerPedId()
    local clonePed = ClonePed(ped, false, true, true)
    SetEntityAlpha(clonePed, 204)
    SetEntityNoCollisionEntity(ped, clonePed, false)
    SetEntityInvincible(clonePed, true)
    SetBlockingOfNonTemporaryEvents(clonePed, true)
    FreezeEntityPosition(clonePed, true)
    TaskPlayAnim(clonePed, animdata[1], animdata[2], 2.0, 2.0, -1, movementFlag, 0, false, false, false)
    FreezeEntityPosition(ped, true)

    local heading = GetEntityHeading(ped)
    local startPos = GetEntityCoords(ped)
    local offsetX, offsetY, offsetZ = 0.0, 0.0, 0.0
    local moveSpeed = 0.03
    local rotSpeed = 3.0

    CreateThread(function()
        while adjustActive do
            Wait(0)

            DisableControlAction(0, 23, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 73, true)
            DisableControlAction(0, 191, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)

            SetEntityCoords(clonePed, startPos.x + offsetX, startPos.y + offsetY, startPos.z + offsetZ)
            SetEntityHeading(clonePed, heading)

            if not IsEntityPlayingAnim(clonePed, animdata[1], animdata[2], 3) then
                TaskPlayAnim(clonePed, animdata[1], animdata[2], 2.0, 2.0, -1, movementFlag, 0, false, false, false)
            end

            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Entrée ~g~Confirmer~s~  |  X ~r~Annuler~s~\nQ/E Rotation  |  R Haut  |  F Bas\nWASD Déplacer")
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsDisabledControlJustPressed(0, 191) then
                local clonePos = GetEntityCoords(clonePed)
                if #(startPos - clonePos) <= 12.0 then
                    FreezeEntityPosition(ped, false)
                    SetEntityCoordsNoOffset(ped, clonePos.x, clonePos.y, clonePos.z)
                    SetEntityHeading(ped, heading)
                    DeletePed(clonePed)
                    ExecuteCommand("e c")
                    Wait(100)
                    ExecuteCommand("e " .. emoteCmd)
                    adjustActive = false
                end
            end

            if IsDisabledControlJustPressed(0, 73) then
                DeletePed(clonePed)
                FreezeEntityPosition(ped, false)
                SetEntityCoords(ped, startPos.x, startPos.y, startPos.z)
                adjustActive = false
            end

            if IsDisabledControlPressed(0, 44) then heading = heading - rotSpeed end
            if IsDisabledControlPressed(0, 38) then heading = heading + rotSpeed end
            if IsDisabledControlPressed(0, 45) then offsetZ = offsetZ + moveSpeed end
            if IsDisabledControlPressed(0, 23) then offsetZ = offsetZ - moveSpeed end

            local rad = math.rad(heading)
            if IsDisabledControlPressed(0, 34) then
                offsetX = offsetX - math.cos(rad) * moveSpeed
                offsetY = offsetY - math.sin(rad) * moveSpeed
            end
            if IsDisabledControlPressed(0, 35) then
                offsetX = offsetX + math.cos(rad) * moveSpeed
                offsetY = offsetY + math.sin(rad) * moveSpeed
            end
            if IsDisabledControlPressed(0, 32) then
                offsetX = offsetX + math.cos(rad + math.pi/2) * moveSpeed
                offsetY = offsetY + math.sin(rad + math.pi/2) * moveSpeed
            end
            if IsDisabledControlPressed(0, 33) then
                offsetX = offsetX - math.cos(rad + math.pi/2) * moveSpeed
                offsetY = offsetY - math.sin(rad + math.pi/2) * moveSpeed
            end
        end
    end)
end)

if CFGDPEMOTES.SqlKeybinding then
    RegisterCommand('emotebind', function(source, args, raw) EmoteBindStart(source, args, raw) end)
    RegisterCommand('emotebinds', function(source, args, raw) EmoteBindsStart(source, args, raw) end)
end

RegisterCommand('emotes', function(source, args, raw) EmotesOnCommand() end)
RegisterCommand('walk', function(source, args, raw) WalkCommandStart(source, args, raw) end)
RegisterCommand('walks', function(source, args, raw) WalksOnCommand() end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DestroyAllPropsDP()
        ClearPedTasksImmediately(PlayerPedId())
        ResetPedMovementClipset(PlayerPedId())
    end
end)

RegisterNetEvent("dpemotes:cancelEmote")
AddEventHandler("dpemotes:cancelEmote", function()
    EmoteCancel()
    DestroyAllPropsDP()
end)

function EmoteCancel(force)
    if exports.sunlife_ui:IsInGunFightZone() then return end
    if exports.sJobs:takedBox() then return end
    if exports.sCore:UsingGilet() then return end
    if exports.sJobs:isUsingEMSItem() then return end

    if InExitEmote then
        print(129)
        return
    end

    local ply = PlayerPedId()
	if not CanCancel and force ~= true then
        return
    end
    if ChosenDict == "MaleScenario" and IsInAnimation then
        ClearPedTasksImmediately(ply)
        IsInAnimation = false
        DebugPrint("Forced scenario exit")
    elseif ChosenDict == "Scenario" and IsInAnimation then
        ClearPedTasksImmediately(ply)
        IsInAnimation = false
        DebugPrint("Forced scenario exit")
    end

    PtfxNotif = false
    PtfxPrompt = false
	Pointing = false

    if IsInAnimation then
        if LocalPlayer.state.ptfx then
            PtfxStop()
        end
        DetachEntity(ply, true, false)
        CancelSharedEmote(ply)

        if ChosenAnimOptions and ChosenAnimOptions.ExitEmote then

            local options = ChosenAnimOptions
            local ExitEmoteType = options.ExitEmoteType or "Emotes"

            if not RP[ExitEmoteType] or not RP[ExitEmoteType][options.ExitEmote] then
                DebugPrint("Exit emote was invalid")
                ClearPedTasks(ply)
                IsInAnimation = false
                return
            end

            OnEmotePlay(RP[ExitEmoteType][options.ExitEmote])
            DebugPrint("Playing exit animation")

            local animationOptions = RP[ExitEmoteType][options.ExitEmote].AnimationOptions
            if animationOptions and animationOptions.EmoteDuration then
                InExitEmote = true
                SetTimeout(animationOptions.EmoteDuration, function()
                    InExitEmote = false
                    DestroyAllPropsDP()
                    ClearPedTasks(ply)
                end)
                return
            end
        else
            ClearPedTasks(ply)
            IsInAnimation = false
        end
        DestroyAllPropsDP()
        lasteCommand = nil
    end
    AnimationThreadStatus = false
    currentEmote = nil
end

IsPlayingAnim = function()
    return IsInAnimation
end

function EmoteChatMessage(args)
    if args == display then
        TriggerEvent("chatMessage", "^5Help^0", { 0, 0, 0 }, string.format(""))
    else
        TriggerEvent("chatMessage", "^5Help^0", { 0, 0, 0 }, string.format("" .. args .. ""))
    end
end

function DebugPrint(args)
    if CFGDPEMOTES.DebugDisplay then
        print(args)
    end
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = PlayerPedId()
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStopDP()
    for a, b in pairs(PlayerParticles) do
        DebugPrint("Stopped PTFX: " .. b)
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end

function EmotesOnCommand(source, args, raw)
    local EmotesCommand = ""
    for a in pairsByKeys(DP.Emotes) do
        EmotesCommand = EmotesCommand .. "" .. a .. ", "
    end
    EmoteChatMessage(EmotesCommand)
    EmoteChatMessage(CFGDPEMOTES.Languages[lang]['emotemenucmd'])
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function EmoteMenuStart(args, hard)
    local name = args
    local etype = hard

    if etype == "dances" then
        if DP.Dances[name] ~= nil then
            if OnEmotePlay(DP.Dances[name], name) then end
        end
    elseif etype == "animals" then
        if DP.AnimalEmotes[name] ~= nil then
            if OnEmotePlay(DP.AnimalEmotes[name], name) then end
        end
    elseif etype == "props" then
        if DP.PropEmotes[name] ~= nil then
            if OnEmotePlay(DP.PropEmotes[name], name) then end
        end
    elseif etype == "emotes" then
        if DP.Emotes[name] ~= nil then
            if OnEmotePlay(DP.Emotes[name], name) then end
        else
            if name ~= "🕺 Dance Emotes" then end
        end
    elseif etype == "sit" then
        if DP.Sits[name] ~= nil then
            if OnEmotePlay(DP.Sits[name], name) then end
        end
    elseif etype == "pegi" then
        if DP.Pegi[name] ~= nil then
            if OnEmotePlay(DP.Pegi[name], name) then end
        end
    elseif etype == "sports" then
        if DP.Sports[name] ~= nil then
            if OnEmotePlay(DP.Sports[name], name) then end
        end
    elseif etype == "vehicle" then
        if DP.VehicleAnimations[name] ~= nil then
            if OnEmotePlay(DP.VehicleAnimations[name], name, etype) then end
        end
    elseif etype == "neige" then
        if DP.Neige[name] ~= nil then
            if OnEmotePlay(DP.Neige[name], name) then end
        end
    elseif etype == "salutes" then
        if DP.Salutes[name] ~= nil then
            if OnEmotePlay(DP.Salutes[name], name) then end
        end
    elseif etype == "poses" then
        if DP.Poses[name] ~= nil then
            if OnEmotePlay(DP.Poses[name], name) then end
        end
    elseif etype == "gangs" then
        if DP.Gangs[name] ~= nil then
            if OnEmotePlay(DP.Gangs[name], name) then end
        end
    elseif etype == "meme" then
        if DP.Meme[name] ~= nil then
            if OnEmotePlay(DP.Meme[name], name) then end
        end
    elseif etype == "expression" then
        if DP.Expressions[name] ~= nil then
            if OnEmotePlay(DP.Expressions[name], name) then end
        end
    end
end

function EmoteCommandStart(source, args, raw)
    if IsPedFalling(PlayerPedId()) then return end
    if IsPedDeadOrDying(PlayerPedId(), false) then return end

    if #args > 0 then
        local name = string.lower(args[1])
        if name == "c" then
            if IsInAnimation then
                EmoteCancel()
            else
                EmoteChatMessage(CFGDPEMOTES.Languages[lang]['nocancel'])
            end
            return
        elseif name == "help" then
            EmotesOnCommand()
            return
        end

        if IsInAnimation then
            EmoteCancel()
            return
        end

        if DP.Emotes[name] ~= nil then
            if OnEmotePlay(DP.Emotes[name], name) then end
            return
        elseif DP.Sits[name] ~= nil then
            if OnEmotePlay(DP.Sits[name], name) then end
            return
        elseif DP.Pegi[name] ~= nil then
            if OnEmotePlay(DP.Pegi[name], name) then end
            return
        elseif DP.Sports[name] ~= nil then
            if OnEmotePlay(DP.Sports[name], name) then end
            return
        elseif DP.VehicleAnimations[name] ~= nil then
            if OnEmotePlay(DP.VehicleAnimations[name], name) then end
            return
        elseif DP.Neige[name] ~= nil then
            if OnEmotePlay(DP.Neige[name], name) then end
            return
        elseif DP.Salutes[name] ~= nil then
            if OnEmotePlay(DP.Salutes[name], name) then end
            return
        elseif DP.Poses[name] ~= nil then
            if OnEmotePlay(DP.Poses[name], name) then end
            return
        elseif DP.Gangs[name] ~= nil then
            if OnEmotePlay(DP.Gangs[name], name) then end
            return
        elseif DP.Meme[name] ~= nil then
            if OnEmotePlay(DP.Meme[name], name) then end
            return
        elseif DP.Dances[name] ~= nil then
            if OnEmotePlay(DP.Dances[name], name) then end
            return
        elseif DP.AnimalEmotes[name] ~= nil then
            if OnEmotePlay(DP.AnimalEmotes[name], name) then end
            return
        elseif DP.PropEmotes[name] ~= nil then
            if OnEmotePlay(DP.PropEmotes[name], name) then end
            return
        else
            EmoteChatMessage("'" .. name .. "' " .. CFGDPEMOTES.Languages[lang]['notvalidemote'] .. "")
        end
    end
end

function LoadDpemotesAnim(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end

    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end

    return true
end

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

function PtfxThisDP(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        RequestNamedPtfxAsset(asset)
        Wait(10)
    end
    UseParticleFxAssetNextCall(asset)
end

function DestroyAllPropsDP()
    for _, v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
    DebugPrint("Destroyed Props")
end

function AddPropToPlayerDP(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    print(('^2[NETDIAG][OBJET]^7 %s Emote.lua:574 CreateObject NETWORKED emote-prop=%s'):format(GetCurrentResourceName(), tostring(prop1)))
    prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function CheckGender()
    local hashSkinMale = GetHashKey("mp_m_freemode_01")
    local hashSkinFemale = GetHashKey("mp_f_freemode_01")

    if GetEntityModel(PlayerPedId()) == hashSkinMale then
        PlayerGender = "male"
    elseif GetEntityModel(PlayerPedId()) == hashSkinFemale then
        PlayerGender = "female"
    end
    DebugPrint("Set gender as = (" .. PlayerGender .. ")")
end

local currentEmote = {}

exports('getCurrentEmoteTT', function()
	return currentEmote
end)

function OnEmotePlay(EmoteName, eName, etype)

    if exports.sunlife_ui:IsInGunFightZone() then return end
    if exports.sJobs:takedBox() then return end
    if exports.sCore:UsingGilet() then return end
    if exports.sJobs:isUsingEMSItem() then return end
    if IsPedShooting(PlayerPedId()) then return end

    if IsPedArmed(PlayerPedId(), 7) then
        local isPose = false
        if eName and DP.Poses[eName] == EmoteName then
            isPose = true
        else
            for _, poseData in pairs(DP.Poses) do
                if poseData == EmoteName then
                    isPose = true
                    break
                end
            end
        end
        if not isPose then
            ESX.ShowNotification("~r~Vous ne pouvez pas faire cette animation avec une arme en main.")
            return
        end
    elseif (GetGameTimer() - lastArmedTimer) < WeaponHolsterCooldown then
        local remaining = math.ceil((WeaponHolsterCooldown - (GetGameTimer() - lastArmedTimer)) / 1000)
        ESX.ShowNotification("~r~Vous devez attendre "..remaining.." seconde(s) après avoir rangé votre arme.")
        return
    end

    local playerPed = PlayerPedId()
    local currentEmoteTable = EmoteName
    for _, tabledata in pairs(DP) do
        for command, emotedata in pairs(tabledata) do
            if emotedata == EmoteName then
                table.insert(currentEmoteTable, command)
                break
            end
        end
    end
    currentEmote = currentEmoteTable

    if etype ~= "vehicle" then
        InVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        if not CFGDPEMOTES.AllowedInCars and InVehicle == 1 then
            return
        end
    end

    if not DoesEntityExist(PlayerPedId()) then
        return false
    end

    if CFGDPEMOTES.DisarmPlayer then
        if IsPedArmed(PlayerPedId(), 7) then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
        end
    end

    ChosenDict, ChosenAnimation, ename = table.unpack(EmoteName)

    lasteCommand = eName

    AnimationDuration = -1

    if PlayerHasProp then
        DestroyAllPropsDP()
    end

    if ChosenDict == "Expression" then
        SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
        return
    end

    if ChosenDict == "MaleScenario" or "Scenario" then
        CheckGender()
        if ChosenDict == "MaleScenario" then if InVehicle then return end
            if PlayerGender == "male" then
                ClearPedTasks(PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
                DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
                IsInAnimation = true
            else
                EmoteChatMessage(CFGDPEMOTES.Languages[lang]['maleonly'])
            end
            return
        elseif ChosenDict == "ScenarioObject" then if InVehicle then return end
            BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioAtPosition(PlayerPedId(), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
            DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
            IsInAnimation = true
            return
        elseif ChosenDict == "Scenario" then if InVehicle then return end
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
            DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
            IsInAnimation = true
            return
        end
    end

    ChosenDict = tostring(ChosenDict)
    ChosenDict = ChosenDict:lower()

    if not LoadDpemotesAnim(ChosenDict) then
        print(ChosenDict, "ChosenDict is bad :(")
        return
    end

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.EmoteLoop then
            MovementType = 1
            if EmoteName.AnimationOptions.EmoteMoving then
                MovementType = 51
            end

        elseif EmoteName.AnimationOptions.EmoteMoving then
            MovementType = 51
        elseif EmoteName.AnimationOptions.EmoteMoving == false then
            MovementType = 0
        elseif EmoteName.AnimationOptions.EmoteStuck then
            MovementType = 50
        end

    else
        MovementType = 0
    end

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.EmoteDuration == nil then
            EmoteName.AnimationOptions.EmoteDuration = -1
            AttachWait = 0
        else
            AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
            AttachWait = EmoteName.AnimationOptions.EmoteDuration
        end

        if EmoteName.AnimationOptions.PtfxAsset then
            PtfxAsset = EmoteName.AnimationOptions.PtfxAsset
            PtfxName = EmoteName.AnimationOptions.PtfxName
            if EmoteName.AnimationOptions.PtfxNoProp then
                PtfxNoProp = EmoteName.AnimationOptions.PtfxNoProp
            else
                PtfxNoProp = false
            end
            Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(EmoteName.AnimationOptions.PtfxPlacement)
            PtfxInfo = EmoteName.AnimationOptions.PtfxInfo
            PtfxWait = EmoteName.AnimationOptions.PtfxWait
            PtfxNotif = false
            PtfxPrompt = true
            PtfxThisDP(PtfxAsset)
        else
            DebugPrint("Ptfx = none")
            PtfxPrompt = false
        end
    end
    TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
    RemoveAnimDict(ChosenDict)
    IsInAnimation = true
    MostRecentDict = ChosenDict
    MostRecentAnimation = ChosenAnimation

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.Prop then
            PropName = EmoteName.AnimationOptions.Prop
            PropBone = EmoteName.AnimationOptions.PropBone
            PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
            if EmoteName.AnimationOptions.SecondProp then
                SecondPropName = EmoteName.AnimationOptions.SecondProp
                SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
                SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
                SecondPropEmote = true
            else
                SecondPropEmote = false
            end
            Wait(AttachWait)
            AddPropToPlayerDP(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
            if SecondPropEmote then
                AddPropToPlayerDP(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
            end
        end
    end
    return true
end
