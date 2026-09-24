INVENTORY.UI.InteractItem = {}
local separatorX, separatorY = UI.ConvertToPixel(20, 158)
local _, intervalY = UI.ConvertToPixel(0, 9)
local _, separatorSliderY = UI.ConvertToPixel(0, 125)
local separatorSplitX, separatorSplitY = UI.ConvertToPixel(136, 93)
INVENTORY.UI.InteractItem.Count = nil
INVENTORY.UI.InteractItem.Maintain = false
INVENTORY.UI.InteractItem.Confirm = false
INVENTORY.UI.InteractItem.NeedConfirmCount = false
INVENTORY.UI.InteractItem.Data = {}
local canPress = false
INVENTORY.UI.InteractItem.InputActive = false
INVENTORY.UI.InteractItem.CountInput = 1
INVENTORY.UI.InteractItem.Filter = ""
lastDui = nil

local function KeyboardInput(prompt, defaultText, maxLength)
    AddTextEntry("FMMC_KEY_TIP8", prompt)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", defaultText or "", "", "", "", maxLength or 8)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

INVENTORY.UI.InteractItem.Cat = {
    {
        label = "Utiliser",
        action = function (data, count)
            -- Garde-fou : un Count bloque a 0 (champ quantite vide) renvoyait
            -- count=0 que le serveur rejette silencieusement (count < 1) -> plus
            -- aucun item utilisable jusqu'a re-saisir une quantite. On force >= 1.
            count = math.floor(tonumber(count) or 0)
            if count < 1 then count = 1 end
            local cant = false
            for key, value in pairs(ConfigShared.Outfit) do
                if data.name == value.itemName then 
                    cant = true 
                end
            end
            if cant then
                return
            end
            if data.name ~= "money" and data.name ~= "dirtymoney" and data.name ~= "outfit" and data.name ~= "identitycard" and data.name ~= "permisauto" and data.name ~= "permisweapon" 
            and data.name ~= "permispeche" and data.name ~= "permischasse" and data.name ~= "permispolice" and data.name ~= "permissheriff" and data.name ~= "permisems"
            and data.name ~= "permisbobcat" and data.name ~= "permislsfd" and data.name ~= "permisgouv"
            and data.name ~= "permisaircraft" and data.name ~= "permisbateau" and data.name ~= "carte_lasventuras" then
                TriggerServerEvent("inventaire:server:useItem", data.name, count, data.metadatas)
                INVENTORY.UI.InteractItem.Maintain = false
                return
            elseif data.name == "permisems" then
                if lastDui ~= nil then
                    DestroyDui(lastDui)
                    lastDui = nil
                end
                if INVENTORY.Permis.EmsOpen then
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = true
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.DataEms = data.metadatas.data
                    if data.metadatas.data.mugshot then 
                    -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataEms.textureDict = uniqueDictName
                        INVENTORY.Permis.DataEms.textureName = uniqueTextureName
                        -- DestroyDui(dui)
                    end
                end
                return
            elseif data.name == "permissheriff" then
                if lastDui ~= nil then
                    DestroyDui(lastDui)
                    lastDui = nil
                end
                if INVENTORY.Permis.BcsoOpen then
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = true
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.DataBcso = data.metadatas.data
                    if data.metadatas.data.mugshot then 
                    -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataBcso.textureDict = uniqueDictName
                        INVENTORY.Permis.DataBcso.textureName = uniqueTextureName
                        -- DestroyDui(dui)
                    end
                end
                return
               
            elseif data.name == "permispolice" then
                if lastDui ~= nil then
                    DestroyDui(lastDui)
                    lastDui = nil
                end
                if INVENTORY.Permis.LspdOpen then
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.LspdOpen = true
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.DataLspd = data.metadatas.data
                    if data.metadatas.data.mugshot then 
                    -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataLspd.textureDict = uniqueDictName
                        INVENTORY.Permis.DataLspd.textureName = uniqueTextureName
                        -- DestroyDui(dui)
                    end
                end
                return
               

            elseif data.name == "permisbobcat" or data.name == "permislsfd" or data.name == "permisgouv" then
                if lastDui ~= nil then
                    DestroyDui(lastDui)
                    lastDui = nil
                end

                local flag = (data.name == "permisbobcat" and "BobcatOpen")
                    or (data.name == "permislsfd" and "LsfdOpen") or "GouvOpen"
                local key = (data.name == "permisbobcat" and "DataBobcat")
                    or (data.name == "permislsfd" and "DataLsfd") or "DataGouv"

                INVENTORY.Permis.Open = false
                INVENTORY.Permis.OpenPermis = false
                INVENTORY.Permis.OpenWeapon = false
                INVENTORY.Permis.OpenChasse = false
                INVENTORY.Permis.OpenPeche = false
                INVENTORY.Permis.LspdOpen = false
                INVENTORY.Permis.BcsoOpen = false
                INVENTORY.Permis.EmsOpen = false

                if INVENTORY.Permis[flag] then
                    INVENTORY.Permis[flag] = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.BobcatOpen = false
                    INVENTORY.Permis.LsfdOpen = false
                    INVENTORY.Permis.GouvOpen = false
                    INVENTORY.Permis[flag] = true
                    INVENTORY.Permis[key] = data.metadatas.data

                    if data.metadatas.data.mugshot then
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        local txd = CreateRuntimeTxd(uniqueDictName)
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        INVENTORY.Permis[key].textureDict = uniqueDictName
                        INVENTORY.Permis[key].textureName = uniqueTextureName
                    end
                end
                return

            elseif data.name == "carte_lasventuras" then
                if INVENTORY.Permis.OpenLvId then
                    INVENTORY.Permis.OpenLvId = false
                    INVENTORY.Permis.DataLvId = {}
                else
                    INVENTORY.Permis.DataLvId = data.metadatas.data
                    INVENTORY.Permis.OpenLvId = true
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                end
                return
            elseif data.name == "identitycard" then
                if INVENTORY.Permis.Open then
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.BcsoOpen = false

                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.DataId = data.metadatas.data
                    -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    -- if closestDistance ~= -1 and closestDistance <= 3.0 then
                    
                    --     TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
                    -- else
                    --     ESX.ShowNotification("~r~Aucun joueur proche !")
                    -- end
                    
                    INVENTORY.Permis.Open = true
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.BcsoOpen = false

                    INVENTORY.Permis.DataId = data.metadatas.data
                    if data.metadatas.data.mugshot then 
                    -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataId.textureDict = uniqueDictName
                        INVENTORY.Permis.DataId.textureName = uniqueTextureName
                        -- DestroyDui(dui)
                    end
                end
                return
            elseif data.name == "permisauto" then
                if INVENTORY.Permis.OpenPermis then
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.OpenAircraft = false
                    INVENTORY.Permis.OpenBateau = false

                    INVENTORY.Permis.DataPermis = {}
                else
                    INVENTORY.Permis.DataPermis = data.metadatas.data

                    INVENTORY.Permis.DataPermis = data.metadatas.data
                    if data.metadatas.data.mugshot then 
                    -- S'assurer que 'data.name' est unique pour chaque DUI
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        -- Créer un nouveau TXD
                        local txd = CreateRuntimeTxd(uniqueDictName)
                        -- Créer un DUI et obtenir son handle
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                        INVENTORY.Permis.DataPermis.textureDict = uniqueDictName
                        INVENTORY.Permis.DataPermis.textureName = uniqueTextureName
                        -- DestroyDui(dui)
                    end

                    -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    -- if closestDistance ~= -1 and closestDistance <= 3.0 then
                      
                    --     TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
                    -- else
                    --     ESX.ShowNotification("~r~Aucun joueur proche !")
                    -- end
                    INVENTORY.Permis.OpenPermis = true
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.OpenAircraft = false
                    INVENTORY.Permis.OpenBateau = false

                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.Open = false
                end
                return
            elseif data.name == "permisaircraft" then
                if INVENTORY.Permis.OpenAircraft then
                    INVENTORY.Permis.OpenAircraft = false
                    INVENTORY.Permis.DataAircraft = {}
                else
                    INVENTORY.Permis.DataAircraft = data.metadatas.data or {}
                    INVENTORY.Permis.OpenAircraft = true
                    INVENTORY.Permis.OpenBateau  = false
                    INVENTORY.Permis.OpenPermis  = false
                    INVENTORY.Permis.OpenWeapon  = false
                    INVENTORY.Permis.OpenChasse  = false
                    INVENTORY.Permis.OpenPeche   = false
                    INVENTORY.Permis.LspdOpen    = false
                    INVENTORY.Permis.BcsoOpen    = false
                    INVENTORY.Permis.EmsOpen     = false
                    INVENTORY.Permis.Open        = false
                end
                return
            elseif data.name == "permisbateau" then
                if INVENTORY.Permis.OpenBateau then
                    INVENTORY.Permis.OpenBateau = false
                    INVENTORY.Permis.DataBateau = {}
                else
                    INVENTORY.Permis.DataBateau = data.metadatas.data or {}
                    INVENTORY.Permis.OpenBateau   = true
                    INVENTORY.Permis.OpenAircraft = false
                    INVENTORY.Permis.OpenPermis   = false
                    INVENTORY.Permis.OpenWeapon   = false
                    INVENTORY.Permis.OpenChasse   = false
                    INVENTORY.Permis.OpenPeche    = false
                    INVENTORY.Permis.LspdOpen     = false
                    INVENTORY.Permis.BcsoOpen     = false
                    INVENTORY.Permis.EmsOpen      = false
                    INVENTORY.Permis.Open         = false
                end
                return
            elseif data.name == "permisweapon" then
                if INVENTORY.Permis.OpenWeapon then
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.DataWeapon = {}
                else
                    INVENTORY.Permis.DataWeapon = data.metadatas.data
                    -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    -- if closestDistance ~= -1 and closestDistance <= 3.0 then
                      
                    --     TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataWeapon)
                    -- else
                    --     ESX.ShowNotification("~r~Aucun joueur proche !")
                    -- end
                    INVENTORY.Permis.OpenWeapon = true
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.Open = false
                end
                return
            elseif data.name == "permischasse" then
                if INVENTORY.Permis.OpenChasse then
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.DataWeapon = {}
                else
                    INVENTORY.Permis.DataWeapon = data.metadatas.data
                    -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					-- if closestDistance ~= -1 and closestDistance <= 3.0 then
                    --     TriggerServerEvent("inventory:server:identityCard", GetPlayerServerId(closestPlayer), data.metadatas, "peche")
                    -- end
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenChasse = true
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.Open = false
                end
                return
            elseif data.name == "permispeche" then
                if INVENTORY.Permis.OpenPeche then
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.OpenPeche = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.Open = false
                    INVENTORY.Permis.DataWeapon = {}
                else
                    INVENTORY.Permis.DataWeapon = data.metadatas.data
                    -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					-- if closestDistance ~= -1 and closestDistance <= 3.0 then
                    --     TriggerServerEvent("inventory:server:identityCard", GetPlayerServerId(closestPlayer), data.metadatas, "weapon")
                    -- end
                    INVENTORY.Permis.OpenWeapon = false
                    INVENTORY.Permis.OpenPermis = false
                    INVENTORY.Permis.OpenChasse = false
                    INVENTORY.Permis.LspdOpen = false
                    INVENTORY.Permis.EmsOpen = false
                    INVENTORY.Permis.BcsoOpen = false
                    INVENTORY.Permis.OpenPeche = true
                    INVENTORY.Permis.Open = false
                end
                return
            elseif data.name == "outfit" then 
                for type, value in pairs(data.metadatas.data) do
                    INVENTORY.ChangeClothOutfit(type, value)
                end
                INVENTORY.UI.Outfit.outfitEkip = true
                INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
                TriggerServerEvent("inventory:server:updateOutfit", INVENTORY.UI.Outfit.outfitEkipData)
                INVENTORY.Raccourci.PlayAnim("pants")
                TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                end)
                INVENTORY.UI.InteractItem.Maintain = false   
                INVENTORY.SyncOufit()
            end
        end
    },
    {
        label = "Donner",
        action = function(data, count)
            if not UI.GetActiveInput() then
                local input = KeyboardInput("ID du joueur", "", 6)
                local id = tonumber(input)
                if id and id ~= GetPlayerServerId(PlayerId()) then
                    local myPos = GetEntityCoords(PlayerPedId())
                    for _, playerId in ipairs(GetActivePlayers()) do
                        if GetPlayerServerId(playerId) == id then
                            local pPos = GetEntityCoords(GetPlayerPed(playerId))
                            if #(myPos - pPos) <= 5.0 then
                                ExecuteCommand(("me donne x%s %s"):format(tonumber(count), data.label))
                                TriggerServerEvent("inventaire:server:giveItem", id, data.name, count, data.metadatas)
                            end
                            break
                        end
                    end
                end
            end
        end
    },
    {
        label = "Renommer",
        action = function (data, count)
            if data.name ~= "money" and data.name ~= "dirtymoney" then
                if not UI.GetActiveInput() then
                    INVENTORY.UI.Other.InputActive = false
                    INVENTORY.UI.Ground.InputActive = false
                    INVENTORY.UI.Player.InputActive = false
                    INVENTORY.UI.Input.Filter = "Nouveau nom de l'item"
                    INVENTORY.UI.Input.FullText = ""
                    UI.ActivateDetectInput()
                    INVENTORY.UI.Input.InputActive = true
                    INVENTORY.UI.Input.Number = false

                    CreateThread(function ()
                        while INVENTORY.UI.Input.InputActive do Wait(100) end
                        -- local name = INVENTORY.InputString("Nouveau nom")
                        local name = INVENTORY.UI.Input.FullText
                        if name and name ~= "Nouveau nom de l'item" and string.match(name, "%a") and not string.match(name, "^%s*$") then
                            TriggerServerEvent("inventaire:server:newName", name, data.name, data.metadatas)
                        end
                    end)
                    INVENTORY.UI.InteractItem.Maintain = false   
                end
            end
        end
    },
    {
        label = "Jeter",
        action = function (data, count)
            ExecuteCommand("e c")
            Citizen.Wait(100)
            ExecuteCommand("e pickup")
            ExecuteCommand("me pose x"..count.." "..data.label)
            if IsPedInAnyVehicle(PlayerPedId(), false) or IsPedInAnyVehicle(PlayerPedId(), true) then
            else
                TriggerServerEvent("inventory:server:dropItem", data.name, count, data.metadatas)
            end
            INVENTORY.UI.InteractItem.Maintain = false   
        end
    },
}

function INVENTORY.UI.InteractItem.Draw(baseX, baseY, data)
    baseX, baseY = baseX + 0.005, baseY + 0.005
    SetScriptGfxDrawOrder(8)
    local w, h = UI.ConvertToPixel(219,100.6)

    UI.DrawSpriteNew("inventory", "background_interact", baseX, baseY, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    local _cnt = tonumber(INVENTORY.UI.InteractItem.Count)
    -- On remet une quantite valide si elle est nil, trop haute, ou < 1 alors
    -- qu'on n'est PAS en train de taber (sinon impossible de vider le champ
    -- pour saisir une nouvelle valeur). Sans le garde "< 1", un Count bloque a
    -- 0 faisait silencieusement echouer Utiliser/Donner/Jeter sur tous les items.
    if _cnt == nil or _cnt > data.count
        or (not INVENTORY.UI.InteractItem.InputActive and _cnt < 1) then
        if data.count <= 1 then 
            INVENTORY.UI.InteractItem.Count = 1

        else
            INVENTORY.UI.InteractItem.Count = math.floor(data.count /2)
        end
    end
    ---Nom Item
    if next(data.metadatas) and data.metadatas.rename ~= nil then
        UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.metadatas.rename , false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    else
        UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.label, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    end

    --COunt

    local w2, h2 = UI.ConvertToPixel(14, 14)


    w, h = UI.ConvertToPixel(63, 21)
    local newWidth = INVENTORY.MeasureStringWidth(INVENTORY.Comma_value(data.count), 0, 0.24)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + 0.03, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + 0.034, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)
    UI.DrawTexts(baseX + w2 + 0.009, baseY + 0.03, ""..INVENTORY.Comma_value(tostring(data.count)), false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    --Serial

    if data.metadatas.id ~= nil then
        local w2, h2 = UI.ConvertToPixel(14, 14)

        w, h = UI.ConvertToPixel(63, 21)
        local newWidth = INVENTORY.MeasureStringWidth(INVENTORY.Comma_value(data.metadatas.id), 0, 0.24)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.029, baseY + 0.03, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)

        UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + 0.034, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)
        UI.DrawTexts(baseX + w2 + 0.029, baseY + 0.03, "#"..data.metadatas.id, false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    end

    --Weight
    local w2, h2 = UI.ConvertToPixel(14, 14)

    w, h = UI.ConvertToPixel(63, 23)
    local newWidth = INVENTORY.MeasureStringWidth(data.weight.."kg", 0, 0.24)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + h + 0.035, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    UI.DrawSpriteNew("inventory", "weight_icon", baseX + 0.008, baseY + h + 0.037, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)
    UI.DrawTexts(baseX + w2 + 0.01, baseY + h + 0.035, ""..data.weight.."kg", false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    SetScriptGfxDrawOrder(7)
end

function INVENTORY.UI.InteractItem.DrawWithOption(baseX, baseY, data)
    baseX, baseY = baseX + 0.005, baseY + 0.005
    --TODO: Mettre detection de ma position souris tu connais le S le J c'est Le S
    SetScriptGfxDrawOrder(8)
    local w, h = UI.ConvertToPixel(219,306.6)
    if #INVENTORY.UI.InteractItem.Cat == 5 then
        w, h  = UI.ConvertToPixel(219,345.6)
    end
    if baseY + h   > 1.0 then
        baseY = 1.0 - h
    end
    UI.DrawSpriteNew("inventory", "background_interact", baseX, baseY, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    local _cnt = tonumber(INVENTORY.UI.InteractItem.Count)
    -- On remet une quantite valide si elle est nil, trop haute, ou < 1 alors
    -- qu'on n'est PAS en train de taber (sinon impossible de vider le champ
    -- pour saisir une nouvelle valeur). Sans le garde "< 1", un Count bloque a
    -- 0 faisait silencieusement echouer Utiliser/Donner/Jeter sur tous les items.
    if _cnt == nil or _cnt > data.count
        or (not INVENTORY.UI.InteractItem.InputActive and _cnt < 1) then
        if data.count <= 1 then 
            INVENTORY.UI.InteractItem.Count = 1

        else
            INVENTORY.UI.InteractItem.Count = math.floor(data.count /2)
        end
    end
    
    ---Nom Item
    if next(data.metadatas) and data.metadatas.rename ~= nil then
        UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.metadatas.rename, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    else
        UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.label, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    end

    --COunt

    local w2, h2 = UI.ConvertToPixel(14, 14)


    w, h = UI.ConvertToPixel(63, 21)
    local newWidth = INVENTORY.MeasureStringWidth(INVENTORY.Comma_value(data.count), 0, 0.24)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + 0.03, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + 0.034, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)
    UI.DrawTexts(baseX + w2 + 0.009, baseY + 0.03, ""..INVENTORY.Comma_value(data.count), false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    --Serial

    if data.metadatas.id ~= nil then
        local w2, h2 = UI.ConvertToPixel(14, 14)

        w, h = UI.ConvertToPixel(63, 21)
        local newWidth = INVENTORY.MeasureStringWidth(INVENTORY.Comma_value(data.metadatas.id), 0, 0.24)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.029, baseY + 0.03, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)

        UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + 0.034, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)
        UI.DrawTexts(baseX + w2 + 0.029, baseY + 0.03, "#"..data.metadatas.id, false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
    end

    --Weight
    local w2, h2 = UI.ConvertToPixel(14, 14)


    w, h = UI.ConvertToPixel(63, 23)
    local newWidth = INVENTORY.MeasureStringWidth(data.weight.."kg", 0, 0.24)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + h + 0.035, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)

    UI.DrawSpriteNew("inventory", "weight_icon", baseX + 0.008, baseY + h + 0.037, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)
    UI.DrawTexts(baseX + w2 + 0.01, baseY + h + 0.035, ""..data.weight.."kg", false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    --SPLIT
    local letter = nil
    if INVENTORY.UI.InteractItem.InputActive and UI.GetActiveInput() then
        letter = UI.ReturnLetter()
    end

    if INVENTORY.UI.InteractItem.InputActive and UI.GetActiveInput() and json.encode(letter) == json.encode("\r")  or IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
        if canPress then 
            UI.DeactivateDetectInput()
            INVENTORY.UI.InteractItem.InputActive  = false
            canPress = false
            letter = nil
        end
    end
    if INVENTORY.UI.InteractItem.InputActive and letter ~= nil and tonumber(letter) then
        if tonumber(INVENTORY.UI.InteractItem.Count == 0) then 
            INVENTORY.UI.InteractItem.Count = tonumber(INVENTORY.UI.InteractItem.Count)
        else
            INVENTORY.UI.InteractItem.Count = tonumber(INVENTORY.UI.InteractItem.Count .. letter)
        end
    end
    local w2, h2 = UI.ConvertToPixel(14, 14)    
    w, h = UI.ConvertToPixel(63, 23)
    if INVENTORY.UI.InteractItem.Count == 0 then 
    end
    local newWidth = INVENTORY.MeasureStringWidth(tostring(INVENTORY.UI.InteractItem.Count), 0, 0.24)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.008 - 0.002 , baseY + separatorSplitY - 0.0005, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = false,
        NoSelect = false,
    }, function (onSelected, onHovered) 
        if onSelected then
            if not UI.GetActiveInput() then
                INVENTORY.UI.InteractItem.Count = 0
                INVENTORY.UI.InteractItem.Filter = ""
                INVENTORY.UI.Other.InputActive = false
                INVENTORY.UI.Ground.InputActive = false
                INVENTORY.UI.Player.InputActive = false
                INVENTORY.UI.InteractItem.InputActive = true

                UI.ActivateDetectInput()
                CreateThread(function ()
                    Wait(500)
                    canPress = true
                end)
            end
        end
    end)
    

    w, h = UI.ConvertToPixel(16, 16)
    UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + separatorSplitY+ 0.003, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = true,
        NoSelect = true,
    }, function (onSelected, onHovered)

    end)
    UI.DrawTexts(baseX + separatorX + w - 0.002, baseY + separatorSplitY  , ""..INVENTORY.Comma_value(INVENTORY.UI.InteractItem.Count), false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    w, h = UI.ConvertToPixel(68, 20)
    UI.DrawSpriteNew("inventory", "btn_normal", baseX + separatorSplitX, baseY + separatorSplitY, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
        devmod = false,
        NoHover = false,
        NoSelect = false,
        CustomHoverTexture = {"inventory", "btn_hovered", nil, nil, {255, 106, 0}}

    }, function (onSelected, onHovered)
        if onSelected then
            INVENTORY.UI.InteractItem.Count = math.floor(data.count/2)
        end

    end)
    UI.DrawTexts(baseX + separatorSplitX + w/2, baseY + separatorSplitY , "Séparer", true, 0.20, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

    

    --Slider 
    w, h = UI.ConvertToPixel(183, 10)
    UI.DrawSlider("amount", baseX + separatorX, baseY + separatorSliderY, w, h, {0, 0, 0, 50}, {255, 106, 0, INVENTORY.UI.Main.Alpha}, tonumber(INVENTORY.UI.InteractItem.Count), data.count, {
        noHover = false
    }, function (valueUpdated, newValue)
        if valueUpdated then
            INVENTORY.UI.InteractItem.Count = math.floor(newValue)
        end
    end)
    INVENTORY.UI.InteractItem.HandleBackspaceInput()
    ----button

    w, h = UI.ConvertToPixel(183, 27)
    local i = 0
    if data.name == "identitycard" or data.name == "permisauto" or data.name == "permisweapon" or data.name == "permischasse" or data.name == "permisems" or data.name == "permispeche" or data.name == "permispolice" or data.name == "permissheriff" or data.name == "permisbobcat" or data.name == "permislsfd" or data.name == "permisgouv" or data.name == "cahier" or data.name == "permisaircraft" or data.name == "permisbateau" or data.name == "carte_lasventuras" then
        if INVENTORY.UI.InteractItem.Cat[5] == nil then 
            INVENTORY.UI.InteractItem.Cat[5] = INVENTORY.UI.InteractItem.Cat[4]

            INVENTORY.UI.InteractItem.Cat[4] = INVENTORY.UI.InteractItem.Cat[3]

            INVENTORY.UI.InteractItem.Cat[3] = INVENTORY.UI.InteractItem.Cat[2]
            INVENTORY.UI.InteractItem.Cat[2] =  {
                label = "Montrer",
                action = function (data, count)
                    if data.name == "cahier" then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent("cahier:showToNearest",
                                GetPlayerServerId(closestPlayer),
                                data.metadatas and data.metadatas.id or nil
                            )
                        else
                            ESX.ShowNotification("~r~Aucun joueur proche !")
                        end
                        INVENTORY.UI.InteractItem.Maintain = false
                        return
                    end

                    local cant = false
                    for key, value in pairs(ConfigShared.Outfit) do
                        if data.name == value.itemName then 
                            cant = true 
                        end
                    end
                    if cant then
                        return
                    end
                    if data.name ~= "money" and data.name ~= "dirtymoney" and data.name ~= "outfit" and data.name ~= "identitycard" and data.name ~= "permisauto" and data.name ~= "permisweapon" 
                    and data.name ~= "permispeche" and data.name ~= "permischasse" and data.name ~= "permispolice" and data.name ~= "permissheriff" and data.name ~= "permisems" and data.name ~= "cahier"
                    and data.name ~= "permisbobcat" and data.name ~= "permislsfd" and data.name ~= "permisgouv"
                    and data.name ~= "permisaircraft" and data.name ~= "permisbateau" and data.name ~= "carte_lasventuras" then
                        TriggerServerEvent("inventaire:server:useItem", data.name, count, data.metadatas)
                        INVENTORY.UI.InteractItem.Maintain = false
                        return
                    elseif data.name == "permisems" then
                        if lastDui ~= nil then
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        if INVENTORY.Permis.EmsOpen then
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.DataId = {}
                        else
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = true
                            INVENTORY.Permis.DataEms = data.metadatas.data
                            if data.metadatas.data.mugshot then 
                            -- S'assurer que 'data.name' est unique pour chaque DUI
                                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname
        
                                -- Créer un nouveau TXD
                                local txd = CreateRuntimeTxd(uniqueDictName)
                                -- Créer un DUI et obtenir son handle
                                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                                lastDui = dui
                                local duiHandle = GetDuiHandle(dui)
                                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
        
                                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                                INVENTORY.Permis.DataEms.textureDict = uniqueDictName
                                INVENTORY.Permis.DataEms.textureName = uniqueTextureName
                                -- DestroyDui(dui)
                            end
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                            
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataEms)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                        end
                        return
                    elseif data.name == "permissheriff" then
                        if lastDui ~= nil then
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        if INVENTORY.Permis.BcsoOpen then
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.DataId = {}
                        else
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.BcsoOpen = true
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.DataBcso = data.metadatas.data
                            if data.metadatas.data.mugshot then 
                            -- S'assurer que 'data.name' est unique pour chaque DUI
                                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname
        
                                -- Créer un nouveau TXD
                                local txd = CreateRuntimeTxd(uniqueDictName)
                                -- Créer un DUI et obtenir son handle
                                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                                lastDui = dui
                                local duiHandle = GetDuiHandle(dui)
                                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
        
                                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                                INVENTORY.Permis.DataBcso.textureDict = uniqueDictName
                                INVENTORY.Permis.DataBcso.textureName = uniqueTextureName
                                -- DestroyDui(dui)
                            end
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                            
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataBcso)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                        end
                        return

                    elseif data.name == "permispolice" then
                        if lastDui ~= nil then
                            DestroyDui(lastDui)
                            lastDui = nil
                        end
                        if INVENTORY.Permis.LspdOpen then
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.DataId = {}
                        else
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.LspdOpen = true
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.DataLspd = data.metadatas.data
                            if data.metadatas.data.mugshot then 
                            -- S'assurer que 'data.name' est unique pour chaque DUI
                                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname
        
                                -- Créer un nouveau TXD
                                local txd = CreateRuntimeTxd(uniqueDictName)
                                -- Créer un DUI et obtenir son handle
                                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                                lastDui = dui
                                local duiHandle = GetDuiHandle(dui)
                                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)
        
                                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                                INVENTORY.Permis.DataLspd.textureDict = uniqueDictName
                                INVENTORY.Permis.DataLspd.textureName = uniqueTextureName
                                -- DestroyDui(dui)
                            end
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                            
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataLspd)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                        end
                        return
                    elseif data.name == "identitycard" then
                        if INVENTORY.Permis.Open then
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.DataId = {}
                        else
                            INVENTORY.Permis.DataId = data.metadatas.data
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                            
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.Open = true
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.OpenPeche = false
                        end
                        return
                    elseif data.name == "permisbobcat" or data.name == "permislsfd" or data.name == "permisgouv" then
                if lastDui ~= nil then
                    DestroyDui(lastDui)
                    lastDui = nil
                end

                local flag = (data.name == "permisbobcat" and "BobcatOpen")
                    or (data.name == "permislsfd" and "LsfdOpen") or "GouvOpen"
                local key = (data.name == "permisbobcat" and "DataBobcat")
                    or (data.name == "permislsfd" and "DataLsfd") or "DataGouv"

                INVENTORY.Permis.Open = false
                INVENTORY.Permis.OpenPermis = false
                INVENTORY.Permis.OpenWeapon = false
                INVENTORY.Permis.OpenChasse = false
                INVENTORY.Permis.OpenPeche = false
                INVENTORY.Permis.LspdOpen = false
                INVENTORY.Permis.BcsoOpen = false
                INVENTORY.Permis.EmsOpen = false

                if INVENTORY.Permis[flag] then
                    INVENTORY.Permis[flag] = false
                    INVENTORY.Permis.DataId = {}
                else
                    INVENTORY.Permis.BobcatOpen = false
                    INVENTORY.Permis.LsfdOpen = false
                    INVENTORY.Permis.GouvOpen = false
                    INVENTORY.Permis[flag] = true
                    INVENTORY.Permis[key] = data.metadatas.data

                    if data.metadatas.data.mugshot then
                        local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                        local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                        local txd = CreateRuntimeTxd(uniqueDictName)
                        local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                        lastDui = dui
                        local duiHandle = GetDuiHandle(dui)
                        CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                        INVENTORY.Permis[key].textureDict = uniqueDictName
                        INVENTORY.Permis[key].textureName = uniqueTextureName
                    end

                    -- Presentation au joueur le plus proche.
                    --
                    -- Ce bloc manquait : sous l'action "Montrer", les badges
                    -- Bobcat / LSFD / Gouvernement s'affichaient uniquement sur
                    -- l'ecran de leur porteur, la ou TOUTES les autres cartes de
                    -- cette meme action declenchent 'jsfour-idcard:open' (carte
                    -- d'identite, Las Venturas, permis police/sheriff/ems, auto,
                    -- avion, bateau, port d'arme). D'ou "je montre mon badge et
                    -- les autres ne le voient pas".
                    --
                    -- Le chemin barre rapide (client/pages/raccourci.lua) le
                    -- faisait deja : le badge marchait ou non selon que le joueur
                    -- passait par le raccourci ou par l'inventaire, ce qui rendait
                    -- le bug intermittent a l'usage.
                    --
                    -- Cote reception, rien a faire : le handler
                    -- 'jsfour-idcard:open' de client/pages/_main.lua sait deja
                    -- rendre ces trois badges.
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis[key])
                    else
                        ESX.ShowNotification("~r~Aucun joueur proche !")
                    end
                end
                return

            elseif data.name == "carte_lasventuras" then
                        if INVENTORY.Permis.OpenLvId then
                            INVENTORY.Permis.OpenLvId = false
                            INVENTORY.Permis.DataLvId = {}
                        else
                            INVENTORY.Permis.DataLvId = data.metadatas.data
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataLvId)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.OpenLvId = true
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.OpenPeche = false
                        end
                        return
                    elseif data.name == "permisauto" then
                        if INVENTORY.Permis.OpenPermis then
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.OpenAircraft = false
                            INVENTORY.Permis.OpenBateau = false
                            INVENTORY.Permis.DataPermis = {}
                        else
                            INVENTORY.Permis.DataPermis = data.metadatas.data
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                              
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.OpenPermis = true
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenAircraft = false
                            INVENTORY.Permis.OpenBateau = false
                            INVENTORY.Permis.Open = false
                        end
                        return
                    elseif data.name == "permisaircraft" then
                        if INVENTORY.Permis.OpenAircraft then
                            INVENTORY.Permis.OpenAircraft = false
                            INVENTORY.Permis.DataAircraft = {}
                        else
                            INVENTORY.Permis.DataAircraft = data.metadatas.data or {}
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataAircraft)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.OpenAircraft = true
                            INVENTORY.Permis.OpenBateau  = false
                            INVENTORY.Permis.OpenPermis  = false
                            INVENTORY.Permis.OpenWeapon  = false
                            INVENTORY.Permis.OpenChasse  = false
                            INVENTORY.Permis.OpenPeche   = false
                            INVENTORY.Permis.LspdOpen    = false
                            INVENTORY.Permis.BcsoOpen    = false
                            INVENTORY.Permis.EmsOpen     = false
                            INVENTORY.Permis.Open        = false
                        end
                        return
                    elseif data.name == "permisbateau" then
                        if INVENTORY.Permis.OpenBateau then
                            INVENTORY.Permis.OpenBateau = false
                            INVENTORY.Permis.DataBateau = {}
                        else
                            INVENTORY.Permis.DataBateau = data.metadatas.data or {}
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataBateau)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.OpenBateau   = true
                            INVENTORY.Permis.OpenAircraft = false
                            INVENTORY.Permis.OpenPermis   = false
                            INVENTORY.Permis.OpenWeapon   = false
                            INVENTORY.Permis.OpenChasse   = false
                            INVENTORY.Permis.OpenPeche    = false
                            INVENTORY.Permis.LspdOpen     = false
                            INVENTORY.Permis.BcsoOpen     = false
                            INVENTORY.Permis.EmsOpen      = false
                            INVENTORY.Permis.Open         = false
                        end
                        return
                    elseif data.name == "permisweapon" then
                        if INVENTORY.Permis.OpenWeapon then
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.DataWeapon = {}
                        else
                            INVENTORY.Permis.DataWeapon = data.metadatas.data
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                              
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataWeapon)
                            else
                                ESX.ShowNotification("~r~Aucun joueur proche !")
                            end
                            INVENTORY.Permis.OpenWeapon = true
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.Open = false
                        end
                        return
                    elseif data.name == "permischasse" then
                        if INVENTORY.Permis.OpenChasse then
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.DataWeapon = {}
                        else
                            INVENTORY.Permis.DataWeapon = data.metadatas.data
                            -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            -- if closestDistance ~= -1 and closestDistance <= 3.0 then
                            --     TriggerServerEvent("inventory:server:identityCard", GetPlayerServerId(closestPlayer), data.metadatas, "peche")
                            -- end
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenChasse = true
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.Open = false
                        end
                        return
                    elseif data.name == "permispeche" then
                        if INVENTORY.Permis.OpenPeche then
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.OpenPeche = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.Open = false
                            INVENTORY.Permis.DataWeapon = {}
                        else
                            INVENTORY.Permis.DataWeapon = data.metadatas.data
                            -- local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            -- if closestDistance ~= -1 and closestDistance <= 3.0 then
                            --     TriggerServerEvent("inventory:server:identityCard", GetPlayerServerId(closestPlayer), data.metadatas, "weapon")
                            -- end
                            INVENTORY.Permis.OpenWeapon = false
                            INVENTORY.Permis.OpenPermis = false
                            INVENTORY.Permis.OpenChasse = false
                            INVENTORY.Permis.OpenPeche = true
                            INVENTORY.Permis.BcsoOpen = false
                            INVENTORY.Permis.EmsOpen = false
                            INVENTORY.Permis.LspdOpen = false
                            INVENTORY.Permis.Open = false
                        end
                        return
                    elseif data.name == "outfit" then 
                        for type, value in pairs(data.metadatas.data) do
                            INVENTORY.ChangeClothOutfit(type, value)
                        end
                        INVENTORY.UI.Outfit.outfitEkip = true
                        INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
                        TriggerServerEvent("inventory:server:updateOutfit", INVENTORY.UI.Outfit.outfitEkipData)
                        INVENTORY.Raccourci.PlayAnim("pants")
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                        end)
                        INVENTORY.UI.InteractItem.Maintain = false   
                        INVENTORY.SyncOufit()
                    end
                end
            }
        end
    else
        if INVENTORY.UI.InteractItem.Cat[5] ~= nil then 
            INVENTORY.UI.InteractItem.Cat[2] = INVENTORY.UI.InteractItem.Cat[3]

            INVENTORY.UI.InteractItem.Cat[3] = INVENTORY.UI.InteractItem.Cat[4]
            INVENTORY.UI.InteractItem.Cat[4] = INVENTORY.UI.InteractItem.Cat[5]

            INVENTORY.UI.InteractItem.Cat[5] = nil
        end
    end
    for key, value in pairs(INVENTORY.UI.InteractItem.Cat) do
        local hover = false
        -- if data.name ~= "money" and data.name ~= "dirtymoney" then 
            UI.DrawSpriteNew("inventory", "btn_normal", baseX + separatorX, (baseY + separatorY ) + ((intervalY + h) * i), w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
                devmod = false,
                NoHover = false,
                NoSelect = false,
                CustomHoverTexture = {"inventory", "btn_hovered", nil, nil, {255, 106, 0}}
            }, function (onSelected, onHovered)
                if onHovered then
                end
                if onSelected then
                    value.action(data, INVENTORY.UI.InteractItem.Count)
                end
            end)
            local zeub = value.label
            if data.name == "identitycard" or data.name == "permisauto" or data.name == "permisweapon" or data.name == "permisems" or data.name == "permischasse" or data.name == "permispeche" or data.name == "permispolice" or data.name == "permissheriff" or data.name == "permisbobcat" or data.name == "permislsfd" or data.name == "permisgouv" or data.name == "permisaircraft" or data.name == "permisbateau" or data.name == "carte_lasventuras" then
                if value.label == "Utiliser" then
                    zeub = "Regarder"
                end
            end
            UI.DrawTexts(baseX + separatorX + w/2, (baseY + separatorY + 0.002) + ((intervalY + h) * i), zeub, true, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
        -- end
        i = i + 1
    end
    SetScriptGfxDrawOrder(7)
end
local isBackspaceHeld = false
local backspaceHeldTime = 0
local repeatThreshold = 0.5
local repeatRate = 0.1

function INVENTORY.UI.InteractItem.HandleBackspaceInput()
    if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
        INVENTORY.UI.InteractItem.RemoveLastCharacter()
        isBackspaceHeld = true
        backspaceHeldTime = GetGameTimer()
    elseif (IsDisabledControlPressed(0, 194) or IsControlPressed(0, 194)) and isBackspaceHeld then
        if (GetGameTimer() - backspaceHeldTime) > (repeatThreshold * 1000) then
            if (GetGameTimer() - backspaceHeldTime) % (repeatRate * 1000) < 50 then
                INVENTORY.UI.InteractItem.RemoveLastCharacter()
            end
        end
    else
        isBackspaceHeld = false
        backspaceHeldTime = 0
    end
end

local w, h = UI.ConvertToPixel(231, 33)

local maxTextWidth = w - 0.025

function INVENTORY.UI.InteractItem.RemoveLastCharacter()
    if string.len(INVENTORY.UI.InteractItem.Count) > 0 then
        INVENTORY.UI.InteractItem.Count = string.sub(INVENTORY.UI.InteractItem.Count, 1, -2)

        local textWidth = INVENTORY.MeasureStringWidth(INVENTORY.UI.InteractItem.Count, 0, 0.25)
        if textWidth > maxTextWidth then
            local startIdx = 1
            while textWidth > maxTextWidth and startIdx < string.len(INVENTORY.UI.InteractItem.Count) do
                startIdx = startIdx + 1
                textWidth = INVENTORY.MeasureStringWidth(string.sub(INVENTORY.UI.InteractItem.Count, startIdx), 0, 0.25)
            end
            INVENTORY.UI.InteractItem.Filter = string.sub(INVENTORY.UI.InteractItem.Count, startIdx)
        else
            INVENTORY.UI.InteractItem.Filter = INVENTORY.UI.InteractItem.Count
        end
        if string.len(INVENTORY.UI.InteractItem.Count) == 0 then 
            INVENTORY.UI.InteractItem.Count = 0
        end
    else
        INVENTORY.UI.InteractItem.Count = 0
    end
end



function INVENTORY.UI.InteractItem.DrawChoice(data)
    SetScriptGfxDrawOrder(8)
    if data ~= nil and data.count ~= nil then 
        local w, h = UI.ConvertToPixel(219,240.6)
        local baseX, baseY = 0.5 -w/2 , 0.5 - h/2
        UI.DrawSpriteNew("inventory", "background_interact", baseX, baseY, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)

        local _cntIn = tonumber(INVENTORY.UI.InteractItem.CountInput)
        if _cntIn == nil or _cntIn > data.count
            or (not INVENTORY.UI.InteractItem.InputActive and _cntIn < 1) then
            if data.count <= 1 then 
                INVENTORY.UI.InteractItem.CountInput = 1

            else
                INVENTORY.UI.InteractItem.CountInput = math.floor(data.count /2)
            end
        end
        
        ---Nom Item
        if next(data.metadatas) and data.metadatas.rename ~= nil then
            UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.metadatas.rename, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
        else
            UI.DrawTexts(baseX + 0.005, baseY + 0.005, data.label, false, 0.25, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)
        end

        --COunt

        local w2, h2 = UI.ConvertToPixel(14, 14)


        w, h = UI.ConvertToPixel(63, 21)
        local newWidth = INVENTORY.MeasureStringWidth(INVENTORY.Comma_value(data.count), 0, 0.24)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + 0.03, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)

        UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + 0.034, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)
        UI.DrawTexts(baseX + w2 + 0.009, baseY + 0.03, ""..INVENTORY.Comma_value(data.count), false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)


        --Weight
        local w2, h2 = UI.ConvertToPixel(14, 14)


        w, h = UI.ConvertToPixel(63, 23)
        local newWidth = INVENTORY.MeasureStringWidth(data.weight.."kg", 0, 0.24)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.006, baseY + h + 0.035, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)

        UI.DrawSpriteNew("inventory", "weight_icon", baseX + 0.008, baseY + h + 0.037, w2, h2, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)
        UI.DrawTexts(baseX + w2 + 0.01, baseY + h + 0.035, ""..data.weight.."kg", false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

        --SPLIT
        local letter = nil
        if INVENTORY.UI.InteractItem.InputActive and UI.GetActiveInput() then
            letter = UI.ReturnLetter()
        end

        if INVENTORY.UI.InteractItem.InputActive and UI.GetActiveInput() and json.encode(letter) == json.encode("\r")  or IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
            if canPress then 
                UI.DeactivateDetectInput()
                INVENTORY.UI.InteractItem.InputActive  = false
                canPress = false
                letter = nil
            end
        end
        if INVENTORY.UI.InteractItem.InputActive and letter ~= nil and tonumber(letter) then
            if tonumber(INVENTORY.UI.InteractItem.CountInput == 0) then 
                INVENTORY.UI.InteractItem.CountInput = tonumber(INVENTORY.UI.InteractItem.CountInput)
            else
                INVENTORY.UI.InteractItem.CountInput = tonumber(INVENTORY.UI.InteractItem.CountInput .. letter)
            end
        end
        local w2, h2 = UI.ConvertToPixel(14, 14)    
        w, h = UI.ConvertToPixel(63, 23)
        if INVENTORY.UI.InteractItem.CountInput == 0 then 
        end
        local newWidth = INVENTORY.MeasureStringWidth(tostring(INVENTORY.UI.InteractItem.CountInput), 0, 0.24)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + 0.008 - 0.002 , baseY + separatorSplitY - 0.0005, newWidth + w2 + 0.005, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = false,
            NoSelect = false,
        }, function (onSelected, onHovered) 
            if onSelected then
                if not UI.GetActiveInput() then
                    INVENTORY.UI.InteractItem.CountInput = 0
                    INVENTORY.UI.InteractItem.Filter = ""
                    INVENTORY.UI.Other.InputActive = false
                    INVENTORY.UI.Ground.InputActive = false
                    INVENTORY.UI.Player.InputActive = false
                    INVENTORY.UI.InteractItem.InputActive = true

                    UI.ActivateDetectInput()
                    CreateThread(function ()
                        Wait(500)
                        canPress = true
                    end)
                end
            end
        end)
        

        w, h = UI.ConvertToPixel(16, 16)
        UI.DrawSpriteNew("inventory", "count_icon", baseX + 0.008, baseY + separatorSplitY+ 0.003, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = true,
            NoSelect = true,
        }, function (onSelected, onHovered)

        end)
        UI.DrawTexts(baseX + separatorX + w - 0.002, baseY + separatorSplitY  , ""..INVENTORY.Comma_value(INVENTORY.UI.InteractItem.CountInput), false, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

        w, h = UI.ConvertToPixel(68, 20)
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + separatorSplitX, baseY + separatorSplitY, w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = false,
            NoSelect = false,
            CustomHoverTexture = {"inventory", "btn_hovered", nil, nil, {255, 106, 0}}

        }, function (onSelected, onHovered)
            if onSelected then
                INVENTORY.UI.InteractItem.CountInput = math.floor(data.count/2)
            end

        end)
        UI.DrawTexts(baseX + separatorSplitX + w/2, baseY + separatorSplitY , "Séparer", true, 0.20, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)

        

        --Slider 
        w, h = UI.ConvertToPixel(183, 10)
        UI.DrawSlider("amount", baseX + separatorX, baseY + separatorSliderY, w, h, {0, 0, 0, 50}, {255, 106, 0, INVENTORY.UI.Main.Alpha}, tonumber(INVENTORY.UI.InteractItem.CountInput), data.count, {
            noHover = false
        }, function (valueUpdated, newValue)
            if valueUpdated then
                INVENTORY.UI.InteractItem.CountInput = math.floor(newValue)
            end
        end)
        INVENTORY.UI.InteractItem.HandleBackspaceInput()

        w, h = UI.ConvertToPixel(183, 27)
        local i = 0
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + separatorX, (baseY + separatorY ) + ((intervalY + h) * i), w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = false,
            NoSelect = false,
            CustomHoverTexture = {"inventory", "btn_hovered", nil, nil, {255, 106, 0}}
        }, function (onSelected, onHovered)
            if onHovered then
            end
            if onSelected then
                INVENTORY.UI.InteractItem.Confirm = true
            end
        end)

        UI.DrawTexts(baseX + separatorX + w/2, (baseY + separatorY + 0.002) + ((intervalY + h) * i), "Confirmer", true, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)


        i = i + 1
        --leave
        UI.DrawSpriteNew("inventory", "btn_normal", baseX + separatorX, (baseY + separatorY ) + ((intervalY + h) * i), w, h, 0, 255, 255, 255, INVENTORY.UI.Main.Alpha, {
            devmod = false,
            NoHover = false,
            NoSelect = false,
            CustomHoverTexture = {"inventory", "btn_hovered", nil, nil, {255, 106, 0}}
        }, function (onSelected, onHovered)
            if onHovered then
            end
            if onSelected then
                INVENTORY.UI.InteractItem.Maintain = false
                INVENTORY.UI.InteractItem.Confirm = false
                INVENTORY.UI.InteractItem.NeedConfirmCount = false
                INVENTORY.UI.InteractItem.Data = {}
                INVENTORY.UI.InteractItem.CountInput = 1
            end
        end)

        UI.DrawTexts(baseX + separatorX + w/2, (baseY + separatorY + 0.002) + ((intervalY + h) * i), "Annuler", true, 0.23, {255, 255, 255, math.floor(INVENTORY.UI.Main.Alpha)}, UI.font["robmed"], false, false, false)



        SetScriptGfxDrawOrder(7)
    end
end



