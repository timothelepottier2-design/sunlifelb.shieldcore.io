ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand('sqlban', function(source, args, rawCommand)
    ESX.TriggerServerCallback("sunlife:tryBan", function(allowed)
        if allowed then
            local target = tonumber(args[1])
            local duree = tonumber(args[2])
            local reason = table.concat(args, " ", 3)
            if target ~= nil then
                TriggerServerEvent("banlist:add", target, duree, reason)
            end
        end
    end)
end)

RegisterCommand('sqlbanlicense', function(source, args, rawCommand)
    ESX.TriggerServerCallback("sunlife:tryBan", function(allowed)
        if allowed then
            local license = tostring(args[1])
            local duree = tonumber(args[2])
            local reason = table.concat(args, " ", 3)

            if license ~= nil then
                TriggerServerEvent("banlist:ladd", license, duree, reason)
            end
        end
    end)
end)
