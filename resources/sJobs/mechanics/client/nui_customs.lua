local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'mechanics', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'mechanics', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('mechanics/' .. name, cb)
end

local nuiCtx = nil
NuiOrbitDirection = 0
NuiOrbitRadius = 3.2

local NuiColorFamilies = {
    black   = { {index=0,label='Noir'}, {index=1,label='Noir graphite'}, {index=2,label='Noir métallique'}, {index=3,label='Noir acier moulé'}, {index=11,label='Noir anth'}, {index=12,label='Noir matte'}, {index=15,label='Noir foncé'}, {index=16,label='Noir foncé 2'}, {index=21,label='Noir huile'}, {index=147,label='Noir charbon'} },
    white   = { {index=106,label='Blanc vanille'}, {index=107,label='Blanc crème'}, {index=111,label='Blanc'}, {index=112,label='Blanc polaire'}, {index=113,label='Blanc beige'}, {index=121,label='Blanc matte'}, {index=122,label='Blanc neige'}, {index=131,label='Blanc coton'}, {index=132,label='Blanc albâtre'}, {index=134,label='Blanc pur'} },
    grey    = { {index=4,label='Gris argent'}, {index=5,label='Gris métallique'}, {index=6,label='Gris laminé'}, {index=7,label='Gris foncé'}, {index=8,label='Gris rocher'}, {index=9,label='Gris nuit'}, {index=10,label='Gris aluminium'}, {index=13,label='Gris matte'}, {index=14,label='Gris clair'}, {index=17,label='Gris asphalt'}, {index=18,label='Gris béton'}, {index=19,label='Gris foncé'}, {index=20,label='Gris magnésite'}, {index=22,label='Gris nickel'}, {index=23,label='Gris zinc'}, {index=24,label='Gris dolomite'}, {index=25,label='Gris bleu'}, {index=26,label='Gris titanium'}, {index=66,label='Gris acier'}, {index=93,label='Gris champagne'}, {index=144,label='Gris chasseur'}, {index=156,label='Gris'} },
    red     = { {index=27,label='Rouge'}, {index=28,label='Rouge torino'}, {index=29,label='Rouge coquelicot'}, {index=30,label='Rouge cuivre'}, {index=31,label='Rouge cardinal'}, {index=32,label='Rouge brique'}, {index=33,label='Rouge grenat'}, {index=34,label='Rouge cabernet'}, {index=35,label='Rouge bonbon'}, {index=39,label='Rouge matte'}, {index=40,label='Rouge foncé'}, {index=43,label='Rouge pulpe'}, {index=44,label='Rouge brillant'}, {index=46,label='Rouge pâle'}, {index=143,label='Rouge vin'}, {index=150,label='Rouge volcan'} },
    pink    = { {index=135,label='Rose électrique'}, {index=136,label='Rose saumon'}, {index=137,label='Rose sucré'} },
    blue    = { {index=54,label='Bleu topaz'}, {index=60,label='Bleu clair'}, {index=61,label='Bleu galaxy'}, {index=62,label='Bleu foncé'}, {index=63,label='Bleu azure'}, {index=64,label='Bleu marine'}, {index=65,label='Bleu lapis'}, {index=67,label='Bleu diamant'}, {index=68,label='Bleu surfer'}, {index=69,label='Bleu pastel'}, {index=70,label='Bleu céleste'}, {index=73,label='Bleu rally'}, {index=74,label='Bleu paradis'}, {index=75,label='Bleu nuit'}, {index=77,label='Bleu cyan'}, {index=78,label='Bleu cobalt'}, {index=79,label='Bleu électrique'}, {index=80,label='Bleu horizon'}, {index=82,label='Bleu métallique'}, {index=83,label='Bleu aquamarine'}, {index=84,label='Bleu agathe'}, {index=85,label='Bleu zirconium'}, {index=86,label='Bleu spinelle'}, {index=87,label='Bleu tourmaline'}, {index=127,label='Bleu paradis 2'}, {index=140,label='Bleu chewin-gum'}, {index=141,label='Bleu nuit 2'}, {index=146,label='Bleu interdit'}, {index=157,label='Bleu glacier'} },
    yellow  = { {index=42,label='Jaune'}, {index=88,label='Jaune blé'}, {index=89,label='Jaune racing'}, {index=91,label='Jaune pâle'}, {index=126,label='Jaune clair'} },
    green   = { {index=49,label='Vert foncé métallique'}, {index=50,label='Vert rally'}, {index=51,label='Vert pin'}, {index=52,label='Vert olive'}, {index=53,label='Vert clair'}, {index=55,label='Vert citron matte'}, {index=56,label='Vert forêt'}, {index=57,label='Vert gazon'}, {index=58,label='Vert impérial'}, {index=59,label='Vert bouteille'}, {index=92,label='Vert citron 2'}, {index=125,label='Vert anis'}, {index=128,label='Vert kaki'}, {index=133,label='Vert armée'}, {index=151,label='Vert foncé'}, {index=152,label='Vert chasseur'}, {index=155,label='Vert feuillage matte'} },
    orange  = { {index=36,label='Orange mandarine'}, {index=38,label='Orange'}, {index=41,label='Orange matte'}, {index=123,label='Orange clair'}, {index=124,label='Orange pêche'}, {index=130,label='Orange citrouille'}, {index=138,label='Orange lambo'} },
    brown   = { {index=45,label='Marron cuivre'}, {index=47,label='Marron clair'}, {index=48,label='Marron brun foncé'}, {index=90,label='Marron bronze'}, {index=94,label='Marron brun métallique'}, {index=95,label='Marron expresso'}, {index=96,label='Marron chocolat'}, {index=97,label='Marron terre cuite'}, {index=98,label='Marron marbre'}, {index=99,label='Marron sable'}, {index=100,label='Marron sepia'}, {index=101,label='Marron bison'}, {index=102,label='Marron palmier'}, {index=103,label='Marron caramel'}, {index=104,label='Marron rouillé'}, {index=105,label='Marron châtaigne'}, {index=108,label='Marron brun'}, {index=109,label='Marron noisette'}, {index=110,label='Marron coquille'}, {index=114,label='Marron acajou'}, {index=115,label='Marron chaudron'}, {index=116,label='Marron blond'}, {index=129,label='Marron gravier'}, {index=153,label='Marron terre noire'}, {index=154,label='Marron désert'} },
    purple  = { {index=71,label='Violet indigo'}, {index=72,label='Violet foncé'}, {index=76,label='Violet foncé 2'}, {index=81,label='Violet Améthyste'}, {index=142,label='Violet mystique'}, {index=145,label='Violet métallique'}, {index=148,label='Violet matte'}, {index=149,label='Violet foncé matte'} },
    chrome  = { {index=117,label='Chrome brossé'}, {index=118,label='Chrome foncé'}, {index=119,label='Aluminium brossé'}, {index=120,label='Chrome'} },
    gold    = { {index=37,label='Or'}, {index=158,label='Or pur'}, {index=159,label='Or brossé'}, {index=160,label='Or clair'} },
}

local function nuiGetColors(family)
    return NuiColorFamilies[family] or {}
end

local PRICE_MULT = 2.0
local function definePrice(vehiclePrice, modPrice)
    if vehiclePrice == 0 or modPrice == 0 then return 0 end
    return math.floor(vehiclePrice * modPrice / 500 * PRICE_MULT + 0.5)
end

function BuildNuiContent(path, ctx)
    if not ctx or not ctx.vehicle then return { type = "categories", items = {} } end
    path = (path or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local vehicle = ctx.vehicle

    if DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)
    end

    local vehiclePrice = ctx.vehiclePrice or 4000000
    local plaque = ctx.plaque or ""
    local oldProps = ctx.oldProps or {}
    local vipMult = ctx.vipPriceMult or 1.0
    local function applyVipDisplay(base)
        if vipMult >= 0.999 then return base end
        return math.floor(base * vipMult + 0.5)
    end

    if path == "" or path == nil then
        return {
            type = "categories",
            items = {
                { id = "upgrades", name = "Performances" },
                { id = "cosmetics", name = "Cosmétiques" }
            },
            actions = {
                { id = "repair", label = "Réparer" },
                { id = "wash", label = "Laver" },
                { id = "resetCustoms", label = "Revenir à l'arrivée" }
            }
        }
    end

    if path == "upgrades" then
        local items = {}
        if GetNumVehicleMods(vehicle, 11) > 0 then table.insert(items, { id = "upgrades.modEngine", name = "Moteur" }) end
        if GetNumVehicleMods(vehicle, 12) > 0 then table.insert(items, { id = "upgrades.modBrakes", name = "Freinage" }) end
        if GetNumVehicleMods(vehicle, 13) > 0 then table.insert(items, { id = "upgrades.modTransmission", name = "Transmission" }) end
        if GetNumVehicleMods(vehicle, 15) > 0 then table.insert(items, { id = "upgrades.modSuspension", name = "Suspension" }) end
        table.insert(items, { id = "upgrades.modTurbo", name = "Turbo" })
        return { type = "categories", items = items }
    end

    if path == "upgrades.modEngine" and cfg_mecano and cfg_mecano.upgradeNames and cfg_mecano.modPrices then
        local names = cfg_mecano.upgradeNames["modEngine"]
        local prices = cfg_mecano.modPrices["modEngine"]
        local modCount = math.min(GetNumVehicleMods(vehicle, 11) - 1, 6)
        local items = {}
        for i = -1, modCount do
            if names[i] and prices[i] ~= nil then
                local base = definePrice(vehiclePrice, prices[i])
                local price = applyVipDisplay(base)
                table.insert(items, {
                    label = names[i],
                    modName = "modEngine",
                    modValue = i,
                    price = price,
                    isCurrent = (oldProps.modEngine == i),
                    modData = { modPrice = base, name = names[i], modName = "modEngine", modValue = i, plaque = plaque }
                })
            end
        end
        return { type = "options", items = items }
    end

    if path == "upgrades.modBrakes" and cfg_mecano and cfg_mecano.upgradeNames and cfg_mecano.modPrices then
        local names = cfg_mecano.upgradeNames["modBrakes"]
        local prices = cfg_mecano.modPrices["modBrakes"]
        local modCount = math.min(GetNumVehicleMods(vehicle, 12) - 1, 3)
        local items = {}
        for i = -1, modCount do
            if names[i] and prices[i] ~= nil then
                local base = definePrice(vehiclePrice, prices[i])
                local price = applyVipDisplay(base)
                table.insert(items, {
                    label = names[i],
                    modName = "modBrakes",
                    modValue = i,
                    price = price,
                    isCurrent = (oldProps.modBrakes == i),
                    modData = { modPrice = base, name = names[i], modName = "modBrakes", modValue = i, plaque = plaque }
                })
            end
        end
        return { type = "options", items = items }
    end

    if path == "upgrades.modTransmission" and cfg_mecano and cfg_mecano.upgradeNames and cfg_mecano.modPrices then
        local names = cfg_mecano.upgradeNames["modTransmission"]
        local prices = cfg_mecano.modPrices["modTransmission"]
        local modCount = math.min(GetNumVehicleMods(vehicle, 13) - 1, 3)
        local items = {}
        for i = -1, modCount do
            if names[i] and prices[i] ~= nil then
                local base = definePrice(vehiclePrice, prices[i])
                local price = applyVipDisplay(base)
                table.insert(items, {
                    label = names[i],
                    modName = "modTransmission",
                    modValue = i,
                    price = price,
                    isCurrent = (oldProps.modTransmission == i),
                    modData = { modPrice = base, name = names[i], modName = "modTransmission", modValue = i, plaque = plaque }
                })
            end
        end
        return { type = "options", items = items }
    end

    if path == "upgrades.modSuspension" and cfg_mecano and cfg_mecano.upgradeNames and cfg_mecano.modPrices then
        local names = cfg_mecano.upgradeNames["modSuspension"]
        local prices = cfg_mecano.modPrices["modSuspension"]
        local modCount = math.min(GetNumVehicleMods(vehicle, 15) - 1, 5)
        local items = {}
        for i = -1, modCount do
            if names[i] and prices[i] ~= nil then
                local base = definePrice(vehiclePrice, prices[i])
                local price = applyVipDisplay(base)
                table.insert(items, {
                    label = names[i],
                    modName = "modSuspension",
                    modValue = i,
                    price = price,
                    isCurrent = (oldProps.modSuspension == i),
                    modData = { modPrice = base, name = names[i], modName = "modSuspension", modValue = i, plaque = plaque }
                })
            end
        end
        return { type = "options", items = items }
    end

    if path == "upgrades.modTurbo" and cfg_mecano and cfg_mecano.modPrices then
        local prices = cfg_mecano.modPrices["modTurbo"]
        local items = {}
        local b0 = definePrice(vehiclePrice, prices[0] or 0)
        local b1 = definePrice(vehiclePrice, prices[1] or 0)
        local p0 = applyVipDisplay(b0)
        local p1 = applyVipDisplay(b1)
        table.insert(items, {
            label = "Turbo Stock",
            modName = "modTurbo",
            modValue = 0,
            price = p0,
            isCurrent = (oldProps.modTurbo == 0),
            modData = { modPrice = b0, name = "Turbo Stock", modName = "modTurbo", modValue = 0, plaque = plaque }
        })
        table.insert(items, {
            label = "Turbo activé",
            modName = "modTurbo",
            modValue = 1,
            price = p1,
            isCurrent = (oldProps.modTurbo == 1),
            modData = { modPrice = b1, name = "Turbo activé", modName = "modTurbo", modValue = 1, plaque = plaque }
        })
        return { type = "options", items = items }
    end

    if path == "cosmetics" then
        local items = {}
        table.insert(items, { id = "cosmetics.windowTint", name = "Teinte vitres" })
        table.insert(items, { id = "cosmetics.modHorns", name = "Klaxons" })
        table.insert(items, { id = "cosmetics.modXenon", name = "Xenon" })
        table.insert(items, { id = "cosmetics.neonEnabled", name = "Néons" })
        table.insert(items, { id = "cosmetics.resprays", name = "Peinture" })
        table.insert(items, { id = "cosmetics.plateIndex", name = "Couleur de plaque" })
        table.insert(items, { id = "cosmetics.bodyparts", name = "Carrosserie" })
        table.insert(items, { id = "cosmetics.wheels", name = "Roues" })
        table.insert(items, { id = "cosmetics.bennysc", name = "Benny's" })
        return { type = "categories", items = items }
    end

    if path == "cosmetics.plateIndex" then
        local plateStyles = {
            [0] = "Bleu sur blanc 1",
            [1] = "Jaune sur noir",
            [2] = "Jaune sur bleu",
            [3] = "Bleu sur blanc 2",
            [4] = "Bleu sur blanc 3",
        }
        local priceTbl = cfg_mecano and cfg_mecano.modPrices and cfg_mecano.modPrices["plateIndex"]
        local mult = (type(priceTbl) == "table") and (priceTbl[0] or 1.1) or (priceTbl or 1.1)
        local items = {}
        -- L'index courant peut etre -1 en base (vehicule sans plaque a la
        -- capture) : on le considere comme le style 0 pour l'affichage.
        local currentPlate = tonumber(oldProps.plateIndex) or 0
        if currentPlate < 0 then currentPlate = 0 end
        for i = 0, 4 do
            local base = definePrice(vehiclePrice, mult)
            local price = applyVipDisplay(base)
            local label = plateStyles[i]
            table.insert(items, {
                label = label,
                modName = "plateIndex",
                modValue = i,
                price = price,
                isCurrent = (currentPlate == i),
                modData = { modPrice = base, name = "Plaque " .. label, modName = "plateIndex", modValue = i, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    if path == "cosmetics.windowTint" and cfg_mecano and cfg_mecano.windowsTintNames and cfg_mecano.modPrices then
        local names = cfg_mecano.windowsTintNames
        local prices = cfg_mecano.modPrices["windowTint"]
        local priceMult = type(prices) == "table" and (prices[1] or 1.12) or prices
        local items = {}
        for i = 0, 5 do
            local name = names[i] or ("Teinte " .. i)
            local base = definePrice(vehiclePrice, priceMult)
            local price = applyVipDisplay(base)
            table.insert(items, {
                label = name,
                modName = "windowTint",
                modValue = i,
                price = price,
                isCurrent = (oldProps.windowTint == i),
                modData = { modPrice = base, name = name, modName = "windowTint", modValue = i, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    if path == "cosmetics.modXenon" then
        return {
            type = "categories",
            items = {
                { id = "cosmetics.modXenon.toggle", name = "Activer / Désactiver" },
                { id = "cosmetics.modXenon.color",  name = "Couleur des xénons" },
            }
        }
    end

    if path == "cosmetics.modXenon.toggle" and cfg_mecano and cfg_mecano.modPrices then
        local prices = cfg_mecano.modPrices["modXenon"] or {}
        local items = {}
        local x0 = definePrice(vehiclePrice, prices[0] or 0)
        local x1 = definePrice(vehiclePrice, prices[1] or 0)
        local p0 = applyVipDisplay(x0)
        local p1 = applyVipDisplay(x1)
        table.insert(items, {
            label = "Xenon désactivé",
            modName = "modXenon",
            modValue = 0,
            price = p0,
            isCurrent = (oldProps.modXenon == 0),
            modData = { modPrice = x0, name = "Xenon désactivé", modName = "modXenon", modValue = 0, plaque = plaque }
        })
        table.insert(items, {
            label = "Xenon activé",
            modName = "modXenon",
            modValue = 1,
            price = p1,
            isCurrent = (oldProps.modXenon == 1),
            modData = { modPrice = x1, name = "Xenon activé", modName = "modXenon", modValue = 1, plaque = plaque }
        })
        return { type = "options", items = items }
    end

    if path == "cosmetics.modXenon.color" and cfg_mecano and cfg_mecano.modPrices then
        local priceMult = cfg_mecano.modPrices["xenonColor"] or 15.75
        local mult = (type(priceMult) == "table") and (priceMult[0] or 15.75) or priceMult
        local items = {}
        for i = 0, 12 do
            local label = (GetXenonColorName and GetXenonColorName(i)) or ("Couleur " .. i)
            local base  = definePrice(vehiclePrice, mult)
            local price = applyVipDisplay(base)
            local isCurrent = (oldProps.modXenon == 1) and (oldProps.xenonColor == i)
            table.insert(items, {
                label = label,
                modName = "xenonColor",
                modValue = i,
                price = price,
                isCurrent = isCurrent,
                modData = { modPrice = base, name = "Xenon " .. label, modName = "xenonColor", modValue = i, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    if path == "cosmetics.resprays" then
        return {
            type = "categories",
            items = {
                { id = "cosmetics.resprays.color1", name = "Couleur principale" },
                { id = "cosmetics.resprays.color2", name = "Couleur secondaire" },
                { id = "cosmetics.resprays.pearlescentColor", name = "Nacré" },
                { id = "cosmetics.resprays.interiorColour", name = "Intérieur" },
                { id = "cosmetics.resprays.dashboardColour", name = "Tableau de bord" },
            }
        }
    end

    local colorFamilies = {
        { id = "black",   name = "Noir" },
        { id = "white",   name = "Blanc" },
        { id = "grey",    name = "Gris" },
        { id = "red",     name = "Rouge" },
        { id = "pink",    name = "Rose" },
        { id = "blue",    name = "Bleu" },
        { id = "yellow",  name = "Jaune" },
        { id = "green",   name = "Vert" },
        { id = "orange",  name = "Orange" },
        { id = "brown",   name = "Marron" },
        { id = "purple",  name = "Violet" },
        { id = "chrome",  name = "Chrome" },
        { id = "gold",    name = "Or" },
    }

    local paintModKeys = { "color1", "color2", "pearlescentColor", "interiorColour", "dashboardColour" }
    for _, modKey in ipairs(paintModKeys) do
        if path == "cosmetics.resprays." .. modKey then
            local items = {}
            for _, fam in ipairs(colorFamilies) do
                table.insert(items, { id = path .. "." .. fam.id, name = fam.name })
            end
            return { type = "categories", items = items }
        end
    end

    for _, modKey in ipairs(paintModKeys) do
        local prefix = "cosmetics.resprays." .. modKey .. "."
        if path:sub(1, #prefix) == prefix then
            local family = path:sub(#prefix + 1):lower()
            if family ~= "" then
                local colors = nuiGetColors(family)
                local priceMult = cfg_mecano and cfg_mecano.modPrices and cfg_mecano.modPrices[modKey]
                local mult = (type(priceMult) == "table") and (priceMult[0] or 1) or (priceMult or 1)
                local items = {}
                for i = 1, #colors do
                    local v = colors[i]
                    if type(v) == "table" and (v.index ~= nil or v.label) then
                        local idx = v.index
                        local label = v.label or ("Couleur " .. tostring(idx))
                        local base = definePrice(vehiclePrice, mult)
                        local price = applyVipDisplay(base)
                        local currentVal = oldProps[modKey]
                        if currentVal == nil and modKey == "interiorColour" then currentVal = oldProps["interiorColor"] end
                        if currentVal == nil and modKey == "dashboardColour" then currentVal = oldProps["dashboardColor"] end
                        table.insert(items, {
                            label = label,
                            modName = modKey,
                            modValue = idx,
                            price = price,
                            isCurrent = (currentVal == idx),
                            modData = { modPrice = base, name = label, modName = modKey, modValue = idx, plaque = plaque }
                        })
                    end
                end
                if #items == 0 then
                    local fb = definePrice(vehiclePrice, mult)
                    table.insert(items, {
                        label = "Couleur " .. family,
                        modName = modKey,
                        modValue = 0,
                        price = applyVipDisplay(fb),
                        isCurrent = (oldProps[modKey] == 0),
                        modData = { modPrice = fb, name = "Couleur", modName = modKey, modValue = 0, plaque = plaque }
                    })
                end
                return { type = "options", items = items }
            end
        end
    end

    if path == "cosmetics.modHorns" and cfg_mecano and cfg_mecano.modPrices then
        local hornCount = GetNumVehicleMods(vehicle, 14) - 1
        if hornCount < 0 then hornCount = 0 end
        hornCount = math.min(hornCount, 51)
        local priceTbl = cfg_mecano.modPrices["modHorns"]
        local items = {}
        for i = -1, hornCount do
            local mult = (type(priceTbl) == "table") and (priceTbl[i] or priceTbl[0] or 1.12) or (priceTbl or 1.12)
            local name = GetHornName and GetHornName(i) or ("Klaxon " .. (i + 2))
            local base = definePrice(vehiclePrice, mult)
            local price = applyVipDisplay(base)
            table.insert(items, {
                label = name,
                modName = "modHorns",
                modValue = i,
                price = price,
                isCurrent = (oldProps.modHorns == i),
                modData = { modPrice = base, name = name, modName = "modHorns", modValue = i, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    if path == "cosmetics.neonEnabled" and cfg_mecano and cfg_mecano.modPrices then
        local items = {}
        local prices = cfg_mecano.modPrices["neonEnabled"] or {}
        local n0 = definePrice(vehiclePrice, prices[0] or 0)
        local n1 = definePrice(vehiclePrice, prices[1] or 1.12)
        local p0 = applyVipDisplay(n0)
        local p1 = applyVipDisplay(n1)
        table.insert(items, {
            label = "Néons désactivés",
            modName = "neonEnabled",
            modValue = { 0, 0, 0, 0 },
            price = p0,
            isCurrent = (oldProps.neonEnabled and (oldProps.neonEnabled[1] or 0) == 0),
            modData = { modPrice = n0, name = "Néons désactivés", modName = "neonEnabled", modValue = { 0, 0, 0, 0 }, plaque = plaque }
        })
        if GetNeons then
            for _, neon in ipairs(GetNeons()) do
                local modVal = { 1, 1, 1, 1, neon.r or 255, neon.g or 255, neon.b or 255 }
                local isCurrent = oldProps.neonEnabled and oldProps.neonEnabled[1] == 1 and oldProps.neonColor and oldProps.neonColor[1] == neon.r and (oldProps.neonColor[2] or 0) == neon.g and (oldProps.neonColor[3] or 0) == neon.b
                table.insert(items, {
                    label = "Néon " .. (neon.label or "Couleur"),
                    modName = "neonEnabled",
                    modValue = modVal,
                    price = p1,
                    isCurrent = isCurrent,
                    modData = { modPrice = n1, name = "Néon " .. (neon.label or ""), modName = "neonEnabled", modValue = modVal, plaque = plaque }
                })
            end
        else
            table.insert(items, {
                label = "Néon blanc",
                modName = "neonEnabled",
                modValue = { 1, 1, 1, 1 },
                price = p1,
                isCurrent = (oldProps.neonEnabled and oldProps.neonEnabled[1] == 1),
                modData = { modPrice = n1, name = "Néon blanc", modName = "neonEnabled", modValue = { 1, 1, 1, 1 }, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    if path == "cosmetics.wheels" then
        local items = {}
        table.insert(items, { id = "cosmetics.wheels.types", name = "Type de roues" })
        table.insert(items, { id = "cosmetics.wheels.wheelColor", name = "Couleur des roues" })
        table.insert(items, { id = "cosmetics.wheels.tyreSmokeColor", name = "Fumée de pneu" })
        return { type = "categories", items = items }
    end

    if path == "cosmetics.wheels.types" then
        local items = {}
        local isBike = IsThisModelABike and IsThisModelABike(GetEntityModel(vehicle))
        if not isBike then
            table.insert(items, { id = "cosmetics.wheels.types.sport", name = "Sport" })
            table.insert(items, { id = "cosmetics.wheels.types.muscle", name = "Muscle" })
            table.insert(items, { id = "cosmetics.wheels.types.lowrider", name = "Lowrider" })
            table.insert(items, { id = "cosmetics.wheels.types.suv", name = "SUV" })
            table.insert(items, { id = "cosmetics.wheels.types.allterrain", name = "Tout terrain" })
            table.insert(items, { id = "cosmetics.wheels.types.tuning", name = "Tuning" })
        end
        table.insert(items, { id = "cosmetics.wheels.types.motorcycle", name = "Moto" })
        if not isBike then
            table.insert(items, { id = "cosmetics.wheels.types.highend", name = "Highend" })
            table.insert(items, { id = "cosmetics.wheels.types.bennys", name = "Benny's" })
            table.insert(items, { id = "cosmetics.wheels.types.bespoke", name = "Sur mesure" })
            table.insert(items, { id = "cosmetics.wheels.types.street", name = "Street" })
        end
        return { type = "categories", items = items }
    end

    local wheelTypeMap = {
        ["sport"] = 0, ["muscle"] = 1, ["lowrider"] = 2, ["suv"] = 3, ["allterrain"] = 4,
        ["tuning"] = 5, ["motorcycle"] = 6, ["highend"] = 7, ["bennys"] = 8, ["bespoke"] = 9, ["street"] = 10
    }
    if path and path:match("^cosmetics%.wheels%.types%.(%w+)$") then
        local wheelTypeName = path:match("^cosmetics%.wheels%.types%.(%w+)$")
        local wheelTypeId = wheelTypeMap[wheelTypeName]
        if wheelTypeId ~= nil and cfg_mecano and cfg_mecano.modPrices then
            local priceKey = wheelTypeName == "motorcycle" and "motorcycle" or (wheelTypeName == "bennys" and "bennys") or wheelTypeName
            local priceMult = cfg_mecano.modPrices[priceKey] or cfg_mecano.modPrices["sport"] or 4.65
            local mult = (type(priceMult) == "table") and (priceMult[0] or priceMult[1] or 4.65) or priceMult
            local savedWheel = oldProps.wheels and (oldProps.wheels + 0) or GetVehicleWheelType(vehicle)
            SetVehicleWheelType(vehicle, wheelTypeId)
            local modCount = GetNumVehicleMods(vehicle, 23) - 1
            if modCount < 0 then modCount = 0 end
            modCount = math.min(modCount, 80)
            local items = {}
            for i = -1, modCount do
                local modLabel = nil
                if GetModTextLabel and GetLabelText then
                    local tl = GetModTextLabel(vehicle, 23, i)
                    if tl and tl ~= "" then modLabel = GetLabelText(tl) end
                end
                if modLabel == "NULL" or not modLabel or modLabel == "" then
                    modLabel = (i == -1) and (wheelTypeName:gsub("^%l", string.upper) .. " Stock") or ("Style " .. (i + 1))
                end
                local base = definePrice(vehiclePrice, mult)
                local price = applyVipDisplay(base)
                local modValue = { wheelTypeId, i }
                local isCurrent = (oldProps.wheels == wheelTypeId and (oldProps.modFrontWheels == i or (GetVehicleClass(vehicle) == 8 and oldProps.modBackWheels == i)))
                table.insert(items, {
                    label = modLabel,
                    modName = "wheels",
                    modValue = modValue,
                    price = price,
                    isCurrent = isCurrent,
                    modData = { modPrice = base, name = "Roues " .. modLabel, modName = "wheels", modValue = modValue, plaque = plaque }
                })
            end
            SetVehicleWheelType(vehicle, savedWheel)
            return { type = "options", items = items }
        end
    end

    if path == "cosmetics.wheels.wheelColor" and cfg_mecano then
        local priceMult = cfg_mecano.modPrices and cfg_mecano.modPrices["wheelColor"] or 0.66
        local mult = (type(priceMult) == "table") and (priceMult[0] or 0.66) or priceMult
        local items = {}
        for _, fam in ipairs(colorFamilies) do
            local colors = nuiGetColors(fam.id) or {}
            if type(colors) == "table" and #colors > 0 then
                for i = 1, #colors do
                    local v = colors[i]
                    if type(v) == "table" and (v.index ~= nil or v.label) then
                        local idx = v.index
                        local label = v.label or ("Couleur " .. tostring(idx))
                        local base = definePrice(vehiclePrice, mult)
                        local price = applyVipDisplay(base)
                        table.insert(items, {
                            label = label,
                            modName = "wheelColor",
                            modValue = idx,
                            price = price,
                            isCurrent = (oldProps.wheelColor == idx),
                            modData = { modPrice = base, name = "Peinture " .. label, modName = "wheelColor", modValue = idx, plaque = plaque }
                        })
                    end
                end
            end
        end
        if #items > 0 then return { type = "options", items = items } end
    end

    if path == "cosmetics.wheels.tyreSmokeColor" and GetNeons and cfg_mecano and cfg_mecano.modPrices then
        local priceMult = cfg_mecano.modPrices["tyreSmokeColor"] or 1.12
        local mult = (type(priceMult) == "table") and (priceMult[0] or 1.12) or priceMult
        local items = {}
        for _, v in ipairs(GetNeons()) do
            local rgb = { v.r or 255, v.g or 255, v.b or 255 }
            local base = definePrice(vehiclePrice, mult)
            local price = applyVipDisplay(base)
            local isCurrent = oldProps.tyreSmokeColor and oldProps.tyreSmokeColor[1] == v.r and (oldProps.tyreSmokeColor[2] or 0) == v.g and (oldProps.tyreSmokeColor[3] or 0) == v.b
            table.insert(items, {
                label = v.label or "Fumée",
                modName = "tyreSmokeColor",
                modValue = rgb,
                price = price,
                isCurrent = isCurrent,
                modData = { modPrice = base, name = "Fumée " .. (v.label or ""), modName = "tyreSmokeColor", modValue = rgb, plaque = plaque }
            })
        end
        return { type = "options", items = items }
    end

    local bodyPartSlots = {
        { id = "modSpoilers",     name = "Spoiler",        slot = 0 },
        { id = "modFrontBumper",  name = "Pare-chocs avant", slot = 1 },
        { id = "modRearBumper",   name = "Pare-chocs arrière", slot = 2 },
        { id = "modSideSkirt",    name = "Jupes",          slot = 3 },
        { id = "modExhaust",      name = "Échappement",    slot = 4 },
        { id = "modFrame",        name = "Châssis",        slot = 5 },
        { id = "modGrille",       name = "Calandre",       slot = 6 },
        { id = "modHood",         name = "Capot",           slot = 7 },
        { id = "modFender",       name = "Aile",           slot = 8 },
        { id = "modRightFender",  name = "Aile droite",    slot = 9 },
        { id = "modRoof",         name = "Toit",           slot = 10 },
    }
    if path == "cosmetics.bodyparts" then
        local items = {}
        for _, part in ipairs(bodyPartSlots) do

            if GetNumVehicleMods(vehicle, part.slot) > 0 then
                table.insert(items, { id = "cosmetics.bodyparts." .. part.id, name = part.name })
            end
        end
        return { type = "categories", items = items }
    end

    if path and path:sub(1, 20) == "cosmetics.bodyparts." then
        local modKey = path:sub(21)
        local slot = nil
        for _, part in ipairs(bodyPartSlots) do
            if part.id == modKey then slot = part.slot break end
        end
        if slot ~= nil and cfg_mecano and cfg_mecano.modPrices then
            local priceTbl = cfg_mecano.modPrices[modKey]
            local mult = (type(priceTbl) == "table") and (priceTbl[0] or priceTbl[-1] or 4.65) or (priceTbl or 4.65)
            local modCount = GetNumVehicleMods(vehicle, slot) - 1
            if modCount < 0 then modCount = 0 end
            local items = {}
            for i = -1, modCount do
                local base = definePrice(vehiclePrice, (type(priceTbl) == "table") and (priceTbl[i] or priceTbl[0] or mult) or mult)
                local price = applyVipDisplay(base)
                local label = (GetModTextLabel and GetLabelText) and GetLabelText(GetModTextLabel(vehicle, slot, i)) or nil
                if not label or label == "NULL" or label == "" then
                    label = (i == -1) and "Stock" or ("Style " .. (i + 1))
                end
                local isCurrent = (oldProps[modKey] == i)
                table.insert(items, {
                    label = label,
                    modName = modKey,
                    modValue = i,
                    price = price,
                    isCurrent = isCurrent,
                    modData = { modPrice = base, name = label, modName = modKey, modValue = i, plaque = plaque }
                })
            end
            return { type = "options", items = items }
        end
    end

    local bennysSlots = {
        { id = "modPlateHolder",   name = "Support plaque",   slot = 25 },
        { id = "modVanityPlate",   name = "Plaque vanity",     slot = 26 },
        { id = "modTrimA",         name = "Habillage A",       slot = 27 },
        { id = "modOrnaments",     name = "Ornements",        slot = 28 },
        { id = "modDashboard",     name = "Tableau de bord",   slot = 29 },
        { id = "modDial",          name = "Cadran",           slot = 30 },
        { id = "modDoorSpeaker",   name = "Haut-parleurs portes", slot = 31 },
        { id = "modSeats",         name = "Sièges",           slot = 32 },
        { id = "modSteeringWheel", name = "Volant",          slot = 33 },
        { id = "modShifterLeavers", name = "Levier de vitesses", slot = 34 },
        { id = "modAPlate",        name = "Plaque A",         slot = 35 },
        { id = "modSpeakers",      name = "Enceintes",        slot = 36 },
        { id = "modTrunk",         name = "Coffre",           slot = 37 },
        { id = "modHydrolic",      name = "Hydraulique",      slot = 38 },
        { id = "modEngineBlock",   name = "Bloc moteur",      slot = 39 },
        { id = "modAirFilter",     name = "Filtre à air",     slot = 40 },
        { id = "modStruts",        name = "Biellettes",       slot = 41 },
        { id = "modArchCover",     name = "Passe-roue",       slot = 42 },
        { id = "modAerials",       name = "Antennes",         slot = 43 },
        { id = "modTrimB",         name = "Habillage B",      slot = 44 },
        { id = "modTank",         name = "Réservoir",        slot = 45 },
        { id = "modWindows",       name = "Vitres",           slot = 46 },
        { id = "modLivery",        name = "Livrée",           slot = 48 },
    }
    if path == "cosmetics.bennysc" then
        local items = {}
        for _, part in ipairs(bennysSlots) do

            if GetNumVehicleMods(vehicle, part.slot) > 0 then
                table.insert(items, { id = "cosmetics.bennysc." .. part.id, name = part.name })
            end
        end
        return { type = "categories", items = items }
    end

    local bennysPrefix = "cosmetics.bennysc."
    if path and #path > #bennysPrefix and path:sub(1, #bennysPrefix) == bennysPrefix then
        local modKey = path:sub(#bennysPrefix + 1)
        local slot = nil
        for _, part in ipairs(bennysSlots) do
            if part.id == modKey then slot = part.slot break end
        end
        if slot ~= nil then
            local priceTbl = (cfg_mecano and cfg_mecano.modPrices) and cfg_mecano.modPrices[modKey]
            local defaultMult = 4.65
            local mult = (type(priceTbl) == "table") and (priceTbl[0] or priceTbl[-1] or defaultMult) or (priceTbl or defaultMult)
            local modCount = GetNumVehicleMods(vehicle, slot) - 1
            if modCount < 0 then modCount = 0 end
            local items = {}
            for i = -1, modCount do
                local base = definePrice(vehiclePrice, (type(priceTbl) == "table") and (priceTbl[i] or priceTbl[0] or mult) or mult)
                local price = applyVipDisplay(base)
                local label = (GetModTextLabel and GetLabelText) and GetLabelText(GetModTextLabel(vehicle, slot, i)) or nil
                if not label or label == "NULL" or label == "" then
                    label = (i == -1) and "Stock" or ("Style " .. (i + 1))
                end
                local isCurrent = (oldProps[modKey] == i)
                table.insert(items, {
                    label = label,
                    modName = modKey,
                    modValue = i,
                    price = price,
                    isCurrent = isCurrent,
                    modData = { modPrice = base, name = label, modName = modKey, modValue = i, plaque = plaque }
                })
            end
            return { type = "options", items = items }
        end
    end

    return { type = "categories", items = {} }
end

function SetNuiMecanoContext(ctx)
    nuiCtx = ctx
end

function GetNuiMecanoContext()
    return nuiCtx
end

RegisterNUICallback("getContent", function(data, cb)
    local path = (data and data.path) and data.path or ""
    local ctx = GetNuiMecanoContext()
    local result = BuildNuiContent(path, ctx)
    if ctx and ctx.oldProps then
        result.oldProps = ctx.oldProps
    end
    cb(result)
end)

RegisterNUICallback("applyMod", function(data, cb)
    local ctx = GetNuiMecanoContext()
    if not ctx or not ctx.buyFn or not data then cb({ ok = false }) return end
    ctx.buyFn(data.modPrice, data.name, data.modName, data.modValue, data.plaque or ctx.plaque)
    cb({ ok = true })
end)

RegisterNUICallback("previewMod", function(data, cb)
    if not data or not data.modName then cb({}) return end
    TriggerEvent("custommenu:previewMod", data.modName, data.modValue)
    cb({})
end)

RegisterNUICallback("clearPreview", function(_, cb)
    TriggerEvent("custommenu:clearPreview")
    cb({})
end)

RegisterNUICallback("setOrbitDirection", function(data, cb)
    local d = (data and data.direction)
    if d == -1 or d == 0 or d == 1 then
        NuiOrbitDirection = d
    end
    cb({})
end)

RegisterNUICallback("setOrbitZoom", function(data, cb)
    local delta = (data and data.delta)
    if type(delta) == "number" then
        NuiOrbitRadius = math.max(2.0, math.min(6.0, (NuiOrbitRadius or 3.2) + delta * 0.28))
    end
    cb({})
end)

RegisterNUICallback("saveCustom", function(_, cb)
    local ctx = GetNuiMecanoContext()
    if not ctx or not ctx.vehicle or not ctx.plaque or not ctx.vehiclePrice then
        cb({ ok = false, message = "Contexte invalide." })
        return
    end
    local cart = ctx.cart or {}
    if #cart == 0 then
        cb({ ok = false, message = "Panier vide." })
        return
    end
    local myCar = ESX.Game.GetVehicleProperties(ctx.vehicle)
    local cartItems = {}
    for _, it in ipairs(cart) do
        table.insert(cartItems, { modName = it.modName, modValue = it.modValue })
    end
    TriggerServerEvent("custommenu:saveCustom", myCar, ctx.plaque, ctx.vehiclePrice, cartItems)
    cb({ ok = true })
end)

RegisterNUICallback("executeAction", function(data, cb)
    local action = data and data.action
    local ctx = GetNuiMecanoContext()
    if not ctx or not ctx.vehicle or not DoesEntityExist(ctx.vehicle) then
        cb({ ok = false, message = "Véhicule invalide." })
        return
    end
    local veh = ctx.vehicle
    if action == "repair" then
        SetVehicleFixed(veh)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        SetVehicleDirtLevel(veh, 0.0)
        cb({ ok = true, message = "Véhicule réparé." })
    elseif action == "wash" then
        SetVehicleDirtLevel(veh, 0.0)
        cb({ ok = true, message = "Véhicule lavé." })
    elseif action == "resetCustoms" then

        if not ctx.oldProps or type(ctx.oldProps) ~= "table" then
            cb({ ok = false, message = "Impossible de restaurer." })
            return
        end
        if ESX and ESX.Game and ESX.Game.SetVehicleProperties then
            ESX.Game.SetVehicleProperties(veh, ctx.oldProps)
            cb({ ok = true, message = "Customisation rétablie (état à l'arrivée)." })
        else
            cb({ ok = false, message = "Erreur." })
        end
    else
        cb({ ok = false, message = "Action inconnue." })
    end
end)

RegisterNUICallback("close", function(_, cb)
    NuiOrbitDirection = 0
    NuiOrbitRadius = 3.2

    local ctx = GetNuiMecanoContext()
    SetNuiMecanoContext(nil)
    SetNuiFocus(false, false)
    cb({})

    if ctx and ctx.onClose then
        Citizen.CreateThread(function()
            local ok, err = pcall(ctx.onClose)
            if not ok then
                print(("[mecano] onClose erreur ignoree : %s"):format(tostring(err)))
            end
        end)
    end
end)
