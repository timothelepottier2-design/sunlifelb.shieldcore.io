CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false
local dontSync = false
local freezeWeather = false
local realTime = false
local currentWarmthLvl = 0

local timeWeatherMenuOpen = false

local TimePresets = {
    { label = "Matin (08:00)", hour = 8, minute = 0 },
    { label = "Midi (12:00)", hour = 12, minute = 0 },
    { label = "Après-midi (16:00)", hour = 16, minute = 0 },
    { label = "Soir (20:00)", hour = 20, minute = 0 },
    { label = "Nuit (00:00)", hour = 0, minute = 0 }
}

local WeatherPresets = {
    { label = "Grand soleil", value = "EXTRASUNNY" },
    { label = "Ensoleillé", value = "CLEAR" },
    { label = "Nuageux", value = "CLOUDS" },
    { label = "Pluie", value = "RAIN" },
    { label = "Orage", value = "THUNDER" },
    { label = "Brouillard", value = "FOGGY" },
    { label = "Temps clair (nuit)", value = "CLEARING" },
    { label = "Neige (XMAS)", value = "XMAS" }
}

local timePresetIndex = 1
local weatherPresetIndex = 1

local timePresetLabels = {}
for i, v in ipairs(TimePresets) do
    timePresetLabels[i] = v.label
end

local weatherPresetLabels = {}
for i, v in ipairs(WeatherPresets) do
    weatherPresetLabels[i] = v.label
end

if cfg_meteo.RealTimeAlways then
    TriggerServerEvent('0r-time:setRealtime')
end

local function KeyboardInputTimeWeather(title, defaultText, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText or "", "", "", "", maxLength or 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    local res = GetOnscreenKeyboardResult()
    if res then return res end
    return ""
end

local function OpenTimeWeatherMenu()
    if timeWeatherMenuOpen then
        print("Closing time & weather menu")
        timeWeatherMenuOpen = false
        RageUI.CloseAll()
        return
    end

    print("Opening time & weather menu")

    RageUI.CloseAll()
    timeWeatherMenuOpen = true

    if RMenu['timeweather'] then
        for name,_ in pairs(RMenu['timeweather']) do
            RMenu:Delete('timeweather', name)
        end
    end

    RMenu.Add('timeweather', 'main', RageUI.CreateMenu("Météo & Temps", "Gestion du monde", 1375, 100))
    local menu = RMenu:Get('timeweather', 'main')
    menu:SetRectangleBanner(255, 220, 0, 140)

    menu.Closed = function()
        timeWeatherMenuOpen = false
    end

    RageUI.Visible(menu, true)

    Citizen.CreateThread(function()
        while timeWeatherMenuOpen do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('timeweather', 'main'), true, true, true, function()
                local h = GetClockHours()
                local m = GetClockMinutes()
                local timeLabel = string.format("%02d:%02d", h, m)

                RageUI.Separator("Temps")

                RageUI.List("Préréglages heure", timePresetLabels, timePresetIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                    timePresetIndex = Index
                    if Selected then
                        local preset = TimePresets[timePresetIndex]
                        if preset then
                            TriggerServerEvent("0r-time:setTime", {
                                hour = preset.hour,
                                minute = preset.minute
                            })
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Heure actuelle (manuel)", nil, {RightLabel = timeLabel}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local inputHour = KeyboardInputTimeWeather("Heure (0-23)", tostring(h), 2)
                        local hour = tonumber(inputHour)
                        if not hour or hour < 0 or hour > 23 then
                            return
                        end
                        local inputMinute = KeyboardInputTimeWeather("Minutes (0-59)", string.format("%02d", m), 2)
                        local minute = tonumber(inputMinute)
                        if not minute or minute < 0 or minute > 59 then
                            return
                        end
                        TriggerServerEvent("0r-time:setTime", {
                            hour = hour,
                            minute = minute
                        })
                    end
                end)

                RageUI.ButtonWithStyle("Temps figé", nil, {RightLabel = freezeTime and "~g~Activé" or "~r~Désactivé"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("0r-time:setFreezetime")
                    end
                end)

                RageUI.ButtonWithStyle("Temps réel", nil, {RightLabel = realTime and "~g~Activé" or "~r~Désactivé"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("0r-time:setRealtime")
                    end
                end)

                RageUI.Separator("Météo")

                RageUI.List("Préréglages météo", weatherPresetLabels, weatherPresetIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                    weatherPresetIndex = Index
                    if Selected then
                        local preset = WeatherPresets[weatherPresetIndex]
                        if preset and preset.value then
                            TriggerServerEvent("0r-time:setWeather", preset.value)
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Météo actuelle (manuel)", nil, {RightLabel = tostring(CurrentWeather)}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local input = KeyboardInputTimeWeather("Type météo (CLEAR, EXTRASUNNY, RAIN...)", CurrentWeather, 20)
                        if input and input ~= "" then
                            TriggerServerEvent("0r-time:setWeather", string.upper(input))
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Météo figée", nil, {RightLabel = freezeWeather and "~g~Activée" or "~r~Désactivée"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('0r-time:setFreezeweather')
                    end
                end)

                RageUI.ButtonWithStyle("Blackout", nil, {RightLabel = blackout and "~g~Activé" or "~r~Désactivé"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('0r-time:setBlackout')
                    end
                end)
            end)
        end
    end)
end

RegisterNetEvent('0r-time:setTime:open')
AddEventHandler('0r-time:setTime:open', function()
    print("Opening time & weather menu")
    OpenTimeWeatherMenu()
end)

RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(0, 0)
    menuIsOpen = false
end)

if cfg_meteo.RealTimeAlways then
    TriggerServerEvent('0r-time:setRealtime')
end

RegisterNetEvent('0r-time:setTime:area_tool')
AddEventHandler('0r-time:setTime:area_tool', function()
    menuIsOpen = true
    SendNUIMessage({ action = "area_tool" })
    SetNuiFocus(1, 1)
end)

RegisterNUICallback("setBlackout", function(data, cb)
    TriggerServerEvent('0r-time:setBlackout')
end)

RegisterNUICallback("getCoord", function(data, cb)
   coords = GetEntityCoords(GetPlayerPed(-1))
   return cb("vector2("..coords.x..", "..coords.y..")")
end)

RegisterNUICallback("setRealtime", function(data, cb)
    TriggerServerEvent('0r-time:setRealtime')
end)

RegisterNUICallback("setFreezetime", function(data, cb)
    TriggerServerEvent('0r-time:setFreezetime')
end)

RegisterNUICallback("setFreezeweather", function(data, cb)
    TriggerServerEvent('0r-time:setFreezeweather')
end)

RegisterNUICallback("setWeather", function(data, cb)
    TriggerServerEvent('0r-time:setWeather', data.time)
end)

RegisterNUICallback("setTime", function(data, cb)
   TriggerServerEvent('0r-time:setTime', data)
end)

RegisterNetEvent('0r-time:updateWeather')
AddEventHandler('0r-time:updateWeather', function(NewWeather, newblackout, newfreezeWeather, newrealtime)
    if dontSync == false then
        CurrentWeather = NewWeather
        blackout = newblackout
        freezeWeather = newfreezeWeather
        realTime = newrealtime

    end
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(500)
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('0r-time:updateTime')
AddEventHandler('0r-time:updateTime', function(base, offset, freeze)
    if dontSync == false then
        freezeTime = freeze
        timeOffset = offset
        baseTime = base
    end
    if menuIsOpen == true then
        SendNUIMessage({ action = "update", date = GetDate() })
    end
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(1000)
        local newBaseTime = baseTime

        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.5
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime

        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('0r-time:requestSync')
end)

RegisterNetEvent('0r-time:notify')
AddEventHandler('0r-time:notify', function(message)
    SendNUIMessage({ action = "message", message = message })
end)

zoneList = {}

Citizen.CreateThread(function()
    for k,v in pairs(cfg_meteo.ZoneList) do
        c = {}
        c.zone = PolyZone:Create(v.coords, v.opts)
        c.name = v.name
        c.time = v.time
        c.weather = v.weather
        table.insert(zoneList, c)
    end
end)

GetDate = function()
  return {
    dayoftheweek = GetClockDayOfWeek(),
    dayofthemonth = GetClockDayOfMonth(),
    hour = GetClockHours(),
    min = GetClockMinutes(),
    month = GetClockMonth(),
    sec = GetClockSeconds(),
    year = GetClockYear(),
    weather = CurrentWeather,
    freezeTime = freezeTime,
    blackout = blackout,
    freezeWeather = freezeWeather,
    realtime = realTime
}
end

CacheZones = {}
Citizen.CreateThread(function()
	for k,v in pairs(zoneList) do
		CacheZones[v.name] = v
		CacheZones[v.name].zone:onPlayerInOut(function(inside, point)
			if inside ~= true then
				 dontSync = false
				 TriggerServerEvent('0r-time:requestSync')
            else
				 CurrentWeather = v.weather
				 if v.time.forceTime == true then
                    dontSync = true
					freezeWeather = true
                    if cfg_meteo.ChangeTimeFadeEffectOnEnter == true then
                        ChangeTimeToFade(v.time.hour)
                    else
                        ShiftToHour(v.time.hour)
                        ShiftToMinute(v.time.minute)
                    end
				 end
           end
		end)
	end
end)

ChangeTimeToFade = function(newTime)
    m = 0
    x_cur_time = GetClockHours()
    for i=1, (math.abs(x_cur_time - newTime) * 60) do
        if newTime ~= GetClockHours() then
            if m >= 60 then
            m = 0
            end
            m = m + 1
            ShiftToMinute(m)
            Citizen.Wait(0)
        end
    end
end

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

Citizen.CreateThread(function()
    local ped = GetPlayerPed(-1)
    while cfg_meteo.ClothingTemperatureEffect == true do
        if GetTableIn(cfg_meteo.ColdWeatherConditions, CurrentWeather) then
            for k,v in pairs(cfg_meteo.ClothingFeelings.Cold) do
                x = GetPedDrawableVariation(ped, k)
                if GetTableIn(v, x) then
                    currentWarmthLvl = currentWarmthLvl - cfg_meteo.PerClothFeeling
                end
            end
        end
        if GetTableIn(cfg_meteo.PerspirationWeatherConditions, CurrentWeather) then
            for k,v in pairs(cfg_meteo.ClothingFeelings.Perspiration) do
                x = GetPedDrawableVariation(ped, k)
                if GetTableIn(v, x) then
                    currentWarmthLvl = currentWarmthLvl + cfg_meteo.PerClothFeeling
                end
            end
        end
        Citizen.Wait(cfg_meteo.TemperatureEffectInterval)
    end
end)

Citizen.CreateThread(function()
    while cfg_meteo.WarmthEffect == true do
       ped = GetPlayerPed(-1)
       lvl = GetWarmthLevel()
       if cfg_meteo.GiveDamage then
            if lvl >= cfg_meteo.CriticalPerspirationLevel then
                if cfg_meteo.WarmthNotifications == true then
                    TriggerEvent('0r-time:notify', cfg_meteo.Translation["faint"])
                end
                ApplyDamageToPed(ped, cfg_meteo.Damage, false)
            end
            if lvl <= cfg_meteo.CriticalColdLevel then
                if cfg_meteo.WarmthNotifications == true then
                    TriggerEvent('0r-time:notify', cfg_meteo.Translation["hypothermia"])
                end
                ApplyDamageToPed(ped, cfg_meteo.Damage, false)
            end
       end
       if lvl >= cfg_meteo.MinimumPerspirationStartLevel then
          if cfg_meteo.WarmthNotifications == true then
            TriggerEvent('0r-time:notify', cfg_meteo.Translation["sweating"])
          end
       end
       if lvl <= cfg_meteo.MinimumColdStartLevel then
          if cfg_meteo.WarmthNotifications == true then
            TriggerEvent('0r-time:notify', cfg_meteo.Translation["cold"])
          end
       end
       Citizen.Wait(cfg_meteo.WarmthEffectInterval)
    end
end)

GetWarmthLevel = function()
    return currentWarmthLvl
end

GetTableIn = function(table, val)
    for k,v in pairs(table) do
        if v == val then
            return true
        end
    end
    return false
end

res_list = {
    "vSync", "easytime", "cd_easytime", "ServerSync", "Renewed-Weathersync", "fivem-realtime",
    "bs_sync", "ParadoxWorldSync", "dynamic-timer-fivem","rw-adminmenu", "qb-weathersync", "weathersync",
    "realtime-weather", "vMenu","BigDaddy-Weather", "esx_weather", "esx_weatherandtime", "esx_weather_sync",
    "es_wsync"
}

Citizen.CreateThread(function()
    for k,v in pairs(res_list) do
        if GetResourceState(v) == "started" then
            print("[WARNING] "..v.." is running, It seems that this script is the script that affects game time. Make sure that this script does not affect game time. If it is not an important script, stop it!")
            break
        end
    end
end)
