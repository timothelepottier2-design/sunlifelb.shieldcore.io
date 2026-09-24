INVENTORY.UI.Outfit = {}
INVENTORY.UI.Outfit.Alpha = 0
INVENTORY.UI.Outfit.outfitEkip = false
local w, h
local wSep, hSep
local clipX, clipY
CreateThread(function ()
    w, h = UI.ConvertToPixel(90, 90)
    wSep, hSep = UI.ConvertToPixel(370, 29)
    clipX, clipY = UI.ConvertToPixel(60, 60)
end)
INVENTORY.UI.Outfit.outfitEkipData = {}
function INVENTORY.UI.Outfit.Draw()
    local baseX, baseY = INVENTORY.Pos.outfit.x, INVENTORY.Pos.outfit.y
    local x, y = UI.CalculateCorrecteSizeForUI("ui_ground_icon", "inventory", "outfit_icon", 70, 70)
    UI.DrawSpriteNew("inventory", "outfit_icon", baseX, baseY, x, y, 0, 255, 106, 0, INVENTORY.UI.Outfit.Alpha, {}, function ()

    end)

    UI.DrawTexts(baseX + 0.025, baseY+ 0.01, "Outfits", false, 0.4, {255, 255, 255, math.floor(INVENTORY.UI.Outfit.Alpha)}, UI.font["robmed"], false, false, false)
    local i = 0
    local lines = 0
    local posX, posY = baseX, baseY + h - 0.005

    local x, y = UI.ConvertToPixel(581, 1000)
    UI.DrawRect( baseX, baseY + h - 0.05 , x, y, 0, 255, 255, 255,0, {}, function (s, h)
        if h then
            if not IsControlPressed(0, 24) and not IsDisabledControlPressed(0, 24) then
                if INVENTORY.UI.Player.ItemGrabIndex ~= 0  then
                    if not INVENTORY.UI.InteractItem.NeedConfirmCount then
                        local data = INVENTORY.UI.Player.ItemGrabData
                        local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                        local male = false -- Définit une variable 'male' à false par défaut
                        
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if data.name == "outfit" then
                            
                            for k, v in pairs(ConfigShared.Outfit) do
                                if male then
                                    if v.skin ~= nil then
                                        for key, value in pairs(v.skin.male) do
                                            INVENTORY.ChangeClothOutfit(key, value)
                                        end
        
                                    else
                                        INVENTORY.ChangeClothOutfit(v.name, v.male.defaultValue)
                                        INVENTORY.ChangeClothOutfit(v.itemVariation, v.male.defaultValueVariation)
                                    end
        
                                else
                                    if v.skin ~= nil then
                                        for key, value in pairs(v.skin.female) do
                                            INVENTORY.ChangeClothOutfit(key, value)
                                        end
                                    else
        
                                        INVENTORY.ChangeClothOutfit(v.name, v.female.defaultValue)
                                        INVENTORY.ChangeClothOutfit(v.itemVariation, v.female.defaultValueVariation)
                                    end
                                end
                            end
                            for type, value in pairs(data.metadatas.data) do
                                INVENTORY.ChangeClothOutfit(type, value)
                            end
                            INVENTORY.Raccourci.PlayAnim("pants")
                            INVENTORY.UI.Outfit.outfitEkip = true
                            INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
                            TriggerServerEvent("inventory:server:updateOutfit", INVENTORY.UI.Outfit.outfitEkipData)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                            INVENTORY.SyncOufit()

                        end
                    end
                    
                end
            end
        end
    end)
    if not INVENTORY.UI.Outfit.outfitEkip then
        UI.DrawSpriteNew("inventory", "outfit_normal", 0.47552081942558, 0.86666667461395, w, h, 0, 255, 255, 255, INVENTORY.UI.Outfit.Alpha, {
            devmod = false,
            NoSelect = true,
            NoHover = false,
            CustomHoverTexture = {"inventory", "outfit_normal"}
        }, function (onSelected, onHovered)
            
        end)
    else
        local baseX, baseY = 0.47552081942558, 0.86666667461395
        local size = GetTextureResolution("item_icon", "outfit")
        local sprite = 'outfit'
        if size.x == 4.0 and size.y == 4.0 then
            sprite = "box"
        end
        local x,y = UI.CalculateCorrecteSizeForUI("item_icon"..i, "item_icon", sprite, 70, 70)
        UI.DrawSpriteNew("inventory", "background_item", baseX, baseY, w, h , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            NoHover = false
        }, function(onSelected, onHovered)
            if onHovered then
                if IsControlPressed(0, 25) or IsDisabledControlPressed(0, 25) then
                    INVENTORY.UI.Outfit.outfitEkip = false
                    INVENTORY.Raccourci.PlayAnim("pants")
                    local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                    local male = false -- Définit une variable 'male' à false par défaut
                    TriggerServerEvent("inventory:server:updateOutfit", nil)
                    if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                        male = true -- Si le modèle est celui du personnage masculin freemode
                    end
                    for k, v in pairs(ConfigShared.Outfit) do
                        if male then
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.male) do
                                    INVENTORY.ChangeClothOutfit(key, value)
                                end

                            else
                                INVENTORY.ChangeClothOutfit(v.name, v.male.defaultValue)
                                INVENTORY.ChangeClothOutfit(v.itemVariation, v.male.defaultValueVariation)
                            end

                        else
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.female) do
                                    INVENTORY.ChangeClothOutfit(key, value)
                                end
                            else

                                INVENTORY.ChangeClothOutfit(v.name, v.female.defaultValue)
                                INVENTORY.ChangeClothOutfit(v.itemVariation, v.female.defaultValueVariation)
                            end
                        end
                    end
                    INVENTORY.SyncOufit()
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_skin:save', skin)
                    end)
                end
            end

        end)
        if sprite == "box" then
            local x,y = UI.CalculateCorrecteSizeForUI("ui_icon_item"..i, "inventory", "box", 70, 70)
            UI.DrawSpriteNew("inventory", "box", baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                centerDraw = true,
                NoHover = false
            }, function(onSelected, onHovered)

            end)
            x, y = UI.ConvertToPixel(90, 2)
            UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

            end)
        else

            UI.DrawSpriteNew("item_icon", sprite, baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                centerDraw = true,
                NoHover = false

            }, function(onSelected, onHovered)

            end)
            x, y = UI.ConvertToPixel(90, 2)
            UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()
            end)
        end
    end
    for k, v in pairs(ConfigShared.Outfit) do
        if i >= 6 then
            i = 0
            lines = lines + 1
            posX = (posX) + (w + wSep) * lines
        end
        if not v.equip then
            UI.DrawSpriteNew("inventory", v.sprite, posX, ( baseY + h - 0.005) + (h + hSep) * i, w, h, 0, 255, 255, 255, INVENTORY.UI.Outfit.Alpha, {
                devmod = false,
                NoSelect = true,
                NoHover = false,
                CustomHoverTexture = {"inventory", v.sprite}
            }, function (onSelected, onHovered)
                if onHovered then
                    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
                        if not IsDisabledControlPressed(0, 24) and INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
                            local data = INVENTORY.UI.Player.ItemGrabData
                            if data.name == v.itemName then
                                v.equip = true
                                v.data = INVENTORY.UI.Player.ItemGrabData
                                INVENTORY.UI.Player.ItemGrabIndex = 0
                                if data.metadatas.data ~= nil then
                                    for key, value in pairs(data.metadatas.data) do
                                        INVENTORY.ChangeCloth(key, value)
                                    end
                                    INVENTORY.Raccourci.PlayAnim(data.name)
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerServerEvent('esx_skin:save', skin)
                                    end)
                                end
                                if INVENTORY.UI.Outfit.outfitEkip then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        local datas = {}
                                        for key, value in pairs(skin) do
                                            for ke, va in pairs(INVENTORY.UI.Outfit.outfitEkipData.data) do
                                                if key == ke then
                                                    datas[key] = value
                                                end
                                            end
                                        end
                                        local metadatas = INVENTORY.UI.Outfit.outfitEkipData
                                        metadatas.data = datas
                                        TriggerServerEvent('inventory:server:changedatainventory', "outfit", INVENTORY.UI.Outfit.outfitEkipData, metadatas)

                                        TriggerServerEvent("inventaire:server:trucbidule", data.name, data.metadatas)
                                    end)
                                end
                                ---Truc qui change la tenue
                            end
                        end
                    end
                end
            end)
        else
            local baseX, baseY = posX, ( baseY + h - 0.005) + (h + hSep) * i
            local size = GetTextureResolution("item_icon", v.itemName)
            local sprite = v.itemName

            if size.x == 4.0 and size.y == 4.0 then
                sprite = "box"
            end

            UI.DrawSpriteNew("inventory", "background_item", baseX, baseY, w, h , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                NoHover = false
            }, function(onSelected, onHovered)
                if onHovered then
                    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
                        if not IsDisabledControlPressed(0, 24) and INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
                            local data = INVENTORY.UI.Player.ItemGrabData
                            if data.name == v.itemName then
                                v.equip = true
                                INVENTORY.UI.Player.ItemGrabIndex = 0
                                v.data = INVENTORY.UI.Player.ItemGrabData
                                if data.metadatas.data ~= nil then
                                    for key, value in pairs(data.metadatas.data) do
                                        INVENTORY.ChangeCloth(key, value)
                                    end
                                    INVENTORY.Raccourci.PlayAnim(data.name)
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerServerEvent('esx_skin:save', skin)
                                    end)
                                end
                                if INVENTORY.UI.Outfit.outfitEkip then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        local datas = {}
                                        for key, value in pairs(skin) do
                                            for ke, va in pairs(INVENTORY.UI.Outfit.outfitEkipData.data) do
                                                if key == ke then
                                                    datas[key] = value
                                                end
                                            end
                                        end
                                        local metadatas = INVENTORY.UI.Outfit.outfitEkipData
                                        metadatas.data = datas
                                        TriggerServerEvent('inventory:server:changedatainventory', "outfit", INVENTORY.UI.Outfit.outfitEkipData, metadatas)

                                        TriggerServerEvent("inventaire:server:trucbidule", data.name, data.metadatas)
                                    end)
                                end
                                ---Truc qui change la tenue
                            end
                        end
                    end

                    if IsControlPressed(0, 25) or IsDisabledControlPressed(0, 25) then
                        v.equip = false
                        INVENTORY.UI.Player.ItemGrabIndex = 0
                        INVENTORY.Raccourci.PlayAnim(v.itemName)
                        local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                        local male = false -- Définit une variable 'male' à false par défaut
                        
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if male then
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.male) do
                                    INVENTORY.ChangeCloth(key, value)
                                end

                            else
                                INVENTORY.ChangeCloth(v.name, v.male.defaultValue)
                                INVENTORY.ChangeCloth(v.itemVariation, v.male.defaultValueVariation)
                            end

                        else
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.female) do
                                    INVENTORY.ChangeCloth(key, value)
                                end
                            else

                                INVENTORY.ChangeCloth(v.name, v.female.defaultValue)
                                INVENTORY.ChangeCloth(v.itemVariation, v.female.defaultValueVariation)
                            end
                        end
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                        end)
                        if INVENTORY.UI.Outfit.outfitEkip then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                local datas = {}
                                for key, value in pairs(skin) do
                                    for ke, va in pairs(INVENTORY.UI.Outfit.outfitEkipData.data) do
                                        if key == ke then
                                            datas[key] = value
                                        end
                                    end     
                                end
                                local metadatas = INVENTORY.UI.Outfit.outfitEkipData
                                metadatas.data = datas
                                TriggerServerEvent('inventory:server:changedatainventory', "outfit", INVENTORY.UI.Outfit.outfitEkipData, metadatas)

                                TriggerServerEvent('inventaire:server:addItemOutfit', v.data.name, 1, v.data.metadatas)
                            end)
                        end
                    end
                end
            end)

            UI.DrawSpriteNew("inventory", "hair_clip", 0.55572915077209, 0.85833334922791, clipX, clipY, 0, 255, 255, 255, INVENTORY.UI.Outfit.Alpha, {
                devmod = false,
                NoSelect = false,
                NoHover = false,
                CustomHoverTexture = {"inventory", "hair_clip_hovered"}
            }, function (onSelected, onHovered)
                if onSelected then
                    INVENTORY.UI.Outfit.ChangeHair()
                end
            end)

            UI.DrawSpriteNew("inventory", "hand_normal", 0.40989583730698, 0.85833334922791, clipX, clipY, 0, 255, 255, 255, INVENTORY.UI.Outfit.Alpha, {
                devmod = false,
                NoSelect = false,
                NoHover = false,
                CustomHoverTexture = {"inventory", "hand_hovered"}
            }, function (onSelected, onHovered)
                if onSelected then
                    INVENTORY.UI.Outfit.ChangeGloves()
                end
            end)

            if sprite == "box" then
                local x,y = UI.CalculateCorrecteSizeForUI("ui_icon_item"..i, "inventory", "box", 70, 70)
                UI.DrawSpriteNew("inventory", "box", baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                    centerDraw = true,
                    NoHover = false
                }, function(onSelected, onHovered)

                end)
                x, y = UI.ConvertToPixel(90, 2)
                UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

                end)
            else
                local x,y = UI.CalculateCorrecteSizeForUI("item_icon"..i, "item_icon", sprite, 70, 70)
                UI.DrawSpriteNew("item_icon", sprite, baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                    centerDraw = true,
                    NoHover = false

                }, function(onSelected, onHovered)

                end)
                x, y = UI.ConvertToPixel(90, 2)
                UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()
                end)
            end
        end
        i = i + 1
    end

end

local last = nil

-- Coiffure "cheveux attachés" appliquée par la pince (n'affecte pas la couleur des cheveux)
local tiedHair = {
    male = 7,
    female = 11,
}

local cooldown = false
function INVENTORY.UI.Outfit.ChangeHair()
    if not cooldown then
        cooldown = true
        CreateThread(function ()
            Utils.LoadAnimDict("clothingtie")

            TriggerEvent('skinchanger:getSkin', function(skin)
                local data = skin

                if data["hair_1"] == nil then
                    cooldown = false
                    return
                end

                local male = GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01')
                local tied = male and tiedHair.male or tiedHair.female

                TaskPlayAnim(PlayerPedId(), "clothingtie", "check_out_a", 3.0, 3.0, 3000, 51, false, false, false)
                UI.RealWait(2500)

                if last == nil then
                    -- On mémorise la coiffure actuelle puis on applique les cheveux attachés
                    last = data["hair_1"]
                    INVENTORY.ChangeClothOutfit("hair_1", tied)
                else
                    -- On restaure la coiffure d'origine
                    INVENTORY.ChangeClothOutfit("hair_1", last)
                    last = nil
                end

                cooldown = false
            end)
        end)
    end
end

local lastz = nil
local cooldownz = false
local glovesVariation = {
    male = {
        [16] = 4,
        [17] = 4,
        [18] = 4,
        [19] = 0,
        [20] = 1,
        [21] = 2,
        [22] = 4,
        [23] = 5,
        [24] = 6,
        [25] = 8,
        [26] = 11,
        [27] = 12,
        [28] = 14,
        [29] = 15,
        [30] = 0,
        [31] = 1,
        [32] = 2,
        [33] = 4,
        [34] = 5,
        [35] = 6,
        [36] = 8,
        [37] = 11,
        [38] = 12,
        [39] = 14,
        [40] = 15,
        [41] = 0,
        [42] = 1,
        [43] = 2,
        [44] = 4,
        [45] = 5,
        [46] = 6,
        [47] = 8,
        [48] = 11,
        [49] = 12,
        [50] = 14,
        [51] = 15,
        [52] = 0,
        [53] = 1,
        [54] = 2,
        [55] = 4,
        [56] = 5,
        [57] = 6,
        [58] = 8,
        [59] = 11,
        [60] = 12,
        [61] = 14,
        [62] = 15,
        [63] = 0,
        [64] = 1,
        [65] = 2,
        [66] = 4,
        [67] = 5,
        [68] = 6,
        [69] = 8,
        [70] = 11,
        [71] = 12,
        [72] = 14,
        [73] = 15,
        [74] = 0,
        [75] = 1,
        [76] = 2,
        [77] = 4,
        [78] = 5,
        [79] = 6,
        [80] = 8,
        [81] = 11,
        [82] = 12,
        [83] = 14,
        [84] = 15,
        [85] = 0,
        [86] = 1,
        [87] = 2,
        [88] = 4,
        [89] = 5,
        [90] = 6,
        [91] = 8,
        [92] = 11,
        [93] = 12,
        [94] = 14,
        [95] = 15,
        [96] = 4,
        [97] = 4,
        [98] = 4,
        [99] = 0,
        [100] = 1,
        [101] = 2,
        [102] = 4,
        [103] = 5,
        [104] = 6,
        [105] = 8,
        [106] = 11,
        [107] = 12,
        [108] = 14,
        [109] = 15,
        [110] = 4,
        [111] = 4,
        [115] = 112,
        [116] = 112,
        [117] = 112,
        [118] = 112,
        [119] = 112,
        [120] = 112,
        [121] = 112,
        [122] = 113,
        [123] = 113,
        [124] = 113,
        [125] = 113,
        [126] = 113,
        [127] = 113,
        [128] = 113,
        [129] = 114,
        [130] = 114,
        [131] = 114,
        [132] = 114,
        [133] = 114,
        [134] = 114,
        [135] = 114,
        [136] = 15,
        [137] = 15,
        [138] = 0,
        [139] = 1,
        [140] = 2,
        [141] = 4,
        [142] = 5,
        [143] = 6,
        [144] = 8,
        [145] = 11,
        [146] = 12,
        [147] = 14,
        [148] = 112,
        [149] = 113,
        [150] = 114,
        [151] = 0,
        [152] = 1,
        [153] = 2,
        [154] = 4,
        [155] = 5,
        [156] = 6,
        [157] = 8,
        [158] = 11,
        [159] = 12,
        [160] = 14,
        [161] = 112,
        [162] = 113,
        [163] = 114,
        [165] = 4,
        [166] = 4,
        [167] = 4,
    },
    female = {
        [16] = 11,
        [17] = 3,
        [18] = 3,
        [19] = 3,
        [20] = 0,
        [21] = 1,
        [22] = 2,
        [23] = 3,
        [24] = 4,
        [25] = 5,
        [26] = 6,
        [27] = 7,
        [28] = 9,
        [29] = 11,
        [30] = 12,
        [31] = 14,
        [32] = 15,
        [33] = 0,
        [34] = 1,
        [35] = 2,
        [36] = 3,
        [37] = 4,
        [38] = 5,
        [39] = 6,
        [40] = 7,
        [41] = 9,
        [42] = 11,
        [43] = 12,
        [44] = 14,
        [45] = 15,
        [46] = 0,
        [47] = 1,
        [48] = 2,
        [49] = 3,
        [50] = 4,
        [51] = 5,
        [52] = 6,
        [53] = 7,
        [54] = 9,
        [55] = 11,
        [56] = 12,
        [57] = 14,
        [58] = 15,
        [59] = 0,
        [60] = 1,
        [61] = 2,
        [62] = 3,
        [63] = 4,
        [64] = 5,
        [65] = 6,
        [66] = 7,
        [67] = 9,
        [68] = 11,
        [69] = 12,
        [70] = 14,
        [71] = 15,
        [72] = 0,
        [73] = 1,
        [74] = 2,
        [75] = 3,
        [76] = 4,
        [77] = 5,
        [78] = 6,
        [79] = 7,
        [80] = 9,
        [81] = 11,
        [82] = 12,
        [83] = 14,
        [84] = 15,
        [85] = 0,
        [86] = 1,
        [87] = 2,
        [88] = 3,
        [89] = 4,
        [90] = 5,
        [91] = 6,
        [92] = 7,
        [93] = 9,
        [94] = 11,
        [95] = 12,
        [96] = 14,
        [97] = 15,
        [98] = 0,
        [99] = 1,
        [100] = 2,
        [101] = 3,
        [102] = 4,
        [103] = 5,
        [104] = 6,
        [105] = 7,
        [106] = 9,
        [107] = 11,
        [108] = 12,
        [109] = 14,
        [110] = 15,
        [111] = 3,
        [112] = 3,
        [113] = 3,
        [114] = 0,
        [115] = 1,
        [116] = 2,
        [117] = 3,
        [118] = 4,
        [119] = 5,
        [120] = 6,
        [121] = 7,
        [122] = 9,
        [123] = 11,
        [124] = 12,
        [125] = 14,
        [126] = 15,
        [127] = 3,
        [128] = 3,
        [132] = 129,
        [133] = 129,
        [134] = 129,
        [135] = 129,
        [136] = 129,
        [137] = 129,
        [138] = 129,
        [139] = 130,
        [140] = 130,
        [141] = 130,
        [142] = 130,
        [143] = 130,
        [144] = 130,
        [145] = 130,
        [146] = 131,
        [147] = 131,
        [148] = 131,
        [149] = 131,
        [150] = 131,
        [151] = 131,
        [152] = 131,
        [154] = 153,
        [155] = 153,
        [156] = 153,
        [157] = 153,
        [158] = 153,
        [159] = 153,
        [160] = 153,
        [162] = 161,
        [163] = 161,
        [164] = 161,
        [165] = 161,
        [166] = 161,
        [167] = 161,
        [168] = 161,
        [169] = 15,
        [170] = 15,
        [171] = 0,
        [172] = 1,
        [173] = 2,
        [174] = 3,
        [175] = 4,
        [176] = 5,
        [177] = 6,
        [178] = 7,
        [179] = 9,
        [180] = 11,
        [181] = 12,
        [182] = 14,
        [183] = 129,
        [184] = 130,
        [185] = 131,
        [186] = 153,
        [187] = 0,
        [188] = 1,
        [189] = 2,
        [190] = 3,
        [191] = 4,
        [192] = 5,
        [193] = 6,
        [194] = 7,
        [195] = 9,
        [196] = 11,
        [197] = 12,
        [198] = 14,
        [199] = 129,
        [200] = 130,
        [201] = 131,
        [202] = 153,
        [203] = 161,
        [204] = 161,
        [206] = 3,
        [207] = 3,
        [208] = 3,
    }
}

function INVENTORY.UI.Outfit.ChangeGloves()
    local data = {}
    if not cooldownz then
        cooldownz = true
        CreateThread(function ()
            Utils.LoadAnimDict("nmt_3_rcm-10")
            
            TriggerEvent('skinchanger:getSkin', function(skin)
                data = skin
                if lastz == nil then 
                    if data["arms"] then
                        local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                        local male = false -- Définit une variable 'male' à false par défaut
                        
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if male then
                            if glovesVariation.male[data["arms"]] ~= nil then
                                lastz = data["arms"]
                                data["arms"] = tonumber(data["arms"])
                                TaskPlayAnim(PlayerPedId(),  "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 3000, 51, false, false, false)
                                UI.RealWait(1200)
                                cooldownz = false

                                INVENTORY.ChangeClothOutfit("arms", glovesVariation.male[data["arms"]])
                            end
                        else
                            if glovesVariation.female[data["hair_1"]] ~= nil then
                                lastz = data["arms"]
                                data["arms"] = tonumber(data["arms"])
                                TaskPlayAnim(PlayerPedId(),  "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 3000, 51, false, false, false)
                                UI.RealWait(1200)
                                cooldownz = false

                                INVENTORY.ChangeClothOutfit("arms", glovesVariation.female[data["arms"]])
                            end
                        end
                    end
                else
                    if data["arms"] then
                        local male = false -- Définit une variable 'male' à false par défaut
                
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if male then
                            if lastz ~= nil then
                                TaskPlayAnim(PlayerPedId(),  "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 3000, 51, false, false, false)
                                UI.RealWait(1200)
                                cooldownz = false

                                INVENTORY.ChangeClothOutfit("arms", lastz)
                            end
                        else
                            if lastz ~= nil then
                                TaskPlayAnim(PlayerPedId(),  "nmt_3_rcm-10", "cs_nigel_dual-10", 3.0, 3.0, 3000, 51, false, false, false)
                                UI.RealWait(1200)
                                cooldownz = false

                                INVENTORY.ChangeClothOutfit("arms", lastz)
                            end
                        end
                        lastz = nil
                    end
                end
                cooldownz = false

            end)
        end)
    end
end
