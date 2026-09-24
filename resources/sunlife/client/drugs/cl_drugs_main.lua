ESX = nil
local MenuOpened = false
local InLabo = false
local cooldown = false
local has = false
local youhave = false
local drug = ""
local sellingDrugs = false

local DRUGS_EVENT_CONVAR = 'slf_dg_ev'

local function _sendGiveDrugs(item)
    local ev = GetConvar(DRUGS_EVENT_CONVAR, '')

    if ev == '' then return end
    TriggerServerEvent(ev, item)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    RMenu.Add('menu', 'entry', RageUI.CreateMenu("SunLife", "Laboratoire", 1, 100))
    RMenu.Add('menu', 'exit', RageUI.CreateMenu("SunLife", "Laboratoire", 1, 100))
    RMenu:Get('menu', 'entry'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'exit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'entry').EnableMouse = false
    RMenu:Get('menu', 'exit').EnableMouse = false
    RMenu:Get('menu', 'entry').Closed = function()
        MenuOpened = false
    end
    RMenu:Get('menu', 'exit').Closed = function()
        MenuOpened = false
    end
end)

local EnAction = false

Citizen.CreateThread(function()
    while ESX == nil do Wait(1) end
    local attente = 150
    while CFG_DRUGS.laboratoires == nil do Wait(10000) end
    while true do
        Wait(attente)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local DansUneZone = false
        for k,v in pairs(CFG_DRUGS.laboratoires) do

            if not DansUneZone and not EnAction then
                local dst_entry = GetDistanceBetweenCoords(pCoords, v.entry, true)
                if dst_entry <= 3.0 then
                    DansUneZone = true
                    DrawMarker(25, v.entry, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                    Draw3DTextH(v.entry.x, v.entry.y, v.entry.z - 1.0, "Entrée du "..v.name, 4, 0.1, 0.1)
                    if dst_entry <= 3.0 then
                        if IsControlJustReleased(1, 38) then
                            if MenuOpened == false then
                                if cooldown then
                                    ESX.ShowNotification("~r~[ANTI-USEBUG]~s~ Vous êtes en cooldown, attendez avant de pouvoir utiliser ce point.")
                                else
                                    exports["sCore"]:setFreecamBypass(true, "TRUE DRUGS")
                                    Wait(1000)
				                    SetEntityCoords(pPed, v.exit, 1, 0, 0, 1)
                                    -- k = cle du labo : plusieurs labos partagent la meme instance,
                                    -- le serveur en a besoin pour memoriser la bonne sortie.
                                    TriggerServerEvent("laboratoires:bucketChange", v.instanceLevel, k)
                                    TriggerEvent("laboratoires:loadData", k)
                                    InLabo = true
                                    cooldown = true
                                    Citizen.Wait(10000)
                                    cooldown = false
                                end
                            end
                        end
                    end
                end
            end

            if DansUneZone then
                attente = 1
            else
                attente = 150
            end
        end
    end
end)

RegisterNetEvent("laboratoires:loadData")
AddEventHandler("laboratoires:loadData", function(drugType)
    for k,v in pairs(CFG_DRUGS.laboratoires) do
        if k == drugType then
            local lastCalled = 0
            TriggerEvent("laboratoires:loadUpgrades", drugType)
            Citizen.CreateThread(function()
                while true do
                    local pPed = PlayerPedId()
                    local pCoords = GetEntityCoords(pPed)

                    if InLabo then

                        local dst_exit = GetDistanceBetweenCoords(pCoords, v.exit, true)
                        if dst_exit <= 3.0 then
                            DrawMarker(25, v.exit, nil, nil, nil, nil, nil, nil, 1.0 , 1.0, 1.0, 255, 117, 31, 225)
                            Draw3DTextH(v.exit.x, v.exit.y, v.exit.z - 1.0, "Sortie du "..v.name, 4, 0.1, 0.1)
                            if dst_exit <= 3.0 then
                                if IsControlJustReleased(1, 38) then
                                    if MenuOpened == false then
                                        if cooldown then
                                            ESX.ShowNotification("~r~[ANTI-USEBUG]~s~ Vous êtes en cooldown, attendez avant de pouvoir utiliser ce point.")
                                        else
                                            SetEntityCoords(pPed, v.entry, 1, 0, 0, 1)
                                            TriggerServerEvent("laboratoires:bucketChange", 0)
                                            TriggerEvent("laboratoires:unloadData")
                                            cooldown = true
                                            Citizen.Wait(10000)
                                            cooldown = false
                                            exports["sCore"]:setFreecamBypass(false, "FALSE DRUGS")
                                        end
                                    end
                                end
                            end
                        end

                        local intervalrecolte = 1000

                        if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                            intervalrecolte = 0
                            DrawMarker(20, v.recolte.x, v.recolte.y, v.recolte.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 2 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter")

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                BoxTaked = true

                                Citizen.CreateThread(function()
                                    while BoxTaked do
                                        SetPedMoveRateOverride(PlayerPedId(), 1.10)
                                        DisableControlAction(0, 22, true)
                                        DisableControlAction(0, 102, true)
                                        DisableControlAction(0, 258, true)
                                        DisableControlAction(0, 259, true)
                                        DisableControlAction(0, 350, true)
                                        DisableControlAction(0, 21, true)
                                        DisableControlAction(0, 137, true)
                                        DisablePlayerFiring(PlayerPedId(), true)
                                        Citizen.Wait(0)
                                    end
                                    DisablePlayerFiring(PlayerPedId(), false)
                                    ExecuteCommand("e stop")
                                    SetPedMoveRateOverride(PlayerPedId(), 1.0)
                                end)

                                ExecuteCommand("e box")
                            end
                        end

                        local intervaltraitement = 1000

                        if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                            intervaltraitement = 0
                            DrawMarker(20, v.traitement.x, v.traitement.y, v.traitement.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 2 then
                            if BoxTaked then
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter")

                                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                    lastCalled = GetGameTimer() + 16 * 1000
                                    BoxTaked = false

                                    FreezeEntityPosition(PlayerPedId(), true)
                                    if k == "weed" then
                                        ExecuteCommand("e weedfarm")
                                    elseif k == "meth" then
                                        ExecuteCommand("e methfarm")
                                    else
                                        ExecuteCommand("e seringue")
                                    end

                                    local success = lib.progressCircle({
                                        duration = 16000,
                                        label = '💊 Traitement en cours...',
                                        useWhileDead = false,
                                        canCancel = false,
                                        disable = {
                                            car = true,
                                            move = true,
                                            combat = true,
                                        }
                                    })

                                    ExecuteCommand("e stop")
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    if success then
                                        _sendGiveDrugs(v.itemgive)
                                    end
                                    BoxTaked = false
                                end
                            else
                                ESX.ShowHelpNotification("Allez à la première étape")
                            end
                        end
                    else
                        return
                    end
                    if InLabo then
                        Citizen.Wait(0)
                    else
                        Citizen.Wait(1500)
                    end
                end
            end)
        end
    end
end)

Citizen.CreateThread(function()
    local lastCalled = 0
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local InZone = false

        for k,v in pairs(CFG_DRUGS.points) do
            local dst_markerInfo = GetDistanceBetweenCoords(v.markerInfo, GetEntityCoords(PlayerPedId()), true)
            if dst_markerInfo <= 100.0 then
                InZone = true
            end
            if dst_markerInfo <= 5.0 then
                Draw3DTextH(v.markerInfo.x, v.markerInfo.y, v.markerInfo.z - 1.0, v.markerMessage, 4, 0.1, 0.1)
            end

            local intervalrecolte = 1000

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                intervalrecolte = 0
                DrawMarker(20, v.recolte.x, v.recolte.y, v.recolte.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
            end

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter")

                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    lastCalled = GetGameTimer() + 500
                    BoxTaked = true

                    Citizen.CreateThread(function()
                        while BoxTaked do
                            SetPedMoveRateOverride(PlayerPedId(), 1.10)
                            DisableControlAction(0, 22, true)
                            DisableControlAction(0, 102, true)
                            DisableControlAction(0, 258, true)
                            DisableControlAction(0, 259, true)
                            DisableControlAction(0, 350, true)
                            DisableControlAction(0, 21, true)
                            DisableControlAction(0, 137, true)
                            DisablePlayerFiring(PlayerPedId(), true)
                            Citizen.Wait(0)
                        end
                        DisablePlayerFiring(PlayerPedId(), false)
                        ExecuteCommand("e stop")
                        SetPedMoveRateOverride(PlayerPedId(), 1.0)
                    end)

                    ExecuteCommand("e box")
                end
            end

            local intervaltraitement = 1000

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                intervaltraitement = 0
                DrawMarker(20, v.traitement.x, v.traitement.y, v.traitement.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
            end

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 2 then
                if BoxTaked then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter")

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 16 * 1000
                        BoxTaked = false

                        ExecuteCommand("e stop")
                        BoxTaked = true

                        if k == "badweed_pooch" then
                            ExecuteCommand("e weedfarm")
                        else
                            ExecuteCommand("e seringue")
                        end

                        local success = lib.progressCircle({
                            duration = 16000,
                            label = '💊 Traitement en cours...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                            }
                        })
                        ExecuteCommand("e stop")
                        FreezeEntityPosition(ped, false)
                        BoxTaked = false

                        if success then
                            _sendGiveDrugs(v.itemgive)
                        end
                    end
                else
                    ESX.ShowHelpNotification("Allez à la première étape")
                end
            end
        end
        if InZone then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("laboratoires:unloadData")
AddEventHandler("laboratoires:unloadData", function()
    InLabo = false
end)

RegisterNetEvent("laboratoires:loadUpgrades")
AddEventHandler("laboratoires:loadUpgrades", function(drugType)
    if drugType == "weed" then
        local BikerWeedFarm = exports.bob74_ipl:GetBikerWeedFarmObject()
        BikerWeedFarm.Style.Set(BikerWeedFarm.Style.upgrade)
        BikerWeedFarm.Security.Set(BikerWeedFarm.Security.upgrade)
        BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.drying, true)
        BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.chairs, true)
        BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.production, true)
        BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.fans, true)

        BikerWeedFarm.Details.Enable({
            BikerWeedFarm.Details.production,
            BikerWeedFarm.Details.chairs,
            BikerWeedFarm.Details.drying,
            BikerWeedFarm.Details.fans,
        }, true)
    elseif drugType == "meth" then
        local BikerMethLab = exports.bob74_ipl:GetBikerMethLabObject()
        BikerMethLab.Style.Set(BikerMethLab.Style.upgrade)
        BikerMethLab.Security.Set(BikerMethLab.Security.upgrade)
        BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
    else
        local BikerCocaine = exports.bob74_ipl:GetBikerCocaineObject()
        BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
        BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)
        BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, true, true)
        BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, true, true)
        BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, true, true)
        BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, true, true)
        BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, true, true)
    end
end)

function GroupDigits(value)
	if value == nil then return 0 end
	local left,num,right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)', '%1'.." "):reverse())
end

function capitalizeFirstLetter(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

takedBox = function()
    return BoxTaked
end

Citizen.CreateThread(function()
    for k,v in pairs(CFG_DRUGS.points) do
        if v.public == true then
            local drugblip = AddBlipForCoord(v.recolte)
            SetBlipSprite(drugblip, v.blip)
            SetBlipColour(drugblip, 0)
            SetBlipScale(drugblip, 0.8)
            SetBlipAsShortRange(drugblip, true)
            local _key = "BN_SUNLIFE_DRUGS_1_" .. tostring(k)
            AddTextEntry(_key, v.name)
            BeginTextCommandSetBlipName(_key)
            EndTextCommandSetBlipName(drugblip)
        end
    end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.8)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end
