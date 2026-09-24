local starterMenuOpen = false

local STARTER_POS = vector3(-1201.444458, -184.352875, 39.324883)
local STARTER_HEADING = 133.68348693848
local STARTER_INTERACT_DIST = 2.5

Citizen.CreateThread(function()
    while ESX == nil do Wait(100) end

    RMenu.Add('snl_starter', 'main', RageUI.CreateMenu("SunLife", "Choisir un starter", 1, 100))
    RMenu:Get('snl_starter', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('snl_starter', 'main').EnableMouse = false
    RMenu:Get('snl_starter', 'main').Closed = function()
        starterMenuOpen = false
    end
end)

local function openStarterMenu()
    if starterMenuOpen then return end
    starterMenuOpen = true
    RageUI.Visible(RMenu:Get('snl_starter', 'main'), true)

    Citizen.CreateThread(function()
        while starterMenuOpen do
            RageUI.IsVisible(RMenu:Get('snl_starter', 'main'), true, true, true, function()
                RageUI.ButtonWithStyle("Starter Légal", "~g~100 000$ ~s~| Chaise verte | 5 Sandwichs | 5 Eaux | 1 BMX", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        starterMenuOpen = false
                        TriggerServerEvent("snl_starter:claim", "legal")
                    end
                end)
                RageUI.ButtonWithStyle("Starter Illégal", "~r~100 000$ sale ~s~| Menotte | Chips | Coca | 1 BMX", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        starterMenuOpen = false
                        TriggerServerEvent("snl_starter:claim", "illegal")
                    end
                end)
            end, function() end)
            Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local nearStarter = false
        local playerPos = GetEntityCoords(PlayerPedId())
        local dist = #(playerPos - STARTER_POS)

        if dist < STARTER_INTERACT_DIST then
            nearStarter = true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour choisir un starter")
            if IsControlJustReleased(1, 38) then
                openStarterMenu()
            end
        end

        if nearStarter then
            Wait(0)
        else
            Wait(1000)
        end
    end
end)
