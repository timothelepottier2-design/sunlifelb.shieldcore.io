ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local dropobj = nil
local parachuteobj = nil
local DropDown = false
local seconds = 0
local blip = nil
local blip2 = nil
local StartCheck = false
local dropZcoords = nil
local dropCoords = nil
local dropCoordsChecked = false

RegisterNetEvent('wais:CreateDrop', function(coords)
    dropCoords = coords

    CreateBlipAirdrop(coords)

    if not ConfigAirdrop.CaseProp then return end

	RequestModel(ConfigAirdrop.CaseProp)
	while (not HasModelLoaded(ConfigAirdrop.CaseProp)) do
		Citizen.Wait(1)
	end

    dropobj = CreateObject(GetHashKey(ConfigAirdrop.CaseProp), ConfigAirdrop.Coords[coords].x, ConfigAirdrop.Coords[coords].y, ConfigAirdrop.Coords[coords].z + 100.0, false, false, false)
    parachuteobj = CreateObject(GetHashKey(ConfigAirdrop.ParachuteProp), ConfigAirdrop.Coords[coords].x, ConfigAirdrop.Coords[coords].y, ConfigAirdrop.Coords[coords].z + 100.0, false, false, false)
    AttachEntityToEntity(parachuteobj, dropobj, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    local foundGround, zpos = GetGroundZFor_3dCoord(ConfigAirdrop.Coords[coords].x, ConfigAirdrop.Coords[coords].y, ConfigAirdrop.Coords[coords].z)
    local foundGround2, zpos2 = GetGroundZFor_3dCoord(GetEntityCoords(dropobj).x, GetEntityCoords(dropobj).y, GetEntityCoords(dropobj).z)

    StartCheck = true

    Citizen.CreateThread(function()
        while StartCheck do
            SetEntityNoCollisionEntity(dropobj, PlayerPedId(), true)
            SetEntityNoCollisionEntity(parachuteobj, PlayerPedId(), true)
            SetEntityProofs(dropobj, true, true, true, true, true, true, true, true)
            SetEntityProofs(parachuteobj, true, true, true, true, true, true, true, true)
            if IsPedInAnyVehicle(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                SetEntityNoCollisionEntity(dropobj, vehicle, true)
                SetEntityNoCollisionEntity(parachuteobj, vehicle, true)
            end
            Citizen.Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        while StartCheck do
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dropCoords = GetEntityCoords(dropobj)
            local distance = #(pedCoords - dropCoords)
            if distance < 300.0 then
                if not dropCoordsChecked then
                    foundGround, zpos = GetGroundZFor_3dCoord(ConfigAirdrop.Coords[coords].x, ConfigAirdrop.Coords[coords].y, ConfigAirdrop.Coords[coords].z)
                    foundGround2, zpos2 = GetGroundZFor_3dCoord(GetEntityCoords(dropobj).x, GetEntityCoords(dropobj).y, GetEntityCoords(dropobj).z)
                    if foundGround and foundGround2 then
                        dropCoordsChecked = true
                    end
                    break
                end
            end
            Citizen.Wait(500)
        end
    end)

    Citizen.CreateThread(function()
        while StartCheck do
            Citizen.Wait(500)
            ActivatePhysics(dropobj)
            SetDamping(dropobj, 2, 0.1)
            SetEntityVelocity(dropobj, 0.0, 0.0, -0.2)
            SetEntityLodDist(parachuteobj, 1000)
        end
    end)

    dropZcoords = zpos

    CreateThread(function()
        while true do
            if GetEntityHeightAboveGround(dropobj) <= 1 then
                parachuteobj = nil
                SecondsToClockAirdrop()
                TimerAirdrop()
                seconds = ConfigAirdrop.DropWaitTime
                DropDown = true
                FreezeEntityPosition(dropobj, true)
                StartCheck = false
                if not dropDownServer then
                    dropDownServer = true
                    TriggerServerEvent('wais:dropCome')
                end
                break
            end
            Wait(1)
        end
    end)
end)

RegisterNetEvent('wais:setDropDown', function()
    dropDownServer = true
    SetEntityCoords(dropobj, ConfigAirdrop.Coords[dropCoords].x, ConfigAirdrop.Coords[dropCoords].y, ConfigAirdrop.Coords[dropCoords].z )
    PlaceObjectOnGroundProperly(dropobj)
    FreezeEntityPosition(dropobj, true)
    parachuteobj = nil
    SecondsToClockAirdrop()
    TimerAirdrop()
    seconds = ConfigAirdrop.DropWaitTime
    DropDown = true
    StartCheck = false
    dropCoordsChecked = false
end)

RegisterNetEvent('wais:deletedrop', function()
    RemoveBlip(blip)
    RemoveBlip(blip2)
    DeleteObject(dropobj)
    DeleteObject(parachuteobj)
    DeleteEntity(parachuteobj)
    parachuteobj = nil
    dropobj = nil
    DropDown = false
    dropCoordsChecked = false
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if DropDown then
            local ped = PlayerPedId()
            local ec = GetEntityCoords(dropobj)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(ped), ec.x, ec.y, ec.z, true)
            if distance < 5 then
                sleep = 5
                if distance < 2 then
                    sleep = 2
                    if seconds >= 1 then
                        DrawText3DAirdrop(ec.x, ec.y, ec.z + 0.4, SecondsToClockAirdrop())
                    else
                        if not IsPedInAnyVehicle(ped, false) then
                            DrawText3DAirdrop(ec.x, ec.y, ec.z + 0.4, '[E] - Récupérer le drop')
                            if IsControlJustReleased(0, 38) then
                                if not IsEntityDead(ped) then
                                    TriggerServerEvent('wais:opendrop')
                                end
                            end
                        else
                            DrawText3DAirdrop(ec.x, ec.y, ec.z + 0.4, 'Sortez du véhicule pour récupérer le drop')
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function CreateBlipAirdrop(coords)
    blip = AddBlipForRadius(ConfigAirdrop.Coords[coords].x,ConfigAirdrop.Coords[coords].y,ConfigAirdrop.Coords[coords].z, 150.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 3)
    SetBlipAlpha (blip, 128)

    blip2 = AddBlipForCoord(ConfigAirdrop.Coords[coords].x,ConfigAirdrop.Coords[coords].y,ConfigAirdrop.Coords[coords].z)
    SetBlipSprite (blip2, 94)
    SetBlipColour (blip2, 4)
    SetBlipAsShortRange(blip2, true)

    AddTextEntry("BN_SUNLIFE_AIRDROPS_1", "Zone de l'airdrop")
    BeginTextCommandSetBlipName("BN_SUNLIFE_AIRDROPS_1")
    EndTextCommandSetBlipName(blip2)
end

function TimerAirdrop()
    CreateThread(function()
        while true do
            if seconds >= 1 then
                seconds = seconds - 1
            else
                break
            end
            Wait(1000)
        end
    end)
end

function SecondsToClockAirdrop()
    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

function DrawText3DAirdrop(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.28, 0.28)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y +0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
end

function DrawScaleformAirdrop(bigMsg,smallMsg,time)
    Citizen.CreateThread(function(...)
        local scaleform = RequestScaleformMovie("mp_big_message_freemode")
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end

        BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
        PushScaleformMovieMethodParameterString(bigMsg)
        PushScaleformMovieMethodParameterString(smallMsg)
        PushScaleformMovieMethodParameterInt(5)
        EndScaleformMovieMethod()

        local timer = GetGameTimer()
        while GetGameTimer() - timer < time * 1000 do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end
