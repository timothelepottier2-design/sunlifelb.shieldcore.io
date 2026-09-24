local remainTime = {
    d = 0,
    m = 0,
    s = 0,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

KeyboardInputNative = function(entryTitle, textEntry, inputText, maxLength)
	playerIsOnKeyBoard = true
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', tostring(inputText or ''), '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	playerIsOnKeyBoard = false

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(100)
		return result
	else
		Citizen.Wait(100)
		return nil
	end
end

openCashier = function()
	PlaySoundFrontend(-1, "DLC_VW_RULES", "dlc_vw_table_games_frontend_sounds", true)

	-- Rafraîchit le solde de jetons (utile pour les caisses hors casino principal,
	-- où CASINO["myJetons"] n'est pas alimenté par les threads du casino).
	ESX.TriggerServerCallback("casino:getJetons", function(jetons)
		if jetons then
			CASINO["myJetons"] = jetons
		end
	end)

	local coords = GetEntityCoords(PlayerPedId())

	RMenu.Add('casino', 'main', RageUI.CreateMenu("", "SERVICES DE CAISSE", 1, 100, "shopui_title_casino", "shopui_title_casino"))
    RMenu:Get('casino', "main").Closed = function()
        CASINO["cashierMenuOpenned"] = false
        
        RMenu:Delete('casino', 'main')
    end

    if CASINO["cashierMenuOpenned"] then
        CASINO["cashierMenuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        CASINO["cashierMenuOpenned"] = true
        RageUI.Visible(RMenu:Get('casino', 'main'), true)
    end

    RMenu:Get('casino', "main"):SetPageCounter("")

    Citizen.CreateThread(function()
        while CASINO["cashierMenuOpenned"] do

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                CASINO["cashierMenuOpenned"] = false
            end

            Citizen.Wait(1000)
        end
    end)

    Citizen.CreateThread(function()
        while CASINO["cashierMenuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('casino', 'main'), true, false, true, function()

                RageUI.ProgressSeparator(GroupDigits(CASINO["myJetons"]).." jetons", {
                    ProgressStart = 0,
                    ProgressMax = 100,
                })

                RageUI.Button("Acquérir des jetons", "Sélectionnez le nombre de jetons que vous voulez acquérir.", {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInputNative("BUY", "Combien en voulez-vous ?", "", 15)
                        amount = tonumber(amount)

                        if amount == nil then return end
                        if amount < 1 then return end

                        TriggerServerEvent("casino:buyJetons", amount)
                    end
                end)

                RageUI.Button("Échanger des jetons", "Sélectionnez le nombre de jetons que vous voulez échanger.", {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInputNative("BUY", "Combien en voulez-vous ?", "", 15)
                        amount = tonumber(amount)

                        if amount == nil then return end
                        if amount < 1 then return end

                        TriggerServerEvent("casino:excJetons", amount)
                    end
                end)
            end)
        end
    end)
end

-- Points de caisse. Le casino principal utilise le comptoir du MLO (sans ped).
-- Les caisses hors casino définissent un "ped" qui sera spawn à l'approche.
local CashierPoints = {
    {
        pos = vector3(1115.99, 220.03, -49.44),
    },
    {
        pos = vector3(6998.733398, 265.138306, 57.852818),
        ped = { model = `u_f_m_casinocash_01`, heading = 221.00073242188 },
    },
}

-- Spawn / despawn des caissier(e)s des points qui en définissent un.
local CashierPeds = {}
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, point in ipairs(CashierPoints) do
            if point.ped then
                local distance = #(playerCoords - point.pos)

                if distance < 100.0 then
                    if not CashierPeds[i] or not DoesEntityExist(CashierPeds[i]) then
                        local model = point.ped.model
                        RequestModel(model)
                        local timeout = GetGameTimer() + 10000
                        while not HasModelLoaded(model) and GetGameTimer() < timeout do
                            Citizen.Wait(10)
                        end
                        if HasModelLoaded(model) then
                            local ped = CreatePed(4, model, point.pos.x, point.pos.y, point.pos.z - 1.0, point.ped.heading, false, true)
                            SetEntityInvincible(ped, true)
                            FreezeEntityPosition(ped, true)
                            SetBlockingOfNonTemporaryEvents(ped, true)
                            SetModelAsNoLongerNeeded(model)
                            CashierPeds[i] = ped
                        end
                    end
                elseif CashierPeds[i] and DoesEntityExist(CashierPeds[i]) then
                    DeletePed(CashierPeds[i])
                    CashierPeds[i] = nil
                end
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local interval = 500
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearCashier = false

        for _, point in ipairs(CashierPoints) do
            if #(playerCoords - point.pos) <= 2.0 then
                nearCashier = true
                if not CASINO["cashierMenuOpenned"] then
                    openCashier()
                end
                break
            end
        end

        if not nearCashier then
            CASINO["cashierMenuOpenned"] = false
        end

        Citizen.Wait(interval)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for i, ped in pairs(CashierPeds) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
        CashierPeds[i] = nil
    end
end)

RegisterNetEvent("casino:updateDailyCashier")
AddEventHandler("casino:updateDailyCashier", function(ddd)
    remainTime = ddd
end)