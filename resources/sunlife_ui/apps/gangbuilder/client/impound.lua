local Config = GangConfig
local ImpoundOpen = false
local ImpoundMenu = nil
local ImpoundVehicles = {}
local ImpoundBlips = {}

local function clearImpoundBlips()
    for i = 1, #ImpoundBlips do
        local b = ImpoundBlips[i]
        if b and DoesBlipExist(b) then
            RemoveBlip(b)
        end
    end
    ImpoundBlips = {}
end

local function createImpoundBlips()
    if not Config or type(Config.GangImpounds) ~= "table" then
        return
    end

    for i = 1, #Config.GangImpounds do
        local d = Config.GangImpounds[i]
        if d and d.pos and d.blip then
            local blip = AddBlipForCoord(d.pos.x, d.pos.y, d.pos.z)
            SetBlipSprite(blip, tonumber(d.blip.sprite) or 67)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, tonumber(d.blip.scale) or 0.8)
            SetBlipColour(blip, tonumber(d.blip.color) or 1)
            SetBlipAsShortRange(blip, true)
            local _key = "BN_SNL_GANGBUILDER_IMP_1_" .. tostring(blip)
            AddTextEntry(_key, tostring(d.label or "Fourrière"))
            BeginTextCommandSetBlipName(_key)
            EndTextCommandSetBlipName(blip)
            ImpoundBlips[#ImpoundBlips + 1] = blip
        end
    end
end

local function refreshImpoundList()
    GB_DealerRpc("impound:list", function(rows)
        ImpoundVehicles = type(rows) == "table" and rows or {}
    end)
end

local function openImpound()
    if ImpoundOpen then
        return
    end

    if not HasGang then
        ESX.ShowNotification("~r~Tu n'as pas de gang.")
        return
    end

    ImpoundOpen = true

    RMenu.Add("gb_impound", "main", RageUI.CreateMenu("Fourrière", "Véhicules sortis", 1, 100))
    ImpoundMenu = RMenu:Get("gb_impound", "main")

    if Config and Config.Menu and Config.Menu.banner then
        local b = Config.Menu.banner
        ImpoundMenu:SetRectangleBanner(b.r or 0, b.g or 0, b.b or 0, b.a or 200)
    end

    refreshImpoundList()
    RageUI.Visible(ImpoundMenu, true)

    CreateThread(function()
        while ImpoundOpen do
            Wait(0)

            RageUI.IsVisible(ImpoundMenu, true, true, true, function()
                RageUI.Separator("Véhicules en circulation")

                if #ImpoundVehicles == 0 then
                    RageUI.Separator("~c~Aucun véhicule sorti")
                    return
                end

                for i = 1, #ImpoundVehicles do
                    local row = ImpoundVehicles[i]
                    local plate = tostring(row.plate or "")
                    local props = json.decode(row.vehicle or "{}") or {}
                    local modelName = tostring(props.modelname or "Vehicule")

                    RageUI.ButtonWithStyle(("%s [%s]"):format(modelName, plate), "Remet ce véhicule dans le garage", { RightLabel = "Ranger →" }, true, function(_, _, selected)
                        if selected then
                            GB_DealerRpc("impound:recover", function(ok, msg)
                                if ok then
                                    ESX.ShowNotification("~g~Véhicule rangé.")
                                    refreshImpoundList()
                                else
                                    ESX.ShowNotification("~r~" .. tostring(msg or "Erreur"))
                                end
                            end, plate)
                        end
                    end)
                end
            end)

            if ImpoundMenu and not RageUI.Visible(ImpoundMenu) then
                ImpoundOpen = false
            end
        end

        RageUI.CloseAll()
    end)
end

CreateThread(function()
    while ESX == nil do
        Wait(0)
    end

    local lastHasGang = nil

    while true do
        local sleep = 1000

        if HasGang ~= lastHasGang then
            lastHasGang = HasGang
            clearImpoundBlips()
            if HasGang then
                createImpoundBlips()
            end
        end

        if HasGang and Config and type(Config.GangImpounds) == "table" then
            local ped = PlayerPedId()
            local pcoords = GetEntityCoords(ped)

            for i = 1, #Config.GangImpounds do
                local d = Config.GangImpounds[i]
                if d and d.pos then
                    local pos = vector3(d.pos.x + 0.0, d.pos.y + 0.0, d.pos.z + 0.0)
                    local dist = #(pcoords - pos)

                    if dist < 30.0 then
                        sleep = 0
                        DrawMarker(2, pos.x, pos.y, pos.z - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 160, false, true, 2, false, nil, nil, false)
                    end

                    local od = tonumber(d.openDist) or 2.0
                    if dist < od then
                        sleep = 0
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentSubstringPlayerName("Appuie sur ~INPUT_CONTEXT~ pour ouvrir la fourrière")
                        EndTextCommandDisplayHelp(0, false, true, -1)

                        if IsControlJustReleased(0, 38) then
                            openImpound()
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
