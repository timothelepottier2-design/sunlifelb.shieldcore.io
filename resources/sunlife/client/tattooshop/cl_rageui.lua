local Config = TattooConfig

local ESX = exports['es_extended']:getSharedObject()

local tattooMenuOpen = false

local categoryLabels = {
    [1]  = "mpbusiness_overlays",   [2]  = "mphipster_overlays",     [3]  = "mpbiker_overlays",
    [4]  = "mpairraces_overlays",   [5]  = "mpbeach_overlays",       [6]  = "mpchristmas2_overlays",
    [7]  = "mpgunrunning_overlays", [8]  = "mpimportexport_overlays",[9]  = "mplowrider2_overlays",
    [10] = "mplowrider_overlays",   [11] = "mpchristmas2017_overlays",[12] = "mpheist3_overlays",
    [13] = "mpheist4_overlays",     [14] = "mpluxe_overlays",        [15] = "mpluxe2_overlays",
    [16] = "mpsecurity_overlays",   [17] = "mpsmuggler_overlays",    [18] = "mpstunt_overlays",
    [19] = "mpsum2_overlays",       [20] = "mpvinewood_overlays",    [21] = "vms_overlays",
    [22] = "multiplayer_overlays",
}

local collectionMenus = {}
local selectedIndex   = {}
local activeCollection = nil
local previewKey       = nil

local function previewTattoo(collection, index)
    local key = collection .. ":" .. index
    if key == previewKey then return end
    previewKey = key
    if Tattoo_DrawTattoo then
        Tattoo_DrawTattoo(index - 1, collection)
    end
end

local function buyTattoo(collection, index)
    local list  = Config.TattooList[collection]
    local entry = list and list[index]
    if not entry then return end

    ESX.TriggerServerCallback("rg_tattoo:buyTattoo", function(success)
        if not success then return end
        TattooState.currentTattoos[#TattooState.currentTattoos + 1] = { collection = collection, texture = index }
        entry.hasTattoo = true
        if Tattoo_ReloadPlayerTattoos then Tattoo_ReloadPlayerTattoos() end
    end, TattooState.currentTattoos, collection, index, entry.price)
end

local function removeTattoo(collection, index)
    local list  = Config.TattooList[collection]
    local entry = list and list[index]
    if not entry then return end

    ESX.TriggerServerCallback("rg_tattoo:removeTattoo", function(success)
        if not success then return end
        for k, v in pairs(TattooState.currentTattoos) do
            if v.collection == collection and v.texture == index then
                table.remove(TattooState.currentTattoos, k)
            end
        end
        entry.hasTattoo = false
        TriggerServerEvent("rg_tattoo:removeTattoo", TattooState.currentTattoos, entry.removePrice)
        if Tattoo_ReloadPlayerTattoos then Tattoo_ReloadPlayerTattoos() end
    end, TattooState.currentTattoos, collection, index, entry.removePrice)
end

function OpenTattooRageMenu(isFemale, categories)
    if tattooMenuOpen then return end

    tattooMenuOpen   = true
    activeCollection = nil
    previewKey       = nil
    collectionMenus  = {}
    selectedIndex    = {}

    if RMenu['tattoo'] then
        for name, _ in pairs(RMenu['tattoo']) do
            RMenu:Delete('tattoo', name)
        end
    end

    RMenu.Add('tattoo', 'main', RageUI.CreateMenu("Tatoueur", "Collections", 1290, 100))
    local mainMenu = RMenu:Get('tattoo', 'main')
    mainMenu:SetRectangleBanner(10, 10, 10, 200)

    for i = 1, 22 do
        local collection = categoryLabels[i]
        local allowed    = categories and categories[tostring(i)]
        local list       = collection and Config.TattooList[collection]
        if allowed and list and #list > 0 then
            local subName = 'col_' .. i
            RMenu.Add('tattoo', subName, RageUI.CreateSubMenu(mainMenu, "Collection " .. i, "Tatouages"))
            local sub = RMenu:Get('tattoo', subName)
            sub:SetRectangleBanner(10, 10, 10, 200)

            local labels = {}
            for idx = 1, #list do
                local t = list[idx]
                labels[idx] = (t and t.label and t.label ~= '') and t.label or ("Tatouage " .. idx)
            end

            collectionMenus[#collectionMenus + 1] = { num = i, collection = collection, menu = sub, labels = labels }
            selectedIndex[collection] = 1
        end
    end

    mainMenu.Closed = function()
        tattooMenuOpen   = false
        collectionMenus  = {}
        activeCollection = nil
        previewKey       = nil
        if DeleteSkinCam then DeleteSkinCam() end

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin then TriggerEvent('skinchanger:loadSkin', skin) end
        end)
    end

    RageUI.CloseAll()
    RageUI.Visible(mainMenu, true)

    Citizen.CreateThread(function()
        while tattooMenuOpen do
            Citizen.Wait(1)

            RageUI.IsVisible(mainMenu, true, true, true, function()

                activeCollection = nil
                for _, entry in ipairs(collectionMenus) do
                    RageUI.ButtonWithStyle("Collection " .. entry.num, nil,
                        { RightLabel = tostring(#Config.TattooList[entry.collection]) .. " ~b~>>" },
                        true, function() end, entry.menu)
                end
            end)

            for _, entry in ipairs(collectionMenus) do
                RageUI.IsVisible(entry.menu, true, true, true, function()
                    local collection = entry.collection

                    if activeCollection ~= collection then
                        activeCollection = collection
                        previewTattoo(collection, selectedIndex[collection] or 1)
                    end

                    local idx = selectedIndex[collection] or 1
                    RageUI.List("Tatouage", entry.labels, idx, nil, {}, true, function(_, _, _, Index)
                        if Index ~= idx then
                            selectedIndex[collection] = Index
                            previewTattoo(collection, Index)
                        end
                    end)

                    local t = Config.TattooList[collection][idx]
                    if t then
                        if t.hasTattoo then
                            RageUI.ButtonWithStyle("Retirer ce tatouage", nil,
                                { RightLabel = "~o~" .. tostring(t.removePrice or 0) .. "$" },
                                true, function(_, _, Selected)
                                    if Selected then removeTattoo(collection, idx) end
                                end)
                        else
                            RageUI.ButtonWithStyle("Se faire tatouer", nil,
                                { RightLabel = "~g~" .. tostring(t.price or 0) .. "$" },
                                true, function(_, _, Selected)
                                    if Selected then buyTattoo(collection, idx) end
                                end)
                        end
                    end
                end)
            end
        end
    end)
end
