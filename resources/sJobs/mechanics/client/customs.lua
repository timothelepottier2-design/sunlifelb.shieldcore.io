local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'mechanics', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'mechanics', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('mechanics/' .. name, cb)
end

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    ESX.PlayerData = ESX.GetPlayerData()

    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "hayes" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "hayes" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "hayes" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

RegisterNetEvent('custommenu:uiNotification')
AddEventHandler('custommenu:uiNotification', function(notifType, text)
    if GetNuiMecanoContext() then
        SendNUIMessage({ action = 'notification', type = notifType or 'info', text = text or '' })
    else
        local prefix = (notifType == 'success') and '~g~' or '~r~'
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification(prefix .. (text or ''))
        end
    end
end)

local function applyOneModToProps(props, modName, modValue, vehicle)
    if modName == "wheels" and type(modValue) == "table" then
        local wt = modValue[1]
        local modIndex = modValue[2]
        props["wheels"] = wt
        props["modFrontWheels"] = modIndex
        if vehicle and GetVehicleClass(vehicle) == 8 then
            props["modBackWheels"] = modIndex
        end
    elseif modName == "neonEnabled" and type(modValue) == "table" then
        if #modValue >= 7 then
            props["neonEnabled"] = { modValue[1], modValue[2], modValue[3], modValue[4] }
            props["neonColor"] = { modValue[5], modValue[6], modValue[7] }
        else
            props["neonEnabled"] = modValue
            if modValue[1] == 0 then props["neonColor"] = { 0, 0, 0 } end
        end
    elseif modName == "tyreSmokeColor" and type(modValue) == "table" then
        props["modSmokeEnabled"] = 1
        props["tyreSmokeColor"] = modValue
    elseif modName == "interiorColour" then
        props["interiorColour"] = modValue
        props["interiorColor"] = modValue
    elseif modName == "dashboardColour" then
        props["dashboardColour"] = modValue
        props["dashboardColor"] = modValue
    elseif modName == "xenonColor" then

        props["modXenon"] = 1
        props["xenonColor"] = modValue
    else
        props[modName] = modValue
    end
end

RegisterNetEvent('custommenu:previewMod')
AddEventHandler('custommenu:previewMod', function(modName, modValue)
    local ctx = GetNuiMecanoContext()
    if not ctx or not ctx.vehicle or not ctx.oldProps or not ESX or not ESX.Game or not ESX.Game.SetVehicleProperties then return end
    local copy = {}
    for k, v in pairs(ctx.oldProps) do copy[k] = v end
    applyOneModToProps(copy, modName, modValue, ctx.vehicle)
    ESX.Game.SetVehicleProperties(ctx.vehicle, copy)
end)

RegisterNetEvent('custommenu:clearPreview')
AddEventHandler('custommenu:clearPreview', function()
    local ctx = GetNuiMecanoContext()
    if not ctx or not ctx.vehicle or not ctx.oldProps or not ESX or not ESX.Game or not ESX.Game.SetVehicleProperties then return end
    ESX.Game.SetVehicleProperties(ctx.vehicle, ctx.oldProps)
end)

local MecanoLSC = nil

-- Remet un vehicule (identifie par sa plaque) dans ses proprietes d'origine :
-- demande par le serveur quand un mecano se deconnecte en pleine session de
-- custom non payee. Seul le client qui a le vehicule sous la main agit.
RegisterNetEvent("custommenu:forceRestore")
AddEventHandler("custommenu:forceRestore", function(plate, props)
    if type(plate) ~= "string" or type(props) ~= "table" then return end
    local want = plate:gsub("%s+", "")
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        local p = GetVehicleNumberPlateText(veh)
        if p and p:gsub("%s+", "") == want then
            if not NetworkHasControlOfEntity(veh) then
                NetworkRequestControlOfEntity(veh)
                local deadline = GetGameTimer() + 500
                while not NetworkHasControlOfEntity(veh) and GetGameTimer() < deadline do Wait(0) end
            end
            if NetworkHasControlOfEntity(veh) then
                pcall(ESX.Game.SetVehicleProperties, veh, props)
            end
            return
        end
    end
end)

RegisterNetEvent("custommenu:saveCustomResult")
AddEventHandler("custommenu:saveCustomResult", function(success, myCarToSave)
    if success and myCarToSave then
        if MecanoLSC then
            MecanoLSC.cart = {}
            -- Les mods sont payes : ils deviennent le nouvel etat d'origine
            -- (une fermeture ulterieure ne les retire plus), et la session
            -- serveur est mise a jour dans le meme sens.
            MecanoLSC.initialProps = json.decode(json.encode(myCarToSave))
            if myCarToSave.plate then
                TriggerServerEvent("custommenu:sessionOpen", myCarToSave.plate, MecanoLSC.initialProps)
            end
        end
        SendNUIMessage({ action = "cartUpdated", total = 0, count = 0 })
        TriggerServerEvent("custommenu:refreshOwnedVehicle", myCarToSave)
    else

        local msg = type(myCarToSave) == "string" and myCarToSave or "Impossible de sauvegarder."
        SendNUIMessage({ action = "notification", type = "error", text = msg })
        SendNUIMessage({ action = "saveFailed" })
    end
end)

loadMecanoDatas = function()
    local LSC = {}
    MecanoLSC = LSC
    LSC.oldProps = {}
    LSC.menuOpenned = false

    Citizen.CreateThread(function()
        while true do
            local nearThing = false

            for k,v in pairs(cfg_mecano.posList) do
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos)

                if dist <= 5.0 then
                    nearThing = true
                    if not LSC.menuOpenned then
                        ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu de customisation")
                    end
                    DrawMarker(6, v.pos, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 117, 31, 225)
                    if IsControlJustPressed(1,38) and IsPedInAnyVehicle(PlayerPedId(), false) then
                        if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'streettuners' or ESX.PlayerData.job.name == 'hayes' or ESX.PlayerData.job.name == 'harmony' or ESX.PlayerData.job.name == 'bennys' or ESX.PlayerData.job.name == 'mayans') then
                            if LSC.menuOpenned == false then
                                LSCopenMenu()
                                break
                            end
                        end
                    end
                end
            end

            for k,v in pairs(GetGamePool('CVehicle')) do
                if GetEntityModel(v) == GetHashKey("servicevan") and #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) < 8.0 then
                    nearThing = true
                    local truckCoords = GetEntityCoords(v)
                    local markerDistance = 3.5
                    local markerHeading = GetEntityHeading(v)
                    local markerOffsetX = -markerDistance * math.cos(math.rad(markerHeading))
                    local markerOffsetY = -markerDistance * math.sin(math.rad(markerHeading))

                    if ESX.PlayerData.job.name == "harmony" and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) ~= GetHashKey("servicevan") then
                        if not LSC.menuOpenned then
                            ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu custom du camion")
                        end
                        DrawMarker(6, truckCoords.x + markerOffsetX, truckCoords.y + markerOffsetY, truckCoords.z - 1.2, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 117, 31, 225)
                        if IsControlJustPressed(0, 38) and IsPedInAnyVehicle(PlayerPedId(), false) then
                            if LSC.menuOpenned == false then
                                LSCopenMenu()
                                break
                            end
                        end
                    end
                end
            end

            if nearThing then
                Citizen.Wait(0)
            else
                Citizen.Wait(500)
            end
        end
    end)

    function tablesAreEqual(table1, table2)
        if #table1 ~= #table2 then
            return false
        end

        for i, v in ipairs(table1) do
            if v ~= table2[i] then
                return false
            end
        end

        return true
    end

    local function applyModToVehicle(vehicle, modName, modValue)
        if not vehicle or not DoesEntityExist(vehicle) then return end

        -- Sans le controle reseau (mecano passager, vehicule dont un autre
        -- client est proprietaire), les changements d'apparence ne sont ni
        -- synchronises ni conserves : on le demande avant d'appliquer.
        if not NetworkHasControlOfEntity(vehicle) then
            NetworkRequestControlOfEntity(vehicle)
            local deadline = GetGameTimer() + 500
            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < deadline do
                Wait(0)
            end
        end

        if modName == "plateIndex" then
            -- Style de plaque : applique directement, puis re-pose le texte
            -- de la plaque pour forcer le moteur a re-rendre la plaque avec
            -- le nouveau style (sinon le changement peut rester invisible
            -- jusqu'au prochain respawn). Trace F8 avant/apres pour
            -- diagnostiquer si le style ne prend toujours pas.
            local idx = math.floor(tonumber(modValue) or 0)
            if idx < 0 then idx = 0 end
            local before = GetVehicleNumberPlateTextIndex(vehicle)
            SetVehicleNumberPlateTextIndex(vehicle, idx)
            SetVehicleNumberPlateText(vehicle, GetVehicleNumberPlateText(vehicle))
            local after = GetVehicleNumberPlateTextIndex(vehicle)
            print(("[mecano] plateIndex %s -> demande %d -> lu %s (controle reseau: %s)"):format(
                tostring(before), idx, tostring(after), tostring(NetworkHasControlOfEntity(vehicle))))
            LSC.oldProps["plateIndex"] = idx
            myCar = ESX.Game.GetVehicleProperties(vehicle)
            LSC.oldProps = ESX.Game.GetVehicleProperties(vehicle)
            if (LSC.oldProps.plateIndex or -1) < 0 then LSC.oldProps.plateIndex = idx end
            return
        end

        if (modName == "wheels") then
            if GetVehicleClass(vehicle) ~= 8 then
                LSC.oldProps["wheels"] = modValue[1]
                LSC.oldProps["modFrontWheels"] = modValue[2]
            else
                LSC.oldProps["wheels"] = modValue[1]
                LSC.oldProps["modFrontWheels"] = modValue[2]
                LSC.oldProps["modBackWheels"] = modValue[2]
            end
        elseif (modName == "neonEnabled" and type(modValue) == "table") then
            if tablesAreEqual(modValue, {1,1,1,1}) then
                LSC.oldProps[modName] = {1, 1, 1, 1}
                LSC.oldProps.neonColor = {255, 255, 255}
            elseif #modValue >= 7 then
                LSC.oldProps[modName] = { modValue[1], modValue[2], modValue[3], modValue[4] }
                LSC.oldProps.neonColor = { modValue[5], modValue[6], modValue[7] }
            else
                LSC.oldProps[modName] = modValue
                if modValue[1] == 0 then
                    LSC.oldProps.neonColor = { 0, 0, 0 }
                end
            end
        elseif (modName == "tyreSmokeColor") then
            LSC.oldProps.modSmokeEnabled = 1
            LSC.oldProps.tyreSmokeColor = modValue
        elseif (modName == "interiorColour") then
            LSC.oldProps[modName] = modValue
            LSC.oldProps.interiorColor = modValue
        elseif (modName == "dashboardColour") then
            LSC.oldProps[modName] = modValue
            LSC.oldProps.dashboardColor = modValue
        elseif (modName == "xenonColor") then

            LSC.oldProps.modXenon = 1
            LSC.oldProps.xenonColor = modValue
        else
            LSC.oldProps[modName] = modValue
        end
        ESX.Game.SetVehicleProperties(vehicle, LSC.oldProps)
        myCar = ESX.Game.GetVehicleProperties(vehicle)
        LSC.oldProps = ESX.Game.GetVehicleProperties(vehicle)
    end

    RegisterNetEvent('custommenu:installMod')
    AddEventHandler('custommenu:installMod', function(modName, modValue)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        applyModToVehicle(vehicle, modName, modValue)
        local ctx = GetNuiMecanoContext()
        if ctx then
            ctx.oldProps = LSC.oldProps
            SendNUIMessage({ action = "modApplied" })
        end
        TriggerServerEvent('custommenu:refreshOwnedVehicle', myCar)
    end)

    RegisterNetEvent("custommenu:cancelInstallMod")
    AddEventHandler("custommenu:cancelInstallMod", function()
        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), LSC.oldProps)
    end)

    LSC.buy = function(modPrice, name, modName, modValue, plaque)
        TriggerServerEvent("custommenu:buyMod", modPrice, name, modName, modValue, plaque)
    end

    LSC.addToCartAndApply = function(modPrice, name, modName, modValue, plaque)
        if not LSC.cart then LSC.cart = {} end
        for i = #LSC.cart, 1, -1 do
            if LSC.cart[i].modName == modName then
                table.remove(LSC.cart, i)
            end
        end
        local price = math.floor(tonumber(modPrice) or 0)
        if price > 0 then
            table.insert(LSC.cart, { modName = modName, modValue = modValue, price = price, name = name })
        end
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        applyModToVehicle(vehicle, modName, modValue)
        local ctx = GetNuiMecanoContext()
        if ctx then
            ctx.oldProps = LSC.oldProps
            local totalBase, count = 0, LSC.cart and #LSC.cart or 0
            for _, it in ipairs(LSC.cart or {}) do totalBase = totalBase + it.price end
            local mult = ctx.vipPriceMult or 1.0
            local total = math.floor(totalBase * mult + 0.5)
            SendNUIMessage({ action = "cartUpdated", total = total, count = count })
            SendNUIMessage({ action = "modApplied" })
        end
    end

    LSC.definePrice = function(vehiclePrice, modPrice)
        if vehiclePrice == 0 then return "GRATUIT" end
        if modPrice == 0 then return "GRATUIT" end
        if vehiclePrice * modPrice / 500 == 0 then return "GRATUIT" end

        return GroupDigits(math.floor(vehiclePrice * modPrice / 500 * 2 + 0.5)).."$"
    end

    LSC.gotBennys = function()
        if
        GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 25)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 26)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 27)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 28)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 29)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 30)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 31)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 32)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 33)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 34)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 35)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 36)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 37)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 38)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 39)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 40)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 41)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 42)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 43)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 44)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 45)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 46)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 48) > 0 then return true end

        return false
    end

    LSC.gotBodyparts = function()
        if
        GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false),   8)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 9)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 0)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 3)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 5)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 7)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 6)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 1)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 2)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 4)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 10) > 0 then return true end

        return false
    end

    LSCopenMenu = function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        if DoesEntityExist(vehicle) then
            SetVehicleModKit(vehicle, 0)
        end

        LSC.oldProps = ESX.Game.GetVehicleProperties(vehicle)
        -- Le gel du vehicule est fait APRES la reponse du serveur (voir plus
        -- bas) : avant, il etait pose ici, et si le callback ne repondait
        -- jamais, le joueur restait gele dans son vehicule sans menu, sans
        -- autre issue que relancer le jeu.

        LSC.cart = {}
        LSC.initialProps = json.decode(json.encode(LSC.oldProps))

        local vehiclePrice = 4000000
        for k,v in pairs(cfg_mecano.vehicles) do
            for i,l in pairs(v.vehicles) do
                if GetEntityModel(vehicle) == GetHashKey(l.hash) then
                    vehiclePrice = l.price*2
                    break
                end
            end
        end

        local plaque = GetVehicleNumberPlateText(vehicle)
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) or "Véhicule"

        local function releaseMecanoCamera()
            local cam = LSC.orbitCam
            LSC.orbitCam = nil
            if cam and DoesCamExist(cam) then
                SetCamActive(cam, false)
                RenderScriptCams(false, false, 0, true, true)
                DestroyCam(cam, false)
            end
            RenderScriptCams(false, false, 0, true, true)
            Citizen.CreateThread(function()
                Citizen.Wait(150)
                RenderScriptCams(false, false, 0, true, true)
            end)
        end

        local mecanoClosed = false
        local function closeMecano()
            if mecanoClosed then return end
            mecanoClosed = true

            local hadUnpaidCart = LSC.cart and #LSC.cart > 0
            LSC.cart = {}
            LSC.menuOpenned = false

            -- Fermeture sans payer : retour aux proprietes d'origine, avec le
            -- controle reseau (mecano passager, ou vehicule appartenant a un
            -- autre client) sinon la restauration ne se synchronise pas et
            -- le proprietaire garde les mods gratuitement.
            if hadUnpaidCart and vehicle and DoesEntityExist(vehicle) and LSC.initialProps then
                if not NetworkHasControlOfEntity(vehicle) then
                    NetworkRequestControlOfEntity(vehicle)
                    local deadline = GetGameTimer() + 500
                    while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < deadline do Wait(0) end
                end
                pcall(ESX.Game.SetVehicleProperties, vehicle, LSC.initialProps)
            end

            if vehicle and DoesEntityExist(vehicle) then
                FreezeEntityPosition(vehicle, false)
            end

            -- Toujours rendre la main, quel que soit le chemin de fermeture :
            -- un focus NUI oublie = joueur bloque, obligé de relancer le jeu.
            SetNuiMecanoContext(nil)
            SendNUIMessage({ action = "close" })
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            TriggerServerEvent("custommenu:sessionClose")
            Citizen.Wait(50)
            releaseMecanoCamera()
        end

        -- Garde-fou : si le serveur ne repond pas, on ne laisse pas le joueur
        -- attendre indefiniment (avant : vehicule gele, aucun menu).
        local answered = false
        Citizen.SetTimeout(6000, function()
            if not answered then
                answered = true
                if ESX and ESX.ShowNotification then
                    ESX.ShowNotification("~r~Le menu de customisation n'a pas répondu, réessayez.")
                end
            end
        end)

        ESX.TriggerServerCallback("custommenu:getVipMultForPlate", function(info)
            if answered then return end
            answered = true

            local vipMult = 1.0
            if type(info) == "table" then

                if info.ok == false and info.reason ~= "rate_limited" then
                    local msg = "Le propriétaire du véhicule doit être connecté pour effectuer une customisation."
                    if info.reason == "unregistered" then
                        msg = "Ce véhicule n'est pas enregistré (plaque inconnue)."
                    elseif info.reason == "gang_streettuners" then
                        msg = "RDV au Street Tuners pour custom vos véhicules de groupe !"
                    elseif info.reason == "gang_holder_offline" then
                        msg = "Le membre qui a sorti ce véhicule d'organisation doit être connecté pour payer."
                    end
                    if ESX and ESX.ShowNotification then
                        ESX.ShowNotification("~r~" .. msg)
                    end
                    return
                end
                vipMult = tonumber(info.mult) or 1.0
            elseif type(info) == "number" then
                vipMult = tonumber(info) or 1.0
            end

            if not DoesEntityExist(vehicle) or not IsPedInAnyVehicle(PlayerPedId(), false) then
                return
            end
            FreezeEntityPosition(vehicle, true)
            TriggerServerEvent("custommenu:sessionOpen", plaque, LSC.initialProps)

            SetNuiMecanoContext({
                vehicle = vehicle,
                vehiclePrice = vehiclePrice,
                plaque = plaque,
                oldProps = LSC.oldProps,
                cart = LSC.cart,
                vipPriceMult = vipMult,
                buyFn = LSC.addToCartAndApply,
                onClose = function()
                    closeMecano()
                end
            })
            SendNUIMessage({ action = "open", vehicleName = vehicleName, plate = plaque })
            SetNuiFocus(true, true)
            -- Le jeu continue de recevoir les touches : permet la sortie de
            -- secours (Echap / Retour) meme si l'interface ne repond plus.
            -- Les commandes de deplacement sont neutralisees dans la boucle
            -- de surveillance ci-dessous.
            SetNuiFocusKeepInput(true)
            LSC.menuOpenned = true

            LSC.orbitCam = nil
            LSC.orbitAngle = GetEntityHeading(vehicle) * (3.14159265359 / 180.0)
            NuiOrbitRadius = 3.2
            local orbitHeight = 0.8
            local orbitSpeed = 2.8

            Citizen.CreateThread(function()
                LSC.orbitCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                if not DoesCamExist(LSC.orbitCam) then return end
                local v = vehicle
                while LSC.menuOpenned and GetNuiMecanoContext() and DoesEntityExist(v) do
                    Citizen.Wait(0)
                    local dir = (type(NuiOrbitDirection) == "number") and NuiOrbitDirection or 0
                    if IsControlPressed(0, 174) then dir = -1 end
                    if IsControlPressed(0, 175) then dir = 1 end
                    if dir ~= 0 then
                        LSC.orbitAngle = LSC.orbitAngle + orbitSpeed * 0.012 * dir
                    end
                    local radius = (type(NuiOrbitRadius) == "number") and math.max(2.0, math.min(6.0, NuiOrbitRadius)) or 3.2
                    local coords = GetEntityCoords(v)
                    local camX = coords.x + radius * math.cos(LSC.orbitAngle)
                    local camY = coords.y + radius * math.sin(LSC.orbitAngle)
                    local camZ = coords.z + orbitHeight
                    SetCamCoord(LSC.orbitCam, camX, camY, camZ)
                    PointCamAtEntity(LSC.orbitCam, v, 0.0, 0.0, 0.0, true)
                    if not IsCamRendering(LSC.orbitCam) then
                        SetCamActive(LSC.orbitCam, true)
                        RenderScriptCams(true, false, 0, true, true)
                    end
                end
                if LSC.orbitCam and DoesCamExist(LSC.orbitCam) then
                    SetCamActive(LSC.orbitCam, false)
                    RenderScriptCams(false, false, 0, true, true)
                    DestroyCam(LSC.orbitCam, false)
                    LSC.orbitCam = nil
                end
                RenderScriptCams(false, false, 0, true, true)
            end)

            -- Surveillance a la frame : sortie de secours et neutralisation des
            -- deplacements pendant que le focus NUI laisse passer les touches.
            Citizen.CreateThread(function()
                local escHeldSince = nil
                while LSC.menuOpenned do
                    Wait(0)

                    -- Pas de pause, pas de deplacement, pas de sortie de vehicule.
                    DisableControlAction(0, 200, true)  -- ESC (pause)
                    DisableControlAction(0, 199, true)  -- P (pause)
                    DisableControlAction(0, 75, true)   -- sortir du vehicule
                    DisableControlAction(0, 71, true)   -- accelerer
                    DisableControlAction(0, 72, true)   -- freiner
                    DisableControlAction(0, 59, true)   -- volant
                    DisableControlAction(0, 60, true)
                    DisableControlAction(0, 24, true)   -- attaque / clic
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 37, true)   -- roue des armes
                    DisableControlAction(0, 44, true)   -- couverture

                    -- Sortie de secours : Retour (Backspace) ou Echap maintenu 1 s.
                    if IsDisabledControlJustPressed(0, 194) then
                        closeMecano()
                        break
                    end
                    if IsDisabledControlPressed(0, 200) then
                        escHeldSince = escHeldSince or GetGameTimer()
                        if GetGameTimer() - escHeldSince > 1000 then
                            closeMecano()
                            break
                        end
                    else
                        escHeldSince = nil
                    end
                end
            end)

            Citizen.CreateThread(function()
                while LSC.menuOpenned do
                    Wait(200)

                    if not IsPedInAnyVehicle(PlayerPedId(), false) or not DoesEntityExist(vehicle)
                        or GetVehiclePedIsIn(PlayerPedId(), false) ~= vehicle then
                        closeMecano()
                    end
                end
            end)
        end, plaque)

        return
    end
end

-- Filet de securite : un restart de la ressource pendant une custom ne doit
-- jamais laisser le joueur avec le focus NUI, une camera scriptee ou un
-- vehicule gele.
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    RenderScriptCams(false, false, 0, true, true)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 and DoesEntityExist(veh) then
        FreezeEntityPosition(veh, false)
    end
end)

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end
