JK = {}
JK.volume = 0.05
JK.sound = exports.xsound

local function requestNoclipGrace(ms)
    if GetResourceState('antisbire') ~= 'started' then return end
    pcall(function() exports['antisbire']:noclipGrace(ms or 5000) end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        PROPERTY["createdPropsByIndex"] = {}
        for _, v in pairs(PROPERTY["createdProps"]) do
            if v.entity then
                DeleteEntity(v.entity)
            end
        end
        ClearSpawnedProps()
    end
end)

RegisterNetEvent("property:ownerMinimizedData")
AddEventHandler("property:ownerMinimizedData", function(data)
    PROPERTY["owned"] = true
    PROPERTY["garageData"] = data.garage
    PROPERTY["expireDate"] = data.expireDate
    PROPERTY["waitingRequestData"] = false

    if data.timeWarning then
        PROPERTY["timeWarning"] = data.timeWarning
    else
        PROPERTY["timeWarning"] = nil
    end
end)

RegisterNetEvent("property:ringerMinimizedData")
AddEventHandler("property:ringerMinimizedData", function(data)
    PROPERTY["garageData"] = data.garage
    PROPERTY["expireDate"] = data.expireDate
end)

RegisterNetEvent("property:visitorMinimizedData")
AddEventHandler("property:visitorMinimizedData", function(data)
    PROPERTY["garageData"] = data.garage
    PROPERTY["expireDate"] = data.expireDate
end)

RegisterNetEvent("property:coOwnerMinimizedData")
AddEventHandler("property:coOwnerMinimizedData", function(data)
    PROPERTY["coOwned"] = true
    PROPERTY["garageData"] = data.garage
    PROPERTY["expireDate"] = data.expireDate
    PROPERTY["waitingRequestData"] = false
end)

RegisterNetEvent("property:jobNotOwned")
AddEventHandler("property:jobNotOwned", function(isImmo, ownerExist)
    PROPERTY["owned"] = false
    PROPERTY["seller"] = true
    PROPERTY["ownerExist"] = ownerExist
    PROPERTY["waitingRequestData"] = false
end)

RegisterNetEvent("property:notOwned")
AddEventHandler("property:notOwned", function(isImmo, ownerExist)
    PROPERTY["owned"] = false
    PROPERTY["seller"] = false
    PROPERTY["ownerExist"] = ownerExist
    PROPERTY["waitingRequestData"] = false
end)

RegisterNetEvent("property:sendOwnerLicense")
AddEventHandler("property:sendOwnerLicense", function(ownerLicense)
    PROPERTY["ownerLicense"] = ownerLicense
end)

RegisterNetEvent("property:whileInterior")
AddEventHandler("property:whileInterior", function(data)
    requestNoclipGrace()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    if data.isVip then
        PROPERTY["isVipInterior"] = true
    end

    PROPERTY["currentCOName"] = nil
    PROPERTY["permissionsList"] = {
        {
            name = "Accès au coffre",
            type = "chestAccess",
            toggle = false,
        },
        {
            name = "Accès à la garde-robe",
            type = "wearAccess",
            toggle = false,
        },
        {
            name = "Accès au /deco",
            type = "editMode",
            toggle = false,
        },
    }

    for k,v in pairs(PROPERTY["blips"]) do
        RemoveBlip(v)
    end

    PROPERTY["inProperty"] = true
    PROPERTY["propertyId"] = data.interiorId
    PROPERTY["hideList"] = {}

    Citizen.CreateThread(function()
        while PROPERTY["inProperty"] do
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
            Citizen.Wait(500)
        end
    end)

    if data.interiorProps then
        Citizen.CreateThread(function()
            local count = 0

            Citizen.Wait(2.5 * 1000)

            for k,v in pairs(data.interiorProps) do
                count = count + 1

                if IsModelValid(v.model) then
                    local hash = GetHashKey(v.model)
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(100)
                    end

                    SetModelAsNoLongerNeeded(hash)

                    v.entity = CreateObject(hash, 1.0, 1.0, 1.0, false, true, false)
                    SetEntityCoords(v.entity, vector3(v.coords.x, v.coords.y, v.coords.z))

                    if not v.rotation then v.rotation = vector3(0.0, 0.0, 0.0) end
                    SetEntityRotation(v.entity, v.rotation.x, v.rotation.y, v.rotation.z)

                    if v.fixGround then
                        PlaceObjectOnGroundProperly(v.entity)
                    end

                    SetEntityCollision(v.entity, false, false)

                    FreezeEntityPosition(v.entity, true)

                    PROPERTY["createdPropsByIndex"][v.id] = v.entity

                    print("created props", v.model, v.id)

                    table.insert(PROPERTY["createdProps"], {
                        entity = v.entity,
                        model = v.model,
                        id = v.id,
                    })
                else
                    print("model invalid", v.model)
                end

                Citizen.Wait(10)
            end

            for k,v in pairs(PROPERTY["createdProps"]) do
                SetEntityCollision(v.entity, true, false)
            end

            print("^2"..count.." entitys ^7loaded in property")
        end)
    end

    PROPERTY["taked"] = false
    if PROPERTY["interiors"][PROPERTY["propertyId"]].recolt then
        local lastCalled = 0
        Citizen.CreateThread(function()
            while PROPERTY["inProperty"] do
                local interval = 1000

                if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.coords, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                    interval = 0
                    DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.coords.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                end

                if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.coords, GetEntityCoords(PlayerPedId()), true) < PROPERTY["interiors"][PROPERTY["propertyId"]].recolt.radius then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter")

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 500
                        PROPERTY["taked"] = true

                        Citizen.CreateThread(function()
                            while PROPERTY["taked"] do
                                SetPedMoveRateOverride(PlayerPedId(), 1.10)
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
                            TriggerEvent("dpemotes:cancelEmote")
                            SetPedMoveRateOverride(PlayerPedId(), 1.0)
                        end)

                        ExecuteCommand("e box")
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end

        if PROPERTY["interiors"][PROPERTY["propertyId"]].traitment then
        local lastCalled = 0
        Citizen.CreateThread(function()
            while PROPERTY["inProperty"] do
                local interval = 1000

                if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.coords, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                    interval = 0
                    DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.coords.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                end

                if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.coords, GetEntityCoords(PlayerPedId()), true) < PROPERTY["interiors"][PROPERTY["propertyId"]].traitment.radius then
                    if PROPERTY["taked"] then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter")

                        if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                            lastCalled = GetGameTimer() + 10 * 1000
                            PROPERTY["taked"] = false

                            ESX.TriggerServerCallback("property:labo:getTraitmentTime", function(time)
                                if time then
                                    local ped = PlayerPedId()
                                    FreezeEntityPosition(ped, true)

                                    ExecuteCommand("e stop")
                                    PROPERTY["taked"] = true
                                    ExecuteCommand("e seringue")

                                    local success = lib.progressCircle({
                                        duration = time,
                                        label = "💊 Traitement en cours...",
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = false,
                                        disable = {
                                            car = true,
                                            move = true,
                                            combat = true,
                                        }
                                    })

                                    ExecuteCommand("e stop")
                                    FreezeEntityPosition(ped, false)
                                    PROPERTY["taked"] = false

                                    if success then
                                        ESX.TriggerServerCallback("property:labo:traitmentFinished", function(yes)
                                            if yes then
                                                PlaySound(-1, "SELECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
                                            end
                                        end, {
                                            propertyId = PROPERTY["propertyIdr"],
                                        })
                                    end
                                end
                            end, {
                                propertyId = PROPERTY["propertyIdr"],
                            })
                        end
                    else
                        ESX.ShowHelpNotification("Allez à la première étape")
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.enabled then
            if PROPERTY["owned"] or PROPERTY["coOwned"] then
                Citizen.CreateThread(function()
                    local lastCalled = 0
                    while PROPERTY["inProperty"] do
                        local interval = 500

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                            interval = 0
                            DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords.z + 0.20, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords, GetEntityCoords(PlayerPedId()), true) < 1.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'ordinateur")

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                PROPERTY["openLaboComputer"]()
                            end
                        end

                        Citizen.Wait(interval)
                    end
                end)
            end
        end
    end

    local gotEmployee, employees = false, {}
    local gotImport = false
    local gotGlowUp, gEmployees = false, {}
    if data.interiorSettings.buyedItems then
        for k,v in pairs(data.interiorSettings.buyedItems) do
            if v.type == "employee" then
                for i,l in pairs(PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.items) do
                    if l.type == "employee" then
                        gotEmployee, employees = true, l.pedsList
                    end
                end
            end

            if v.type == "importexport" then
                gotImport = true
            end

            if v.type == "glowup" then
                for i,l in pairs(PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.items) do
                    if l.type == "glowup" then
                        gotGlowUp, gEmployees = true, l.pedsList
                    end
                end
            end
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].glowUpAction then
        PROPERTY["interiors"][PROPERTY["propertyId"]].glowUpAction(gotGlowUp)
    end

    if gotGlowUp then
        Citizen.CreateThread(function()
            local employeesLoaded = false
            local entitysCreated = {}
            while PROPERTY["inProperty"] do
                local interval = 1000

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords, true) < 100.0 then
                    if not employeesLoaded then
                        employeesLoaded = true

                        RequestModel(GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel))
                        while not HasModelLoaded(GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel)) do
                            Citizen.Wait(100)
                        end

                        for a,q in pairs(gEmployees) do
                            q.entity = CreatePed(4, GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel), q.coords, q.heading, false, false)

                            table.insert(entitysCreated, q.entity)

                            FreezeEntityPosition(q.entity, true)
                            TaskSetBlockingOfNonTemporaryEvents(q.entity, true)
                            SetEntityInvincible(q.entity, true)
                            TaskStartScenarioInPlace(q.entity, "PROP_HUMAN_PARKING_METER", 0, 0)
                        end
                    end
                else
                    if employeesLoaded then
                        employeesLoaded = false

                        for k,v in pairs(entitysCreated) do
                            DeleteEntity(v)
                        end
                    end
                end

                Citizen.Wait(interval)
            end
            for k,v in pairs(entitysCreated) do
                DeleteEntity(v)
            end
        end)
    end

    if gotEmployee then
        Citizen.CreateThread(function()
            local employeesLoaded = false
            local entitysCreated = {}
            while PROPERTY["inProperty"] do
                local interval = 1000

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].computerShop.coords, true) < 100.0 then
                    if not employeesLoaded then
                        employeesLoaded = true

                        RequestModel(GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel))
                        while not HasModelLoaded(GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel)) do
                            Citizen.Wait(100)
                        end

                        for a,q in pairs(employees) do
                            q.entity = CreatePed(4, GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].pedModel), q.coords, q.heading, false, false)

                            table.insert(entitysCreated, q.entity)

                            FreezeEntityPosition(q.entity, true)
                            TaskSetBlockingOfNonTemporaryEvents(q.entity, true)
                            SetEntityInvincible(q.entity, true)
                            TaskStartScenarioInPlace(q.entity, "PROP_HUMAN_PARKING_METER", 0, 0)
                        end
                    end
                else
                    if employeesLoaded then
                        employeesLoaded = false

                        for k,v in pairs(entitysCreated) do
                            DeleteEntity(v)
                        end
                    end
                end

                Citizen.Wait(interval)
            end
            for k,v in pairs(entitysCreated) do
                DeleteEntity(v)
            end
        end)
    end

    if gotImport then
        Citizen.CreateThread(function()
            while PROPERTY["inProperty"] do
                local interval = 1000

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.coords, true) < 100.0 then
                    if not PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.loaded then
                        PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.loaded = true

                        local model = GetHashKey("mp_m_avongoon")
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Citizen.Wait(100)
                        end

                        PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped = CreatePed(1, model, PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.coords, PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.heading, false, false)
                        FreezeEntityPosition(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped, true)
                        TaskSetBlockingOfNonTemporaryEvents(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped, true)
                        SetEntityInvincible(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped, true)
                    end
                else
                    if PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.loaded then
                        PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.loaded = false

                        DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped)
                    end
                end

                Citizen.Wait(interval)
            end
        end)

        Citizen.CreateThread(function()
            local lastCalled = 0
            while PROPERTY["inProperty"] do
                local interval = 500

                if PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.loaded then
                    interval = 0

                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.coords, true) < 5.0 then
                        local x, y, z = table.unpack(GetPedBoneCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped, 12844, 0, 0, 0))
                        ESX.Game.Utils.DrawText3D(vector3(x, y, z + 0.40), "Import/export", 1.0)
                    end

                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.coords, true) < 2.5 then
                        if not PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.called then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.called = true
                            PlayPedAmbientSpeechNative(PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.ped, "GENERIC_HI", "SPEECH_PARAMS_STANDARD")
                        end

                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu Import/Export")

                        if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                            lastCalled = GetGameTimer() + 500
                            PROPERTY["openImportExport"]()
                        end
                    else
                        PROPERTY["interiors"][PROPERTY["propertyId"]].importexport.called = false
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.enabled then
            Citizen.CreateThread(function()
                while PROPERTY["inProperty"] do
                    local interval = 1000

                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, true) < 100.0 then
                        if not PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded = true

                            local model = GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.hash)
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Citizen.Wait(100)
                            end

                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped = CreatePed(1, model, PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.heading, false, false)
                            FreezeEntityPosition(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                            TaskSetBlockingOfNonTemporaryEvents(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                            SetEntityInvincible(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                        end
                    else
                        if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded = false

                            DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped)
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)

            Citizen.CreateThread(function()
                local lastCalled = 0
                while PROPERTY["inProperty"] do
                    local interval = 500

                    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                        interval = 0

                        local x, y, z = table.unpack(GetPedBoneCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, 12844, 0, 0, 0))
                        ESX.Game.Utils.DrawText3D(vector3(x, y, z + 0.50), "Secrétaire", 1.0, 4)

                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, true) < 2.5 then
                            if not PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called then
                                PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called = true
                                PlayPedAmbientSpeechNative(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, "GENERIC_HI", "SPEECH_PARAMS_STANDARD")
                            end

                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec la secrétaire", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.action()
                            end
                        else
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called = false
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].barman then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].barman.enabled then
            AddTextEntry('BLIPS_GEN_PROPERTY_BARMAN', 'Propriété - Barman')

            local barmanBlip = AddBlipForCoord(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.pos)
            SetBlipSprite(barmanBlip, 93)
            SetBlipDisplay(barmanBlip, 4)
            SetBlipColour(barmanBlip, 2)
            SetBlipScale(barmanBlip, 0.8)
            SetBlipAsShortRange(barmanBlip, true)
            SetBlipCategory(barmanBlip, PROPERTY_BLIP_CATEGORY)

            BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_BARMAN')
            EndTextCommandSetBlipName(barmanBlip)

            table.insert(PROPERTY["blips"], barmanBlip)

            Citizen.CreateThread(function()
                while PROPERTY["inProperty"] do
                    local interval = 1000

                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.pos, true) < 100.0 then
                        if not PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.loaded = true

                            local model = GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.hash)
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Citizen.Wait(100)
                            end

                            PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped = CreatePed(1, model, PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.pos, PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.heading, false, false)
                            FreezeEntityPosition(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped, true)
                            TaskSetBlockingOfNonTemporaryEvents(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped, true)
                            SetEntityInvincible(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped, true)
                        end
                    else
                        if PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.loaded = false

                            DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped)
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)

            Citizen.CreateThread(function()
                local lastCalled = 0
                while PROPERTY["inProperty"] do
                    local interval = 500

                    if PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.loaded then
                        interval = 0

                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.pos, true) < 10.0 then
                            local x, y, z = table.unpack(GetPedBoneCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped, 12844, 0, 0, 0))
                            ESX.Game.Utils.DrawText3D(vector3(x, y, z + 0.50), "Barman", 1.0, 4)
                        end

                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.coords.pos, true) < 2.5 then
                            if not PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.called then
                                PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.called = true
                                PlayPedAmbientSpeechNative(PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.ped, "GENERIC_HI", "SPEECH_PARAMS_STANDARD")
                            end

                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le barman", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.action()
                            end
                        else
                            PROPERTY["interiors"][PROPERTY["propertyId"]].barman.model.called = false
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].boombox then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.enabled then
            RegisterNetEvent("property:soundStatus")
            AddEventHandler("property:soundStatus", function(type, musicId, data)
                if type == "play" then
                    JK.sound:PlayUrlPos(musicId, data.link, data.volume, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, false)
                    JK.sound:Distance(musicId, 30)

                    JK.isPlaying = true
                    JK.isResume = true
                end

                if type == "stop" then
                    PROPERTY["musicTitle"] = nil

                    JK.sound:Destroy(musicId)

                    JK.isPlaying = false
                    JK.isResume = false
                end

                if type == "resume" then
                    if JK.sound:isPaused(musicId) then
                        JK.sound:Resume(musicId)
                    end

                    JK.isPlaying = true
                    JK.isResume = true
                end

                if type == "pause" then
                    if not JK.sound:isPaused(musicId) then
                        JK.sound:Pause(musicId)
                    end

                    JK.isPlaying = true
                    JK.isResume = false
                end

                if type == "sync" then
                    if JK.sound:soundExists(musicId) then
                        JK.sound:setTimeStamp(musicId, data.time)
                    else
                        JK.sound:PlayUrlPos(musicId, data.link, data.volume, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, false)
                        JK.sound:Distance(musicId, 30)

                        JK.sound:setTimeStamp(musicId, data.time)

                        JK.isPlaying = true
                        JK.isResume = true
                    end
                end

                if type == "volume" then
                    JK.sound:setVolume(musicId, data.volume)
                end
            end)

            if PROPERTY["owned"] or PROPERTY["coOwned"] then
                Citizen.CreateThread(function()
                    local lastCalled = 0
                    while PROPERTY["inProperty"] do
                        local interval = 500

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                            interval = 0
                            DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.z + 0.25, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 1.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec l'enceinte", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                PROPERTY["openBoombox"]()
                            end
                        end

                        Citizen.Wait(interval)
                    end
                end)
            end

            Citizen.CreateThread(function()
                while PROPERTY["inProperty"] do
                    local interval = 500

                    if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                        interval = 0
                        if PROPERTY["musicTitle"] then
                            ESX.Game.Utils.DrawText3D(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.z + 0.15), "🎶 "..PROPERTY["musicTitle"], 0.50, 4)
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].telescope then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.enabled then
            if PROPERTY["owned"] or PROPERTY["coOwned"] then
                Citizen.CreateThread(function()
                    local lastCalled = 0
                    while PROPERTY["inProperty"] do
                        local interval = 500

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                            interval = 0
                            DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.z + 1.10, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords, GetEntityCoords(PlayerPedId()), true) < 1.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le télecsope", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                lastCalled = GetGameTimer() + 500
                                ExecuteCommand("telescope")
                            end
                        end

                        Citizen.Wait(interval)
                    end
                end)
            end
        end
    end

    PROPERTY["propertyIdr"] = data.propertyId
    PROPERTY["interiorSettings"] = data.interiorSettings
    PROPERTY["garageSettings"] = data.garageSettings

    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary then
        if DoesEntityExist(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped) then
            DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped)
        end
    end

    if PROPERTY["garageSettings"] then
        if PROPERTY["garageSettings"].helipad then
            table.insert(PROPERTY["permissionsList"], {
                name = "Accès à l'helipad",
                type = "helipadAccess",
                toggle = false,
            })
        end
    end

    if PROPERTY["interiorSettings"] then
        if PROPERTY["interiorSettings"].wallText then
            if PROPERTY["interiorSettings"].wallText.enabled then
                local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                FinanceOrganization.Office.Enable(true)
                FinanceOrganization.Name.Set(PROPERTY["interiorSettings"].wallText.text, 1, PROPERTY["interiorSettings"].wallText.color, PROPERTY["interiorSettings"].wallText.font)
            else
                FinanceOrganization.Office.Enable(false)
            end
        end

        if PROPERTY["interiorSettings"].rooftop then
            table.insert(PROPERTY["permissionsList"], {
                name = "Accès au rooftop",
                type = "rooftopAccess",
                toggle = false,
            })
        end
    end

    if data.ringed then
        PROPERTY["ringed"] = true
    end

    AddTextEntry('BLIPS_GEN_PROPERTY_EXIT', 'Propriété - Sortie')
    AddTextEntry('BLIPS_GEN_PROPERTY_CHEST', 'Propriété - Coffre')

    local exitBlip = AddBlipForCoord(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z))
    SetBlipSprite(exitBlip, 143)
    SetBlipDisplay(exitBlip, 4)
    SetBlipColour(exitBlip, 2)
    SetBlipScale(exitBlip, 0.8)
    SetBlipAsShortRange(exitBlip, true)
    SetBlipCategory(exitBlip, PROPERTY_BLIP_CATEGORY)

    BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_EXIT')
    EndTextCommandSetBlipName(exitBlip)

    local chestBlip = AddBlipForCoord(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z))
    SetBlipSprite(chestBlip, 478)
    SetBlipDisplay(chestBlip, 4)
    SetBlipColour(chestBlip, 2)
    SetBlipScale(chestBlip, 0.8)
    SetBlipAsShortRange(chestBlip, true)
    SetBlipCategory(chestBlip, PROPERTY_BLIP_CATEGORY)

    BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_CHEST')
    EndTextCommandSetBlipName(chestBlip)

    table.insert(PROPERTY["blips"], exitBlip)
    table.insert(PROPERTY["blips"], chestBlip)

    if data.interiorSettings and PROPERTY["interiors"][PROPERTY["propertyId"]]["editables"] then
        for k,v in pairs(PROPERTY["interiors"][PROPERTY["propertyId"]]["editables"]) do
            if v.type == "interiorStyles" then
                if v.list[data.interiorSettings.interiorStyle] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.interiorStyle].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "strip" then
                if data.interiorSettings.strip then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "booze" then
                if data.interiorSettings.booze then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "chairs" then
                if data.interiorSettings.chairs then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "bunkerEquipment" then
                if data.interiorSettings.bunkerEquipment then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "casinoDecors" then
                if v.list[data.interiorSettings.casinoDecor] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.casinoDecor].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "casinoDecorsBar" then
                if v.list[data.interiorSettings.casinoDecorsBar] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.casinoDecorsBar].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end
        end
    end

    local a = 0
    for i=1, 100 do
        if a == 0 then
            SetEntityAlpha(PlayerPedId(), 100, false)
            a = 1
        elseif a == 1 then
            ResetEntityAlpha(PlayerPedId())
            a = 0
            Citizen.Wait(10)
        end
        Citizen.Wait(10)
    end

    if data.permissions then
        for k,v in pairs(data.permissions) do
            if v.name == "chestAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "wearAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "helipadAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "rooftopAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "editMode" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end
        end
    end

    while PROPERTY["inProperty"] do
        if #(GetEntityCoords(PlayerPedId()) - vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z)) > 250.0 then
            SetEntityCoords(PlayerPedId(), vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z))
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("property:endedInterior")
AddEventHandler("property:endedInterior", function()
    requestNoclipGrace()
    RageUI.CloseAll()
    PROPERTY["menuOpenned"] = false

    PROPERTY["inNoclip"] = false
    SetEntityVisible(PlayerPedId(), 1, 0)
    SetEntityInvincible(PlayerPedId(), 0)
    SetEntityCollision(PlayerPedId(), true, true)
    ClearPedTasksImmediately(PlayerPedId())

    for _, v in pairs(PROPERTY["createdProps"] or {}) do
        if v.entity and DoesEntityExist(v.entity) then
            DeleteEntity(v.entity)
        end
    end
    PROPERTY["createdProps"] = {}
    PROPERTY["createdPropsByIndex"] = {}

    for _, v in pairs(PROPERTY["blips"] or {}) do
        if v and v ~= 0 then RemoveBlip(v) end
    end
    PROPERTY["blips"] = {}

    for _, v in pairs(PROPERTY["spawnedVehicles"] or {}) do
        if DoesEntityExist(v) then DeleteEntity(v) end
    end
    PROPERTY["spawnedVehicles"] = {}

    local pid = PROPERTY["propertyId"]
    if pid and PROPERTY["interiors"][pid] then
        local i = PROPERTY["interiors"][pid]
        if i.secretary and i.secretary.model then
            if i.secretary.model.ped and DoesEntityExist(i.secretary.model.ped) then
                DeleteEntity(i.secretary.model.ped)
            end
            i.secretary.model.ped = nil
            i.secretary.model.loaded = nil
        end
        if i.importexport then
            if i.importexport.ped and DoesEntityExist(i.importexport.ped) then
                DeleteEntity(i.importexport.ped)
            end
            i.importexport.ped = nil
            i.importexport.loaded = nil
            i.importexport.called = nil
        end

        if i.wallText and i.wallText.enabled then

            local ok, FinanceOrganization = pcall(function()
                return exports.bob74_ipl:GetFinanceOrganizationObject()
            end)
            if ok and FinanceOrganization then
                FinanceOrganization.Name.Set("", 0, 0, 0)
            end
        end
    end

    PROPERTY["inProperty"] = false
    PROPERTY["inGarage"] = false
    PROPERTY["propertyId"] = nil
    PROPERTY["callExpire"] = 0
    PROPERTY["hideList"] = {}

    local a = 0
    for i=1, 100 do
        if a == 0 then
            SetEntityAlpha(PlayerPedId(), 100, false)
            a = 1
        elseif a == 1 then
            ResetEntityAlpha(PlayerPedId())
            a = 0
            Citizen.Wait(10)
        end
        Citizen.Wait(10)
    end
end)

RegisterNetEvent("property:whileGarage")
AddEventHandler("property:whileGarage", function(data)
    requestNoclipGrace()
    PROPERTY["_garageCfgWarned"] = nil
    print(("[GARAGE-DBG] whileGarage recu : garageInterior=%s (type %s) | propertyId=%s | configOK=%s | nbVehServeur=%s")
        :format(tostring(data and data.garageInterior), type(data and data.garageInterior),
                tostring(data and data.propertyId),
                tostring(data and data.garageInterior and PROPERTY["garages"] and PROPERTY["garages"][data.garageInterior] ~= nil),
                tostring(data and data.garage and #data.garage or "nil")))
    if PROPERTY["creatorData"]["vehiclesSpawned"] then
        for k,v in pairs(PROPERTY["creatorData"]["vehiclesSpawned"]) do
            DeleteEntity(v)
        end
    end

    PROPERTY["garageSettings"] = data.garageSettings

    Citizen.CreateThread(function()
        ClearAreaOfVehicles(PROPERTY["garages"][PROPERTY["garageInterior"]].places[1].pos, 100.0, false, false, false, false, false)

        for k,v in pairs(PROPERTY["blips"]) do
            RemoveBlip(v)
        end
        for k,v in pairs(PROPERTY["spawnedVehicles"]) do
            DeleteEntity(v)
        end

        local a = 0
        for i=1, 100 do
            if a == 0 then
                SetEntityAlpha(PlayerPedId(), 100, false)
                a = 1
            elseif a == 1 then
                ResetEntityAlpha(PlayerPedId())
                a = 0
                Citizen.Wait(10)
            end
            Citizen.Wait(10)
        end
    end)

    PROPERTY["inGarage"] = true
    PROPERTY["garageInterior"] = data.garageInterior
    PROPERTY["propertyId"] = data.propertyId

    AddTextEntry('BLIPS_GEN_PROPERTY_EXIT', 'Garage - Sortie')

    local exitBlip = AddBlipForCoord(vector3(PROPERTY["garages"][PROPERTY["garageInterior"]].entry.x, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.y, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.z))
    SetBlipSprite(exitBlip, 143)
    SetBlipDisplay(exitBlip, 4)
    SetBlipColour(exitBlip, 2)
    SetBlipScale(exitBlip, 0.8)
    SetBlipAsShortRange(exitBlip, true)
    SetBlipCategory(exitBlip, PROPERTY_BLIP_CATEGORY)

    BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_EXIT')
    EndTextCommandSetBlipName(exitBlip)

    table.insert(PROPERTY["blips"], exitBlip)

    PROPERTY["spawnedVehicles"] = {}

    local count, vehicles = 0, {}
    if PROPERTY["garageSettings"].placement then
        if not PROPERTY["askedGarage"] then
            PROPERTY["askedGarage"] = true
            TriggerServerEvent("garage:generate")
        end

        for k,v in pairs(PROPERTY["garages"][PROPERTY["garageInterior"]].places) do
            if count < #PROPERTY["garages"][PROPERTY["garageInterior"]].places then
                if PROPERTY["garageSettings"].placement[k].plate ~= "LIBRE" then
                    local vehicleInfo = {}
                    local loaded = false

                    ESX.TriggerServerCallback("garage:getInfos", function(d)
                        if d then
                            vehicleInfo = d
                            loaded = true
                        end
                    end, PROPERTY["garageSettings"].placement[k].plate)

                    local waited = 0
                    while not loaded and waited < 30 do
                        Citizen.Wait(100)
                        waited = waited + 1
                    end

                    if vehicleInfo and vehicleInfo.vehicle and IsModelValid(vehicleInfo.vehicle.model) then
                        if not IsThisModelAPlane(vehicleInfo.vehicle.model) and not IsThisModelAHeli(vehicleInfo.vehicle.model) then
                            RequestModel(vehicleInfo.vehicle.model)
                            while not HasModelLoaded(vehicleInfo.vehicle.model) do
                                Citizen.Wait(100)
                            end

                            local vehicle = CreateVehicle(vehicleInfo.vehicle.model, v.pos, v.heading, false, false)
                            ESX.Game.SetVehicleProperties(vehicle, vehicleInfo.vehicle)

                            if not PROPERTY["owned"] then
                                SetVehicleDoorsLocked(vehicle, 2)
                            end

                            table.insert(PROPERTY["spawnedVehicles"], vehicle)
                            count = count + 1
                        end
                    else
                        print("not valid !")
                    end
                else

                end
            end
        end
    else
        for k,v in pairs(data.garage) do
            table.insert(vehicles, v)
        end

        Citizen.CreateThread(function()
            for k,v in pairs(PROPERTY["garages"][PROPERTY["garageInterior"]].places) do
                if vehicles[k] and count < #PROPERTY["garages"][PROPERTY["garageInterior"]].places then
                    local hash = vehicles[k].model

                    if IsModelValid(hash) and hash ~= nil then
                        if not IsThisModelAPlane(hash) and not IsThisModelAHeli(hash) then
                            RequestModel(hash)
                            while not HasModelLoaded(hash) do
                                Citizen.Wait(100)
                            end

                            local vehicle = CreateVehicle(hash, v.pos, v.heading, false, false)
                            local vehicleProps = {}

                            ESX.TriggerServerCallback("garage:getInfos", function(vehicleInfos)
                                if vehicleInfos then
                                    ESX.Game.SetVehicleProperties(vehicle, vehicleInfos.vehicle)
                                end
                            end, vehicles[k].plate)

                            if not PROPERTY["owned"] then
                                SetVehicleDoorsLocked(vehicle, 2)
                            end

                            table.insert(PROPERTY["spawnedVehicles"], vehicle)
                            count = count + 1
                        end
                    end
                end
            end
        end)
    end

    if not data.coOwner and not data.ringer then
        Citizen.CreateThread(function()
            local asked, lastVehicleCoords = false, nil
            while PROPERTY["inGarage"] do
                local interval = 0

                for k,v in pairs(PROPERTY["spawnedVehicles"]) do
                    if IsPedInVehicle(PlayerPedId(), v, false) then

                        if IsControlPressed(0, 32) or IsControlPressed(0, 71) or IsControlPressed(0, 77) or IsControlPressed(0, 87) or IsControlPressed(0, 129) or IsControlPressed(0, 136) or IsControlPressed(0, 150) or IsControlPressed(0, 232) and not asked then
                            asked = true
                            DoScreenFadeOut(1000)
                            Citizen.Wait(2500)
                            TriggerServerEvent("property:exitWithVehicle", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)), PROPERTY["propertyId"])
                            PROPERTY["inGarage"] = false
                            asked, lastVehicleCoords = false, nil
                            Citizen.Wait(2500)
                            DoScreenFadeIn(1000)
                        end
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end

end)

RegisterNetEvent("property:refreshGarage")
AddEventHandler("property:refreshGarage", function(data)
    PROPERTY["garageSettings"] = data.garageSettings
    for k,v in pairs(PROPERTY["spawnedVehicles"]) do
        DeleteEntity(v)
    end

    PROPERTY["spawnedVehicles"] = {}

    local count, vehicles = 0, {}
    if PROPERTY["garageSettings"].placement then
        if not PROPERTY["askedGarage"] then
            PROPERTY["askedGarage"] = true
            TriggerServerEvent("garage:generate")
        end

        for k,v in pairs(PROPERTY["garages"][PROPERTY["garageInterior"]].places) do
            if count < #PROPERTY["garages"][PROPERTY["garageInterior"]].places then
                if PROPERTY["garageSettings"].placement[k].plate ~= "LIBRE" then
                    local vehicleInfo = {}
                    local loaded = false

                    ESX.TriggerServerCallback("garage:getInfos", function(d)
                        if d then
                            vehicleInfo = d
                            loaded = true
                        end
                    end, PROPERTY["garageSettings"].placement[k].plate)

                    local waited = 0
                    while not loaded and waited < 30 do
                        Citizen.Wait(100)
                        waited = waited + 1
                    end

                    if vehicleInfo and vehicleInfo.vehicle and IsModelValid(vehicleInfo.vehicle.model) then
                        if not IsThisModelAPlane(vehicleInfo.vehicle.model) and not IsThisModelAHeli(vehicleInfo.vehicle.model) then
                            RequestModel(vehicleInfo.vehicle.model)
                            while not HasModelLoaded(vehicleInfo.vehicle.model) do
                                Citizen.Wait(100)
                            end

                            local vehicle = CreateVehicle(vehicleInfo.vehicle.model, v.pos, v.heading, false, false)
                            ESX.Game.SetVehicleProperties(vehicle, vehicleInfo.vehicle)

                            if not PROPERTY["owned"] then
                                SetVehicleDoorsLocked(vehicle, 2)
                            end

                            table.insert(PROPERTY["spawnedVehicles"], vehicle)
                            count = count + 1
                        end
                    else
                        print("not valid !")
                    end
                else

                end
            end
        end
    else
        for k,v in pairs(data.garage) do
            table.insert(vehicles, v)
        end

        Citizen.CreateThread(function()
            for k,v in pairs(PROPERTY["garages"][PROPERTY["garageInterior"]].places) do
                if vehicles[k] and count < #PROPERTY["garages"][PROPERTY["garageInterior"]].places then
                    local hash = vehicles[k].model

                    if IsModelValid(hash) then
                        if not IsThisModelAPlane(hash) and not IsThisModelAHeli(hash) then
                            RequestModel(hash)
                            while not HasModelLoaded(hash) do
                                Citizen.Wait(100)
                            end

                            local vehicle = CreateVehicle(hash, v.pos, v.heading, false, false)
                            local vehicleProps = {}
                            ESX.TriggerServerCallback("garage:getInfos", function(vehicleInfos)
                                if vehicleInfos then
                                    ESX.Game.SetVehicleProperties(vehicle, vehicleInfos.vehicle)
                                end
                            end, vehicles[k].plate)

                            if not PROPERTY["owned"] then
                                SetVehicleDoorsLocked(vehicle, 2)
                            end

                            table.insert(PROPERTY["spawnedVehicles"], vehicle)
                            count = count + 1
                        end
                    end
                end
            end
        end)
    end

    if not data.coOwner and not data.ringer then
        Citizen.CreateThread(function()
            local asked, lastVehicleCoords = false, nil
            while PROPERTY["inGarage"] do
                local interval = 0

                for k,v in pairs(PROPERTY["spawnedVehicles"]) do
                    if IsPedInVehicle(PlayerPedId(), v, false) then
                        if IsControlPressed(0, 32) or IsControlPressed(0, 71) or IsControlPressed(0, 77) or IsControlPressed(0, 87) or IsControlPressed(0, 129) or IsControlPressed(0, 136) or IsControlPressed(0, 150) or IsControlPressed(0, 232) and not asked then
                            asked = true
                            DoScreenFadeOut(1000)
                            Citizen.Wait(2500)
                            TriggerServerEvent("property:exitWithVehicle", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)), PROPERTY["propertyId"])
                            PROPERTY["inGarage"] = false
                            asked, lastVehicleCoords = false, nil
                            Citizen.Wait(2500)
                            DoScreenFadeIn(1000)
                        end
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end

end)

RegisterNetEvent("property:ringed")
AddEventHandler("property:ringed", function()
    if not PROPERTY["returnProperty"] then
        PROPERTY["callExpire"] = GetGameTimer() + 30 * 1000

        while PROPERTY["callExpire"] > GetGameTimer() do

            if IsControlJustPressed(0, 38) then
                if not PROPERTY.isNearPoint() then
                    PROPERTY["callExpire"] = 0
                    TriggerServerEvent("property:acceptRing")
                end
            end

            Citizen.Wait(0)
        end
    else
        print("c ici")
    end
end)

RegisterNetEvent("property:newPlayerInProperty")
AddEventHandler("property:newPlayerInProperty", function(data)
    local alreadyAdded = false
    for k,v in pairs(PROPERTY["playersInProperty"]) do
        if v.serverId == data.serverId then
            alreadyAdded = true
        end
    end
    if alreadyAdded then return end

    table.insert(PROPERTY["playersInProperty"], data)
end)

RegisterNetEvent("property:deletePlayerFromProperty")
AddEventHandler("property:deletePlayerFromProperty", function(data)
    for k,v in pairs(PROPERTY["playersInProperty"]) do
        if v.serverId == data.serverId then
            PROPERTY["playersInProperty"][k] = nil
        end
    end
end)

RegisterNetEvent("property:createVehicle")
AddEventHandler("property:createVehicle", function(vehicleProps, spawnpoint, heading)
    print("creating vehicle!", json.encode(vehicleProps))

    ESX.Game.SpawnVehicle(vehicleProps["model"], spawnpoint, heading, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
        NetworkFadeInEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(vehicleProps["model"])
        SetEntityAsMissionEntity(vehicle, true, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetVehicleNumberPlateText(vehicle, vehicleProps['plate'])
        SetVehicleFuelLevel(vehicle, 100.0)

        if GetVehicleClass(vehicle) == 15 then
            for i = 1, 10, 1 do
                SetVehicleExtra(vehicle, i, 0)
            end
        end

        local a = 0
        for i=1, 100 do
            if a == 0 then
                SetEntityAlpha(vehicle, 100, false)
                a = 1
            elseif a == 1 then
                ResetEntityAlpha(vehicle)
                a = 0
                Citizen.Wait(10)
            end
            Citizen.Wait(10)
        end
    end)
end)

RegisterNetEvent("property:sendBuildingData")
AddEventHandler("property:sendBuildingData", function(buildings)
    PROPERTY["buildingDataLoaded"] = true
    PROPERTY["buildingData"] = buildings
end)

RegisterNetEvent("property:sendBuildings")
AddEventHandler("property:sendBuildings", function(buildings)
    PROPERTY["buildings"] = buildings
end)

RegisterNetEvent("property:sendCoOwners")
AddEventHandler("property:sendCoOwners", function(coOwners)
    PROPERTY["coOwners"] = coOwners
end)

RegisterNetEvent("property:sendPlayersInProperty")
AddEventHandler("property:sendPlayersInProperty", function(playersInProperty)
    if playersInProperty then
        for k,v in pairs(playersInProperty) do
            table.insert(PROPERTY["playersInPropertyList"], v)
        end
    end
end)

RegisterNetEvent("property:beenCoOwner")
AddEventHandler("property:beenCoOwner", function(data)
    PROPERTY["ringed"] = false
    PROPERTY["coOwned"] = true
    PROPERTY["owned"] = false

    PROPERTY["hideList"] = {}

    if data.permissions then
        for k,v in pairs(data.permissions) do
            if v.name == "chestAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "wearAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "editMode" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end
        end
    end
end)

RegisterNetEvent("property:updatePermissions")
AddEventHandler("property:updatePermissions", function(data)
    PROPERTY["hideList"] = {}
    if data.permissions then
        for k,v in pairs(data.permissions) do
            if v.name == "chestAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "wearAccess" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end

            if v.name == "editMode" and v.toggle ~= true then
                PROPERTY["hideList"][v.name] = true
            end
        end
    end
end)

RegisterNetEvent("property:updateInteriorSettings")
AddEventHandler("property:updateInteriorSettings", function(interiorSettings)
    PROPERTY["interiorSettings"] = interiorSettings
end)

RegisterNetEvent("property:updateInteriorSettingsAndApply")
AddEventHandler("property:updateInteriorSettingsAndApply", function(interiorSettings)
    PROPERTY["interiorSettings"] = interiorSettings

    if PROPERTY["interiorSettings"] then
        if PROPERTY["interiorSettings"].wallText then
            if PROPERTY["interiorSettings"].wallText.enabled then
                local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                FinanceOrganization.Office.Enable(true)
                FinanceOrganization.Name.Set(PROPERTY["interiorSettings"].wallText.text, 1, PROPERTY["interiorSettings"].wallText.color, PROPERTY["interiorSettings"].wallText.font)
            else
                FinanceOrganization.Office.Enable(false)
            end
        end
    end
end)

RegisterNetEvent("property:sendMusicTitle")
AddEventHandler("property:sendMusicTitle", function(musicTitle)
    PROPERTY["musicTitle"] = musicTitle
end)

local function searchDuplicates(t)
    seen = {}
    duplicated = {}

    for i=1, #t do
        element = t[i]

        if seen[element] then
            duplicated[element] = true
        else
            seen[element] = true
        end
    end

    return duplicated
end

local personalUuids = {}

local function dedupByDoor(t)
    local seen = {}
    for k,v in pairs(t) do
        if not seen[v.door] then
            seen[v.door] = true
        else
            t[k] = nil
        end
    end
    return t
end

local function applyMinimizedBlips()
    for k,v in pairs(PROPERTY["jobBlips"]) do
        RemoveBlip(v)
    end
    PROPERTY["jobBlips"] = {}
    for k,v in pairs(PROPERTY["personnalBlips"]) do
        RemoveBlip(v)
    end
    PROPERTY["personnalBlips"] = {}

    if playerJob == "immo" then

        for k,v in pairs(minimizedPropertys) do
            if not v.hide then
                local blip = AddBlipForCoord(vector3(v.door.x, v.door.y, v.door.z))
                SetBlipSprite(blip, 411)
                SetBlipDisplay(blip, 4)
                SetBlipColour(blip, v.owned and 39 or 2)
                SetBlipScale(blip, 0.8)
                SetBlipAsShortRange(blip, true)
                SetBlipCategory(blip, PROPERTY_BLIP_CATEGORY)

                BeginTextCommandSetBlipName(PROPERTY_BLIP_GROUP_GXT)
                EndTextCommandSetBlipName(blip)
                table.insert(PROPERTY["jobBlips"], blip)
            end
        end

        for k,v in pairs(minimizedBuildings) do
            if not v.hide then
                local blip = AddBlipForCoord(vector3(v.door.x, v.door.y, v.door.z))
                SetBlipSprite(blip, 475)
                SetBlipDisplay(blip, 4)
                SetBlipColour(blip, 2)
                SetBlipScale(blip, 0.8)
                SetBlipAsShortRange(blip, true)
                SetBlipCategory(blip, PROPERTY_BLIP_CATEGORY)

                BeginTextCommandSetBlipName(PROPERTY_BLIP_GROUP_GXT)
                EndTextCommandSetBlipName(blip)
                table.insert(PROPERTY["jobBlips"], blip)
            end
        end
    end

    for k,v in pairs(minimizedBuildings) do
        if not v.hide then
            local blip = UTILS.CreateBlip({
                pos = v.door,
                sprite = 475,
                color = 3,
                scale = 0.65,
                title = v.name,
            })
            table.insert(PROPERTY["personnalBlips"], blip)
        end
    end

    for k,v in pairs(personalUuids) do
        local blip = UTILS.CreateBlip({
            pos = v.door,
            sprite = 40,
            color = 69,
            scale = 0.65,
            title = v.name,
        })
        table.insert(PROPERTY["personnalBlips"], blip)
    end
end

RegisterNetEvent("property:sendMinimized")
AddEventHandler("property:sendMinimized", function(d, b, g, UUID, e)
    playerUUID = UUID
    minimizedBuildings = dedupByDoor(b)
    minimizedPropertys = dedupByDoor(d)
    personalUuids = g or {}
    applyMinimizedBlips()
end)

RegisterNetEvent("property:sendMinimizedGlobal")
AddEventHandler("property:sendMinimizedGlobal", function(d, b)
    minimizedBuildings = dedupByDoor(b)
    minimizedPropertys = dedupByDoor(d)
    applyMinimizedBlips()
end)

RegisterNetEvent("property:sendMinimizedPersonal")
AddEventHandler("property:sendMinimizedPersonal", function(g, UUID, e)
    if UUID then playerUUID = UUID end
    personalUuids = g or {}
    applyMinimizedBlips()
end)

local function onJobChanged(job)
    if job and job.name then
        playerJob = job.name
    end
    applyMinimizedBlips()
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', onJobChanged)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', onJobChanged)

RegisterNetEvent("property:whileVisit")
AddEventHandler("property:whileVisit", function(data)
    requestNoclipGrace()
    for k,v in pairs(PROPERTY["blips"]) do
        RemoveBlip(v)
    end

    PROPERTY["visiting"] = true
    PROPERTY["inProperty"] = true
    PROPERTY["propertyId"] = data.interiorId

    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.enabled then
            Citizen.CreateThread(function()
                while PROPERTY["inProperty"] do
                    local interval = 1000

                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, true) < 100.0 then
                        if not PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded = true

                            local model = GetHashKey(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.hash)
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Citizen.Wait(100)
                            end

                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped = CreatePed(1, model, PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.heading, false, false)
                            FreezeEntityPosition(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                            TaskSetBlockingOfNonTemporaryEvents(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                            SetEntityInvincible(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, true)
                        end
                    else
                        if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded = false

                            DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped)
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)

            Citizen.CreateThread(function()
                local lastCalled = 0
                while PROPERTY["inProperty"] do
                    local interval = 500

                    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.loaded then
                        interval = 0

                        local x, y, z = table.unpack(GetPedBoneCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, 12844, 0, 0, 0))
                        ESX.Game.Utils.DrawText3D(vector3(x, y, z + 0.50), "Secrétaire", 1.0, 4)

                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.coords.pos, true) < 2.5 then
                            if not PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called then
                                PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called = true
                                PlayPedAmbientSpeechNative(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped, "GENERIC_HI", "SPEECH_PARAMS_STANDARD")
                            end

                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec la secrétaire", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                if not PROPERTY["visiting"] then
                                    lastCalled = GetGameTimer() + 500
                                    PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.action()
                                else
                                    ESX.ShowNotification("~r~Indisponible en visite")
                                end
                            end
                        else
                            PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.called = false
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].boombox then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.enabled then
            RegisterNetEvent("property:soundStatus")
            AddEventHandler("property:soundStatus", function(type, musicId, data)
                if type == "play" then
                    JK.sound:PlayUrlPos(musicId, data.link, data.volume, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, false)
                    JK.sound:Distance(musicId, 30)

                    JK.isPlaying = true
                    JK.isResume = true
                end

                if type == "stop" then
                    PROPERTY["musicTitle"] = nil

                    JK.sound:Destroy(musicId)

                    JK.isPlaying = false
                    JK.isResume = false
                end

                if type == "resume" then
                    if JK.sound:isPaused(musicId) then
                        JK.sound:Resume(musicId)
                    end

                    JK.isPlaying = true
                    JK.isResume = true
                end

                if type == "pause" then
                    if not JK.sound:isPaused(musicId) then
                        JK.sound:Pause(musicId)
                    end

                    JK.isPlaying = true
                    JK.isResume = false
                end

                if type == "sync" then
                    if JK.sound:soundExists(musicId) then
                        JK.sound:setTimeStamp(musicId, data.time)
                    else
                        JK.sound:PlayUrlPos(musicId, data.link, data.volume, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, false)
                        JK.sound:Distance(musicId, 30)

                        JK.sound:setTimeStamp(musicId, data.time)

                        JK.isPlaying = true
                        JK.isResume = true
                    end
                end

                if type == "volume" then
                    JK.sound:setVolume(musicId, data.volume)
                end
            end)

            if PROPERTY["owned"] or PROPERTY["visiting"] or PROPERTY["coOwned"] then
                Citizen.CreateThread(function()
                    local lastCalled = 0
                    while PROPERTY["inProperty"] do
                        local interval = 500

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                            interval = 0
                            DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.z + 0.25, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 1.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec l'enceinte", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                if not PROPERTY["visiting"] then
                                    lastCalled = GetGameTimer() + 500
                                    PROPERTY["openBoombox"]()
                                else
                                    ESX.ShowNotification("~r~Indisponible en visite")
                                end
                            end
                        end

                        Citizen.Wait(interval)
                    end
                end)
            end

            Citizen.CreateThread(function()
                while PROPERTY["inProperty"] do
                    local interval = 500

                    if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                        interval = 0
                        if PROPERTY["musicTitle"] then
                            ESX.Game.Utils.DrawText3D(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].boombox.coords.z + 0.15), "🎶 "..PROPERTY["musicTitle"], 0.50, 4)
                        end
                    end

                    Citizen.Wait(interval)
                end
            end)
        end
    end

    if PROPERTY["interiors"][PROPERTY["propertyId"]].telescope then
        if PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.enabled then
            if PROPERTY["owned"] or PROPERTY["coOwned"] or PROPERTY["visiting"] then
                Citizen.CreateThread(function()
                    local lastCalled = 0
                    while PROPERTY["inProperty"] do
                        local interval = 500

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords, GetEntityCoords(PlayerPedId()), true) < 10.0 then
                            interval = 0
                            DrawMarker(20, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.x, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.y, PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords.z + 1.10, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 255, 117, 31, 225, false, true)
                        end

                        if GetDistanceBetweenCoords(PROPERTY["interiors"][PROPERTY["propertyId"]].telescope.coords, GetEntityCoords(PlayerPedId()), true) < 1.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le télecsope", true)

                            if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                                if not PROPERTY["visiting"] then
                                    lastCalled = GetGameTimer() + 500
                                    ExecuteCommand("telescope")
                                else
                                    ESX.ShowNotification("~r~Indisponible en visite")
                                end
                            end
                        end

                        Citizen.Wait(interval)
                    end
                end)
            end
        end
    end

    PROPERTY["propertyIdr"] = data.propertyId
    PROPERTY["interiorSettings"] = data.interiorSettings
    PROPERTY["garageSettings"] = data.garageSettings

    if PROPERTY["interiors"][PROPERTY["propertyId"]].secretary then
        if DoesEntityExist(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped) then
            DeleteEntity(PROPERTY["interiors"][PROPERTY["propertyId"]].secretary.model.ped)
        end
    end

    if PROPERTY["interiorSettings"] then
        if PROPERTY["interiorSettings"].wallText then
            local ok, FinanceOrganization = pcall(function()
                return exports.bob74_ipl:GetFinanceOrganizationObject()
            end)
            if ok and FinanceOrganization then
                if PROPERTY["interiorSettings"].wallText.enabled then
                    FinanceOrganization.Office.Enable(true)
                    FinanceOrganization.Name.Set("VOTRE TEXTE", 1, 0, 0)
                else

                    FinanceOrganization.Office.Enable(false)
                end
            end
        end
    end

    AddTextEntry('BLIPS_GEN_PROPERTY_EXIT', 'Propriété - Sortie')
    AddTextEntry('BLIPS_GEN_PROPERTY_CHEST', 'Propriété - Coffre')

    local exitBlip = AddBlipForCoord(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z))
    SetBlipSprite(exitBlip, 143)
    SetBlipDisplay(exitBlip, 4)
    SetBlipColour(exitBlip, 2)
    SetBlipScale(exitBlip, 0.8)
    SetBlipAsShortRange(exitBlip, true)
    SetBlipCategory(exitBlip, PROPERTY_BLIP_CATEGORY)

    BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_EXIT')
    EndTextCommandSetBlipName(exitBlip)

    local chestBlip = AddBlipForCoord(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z))
    SetBlipSprite(chestBlip, 478)
    SetBlipDisplay(chestBlip, 4)
    SetBlipColour(chestBlip, 2)
    SetBlipScale(chestBlip, 0.8)
    SetBlipAsShortRange(chestBlip, true)
    SetBlipCategory(chestBlip, PROPERTY_BLIP_CATEGORY)

    BeginTextCommandSetBlipName('BLIPS_GEN_PROPERTY_CHEST')
    EndTextCommandSetBlipName(chestBlip)

    table.insert(PROPERTY["blips"], exitBlip)
    table.insert(PROPERTY["blips"], chestBlip)

    if data.interiorSettings and PROPERTY["interiors"][PROPERTY["propertyId"]]["editables"] then
        for k,v in pairs(PROPERTY["interiors"][PROPERTY["propertyId"]]["editables"]) do
            if v.type == "interiorStyles" then
                if v.list[data.interiorSettings.interiorStyle] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.interiorStyle].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "strip" then
                if data.interiorSettings.strip then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "booze" then
                if data.interiorSettings.booze then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "chairs" then
                if data.interiorSettings.chairs then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "bunkerEquipment" then
                if data.interiorSettings.bunkerEquipment then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.action(true)
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "casinoDecors" then
                if v.list[data.interiorSettings.casinoDecor] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.casinoDecor].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end

            if v.type == "casinoDecorsBar" then
                if v.list[data.interiorSettings.casinoDecorsBar] then
                    local coords = GetEntityCoords(PlayerPedId())
                    v.list[data.interiorSettings.casinoDecorsBar].action()
                    SetEntityCoords(PlayerPedId(), coords)
                end
            end
        end
    end

    local a = 0
    for i=1, 100 do
        if a == 0 then
            SetEntityAlpha(PlayerPedId(), 100, false)
            a = 1
        elseif a == 1 then
            ResetEntityAlpha(PlayerPedId())
            a = 0
            Citizen.Wait(10)
        end
        Citizen.Wait(10)
    end
end)

RegisterNetEvent('property:onBuy')
AddEventHandler('property:onBuy', function()
    TriggerServerEvent("property:buyed")
end)

RegisterNetEvent('property:sendVehiclesMinimized')
AddEventHandler('property:sendVehiclesMinimized', function(vehicles)
    PROPERTY["myVehicles"] = vehicles
end)

RegisterNetEvent("property:sendChestInfo")
AddEventHandler("property:sendChestInfo", function(inventoryData)
    PROPERTY["inventory"] = inventoryData.inventory
    PROPERTY["inventoryWeight"] = inventoryData.weight
    PROPERTY["inventoryCapacity"] = inventoryData.capacity
    PROPERTY["inventoryMoney"] = inventoryData.money
    PROPERTY["inventoryDirtyMoney"] = inventoryData.dirty

    local t = ESX.GetPlayerData()
    PROPERTY["myInventory"]       = {}

    for k,v in pairs(t.inventory) do
        if v.count > 0 then
            table.insert(PROPERTY["myInventory"], {
                label     = t.inventory[k].label,
                count     = t.inventory[k].count,
                value     = t.inventory[k].name,
                name      = t.inventory[k].label,
                limit     = t.inventory[k].limit,
            })
        end
    end
end)

RegisterNetEvent("property:sendChestInfoBase")
AddEventHandler("property:sendChestInfoBase", function(inventoryData, blackMoney)
    PROPERTY["inventoryEnabled"] = inventoryData.enabled

    if blackMoney then
        PROPERTY["blackMoney"] = blackMoney
    end
end)

RegisterNetEvent("property:sendWebhooks")
AddEventHandler("property:sendWebhooks", function(webhooks)
    PROPERTY["webhooks"] = webhooks
end)

RegisterNetEvent("property:sendLetterbox")
AddEventHandler("property:sendLetterbox", function(letterboxData)
    PROPERTY["letterbox"] = letterboxData.inventory
    PROPERTY["letterboxWeight"] = letterboxData.weight
    PROPERTY["letterboxMoney"] = letterboxData.money
    PROPERTY["letterboxDirtyMoney"] = letterboxData.dirty
end)

RegisterNetEvent("property:sendMyClothes")
AddEventHandler("property:sendMyClothes", function(clothes)
    PROPERTY["myClothes"] = clothes
end)

RegisterNetEvent("property:sendOtherPlayersClothes")
AddEventHandler("property:sendOtherPlayersClothes", function(clothes)
    PROPERTY["otherPlayersClothes"] = clothes
end)

RegisterNetEvent("property:billing:open")
AddEventHandler("property:billing:open", function(label, price, event, incoins, id)
    PROPERTY["openBilling"](label, price, event, incoins, id)
end)

RegisterNetEvent("property:labo:detector:detected")
AddEventHandler("property:labo:detector:detected", function(info)
    ESX.ShowNotification("~r~Il y'a quelqu'un qui s'approche de la porte de votre laboratoire !")

    local coords = vector3(info.door.x, info.door.y, info.door.z)
    local alpha = 250
    local alpha2 = 170
    local info = AddBlipForCoord(coords)
    local info2 = AddBlipForCoord(coords)

    SetBlipSprite(info, 161)
    SetBlipDisplay(info, 4)
    SetBlipColour(info, 1)
    SetBlipScale(info, 0.8)
    SetBlipAsShortRange(info, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info)

    SetBlipSprite(info2, 459)
    SetBlipDisplay(info2, 4)
    SetBlipColour(info2, 1)
    SetBlipScale(info2, 0.8)
    SetBlipAsShortRange(info2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info2)

	while alpha ~= 0 do
		Citizen.Wait(30 * 10)
		alpha = alpha - 1
		SetBlipAlpha(info, alpha)
		SetBlipAlpha(info2, alpha)

		if alpha == 0 then
			RemoveBlip(info)
			RemoveBlip(info2)
			return
		end
	end
end)

RegisterNetEvent("property:labo:importexport:sendEvent")
AddEventHandler("property:labo:importexport:sendEvent", function(info)
    ESX.ShowAdvancedNotification("Transport de drogues", "~r~SunLife", "Une nouvelle mission de cargaison de drogues est disponible !", "CHAR_MP_GERALD", 8)

    local blip = AddBlipForCoord(info.spawnPos)
    SetBlipSprite(blip, 496)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~r~Mission illégale")
	EndTextCommandSetBlipName(blip)

    Citizen.CreateThread(function()
        while #(GetEntityCoords(PlayerPedId()) - info.spawnPos) > 100.0 do
            Citizen.Wait(100)
        end

        PROPERTY["taked"] = false
        local called = false
        local removeAll = false
        Citizen.CreateThread(function()
            while not PROPERTY["taked"] do

                if #(GetEntityCoords(PlayerPedId()) - info.spawnPos) < 15.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre le véhicule de livraison")

                    if IsControlJustPressed(0, 38) then
                        PROPERTY["taked"] = true

                        ESX.TriggerServerCallback("property:importexport:tryTake", function(yes)
                            if yes then
                                TriggerServerEvent("property:labo:importexport:setTrunk", {
                                    id = info.id,
                                })

                                TriggerServerEvent('eye:veh:authorize', GetHashKey("mule"), 'property_mule')
                                ESX.Game.SpawnVehicle(GetHashKey("mule"), info.spawnPos, info.spawnHeading, function(vehicle)
                                    SetVehicleNumberPlateText(vehicle, "EXPORT")
                                    SetVehicleFuelLevel(vehicle, 100.0)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                end)
                            else
                                removeAll = true
                            end
                        end, info)
                    end
                else
                    called = false
                end

                Citizen.Wait(0)
            end

            if not removeAll then
                local blip = AddBlipForCoord(info.deliverPos)
                SetBlipSprite(blip, 496)
                SetBlipColour(blip, 1)
                SetBlipRoute(blip, true)

                ESX.ShowNotification("~o~Livrez le véhicule à cette position GPS")

                while #(GetEntityCoords(PlayerPedId()) - info.deliverPos) > 15.0 do
                    Citizen.Wait(0)
                end

                local deposed = false
                while not deposed do

                    if #(GetEntityCoords(PlayerPedId()) - info.deliverPos) < 5.0 and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey("mule") then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour livrer le véhicule")

                        if IsControlJustPressed(0, 38) then
                            deposed = true

                            RemoveBlip(blip)
                            DeleteEntity(GetVehiclePedIsUsing(PlayerPedId()))

                            TriggerServerEvent("property:labo:importexport:delivery")
                        end
                    end

                    Citizen.Wait(0)
                end
            end
        end)
    end)
end)

RegisterNetEvent("property:police:sendPerceuseMinigame")
AddEventHandler("property:police:sendPerceuseMinigame", function(info)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)

    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("Drilling:Start", function(success)
        ClearPedTasks(PlayerPedId())
        if success then
            local progress = lib.progressCircle({
                duration = 10000,
                label = "⏳ Forçage en cours...",
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true
                }
            })
            if progress and #(GetEntityCoords(PlayerPedId()) - coords) < 5.0 then
                TriggerServerEvent("property:police:perceuseMinigame:won")
            else
                ESX.ShowNotification("~r~Vous vous êtes éloigné du point.")
            end
        else
            ESX.ShowNotification("~r~Vous avez échoué le forçage")
        end
    end)
end)

RegisterNetEvent("property:isForced")
AddEventHandler("property:isForced", function(toggle)
    PROPERTY["isForced"] = toggle
end)

RegisterNetEvent("property:doorForced")
AddEventHandler("property:doorForced", function(propertyId)
    if not propertyId then return end
    PROPERTY["forcedProperties"] = PROPERTY["forcedProperties"] or {}
    PROPERTY["forcedProperties"][propertyId] = true
end)

RegisterNetEvent("property:gang:sendPerceuseMinigame")
AddEventHandler("property:gang:sendPerceuseMinigame", function(info)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)

    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("Drilling:Start", function(success)
        ClearPedTasks(PlayerPedId())
        if success then
            local progress = lib.progressCircle({
                duration = 10000,
                label = "⏳ Forçage en cours...",
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true
                }
            })
            if progress and #(GetEntityCoords(PlayerPedId()) - coords) < 5.0 then
                TriggerServerEvent("property:gang:perceuseMinigame:won")
            else
                ESX.ShowNotification("~r~Vous vous êtes éloigné du point.")
            end
        else
            ESX.ShowNotification("~r~Vous avez échoué le forçage")
        end
    end)
end)

RegisterNetEvent("property:labo:sendMinimized")
AddEventHandler("property:labo:sendMinimized", function(info)
    PROPERTY["laboPos"] = info

    if not PROPERTY["launchedLaboThread"] then
        PROPERTY["launchedLaboThread"] = true
        Citizen.CreateThread(function()
            while true do
                local interval = 15 * 1000

                for k,v in pairs(PROPERTY["laboPos"]) do
                    if not v.lastCalled then v.lastCalled = 0 end
                    if #(GetEntityCoords(PlayerPedId()) - v.door) < 15.0 and GetGameTimer() > v.lastCalled then
                        v.lastCalled = GetGameTimer() + 15 * 1000
                        TriggerServerEvent("property:labo:laboNear", {
                            propertyId = v.propertyId,
                        })
                    end
                end

                Citizen.Wait(interval)
            end
        end)
    end
end)

RegisterNetEvent("property:furniture:refresh")
AddEventHandler("property:furniture:refresh", function(props)
    PROPERTY["createdPropsByIndex"] = {}
    for _, v in pairs(PROPERTY["createdProps"]) do
        if v.entity then
            DeleteEntity(v.entity)
        end
    end

    Citizen.CreateThread(function()
        local count = 0

        Citizen.Wait(2.5 * 1000)

        for k,v in pairs(props) do
            count = count + 1

            if IsModelValid(v.model) then
                local hash = GetHashKey(v.model)
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(100)
                end

                SetModelAsNoLongerNeeded(hash)

                v.entity = CreateObject(hash, 1.0, 1.0, 1.0, false, true, false)
                SetEntityCoords(v.entity, vector3(v.coords.x, v.coords.y, v.coords.z))

                if not v.rotation then v.rotation = vector3(0.0, 0.0, 0.0) end
                SetEntityRotation(v.entity, v.rotation.x, v.rotation.y, v.rotation.z)

                if v.fixGround then
                    PlaceObjectOnGroundProperly(v.entity)
                end

                SetEntityCollision(v.entity, false, false)

                FreezeEntityPosition(v.entity, true)

                PROPERTY["createdPropsByIndex"][v.id] = v.entity

                table.insert(PROPERTY["createdProps"], {
                    entity = v.entity,
                    model = v.model,
                    id = v.id,
                })
            else
                print("model invalid", v.model)
            end

            Citizen.Wait(10)
        end

        for k,v in pairs(PROPERTY["createdProps"]) do
            SetEntityCollision(v.entity, true, false)
        end

        print("^2"..count.." entitys ^7loaded in property")

        if PROPERTY["pendingEditProp"] then
            local pending = PROPERTY["pendingEditProp"]
            PROPERTY["pendingEditProp"] = nil

            for k,v in pairs(props) do
                if v.id == pending.id then
                    local editProp = {
                        id = v.id,
                        model = v.model,
                        coords = v.coords,
                        heading = v.heading,
                        rotation = v.rotation,
                        fixGround = v.fixGround,
                        entity = PROPERTY["createdPropsByIndex"][v.id],
                        index = k,
                    }

                    Citizen.SetTimeout(500, function()
                        if PROPERTY["openEditMode"] then
                            PROPERTY["openEditMode"](editProp)
                        end
                    end)
                    break
                end
            end
        end
    end)
end)
