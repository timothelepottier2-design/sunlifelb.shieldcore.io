local population, blips, inRob = {}, {}, false
local takedBox = false
local CambrioMenu = false

local currentRobbery = nil

local function Cambrio_secondsToClock(seconds)
    local s = math.max(0, math.floor(seconds))
    local m = math.floor(s / 60)
    s = s % 60
    return m, s
end

local function Cambrio_DrawHud(remaining, totalDuration, taked, total)
    local pX, pY = 0.86, 0.30
    local pW, pH = 0.18, 0.16
    local pTop = pY - pH * 0.5
    local pBot = pY + pH * 0.5

    DrawRect(pX, pY, pW, pH, 10, 10, 10, 215)
    DrawRect(pX, pTop + 0.001, pW, 0.002, 255, 117, 31, 255)
    DrawRect(pX, pBot - 0.001, pW, 0.002, 255, 117, 31, 255)

    SetTextFont(4)
    SetTextScale(0.0, 0.34)
    SetTextColour(255, 117, 31, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("CAMBRIOLAGE")
    DrawText(pX, pTop + 0.010)

    SetTextFont(4)
    SetTextScale(0.0, 0.27)
    SetTextColour(138, 138, 138, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("Mission en cours")
    DrawText(pX, pTop + 0.030)

    DrawRect(pX, pTop + 0.052, pW - 0.020, 0.0014, 255, 255, 255, 18)

    local mins, secs = Cambrio_secondsToClock(remaining)
    SetTextFont(7)
    SetTextScale(0.0, 0.65)
    SetTextColour(242, 242, 242, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("%02d:%02d", mins, secs))
    DrawText(pX, pTop + 0.060)

    SetTextFont(4)
    SetTextScale(0.0, 0.27)
    SetTextColour(138, 138, 138, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("OBJETS VOLÉS")
    DrawText(pX, pTop + 0.106)

    SetTextFont(4)
    SetTextScale(0.0, 0.36)
    SetTextColour(242, 242, 242, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("%d / %d", taked or 0, total or 0))
    DrawText(pX, pTop + 0.124)

    local barW = pW - 0.020
    local barH = 0.0050
    local barY = pBot - 0.012
    local barLeft = pX - barW * 0.5
    local ratio = (totalDuration and totalDuration > 0) and (remaining / totalDuration) or 0
    if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end

    DrawRect(pX, barY, barW, barH, 28, 28, 28, 255)
    if ratio > 0 then
        local r, g, b = 255, 117, 31
        if ratio < 0.20 then r, g, b = 220, 50, 50 end
        local fillW = barW * ratio
        DrawRect(barLeft + fillW * 0.5, barY, fillW, barH, r, g, b, 255)
    end
end

local function Cambrio_CountItems(houseId)
    local taked, total = 0, 0
    if cfg_cambriolage and cfg_cambriolage["allHouses"] and cfg_cambriolage["allHouses"][houseId] then
        for _, it in pairs(cfg_cambriolage["allHouses"][houseId].items) do
            total = total + 1
            if it.taked then taked = taked + 1 end
        end
    end
    return taked, total
end

local function Cambrio_StartHud(houseId, duration)
    duration = duration or 120
    currentRobbery = {
        houseId       = houseId,
        deadline      = GetGameTimer() + duration * 1000,
        totalDuration = duration,
    }

    Citizen.CreateThread(function()
        local notified = false
        while inRob and currentRobbery and currentRobbery.houseId == houseId do
            local remaining = math.max(0, math.floor((currentRobbery.deadline - GetGameTimer()) / 1000))
            local taked, total = Cambrio_CountItems(houseId)

            Cambrio_DrawHud(remaining, currentRobbery.totalDuration, taked, total)

            if remaining <= 0 and not notified then
                notified = true
                if ESX and ESX.ShowNotification then
                    ESX.ShowNotification("~r~Le temps imparti pour ce cambriolage est écoulé !")
                end
                inRob = false
                TriggerServerEvent("cambriolage:leave", houseId)
                break
            end

            Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    while true do
        local interval = 1500

        local askedThisTick = false
        for k,v in pairs(cfg_cambriolage["allHouses"]) do
            if v.pos then
                if GetDistanceBetweenCoords(v.pos, GetEntityCoords(PlayerPedId()), false) < 35.0 then
                    interval = 0
                    DrawMarker(6, v.pos.x, v.pos.y, v.pos.z - 1.0, nil, nil, nil, -90, nil, nil, 1.4, 1.4, 1.4, 255, 117, 31, 225, false, false)
                end

                if GetDistanceBetweenCoords(v.pos, GetEntityCoords(PlayerPedId()), false) < 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour cambrioler")

                    if not askedThisTick and IsControlJustReleased(0, 38) then
                        askedThisTick = true
                        TriggerServerEvent("cambriolage:ask", k)
                    end
                else
                    v.called = false
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("cambriolage:start")
AddEventHandler("cambriolage:start", function(houseId, duration)
    inRob = true
    playerIsRobbing = true
    Cambrio_StartHud(houseId, duration)
    Citizen.CreateThread(function()
        while inRob do
            for k, v in pairs(population) do
                if DoesEntityExist(v) and not IsPedDeadOrDying(v, 1) then
                    PlayAmbientSpeech1(v, "GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 0)
                end
            end
            if IsPedDeadOrDying(PlayerPedId(), 1) then
                inRob = false
                TriggerServerEvent("cambriolage:leaveDeath", houseId)
            end
            Wait(4500)
        end
    end)

    Citizen.CreateThread(function()
        while inRob do
            local interval = 500

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 35.0 then
                interval = 0
                DrawMarker(6, cfg_cambriolage["allHouses"][houseId].backCoords.x, cfg_cambriolage["allHouses"][houseId].backCoords.y, cfg_cambriolage["allHouses"][houseId].backCoords.z - 1.0, nil, nil, nil, -90, nil, nil, 0.8, 0.8, 0.8, 255, 117, 31, 225, false, false)
            end

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir")

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("cambriolage:leave", houseId)
                end
            else
                cfg_cambriolage["allHouses"][houseId].calledLeave = false
            end

            Citizen.Wait(interval)
        end
    end)

    Citizen.CreateThread(function()
        while inRob do

            for k,v in pairs(cfg_cambriolage["allHouses"][houseId].items) do
                if not v.taked then
                    DrawMarker(6, v.pos.x, v.pos.y, v.pos.z - 1.0, nil, nil, nil, -90, nil, nil, 1.4, 1.4, 1.4, 255, 117, 31, 225, false, false)

                    if GetDistanceBetweenCoords(v.pos, GetEntityCoords(PlayerPedId()), false) <= 2.0 then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre l'objet")

                        if IsControlJustReleased(0, 38) then
                            if not v.busy and not takedBox then
                                v.busy = true
                                local ped = PlayerPedId()
	                            local coords = GetEntityCoords(ped)
	                            local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

                                TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", -1, true)

                                local rand = math.random(5, 8) * 1000
                                local timeout = GetGameTimer() + rand

                                local success = lib.progressCircle({
                                    duration = rand,
                                    label = '⌛ Cambriolage en cours...',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        car = true,
                                        move = true,
                                        combat = true,
                                    },
                                })
                                if success then
                                    v.taked = true
                                    TakeItemFromProperty(houseId, k)
                                end

                                ClearPedTasksImmediately(ped)
                                v.busy = false
                            end
                        end
                    else
                        v.called = false
                    end
                end
            end

            Wait(0)
        end
    end)

    for id, v in pairs(cfg_cambriolage["allHouses"][houseId].possibleOponents) do
        local model = GetHashKey(v[1])

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end

        local ped = CreatePed(9, model, v[2], v[3], false, false)
        if v[4] ~= nil then
            TaskStartScenarioInPlace(ped, v[4], -1, false)
        end

        if v[5] ~= nil then
            GiveWeaponToPed(ped, GetHashKey(v[5]), 1000, false, true)
        end

        if v[6] then
            SetPedArmour(ped, v[6])
        end

        SetPedSuffersCriticalHits(ped, false)
        population[id] = ped
    end

    local group = AddRelationshipGroup("FAMILY")
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYERS"), group)
    SetRelationshipBetweenGroups(5, group, GetHashKey("PLAYERS"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), group)
    SetRelationshipBetweenGroups(5, group, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, group, group)

    SetRelationshipBetweenGroups(5, GetHashKey("PLAYERS"), GetHashKey("FAMILY"))
    SetRelationshipBetweenGroups(5, GetHashKey("FAMILY"), GetHashKey("PLAYERS"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("FAMILY"))
    SetRelationshipBetweenGroups(5, GetHashKey("FAMILY"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("FAMILY"), GetHashKey("FAMILY"))

    for k, v in pairs(population) do
        if DoesEntityExist(v) then
            SetPedRelationshipGroupHash(v, GetHashKey("FAMILY"))
            SetPedRelationshipGroupDefaultHash(v, GetHashKey("FAMILY"))
            SetBlockingOfNonTemporaryEvents(v, false)
            SetPedHearingRange(v, 10000.0)
            SetPedSeeingRange(v, 10000.0)
            SetPedCombatAttributes(v, 0, true)
            SetPedCombatAttributes(v, 5, true)
            SetPedCombatAttributes(v, 46, true)
        end
    end
end)

RegisterNetEvent("cambriolage:continue")
AddEventHandler("cambriolage:continue", function(houseId, duration)
    inRob = true
    playerIsRobbing = true
    Cambrio_StartHud(houseId, duration)
    Citizen.CreateThread(function()
        while inRob do

            if IsPedDeadOrDying(PlayerPedId(), 1) then
                inRob = false
                TriggerServerEvent("cambriolage:leaveDeath", houseId)
            end
            Wait(4500)
        end
    end)

    Citizen.CreateThread(function()
        while inRob do
            local interval = 500

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 35.0 then
                interval = 0
                DrawMarker(6, cfg_cambriolage["allHouses"][houseId].backCoords.x, cfg_cambriolage["allHouses"][houseId].backCoords.y, cfg_cambriolage["allHouses"][houseId].backCoords.z - 1.0, nil, nil, nil, -90, nil, nil, 0.8, 0.8, 0.8, 255, 117, 31, 225, false, false)
            end

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir")

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("cambriolage:leave", houseId)
                end
            else
                cfg_cambriolage["allHouses"][houseId].calledLeave = false
            end

            Citizen.Wait(interval)
        end
    end)

    Citizen.CreateThread(function()
        while inRob do

            for k,v in pairs(cfg_cambriolage["allHouses"][houseId].items) do
                if not v.taked then
                    DrawMarker(6, v.pos.x, v.pos.y, v.pos.z - 1.0, nil, nil, nil, -90, nil, nil, 1.4, 1.4, 1.4, 255, 117, 31, 225, false, false)

                    if GetDistanceBetweenCoords(v.pos, GetEntityCoords(PlayerPedId()), false) <= 2.0 then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre l'objet")

                        if IsControlJustReleased(0, 38) then
                            if not v.busy and not takedBox then
                                v.busy = true

                                TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", -1, true)

                                local rand = math.random(5, 8) * 1000

                                local success = lib.progressCircle({
                                    duration = rand,
                                    label = '⌛ Cambriolage en cours...',
                                    useWhileDead = false,
                                    canCancel = false,
                                    disable = {
                                        car = true,
                                        move = true,
                                        combat = true,
                                    }
                                })

                                if success then
                                    v.taked = true
                                    TakeItemFromProperty(houseId, k)
                                end

                                ClearPedTasksImmediately(ped)
                                v.busy = false
                            end
                        end
                    else
                        v.called = false
                    end
                end
            end

            Wait(0)
        end
    end)
end)

RegisterNetEvent("cambriolage:enterAsCop")
AddEventHandler("cambriolage:enterAsCop", function(houseId)
    inRob = true
    playerIsRobbing = true
    Citizen.CreateThread(function()
        while inRob do
            if IsPedDeadOrDying(PlayerPedId(), 1) then
                inRob = false
                TriggerServerEvent("cambriolage:leaveDeath", houseId)
            end
            Wait(4500)
        end
    end)

    Citizen.CreateThread(function()
        while inRob do
            local interval = 500

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 35.0 then
                interval = 0
                DrawMarker(6, cfg_cambriolage["allHouses"][houseId].backCoords.x, cfg_cambriolage["allHouses"][houseId].backCoords.y, cfg_cambriolage["allHouses"][houseId].backCoords.z - 1.0, nil, nil, nil, -90, nil, nil, 0.8, 0.8, 0.8, 255, 117, 31, 225, false, false)
            end

            if GetDistanceBetweenCoords(cfg_cambriolage["allHouses"][houseId].backCoords, GetEntityCoords(PlayerPedId()), false) < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir")

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("cambriolage:leave", houseId)
                end
            else
                cfg_cambriolage["allHouses"][houseId].calledLeave = false
            end

            Citizen.Wait(interval)
        end
    end)
end)

RegisterNetEvent("cambriolage:taked")
AddEventHandler("cambriolage:taked", function(houseId, objectId)
    if cfg_cambriolage
    and cfg_cambriolage["allHouses"]
    and cfg_cambriolage["allHouses"][houseId]
    and cfg_cambriolage["allHouses"][houseId].items
    and cfg_cambriolage["allHouses"][houseId].items[objectId] then
        cfg_cambriolage["allHouses"][houseId].items[objectId].taked = true
    end
end)

RegisterNetEvent("cambriolage:leaved")
AddEventHandler("cambriolage:leaved", function()
    inRob = false
    playerIsRobbing = false
    currentRobbery = nil

    for k, v in pairs(blips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end

    for k, v in pairs(population) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end

    blips = {}
    population = {}
end)

Draw2DText = function(x, y, text, scale, colours)
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

TakeItemFromProperty = function(houseId, index)
    TriggerServerEvent("cambriolage:take", houseId, index)
    PlaySound(-1, "SELECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
end

Citizen.CreateThread(function()
	RMenu.Add('menu', 'cambrio', RageUI.CreateMenu("SunLife", "Revendeur", 1, 100))
    RMenu:Get('menu', 'cambrio'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'cambrio').EnableMouse = false
    RMenu:Get('menu', 'cambrio').Closed = function()
		CambrioMenu = false
    end
end)

function openCambrioSellMenu()
	if CambrioMenu then
        RageUI.CloseAll()
        CambrioMenu = false
        return
    else
        CambrioMenu = true
        RageUI.Visible(RMenu:Get('menu', 'cambrio'), true)

        Citizen.CreateThread(function()
            while CambrioMenu do
                RageUI.IsVisible(RMenu:Get('menu', 'cambrio'), true, true, true, function()
                    for k,v in pairs(cfg_cambrio) do
                        RageUI.ButtonWithStyle("Vendre mes " ..v.name, nil, {RightLabel = ESX.Math.GroupDigits(v.price, 2).."$/unité"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                item = v.nameHash
								local count = KeyboardInput("Combien voulez-vous en vendre ?", "", "1", 100)
                                TriggerServerEvent("cambriolage:sellItem", item, count)
                            end
                        end)
                    end
                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local sellcambrioitems = {
	{x = -267.168823, y = 237.538315, z = 89.674623, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(sellcambrioitems) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellcambrioitems[k].x, sellcambrioitems[k].y, sellcambrioitems[k].z)

            if dist <= 3.0 then
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour ouvrir le menu du revendeur")
                DrawMarker(6, sellcambrioitems[k].x, sellcambrioitems[k].y, sellcambrioitems[k].z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                if IsControlJustPressed(1,38) then
					if CambrioMenu == false then
                        openCambrioSellMenu()
					end
                end
            end
		end
		if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

Citizen.CreateThread(function()
    for k in pairs(sellcambrioitems) do
        local sellcambrioblips = AddBlipForCoord(sellcambrioitems[k].x, sellcambrioitems[k].y, sellcambrioitems[k].z)
        SetBlipSprite (sellcambrioblips, 103)
        SetBlipDisplay(sellcambrioblips, 4)
        SetBlipScale(sellcambrioblips, 0.8)
        SetBlipColour (sellcambrioblips, 40)
        SetBlipAsShortRange(sellcambrioblips, true)

        local _key = "BN_SUNLIFE_CAMBRIOLAGE_1_" .. tostring(k)
        AddTextEntry(_key, "Acheteur d'objets volés")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(sellcambrioblips)
    end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
      	Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
      	local result = GetOnscreenKeyboardResult()
      	Citizen.Wait(500)
      	return result
    else
      	Citizen.Wait(500)
      	return nil
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(cfg_cambriolage["allHouses"]) do
        local cambrioblips = AddBlipForCoord(v.pos)
        SetBlipSprite (cambrioblips, 514)
        SetBlipDisplay(cambrioblips, 4)
        SetBlipScale(cambrioblips, 0.8)
        SetBlipColour (cambrioblips, 40)
        SetBlipAsShortRange(cambrioblips, true)

        local _key = "BN_SUNLIFE_CAMBRIOLAGE_2_" .. tostring(k)
        AddTextEntry(_key, "Cambriolage")
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(cambrioblips)
    end
end)

local function _resetHouseLocal(houseId)
    if not cfg_cambriolage
    or not cfg_cambriolage["allHouses"]
    or not cfg_cambriolage["allHouses"][houseId]
    or not cfg_cambriolage["allHouses"][houseId].items then
        return
    end

    for _, data in pairs(cfg_cambriolage["allHouses"][houseId].items) do
        data.taked = false
        data.busy = false
    end
end

RegisterNetEvent("cambriolage:resetHouse")
AddEventHandler("cambriolage:resetHouse", function(houseId)
    if type(houseId) == "table" then
        for i = 1, #houseId do
            _resetHouseLocal(houseId[i])
        end
    else
        _resetHouseLocal(houseId)
    end
end)
