local Config = GangConfig

ESX = exports["es_extended"]:getSharedObject()

local PropsGangList = {}
local AllWorldProps = {}
local AllWorldPropsVersion = 0
local WorldSpawnedProps = {}
local PropsGangOpen = false
local PropsGangMenusReady = false
local MyGangNameForProps = nil
local MyGangHQPosForProps = nil
local MyGangCanPlaceProps = false

local WORLD_SPAWN_DISTANCE = 150.0

local MOVE_SPEED = 0.04
local ROTATE_SPEED = 1.0
local HEIGHT_SPEED = 0.025

local function startPlacementMode(modelName)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local hash = GetHashKey(modelName)
    if not IsModelInCdimage(hash) then
        ESX.ShowNotification("~r~Modèle de prop invalide.")
        return
    end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    if not HasModelLoaded(hash) then
        ESX.ShowNotification("~r~Impossible de charger le prop.")
        return
    end
    local preview = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(preview, heading)
    SetEntityAlpha(preview, 180)
    FreezeEntityPosition(preview, true)
    SetEntityCollision(preview, false, false)
    SetEntityInvincible(preview, true)
    local pos = { x = coords.x, y = coords.y, z = coords.z }
    local h = heading
    ESX.ShowNotification("~b~Déplacez le prop avec les flèches. ENTRÉE = placer, RETOUR = annuler.")
    CreateThread(function()
        while DoesEntityExist(preview) do
            Wait(0)
            SetEntityCoords(preview, pos.x, pos.y, pos.z, false, false, false, false)
            SetEntityHeading(preview, h)
            local rad = math.rad(h)

            if IsControlPressed(0, 172) or IsControlPressed(2, 188) then
                pos.x = pos.x - math.sin(rad) * MOVE_SPEED
                pos.y = pos.y + math.cos(rad) * MOVE_SPEED
            end
            if IsControlPressed(0, 173) or IsControlPressed(2, 187) then
                pos.x = pos.x + math.sin(rad) * MOVE_SPEED
                pos.y = pos.y - math.cos(rad) * MOVE_SPEED
            end

            if IsControlPressed(0, 174) or IsControlPressed(2, 189) then
                h = h - ROTATE_SPEED
                if h < 0.0 then h = h + 360.0 end
            end
            if IsControlPressed(0, 175) or IsControlPressed(2, 190) then
                h = h + ROTATE_SPEED
                if h >= 360.0 then h = h - 360.0 end
            end
            if IsControlPressed(0, 21) then
                pos.z = pos.z + HEIGHT_SPEED
            end
            if IsControlPressed(0, 36) then
                pos.z = pos.z - HEIGHT_SPEED
            end
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("ENTRÉE = Placer | RETOUR = Annuler | Flèches = déplacer/tourner | MAJ = monter | CTRL = descendre")
            EndTextCommandDisplayHelp(0, false, true, -1)
            if IsControlJustPressed(0, 191) or IsControlJustPressed(2, 191) then
                local maxDist = tonumber(Config.PropsMaxDistanceFromHQ) or 100.0
                if type(MyGangHQPosForProps) == "table" and type(MyGangHQPosForProps.x) == "number" and type(MyGangHQPosForProps.y) == "number" and type(MyGangHQPosForProps.z) == "number" then
                    local dx = pos.x - MyGangHQPosForProps.x
                    local dy = pos.y - MyGangHQPosForProps.y
                    local dz = pos.z - MyGangHQPosForProps.z
                    if (dx * dx + dy * dy + dz * dz) > (maxDist * maxDist) then
                        ESX.ShowNotification(("~r~Trop loin du QG (max %d m)."):format(math.floor(maxDist + 0.5)))
                    else
                        SetModelAsNoLongerNeeded(hash)
                        DeleteEntity(preview)
                        TriggerServerEvent("gangbuilder:props:place", modelName, pos.x, pos.y, pos.z, 0.0, 0.0, h)
                        ESX.ShowNotification("~g~Prop posé et sauvegardé.")
                        return
                    end
                else
                    SetModelAsNoLongerNeeded(hash)
                    DeleteEntity(preview)
                    TriggerServerEvent("gangbuilder:props:place", modelName, pos.x, pos.y, pos.z, 0.0, 0.0, h)
                    ESX.ShowNotification("~g~Prop posé et sauvegardé.")
                    return
                end
            end
            if IsControlJustPressed(0, 200) or IsControlJustPressed(2, 200) then
                SetModelAsNoLongerNeeded(hash)
                DeleteEntity(preview)
                ESX.ShowNotification("~o~Placement annulé.")
                return
            end
        end
        SetModelAsNoLongerNeeded(hash)
    end)
end

local function deleteAllWorldSpawnedProps()
    for id, ent in pairs(WorldSpawnedProps) do
        if DoesEntityExist(ent) then
            DeleteEntity(ent)
        end
    end
    WorldSpawnedProps = {}
end

local function spawnOneProp(p)
    if not p or not p.prop_model or p.prop_model == "" then
        return nil
    end
    local hash = GetHashKey(p.prop_model)
    if not IsModelInCdimage(hash) then
        return nil
    end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    if not HasModelLoaded(hash) then
        return nil
    end
    local obj = CreateObject(hash, p.x, p.y, p.z, false, false, false)
    SetEntityHeading(obj, p.heading or 0.0)
    if p.pitch and p.roll then
        SetEntityRotation(obj, p.pitch, p.roll, p.heading or 0.0, 2, true)
    end
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    SetEntityCanBeDamaged(obj, false)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

function PropsGangRefreshSpawns(list)
    if type(list) ~= "table" then
        list = {}
    end
    PropsGangList = list
end

local function refreshWorldPropsSpawns()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then
        return
    end
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    local distSqLimit = WORLD_SPAWN_DISTANCE * WORLD_SPAWN_DISTANCE
    for i = 1, #AllWorldProps do
        local p = AllWorldProps[i]
        local id = p and p.id
        if not id then goto continue end
        local dx = (p.x or 0) - px
        local dy = (p.y or 0) - py
        local dz = (p.z or 0) - pz
        local distSq = dx * dx + dy * dy + dz * dz
        if distSq <= distSqLimit then
            if not WorldSpawnedProps[id] or not DoesEntityExist(WorldSpawnedProps[id]) then
                local ent = spawnOneProp(p)
                if ent then
                    WorldSpawnedProps[id] = ent
                end
            end
        else
            if WorldSpawnedProps[id] and DoesEntityExist(WorldSpawnedProps[id]) then
                DeleteEntity(WorldSpawnedProps[id])
            end
            WorldSpawnedProps[id] = nil
        end
        ::continue::
    end
    for id, ent in pairs(WorldSpawnedProps) do
        local found = false
        for j = 1, #AllWorldProps do
            if AllWorldProps[j] and AllWorldProps[j].id == id then
                found = true
                break
            end
        end
        if not found and DoesEntityExist(ent) then
            DeleteEntity(ent)
            WorldSpawnedProps[id] = nil
        end
    end
end

local function fetchAllWorldProps()
    ESX.TriggerServerCallback("gangbuilder:props:getAllForWorld", function(list, version)
        if list == nil then

            return
        end
        if type(list) ~= "table" then
            list = {}
        end
        AllWorldProps = list
        AllWorldPropsVersion = tonumber(version) or AllWorldPropsVersion
        refreshWorldPropsSpawns()
    end, AllWorldPropsVersion)
end

local function applyPropsMenuStyle()
    if type(applyMenuStyle) == "function" then
        applyMenuStyle("propsgang", { "main", "list", "place_model" })
    end
end

local function ensurePropsMenus()
    if PropsGangMenusReady then
        return
    end
    RMenu.Add("propsgang", "main", RageUI.CreateMenu(Config.Menu.title or "GangBuilder", "Props du gang", 1, 100))
    RMenu.Add("propsgang", "list", RageUI.CreateSubMenu(RMenu:Get("propsgang", "main"), Config.Menu.title or "GangBuilder", "Liste des props posés"))
    RMenu.Add("propsgang", "place_model", RageUI.CreateSubMenu(RMenu:Get("propsgang", "main"), Config.Menu.title or "GangBuilder", "Choisir le prop à poser"))

    local m = RMenu:Get("propsgang", "main")
    m.Closed = function()
        PropsGangOpen = false
        RageUI.CloseAll()
        RMenu:Delete("propsgang", "main")
        RMenu:Delete("propsgang", "list")
        RMenu:Delete("propsgang", "place_model")
        PropsGangMenusReady = false
    end

    applyPropsMenuStyle()
    PropsGangMenusReady = true
end

function OpenPropsGangMenu()
    if PropsGangOpen then
        return
    end
    if IsPedDeadOrDying(PlayerPedId(), false) then
        return
    end

    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or not bundle.gang or not bundle.gang.name then
            ESX.ShowNotification("~r~Vous devez être membre d'un groupe pour accéder aux props.")
            return
        end
        MyGangNameForProps = bundle.gang.name
        MyGangCanPlaceProps = type(bundle.my) == "table" and type(bundle.my.perms) == "table" and bundle.my.perms.props_access == true
        local mgmt = bundle.gang.management
        if type(mgmt) == "table" and type(mgmt.pos) == "table" and type(mgmt.pos.x) == "number" and type(mgmt.pos.y) == "number" and type(mgmt.pos.z) == "number" then
            MyGangHQPosForProps = { x = mgmt.pos.x, y = mgmt.pos.y, z = mgmt.pos.z }
        else
            MyGangHQPosForProps = nil
        end
        ESX.TriggerServerCallback("gangbuilder:props:getList", function(ok, list)
            if not ok then
                ESX.ShowNotification("~r~Impossible de charger les props.")
                return
            end
            PropsGangRefreshSpawns(list or {})
            ensurePropsMenus()
            PropsGangOpen = true
            RageUI.Visible(RMenu:Get("propsgang", "main"), true)

            CreateThread(function()
                while PropsGangOpen do
                    Wait(0)
                    local maxProps = tonumber(Config.PropsMaxPerGang) or 20
                    local count = #PropsGangList
                    local canPlace = MyGangCanPlaceProps and count < maxProps

                    RageUI.IsVisible(RMenu:Get("propsgang", "main"), true, true, true, function()
                        RageUI.Separator(("Props du gang (%d / %d)"):format(count, maxProps))
                        RageUI.ButtonWithStyle("Placer un prop ici", not MyGangCanPlaceProps and "~r~Non autorisé" or (canPlace and ("Position actuelle (%d / %d)"):format(count, maxProps) or ("~r~Limite atteinte (%d / %d)"):format(count, maxProps)), { RightLabel = "→" }, canPlace, function(_, _, selected)
                        end, RMenu:Get("propsgang", "place_model"))
                        RageUI.ButtonWithStyle("Liste des props posés", ("%d prop(s)"):format(count), { RightLabel = "→" }, true, function(_, _, selected)
                        end, RMenu:Get("propsgang", "list"))
                    end)

                    RageUI.IsVisible(RMenu:Get("propsgang", "place_model"), true, true, true, function()
                        RageUI.Separator("Choisir un prop à poser")
                        for i = 1, #Config.PropsModels do
                            local m = Config.PropsModels[i]
                            if m and m.model and m.label then
                                RageUI.ButtonWithStyle(m.label, m.model, { RightLabel = "Poser →" }, true, function(_, _, selected)
                                    if selected then
                                        RageUI.CloseAll()
                                        RMenu:Delete("propsgang", "main")
                                        RMenu:Delete("propsgang", "list")
                                        RMenu:Delete("propsgang", "place_model")
                                        PropsGangMenusReady = false
                                        PropsGangOpen = false
                                        startPlacementMode(m.model)
                                    end
                                end)
                            end
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("propsgang", "list"), true, true, true, function()
                        if #PropsGangList == 0 then
                            RageUI.Separator("Aucun prop posé")
                        else
                            RageUI.Separator(("Props posés: %d"):format(#PropsGangList))
                            for i = 1, #PropsGangList do
                                local p = PropsGangList[i]
                                local label = ("#%d - %s (%.1f, %.1f, %.1f)"):format(p.id, p.prop_model or "?", p.x or 0, p.y or 0, p.z or 0)
                                RageUI.ButtonWithStyle(label, MyGangCanPlaceProps and "Retirer ce prop du monde et de la sauvegarde" or "~r~Non autorisé à retirer", { RightLabel = MyGangCanPlaceProps and "~r~Retirer" or "" }, true, function(_, _, selected)
                                    if selected and p.id and MyGangCanPlaceProps then
                                        TriggerServerEvent("gangbuilder:props:remove", p.id)
                                        RageUI.GoBack()
                                    end
                                end)
                            end
                        end
                    end)
                end
            end)
        end)
    end)
end

RegisterNetEvent("gangbuilder:props:sync", function(list)
    if type(list) ~= "table" then
        list = {}
    end
    PropsGangRefreshSpawns(list)
end)

RegisterNetEvent("gangbuilder:props:worldSync", function(list, version)
    if type(list) ~= "table" then
        list = {}
    end
    AllWorldProps = list
    AllWorldPropsVersion = tonumber(version) or AllWorldPropsVersion
    refreshWorldPropsSpawns()
end)

RegisterNetEvent("gangbuilder:props:worldDelta", function(payload)
    if type(payload) ~= "table" then
        return
    end
    local fromV = tonumber(payload.from)
    local toV = tonumber(payload.to)
    if not fromV or not toV then
        return
    end

    if AllWorldPropsVersion ~= fromV then
        fetchAllWorldProps()
        return
    end

    if type(payload.removed) == "table" then
        for i = 1, #payload.removed do
            local id = tonumber(payload.removed[i])
            if id then
                for j = #AllWorldProps, 1, -1 do
                    if AllWorldProps[j] and AllWorldProps[j].id == id then
                        table.remove(AllWorldProps, j)
                        break
                    end
                end
                local ent = WorldSpawnedProps[id]
                if ent and DoesEntityExist(ent) then
                    DeleteEntity(ent)
                end
                WorldSpawnedProps[id] = nil
            end
        end
    end

    if type(payload.added) == "table" then
        for i = 1, #payload.added do
            local p = payload.added[i]
            if p and p.id then
                AllWorldProps[#AllWorldProps + 1] = p
            end
        end
    end

    AllWorldPropsVersion = toV
    refreshWorldPropsSpawns()
end)

RegisterNetEvent("gangbuilder:props:worldChanged", function()
    fetchAllWorldProps()
end)

RegisterNetEvent("gangbuilder:syncGang", function(gang)
    if gang == false or not gang then
        MyGangNameForProps = nil
        MyGangHQPosForProps = nil
        MyGangCanPlaceProps = false
        PropsGangList = {}
        return
    end
    if type(gang) == "table" and gang.name then
        MyGangNameForProps = gang.name
        local mgmt = gang.management
        if type(mgmt) == "table" and type(mgmt.pos) == "table" and type(mgmt.pos.x) == "number" and type(mgmt.pos.y) == "number" and type(mgmt.pos.z) == "number" then
            MyGangHQPosForProps = { x = mgmt.pos.x, y = mgmt.pos.y, z = mgmt.pos.z }
        else
            MyGangHQPosForProps = nil
        end
        GB_GetBundle(function(bundle)
            MyGangCanPlaceProps = bundle and type(bundle.my) == "table" and type(bundle.my.perms) == "table" and bundle.my.perms.props_access == true
            ESX.TriggerServerCallback("gangbuilder:props:getList", function(ok, list)
                if ok and type(list) == "table" then
                    PropsGangRefreshSpawns(list)
                end
            end)
        end)
    end
end)

RegisterNetEvent("gangbuilder:members:updated", function()
    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or not bundle.gang then
            MyGangNameForProps = nil
            MyGangHQPosForProps = nil
            MyGangCanPlaceProps = false
            PropsGangList = {}
            return
        end
        MyGangNameForProps = bundle.gang.name
        MyGangCanPlaceProps = type(bundle.my) == "table" and type(bundle.my.perms) == "table" and bundle.my.perms.props_access == true
        local mgmt = bundle.gang.management
        if type(mgmt) == "table" and type(mgmt.pos) == "table" and type(mgmt.pos.x) == "number" and type(mgmt.pos.y) == "number" and type(mgmt.pos.z) == "number" then
            MyGangHQPosForProps = { x = mgmt.pos.x, y = mgmt.pos.y, z = mgmt.pos.z }
        else
            MyGangHQPosForProps = nil
        end
        ESX.TriggerServerCallback("gangbuilder:props:getList", function(ok, list)
            if ok and type(list) == "table" then
                PropsGangRefreshSpawns(list)
            end
        end)
    end)
end)

RegisterNetEvent("esx:playerLoaded", function()
    Wait(2000)
    fetchAllWorldProps()
    CreateThread(function()
        while true do
            Wait(2000)
            refreshWorldPropsSpawns()
        end
    end)
    GB_GetBundle(function(bundle)
        if bundle == false or type(bundle) ~= "table" or not bundle.gang then
            return
        end
        MyGangNameForProps = bundle.gang.name
        MyGangCanPlaceProps = type(bundle.my) == "table" and type(bundle.my.perms) == "table" and bundle.my.perms.props_access == true
        local mgmt = bundle.gang.management
        if type(mgmt) == "table" and type(mgmt.pos) == "table" then
            MyGangHQPosForProps = { x = mgmt.pos.x, y = mgmt.pos.y, z = mgmt.pos.z }
        else
            MyGangHQPosForProps = nil
        end
        ESX.TriggerServerCallback("gangbuilder:props:getList", function(ok, list)
            if ok and type(list) == "table" then
                PropsGangRefreshSpawns(list)
            end
        end)
    end)
end)

RegisterCommand(Config.PropsCommand or "propsgang", function()
    OpenPropsGangMenu()
end, false)

AddEventHandler("onClientResourceStart", function(resName)
    if resName ~= GetCurrentResourceName() then
        return
    end
    fetchAllWorldProps()
end)

AddEventHandler("onResourceStop", function(resName)
    if resName ~= GetCurrentResourceName() then
        return
    end
    deleteAllWorldSpawnedProps()
end)
