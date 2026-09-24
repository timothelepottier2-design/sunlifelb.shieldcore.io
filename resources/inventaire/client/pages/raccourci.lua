INVENTORY.Raccourci = {}
INVENTORY.Raccourci.WeaponEkip = false
INVENTORY.Raccourci.LastWeapon = "WEAPON_PISTOL"
INVENTORY.Raccourci.cd = true
function INVENTORY.KeyRegister(Controls, ControlName, Description, Action)
	RegisterKeyMapping(string.format('%s', ControlName), Description, "keyboard", Controls)
	RegisterCommand(string.format('%s', ControlName), function(source, args)
		if (Action ~= nil) then
			Action();
		end
	end, false)
end

function INVENTORY.Raccourci.Cooldown()
    CreateThread(function()
        INVENTORY.Raccourci.cd = false
        -- 300 ms suffit a debouncer un double-declenchement accidentel tout
        -- en laissant enchainer ranger -> ressortir l'arme sans avaler la
        -- pression (avant : 800 ms, ce qui obligeait a appuyer 2 fois).
        Wait(300)
        INVENTORY.Raccourci.cd = true
    end)
end

local coolDown = false
INVENTORY.KeyRegister("TAB", "Inventaire", "Inventaire", function()
    print(coolDown)
    if not coolDown then
        coolDown = true
        if not INVENTORY.OpenVehicle() then
            INVENTORY.UI.Other.CurrentWeight = "0.0"
            INVENTORY.UI.Other.MaxWeight = "0.0"
            if not INVENTORY.Open then
                INVENTORY.OpenMenu()
            else
                INVENTORY.Close()
            end
        end
        Wait(300)
        coolDown = false
    end

end)


-- local odl = GetVehicleNumberPlateText
-- local function GetVehicleNumberPlateText(veh)
--     -- Supposons que 'plate_text' est le texte de la plaque que vous avez récupéré
--     local plate_text = odl(veh)  -- Simulant un texte de plaque avec un espace à la fin

--     -- Supprimez l'espace à la fin en utilisant la fonction 'string.match' avec un pattern
--     local cleaned_plate_text = string.match(plate_text, "^(.-)%s*$")

--     return cleaned_plate_text
-- end

function INVENTORY.GetVehicleLockNear()
    local veh, dst = Utils.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    if veh == -1 then
        return true
    end
    local lockStatus = GetVehicleDoorLockStatus(veh)

    if lockStatus ~= 1 then
        return true
    else
        return false
    end
end

function INVENTORY.OpenVehicle()
    local veh, dst = Utils.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    if veh == -1 then
        return false
    end
    local lockStatus = GetVehicleDoorLockStatus(veh)

    if lockStatus ~= 1 then
        return false
    end
    local plate = GetVehicleNumberPlateText(veh)
    local class = GetVehicleClass(veh)
    local weight = 50.0
    if ConfigShared.Trunk.TrunkClassWeights[class] then
        weight = ConfigShared.Trunk.TrunkClassWeights[class]
    end
    local modelId = GetEntityModel(veh)
    local hash = GetHashKey(veh)
    local displayName = GetDisplayNameFromVehicleModel(modelId)
    local spawnName = string.lower(displayName)
    local spawnNameHash = GetHashKey(spawnName)
    local vehicleName = displayName
    if ConfigShared.Trunk.TrunkIndividualWeights[spawnName] then
        weight = ConfigShared.Trunk.TrunkIndividualWeights[spawnName]
    end
    if spawnNameHash == 751804762 then
        INVENTORY.UI.Other.MaxWeight = 350
    else
        INVENTORY.UI.Other.MaxWeight = weight
    end
    local zizi = nil
    if veh and dst <= 3 then
        if not INVENTORY.InOpening and INVENTORY.InClosing then
            if not INVENTORY.Open then
                TriggerServerEvent("inventory:server:openVehicle", plate, true)
                zizi =  true 
            end
        else
            zizi =  false
            if INVENTORY.Open then
                TriggerServerEvent("inventory:server:openVehicle", plate, false)
                zizi =  false
            end
        end
      
    end
    while zizi == nil do Wait(500) print("nil") end 
    return zizi
end


RegisterNetEvent("inventory:client:openVehicle", function (inv, plate)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = plate
    print(INVENTORY.UI.Other.Info, plate)
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsVehicle = true
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:openSociety", function (inv, society, weight)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = society
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsSociety = true
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

-- Support des coffres de gang SNL_GangBuilder (comme inventaire-prime avec kxGangBuilder)
local lastGangChestOpen = 0

-- Cache des poids d'items connus côté client (alimenté par l'inventaire joueur, etc.)
local KnownItemWeights = KnownItemWeights or {}

local function _learnPlayerItemWeights()
    if not ESX or not ESX.GetPlayerData then return end
    local pd = ESX.GetPlayerData()
    if not pd or type(pd.inventory) ~= "table" then return end
    for i = 1, #pd.inventory do
        local it = pd.inventory[i]
        if it and it.name then
            local w = tonumber(it.weight)
            if w and w > 0 then
                KnownItemWeights[it.name] = w
            end
        end
    end
end

local function _resolveItemWeight(name, fallbackWeight)
    local w = tonumber(fallbackWeight)
    if w and w > 0 then return w end
    if name and KnownItemWeights[name] then
        return KnownItemWeights[name]
    end
    return 0
end

-- Normalise une liste d'items (coffre de gang) en garantissant
-- que chaque item possède au moins {name, label, count, weight, metadatas}
-- avec un weight numérique non-nul si possible.
local function _normalizeGangChestItems(inv)
    local out = {}
    if type(inv) ~= "table" then return out end
    _learnPlayerItemWeights()
    for i = 1, #inv do
        local v = inv[i]
        if type(v) == "table" and v.name then
            local count = tonumber(v.count) or tonumber(v.amount) or 0
            if count > 0 then
                local weight = _resolveItemWeight(v.name, v.weight)
                out[#out + 1] = {
                    name = v.name,
                    label = v.label or v.name,
                    count = count,
                    weight = weight,
                    metadatas = v.metadatas or v.metadata or {},
                }
            end
        end
    end
    return out
end

RegisterNetEvent("inventory:client:openGangChest", function(inv, info, maxWeight, chestIndex)
    local now = GetGameTimer()
    local normalized = _normalizeGangChestItems(inv)
    -- Debounce: ignorer les appels trop rapprochés (évite le spam)
    if now - lastGangChestOpen < 800 then
        INVENTORY.Other = normalized
        INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(INVENTORY.Other)
        INVENTORY.GangChestIndex = tonumber(chestIndex) or INVENTORY.GangChestIndex
        return
    end
    lastGangChestOpen = now

    INVENTORY.Other = normalized
    INVENTORY.UI.Other.Info = tostring(info or "")
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(INVENTORY.Other)
    INVENTORY.UI.Other.MaxWeight = tonumber(maxWeight or 0) or 0

    INVENTORY.IsGang = true
    INVENTORY.GangChestIndex = tonumber(chestIndex) or INVENTORY.GangChestIndex

    INVENTORY.IsVehicle = false
    INVENTORY.IsSociety = false
    INVENTORY.IsProperty = false
    INVENTORY.IsPlayer = false

    -- Si le menu est déjà ouvert avec ce coffre, on met juste à jour les données
    if INVENTORY.Open and INVENTORY.IsGang then
        return
    end

    -- Déferrer l'ouverture pour éviter les conflits avec les états InOpening/InClosing
    CreateThread(function()
        Wait(0)
        INVENTORY.OpenMenu()
    end)
end)

RegisterNetEvent("inventory:client:refreshGangChest", function(inv, cap, chestIndex)
    INVENTORY.Other = _normalizeGangChestItems(inv)
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(INVENTORY.Other)
    INVENTORY.UI.Other.MaxWeight = tonumber(cap) or INVENTORY.UI.Other.MaxWeight
    INVENTORY.GangChestIndex = chestIndex
end)

RegisterNetEvent("inventory:client:OpenFouille", function (id, inv, weight)
    ExecuteCommand("me fouille la personne")
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = id
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsPlayer = true
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:openProperty", function (inv, property, weight)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = "Propriété n°"..property
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsSociety = false
    INVENTORY.IsProperty = true
    INVENTORY.IsPlayer = false
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

-- Boite aux lettres de propriete : `canWithdraw` = locataire / co-proprietaire.
RegisterNetEvent("inventory:client:openMailbox", function (inv, propertyId, weight, canWithdraw)
    INVENTORY.Other = inv or {}
    INVENTORY.UI.Other.Info = "Boîte aux lettres n°"..tostring(propertyId)
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(INVENTORY.Other)
    INVENTORY.IsSociety = false
    INVENTORY.IsProperty = false
    INVENTORY.IsPlayer = false
    INVENTORY.IsMailbox = true
    INVENTORY.MailboxId = tonumber(propertyId)
    INVENTORY.MailboxCanWithdraw = canWithdraw == true
    INVENTORY.UI.Other.MaxWeight = weight
    if not INVENTORY.Open then
        INVENTORY.OpenMenu()
    end
end)

RegisterNetEvent("inventory:client:refreshMailboxInv", function (inv)
    if inv ~= nil and INVENTORY.IsMailbox then
        INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
        INVENTORY.Other = inv
    end
end)

RegisterNetEvent("inventory:client:closeInventory", function ()
    INVENTORY.Close()
end)

function INVENTORY.GetInventory()
    ESX.PlayerData = ESX.GetPlayerData()
    INVENTORY.Player = {}
    INVENTORY.Player = ESX.PlayerData.inventory
    INVENTORY.GetPlayerCurrentWeight()
    INVENTORY.UI.Player.FilterData = {}
    for key, value in pairs(INVENTORY.Player) do
        if not ConfigShared.Filter[5].item[string.upper(value.name)] and not ESX.IsContribWeapon(string.upper(value.name)) then
            table.insert(INVENTORY.UI.Player.FilterData, value)
        end
    end
        INVENTORY.UI.Player.FilterSelected = 1
    INVENTORY.UI.Player.Filter = "Rechercher"
end

function HasRaccourci(i)
    local has = false
 
    for k, v in pairs(INVENTORY.Player) do 
        if INVENTORY.UI.Player.PinItem[i] ~= nil then 
            if INVENTORY.UI.Player.PinItem[i].name == v.name then 
                has = true
            end
        end        
    end
    if not has then 
        INVENTORY.UI.Player.PinItem[i] = nil
    end
    return has
end

INVENTORY.KeyRegister("1", "raccourci_é", "Raccourci 1", function()
    INVENTORY.Raccourci.UseRaccourci(1)
end)


INVENTORY.KeyRegister("2", "raccourci_'", "Raccourci 2", function()
    INVENTORY.Raccourci.UseRaccourci(2)
end)

INVENTORY.KeyRegister("3", "raccourci_&", "Raccourci 3", function()
    INVENTORY.Raccourci.UseRaccourci(3)
end)

INVENTORY.KeyRegister("4", "raccourci_()", "Raccourci 4", function()
    INVENTORY.Raccourci.UseRaccourci(4)
end)

INVENTORY.KeyRegister("5", "raccourci__", "Raccourci 5", function()
    INVENTORY.Raccourci.UseRaccourci(5)
end)

RegisterNetEvent("inventory:server:updateRaccourci", function (id, data)
    if id ~= nil then
        AddRaccourci(id, data)
    end
end)


local cooldownoutfit = false
function INVENTORY.Raccourci.UseRaccourci(key)
    if INVENTORY.Raccourci.cd == false then
        return
    end
    INVENTORY.GetInventory()
    local has = HasRaccourci(key)
    if not has then return end
    INVENTORY.Raccourci.Cooldown()
    -- if INVENTORY.UI.InteractItem.CountInput
    if INVENTORY.UI.Player.PinItem[key] ~= nil then 
        if INVENTORY.UI.Player.PinItem[key].count <= 0 then
            -- TriggerServerEvent("inventory:server:updateRaccourci", key, nil)
            AddRaccourci(key, nil)

            INVENTORY.UI.Player.PinItem[key] = nil
            return
        end
    end
    if INVENTORY.UI.Player.PinItem[key] == nil then
        return
    end
    local data = INVENTORY.UI.Player.PinItem[key]
    local isWeapon = false
    local isOutfit = false
    if data.name == "money" or data.name == "dirtymoney" then
        return
    end

    if data.name == "identitycard" then
        if INVENTORY.Permis.Open then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.DataId = data.metadatas.data
            INVENTORY.Permis.Open = true
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.OpenPeche = false
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.Open do
                    INVENTORY.Permis.DrawId()
                    Wait(1)
                end
            end)

            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
        end
        return
    end
    
    if data.name == "permisems" then
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
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.EmsOpen do
                    INVENTORY.Permis.DrawBadgeEms()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    if data.name == "permissheriff" then
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
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.BcsoOpen do
                    INVENTORY.Permis.DrawBadgeSheriff()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    if data.name == "permispolice" then
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
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
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
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
            
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataLspd)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.LspdOpen do
                    INVENTORY.Permis.DrawBadgeLSPD()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    -- Badges Bobcat Security et LSFD : meme comportement que les autres badges
    -- (bascule d'affichage + presentation au joueur le plus proche), factorise
    -- pour les deux au lieu d'un bloc copie-colle chacun.
    if data.name == "permisbobcat" or data.name == "permislsfd" or data.name == "permisgouv" then
        if lastDui ~= nil then
            DestroyDui(lastDui)
            lastDui = nil
        end

        local badges = {
            permisbobcat = { flag = "BobcatOpen", key = "DataBobcat", draw = INVENTORY.Permis.DrawBadgeBobcat },
            permislsfd   = { flag = "LsfdOpen",   key = "DataLsfd",   draw = INVENTORY.Permis.DrawBadgeLsfd },
            permisgouv   = { flag = "GouvOpen",   key = "DataGouv",   draw = INVENTORY.Permis.DrawBadgeGouv },
        }
        local flag = badges[data.name].flag
        local key  = badges[data.name].key
        local draw = badges[data.name].draw

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

            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis[key])
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end

            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis[flag] do
                    draw()
                    Wait(1)
                end
            end)
        end

        return
    end

    if data.name == "permisweapon" then
        if INVENTORY.Permis.OpenWeapon then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.DataWeapon = {}
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = true
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.Open = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataWeapon)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenWeapon do
                    INVENTORY.Permis.DrawWeapon()
                    Wait(1)
                end
            end)
        end
        return
    end

    if data.name == "permischasse" then
        if INVENTORY.Permis.OpenChasse then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataWeapon = {}
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = true
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false

            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenChasse do
                    INVENTORY.Permis.DrawChasse()
                    Wait(1)
                end
            end)
        end
        return
    end 

    if data.name == "permispeche" then
        if INVENTORY.Permis.OpenPeche then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.DataWeapon = {}
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = true
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false

            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenPeche do
                    INVENTORY.Permis.DrawPeche()
                    Wait(1)
                end
            end)
        end
        return
    end 

    if data.name == "permisauto" then
        if INVENTORY.Permis.OpenPermis then
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataPermis = {}
        else
            INVENTORY.Permis.DataPermis = data.metadatas.data
            INVENTORY.Permis.OpenPermis = true
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.OpenAircraft = false
            INVENTORY.Permis.OpenBateau = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataPermis)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenPermis do
                    INVENTORY.Permis.DrawPermis()
                    Wait(1)
                end
            end)

        end
        return
    end

    if data.name == "permisaircraft" then
        if INVENTORY.Permis.OpenAircraft then
            INVENTORY.Permis.OpenAircraft = false
            INVENTORY.Permis.DataAircraft = {}
        else
            INVENTORY.Permis.DataAircraft = data.metadatas.data or {}
            INVENTORY.Permis.OpenAircraft = true
            INVENTORY.Permis.OpenBateau   = false
            INVENTORY.Permis.OpenPermis   = false
            INVENTORY.Permis.Open         = false
            INVENTORY.Permis.BcsoOpen     = false
            INVENTORY.Permis.EmsOpen      = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataAircraft)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenAircraft do
                    INVENTORY.Permis.DrawAircraft()
                    Wait(1)
                end
            end)
        end
        return
    end

    if data.name == "permisbateau" then
        if INVENTORY.Permis.OpenBateau then
            INVENTORY.Permis.OpenBateau = false
            INVENTORY.Permis.DataBateau = {}
        else
            INVENTORY.Permis.DataBateau = data.metadatas.data or {}
            INVENTORY.Permis.OpenBateau   = true
            INVENTORY.Permis.OpenAircraft = false
            INVENTORY.Permis.OpenPermis   = false
            INVENTORY.Permis.Open         = false
            INVENTORY.Permis.BcsoOpen     = false
            INVENTORY.Permis.EmsOpen      = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataBateau)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenBateau do
                    INVENTORY.Permis.DrawBateau()
                    Wait(1)
                end
            end)
        end
        return
    end
    if ConfigShared.Filter[3].item[(data.name)] then
        isOutfit = true
    end
    if ConfigShared.Filter[5].item[string.upper(data.name)] then
        isWeapon = true
    end

    if isWeapon then
        if exports["sunlife"]:InZoneSafe() then
            return
        end
        local lastdata = Utils.TableCopy(data)

        if INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon == data.name then
            -- Sauvegarder les munitions AVANT de retirer l'arme
            local weaponHash = GetHashKey(data.name)
            local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
            local metaForServer = Utils.TableCopy(data.metadatas or {})
            -- Passe par le dedup expose par pages/weapon.lua. Pas un export
            -- direct car raccourci.lua peut etre charge avant weapon.lua ;
            -- en fallback, TriggerServerEvent classique (rare au demarrage).
            local _sendAmmoIfNeeded = exports[GetCurrentResourceName()]
                and exports[GetCurrentResourceName()].sendAmmoIfNeeded
            if _sendAmmoIfNeeded then
                _sendAmmoIfNeeded(data.name, metaForServer, ammo)
            else
                TriggerServerEvent("inventory:server:newAmmo", data.name, metaForServer, ammo)
            end
            if data.metadatas then data.metadatas.ammo = ammo end
            SaveRaccourci()
            INVENTORY.Raccourci.WeaponEkip = false
            INVENTORY.Raccourci.LastWeapon = data.name
            RemoveAllPedWeapons(PlayerPedId(), 1)
            SetCurrentPedWeapon(PlayerPedId(), 'WEAPON_UNARMED', true)
            INVENTORY.Weapon.Selected = {}
        elseif not INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon ~= data.name then
            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
            
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end

            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
            

        elseif not INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon == data.name then
            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), data.name, true)
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end
            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
        elseif INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon ~= data.name then
            -- Switch d'une arme raccourci à une autre.
            -- On sauvegarde d'abord les munitions de l'arme actuelle avant de la remplacer,
            -- sinon on perd l'ammo (la metadata côté serveur ne reflète plus ce que le ped a).
            local prevName = INVENTORY.Raccourci.LastWeapon
            if prevName and INVENTORY.Weapon.Selected and INVENTORY.Weapon.Selected.name == prevName then
                local prevHash = GetHashKey(prevName)
                local prevAmmo = GetAmmoInPedWeapon(PlayerPedId(), prevHash)
                local prevMeta = Utils.TableCopy(INVENTORY.Weapon.Selected.metadatas or {})
                local _sendAmmoIfNeeded = exports[GetCurrentResourceName()]
                    and exports[GetCurrentResourceName()].sendAmmoIfNeeded
                if _sendAmmoIfNeeded then
                    _sendAmmoIfNeeded(prevName, prevMeta, prevAmmo)
                else
                    TriggerServerEvent("inventory:server:newAmmo", prevName, prevMeta, prevAmmo)
                end
                if INVENTORY.Weapon.Selected.metadatas then
                    INVENTORY.Weapon.Selected.metadatas.ammo = prevAmmo
                end
                if INVENTORY.Weapon.Selected.metadatas and INVENTORY.Weapon.Selected.metadatas.id then
                    for _, pin in pairs(INVENTORY.UI.Player.PinItem) do
                        if pin and pin.name == prevName and pin.metadatas
                            and pin.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then
                            pin.metadatas.ammo = prevAmmo
                        end
                    end
                    SaveRaccourci()
                end
            end

            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
            
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end
            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
            

            -- for key, value in pairs(data.components) do
            --     local componentHash = ESX.GetWeaponContiComponent(data.name, value).hash
            --     GiveWeaponComponentToPed(PlayerPedId(), data.name, componentHash)
            -- end
        end
        return
    elseif isOutfit then
        if not cooldownoutfit then
            cooldownoutfit = true
            if data.name ~= "outfit" then
                for k, v in pairs(ConfigShared.Outfit) do
                    if v.itemName == data.name then
                        if not v.equip then
                            v.equip = true
                            for type, value in pairs(data.metadatas.data) do
                                INVENTORY.ChangeClothOutfit(type, value)
                            end
                        else
                            for type, value in pairs(data.metadatas.data) do
                                INVENTORY.ChangeClothOutfit(type, value)
                            end
                        end
                    end
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
            else
                INVENTORY.Raccourci.PlayAnim("outfit")
                INVENTORY.UI.Outfit.outfitEkip = true
                INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
                TriggerServerEvent('inventory:server:updateOutfit', data.metadatas)

                Wait(5000)
                for type, value in pairs(data.metadatas.data) do
                    INVENTORY.ChangeClothOutfit(type, value)
                end
                INVENTORY.UI.Outfit.outfitEkip = true
            end
            INVENTORY.SyncOufit()

            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
            end)
            Wait(2000)
            cooldownoutfit = false
        end
        return
    else
        if data.name ~= "identitycard" and data.name ~= "permisauto" and data.name ~= "permisweapon" and data.name ~= "permisaircraft" and data.name ~= "permisbateau"  then
            TriggerServerEvent("inventaire:server:useItem", data.name, 1, data.metadatas)
                
            if data.count == 0 then
                AddRaccourci(key, nil)
                return
            end
            
            data.count = data.count
            local dataSend = {
                name = INVENTORY.UI.Player.PinItem[key].name,
                label = INVENTORY.UI.Player.PinItem[key].label,
                weight = INVENTORY.UI.Player.PinItem[key].weight,
                metadatas = INVENTORY.UI.Player.PinItem[key].metadatas
            }
          
            AddRaccourci(key, dataSend)
            return
        end
    end
end

function INVENTORY.Raccourci.PlayAnim(type)
    CreateThread(function ()
        for key, value in pairs(ConfigShared.Outfit) do
            local type2 = 'pants'
            if type == 'outfit' then
                type2 = "pants"
            end
            if type2 == value.itemName then
                Utils.LoadAnimDict(value.anim.dict)
                TaskPlayAnim(PlayerPedId(), value.anim.dict, value.anim.anim, 8.0, -8.0, -1, 51, 0, 0, 0, 0)
                if type == "outfit" then
                    Wait(5000)
                else
                    Wait(1300)
                end
                ClearPedTasks(PlayerPedId())
            end
        end
    end)
end

function INVENTORY.Raccourci.SetComponent(data)
    if data.metadatas.component ~= nil and next(data.metadatas.component) then 
        for components, value in pairs(data.metadatas.component) do
            for _, skin in pairs(ConfigShared.AccessoriesWeapon) do
                if components == skin.component then 
                    for i,j in pairs(skin.weapons) do
                        if data.name == j.name then
                            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.name), GetHashKey(j.componentID))
                        end
                    end
                end
            end
        end
    end

    -- Le raccourci (KVP) peut avoir ete epingle depuis une copie d'inventaire
    -- perimee, donc sans les accessoires achetes. On recale ses attachments sur
    -- l'item d'inventaire (meme id) avant de les appliquer. Fusion par categorie,
    -- jamais de suppression : un retrait passe deja par SetWeaponAttachment.
    if data.metadatas.id ~= nil and ESX and ESX.PlayerData and ESX.PlayerData.inventory then
        for _, item in pairs(ESX.PlayerData.inventory) do
            if item.name == data.name and item.metadatas and item.metadatas.id == data.metadatas.id then
                if type(item.metadatas.attachments) == "table" then
                    local healed = false
                    data.metadatas.attachments = data.metadatas.attachments or {}
                    for category, componentID in pairs(item.metadatas.attachments) do
                        if data.metadatas.attachments[category] ~= componentID then
                            data.metadatas.attachments[category] = componentID
                            healed = true
                        end
                    end
                    if healed then SaveRaccourci() end
                end
                break
            end
        end
    end

    -- Accessoires d'armes (boutique) : metadatas.attachments = { [categorie] = componentID }
    -- Re-applique les accessoires achetes a chaque equipement / reconnexion.
    if data.metadatas.attachments ~= nil and next(data.metadatas.attachments) then
        for _, componentID in pairs(data.metadatas.attachments) do
            if type(componentID) == "string" and componentID ~= "" then
                GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.name), GetHashKey(componentID))
            end
        end
    end
end
local db = nil

-- Le KVP client de FiveM (SetResourceKvp) est commun a toutes les instances
-- d'une ressource portant le meme nom : deux serveurs partagent donc le meme
-- store cote client. On namespace la cle des raccourcis avec l'endpoint du
-- serveur courant pour que chaque serveur ait ses propres raccourcis.
local function GetRaccourciKey()
    local endpoint = nil
    if GetCurrentServerEndpoint then
        endpoint = GetCurrentServerEndpoint()
    end
    if endpoint and endpoint ~= "" then
        return "raccourci_" .. endpoint
    end
    return "raccourci"
end

Citizen.CreateThread(function()
    Citizen.Wait(15 * 1000)
    db = rockdb:new()
    if db then
        local key = GetRaccourciKey()
        local loaded = db:GetTable(key)
        -- Migration : si rien n'est stocke sous la cle propre au serveur, on
        -- reprend une fois l'ancienne cle globale pour ne pas perdre les
        -- raccourcis existants. Apres la 1ere sauvegarde chaque serveur ecrit
        -- sous sa propre cle et les raccourcis divergent.
        if loaded == nil then
            loaded = db:GetTable("raccourci")
        end
        if INVENTORY.UI.Player.PinItem == nil or not next(INVENTORY.UI.Player.PinItem or {}) then
            INVENTORY.UI.Player.PinItem = loaded or {}
        end
        SaveRaccourci()
    else
        INVENTORY.UI.Player.PinItem = INVENTORY.UI.Player.PinItem or {}
    end
end)

function AddRaccourci(id, data)
    if data ~= nil then 
        if INVENTORY.UI.Player.PinItem == nil then
            INVENTORY.UI.Player.PinItem = {}
        end
        if INVENTORY.UI.Player.PinItem[id] == nil then
            INVENTORY.UI.Player.PinItem[id] = {}
            INVENTORY.UI.Player.PinItem[id] = data
            if INVENTORY.UI.Player.PinItem[id].count == nil then 
                INVENTORY.UI.Player.PinItem[id].count = 1
            end
        else
            INVENTORY.UI.Player.PinItem[id] = data
            if INVENTORY.UI.Player.PinItem[id].count == nil then 
                INVENTORY.UI.Player.PinItem[id].count = 1
            end
        end
        SaveRaccourci()
    end
end


function SaveRaccourci()
    if db == nil then
        return
    end
    db:SaveTable(GetRaccourciKey(), INVENTORY.UI.Player.PinItem)
end

-- Accessoires d'armes (boutique) : applique/retire un accessoire et PERSISTE
-- son etat la ou il faut pour qu'il survive a un re-equipement / une reconnexion :
--   1) sur le ped si l'arme est en main
--   2) dans INVENTORY.Weapon.Selected.metadatas.attachments
--   3) dans l'item epingle du raccourci (KVP client) + SaveRaccourci()
-- Le serveur (boutique) ayant deja ecrit dans l'inventaire serveur, cet export
-- aligne la copie cote raccourci qui sert reellement a re-equiper l'arme.
exports("SetWeaponAttachment", function(weaponName, id, category, componentID, removed)
    if type(weaponName) ~= "string" or type(category) ~= "string" then return false end
    local hash = GetHashKey(weaponName)
    local ped = PlayerPedId()

    -- 1) Application visuelle immediate si l'arme est en main
    if GetSelectedPedWeapon(ped) == hash and type(componentID) == "string" and componentID ~= "" then
        if removed then
            RemoveWeaponComponentFromPed(ped, hash, GetHashKey(componentID))
        else
            GiveWeaponComponentToPed(ped, hash, GetHashKey(componentID))
        end
    end

    local function applyMeta(meta)
        if type(meta) ~= "table" then return end
        meta.attachments = meta.attachments or {}
        if removed then
            meta.attachments[category] = nil
        else
            meta.attachments[category] = componentID
        end
    end

    -- 2) Arme actuellement selectionnee
    if INVENTORY and INVENTORY.Weapon and INVENTORY.Weapon.Selected
       and INVENTORY.Weapon.Selected.name == weaponName
       and INVENTORY.Weapon.Selected.metadatas then
        local selMeta = INVENTORY.Weapon.Selected.metadatas
        if id == nil or selMeta.id == id then
            applyMeta(selMeta)
        end
    end

    -- 3) Raccourci (hotbar) : la copie KVP qui sert a re-equiper l'arme
    if INVENTORY and INVENTORY.UI and INVENTORY.UI.Player and INVENTORY.UI.Player.PinItem then
        local changed = false
        for _, pin in pairs(INVENTORY.UI.Player.PinItem) do
            if pin and pin.name == weaponName and pin.metadatas then
                if id == nil or pin.metadatas.id == id then
                    applyMeta(pin.metadatas)
                    changed = true
                end
            end
        end
        if changed then
            SaveRaccourci()
        end
    end

    return true
end)


-- RegisterNetEvent("inventory:client:loadraccourci", function (data)
--     INVENTORY.UI.Player.PinItem = data
-- end)

RegisterNetEvent("inventaire:useoutfit", function (data)
    if INVENTORY.Raccourci.cd == false then
        return
    end
    INVENTORY.Raccourci.Cooldown()
    if not INVENTORY.UI.Outfit.outfitEkip then 
        if data.name ~= "outfit" then
            for k, v in pairs(ConfigShared.Outfit) do
                if v.itemName == data.name then
                    INVENTORY.Raccourci.PlayAnim(v.itemName)
                    Wait(1300)
                    if not v.equip then
                        v.equip = true
                        for type, value in pairs(data.metadatas.data) do
                            INVENTORY.ChangeClothOutfit(type, value)
                        end
                    else
                        v.equip = false
                        local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                        local male = false -- Définit une variable 'male' à false par défaut
                        
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if male  then
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
                    end
                end
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
        else
            INVENTORY.Raccourci.PlayAnim("outfit")
            INVENTORY.UI.Outfit.outfitEkip = true
            INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
            TriggerServerEvent('inventory:server:updateOutfit', data.metadatas)
            Wait(5000)
            for type, value in pairs(data.metadatas.data) do
                INVENTORY.ChangeClothOutfit(type, value)
            end
            INVENTORY.UI.Outfit.outfitEkip = true
        end
    else
        local nibard = false
        for k, v in pairs(ConfigShared.Outfit) do
            if v.itemName == data.name then
                nibard = true
                INVENTORY.Raccourci.PlayAnim(v.itemName)
                Wait(1300)
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
            end
        end
       if not nibard then
            Wait(5000)

            INVENTORY.UI.Outfit.outfitEkip = false
            INVENTORY.Raccourci.PlayAnim("pants")
            for k, v in pairs(ConfigShared.Outfit) do
                local male = false -- Définit une variable 'male' à false par défaut
                
                if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                    male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                end
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
       end
    end
    -- INVENTORY.SyncOufit()

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
    Wait(2000)
end)

RegisterNetEvent("inventory:client:syncRaccourci", function (key, data)
    INVENTORY.UI.Player.PinItem[key] = data
end)