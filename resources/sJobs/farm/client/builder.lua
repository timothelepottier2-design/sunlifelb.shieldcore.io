local builderOpen = false
BUILDER = {}
BUILDER.ItemsCache = {}

RMenu.Add('builder', 'main',     RageUI.CreateMenu("SunLife", "Job creator",            1, 100))
RMenu.Add('builder', 'pos',      RageUI.CreateSubMenu(RMenu:Get('builder', 'main'),  "SunLife", "Positions"))
RMenu.Add('builder', 'items',    RageUI.CreateSubMenu(RMenu:Get('builder', 'main'),  "SunLife", "Items"))
RMenu.Add('builder', 'garage',   RageUI.CreateSubMenu(RMenu:Get('builder', 'main'),  "SunLife", "Garage"))
RMenu.Add('builder', 'itemPick', RageUI.CreateSubMenu(RMenu:Get('builder', 'items'), "SunLife", "Choisir un item"))

for _, k in ipairs({ 'main', 'pos', 'items', 'garage', 'itemPick' }) do
    RMenu:Get('builder', k):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('builder', k).EnableMouse = false
end

RMenu:Get('builder', 'main').Closed = function()
    builderOpen = false
end

local function ResetBuilderData()
    BUILDER.Data = {
        metier       = "exemple",
        metierMaj    = "Exemple",
        washMoney    = false,
        actionPatron = vector3(0, 0, 0),
        vestiaire    = vector3(0, 0, 0),
        coffre       = vector3(0, 0, 0),
        coffrePatron = false,

        blips_info = {
            actionPatron = { name = "Action Patron" },
        },

        recolte = {
            zone  = vector3(0, 0, 0),
            limit = 10,
            item  = "",
            msg   = "~g~Récolte en cours...",
        },
        traitement = {
            zone          = vector3(0, 0, 0),
            limit         = 250,
            itemTraite    = "",
            item          = "",
            item_required = 100,
            give          = 100,
            msg           = "",
        },
        vente = {
            zone          = vector3(0, 0, 0),
            itemVente     = "",
            item_required = 100,
            msg           = "",
        },
        garage = {
            vehicule     = {},
            xenon        = true,
            fullCustom   = true,
            color1       = 0,
            color2       = 0,
            garagePos    = vector3(0, 0, 0),
            pointDeSpawn = {
                { pos = vector3(0, 0, 0), heading = 0.0 },
            },
        },

        newItems = {},
    }
end

ResetBuilderData()

function BUILDER.InputString(label, maxLen, defaultVal)
    local input = lib.inputDialog("Builder - " .. tostring(label), {
        {
            type     = "input",
            label    = label,
            default  = defaultVal and tostring(defaultVal) or nil,
            max      = maxLen or 30,
            required = true,
        },
    })
    if not input or not input[1] then return nil end
    return input[1]
end

function BUILDER.InputNumber(label, default, min, max)
    local input = lib.inputDialog("Builder - " .. tostring(label), {
        {
            type     = "number",
            label    = label,
            default  = tonumber(default),
            min      = min,
            max      = max,
            required = true,
        },
    })
    if not input or input[1] == nil then return nil end
    return tonumber(input[1])
end

local function isValidStr(s)
    return s ~= nil and s ~= "" and s ~= " " and s ~= "exemple"
end

local function v3IsZero(v)
    return v == vector3(0, 0, 0)
end

local function checkMark(b)
    return b and "✅" or "❌"
end

local function fmtPos(v)
    if v3IsZero(v) then return "❌" end
    return ("%.1f, %.1f, %.1f"):format(v.x, v.y, v.z)
end

local function refreshItemsList()
    ESX.TriggerServerCallback('farm:builder:getItems', function(items)
        BUILDER.ItemsCache = items or {}
    end)
end

local pickTarget = nil

local function selectItem(target)
    pickTarget = target
    refreshItemsList()
    RageUI.Visible(RMenu:Get('builder', 'itemPick'), true)
end

local function applyItemSelection(itemName)
    if not isValidStr(itemName) then return end
    if pickTarget == "recolte" then
        BUILDER.Data.recolte.item       = itemName
        BUILDER.Data.traitement.itemTraite = itemName
    elseif pickTarget == "traitement" then
        BUILDER.Data.traitement.item = itemName
        BUILDER.Data.vente.itemVente = itemName
    end
    pickTarget = nil

    RageUI.GoBack()
end

local adminCache = { value = nil, ts = 0 }
local ADMIN_CACHE_TTL_MS = 60 * 1000

local function checkSuperadmin(cb)
    local now = GetGameTimer()
    if adminCache.value ~= nil and (now - adminCache.ts) < ADMIN_CACHE_TTL_MS then
        return cb(adminCache.value)
    end
    ESX.TriggerServerCallback('farm:builder:isSuperadmin', function(isAdmin)
        adminCache.value = isAdmin == true
        adminCache.ts    = GetGameTimer()
        cb(adminCache.value)
    end)
end

RegisterCommand("createJob", function()

    checkSuperadmin(function(isAdmin)
        if not isAdmin then
            ESX.ShowNotification("~r~Acces refuse : reserve aux superadmin")
            return
        end
        TriggerServerEvent("openccreatorjobmenu")
    end)
end, false)

RegisterNetEvent('openmenuzeub', function()
    checkSuperadmin(function(isAdmin)
        if not isAdmin then return end
        OpenBuilderMenu()
    end)
end)

local function drawMarkers()
    local D = BUILDER.Data

    if not v3IsZero(D.actionPatron) then
        DrawMarker(20, D.actionPatron, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   0.3, 0.3, 0.3, 255, 117, 31, 225, 1, 0, 2, 1, nil, nil, 0)
    end
    if not v3IsZero(D.vestiaire) then
        DrawMarker(25, D.vestiaire - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   1.0, 1.0, 1.0, 100, 200, 255, 225, 0, 0, 2, 1, nil, nil, 0)
    end
    if D.coffrePatron and not v3IsZero(D.coffre) then
        DrawMarker(25, D.coffre - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   1.0, 1.0, 1.0, 255, 117, 31, 225, 0, 0, 2, 1, nil, nil, 0)
    end
    if not v3IsZero(D.recolte.zone) then
        DrawMarker(25, D.recolte.zone - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   5.0, 5.0, 5.0, 100, 255, 100, 225, 0, 0, 2, 1, nil, nil, 0)
    end
    if not v3IsZero(D.traitement.zone) then
        DrawMarker(25, D.traitement.zone - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   5.0, 5.0, 5.0, 255, 200, 50, 225, 0, 0, 2, 1, nil, nil, 0)
    end
    if not v3IsZero(D.vente.zone) then
        DrawMarker(25, D.vente.zone - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   5.0, 5.0, 5.0, 255, 50, 50, 225, 0, 0, 2, 1, nil, nil, 0)
    end
    if not v3IsZero(D.garage.garagePos) then
        DrawMarker(25, D.garage.garagePos - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   1.0, 1.0, 1.0, 200, 200, 200, 225, 0, 0, 2, 1, nil, nil, 0)
    end
end

local function validateAndSubmit()
    local D = BUILDER.Data
    local errors = {}

    if not isValidStr(D.metier) or D.metier == "exemple" then
        errors[#errors+1] = "metier (nom interne)"
    end
    if not isValidStr(D.metierMaj) or D.metierMaj == "Exemple" then
        errors[#errors+1] = "metierMaj (label affiche)"
    end
    if v3IsZero(D.actionPatron) then errors[#errors+1] = "position action patron" end
    if v3IsZero(D.vestiaire)    then errors[#errors+1] = "position vestiaire"     end
    if D.coffrePatron and v3IsZero(D.coffre) then errors[#errors+1] = "position coffre" end
    if v3IsZero(D.recolte.zone)    then errors[#errors+1] = "position recolte"    end
    if v3IsZero(D.traitement.zone) then errors[#errors+1] = "position traitement" end
    if v3IsZero(D.vente.zone)      then errors[#errors+1] = "position vente"      end
    if v3IsZero(D.garage.garagePos) then errors[#errors+1] = "position garage"    end
    if v3IsZero(D.garage.pointDeSpawn[1].pos) then errors[#errors+1] = "position spawn vehicule" end
    if not isValidStr(D.recolte.item)    then errors[#errors+1] = "item recolte"    end
    if not isValidStr(D.traitement.item) then errors[#errors+1] = "item traitement" end
    if #D.garage.vehicule == 0 then errors[#errors+1] = "au moins un vehicule" end

    if #errors > 0 then
        ESX.ShowNotification("~r~Manquant : " .. table.concat(errors, ", "))
        return
    end

    if not isValidStr(D.traitement.msg) then
        D.traitement.msg = ("~r~-%d %s\n~g~+%d %s"):format(
            D.traitement.item_required, D.traitement.itemTraite,
            D.traitement.give, D.traitement.item)
    end
    if not isValidStr(D.vente.msg) then
        D.vente.msg = ("~r~-%d %s"):format(D.vente.item_required, D.vente.itemVente)
    end

    TriggerServerEvent("farm:server:createSociety", D)
    ESX.ShowNotification("~g~Demande envoyee. Verifie les notifications staff.")
    ResetBuilderData()
end

local function setPosFromPlayer(target)
    if target == "actionPatron" then
        BUILDER.Data.actionPatron = GetEntityCoords(PlayerPedId())
    elseif target == "vestiaire" then
        BUILDER.Data.vestiaire = GetEntityCoords(PlayerPedId())
    elseif target == "coffre" then
        BUILDER.Data.coffre = GetEntityCoords(PlayerPedId())
    elseif target == "recolte" then
        BUILDER.Data.recolte.zone = GetEntityCoords(PlayerPedId())
    elseif target == "traitement" then
        BUILDER.Data.traitement.zone = GetEntityCoords(PlayerPedId())
    elseif target == "vente" then
        BUILDER.Data.vente.zone = GetEntityCoords(PlayerPedId())
    elseif target == "garagePos" then
        BUILDER.Data.garage.garagePos = GetEntityCoords(PlayerPedId())
    elseif target == "garageSpawn" then
        BUILDER.Data.garage.pointDeSpawn[1].pos     = GetEntityCoords(PlayerPedId())
        BUILDER.Data.garage.pointDeSpawn[1].heading = GetEntityHeading(PlayerPedId())
    end
end

local function renderMain()
    local D = BUILDER.Data

    RageUI.ButtonWithStyle("Nom interne (metier)", "Lowercase, sans espace. Ex: tabac",
        { RightLabel = D.metier }, true, function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputString("Nom interne", 30, D.metier)
            if isValidStr(v) then
                D.metier = string.lower(v):gsub("%s+", "")
            end
        end
    end)

    RageUI.ButtonWithStyle("Label affiche", "Visible en jeu. Ex: Tabagiste",
        { RightLabel = D.metierMaj }, true, function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputString("Label", 50, D.metierMaj)
            if isValidStr(v) then D.metierMaj = v end
        end
    end)

    RageUI.Checkbox("Blanchiment", "Activer le menu blanchiment patron",
        D.washMoney, {}, function(_, _, _, Checked)
        D.washMoney = Checked
    end)

    RageUI.Checkbox("Coffre patron", "Le metier a-t-il un coffre patron ?",
        D.coffrePatron, {}, function(_, _, _, Checked)
        D.coffrePatron = Checked
    end)

    RageUI.Separator("Configuration")

    RageUI.ButtonWithStyle("Positions", "", { RightLabel = "→" }, true,
        function() end, RMenu:Get('builder', 'pos'))
    RageUI.ButtonWithStyle("Items (recolte / produit)", "", { RightLabel = "→" }, true,
        function() end, RMenu:Get('builder', 'items'))
    RageUI.ButtonWithStyle("Garage et vehicules", "",
        { RightLabel = ("%d vehicules"):format(#D.garage.vehicule) }, true,
        function() end, RMenu:Get('builder', 'garage'))

    RageUI.Separator("Validation")

    RageUI.ButtonWithStyle("✅ Creer l'entreprise", "Insertion BDD + reload requis",
        { RightLabel = "" }, true, function(_, _, Selected)
        if Selected then validateAndSubmit() end
    end)

    RageUI.ButtonWithStyle("🔄 Reset", "Repart de zero",
        { RightLabel = "" }, true, function(_, _, Selected)
        if Selected then
            ResetBuilderData()
            ESX.ShowNotification("Builder reset")
        end
    end)
end

local function renderPos()
    local D = BUILDER.Data
    RageUI.Separator("Patron")
    RageUI.ButtonWithStyle("Action patron", fmtPos(D.actionPatron),
        { RightLabel = checkMark(not v3IsZero(D.actionPatron)) }, true, function(_, _, Selected)
        if Selected then setPosFromPlayer("actionPatron") end
    end)
    RageUI.ButtonWithStyle("Vestiaire", fmtPos(D.vestiaire),
        { RightLabel = checkMark(not v3IsZero(D.vestiaire)) }, true, function(_, _, Selected)
        if Selected then setPosFromPlayer("vestiaire") end
    end)
    if D.coffrePatron then
        RageUI.ButtonWithStyle("Coffre patron", fmtPos(D.coffre),
            { RightLabel = checkMark(not v3IsZero(D.coffre)) }, true, function(_, _, Selected)
            if Selected then setPosFromPlayer("coffre") end
        end)
    end

    RageUI.Separator("Zones de travail")
    RageUI.ButtonWithStyle("Recolte", fmtPos(D.recolte.zone),
        { RightLabel = checkMark(not v3IsZero(D.recolte.zone)) }, true, function(_, _, Selected)
        if Selected then setPosFromPlayer("recolte") end
    end)
    RageUI.ButtonWithStyle("Traitement", fmtPos(D.traitement.zone),
        { RightLabel = checkMark(not v3IsZero(D.traitement.zone)) }, true, function(_, _, Selected)
        if Selected then setPosFromPlayer("traitement") end
    end)
    RageUI.ButtonWithStyle("Vente", fmtPos(D.vente.zone),
        { RightLabel = checkMark(not v3IsZero(D.vente.zone)) }, true, function(_, _, Selected)
        if Selected then setPosFromPlayer("vente") end
    end)
end

local function renderItems()
    local D = BUILDER.Data

    RageUI.Separator("Item de recolte (matiere premiere)")
    RageUI.ButtonWithStyle("Item recolte", "Item gather + traite",
        { RightLabel = D.recolte.item ~= "" and D.recolte.item or "❌" }, true,
        function(_, _, Selected)
        if Selected then selectItem("recolte") end
    end)

    RageUI.Separator("Item produit (vendu)")
    RageUI.ButtonWithStyle("Item produit", "Item resultat traitement + vendu",
        { RightLabel = D.traitement.item ~= "" and D.traitement.item or "❌" }, true,
        function(_, _, Selected)
        if Selected then selectItem("traitement") end
    end)

    RageUI.Separator("Quantites")
    RageUI.ButtonWithStyle("Limite recolte", "Combien d'items recoltes par cycle (1..50)",
        { RightLabel = tostring(D.recolte.limit) }, true, function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputNumber("Limite recolte (1..50)", D.recolte.limit, 1, 50)
            if v then D.recolte.limit = v end
        end
    end)
    RageUI.ButtonWithStyle("Limite traitement (poids)", "Capacite traitement en poids (50..20000)",
        { RightLabel = tostring(D.traitement.limit) }, true, function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputNumber("Limite traitement (50..20000)", D.traitement.limit, 50, 20000)
            if v then D.traitement.limit = v end
        end
    end)
    RageUI.ButtonWithStyle("Quantite required (vente/traitement)",
        "Items requis par operation vente+traitement (1..500)",
        { RightLabel = tostring(D.vente.item_required) }, true, function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputNumber("Quantite required (1..500)", D.vente.item_required, 1, 500)
            if v then
                D.vente.item_required = v
                D.traitement.item_required = v
                D.traitement.give = v
            end
        end
    end)
end

local function renderItemPick()
    if not pickTarget then return end

    RageUI.Separator(("Choisir un item pour : %s"):format(pickTarget))

    RageUI.ButtonWithStyle("➕ Creer un nouvel item", "Insertion en BDD",
        { RightLabel = "" }, true, function(_, _, Selected)
        if Selected then
            local input = lib.inputDialog("Nouvel item", {
                {
                    type        = "input",
                    label       = "Nom interne",
                    description = "lowercase, sans espace, [a-z0-9_]. Ex: tabacbrun",
                    max         = 30,
                    required    = true,
                },
                {
                    type        = "input",
                    label       = "Label affiche",
                    description = "Ce que voient les joueurs. Ex: Tabac brun",
                    max         = 50,
                    required    = true,
                },
                {
                    type        = "number",
                    label       = "Poids (kg)",
                    description = "0.05 par defaut",
                    default     = 0.05,
                    min         = 0,
                    max         = 50,
                    required    = true,
                },
            })
            if not input then return end

            local name   = string.lower(tostring(input[1] or "")):gsub("%s+", "")
            local label  = tostring(input[2] or "")
            local weight = tonumber(input[3]) or 0.05

            if not name:match("^[a-z0-9_]+$") then
                ESX.ShowNotification("~r~Nom invalide (a-z, 0-9, _ uniquement)")
                return
            end
            if not isValidStr(label) then
                ESX.ShowNotification("~r~Label invalide")
                return
            end

            BUILDER.Data.newItems[#BUILDER.Data.newItems + 1] = {
                name = name, label = label, weight = weight
            }
            applyItemSelection(name)
            ESX.ShowNotification(("~g~Item '%s' pret a etre cree"):format(name))
        end
    end)

    RageUI.Separator(("Items existants (%d)"):format(#BUILDER.ItemsCache))

    local maxShow = 50
    for i = 1, math.min(#BUILDER.ItemsCache, maxShow) do
        local it = BUILDER.ItemsCache[i]
        RageUI.ButtonWithStyle(it.name, it.label, { RightLabel = "" }, true,
            function(_, _, Selected)
            if Selected then applyItemSelection(it.name) end
        end)
    end
    if #BUILDER.ItemsCache > maxShow then
        RageUI.Separator(("... %d autres (utilise + Creer pour ajouter)"):format(
            #BUILDER.ItemsCache - maxShow))
    end
end

local function renderGarage()
    local D = BUILDER.Data

    RageUI.Separator("Positions")
    RageUI.ButtonWithStyle("Position garage (entree menu)", fmtPos(D.garage.garagePos),
        { RightLabel = checkMark(not v3IsZero(D.garage.garagePos)) }, true,
        function(_, _, Selected)
        if Selected then setPosFromPlayer("garagePos") end
    end)
    RageUI.ButtonWithStyle("Spawn vehicule (pos + heading)", fmtPos(D.garage.pointDeSpawn[1].pos),
        { RightLabel = checkMark(not v3IsZero(D.garage.pointDeSpawn[1].pos)) }, true,
        function(_, _, Selected)
        if Selected then setPosFromPlayer("garageSpawn") end
    end)

    RageUI.Separator("Options")
    RageUI.Checkbox("Xenon", "", D.garage.xenon, {}, function(_, _, _, Checked)
        D.garage.xenon = Checked
    end)
    RageUI.Checkbox("Full custom", "", D.garage.fullCustom, {}, function(_, _, _, Checked)
        D.garage.fullCustom = Checked
    end)

    RageUI.Separator(("Vehicules (%d)"):format(#D.garage.vehicule))
    RageUI.ButtonWithStyle("➕ Ajouter un vehicule", "Spawn name", { RightLabel = "" }, true,
        function(_, _, Selected)
        if Selected then
            local v = BUILDER.InputString("Spawn name", 30, "")
            if isValidStr(v) then
                table.insert(D.garage.vehicule, v)
            end
        end
    end)
    for k, v in ipairs(D.garage.vehicule) do
        RageUI.ButtonWithStyle(v, "Cliquer pour retirer", { RightLabel = "❌" }, true,
            function(_, _, Selected)
            if Selected then table.remove(D.garage.vehicule, k) end
        end)
    end
end

function OpenBuilderMenu()
    if builderOpen then
        builderOpen = false
        return
    end
    builderOpen = true
    refreshItemsList()
    RageUI.Visible(RMenu:Get('builder', 'main'), true)

    Citizen.CreateThread(function()
        while builderOpen do
            drawMarkers()
            RageUI.IsVisible(RMenu:Get('builder', 'main'),     true, true, true, renderMain)
            RageUI.IsVisible(RMenu:Get('builder', 'pos'),      true, true, true, renderPos)
            RageUI.IsVisible(RMenu:Get('builder', 'items'),    true, true, true, renderItems)
            RageUI.IsVisible(RMenu:Get('builder', 'itemPick'), true, true, true, renderItemPick)
            RageUI.IsVisible(RMenu:Get('builder', 'garage'),   true, true, true, renderGarage)
            Wait(0)
        end
    end)
end
