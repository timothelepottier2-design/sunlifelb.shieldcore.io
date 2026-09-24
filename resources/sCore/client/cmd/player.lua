local pedDisplaying = {}

local function display(ped, text, cmd)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
	local colorResult = nil

	if cmd == "me" then
        colorResult = { r = 255, g = 255, b = 255, alpha = 255 }
    elseif tonumber(cmd) ~= nil then
        local x = tonumber(cmd)
        local red = (255 + 1.47 * x) - (0.0402 * x ^ 2)
        local green = (4.77 * x) - (0.0222 * x ^ 2)
        green = math.ceil(green)
        if red > 255 then
            red = 255
        else
            red = math.ceil(red)
        end
        colorResult = { r = red, g = green, b = 0, alpha = 255 }
    end

    if dist <= 250 then
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true
        Citizen.CreateThread(function()
            Wait(5000)
            display = false
        end)
        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text, colorResult)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

RegisterNetEvent("sCore.displayMe")
AddEventHandler("sCore.displayMe", function(text, serverId, cmd)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        display(ped, text, cmd)
    end
end)

local function GetAroundPlayersForZone()
    local coords = GetEntityCoords(PlayerPedId())
    local nearby = lib.getNearbyPlayers(coords, 10.0, true)
    local out = {}
    local seen = {}
    local mySid = GetPlayerServerId(PlayerId())
    seen[mySid] = true
    out[#out + 1] = mySid
    for i = 1, #nearby do
        local sid = GetPlayerServerId(nearby[i].id)
        if sid and not seen[sid] then
            seen[sid] = true
            out[#out + 1] = sid
        end
    end
    return out
end

RegisterCommand('me', function(source, args)
    if #args == 0 then
        return
    end

    local text = '* La personne ' .. table.concat(args, ' ') .. ' *'
    local lowerText = string.lower(text)

    local blacklistedWords = {'∑', '÷', '¦', '%^', 'top', 'gang', 'mafia'}
    for i = 1, #blacklistedWords do
        if string.find(lowerText, blacklistedWords[i], 1, true) then
            return
        end
    end

    TriggerServerEvent('sCore.zoneDisplay', GetAroundPlayersForZone(), text, "me")
end)

RegisterCommand("co", function(source, args)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    print("coordonné = " ..playerCoords.. ", heading = " ..playerHeading)
    lib.setClipboard("coordonné = " ..playerCoords.. ", heading = " ..playerHeading)
    ESX.ShowNotification("~g~Coordonné copié dans le presse papier")
end)
