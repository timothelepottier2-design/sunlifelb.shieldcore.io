shopobject = shopobject or {}
_sync = true
ShopActif = false
MenuActuel = ""

Citizen.CreateThread(function()
	RMenu.Add('menu', 'shop', RageUI.CreateMenu("SunLife", "Menu Supérettes", 1, 100))
	RMenu:Get('menu', 'shop'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'shop').EnableMouse = false
    RMenu:Get('menu', 'shop').Closed = function()
		ShopActif = false
    end
end)

function CreateShop()
	local coords = GetEntityCoords(PlayerPedId())

	if ShopActif then
		RageUI.CloseAll()
        ShopActif = false
        return
    else
        ShopActif = true
		for k,v in pairs(shopobject) do
			_prix = 0
			_quantite = 1

			if MenuActuel == v.MenuId then
				RageUI.Visible(RMenu:Get('menu', 'shop'), true)

				Citizen.CreateThread(function()
					while ShopActif do
						Wait(0)

						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
							RageUI.CloseAll()
							ShopActif = false
						end

						RageUI.IsVisible(RMenu:Get('menu', 'shop'), true, true, true, function()
							RageUI.ButtonWithStyle("Quantité ", nil, {RightLabel = "~h~".._quantite.. "x"}, true, function(Hovered, Active, Selected)
								if (Selected) then
									if Selected then
										SelectQuantite()
									end
								end
							end)

							for k,v in pairs(v.items) do
								RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "~h~"..v.prix * _quantite.."$"}, true, function(Hovered, Active, Selected)
									if (Active) then
										_prix = v.prix
									end
									if (Selected) then
										if _quantite >= 1 then
											TriggerServerEvent("shop:Buy", v.NomItem, _quantite)
										end
									end
								end)
							end
						end, function()
						end)
					end
				end, function()
				end, 1)
			end
		end
	end
end

function SelectQuantite()
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait( 0 )
	end

	local result = GetOnscreenKeyboardResult()

	if result and result ~= "" then
		_quantite = tonumber(result)
		if _quantite > 20 then
			_quantite = 20
		end
	else
		_quantite = 1
	end
end

local smoking = false
local cigProp = nil
local helpShown = false

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function attachCig()
    local ped = PlayerPedId()
    if DoesEntityExist(cigProp) then
        DeleteObject(cigProp)
        cigProp = nil
    end
    local model = GetHashKey('prop_cs_ciggy_01')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    print(('^2[NETDIAG][OBJET]^7 %s cl_menu.lua:119 CreateObject NETWORKED cigProp model=%s'):format(GetCurrentResourceName(), tostring(model)))
    cigProp = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(cigProp, ped, GetPedBoneIndex(ped, 28422), 0.02, 0.02, 0.0, 90.0, 0.0, -20.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(model)
end

local function startSmoke()
    local ped = PlayerPedId()
    if smoking then return end
    smoking = true
    attachCig()
    loadAnimDict('amb@world_human_aa_smoke@male@idle_a')
    TaskPlayAnim(ped, 'amb@world_human_aa_smoke@male@idle_a', 'idle_c', 8.0, -8.0, -1, 49, 0.0, false, false, false)
    helpShown = true
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName('~INPUT_CONTEXT~ pour arrêter de fumer')
    EndTextCommandDisplayHelp(0, false, true, -1)
    CreateThread(function()
        while smoking do
            if IsControlJustReleased(0, 38) then
                TriggerEvent('cigarettes:stop')
            end
            if IsPedInAnyVehicle(ped, false) or IsEntityDead(ped) or IsPedRagdoll(ped) then
                TriggerEvent('cigarettes:stop')
            end
            Wait(0)
        end
    end)
end

local function stopSmoke()
    local ped = PlayerPedId()
    smoking = false
    ClearPedTasks(ped)
    if DoesEntityExist(cigProp) then
        DeleteObject(cigProp)
        cigProp = nil
    end
    if helpShown then
        ClearAllHelpMessages()
        helpShown = false
    end
end

RegisterNetEvent('cigarettes:start', function()
    startSmoke()
end)

RegisterNetEvent('cigarettes:stop', function()
    stopSmoke()
end)

RegisterNetEvent('cigarettes:notify', function(msg)
    TriggerEvent('esx:showNotification', msg)
end)

RegisterNetEvent('cigarettes:left', function(n)
    if n and n > 0 then
        TriggerEvent('esx:showNotification', ('~b~Il reste %s clopes dans le paquet.'):format(n))
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if smoking then stopSmoke() end
end)
