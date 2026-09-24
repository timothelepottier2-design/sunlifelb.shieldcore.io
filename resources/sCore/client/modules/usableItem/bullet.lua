local objectName <const> = "prop_cs_heist_bag_02"
local applyArmor = false

local KVP_KEY = "armor_value"
local APPLY_DELAY = 750

local function clamp(v, a, b)
    v = tonumber(v) or 0
    if v < a then return a end
    if v > b then return b end
    return v
end

local function getArmor()
    return (GetPedArmour(PlayerPedId()) or 0)
end

local function setArmor(val)
    SetPedArmour(PlayerPedId(), clamp(math.floor(val or 0), 0, 100))
end

local pendingRestoreValue = nil
AddEventHandler('onClientResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    local stored = GetResourceKvpInt(KVP_KEY) or 0
    if stored and stored > 0 then
        pendingRestoreValue = clamp(stored, 0, 100)
        CreateThread(function()
            Wait(APPLY_DELAY)
            if pendingRestoreValue then
                setArmor(pendingRestoreValue)
            end
        end)
    else
        pendingRestoreValue = nil
    end
end)

AddEventHandler('playerSpawned', function()
    if not pendingRestoreValue then return end
    CreateThread(function()
        Wait(APPLY_DELAY)
        setArmor(pendingRestoreValue)
    end)
end)

AddEventHandler('onClientResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    local current = getArmor()
    SetResourceKvpInt(KVP_KEY, clamp(current, 0, 100))
end)

RegisterNetEvent("sCore.applyArmor", function(armorType)
    if not armorType then
        return
    end

    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.7, -1.0)
    local playerCoords = GetEntityCoords(ped)
    local time = armorType == "hard" and math.random(20000,25000) or math.random(10000,15000)

    if IsPedInAnyVehicle(ped, false) then
        ESX.ShowNotification("Vous avez déchiré votre gilet en essayant de l'utiliser dans un espace restreint. Il est inutilisable...")
        return
    end

    loadModel(objectName)

    print(('^2[NETDIAG][OBJET]^7 %s bullet.lua:70 CreateObject NETWORKED obj=%s'):format(GetCurrentResourceName(), tostring(objectName)))
    local object = CreateObject(GetHashKey(objectName), coords, true, false, false)
    FreezeEntityPosition(object, true)

    ExecuteCommand("e mechanic4")
    applyArmor = true

    local result = lib.progressCircle({
        duration = time,
        useWhileDead = false,
        canCancel = true,
        label = '⌛ Ajout du gilet...',
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    ClearPedTasks(ped)

    if not result then
        ESX.ShowNotification("Vous avez annulé la pose du gilet pare-balles.")
        applyArmor = false
        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
        return
    end

    if GetDistanceBetweenCoords(GetEntityCoords(ped), playerCoords, true) > 1.0 then
        ESX.ShowNotification("Vous n'avez pas pu mettre ce gilet pare-balles correctement car vous étiez en train de bouger.")
        applyArmor = false
        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
        return
    end

    SetPedArmour(ped, 100)
    ESX.ShowNotification("~g~Vous avez mis votre gilet !")

    PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
    applyArmor = false
end)

function UsingGilet()
    return applyArmor
end

exports("UsingGilet", UsingGilet)
