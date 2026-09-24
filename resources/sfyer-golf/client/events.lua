-- This file is made for developpers who wants to adapt their server/hud with the script
-- Please create an event handler for these events if you want to do some actions in others scripts

-- Scaleform (UI) relative events
RegisterNetEvent('scriptifyer-golf:client:enteringPlayingMode') -- Showing main UI
RegisterNetEvent('scriptifyer-golf:client:exitingPlayingMode')
RegisterNetEvent('scriptifyer-golf:client:enteringMobileScoreboard')
RegisterNetEvent('scriptifyer-golf:client:exitingMobileScoreboard')

-- Game state events
RegisterNetEvent('scriptifyer-golf:client:startingGolf') 
RegisterNetEvent('scriptifyer-golf:client:endingGolf')
RegisterNetEvent('scriptifyer-golf:client:finishedHole')

--Utils
RegisterNetEvent('scriptifyer-golf:client:openMenu') -- Open main menu (create parties, ...)
RegisterNetEvent('scriptifyer-golf:client:closeMenu') -- Close main menu (create parties, ...)
RegisterNetEvent('scriptifyer-golf:client:initializeBall') -- Event when ball is initializing
RegisterNetEvent('scriptifyer-golf:client:enterPlayingMode') -- Event when player is entering playing mode

--[[ Example : 
AddEventHandler('scriptifyer-golf:client:enteringPlayingMode', function ()
    -- Do anything you want
end)]]