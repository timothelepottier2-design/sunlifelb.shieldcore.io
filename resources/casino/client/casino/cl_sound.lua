-- Disable invisible peds speeches
SetAmbientZoneStatePersistent("iz_vw_dlc_casino_main_rm_gamingfloor_01", false, true)
SetAmbientZoneStatePersistent("iz_vw_dlc_casino_main_rm_gamingfloor_02", false, true)
SetAmbientZoneStatePersistent("iz_vw_dlc_casino_main_rm_gamingfloor_03", false, true)
-- SetAmbientZoneStatePersistent(ambientZone, p1, p2)
-- SetAmbientZoneStatePersistent(ambientZone, p1, p2)

Citizen.CreateThread(function()
    Citizen.Wait(10 * 1000)
    local casinoCoords = vector3(1114.41, 228.13, -50.82)

    while true do
        while #(GetEntityCoords(PlayerPedId()) - casinoCoords) > 100.0 do Citizen.Wait(1000) end
        
        -- Request audio banks
        RequestScriptAudioBank('DLC_VINEWOOD\\CASINO_GENERAL', false)
        RequestScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_01', false)
        RequestScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_02', false)
        RequestScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_03', false)

        -- Wait for table objects to exist
        while #(GetEntityCoords(PlayerPedId()) - casinoCoords) < 100.0 and not DoesEntityExist(GetClosestObjectOfType(1129.406, 262.3578, -52.041, 1.0, `vw_prop_casino_blckjack_01b`, 0, 0, 0)) do Citizen.Wait(1000) end
        
        if #(GetEntityCoords(PlayerPedId()) - casinoCoords) < 100.0 then
            -- Change high stake blackjack table skin
            local blackjackTable = GetClosestObjectOfType(1129.406, 262.3578, -52.041, 1.0, `vw_prop_casino_blckjack_01b`, 0, 0, 0)
            SetObjectTextureVariant(blackjackTable,3)
            blackjackTable = GetClosestObjectOfType(1145.329, 248.067, -51.0357,1.0, `vw_prop_casino_blckjack_01b`, 0, 0, 0)
            SetObjectTextureVariant(blackjackTable,3)
            
            -- Change high stake 3 card poker table skin
            local threeCardPoker = GetClosestObjectOfType(1132.912, 265.862, -51.035, 1.0, `vw_prop_casino_3cardpoker_01b`, 0, 0, 0)
            SetObjectTextureVariant(threeCardPoker,3)
            threeCardPoker = GetClosestObjectOfType(1147.906, 250.8641, -51.035, 1.0, `vw_prop_casino_3cardpoker_01b`, 0, 0, 0)
            SetObjectTextureVariant(threeCardPoker,3)
        end
        
        while #(GetEntityCoords(PlayerPedId()) - casinoCoords) < 100.0 do Citizen.Wait(1000) end
        
        -- Release audio banks
        ReleaseScriptAudioBank('DLC_VINEWOOD\\CASINO_GENERAL', 0)
        ReleaseScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_01', 0)
        ReleaseScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_02', 0)
        ReleaseScriptAudioBank('DLC_VINEWOOD\\CASINO_SLOT_MACHINES_03', 0)
    end
end)