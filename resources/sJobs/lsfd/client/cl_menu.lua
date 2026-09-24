Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

LSFD["myClothes"] = {}
LSFD.onDuty = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = job.grade_name
end)

LSFD.openCentral = function()
    RMenu.Add('lsfd', 'central', RageUI.CreateMenu('LSFD - Centrale', 'Feux en cours', 1, 100))
    RMenu:Get('lsfd', 'central').Closed = function()
        LSFD['menuOpenned'] = false
        RMenu:Delete('lsfd', 'central')
    end

    if LSFD['menuOpenned'] then
        LSFD['menuOpenned'] = false
        return
    else
        RageUI.CloseAll()
        LSFD['menuOpenned'] = true
        RageUI.Visible(RMenu:Get('lsfd', 'central'), true)
    end

    for name, menu in pairs(RMenu['lsfd']) do
        RMenu:Get('lsfd', name):SetRectangleBanner(255, 106, 0, 140)
    end

    TriggerServerEvent('lsfd:requestDutyState')

    if not activeFiresClient then activeFiresClient = {} end

    Citizen.CreateThread(function()
        while LSFD['menuOpenned'] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('lsfd', 'central'), true, false, true, function()
                local hasFires = false

                local dutyTxt = LSFD.onDuty and "~g~EN SERVICE" or "~y~HORS SERVICE"
                RageUI.Separator(("Statut: %s"):format(dutyTxt))

                RageUI.ButtonWithStyle(LSFD.onDuty and "Quitter le service" or "Prendre son service",
                "Active/désactive votre service LSFD. Le spawn auto des feux dépend de ce statut.",
                {}, true, function(_, _, Selected)
                    if Selected then
                        TriggerServerEvent('lsfd:setDuty', not LSFD.onDuty)
                    end
                end)

                RageUI.ButtonWithStyle("Appeler la fourrière",
                "Signale votre position aux agents de la fourrière en service.",
                { RightLabel = "🚛" }, true, function(_, _, Selected)
                    if Selected then
                        TriggerServerEvent("sJobs.callFourriere")
                        LSFD['menuOpenned'] = false
                        RageUI.CloseAll()
                    end
                end)

                for fireId, fireData in pairs(activeFiresClient) do
                    if not fireData.hide then
                        hasFires = true
                        local loc = fireData.location

                        local streetHash = GetStreetNameAtCoord(loc.x, loc.y, loc.z)
                        local streetName = "Inconnu"
                        if streetHash ~= 0 then
                            streetName = GetStreetNameFromHashKey(streetHash)
                        end

                        local intensity = fireData.intensity or 1

                        local buttonLabel = string.format("Feu #%d - %s - Gravité: %d", fireId, streetName, intensity)
                        RageUI.ButtonWithStyle(buttonLabel, "ENTRER pour mettre un point GPS", {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SetNewWaypoint(loc.x, loc.y)
                                ESX.ShowNotification("~y~GPS positionné sur le feu n°" .. fireId)
                            end
                        end)
                    end
                end

                if not hasFires then
                    RageUI.Separator("~r~Aucun incendie en cours...")
                end
            end)
        end
    end)
end

RegisterCommand("openCentralLSFD", function()
    if not (ESX.PlayerData.job.name == "lsfd") then return end
    LSFD.openCentral()
end, false)

RegisterKeyMapping("openCentralLSFD", "Ouvrir le menu LSFD", "keyboard", "F6")

RegisterNetEvent('lsfd:dutyState')
AddEventHandler('lsfd:dutyState', function(state)
    LSFD.onDuty = state and true or false
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(LSFD.onDuty and "~g~Vous prenez votre service" or "~y~Vous quittez votre service")
    end
    if LSFD.onDuty then
        TriggerServerEvent('kxFires:sendActiveFires')
    else

    end
end)
