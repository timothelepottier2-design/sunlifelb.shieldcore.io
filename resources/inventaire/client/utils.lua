Utils = {}


function Utils.GetClosestVehicle(coords)
    local vehicles = GetGamePool("CVehicle")
    local closestDistance = 3.0
    local closestVehicle = -1
    local playerPed = GetPlayerPed(-1)
    local coords = coords
    if coords == nil then
        coords = GetEntityCoords(playerPed)
    end

    for k,v in pairs(vehicles) do
        local vehicleCoords = GetEntityCoords(v)
        local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle  = v
            closestDistance = distance
        end
    end

    return closestVehicle, closestDistance
end

function Utils.GetMugshotPlayer(ped)
    ped = PlayerPedId()
    local handle = RegisterPedheadshot(ped)
    while not IsPedheadshotReady(handle) do
        Wait(100)
    end
    local test = GetPedheadshotTxdString(handle)
    return test
end
function INVENTORY.AsSameMetadas(metadata1, metadata2)
    -- Fast-path : si les deux metadatas ont un `id` non-nil identique,
    -- on considère que c'est la même INSTANCE d'item (cahier, arme, permis...).
    -- Évite les fausses négatives quand le contenu mute (titre, contenu, etc.)
    -- entre la version cachée et la version live.
    if type(metadata1) == 'table' and type(metadata2) == 'table'
       and metadata1.id ~= nil and metadata2.id ~= nil
       and metadata1.id == metadata2.id then
        return true
    end

    local function deepCompare(table1, table2)
        if table1 == table2 then
            return true
        end
        local table1Type = type(table1)
        local table2Type = type(table2)
        if table1Type ~= table2Type then
            return false
        end
        if table1Type ~= 'table' then
            return false
        end

        local keySet = {}

        for key1, value1 in pairs(table1) do
            local value2 = table2[key1]
            -- Ici, on remplace tablesAreEqual par deepCompare
            if value2 == nil or deepCompare(value1, value2) == false then
                return false
            end
            keySet[key1] = true
        end

        for key2, _ in pairs(table2) do
            if not keySet[key2] then
                return false
            end
        end
        return true
    end
    return deepCompare(metadata1, metadata2)
end

function INVENTORY.Comma_value(amount)
    -- local formatted = amount
    -- local k
    -- -- while true do  
    --     formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    --     if (k==0) then
    --         formatted = 0
    --     end
	-- -- 	Wait(1)
    -- -- end
	local formatted = tostring(amount)
    -- Applique le formatage en partant de la fin du nombre
    formatted = string.reverse(formatted)
    formatted = string.gsub(formatted, "(%d%d%d)", "%1,")
    formatted = string.reverse(formatted)
    -- Enlève la virgule en début si elle existe (due à la réversion pour le dernier groupe de chiffres)
    formatted = string.gsub(formatted, "^,", "")
    return formatted
end

RegisterNetEvent("inventory:client:refresh")
AddEventHandler("inventory:client:refresh", function()

    ESX.PlayerData = ESX.GetPlayerData()

    INVENTORY.UI.Player.CurrentWeight = INVENTORY.GetPlayerCurrentWeight()
end)

function INVENTORY.GetPlayerCurrentWeight()
    local currentWeight = 0
    for i = 1, #ESX.PlayerData.inventory, 1 do
        currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
    end
    return currentWeight
end

function INVENTORY.GetCurrentWeight(inv)
    local currentWeight = 0
    if type(inv) ~= "table" then return 0 end
    for i = 1, #inv, 1 do
        local it = inv[i]
        if type(it) == "table" then
            local w = tonumber(it.weight) or 0
            local c = tonumber(it.count) or 0
            currentWeight = currentWeight + (w * c)
        end
    end
    return currentWeight
end

function INVENTORY.InputString(text, number, windows)
	if number == nil then 
		number = 30
	end
	AddTextEntry("FMMC_KEY_TIP8", text)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", windows, "", "", "", number)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(10)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()

		return result
	else
		return nil
	end
end

function INVENTORY.MeasureStringWidth(str, font, scale)
    BeginTextCommandWidth("STRING")
    SetTextFont(font)
    SetTextScale(scale, scale)
    AddTextComponentSubstringPlayerName(str)
    return EndTextCommandGetWidth(true)
end


function Utils.LoadAnimDict(animDict)
	RequestAnimDict(animDict)
	if DoesAnimDictExist(animDict) then
		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
		-- Citizen.CreateThread(function() -- For now we let the dict loaded
		--     Wait(1000)
		--     RemoveAnimDict(animDict)
		-- end)
	else
		print("^1Trying to load anim dict that do not exist ", animDict)
	end
end

local timer = GetGameTimer()

--[[Citizen.CreateThread(function()
    while true do
        local invOpen = false
        if INVENTORY.ActivateInv then
            invOpen = true
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 199, true)
        end

        if invOpen then
            Wait(1)
        else
            Wait(750)
        end
    end
end)]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        BlockWeaponWheelThisFrame()
    end
end)

function Utils.TableCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Utils.TableCopy(orig_key)] = Utils.TableCopy(orig_value)
        end
        setmetatable(copy, Utils.TableCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end