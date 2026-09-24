ESX = nil
local InStaffJail = false
local JailTimerThreadRunning = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

JAILSTAFF = {
    ["points"] = {
        ["in"] = {
            {pos = vector3(1687.958252, 2522.106934, 45.564846), heading = 345.23580932617},
        },
		["out"] = {
            {pos = vector3(220.3547, -803.944, 30.83182)},
        },
    },
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterCommand('warn', function(source, args, rawCommand)
    local id = tonumber(args[1])
    local reason = table.concat(args, " ", 2)

    TriggerServerEvent("adminmenu:warn", id, reason)
end, false)

RegisterNetEvent('adminmenu:sendJailTimer')
AddEventHandler('adminmenu:sendJailTimer', function(timetoout, reason)
    InStaffJail = true

    JailStaffTimer(timetoout, reason)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports["pma-voice"]:setRadioChannel(0)

    for k,v in pairs(JAILSTAFF["points"]["in"]) do
        SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
        if v.heading then
            SetEntityHeading(PlayerPedId(), v.heading)
        end
    end
end)

RegisterNetEvent('adminmenu:sendPlayerOutOfJail')
AddEventHandler('adminmenu:sendPlayerOutOfJail', function()

    InStaffJail = false
    JailTimerThreadRunning = false
    for k,v in pairs(JAILSTAFF["points"]["out"]) do
        SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
    end
end)

local function WrapText(text, maxChars)
    local lines = {}
    local current = ""

    for word in text:gmatch("%S+") do
        if #current == 0 then
            current = word
        elseif #current + 1 + #word <= maxChars then
            current = current .. " " .. word
        else
            table.insert(lines, current)
            current = word
        end
    end

    if #current > 0 then
        table.insert(lines, current)
    end

    return lines
end

local jailTotalTime = 0

local function Admin_DrawJailHud(jailTimer, totalTime, reasonLines)

    local pX, pY = 0.5, 0.18
    local pW, pH = 0.30, 0.20
    local pTop = pY - pH * 0.5
    local pBot = pY + pH * 0.5

    DrawRect(pX, pY, pW, pH, 10, 10, 10, 215)

    DrawRect(pX, pTop + 0.001, pW, 0.002, 255, 117, 31, 255)
    DrawRect(pX, pBot - 0.001, pW, 0.002, 255, 117, 31, 255)

    SetTextFont(4)
    SetTextScale(0.0, 0.34)
    SetTextColour(255, 117, 31, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("PRISON ADMIN")
    DrawText(pX, pTop + 0.010)

    SetTextFont(4)
    SetTextScale(0.0, 0.27)
    SetTextColour(138, 138, 138, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("Détention en cours")
    DrawText(pX, pTop + 0.030)

    DrawRect(pX, pTop + 0.052, pW - 0.020, 0.0014, 255, 255, 255, 18)

    local h, m, s = Admin_secondsToClock(jailTimer)
    SetTextFont(7)
    SetTextScale(0.0, 0.85)
    SetTextColour(242, 242, 242, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(string.format("%02d:%02d:%02d", h, m, s))
    DrawText(pX, pTop + 0.060)

    SetTextFont(4)
    SetTextScale(0.0, 0.28)
    SetTextColour(138, 138, 138, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("RAISON")
    DrawText(pX, pTop + 0.117)

    local lineHeight = 0.018
    local reasonY = pTop + 0.135
    for i = 1, math.min(#reasonLines, 2) do
        SetTextFont(4)
        SetTextScale(0.0, 0.32)
        SetTextColour(242, 242, 242, 255)
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(reasonLines[i] or "")
        DrawText(pX, reasonY + (i - 1) * lineHeight)
    end

    local barW = pW - 0.020
    local barH = 0.005
    local barY = pBot - 0.013
    local barLeft = pX - barW * 0.5

    local ratio = (totalTime > 0) and (jailTimer / totalTime) or 0
    if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end

    DrawRect(pX, barY, barW, barH, 28, 28, 28, 255)

    if ratio > 0 then
        local fillW = barW * ratio
        DrawRect(barLeft + fillW * 0.5, barY, fillW, barH, 255, 117, 31, 255)
    end
end

function JailStaffTimer(timetoout, reason)

    if JailTimerThreadRunning then return end
    JailTimerThreadRunning = true

    local jailTimer = ESX.Math.Round(timetoout)
    jailTotalTime = jailTimer
    local updateTimer = 60

    Citizen.CreateThread(function()
        while jailTimer > 0 and InStaffJail do
            Citizen.Wait(1000)
            jailTimer = jailTimer - 1
            updateTimer = updateTimer - 1

            if wintime then
                jailTimer = jailTimer - 5
            end

            if updateTimer <= 0 then
                TriggerServerEvent("adminmenu:updateJailTimeExact", jailTimer)
                updateTimer = 60
            end
        end

        if jailTimer <= 0 and InStaffJail then
            InStaffJail = false
            TriggerServerEvent("adminmenu:getOutJail")

            for k, v in pairs(JAILSTAFF["points"]["out"]) do
                SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
            end
        end

        JailTimerThreadRunning = false
    end)

    Citizen.CreateThread(function()
        local reasonLines = WrapText(reason or "Aucune raison", 36)

        while jailTimer > 0 and InStaffJail do
            Citizen.Wait(0)
            Admin_DrawJailHud(jailTimer, jailTotalTime, reasonLines)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if InStaffJail then
            local player = PlayerPedId()
            local coordsJoueur = GetEntityCoords(PlayerPedId(), true)
            local jp = JAILSTAFF["points"]["in"][1].pos
            local distance = GetDistanceBetweenCoords(jp.x, jp.y, jp.z, coordsJoueur, true)

            if distance > 100 then
                SetEntityCoords(PlayerPedId(), jp.x, jp.y, jp.z)
                local jh = JAILSTAFF["points"]["in"][1].heading
                if jh then SetEntityHeading(PlayerPedId(), jh) end
            end

            if GetSelectedPedWeapon(player) ~= GetHashKey("WEAPON_UNARMED") then
                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
            end

            DisablePlayerFiring(player,true)
            DisableControlAction(2, 37, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 64, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            for i = 157, 164 do
                DisableControlAction(0, i, true)
            end
        end
        if InStaffJail then
            Citizen.Wait(0)
        else
            Citizen.Wait(2500)
        end
    end
end)

function Admin_DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.3)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

RegisterCommand("unjail", function(source, args)
    local id = args[1]

    TriggerServerEvent("adminmenu:admin:getOutJail", id)
end)

exports("inJail", function()
    return InStaffJail
end)

function Admin_secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return hours, mins, secs
end

local JAIL_WARNING_DURATION_MS = 10000
local _jailWarn = { count = 0, remaining = 0, expiresAt = 0, threadRunning = false }

local function _drawJailWarning()
    local now = GetGameTimer()
    local timeLeft = _jailWarn.expiresAt - now
    if timeLeft <= 0 then return end

    local elapsed = JAIL_WARNING_DURATION_MS - timeLeft
    local alpha = 1.0
    if elapsed < 500 then
        alpha = elapsed / 500
    elseif timeLeft < 500 then
        alpha = timeLeft / 500
    end
    if alpha < 0 then alpha = 0 elseif alpha > 1 then alpha = 1 end
    local a = math.floor(alpha * 255)

    local pX, pY = 0.5, 0.16
    local pW, pH = 0.46, 0.13
    local pTop = pY - pH * 0.5
    local pBot = pY + pH * 0.5

    DrawRect(pX, pY, pW, pH, 10, 10, 10, math.floor(alpha * 215))

    DrawRect(pX, pTop + 0.001, pW, 0.003, 230, 40, 40, a)
    DrawRect(pX, pBot - 0.001, pW, 0.003, 230, 40, 40, a)

    SetTextFont(4)
    SetTextScale(0.0, 0.65)
    SetTextColour(230, 40, 40, a)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(("⚠  Attention vous avez %d jails"):format(_jailWarn.count))
    DrawText(pX, pTop + 0.012)

    DrawRect(pX, pTop + 0.062, pW - 0.030, 0.0014, 255, 255, 255, math.floor(alpha * 32))

    SetTextFont(4)
    SetTextScale(0.0, 0.50)
    SetTextColour(255, 117, 31, a)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(("Vous êtes à %d jails du ban permanent"):format(_jailWarn.remaining))
    DrawText(pX, pTop + 0.075)
end

RegisterNetEvent('adminmenu:showJailWarning')
AddEventHandler('adminmenu:showJailWarning', function(count, remaining)
    _jailWarn.count = tonumber(count) or 0
    _jailWarn.remaining = tonumber(remaining) or 0
    _jailWarn.expiresAt = GetGameTimer() + JAIL_WARNING_DURATION_MS

    if _jailWarn.threadRunning then return end
    _jailWarn.threadRunning = true

    Citizen.CreateThread(function()
        while GetGameTimer() < _jailWarn.expiresAt do
            Citizen.Wait(0)
            _drawJailWarning()
        end
        _jailWarn.threadRunning = false
    end)
end)
