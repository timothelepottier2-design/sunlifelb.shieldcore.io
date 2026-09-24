local WASH_POINT <const> = {
    pos     = vec3(91.280640, -1603.840332, 30.895018),
    heading = 233.0647277832,
}

local MARKER_Z_OFFSET <const> = -0.80

local PED_MODEL <const> = `ig_money`

local washerPed = nil

Citizen.CreateThread(function()
    local v = WASH_POINT.pos
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, 207)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    local _key = "BN_SCORE_WASH_1_" .. tostring(blip)
    AddTextEntry(_key, "Blanchiment")
    BeginTextCommandSetBlipName(_key)
    EndTextCommandSetBlipName(blip)
end)

local function SpawnWasherPed()
    if washerPed and DoesEntityExist(washerPed) then return end

    RequestModel(PED_MODEL)
    local timeout = 0
    while not HasModelLoaded(PED_MODEL) and timeout < 5000 do
        Wait(10); timeout = timeout + 10
    end
    if not HasModelLoaded(PED_MODEL) then return end

    washerPed = CreatePed(
        4, PED_MODEL,
        WASH_POINT.pos.x, WASH_POINT.pos.y, WASH_POINT.pos.z - 1.0,
        WASH_POINT.heading,
        false, true
    )
    SetEntityInvincible(washerPed, true)
    SetBlockingOfNonTemporaryEvents(washerPed, true)
    FreezeEntityPosition(washerPed, true)
    SetPedDiesWhenInjured(washerPed, false)
    SetPedCanRagdoll(washerPed, false)
    SetPedFleeAttributes(washerPed, 0, false)
    TaskStartScenarioInPlace(washerPed, "WORLD_HUMAN_SMOKING", 0, true)
    SetModelAsNoLongerNeeded(PED_MODEL)
end

local function DespawnWasherPed()
    if washerPed and DoesEntityExist(washerPed) then
        DeleteEntity(washerPed)
    end
    washerPed = nil
end

AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() then
        DespawnWasherPed()
    end
end)

local pos, quantity = nil, 0
local open = false

Citizen.CreateThread(function()
    RMenu.Add('moneywash', 'main', RageUI.CreateMenu("SunLife", "Menu Blanchisseur", 1, 100))
    RMenu:Get('moneywash', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('moneywash', 'main').EnableMouse = false
    RMenu:Get('moneywash', 'main').Closed = function()
        open = false
    end
end)

local function openMenu()
    if open then
        return
    end
    open = true
    RageUI.Visible(RMenu:Get('moneywash', 'main'), true)
    pos = GetEntityCoords(PlayerPedId())

    Citizen.CreateThread(function()
        while open do
            RageUI.IsVisible(RMenu:Get('moneywash', 'main'), true, true, true, function()
                RageUI.Separator("Pourcentage du blanchisseur: ~o~25%")

                RageUI.ButtonWithStyle("Montant à blanchir: ~o~", nil, {RightLabel = "~o~"..quantity.. " $"}, true, function(Hovered, Active, Selected)
					if Selected then
						local input = lib.inputDialog("Blanchiment d'argent", {
                            {type = "number", label = "Montant à blanchir", placeholder = "Entrez le montant", min = 1, max = 100001}
                        })

                        if input and input[1] then
                            local montant = tonumber(input[1])
                            if montant and montant > 0 then
                                quantity = montant
                            else
                                ESX.ShowNotification("Montant invalide.")
                            end
                        end
					end
				end)

                RageUI.Separator()

                RageUI.ButtonWithStyle("Débuter le blanchiment", nil, {RightLabel = "~o~"..quantity.. " $"}, true, function(Hovered, Active, Selected)
					if Selected then
                        ESX.TriggerServerCallback("sCore.checkMoney", function(hasMoney)
                            if hasMoney then

                                local timer = math.min(30000, math.max(5000, quantity * 0.20))
                                local success = lib.progressCircle({
                                    duration = timer,
                                    useWhileDead = false,
                                    canCancel = true,
                                    label = "⌛ Blanchiment en cours...",
                                    disable = {
                                        car = true,
                                        move = true,
                                        combat = true,
                                    }
                                })
                                if success then
                                    TriggerServerEvent("sCore.moneyWash", quantity)
                                else
                                    ESX.ShowNotification("Vous avez annulé le blanchiment.")
                                end
                            else
                                ESX.ShowNotification("Vous n'avez pas l'argent nécessaire.")
                            end
                        end, quantity, "black_money")
					end
				end)
            end, function()
            end)
            if not RageUI.Visible(RMenu:Get('moneywash', 'main')) then
                open = false
                pos = nil
                break
            end

            if pos and #(GetEntityCoords(PlayerPedId()) - pos) > 4.0 then
                RageUI.CloseAll()
            end
            Wait(0)
        end
    end)
end

local function markerMoneyWash(data)

    DrawMarker(
        6,
        data.coords.x, data.coords.y, data.coords.z + MARKER_Z_OFFSET,
        nil, nil, nil,
        -90, nil, nil,
        1.5, 1.5, 1.5,
        255, 117, 31, 225,
        false, false
    )

    if data.currentDistance < 3.0 then
        ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler avec le ~o~blanchisseur")
        if IsControlJustPressed(1, 38) then
            openMenu()
        end
    end
end

local function initWashMoney()
    lib.points.new({
        coords   = WASH_POINT.pos,
        distance = 50.0,
        onEnter = function(self)
            SpawnWasherPed()
        end,
        onExit = function(self)
            DespawnWasherPed()
        end,
        nearby = function(self)
            markerMoneyWash({coords = self.coords, currentDistance = self.currentDistance})
        end,
    })
end

Citizen.CreateThread(function()
    initWashMoney()
end)
