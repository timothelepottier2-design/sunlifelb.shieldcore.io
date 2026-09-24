local RESIDUE_DURATION_MS <const> = 10 * 60 * 1000

local NO_RESIDUE_WEAPONS <const> = {
    [`WEAPON_STUNGUN`] = true,
    [`WEAPON_FLAREGUN`] = true,
    [`WEAPON_FIREEXTINGUISHER`] = true,
    [`WEAPON_PETROLCAN`] = true,
    [`WEAPON_HAZARDCAN`] = true,
    [`WEAPON_FERTILIZERCAN`] = true,
}

local residueUntil = 0
local cleaning = false
local testing = false

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()

        if IsPedArmed(ped, 6) then
            wait = 0
            if IsPedShooting(ped) and not NO_RESIDUE_WEAPONS[GetSelectedPedWeapon(ped)] then
                residueUntil = GetGameTimer() + RESIDUE_DURATION_MS
            end
        end

        Wait(wait)
    end
end)

local function HasResidue()
    return residueUntil > 0 and GetGameTimer() < residueUntil
end

RegisterNetEvent("sCore.powderTest.query", function(requestId)
    if type(requestId) ~= "number" then
        return
    end
    TriggerServerEvent("sCore.powderTest.answer", requestId, HasResidue())
end)

AddEventHandler("sCore.powderTest.start", function(targetId)
    targetId = tonumber(targetId)
    if not targetId or testing then
        return
    end
    testing = true

    local ped = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if targetPed and targetPed ~= 0 then
        local c = GetEntityCoords(targetPed)
        TaskTurnPedToFaceCoord(ped, c.x, c.y, c.z, 2000)
    end

    local ok = lib.progressCircle({
        duration = 5000,
        useWhileDead = false,
        canCancel = true,
        label = "🧤 Prélèvement sur les mains...",
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    ClearPedTasks(ped)
    testing = false

    if not ok then
        return
    end

    TriggerServerEvent("sCore.powderTest.request", targetId)
end)

RegisterNetEvent("sCore.powderTest.result", function(targetName, positive)
    targetName = tostring(targetName or "?")

    if positive == nil then
        ESX.ShowNotification("~o~Test de poudre : résultat indisponible pour ~s~" .. targetName .. "~o~.")
    elseif positive then
        ESX.ShowNotification("~r~Test de poudre POSITIF~s~ sur " .. targetName .. "\nRésidus de tir datant de moins de 10 minutes.")
    else
        ESX.ShowNotification("~g~Test de poudre NÉGATIF~s~ sur " .. targetName .. "\nAucun résidu de tir détecté.")
    end
end)

RegisterNetEvent("sCore.powderTest.clean", function()
    if cleaning then
        ESX.ShowNotification("~r~Vous êtes déjà en train de vous désinfecter les mains.")
        return
    end
    cleaning = true

    local ok = lib.progressCircle({
        duration = 8000,
        useWhileDead = false,
        canCancel = true,
        label = "🧴 Désinfection des mains...",
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    ClearPedTasks(PlayerPedId())
    cleaning = false

    if not ok then
        return
    end

    TriggerServerEvent("sCore.powderTest.cleanDone")
end)

RegisterNetEvent("sCore.powderTest.cleanApply", function()
    residueUntil = 0
    ESX.ShowNotification("~g~Vos mains sont propres, plus aucun résidu de poudre.")
end)
