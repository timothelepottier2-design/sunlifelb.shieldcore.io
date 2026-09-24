local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'staffui', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'staffui', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('staffui/' .. name, cb)
end

local ADMINHUD_VISIBLE = true

RegisterNetEvent("adminhud:set", function(data)
    local function num(v, fallback)
        local n = tonumber(v)
        return n or fallback or 0
    end

    local serverWantsOn = staffMode and (data and data.on ~= false)

    local payload = {
        action    = "adminhud:set",
        on        = serverWantsOn,

        reports   = num(data and data.reports, 0),
        staffs    = num(data and data.staffs,  0)
    }

    SendNUIMessage(payload)

end)

staffMode = false
RegisterNetEvent("adminmenu:cbStaffState")
AddEventHandler("adminmenu:cbStaffState", function(isStaff)
    staffMode = isStaff
end)

RegisterCommand('adminhud_toggle', function()
    if not staffMode then return end
    TriggerEvent('adminhud:toggle')
end, false)
RegisterKeyMapping('adminhud_toggle', 'Afficher/Cacher le HUD Staff', 'keyboard', 'H')

RegisterNetEvent("adminhud:toggle", function(on)
    print("adminhud:toggle", on)
    local show = on
    if show == nil then show = not ADMINHUD_VISIBLE end
    ADMINHUD_VISIBLE = show and true or false

    SendNUIMessage({
        action = "adminhud:toggle",
        on     = ADMINHUD_VISIBLE
    })
end)

CreateThread(function()
    Wait(100)
    SetNuiFocus(false, false)

end)
