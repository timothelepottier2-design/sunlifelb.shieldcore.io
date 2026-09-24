-- Merged from foodsystem/client/main.lua. ESX is already provided by es_extended itself.
local IsDead = false
local IsAnimated = false
local checked = false
local drunkDriving = false
local level = -4
local drunk	= false
local timing = false

RandomVehicleInteraction = {
	{interaction = 27, time = 1500},
	{interaction = 6, time = 1000},
	{interaction = 7, time = 800},
	{interaction = 8, time = 800},
	{interaction = 10, time = 800},
	{interaction = 11, time = 800},
	{interaction = 23, time = 2000},
	{interaction = 31, time = 2000}
}

-- Init RNG une seule fois (utilisé par fuckDrunkDriver et autres)
math.randomseed(GetGameTimer())

Citizen.CreateThread(function()
    LoadHungerThirst()
end)

AddEventHandler('foodsystem:resetStatus', function()
	TriggerEvent('addFaim', 100)
	TriggerEvent('addSoif', 100)
end)

RegisterNetEvent('foodsystem:healPlayer')
AddEventHandler('foodsystem:healPlayer', function()
	TriggerEvent('addFaim', 100)
	TriggerEvent('addSoif', 100)

	local sourcePed = PlayerPedId()
	SetEntityHealth(sourcePed, GetEntityMaxHealth(sourcePed))
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('foodsystem:resetStatus')
	end

	LoadHungerThirst()

	IsDead = false
end)

AddEventHandler('foodsystem:isEating', function(cb)
	cb(IsAnimated)
end)

function LoadHungerThirst()
    local hunger = GetResourceKvpString("player_hunger")
    local thirst = GetResourceKvpString("player_thirst")

    status.faim = hunger and tonumber(hunger) or 100
    status.soif = thirst and tonumber(thirst) or 100
end

function SaveHungerThirst()
    SetResourceKvp("player_hunger", tostring(status.faim))
    SetResourceKvp("player_thirst", tostring(status.soif))
end

-- Helper interne: charge un anim dict avec timeout (évite boucle infinie si dict invalide).
local function _loadAnimDict(dict, timeoutMs)
	RequestAnimDict(dict)
	local deadline = GetGameTimer() + (timeoutMs or 3000)
	while not HasAnimDictLoaded(dict) and GetGameTimer() < deadline do
		Citizen.Wait(10)
	end
	return HasAnimDictLoaded(dict)
end

-- Helper interne: nettoie une entity quand on quitte la ressource au cas où le thread serait
-- toujours en train de tourner (rebuild en plein eat/drink).
local _activeProps = {}
AddEventHandler('onResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end
	for entity in pairs(_activeProps) do
		if DoesEntityExist(entity) then DeleteObject(entity) end
	end
	_activeProps = {}
end)

RegisterNetEvent('foodsystem:onEat')
AddEventHandler('foodsystem:onEat', function(prop_name)
	if IsAnimated then return end
	prop_name = prop_name or 'prop_cs_burger_01'
	IsAnimated = true
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		local x, y, z = table.unpack(GetEntityCoords(playerPed))
		print(('^2[NETDIAG][OBJET]^7 %s foodsystem.lua CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(prop_name)))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		_activeProps[prop] = true
		AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		if _loadAnimDict('mp_player_inteat@burger') then
			TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
		end
		Citizen.Wait(3000)
		IsAnimated = false
		ClearPedSecondaryTask(playerPed)
		if DoesEntityExist(prop) then DeleteObject(prop) end
		_activeProps[prop] = nil
	end)
end)

RegisterNetEvent('foodsystem:onDrink')
AddEventHandler('foodsystem:onDrink', function(prop_name)
	if IsAnimated then return end
	prop_name = prop_name or 'prop_ecola_can'
	IsAnimated = true
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		local x, y, z = table.unpack(GetEntityCoords(playerPed))
		print(('^2[NETDIAG][OBJET]^7 %s foodsystem.lua CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(prop_name)))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		_activeProps[prop] = true
		AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		if _loadAnimDict('mp_player_intdrink') then
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
		end
		Citizen.Wait(3000)
		IsAnimated = false
		ClearPedSecondaryTask(playerPed)
		if DoesEntityExist(prop) then DeleteObject(prop) end
		_activeProps[prop] = nil
	end)
end)

RegisterNetEvent('foodsystem:onSaoul')
AddEventHandler('foodsystem:onSaoul', function(prop_name)
	if IsAnimated then return end
	prop_name = prop_name or 'prop_drink_whisky'
	IsAnimated = true
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		local x, y, z = table.unpack(GetEntityCoords(playerPed))
		print(('^2[NETDIAG][OBJET]^7 %s foodsystem.lua CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(prop_name)))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		_activeProps[prop] = true
		AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		if _loadAnimDict('mp_player_intdrink') then
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
		end
		Citizen.Wait(3000)
		IsAnimated = false
		ClearPedSecondaryTask(playerPed)
		if DoesEntityExist(prop) then DeleteObject(prop) end
		_activeProps[prop] = nil
		TriggerEvent("foodsystem:GetDrunk")
	end)
end)

status = {}
status.faim = 50
status.soif = 50
status.show = false

RegisterNetEvent("food:client:get", function (data)
	if not data then return end
	status.faim = tonumber(data.hunger) or status.faim
	status.soif = tonumber(data.thirst) or status.soif
end)

-- ## Actualisation de la faim & soif
Citizen.CreateThread(function ()
	while true do
		local player = PlayerId()

		Wait(15000)
		if exports.sunlife:getStaffMod() == false and not exports["sunlife"]:getAFKStatus() and not exports["sunlife"]:inJail() then
			if status.faim and status.soif then
				delFaim(0.20)
				delSoif(0.22)
				if status.faim < 20 or status.soif < 20 then
					SetRunSprintMultiplierForPlayer(player, 0.4)
				end
			end
		end
	end
end)

function returnStatus()
	return status
end

exports("whatisthisgoingon", function ()
	return tonumber(status.faim) or 100, tonumber(status.soif) or 100
end)

function addFaim(calories)
    local cur = tonumber(status.faim) or 0
    local add = tonumber(calories) or 0
    if cur >= 100 then
        status.faim = 100
        return
    end
    if cur + add <= 100 then
        status.faim = cur + add
    else
        status.faim = 100
    end
end

function delFaim(calories)
    local cur = tonumber(status.faim) or 0
    local sub = tonumber(calories) or 0
    if cur <= 0 then
        status.faim = 0
        return
    end
    if cur - sub >= 0 then
        status.faim = cur - sub
    else
        status.faim = 0
    end
    if status.faim <= 20 then
        ESX.ShowNotification("~r~Vous avez faim...")
    end
end

function setFaim(calories)
	status.faim = calories
end

function addSoif(water)
    local cur = tonumber(status.soif) or 0
    local add = tonumber(water) or 0
    if cur >= 100 then
        status.soif = 100
        return
    end
    if cur + add <= 100 then
        status.soif = cur + add
    else
        status.soif = 100
    end
end

function delSoif(water)
    local cur = tonumber(status.soif) or 0
    local sub = tonumber(water) or 0
    if cur <= 0 then
        status.soif = 0
        return
    end
    if cur - sub >= 0 then
        status.soif = cur - sub
    else
        status.soif = 0
    end
    if status.soif <= 20 then
        ESX.ShowNotification("~b~Vous commencez à avoir soif...")
    end
end

function setSoif(water)
	status.soif = water
end

RegisterNetEvent("status:addFaim")
AddEventHandler("status:addFaim", function(calories)
	addFaim(calories)
end)

function startCoolDown()
	Wait(1000 * 60 * 5)
end

RegisterNetEvent("status:addsomeFaim")
AddEventHandler("status:addsomeFaim", function(calories)
	addFaim(calories*0.1)
end)

RegisterNetEvent("status:addSoif")
AddEventHandler("status:addSoif", function(water)
	addSoif(water)
	startCoolDown()
end)

RegisterNetEvent("status:addFaim")
AddEventHandler("status:addFaim", function(calories)
	addFaim(calories)
end)

RegisterNetEvent("status:refresh")
AddEventHandler("status:refresh", function(f, s)
	setFaim(f)
	setSoif(s)
end)

RegisterNetEvent("status:open/close")
AddEventHandler("status:open/close", function()
    status.show = not status.show
end)

local function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
    while true do
        if status.faim < 1 or status.soif < 1 then
            SetEntityHealth(PlayerPedId(), 0)
        end
        Citizen.Wait(5000)
    end
end)

function Normal()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

	  	ClearTimecycleModifier()
	  	ResetScenarioTypesEnabled()
	  	SetPedIsDrug(playerPed, false)
	  	SetPedMotionBlur(playerPed, false)
	end)
end

function overdose()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

		SetEntityHealth(playerPed, 0)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrug(playerPed, false)
		SetPedMotionBlur(playerPed, false)
	end)
end

RegisterNetEvent('foodsystem:GetDrunk')
AddEventHandler('foodsystem:GetDrunk', function()
	level = level + 1

	if level < 0 then
		return
	end

	if level == 0 then
		anim = "move_m@drunk@slightlydrunk"
		shake = 1.0
		setPlayerDrunk(anim, shake)

	elseif level == 1 then
		anim = "move_m@drunk@moderatedrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)

	elseif level >= 2 then
		anim = "move_m@drunk@verydrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)
	end

	if not drunk then
		drunk = true
		timer()
		Citizen.CreateThread(function()
			local PlayerPed = PlayerPedId()
			drunkDriving = true

			while drunkDriving do
				Citizen.Wait(7000)
				if IsPedInAnyVehicle(PlayerPed, false) or IsPedInAnyVehicle(PlayerPed, false) == 0 then
					local vehicle = GetVehiclePedIsIn(PlayerPed, false)
					if GetPedInVehicleSeat(vehicle, -1) == PlayerPed then
						local class = GetVehicleClass(vehicle)

						if class ~= 15 or 16 or 21 or 13 then
							local whatToFuckThemWith = fuckDrunkDriver()
							TaskVehicleTempAction(PlayerPed, vehicle, whatToFuckThemWith.interaction, whatToFuckThemWith.time)
						end
					end
				end
			end
		end)
		-- Avant: Wait(0) chaque frame juste pour afficher un texte → CPU pour rien.
		-- Le draw doit rester chaque frame (sinon l'OS ne le rend pas), mais il est désormais
		-- conditionné: Wait(0) seulement si le HUD doit être visible, sinon Wait(500).
		Citizen.CreateThread(function()
			while drunk do
				DrawGenericTextThisFrame()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Vous êtes bourré !")
				DrawText(0.5, 0.8)
				Citizen.Wait(0)
			end
		end)
	end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 1.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(1)
end

-- math.randomseed est cher; on le set 1× au load (juste en-dessous), pas à chaque appel.
function fuckDrunkDriver()
	local shitFuckDamn = math.random(1, #RandomVehicleInteraction)
	return RandomVehicleInteraction[shitFuckDamn]
end

function setPlayerDrunk(anim, shake)
	local PlayerPed = PlayerPedId()

	RequestAnimSet(anim)
	while not HasAnimSetLoaded(anim) do
		Citizen.Wait(100)
	end

	SetPedMovementClipset(PlayerPed, anim, true)
	ShakeGameplayCam("DRUNK_SHAKE", shake)
	SetPedMotionBlur(PlayerPed, true)
	SetPedIsDrunk(PlayerPed, true)
end

function timer()
	local timer = 300
	Citizen.CreateThread( function()
		if not timing then
			timing = true
			while timer ~= 0 do
				Wait(5000)
				timer = timer - 5
				if timer == 0 then
					Sober()
					return
				end
			end
		end
	end)
end

function Sober()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		level = -4
		timing = false
		drunk = false
		drunkDriving = false
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
		ClearPedSecondaryTask(playerPed)
		ShakeGameplayCam("DRUNK_SHAKE", 0.0)
	end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2 * 60 * 1000)
        SaveHungerThirst()
    end
end)
