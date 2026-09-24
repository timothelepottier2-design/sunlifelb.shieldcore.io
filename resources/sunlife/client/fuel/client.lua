ESX = nil
local FUEL_DECOR = "_ANDY_FUEL_DECORE_"
local nozzleDropped = false
local holdingNozzle = false
local nozzleInVehicle = false
local nozzle
local rope
local vehicleFueling
local usedPump
local pumpCoords
local wastingFuel = false
local usingCan = false
local nearTank = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253),
    vector3(2796.324, 4839.55, 46.253),
    vector3(-1227.9604492188, 6918.3081054688, 20.349634170532),
    vector3(-1227.9571533203, 6918.3100585938, 20.349639892578),
    vector3(-3269.0815429688, 6175.5888671875, 13.483327865601),
    vector3(-3270.3337402344, 6183.9936523438, 13.607933998108),
    vector3(-3283.6901855469, 6181.9663085938, 13.614853858948),
    vector3(-3282.4602050781, 6173.6157226562, 13.614838600159),
    vector3(1433.1442871094, 3715.1428222656, 33.295467376709)
}

local BLIP_CAT_FUEL = 42

local FuelStationsBlips = {
    vector3(49.4187, 2778.793, 58.043),
    vector3(263.894, 2606.463, 44.983),
    vector3(1039.958, 2671.134, 39.550),

    vector3(2539.685, 2594.192, 37.944),
    vector3(2679.858, 3263.946, 55.240),
    vector3(2005.055, 3773.887, 32.403),
    vector3(1687.156, 4929.392, 42.078),
    vector3(1701.314, 6416.028, 32.763),
    vector3(179.857, 6602.839, 31.868),
    vector3(-94.4619, 6419.594, 31.489),
    vector3(-2554.996, 2334.40, 33.078),
    vector3(-1800.375, 803.661, 138.651),
    vector3(-1437.622, -276.747, 46.207),
    vector3(-2096.243, -320.286, 13.168),
    vector3(-724.619, -935.1631, 19.213),
    vector3(-526.019, -1211.003, 18.184),
    vector3(-70.2148, -1761.792, 29.534),
    vector3(265.648, -1261.309, 29.292),
    vector3(819.653, -1028.846, 26.403),

    vector3(1181.381, -330.847, 69.316),
    vector3(620.843, 269.100, 103.089),
    vector3(2581.321, 362.039, 108.468),
    vector3(176.631, -1562.025, 29.263),
    vector3(-319.292, -1471.715, 30.549),

    vector3(2796.324, 4839.55, 46.253),
    vector3(1433.1442871094, 3715.1428222656, 33.295467376709),
}

CreateThread(function()

    AddTextEntry("BLIP_CAT_" .. BLIP_CAT_FUEL, "Station essence")

    AddTextEntry("BN_SNL_FUEL_STATION", "Station essence")

    for _, pos in ipairs(FuelStationsBlips) do
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 361)
        SetBlipScale(blip, 0.65)
        SetBlipColour(blip, 2)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        SetBlipCategory(blip, BLIP_CAT_FUEL)
        BeginTextCommandSetBlipName("BN_SNL_FUEL_STATION")
        EndTextCommandSetBlipName(blip)
    end
end)

local nozzleBasedOnClass = {
    0.65,
    0.65,
    0.85,
    0.6,
    0.55,
    0.6,
    0.6,
    0.55,
    0.12,
    0.8,
    0.7,
    0.6,
    0.7,
    0.0,
    0.0,
    0.0,
    0.0,
    0.6,
    0.65,
    0.65,
    0.75,
    0.0
}

for _, vehHash in pairs(FuelConfig.electricVehicles) do
    FuelConfig.electricVehicles[vehHash] = vehHash
end

function GetFuel(vehicle)
    if not DecorExistOn(vehicle, FUEL_DECOR) then
        return GetVehicleFuelLevel(vehicle)
    end
	return DecorGetFloat(vehicle, FUEL_DECOR)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == "number" and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel)
		DecorSetFloat(vehicle, FUEL_DECOR, GetVehicleFuelLevel(vehicle))
	end
end

function nearPump(coords)
    local entity = nil
    for hash in pairs(FuelConfig.pumpModels) do
        entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.8, hash, false, false, false)
        if entity ~= 0 then break end
    end
    if FuelConfig.pumpModels[GetEntityModel(entity)] then
        return GetEntityCoords(entity), entity
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end

function PlayEffect(pdict, pname)
    CreateThread(function()
        local position = GetOffsetFromEntityInWorldCoords(nozzle, 0.0, 0.28, 0.17)
        UseParticleFxAssetNextCall(pdict)
        local pfx = StartParticleFxLoopedAtCoord(pname, position.x, position.y, position.z, 0.0, 0.0, GetEntityHeading(nozzle), 1.0, false, false, false, false)
        Wait(100)
        StopParticleFxLooped(pfx, 0)
    end)
end

function vehicleInFront()
    local entity = nil
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
    local rayHandle = CastRayPointToPoint(pedCoords.x, pedCoords.y, pedCoords.z - 1.3, offset.x, offset.y, offset.z, 10, ped, 0)
    local A, B, C, D, entity = GetRaycastResult(rayHandle)
    if IsEntityAVehicle(entity) then
        return entity
    end
end

function grabNozzleFromPump()
    LoadAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    Wait(300)

    nozzle = CreateObject(`prop_cs_fuel_nozle`, 0, 0, 0, false, false, true)
    AttachEntityToEntity(nozzle, ped, GetPedBoneIndex(ped, 0x49D9), 0.11, 0.02, 0.02, -80.0, -90.0, 15.0, true, true, false, true, 1, true)
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Wait(0)
    end
    RopeLoadTextures()
    while not pump do
        Wait(0)
    end
    rope = AddRope(pump.x, pump.y, pump.z, 0.0, 0.0, 0.0, 3.0, 1, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not rope do
        Wait(0)
    end
    ActivatePhysics(rope)
    Wait(50)
    local nozzlePos = GetEntityCoords(nozzle)
    nozzlePos = GetOffsetFromEntityInWorldCoords(nozzle, 0.0, -0.033, -0.195)
    AttachEntitiesToRope(rope, pumpHandle, nozzle, pump.x, pump.y, pump.z + 1.45, nozzlePos.x, nozzlePos.y, nozzlePos.z, 5.0, false, false, nil, nil)
    nozzleDropped = false
    holdingNozzle = true
    nozzleInVehicle = false
    vehicleFueling = false
    usedPump = pumpHandle
end

function grabExistingNozzle()
    AttachEntityToEntity(nozzle, ped, GetPedBoneIndex(ped, 0x49D9), 0.11, 0.02, 0.02, -80.0, -90.0, 15.0, true, true, false, true, 1, true)
    nozzleDropped = false
    holdingNozzle = true
    nozzleInVehicle = false
    vehicleFueling = false
end

function putNozzleInVehicle(vehicle, ptankBone, isBike, dontClear, newTankPosition)
    if isBike then
        AttachEntityToEntity(nozzle, vehicle, ptankBone, 0.0 + newTankPosition.x, -0.2 + newTankPosition.y, 0.2 + newTankPosition.z, -80.0, 0.0, 0.0, true, true, false, false, 1, true)
    else
        AttachEntityToEntity(nozzle, vehicle, ptankBone, -0.18 + newTankPosition.x, 0.0 + newTankPosition.y, 0.75 + newTankPosition.z, -125.0, -90.0, -90.0, true, true, false, false, 1, true)
    end
    if not dontClear and IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
        ClearPedTasks(ped)
    end
    nozzleDropped = false
    holdingNozzle = false
    nozzleInVehicle = true
    wastingFuel = false
    vehicleFueling = vehicle
end

function dropNozzle()
    DetachEntity(nozzle, true, true)
    nozzleDropped = true
    holdingNozzle = false
    nozzleInVehicle = false
    vehicleFueling = false
end

function returnNozzleToPump()
    DeleteEntity(nozzle)
    RopeUnloadTextures()
    DeleteRope(rope)
    nozzleDropped = false
    holdingNozzle = false
    nozzleInVehicle = false
    vehicleFueling = false
end

local function isNearGasStation(myCoords)
    for _, station in pairs(GasStations) do
        if #(myCoords - station) < 15.0 then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        local playerNearTank = false
        local myCoords = GetEntityCoords(PlayerPedId())

        if isNearGasStation(myCoords) then
            playerNearTank = true
            ped = PlayerPedId()
            pedCoords = GetEntityCoords(ped)
            pump, pumpHandle = nearPump(myCoords)
            veh = GetVehiclePedIsIn(ped, true)
        end

        if playerNearTank == true then
            Citizen.Wait(500)
        else
            Citizen.Wait(2000)
        end
    end
end)

local function vehicleIsFueling()
    local classMultiplier = FuelConfig.vehicleClasses[GetVehicleClass(vehicleFueling)]
    local cost = 0

    ESX.ShowNotification("Remplissage en cours...")

    local availableMoney = nil
    ESX.TriggerServerCallback('fuel:getPlayerMoney', function(money)
        availableMoney = tonumber(money) or 0
    end, 'bank')

    local waited = 0
    while availableMoney == nil and waited < 2000 do
        Wait(50)
        waited = waited + 50
    end
    if not availableMoney or availableMoney <= 0 then
        ESX.ShowNotification("~r~Vous n'avez pas assez d'argent en banque.")
        vehicleFueling = false
        return
    end

    while vehicleFueling do
        local fuel = GetFuel(vehicleFueling)
        if not DoesEntityExist(vehicleFueling) then
            dropNozzle()

            vehicleFueling = false
            break
        end

        local newCost = ((2.0 / classMultiplier) * FuelConfig.fuelCostMultiplier) - math.random(0, 100) / 100

        if availableMoney < (cost + newCost) then
            ESX.ShowNotification("~r~Solde insuffisant, ravitaillement stoppe.")
            vehicleFueling = false
            break
        end

        fuel = fuel + classMultiplier * 50
        if fuel < 100 then
            cost = cost + newCost
        end

        if fuel >= 100 then
            fuel = 100.0
            SetFuel(vehicleFueling, fuel)
            vehicleFueling = false
            SetFuel(vehicleFueling, fuel)
            break
        end

        SetFuel(vehicleFueling, fuel)

        Wait(600)
    end

    if cost > 0 then
        TriggerServerEvent("fuel:pay", math.floor(cost))
        cost = 0
    end
end

CreateThread(function()
    while true do
        Wait(2000)
        if vehicleFueling then
            vehicleIsFueling()
        end
    end
end)

CreateThread(function()
    local wait = 500
    while true do
        Wait(wait)
        if pump then
            wait = 0
            if not holdingNozzle and not nozzleInVehicle and not nozzleDropped then
                DrawText3D(pump.x, pump.y, pump.z + 1.2, "Récupérer le pistolet à essence [E]")
                if IsControlJustPressed(0, 51) then
                    grabNozzleFromPump()
                    Wait(1000)
                    ClearPedTasks(ped)
                end
            elseif holdingNozzle and not nearTank and pumpHandle == usedPump then
                DrawText3D(pump.x, pump.y, pump.z + 1.2, "Déposer le pistolet à essence [E]")
                if IsControlJustPressed(0, 51) then
                    LoadAnimDict("anim@am_hold_up@male")
                    TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                    Wait(300)
                    returnNozzleToPump()
                    Wait(1000)
                    ClearPedTasks(ped)
                end
            end
        else
            wait = 500
        end
    end
end)

CreateThread(function()
    local wait = 500
    while true do
        Wait(wait)
        if holdingNozzle or nozzleInVehicle or nozzleDropped then
            wait = 0

            if pump then
                pumpCoords = GetEntityCoords(usedPump)
            end
            if nozzle and pumpCoords then
                nozzleLocation = GetEntityCoords(nozzle)
                if #(nozzleLocation - pumpCoords) > 6.0 then
                    dropNozzle()
                elseif #(pumpCoords - pedCoords) > 100.0 then
                    returnNozzleToPump()
                end
                if nozzleDropped and #(nozzleLocation - pedCoords) < 1.5 then
                    DrawText3D(nozzleLocation.x, nozzleLocation.y, nozzleLocation.z, "Récupérer le pistolet à essence [E]")
                    if IsControlJustPressed(0, 51) then
                        LoadAnimDict("anim@mp_snowball")
                        TaskPlayAnim(ped, "anim@mp_snowball", "pickup_snowball", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                        Wait(700)
                        grabExistingNozzle()
                        ClearPedTasks(ped)
                    end
                end
            end

            local veh = vehicleInFront()

            if holdingNozzle and nozzle then
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 24, true)
                if IsDisabledControlPressed(0, 24) then
                    if veh and tankPosition and #(pedCoords - tankPosition) < 1.2 then
                        if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                            LoadAnimDict("timetable@gardener@filling_can")
                            TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                        end
                        wastingFuel = false
                        vehicleFueling = veh
                    else
                        if IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                            vehicleFueling = false
                            ClearPedTasks(ped)
                        end
                        if nozzleLocation then
                            wastingFuel = true
                            PlayEffect("core", "veh_trailer_petrol_spray")
                        end
                    end
                else
                    if IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                        vehicleFueling = false
                        ClearPedTasks(ped)
                    end
                    wastingFuel = false
                end
            end

            if veh then
                local vehClass = GetVehicleClass(veh)
                local zPos = nozzleBasedOnClass[vehClass + 1]
                local isBike = false
                local nozzleModifiedPosition = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.0
                }
                local textModifiedPosition = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.0
                }

                if vehClass == 8 and vehClass ~= 13 and not FuelConfig.electricVehicles[GetHashKey(veh)] then
                    tankBone = GetEntityBoneIndexByName(veh, "petrolcap")
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "petroltank")
                    end
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "engine")
                    end
                    isBike = true
                elseif vehClass ~= 13 and not FuelConfig.electricVehicles[GetHashKey(veh)] then
                    tankBone = GetEntityBoneIndexByName(veh, "petrolcap")
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "petroltank_l")
                    end
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "hub_lr")
                    end
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "handle_dside_r")
                        nozzleModifiedPosition.x = 0.1
                        nozzleModifiedPosition.y = -0.5
                        nozzleModifiedPosition.z = -0.6
                        textModifiedPosition.x = 0.55
                        textModifiedPosition.y = 0.1
                        textModifiedPosition.z = -0.2
                    end
                end
                tankPosition = GetWorldPositionOfEntityBone(veh, tankBone)
                if tankPosition and #(pedCoords - tankPosition) < 1.2 then
                    if not nozzleInVehicle and holdingNozzle then
                        nearTank = true
                        DrawText3D(tankPosition.x + textModifiedPosition.x, tankPosition.y + textModifiedPosition.y, tankPosition.z + zPos + textModifiedPosition.z, "Attacher le pistolet à essence [E]")
                        if IsControlJustPressed(0, 51) then
                            LoadAnimDict("timetable@gardener@filling_can")
                            TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                            Wait(300)
                            putNozzleInVehicle(veh, tankBone, isBike, true, nozzleModifiedPosition)
                            Wait(300)
                            ClearPedTasks(ped)
                        end
                    elseif nozzleInVehicle then
                        DrawText3D(tankPosition.x + textModifiedPosition.x, tankPosition.y + textModifiedPosition.y, tankPosition.z + zPos + textModifiedPosition.z, "Récupérer le pistolet à essence [E]")
                        if IsControlJustPressed(0, 51) then
                            LoadAnimDict("timetable@gardener@filling_can")
                            TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                            Wait(300)
                            grabExistingNozzle()
                            Wait(300)
                            ClearPedTasks(ped)
                        end
                    end
                end
            else
                nearTank = false
            end
        else
            wait = 500
        end
    end
end)

CreateThread(function()
    local wait = 500
    while true do
        Wait(wait)
        if GetSelectedPedWeapon(ped) == 883325847 and not holdingNozzle and not nozzleInVehicle then
            wait = 0
            local veh = vehicleInFront()
            if veh then
                local vehClass = GetVehicleClass(veh)
                local zPos = nozzleBasedOnClass[vehClass + 1]
                local can = GetAmmoInPedWeapon(ped, 883325847)
                local distance = 1.2

                if vehClass == 8 and vehClass ~= 13 and not FuelConfig.electricVehicles[GetHashKey(veh)] then
                    tankBone = GetEntityBoneIndexByName(veh, "petroltank")
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "engine")
                    end
                elseif vehClass == 14 and not FuelConfig.electricVehicles[GetHashKey(veh)] then
                    tankBone = GetEntityBoneIndexByName(veh, "engine")
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "bodyshell")
                    else
                        distance = 2.0
                    end
                elseif vehClass ~= 13 and not FuelConfig.electricVehicles[GetHashKey(veh)] then
                    tankBone = GetEntityBoneIndexByName(veh, "petroltank_l")
                    if tankBone == -1 then
                        tankBone = GetEntityBoneIndexByName(veh, "hub_lr")
                    end
                end
                tankPosition = GetWorldPositionOfEntityBone(veh, tankBone)
                if tankPosition and #(pedCoords - tankPosition) < distance then
                    local fuel = GetFuel(veh)
                    DrawText3D(tankPosition.x, tankPosition.y, tankPosition.z + zPos, math.floor(fuel) .. "% refuel [E]")
                    local ammo = GetAmmoInPedWeapon(ped, 883325847)
                    if IsControlPressed(0, 51) and ammo > 0 then
                        if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                            LoadAnimDict("timetable@gardener@filling_can")
                            TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
                        elseif can and DoesEntityExist(veh) then
                            SetPedAmmo(ped, 883325847, ammo - 3)
                            vehicleFueling = veh
                            usingCan = true
                        end
                    else
                        vehicleFueling = false
                        usingCan = false
                        if IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                            ClearPedTasks(ped)
                        end
                    end
                end
            end
        else
            wait = 500
        end
    end
end)

CreateThread(function()
    while true do
        Wait(3500)
        local pedVeh = GetVehiclePedIsIn(ped)
        local seat = GetPedInVehicleSeat(pedVeh, -1)
        if pedVeh ~= 0 and seat ~= 0 then
            local vehClass = GetVehicleClass(pedVeh)
            if not DecorExistOn(pedVeh, FUEL_DECOR) then
                -- Premier compteur d'un vehicule : aleatoire 20-80 % pour les
                -- vehicules terrestres. Bateaux (14), helicos (15) et avions
                -- (16) sortent TOUJOURS le plein, quel que soit le garage
                -- (societe LSFD/police/EMS, garages joueurs, locations) :
                -- avant, un bateau pouvait sortir a 20 % et tomber en panne
                -- au large quelques minutes plus tard.
                if vehClass == 14 or vehClass == 15 or vehClass == 16 then
                    SetFuel(pedVeh, 100.0)
                else
                    SetFuel(pedVeh, math.random(200, 800) / 10)
                end
            end
            local fuel = GetFuel(pedVeh)
            if GetIsVehicleEngineRunning(pedVeh) then
                if fuel < 5.0 then
                    DisableControlAction(0, 71)
                    SetVehicleEngineOn(pedVeh, false, true, true)
                end
                SetFuel(pedVeh, fuel - ((GetVehicleCurrentRpm(pedVeh) * FuelConfig.vehicleClasses[vehClass]) / 1.7))
            end
        end
    end
end)

local _pumpsSpawned = false
CreateThread(function()
    if _pumpsSpawned then return end
    _pumpsSpawned = true
    for _, pumps in pairs(FuelConfig.addPumps) do
        local obj = CreateObject(GetHashKey(pumps.hash), pumps.x, pumps.y, pumps.z - 1.0, false, false, true)
        SetEntityAsMissionEntity(obj, true, true)
        FreezeEntityPosition(obj, true)
    end
end)

CreateThread(function()
    DecorRegister(FUEL_DECOR, 1)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(45000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			local vehicleClass = GetVehicleClass(vehicle)

			if GetPedInVehicleSeat(vehicle, -1) == ped and IsValidVehicleClass(vehicleClass) then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end
		end
	end
end)

function IsValidVehicleClass(vehicleClass)
	local validClasses = {
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20
	}
	for _, vClass in ipairs(validClasses) do
		if vehicleClass == vClass then
			return true
		end
	end
	return false
end

function ManageFuelUsage(vehicle)
	SetFuel(vehicle, GetFuel(vehicle))
	fuelSynced = true

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - 1.0)
	end
end
