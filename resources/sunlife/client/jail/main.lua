ESX = nil
local JailMenuOpened = false
local wintime = false
InJail = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    RMenu.Add('jail_main', 'debutjail', RageUI.CreateMenu("SunLife", "Prison", 1, 100))
    RMenu:Get('jail_main', 'debutjail'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('jail_main', 'debutjail').EnableMouse = false
    RMenu:Get('jail_main', 'debutjail').Closed = function()
        JailMenuOpened = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
end)

JAIL = {
    ["points"] = {
        ["in"] = {
            {pos = vector3(3963.867432, 48.776920, 22.342361)},
        },
		["out"] = {
            {pos = vector3(1851.411499, 2585.896484, 45.672665)},
        },
        ["task"] = {
            {pos = vector3(3952.036133, 42.213394, 22.342392), heading = 83.143096923828},
            {pos = vector3(3946.386963, 42.762074, 22.342381), heading = 85.368797302246},
            {pos = vector3(3943.775146, 48.693615, 22.342381), heading = 358.71810913086},
            {pos = vector3(3944.624023, 55.276619, 22.342381), heading = 15.862273216248},
            {pos = vector3(3951.697754, 56.295582, 22.342363), heading = 263.04357910156},
            {pos = vector3(3953.189453, 51.687378, 22.353239), heading = 172.57572937012},
            {pos = vector3(3950.599365, 47.564991, 22.352942), heading = 141.35366821289},
            {pos = vector3(3962.753418, 49.330215, 22.342382), heading = 278.33883666992},
            {pos = vector3(3965.312744, 39.729149, 22.342342), heading = 191.58088684082}
        },
        ["jail"] = {
            {pos = vector3(1847.104, 2586.035, 44.75199)},
            {pos = vector3(1825.868, 3687.721, 28.75564)},
            {pos = vector3(-1125.327515, -828.964722, 3.970649)},
            {pos = vector3(-574.9072265625, -431.1540222168, 30.260272598267)},
            {pos = vector3(2829.3422851562, 4714.6469726562, 47.627342224121)},
            {pos = vector3(471.6486, -971.1223, 20.65963)},
            {pos = vector3(3865.718506, -19.683638, 5.713638)},
        },
    },
    Items = {
        "WORLD_HUMAN_GARDENER_PLANT",
        "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
        "WORLD_HUMAN_BUM_WASH",
        "WORLD_HUMAN_CONST_DRILL",
        "WORLD_HUMAN_JANITOR"
    },
}
local _quantite

local _jailModes = nil
local _jailModeIdx = 1
local _jailStationType = nil

local function _isCellMode()
    return _jailModes and _jailModes[_jailModeIdx] and _jailModes[_jailModeIdx].id == "cell"
end

local function _modeBounds()
    if _isCellMode() and JailCellsConfig then
        return JailCellsConfig.min_seconds or 60,
               JailCellsConfig.max_seconds or 3600,
               JailCellsConfig.default_seconds or 300
    end
    return 600, 7200, 600
end

function OpenMyPoliceJailMenu()
    if JailMenuOpened then
        JailMenuOpened = false
        return
    else
        JailMenuOpened = true

        _jailStationType = nil
        if JailCells and JailCells.getStationFromCoords then
            _jailStationType = JailCells.getStationFromCoords(GetEntityCoords(PlayerPedId()))
        end

        _jailModes = { { id = "prison", label = "Prison" } }
        if _jailStationType then
            local lbl = (JailCells and JailCells.getStationLabel and JailCells.getStationLabel(_jailStationType)) or _jailStationType
            table.insert(_jailModes, { id = "cell", label = "Cellule (" .. lbl .. ")" })
        end
        _jailModeIdx = 1
        _quantite = 600

        local curr_pl_billing = ""
        RageUI.Visible(RMenu:Get('jail_main', 'debutjail'), true)

        Citizen.CreateThread(function()
            while JailMenuOpened do
                RageUI.IsVisible(RMenu:Get('jail_main', 'debutjail'), true, true, true, function()

                    if #_jailModes > 1 then
                        local labels = {}
                        for i = 1, #_jailModes do labels[i] = _jailModes[i].label end
                        RageUI.List("Type", labels, _jailModeIdx, "Prison = pénitencier ; Cellule = poste de police local.", {}, true,
                            function(Hovered, Active, Selected, Index)
                                if Index ~= _jailModeIdx then
                                    _jailModeIdx = Index

                                    local _, _, def = _modeBounds()
                                    _quantite = def
                                end
                            end)
                    end

                    RageUI.ButtonWithStyle("Combien de temps ? (Secondes)", nil, {RightLabel = "~o~"..GroupDigits(_quantite).. " seconde(s)"}, true, function(_, _, Selected)
						if Selected then
							SelectNumber()
						end
					end)

                    RageUI.Separator()

                    for _, player in ipairs(GetActivePlayers()) do
                        local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)
                        local coords = GetEntityCoords(GetPlayerPed(player))

                        if dst < 3.0 then
                            RageUI.ButtonWithStyle("Joueur #".._, nil, {RightLabel = curr_pl_billing}, true, function(h, a, s)
                                if a then
                                    DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                    curr_pl_billing = ""
                                else
                                    curr_pl_billing = "🩹"
                                end
                                if s then
                                    local minS, maxS = _modeBounds()
                                    if _quantite < minS or _quantite > maxS then
                                        ESX.ShowNotification(("~r~Durée invalide pour ce mode (%d - %d s)."):format(minS, maxS))
                                    elseif _isCellMode() then
                                        TriggerServerEvent("jail:cells:put", GetPlayerServerId(player), _jailStationType, _quantite)
                                        RageUI.CloseAll()
                                        JailMenuOpened = false
                                    else
                                        TriggerServerEvent("jail:sendPlayerToJail", GetPlayerServerId(player), _quantite)
                                        RageUI.CloseAll()
                                        JailMenuOpened = false
                                    end
                                end
                            end)
                        end
                    end

                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

Citizen.CreateThread(function()
    while true do
        local nearThing = false

        for k,v in pairs(JAIL["points"]["jail"]) do

            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

            if dist <= 3.5 then
                nearThing = true
                DrawMarker(6, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu de la prison")
                if IsControlJustPressed(0, 38) then
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' then
                        if JailMenuOpened == false then
				            OpenMyPoliceJailMenu()
                        end
                    else
                        ESX.ShowNotification("~r~Vous n'avez pas le job requis !")
                    end
                end
            end
        end
        if nearThing then
			Wait(0)
		else
			Wait(250)
		end
    end
end)

function RandomItem()
    return JAIL.Items[math.random(#JAIL.Items)]
end

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k,v in pairs(JAIL["points"]["task"]) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

			if dist < 50.0 then
                nearThing = true
                DrawMarker(1, v.pos.x, v.pos.y, v.pos.z - 1.0, nil, nil, nil, 90, nil, nil, 0.9, 0.9, 0.5, 255, 117, 31, 225, true, false)
                Draw3DTextH(v.pos.x, v.pos.y, v.pos.z - 1.5, "Tâche", 4, 0.1, 0.1)
                if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour faire une tâche")
                    if IsControlJustPressed(1, 38) then
                        TaskStartScenarioInPlace(PlayerPedId(), RandomItem(), 0, true)
                        Wait(5000)
                        wintime = true
                        Wait(1500)
                        wintime = false
                        ClearPedTasksImmediately(PlayerPedId())
                        RemoveNearbyObjects(PlayerPedId(), 5.0)
                        ESX.ShowNotification("~g~Vous avez gagné 5 secondes !")
                    end
                end
            end
		end
		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(250)
		end
	end
end)

RegisterNetEvent('jail:sendJailTimer')
AddEventHandler('jail:sendJailTimer', function(timetoout)
    InJail = true
    JailTimer(timetoout)
    for k,v in pairs(JAIL["points"]["in"]) do
        SetEntityCoords(PlayerPedId(), 3963.729736, 44.260399, 22.342363)
    end
    local model = GetEntityModel(PlayerPedId())
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 56, ['torso_2'] = 0,
                ['arms'] = 0, ['arms_2'] = 0,
                ['pants_1'] = 27, ['pants_2'] = 2,
                ['shoes_1'] = 1, ['shoes_2'] = 14,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
            }
        else
            clothesSkin = {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 56, ['torso_2'] = 0,
                ['arms'] = 0, ['arms_2'] = 0,
                ['pants_1'] = 27, ['pants_2'] = 0,
                ['shoes_1'] = 1, ['shoes_2'] = 14,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent('jail:sendPlayerOutOfJail')
AddEventHandler('jail:sendPlayerOutOfJail', function()
    InJail = false
    for k,v in pairs(JAIL["points"]["out"]) do
        SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
    end
    exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
        local isMale = skin.sex == "mp_m_freemode_01"
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            exports['esx_skin']:GetCachedSkin(function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end)
    end)
end)

function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return 0, 0
    else
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60

        return mins, secs
    end
end

function JailTimer(timetoout)
    local jailTimer = ESX.Math.Round(timetoout * 1000 / 1000)

    if GetResourceState('lb-phone') == 'started' then
        exports['lb-phone']:ToggleDisabled(true)
    end

    Citizen.CreateThread(function()

        local sinceCheckpoint = 0
        while jailTimer > 0 do
            Citizen.Wait(1000)

            if jailTimer > 0 then
                jailTimer = jailTimer - 1

                if wintime then
                    jailTimer = jailTimer - 5
                end

                if jailTimer < 0 then jailTimer = 0 end

                sinceCheckpoint = sinceCheckpoint + 1
                if sinceCheckpoint >= 15 then
                    sinceCheckpoint = 0
                    TriggerServerEvent("jail:updateJailTime", jailTimer)
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        local text, timeHeld = "", 0

        while jailTimer > 0 and InJail do
            Citizen.Wait(0)
            local mins, secs = secondsToClock(jailTimer)
            local text = "Vous sortez de prison dans ~o~" .. string.format("%02d:%02d", mins, secs)

            timeHeld = 0

            DrawGenericTextThisFrame()

            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.5, 0.92)
        end

        if jailTimer < 1 and InJail then
            for k, v in pairs(JAIL["points"]["out"]) do
                SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
            end

            if GetResourceState('lb-phone') == 'started' then
                exports['lb-phone']:ToggleDisabled(false)
            end

            InJail = false

            TriggerServerEvent("jail:updateJailTime", 0)
            TriggerServerEvent("jail:getOutJail")
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        if InJail then
            local coordsJoueur = GetEntityCoords(PlayerPedId(), true)
            local distance = GetDistanceBetweenCoords(3963.729736, 44.260399, 22.342363, coordsJoueur, true)

            if distance > 250 then
                SetEntityCoords(PlayerPedId(), 3963.729736, 44.260399, 22.342363)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local unarmed = GetHashKey("WEAPON_UNARMED")
    while true do
        if InJail then
            local ped = PlayerPedId()
            if GetSelectedPedWeapon(ped) ~= unarmed then
                SetCurrentPedWeapon(ped, unarmed, true)
            end

            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            for i = 157, 164 do
                DisableControlAction(0, i, true)
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

local _unarmedHash = GetHashKey("WEAPON_UNARMED")
Citizen.CreateThread(function()
    while true do
        if InJail then
            local ped = PlayerPedId()

            DisablePlayerFiring(ped, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(2, 37, true)
            DisableControlAction(0, 106, true)

            if GetSelectedPedWeapon(ped) ~= _unarmedHash then
                SetCurrentPedWeapon(ped, _unarmedHash, true)
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.8)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
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

function SelectNumber()

	local minS, maxS, defS = 600, 7200, 600
	if _modeBounds then
		minS, maxS, defS = _modeBounds()
	end

	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	local result = GetOnscreenKeyboardResult()

	if result and result ~= "" then
		_quantite = tonumber(result) or defS
        if _quantite > maxS then
            ESX.ShowNotification(("~r~Vous ne pouvez pas mettre plus de %d secondes !"):format(maxS))
            _quantite = maxS
		elseif _quantite < minS then
			ESX.ShowNotification(("~r~Minimum %d secondes !"):format(minS))
			_quantite = minS
		end
	else
		_quantite = defS
	end
end

exports("InJail", function ()
    return InJail
end)

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end

RegisterCommand("sprison", function(source, args)
    local id = args[1]

    TriggerServerEvent("jail:admin:getOutJail", id)
end)

function RemoveNearbyObjects(ped, radius)
    local x, y, z = table.unpack(GetEntityCoords(ped, false))
    local objects = GetGamePool('CObject')
    for _, obj in pairs(objects) do
        if GetDistanceBetweenCoords(x, y, z, GetEntityCoords(obj, false), true) < radius then
            SetEntityAsMissionEntity(obj, false, true)
            DeleteObject(obj)
        end
    end
end
