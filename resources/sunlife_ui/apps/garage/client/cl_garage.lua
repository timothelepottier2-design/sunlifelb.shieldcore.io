local lastcarout = {}
local pointDeSpawn = {}
local last_veh = nil
local maxVec = 80

MYFAV = {}

local _ownedPlatesSet = {}
local _ownedPlatesReady = false

local function _normPlateClient(p)
    if not p then return nil end
    return tostring(p):gsub("%s+", ""):upper()
end

RegisterNetEvent('garage:syncOwnedPlates', function(plates, ready)
    _ownedPlatesSet = {}
    if type(plates) == "table" then
        for i = 1, #plates do
            local pk = _normPlateClient(plates[i])
            if pk then _ownedPlatesSet[pk] = true end
        end
    end
    _ownedPlatesReady = ready and true or false
end)

CreateThread(function()
    while ESX == nil or not ESX.PlayerLoaded do Wait(500) end
    if not _ownedPlatesReady then
        TriggerServerEvent('garage:requestOwnedPlatesSync')
    end
end)

RegisterNetEvent('garage:deltaOwnedPlate', function(plate, owned)
    local pk = _normPlateClient(plate)
    if pk then _ownedPlatesSet[pk] = owned and true or nil end
end)

local function _isPlateOwnedFast(plate, cb)
    local pk = _normPlateClient(plate)
    if _ownedPlatesReady and pk and _ownedPlatesSet[pk] == true then
        cb(true)
        return
    end
    ESX.TriggerServerCallback('Core:requestPlayerCars', cb, plate)
end

function updateGaragePublicFavorites()
    local favPlatesJson = GetResourceKvpString("fav_plates")
    if favPlatesJson then
        MYFAV = json.decode(favPlatesJson)
    else
        MYFAV = {}
    end
end

function OpenGaragePublicMenu(spawner)
    maxVec = GetMaxGarageSlots and GetMaxGarageSlots() or 80

    if not IsPedInAnyVehicle(PlayerPedId(), 0) then
        last_veh = GetVehiclePedIsIn(PlayerPedId(), 1)
    else
        last_veh = GetVehiclePedIsIn(PlayerPedId(), 0)
    end

    pointDeSpawn = spawner

end

function tostring_majuscules(obj)
    local str = tostring(obj)
    return str:upper()
end

function suppGaragePublicauto()
    for k, v in pairs(lastcarout) do
        ESX.Game.DeleteVehicle(v)
        lastcarout[k] = nil
    end
end

function ActivateGaragePublicCam()
    Cam.create("previewgarage")
end

function DeactivateGaragePublicCam()
    CreateThread(function()
        Cam.render("previewgarage", false, true, 1000)
        Wait(1000)
        Cam.delete("previewgarage")
        ClearFocus()
    end)
    TriggerServerEvent('instancetucoco', 0)
end

function SetVehicleProperties(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)
end

local GARAGE_CENTER = vector3(227.574036, -794.700684, 30.639799)
local GARAGE_RADIUS = 500.0

function LookingForGaragePublicPlace(posList)
    for _, v in pairs(posList) do
        local distance = #(v.pos - GARAGE_CENTER)

        if distance <= GARAGE_RADIUS then
            if ESX.Game.IsSpawnPointClear(v.pos, 3.0) then
                return v.pos, v.heading
            else
                return false
            end
        end

        return v.pos, v.heading
    end
end

Round = function(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

Trim = function(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

Citizen.CreateThread(function()
    while true do
        collectgarbage()

        Wait(15 * 1000)
    end
end)

local rangerauto = {
    { x = -286.35809326172, y = -904.20959472656, z = 30.180598831177, },
    { x = -2182.37,         y = -369.59,          z = 12.08, },
    { x = -1200.69,         y = -370.89,          z = 36.29, },
    { x = -733.39,          y = -71.49,           z = 40.75, },
    { x = -1183.53,         y = -1496.05,         z = 3.38, },
    { x = 55.02,            y = 20.18,            z = 68.65, },
    { x = 266.71,           y = -332.32,          z = 43.92, },
    { x = 1029.29,          y = -763.81,          z = 56.99, },
    { x = 956.18,           y = -2105.75,         z = 29.61, },
    { x = -964.59,          y = -2697.69,         z = 12.83, },
    { x = -897.4,           y = -2035.69,         z = 8.3, },
    { x = -3141.67,         y = 1117.07,          z = 19.7, },
    { x = 264.15,           y = 2602.11,          z = 43.84, },
    { x = 2544.3,           y = 2612.16,          z = 36.94, },
    { x = 1523.92,          y = 3766.97,          z = 33.05, },
    { x = 2565.7,           y = 4685.87,          z = 33.06, },
    { x = -185.78034973145, y = 6219.4755859375,  z = 30.53, },
    { x = -2194.58,         y = 4267.58,          z = 47.54, },
    { x = 354.36,           y = -1681.01,         z = 31.54, },
    { x = 970.9,            y = -140.72,          z = 74.38, },
    { x = 918.09,           y = 50.38,            z = 79.9, },
    { x = 878.08,           y = 4.9,              z = 77.76, },
    { x = 214.21594238281,  y = -793.84655761719, z = 29.905844726562, },
    { x = 2845.1665039062,  y = 4745.1171875,     z = 47.581262207031 },
    { x = 625.69104003906,  y = 24.935739517212,  z = 86.992985534668 },
    { x = -520.79376220703, y = 7411.5766601562,  z = 11.965186691284 },
    { x = -736.01702880859, y = 7041.712890625,   z = 40.13356552124 },
    { x = -420.23013305664, y = 1202.2840576172,  z = 324.74181518555 },
    { x = -884.87353515625, y = -2051.7111816406, z = 8.3991409301758 },
    { x = 438.20449829102,  y = 221.65756225586,  z = 102.26544342041 },
    { x = 1854.9141845703,  y = 2575.0930175781,  z = 44.772664642334 },
    { x = -2286.0114746094, y = 4262.51171875,    z = 42.613984680176 },
    { x = -1141.0092773438, y = 2679.0107421875,  z = 17.193902587891 },
    { x = 4497.650390625,   y = -4462.1450195312, z = 3.3164063453674 },
    { x = 2579.5688476562,  y = 427.85565185547,  z = 107.55566558838 },
    { x = 988.70324707031,  y = -1402.9484863281, z = 30.458345031738 },
    { x = -588.9453125,     y = 191.33200073242,  z = 70.38678894043 },
    { x = -795.409, y = 302.752, z = 85.703, },
    { x = -1243.3056640625, y = -3345.0495605469, z = 14.045049285889 },
    { x = 4440.9047851562, y = -4491.5146484375, z = 3.3187128067017 },
    { x = -3440.0998535156, y = 949.33911132812, z = -1.44730844497681 },
    { x = -3146.751953125, y = 7237.6596679688, z = 43.05238494873 },
    { x = -1791.5915527344, y = 6428.345703125, z = 25.191875076294 },
    { x = -927.31561279297, y = 6523.115234375, z = 0.1223014354706 },
    { x = 2124.2780761719, y = 4802.7514648438, z = 40.194371795654 },
    { x = 1739.8273925781, y = 3289.8686523438, z = 40.222497558594 },
    { x = -731.399414, y = -1334.569702, z = 0.268017 },
    { x = -1602.447998, y = -886.188660, z = 8.694394 },
    { x = 4962.662598, y = -5116.919922, z = 2.109141 },
    { x = 7040.871094, y = -1627.519897, z = 129.957468 },
    { x = 7035.384766, y = 225.711044, z = 56.786600 },
    { x = -453.483398, y = 1145.392700, z = 326.786035 },
}

local scooterModels = {
    [GetHashKey("faggio")] = true,
}

function IsPlayerInScooter(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle and vehicle ~= 0 then
        local model = GetEntityModel(vehicle)
        return scooterModels[model] == true
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        local nearThing = false

        for k in pairs(rangerauto) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, rangerauto[k].x, rangerauto[k].y, rangerauto[k].z)
            local last_veh = GetVehiclePedIsIn(PlayerPedId(), 1)

            if dist <= 30.0 then
                DrawMarker(6, rangerauto[k].x, rangerauto[k].y, rangerauto[k].z, nil, nil, nil, -90, nil, nil, 2.9, 2.9,
                    2.9, 255, 117, 31, 225)
                nearThing = true
                if dist <= 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~o~[E]~w~ pour ranger un véhicule")
                    if IsControlJustPressed(1, 51) then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            local vehicleId = last_veh

                            local netId = NetworkGetNetworkIdFromEntity(vehicleId)
                            local plate = GetVehicleNumberPlateText(vehicleId)
                            local data = {
                                props = ESX.Game.GetVehicleProperties(vehicleId),
                            }

                            DeleteEntity(vehicleId)
                            TriggerServerEvent("zGarage:DeleteEntity", netId, plate, data)
                            ESX.ShowNotification("~g~Votre véhicule a été rangé au garage")
                        else
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
                        end
                    end
                end
            end
        end

        if nearThing then
            Wait(0)
        else
            Wait(1000)
        end
    end
end)

local lastLockRequest = 0
local LOCK_COOLDOWN_MS = 1000

local function OpenCloseVehicleEntreprise()
    local now = GetGameTimer()
    if now - lastLockRequest < LOCK_COOLDOWN_MS then return end
    lastLockRequest = now

    local coords = GetEntityCoords(PlayerPedId(), false)
    local VehUse = GetVehiclePedIsIn(PlayerPedId()) ~= 0 and GetVehiclePedIsIn(PlayerPedId()) or
        GetClosestVehicle(coords, 7.0, 0, 71)
    if VehUse ~= 0 then
        local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), GetEntityCoords(VehUse))
        if dist > 10 then
            ESX.ShowNotification('Vous êtes trop loin du véhicule')
        else
            _isPlateOwnedFast(GetVehicleNumberPlateText(VehUse), function(isOwnedVehicle)
                if isOwnedVehicle then
                    ExecuteCommand('e keyfob')
                    local locked = GetVehicleDoorLockStatus(VehUse)
                    if locked == 1 then
                        SetVehicleDoorsLocked(VehUse, 2)
                        ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
                        TriggerEvent("sound:play", "doorlock", 0.15)
                        ExecuteCommand('me ferme le véhicule')
                    elseif locked == 2 then
                        SetVehicleDoorsLocked(VehUse, 1)
                        ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
                        TriggerEvent("sound:play", "doorlock", 0.15)
                        ExecuteCommand('me ouvre le véhicule')
                    end
                    SetVehicleLights(VehUse, 2)
                    Wait(200)
                    SetVehicleLights(VehUse, 0)
                    StartVehicleHorn(VehUse, 100, 1, false)
                    Wait(200)
                    SetVehicleLights(VehUse, 2)
                    Wait(400)
                    SetVehicleLights(VehUse, 0)
                else
                    ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
                end
            end)
        end
    end
end

KeyboardInputGaragePublic = function(one, two, max)
    local i = nil

    exports.dialog:openDialog(one, function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)

    return i
end

RegisterCommand("vehicule_lock", function()
    OpenCloseVehicleEntreprise()
end, false)
RegisterKeyMapping("vehicule_lock", "Ouvrir/Fermer Véhicule", "keyboard", 'U')

RegisterCommand('OpenNui', function()
    PRIME.Nui.Visible(true)
end, false)

RegisterCommand('OpenGaragePublicMenu', function(source, args, rawCommand)
    PRIME.Nui.Garage(true)
end, false)
