local open = false
local currentSociety = nil
local currentCloseCb = nil

ESX = nil

local base64MoneyIcon = 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAFoAAABaCAMAAAAPdrEwAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAAMAUExURQAAACmvPCmwPCuwPiywPi2wPy6xQC6xQS+yQTCxQTCyQTCyQjGyQzKyRDOzRDOzRTSzRTSzRTSzRjW0RjW0Rza0SDe0STi0STm1Sjq1Szq2Szu2TDy2TDy2TT22Tj63Tz+3UEC4UEG4UUG4UkK4U0O5VES5VEW6VUa6Vke6V0i7WEm7WUu8Wku8W0y8W028XE29XU++XlC9X1C+X1G+YFK+YVO/YlW/ZFXAZFfAZVfAZljBZlnBZ1rBaVvCaVvCalzDal7CbF/DbV/EbWHEbmLEb2LEcGTFcWfGdGjHdWrHd2vId2vIeGzIeW3JenHKfXLKfnPLf3TLgHXLgXXMgHXMgXbMgnjNg3nMhHrNhnrOhnzOiH7PiYLQjYPRjoTRjoTRj4XRkIXSkIfSkojSk4rUlYzUlo7VmJDWmpHWm5LXnJTXnZTXnpXYnpbYn5nZopzapJ3bpZ7bpp7bp6DcqKLcqqPcq6Tcq6TdrKberqjfr6jfsKnfsavgs6zgs6zgtK7hta/htrDit7LiuLLiubPjurTjurXju7bkvLbkvbnlv7rlwLrmwLzmwr3nw77nxMDnxcLox8PpyMTpycXpysXqysbqy8fqzMnrzcrrz8vsz8vs0Mzs0c3t0tHu1dHu1tPv19Tv2NXv2dXw2dbw2tfw29jw3Nnx3drx3t7z4d/z4uD04+H05OP15eP15uT15uT15+X16OX26Of26en36+r37Ov37er47Ov47ez47e347u347+758PD58fD68fD68vL69PT79fX79vb79/b89vb89/f8+Pj9+fn9+vr9+/v++/v+/Pz+/P3+/f3+/v7//7fZHJgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGHRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4xLjb9TgnoAAAGdUlEQVRoQ7WZ93sURRiAFZO76O1eklt215OgBwqJgmgCRhAhRrAAiogBI4gBJEFEgWAEYiGIYEGp1kjXQECkiF0OWyjJ/k34zcy3db7Zu8fHe3/KTXnzPbPT56orRTEYAhMLUFgNKkeiGH8BNaV1KWSPVXveU9s3LW9pvhdoblm+afspTHZi5Wo1BnzpaOfcnFmWSBv29YBtpBNlZm5u59FLPDsmdJUaxQeXNugZw5IwMnrD0oO8iFKuUHNx/+bGZLWNMgm7Otm4uZ/LsVIEUs3F+Y5a3USNAlOv7cgr5ZSamQffyOnKgH1sPdfFi2PVILKaReEcmKwVIWbY2uQDvApW95HULIb+Ng0rFoXWxppcCjyqZuZjk4oNWWBrk44R7oiamXdkC3w9GTO7Q3aH1cy8OkWFnHtitstM4j/bqdWSO6Rm5nYdS4e5FbKQwxlMC6G3Q1bIHVQz8+IKLBphJLdydlRjWpiKxZAXdAfUPOak4gOO4FZOdxWmhbGTkbh9NTOvoVsDuGmAaxkdlZgWRV8Dub7bV0PyzhQWkqk5z7WMdjpqILUTslEXUEPQJ7Lq7pz9WXiBZ4iZUGBnTwTCdtVgvjgxpj+b3vTvTEteq5KbEy/6blcNVZapR3cmdc9Z4QV6Pnxzdr1GF9aWQQFUohqCPqQc3ZV17X3C6tP31kyL+Jy2dsgLW6jBPDgVc6OkR3XxCV/i9IqRRFedylxc6qk30L3DNF7ikz1Jft0oLOaT2hBSg/l8jmwOo24/amimYzkfOwfdlLtdNT1YjIaf0EFzgGhuNnB8teNcqCWDvs3vzSSLqC9Ze0F0EqaGoDeSQWt7UaHgXA0WDKFvFGEzNRS6mxot6VZhUNJNdm7zbsgSagj6UAKTQ5hnhEHJffRISIi+LdRLyNn9cTSoOExP3FZmiat2nIF66t9Xb0GFz8Df+AenVTEF2vUwAzM1BN1LfsTkcVS4bJs+fnRj84z3joqf+eFYUELvZWFzdSfZHjeeEwqXl6/myWaZ0bSVDf3uJP9NkOn01HPISXIMTJAB/hiB6WBPN+xxBpvxl4wxR6ihll8pSL1QupwLLhR22YL9ysVGrKRcfZJeAu4QSo+1yWA3rla2NGCeZGpoj13lmBJm1F/odDm+fv68phorU0l+miDlu6BFmLqbHDCWdhqVQQb/zPesW1inqxdoRqIb1SvSmBJG+wR1BF+/NkmLWUnTK1DdQq+i5gvoIbn85QPqtdRoQfU0TIgy4h/UKOi+gZ5DgGmonqIoob2CDhXHblE0ij2lgNo2YMcSy7fkhF2E2rIm/IoOFV/Q+78i1JkJheJ+jOzjnlr1GRk18swa4iC9t3U/o6LzCVLTP4dlVM14LBfC63yKIYOYeuMqcRoneZFqEW/IKAY6Q8xumla3YP2+PNnNt1Jqb6Arpifg5kXuHjNTaVi1s5/eJs0r+6gFUkxP6kkV2mKBs8UMZSYMdmAJcpxqTTGpqpcCEO1znCMTwlPFNbuF0uUs1UVwKYAWoRcwGDHsbNS/algwu+J1bvToI9TuAgZqetm1roPVk/FDazbhjaryr0SiSw/R1oFll94sWNnfsLrzS1eTkawyjKrE6HcwyeVtIix3s6Dc4ljzsTbnx74P1na83+uf8ZBn5cb0tjgsbHJjlvoMa8dxWT4XBDZmoCa3k7eH9yE0u4l9jr+dZN2P2ASnVorK8TwoVwxsglnYxNY9852oHMseogMEt+4QtnzgGDoTa8eRW9XoQZq5qeN/5fCFigWmd14VNRXLx3/et8lLC7N8XNtH0VP6mXfvV+z4iEsLFrbqqkXXho2Z8dynwgo8NdZK0SXpqxbmjrsgquhCsXrhgOYgL4h4k8Rca5VvFV7gTkySUVxrsbBjLuOGfMy1jCZFa6gv47hbeYU4ZA/XMmbRy13MFaJwqy4+Ez1cy3iSVsddfGLcdJvo33Ato5VcSeOva4WbvmQ2v+daxkrqfqXQJbNwk1fj9kOPuNwlZxdxNS7c5IW+MdRFMhd3oS/cpXmG4EOnRI8nAAt8sKsETz4AK1yahyqAy0vxvAaU7lEQcJ8yj9BPmUf+81MmR8iB//kBllOyZ2NOqR67XUAVABNjuXLlX2rCcoFjOcGoAAAAAElFTkSuQmCC'

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
	RefreshBussHUD()
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	RefreshBussHUD()
end)

-- ===========================================================================
--  HUD argent société (conservé à l'identique de ce serveur)
-- ===========================================================================
function EnableSocietyMoneyHUDElement()
	local tpl = '<div><img src="' .. base64MoneyIcon .. '" style="width:20px; height:20px; vertical-align:middle;">&nbsp;{{money}}</div>'
	if ESX.GetConfig().EnableHud then
		ESX.UI.HUD.RegisterElement('society_money', 3, 0, tpl, { money = 0 })
	end
	TriggerEvent('esx_society:toggleSocietyHud', true)
end

function DisableSocietyMoneyHUDElement()
	if ESX.GetConfig().EnableHud then
		ESX.UI.HUD.RemoveElement('society_money')
	end
	TriggerEvent('esx_society:toggleSocietyHud', false)
end

function UpdateSocietyMoneyHUDElement(money)
	if ESX.GetConfig().EnableHud then
		ESX.UI.HUD.UpdateElement('society_money', { money = ESX.Math.GroupDigits(money) })
	end
	ESX.ShowNotification('Il vous reste:~g~ ' .. money .. ' ~w~$')
	TriggerEvent('esx_society:setSocietyMoney', money)
end

function RefreshBussHUD()
	DisableSocietyMoneyHUDElement()
	if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		EnableSocietyMoneyHUDElement()
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoneyHUDElement(money)
		end, ESX.PlayerData.job.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoneyHUDElement(money)
	end
end)

-- ===========================================================================
--  Factures : table society_invoices (persistante), alimentée par esx_society
--  à chaque facture payée ou vente encaissée, pour toutes les sociétés.
-- ===========================================================================
local function refreshInvoices()
	if not currentSociety then return end
	ESX.TriggerServerCallback('esx_society:getSocietyInvoices', function(list)
		SendNUIMessage({ action = 'updateInvoices', list = list or {} })
	end, currentSociety, 100)
end

-- ===========================================================================
--  NUI
-- ===========================================================================
local function refreshNuiData(society, cb)
	if not society then if cb then cb() end return end
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(balance)
		ESX.TriggerServerCallback('esx_society:getSocietyTransactions', function(transactions)
			ESX.TriggerServerCallback('esx_society:getSocietyTransactionsGraph', function(graphData)
				ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
					ESX.TriggerServerCallback('esx_society:getJob', function(job)
						SendNUIMessage({
							action = 'update',
							balance = balance,
							transactions = transactions,
							graphData = graphData,
							employees = employees,
							job = job
						})
						if cb then cb() end
					end, society)
				end, society)
			end, society, 30)
		end, society, 100)
	end, society)
end

local function openSocietyNui(society)
	currentSociety = society
	ESX.TriggerServerCallback('esx_society:getBossMenuData', function(data)
		if not data then
			ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
			return
		end
		SendNUIMessage({
			action = 'open',
			society = society,
			balance = data.balance,
			transactions = data.transactions,
			graphData = data.graphData,
			employees = data.employees,
			job = data.job,
			salaryHistory = data.salaryHistory or {},
			invoices = data.invoices or {},
			serviceCurrent = data.serviceCurrent or {},
			serviceSessions = data.serviceSessions or {},
			serviceFilter = 'day',
			playerInService = data.playerInService == true,
			washMoneyAllowed = data.washMoneyAllowed == true,
			permissionLabels = {},
			societyWebhook = data.societyWebhook or '',
			currentIdentifier = (ESX and ESX.PlayerData and ESX.PlayerData.identifier) or ''
		})
		SetNuiFocus(true, true)
		open = true
		refreshInvoices()
	end, society)
end

local function closeSocietyNui()
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'close' })
	open = false
	currentSociety = nil
	if currentCloseCb then currentCloseCb() currentCloseCb = nil end
end

function OpenBossMenu(society, close, options)
	currentCloseCb = close
	openSocietyNui(society)
end

AddEventHandler('esx_society:openBosstozMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

-- ===========================================================================
--  NUI callbacks
-- ===========================================================================
RegisterNUICallback('close', function(_, cb)
	closeSocietyNui()
	cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
	local amount = tonumber(data and data.amount)
	if not amount or amount <= 0 or not currentSociety then cb('invalid') return end
	TriggerServerEvent('esx_society:depositMoney', currentSociety, amount)
	Citizen.SetTimeout(600, function()
		refreshNuiData(currentSociety, function() RefreshBussHUD() end)
	end)
	cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
	local amount = tonumber(data and data.amount)
	if not amount or amount <= 0 or not currentSociety then cb('invalid') return end
	TriggerServerEvent('esx_society:withdrawMoney', currentSociety, amount)
	Citizen.SetTimeout(600, function()
		refreshNuiData(currentSociety, function() RefreshBussHUD() end)
	end)
	cb('ok')
end)

RegisterNUICallback('getUnemployed', function(_, cb)
	local myPed = PlayerPedId()
	local myCoords = GetEntityCoords(myPed)
	local myServerId = GetPlayerServerId(PlayerId())
	local nearbyIds, seen = {}, {}
	for _, playerIndex in ipairs(GetActivePlayers()) do
		local serverId = GetPlayerServerId(playerIndex)
		if serverId and serverId ~= myServerId and not seen[serverId] then
			seen[serverId] = true
			local ped = GetPlayerPed(playerIndex)
			if ped and ped ~= 0 and #(myCoords - GetEntityCoords(ped)) <= 10.0 then
				table.insert(nearbyIds, serverId)
			end
		end
	end
	for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			local serverId = GetPlayerServerId(i)
			if serverId and serverId ~= myServerId and not seen[serverId] then
				seen[serverId] = true
				local ped = GetPlayerPed(i)
				if ped and ped ~= 0 and #(myCoords - GetEntityCoords(ped)) <= 10.0 then
					table.insert(nearbyIds, serverId)
				end
			end
		end
	end
	ESX.TriggerServerCallback('esx_society:getNearbyUnemployedPlayers', function(list)
		SendNUIMessage({ action = 'setUnemployed', list = list or {} })
	end, nearbyIds)
	cb('ok')
end)

RegisterNUICallback('recruit', function(data, cb)
	local identifier = data and data.identifier
	local grade = tonumber(data and data.grade)
	if not identifier or not grade or not currentSociety then cb('invalid') return end
	ESX.TriggerServerCallback('esx_society:affiliateJob', function()
		refreshNuiData(currentSociety)
	end, identifier, currentSociety, grade, 'hire', currentSociety)
	cb('ok')
end)

RegisterNUICallback('fire', function(data, cb)
	local identifier = data and data.identifier
	if not identifier or not currentSociety then cb('invalid') return end
	ESX.TriggerServerCallback('esx_society:affiliateJob', function()
		refreshNuiData(currentSociety)
	end, identifier, 'unemployed', 0, 'fire', currentSociety)
	cb('ok')
end)

RegisterNUICallback('promote', function(data, cb)
	local identifier = data and data.identifier
	local grade = tonumber(data and data.grade)
	if not identifier or not grade or not currentSociety then cb('invalid') return end
	ESX.TriggerServerCallback('esx_society:affiliateJob', function()
		refreshNuiData(currentSociety)
	end, identifier, currentSociety, grade, 'promote', currentSociety)
	cb('ok')
end)

RegisterNUICallback('demote', function(data, cb)
	local identifier = data and data.identifier
	local grade = tonumber(data and data.grade)
	if not identifier or not grade or not currentSociety then cb('invalid') return end
	ESX.TriggerServerCallback('esx_society:affiliateJob', function()
		refreshNuiData(currentSociety)
	end, identifier, currentSociety, grade, 'promote', currentSociety)
	cb('ok')
end)

RegisterNUICallback('sendSalary', function(data, cb)
	local identifier = data and data.identifier
	local amount = tonumber(data and data.amount)
	if not identifier or not amount or amount <= 0 or not currentSociety then cb('invalid') return end
	TriggerServerEvent('esx_society:sendEmployeeMoney', currentSociety, identifier, amount)
	Citizen.SetTimeout(800, function()
		ESX.TriggerServerCallback('esx_society:getSocietySalaryHistory', function(salaryHistory)
			SendNUIMessage({ action = 'updateSalaryHistory', list = salaryHistory or {} })
		end, currentSociety, 50)
		refreshNuiData(currentSociety)
	end)
	cb('ok')
end)

RegisterNUICallback('getSalaryHistory', function(_, cb)
	if not currentSociety then cb('ok') return end
	ESX.TriggerServerCallback('esx_society:getSocietySalaryHistory', function(list)
		SendNUIMessage({ action = 'updateSalaryHistory', list = list or {} })
	end, currentSociety, 50)
	cb('ok')
end)

RegisterNUICallback('getInvoices', function(_, cb)
	refreshInvoices()
	cb('ok')
end)

RegisterNUICallback('getServiceCurrent', function(_, cb)
	if not currentSociety then cb('ok') return end
	ESX.TriggerServerCallback('esx_society:getSocietyServiceCurrent', function(list)
		SendNUIMessage({ action = 'updateServiceCurrent', list = list or {} })
	end, currentSociety)
	cb('ok')
end)

RegisterNUICallback('getServiceSessions', function(data, cb)
	if not currentSociety then cb('ok') return end
	local filter = (data and data.filter) or 'day'
	ESX.TriggerServerCallback('esx_society:getSocietyServiceSessions', function(list)
		SendNUIMessage({ action = 'updateServiceSessions', list = list or {}, filter = filter })
	end, currentSociety, filter, 100)
	cb('ok')
end)

RegisterNUICallback('toggleService', function(data, cb)
	if not currentSociety then cb('invalid') return end
	local state = data and data.state
	TriggerServerEvent('esx_society:setServiceState', currentSociety, state == true)
	Citizen.SetTimeout(300, function()
		ESX.TriggerServerCallback('esx_society:getMyServiceState', function(inService)
			SendNUIMessage({ action = 'updateMyServiceState', inService = inService })
		end, currentSociety)
	end)
	cb('ok')
end)

RegisterNUICallback('getMyServiceState', function(_, cb)
	if not currentSociety then cb('ok') return end
	ESX.TriggerServerCallback('esx_society:getMyServiceState', function(inService)
		SendNUIMessage({ action = 'updateMyServiceState', inService = inService })
	end, currentSociety)
	cb('ok')
end)

RegisterNUICallback('washMoney', function(data, cb)
	if not currentSociety then cb('invalid') return end
	local amount = tonumber(data and data.amount)
	if not amount or amount <= 0 then cb('invalid') return end
	TriggerServerEvent('esx_society:washMoney', currentSociety, amount)
	cb('ok')
end)

RegisterNUICallback('setSocietyWebhook', function(data, cb)
	if not currentSociety then cb('invalid') return end
	TriggerServerEvent('esx_society:setSocietyWebhook', currentSociety, (data and data.url) or '')
	cb('ok')
end)

RegisterNetEvent('esx_society:webhookSaved')
AddEventHandler('esx_society:webhookSaved', function(url)
	SendNUIMessage({ action = 'webhookSaved', societyWebhook = url or '' })
end)

-- Employé : se mettre en/hors service depuis un autre script.
RegisterNetEvent('esx_society:toggleService')
AddEventHandler('esx_society:toggleService', function(state)
	local job = ESX and ESX.PlayerData and ESX.PlayerData.job
	if not job or not job.name then return end
	TriggerServerEvent('esx_society:setServiceState', job.name, state == true)
end)
