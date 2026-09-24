ESX = nil
local playerJob = nil
local nomMetier = nil
local JobTable = {}
local metierNom = nil
local DansUneZone = false
local VestiaireOpen = false
local blipsCreated = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    grade = PlayerData.job.grade_name

    RMenu.Add('menu', 'vestiaire', RageUI.CreateMenu("SunLife", "Vestiaire", 1, 100))
    RMenu.Add('menu', 'mestenues', RageUI.CreateSubMenu(RMenu:Get('menu', 'vestiaire'), "SunLife", "Vestiaire"))
    RMenu.Add('menu', 'options', RageUI.CreateSubMenu(RMenu:Get('menu', 'mestenues'), "SunLife", "Vestiaire"))
    RMenu:Get('menu', 'vestiaire'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'mestenues'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'options'):SetRectangleBanner(255, 117, 31, 225)

    RMenu:Get('menu', 'vestiaire').EnableMouse = false
    RMenu:Get('menu', 'vestiaire').Closed = function()
        VestiaireOpen = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

    for k,v in pairs(jobs) do
        if ESX.PlayerData.job.name == v.metier then
            JobTable = v
            if playerJobGrade == "boss" then
                local blip = AddBlipForCoord(JobTable.actionPatron)
                SetBlipSprite(blip, 85)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 0)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(JobTable.blips_info.actionPatron.name)
                EndTextCommandSetBlipName(blip)

                table.insert(blipsCreated, blip)
            end

            if JobTable.coffre then
                local blip = AddBlipForCoord(JobTable.coffre)
                SetBlipSprite(blip, 85)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 0)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName("Coffre: "..JobTable.metierMaj)
                EndTextCommandSetBlipName(blip)

                table.insert(blipsCreated, blip)
            end

            local blip = AddBlipForCoord(JobTable.recolte.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone récolte: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)

            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.traitement.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone traitement: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)

            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.vente.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone vente: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)

            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.garage.garagePos)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)

            table.insert(blipsCreated, blip)

            metierNom = v.metier
        end
    end
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job

    for k,v in pairs(blipsCreated) do
        RemoveBlip(v)
    end

    local found = false
    for k,v in pairs(jobs) do
        if ESX.PlayerData.job.name == v.metier then
            JobTable = v
            found = true
            if playerJobGrade == "boss" then
                local blip = AddBlipForCoord(JobTable.actionPatron)
                SetBlipSprite(blip, 85)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 0)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(JobTable.blips_info.actionPatron.name)
                EndTextCommandSetBlipName(blip)
                table.insert(blipsCreated, blip)
            end

            if JobTable.coffre then
                local blip = AddBlipForCoord(JobTable.coffre)
                SetBlipSprite(blip, 85)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 0)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName("Coffre: "..JobTable.metierMaj)
                EndTextCommandSetBlipName(blip)
                table.insert(blipsCreated, blip)
            end

            local blip = AddBlipForCoord(JobTable.recolte.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone récolte: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)
            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.traitement.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone traitement: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)
            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.vente.zone)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Zone vente: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)
            table.insert(blipsCreated, blip)

            local blip = AddBlipForCoord(JobTable.garage.garagePos)
            SetBlipSprite(blip, 85)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..JobTable.metierMaj)
            EndTextCommandSetBlipName(blip)
            table.insert(blipsCreated, blip)

            metierNom = v.metier
        end
    end

    if not found then
        JobTable = {}
    end
end)

local function mergeFarmCacheIntoJobs(cache)
    if type(cache) ~= "table" then return false end
    if not jobs then jobs = {} end

    local existing = {}
    for _, v in pairs(jobs) do
        if v and v.metier then existing[v.metier] = true end
    end

    local added = 0
    for _, v in pairs(cache) do
        if v and v.metier and not existing[v.metier] then
            table.insert(jobs, v)
            existing[v.metier] = true
            added = added + 1
        end
    end
    return added > 0
end

RegisterNetEvent("farm:serv:client")
AddEventHandler("farm:serv:client", function(cache)
    local changed = mergeFarmCacheIntoJobs(cache)
    if not changed then return end

    if ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name then
        local currentJob = ESX.PlayerData.job.name
        for _, v in pairs(jobs) do
            if v.metier == currentJob and (not JobTable or JobTable.metier ~= currentJob) then
                TriggerEvent("esx:affiliateJob", ESX.PlayerData.job)
                break
            end
        end
    end
end)

CreateThread(function()
    while ESX == nil do Wait(100) end
    Wait(1000)
    TriggerServerEvent("farm:serv:getFarm")
end)

local EnAction = false

local SLEEP_FAR  = 1500
local SLEEP_NEAR = 0

local function showHelp(text)
    ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour " .. text)
end

local function pressedE()
    return IsControlJustReleased(1, 38)
end

Citizen.CreateThread(function()
    while ESX == nil do Wait(100) end
    local sleep = SLEEP_FAR

    while true do
        Wait(sleep)
        sleep = SLEEP_FAR

        if not JobTable.metier or EnAction then
            goto continue
        end

        local pPed    = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        if JobTable.actionPatron then
            local d = #(pCoords - JobTable.actionPatron)
            if d <= 5.0 then
                sleep = SLEEP_NEAR
                DrawMarker(20, JobTable.actionPatron.x, JobTable.actionPatron.y, JobTable.actionPatron.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 117, 31, 225, 1, 0, 2, 1, nil, nil, 0)
                if d <= 3.0 then
                    showHelp("ouvrir les actions patron")
                    if pressedE() then
                        OpenPatronMenu(JobTable.metier, JobTable.washMoney)
                    end
                end
                goto continue
            end
        end

        if JobTable.recolte and JobTable.recolte.zone then
            local d = #(pCoords - JobTable.recolte.zone)
            if d <= 10.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.recolte.zone.x, JobTable.recolte.zone.y, JobTable.recolte.zone.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                showHelp("~o~recolter")
                if pressedE() then
                    StartRecolte(JobTable.recolte)
                end
                goto continue
            end
        end

        if JobTable.traitement and JobTable.traitement.zone then
            local d = #(pCoords - JobTable.traitement.zone)
            if d <= 10.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.traitement.zone.x, JobTable.traitement.zone.y, JobTable.traitement.zone.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                showHelp("~o~traiter")
                if pressedE() then
                    StartTraitement(JobTable.traitement)
                end
                goto continue
            end
        end

        if JobTable.vente and JobTable.vente.zone then
            local d = #(pCoords - JobTable.vente.zone)
            if d <= 10.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.vente.zone.x, JobTable.vente.zone.y, JobTable.vente.zone.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                showHelp("~o~vendre")
                if pressedE() then
                    StartVente(JobTable.vente, nomMetier)
                end
                goto continue
            end
        end

        if JobTable.garage and JobTable.garage.garagePos then
            local d = #(pCoords - JobTable.garage.garagePos)
            if d <= 5.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.garage.garagePos.x, JobTable.garage.garagePos.y, JobTable.garage.garagePos.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                if d <= 2.0 then
                    showHelp("ouvrir le ~o~garage")
                    if pressedE() then
                        OpenGarageMenu(JobTable.garage.vehicule, JobTable.garage.pointDeSpawn,
                            JobTable.garage.xenon, JobTable.garage.fullCustom,
                            JobTable.garage.color1, JobTable.garage.color2)
                    end
                end
                goto continue
            end
        end

        if JobTable.vestiaire then
            local d = #(pCoords - JobTable.vestiaire)
            if d <= 5.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.vestiaire.x, JobTable.vestiaire.y, JobTable.vestiaire.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                if d <= 2.0 then
                    showHelp("ouvrir le ~o~vestiaire")
                    if pressedE() then
                        TriggerEvent("snl_clothesshop:openVestiaire")
                    end
                end
                goto continue
            end
        end

        if JobTable.coffre then
            local d = #(pCoords - JobTable.coffre)
            if d <= 5.0 then
                sleep = SLEEP_NEAR
                DrawMarker(25, JobTable.coffre.x, JobTable.coffre.y, JobTable.coffre.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
                if d <= 2.0 then
                    showHelp("ouvrir le ~o~coffre")
                    if pressedE() then
                        TriggerEvent("coffres:openCoffre", ESX.PlayerData.job.name)
                    end
                end
            end
        end

        ::continue::
    end
end)

local function runProgress(label, scenario)
    local pPed = PlayerPedId()
    FreezeEntityPosition(pPed, true)
    if scenario then
        TaskStartScenarioInPlace(pPed, scenario, 0, true)
    end
    TriggerEvent("vehicle_inventory:closeAll")

    local success = lib.progressCircle({
        duration     = 25000,
        label        = label,
        useWhileDead = false,
        canCancel    = false,
        disable      = { car = true, move = true, combat = true },
    })

    if scenario then
        ClearPedTasksImmediately(pPed)
    end
    FreezeEntityPosition(pPed, false)
    TriggerEvent("vehicle_inventory:closeAll")
    return success
end

function StartRecolte(info)
    if EnAction then return end
    Citizen.CreateThread(function()
        EnAction = true
        local pPed    = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        if #(pCoords - info.zone) > 10.0 then
            ESX.ShowNotification("~r~Vous etes trop loin du point !")
            EnAction = false
            return
        end
        if IsPedInAnyVehicle(pPed, true) then
            ESX.ShowNotification("~r~Vous ne pouvez pas recolter dans un vehicule !")
            EnAction = false
            return
        end

        if runProgress("⌛ Recolte en cours...", "WORLD_HUMAN_GARDENER_PLANT") then
            TriggerServerEvent("rEntreprise:GiveItem", info.item, info.limit)
        end
        EnAction = false
    end)
end

function StartTraitement(info)
    if EnAction then return end
    Citizen.CreateThread(function()
        EnAction = true
        local pPed    = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        if #(pCoords - info.zone) > 10.0 then
            ESX.ShowNotification("~r~Vous etes trop loin du point !")
            EnAction = false
            return
        end
        if IsPedInAnyVehicle(pPed, true) then
            ESX.ShowNotification("~r~Vous ne pouvez pas traiter dans un vehicule !")
            EnAction = false
            return
        end

        if runProgress("⌛ Traitement en cours...", nil) then
            TriggerServerEvent("rEntreprise:EchangeItem",
                info.item, info.itemTraite, info.limit, info.item_required, info.give)
        end
        EnAction = false
    end)
end

function StartVente(info, society)
    if EnAction then return end
    Citizen.CreateThread(function()
        EnAction = true
        local pPed    = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        if #(pCoords - info.zone) > 5.0 then
            ESX.ShowNotification("~r~Vous etes trop loin du point !")
            EnAction = false
            return
        end
        if IsPedInAnyVehicle(pPed, true) then
            ESX.ShowNotification("~r~Vous ne pouvez pas vendre dans un vehicule !")
            EnAction = false
            return
        end

        if runProgress("⌛ Vente en cours...", nil) then
            TriggerServerEvent("rEntreprise:VenteItem", info.itemVente, 0, metierNom, info.item_required)
        end
        EnAction = false
    end)
end

function openVestiaireMenu()
    local elements = {}
    local cache = {}
    cache.value = null
    ESX.TriggerServerCallback('entreprises:getPlayerDressing', function(dressing)
        for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
        end
    end)

    if VestiaireOpen then
        VestiaireOpen = false
        return
    else
        VestiaireOpen = true
        RageUI.Visible(RMenu:Get('menu', 'vestiaire'), true)

        Citizen.CreateThread(function()
            while VestiaireOpen do
                Wait(0)
                RageUI.IsVisible(RMenu:Get('menu', 'vestiaire'), true, true, true, function()
                    RageUI.ButtonWithStyle("Mes tenues", nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                    end, RMenu:Get('menu', 'mestenues'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'mestenues'), true, true, true, function()
                    for k, v in pairs(elements) do
                        RageUI.ButtonWithStyle(v.label, nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                cache.value = v.value
                            end
                        end, RMenu:Get('menu', 'options'))
                    end
                end, function()
				end)

                RageUI.IsVisible(RMenu:Get('menu', 'options'), true, true, true, function()
                    RageUI.ButtonWithStyle("Mettre la tenue", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                ESX.TriggerServerCallback('entreprises:getPlayerOutfit', function(clothes)
                                    TriggerEvent('skinchanger:loadClothes', skin, clothes)
                                    TriggerEvent('ESX_skin:setLastSkin', skin)

                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerServerEvent('ESX_skin:save', skin)
                                    end)
                                end, cache.value)
                            end)
                        end
                    end)
                end, function()
				end)
            end
        end)
    end
end

function OpenPatronMenu(metier, wash)
    if ESX.PlayerData.job.grade_name == 'boss' then
        TriggerEvent('esx_society:openBosstozMenu', metier, function(data, menu)
        end)
        ESX.UI.Menu.CloseAll()
    end
end

function isFarmOpenned()
	return EnAction
end
