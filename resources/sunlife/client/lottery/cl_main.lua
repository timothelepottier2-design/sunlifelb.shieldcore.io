Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    RMenu.Add('LOTTERY', 'main_menu', RageUI.CreateMenu("SunLife", "Loterie", 1, 100))

    RMenu:Get('LOTTERY', 'main_menu'):SetRectangleBanner(255, 117, 31, 225)
    RMenu.Add('LOTTERY', 'main_menu_register', RageUI.CreateSubMenu(RMenu:Get('LOTTERY', 'main_menu'), "SunLife", "Loterie"))
    RMenu:Get('LOTTERY', 'main_menu_register'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('LOTTERY', 'main_menu').Closed = function()
        LOTTERY.openned = false
    end
end)

LOTTERY = {}
LOTTERY.nickname              = 'Inconnu'
LOTTERY.paymentClass          = 1
LOTTERY.selectedPaymentLabel  = "Carte Bancaire"
LOTTERY.ticketsToBuy          = 1
LOTTERY.opening               = false

LOTTERY.scheduleLabel         = "Tous les dimanches à 23h59"
LOTTERY.pot                   = 0
LOTTERY.myTickets             = 0
LOTTERY.maxTicketsPerPlayer   = 10
LOTTERY.ticketPrice           = 50000
LOTTERY.ticketContribution    = 40000
LOTTERY.basePot               = 1000000

local function GroupDigits(value)
	value = tostring(tonumber(value) or 0)
	local left, num = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
	if not left then return value end
	return left..(num:reverse():gsub('(%d%d%d)','%1' .. " "):reverse())
end

local function clampTicketsToBuy()
    local remaining = math.max(0, LOTTERY.maxTicketsPerPlayer - LOTTERY.myTickets)
    if remaining <= 0 then
        LOTTERY.ticketsToBuy = 0
    else
        if LOTTERY.ticketsToBuy < 1 then LOTTERY.ticketsToBuy = 1 end
        if LOTTERY.ticketsToBuy > remaining then LOTTERY.ticketsToBuy = remaining end
    end
end

LOTTERY.initMenu = function()
    if LOTTERY.openned then
        LOTTERY.openned = false
        return
    end
    if LOTTERY.opening then return end
    LOTTERY.opening = true

    Citizen.SetTimeout(5000, function()
        if LOTTERY.opening then
            LOTTERY.opening = false
            ESX.ShowNotification("~r~La loterie ne répond pas, réessaye dans un instant.")
        end
    end)

    ESX.TriggerServerCallback("lottery:getLotteryData", function(data)
        LOTTERY.opening = false
        if type(data) ~= 'table' then
            ESX.ShowNotification("~r~Erreur loterie : réponse serveur invalide.")
            return
        end

        LOTTERY.scheduleLabel       = data.scheduleLabel       or LOTTERY.scheduleLabel
        LOTTERY.pot                 = data.pot                 or 0
        LOTTERY.myTickets           = data.myTickets           or 0
        LOTTERY.maxTicketsPerPlayer = data.maxTicketsPerPlayer or LOTTERY.maxTicketsPerPlayer
        LOTTERY.ticketPrice         = data.ticketPrice         or LOTTERY.ticketPrice
        LOTTERY.ticketContribution  = data.ticketContribution  or LOTTERY.ticketContribution
        LOTTERY.basePot             = data.basePot             or LOTTERY.basePot

        clampTicketsToBuy()

        LOTTERY.openned = true
        RageUI.Visible(RMenu:Get('LOTTERY', 'main_menu'), true)

        Citizen.CreateThread(function()
            while LOTTERY.openned do

                RageUI.IsVisible(RMenu:Get('LOTTERY', 'main_menu'), true, true, true, function()
                    RageUI.ButtonWithStyle("~y~Tirage : "..tostring(LOTTERY.scheduleLabel), nil, {}, true)
                    RageUI.ButtonWithStyle("~y~Cagnotte actuelle : "..GroupDigits(LOTTERY.pot).." $", nil, {}, true)
                    RageUI.ButtonWithStyle("~y~Mes tickets : "..LOTTERY.myTickets.." / "..LOTTERY.maxTicketsPerPlayer, nil, {}, true)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle(
                        "Acheter des tickets",
                        "Prix : "..GroupDigits(LOTTERY.ticketPrice).." $ par ticket  (max "..LOTTERY.maxTicketsPerPlayer.."/joueur)",
                        {}, true,
                        function(_, _, s) end,
                        RMenu:Get('LOTTERY', 'main_menu_register')
                    )
                end)

                RageUI.IsVisible(RMenu:Get('LOTTERY', 'main_menu_register'), true, true, true, function()
                    local remaining = math.max(0, LOTTERY.maxTicketsPerPlayer - LOTTERY.myTickets)
                    local totalCost = LOTTERY.ticketsToBuy * LOTTERY.ticketPrice

                    RageUI.Separator("Achat de tickets")

                    RageUI.ButtonWithStyle("Mode de paiement", nil, {RightLabel = LOTTERY.selectedPaymentLabel}, true, function(_, _, Selected)
                        if Selected then
                            local input = lib.inputDialog('Mode de Paiement', {
                                {
                                    type = 'select',
                                    label = 'Choisissez un mode',
                                    required = true,
                                    options = {
                                        { value = 1, label = 'Carte Bancaire' },
                                        { value = 2, label = 'Liquide' }
                                    }
                                }
                            })
                            if input and input[1] then
                                LOTTERY.paymentClass = input[1]
                                LOTTERY.selectedPaymentLabel = (input[1] == 1) and "Carte Bancaire" or "Liquide"
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Prénom/Nom", nil, {RightLabel = LOTTERY.nickname}, true, function(_, _, s)
                        if s then
                            local input = lib.inputDialog('Nom RP', {
                                { type = 'input', label = "Entrez votre prénom & nom", required = true }
                            })
                            if input and input[1] and input[1] ~= '' then
                                LOTTERY.nickname = tostring(input[1])
                            else
                                ESX.ShowNotification("~r~Nom invalide.")
                            end
                        end
                    end)

                    RageUI.Separator("")

                    if remaining <= 0 then
                        RageUI.ButtonWithStyle("~r~Limite atteinte", "Tu as déjà acheté le maximum ("..LOTTERY.maxTicketsPerPlayer..") de tickets pour ce tirage.", {}, true)
                    else
                        RageUI.ButtonWithStyle("Nombre de tickets",
                            "Choisis combien de tickets tu veux acheter (1 à "..remaining..")",
                            {RightLabel = tostring(LOTTERY.ticketsToBuy)},
                            true,
                            function(_, _, s)
                                if s then
                                    local input = lib.inputDialog("Nombre de tickets", {
                                        { type = 'number', label = "Combien de tickets ?", min = 1, max = remaining, default = LOTTERY.ticketsToBuy }
                                    })
                                    if input and input[1] then
                                        local n = math.floor(tonumber(input[1]) or 0)
                                        if n >= 1 and n <= remaining then
                                            LOTTERY.ticketsToBuy = n
                                        else
                                            ESX.ShowNotification(("~r~Choisis un nombre entre 1 et %d."):format(remaining))
                                        end
                                    end
                                end
                            end
                        )

                        RageUI.ButtonWithStyle("Coût total", nil, {RightLabel = GroupDigits(totalCost).." $"}, true)

                        RageUI.Separator("")

                        RageUI.ButtonWithStyle("~y~Je participe", nil, {}, true, function(_, _, s)
                            if s then
                                if LOTTERY.nickname == 'Inconnu' or LOTTERY.nickname == '' then
                                    ESX.ShowNotification("~r~Mets d'abord ton prénom/nom RP.")
                                    return
                                end
                                local n = LOTTERY.ticketsToBuy
                                ESX.TriggerServerCallback('lottery:buyTickets', function(ok, errMsg, newMyTickets, newPot)
                                    if ok then
                                        LOTTERY.myTickets = newMyTickets or (LOTTERY.myTickets + n)
                                        LOTTERY.pot       = newPot       or (LOTTERY.pot + n * LOTTERY.ticketContribution)
                                        clampTicketsToBuy()
                                        ESX.ShowNotification(("~g~%d ticket(s) acheté(s) ! ~s~Tirage : %s"):format(n, LOTTERY.scheduleLabel))
                                        if LOTTERY.myTickets >= LOTTERY.maxTicketsPerPlayer then
                                            RageUI.GoBack()
                                        end
                                    else
                                        ESX.ShowNotification("~r~"..tostring(errMsg or "Achat refusé."))
                                    end
                                end, LOTTERY.nickname, n, LOTTERY.paymentClass)
                            end
                        end)
                    end
                end)

                if not RageUI.Visible(RMenu:Get('LOTTERY', 'main_menu')) and not RageUI.Visible(RMenu:Get('LOTTERY', 'main_menu_register')) then
                    LOTTERY.openned = false
                    break
                end
                Wait(0)
            end
        end)
    end)
end

LOTTERY.pos     = vec3(1088.441040, 221.463974, -49.200466)
LOTTERY.heading = 183.31631469727

local PED_MODELS = { `s_m_y_casino_01`, `a_m_y_business_03` }

local lotteryPed = nil

local function SpawnLotteryPed()
    if lotteryPed and DoesEntityExist(lotteryPed) then return end

    local chosen = nil
    for _, model in ipairs(PED_MODELS) do
        if IsModelInCdimage(model) and IsModelValid(model) then
            chosen = model
            break
        end
    end
    if not chosen then return end

    RequestModel(chosen)
    local timeout = 0
    while not HasModelLoaded(chosen) and timeout < 5000 do
        Wait(10); timeout = timeout + 10
    end
    if not HasModelLoaded(chosen) then return end

    lotteryPed = CreatePed(
        4, chosen,
        LOTTERY.pos.x, LOTTERY.pos.y, LOTTERY.pos.z - 1.0,
        LOTTERY.heading,
        false, true
    )
    SetEntityInvincible(lotteryPed, true)
    SetBlockingOfNonTemporaryEvents(lotteryPed, true)
    FreezeEntityPosition(lotteryPed, true)
    SetPedDiesWhenInjured(lotteryPed, false)
    SetPedCanRagdoll(lotteryPed, false)
    SetPedFleeAttributes(lotteryPed, 0, false)
    TaskStartScenarioInPlace(lotteryPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    SetModelAsNoLongerNeeded(chosen)
end

local function DespawnLotteryPed()
    if lotteryPed and DoesEntityExist(lotteryPed) then
        DeleteEntity(lotteryPed)
    end
    lotteryPed = nil
end

AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() then
        DespawnLotteryPed()
    end
end)

Citizen.CreateThread(function()
    AddTextEntry("BN_LOTTERY", "Loterie")
    local blip = AddBlipForCoord(LOTTERY.pos.x, LOTTERY.pos.y, LOTTERY.pos.z)
    SetBlipSprite(blip, 117)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.85)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("BN_LOTTERY")
    EndTextCommandSetBlipName(blip)
end)

local function nearbyLottery(data)

    if data.currentDistance < 2.0 then
        if not LOTTERY.openned then
            ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour ouvrir le menu de la loterie")
            if IsControlJustPressed(1, 38) and not LOTTERY.opening then
                LOTTERY.initMenu()
            end
        end
    end
end

local function initLottery()
    lib.points.new({
        coords   = LOTTERY.pos,
        distance = 50.0,
        onEnter  = function(self) SpawnLotteryPed() end,
        onExit   = function(self) DespawnLotteryPed() end,
        nearby   = function(self)
            nearbyLottery({
                coords          = self.coords,
                currentDistance = self.currentDistance,
            })
        end
    })
end

Citizen.CreateThread(function()
    initLottery()
end)
