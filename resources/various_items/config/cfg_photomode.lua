Config_Photomode = {}

Config_Photomode.MaxDistanceFromPlayer = 30.0 -- Max distance from player to camera
Config_Photomode.ShowIconAbovePlayersInPhotomode = true

Config_Photomode.CheckJob = false  -- Activate job check
Config_Photomode.CheckGroup = false  -- Activate user group check
Config_Photomode.CheckVIP = true  -- Activate VIP check

-- List of jobs authorized to use photo mode (if CheckJob is enabled)
Config_Photomode.AllowedJobs = {'police', 'ambulance'}

-- List of groups authorized to use photo mode (if CheckGroup is enabled)
Config_Photomode.AllowedGroups = {'admin', 'gerant', 'mod'}

-- Notification Config_Photomodeuration
Config_Photomode.NotificationType = 'esx' -- Can be 'esx', 'qb', or 'custom'.

-- Check for updates
Config_Photomode.CheckForUpdates = false -- Check for updates

-- Message to display when a player does not have permission to use the command
Config_Photomode.NoPermissionMessage = "Vous n'avez pas la permission d'utiliser cette commande car vous n'êtes pas VIP !"

Config_Photomode.HideCommandTip = true -- Hide the "Press [e]" text

-- Function Triggered when a player enter photomode
-- You can use this function to toggle off your HUD
function Config_Photomode.EnteredPhotomode()

end

-- Function Triggered when a player exit photomode
-- You can use this function to toggle on your HUD
function Config_Photomode.ExitedPhotomode()

end


-- Function Server Side
-- This function currently returns false for all players.
-- To implement VIP checks, you need to edit this function to include the logic for determining if a player is a VIP.
-- Replace the 'return false' line with the appropriate VIP check logic.
function Config_Photomode.IsPlayerVIP(source)
    -- Add your VIP check logic here
    return false
end

function Config_Photomode.SendNotification(source, message)
    if Config_Photomode.NotificationType == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
    elseif Config_Photomode.NotificationType == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, 'error')
    elseif Config_Photomode.NotificationType == 'custom' then
        -- If the user wants to use his own notification system
        -- He can add a function here for his notifications
        -- Example: TriggerClientEvent('custom_notify', source, message, 'error')
    end
end