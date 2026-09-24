ESX = nil

local DrugsOpen = false
local selling = false
local actualpoint = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	RMenu.Add('menu', 'sell', RageUI.CreateMenu("SunLife", "Acheteur de drogues de laboratoire", 1, 100))
    RMenu:Get('menu', 'sell'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'sell').EnableMouse = false
    RMenu:Get('menu', 'sell').Closed = function()
		DrugsOpen = false
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

function openSellingMenu(actualpoint)
	if DrugsOpen then
        RageUI.CloseAll()
        DrugsOpen = false
        return
    else
        DrugsOpen = true
        RageUI.Visible(RMenu:Get('menu', 'sell'), true)

        Citizen.CreateThread(function()
            while DrugsOpen do
                RageUI.IsVisible(RMenu:Get('menu', 'sell'), true, true, true, function()
                    for i,j in pairs(actualpoint) do
                        local sellPrice = math.floor(j.price * ((CFG_DRUGS and CFG_DRUGS.sellPriceMultiplier) or 1.0))
                        RageUI.ButtonWithStyle(j.name, nil, {RightLabel = sellPrice .. "$/unité"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local amount = KeyboardInputDrugs("Combien voulez-vous vendre ?", "", 10)
                                if amount ~= "" or amount ~= nil then
                                    amount = tonumber(amount)

                                    if amount then
                                        if amount <= 10 then
                                            local pid = PlayerPedId()
                                            loadAnimDict('mp_common')
                                            TaskPlayAnim(pid, "mp_common", "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
                                            TriggerServerEvent("drugs:sellItem", j.item, amount)
                                            RageUI.CloseAll()
                                            DrugsOpen = false
                                        else
                                            ESX.ShowNotification("Vous ne pouvez pas vendre plus de 10 unités à la fois.")
                                        end
                                    else
                                        RageUI.CloseAll()
                                        DrugsOpen = false
                                    end
                                else
                                    ESX.ShowNotification("Entrée invalide !")
                                end
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

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k,v in pairs(CFG_DRUGS.drugstosell) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.coords)

            if dist <= 3.0 then
				actualpoint = v.items
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour parler avec l'acheteur de drogues")
                DrawMarker(6, v.coords, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
                if IsControlJustPressed(1,38) then
					if DrugsOpen == false then
                        openSellingMenu(actualpoint)
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

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z+1)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
end

KeyboardInputDrugs = function(one, two, max)
    local i = nil

    exports.dialog:openDialog(one, function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)

    return i
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function isMenuOpenned()
	return DrugsOpen
end
