local dataKits <const> = {
    vector3(-350.2817, -168.5658, 37.9862),
    vector3(-215.8730, -1319.0000, 30.2944),
    vector3(37.2420, 6518.9058, 30.9183),
    vector3(32.617222, 6524.386719, 31.012914)
}
local openKits = false

CreateThread(function()
    RMenu.Add('mecanoKits', 'kits', RageUI.CreateMenu("SunLife", "Objets Mécano", 1, 100))
    RMenu:Get('mecanoKits', 'kits'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('mecanoKits', 'kits').EnableMouse = false
    RMenu:Get('mecanoKits', 'kits').Closed = function()
		openKits = false
    end
end)

RegisterNetEvent("sJobs_announce.setBlip", function(blipId, text, coords)
    if not blipId or not text then
        return
    end

    local blipHarmony = AddBlipForCoord(coords)
	SetBlipSprite(blipHarmony, blipId)
	SetBlipScale(blipHarmony, 0.8)
	SetBlipColour(blipHarmony, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blipHarmony)

    Citizen.SetTimeout(30000, function()
        RemoveBlip(blipHarmony)
    end)
end)

local function menuKits()
    if openKits then
        openKits = false
        return
    end
    openKits = true
    RageUI.Visible(RMenu:Get('mecanoKits', 'kits'), true)

    Citizen.CreateThread(function()
        while openKits do
            RageUI.IsVisible(RMenu:Get('mecanoKits', 'kits'), true, true, true, function()
                RageUI.ButtonWithStyle("Kits de réparation", nil, { RightLabel = "7,500$" }, true, function(_, _, Selected)
                    if Selected then
                        local input = lib.inputDialog("Quantité de kits", {
                            {type = "number", label = "Nombre de kits", min = 1, default = 1}
                        })
                        if input and tonumber(input[1]) then
                            local quantity = tonumber(input[1])
                            TriggerServerEvent("sJobs.buyKits", quantity)
                        else
                            ESX.ShowNotification("~r~Quantité invalide.")
                        end
                    end
                end)
            end, function()
            end)
            Wait(0)
        end
    end)
end

local function markerKits(data)
    local allowedJobs <const> = {
        hayes = true,
        harmony = true,
        bennys = true,
        streettuners = true
    }

    if allowedJobs[playerJob] then
        DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.9, 1.9, 1.9, 255, 117, 31, 225, false, false)

        if data.currentDistance < 3.0 then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder aux ~o~kits")
            if IsControlJustPressed(1, 38) then
                menuKits()
            end
        end
    end
end

local function initKitsSystem()
    for _, coords in ipairs(dataKits) do
        lib.points.new({
            coords = coords,
            distance = 10,
            nearby = function(self)
                markerKits({
                    coords = self.coords,
                    currentDistance = self.currentDistance
                })
            end
        })
    end
end

Citizen.CreateThread(function()
    initKitsSystem()
end)
