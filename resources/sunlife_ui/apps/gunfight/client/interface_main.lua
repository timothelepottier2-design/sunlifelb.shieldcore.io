local Config = GunInterfaceConfig

local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'gunfight', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'gunfight', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('gunfight/' .. name, cb)
end

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 306, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local IsNotification, IsHolder, IsTextUI, isRequestMenu = false, false, false, false
local onClose, onSubmit, onCancel, blur = nil, nil, nil, false
local onAccept, onDecline = nil, nil

function Notification(text, duration, ntype)
    if IsNotification then return end
    if text == nil or type(text) ~= "string" then if Config.Debug then print('Text cannot be loaded') end return end
    if type(duration) ~= 'number' or duration == nil then duration = Config.DefaultNotificationDuration end
    if type(ntype) ~= 'string' or ntype == nil then ntype = 'info' end

    SendNUIMessage({ type = 'Notification', text = text, duration = duration, ntype = ntype })
    IsNotification = true
end

RegisterNUICallback('hideNotif', function(data, cb)
    IsNotification = false
end)

function HolderButton(option)
    if IsHolder then return end
    if option.key == nil then if Config.Debug then print('Key cannot be loaded') end return end
    if type(option.duration) ~= 'number' or option.duration == nil then option.duration = Config.DefaultDuration end
    SendNUIMessage({ type = 'showHolder', key = option.key })
    local progress = 0
    local startTime = 0
    local isHolding = false
    IsHolder = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlPressed(0, Keys[option.key]) then
                if not isHolding then
                    startTime = GetGameTimer()
                    isHolding = true
                end
                local currentTime = GetGameTimer()
                local deltaTime = currentTime - startTime
                progress = progress + deltaTime / option.duration
                startTime = currentTime
                if progress >= 1 then
                    progress = 0
                    isHolding = false
                    IsHolder = false
                    SendNUIMessage({ type = 'hideHolder' })
                    option.onFinish()
                    break
                end
            elseif isHolding then
                local currentTime = GetGameTimer()
                local deltaTime = currentTime - startTime
                progress = progress - deltaTime / option.duration
                startTime = currentTime
                if progress <= 0 then
                    progress = 0
                    isHolding = false
                    IsHolder = false
                end
            end
            SendNUIMessage({ type = 'updateHolder', progress = progress })
        end
    end)
end

function HideHolder()
    IsHolder = false
    SendNUIMessage({ type = 'hideHolder' })
end

function ShowTextUI(option)
    if option.key == nil or type(option.key) ~= 'string' then if Config.Debug then print('Key cannot be loaded') end return end
    if option.label == nil or type(option.label) ~= 'string' then if Config.Debug then print('Label cannot be loaded') end return end
    if type(option.onPress) ~= 'function' then if Config.Debug then print('onPress cannot be loaded') end return end
    IsTextUI = true
    SendNUIMessage({ type = "showTextUI", key = option.key, label = option.label })
    Citizen.CreateThread(function ()
        while IsTextUI and option.onPress() do
            Citizen.Wait(0)
            if IsControlJustReleased(0, Keys[option.key]) then
                SendNUIMessage({ type = "hideTextUI" })
                IsTextUI = false
                option.onPress();
                break
            end
        end
    end)
end

function HideTextUI()
    IsTextUI = false
    SendNUIMessage({ type = "hideTextUI" })
end

function Request(option)
    if isRequestMenu then return end
    if option.title == nil or type(option.title) ~= 'string' then if Config.Debug then print('Title cannot be loaded') end return end
    if option.text == nil or type(option.text) ~= 'string' then if Config.Debug then print('Text cannot be loaded') end return end
    if option.keys == nil or type(option.keys) ~= 'table' then if Config.Debug then print('Keys Table cannot be loaded') end return end
    if option.duration == nil or type(option.duration) ~= 'number' then option.duration = Config.DefaultDuration end

    onAccept = option.onAccept
    onDecline = option.onDecline

    option.onDecline = nil
    option.onAccept = nil
    isRequestMenu = true
    Citizen.CreateThread(function ()
        while isRequestMenu do
            Citizen.Wait(0)
            if IsControlJustReleased(0, Keys[option.keys.accept]) then
                SendNUIMessage({ type = "hideRequestMenu" })
                isRequestMenu = false
                onAccept()
                break
            end
            if IsControlJustReleased(0, Keys[option.keys.decline]) then
                SendNUIMessage({ type = "hideRequestMenu" })
                isRequestMenu = false
                onDecline()
                break
            end
        end
    end)
    SendNUIMessage({ type = 'requestMenu', data = option })
end

RegisterNUICallback('RequestExpired', function(data, cb)
    isRequestMenu = false
end)

function RegisterMenu(option)
    if option.id == nil or type(option.id) ~= 'string' then if Config.Debug then print('Id cannot be loaded') end return end
    if option.title == nil or type(option.title) ~= 'string' then if Config.Debug then print('Title cannot be loaded') end return end
    if option.buttons == nil or type(option.buttons) ~= 'table' then if Config.Debug then print('Buttons cannot be loaded') end return end
    if option.blurBg == nil then option.blurBg = false blur = false end
    if option.blurBg then
        blur = true
        StartScreenEffect('MenuMGIn', 1, true)
    end
    onClose  = option.onClose
    onSubmit = option.onSubmit
    onCancel = option.onCancel

    option.onClose = nil
    option.onSubmit = nil
    option.onCancel = nil

    SendNUIMessage({ type = 'registerMenu', data = option })
end

function ShowMenu(id)
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "showMenu", id = id })
end

function HideMenu(id)
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "hideMenu", id = id })
end

RegisterNUICallback('onCloseMenu', function(data, cb)
    SetNuiFocus(false, false)
    if blur then
        StopScreenEffect('MenuMGIn')
    end
    if onClose ~= nil then
        onClose()
    end
end)

RegisterNUICallback('onSubmitMenu', function(data, cb)
    SetNuiFocus(false, false)
    if blur then
        StopScreenEffect('MenuMGIn')
    end
    if onSubmit ~= nil then
        onSubmit(data.args, data.input)
    end
end)

RegisterNUICallback('onCancelMenu', function(data, cb)
    SetNuiFocus(false, false)
    if blur then
        StopScreenEffect('MenuMGIn')
    end
    if onCancel ~= nil then
        onCancel()
    end
end)

RegisterNUICallback('getConfig', function()
    SendNUIMessage({ type = 'setupConfig', Config = Config})
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    StopScreenEffect('MenuMGIn')
end)

exports('Notification', Notification)
exports('Holder', HolderButton)
exports('HideHolder', HideHolder)
exports('ShowTextUI', ShowTextUI)
exports('HideTextUI', HideTextUI)
exports('Request', Request)
exports('RegisterMenu', RegisterMenu)
exports('ShowMenu', ShowMenu)
exports('HideMenu', HideMenu)

RegisterNetEvent('jale_interface:Notification')
AddEventHandler('jale_interface:Notification', function(text, duration, ntype)
    Notification(text, duration, ntype)
end)

RegisterNetEvent('jale_interface:Holder')
AddEventHandler('jale_interface:Holder', function(option)
    HolderButton(option)
end)

RegisterNetEvent('jale_interface:HideHolder')
AddEventHandler('jale_interface:HideHolder', function(option)
    HideHolder()
end)

RegisterNetEvent('jale_interface:ShowTextUI')
AddEventHandler('jale_interface:ShowTextUI', function(option)
    ShowTextUI(option)
end)

RegisterNetEvent('jale_interface:HideTextUI')
AddEventHandler('jale_interface:HideTextUI', function(option)
    HideTextUI()
end)

RegisterNetEvent('jale_interface:Request')
AddEventHandler('jale_interface:Request', function(option)
    Request(option)
end)

RegisterNetEvent('jale_interface:RegisterMenu')
AddEventHandler('jale_interface:RegisterMenu', function(option)
    RegisterMenu(option)
end)

RegisterNetEvent('jale_interface:ShowMenu')
AddEventHandler('jale_interface:ShowMenu', function(id)
    ShowMenu(id)
end)

RegisterNetEvent('jale_interface:HideMenu')
AddEventHandler('jale_interface:HideMenu', function(id)
    HideMenu(id)
end)
