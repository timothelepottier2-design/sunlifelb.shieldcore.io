ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local lastCalled = 0
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local wait = 1000

        for k,v in pairs(Config.farming) do
            local dst_markerInfo = GetDistanceBetweenCoords(v.markerInfo, GetEntityCoords(PlayerPedId()), true)
            if dst_markerInfo <= 5.0 then
                Draw3DTextH(v.markerInfo.x, v.markerInfo.y, v.markerInfo.z - 1.0, v.markerMessage, 4, 0.1, 0.1)
            end

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                wait = 0
                DrawMarker(20, v.recolte.x, v.recolte.y, v.recolte.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 106, 0, 140, false, true)
            end

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter")

                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    lastCalled = GetGameTimer() + 500
                    BoxTaked = true

                    Citizen.CreateThread(function()
                        while BoxTaked do
                            SetPedMoveRateOverride(PlayerPedId(), 2.10)
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

                    ExecuteCommand("e boxsteel")
                end
            end

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                wait = 0
                DrawMarker(20, v.traitement.x, v.traitement.y, v.traitement.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 106, 0, 140, false, true)
            end

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 2 then
                if BoxTaked then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter")

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 10 * 1000
                        BoxTaked = false

                        local finished = false

                        ExecuteCommand("e stop")
                        BoxTaked = true
                        FreezeEntityPosition(PlayerPedId(), true)
                        ExecuteCommand("e seringue")
                        TriggerEvent("core:drawBar", 15000, "💊 Traitement en cours...")
                        Citizen.Wait(15000)
                        finished = true
                        BoxTaked = false
                        ExecuteCommand("e stop")
                        TriggerServerEvent("jobs:setupPlayerMission")
                        FreezeEntityPosition(PlayerPedId(), false)
                        if finished then
                            SJobsTriggerPay("farm")
                        end
                    end
                else
                    ESX.ShowHelpNotification("Allez à la première étape")
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

local function GroupDigits(value)
	if value == nil then return 0 end
	local left,num,right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)', '%1'.." "):reverse())
end

local function capitalizeFirstLetter(str)
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

local jobpack_takedBox = function()
    return BoxTaked
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.farming) do
        if v.public == true then
            local drugblip = AddBlipForCoord(v.recolte)
            SetBlipSprite(drugblip, v.blip)
            SetBlipColour(drugblip, v.color)
            SetBlipScale(drugblip, v.scale)
            SetBlipAsShortRange(drugblip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(drugblip)
        end
    end
end)
