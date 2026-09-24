isStaffMode, serverInteraction = false,false

RegisterNetEvent("adminmenu:cbStaffState")
AddEventHandler("adminmenu:cbStaffState", function(isStaff)
    isStaffMode = isStaff
    serverInteraction = false
    DecorSetBool(PlayerPedId(), "isStaffMode", isStaffMode)
    if not isStaffMode then
        ForceDeactivateNoclip()
        showNames(false)
        isNameShown = false
        blipsActive = false
        TriggerEvent("adminhud:toggle", false)
        exports['esx_skin']:GetCachedSkin(function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    else
        Citizen.CreateThread(function()
           while isStaffMode do
               Citizen.Wait(30 * 1000)
               TriggerServerEvent("adminhud:requestData")
           end
        end)
    end
end)
