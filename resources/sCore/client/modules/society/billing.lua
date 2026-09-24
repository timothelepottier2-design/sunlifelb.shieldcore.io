local paidBills = {}
local PAID_BILLS_MAX = 100

exports("getPaidBills", function()
    return paidBills
end)

local function saveBillCache(jobName, amount)
    if not jobName or not amount then
        return
    end

    paidBills[#paidBills + 1] = {
        jobLabel = jobName,
        amount = amount
    }

    if #paidBills > PAID_BILLS_MAX then
        table.remove(paidBills, 1)
    end
end

RegisterNetEvent("sCore.sendBill", function(jobName)
    if not jobName then
        return
    end

    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    local closestPlayer = lib.getClosestPlayer(playerCoords, 3.0)

    if not closestPlayer then
        ESX.ShowNotification("~r~Aucun joueur à proximité.")
        return
    end

    local targetServerId = GetPlayerServerId(closestPlayer)
    if not targetServerId then
        return
    end

    local input = lib.inputDialog("Facturation", {
        {type = "number", label = "Montant à facturer", icon = "dollar-sign", required = true, min = 1}
    })
    if not input or not input[1] then
        ESX.ShowNotification("~r~Facturation annulée.")
        return
    end

    local amount = tonumber(input[1])
    if not amount or amount <= 0 then
        ESX.ShowNotification("~r~Montant invalide.")
        return
    end

    TriggerServerEvent("sCore.submitBill", targetServerId, jobName, amount)
end)

RegisterNetEvent("sCore.validBill", function(playerTarget, playerSource, jobName, amount, billId)
    if not playerTarget or not playerSource or not jobName or not amount or not billId then
        return
    end

    ESX.ShowAdvancedNotification("Portefeuille", "~b~Nouvelle facture !", "~b~Société:~s~\n" ..jobName.. "\n~b~Montant:~s~\n " ..amount.. "\n\nE pour ~g~accepter~s~ | X pour ~r~refuser~s~", "CHAR_BANK_FLEECA", 8)

    Citizen.CreateThread(function()
        local timer = 0

        while true do
            timer = timer + 1
            if timer > 450 then
                TriggerServerEvent("sCore.declineBill", playerSource, billId)
                break
            end

            if IsControlPressed(0, 38) then
                saveBillCache(jobName, amount)

                TriggerServerEvent("sCore.payBill", playerTarget, playerSource, amount, jobName, billId)
                TriggerEvent("sound:play", "caching", 0.20)
                break
            elseif IsControlPressed(0, 252) then
                TriggerServerEvent("sCore.declineBill", playerSource, billId)
                break
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterCommand("facturee", function()
    TriggerEvent("sCore.sendBill", "kebab")
end)
