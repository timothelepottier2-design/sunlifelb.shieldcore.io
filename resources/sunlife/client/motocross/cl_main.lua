local ped = {
    pos = vector4(-153.623108, 2669.049072, 56.300602, 60.914260864258),
    model = "a_m_y_roadcyc_01",
    label = "Jordy",
    dstInteract = 3.0,
}

local spawnPoints = {
    moto = { coords = vector3(-157.496002, 2670.590332, 56.113998), heading = 175.38305664062, model = 'sanchez' },
    dirt = { coords = vector3(-157.496002, 2670.590332, 56.113998), heading = 175.38305664062, model = 'manchez' },
}

local motocrossMenuOpen = false

local function rentMoto(vehicleType)
    ESX.TriggerServerCallback('motocross:rentVehicle', function(success, msg)
        if not success then
            ESX.ShowNotification("~r~Location impossible : " .. (msg or "Erreur"))
            return
        end

        local spawnInfo = spawnPoints[vehicleType]
        if not spawnInfo then
            ESX.ShowNotification("~r~Erreur de spawn")
            return
        end

        TriggerServerEvent('eye:veh:authorize', spawnInfo.model, 'location')
        ESX.Game.SpawnVehicle(spawnInfo.model, spawnInfo.coords, spawnInfo.heading, function(veh)
            SetVehicleNumberPlateText(veh, "CROSS " .. math.random(100, 999))
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            ESX.ShowNotification(("~g~%s louée avec succès"):format(spawnInfo.model))

            local startPos = spawnInfo.coords
            CreateThread(function()
                while DoesEntityExist(veh) do
                    Wait(5000)
                    local currentPos = GetEntityCoords(veh)
                    local dist = #(currentPos - startPos)
                    if dist > 1000.0 then
                        ESX.ShowNotification("~r~Vous êtes trop loin, le véhicule est repris")
                        DeleteEntity(veh)
                        break
                    end
                end
            end)
        end)
    end, vehicleType)
end

function locateMoto()
    rentMoto('moto')
end

function locateDirt()
    rentMoto('dirt')
end

Citizen.CreateThread(function()
    RMenu.Add('motocross', 'main', RageUI.CreateMenu("Location motocross", "Choisissez un véhicule"))
    RMenu:Get('motocross', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('motocross', 'main').Closed = function()
        motocrossMenuOpen = false
    end
end)

local function OpenMotocrossMenu()
    if motocrossMenuOpen then
        return
    end
    motocrossMenuOpen = true
    RageUI.Visible(RMenu:Get('motocross', 'main'), true)
    CreateThread(function()
        while motocrossMenuOpen do
            RageUI.IsVisible(RMenu:Get('motocross', 'main'), true, true, true, function()
                RageUI.ButtonWithStyle("Louer une Moto-cross (10,000$)", "", { RightLabel = "🏁" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        locateMoto()
                    end
                end)
                RageUI.ButtonWithStyle("Louer une Dirt bike (30,000$)", "", { RightLabel = "🏁" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        locateDirt()
                    end
                end)
            end, function()
            end)
            Wait(0)
        end
    end)
end

local circuitBlipPos <const> = vector3(1043.545166, 2340.679199, 52.379627)

Citizen.CreateThread(function()
    local circuit = AddBlipForCoord(circuitBlipPos.x, circuitBlipPos.y, circuitBlipPos.z)
    SetBlipSprite(circuit, 596)
    SetBlipDisplay(circuit, 4)
    SetBlipScale(circuit, 0.8)
    SetBlipColour(circuit, 5)
    SetBlipAsShortRange(circuit, true)

    AddTextEntry("BN_SUNLIFE_CIRCUIT_SENORA", "Circuit de Grand Senora")
    BeginTextCommandSetBlipName("BN_SUNLIFE_CIRCUIT_SENORA")
    EndTextCommandSetBlipName(circuit)
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(ped.pos.x, ped.pos.y, ped.pos.z)
    SetBlipSprite(blip, 348)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)

    AddTextEntry("BN_SUNLIFE_MOTOCROSS_1", "Circuit & Location motocross")
    BeginTextCommandSetBlipName("BN_SUNLIFE_MOTOCROSS_1")
    EndTextCommandSetBlipName(blip)

    while true do
        local interval = 1000
        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)
        local dst = #(vector3(ped.pos.x, ped.pos.y, ped.pos.z) - pCoords)

        if dst < 30.0 then
            interval = 0
            ESX.Game.Utils.DrawText3D(vector3(ped.pos.x, ped.pos.y, ped.pos.z + 0.95), "~y~" .. ped.label, 0.8, 1)

            if not DoesEntityExist(ped.entity) then
                local model = GetHashKey(ped.model)
                if not HasModelLoaded(model) then
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                end

                ped.entity = CreatePed(1, model, ped.pos.x, ped.pos.y, ped.pos.z - 1.0, ped.pos.a, false, false)
                SetEntityHeading(ped.entity, ped.pos.a)
                SetEntityInvincible(ped.entity, true)
                SetBlockingOfNonTemporaryEvents(ped.entity, true)
                FreezeEntityPosition(ped.entity, true)
            end

            if dst < ped.dstInteract then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler à ~y~" .. ped.label)
                if IsControlJustPressed(0, 38) then
                    OpenMotocrossMenu()
                end
            end
        else
            if DoesEntityExist(ped.entity) then
                DeleteEntity(ped.entity)
                ped.entity = nil
            end
        end

        Citizen.Wait(interval)
    end
end)
