local currentShield = false
local shieldEntity, initialWeapon = nil, nil
local allowWeapons <const> = {
    GetHashKey("WEAPON_PISTOL"),
    GetHashKey("WEAPON_COMBATPISTOL"),
    GetHashKey("WEAPON_APPISTOL"),
    GetHashKey("WEAPON_PISTOL50"),
    GetHashKey("WEAPON_HKUSP"),
    GetHashKey("WEAPON_357")
}

local function shieldAnimLoop()
    Citizen.CreateThread(function()
        while currentShield do
            local ped = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(ped)

            if currentWeapon ~= initialWeapon then
                ESX.ShowNotification("~r~Vous avez changé d'arme, le bouclier est désactivé.")
                currentShield = false
                if shieldEntity and DoesEntityExist(shieldEntity) then
                    DeleteEntity(shieldEntity)
                end
                shieldEntity = nil
                ClearPedTasksImmediately(ped)
                SetWeaponAnimationOverride(ped, GetHashKey("Default"))
                return
            end

            if not IsEntityPlayingAnim(ped, "combat@gestures@gang@pistol_1h@beckon", "0", 3) then
                TaskPlayAnim(ped, "combat@gestures@gang@pistol_1h@beckon", "0", 8.0, -8.0, -1, 50, 0.0, false, false, false)
            end
            Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("sCore.usableShield", function(propName)
    if not propName then
        return
    end

    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped, false)
    local selectedWeapon = GetSelectedPedWeapon(ped)

    local canActive = false
    for i = 1, #allowWeapons do
        if selectedWeapon == allowWeapons[i] then
            canActive = true
            break
        end
    end
    if not canActive then
        return ESX.ShowNotification("~r~Vous devez avoir un pistolet en main !")
    end

    if not currentShield then
        currentShield = true
        initialWeapon = selectedWeapon

        loadDict("combat@gestures@gang@pistol_1h@beckon")
        TaskPlayAnim(ped, "combat@gestures@gang@pistol_1h@beckon", "0", 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

        loadModel(propName)

        print(('^2[NETDIAG][OBJET]^7 %s shield.lua:67 CreateObject NETWORKED prop=%s'):format(GetCurrentResourceName(), tostring(propName)))
        shieldEntity = CreateObject(GetHashKey(propName), playerCoords.x, playerCoords.y, playerCoords.z, 1, 1, 1)
        AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
        SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))

        shieldAnimLoop()
    else
        currentShield = false
        if shieldEntity and DoesEntityExist(shieldEntity) then
            DeleteEntity(shieldEntity)
        end
        shieldEntity = nil
        ClearPedTasksImmediately(ped)
        SetWeaponAnimationOverride(ped, GetHashKey("Default"))
    end
end)
