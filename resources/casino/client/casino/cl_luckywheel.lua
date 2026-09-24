local Wheel = nil
local Lambo = nil
local IsShowCar = false
local WheelPos = vector3(1109.76, 227.89, -49.20)
local BaseWheelPos = vector3(1111.05, 229.81, -50.63)
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}
local IsRolling = false
local BaseWheel = nil
local LuckyWheelCost = 2000
local LuckWheelSpinTime = 9000
local areEntityCreated = false
local socle, veh = nil, nil
local showedMenu = false
local lastClosed = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local model = GetHashKey('vw_prop_vw_luckywheel_02a')
    local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')
    local carmodel = GetHashKey('furoregt')

    RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_GENERAL", false)

    Citizen.CreateThread(function()
        -- Base wheel
        RequestModel(baseWheelModel)
        BaseWheel = CreateObject(baseWheelModel, BaseWheelPos.x, BaseWheelPos.y, BaseWheelPos.z, false, false, true)
        SetEntityHeading(BaseWheel, 0.0)
        SetModelAsNoLongerNeeded(baseWheelModel)

        -- Wheel
        RequestModel(model)
        Wheel = CreateObject(model, 1111.05, 229.81, -50.38, false, false, true)
        SetEntityHeading(Wheel, 0.0)
        SetModelAsNoLongerNeeded(model)
        
    end)
end)

function ScaleBetween(unscaledNum, minAllowed, maxAllowed, min, max)
    return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
end

RegisterNetEvent("luckywheel:doRoll")
AddEventHandler("luckywheel:doRoll", function(priceIndex, sound)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local wheelPos = vector3(1111.02, 227.98, -49.64)
    local distance = #(playerCoords - wheelPos)
    if distance > 3 then
       return
    end

    IsRolling = true
    SetEntityHeading(Wheel, -30.0)
    SetEntityRotation(Wheel, 0.0, 0.0, 0.0, 1, true) -- Set on index = 1

    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, "Spin_Start", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)

    Citizen.CreateThread(function()
        local timeout = GetGameTimer() + LuckWheelSpinTime
        local now = GetGameTimer()
        local start = now
        local winAngle = (priceIndex-1) * 18

        local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey("vw_prop_vw_luckylight_on"), false, false, false)
        local object2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey("vw_prop_vw_jackpot_on"), false, false, false)
        SetEntityVisible(object, false, 0)
        SetEntityVisible(object2, false, 0)

        while now < timeout do
            now = GetGameTimer()
            local angleMultipler = ScaleBetween(now, 1.0, 0.0, start, timeout)
            local angle = (winAngle + 360 * 10) * angleMultipler * angleMultipler + winAngle

            SetEntityRotation(Wheel, 0.0, angle, 0.0, 1, true)
            Citizen.Wait(0)
        end

        local soundId = GetSoundId()

        local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey("vw_prop_vw_luckylight_on"), false, false, false)
        local object2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey("vw_prop_vw_jackpot_on"), false, false, false)
        local light, triangle = nil, nil
        local m1b = GetHashKey('vw_prop_vw_luckylight_off')
        local m2b = GetHashKey('vw_prop_vw_jackpot_on')

        if object ~= 0 then
            local coords, rotation, heading = GetEntityCoords(object), GetEntityRotation(object), GetEntityHeading(object)
            local coords2, rotation2, heading2 = GetEntityCoords(object2), GetEntityRotation(object2), GetEntityHeading(object2)

		    RequestModel(m1b) while not HasModelLoaded(m1b) do Citizen.Wait(0) end
		    RequestModel(m2b) while not HasModelLoaded(m2b) do Citizen.Wait(0) end
            light = CreateObject(m1b, coords.x, coords.y, coords.z, false, false, true)
            SetEntityVisible(light, true, 0)
            SetEntityHeading(light, heading)
            SetModelAsNoLongerNeeded(light)

            triangle = CreateObject(m2b, coords2.x, coords2.y, coords2.z, false, false, true)
            SetEntityVisible(triangle, true, 0)
            SetEntityHeading(triangle, heading2)
            SetModelAsNoLongerNeeded(triangle)

            Citizen.CreateThread(function()
                local t = false
                for i=1,30,1 do
                    Citizen.Wait(200)
                    SetEntityVisible(object, t, 0)
                    SetEntityVisible(light, t, 0)
                    t = not t
                    SetEntityVisible(object2, t, 0)
                    SetEntityVisible(triangle, t, 0)
                end
            end)
        end

        if sound == 'car' then
            PlaySoundFromCoord(soundId, "Win_Car", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		elseif sound == 'cash' then
            PlaySoundFromCoord(soundId, "Win_Cash", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		elseif sound == 'chips' then
            PlaySoundFromCoord(soundId, "Win_Chips", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		elseif sound == 'clothes' then
            PlaySoundFromCoord(soundId, "Win_Clothes", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		elseif sound == 'mystery' then
            PlaySoundFromCoord(soundId, "Win_Mystery", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		else
            PlaySoundFromCoord(soundId, "Win", 1109.76, 227.89, -49.20, 'dlc_vw_casino_lucky_wheel_sounds', true, 0, false)
		end
    end)
end)

RegisterNetEvent("luckywheel:rollFinished")
AddEventHandler("luckywheel:rollFinished", function() 
    IsRolling = false
end)

function doRoll()
    if not IsRolling then
        PlaySoundFrontend(-1, "DLC_VW_CONTINUE", "dlc_vw_table_games_frontend_sounds", true)

        IsRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        RequestAnimDict(lib)
		local _movePos = vector3(1109.55, 228.88, -49.64)
		TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  312.2,  0.0)
		local _isMoved = false
		while not _isMoved do
			local coords = GetEntityCoords(PlayerPedId())
			if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
				_isMoved = true
			end
			Citizen.Wait(0)
		end
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
		TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
		while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
		TriggerServerEvent("sunLifeCasino.rollWheel", exports["sJobs"]:GeneratePlate())
		TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
    end
end

local function removeAllWheelShits()
    DeleteEntity(triangle)
    triangle = nil
    DeleteEntity(base)
    base = nil
    DeleteEntity(socle)
    socle = nil
    DeleteEntity(veh)
    veh = nil
    DeleteEntity(roue)
    roue = nil
    areEntityCreated = false
end

local function createAllWheelShits()
    -- Socle
    model = GetHashKey("vw_prop_vw_casino_podium_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do print("soucay4") Wait(1) end
    socle = CreateObject(model, vector3(226.07943725586, -877.56732177734, 29.392116928101), false, false)
    SetEntityRotation(roue, GetEntityPitch(roue), GetEntityRoll(roue), 160.0, 3, 1)
    SetEntityRotation(base, GetEntityPitch(base), GetEntityRoll(base), 160.0, 3, 1)
    SetEntityRotation(triangle, GetEntityPitch(triangle), GetEntityRoll(triangle), 160.0, 3, 1)
    -- Véhicule
    model = GetHashKey("gexige")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    veh = CreateVehicle(model, vector3(1100.01, 219.99, -48.75), 90.0, false, false)
    FreezeEntityPosition(veh, true)
    SetVehicleEngineOn(veh, false, true, true)
    SetVehicleDoorsLocked(veh, 2)
    SetEntityInvincible(veh, true)
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleLights(veh, 2)
    SetVehicleCustomPrimaryColour(veh, 33,33,33)
    SetVehicleCustomSecondaryColour(veh, 33,33,33)
    SetVehicleNumberPlateText(veh, "CASINO")
    areEntityCreated = true
end

Citizen.CreateThread(function()
    Citizen.Wait(10 * 1000)
    local rot = 1.0

    while true do
        local interval = 200
        if areEntityCreated and socle ~= nil and veh ~= nil then
            rot = rot - 0.15
            SetEntityRotation(socle, GetEntityPitch(socle), GetEntityRoll(socle), rot, 3, 1)
            SetEntityHeading(veh, rot)

            if GetClosestObjectOfType(1100.01, 219.99, -48.75, 5.0, GetHashKey("vw_prop_vw_casino_podium_01a"), false, false, false) ~= 0 then
                SetEntityHeading(GetClosestObjectOfType(1100.01, 219.99, -48.75, 5.0, GetHashKey("vw_prop_vw_casino_podium_01a"), false, false, false), rot)
            end
        else
            interval = 500
        end
        Wait(interval)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(10 * 1000)
    local called = false
    local basePos = vector3(1111.02, 227.98, -49.64)
    while true do
        local interval = 500

        if areEntityCreated then
            if #(GetEntityCoords(PlayerPedId()) - basePos) > 150.0 then
                removeAllWheelShits()                
            end
        else
            if #(GetEntityCoords(PlayerPedId()) - basePos) < 150.0 then
                createAllWheelShits()
            end
        end

        Citizen.Wait(interval)
    end
end)

function ShowLuckyWheelMenu()
    if IsRolling then return end
    if lastClosed > GetGameTimer() then return end

    showedMenu = true
	PlaySoundFrontend(-1, "DLC_VW_RULES", "dlc_vw_table_games_frontend_sounds", true)

	local coords = GetEntityCoords(PlayerPedId())

	RMenu.Add('casino', 'main', RageUI.CreateMenu("", "ROUE DE LA FORTUNE", 1, 100, "CasinoUI_Lucky_Wheel", "CasinoUI_Lucky_Wheel"))
    RMenu:Get('casino', "main").Closable = false
    RMenu:Get('casino', "main").Closed = function()
        showedMenu = false
        
        RMenu:Delete('casino', 'main')
    end
    
    RageUI.Visible(RMenu:Get('casino', 'main'), true)

    RMenu:Get('casino', "main"):SetPageCounter("")

    Citizen.CreateThread(function()
        while showedMenu do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                showedMenu = false
            end

            RageUI.IsVisible(RMenu:Get('casino', 'main'), true, false, true, function()

                RageUI.FakeButton("Chances de gagner:\n\nVoiture du podium: 1 sur 50\n500,000$: 2 sur 50\n400,000$: 1 sur 50\n5,000 jetons: 1 sur 50\n3,500 jetons: 2 sur 50\n300,000$: 2 sur 50\n200,000$: 21 sur 50\n100,000$: 21 sur 50", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 38) then
                            lastClosed = GetGameTimer() + 12 * 1000

                            ESX.TriggerServerCallback("luckywheel:canRoll", function(isGood)
                                if isGood then
                                    doRoll()
                                end
                            end)
                        end
                    end
                end)

            end)

        end
    end)
end

Citizen.CreateThread(function()
    local called = false
    local basePos = vector3(1111.02, 227.98, -49.64)
    while true do
        local interval = 500

        if #(GetEntityCoords(PlayerPedId()) - basePos) <= 2.0 then
            if not showedMenu and not IsRolling then
                ShowLuckyWheelMenu()
            end
        else
            showedMenu = false
            called = false
        end

        Citizen.Wait(interval)
    end
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Wheel then 
            DeleteObject(Wheel)
        end

        if BaseWheel then 
            DeleteObject(BaseWheel)
        end

        if socle then
            DeleteObject(socle)
        end

        if veh then
            DeleteObject(veh)
        end
	end
end)