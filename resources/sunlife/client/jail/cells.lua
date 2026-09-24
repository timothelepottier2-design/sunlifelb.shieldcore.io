InCell           = false
local _cell      = nil
local _hudThread = false

JailCells = JailCells or {}

function JailCells.getStationFromCoords(coords)
    if not JailCellsConfig or not JailCellsConfig.stations then return nil end
    local bestType, bestDist = nil, math.huge
    for stationType, st in pairs(JailCellsConfig.stations) do
        local d = #(coords - st.center)
        if d <= (st.detect_radius or 100.0) and d < bestDist then
            bestType, bestDist = stationType, d
        end
    end
    return bestType
end

function JailCells.getStationLabel(stationType)
    local st = JailCellsConfig and JailCellsConfig.stations and JailCellsConfig.stations[stationType]
    return st and st.label or stationType
end

local function drawCellTimer()
    if _hudThread then return end
    _hudThread = true
    CreateThread(function()
        while InCell and _cell do
            Wait(0)
            local remaining = math.max(0, math.floor(_cell.endsAt - GetGameTimer() / 1000))
            local mins = math.floor(remaining / 60)
            local secs = remaining % 60
            local lbl  = JailCells.getStationLabel(_cell.stationType) or "Poste"

            SetTextFont(4)
            SetTextScale(0.0, 0.55)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(("Cellule ~o~%s~w~ — sortie dans ~o~%02d:%02d"):format(lbl, mins, secs))
            DrawText(0.5, 0.92)
        end
        _hudThread = false
    end)
end

local function startEscapeWatcher()
    CreateThread(function()
        while InCell and _cell do
            Wait(_cell.escape_check_interval or 1000)
            if InCell and _cell then
                local p   = PlayerPedId()
                local pos = GetEntityCoords(p)
                local d   = #(pos - _cell.pos)
                if d > (_cell.escape_distance or 6.0) then
                    SetEntityCoords(p, _cell.pos.x, _cell.pos.y, _cell.pos.z, false, false, false, false)
                    SetEntityHeading(p, _cell.heading or 0.0)
                    if ESX and ESX.ShowNotification then
                        ESX.ShowNotification("~r~Vous ne pouvez pas quitter votre cellule.")
                    end
                end
            end
        end
    end)
end

local function startWeaponBlocker()
    CreateThread(function()
        local unarmed = GetHashKey("WEAPON_UNARMED")
        while InCell do
            local ped = PlayerPedId()
            if GetSelectedPedWeapon(ped) ~= unarmed then
                SetCurrentPedWeapon(ped, unarmed, true)
            end

            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 106, true)
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

            Wait(0)
        end
    end)
end

RegisterNetEvent("jail:cells:start", function(data)
    if not data or not data.pos then return end
    InCell = true
    _cell  = {
        stationType           = data.stationType,
        slotIdx               = data.slotIdx,
        pos                   = data.pos,
        heading               = data.heading or 0.0,
        endsAt                = (GetGameTimer() / 1000) + (data.seconds or 60),
        release               = data.release,
        escape_distance       = data.escape_distance or 6.0,
        escape_check_interval = data.escape_check_interval or 1000,
    }

    local p = PlayerPedId()
    SetEntityCoords(p, data.pos.x, data.pos.y, data.pos.z, false, false, false, false)
    SetEntityHeading(p, _cell.heading)
    ClearPedTasksImmediately(p)

    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(("~o~Vous avez été placé en cellule (~w~%ds~o~)."):format(data.seconds or 60))
    end

    drawCellTimer()
    startEscapeWatcher()
    startWeaponBlocker()

    CreateThread(function()
        while InCell and _cell do
            Wait(1000)
            if (_cell.endsAt - GetGameTimer() / 1000) <= -2 then
                TriggerServerEvent("jail:cells:freeMe", _cell.stationType, _cell.slotIdx)
                break
            end
        end
    end)
end)

RegisterNetEvent("jail:cells:end", function(data)
    if not InCell then return end
    InCell = false
    local release = (data and data.release) or (_cell and _cell.release)
    _cell = nil

    if release and release.pos then
        local p = PlayerPedId()
        SetEntityCoords(p, release.pos.x, release.pos.y, release.pos.z, false, false, false, false)
        SetEntityHeading(p, release.heading or 0.0)
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    InCell = false
    _cell  = nil
end)

exports("InCell", function()
    return InCell
end)
