local peds = {}
local robbed = {}
local current = 0
local inGame = false

RegisterNetEvent('g4_shoprobbery:updateData', function(data)
    robbed = data
end)

Citizen.CreateThread(function()
    AddTextEntry("begin_robbery", ConfigShopRobberies.Translations.pressToBegin)

    for i,v in ipairs(ConfigShopRobberies.Cashiers) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped)  do
            Wait(100)
        end

        local ped = CreatePed(1, v.ped, v.pos.x, v.pos.y, v.pos.z, v.pos.w, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedCanBeTargetted(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)

        table.insert(peds, ped)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local player = PlayerId()
        local playerPed = PlayerPedId()
        local closest, distance = getClosest(playerPed)

        if closest and peds[closest] and DoesEntityExist(peds[closest]) and distance then
            if robbed[closest] then
                RequestAnimDict('switch@trevor@floyd_crying')
                while not HasAnimDictLoaded('switch@trevor@floyd_crying') do
                    Wait(0)
                end
                if not IsEntityPlayingAnim(peds[closest], "switch@trevor@floyd_crying", "console_end_loop_floyd", 3) then
                    TaskPlayAnim(peds[closest], "switch@trevor@floyd_crying", "console_end_loop_floyd", 8.0, 8.0, -1, 49, 0, 0, 0, 0 )
                end
            elseif not robbed[closest] and IsEntityPlayingAnim(peds[closest], "switch@trevor@floyd_crying", "console_end_loop_floyd", 3) then
                ClearPedTasks(peds[closest])
            end

            if distance <= 3.0 then
                wait = 1
                if IsPedArmed(playerPed, 4) then
                    if not robbed[closest] then
                        inGame = true

                        if IsControlJustPressed(0, 18) then
                            TriggerServerEvent('g4_shoprobbery:begin', closest)
                            current = closest
                        end
                        inGame = false
                    else

                        if IsControlJustPressed(0, 18) then
                            ESX.ShowNotification("Cette supérette vient d'être braquée !")
                        end
                    end
                elseif IsEntityPlayingAnim(peds[closest], "missminuteman_1ig_2", "handsup_base", 3) then
                    ClearPedTasks(peds[closest])
                end
            end
        end

        Citizen.Wait(wait)
    end
end)

RegisterNetEvent('g4_shoprobbery:startRobbery', function(id)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

    if #(coords - vec3(755.57, 4899.1, 0)) <= 3000 then
        TriggerServerEvent("sJobs.alerteCitoyens", coords, "Un commerce est en train de se faire braquer vers " ..streetname.. " !", "sheriff")
    else
        TriggerServerEvent("sJobs.alerteCitoyens", coords, "Un commerce est en train de se faire braquer vers " ..streetname.. " !", "police")
    end

    local success = lib.progressCircle({
        duration = 10000,
        label = "⌛ Braquage en cours...",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        }
    })

    if not success then
        ESX.ShowNotification("Braquage annulé.")
        return
    end

    TriggerServerEvent('g4_shoprobbery:gameEnded', id)
end)

RegisterNetEvent('g4_shoprobbery:notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('g4_shoprobbery:policeBlip', function(id)
    if ConfigShopRobberies.Cashiers[id] then
        local blip = AddBlipForCoord(ConfigShopRobberies.Cashiers[id].pos.x, ConfigShopRobberies.Cashiers[id].pos.y, ConfigShopRobberies.Cashiers[id].pos.z)
        SetBlipSprite(blip, ConfigShopRobberies.PoliceBlip.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, ConfigShopRobberies.PoliceBlip.scale)
        SetBlipColour(blip, ConfigShopRobberies.PoliceBlip.color)
        SetBlipAsShortRange(blip, true)
        local _key = "BN_SUNLIFE_SHOPROBBERY_1_" .. tostring(blip)
        AddTextEntry(_key, ConfigShopRobberies.PoliceBlip.name)
        BeginTextCommandSetBlipName(_key)
        EndTextCommandSetBlipName(blip)
        Wait(ConfigShopRobberies.PoliceBlip.activeTime * 1000)
        RemoveBlip(blip)
    end
end)

function getClosest(playerPed)
    local player_coords = GetEntityCoords(playerPed)
    local closest_distance = 15.0
    local closest = nil

    for i,v in ipairs(peds) do
        local ped_coords = GetEntityCoords(v)
        local distance = #(ped_coords-player_coords)

        if distance <= closest_distance then
            closest_distance = distance
            closest = i
        end
    end

    return closest, closest_distance
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for i,v in ipairs(peds) do
        DeletePed(v)
    end
end)
