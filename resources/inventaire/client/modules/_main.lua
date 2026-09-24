INVENTORY = {}
INVENTORY.Player = {}
INVENTORY.Ground = {}
INVENTORY.Other = {}
INVENTORY.Open = false
INVENTORY.Leave = false
INVENTORY.PedCloned = {}
INVENTORY.PedCreated  = false
INVENTORY.InClosing = true
INVENTORY.InOpening = false
INVENTORY.IsSociety = false
INVENTORY.IsVehicle = false
INVENTORY.IsProperty = false
INVENTORY.IsGang = false
INVENTORY.GangChestIndex = nil
-- Boite aux lettres de propriete (depot libre, retrait locataire).
INVENTORY.IsMailbox = false
INVENTORY.MailboxId = nil
INVENTORY.MailboxCanWithdraw = false
INVENTORY.DEAD = false
INVENTORY.CanOpen = false

CreateThread(function()
    Wait(3000)
    INVENTORY.CanOpen = true
    DisplayRadar(true)
end)

function INVENTORY.SyncOufit()
    local data = nil
    TriggerEvent('skinchanger:getSkin', function(skin)
        data = skin
    end)
    while data == nil do 
        Wait(100)
    end
    local gender = "male"
    if IsPedMale(PlayerPedId()) == 1 then
        gender = "male"
    else
        gender = "female"
    end
    local clothingItems = {
        ["tshirt"] = {"tshirt_1", "tshirt_2", "torso_1", "torso_2", "arms", "arms_2", "decals_1", "decals_2"},
        ["pants"] = {"pants_1", "pants_2"},
        ["shoes"] = {"shoes_1", "shoes_2"},
        ["mask"] = {"mask_1", "mask_2"},
        ["bproof"] = {"bproof_1", "bproof_2"},
        ["chain"] = {"chain_1", "chain_2"},
        ["helmet"] = {"helmet_1", "helmet_2"},
        ["glasses"] = {"glasses_1", "glasses_2"},
        ["watch"] = {"watches_1", "watches_2"},
        ["bracelets"] = {"bracelets_1", "bracelets_2"},
        ["bag"] = {"bags_1", "bags_2"},
        ["ears"] = {"ears_1", "ears_2"},
    }
    for itemKey, itemValues in pairs(clothingItems) do
        for key, outfitItem in pairs(ConfigShared.Outfit) do
            if itemKey ~= "tshirt" and outfitItem.itemName ~= "tshirt" then 
                local gender = "male" -- ou "female", selon le sexe du personnage
                if IsPedMale(PlayerPedId()) == 1 then
                    gender = "male"
                else
                    gender = "female"
                end
              -- Comparaison avec getSkin pour voir si l'élément correspond aux valeurs par défaut
                if data[outfitItem.name] == outfitItem[gender].defaultValue and data[outfitItem.itemVariation] == outfitItem[gender].defaultValueVariation then
                    outfitItem.equip = false
                else
                    outfitItem.equip = true
                    local meta = {}
                    meta.name = outfitItem.itemName
                    meta.metadatas = {}
                    meta.metadatas.data = {}
                    meta.metadatas.data[outfitItem.name] = data[outfitItem.name]
                    meta.metadatas.data[outfitItem.itemVariation] = data[outfitItem.itemVariation]
                    outfitItem.data = meta
                end
            elseif itemKey == "tshirt" and outfitItem.itemName == "tshirt" then
                local gender = "male" -- ou "female", selon le sexe du personnage
              
                if IsPedMale(PlayerPedId()) == 1 then
                    gender = "male"
                else
                    gender = "female"
                end
                local default = 0
                    for _, value in pairs(itemValues) do
                        if outfitItem.skin[gender][value] == data[value] then
                        default = default + 1
                    end
                end
                if default < 8 then
                    outfitItem.equip = true
                    local meta = {}
                    meta.name = "tshirt"
                    meta.metadatas = {}
                    meta.metadatas.data = {}
                    meta.metadatas.data["tshirt_1"] = data["tshirt_1"]
                    meta.metadatas.data["tshirt_2"] = data["tshirt_2"]
                    meta.metadatas.data["torso_1"] =  data["torso_1"]
                    meta.metadatas.data["torso_2"] =  data["torso_2"]
                    meta.metadatas.data["arms"] =  data["arms"]
                    meta.metadatas.data["arms_2"] = data["arms_2"]
                    meta.metadatas.data["decals_1"] =  data["decals_1"]
                    meta.metadatas.data["decals_2"] =  data["decals_2"]
                    outfitItem.data = meta
                else
                    outfitItem.equip = false

                end
            end
        end
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsEntityDead(PlayerPedId()) then 
            INVENTORY.Close()
        end
    end
end)

function INVENTORY.OpenMenu()
    if not INVENTORY.CanOpen then
        return
    end

    if IsEntityDead(PlayerPedId()) then 
        return
    end

    INVENTORY.Open = true
    INVENTORY.InClosing = false
    ESX.PlayerData = ESX.GetPlayerData()
       
    if ConfigShared.Framework == "esx" then
        INVENTORY.Player = ESX.PlayerData.inventory
    end

    if ESX.PlayerData.rank == "diamond" then
        INVENTORY.MaxWeight = "60"
    elseif ESX.PlayerData.rank == "gold" then
        INVENTORY.MaxWeight = "45"
    else
        INVENTORY.MaxWeight = ESX.PlayerData.maxWeight
    end
    INVENTORY.Clone()

    local waitStart = GetGameTimer()
    while INVENTORY.Player == nil do 
        INVENTORY.Player = ESX.PlayerData.inventory
        if GetGameTimer() - waitStart > 2000 then
            INVENTORY.Player = {}
            break
        end
        Wait(100)
    end

    INVENTORY.UI.Player.FilterData = {}
    for key, value in pairs(INVENTORY.Player) do
        if not ConfigShared.Filter[5].item[string.upper(value.name)] and not ESX.IsContribWeapon(string.upper(value.name)) then 
            table.insert(INVENTORY.UI.Player.FilterData, value)
        end  
    end

    INVENTORY.UI.Player.FilterSelected = 1
    INVENTORY.UI.Other.FilterSelected = 1

    INVENTORY.UI.Player.Min = 1
    INVENTORY.UI.Player.Max = 25
    INVENTORY.UI.Player.Index = 0
    INVENTORY.UI.Player.Page = 0

    INVENTORY.Player = INVENTORY.UI.Player.FilterData
    INVENTORY.DEAD = false

    INVENTORY.ResetAlpha()
    INVENTORY.Leave = false
    INVENTORY.UI.Player.CurrentWeight = INVENTORY.GetPlayerCurrentWeight()
    INVENTORY.InOpening = true
    INVENTORY.SyncOufit()
    TEST = true
    ExecuteCommand("hudtoggle")

    Citizen.CreateThread(function() -- No pages used so no need to loop for now.
        local timer = GetGameTimer()
        while INVENTORY.Open do
            local currentTimer = GetGameTimer()
            Utils.TimeFrame = currentTimer - timer
            timer = currentTimer
            ShowCursorThisFrame()
            SetMouseCursorSprite(1)
            if UI.Input then 
                DisableAllControlActions(0)
                DisableAllControlActions(1)
                DisableAllControlActions(2)
            else
                for k,v in pairs(UI.lockedControls[1]) do
                    if v ~= nil then
                        DisableControlAction(0, v, true)
                    end
                end
            end
              
            UI.pages["u_inventory"].drawFunction()

            Wait(1)
            
            
        end
    end)
end

function INVENTORY.ResetAlpha()
    INVENTORY.UI.Main.Alpha = 0
    INVENTORY.UI.Main.AlphaBackground = 0
    INVENTORY.UI.Player.Alpha = 0
    INVENTORY.UI.Ground.Alpha = 0
    INVENTORY.UI.Other.Alpha = 0
    INVENTORY.UI.Outfit.Alpha = 0
    INVENTORY.UI.Player.AlphaFilter = 0
    INVENTORY.UI.Ground.AlphaFilter = 0
    INVENTORY.UI.Other.AlphaFilter = 0
    INVENTORY.UI.Player.AlphaCrossBar = 0
    INVENTORY.UI.Ground.AlphaCrossBar = 0
    INVENTORY.UI.Other.AlphaCrossBar = 0
end

function INVENTORY.Close()
    if INVENTORY.InOpening and not INVENTORY.InClosing then
        if INVENTORY.UI.Other.Info ~= "" then 
            if INVENTORY.IsVehicle then
                TriggerServerEvent("inventory:server:RemoveCacheVehicle", INVENTORY.UI.Other.Info)
            end
            if INVENTORY.IsSociety then
                TriggerServerEvent("inventory:server:RemoveCacheSociety", INVENTORY.UI.Other.Info)
            end
            if INVENTORY.IsProperty then
                TriggerServerEvent("inventory:server:RemoveCacheProperty", INVENTORY.UI.Other.Info)
            end
            if INVENTORY.IsMailbox and INVENTORY.MailboxId then
                TriggerServerEvent("inventory:server:RemoveCacheMailbox", INVENTORY.MailboxId)
            end
        end
        INVENTORY.UI.Other.Info = ""
        INVENTORY.Other = {}
        INVENTORY.InClosing = true
        INVENTORY.Open = false
        INVENTORY.Leave = true
        INVENTORY.Clone()
        UI.DisableControlsForPage("u_inventory")
        INVENTORY.UI.InteractItem.Maintain = false
        INVENTORY.IsVehicle = false
        INVENTORY.IsSociety = false
        INVENTORY.IsProperty = false
        INVENTORY.IsGang = false
        INVENTORY.GangChestIndex = nil
        INVENTORY.IsMailbox = false
        INVENTORY.MailboxId = nil
        INVENTORY.MailboxCanWithdraw = false
        INVENTORY.IsPlayer = false
        INVENTORY.UI.Other.InputActive = false
        INVENTORY.UI.Ground.InputActive = false
        INVENTORY.UI.Player.InputActive = false
        INVENTORY.UI.Input.Filter = "ID du joueur"
        INVENTORY.UI.Input.FullText = ""
        INVENTORY.UI.InteractItem.NeedConfirmCount = false
        INVENTORY.Permis.Open = false
        INVENTORY.Permis.OpenPermis = false
        INVENTORY.Permis.LspdOpen = false
        INVENTORY.Permis.BcsoOpen = false
        INVENTORY.Permis.EmsOpen = false
        UI.DeactivateDetectInput()
        INVENTORY.UI.Input.InputActive = false
        INVENTORY.UI.Input.Number = false
        INVENTORY.Permis.OpenWeapon = false
        INVENTORY.Permis.OpenChasse = false
        INVENTORY.Permis.OpenPeche = false
        INVENTORY.UI.Input.InputActive = false
        INVENTORY.DEAD = false

        INVENTORY.UI.Main.Alpha = 0
        UI.EnableControlsForPage("u_inventory")
        ExecuteCommand("hudtoggle")

        INVENTORY.InOpening = false
        INVENTORY.PlayerProx = nil

    end
end

function INVENTORY.Clone()
    if ConfigShared.PedVisible  then
        if not INVENTORY.PedCreated  then
            local heading = GetEntityHeading(PlayerPedId())
            SetFrontendActive(true)
            ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
            Wait(100)
            INVENTORY.PedCloned = ClonePed(PlayerPedId(),false, false, true)
            local x, y, z = table.unpack(GetEntityCoords(INVENTORY.PedCloned))
            SetEntityCoords(INVENTORY.PedCloned, x, y, z - 10)
            SetMouseCursorVisibleInMenus(true)
            FreezeEntityPosition(INVENTORY.PedCloned, true)
            SetEntityVisible(INVENTORY.PedCloned, false, false)
            NetworkSetEntityInvisibleToNetwork(INVENTORY.PedCloned, false)
            Wait(200)
            SetPedAsNoLongerNeeded(INVENTORY.PedCloned)
            ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
            GivePedToPauseMenu(INVENTORY.PedCloned, 1)
            SetPauseMenuPedLighting(true)
            SetPauseMenuPedSleepState(true)
            INVENTORY.PedCreated = true
        else
            ReplaceHudColourWithRgba(117, 0, 0, 0, 187)
            DeleteEntity(INVENTORY.PedCloned)
            SetFrontendActive(false)
            INVENTORY.PedCreated = false
        end
    end
end


function INVENTORY.ChangeCloth(type, id)
    if type ~= nil then 
        if id ~= nil then 
            TriggerEvent("skinchanger:change", type, id)
            CreateThread(function ()
                local heading = GetEntityHeading(PlayerPedId())
                DeleteEntity(INVENTORY.PedCloned)
                -- ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
                INVENTORY.PedCloned = ClonePed(PlayerPedId(),false, false, true)
                local x, y, z = table.unpack(GetEntityCoords(INVENTORY.PedCloned))
                SetEntityCoords(INVENTORY.PedCloned, x, y, z - 10)
                SetMouseCursorVisibleInMenus(true)
                FreezeEntityPosition(INVENTORY.PedCloned, true)
                SetEntityVisible(INVENTORY.PedCloned, false, false)
                NetworkSetEntityInvisibleToNetwork(INVENTORY.PedCloned, false)
                SetPedAsNoLongerNeeded(INVENTORY.PedCloned)
                ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
                GivePedToPauseMenu(INVENTORY.PedCloned, 1)
                SetPauseMenuPedLighting(true)
                SetPauseMenuPedSleepState(true)
            end)
           
        else 
            print("id == nil change cloth")
        end
    else 
        print("type == nil change cloth")
    end
end

function INVENTORY.ChangeClothOutfit(type, id)
    if type ~= nil then
        if id ~= nil then 
            TriggerEvent("skinchanger:change", type, id)
 
            CreateThread(function ()
                local heading = GetEntityHeading(PlayerPedId())
                DeleteEntity(INVENTORY.PedCloned)
                -- ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
                INVENTORY.PedCloned = ClonePed(PlayerPedId(),false, false, true)
                local x, y, z = table.unpack(GetEntityCoords(INVENTORY.PedCloned))
                SetEntityCoords(INVENTORY.PedCloned, x, y, z - 10)
                SetMouseCursorVisibleInMenus(true)
                FreezeEntityPosition(INVENTORY.PedCloned, true)
                SetEntityVisible(INVENTORY.PedCloned, false, false)
                NetworkSetEntityInvisibleToNetwork(INVENTORY.PedCloned, false)
                SetPedAsNoLongerNeeded(INVENTORY.PedCloned)
                ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
                GivePedToPauseMenu(INVENTORY.PedCloned, 1)
                SetPauseMenuPedLighting(true)
                SetPauseMenuPedSleepState(true)
            end)
           
        else 
            print("id == nil change cloth")
        end
    else 
        print("type == nil change cloth")
    end
end

AddEventHandler("inventory:getMugshot", function (cb)
    local ped = PlayerPedId()
    local handle = RegisterPedheadshot(ped)
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(100)
    end
    local mugshotTxd = GetPedheadshotTxdString(handle)
    local zeub = true
    SendNUIMessage({
        action    = 'encours',
        start = true,
    })
    Wait(100)
    CreateThread(function ()
        while zeub do
            Wait(1)
            DrawSprite(mugshotTxd, mugshotTxd, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        end
    end)

    CreateThread(function ()
        Wait(8000)
        zeub = false
    end)

    Wait(200)
    exports['screenshot-basic']:requestScreenshotUpload('https://api.fivemanage.com/api/image?apiKey=OKgN5zIdYAThp0XIpidyEhWfqmrV4rlG', 'image', function(data)
        zeub = false
        UnregisterPedheadshot(handle)
        SendNUIMessage({
            action    = 'encours',
            start = false,
        })

        local resp = json.decode(data)
        if resp and resp.url then
            cb(resp.url)
        else
            cb(nil)
        end
    end)
end)

RegisterCommand("zeubss", function ()
    exports['screenshot-basic']:requestScreenshotUpload('https://api.fivemanage.com/api/image?apiKey=PeVQLOoC6WPZQKrj8fZUbbO0TphqPCOM', 'image', function(data)
        local resp = json.decode(data)
        if resp then
            print(resp.url)
        end
    end)
end, false)