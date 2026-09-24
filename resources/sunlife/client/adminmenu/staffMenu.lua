local isMenuOpened, cat = false, "adminmenu"
local prefix = "~r~[Admin]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local itemSearch = ""

local offlineCasierLicense = ""
local offlineCasierLoading = false
local offlineBans, offlineWarns, offlineJails = {}, {}, {}
local creditsSent = false
local rainbow_mode, rocket, drag, reason, ban_time, ban_time_name, InfStamina, gloves, sonoplz = false, false, false, nil, nil, nil, false, false, false
local unbreakable = false
local serviceStaffRec = {}
local nombreStaffActifs = 0

local giveStyle = { RightLabel = "~b~Donner ~s~→→" }
local itemsByLetter = {}
local itemsFlat = {}
local itemsCacheRef = nil

local function prepareItemsCache()
    if itemsCacheRef == items then
        return
    end

    itemsByLetter = {}
    itemsFlat = {}

    for _, itemInfos in pairs(items) do
        local label = itemInfos.label or itemInfos.name or ""
        local itemName = itemInfos.name

        local entry = {
            baseLabel = "→ ~s~" .. label,

            searchLabel = string.lower(label .. " " .. (itemName or "")),
            giveCb = function(_, _, s)
                if s then
                    local qty = input("Quantité", "", 20, true)
                    if qty ~= nil then
                        ESX.ShowNotification("~y~Give de l'item...")
                        TriggerServerEvent("adminmenu:give", selectedPlayer, itemName, qty)
                    end
                end
            end,
        }

        local letter = string.sub(string.lower(label), 1, 1)
        local bucket = itemsByLetter[letter]
        if not bucket then
            bucket = {}
            itemsByLetter[letter] = bucket
        end
        bucket[#bucket + 1] = entry

        itemsFlat[#itemsFlat + 1] = entry
    end

    itemsCacheRef = items
end

local offlineCasierStyle = { RightLabel = "~r~🗑 Supprimer" }

local function drawOfflineCasierCategory(typeLabel, list)
    for k, v in pairs(list) do
        local reason = v.reason or "Aucune raison"
        local staff = v.staff_name or "Inconnu"
        local date = v.timestamp or "Date inconnue"

        local durLine = ""
        if typeLabel == "JAIL" then
            local secs = tonumber(v.duration) or 0
            durLine = ("~s~\nDurée: ~o~%s"):format(secs > 0 and (math.floor(secs / 60) .. " min") or "-")
        elseif typeLabel == "BAN" then
            local hasDur = v.duration ~= nil and tostring(v.duration) ~= "0" and tostring(v.duration) ~= ""
            durLine = ("~s~\nDurée: ~o~%s"):format(hasDur and (tostring(v.duration) .. " s") or "Permanent")
        end

        local label = ("~s~Raison: ~o~%s~s~\nStaff: ~o~%s~s~\nDate: ~o~%s%s"):format(reason, staff, date, durLine)

        RageUI.ButtonWithStyle(("~r~[%s]~s~ #%s"):format(typeLabel, tostring(v.id or k)), label, offlineCasierStyle, true, function(_, _, Selected)
            if Selected and v.id then
                local raw = input("Écrivez 'oui' pour confirmer la suppression", "", 10, false)
                local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                if confirm == "oui" or confirm == "o" then
                    ESX.TriggerServerCallback("adminmenu:removeSanctionByLicense", function(ok)
                        if ok then
                            list[k] = nil
                        end
                    end, offlineCasierLicense, v.id)
                end
            end
        end)
    end
end

local vcColorList = {}
for i = 0, 159 do
    vcColorList[#vcColorList + 1] = tostring(i)
end

local vcWindowTintList = {
    { Name = "Aucune",      value = 0 },
    { Name = "Noir pur",    value = 1 },
    { Name = "Fumé foncé",  value = 2 },
    { Name = "Fumé clair",  value = 3 },
    { Name = "Usine",       value = 4 },
    { Name = "Limousine",   value = 5 },
    { Name = "Vert",        value = 6 },
}

local vcPlateList = {
    { Name = "Bleu / Blanc",    value = 0 },
    { Name = "Jaune / Noir",    value = 1 },
    { Name = "Jaune / Bleu",    value = 2 },
    { Name = "Bleu / Blanc 2",  value = 3 },
    { Name = "Bleu / Blanc 3",  value = 4 },
    { Name = "Yankton",         value = 5 },
}

local vcWheelTypeList = {
    { Name = "Sport",          value = 0 },
    { Name = "Muscle",         value = 1 },
    { Name = "Lowrider",       value = 2 },
    { Name = "SUV",            value = 3 },
    { Name = "Tout-terrain",   value = 4 },
    { Name = "Tuner",          value = 5 },
    { Name = "Moto",           value = 6 },
    { Name = "Haut de gamme",  value = 7 },
}

local vcToggleList = { { Name = "Désactivé", value = 0 }, { Name = "Activé", value = 1 } }

local vcModCategories = {
    { label = "Aileron",               modType = 0 },
    { label = "Pare-chocs avant",      modType = 1 },
    { label = "Pare-chocs arrière",    modType = 2 },
    { label = "Bas de caisse",         modType = 3 },
    { label = "Échappement",           modType = 4 },
    { label = "Châssis",               modType = 5 },
    { label = "Calandre",              modType = 6 },
    { label = "Capot",                 modType = 7 },
    { label = "Aile gauche",           modType = 8 },
    { label = "Aile droite",           modType = 9 },
    { label = "Toit",                  modType = 10 },
    { label = "Moteur",                modType = 11 },
    { label = "Freins",                modType = 12 },
    { label = "Transmission",          modType = 13 },
    { label = "Klaxon",                modType = 14 },
    { label = "Suspension",            modType = 15 },
    { label = "Blindage",              modType = 16 },
    { label = "Support de plaque",     modType = 25 },
    { label = "Plaque (déco)",         modType = 26 },
    { label = "Trim Design",           modType = 27 },
    { label = "Ornements",             modType = 28 },
    { label = "Tableau de bord (mod)", modType = 29 },
    { label = "Compteurs",             modType = 30 },
    { label = "HP de portes",          modType = 31 },
    { label = "Sièges",                modType = 32 },
    { label = "Volant",                modType = 33 },
    { label = "Levier de vitesse",     modType = 34 },
    { label = "Plaques",               modType = 35 },
    { label = "Enceintes",             modType = 36 },
    { label = "Coffre",                modType = 37 },
    { label = "Hydrauliques",          modType = 38 },
    { label = "Bloc moteur",           modType = 39 },
    { label = "Filtre à air",          modType = 40 },
    { label = "Jambes de force",       modType = 41 },
    { label = "Cache d'arches",        modType = 42 },
    { label = "Antennes",              modType = 43 },
    { label = "Garnitures",            modType = 44 },
    { label = "Réservoir",             modType = 45 },
    { label = "Fenêtres",              modType = 46 },
    { label = "Livrée",                modType = 48 },
}

local function vcVeh()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return nil end
    local veh = GetVehiclePedIsIn(ped, false)
    if not veh or veh == 0 then return nil end
    return veh
end

local function vcApplyVeh()
    local veh = vcVeh()
    if not veh then return nil end
    NetworkRequestControlOfEntity(veh)
    SetVehicleModKit(veh, 0)
    return veh
end

local function vcInitVehicle()
    local veh = vcVeh()
    if not veh then return end
    NetworkRequestControlOfEntity(veh)
    SetVehicleModKit(veh, 0)
end

local function vcBuildModItems(num)
    local items = { "D'origine" }
    for k = 1, num do
        items[#items + 1] = tostring(k)
    end
    return items
end

local function vcValueIndex(list, value)
    for i, t in ipairs(list) do
        if t.value == value then return i end
    end
    return 1
end

local SANCTIONS = {
    { label = "Sortir arme zone safe ou pour aucune raison", time = 30,  type = "jail" },
    { label = "Conduite HRP",                                time = 20,  type = "jail" },
    { label = "HRP vocal",                                   time = 30,  type = "jail" },
    { label = "Report mensonger",                            time = 60,  type = "jail" },
    { label = "No fear",                                     time = 90,  type = "jail" },
    { label = "NoPainRP",                                    time = 45,  type = "jail" },
    { label = "Braquage personne inutile",                   time = 60,  type = "jail" },
    { label = "Vol véhicule zone safe",                      time = 60,  type = "jail" },
    { label = "Powergaming",                                 time = 90,  type = "jail" },
    { label = "MassRP",                                      time = 90,  type = "jail" },
    { label = "Tirs inutiles",                               time = 60,  type = "jail" },
    { label = "Insulte coma",                                time = 60,  type = "jail" },
    { label = "Freeloot",                                    time = 90,  type = "jail" },
    { label = "Non respect de la règle sommation",           time = 90,  type = "jail" },
    { label = "Alt+F4",                                      time = 90,  type = "jail" },
    { label = "Freekill",                                    time = 30,  type = "jail" },
    { label = "Freekill x2",                                 time = 60,  type = "jail" },
    { label = "Freekill x3",                                 time = 90,  type = "jail" },
    { label = "Freekill x4",                                 time = 120, type = "jail" },
    { label = "Freekill x5",                                 time = 160, type = "jail" },
    { label = "Metagaming",                                  time = 90,  type = "jail" },
    { label = "Insulte staff",                               time = 90,  type = "jail" },
    { label = "Insulte grave",                               time = 90,  type = "jail" },
    { label = "Alliance gang",                               time = 90,  type = "jail" },
    { label = "NRR (Non Respect des Règles)",                time = 90,  type = "jail" },
    { label = "Arnaques",                                    time = 0,   type = "ban",  note = "Ban permanent - Jusqu'à restitution de l'objet/argent" },
    { label = "Incohérence RP",                              time = 60,  type = "jail" },
    { label = "Troll simple",                                time = 60,  type = "jail" },
    { label = "Usebug / Glitch",                             time = 90,  type = "jail" },
    { label = "Freekill/Freepunch carkill abusif",           time = 60,  type = "jail", note = "30 minutes par victime" },
    { label = "Troll abusif",                                time = 120, type = "jail" },
    { label = "Triche",                                      time = 0,   type = "ban",  note = "Ban permanent" },
    { label = "Trash en jail",                               time = 0,   type = "trash", note = "Isole le joueur dans une instance random (uniquement si déjà en jail). Persiste après reco/reboot." },
}

local hideTakenReports = false
local Filter = "Aucun filtre"
local function subCat(name)
    return cat .. name
end

local function msg(string)
    ESX.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~o~"
    else
        return "~s~"
    end
end

local function statsSeparator()
    RageUI.Separator("Staff connectés: ~o~" .. staff .. "~s~ | Staff en service: ~o~" .. nombreStaffActifs)
    RageUI.Separator("Connectés: ~o~" .. connecteds.. "~s~ | Reports: ~o~" .. reportCount)
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

local ranksRelative = {
    ["user"] = 1,
    ["help"] = 2,
    ["test"] = 3,
    ["mod"] = 4,
    ["admin"] = 5,
    ["gerant"] = 6,
    ["superadmin"] = 7
}

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Helpeur", rank = "help" },
    [3] = { label = "Modérateur-Test", rank = "test" },
    [4] = { label = "Modérateur", rank = "mod" },
    [5] = { label = "Admin", rank = "admin" },
    [6] = { label = "Gérant", rank = "gerant" },
    [7] = { label = "SuperAdmin", rank = "superadmin" }
}

local function getRankDisplay(rank)
    local ranks = {
        ["superadmin"] = "~r~[S.Admin] ~s~",
        ["gerant"] = "~r~[Gérant] ~s~",
        ["admin"] = "~r~[Admin] ~s~",
        ["mod"] = "~r~[Modo] ~s~",
        ["test"] = "~r~[Modo-Test] ~s~",
        ["help"] = "~r~[Helpeur] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[EN ATTENTE]~s~ "
    end
end

local staffActivityRows      = {}
local staffActivityEntries   = {}
local staffActivityTotals    = { staffs = 0, duty = 0, reports = 0 }
local staffActivityOnline    = 0
local staffActivityLoading   = false
local staffActivityResetting = false
local staffActivityResetSentAt = 0
local staffActivityFetchedAt = 0
local staffActivitySortBy    = "duty"
local STAFF_ACTIVITY_MIN_REFRESH_MS = 5000
local staffActivityNoop = function() end

local function fmtDuty(sec)
    sec = math.floor(tonumber(sec) or 0)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    if h > 0 then
        return ("%dh%02d"):format(h, m)
    elseif m > 0 then
        return ("%dmin"):format(m)
    end
    return ("%ds"):format(sec)
end

local function fmtAgo(sec)
    sec = tonumber(sec)
    if not sec or sec < 0 then return "Inconnue" end
    if sec < 60 then return "à l'instant" end
    local d = math.floor(sec / 86400)
    if d >= 1 then return ("il y a %dj"):format(d) end
    local h = math.floor(sec / 3600)
    if h >= 1 then return ("il y a %dh"):format(h) end
    return ("il y a %dmin"):format(math.floor(sec / 60))
end

local function buildStaffActivityEntries()
    local rows = staffActivityRows

    if staffActivitySortBy == "reports" then
        table.sort(rows, function(a, b)
            if (a.reports or 0) == (b.reports or 0) then return (a.duty or 0) > (b.duty or 0) end
            return (a.reports or 0) > (b.reports or 0)
        end)
    else
        table.sort(rows, function(a, b)
            if (a.duty or 0) == (b.duty or 0) then return (a.reports or 0) > (b.reports or 0) end
            return (a.duty or 0) > (b.duty or 0)
        end)
    end

    local entries = {}
    for i = 1, #rows do
        local r       = rows[i]
        local reports = tonumber(r.reports) or 0
        local status  = r.online and "~g~●~s~ " or "~c~●~s~ "

        local desc = ("~o~Temps de service total~s~: ~b~%s~n~~o~Reports pris en charge~s~: ~y~%d"):format(
            fmtDuty(r.duty), reports)
        if r.online then
            desc = desc .. ("~n~~o~En service depuis~s~: ~g~%s"):format(fmtDuty(r.session))
        else
            desc = desc .. ("~n~~o~Dernière activité~s~: ~s~%s"):format(fmtAgo(r.lastSeen))
        end

        entries[i] = {
            label = ("%s~s~%d. %s%s"):format(status, i, getRankDisplay(r.rank), r.name or "Inconnu"),
            desc  = desc,

            style = { RightLabel = ("~b~%s ~s~| ~y~%d~s~ rep."):format(fmtDuty(r.duty), reports) },
        }
    end

    staffActivityEntries = entries
end

local staffActivityRequestedAt = 0

local function fetchStaffActivity(force)
    local now = GetGameTimer()

    if staffActivityLoading then

        if (now - staffActivityRequestedAt) < 15000 then return end
    end

    if not force and staffActivityFetchedAt ~= 0
        and (now - staffActivityFetchedAt) < STAFF_ACTIVITY_MIN_REFRESH_MS then
        return
    end

    staffActivityLoading   = true
    staffActivityRequestedAt = now
    ESX.TriggerServerCallback("adminmenu:getStaffActivity", function(res)
        staffActivityLoading   = false
        staffActivityFetchedAt = GetGameTimer()

        if type(res) ~= "table" or not res.ok then
            staffActivityRows, staffActivityEntries = {}, {}
            staffActivityTotals = { staffs = 0, duty = 0, reports = 0 }
            staffActivityOnline = 0
            ESX.ShowNotification("~r~Accès refusé ou données indisponibles.")
            return
        end

        staffActivityRows   = res.rows or {}
        staffActivityTotals = res.totals or { staffs = 0, duty = 0, reports = 0 }
        staffActivityOnline = res.online or 0
        buildStaffActivityEntries()
    end)
end

RegisterNetEvent("adminmenu:staffActivityReset")
AddEventHandler("adminmenu:staffActivityReset", function(res)
    staffActivityResetting = false
    staffActivityFetchedAt = GetGameTimer()

    if type(res) == "table" and res.ok then
        staffActivityRows   = res.rows or {}
        staffActivityTotals = res.totals or { staffs = 0, duty = 0, reports = 0 }
        staffActivityOnline = res.online or 0
    else
        staffActivityRows   = {}
        staffActivityTotals = { staffs = 0, duty = 0, reports = 0 }
        staffActivityOnline = 0
    end

    buildStaffActivityEntries()
    ESX.ShowNotification("~o~Statistiques du staff réinitialisées.")
end)

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end
function DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod, shadow)
    if rgb[4] >= 0 then
        if devmod then
            local x2 = GetControlNormal(0, 239)
            local y2 = GetControlNormal(0, 240)

            x = x2
            y = y2
            print(x, y)
            if IsControlJustReleased(0, 38) then
                TriggerEvent("addToCopy", x..", "..y)
            end
        end

        if shadow == nil then
            shadow = false
        end

        if rightJustify ~= 0 and rightJustify ~= false then
            SetTextJustification(2)
            SetTextWrap(0.0, x)
        end

        SetTextFont(font)
        SetTextScale(scale, scale)
        if shadow ~= nil and shadow == true then
            SetTextDropshadow(1, 0, 0, 0, 100)

        end
        SetTextColour(rgb[1], rgb[2], rgb[3], math.floor(rgb[4]))
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x,y)
    end

end

PMA = exports["pma-voice"]

function openMenu()

    if isMenuOpened then
        return
    end

    if not permLevel or permLevel == nil then
        return
    end

    if permLevel == "user" then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end

    TriggerServerEvent("adminhud:requestData")

    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~o~", "~y~", "~c~", "~o~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    isMenuOpened = true

    Citizen.CreateThread(function()
        while isMenuOpened do
            Citizen.Wait(10000)
            if isMenuOpened then
                TriggerServerEvent("adminhud:requestData")
            end
        end
    end)

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("SunLife", "Menu administratif", 1, 100))
    RMenu:Get(cat, subCat('main')):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get(cat, subCat("main")).Closed = function()
        TriggerEvent('adminmenu:closed')
    end
    RMenu:Get(cat, subCat("main")):SetPosition(1320, 200)
    RMenu.Add(cat, subCat("personnal"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("personnal")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicleCustom"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("vehicle")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("vehicleCustom")).Closed = function()
    end

    RMenu.Add(cat, subCat("teleportation"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("teleportation")).Closed = function()
    end

    RMenu.Add(cat, subCat("getInv"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("getInv")).Closed = function()
    end

    RMenu.Add(cat, subCat("staff"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("staff")).Closed = function()
    end

    RMenu.Add(cat, subCat("casierOffline"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("casierOffline")).Closed = function()
    end

    RMenu.Add(cat, subCat("staffActivity"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("staffActivity")).Closed = function()
    end

    RMenu.Add(cat, subCat("peds"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("personnal")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("peds")).Closed = function()
    end

    RMenu.Add(cat, subCat("casier"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("casier")).Closed = function()
    end

    RMenu.Add(cat, subCat("addSanction"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("addSanction")).Closed = function()
    end

    RMenu.Add(cat, subCat("bans"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("bans")).Closed = function()
    end

    RMenu.Add(cat, subCat("warns"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("warns")).Closed = function()
    end

    RMenu.Add(cat, subCat("jails"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "SunLife", "Menu administratif"))
    RMenu:Get(cat, subCat("jails")).Closed = function()
    end

    ESX.TriggerServerCallback("Staff:GetPlayers", function(serviceStaff)
        nombreStaffActifs = #serviceStaff
    end)

    Citizen.CreateThread(function()
        while isMenuOpened do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~o~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while isMenuOpened do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)

    local canOpen = false
    local callback = false
    ESX.TriggerServerCallback("Staff:IsPlayerStaff", function(isStaff)
        callback = true
        canOpen = isStaff
    end)

    while not callback do
        Citizen.Wait(100)
    end

    if not canOpen then
        ESX.ShowNotification("Vous n'êtes pas autorisé à accéder à ce menu")
        isMenuOpened = false
        return
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)

    Citizen.CreateThread(function()
        while isMenuOpened do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if isStaffMode then
                    RageUI.ButtonWithStyle("~r~Désactiver le Mode Staff", nil, { RightLabel = "❌" }, not serverInteraction, function(_, _, s)
                        if s then
                            TriggerEvent("adminhud:toggle", false)

                            exports["sCore"]:setFreecamBypass(false, "FALSE ADMINMENU")
                            serverInteraction = true
                            blipsActive = false
                            showNames(false)
                            isNameShown = false
                            TriggerServerEvent("Staff:RemovePlayer")
                            TriggerServerEvent("adminmenu:setStaffState", false)
                            TriggerServerEvent('StaffModV2:SendLogFDS')
                            exports['esx_skin']:GetCachedSkin(function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                            ForceDeactivateNoclip()
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~o~Activer le Mode Staff", nil, { RightLabel = "✅" }, not serverInteraction, function(_, _, s)
                        if s then
                            TriggerEvent("adminhud:toggle", true)

                            exports["sCore"]:setFreecamBypass(true, "TRUE ADMINMENU")
                            local model = GetEntityModel(PlayerPedId())
                            serverInteraction = true
                            TriggerServerEvent("Staff:AddPlayer")
                            TriggerServerEvent("adminmenu:setStaffState", true)
                            TriggerServerEvent('StaffModV2:SendLogPDS')
                            showNames(true)
                            isNameShown = true
                            blipsActive = true
                            if permLevel ~= "help" then
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    if skin.sex == "mp_m_freemode_01" then
                                        clothesSkin = {
                                            ['bags_1'] = 0, ['bags_2'] = 0,
                                            ['tshirt_1'] = 15, ['tshirt_2'] = 2,
                                            ['torso_1'] = 178, ['torso_2'] = 0,
                                            ['arms'] = 31,
                                            ['pants_1'] = 77, ['pants_2'] = 0,
                                            ['shoes_1'] = 55, ['shoes_2'] = 0,
                                            ['mask_1'] = 0, ['mask_2'] = 0,
                                            ['bproof_1'] = 0,
                                            ['chain_1'] = 0,
                                        }
                                    else
                                        clothesSkin = {
                                            ['bags_1'] = 0, ['bags_2'] = 0,
                                            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                            ['torso_1'] = 180, ['torso_2'] = 0,
                                            ['arms'] = 36, ['arms_2'] = 0,
                                            ['pants_1'] = 79, ['pants_2'] = 0,
                                            ['shoes_1'] = 58, ['shoes_2'] = 0,
                                            ['mask_1'] = 0, ['mask_2'] = 0,
                                            ['bproof_1'] = 0,
                                            ['chain_1'] = 0,
                                        }
                                    end
                                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                                end)
                            end
                           TriggerServerEvent("adminhud:requestData")
                        end
                    end)
                end
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Personnel", nil, { RightLabel = "→→" }, isStaffMode, function()
                end, RMenu:Get(cat, subCat("personnal")))
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Reports (~r~" .. reportCount .. "~s~)", nil, { RightLabel = "→→" }, isStaffMode, function(_, _, s)
                end, RMenu:Get(cat, subCat("reports")))
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Joueurs", nil, { RightLabel = "→→" }, isStaffMode, function(h, a, s)
                    if s then
                        TriggerServerEvent("admin:menu:GetAllPlayers")
                    end
                end, RMenu:Get(cat, subCat("players")))
                if permLevel ~= "help" then
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Véhicules", nil, { RightLabel = "→→" }, isStaffMode, function()
                        end, RMenu:Get(cat, subCat("vehicle")))
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Staff en service", nil, { RightLabel = "→→" }, isStaffMode, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback("Staff:GetPlayers", function(serviceStaff)
                                serviceStaffRec = serviceStaff
                            end)
                        end
                    end, RMenu:Get(cat, subCat("staff")))

                    if canUse("removeSanction", permLevel) then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Casier hors-ligne ~c~(License)", nil, { RightLabel = "→→" }, isStaffMode, function()
                        end, RMenu:Get(cat, subCat("casierOffline")))
                    end

                    if canUse("staffActivity", permLevel) then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Activité du staff ~c~(PDS / Reports)", "~o~Réservé SuperAdmin~s~ — Temps de prise de service cumulé et nombre de reports pris par chaque membre du staff.", { RightLabel = "→→" }, isStaffMode, function(_, _, s)
                            if s then
                                fetchStaffActivity(false)
                            end
                        end, RMenu:Get(cat, subCat("staffActivity")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("personnal")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if isStaffMode then
                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNoClip) .. "NoClip", nil, isNoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNoClip = Checked;
                    end, function()
                        ToogleNoClip()
                    end, function()
                        ToogleNoClip()
                    end)

                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNameShown = Checked;
                    end, function()
                        showNames(true)
                    end, function()
                        showNames(false)
                    end)

                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(blipsActive) .. "Affichage des blips", nil, blipsActive, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        blipsActive = Checked;
                    end, function()
                    end, function()
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP aléatoire", nil, {}, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:randomTP")
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur Marqueur", nil, {}, true, function(_, _, s)
                        if s then
                            admin_tp_marker()
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP instance Jail", nil, { RightLabel = "~p~Instance" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:tpInstanceJail")
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP instance Joueurs", nil, { RightLabel = "~g~Instance 0" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:tpInstancePlayers")
                        end
                    end)

                    if permLevel ~= "help" then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soin", nil, {}, true, function(_, _, s)
                            if s then
                                SetEntityHealth(PlayerPedId(), 200)
					        	ESX.ShowNotification("~o~Vous vous êtes soigné")
                            end
                        end)

                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Armure", nil, {}, true, function(_, _, s)
                            if s then

                                pcall(function() exports['antisbire']:armorGrace(3000) end)
                                SetPedArmour(PlayerPedId(), 200)
					    		ESX.ShowNotification("~o~Votre armure vous a été attribuée")
                            end
                        end)

                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Changer de couleur", nil, {}, true, function(_, _, s)
                            if s then
                                local couleur = math.random(0,9)
               		    		TriggerEvent('skinchanger:getSkin', function(skin)
                        			local clothesSkin = {
                            			['torso_2'] = couleur,
                            			['pants_2'] = couleur,
                            			['shoes_2'] = couleur,
                            			['helmet_2'] = couleur,
                        			}
                        			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					    		end)
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Téléportation", nil, { RightLabel = "→→" }, isStaffMode, function()
                    end, RMenu:Get(cat, subCat("teleportation")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Peds", nil, { RightLabel = "→→" }, canUse("funnyassshit", permLevel), function()
                    end, RMenu:Get(cat, subCat("peds")))

                    if fastrun then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Fast Run", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                fastrun = not fastrun
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Fast Run", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                fastrun = not fastrun
                            end
                        end)
                    end

                    if SuperJump then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Super Jump", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                SuperJump = not SuperJump
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Super Jump", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                SuperJump = not SuperJump
                            end
                        end)
                    end

                    if InfStamina then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Stamina Infini", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                InfStamina = not InfStamina
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Stamina Infini", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                InfStamina = not InfStamina
                            end
                        end)
                    end

                    if sonoplz then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Bip Sonore", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                ExecuteCommand("sonooff")
                                sonoplz = not sonoplz
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Bip Sonore", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                ExecuteCommand("sonooff")
                                sonoplz = not sonoplz
                            end
                        end)
                    end

                    if fastrun then
                        SetRunSprintMultiplierForPlayer(PlayerId(-1), 2.49)
                        SetPedMoveRateOverride(PlayerPedId(), 2.15)
                    else
                        SetRunSprintMultiplierForPlayer(PlayerId(-1), 1.0)
                        SetPedMoveRateOverride(PlayerPedId(), 1.0)
                    end
                    if SuperJump then
                        SetSuperJumpThisFrame(PlayerId(-1))
                    end
                    if InfStamina then
                        RestorePlayerStamina(PlayerId(-1), 1.0)
                    end
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.ButtonWithStyle("Filtre", "~o~Cliquez pour filtrer par nom ou ID", { RightLabel = Filter }, true, function(_, _, s)
                    if s then

                        local raw = input('Nom ou ID du joueur', '', 35)
                        if raw == nil then

                            return
                        end

                        local name = tostring(raw):gsub('^%s+', ''):gsub('%s+$', '')
                        if name ~= '' then
                            Filter = name
                            ESX.ShowNotification("~o~Filtre actif: ~s~" .. name)
                        else
                            Filter = "Aucun filtre"
                            ESX.ShowNotification("~o~Filtre désactivé")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Réinitialiser le filtre", nil, { RightLabel = "✖" }, Filter ~= "Aucun filtre", function(_, _, s)
                    if s then
                        Filter = "Aucun filtre"
                        ESX.ShowNotification("~o~Filtre désactivé")
                    end
                end)
                RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(showAreaPlayers) .. "Restreindre à ma zone", nil, showAreaPlayers, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    showAreaPlayers = Checked;
                end, function()
                end, function()
                end)

                local hasFilter = Filter ~= nil and Filter ~= "" and Filter ~= "Aucun filtre"
                local filterLower = hasFilter and tostring(Filter):lower() or nil

                local function matchesFilter(player, source)
                    if not hasFilter then return true end

                    if player and player.name then
                        local pname = tostring(player.name):lower()
                        if string.find(pname, filterLower, 1, true) then
                            return true
                        end
                    end

                    if source ~= nil and string.find(tostring(source):lower(), filterLower, 1, true) then
                        return true
                    end
                    return false
                end

                local matchedCount = 0

                if not showAreaPlayers then
                    local sortedPlayers = {}
                    for id, player in pairs(localPlayers) do
                        table.insert(sortedPlayers, {id = id, player = player})
                    end

                    table.sort(sortedPlayers, function(a, b)
                        return tonumber(a.id) < tonumber(b.id)
                    end)

                    if hasFilter then
                        RageUI.Separator("Résultats pour: ~o~" .. Filter)
                    else
                        RageUI.Separator("Joueurs")
                    end

                    for _, entry in ipairs(sortedPlayers) do
                        local source = entry.id
                        local player = entry.player
                        if player and player.name ~= nil and matchesFilter(player, source) then
                            if player.rank ~= "superadmin" or permLevel == "superadmin" or tonumber(source) == GetPlayerServerId(PlayerId()) then
                                matchedCount = matchedCount + 1
                                RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. cVarLong() .. "→ ~s~" .. player.name .. " (" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)" .. (player.newTag or ""), nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and tonumber(source) ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                    if s then
                                        selectedPlayer = tonumber(source) or source
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                            end
                        end
                    end
                else
                    local sIDs = {}
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            table.insert(sIDs, sID)
                        end
                    end

                    table.sort(sIDs)

                    if hasFilter then
                        RageUI.Separator("Résultats (zone) pour: ~o~" .. Filter)
                    else
                        RageUI.Separator("Joueurs (ma zone)")
                    end

                    for _, sID in ipairs(sIDs) do
                        local player = localPlayers[sID]
                        if player and (player.rank ~= "superadmin" or permLevel == "superadmin" or sID == GetPlayerServerId(PlayerId())) and matchesFilter(player, sID) then
                            matchedCount = matchedCount + 1
                            RageUI.ButtonWithStyle(
                                getRankDisplay(player.rank) .. "~s~[~o~" .. sID .. "~s~] " .. cVarLong() .. "→ ~s~" .. player.name .. " (" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)" .. (player.newTag or ""),
                                nil, { RightLabel = "→→" },
                                true,
                                function(_, _, s)
                                    if s then
                                        selectedPlayer = sID
                                    end
                                end, RMenu:Get(cat, subCat("playersManage"))
                            )
                        end
                    end
                end

                if hasFilter and matchedCount == 0 then
                    RageUI.Separator("~r~Aucun joueur ne correspond à \"" .. Filter .. "\"")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Paramètres")
                RageUI.Checkbox(colorByState(hideTakenReports) .. "Cacher les pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    hideTakenReports = Checked
                end)

                local sortedReports = {}
                for sender, infos in pairs(localReportsTable) do
                    local totalMinutes = infos.timeElapsed[2] * 60 + infos.timeElapsed[1]
                    table.insert(sortedReports, {sender = sender, infos = infos, totalMinutes = totalMinutes})
                end

                table.sort(sortedReports, function(a, b)
                    return a.totalMinutes > b.totalMinutes
                end)

                RageUI.Separator("Reports")
                for _, report in ipairs(sortedReports) do
                    local sender = report.sender
                    local infos = report.infos
                    if infos.taken and infos.name then
                        if not hideTakenReports then
                            RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name .. " ~r~(" .. infos.graviter .. ")", "~o~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Catégorie~s~: " .. infos.category .. "~n~~o~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "→→" }, true, function(_, _, s)
                                if s then
                                    selectedReport = sender
                                end
                            end, RMenu:Get(cat, subCat("reports_take")))
                        end
                    else
                        RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name .. " ~r~(" .. infos.graviter .. ")", "~o~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Catégorie~s~: " .. infos.category, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                selectedReport = sender
                            end
                        end, RMenu:Get(cat, subCat("reports_take")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                if localReportsTable[selectedReport] ~= nil then
                    RageUI.Separator("ID du Report: #" .. localReportsTable[selectedReport].uniqueId .. " ~s~| ID de l'auteur: ~y~" .. selectedReport .. generateTakenBy(selectedReport))
                    RageUI.Separator("Actions disponibles")
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Prendre en charge ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("adminmenu:takeReport", selectedReport)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Cloturer ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:closeReport", selectedReport)
                        end
                    end)
                    RageUI.Separator("Actions rapides")

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Casier", nil, { RightLabel = "»" }, canUse("casier", permLevel), function(_, _, s)
                        if s then

                        end
                    end, RMenu:Get(cat, subCat("casier")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur lui", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedReport, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Return", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:returnTarget", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP Parking Central", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("adminmenu:tppc", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~y~Actions avancées", "~y~Description~s~: " .. infos.reason.."~n~~r~Attention~s~: Cette action vous fera changer de menu", { RightLabel = "→→" }, GetPlayerServerId(PlayerId()) ~= selectedReport, function(_, _, s)
                        if s then
                            selectedPlayer = selectedReport
                        end
                    end,RMenu:Get(cat,subCat("playersManage")))
                else
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce report n'est plus valide")
                    RageUI.Separator("")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    statsSeparator()
                    RageUI.Separator("Gestion: ~o~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                    RageUI.Separator("Téléportation")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~S'y téléporter", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Téléporter sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedPlayer, GetEntityCoords(PlayerPedId()))
                        end
                    end)
                    RageUI.Separator("Modération")
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~r~Ajouter une sanction", "~o~Appliquer une sanction prédéfinie (jail/ban) sur ce joueur", { RightLabel = "»" }, canUse("jail", permLevel) or canUse("ban", permLevel), function(_, _, s)
                        if s then

                        end
                    end, RMenu:Get(cat, subCat("addSanction")))
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Casier", nil, { RightLabel = "»" }, canUse("casier", permLevel), function(_, _, s)
                        if s then

                        end
                    end, RMenu:Get(cat, subCat("casier")))
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Spectate", nil, { RightLabel = "→→" }, canUse("spectate", permLevel), function(_, _, s)
                        if s then
                            ToogleNoClip()
                            SetEntityVisible(PlayerPedId(), false, 0)
                            TriggerServerEvent("spectate:start", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Message", nil, { RightLabel = "→→" }, canUse("mess", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoi du message en cours...")
                                TriggerServerEvent("adminmenu:message", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Warn", nil, { RightLabel = "→→" }, canUse("warn", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Warn", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoi du warn en cours...")
                                TriggerServerEvent("adminmenu:warn", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Kick", nil, { RightLabel = "→→" }, canUse("kick", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Raison", "", 80, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Application de la sanction en cours...")
                                TriggerServerEvent("adminmenu:kick", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Bannir", nil, { RightLabel = "→→" }, canUse("ban", permLevel), function(_, _, s)
                        if s then
                            local days = input("Durée du banissement (en jours — ex: 7 = une semaine, 0.5 = 12h)", "", 20, true)
                            if days ~= nil then
                                local reason = input("Raison", "", 80, false)
                                if reason ~= nil then
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    ExecuteCommand(("sqlban %s %s %s"):format(selectedPlayer, days, reason))
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Changer le groupe", nil, { RightLabel = "→→" }, canUse("setGroup", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("setGroup")))
                    RageUI.Separator("Personnage")

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Voir l'inventaire", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            cash = {}
                            blackmoney = {}
                            hisitems = {}

                            ESX.TriggerServerCallback("adminmenu:getPlayerInventory", function(data)
                                table.insert(cash, {
                                    label    = ESX.Math.Round(data.money),
                                    value    = 'money',
                                    amount   = data.money
                                })

                                for k,v in pairs(data.accounts) do
                                    if v.name == 'black_money' and v.money > 0 then
                                          table.insert(blackmoney, {
                                                label    = ESX.Math.Round(v.money),
                                                value    = 'black_money',
                                                itemType = 'item_account',
                                                amount   = v.money
                                          })
                                    end
                                end

                                for k,v in pairs(data.inventory) do
                                    if v.count > 0 then
                                          table.insert(hisitems, {
                                                label    = v.label,
                                                right    = v.count,
                                                value    = v.name,
                                                itemType = 'item_standard',
                                                amount   = v.count
                                          })
                                    end
                                end
                            end, selectedPlayer)
                        end
                    end, RMenu:Get(cat, subCat("getInv")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give un item", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("items")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Wipe", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local raw = input("Écrivez 'oui' pour confirmer le wipe", "", 35, false)
                            local result = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                            if result == "oui" or result == "o" then
                                ESX.ShowNotification("~o~Wipe du joueur en cours...")
                                TriggerServerEvent("adminmenu:wipe", selectedPlayer)
                            end
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("addSanction")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    statsSeparator()
                    RageUI.Separator("Sanction pour: ~o~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                    RageUI.Separator("~r~Sélectionnez la sanction à appliquer")

                    for i = 1, #SANCTIONS do
                        local sanction = SANCTIONS[i]
                        local isBan = sanction.type == "ban"
                        local rightLabel
                        local description

                        local isTrash = sanction.type == "trash"

                        if isBan then
                            rightLabel = "~r~Ban perma"
                            description = sanction.note or "Ban permanent"
                        elseif isTrash then
                            rightLabel = "~p~Isolement"
                            description = sanction.note or "Isole le joueur dans une instance random"
                        else
                            rightLabel = "~b~" .. sanction.time .. " min"
                            description = "Jail ~b~" .. sanction.time .. " minutes"
                            if sanction.note then
                                description = description .. "~n~~o~" .. sanction.note
                            end
                        end

                        local canApply
                        if isBan then
                            canApply = canUse("ban", permLevel)
                        else
                            canApply = canUse("jail", permLevel)
                        end

                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. sanction.label, description, { RightLabel = rightLabel }, canApply, function(_, _, s)
                            if s then
                                if isBan then

                                    local raw = input("Écrivez 'oui' pour confirmer le ban permanent", "", 10, false)
                                    local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                                    if confirm == "oui" or confirm == "o" then
                                        ESX.ShowNotification("~r~Application du ban permanent en cours...")
                                        ExecuteCommand(("sqlban %s %s %s"):format(selectedPlayer, 0, sanction.label))
                                    else
                                        ESX.ShowNotification("~o~Ban annulé.")
                                    end
                                elseif isTrash then
                                    TriggerServerEvent("adminmenu:trashInJail", selectedPlayer)
                                else
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    TriggerServerEvent("adminmenu:sendPlayerToJail", selectedPlayer, sanction.time * 60, sanction.label)
                                end
                            end
                        end)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("casier")), true, true, true, function()
                shouldStayOpened = true

                RageUI.ButtonWithStyle("~r~>~s~ Liste des bannissements", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerBans = {}
                        ESX.TriggerServerCallback("adminmenu:getBans", function(data)
                            playerBans = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("bans")))

                RageUI.ButtonWithStyle("~r~>~s~ Liste des warns", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerWarns = {}
                        ESX.TriggerServerCallback("adminmenu:getWarns", function(data)
                            playerWarns = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("warns")))

                RageUI.ButtonWithStyle("~r~>~s~ Liste des jails", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerJails = {}
                        ESX.TriggerServerCallback("adminmenu:getJails", function(data)
                            playerJails = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("jails")))

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("bans")), true, true, true, function()
                shouldStayOpened = true

                local canRemove = canUse("removeSanction", permLevel)

                for k,v in pairs(playerBans) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local duration = v.duration and (v.duration .. " secondes") or "Permanent"
                    local date = v.timestamp or "Date inconnue"

                    local rightLabel = canRemove and "~r~Retirer ~s~→→" or "→→→"
                    local label = ("Raison: ~r~%s\n~s~Durée: %s\nStaff: %s\nDate: %s%s"):format(
                        reason, duration, staff, date,
                        canRemove and "\n~r~Sélectionnez pour retirer cette sanction" or ""
                    )

                    RageUI.ButtonWithStyle("Ban #" .. k, label, {RightLabel = rightLabel}, true, function(Hovered, Active, Selected)
                        if Selected and canRemove and v.id then
                            local raw = input("Écrivez 'oui' pour confirmer la suppression", "", 10, false)
                            local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                            if confirm == "oui" or confirm == "o" then
                                ESX.TriggerServerCallback("adminmenu:removeSanction", function(ok)
                                    if ok then
                                        playerBans[k] = nil
                                    end
                                end, selectedPlayer, v.id)
                            end
                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("warns")), true, true, true, function()
                shouldStayOpened = true

                local canRemove = canUse("removeSanction", permLevel)

                for k,v in pairs(playerWarns) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local date = v.timestamp or "Date inconnue"

                    local rightLabel = canRemove and "~r~Retirer ~s~→→" or "→→→"
                    local label = ("Raison: ~y~%s\n~s~Staff: %s\nDate: %s%s"):format(
                        reason, staff, date,
                        canRemove and "\n~r~Sélectionnez pour retirer cette sanction" or ""
                    )

                    RageUI.ButtonWithStyle("Warn #" .. k, label, {RightLabel = rightLabel}, true, function(Hovered, Active, Selected)
                        if Selected and canRemove and v.id then
                            local raw = input("Écrivez 'oui' pour confirmer la suppression", "", 10, false)
                            local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                            if confirm == "oui" or confirm == "o" then
                                ESX.TriggerServerCallback("adminmenu:removeSanction", function(ok)
                                    if ok then
                                        playerWarns[k] = nil
                                    end
                                end, selectedPlayer, v.id)
                            end
                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("jails")), true, true, true, function()
                shouldStayOpened = true

                local canRemove = canUse("removeSanction", permLevel)

                for k,v in pairs(playerJails) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local duration = v.duration and (v.duration .. " min") or "Indéfini"
                    local date = v.timestamp or "Date inconnue"

                    local rightLabel = canRemove and "~r~Retirer ~s~→→" or "→→→"
                    local label = ("Raison: ~b~%s\n~s~Durée: %s\nStaff: %s\nDate: %s%s"):format(
                        reason, duration, staff, date,
                        canRemove and "\n~r~Sélectionnez pour retirer cette sanction" or ""
                    )

                    RageUI.ButtonWithStyle("Jail #" .. k, label, {RightLabel = rightLabel}, true, function(Hovered, Active, Selected)
                        if Selected and canRemove and v.id then
                            local raw = input("Écrivez 'oui' pour confirmer la suppression", "", 10, false)
                            local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                            if confirm == "oui" or confirm == "o" then
                                ESX.TriggerServerCallback("adminmenu:removeSanction", function(ok)
                                    if ok then
                                        playerJails[k] = nil
                                    end
                                end, selectedPlayer, v.id)
                            end
                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("getInv")), true, true, true, function()
                shouldStayOpened = true
                for k,v in pairs(cash) do
                    RageUI.ButtonWithStyle("~r~>~s~ Argent Liquide", nil, {RightLabel = ("%s $"):format(v.label) }, true, function(Hovered, Active, Selected)
                    end)
                end
                for k,v in pairs(blackmoney) do
                    RageUI.ButtonWithStyle("~r~>~s~ Argent sale", nil, {RightLabel = ("%s $"):format(v.label) }, true, function(Hovered, Active, Selected)
                    end)
                end
                RageUI.Separator()
                for k,v in pairs(hisitems) do
                    RageUI.ButtonWithStyle(("~r~> ~s~%s"):format(v.label), nil, { RightLabel = ("x%s"):format(v.right) }, true, function(Hovered, Active, Selected)
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("items")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~o~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")

                prepareItemsCache()

                local hasSearch = itemSearch ~= nil and itemSearch ~= ""

                RageUI.ButtonWithStyle("Rechercher un item", "~o~Cliquez pour rechercher par nom", { RightLabel = hasSearch and ("~b~" .. itemSearch) or "🔍" }, true, function(_, _, s)
                    if s then
                        local raw = input("Rechercher un item", "", 35)
                        if raw == nil then
                            return
                        end
                        local q = tostring(raw):gsub('^%s+', ''):gsub('%s+$', '')
                        if q ~= '' then
                            itemSearch = q
                            ESX.ShowNotification("~o~Recherche: ~s~" .. q)
                        else
                            itemSearch = ""
                            ESX.ShowNotification("~o~Recherche désactivée")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Réinitialiser la recherche", nil, { RightLabel = "✖" }, hasSearch, function(_, _, s)
                    if s then
                        itemSearch = ""
                        ESX.ShowNotification("~o~Recherche désactivée")
                    end
                end)

                if hasSearch then
                    RageUI.Separator("Résultats: ~b~" .. itemSearch)
                    local query = string.lower(itemSearch)
                    local colorPrefix = cVarLong()
                    local found = 0
                    for i = 1, #itemsFlat do
                        local entry = itemsFlat[i]
                        if string.find(entry.searchLabel, query, 1, true) then
                            found = found + 1
                            RageUI.ButtonWithStyle(colorPrefix .. entry.baseLabel, nil, giveStyle, true, entry.giveCb)
                        end
                    end
                    if found == 0 then
                        RageUI.Separator('~r~Aucun item ne correspond à "' .. itemSearch .. '"')
                    end
                else
                    RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
                    RageUI.Separator("Items disponibles")
                    local bucket = itemsByLetter[string.lower(filterArray[filter])]
                    if bucket then
                        local colorPrefix = cVarLong()
                        for i = 1, #bucket do
                            local entry = bucket[i]
                            RageUI.ButtonWithStyle(colorPrefix .. entry.baseLabel, nil, giveStyle, true, entry.giveCb)
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("setGroup")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~o~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.Separator("Rangs disponibles")
                for i = 1, #ranksInfos do
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. ranksInfos[i].label, nil, { RightLabel = "~b~Attribuer ~s~→→" }, ranksRelative[permLevel] > i, function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Application du rang...")
                            TriggerServerEvent("adminmenu:setGroup", selectedPlayer, ranksInfos[i].rank)
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            Citizen.CreateThread(function()
                                local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                                NetworkRequestControlOfEntity(veh)
                                while not NetworkHasControlOfEntity(veh) do
                                    Wait(1)
                                end
                                DeleteEntity(veh)
                                ESX.ShowNotification("~o~Véhicule supprimé")
                            end)
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            SetVehicleFixed(veh)
                            SetVehicleDeformationFixed(veh)
                            SetVehicleDirtLevel(veh, 0.0)
                            SetVehicleEngineHealth(veh, 1000.0)
                            ESX.ShowNotification("~o~Véhicule réparé")
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                do
                    local rightLabel = unbreakable and "~o~Activé" or "~r~Désactivé"
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Incassable", "~s~Rend le véhicule indestructible (aucun dégât, pas de déformation, pneus/roues incassables).", { RightLabel = rightLabel }, true, function(Hovered, Active, Selected)
                        if Active then
                            ClosetVehWithDisplay()
                        end
                        if Selected then
                            if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                                return
                            end

                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end

                            unbreakable = not unbreakable

                            SetVehicleCanBeVisiblyDamaged(veh, not unbreakable)
                            SetVehicleTyresCanBurst(veh, not unbreakable)
                            SetVehicleWheelsCanBreak(veh, not unbreakable)
                            SetEntityProofs(veh, unbreakable, unbreakable, unbreakable, unbreakable, unbreakable, unbreakable, unbreakable, unbreakable)
                            SetEntityInvincible(veh, unbreakable)
                            SetVehicleStrong(veh, unbreakable)

                            if unbreakable then
                                SetVehicleFixed(veh)
                                SetVehicleDeformationFixed(veh)
                                SetVehicleEngineHealth(veh, 1000.0)
                                SetVehicleBodyHealth(veh, 1000.0)
                                SetVehiclePetrolTankHealth(veh, 1000.0)
                                ESX.ShowNotification("~o~Véhicule rendu incassable")
                            else
                                ESX.ShowNotification("~r~Véhicule à nouveau cassable")
                            end
                        end
                    end)
                end

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Custom véhicule", "~o~Réservé SuperAdmin — Couleurs, carrosserie, jantes, vitres, plaque...", { RightLabel = "→→" }, permLevel == "superadmin", function(Hovered, Active, Selected)
                    if Selected then
                        if permLevel ~= "superadmin" then
                            ESX.ShowNotification("~r~Accès réservé aux SuperAdmins.")
                            return
                        end
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            vcInitVehicle()
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end, RMenu:Get(cat, subCat("vehicleCustom")))

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Full Custom", nil, { RightLabel = "→→" }, canUse("funnyassshit", permLevel), function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            ESX.Game.SetVehicleProperties(veh, {
                                modEngine = 3,
                                modBrakes = 3,
                                modTransmission = 3,
                                modSuspension = 3,
                                modTurbo = true
                            })
                            SetVehicleWindowTint(veh, 2)
                            SetVehicleWindowTint(veh, 3)
                            ESX.ShowNotification("~o~Véhicule amélioré")
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Changer la plaque", nil, { RightLabel = "→→" }, canUse("funnyassshit", permLevel), function(_, _, s)
                    if s then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plaqueVehicule = input("Plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false) , plaqueVehicule)
                            ESX.ShowNotification("La plaque du véhicule est désormais : ~h~"..plaqueVehicule)
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                if rainbow_mode then
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Rainbow", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rainbow_mode = not rainbow_mode
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Rainbow", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rainbow_mode = not rainbow_mode
                        end
                    end)
                end
                if rocket then
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Fusée", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rocket = not rocket
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Fusée", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rocket = not rocket
                        end
                    end)
                end
                if drag then
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Dragster", nil, { RightLabel = "~o~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            drag = not drag
                            if drag then
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 175.0 * 20.0)
                            else
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 0.1 * 20.0)
                            end
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mode Dragster", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            drag = not drag
                            if drag then
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 175.0 * 20.0)
                            else
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 0.1 * 20.0)
                            end
                        end
                    end)
                end

                if rainbow_mode then
                    local ra = RGBRainbow(1.0)
                    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)
                    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)
                end
                if rocket and IsPedInAnyVehicle(PlayerPedId(), true) then
                    if IsControlPressed(0, 209) then
                        SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 70.0)
                    elseif IsControlPressed(0, 210) then
                        SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 0.0)
                    end
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicleCustom")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if permLevel ~= "superadmin" then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Accès réservé aux SuperAdmins")
                    RageUI.Separator("")
                    return
                end

                local veh = vcVeh()
                if not veh then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Vous n'êtes pas dans un véhicule !")
                    RageUI.Separator("")
                    return
                end

                local canCustom = permLevel == "superadmin"

                RageUI.Separator("Couleurs")

                local p, s = GetVehicleColours(veh)
                RageUI.List(cVarLong() .. "→ ~s~Couleur 1", vcColorList, (p or 0) + 1, "~o~Couleur primaire", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then local _, sc = GetVehicleColours(v) SetVehicleColours(v, Index - 1, sc) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Couleur 2", vcColorList, (s or 0) + 1, "~o~Couleur secondaire", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then local pc = GetVehicleColours(v) SetVehicleColours(v, pc, Index - 1) end
                end)

                local pearl, wheelCol = GetVehicleExtraColours(veh)
                RageUI.List(cVarLong() .. "→ ~s~Carrosserie (nacré)", vcColorList, (pearl or 0) + 1, "~o~Couleur nacrée", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then local _, wc = GetVehicleExtraColours(v) SetVehicleExtraColours(v, Index - 1, wc) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Couleur des jantes", vcColorList, (wheelCol or 0) + 1, "~o~Couleur des jantes", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then local pc2 = GetVehicleExtraColours(v) SetVehicleExtraColours(v, pc2, Index - 1) end
                end)

                RageUI.List(cVarLong() .. "→ ~s~Couleur intérieur", vcColorList, (GetVehicleInteriorColour(veh) or 0) + 1, "~o~Couleur de l'habitacle", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then SetVehicleInteriorColour(v, Index - 1) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Couleur tableau de bord", vcColorList, (GetVehicleDashboardColour(veh) or 0) + 1, "~o~Couleur du tableau de bord", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then SetVehicleDashboardColour(v, Index - 1) end
                end)

                RageUI.Separator("Vitres & plaque")

                RageUI.List(cVarLong() .. "→ ~s~Vitres teintées", vcWindowTintList, vcValueIndex(vcWindowTintList, GetVehicleWindowTint(veh)), "~o~Teinte des vitres", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then SetVehicleWindowTint(v, vcWindowTintList[Index].value) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Contour de plaque", vcPlateList, vcValueIndex(vcPlateList, GetVehicleNumberPlateTextIndex(veh)), "~o~Style / contour de la plaque", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then SetVehicleNumberPlateTextIndex(v, vcPlateList[Index].value) end
                end)

                RageUI.Separator("Roues")

                RageUI.List(cVarLong() .. "→ ~s~Type de jantes", vcWheelTypeList, vcValueIndex(vcWheelTypeList, GetVehicleWheelType(veh)), "~o~Catégorie de jantes", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then SetVehicleWheelType(v, vcWheelTypeList[Index].value) end
                end)

                local numFront = GetNumVehicleMods(veh, 23)
                if numFront and numFront > 0 then
                    local items = vcBuildModItems(numFront)
                    local idx = (GetVehicleMod(veh, 23) or -1) + 2
                    if idx < 1 or idx > #items then idx = 1 end
                    RageUI.List(cVarLong() .. "→ ~s~Jantes", items, idx, "~o~Modèle de jantes", {}, canCustom, function() end, function(Index)
                        local v = vcApplyVeh()
                        if v then SetVehicleMod(v, 23, Index - 2, false) end
                    end)
                end

                local numBack = GetNumVehicleMods(veh, 24)
                if numBack and numBack > 0 then
                    local items = vcBuildModItems(numBack)
                    local idx = (GetVehicleMod(veh, 24) or -1) + 2
                    if idx < 1 or idx > #items then idx = 1 end
                    RageUI.List(cVarLong() .. "→ ~s~Jantes arrière", items, idx, "~o~Jantes arrière (moto)", {}, canCustom, function() end, function(Index)
                        local v = vcApplyVeh()
                        if v then SetVehicleMod(v, 24, Index - 2, false) end
                    end)
                end

                RageUI.Separator("Options")

                RageUI.List(cVarLong() .. "→ ~s~Turbo", vcToggleList, (IsToggleModOn(veh, 18) and 2 or 1), "~o~Turbo", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then ToggleVehicleMod(v, 18, Index == 2) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Xénon", vcToggleList, (IsToggleModOn(veh, 22) and 2 or 1), "~o~Phares xénon", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then ToggleVehicleMod(v, 22, Index == 2) end
                end)
                RageUI.List(cVarLong() .. "→ ~s~Fumée de pneus", vcToggleList, (IsToggleModOn(veh, 20) and 2 or 1), "~o~Fumée de pneus", {}, canCustom, function() end, function(Index)
                    local v = vcApplyVeh()
                    if v then ToggleVehicleMod(v, 20, Index == 2) end
                end)

                local liveryCount = GetVehicleLiveryCount(veh)
                if liveryCount and liveryCount > 0 then
                    local items = vcBuildModItems(liveryCount)
                    local idx = (GetVehicleLivery(veh) or -1) + 2
                    if idx < 1 or idx > #items then idx = 1 end
                    RageUI.List(cVarLong() .. "→ ~s~Livrée", items, idx, "~o~Livrée du véhicule", {}, canCustom, function() end, function(Index)
                        local v = vcApplyVeh()
                        if v then SetVehicleLivery(v, Index - 2) end
                    end)
                end

                RageUI.Separator("Carrosserie & intérieur")

                for _, c in ipairs(vcModCategories) do
                    local num = GetNumVehicleMods(veh, c.modType)
                    if num and num > 0 then
                        local items = vcBuildModItems(num)
                        local idx = (GetVehicleMod(veh, c.modType) or -1) + 2
                        if idx < 1 or idx > #items then idx = 1 end
                        RageUI.List(cVarLong() .. "→ ~s~" .. c.label, items, idx, nil, {}, canCustom, function() end, function(Index)
                            local v = vcApplyVeh()
                            if v then SetVehicleMod(v, c.modType, Index - 2, false) end
                        end)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("teleportation")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("Lieux de téléportation")

                RageUI.ButtonWithStyle("Parking Central", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -327.82, -899.74, 32.47, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Poste de police", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 413.69, -980.12, 29.98, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Sandy Shores", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 1755.12, 3741.03, 34.7, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Paleto Bay", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 90.53, 6551.6, 31.61, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Base militaire", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -2146.6, 3092.17, 34.61, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Port", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 1218.4, -3087.35, 6.38, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Plage", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -1796.29, -818.22, 8.68, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Aéroport", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -1028.99, -2723.76, 20.47, false, false, false, true)
                    end
                end)

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("staff")), true, true, true, function()
                shouldStayOpened = true
                for k,v in pairs(serviceStaffRec) do
                    RageUI.ButtonWithStyle(v, nil, {}, true, function()
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("staffActivity")), true, true, true, function()
                shouldStayOpened = true

                if not canUse("staffActivity", permLevel) then
                    RageUI.Separator("~r~Accès réservé aux SuperAdmins")
                    return
                end

                if staffActivityResetting and (GetGameTimer() - staffActivityResetSentAt) > 10000 then
                    staffActivityResetting = false
                end

                if not staffActivityLoading and not staffActivityResetting
                    and (GetGameTimer() - staffActivityFetchedAt) > 30000 then
                    fetchStaffActivity(true)
                end

                RageUI.Separator("Activité du staff ~c~(cumul depuis toujours)")
                RageUI.Separator(("Staffs suivis: ~o~%d~s~ | En service: ~g~%d"):format(
                    staffActivityTotals.staffs or 0, staffActivityOnline))
                RageUI.Separator(("Service cumulé: ~b~%s~s~ | Reports pris: ~y~%d"):format(
                    fmtDuty(staffActivityTotals.duty), staffActivityTotals.reports or 0))

                RageUI.ButtonWithStyle("Rafraîchir les données", "~o~Recharge le classement (le serveur met en cache 15s).",
                    { RightLabel = staffActivityLoading and "~y~Chargement..." or "🔄" }, not staffActivityLoading, function(_, _, s)
                    if s then
                        fetchStaffActivity(true)
                    end
                end)

                RageUI.ButtonWithStyle("Trier par", "~o~Bascule le classement entre temps de service et nombre de reports.",
                    { RightLabel = staffActivitySortBy == "duty" and "~b~Temps de service" or "~y~Reports pris" }, true, function(_, _, s)
                    if s then
                        staffActivitySortBy = (staffActivitySortBy == "duty") and "reports" or "duty"
                        buildStaffActivityEntries()
                    end
                end)

                RageUI.ButtonWithStyle("~r~Réinitialiser les statistiques",
                    "~r~Attention~s~: remet à zéro le temps de service ~s~ET~s~ le nombre de reports de ~r~TOUS~s~ les staffs.~n~~r~Action irréversible.",
                    { RightLabel = staffActivityResetting and "~y~En cours..." or "~r~🗑 Reset" },
                    not staffActivityResetting and not staffActivityLoading, function(_, _, s)
                    if s then
                        local raw = input("Écrivez 'oui' pour confirmer la remise à zéro TOTALE", "", 10, false)
                        local confirm = raw and tostring(raw):gsub("%s+", ""):lower() or ""
                        if confirm ~= "oui" and confirm ~= "o" then
                            ESX.ShowNotification("~o~Réinitialisation annulée.")
                            return
                        end

                        staffActivityResetting  = true
                        staffActivityResetSentAt = GetGameTimer()
                        TriggerServerEvent("adminmenu:resetStaffActivity")
                    end
                end)

                local entries = staffActivityEntries
                local count   = #entries

                if count == 0 then
                    RageUI.Separator(staffActivityLoading and "~y~Chargement..." or "~r~Aucune donnée d'activité staff")
                else
                    RageUI.Separator("Classement")
                    for i = 1, count do
                        local e = entries[i]
                        RageUI.ButtonWithStyle(e.label, e.desc, e.style, true, staffActivityNoop)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("casierOffline")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("Casier hors-ligne ~c~(recherche par license)")

                local rightLabel = "🔍"
                if offlineCasierLoading then
                    rightLabel = "~y~Chargement..."
                elseif offlineCasierLicense ~= "" then
                    rightLabel = "~b~" .. offlineCasierLicense:sub(1, 22)
                end

                RageUI.ButtonWithStyle("Rechercher une license", "~o~Entrez la license du joueur (ex: license:xxxxxxxx)", { RightLabel = rightLabel }, not offlineCasierLoading, function(_, _, s)
                    if s then

                        local raw = pasteInput("Casier hors-ligne", "License du joueur", 80, "license:xxxxxxxxxxxxxxxx")
                        if raw ~= nil then
                            local lic = tostring(raw):gsub("^%s+", ""):gsub("%s+$", "")
                            if lic ~= "" then
                                offlineCasierLicense = lic
                                offlineBans, offlineWarns, offlineJails = {}, {}, {}
                                offlineCasierLoading = true
                                ESX.TriggerServerCallback("adminmenu:getCasierByLicense", function(res)
                                    offlineCasierLoading = false
                                    if type(res) ~= "table" or not res.ok then
                                        offlineCasierLicense = ""
                                        ESX.ShowNotification("~r~License invalide.")
                                        return
                                    end
                                    offlineCasierLicense = res.identifier or lic
                                    offlineBans = res.bans or {}
                                    offlineWarns = res.warns or {}
                                    offlineJails = res.jails or {}
                                    local total = #offlineBans + #offlineWarns + #offlineJails
                                    if not res.exists and total == 0 then
                                        ESX.ShowNotification("~r~Aucun joueur / casier trouvé pour cette license.")
                                    else
                                        ESX.ShowNotification(("~o~Casier chargé: ~s~%d ban(s), %d warn(s), %d jail(s)"):format(#offlineBans, #offlineWarns, #offlineJails))
                                    end
                                end, lic)
                            end
                        end
                    end
                end)

                if offlineCasierLicense ~= "" then
                    RageUI.ButtonWithStyle("~r~Réinitialiser la recherche", nil, { RightLabel = "✖" }, not offlineCasierLoading, function(_, _, s)
                        if s then
                            offlineCasierLicense = ""
                            offlineBans, offlineWarns, offlineJails = {}, {}, {}
                        end
                    end)
                end

                if offlineCasierLicense == "" then
                    RageUI.Separator("~o~Aucune license recherchée")
                elseif not offlineCasierLoading then
                    RageUI.Separator("License: ~b~" .. offlineCasierLicense)
                    if not next(offlineBans) and not next(offlineWarns) and not next(offlineJails) then
                        RageUI.Separator("~g~Casier vierge (aucune sanction)")
                    else
                        drawOfflineCasierCategory("BAN", offlineBans)
                        drawOfflineCasierCategory("WARN", offlineWarns)
                        drawOfflineCasierCategory("JAIL", offlineJails)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("peds")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("Peds")

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Ped Custom", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    if s then
                        local j1 = PlayerId()
                        local newped = input('Entrez le nom du personnage ?', '', 45)
                        local p1 = GetHashKey(newped)
                        RequestModel(p1)
                        while not HasModelLoaded(p1) do
                            Wait(100)
                        end
                        SetPlayerModel(j1, p1)
                        SetModelAsNoLongerNeeded(p1)
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Reprendre son apparence", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    if s then
                        exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
                            local isMale = skin.sex == "mp_m_freemode_01"
                            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                exports['esx_skin']:GetCachedSkin(function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                end)
                            end)
                        end)
                    end
                end)

            end, function()
            end, 1)

            if not shouldStayOpened then
                isMenuOpened = false
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent("adminmenu:openPlayerProfile")
AddEventHandler("adminmenu:openPlayerProfile", function(serverId)
    serverId = tonumber(serverId)
    if not serverId then return end
    if permLevel == nil or permLevel == "user" then return end

    TriggerServerEvent("admin:menu:GetAllPlayers")
    selectedPlayer = serverId

    if not isMenuOpened then
        Citizen.CreateThread(function()
            openMenu()
        end)
    end

    Citizen.CreateThread(function()
        local tries = 0
        while tries < 60 do
            if isMenuOpened and RMenu:Get(cat, subCat("playersManage")) and localPlayers[serverId] then
                break
            end
            Wait(50)
            tries = tries + 1
        end

        if not isMenuOpened then return end
        if not localPlayers[serverId] then
            ESX.ShowNotification("~r~Joueur introuvable dans la liste.")
            return
        end

        local mainMenu = RMenu:Get(cat, subCat("main"))
        local pmMenu   = RMenu:Get(cat, subCat("playersManage"))
        if mainMenu then RageUI.Visible(mainMenu, false) end
        if pmMenu then RageUI.Visible(pmMenu, true) end
    end)
end)

function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end
			Citizen.Wait(0)
		end
	end
end

KEYBOARDACTIVE = false

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    KEYBOARDACTIVE = true
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        KEYBOARDACTIVE = false
        return GetOnscreenKeyboardResult()
    else
        KEYBOARDACTIVE = false
        return nil
    end
end

function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

function getStaffMod()
    return isStaffMode
end
local staffInService = {}

exports("getPlayerInStaffMod", function (source)

    if staffInService[source] then
        return true
    else
        return false
    end
end)

RegisterNetEvent("staffService", function(data)
    if data ~= nil then
        staffInService = data
    end
end)

RegisterCommand("return", function(source, args, rawCommand)
    local serverId = tonumber(args[1])
    TriggerServerEvent("adminmenu:returnTarget", serverId)
end, false)

function getVehicleIn(modelName)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local forward = GetEntityForwardVector(playerPed)
    local spawnCoords = {
        x = coords.x + forward.x * 3.0,
        y = coords.y + forward.y * 3.0,
        z = coords.z,
        heading = heading
    }

    TriggerServerEvent('esx:getVehicleIn', modelName, spawnCoords)
end

RegisterCommand('c', function(_, args)
    local veh = args[1] or 'adder'
    getVehicleIn(veh)
end)
