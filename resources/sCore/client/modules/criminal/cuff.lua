isCuff = false
local cuffThread = false

local function cuffLoop()
    if cuffThread then
        return
    end
    cuffThread = true

    Citizen.CreateThread(function()
        local animDict <const> = "mp_arresting"
        local animName <const> = "idle"

        loadDict(animDict)

        while isCuff do
            local ped = PlayerPedId()
            DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(2, 1, true)
			DisableControlAction(2, 2, true)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, 45, true)
			DisableControlAction(2, 27, true)
			DisableControlAction(2, 22, true)
			DisableControlAction(2, 44, true)
			DisableControlAction(2, 37, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 0, true)
			DisableControlAction(2, 199, true)
			DisableControlAction(2, 59, true)
			DisableControlAction(2, 36, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)

            if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                TaskPlayAnim(ped, animDict, animName, 8.0, -8, -1, 49, 0, false, false, false)
            end

            Wait(0)
        end

        cuffThread = false
    end)
end

RegisterNetEvent("sCore.mainCuff", function()
    isCuff = not isCuff
    local ped = PlayerPedId()

    Citizen.CreateThread(function()
        if isCuff then
            local animDict <const> = "mp_arresting"
            local animName <const> = "idle"

            loadDict(animDict)
            TaskPlayAnim(ped, animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetEnableHandcuffs(ped, true)
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(ped, false)
            DisplayRadar(false)

            cuffLoop()
        else
            ClearPedSecondaryTask(ped)
            SetEnableHandcuffs(ped, false)
            DisablePlayerFiring(PlayerId(), false)
            SetPedCanPlayGestureAnims(ped,  true)
            DisplayRadar(true)
        end
    end)
end)
