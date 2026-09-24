ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.SetTimeout(3 * 1000, function()
		TriggerServerEvent("sunLife:logged")
		TriggerServerEvent("dpemote:server:getDemarche")
	end)
end)

My = {}

RegisterNetEvent("sunLife:logged")
AddEventHandler("sunLife:logged", function(data)
    if data.exp then
        MEXP = data.exp
        My.exp = data.exp
        My.level = data.level

        while not MEXP do Wait(100) print("Waiting for infos") end

        TriggerEvent("XNL_NET:XNL_SetInitialXPLevels", MEXP, true, true)

    end
end)

RegisterNetEvent("XNL_NET:AddPlayerXP")
AddEventHandler("XNL_NET:AddPlayerXP", function(amount)
    if type(amount) ~= "number" then return end
    if MEXP then MEXP = MEXP + amount end
    if My then My.exp = (My.exp or 0) + amount end
end)

RegisterNetEvent("XNL_NET:RemovePlayerXP")
AddEventHandler("XNL_NET:RemovePlayerXP", function(amount)
    if type(amount) ~= "number" then return end
    if MEXP then MEXP = math.max(0, MEXP - amount) end
    if My then My.exp = math.max(0, (My.exp or 0) - amount) end
end)

RegisterNetEvent("sunLife:expSync")
AddEventHandler("sunLife:expSync", function(exp)
    exp = tonumber(exp)
    if not exp then return end
    MEXP = exp
    if My then My.exp = exp end
end)
