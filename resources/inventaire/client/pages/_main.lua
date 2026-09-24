INVENTORY.UI = {}
INVENTORY.UI.Main = {}
INVENTORY.UI.Main.Alpha = 0
INVENTORY.UI.Main.AlphaBackground = 0
INVENTORY.DEAD = false
local wPLayer, hPlayer = UI.ConvertToPixel(76, 124)
local wGround, hGround = UI.ConvertToPixel(1273, 563)
local wOutfit, hOutfit = UI.ConvertToPixel(678, 124)
INVENTORY.Pos = {
    player = vector2(wPLayer, hPlayer),
    ground = vector2(wGround, hGround),
    outfit = vector2(wOutfit, hOutfit),
    other = vector2(wGround, hPlayer),
    playerprox = vector2(wGround, hGround)
}
--TODO: Fonction qui fait tout les alphas

---PAS OUBLIER LES CONFIG DE COULEUR ETC ETC ETC 
function INVENTORY.UI.Main.Draw()
    SetScriptGfxDrawBehindPausemenu(1)
    UI.DrawRect(0, 0, 1.0, 1.0, 0, 14, 15, 20, INVENTORY.UI.Main.AlphaBackground, {}, function ()
    end)
    --Logo
    local x, y = UI.CalculateCorrecteSizeForUI("logo_inventory", "inventory", "logo", 100, 100)

    UI.DrawSpriteNew("inventory", "logo", 0.5, 0.093518517911434, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        centerDraw = true
    }, function ()

    end)

    --DIFFERENTS PART
    INVENTORY.Alpha()
    INVENTORY.UI.Player.Draw()


    if IsPedInAnyVehicle(PlayerPedId(), false) or IsPedInAnyVehicle(PlayerPedId(), true) then
        INVENTORY.UI.PlayerProx.Draw()
    else
        if not INVENTORY.Permis.Open and not INVENTORY.Permis.OpenPermis and not INVENTORY.Permis.OpenWeapon and not INVENTORY.Permis.OpenChasse and not INVENTORY.Permis.OpenPeche and not INVENTORY.Permis.OpenAircraft and not INVENTORY.Permis.OpenBateau or INVENTORY.Pos.ground == vector2(wGround, hPlayer) then
            if INVENTORY.UI.Other.Info ~= "" then
                INVENTORY.UI.PlayerProx.Draw()
            else

                INVENTORY.UI.Ground.Draw()
            end
        end
    end
    INVENTORY.UI.Outfit.Draw()

    if INVENTORY.UI.Other.Info ~= "" then
        if INVENTORY.Pos.ground ~= vector2(wGround, hGround) then
            INVENTORY.Pos.ground = vector2(wGround, hGround)
        end
        INVENTORY.UI.Other.Draw()
    
    else
        if INVENTORY.Pos.ground ~= vector2(wGround, hPlayer) then
            INVENTORY.Pos.ground = vector2(wGround, hPlayer)
        end
        if not INVENTORY.Permis.Open and not INVENTORY.Permis.OpenPermis and not INVENTORY.Permis.OpenWeapon  and not INVENTORY.Permis.OpenChasse and not INVENTORY.Permis.EmsOpen and not INVENTORY.Permis.OpenPeche and not INVENTORY.Permis.LspdOpen and not INVENTORY.Permis.BcsoOpen and not INVENTORY.Permis.BobcatOpen and not INVENTORY.Permis.LsfdOpen and not INVENTORY.Permis.GouvOpen and not INVENTORY.Permis.OpenAircraft and not INVENTORY.Permis.OpenBateau then
            INVENTORY.UI.PlayerProx.Draw()
        end
    end
    INVENTORY.GetStatusGrab()
    if INVENTORY.UI.InteractItem.NeedConfirmCount then
        INVENTORY.UI.InteractItem.DrawChoice(INVENTORY.UI.InteractItem.Data)
    end
    if INVENTORY.Permis.Open then
        INVENTORY.Permis.DrawId()
    end

    if INVENTORY.Permis.OpenPermis then
        INVENTORY.Permis.DrawPermis()
    end
    if INVENTORY.Permis.OpenWeapon then 
        INVENTORY.Permis.DrawWeapon()
    end

    if INVENTORY.Permis.OpenChasse then 
        INVENTORY.Permis.DrawChasse()
    end

    if INVENTORY.Permis.LspdOpen then 
        INVENTORY.Permis.DrawBadgeLSPD()
    end
    if INVENTORY.Permis.BcsoOpen then 
        INVENTORY.Permis.DrawBadgeSheriff()
    end

    if INVENTORY.Permis.EmsOpen then
        INVENTORY.Permis.DrawBadgeEms()
    end
    if INVENTORY.Permis.BobcatOpen then
        INVENTORY.Permis.DrawBadgeBobcat()
    end
    if INVENTORY.Permis.LsfdOpen then
        INVENTORY.Permis.DrawBadgeLsfd()
    end
    if INVENTORY.Permis.GouvOpen then
        INVENTORY.Permis.DrawBadgeGouv()
    end
    if INVENTORY.Permis.OpenPeche then 
        INVENTORY.Permis.DrawPeche()
    end

    if INVENTORY.Permis.OpenAircraft then
        INVENTORY.Permis.DrawAircraft()
    end

    if INVENTORY.Permis.OpenBateau then
        INVENTORY.Permis.DrawBateau()
    end

    if INVENTORY.Permis.OpenLvId then
        INVENTORY.Permis.DrawLvId()
    end

    if INVENTORY.UI.Input.InputActive then
        INVENTORY.UI.InputDraw()
    end
end

Open = false
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(data, type, pedId)
    if Open then
        Open = false
    else
        Open = true
        local load = false
        CreateThread(function ()
            while Open and not INVENTORY.Open do
                if IsControlJustPressed(0, 177) then
                    Open = false
                    if lastDui ~= nil then
                        DestroyDui(lastDui)
                        lastDui = nil
                    end
                    return
                end

                if type == "permisems" then
                    INVENTORY.Permis.DataEms = data
                    if data and data.mugshot and not load then 
                        if lastDui ~= nil then 
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        load = true
                        -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. type..data.firstname
                        local uniqueTextureName = 'dui_tex_' .. type..data.firstname
                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
    
                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataEms.textureDict = uniqueDictName
                        INVENTORY.Permis.DataEms.textureName = uniqueTextureName
                            -- DestroyDui(dui)
                    end
                    INVENTORY.Permis.DrawBadgeEms()
                end
                if type == "permissheriff" then
                    INVENTORY.Permis.DataBcso = data
                    if data and data.mugshot and not load then 
                        if lastDui ~= nil then 
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        load = true
                        -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. type..data.firstname
                        local uniqueTextureName = 'dui_tex_' .. type..data.firstname
                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
    
                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataBcso.textureDict = uniqueDictName
                        INVENTORY.Permis.DataBcso.textureName = uniqueTextureName
                            -- DestroyDui(dui)
                    end
                    INVENTORY.Permis.DrawBadgeSheriff()
                end
                if type == "permispolice" then
                    INVENTORY.Permis.DataLspd = data
                    if data and data.mugshot and not load then 
                        if lastDui ~= nil then 
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        load = true
                        -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. type..data.firstname
                        local uniqueTextureName = 'dui_tex_' .. type..data.firstname
                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
    
                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataLspd.textureDict = uniqueDictName
                        INVENTORY.Permis.DataLspd.textureName = uniqueTextureName
                            -- DestroyDui(dui)
                    end
                    INVENTORY.Permis.DrawBadgeLSPD()
                end
                if type == "permisbobcat" or type == "permislsfd" or type == "permisgouv" then
                    local key = (type == "permisbobcat" and "DataBobcat")
                        or (type == "permislsfd" and "DataLsfd")
                        or "DataGouv"
                    INVENTORY.Permis[key] = data
                    if data and data.mugshot and not load then
                        if lastDui ~= nil then
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        load = true
                        local uniqueDictName = 'dui_dict_' .. type..data.firstname
                        local uniqueTextureName = 'dui_tex_' .. type..data.firstname
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        local dui = CreateDui(data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        INVENTORY.Permis[key].textureDict = uniqueDictName
                        INVENTORY.Permis[key].textureName = uniqueTextureName
                    end
                    if type == "permisbobcat" then
                        INVENTORY.Permis.DrawBadgeBobcat()
                    elseif type == "permislsfd" then
                        INVENTORY.Permis.DrawBadgeLsfd()
                    else
                        INVENTORY.Permis.DrawBadgeGouv()
                    end
                end
                if type == "identitycard" then
                    INVENTORY.Permis.DataId = data


                    if data and data.mugshot and not load then 
                        if lastDui ~= nil then 
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        load = true
                        -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. type..data.firstname
                        local uniqueTextureName = 'dui_tex_' .. type..data.firstname
                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
    
                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataId.textureDict = uniqueDictName
                        INVENTORY.Permis.DataId.textureName = uniqueTextureName
                    end

                    INVENTORY.Permis.DrawId()
                end
                if type == "permisauto" then
                    INVENTORY.Permis.DataPermis = data

                    INVENTORY.Permis.DrawPermis()
                end
                if type == "permisweapon" then
                    INVENTORY.Permis.DataWeapon = data
                    INVENTORY.Permis.DrawWeapon()
                end
                if type == "permisaircraft" then
                    INVENTORY.Permis.DataAircraft = data or {}
                    INVENTORY.Permis.DrawAircraft()
                end
                if type == "permisbateau" then
                    INVENTORY.Permis.DataBateau = data or {}
                    INVENTORY.Permis.DrawBateau()
                end
                if type == "carte_lasventuras" then
                    INVENTORY.Permis.DataLvId = data or {}
                    INVENTORY.Permis.DrawLvId()
                end
            
                if INVENTORY.Permis.OpenChasse then 
                    INVENTORY.Permis.DrawChasse()
                end
            
                if INVENTORY.Permis.OpenPeche then 
                    INVENTORY.Permis.DrawPeche()
                end
                Wait(1)
            end
        end)
    end
end)

local w, h = UI.ConvertToPixel(90, 90)
local saveX, saveY = UI.GetControl().x, UI.GetControl().y
local idSelected = 1
function INVENTORY.UI.DrawItem(baseX, baseY, i, data, type)

    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 and INVENTORY.UI.Player.ItemGrabIndex == i and type == "player" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end
    if INVENTORY.UI.Ground.ItemGrabIndex ~= 0 and INVENTORY.UI.Ground.ItemGrabIndex == i and type == "ground" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end

    if INVENTORY.UI.Other.ItemGrabIndex ~= 0 and INVENTORY.UI.Other.ItemGrabIndex == i and type == "other" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end

    local sprite, iconDict, iconCustom = ItemIcons.Resolve(data.name)
    UI.DrawSpriteNew("inventory", "background_item", baseX, baseY, w, h , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        NoHover = false
    }, function(onSelected, onHovered)
        if onHovered then
            local x = UI.GetControl().x
            local y = UI.GetControl().y
            -- if type == "player" and IsControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 25)  then
            --     if not INVENTORY.UI.InteractItem.Maintain then
            --         saveX, saveY = x, y
            --         idSelected = i
            --         INVENTORY.UI.InteractItem.Maintain = true
            --     else
            --         INVENTORY.UI.InteractItem.Maintain = false
            --     end
            -- end
            if not INVENTORY.UI.InteractItem.Maintain and  INVENTORY.UI.Player.ItemGrabIndex == 0 and INVENTORY.UI.Ground.ItemGrabIndex == 0 and INVENTORY.UI.Other.ItemGrabIndex == 0 then
                INVENTORY.UI.InteractItem.Draw(x, y, data)
            end
        end


        if onSelected then
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Player.ItemGrabIndex == 0 and type == "player" then
                INVENTORY.UI.Player.ItemGrabIndex = i
            end
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Ground.ItemGrabIndex == 0 and type == "ground" then
                INVENTORY.UI.Ground.ItemGrabIndex = i
            end
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Other.ItemGrabIndex == 0 and type == "other" then
                INVENTORY.UI.Other.ItemGrabIndex = i
            end
        end
    end)

    if INVENTORY.UI.InteractItem.Maintain and idSelected == i and type == "player" then
        INVENTORY.UI.InteractItem.DrawWithOption(saveX, saveY, data)
    end
    UI.DrawTexts(baseX + 0.002, baseY, tostring("x"..data.count), false, 0.2, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, 0, false, false)
    if sprite == "box" then
        local x,y = UI.CalculateCorrecteSizeForUI("ui_icon_item"..i..type, "inventory", "box", 70, 70)
        UI.DrawSpriteNew("inventory", "box", baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            centerDraw = true,
            NoHover = false
        }, function(onSelected, onHovered)

        end)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    elseif iconCustom then
        local x,y = UI.ConvertToPixel(70, 70)
        ItemIcons.Draw(iconDict, sprite, baseX + (w/2 ), baseY + h/2, x, y, INVENTORY.UI.Main.Alpha)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    else
        local x,y = UI.CalculateCorrecteSizeForUI("item_icon"..i..type, "item_icon", sprite, 70, 70)
        UI.DrawSpriteNew("item_icon", sprite, baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            centerDraw = true,
            NoHover = false

        }, function(onSelected, onHovered)

        end)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    end
    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 and INVENTORY.UI.Player.ItemGrabIndex == i or INVENTORY.UI.Ground.ItemGrabIndex ~= 0 and INVENTORY.UI.Ground.ItemGrabIndex == i    then
        SetScriptGfxDrawOrder(7)
    end
    if  INVENTORY.UI.Other.ItemGrabIndex ~= 0 and INVENTORY.UI.Other.ItemGrabIndex == i then
        SetScriptGfxDrawOrder(7)

    end
end

function INVENTORY.UI.DrawItemPlayer(baseX, baseY, i, data, type)
    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 and INVENTORY.UI.Player.ItemGrabIndex == i and type == "player" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end
    if INVENTORY.UI.Ground.ItemGrabIndex ~= 0 and INVENTORY.UI.Ground.ItemGrabIndex == i and type == "ground" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end

    if INVENTORY.UI.Other.ItemGrabIndex ~= 0 and INVENTORY.UI.Other.ItemGrabIndex == i and type == "other" then
        SetScriptGfxDrawOrder(8)
        local pos = (vector2(UI.GetControl().x, UI.GetControl().y) - vector2(w, h)/2.0)
        baseX, baseY = pos.x, pos.y
    end

    local sprite, iconDict, iconCustom = ItemIcons.Resolve(data.name)
    UI.DrawSpriteNew("inventory", "background_item", baseX, baseY, w, h , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        NoHover = false
    }, function(onSelected, onHovered)
        if onHovered then
            local x = UI.GetControl().x
            local y = UI.GetControl().y
            if type == "player" and IsControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 25)  then
                if not INVENTORY.UI.InteractItem.Maintain then
                    saveX, saveY = x, y
                    idSelected = i
                    INVENTORY.UI.InteractItem.Maintain = true
                else
                    INVENTORY.UI.InteractItem.Maintain = false
                end
            end
            if not INVENTORY.UI.InteractItem.Maintain and  INVENTORY.UI.Player.ItemGrabIndex == 0 and INVENTORY.UI.Ground.ItemGrabIndex == 0 and INVENTORY.UI.Other.ItemGrabIndex == 0 then
                INVENTORY.UI.InteractItem.Draw(x, y, data)
            end
        end


        if onSelected then
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Player.ItemGrabIndex == 0 and type == "player" then
                INVENTORY.UI.Player.ItemGrabIndex = i
            end
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Ground.ItemGrabIndex == 0 and type == "ground" then
                INVENTORY.UI.Ground.ItemGrabIndex = i
            end
            if not INVENTORY.UI.InteractItem.Maintain and INVENTORY.UI.Other.ItemGrabIndex == 0 and type == "other" then
                INVENTORY.UI.Other.ItemGrabIndex = i
            end
        end
    end)

    if INVENTORY.UI.InteractItem.Maintain and idSelected == i and type == "player" then
        INVENTORY.UI.InteractItem.DrawWithOption(saveX, saveY, data)
    end
    UI.DrawTexts(baseX + 0.002, baseY, tostring("x"..data.count), false, 0.2, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, 0, false, false)
    if sprite == "box" then
        local x,y = UI.CalculateCorrecteSizeForUI("ui_icon_item"..i..type, "inventory", "box", 70, 70)
        UI.DrawSpriteNew("inventory", "box", baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            centerDraw = true,
            NoHover = false
        }, function(onSelected, onHovered)

        end)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    elseif iconCustom then
        local x,y = UI.ConvertToPixel(70, 70)
        ItemIcons.Draw(iconDict, sprite, baseX + (w/2 ), baseY + h/2, x, y, INVENTORY.UI.Main.Alpha)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    else
        local x,y = UI.CalculateCorrecteSizeForUI("item_icon"..i..type, "item_icon", sprite, 70, 70)
        UI.DrawSpriteNew("item_icon", sprite, baseX + (w/2 ), baseY + h/2, x,y , 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            centerDraw = true,
            NoHover = false

        }, function(onSelected, onHovered)

        end)
        x, y = UI.ConvertToPixel(90, 2)
        UI.DrawRect( baseX, baseY + h - y, x, y, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {}, function ()

        end)
    end
    if INVENTORY.UI.Player.ItemGrabIndex ~= 0 and INVENTORY.UI.Player.ItemGrabIndex == i or INVENTORY.UI.Ground.ItemGrabIndex ~= 0 and INVENTORY.UI.Ground.ItemGrabIndex == i    then
        SetScriptGfxDrawOrder(7)
    end
    if  INVENTORY.UI.Other.ItemGrabIndex ~= 0 and INVENTORY.UI.Other.ItemGrabIndex == i then
        SetScriptGfxDrawOrder(7)

    end
end

function INVENTORY.Alpha()
    if not INVENTORY.Leave then
        INVENTORY.UI.Main.Alpha = UI.CalculateNextScalablePosition(255, INVENTORY.UI.Main.Alpha, 0.004)
        INVENTORY.UI.Main.AlphaBackground = UI.CalculateNextScalablePosition(150, INVENTORY.UI.Main.AlphaBackground, 0.010)
        INVENTORY.UI.Player.Alpha = UI.CalculateNextScalablePosition(255, INVENTORY.UI.Player.Alpha, 0.004)
        INVENTORY.UI.Ground.Alpha = UI.CalculateNextScalablePosition(255, INVENTORY.UI.Ground.Alpha, 0.004)
        INVENTORY.UI.Outfit.Alpha = UI.CalculateNextScalablePosition(255, INVENTORY.UI.Outfit.Alpha, 0.004)
        INVENTORY.UI.Other.Alpha = UI.CalculateNextScalablePosition(255, INVENTORY.UI.Outfit.Alpha, 0.004)
        INVENTORY.UI.Player.AlphaFilter = UI.CalculateNextScalablePosition(172, INVENTORY.UI.Player.AlphaFilter, 0.004)
        INVENTORY.UI.Ground.AlphaFilter = UI.CalculateNextScalablePosition(172, INVENTORY.UI.Ground.AlphaFilter, 0.004)
        INVENTORY.UI.Other.AlphaFilter = UI.CalculateNextScalablePosition(172, INVENTORY.UI.Ground.AlphaFilter, 0.004)
        INVENTORY.UI.Player.AlphaCrossBar = UI.CalculateNextScalablePosition(50, INVENTORY.UI.Ground.AlphaFilter, 0.004)
        INVENTORY.UI.Ground.AlphaCrossBar = UI.CalculateNextScalablePosition(50, INVENTORY.UI.Ground.AlphaFilter, 0.004)
        INVENTORY.UI.Other.AlphaCrossBar = UI.CalculateNextScalablePosition(50, INVENTORY.UI.Ground.AlphaFilter, 0.004)
    else
        INVENTORY.UI.Main.Alpha = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Main.Alpha, 0.008)
        INVENTORY.UI.Main.AlphaBackground = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Main.AlphaBackground, 0.010)
        INVENTORY.UI.Player.Alpha = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Player.Alpha, 0.008)
        INVENTORY.UI.Ground.Alpha = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.Alpha, 0.008)
        INVENTORY.UI.Outfit.Alpha = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Outfit.Alpha, 0.008)
        INVENTORY.UI.Other.Alpha = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Outfit.Alpha, 0.008)
        INVENTORY.UI.Player.AlphaFilter = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Player.AlphaFilter, 0.008)
        INVENTORY.UI.Ground.AlphaFilter = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.AlphaFilter, 0.008)
        INVENTORY.UI.Other.AlphaFilter = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.AlphaFilter, 0.008)
        INVENTORY.UI.Player.AlphaCrossBar = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.AlphaFilter, 0.008)
        INVENTORY.UI.Ground.AlphaCrossBar = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.AlphaFilter, 0.008)
        INVENTORY.UI.Other.AlphaCrossBar = UI.CalculateNextScalablePosition(0, INVENTORY.UI.Ground.AlphaFilter, 0.008)
    end

end

function INVENTORY.DiffNextMultiple(max)
    local reste = max % 5
    if reste == 0 then
        return 0
    else
        return 5 - reste
    end
end


function INVENTORY.GetStatusGrab()
    if IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) then
        if INVENTORY.UI.Player.ItemGrabIndex ~= 0 then
            if INVENTORY.UI.Player.FilterSelected ~= 1 then
                INVENTORY.UI.Player.ItemGrabData = INVENTORY.UI.Player.FilterData[INVENTORY.UI.Player.ItemGrabIndex]
            else
                INVENTORY.UI.Player.ItemGrabData = INVENTORY.Player[INVENTORY.UI.Player.ItemGrabIndex]

            end
        end

        if INVENTORY.UI.Ground.ItemGrabIndex ~= 0 then
            INVENTORY.UI.Ground.ItemGrabData = INVENTORY.Ground[INVENTORY.UI.Ground.ItemGrabIndex]
        end
        if INVENTORY.UI.Other.ItemGrabIndex ~= 0 then
            if INVENTORY.UI.Other.FilterSelected ~= 1 then
                INVENTORY.UI.Other.ItemGrabData = INVENTORY.UI.Other.FilterData[INVENTORY.UI.Other.ItemGrabIndex]
            else
                INVENTORY.UI.Other.ItemGrabData = INVENTORY.Other[INVENTORY.UI.Other.ItemGrabIndex]
            end
        end
    else
        INVENTORY.UI.Player.ItemGrabIndex = 0
        INVENTORY.UI.Ground.ItemGrabIndex = 0
        INVENTORY.UI.Other.ItemGrabIndex = 0
    end
end


RegisterNetEvent("inventory:client:updateItem", function (index, data)
    INVENTORY.Player[index] = data
end)

RegisterNetEvent("inventory:client:refresh", function ()
    ESX.PlayerData = ESX.GetPlayerData()
    INVENTORY.Player = {}
    INVENTORY.Player = ESX.PlayerData.inventory
    INVENTORY.UI.Player.CurrentWeight = INVENTORY.GetPlayerCurrentWeight()

    INVENTORY.UI.Player.FilterData = {}
    for key, value in pairs(INVENTORY.Player) do
        if not ConfigShared.Filter[5].item[string.upper(value.name)] and not ESX.IsContribWeapon(string.upper(value.name)) then
            table.insert(INVENTORY.UI.Player.FilterData, value)
        end
    end
    
    INVENTORY.UI.Player.FilterSelected = 1
    INVENTORY.UI.Player.Filter = "Rechercher"
    INVENTORY.UI.Player.FullText = ""
    INVENTORY.Player = INVENTORY.UI.Player.FilterData
end)

RegisterNetEvent("inventory:client:new", function (inv)
    ESX.PlayerData.inventory = inv
end)

RegisterNetEvent("inventory:client:refreshVehicleInv", function (inv)
    if inv ~= nil then 
        INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
        INVENTORY.Other = inv
    end
end)

RegisterNetEvent("inventory:client:refreshFouilleInv", function (inv)
    if inv ~= nil then 
        INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
        INVENTORY.Other = inv
    end
end)

RegisterNetEvent("inventory:client:refreshSocietyInv", function (inv)
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.Other = inv
end)

RegisterNetEvent("inventory:client:refreshPropertyInv", function (inv)
    if inv ~= nil then 
        INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
        INVENTORY.Other = inv
    end
end)

RegisterCommand("close", function ()
    INVENTORY.Clone()
end)

-- CreateThread(function()
--     while true do 
--         Wait(800)

--         if INVENTORY.UI and INVENTORY.UI.Player then 
--             if IsEntityDead(PlayerPedId()) and not INVENTORY.DEAD then 
--                 INVENTORY.DEAD = true
--                 INVENTORY.Close()
                
--             end
--             for i = 1, 5 do 
--                 local has = false

--                 for k, v in pairs(INVENTORY.Player) do 
--                     if INVENTORY.UI.Player.PinItem[i] ~= nil then 
--                         if INVENTORY.UI.Player.PinItem[i].name == v.name then 
--                             has = true
--                         end
--                     end        
--                 end
--                 if not has then 
--                     print(i, "remove")
--                     INVENTORY.UI.Player.PinItem[i] = nil
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('coffres:openCoffre')
AddEventHandler('coffres:openCoffre', function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    local myjob = ESX.PlayerData.job and ESX.PlayerData.job.name or nil

    if type(job) ~= "string" or job == "" then
        ESX.ShowNotification("~r~Coffre invalide.")
        return
    end

    if myjob and myjob == job then
        local society = string.gsub(myjob, "%s+", "")
        TriggerServerEvent("inventory:server:openSociety", society)
        return
    end

    local gangName = exports["sunlife_ui"]:GetMyGangName()
    if gangName and gangName ~= "" and gangName == job then
        local society = string.gsub(gangName, "%s+", "")
        TriggerServerEvent("inventory:server:openSociety", society)
        return
    end

    print("OPENCOFFRE job param =", job)
    print("MYJOB =", myjob)
    print("GANGNAME =", gangName)    

    ESX.ShowNotification("~r~Vous n'avez pas accès à ce coffre !")
end)