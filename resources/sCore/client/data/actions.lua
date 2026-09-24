Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
end)

local vehicleState = {
    inVehicle = false,
    enteringVehicle = false,
    vehicle = false,
    seat = false
}
local inPauseMenu = false

local function getSeatPedIsIn()
    local ped = PlayerPedId()
    local veh = vehicleState.vehicle
    if not veh or veh == 0 then return -1 end

    local maxSeats = GetVehicleMaxNumberOfPassengers(veh)
    for i = -1, maxSeats - 1 do
        if GetPedInVehicleSeat(veh, i) == ped then
            return i
        end
    end
    return -1
end

local function setVehicleStatus()
    ESX.SetPlayerData("vehicle", vehicleState.vehicle)
    ESX.SetPlayerData("seat", vehicleState.seat)
end

local function resetVehicleData()
    vehicleState.enteringVehicle = false
    vehicleState.vehicle = false
    vehicleState.seat = false
    vehicleState.inVehicle = false

    setVehicleStatus()
end

local function getVehicleData()
    if not DoesEntityExist(vehicleState.vehicle) then
        return
    end

    local vehicleModel = GetEntityModel(vehicleState.vehicle)
    local displayName = GetDisplayNameFromVehicleModel(vehicleModel)
    local netId = NetworkGetEntityIsNetworked(vehicleState.vehicle) and VehToNet(vehicleState.vehicle) or vehicleState.vehicle
    local plate = GetVehicleNumberPlateText(vehicleState.vehicle)

    return displayName, netId, plate
end

local function exitVehicle()
    local ped = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(ped, false)

    if currentVehicle ~= vehicleState.vehicle or IsEntityDead(ped) then
        local displayName, netId, plate = getVehicleData()

        TriggerEvent("sCore.exitedVehicle", vehicleState.vehicle, plate, vehicleState.seat, displayName, netId)
        TriggerServerEvent("sCore.exitedVehicle", plate, vehicleState.seat, displayName, netId)

        resetVehicleData()
    end
end

local function warpEnter()
    vehicleState.enteringVehicle = true
    vehicleState.inVehicle = true
    vehicleState.seat = getSeatPedIsIn()

    local displayName, netId, plate = getVehicleData()

    setVehicleStatus()
    TriggerEvent("sCore.enteredVehicle", vehicleState.vehicle, plate, vehicleState.seat, displayName, netId)
    TriggerServerEvent("sCore.enteredVehicle", plate, vehicleState.seat, displayName, netId)
end

local function enterAborted()
    resetVehicleData()

end

local function enterVehicle()
    local ped = PlayerPedId()
    vehicleState.seat = GetSeatPedIsTryingToEnter(ped)
    vehicleState.enteringVehicle = true

    setVehicleStatus()
end

local function trackVehicle()
    local ped = PlayerPedId()

    if not vehicleState.inVehicle and not IsEntityDead(ped) then
        local tempVehicle = GetVehiclePedIsTryingToEnter(ped)

        if DoesEntityExist(tempVehicle) and not vehicleState.enteringVehicle then
            vehicleState.vehicle = tempVehicle
            enterVehicle()
        elseif not DoesEntityExist(vehicleState.vehicle) and not IsPedInAnyVehicle(ped, true) and vehicleState.enteringVehicle then
            enterAborted()
        elseif IsPedInAnyVehicle(ped, false) then
            vehicleState.vehicle = GetVehiclePedIsIn(ped, false)
            warpEnter()
        end
    elseif vehicleState.inVehicle then
        exitVehicle()
    end
end

local function trackPauseMenu()
    local isActive = IsPauseMenuActive()

    if isActive ~= inPauseMenu then
        inPauseMenu = isActive
        TriggerEvent("esx:pauseMenuActive", isActive)
    end
end

local function actionInit()
    Citizen.CreateThread(function()
        while true do
            trackVehicle()
            trackPauseMenu()
            Wait(500)
        end
    end)
end

local function dispatchService()
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
    SetAudioFlag('PoliceScannerDisabled', true)
end

local function wantedLevel()
    local ped = PlayerId()

    ClearPlayerWantedLevel(ped)
    SetPoliceIgnorePlayer(ped, true)
    SetDispatchCopsForPlayer(ped, false)
    SetMaxWantedLevel(0)
end

local function enablePvP()
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end

local function disableNPCDrops()
    local weaponPickups <const> = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
    for i = 1, #weaponPickups do
        ToggleUsePickupsForPlayer(PlayerId(), weaponPickups[i], false)
    end
end

local function disableAimAssist()
    SetPlayerTargetingMode(3)
end

local function echapMenu()
	Citizen.CreateThread(function()
        AddTextEntry('PM_SCR_MAP', "Carte")
        AddTextEntry('PM_SCR_GAM', "Jeu")
		AddTextEntry("PM_PANE_LEAVE", "Quitter ~o~SunLife RP")
		AddTextEntry("PM_PANE_QUIT", "Quitter FiveM")
        AddTextEntry('PM_SCR_INF', "Infos")
        AddTextEntry('PM_SCR_STA', "Statistiques")
        AddTextEntry('PM_SCR_SET', "Parametres")
        AddTextEntry('PM_PANE_CFX', "SunLife RP")
        AddTextEntry('PM_SCR_GAL', "Galerie")
		Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~o~SunLife RP~s~ | Pseudo : " ..GetPlayerName(PlayerId()).." | ~o~ID: "..GetPlayerServerId(PlayerId()).."")
	end)
end

actionInit()
dispatchService()
wantedLevel()
enablePvP()
disableNPCDrops()
disableAimAssist()
echapMenu()
