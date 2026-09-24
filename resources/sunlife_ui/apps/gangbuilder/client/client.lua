local Config = GangConfig
ESX = exports["es_extended"]:getSharedObject()

local _gbDealerPending = {}
local _gbDealerSeq = 0

function GB_DealerRpc(op, cb, ...)
    _gbDealerSeq = _gbDealerSeq + 1
    local reqId = _gbDealerSeq
    _gbDealerPending[reqId] = cb or function() end
    TriggerServerEvent("gb:dealer:rpc", reqId, op, ...)
end

GB_Rpc = GB_DealerRpc

RegisterNetEvent("gb:dealer:rpc:reply")
AddEventHandler("gb:dealer:rpc:reply", function(reqId, ...)
    local cb = _gbDealerPending[reqId]
    if not cb then return end
    _gbDealerPending[reqId] = nil
    cb(...)
end)

local _BUNDLE_NONE = {}
local _bundleCache = _BUNDLE_NONE
local _bundleCacheExpire = 0
local _bundleCacheTtlMs = 500
local _bundlePendingCbs = nil

function GB_InvalidateBundleCache()
    _bundleCache = _BUNDLE_NONE
    _bundleCacheExpire = 0
end

function GB_GetBundle(cb)
    cb = cb or function() end

    local now = GetGameTimer()
    if _bundleCache ~= _BUNDLE_NONE and now < _bundleCacheExpire then
        cb(_bundleCache)
        return
    end

    if _bundlePendingCbs ~= nil then
        _bundlePendingCbs[#_bundlePendingCbs + 1] = cb
        return
    end

    _bundlePendingCbs = { cb }
    GB_Rpc("gb:bundle", function(bundle)
        _bundleCache = bundle
        _bundleCacheExpire = GetGameTimer() + _bundleCacheTtlMs
        local cbs = _bundlePendingCbs
        _bundlePendingCbs = nil
        if cbs then
            for i = 1, #cbs do
                local fn = cbs[i]
                if fn then
                    local ok, err = pcall(fn, bundle)
                    if not ok then
                        print(("[GangBuilder] GB_GetBundle callback error: %s"):format(tostring(err)))
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("gangbuilder:syncGang")
AddEventHandler("gangbuilder:syncGang", GB_InvalidateBundleCache)

RegisterNetEvent("gangbuilder:syncGangs")
AddEventHandler("gangbuilder:syncGangs", GB_InvalidateBundleCache)

RegisterNetEvent("gangbuilder:members:updated")
AddEventHandler("gangbuilder:members:updated", GB_InvalidateBundleCache)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", GB_InvalidateBundleCache)

RegisterNetEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", GB_InvalidateBundleCache)

local gangbOpen = false
local cachedGangs = {}

local createState = {
    name = "",
    typeIndex = 1,
    territoryColor = 1,
    armoryPos = nil,
    armoryWeapons = {},
    chests = {},
    garagePos = nil,
    garageHeading = 0.0,
    vehicleStorePos = nil,
    vehicleRetrievePos = nil,
    launderingEnabled = false,
    launderingPos = nil,
    ranks = {},
    managementPos = nil,
}

local editGangId = nil
local editState = {
    name = "",
    typeIndex = 1,
    territoryColor = 1,
    armoryPos = nil,
    armoryWeapons = {},
    chests = {},
    garagePos = nil,
    garageHeading = 0.0,
    vehicleStorePos = nil,
    vehicleRetrievePos = nil,
    launderingEnabled = false,
    launderingPos = nil,
    ranks = {},
    managementPos = nil,
    originalName = nil,
}

local previewMode = nil

local editChestStockIndex = nil
local editChestStock = { items = {}, capacity = 0, gang_name = "" }

local editChestDetailIndex = nil
local createChestDetailIndex = nil

local function stockGangName()
    if editState.originalName and editState.originalName ~= "" then
        return editState.originalName
    end
    return tostring(editState.name or "")
end

local function refreshEditChestStock()
    local gangName = stockGangName()
    if gangName == "" or not editChestStockIndex then
        editChestStock = { items = {}, capacity = 0, gang_name = "" }
        return
    end

    ESX.TriggerServerCallback("gangbuilder:admin:chest:get", function(ok, dataOrMsg)
        if not ok or type(dataOrMsg) ~= "table" then
            editChestStock = { items = {}, capacity = 0, gang_name = "" }
            if type(dataOrMsg) == "string" and dataOrMsg ~= "" then
                ESX.ShowNotification("~r~" .. dataOrMsg)
            end
            return
        end
        editChestStock = dataOrMsg
    end, gangName, tonumber(editChestStockIndex))
end

local function isValidPos(p)
    return type(p) == "table" and type(p.x) == "number" and type(p.y) == "number" and type(p.z) == "number"
end

local function drawModernMarker(pos, markerType, scale, rgba)
    DrawMarker(
        markerType,
        pos.x + 0.0, pos.y + 0.0, (pos.z - 0.5) + 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale, scale, scale,
        rgba[1], rgba[2], rgba[3], rgba[4],
        false, true, 2, false, nil, nil, false
    )
end

local function drawWorldText(pos, text, rgba, maxDist)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local d = #(pcoords - vector3(pos.x, pos.y, pos.z - 0.2))
    if d > (maxDist or 25.0) then
        return
    end

    local onScreen, sx, sy = World3dToScreen2d(pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
    if not onScreen then
        return
    end

    local cam = GetGameplayCamCoords()
    local distCam = #(vector3(pos.x, pos.y, pos.z) - cam)
    local scale = (2.0 / distCam) * 2.2
    local fov = (1.0 / GetGameplayCamFov()) * 100.0
    scale = scale * fov

    local r = rgba and rgba[1] or 255
    local g = rgba and rgba[2] or 255
    local b = rgba and rgba[3] or 255
    local a = rgba and rgba[4] or 220

    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.0, 0.32 * scale)
    SetTextColour(r, g, b, a)
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(sx, sy)
end

local function labelPos(pos, zOffset)
    return { x = pos.x + 0.0, y = pos.y + 0.0, z = pos.z + (zOffset or 0.35) + 0.0 }
end

local function previewState()
    if previewMode == "create" then
        return createState
    end
    if previewMode == "edit" and editGangId then
        return editState
    end
    return nil
end

function applyMenuStyle(namespace, names)
    for i = 1, #names do
        local menu = RMenu:Get(namespace, names[i])
        if menu then
            menu:SetRectangleBanner(Config.Menu.banner.r, Config.Menu.banner.g, Config.Menu.banner.b, Config.Menu.banner.a)
        end
    end
end

local function nextRankId(ranks)
    local maxId = 0
    for i = 1, #ranks do
        local r = ranks[i]
        local id = tonumber(r and r.id or 0) or 0
        if id > maxId then
            maxId = id
        end
    end
    return maxId + 1
end

local function ensureRankPerms(rank)
    rank.perms = rank.perms or {}
    for i = 1, #Config.RankPermissions do
        local k = Config.RankPermissions[i].key
        if rank.perms[k] ~= true then
            rank.perms[k] = false
        end
    end
end

local function applyGangToEditState(g)
    editGangId = g.id
    editState.name = g.name or ""
    editState.territoryColor = tonumber(g.territory_color or 1) or 1

    editState.typeIndex = 1
    for i = 1, #Config.Types do
        if Config.Types[i] == g.type then
            editState.typeIndex = i
            break
        end
    end

    editState.armoryPos = g.armory and g.armory.pos or nil
    editState.armoryWeapons = {}

    if g.armory and type(g.armory.weapons) == "table" then
        for i = 1, #g.armory.weapons do
            local w = g.armory.weapons[i]
            if w and w.item then
                editState.armoryWeapons[w.item] = true
            end
        end
    end

    editState.chests = {}
    if type(g.chests) == "table" then
        for i = 1, #g.chests do
            editState.chests[i] = g.chests[i]
        end
    end

    editState.garagePos = g.garage and g.garage.pos or nil
    editState.garageHeading = g.garage and (g.garage.heading or 0.0) or 0.0

    editState.vehicleStorePos = g.vehicle_store and g.vehicle_store.pos or nil
    editState.vehicleRetrievePos = g.vehicle_retrieve and g.vehicle_retrieve.pos or nil

    editState.launderingEnabled = g.laundering and g.laundering.enabled == true or false
    editState.launderingPos = g.laundering and g.laundering.pos or nil
    editState.managementPos = g.management and g.management.pos or nil

    editState.ranks = {}
    if type(g.ranks) == "table" then
        for i = 1, #g.ranks do
            editState.ranks[i] = g.ranks[i]
        end
    end

    editState.originalName = g.name or ""
end

local capacityLabels = {}
local function rebuildCapacityLabels()
    capacityLabels = {}
    if Config and Config.ChestCapacities then
        for i = 1, #Config.ChestCapacities do
            capacityLabels[i] = Config.ChestCapacities[i].label
        end
    end
end

rebuildCapacityLabels()

local function resetCreate()
    createState.name = ""
    createState.typeIndex = 1
    createState.territoryColor = 1
    createState.armoryPos = nil
    createState.armoryWeapons = {}
    createState.chests = {}
    createState.garagePos = nil
    createState.garageHeading = 0.0
    createState.vehicleStorePos = nil
    createState.vehicleRetrievePos = nil
    createState.launderingEnabled = false
    createState.launderingPos = nil
    createState.ranks = {}
    createState.managementPos = nil
end

local function KeyboardInput(title, defaultText, maxLen)
    AddTextEntry("GANGB_INPUT", title)
    DisplayOnscreenKeyboard(1, "GANGB_INPUT", "", defaultText or "", "", "", "", maxLen or 64)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

local function vecToTable(v)
    return { x = v.x + 0.0, y = v.y + 0.0, z = v.z + 0.0 }
end

local function getPlayerPos()
    return GetEntityCoords(PlayerPedId())
end

local function capturePos()
    local p = getPlayerPos()
    return vecToTable(p)
end

local function capturePosHeading()
    local p = getPlayerPos()
    local h = GetEntityHeading(PlayerPedId()) + 0.0
    return vecToTable(p), h
end

RegisterNetEvent("gangbuilder:syncGangs", function(gangs)
    if type(gangs) == "table" then
        cachedGangs = gangs
    end
end)

local function openGangBuilder()
    ESX.TriggerServerCallback("gangbuilder:canOpen", function(allowed)
        if not allowed then
            ESX.ShowNotification("~r~Accès refusé.")
            return
        end

        ESX.TriggerServerCallback("gangbuilder:getGangs", function(gangs)
            cachedGangs = gangs or cachedGangs

            RMenu.Add("gangb", "main", RageUI.CreateMenu(Config.Menu.title, Config.Menu.subtitle, 1, 100))
            RMenu.Add("gangb", "list", RageUI.CreateSubMenu(RMenu:Get("gangb", "main"), Config.Menu.title, "Gangs existants"))
            RMenu.Add("gangb", "create", RageUI.CreateSubMenu(RMenu:Get("gangb", "main"), Config.Menu.title, "Créer un gang"))
            RMenu.Add("gangb", "armory", RageUI.CreateSubMenu(RMenu:Get("gangb", "create"), Config.Menu.title, "Armurerie"))
            RMenu.Add("gangb", "chests", RageUI.CreateSubMenu(RMenu:Get("gangb", "create"), Config.Menu.title, "Coffres"))
            RMenu.Add("gangb", "chest_add", RageUI.CreateSubMenu(RMenu:Get("gangb", "chests"), Config.Menu.title, "Ajouter un coffre"))
            RMenu.Add("gangb", "chest_detail", RageUI.CreateSubMenu(RMenu:Get("gangb", "chests"), Config.Menu.title, "Coffre"))

            RMenu.Add("gangb", "edit", RageUI.CreateSubMenu(RMenu:Get("gangb", "list"), Config.Menu.title, "Éditer un gang"))
            RMenu.Add("gangb", "edit_armory", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit"), Config.Menu.title, "Armurerie"))
            RMenu.Add("gangb", "edit_chests", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit"), Config.Menu.title, "Coffres"))
            RMenu.Add("gangb", "edit_chest_add", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit_chests"), Config.Menu.title, "Ajouter un coffre"))
            RMenu.Add("gangb", "edit_chest_detail", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit_chests"), Config.Menu.title, "Coffre"))
            RMenu.Add("gangb", "edit_chest_stock", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit_chest_detail"), Config.Menu.title, "Stock du coffre"))

            RMenu.Add("gangb", "create_ranks", RageUI.CreateSubMenu(RMenu:Get("gangb", "create"), Config.Menu.title, "Rangs"))
            RMenu.Add("gangb", "create_rank_edit", RageUI.CreateSubMenu(RMenu:Get("gangb", "create_ranks"), Config.Menu.title, "Éditer un rang"))

            RMenu.Add("gangb", "edit_ranks", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit"), Config.Menu.title, "Rangs"))
            RMenu.Add("gangb", "edit_rank_edit", RageUI.CreateSubMenu(RMenu:Get("gangb", "edit_ranks"), Config.Menu.title, "Éditer un rang"))

            local m = RMenu:Get("gangb", "main")

            m.Closed = function()
                gangbOpen = false
                RageUI.CloseAll()
                RMenu:Delete("gangb", "main")
                RMenu:Delete("gangb", "list")
                RMenu:Delete("gangb", "create")
                RMenu:Delete("gangb", "armory")
                RMenu:Delete("gangb", "chests")
                RMenu:Delete("gangb", "chest_add")
                RMenu:Delete("gangb", "chest_detail")
                RMenu:Delete("gangb", "edit")
                RMenu:Delete("gangb", "edit_armory")
                RMenu:Delete("gangb", "edit_chests")
                RMenu:Delete("gangb", "edit_chest_add")
                RMenu:Delete("gangb", "edit_chest_detail")
                RMenu:Delete("gangb", "edit_chest_stock")
                RMenu:Delete("gangb", "create_ranks")
                RMenu:Delete("gangb", "create_rank_edit")
                RMenu:Delete("gangb", "edit_ranks")
                RMenu:Delete("gangb", "edit_rank_edit")
            end

            applyMenuStyle("gangb", {
                "main",
                "list",
                "create",
                "armory",
                "chests",
                "chest_add",
                "chest_detail",
                "edit",
                "edit_armory",
                "edit_chests",
                "edit_chest_add",
                "edit_chest_detail",
                "edit_chest_stock",
                "create_ranks",
                "create_rank_edit",
                "edit_ranks",
                "edit_rank_edit"
            })

            local function forceSubtitles(namespace, map)
                for name, subtitle in pairs(map) do
                    local menu = RMenu:Get(namespace, name)
                    if menu then
                        menu.Subtitle = subtitle
                    end
                end
            end

            forceSubtitles("gangb", {
                list = "Gangs existants",
                create = "Créer un gang",
                armory = "Armurerie",
                chests = "Coffres",
                chest_add = "Ajouter un coffre",
                chest_detail = "Coffre",
                edit = "Éditer un gang",
                edit_armory = "Armurerie",
                edit_chests = "Coffres",
                edit_chest_add = "Ajouter un coffre",
                edit_chest_detail = "Coffre",
                create_ranks = "Rangs",
                create_rank_edit = "Éditer un rang",
                edit_ranks = "Rangs",
                edit_rank_edit = "Éditer un rang",
            })

            if gangbOpen then
                gangbOpen = false
                return
            end

            gangbOpen = true
            RageUI.Visible(RMenu:Get("gangb", "main"), true)

            Citizen.CreateThread(function()
                while gangbOpen do
                    Wait(0)

                    local st = previewState()
                    if not st then
                        goto continue
                    end

                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)

                    if isValidPos(st.armoryPos) then
                        local d = #(pcoords - vector3(st.armoryPos.x, st.armoryPos.y, st.armoryPos.z))
                        if d < 75.0 then
                            drawModernMarker(st.armoryPos, 2, 0.6, { 70, 160, 255, 180 })
                            drawWorldText(labelPos(st.armoryPos, 0.45), "Armurerie", { 255, 255, 255, 230 }, 30.0)
                        end
                    end

                    if isValidPos(st.managementPos) then
                        local d = #(pcoords - vector3(st.managementPos.x, st.managementPos.y, st.managementPos.z))
                        if d < 75.0 then
                            drawModernMarker(st.managementPos, 2, 0.65, { 255, 90, 200, 185 })
                            drawWorldText(labelPos(st.managementPos, 0.45), "Gestion", { 255, 255, 255, 230 }, 30.0)
                        end
                    end

                    if type(st.chests) == "table" then
                        for i = 1, #st.chests do
                            local c = st.chests[i]
                            if c and isValidPos(c.pos) then
                                local d = #(pcoords - vector3(c.pos.x, c.pos.y, c.pos.z))
                                if d < 75.0 then
                                    drawModernMarker(c.pos, 2, 0.5, { 255, 200, 70, 170 })
                                    local w = tonumber(c.weight or 0) or 0
                                    local t = ("Coffre #%d - %sKG"):format(i, tostring(w))
                                    drawWorldText(labelPos(c.pos, 0.45), t, { 255, 255, 255, 230 }, 25.0)
                                end
                            end
                        end
                    end

                    if isValidPos(st.garagePos) then
                        local d = #(pcoords - vector3(st.garagePos.x, st.garagePos.y, st.garagePos.z))
                        if d < 100.0 then
                            drawModernMarker(st.garagePos, 2, 0.8, { 120, 255, 120, 170 })
                            drawWorldText(labelPos(st.garagePos, 0.55), "Garage", { 255, 255, 255, 230 }, 35.0)
                        end
                    end

                    if isValidPos(st.vehicleStorePos) then
                        local d = #(pcoords - vector3(st.vehicleStorePos.x, st.vehicleStorePos.y, st.vehicleStorePos.z))
                        if d < 100.0 then
                            drawModernMarker(st.vehicleStorePos, 2, 0.75, { 255, 120, 120, 170 })
                            drawWorldText(labelPos(st.vehicleStorePos, 0.55), "Rangement vehicule", { 255, 255, 255, 230 }, 35.0)
                        end
                    end

                    if isValidPos(st.vehicleRetrievePos) then
                        local d = #(pcoords - vector3(st.vehicleRetrievePos.x, st.vehicleRetrievePos.y, st.vehicleRetrievePos.z))
                        if d < 100.0 then
                            drawModernMarker(st.vehicleRetrievePos, 2, 0.75, { 120, 255, 120, 170 })
                            drawWorldText(labelPos(st.vehicleRetrievePos, 0.55), "Sortie vehicule", { 255, 255, 255, 230 }, 35.0)
                        end
                    end

                    if st.launderingEnabled == true and isValidPos(st.launderingPos) then
                        local d = #(pcoords - vector3(st.launderingPos.x, st.launderingPos.y, st.launderingPos.z))
                        if d < 75.0 then
                            drawModernMarker(st.launderingPos, 2, 0.6, { 200, 120, 255, 180 })
                            drawWorldText(labelPos(st.launderingPos, 0.45), "Blanchiment", { 255, 255, 255, 230 }, 30.0)
                        end
                    end

                    ::continue::
                end
            end)

            Citizen.CreateThread(function()
                local chestCapIndex = 1
                local editChestCapIndex = 1
                local createRankIndex = nil
                local editRankIndex = nil

                while gangbOpen do
                    Wait(0)

                    RageUI.IsVisible(RMenu:Get("gangb", "main"), true, true, true, function()
                        previewMode = nil

                        RageUI.ButtonWithStyle("Créer un nouveau groupe", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                resetCreate()
                            end
                        end, RMenu:Get("gangb", "create"))

                        RageUI.ButtonWithStyle("Voir les groupes déjà créés", nil, { RightLabel = "→" }, true, function() end, RMenu:Get("gangb", "list"))
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "list"), true, true, true, function()
                        previewMode = nil

                        if #cachedGangs == 0 then
                            RageUI.Separator("Aucun gang")
                            return
                        end

                        for i = 1, #cachedGangs do
                            local g = cachedGangs[i]
                            local rl = string.format("%s | Couleur: %s", g.type or "?", tostring(g.territory_color or "?"))
                            RageUI.ButtonWithStyle(g.name or "?", rl, { RightLabel = "→" }, true, function(_, _, selected)
                                if selected then
                                    applyGangToEditState(g)
                                end
                            end, RMenu:Get("gangb", "edit"))
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit"), true, true, true, function()
                        previewMode = "edit"

                        if not editGangId then
                            RageUI.Separator("~r~Aucun gang sélectionné")
                            return
                        end

                        RageUI.Separator("ID: " .. tostring(editGangId))

                        RageUI.ButtonWithStyle("Nom du gang", nil, { RightLabel = (editState.name ~= "" and editState.name or "~c~Non défini") }, true, function(_, _, selected)
                            if selected then
                                local input = KeyboardInput("Nom du gang", editState.name, 64)
                                if input and input:gsub("%s+", "") ~= "" then
                                    editState.name = input
                                else
                                    ESX.ShowNotification("~r~Nom invalide.")
                                end
                            end
                        end)

                        RageUI.List("Type de groupe", Config.Types, editState.typeIndex, nil, {}, true, function(_, _, _, index)
                            editState.typeIndex = index
                        end)

                        RageUI.ButtonWithStyle("Couleur du territoire (blip)", nil, { RightLabel = tostring(editState.territoryColor) }, true, function(_, _, selected)
                            if selected then
                                local input = KeyboardInput("Couleur du territoire (nombre)", tostring(editState.territoryColor), 8)
                                local num = tonumber(input)
                                if num then
                                    editState.territoryColor = math.floor(num)
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        local mgmtLabel = "~c~Non défini"
                        if editState.managementPos then
                            mgmtLabel = "✅"
                        end

                        RageUI.ButtonWithStyle("Position du point de gestion", nil, { RightLabel = mgmtLabel }, true, function(_, _, selected)
                            if selected then
                                editState.managementPos = capturePos()
                                ESX.ShowNotification("~g~Point de gestion défini.")
                            end
                        end)

                        RageUI.ButtonWithStyle("Configurer l'armurerie", nil, { RightLabel = "→" }, true, function() end, RMenu:Get("gangb", "edit_armory"))

                        local chestCount = #editState.chests
                        RageUI.ButtonWithStyle("Positions des coffres", nil, { RightLabel = tostring(chestCount) .. " →" }, true, function() end, RMenu:Get("gangb", "edit_chests"))

                        local garageLabel = "~c~Non défini"
                        if editState.garagePos then
                            garageLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position du garage (avec heading)", nil, { RightLabel = garageLabel }, true, function(_, _, selected)
                            if selected then
                                local p, h = capturePosHeading()
                                editState.garagePos = p
                                editState.garageHeading = h
                                ESX.ShowNotification("~g~Garage défini.")
                            end
                        end)

                        local storeLabel = "~c~Non défini"
                        if editState.vehicleStorePos then
                            storeLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position de rangement véhicule", nil, { RightLabel = storeLabel }, true, function(_, _, selected)
                            if selected then
                                editState.vehicleStorePos = capturePos()
                                ESX.ShowNotification("~g~Rangement véhicule défini.")
                            end
                        end)

                        local retLabel = "~c~Non défini"
                        if editState.vehicleRetrievePos then
                            retLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position de sortie véhicule", nil, { RightLabel = retLabel }, true, function(_, _, selected)
                            if selected then
                                editState.vehicleRetrievePos = capturePos()
                                ESX.ShowNotification("~g~Sortie véhicule définie.")
                            end
                        end)

                        RageUI.Checkbox("Point de blanchiment", nil, editState.launderingEnabled, {}, function(_, _, selected, checked)
                            if selected then
                                editState.launderingEnabled = checked
                                if not checked then
                                    editState.launderingPos = nil
                                end
                            end
                        end)

                        if editState.launderingEnabled then
                            local lLabel = "~c~Non défini"
                            if editState.launderingPos then
                                lLabel = "✅"
                            end
                            RageUI.ButtonWithStyle("Définir position blanchiment", nil, { RightLabel = lLabel }, true, function(_, _, selected)
                                if selected then
                                    editState.launderingPos = capturePos()
                                    ESX.ShowNotification("~g~Blanchiment défini.")
                                end
                            end)
                        end

                        RageUI.ButtonWithStyle("Rangs", nil, { RightLabel = tostring(#editState.ranks) .. " →" }, true, function() end, RMenu:Get("gangb", "edit_ranks"))

                        RageUI.Separator(" ")

                        RageUI.ButtonWithStyle("Sauvegarder", nil, { RightLabel = "→→→" }, true, function(_, _, selected)
                            if not selected then
                                return
                            end

                            local selectedWeapons = {}
                            for i = 1, #Config.AvailableWeapons do
                                local w = Config.AvailableWeapons[i]
                                if editState.armoryWeapons[w.item] == true then
                                    selectedWeapons[#selectedWeapons + 1] = {
                                        item = w.item,
                                        label = w.label,
                                        price = w.price,
                                    }
                                end
                            end

                            local payload = {
                                name = editState.name,
                                type = Config.Types[editState.typeIndex],
                                territory_color = editState.territoryColor,
                                armory = {
                                    pos = editState.armoryPos,
                                    weapons = selectedWeapons,
                                },
                                chests = editState.chests,
                                garage = {
                                    pos = editState.garagePos,
                                    heading = editState.garageHeading,
                                },
                                vehicle_store = {
                                    pos = editState.vehicleStorePos,
                                },
                                vehicle_retrieve = {
                                    pos = editState.vehicleRetrievePos,
                                },
                                laundering = {
                                    enabled = editState.launderingEnabled,
                                    pos = editState.launderingPos,
                                },
                                management = {
                                    pos = editState.managementPos,
                                },
                                ranks = editState.ranks,
                            }

                            TriggerServerEvent("gangbuilder:updateGang", editGangId, payload)
                        end)

                        RageUI.ButtonWithStyle("~r~Supprimer le gang", "~r~Action irréversible", { RightLabel = "X" }, true, function(_, _, selected)
                            if selected then
                                TriggerServerEvent("gangbuilder:deleteGang", editGangId)
                                editGangId = nil
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_armory"), true, true, true, function()
                        previewMode = "edit"

                        local posLabel = "~c~Non défini"
                        if editState.armoryPos then
                            posLabel = "✅"
                        end

                        RageUI.ButtonWithStyle("Position de l'armurerie", nil, { RightLabel = posLabel }, true, function(_, _, selected)
                            if selected then
                                editState.armoryPos = capturePos()
                                ESX.ShowNotification("~g~Armurerie position définie.")
                            end
                        end)

                        RageUI.Separator("Armes disponibles")

                        for i = 1, #Config.AvailableWeapons do
                            local w = Config.AvailableWeapons[i]
                            local enabled = editState.armoryWeapons[w.item] == true
                            local rl = string.format("%s$", tostring(w.price))
                            RageUI.Checkbox(w.label .. " (" .. rl .. ")", w.item, enabled, {}, function(_, _, selected, checked)
                                if selected then
                                    editState.armoryWeapons[w.item] = checked
                                end
                            end)
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_chests"), true, true, true, function()
                        previewMode = "edit"

                        RageUI.ButtonWithStyle("Ajouter un coffre", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                editChestCapIndex = 1
                            end
                        end, RMenu:Get("gangb", "edit_chest_add"))

                        if #editState.chests == 0 then
                            RageUI.Separator("Aucun coffre")
                            return
                        end

                        RageUI.Separator("Coffres configurés")

                        for i = 1, #editState.chests do
                            local c = editState.chests[i]
                            local valid = c and c.pos and c.pos.x and c.pos.y and c.pos.z
                            local desc = valid and ("Capacité: %sKG | Pos: %.2f %.2f %.2f"):format(tostring(c.weight), c.pos.x, c.pos.y, c.pos.z) or "~r~Données invalides"

                            RageUI.ButtonWithStyle(
                                ("Coffre #%d"):format(i),
                                desc,
                                { RightLabel = "→" },
                                true,
                                function(_, _, selected)
                                    if selected then
                                        editChestDetailIndex = i
                                        editChestStockIndex = i
                                        refreshEditChestStock()
                                    end
                                end,
                                RMenu:Get("gangb", "edit_chest_detail")
                            )
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_chest_detail"), true, true, true, function()
                        previewMode = "edit"

                        local idx = tonumber(editChestDetailIndex)
                        local c = idx and editState.chests[idx]
                        if not c then
                            RageUI.Separator("~r~Aucun coffre sélectionné")
                            return
                        end

                        local posLabel = "~r~Non définie"
                        if c.pos and c.pos.x and c.pos.y and c.pos.z then
                            posLabel = ("%.1f %.1f %.1f"):format(c.pos.x, c.pos.y, c.pos.z)
                        end
                        RageUI.Separator(("Coffre #%d | Capacité: %sKG"):format(idx, tostring(c.weight)))

                        RageUI.ButtonWithStyle(
                            "Stock du coffre",
                            nil,
                            { RightLabel = "→" },
                            true,
                            function(_, _, selected)
                                if selected then
                                    editChestStockIndex = idx
                                    refreshEditChestStock()
                                end
                            end,
                            RMenu:Get("gangb", "edit_chest_stock")
                        )

                        RageUI.ButtonWithStyle("Modifier la position", posLabel, { RightLabel = "Prendre position ici" }, true, function(_, _, selected)
                            if selected then
                                c.pos = capturePos()
                                ESX.ShowNotification("~g~Position du coffre #" .. tostring(idx) .. " mise à jour.")
                            end
                        end)

                        RageUI.ButtonWithStyle("Supprimer le coffre", nil, { RightLabel = "~r~Supprimer" }, true, function(_, _, selected)
                            if selected then
                                table.remove(editState.chests, idx)
                                editChestDetailIndex = nil
                                ESX.ShowNotification("~g~Coffre supprimé.")
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_chest_stock"), true, true, true, function()
                        previewMode = "edit"

                        if not editChestStockIndex then
                            RageUI.Separator("~r~Aucun coffre sélectionné")
                            return
                        end

                        local cap = tonumber(editChestStock.capacity) or 0
                        RageUI.Separator(("Coffre #%d | Capacité: %s"):format(editChestStockIndex, tostring(cap)))

                        RageUI.ButtonWithStyle("Rafraîchir", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                refreshEditChestStock()
                            end
                        end)

                        RageUI.Separator(" ")

                        RageUI.ButtonWithStyle("Ajouter un objet", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if not selected then
                                return
                            end

                            local item = KeyboardInput("Nom item (ex: bread)", "", 64)
                            if not item or item:gsub("%s+", "") == "" then
                                ESX.ShowNotification("~r~Item invalide.")
                                return
                            end

                            local qty = KeyboardInput("Quantité à ajouter", "1", 10)
                            local n = tonumber(qty)
                            if not n or n <= 0 then
                                ESX.ShowNotification("~r~Quantité invalide.")
                                return
                            end

                            ESX.TriggerServerCallback("gangbuilder:admin:chest:add", function(ok, msg, newInv)
                                if not ok then
                                    ESX.ShowNotification("~r~" .. tostring(msg or "Erreur"))
                                    return
                                end
                                ESX.ShowNotification("~g~" .. tostring(msg or "OK"))
                                if type(newInv) == "table" then
                                    editChestStock.items = newInv
                                else
                                    refreshEditChestStock()
                                end
                            end, stockGangName(), tonumber(editChestStockIndex), tostring(item), tonumber(n))
                        end)

                        RageUI.Separator("Contenu")

                        local items = (type(editChestStock.items) == "table") and editChestStock.items or {}
                        if #items == 0 then
                            RageUI.Separator("~c~Vide")
                            return
                        end

                        for i = 1, #items do
                            local it = items[i]
                            local label = tostring((it and it.label) or (it and it.name) or "Item")
                            local count = tonumber(it and it.count) or 0

                            RageUI.ButtonWithStyle(
                                label,
                                nil,
                                { RightLabel = ("x%d →"):format(count) },
                                count > 0,
                                function(_, _, selected)
                                    if not selected then
                                        return
                                    end

                                    local qty = KeyboardInput(("Quantité à retirer (max %d)"):format(count), "1", 10)
                                    local n = tonumber(qty)
                                    if not n or n <= 0 or n > count then
                                        ESX.ShowNotification("~r~Quantité invalide.")
                                        return
                                    end

                                    ESX.TriggerServerCallback("gangbuilder:admin:chest:remove", function(ok, msg, newInv)
                                        if not ok then
                                            ESX.ShowNotification("~r~" .. tostring(msg or "Erreur"))
                                            return
                                        end
                                        ESX.ShowNotification("~g~" .. tostring(msg or "OK"))
                                        if type(newInv) == "table" then
                                            editChestStock.items = newInv
                                        else
                                            refreshEditChestStock()
                                        end
                                    end, stockGangName(), tonumber(editChestStockIndex), tonumber(i), tonumber(n))
                                end
                            )
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_chest_add"), true, true, true, function()
                        previewMode = "edit"

                        if not Config or not Config.ChestCapacities or #Config.ChestCapacities == 0 then
                            RageUI.Separator("~r~Aucune capacité configurée")
                            return
                        end

                        if #capacityLabels == 0 then
                            rebuildCapacityLabels()
                        end

                        RageUI.List("Capacité", capacityLabels, editChestCapIndex, nil, {}, true, function(_, _, _, index)
                            editChestCapIndex = index
                        end)

                        RageUI.ButtonWithStyle("Prendre position ici", nil, { RightLabel = "OK" }, true, function(_, _, selected)
                            if selected then
                                local cap = Config.ChestCapacities[editChestCapIndex]
                                if not cap then
                                    ESX.ShowNotification("~r~Capacité invalide (config).")
                                    return
                                end

                                local p = capturePos()
                                editState.chests[#editState.chests + 1] = {
                                    pos = p,
                                    weight = cap.weight,
                                    label = cap.label,
                                }

                                ESX.ShowNotification("~g~Coffre ajouté.")
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "create_ranks"), true, true, true, function()
                        previewMode = "create"

                        RageUI.ButtonWithStyle("Ajouter un rang", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                local label = KeyboardInput("Label du rang", "", 32)
                                if not label or label:gsub("%s+", "") == "" then
                                    ESX.ShowNotification("~r~Label invalide.")
                                    return
                                end

                                local id = nextRankId(createState.ranks)
                                createState.ranks[#createState.ranks + 1] = {
                                    id = id,
                                    label = label,
                                    perms = {},
                                }
                                ensureRankPerms(createState.ranks[#createState.ranks])
                                createRankIndex = #createState.ranks
                            end
                        end, RMenu:Get("gangb", "create_rank_edit"))

                        if #createState.ranks == 0 then
                            RageUI.Separator("Aucun rang")
                            return
                        end

                        RageUI.Separator("Rangs")
                        for i = 1, #createState.ranks do
                            local r = createState.ranks[i]
                            local rl = "ID: " .. tostring(r.id or "?")
                            RageUI.ButtonWithStyle(r.label or "?", nil, { RightLabel = rl .. " →" }, true, function(_, _, selected)
                                if selected then
                                    createRankIndex = i
                                    ensureRankPerms(createState.ranks[i])
                                end
                            end, RMenu:Get("gangb", "create_rank_edit"))
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "create_rank_edit"), true, true, true, function()
                        previewMode = "create"

                        if not createRankIndex or not createState.ranks[createRankIndex] then
                            RageUI.Separator("~r~Aucun rang sélectionné")
                            return
                        end

                        local r = createState.ranks[createRankIndex]
                        ensureRankPerms(r)

                        RageUI.Separator("ID: " .. tostring(r.id or "?"))

                        RageUI.ButtonWithStyle("Label", nil, { RightLabel = (r.label and r.label ~= "" and r.label or "~c~Non défini") }, true, function(_, _, selected)
                            if selected then
                                local label = KeyboardInput("Label du rang", r.label or "", 32)
                                if label and label:gsub("%s+", "") ~= "" then
                                    r.label = label
                                else
                                    ESX.ShowNotification("~r~Label invalide.")
                                end
                            end
                        end)

                        RageUI.Separator("Permissions")

                        for i = 1, #Config.RankPermissions do
                            local p = Config.RankPermissions[i]
                            if p.key == "laundering_access" and createState.launderingEnabled ~= true then
                                RageUI.Separator("~c~Blanchiment inactif pour ce gang")
                            else
                                RageUI.Checkbox(p.label, nil, r.perms[p.key] == true, {}, function(_, _, selected, checked)
                                    if selected then
                                        r.perms[p.key] = checked
                                    end
                                end)
                            end
                        end

                        RageUI.Separator(" ")

                        RageUI.ButtonWithStyle("~r~Supprimer ce rang", nil, { RightLabel = "X" }, true, function(_, _, selected)
                            if selected then
                                table.remove(createState.ranks, createRankIndex)
                                createRankIndex = nil
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_ranks"), true, true, true, function()
                        previewMode = "edit"

                        if not editGangId then
                            RageUI.Separator("~r~Aucun gang sélectionné")
                            return
                        end

                        RageUI.ButtonWithStyle("Ajouter un rang", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                local label = KeyboardInput("Label du rang", "", 32)
                                if not label or label:gsub("%s+", "") == "" then
                                    ESX.ShowNotification("~r~Label invalide.")
                                    return
                                end

                                local id = nextRankId(editState.ranks)
                                editState.ranks[#editState.ranks + 1] = {
                                    id = id,
                                    label = label,
                                    perms = {},
                                }
                                ensureRankPerms(editState.ranks[#editState.ranks])
                                editRankIndex = #editState.ranks
                            end
                        end, RMenu:Get("gangb", "edit_rank_edit"))

                        if #editState.ranks == 0 then
                            RageUI.Separator("Aucun rang")
                            return
                        end

                        RageUI.Separator("Rangs")
                        for i = 1, #editState.ranks do
                            local r = editState.ranks[i]
                            local rl = "ID: " .. tostring(r.id or "?")
                            RageUI.ButtonWithStyle(r.label or "?", nil, { RightLabel = rl .. " →" }, true, function(_, _, selected)
                                if selected then
                                    editRankIndex = i
                                    ensureRankPerms(editState.ranks[i])
                                end
                            end, RMenu:Get("gangb", "edit_rank_edit"))
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "edit_rank_edit"), true, true, true, function()
                        previewMode = "edit"

                        if not editRankIndex or not editState.ranks[editRankIndex] then
                            RageUI.Separator("~r~Aucun rang sélectionné")
                            return
                        end

                        local r = editState.ranks[editRankIndex]
                        ensureRankPerms(r)

                        RageUI.Separator("ID: " .. tostring(r.id or "?"))

                        RageUI.ButtonWithStyle("Label", nil, { RightLabel = (r.label and r.label ~= "" and r.label or "~c~Non défini") }, true, function(_, _, selected)
                            if selected then
                                local label = KeyboardInput("Label du rang", r.label or "", 32)
                                if label and label:gsub("%s+", "") ~= "" then
                                    r.label = label
                                else
                                    ESX.ShowNotification("~r~Label invalide.")
                                end
                            end
                        end)

                        RageUI.Separator("Permissions")

                        for i = 1, #Config.RankPermissions do
                            local p = Config.RankPermissions[i]
                            if p.key == "laundering_access" and editState.launderingEnabled ~= true then
                                RageUI.Separator("~c~Blanchiment inactif pour ce gang")
                            else
                                RageUI.Checkbox(p.label, nil, r.perms[p.key] == true, {}, function(_, _, selected, checked)
                                    if selected then
                                        r.perms[p.key] = checked
                                    end
                                end)
                            end
                        end

                        RageUI.Separator(" ")

                        RageUI.ButtonWithStyle("~r~Supprimer ce rang", nil, { RightLabel = "X" }, true, function(_, _, selected)
                            if selected then
                                table.remove(editState.ranks, editRankIndex)
                                editRankIndex = nil
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "create"), true, true, true, function()
                        previewMode = "create"

                        RageUI.ButtonWithStyle("Nom du gang", nil, { RightLabel = (createState.name ~= "" and createState.name or "~c~Non défini") }, true, function(_, _, selected)
                            if selected then
                                local input = KeyboardInput("Nom du gang", createState.name, 64)
                                if input and input:gsub("%s+", "") ~= "" then
                                    createState.name = input
                                else
                                    ESX.ShowNotification("~r~Nom invalide.")
                                end
                            end
                        end)

                        RageUI.List("Type de groupe", Config.Types, createState.typeIndex, nil, {}, true, function(_, _, _, index)
                            createState.typeIndex = index
                        end)

                        RageUI.ButtonWithStyle("Couleur du territoire (blip)", nil, { RightLabel = tostring(createState.territoryColor) }, true, function(_, _, selected)
                            if selected then
                                local input = KeyboardInput("Couleur du territoire (nombre)", tostring(createState.territoryColor), 8)
                                local num = tonumber(input)
                                if num then
                                    createState.territoryColor = math.floor(num)
                                else
                                    ESX.ShowNotification("~r~Valeur invalide.")
                                end
                            end
                        end)

                        local mgmtLabel = "~c~Non défini"
                        if createState.managementPos then
                            mgmtLabel = "✅"
                        end

                        RageUI.ButtonWithStyle("Position du point de gestion", nil, { RightLabel = mgmtLabel }, true, function(_, _, selected)
                            if selected then
                                createState.managementPos = capturePos()
                                ESX.ShowNotification("~g~Point de gestion défini.")
                            end
                        end)

                        RageUI.ButtonWithStyle("Configurer l'armurerie", nil, { RightLabel = "→" }, true, function() end, RMenu:Get("gangb", "armory"))

                        local chestCount = #createState.chests
                        RageUI.ButtonWithStyle("Positions des coffres", nil, { RightLabel = tostring(chestCount) .. " →" }, true, function() end, RMenu:Get("gangb", "chests"))

                        local garageLabel = "~c~Non défini"
                        if createState.garagePos then
                            garageLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position du garage (avec heading)", nil, { RightLabel = garageLabel }, true, function(_, _, selected)
                            if selected then
                                local p, h = capturePosHeading()
                                createState.garagePos = p
                                createState.garageHeading = h
                                ESX.ShowNotification("~g~Garage défini.")
                            end
                        end)

                        local storeLabel = "~c~Non défini"
                        if createState.vehicleStorePos then
                            storeLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position de rangement véhicule", nil, { RightLabel = storeLabel }, true, function(_, _, selected)
                            if selected then
                                createState.vehicleStorePos = capturePos()
                                ESX.ShowNotification("~g~Rangement véhicule défini.")
                            end
                        end)

                        local retLabel = "~c~Non défini"
                        if createState.vehicleRetrievePos then
                            retLabel = "✅"
                        end
                        RageUI.ButtonWithStyle("Position de sortie véhicule", nil, { RightLabel = retLabel }, true, function(_, _, selected)
                            if selected then
                                createState.vehicleRetrievePos = capturePos()
                                ESX.ShowNotification("~g~Sortie véhicule définie.")
                            end
                        end)

                        RageUI.Checkbox("Point de blanchiment", nil, createState.launderingEnabled, {}, function(_, _, selected, checked)
                            if selected then
                                createState.launderingEnabled = checked
                                if not checked then
                                    createState.launderingPos = nil
                                end
                            end
                        end)

                        if createState.launderingEnabled then
                            local lLabel = "~c~Non défini"
                            if createState.launderingPos then
                                lLabel = "✅"
                            end
                            RageUI.ButtonWithStyle("Définir position blanchiment", nil, { RightLabel = lLabel }, true, function(_, _, selected)
                                if selected then
                                    createState.launderingPos = capturePos()
                                    ESX.ShowNotification("~g~Blanchiment défini.")
                                end
                            end)
                        end

                        RageUI.ButtonWithStyle("Rangs", nil, { RightLabel = tostring(#createState.ranks) .. " →" }, true, function() end, RMenu:Get("gangb", "create_ranks"))

                        RageUI.Separator(" ")

                        RageUI.ButtonWithStyle("Créer le groupe", nil, { RightLabel = "→→→" }, true, function(_, _, selected)
                            if not selected then
                                return
                            end

                            local selectedWeapons = {}
                            for i = 1, #Config.AvailableWeapons do
                                local w = Config.AvailableWeapons[i]
                                if createState.armoryWeapons[w.item] == true then
                                    selectedWeapons[#selectedWeapons + 1] = {
                                        item = w.item,
                                        label = w.label,
                                        price = w.price,
                                    }
                                end
                            end

                            local payload = {
                                name = createState.name,
                                type = Config.Types[createState.typeIndex],
                                territory_color = createState.territoryColor,
                                armory = {
                                    pos = createState.armoryPos,
                                    weapons = selectedWeapons,
                                },
                                chests = createState.chests,
                                garage = {
                                    pos = createState.garagePos,
                                    heading = createState.garageHeading,
                                },
                                vehicle_store = {
                                    pos = createState.vehicleStorePos,
                                },
                                vehicle_retrieve = {
                                    pos = createState.vehicleRetrievePos,
                                },
                                laundering = {
                                    enabled = createState.launderingEnabled,
                                    pos = createState.launderingPos,
                                },
                                management = {
                                    pos = createState.managementPos,
                                },
                                ranks = createState.ranks,
                            }

                            TriggerServerEvent("gangbuilder:createGang", payload)
                            RageUI.GoBack()
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "armory"), true, true, true, function()
                        previewMode = "create"

                        local posLabel = "~c~Non défini"
                        if createState.armoryPos then
                            posLabel = "✅"
                        end

                        RageUI.ButtonWithStyle("Position de l'armurerie", nil, { RightLabel = posLabel }, true, function(_, _, selected)
                            if selected then
                                createState.armoryPos = capturePos()
                                ESX.ShowNotification("~g~Armurerie position définie.")
                            end
                        end)

                        RageUI.Separator("Armes disponibles")

                        for i = 1, #Config.AvailableWeapons do
                            local w = Config.AvailableWeapons[i]
                            local enabled = createState.armoryWeapons[w.item] == true
                            local rl = string.format("%s$", tostring(w.price))
                            RageUI.Checkbox(w.label .. " (" .. rl .. ")", w.item, enabled, {}, function(_, _, selected, checked)
                                if selected then
                                    createState.armoryWeapons[w.item] = checked
                                end
                            end)
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "chests"), true, true, true, function()
                        previewMode = "create"

                        RageUI.ButtonWithStyle("Ajouter un coffre", nil, { RightLabel = "→" }, true, function(_, _, selected)
                            if selected then
                                chestCapIndex = 1
                            end
                        end, RMenu:Get("gangb", "chest_add"))

                        if #createState.chests == 0 then
                            RageUI.Separator("Aucun coffre")
                            return
                        end

                        RageUI.Separator("Coffres configurés")

                        for i = 1, #createState.chests do
                            local c = createState.chests[i]
                            local valid = c and c.pos and c.pos.x and c.pos.y and c.pos.z
                            local desc = valid and ("Capacité: %sKG | Pos: %.2f %.2f %.2f"):format(tostring(c.weight), c.pos.x, c.pos.y, c.pos.z) or "~r~Données invalides"

                            RageUI.ButtonWithStyle(
                                ("Coffre #%d"):format(i),
                                desc,
                                { RightLabel = "→" },
                                true,
                                function(_, _, selected)
                                    if selected then
                                        createChestDetailIndex = i
                                    end
                                end,
                                RMenu:Get("gangb", "chest_detail")
                            )
                        end
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "chest_detail"), true, true, true, function()
                        previewMode = "create"

                        local idx = tonumber(createChestDetailIndex)
                        local c = idx and createState.chests[idx]
                        if not c then
                            RageUI.Separator("~r~Aucun coffre sélectionné")
                            return
                        end

                        local posLabel = "~r~Non définie"
                        if c.pos and c.pos.x and c.pos.y and c.pos.z then
                            posLabel = ("%.1f %.1f %.1f"):format(c.pos.x, c.pos.y, c.pos.z)
                        end
                        RageUI.Separator(("Coffre #%d | Capacité: %sKG"):format(idx, tostring(c.weight)))

                        RageUI.ButtonWithStyle("Modifier la position", posLabel, { RightLabel = "Prendre position ici" }, true, function(_, _, selected)
                            if selected then
                                c.pos = capturePos()
                                ESX.ShowNotification("~g~Position du coffre #" .. tostring(idx) .. " mise à jour.")
                            end
                        end)

                        RageUI.ButtonWithStyle("Supprimer le coffre", nil, { RightLabel = "~r~Supprimer" }, true, function(_, _, selected)
                            if selected then
                                table.remove(createState.chests, idx)
                                createChestDetailIndex = nil
                                ESX.ShowNotification("~g~Coffre supprimé.")
                                RageUI.GoBack()
                            end
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("gangb", "chest_add"), true, true, true, function()
                        previewMode = "create"

                        if not Config or not Config.ChestCapacities or #Config.ChestCapacities == 0 then
                            RageUI.Separator("~r~Aucune capacité configurée")
                            RageUI.Separator("Vérifie config.lua + fxmanifest.lua")
                            return
                        end

                        if #capacityLabels == 0 then
                            rebuildCapacityLabels()
                        end

                        RageUI.List("Capacité", capacityLabels, chestCapIndex, nil, {}, true, function(_, _, _, index)
                            chestCapIndex = index
                        end)

                        RageUI.ButtonWithStyle("Prendre position ici", nil, { RightLabel = "OK" }, true, function(_, _, selected)
                            if selected then
                                local cap = Config.ChestCapacities[chestCapIndex]
                                if not cap then
                                    ESX.ShowNotification("~r~Capacité invalide (config).")
                                    return
                                end

                                local p = capturePos()
                                createState.chests[#createState.chests + 1] = {
                                    pos = p,
                                    weight = cap.weight,
                                    label = cap.label,
                                }

                                ESX.ShowNotification("~g~Coffre ajouté.")
                                RageUI.GoBack()
                            end
                        end)
                    end)
                end
            end)
        end)
    end)
end

RegisterCommand(Config.Command, function()
    if IsPedDeadOrDying(PlayerPedId(), false) then
        return
    end
    openGangBuilder()
end, false)

RegisterCommand("setg", function(source, args)
    local targetId = tonumber(args[1])
    local gangName = args[2]
    local rankId = tonumber(args[3])

    if not targetId or not gangName or gangName == "" then
        ESX.ShowNotification("~r~Usage: /setg <id> <nomdugroupe|sansgroupe> [idrank]")
        return
    end

    gangName = tostring(gangName):gsub("^%s+", ""):gsub("%s+$", "")
    local lowered = string.lower(gangName)

    if lowered == "sansgroupe" or lowered == "aucun" or lowered == "none" then
        TriggerServerEvent("gangbuilder:members:removeGang", targetId)
        return
    end

    if not rankId then
        ESX.ShowNotification("~r~Usage: /setg <id> <nomdugroupe> <idrank>")
        return
    end

    TriggerServerEvent("gangbuilder:members:setGang", targetId, gangName, rankId)
end, false)

RegisterCommand("unsetg", function(source, args)
    local targetId = tonumber(args[1])

    if not targetId then
        ESX.ShowNotification("~r~Usage: /unsetg <id>")
        return
    end

    TriggerServerEvent("gangbuilder:members:removeGang", targetId)
end, false)
