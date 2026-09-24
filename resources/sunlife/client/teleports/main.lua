ESX                           = nil

local PlayerData              = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    LoadMarkers()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    PlayerData.job = job
end)

function LoadMarkers()
    Citizen.CreateThread(function()
        while true do
            local plyCoords = GetEntityCoords(PlayerPedId())
            local near = false

            for location, val in pairs(ConfigTeleports.Teleporters) do
                local Enter = val['Enter']
                local Exit = val['Exit']
                local JobNeeded = val['Job']

                local dstCheckEnter, dstCheckExit = GetDistanceBetweenCoords(plyCoords, Enter['x'], Enter['y'], Enter['z'], true), GetDistanceBetweenCoords(plyCoords, Exit['x'], Exit['y'], Exit['z'], true)

                if dstCheckEnter <= 7.5 then
                    near = true
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then
                            DrawMarker(6, Enter['x'], Enter['y'], Enter['z'], nil, nil, nil, -90, nil, nil, 1.9, 1.9, 1.9, 255, 117, 31, 225, false, false)
                            Draw3DTextH(Enter['x'], Enter['y'], Enter['z'] - 0.98, Enter['Information'], 4, 0.1, 0.1)
                            if dstCheckEnter <= 1.2 then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'enter')
                                end
                            end
                        end
                    else
                        DrawMarker(6, Enter['x'], Enter['y'], Enter['z'], nil, nil, nil, -90, nil, nil, 1.9, 1.9, 1.9, 255, 117, 31, 225, false, false)
                        Draw3DTextH(Enter['x'], Enter['y'], Enter['z'] - 0.98, Enter['Information'], 4, 0.1, 0.1)
                        if dstCheckEnter <= 1.2 then
                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'enter')
                            end
                        end
                    end
                end

                if dstCheckExit <= 7.5 then
                    near = true
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then
                            DrawMarker(6, Exit['x'], Exit['y'], Exit['z'], nil, nil, nil, -90, nil, nil, 1.9, 1.9, 1.9, 255, 117, 31, 225, false, false)
                            Draw3DTextH(Exit['x'], Exit['y'], Exit['z'] - 0.98, Exit['Information'], 4, 0.1, 0.1)
                            if dstCheckExit <= 1.2 then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'exit')
                                end
                            end

                        end
                    else
                        DrawMarker(6, Exit['x'], Exit['y'], Exit['z'], nil, nil, nil, -90, nil, nil, 1.9, 1.9, 1.9, 255, 117, 31, 225, false, false)
                        Draw3DTextH(Exit['x'], Exit['y'], Exit['z'] - 0.98, Exit['Information'], 4, 0.1, 0.1)
                        if dstCheckExit <= 1.2 then
                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'exit')
                            end
                        end
                    end
                end
            end
            if near then
                Citizen.Wait(0)
            else
                Citizen.Wait(1000)
            end
        end
    end)
end

function Teleport(table, location)
    if location == 'enter' then
        DoScreenFadeOut(100)

        Citizen.Wait(750)

        ESX.Game.Teleport(PlayerPedId(), table['Exit'])

        DoScreenFadeIn(100)
    else
        DoScreenFadeOut(100)

        Citizen.Wait(750)

        ESX.Game.Teleport(PlayerPedId(), table['Enter'])

        DoScreenFadeIn(100)
    end
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
