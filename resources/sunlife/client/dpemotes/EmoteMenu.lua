local EmoteTable = {}
local FavEmoteTable = {}
local KeyEmoteTable = {}
local DanceTable = {}
local AnimalTable = {}
local PropETable = {}
local WalkTable = {}
local FaceTable = {}
local ShareTable = {}
local FavoriteEmote = ""
emotePed = nil

local EMOTE_COOLDOWN = 5000
local lastEmoteTime = 0

-- Cooldown entre deux animations retire (demande du 2026-09-12) : on garde
-- juste un anti double-clic de 150 ms pour ne pas empiler deux TaskPlayAnim
-- sur la meme frame.
local function CanPlayEmote()
    local now = GetGameTimer()
    if now - lastEmoteTime < 150 then
        return false
    end
    lastEmoteTime = now
    return true
end

local function EmoteTextInput(title, default, maxLength)
    AddTextEntry('EMOTE_SEARCH', title)
    DisplayOnscreenKeyboard(1, 'EMOTE_SEARCH', '', default or '', '', '', '', maxLength or 30)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() == 1 then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

RequestDemarcheThing = function(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

local prop = nil

CreateThread(function ()
    while true do
        if not inMenu or not RMenu:Get('animation', "main") then
            if emotePed ~= nil  then
                DeleteEntity(emotePed)
                if prop ~= nil then
                    DeleteEntity(prop)
                    prop = nil
                end
                emotePed = nil
            end
        end
        Wait(800)
    end
end)

local currentEmote = nil

OpenEmoteMenu = function()
    RMenu.Add('animation', 'main', RageUI.CreateMenu("Animation", "Que voulez-vous faire ?", 1, 100))

    RMenu.Add('animation', 'humor', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Humeurs", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'aimstyles', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Style de visée", "Que voulez-vous faire ?"))
    RMenu.Add('animation', 'holsterAnim', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Animation sortie", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'walks', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Démarches", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'animations', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Animation", "Que voulez-vous faire ?"))
    RMenu.Add('animation', 'neige', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Neige", "Liste des animations"))
    RMenu.Add('animation', 'danses', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Danses", "Liste des danses"))
    RMenu.Add('animation', 'vehicle', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "En véhicule", "Liste des animations"))
    RMenu.Add('animation', 'animals', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Animaux", "Liste des animations"))
    RMenu.Add('animation', 'objects', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Objets", "Liste des animations"))
    RMenu.Add('animation', 'shared', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Partagées", "Liste des animations"))
    RMenu.Add('animation', 'sit', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "S'asseoir", "Liste des animations"))
    RMenu.Add('animation', 'pegi', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Pegi 18", "Liste des animations"))
    RMenu.Add('animation', 'sports', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Sport", "Liste des animations"))
    RMenu.Add('animation', 'salutes', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Saluts", "Liste des animations"))
    RMenu.Add('animation', 'poses', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Poses", "Liste des animations"))
    RMenu.Add('animation', 'gangs', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Gang", "Liste des animations"))
    RMenu.Add('animation', 'meme', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Animations de meme", "Liste des animations"))
    RMenu:Get('animation', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'main'):SetPosition(1340, 200)

    RMenu:Get('animation', 'humor'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'humor'):SetPosition(1340, 200)

    RMenu:Get('animation', 'aimstyles'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'aimstyles'):SetPosition(1340, 200)

    RMenu:Get('animation', 'holsterAnim'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'holsterAnim'):SetPosition(1340, 200)

    RMenu:Get('animation', 'walks'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'walks'):SetPosition(1340, 200)

    RMenu:Get('animation', 'animations'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'animations'):SetPosition(1340, 200)

    RMenu:Get('animation', 'danses'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'danses'):SetPosition(1340, 200)

    RMenu:Get('animation', 'animals'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'animals'):SetPosition(1340, 200)

    RMenu:Get('animation', 'objects'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'objects'):SetPosition(1340, 200)

    RMenu:Get('animation', 'shared'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'shared'):SetPosition(1340, 200)

    RMenu:Get('animation', 'sit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'sit'):SetPosition(1340, 200)

    RMenu:Get('animation', 'pegi'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'pegi'):SetPosition(1340, 200)

    RMenu:Get('animation', 'vehicle'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'vehicle'):SetPosition(1340, 200)

    RMenu:Get('animation', 'neige'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'neige'):SetPosition(1340, 200)

    RMenu:Get('animation', 'sports'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'sports'):SetPosition(1340, 200)

    RMenu:Get('animation', 'salutes'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'salutes'):SetPosition(1340, 200)

    RMenu:Get('animation', 'poses'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'poses'):SetPosition(1340, 200)

    RMenu:Get('animation', 'gangs'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'gangs'):SetPosition(1340, 200)

    RMenu:Get('animation', 'meme'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('animation', 'meme'):SetPosition(1340, 200)

    RMenu:Get('animation', "main").Closed = function()
        inMenu = false
        if emotePed ~= nil then
            DeleteEntity(emotePed)
            emotePed = nil
        end
        if prop ~= nil then
            DeleteEntity(prop)
            prop = nil
        end

        for k,v in pairs(PropETable) do
            DeleteEntity(v)
        end

        RMenu:Delete('animation', 'main')
        RMenu:Delete('animation', 'animations')
        RMenu:Delete('animation', 'aimstyles')
        RMenu:Delete('animation', 'holsterAnim')
        RMenu:Delete('animation', 'danses')
        RMenu:Delete('animation', 'animals')
        RMenu:Delete('animation', 'objects')
        RMenu:Delete('animation', 'shared')
        RMenu:Delete('animation', 'sit')
        RMenu:Delete('animation', 'pegi')
        RMenu:Delete('animation', 'vehicle')
        RMenu:Delete('animation', 'neige')
        RMenu:Delete('animation', 'sports')
        RMenu:Delete('animation', 'salutes')
        RMenu:Delete('animation', 'poses')
        RMenu:Delete('animation', 'gangs')
        RMenu:Delete('animation', 'meme')
    end

    if inMenu then
        inMenu = false
        return
    else
        RageUI.CloseAll()

        inMenu = true
        RageUI.Visible(RMenu:Get('animation', 'main'), true)
    end

    for k,v in pairsByKeys(DP.Emotes) do
        EmoteTable[k] = k
    end

    local choices = {
        [1] = "▶",
        [2] = "🛑",
    }
    for i=1, 5 do
        choices[2+i] = "Raccourcis #"..i
    end

    local expression = {
        [1] = "▶",
        [2] = "⭐",
    }

    local currentIndex = {}

    local emoteFilterQuery = ""
    local emoteFilterResults = {}

    local function buildEmoteFilter(q)
        emoteFilterResults = {}
        if not q or q == "" then return end
        local s = string.lower(q)
        local function add(tbl, cat)
            if not tbl then return end
            for k,v in pairsByKeys(tbl) do
                local x,y,z,other = table.unpack(v)
                local label = z or tostring(k)
                local lk = string.lower(tostring(k))
                local ll = string.lower(tostring(label))
                if string.find(lk, s, 1, true) or string.find(ll, s, 1, true) then
                    table.insert(emoteFilterResults, {key=k, label=label, cat=cat, dict=x, anim=y, opts=tbl[k].AnimationOptions, other=other})
                end
            end
        end
        add(DP.Emotes,'emotes')
        add(DP.Dances,'dances')
        add(DP.AnimalEmotes,'animals')
        add(DP.PropEmotes,'props')
        add(DP.Shared,'shared')
        add(DP.Sits,'sit')
        add(DP.Pegi,'pegi')
        add(DP.Sports,'sports')
        add(DP.Salutes,'salutes')
        add(DP.Poses,'poses')
        add(DP.Gangs,'gangs')
        add(DP.VehicleAnimations,'vehicle')
        add(DP.Meme,'meme')
        if DP.Neige then add(DP.Neige,'neige') end
    end

    local holsterAnims = {
        {name = nil, label = "Par défaut"},
        {name = "BackHolsterAnimation", label = "Sort du dos"},
        {name = "SideHolsterAnimation", label = "Sort du côté droit"},
        {name = "SideLegHolsterAnimation", label = "Sort du côté droit #2"},
        {name = "FrontHolsterAnimation", label = "Sort du côté gauche"},
        {name = "AgressiveFrontHolsterAnimation", label = "Sort du côté gauche agressif"},
    }
    local function createClone()
        local clone = ClonePed(PlayerPedId(), false, false, true)

        FreezeEntityPosition(clone, true)

        SetEntityVisible(clone, false, false)

        SetEntityInvincible(clone, true)

        SetEntityCanBeDamaged(clone, false)

        SetPedCanRagdoll(clone, false)

        SetPedCanRagdollFromPlayerImpact(clone, false)
        SetEntityCollision(clone, false)
        return clone
    end
    local function RotationToDirection(rotation)
        local adjustedRotation = vector3(
            (math.pi / 180) * rotation.x,
            (math.pi / 180) * rotation.y,
            (math.pi / 180) * rotation.z
        )
        local direction = vector3(
            -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
            math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
            math.sin(adjustedRotation.x)
        )
        return direction
    end

    if emotePed ~= nil then
        DeletePed(emotePed)
    end
    emotePed = nil
    emotePed = createClone()
    currentEmote = nil
    local lastAnim = nil
    Citizen.CreateThread(function()
        while inMenu do
            Wait(1)
            if emotePed then
                local coordsCam = GetGameplayCamCoord()
                local rot = GetGameplayCamRot(2)
                local forward = RotationToDirection(rot)
                local right = RotationToDirection(vector3(rot.x, rot.y, rot.z - 90.0))
                local up = vector3(0.0, 0.0, 1.0)

                local forwardOffset = 5.2
                local rightOffset = 1.2
                local upOffset = 0.5

                local pedCoords = coordsCam + forward * forwardOffset + right * rightOffset + up * upOffset

                SetEntityCoordsNoOffset(emotePed, pedCoords.x, pedCoords.y, pedCoords.z, true, true, true)
                SetEntityVisible(emotePed, true, false)
                SetEntityHeading(emotePed, rot.z + 180)
                CreateThread(function()
                end)

                local emote = currentEmote
                if emote ~= nil then
                    if emote.dict ~= nil and emote.anim ~= nil  then
                        if lastAnim == nil then
                            lastAnim = emote
                            if prop ~= nil then
                                DeleteEntity(prop)
                                prop = nil
                            end
                            if emote.dict ~= "MaleScenario" and emote.dict ~= "Scenario" and emote.dict ~= "Expression" then
                                ClearPedTasksImmediately(emotePed)
                                ResetPedMovementClipset(emotePed)

                                CreateThread(function()
                                    while not HasAnimDictLoaded(emote.dict) do
                                        RequestAnimDict(emote.dict)
                                        Wait(10)
                                    end
                                    TaskPlayAnim(emotePed, emote.dict, emote.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                                end)
                                while not HasAnimDictLoaded(emote.dict) do
                                    RequestAnimDict(emote.dict)
                                    Wait(10)
                                end
                                TaskPlayAnim(emotePed, emote.dict, emote.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                            else
                                if emote.dict == "Expression" then
                                    SetFacialIdleAnimOverride(emotePed, emote.anim, 0)
                                else
                                    ClearPedTasksImmediately(emotePed)
                                    ResetPedMovementClipset(emotePed)
                                    TaskStartScenarioInPlace(emotePed, emote.anim, 0, true)
                                end
                            end
                        end
                        if lastAnim ~= nil and lastAnim.dict ~= nil and lastAnim.anim ~= nil then
                            if lastAnim.anim ~= emote.anim then
                                if prop ~= nil then
                                    DeleteEntity(prop)
                                    prop = nil
                                end
                                if emote.dict ~= "MaleScenario" and emote.dict ~= "Scenario" and emote.dict ~= "Expression" then
                                    ClearPedTasksImmediately(emotePed)

                                    if emote.dict and emote.anim then
                                        CreateThread(function()
                                            while not HasAnimDictLoaded(emote.dict) do
                                                RequestAnimDict(emote.dict)
                                                Wait(10)
                                            end
                                            TaskPlayAnim(emotePed, emote.dict, emote.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                                        end)
                                    end
                                else
                                    if emote.dict == "Expression" then
                                        SetFacialIdleAnimOverride(emotePed, emote.anim, 0)
                                    else
                                        ClearPedTasksImmediately(emotePed)
                                        TaskStartScenarioInPlace(emotePed, emote.anim, 0, true)
                                    end
                                end
                                lastAnim = emote
                                if emote.prop ~= nil and emote.propbone ~= nil and emote.PropPlacement ~= nil then
                                    if prop ~= nil then
                                        DeleteEntity(prop)
                                        prop = nil
                                    end
                                    local Player = emotePed
                                    local x, y, z = table.unpack(GetEntityCoords(Player))
                                    if emote.dict ~= "MaleScenario" and emote.dict ~= "Scenario" and emote.dict ~= "Expression" and emote.prop ~= nil then
                                        if IsModelInCdimage(GetHashKey(emote.prop)) and IsModelValid(GetHashKey(emote.prop)) then

                                            CreateThread(function()
                                                LoadPropDict(emote.prop)
                                                prop = CreateObject(GetHashKey(emote.prop), x, y, z + 0.2, false, false, false)
                                                table.insert(PropETable, prop)
                                                AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, emote.propbone), emote.PropPlacement[1], emote.PropPlacement[2], emote.PropPlacement[3], emote.PropPlacement[4], emote.PropPlacement[5], emote.PropPlacement[6], true, true, false, true, 1, true)
                                                SetModelAsNoLongerNeeded(emote.prop)
                                            end)
                                        else
                                            print("passe pas "..emote.prop)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

            else
                if emotePed then
                    SetEntityVisible(emotePed, false, false)
                end
            end

            RageUI.IsVisible(RMenu:Get('animation', 'main'), true, false, true, function()
                RageUI.ButtonWithStyle("Animations", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'animations'))
                RageUI.ButtonWithStyle("Humeur", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'humor'))
                RageUI.ButtonWithStyle("Démarche", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'walks'))
                RageUI.ButtonWithStyle("Style de visée", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'aimstyles'))
                RageUI.ButtonWithStyle("Animation sortie d'arme", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'holsterAnim'))
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'holsterAnim'), true, false, true, function()

                for k,v in pairs(holsterAnims) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetResourceKvp("HolsterAnim", v.name)
                            playerHolsterAnim = GetResourceKvpString("HolsterAnim")
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'aimstyles'), true, false, true, function()

                if currentIndex["aimstyle"] == nil then
                    local saved = tonumber(GetResourceKvpString("gunstyle") or "")
                    if saved and DP.GunStyles[saved] then
                        currentIndex["aimstyle"] = saved
                    else
                        currentIndex["aimstyle"] = 1
                    end
                end
                if not DP.GunStyles[currentIndex["aimstyle"]] then
                    currentIndex["aimstyle"] = 1
                end
                RageUI.ButtonWithStyle("Style de visée", nil, {RightLabel = "← "..DP.GunStyles[currentIndex["aimstyle"]].name.." →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 174) then
                            if currentIndex["aimstyle"] - 1 < 1 then
                                currentIndex["aimstyle"] = #DP.GunStyles
                            else
                                currentIndex["aimstyle"] = currentIndex["aimstyle"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if currentIndex["aimstyle"] + 1 > #DP.GunStyles then
                                currentIndex["aimstyle"] = 1
                            else
                                currentIndex["aimstyle"] = currentIndex["aimstyle"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                        if DP.GunStyles[currentIndex["aimstyle"]].a ~= nil and DP.GunStyles[currentIndex["aimstyle"]].b ~= nil and DP.GunStyles[currentIndex["aimstyle"]].c ~= nil  then
                            currentEmote = {dict = DP.GunStyles[currentIndex["aimstyle"]].b, anim = DP.GunStyles[currentIndex["aimstyle"]].c}
                        elseif DP.GunStyles[currentIndex["aimstyle"]].a ~= nil and DP.GunStyles[currentIndex["aimstyle"]].b == nil and DP.GunStyles[currentIndex["aimstyle"]].c == nil then
                            currentEmote = {dict = "zizi"}

                        end
                    end

                    if Selected then
                        SetResourceKvp("gunstyle", tostring(currentIndex["aimstyle"]))

                        DecorSetInt(PlayerPedId(), "gunstyle", currentIndex["aimstyle"])
                        SetWeaponAnimationOverride(PlayerPedId(), GetHashKey(DP.GunStyles[currentIndex["aimstyle"]].a))
                        ClearPedTasks(PlayerPedId())
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'walks'), true, false, true, function()

                if currentIndex["Par défaut"] == nil then currentIndex["Par défaut"] = 1 end
                RageUI.ButtonWithStyle("Par défaut", nil, {RightLabel = "← "..expression[currentIndex["Par défaut"]].." →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 174) then
                            if currentIndex["Par défaut"] - 1 < 1 then
                                currentIndex["Par défaut"] = #expression
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if currentIndex["Par défaut"] + 1 > #expression then
                                currentIndex["Par défaut"] = 1
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                        currentEmote = {dict = "zizi"}

                    end

                    if Selected then
                        if expression[currentIndex["Par défaut"]] == "▶" then
                            ResetPedMovementClipset(PlayerPedId())
                        elseif expression[currentIndex["Par défaut"]] == "⭐" then
                            if GetResourceKvpString("favoriteWalk") then
                                DeleteResourceKvp("favoriteWalk")
                            end

                            ResetPedMovementClipset(PlayerPedId())
                        end
                    end
                end)

                for k,v in pairsByKeys(DP.Walks) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(k, nil, {RightLabel = "← "..expression[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #expression
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #expression then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Walks[k] then
                                currentEmote = { dict = x }
                            end
                        end

                        if Selected then
                            if expression[currentIndex[k]] == "▶" then
                                RequestDemarcheThing(tostring(x))
                                SetPedMovementClipset(PlayerPedId(), tostring(x), 0.2)
                                RemoveAnimSet(tostring(x))
                                TriggerServerEvent("dpemote:server:setDemarche", tostring(x))
                            elseif expression[currentIndex[k]] == "⭐" then

                                RequestDemarcheThing(tostring(x))
                                SetPedMovementClipset(PlayerPedId(), tostring(x), 0.2)
                                RemoveAnimSet(tostring(x))
                                TriggerServerEvent("dpemote:server:setDemarche", tostring(x))
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'humor'), true, false, true, function()

                if currentIndex["Par défaut"] == nil then currentIndex["Par défaut"] = 1 end
                RageUI.ButtonWithStyle("Par défaut", nil, {RightLabel = "← "..expression[currentIndex["Par défaut"]].." →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 174) then
                            if currentIndex["Par défaut"] - 1 < 1 then
                                currentIndex["Par défaut"] = #expression
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if currentIndex["Par défaut"] + 1 > #expression then
                                currentIndex["Par défaut"] = 1
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                    end

                    if Selected then
                        if expression[currentIndex["Par défaut"]] == "▶" then
                            ClearFacialIdleAnimOverride(PlayerPedId())
                        elseif expression[currentIndex["Par défaut"]] == "⭐" then
                            if GetResourceKvpString("favoritehumor") then
                                DeleteResourceKvp("favoritehumor")
                            end

                            ClearFacialIdleAnimOverride(PlayerPedId())
                        end
                    end
                end)

                for k,v in pairsByKeys(DP.Expressions) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(k, nil, {RightLabel = "← "..expression[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #expression
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #expression then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            currentEmote = {dict = DP.Expressions[k][1], anim = DP.Expressions[k][2]}

                        end

                        if Selected and CanPlayEmote() then
                            if expression[currentIndex[k]] == "▶" then
                                EmoteMenuStart(tostring(k), "expression")
                            elseif expression[currentIndex[k]] == "⭐" then
                                SetResourceKvp("favoritehumor", tostring(k))
                                EmoteMenuStart(tostring(k), "expression")
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'animations'), true, false, true, function()

                RageUI.ButtonWithStyle("Ajuster l'animation", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("adjust")
                        inMenu = false
                        RageUI.CloseAll()
                    end
                end)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("Danses", nil, {RightLabel = "🕺🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'danses'))
                RageUI.ButtonWithStyle("Animations en véhicule", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'vehicle'))

                RageUI.ButtonWithStyle("Animations d'animaux", nil, {RightLabel = "🐶"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'animals'))
                RageUI.ButtonWithStyle("Animations avec objet", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'objects'))
                RageUI.ButtonWithStyle("Animations partagées", nil, {RightLabel = "🧒🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'shared'))
                RageUI.ButtonWithStyle("Animations pour s'asseoir", nil, {RightLabel = "🪑"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'sit'))
                RageUI.ButtonWithStyle("Animations de sport", nil, {RightLabel = "🏋🏽‍♀️"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'sports'))
                RageUI.ButtonWithStyle("Animations de saluts", nil, {RightLabel = "🖖🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'salutes'))
                RageUI.ButtonWithStyle("Animations de poses", nil, {RightLabel = "🕺🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'poses'))
                RageUI.ButtonWithStyle("Animations PEGI 18", nil, {RightLabel = "🔞"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'pegi'))
                RageUI.ButtonWithStyle("Animations de gangs", nil, {RightLabel = "🔪"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'gangs'))
                RageUI.ButtonWithStyle("Animations de meme", nil, {RightLabel = "😂"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'meme'))

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Filtrer les animations", emoteFilterQuery ~= "" and ("Filtre: "..emoteFilterQuery) or nil, {RightLabel = "🔎"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local q = EmoteTextInput("Rechercher", emoteFilterQuery, 30)
                        if q == nil then return end
                        emoteFilterQuery = q
                        buildEmoteFilter(emoteFilterQuery)
                    end
                end)

                if emoteFilterQuery ~= "" then
                    RageUI.ButtonWithStyle("Effacer le filtre", nil, {RightLabel = "✖"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            emoteFilterQuery = ""
                            emoteFilterResults = {}
                        end
                    end)
                    for i,res in ipairs(emoteFilterResults) do
                        local key = "filter:"..res.cat..":"..res.key
                        if currentIndex[key] == nil then currentIndex[key] = 1 end
                        RageUI.ButtonWithStyle(res.label, "/e ("..res.key..")", {RightLabel="← "..choices[currentIndex[key]].." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[key] - 1 < 1 then currentIndex[key] = #choices else currentIndex[key] = currentIndex[key] - 1 end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET","NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[key] + 1 > #choices then currentIndex[key] = 1 else currentIndex[key] = currentIndex[key] + 1 end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET","NAV_LEFT_RIGHT")
                                end
                                if res.dict and res.anim then
                                    if res.opts and res.opts.Prop then
                                        currentEmote = {dict=res.dict, anim=res.anim, prop=res.opts.Prop, propbone=res.opts.PropBone, PropPlacement=res.opts.PropPlacement}
                                    else
                                        currentEmote = {dict=res.dict, anim=res.anim}
                                    end
                                end
                            end
                            if Selected then
                                local ch = choices[currentIndex[key]]
                                if ch == "▶" then
                                    if res.cat == "shared" then
                                        target, distance = GetClosestPlayer()
                                        if distance ~= -1 and distance < 3 then
                                            TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), tostring(string.lower(res.key)))
                                            SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                        else
                                            SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                        end
                                    else
                                        if CanPlayEmote() then
                                            EmoteMenuStart(tostring(string.lower(res.key)), res.cat)
                                        end
                                    end
                                elseif ch == "🛑" then
                                    EmoteCancel()
                                else
                                    local idx = tonumber(string.match(ch, "%d+"))
                                    if idx then
                                        SetResourceKvp("bindedanim_"..idx, tostring(string.lower(res.key)))
                                    end
                                end
                            end
                        end)
                    end
                    RageUI.Separator("")
                end

                for k,v in pairsByKeys(DP.Emotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Emotes[k][1] ~= nil and DP.Emotes[k][2] ~= nil then
                                if DP.Emotes[k].AnimationOptions ~= nil and DP.Emotes[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Emotes[k][1], anim = DP.Emotes[k][2], prop = DP.Emotes[k].AnimationOptions.Prop, propbone = DP.Emotes[k].AnimationOptions.PropBone, PropPlacement = DP.Emotes[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Emotes[k][1], anim = DP.Emotes[k][2]}
                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "emotes")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'danses'), true, false, true, function()

                for k,v in pairsByKeys(DP.Dances) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Dances[k][1] ~= nil and DP.Dances[k][2] ~= nil then
                                if DP.Dances[k].AnimationOptions ~= nil and DP.Dances[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Dances[k][1], anim = DP.Dances[k][2], prop = DP.Dances[k].AnimationOptions.Prop, propbone = DP.Dances[k].AnimationOptions.PropBone, PropPlacement = DP.Dances[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Dances[k][1], anim = DP.Dances[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "dances")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'animals'), true, false, true, function()

                for k,v in pairsByKeys(DP.AnimalEmotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.AnimalEmotes[k][1] ~= nil and DP.AnimalEmotes[k][2] ~= nil then
                                if DP.AnimalEmotes[k].AnimationOptions ~= nil and DP.AnimalEmotes[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.AnimalEmotes[k][1], anim = DP.AnimalEmotes[k][2], prop = DP.AnimalEmotes[k].AnimationOptions.Prop, propbone = DP.AnimalEmotes[k].AnimationOptions.PropBone, PropPlacement = DP.AnimalEmotes[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.AnimalEmotes[k][1], anim = DP.AnimalEmotes[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "animals")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'objects'), true, false, true, function()

                for k,v in pairsByKeys(DP.PropEmotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.PropEmotes[k][1] ~= nil and DP.PropEmotes[k][2] ~= nil then
                                if DP.PropEmotes[k].AnimationOptions ~= nil and DP.PropEmotes[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.PropEmotes[k][1], anim = DP.PropEmotes[k][2], prop = DP.PropEmotes[k].AnimationOptions.Prop, propbone = DP.PropEmotes[k].AnimationOptions.PropBone, PropPlacement = DP.PropEmotes[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.PropEmotes[k][1], anim = DP.PropEmotes[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "props")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'shared'), true, false, true, function()

                for k,v in pairsByKeys(DP.Shared) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z, otheremotename = table.unpack(v)
                    if otheremotename == nil then
                        RageUI.ButtonWithStyle(z, "/nearby (~g~"..k.."~s~)", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end

                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end

                                if DP.Shared[k][1] ~= nil and DP.Shared[k][2] ~= nil then
                                    if DP.Shared[k].AnimationOptions ~= nil and DP.Shared[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2], prop = DP.Shared[k].AnimationOptions.Prop, propbone = DP.Shared[k].AnimationOptions.PropBone, PropPlacement = DP.Shared[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2]}

                                    end
                                end
                            end

                            if Selected then
                                target, distance = GetClosestPlayer()
                                if (distance ~= -1 and distance < 3) then
                                    local targetPed = GetPlayerPed(target)
                                    if IsEntityDead(targetPed) then
                                        SimpleNotify("~r~Vous ne pouvez pas faire cette interaction avec un joueur inconscient.")
                                        return
                                    end

                                    _, _, rename = table.unpack(DP.Shared[tostring(string.lower(k))])
                                    TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), tostring(string.lower(k)))
                                    SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                else
                                    SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                end
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(z, "/nearby (~g~"..k.."~s~) "..CFGDPEMOTES.Languages[lang]['makenearby'].." (~y~"..otheremotename.."~s~)", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end

                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Shared[k][1] ~= nil and DP.Shared[k][2] ~= nil then
                                    if DP.Shared[k].AnimationOptions ~= nil and DP.Shared[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2], prop = DP.Shared[k].AnimationOptions.Prop, propbone = DP.Shared[k].AnimationOptions.PropBone, PropPlacement = DP.Shared[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2]}

                                    end
                                end

                            end

                            if Selected then
                                target, distance = GetClosestPlayer()
                                if (distance ~= -1 and distance < 3) then
                                    _, _, rename = table.unpack(DP.Shared[tostring(string.lower(k))])
                                    TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), tostring(string.lower(k)))
                                    SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                else
                                    SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                end
                            end
                        end)
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'poses'), true, false, true, function()

                for k,v in pairsByKeys(DP.Poses) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if DP.Poses[k][1] ~= nil and DP.Poses[k][2] ~= nil then
                                if DP.Poses[k].AnimationOptions ~= nil and DP.Poses[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Poses[k][1], anim = DP.Poses[k][2], prop = DP.Poses[k].AnimationOptions.Prop, propbone = DP.Poses[k].AnimationOptions.PropBone, PropPlacement = DP.Poses[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Poses[k][1], anim = DP.Poses[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "poses")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'salutes'), true, false, true, function()

                for k,v in pairsByKeys(DP.Salutes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if DP.Salutes[k][1] ~= nil and DP.Salutes[k][2] ~= nil then
                                if DP.Salutes[k].AnimationOptions ~= nil and DP.Salutes[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Salutes[k][1], anim = DP.Salutes[k][2], prop = DP.Salutes[k].AnimationOptions.Prop, propbone = DP.Salutes[k].AnimationOptions.PropBone, PropPlacement = DP.Salutes[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Salutes[k][1], anim = DP.Salutes[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "salutes")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'vehicle'), true, false, true, function()

                for k,v in pairsByKeys(DP.VehicleAnimations) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")

                            end
                            if DP.VehicleAnimations[k][1] ~= nil and DP.VehicleAnimations[k][2] ~= nil then
                                if DP.VehicleAnimations[k].AnimationOptions ~= nil and DP.VehicleAnimations[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.VehicleAnimations[k][1], anim = DP.VehicleAnimations[k][2], prop = DP.VehicleAnimations[k].AnimationOptions.Prop, propbone = DP.VehicleAnimations[k].AnimationOptions.PropBone, PropPlacement = DP.VehicleAnimations[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.VehicleAnimations[k][1], anim = DP.VehicleAnimations[k][2]}

                                end
                            end
                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "vehicle")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'neige'), true, false, true, function()

                for k,v in pairsByKeys(DP.Neige) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Neige[k][1] ~= nil and DP.Neige[k][2] ~= nil then
                                if DP.Neige[k].AnimationOptions ~= nil and DP.Neige[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Neige[k][1], anim = DP.Neige[k][2], prop = DP.Neige[k].AnimationOptions.Prop, propbone = DP.Neige[k].AnimationOptions.PropBone, PropPlacement = DP.Neige[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Neige[k][1], anim = DP.Neige[k][2]}
                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "neige")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'sports'), true, false, true, function()

                for k,v in pairsByKeys(DP.Sports) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Sports[k][1] ~= nil and DP.Sports[k][2] ~= nil then
                                if DP.Sports[k].AnimationOptions ~= nil and DP.Sports[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Sports[k][1], anim = DP.Sports[k][2], prop = DP.Sports[k].AnimationOptions.Prop, propbone = DP.Sports[k].AnimationOptions.PropBone, PropPlacement = DP.Sports[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Sports[k][1], anim = DP.Sports[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "sports")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'pegi'), true, false, true, function()

                for k,v in pairsByKeys(DP.Pegi) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Pegi[k][1] ~= nil and DP.Pegi[k][2] ~= nil then
                                if DP.Pegi[k].AnimationOptions ~= nil and DP.Pegi[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Pegi[k][1], anim = DP.Pegi[k][2], prop = DP.Pegi[k].AnimationOptions.Prop, propbone = DP.Pegi[k].AnimationOptions.PropBone, PropPlacement = DP.Pegi[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Pegi[k][1], anim = DP.Pegi[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "pegi")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'gangs'), true, false, true, function()

                for k,v in pairsByKeys(DP.Gangs) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Gangs[k][1] ~= nil and DP.Gangs[k][2] ~= nil then
                                if DP.Gangs[k].AnimationOptions ~= nil and DP.Gangs[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Gangs[k][1], anim = DP.Gangs[k][2], prop = DP.Gangs[k].AnimationOptions.Prop, propbone = DP.Gangs[k].AnimationOptions.PropBone, PropPlacement = DP.Gangs[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Gangs[k][1], anim = DP.Gangs[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "gangs")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'meme'), true, false, true, function()

                for k,v in pairsByKeys(DP.Meme) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Meme[k][1] ~= nil and DP.Meme[k][2] ~= nil then
                                if DP.Meme[k].AnimationOptions ~= nil and DP.Meme[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Meme[k][1], anim = DP.Meme[k][2], prop = DP.Meme[k].AnimationOptions.Prop, propbone = DP.Meme[k].AnimationOptions.PropBone, PropPlacement = DP.Meme[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Meme[k][1], anim = DP.Meme[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "meme")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('animation', 'sit'), true, false, true, function()

                for k,v in pairsByKeys(DP.Sits) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "← "..choices[currentIndex[k]].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if DP.Sits[k][1] ~= nil and DP.Sits[k][2] ~= nil then
                                if DP.Sits[k].AnimationOptions ~= nil and DP.Sits[k].AnimationOptions.Prop then
                                    currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2], prop = DP.Sits[k].AnimationOptions.Prop, propbone = DP.Sits[k].AnimationOptions.PropBone, PropPlacement = DP.Sits[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                if CanPlayEmote() then
                                    EmoteMenuStart(tostring(string.lower(k)), "sit")
                                end
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end

            end)

        end
    end)
end

rightPosition = { x = 1450, y = 100 }
leftPosition = { x = 0, y = 100 }
menuPosition = { x = 0, y = 200 }

if CFGDPEMOTES.MenuPosition then
    if CFGDPEMOTES.MenuPosition == "left" then
        menuPosition = leftPosition
    elseif CFGDPEMOTES.MenuPosition == "right" then
        menuPosition = rightPosition
    end
end

if CFGDPEMOTES.CustomMenuEnabled then
    local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
    local Object = CreateDui(CFGDPEMOTES.MenuImage, 512, 128)
    _G.Object = Object
    local TextureThing = GetDuiHandle(Object)
    local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
    Menuthing = "Custom_Menu_Head"
else
    Menuthing = "shopui_title_sm_hangar"
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

lang = CFGDPEMOTES.MenuLanguage

function AddEmoteMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['emotes'], "", "", Menuthing, Menuthing)
    local dancemenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['danceemotes'], "", "", Menuthing, Menuthing)
    local animalmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['animalemotes'], "", "", Menuthing, Menuthing)
    local propmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['propemotes'], "", "", Menuthing, Menuthing)
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['danceemotes'])
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['danceemotes'])
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['animalemotes'])

    if CFGDPEMOTES.SharedEmotesEnabled then
        sharemenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['shareemotes'], CFGDPEMOTES.Languages[lang]['shareemotesinfo'], "", Menuthing, Menuthing)
        shareddancemenu = _menuPool:AddSubMenu(sharemenu, CFGDPEMOTES.Languages[lang]['sharedanceemotes'], "", "", Menuthing, Menuthing)
        table.insert(ShareTable, 'none')
        table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['shareemotes'])
    end

    if not CFGDPEMOTES.SqlKeybinding then
        unbind2item = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['rfavorite'], CFGDPEMOTES.Languages[lang]['rfavorite'])
        unbinditem = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['prop2info'], "")
        favmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['favoriteemotes'], CFGDPEMOTES.Languages[lang]['favoriteinfo'], "", Menuthing, Menuthing)
        favmenu:AddItem(unbinditem)
        favmenu:AddItem(unbind2item)
        table.insert(FavEmoteTable, CFGDPEMOTES.Languages[lang]['rfavorite'])
        table.insert(FavEmoteTable, CFGDPEMOTES.Languages[lang]['rfavorite'])
        table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['favoriteemotes'])
    else
        table.insert(EmoteTable, "keybinds")
        keyinfo = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['keybinds'], CFGDPEMOTES.Languages[lang]['keybindsinfo'] .. " /emotebind [~y~num4-9~s~] [~g~emotename~s~]")
        submenu:AddItem(keyinfo)
    end

    for a, b in pairsByKeys(DP.Emotes) do
        x, y, z = table.unpack(b)
        emoteitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        submenu:AddItem(emoteitem)
        table.insert(EmoteTable, a)
        if not CFGDPEMOTES.SqlKeybinding then
            favemoteitem = NativeUI.CreateItem(z, CFGDPEMOTES.Languages[lang]['set'] .. z .. CFGDPEMOTES.Languages[lang]['setboundemote'])
            favmenu:AddItem(favemoteitem)
            table.insert(FavEmoteTable, a)
        end
    end

    for a, b in pairsByKeys(DP.Dances) do
        x, y, z = table.unpack(b)
        danceitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        sharedanceitem = NativeUI.CreateItem(z, "")
        dancemenu:AddItem(danceitem)
        if CFGDPEMOTES.SharedEmotesEnabled then
            shareddancemenu:AddItem(sharedanceitem)
        end
        table.insert(DanceTable, a)
    end

    for a, b in pairsByKeys(DP.AnimalEmotes) do
        x, y, z = table.unpack(b)
        animalitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        animalmenu:AddItem(animalitem)
        table.insert(AnimalTable, a)
    end

    if CFGDPEMOTES.SharedEmotesEnabled then
        for a, b in pairsByKeys(DP.Shared) do
            x, y, z, otheremotename = table.unpack(b)
            if otheremotename == nil then
                shareitem = NativeUI.CreateItem(z, "/nearby (~g~" .. a .. "~s~)")
            else
                shareitem = NativeUI.CreateItem(z, "/nearby (~g~" .. a .. "~s~) " .. CFGDPEMOTES.Languages[lang]['makenearby'] .. " (~y~" .. otheremotename .. "~s~)")
            end
            sharemenu:AddItem(shareitem)
            table.insert(ShareTable, a)
        end
    end

    for a, b in pairsByKeys(DP.PropEmotes) do
        x, y, z = table.unpack(b)
        propitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        propmenu:AddItem(propitem)
        table.insert(PropETable, a)
        if not CFGDPEMOTES.SqlKeybinding then
            propfavitem = NativeUI.CreateItem(z, CFGDPEMOTES.Languages[lang]['set'] .. z .. CFGDPEMOTES.Languages[lang]['setboundemote'])
            favmenu:AddItem(propfavitem)
            table.insert(FavEmoteTable, a)
        end
    end

    if not CFGDPEMOTES.SqlKeybinding then
        favmenu.OnItemSelect = function(sender, item, index)
            if FavEmoteTable[index] == CFGDPEMOTES.Languages[lang]['rfavorite'] then
                FavoriteEmote = ""
                ShowNotification(CFGDPEMOTES.Languages[lang]['rfavorite'], 2000)
                return
            end
            if CFGDPEMOTES.FavKeybindEnabled then
                FavoriteEmote = FavEmoteTable[index]
                ShowNotification("~o~" .. firstToUpper(FavoriteEmote) .. CFGDPEMOTES.Languages[lang]['newsetemote'])
            end
        end
    end

    dancemenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(DanceTable[index], "dances")
    end

    animalmenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(AnimalTable[index], "animals")
    end

    if CFGDPEMOTES.SharedEmotesEnabled then
        sharemenu.OnItemSelect = function(sender, item, index)
            if ShareTable[index] ~= 'none' then
                target, distance = GetClosestPlayer()
                if (distance ~= -1 and distance < 3) then
                    _, _, rename = table.unpack(DP.Shared[ShareTable[index]])
                    TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), ShareTable[index])
                    SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
                else
                    SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                end
            end
        end

        shareddancemenu.OnItemSelect = function(sender, item, index)
            target, distance = GetClosestPlayer()
            if (distance ~= -1 and distance < 3) then
                _, _, rename = table.unpack(DP.Dances[DanceTable[index]])
                TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), DanceTable[index], 'Dances')
                SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
            else
                SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
            end
        end
    end

    propmenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(PropETable[index], "props")
    end

    submenu.OnItemSelect = function(sender, item, index)
        if EmoteTable[index] ~= CFGDPEMOTES.Languages[lang]['favoriteemotes'] then
            EmoteMenuStart(EmoteTable[index], "emotes")
        end
    end
end

function AddCancelEmote(menu)
    local newitem = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['cancelemote'], CFGDPEMOTES.Languages[lang]['cancelemoteinfo'])
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, checked_)
        if item == newitem then
            EmoteCancel()
            DestroyAllPropsDP()
        end
    end
end

function AddWalkMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['walkingstyles'], "", "", Menuthing, Menuthing)

    walkreset = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['normalreset'], CFGDPEMOTES.Languages[lang]['resetdef'])
    submenu:AddItem(walkreset)
    table.insert(WalkTable, CFGDPEMOTES.Languages[lang]['resetdef'])

    WalkInjured = NativeUI.CreateItem("Injured", "")
    submenu:AddItem(WalkInjured)
    table.insert(WalkTable, "move_m@injured")

    for a, b in pairsByKeys(DP.Walks) do
        x = table.unpack(b)
        walkitem = NativeUI.CreateItem(a, "")
        submenu:AddItem(walkitem)
        table.insert(WalkTable, x)
    end

    submenu.OnItemSelect = function(sender, item, index)
        if item ~= walkreset then
            WalkMenuStart(WalkTable[index])
        else
            ResetPedMovementClipset(PlayerPedId())
        end
    end
end

function AddFaceMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['moods'], "", "", Menuthing, Menuthing)

    facereset = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['normalreset'], CFGDPEMOTES.Languages[lang]['resetdef'])
    submenu:AddItem(facereset)
    table.insert(FaceTable, "")

    for a, b in pairsByKeys(DP.Expressions) do
        x, y, z = table.unpack(b)
        faceitem = NativeUI.CreateItem(a, "")
        submenu:AddItem(faceitem)
        table.insert(FaceTable, a)
    end

    submenu.OnItemSelect = function(sender, item, index)
        if item ~= facereset then
            EmoteMenuStart(FaceTable[index], "expression")
        else
            ClearFacialIdleAnimOverride(PlayerPedId())
        end
    end
end

function AddInfoMenu(menu)
    if not UpdateAvailable then
        infomenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['infoupdate'], "(1.7.4)", "", Menuthing, Menuthing)
    else
        infomenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['infoupdateav'], CFGDPEMOTES.Languages[lang]['infoupdateavtext'], "", Menuthing, Menuthing)
    end
    contact = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['suggestions'], CFGDPEMOTES.Languages[lang]['suggestionsinfo'])
    u170 = NativeUI.CreateItem("1.7.0", "Added /emotebind [key] [emote]!")
    u165 = NativeUI.CreateItem("1.6.5", "Updated camera/phone/pee/beg, added makeitrain/dance(glowstick/horse).")
    u160 = NativeUI.CreateItem("1.6.0", "Added shared emotes /nearby, or in menu, also fixed some emotes!")
    u151 = NativeUI.CreateItem("1.5.1", "Added /walk and /walks, for walking styles without menu")
    u150 = NativeUI.CreateItem("1.5.0", "Added Facial Expressions menu (if enabled by server owner)")
    infomenu:AddItem(contact)
    infomenu:AddItem(u170)
    infomenu:AddItem(u165)
    infomenu:AddItem(u160)
    infomenu:AddItem(u151)
    infomenu:AddItem(u150)
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

RegisterNetEvent("dp:Update")
AddEventHandler("dp:Update", function(state)
    UpdateAvailable = state
    AddInfoMenu(mainMenu)
    _menuPool:RefreshIndex()
end)

RegisterNetEvent("dp:RecieveMenu")
AddEventHandler("dp:RecieveMenu", function()
    OpenEmoteMenu()
end)

RegisterNetEvent("dp:cancelEmote")
AddEventHandler("dp:cancelEmote", function()
    EmoteCancel()
end)

Citizen.CreateThread(function()
    for i=1, 5 do
        Keys.Register('', 's'..i, "Raccourcis animation #"..i, function()
            if IsPedDeadOrDying(PlayerPedId()) then return end
            if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
                local anim = GetResourceKvpString("bindedanim_"..i)

                if anim and CanPlayEmote() then
                    EmoteCommandStart(0, {
                        [1] = anim
                    })
                end
            end
        end)
    end

    Keys.Register('F7', 'menuAnimation', "Menu animation", function()
        if IsPedDeadOrDying(PlayerPedId()) then return end
        if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
            OpenEmoteMenu()
        end
    end)

    Keys.Register('X', 'cancelAnimation', "Annuler l'animation en cours", function()
        if IsPedDeadOrDying(PlayerPedId()) then return end
        if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
            EmoteCancel()
        end
    end)
end)

RegisterNetEvent("emote:SetDemarche", function (demarche)
    RequestDemarcheThing(tostring(demarche))
    SetPedMovementClipset(PlayerPedId(), tostring(demarche), 0.2)
    RemoveAnimSet(tostring(demarche))
end)

function getCurrentEmote()
    return currentEmote
end
