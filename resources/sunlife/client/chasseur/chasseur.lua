ESX = nil

local OnMenuActive = false
local VehiculeRecup = false
local SpawnVehicule = {coords = vector3(-1467.25, -925.65, 10.05)}
local StartMission = false
local MissionCorps = false
local cooldownchasseur = false

NpcBgSpawn = {
    vector3(-249.76, 490.05, 126.08),
    vector3(1057.8, -612.84, 56.78),
    vector3(-119.48, -2359.01, 9.32),
    vector3(-2960.33, 53.2, 11.61),
    vector3(-1281.5, 302.8, 64.96),
    vector3(169.77, -1724.8, 29.3),
    vector3(80.9, -1617.7, 29.59),
    vector3(483.58, -1337.97, 29.3),
    vector3(1022.63, -2507.84, 28.45),
    vector3(1241.45, -3322.37, 6.03),
    vector3(1179.19, 2701.6, 38.17),
    vector3(1953.5, 3842.64, 32.18),
    vector3(74.32, 3679.61, 39.76),
    vector3(-200.58, 6354.86, 31.49),
    vector3(-1490.93, 4981.59, 63.33),
    vector3(186.03, -1112.15, 29.29),
    vector3(1211.23, -1389.72, 35.38),
	vector3(279.288, -1798.33, 27.113)
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

	RMenu.Add('menu', 'chasseur', RageUI.CreateMenu("SunLife", "Chasse à l'homme", 1, 100))
    RMenu:Get('menu', 'chasseur'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'chasseur').EnableMouse = false
    RMenu:Get('menu', 'chasseur').Closed = function()
		OnMenuActive = false
    end
end)

function RandomSpawnNPC()
    local index = GetRandomIntInRange(1, #NpcBgSpawn)
    return NpcBgSpawn[index]
end

function GetNPC(_npc)
    npc_ = _npc
end

function StartMission()
    TriggerServerEvent("chasseur:setupPlayerMission")
	PlaySoundFrontend(-1, "Team_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset", 1)
	local ped = PlayerPedId()
	RequestModel(GetHashKey("u_m_y_zombie_01"))
	while not HasModelLoaded(GetHashKey("u_m_y_zombie_01")) do
		Wait(1)
	end
	NpcSpawnCoords = RandomSpawnNPC()
	npc = CreatePed(4, GetHashKey("u_m_y_zombie_01"), NpcSpawnCoords.x, NpcSpawnCoords.y, NpcSpawnCoords.z-1, 143.21, false, false)
	TaskWanderStandard(npc, 10.0, 10)
	local blip = AddBlipForEntity(npc)
	SetBlipSprite(blip, 103)
    SetBlipColour(blip, 38)
    SetBlipScale(blip, 0.8)
    SetBlipRoute(blip, true)
    ESX.ShowAdvancedNotification("Hao", "~o~Contrat", "Va me tuer ce petit con, prends ta caisse !", "CHAR_HAO", 8)
    PedCoord = GetEntityCoords(npc)
    PlayerCoord = GetEntityCoords(ped)
    local distanceNPC = GetDistanceBetweenCoords(PedCoord, PlayerCoord, true)
    local ped = PlayerPedId()
    local IsNpcDead = GetEntityHealth(npc)

    while IsNpcDead > 1 do
        IsNpcDead = GetEntityHealth(npc)
        Citizen.Wait(1000)
    end

    TaskWanderStandard(npc, 10.0, 10)
    RemoveBlip(blip)
    ESX.ShowAdvancedNotification("Hao", "~b~Contrat", "Super, je te fais un virement !", "CHAR_HAO", 8)
    TriggerServerEvent('Chasseur:GettozPayBlack')
    Wait(1000)
end

function openChasseurMenu()
	local coords = GetEntityCoords(PlayerPedId())

    if OnMenuActive then
        OnMenuActive = false
        return
    else
        OnMenuActive = true
        RageUI.Visible(RMenu:Get('menu', 'chasseur'), true)

        Citizen.CreateThread(function()
            while OnMenuActive do

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                    RageUI.CloseAll()
                    OnMenuActive = false
                end

                RageUI.IsVisible(RMenu:Get('menu', 'chasseur'), true, true, true, function()
                    RageUI.ButtonWithStyle("Commençer une mission", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
                            if cooldownchasseur then
                                ESX.ShowNotification("~r~Vous ne pouvez faire qu'une seule mission toutes les 5 minutes !")
                            else
							    StartMission()
							    RageUI.CloseAll()
							    OnMenuActive = false
							    VehiculeRecup = true
                                cooldownchasseur = true
                                Citizen.Wait(300000)
                                cooldownchasseur = false
                            end
                        end
                    end)
                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local position = {
	{x = -1471.77 , y = -908.78, z = 10.13, },
    {x = -101.5851 , y = 6505.93, z = 30.5508, }
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false
		for k in pairs(position) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 3.0 then
                nearThing = true

                if OnMenuActive == false then
                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler à Hao")
				    if IsControlJustPressed(1,51) then
				    	openChasseurMenu()
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

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)

    AddTextComponentString(text)
    DrawText(_x, _y)
end
