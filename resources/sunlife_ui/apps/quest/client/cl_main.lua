local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'quest', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'quest', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('quest/' .. name, cb)
end

ESX = exports['es_extended']:getSharedObject()

local questUIOpen = false

RegisterCommand("quete", function()
    if questUIOpen then return end
    openQuestUI()
end, false)
RegisterKeyMapping("quete", "Ouvrir les quêtes", "keyboard", "")

function openQuestUI()
    if questUIOpen then return end
    questUIOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "open" })
end

function closeQuestUI()
    if not questUIOpen then return end
    questUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
end

RegisterNUICallback("close", function(_, cb)
    closeQuestUI()
    cb("ok")
end)

RegisterNUICallback("getData", function(_, cb)
    ESX.TriggerServerCallback("snl_quest:getData", function(data)
        cb(data)
    end)
end)

RegisterNUICallback("getLeaderboard", function(_, cb)
    ESX.TriggerServerCallback("snl_quest:getLeaderboard", function(data)
        cb(data)
    end)
end)

RegisterNetEvent("snl_quest:questCompleted")
AddEventHandler("snl_quest:questCompleted", function(questId, money, xp, totalXp)
    SendNUIMessage({
        type = "questCompleted",
        questId = questId,
        money = money,
        xp = xp,
        totalXp = totalXp,
    })

    ESX.ShowAdvancedNotification("~o~Quêtes", "SunLife", "Quête complétée ! +$" .. money .. " | +" .. xp .. " XP", "CHAR_SUNLIFE", 8)
end)

exports('completeQuest', function(questId)
    TriggerServerEvent("snl_quest:triggerComplete", questId)
end)
