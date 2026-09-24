local dataCoordsEMS <const> = {
    { name = "Étage -1", marker = vector3(-670.524963, 361.963776, 76.874643)},
    { name = "Étage 0", marker = vector3(-670.524475, 361.789276, 82.183786)},
    { name = "Toit", marker = vector3(-674.255798, 323.322571, 139.222803)},
}

local dataCoordsLSPD <const> = {
    { name = "Étage -2", marker = vector3(-1093.984741, -848.039551, 6.708759)},
    { name = "Étage -1", marker = vector3(-1094.067749, -847.928284, 14.722201)},
    { name = "Étage 0", marker = vector3(-1094.091431, -847.910034, 18.326031)},
    { name = "Étage 1", marker = vector3(-1094.216309, -847.869934, 21.792784)},
    { name = "Étage 2", marker = vector3(-1094.279785, -847.726013, 26.063307)},
    { name = "Étage 3", marker = vector3(-1094.552246, -847.606140, 29.768621)},
    { name = "Étage 4", marker = vector3(-1094.183350, -847.849976, 33.272385)},
}

local currentAscenseur, pos = nil, nil
local open = false

Citizen.CreateThread(function()
    RMenu.Add('ascenseur', 'elevator', RageUI.CreateMenu("SunLife", "Ascenseur", 1, 100))
    RMenu:Get('ascenseur', 'elevator'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('ascenseur', 'elevator').EnableMouse = false
    RMenu:Get('ascenseur', 'elevator').Closed = function()
        open = false
        currentAscenseur = nil
    end
end)

local function transition()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    SetEntityCoordsNoOffset(playerPed, pos.x, pos.y, pos.z, false, false, false, true)
    DoScreenFadeIn(3000)
end

local function menuAscenseur()
    if open then
        return
    end
    open = true
    RageUI.Visible(RMenu:Get('ascenseur', 'elevator'), true)
    pos = GetEntityCoords(PlayerPedId())

    Citizen.CreateThread(function()
        while open do
            RageUI.IsVisible(RMenu:Get('ascenseur', 'elevator'), true, true, true, function()
                if currentAscenseur == "EMS" then
                    for _, v in ipairs(dataCoordsEMS) do
                        RageUI.ButtonWithStyle(v.name, nil, { RightLabel = "→" }, true, function(_, _, Selected)
                            if Selected then
                                transition()
                                SetEntityCoordsNoOffset(PlayerPedId(), v.marker.x, v.marker.y, v.marker.z, false, false, false, true)
                                RageUI.CloseAll()
                            end
                        end)
                    end
                elseif currentAscenseur == "LSPD" then
                    for _, v in ipairs(dataCoordsLSPD) do
                        RageUI.ButtonWithStyle(v.name, nil, { RightLabel = "→" }, true, function(_, _, Selected)
                            if Selected then
                                transition()
                                SetEntityCoordsNoOffset(PlayerPedId(), v.marker.x, v.marker.y, v.marker.z, false, false, false, true)
                                RageUI.CloseAll()
                            end
                        end)
                    end
                end
            end, function()
            end)

            if not RageUI.Visible(RMenu:Get('ascenseur', 'elevator')) then
                open = false
                pos = nil
                break
            end

            if pos and #(GetEntityCoords(PlayerPedId()) - pos) > 2.0 then
                RageUI.CloseAll()
            end
            Wait(0)
        end
    end)
end

local function markerAscenseur(data, typeAscenseur)
    DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)

    if data.currentDistance < 3.0 then
        ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour ouvrir le menu de l'ascenseur")
        if IsControlJustPressed(1, 38) then
            currentAscenseur = typeAscenseur
            menuAscenseur()
        end
    end
end

local function initAscenseurs()
    for _, v in ipairs(dataCoordsEMS) do
        lib.points.new({
            coords = v.marker,
            distance = 10,
            nearby = function(self)
                markerAscenseur({
                    coords = self.coords,
                    currentDistance = self.currentDistance
                }, "EMS")
            end
        })
    end
    for _, v in ipairs(dataCoordsLSPD) do
        lib.points.new({
            coords = v.marker,
            distance = 10,
            nearby = function(self)
                markerAscenseur({
                    coords = self.coords,
                    currentDistance = self.currentDistance
                }, "LSPD")
            end
        })
    end
end

Citizen.CreateThread(function()
    initAscenseurs()
end)
