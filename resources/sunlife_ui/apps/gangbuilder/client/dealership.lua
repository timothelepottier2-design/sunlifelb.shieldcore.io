local Config = GangConfig
local ESX = exports["es_extended"]:getSharedObject()

local DealerOpen = false
local DealerMenu = nil
local DealerSub = nil

local PreviewVeh = nil
local PreviewCam = nil
local PreviewModel = nil

local CurrentCatalogLabel = nil
local CurrentCatalogVehicles = {}

local DealerBlips = {}
HasGang = false
LastGangType = nil

local function clearDealerBlips()
    for i = 1, #DealerBlips do
        local b = DealerBlips[i]
        if b and DoesBlipExist(b) then
            RemoveBlip(b)
        end
    end
    DealerBlips = {}
end

local function createDealerBlips()
    if not Config or type(Config.VehicleDealerships) ~= "table" then
        return
    end

    for i = 1, #Config.VehicleDealerships do
        local d = Config.VehicleDealerships[i]
        if d and d.pos then
            local blip = AddBlipForCoord(d.pos.x, d.pos.y, d.pos.z)
            SetBlipSprite(blip, 225)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
            local _key = "BN_SNL_GANGBUILDER_DEAL_1_" .. tostring(blip)
            AddTextEntry(_key, "Concessionnaire illégal")
            BeginTextCommandSetBlipName(_key)
            EndTextCommandSetBlipName(blip)
            DealerBlips[#DealerBlips + 1] = blip
        end
    end
end

local function refreshGangState(cb)
    GB_GetBundle(function(bundle)
        local nowHasGang = (bundle ~= false and type(bundle) == "table" and type(bundle.gang) == "table")
        local nowType = nil

        if nowHasGang then
            nowType = tostring(bundle.gang.type or "")
        end

        local changed = (nowHasGang ~= HasGang) or (nowType ~= LastGangType)

        HasGang = nowHasGang
        LastGangType = nowType

        if changed then
            clearDealerBlips()

            if HasGang then
                createDealerBlips()
            end
        end

        if cb then
            cb(HasGang, LastGangType)
        end
    end)
end

local function trim(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function mergeVehicles(base, extra)
    local out = {}

    if type(base) == "table" then
        for _, v in ipairs(base) do
            out[#out+1] = v
        end
    end

    if type(extra) == "table" then
        for _, v in ipairs(extra) do
            out[#out+1] = v
        end
    end

    return out
end

local function catalogForType(gtype)
    if not Config or type(Config.DealershipCatalogs) ~= "table" then
        return nil
    end

    local c = Config.DealershipCatalogs[gtype]
    if not c then
        return nil
    end

    local vehicles = {}

    if type(c.inherit) == "string" and c.inherit ~= "" then
        local base = Config.DealershipCatalogs[c.inherit]
        if base and type(base.vehicles) == "table" then
            vehicles = mergeVehicles(base.vehicles, c.vehicles)
        end
    else
        vehicles = c.vehicles
    end

    return {
        label = c.label or gtype,
        vehicles = vehicles
    }
end

local function unloadPreview()
    if PreviewVeh and DoesEntityExist(PreviewVeh) then
        DeleteEntity(PreviewVeh)
    end
    PreviewVeh = nil
    PreviewModel = nil

    if PreviewCam then
        RenderScriptCams(false, true, 200, true, true)
        DestroyCam(PreviewCam, false)
    end
    PreviewCam = nil
end

local function ensureCam()
    if PreviewCam then
        return
    end

    local c = Config.DealershipPreview and Config.DealershipPreview.cam
    if not c then
        return
    end

    PreviewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(PreviewCam, c.x + 0.0, c.y + 0.0, c.z + 0.0)
    SetCamRot(PreviewCam, c.rx + 0.0, c.ry + 0.0, c.rz + 0.0, 2)
    SetCamFov(PreviewCam, c.fov + 0.0)
    RenderScriptCams(true, true, 200, true, true)
end

local function spawnPreview(model)
    model = trim(model)
    if model == "" then
        return
    end

    if PreviewModel == model and PreviewVeh and DoesEntityExist(PreviewVeh) then
        return
    end

    local p = Config.DealershipPreview and Config.DealershipPreview.veh
    if not p then
        return
    end

    local hash = GetHashKey(model)
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        return
    end

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    if PreviewVeh and DoesEntityExist(PreviewVeh) then
        DeleteEntity(PreviewVeh)
    end

    PreviewVeh = CreateVehicle(hash, p.x + 0.0, p.y + 0.0, p.z + 0.0, p.h + 0.0, false, false)
    SetEntityInvincible(PreviewVeh, true)
    SetVehicleEngineOn(PreviewVeh, true, true, false)
    SetVehicleDirtLevel(PreviewVeh, 0.0)
    FreezeEntityPosition(PreviewVeh, true)
    SetVehicleDoorsLocked(PreviewVeh, 2)
    SetEntityAsMissionEntity(PreviewVeh, true, true)

    PreviewModel = model
    SetModelAsNoLongerNeeded(hash)
end

local function openDealer()
    if not HasGang then
        ESX.ShowNotification("~r~Tu n'as pas de gang.")
        return
    end

    if DealerOpen then
        return
    end

    DealerOpen = true

    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or type(bundle.gang) ~= "table" then
            ESX.ShowNotification("~r~Aucun gang.")
            DealerOpen = false
            return
        end

        local gangType = tostring(bundle.gang.type or "")
        local cat = catalogForType(gangType)
        if not cat or type(cat.vehicles) ~= "table" then
            ESX.ShowNotification("~r~Aucun catalogue pour ton type: " .. gangType)
            DealerOpen = false
            return
        end

        CurrentCatalogLabel = tostring(cat.label or gangType)
        CurrentCatalogVehicles = cat.vehicles

        RMenu.Add("gb_dealer", "main", RageUI.CreateMenu("Concession", CurrentCatalogLabel, 1, 100))
        RMenu.Add("gb_dealer", "list", RageUI.CreateSubMenu(RMenu:Get("gb_dealer", "main"), "Concession", CurrentCatalogLabel))

        DealerMenu = RMenu:Get("gb_dealer", "main")
        DealerSub = RMenu:Get("gb_dealer", "list")

        if Config and Config.Menu and Config.Menu.banner then
            local b = Config.Menu.banner
            DealerMenu:SetRectangleBanner(b.r or 0, b.g or 0, b.b or 0, b.a or 200)
            DealerSub:SetRectangleBanner(b.r or 0, b.g or 0, b.b or 0, b.a or 200)
        end

        RageUI.Visible(DealerMenu, true)

        CreateThread(function()
            while DealerOpen do
                Wait(0)

                RageUI.IsVisible(DealerMenu, true, true, true, function()
                    RageUI.Separator("Catalogue: ~b~" .. tostring(CurrentCatalogLabel))
                    RageUI.ButtonWithStyle("Voir les véhicules", nil, { RightLabel = "→" }, true, function() end, DealerSub)
                end)

                RageUI.IsVisible(DealerSub, true, true, true, function()
                    if type(CurrentCatalogVehicles) ~= "table" or #CurrentCatalogVehicles == 0 then
                        RageUI.Separator("~c~Aucun véhicule")
                        return
                    end

                    for i = 1, #CurrentCatalogVehicles do
                        local v = CurrentCatalogVehicles[i]
                        local label = tostring(v.label or v.model or "Vehicule")
                        local model = tostring(v.model or "")
                        local price = tonumber(v.price) or 0

                        RageUI.ButtonWithStyle(label, nil, { RightLabel = ("~g~%s$"):format(ESX.Math.GroupDigits(price)) }, true, function(_, active, selected)
                            if active then
                                spawnPreview(model)
                            end

                            if selected then
                                GB_DealerRpc("dealership:buy", function(ok, msg, plate)
                                    if ok then
                                        ESX.ShowNotification(("~g~Achat OK~s~ (%s)"):format(tostring(plate or "")))
                                    else
                                        ESX.ShowNotification("~r~" .. tostring(msg or "Erreur"))
                                    end
                                end, model)
                            end
                        end)
                    end
                end)

                if DealerMenu and not RageUI.Visible(DealerMenu) and not RageUI.Visible(DealerSub) then
                    DealerOpen = false
                end
            end

            unloadPreview()
            RageUI.CloseAll()
        end)
    end)
end

CreateThread(function()
    Citizen.Wait(1500)
    refreshGangState()
end)

RegisterNetEvent("esx:playerLoaded", function()
    refreshGangState()
end)

RegisterNetEvent("gangbuilder:members:updated", function()
    refreshGangState()
end)

RegisterNetEvent("gangbuilder:syncGang", function()
    refreshGangState()
end)

RegisterNetEvent("esx:setJob", function()
    refreshGangState()
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if HasGang and Config and type(Config.VehicleDealerships) == "table" then
            local ped = PlayerPedId()
            local pcoords = GetEntityCoords(ped)

            for i = 1, #Config.VehicleDealerships do
                local d = Config.VehicleDealerships[i]
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
                        AddTextComponentSubstringPlayerName("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le concessionnaire")
                        EndTextCommandDisplayHelp(0, false, true, -1)

                        if IsControlJustReleased(0, 38) then
                            openDealer()
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
