local dumpsters = {
    "prop_bin_01a", "prop_bin_02a", "prop_bin_03a", "prop_bin_04a", "prop_bin_05a",
    "prop_bin_06a", "prop_bin_07a", "prop_bin_08a", "prop_bin_09a", "prop_bin_10a",
    "prop_bin_11a", "prop_bin_12a", "prop_bin_13a", "prop_bin_14a", "prop_bin_14b",
    "prop_bin_beach_01a", "prop_bin_delpiero", "prop_bin_14c", "prop_bin_05b",
    "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b", "prop_dumpster_3a",
    "prop_dumpster_4a", "prop_dumpster_4b", "hei_prop_heist_binbag", "prop_rub_binbag_sd_01",
    "prop_rub_binbag_sd_02", "prop_rub_binbag_sd_03", "prop_rub_binbag_sd_04", "prop_rub_binbag_sd_05",
    "prop_rub_binbag_sd_06", "prop_rub_binbag_sd_07", "prop_rub_binbag_sd_08", "prop_rub_binbag_sd_09",
    "prop_rub_binbag_sd_10", "prop_rub_binbag_sd_11", "prop_rub_binbag_sd_12", "prop_rub_binbag_05"
}
DontMindDumpster = {}

local searchedDumpsters = {}
local searchedEntities = {}
local dumpstersHashes = {}
for i = 1, #dumpsters do
    dumpstersHashes[i] = GetHashKey(dumpsters[i])
end

Citizen.CreateThread(function()
    DecorRegister("props", 3)

    local highlightedDumpster = nil
    while true do
        local sleep = 5000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        closestDumpster = nil
        for i = 1, #dumpstersHashes do
            local dumpster = GetClosestObjectOfType(coords, 1.0, dumpstersHashes[i], false, false, false)
            if dumpster ~= 0 and not DontMindDumpster[dumpster] then

                if not (DecorExistOn(dumpster, "props") and DecorGetInt(dumpster, "props") == 1) then
                    closestDumpster = dumpster
                    break
                end
            end
        end

        if closestDumpster ~= 0 and closestDumpster ~= nil then

            if DecorExistOn(closestDumpster, "props") and DecorGetInt(closestDumpster, "props") == 1 then

            else

                sleep = 0
                if closestDumpster ~= highlightedDumpster then
                    if highlightedDumpster then SetEntityDrawOutline(highlightedDumpster, false) end
                    SetEntityDrawOutline(closestDumpster, true)
                    SetEntityDrawOutlineColor(255, 106, 0, 185)
                    highlightedDumpster = closestDumpster
                    PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)
                end

                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour fouiller la poubelle")
                if IsControlJustReleased(0, 38) then
                    StartDumpsterSearch(GetEntityCoords(closestDumpster), closestDumpster)
                end
            end
        else
            if highlightedDumpster then
                SetEntityDrawOutline(highlightedDumpster, false)
                highlightedDumpster = nil
            end
        end

        Citizen.Wait(sleep)
    end
end)

function CanPlayerSearchDumpster(playerPed)

    if IsEntityDead(playerPed) then
        return false
    end

    if IsPedInAnyVehicle(playerPed, false) then
        return false
    end

    if IsPedFalling(playerPed) or IsPedRagdoll(playerPed) then
        return false
    end

    return true
end

function StartDumpsterSearch(dumpsterCoords, entity)
    local playerPed = PlayerPedId()

    if not CanPlayerSearchDumpster(playerPed) then
        zUtils.ShowNotification("~r~Vous ne pouvez pas fouiller la poubelle pour le moment")
        return
    end

    if searchedEntities[entity] then
        zUtils.ShowNotification("~r~Cette poubelle a déjà été fouillée récemment")
        return
    end

    searchedEntities[entity] = true

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(5000)
    ClearPedTasks(playerPed)

    TriggerServerEvent('dumpster:searchDumpster', {x = dumpsterCoords.x, y = dumpsterCoords.y, z = dumpsterCoords.z})
end

RegisterNetEvent('dumpster:markDumpster')
AddEventHandler('dumpster:markDumpster', function(dumpsterCoords)
    searchedDumpsters[dumpsterCoords] = true
    Citizen.CreateThread(function()
        Citizen.Wait(120 * 1000)
        searchedDumpsters[dumpsterCoords] = nil
    end)
end)
