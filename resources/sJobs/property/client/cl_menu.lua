local myRank = "user"

local STAFF_LICENSES = {
    ['license:bf139851ff0558418e7d868f7cbf277ea9ff75a7'] = true,
    ['license:73d4f1a73b5dff9b6e8cb84e760f896c1f8c7aa8'] = true,
    ['license:447802f342a61a65447c68653f28b4386cf2548b'] = true,
    ['license:25d5bde27845d3a0954e70a3fc71e9885380719e'] = true,
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData and not ESX.GetPlayerData().identifier do
        Citizen.Wait(50)
    end
    if STAFF_LICENSES[ESX.GetPlayerData().identifier] then
        myRank = "superadmin"
    end
end)

local function canDeleteProperty()
    if myRank == "superadmin" then return true end
    local job = PROPERTY["getJob"] and PROPERTY["getJob"]() or nil
    if not job then return false end
    return job.name == "immo" and tostring(job.grade_name or ""):lower() == "boss"
end

PROPERTY["handleMenu"] = function(property)
    if temptable then temptable = nil end

    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    if property.building then
        local coords = GetEntityCoords(PlayerPedId())

        PROPERTY["owned"] = false
        PROPERTY["coOwned"] = false
        PROPERTY["seller"] = false
        TriggerServerEvent("property:requestBuilding", property.building)

        RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", "Liste des propriétés", 1, 100))
        RMenu.Add('property', 'select', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Location long terme"))
        RMenu.Add('property', 'visit', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Location long terme"))
        RMenu.Add('property', 'visitChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'visit'), "Propriété", "Location long terme"))
        RMenu.Add('property', 'sell', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "À qui voulez-vous louer ?"))
        RMenu.Add('property', 'sellChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'sell'), "Propriété", "Combien de temps ?"))
        RMenu.Add('property', 'myInventory', RageUI.CreateSubMenu(RMenu:Get('property', 'select'), "Propriété", "Que voulez-vous y mettre ?"))
        RMenu.Add('property', 'renew', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Renouvelement de votre propriété"))
        RMenu.Add('property', 'mailboxes', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Boîtes aux lettres"))

        for name, menu in pairs(RMenu['property']) do
            RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
        end

        RMenu:Get('property', "select").Closed = function()
            PROPERTY["owned"] = false
            PROPERTY["coOwned"] = false
            PROPERTY["seller"] = false
        end

        RMenu:Get('property', "main").Closed = function()
            PROPERTY["menuOpenned"] = false

            RMenu:Delete('property', 'main')
            RMenu:Delete('property', 'select')
            RMenu:Delete('property', 'visit')
            RMenu:Delete('property', 'visitChoose')
            RMenu:Delete('property', 'sell')
            RMenu:Delete('property', 'sellChoose')
            RMenu:Delete('property', 'myInventory')
            RMenu:Delete('property', 'renew')
            RMenu:Delete('property', 'mailboxes')
        end

        if PROPERTY["menuOpenned"] then
            PROPERTY["menuOpenned"] = false
            return
        else
            RageUI.CloseAll()

            PROPERTY["menuOpenned"] = true
            RageUI.Visible(RMenu:Get('property', 'main'), true)
        end

        PROPERTY["buildingDataLoaded"] = false
        TriggerServerEvent("garage:generateBase")

        while not PROPERTY["buildingDataLoaded"] do
            Citizen.Wait(100)
        end

        local myPropertys = {}
        for k,v in pairs(PROPERTY["buildingData"]) do
            if v.owned or v.coOwned then
                table.insert(myPropertys, v)
            end
        end

        local searchTxt = ""

        local function matchFilter(v)
            if not v then return false end
            if searchTxt == nil or searchTxt == "" then return true end
            local key = string.lower(tostring(searchTxt))
            local name = string.lower(tostring(v.name or ""))
            if string.find(name, key, 1, true) then return true end
            if v.price and string.find(tostring(v.price), searchTxt, 1, true) then return true end
            if v.id and string.find(tostring(v.id), searchTxt, 1, true) then return true end
            return false
        end

        Citizen.CreateThread(function()
            while PROPERTY["menuOpenned"] do
                Wait(1)

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                    RageUI.CloseAll()
                    PROPERTY["menuOpenned"] = false
                end

                RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                    RageUI.ButtonWithStyle("Recherche", "Filtrer par nom, prix ou ID", {RightLabel = (searchTxt ~= "" and ("🔎 "..searchTxt) or "🔎")}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local t = UTILS.KeyboardInput("Entrez un mot-clé (nom, prix ou ID)", searchTxt, 25)
                            if t ~= nil then
                                searchTxt = tostring(t)
                            end
                        end
                    end)

                    if searchTxt ~= "" then
                        RageUI.ButtonWithStyle("Effacer le filtre", nil, {RightLabel = "✖"}, true, function(_, _, Selected)
                            if Selected then
                                searchTxt = ""
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle("Boîtes aux lettres", "Déposer du courrier dans un appartement du building, ou relever le vôtre", {RightLabel = "✉️"}, true, function() end, RMenu:Get('property', 'mailboxes'))

                    if #myPropertys > 0 then
                        for k,v in pairs(myPropertys) do
                            if matchFilter(v) then
                                local RL = v.owned and "🏠"
                                if v.coOwned then
                                    RL = v.coOwned and "🔑"
                                end
                                RageUI.ButtonWithStyle(v.name.. " - " ..v.price.. " $/semaine", nil, {RightLabel = RL}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if temptable == nil then temptable = {} end
                                        TriggerServerEvent("property:request", v.id)
                                        temptable = v
                                    end
                                end, RMenu:Get('property', 'select'))
                            end
                        end
                    end

                    if #PROPERTY["buildingData"] > 1 then
                        RageUI.Separator("")
                    end

                    for k,v in pairs(PROPERTY["buildingData"]) do
                        if not v.owned and not v.coOwned and matchFilter(v) then
                            if v.someone then
                                RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if temptable == nil then temptable = {} end
                                        TriggerServerEvent("property:request", v.id)
                                        temptable = v
                                    end
                                end, RMenu:Get('property', 'select'))
                            else
                                RageUI.ButtonWithStyle(v.name.. " - " ..v.price.. " $/semaine", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if temptable == nil then temptable = {} end
                                        TriggerServerEvent("property:request", v.id)
                                        temptable = v
                                    end
                                end, RMenu:Get('property', 'select'))
                            end
                        end
                    end

                end)

                -- Boites aux lettres du building : un bouton par appartement.
                -- Les appartements du joueur sont listes en premier.
                RageUI.IsVisible(RMenu:Get('property', 'mailboxes'), true, true, true, function()
                    RageUI.ButtonWithStyle("Recherche", "Filtrer par nom ou ID", {RightLabel = (searchTxt ~= "" and ("🔎 "..searchTxt) or "🔎")}, true, function(_, _, Selected)
                        if Selected then
                            local t = UTILS.KeyboardInput("Entrez un mot-clé (nom ou ID)", searchTxt, 25)
                            if t ~= nil then searchTxt = tostring(t) end
                        end
                    end)

                    local function mailboxButton(v, mine)
                        RageUI.ButtonWithStyle(v.name, mine and "Relever votre courrier" or "Déposer un objet (5 kg max, pas d'argent)", {RightLabel = mine and "🏠 ✉️" or "✉️"}, true, function(_, _, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false
                                TriggerServerEvent("inventory:server:openMailbox", v.id)
                            end
                        end)
                    end

                    for _, v in pairs(myPropertys) do
                        if matchFilter(v) then mailboxButton(v, true) end
                    end
                    if #myPropertys > 0 then RageUI.Separator("") end
                    for _, v in pairs(PROPERTY["buildingData"]) do
                        if not v.owned and not v.coOwned and matchFilter(v) then
                            mailboxButton(v, false)
                        end
                    end
                end, function() end)

                RageUI.IsVisible(RMenu:Get('property', 'select'), true, true, true, function()

                    if PROPERTY["returnProperty"] and GetDistanceBetweenCoords(PROPERTY["returnPropertyCoords"], GetEntityCoords(PlayerPedId()), true) < 10.0 and PROPERTY["returnPropertyId"] == PROPERTY["propertyIdr"] then
                        RageUI.ButtonWithStyle("Retourner dans la propriété", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false

                                PROPERTY["returnProperty"] = false
                                TriggerServerEvent("property:enter", {
                                    id = PROPERTY["propertyIdr"],
                                })
                            end
                        end)
                    else
                        if PROPERTY["owned"] or PROPERTY["coOwned"] then
                            RageUI.ButtonWithStyle("Entrer dans la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    PROPERTY["menuOpenned"] = false

                                    PROPERTY["returnProperty"] = false

                                    TriggerServerEvent("property:enter", temptable)
                                end
                            end)

                            if PROPERTY["garageData"].type == 2 then
                                RageUI.ButtonWithStyle("Entrer dans le garage", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false

                                        PROPERTY["returnProperty"] = false

                                        TriggerServerEvent("property:enterGarage", temptable)
                                    end
                                end)
                                RageUI.ButtonWithStyle("Ranger mon véhicule", nil, { RightLabel = "✅" },true, function(Hovered, Active, Selected)
                                    if Selected then
                                        local veh = GetPlayersLastVehicle(PlayerPedId(), 1)
                                        DeleteEntity(veh)
                                        ESX.ShowNotification("~g~Vous avez rangé votre véhicule !")
                                    end
                                end)
                            end

                            if PROPERTY["timeWarning"] then
                                RageUI.ButtonWithStyle("Renouveler la propriété", nil, {RightLabel = "💳"}, true, function(Hovered, Active, Selected)
                                end, RMenu:Get('property', 'renew'))

                                RageUI.Separator(PROPERTY["timeWarning"])
                            else
                                RageUI.Separator("Expire le "..PROPERTY["expireDate"])
                            end

                        else
                            if PROPERTY["seller"] then
                                RageUI.ButtonWithStyle("Louer", nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        tempplayer = {
                                            serverId = GetPlayerServerId(PlayerId()),
                                        }
                                    end
                                end, RMenu:Get('property', 'sellChoose'))

                                RageUI.ButtonWithStyle("Visiter", nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        PROPERTY["visitors"] = {}
                                    end
                                end, RMenu:Get('property', 'visit'))

                                if canDeleteProperty() then
                                    RageUI.ButtonWithStyle("~r~Supprimer la propriété", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent("property:deleteProperty", {
                                                propertyId = temptable.id,
                                            })

                                            RageUI.CloseAll()
                                            PROPERTY["menuOpenned"] = false
                                        end
                                    end)
                                end
                            else
                                if not PROPERTY["ownerExist"] then
                                    RageUI.ButtonWithStyle("Louer", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            tempplayer = {
                                                serverId = GetPlayerServerId(PlayerId()),
                                            }
                                        end
                                    end, RMenu:Get('property', 'sellChoose'))
                                else
                                    RageUI.Separator("Cet appartement est déja réservé !")
                                end

                                if PROPERTY["ownerExist"] and IsPoliceLt() then
                                    RageUI.ButtonWithStyle("👮 Voir l'identité du locataire", nil, {RightLabel = "→→→"}, true, function(_, _, Selected)
                                        if Selected then
                                            ESX.TriggerServerCallback("property:getTenantIdentity", function(data)
                                                if not data or not data.ok then
                                                    ESX.ShowNotification("~r~Accès refusé.")
                                                    return
                                                end
                                                if not data.found then
                                                    ESX.ShowNotification("~c~Aucun locataire enregistré.")
                                                    return
                                                end
                                                local online = data.online and " ~g~(en ville)" or " ~c~(hors ligne)"
                                                ESX.ShowNotification(("Locataire: ~y~%s %s~s~%s"):format(data.firstname or "?", data.lastname or "?", online))
                                            end, property.id)
                                        end
                                    end)
                                end

                                if PROPERTY["lastRinged"][temptable.id] == nil then PROPERTY["lastRinged"][temptable.id] = 0 end
                                RageUI.ButtonWithStyle("Sonner", nil, {RightLabel = PROPERTY["lastRinged"][temptable.id] > GetGameTimer() and "⌛" or '🔔'}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerEvent("sound:play", "dingdong", 0.10)
                                        if GetGameTimer() > PROPERTY["lastRinged"][temptable.id] then
                                            PROPERTY["lastRinged"][temptable.id] = GetGameTimer() + 10 * 1000
                                            TriggerServerEvent("property:ring", temptable)

                                            RageUI.CloseAll()
                                            PROPERTY["menuOpenned"] = false
                                        end
                                    end
                                end)

                                if canDeleteProperty() then
                                    RageUI.ButtonWithStyle("~r~Supprimer la propriété", nil, {}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent("property:deleteProperty", {
                                                propertyId = property.id,
                                            })

                                            RageUI.CloseAll()
                                            PROPERTY["menuOpenned"] = false
                                        end
                                    end)
                                end
                            end
                        end
                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'myInventory'), true, true, true, function()

                    RageUI.ButtonWithStyle("~c~Source inconnue", nil, {RightLabel = "~c~"..ESX.Math.GroupDigits(playerDirty).."$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = UTILS.KeyboardInput("Combien voulez-vous déposer d'argent liquide ?", "", 30)
                            amount = tonumber(amount)

                            TriggerServerEvent("property:deposit", {
                                propertyId = temptable.id,
                                type = "dirty",
                                amount = amount,
                                letterbox = true,
                            })
                        end
                    end)

                    if UTILS.TableCount(PROPERTY["myInventory"]) < 1 then
                        RageUI.ButtonWithStyle("Vide", nil, {}, true, function() end)
                    elseif UTILS.TableCount(PROPERTY["myInventory"]) > 0 then
                        if inventoryIndex == nil then inventoryIndex = 1 end
                        RageUI.ButtonWithStyle("Filtre d'objets", nil, {RightLabel = "← "..PROPERTY["categories"][inventoryIndex].." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if inventoryIndex - 1 < 1 then
                                        inventoryIndex = #PROPERTY["categories"]
                                    else
                                        inventoryIndex = inventoryIndex - 1
                                    end

                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if inventoryIndex + 1 > #PROPERTY["categories"] then
                                        inventoryIndex = 1
                                    else
                                        inventoryIndex = inventoryIndex + 1
                                    end

                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)

                        for k, v in pairs(PROPERTY["myInventory"]) do
                            local w = UTILS.getWeightOfThis(v.name, v.count)
                            if w <= 3.0 then
                                if PROPERTY["categories"][inventoryIndex] == 'Nourriture' then
                                    if cfg_inventory.foodItems[v.name] then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                elseif PROPERTY["categories"][inventoryIndex] == 'Armes' then
                                    if string.sub(v.name, 1, string.len("WEAPON_")) == "WEAPON_" then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                elseif PROPERTY["categories"][inventoryIndex] == 'Papiers' then
                                    if cfg_inventory.papersItems[v.name] then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                else
                                    if v.label == v.olabel then
                                        RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                if v.count > 1 then
                                                    local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                    amount = tonumber(amount)

                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = amount,
                                                        letterbox = true,
                                                    })
                                                else
                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = 1,
                                                        letterbox = true,
                                                    })
                                                end
                                            end
                                        end)
                                    else
                                        RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                if v.count > 1 then
                                                    local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                    amount = tonumber(amount)

                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = amount,
                                                        letterbox = true,
                                                    })
                                                else
                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = 1,
                                                        letterbox = true,
                                                    })
                                                end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'sell'), true, true, true, function()

                    for i,l in ipairs(GetActivePlayers()) do
                        if GetPlayerServerId(PlayerId()) == GetPlayerServerId(l) then
                            RageUI.ButtonWithStyle("Joueur #"..GetPlayerServerId(l), nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    local coords = GetEntityCoords(GetPlayerPed(l))
                                    DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                    DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                end

                                if Selected then
                                    if tempplayer == nil then
                                        tempplayer = {
                                            serverId = GetPlayerServerId(l),
                                        }
                                    end
                                end
                            end, RMenu:Get('property', 'sellChoose'))
                        end
                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'renew'), true, true, true, function()

                    if currentIndex == nil then currentIndex = 1 end
                    RageUI.List("Durée de la location", PROPERTY["allowedTimes"], currentIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        currentIndex = Index
                        if Selected then
                            print("temps choisi", PROPERTY["allowedTimes"][currentIndex])
                        end
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("~g~Recevoir la facture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:sendBilling", {
                                propertyId = temptable.id,
                                serverId = GetPlayerServerId(PlayerId()),
                                time = currentIndex,
                            })

                            currentIndex = nil
                            tempplayer = nil
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'sellChoose'), true, true, true, function()

                    if currentIndex == nil then currentIndex = 1 end
                    RageUI.List("Durée de la location", PROPERTY["allowedTimes"], currentIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        currentIndex = Index
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("~g~Envoyer la facture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:sendBilling", {
                                propertyId = temptable.id,
                                serverId = tempplayer.serverId,
                                time = currentIndex,
                            })

                            currentIndex = nil
                            tempplayer = nil
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'visit'), true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter des visiteurs", nil, {RightLabel = "🔑"}, true, function(Hovered, Active, Selected) end, RMenu:Get('property', 'visitChoose'))

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("Entrer dans la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:visit", {
                                propertyId = temptable.id,
                                visitors = PROPERTY["visitors"],
                            })

                            PROPERTY["visitors"] = {}
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'visitChoose'), true, true, true, function()

                    for i,l in ipairs(GetActivePlayers()) do
                        if GetPlayerServerId(PlayerId()) ~= GetPlayerServerId(l) and IsEntityVisible(GetPlayerPed(l)) then
                            if PROPERTY["visitors"][GetPlayerServerId(l)] then
                                RageUI.ButtonWithStyle("~c~Joueur #"..GetPlayerServerId(l), "~c~Appuyez pour retirer", {RightLabel = "DÉJÀ AJOUTÉ"}, true, function(Hovered, Active, Selected)
                                    if Active then
                                        local coords = GetEntityCoords(GetPlayerPed(l))
                                        DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                        DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                    end

                                    if Selected then
                                        if PROPERTY["visitors"][GetPlayerServerId(l)] then
                                            PROPERTY["visitors"][GetPlayerServerId(l)] = nil
                                        end
                                    end
                                end)
                            else
                                RageUI.ButtonWithStyle("Joueur #"..GetPlayerServerId(l), nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Active then
                                        local coords = GetEntityCoords(GetPlayerPed(l))
                                        DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                        DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                    end

                                    if Selected then
                                        if not PROPERTY["visitors"][GetPlayerServerId(l)] then
                                            PROPERTY["visitors"][GetPlayerServerId(l)] = {
                                                serverId = GetPlayerServerId(l),
                                            }
                                        end
                                    end
                                end)
                            end
                        end
                    end

                end)
            end
        end)
    else
        local coords = GetEntityCoords(PlayerPedId())

        PROPERTY["owned"] = false
        PROPERTY["coOwned"] = false
        PROPERTY["seller"] = false
        PROPERTY["waitingRequestData"] = true
        TriggerServerEvent("property:request", property.id)

        while PROPERTY["waitingRequestData"] do
            Citizen.Wait(100)
        end

        RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", "Liste des propriétés", 1, 100))
        RMenu.Add('property', 'select', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", PROPERTY["propertyName"]))
        RMenu.Add('property', 'visit', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", PROPERTY["propertyName"]))
        RMenu.Add('property', 'visitChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'visit'), "Propriété", PROPERTY["propertyName"]))
        RMenu.Add('property', 'sell', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "À qui voulez-vous louer ?"))
        RMenu.Add('property', 'sellChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'sell'), "Propriété", "Combien de temps ?"))
        RMenu.Add('property', 'myInventory', RageUI.CreateSubMenu(RMenu:Get('property', 'select'), "Propriété", "Que voulez-vous y mettre ?"))
        RMenu.Add('property', 'renew', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Renouvelement de votre propriété"))
        RMenu:Get('property', "main").Closed = function()
            PROPERTY["menuOpenned"] = false

            RMenu:Delete('property', 'main')
            RMenu:Delete('property', 'select')
            RMenu:Delete('property', 'visit')
            RMenu:Delete('property', 'visitChoose')
            RMenu:Delete('property', 'sell')
            RMenu:Delete('property', 'sellChoose')
            RMenu:Delete('property', 'myInventory')
            RMenu:Delete('property', 'myLetterbox')
            RMenu:Delete('property', 'renew')
        end

        for name, menu in pairs(RMenu['property']) do
            RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
        end

        if PROPERTY["menuOpenned"] then
            PROPERTY["menuOpenned"] = false
            return
        else
            RageUI.CloseAll()

            PROPERTY["menuOpenned"] = true
            RageUI.Visible(RMenu:Get('property', 'main'), true)
        end

        TriggerServerEvent("garage:generateBase")

        Citizen.CreateThread(function()
            while PROPERTY["menuOpenned"] do
                Wait(1)

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                    RageUI.CloseAll()
                    PROPERTY["menuOpenned"] = false
                end

                RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                    -- Boite aux lettres : tout le monde peut y deposer, seul le
                    -- locataire retire (droits verifies cote serveur).
                    RageUI.ButtonWithStyle("Boîte aux lettres", (PROPERTY["owned"] or PROPERTY["coOwned"]) and "Relever votre courrier" or "Déposer un objet (5 kg max, pas d'argent)", {RightLabel = "✉️"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false
                            TriggerServerEvent("inventory:server:openMailbox", property.id)
                        end
                    end)

                    if PROPERTY["owned"] or PROPERTY["coOwned"] then
                        RageUI.ButtonWithStyle("Entrer dans la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false

                                PROPERTY["returnProperty"] = false

                                TriggerServerEvent("property:enter", property)
                            end
                        end)

                        if PROPERTY["garageData"].type == 2 then
                            RageUI.ButtonWithStyle("Entrer dans le garage", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    PROPERTY["menuOpenned"] = false

                                    PROPERTY["returnProperty"] = false

                                    TriggerServerEvent("property:enterGarage", property)
                                end
                            end)
                            RageUI.ButtonWithStyle("Ranger mon véhicule", nil, { RightLabel = "✅" },true, function(Hovered, Active, Selected)
                                if Selected then
                                    local veh = GetPlayersLastVehicle(PlayerPedId(), 1)
                                    DeleteEntity(veh)
                                    ESX.ShowNotification("~g~Vous avez rangé votre véhicule !")
                                end
                            end)
                        end
                        print(ESX.GetPlayerData().rank)

                        if PROPERTY["timeWarning"] then
                            RageUI.ButtonWithStyle("Renouveler la propriété", nil, {RightLabel = "💳"}, true, function(Hovered, Active, Selected)
                            end, RMenu:Get('property', 'renew'))

                            RageUI.Separator(PROPERTY["timeWarning"])
                        else
                            RageUI.Separator("Expire le "..PROPERTY["expireDate"])
                        end
                        if canDeleteProperty() then
                            RageUI.ButtonWithStyle("~r~Supprimer la propriété", nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    TriggerServerEvent("property:deleteProperty", {
                                        propertyId = property.id,
                                    })

                                    RageUI.CloseAll()
                                    PROPERTY["menuOpenned"] = false
                                end
                            end)
                        end
                    else
                        if PROPERTY["seller"] then

                            RageUI.ButtonWithStyle("Louer", nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    tempplayer = {
                                        serverId = GetPlayerServerId(PlayerId()),
                                    }
                                end
                            end, RMenu:Get('property', 'sellChoose'))

                            RageUI.ButtonWithStyle("Visiter", nil, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PROPERTY["visitors"] = {}
                                end
                            end, RMenu:Get('property', 'visit'))

                            if not IsPropertyDoorForced(property.id) then
                                if playerJob == "police" or playerJob == "sheriff" then
                                    if CanDestroyProperty() then
                                        RageUI.ButtonWithStyle("~r~Forcer la porte", nil, {RightLabel = "🔨"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                TriggerServerEvent("property:police:tryForce", {
                                                    propertyId = property.id,
                                                })

                                                RageUI.CloseAll()
                                                PROPERTY["menuOpenned"] = false
                                            end
                                        end)
                                    else
                                        RageUI.ButtonWithStyle("~c~Forcer la porte", nil, {RightBadge = RageUI.BadgeStyle.Lock, RightLabel = "Grade insuffisant"}, true, function(Hovered, Active, Selected) end)
                                    end
                                else
                                    if playerCrew ~= "Aucun" then
                                        RageUI.ButtonWithStyle("~r~Forcer la porte", nil, {RightLabel = "🔨"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                TriggerServerEvent("property:gang:tryForce", {
                                                    propertyId = property.id,
                                                })

                                                RageUI.CloseAll()
                                                PROPERTY["menuOpenned"] = false
                                            end
                                        end)
                                    end
                                end
                            else
                                RageUI.ButtonWithStyle("Entrer dans la propriété ~r~(porte cassée)", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false

                                        PROPERTY["returnProperty"] = false

                                        TriggerServerEvent("property:isForced:enter", {
                                            propertyId = property.id,
                                        })
                                    end
                                end)
                            end

                            if canDeleteProperty() then
                                RageUI.ButtonWithStyle("~r~Supprimer la propriété", nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("property:deleteProperty", {
                                            propertyId = property.id,
                                        })

                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false
                                    end
                                end)
                            end
                        else
                            if not PROPERTY["ownerExist"] then
                                RageUI.ButtonWithStyle("Louer", nil, {}, true, function(Hovered, Active, Selected)
                                end, RMenu:Get('property', 'sellChoose'))
                            end

                            if PROPERTY["ownerExist"] and IsPoliceLt() then
                                RageUI.ButtonWithStyle("👮 Voir l'identité du locataire", nil, {RightLabel = "→→→"}, true, function(_, _, Selected)
                                    if Selected then
                                        ESX.TriggerServerCallback("property:getTenantIdentity", function(data)
                                            if not data or not data.ok then
                                                ESX.ShowNotification("~r~Accès refusé.")
                                                return
                                            end
                                            if not data.found then
                                                ESX.ShowNotification("~c~Aucun locataire enregistré.")
                                                return
                                            end
                                            local online = data.online and " ~g~(en ville)" or " ~c~(hors ligne)"
                                            ESX.ShowNotification(("Locataire: ~y~%s %s~s~%s"):format(data.firstname or "?", data.lastname or "?", online))
                                        end, property.id)
                                    end
                                end)
                            end

                            if PROPERTY["lastRinged"][property.id] == nil then PROPERTY["lastRinged"][property.id] = 0 end
                            RageUI.ButtonWithStyle("Sonner", nil, {RightLabel = PROPERTY["lastRinged"][property.id] > GetGameTimer() and "⌛" or '🔔'}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    TriggerEvent("sound:play", "dingdong", 0.10)
                                    if GetGameTimer() > PROPERTY["lastRinged"][property.id] then
                                        PROPERTY["lastRinged"][property.id] = GetGameTimer() + 10 * 1000
                                        TriggerServerEvent("property:ring", property)

                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false
                                    end
                                end
                            end)

                            if not IsPropertyDoorForced(property.id) then
                                if PROPERTY["getJob"]().name == "police" or PROPERTY["getJob"]().name == "sheriff" then
                                    if CanDestroyProperty() then
                                        RageUI.ButtonWithStyle("~r~Forcer la porte", nil, {RightLabel = "🔨"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                TriggerServerEvent("property:police:tryForce", {
                                                    propertyId = property.id,
                                                })

                                                RageUI.CloseAll()
                                                PROPERTY["menuOpenned"] = false
                                            end
                                        end)
                                    else
                                        RageUI.ButtonWithStyle("~c~Forcer la porte", nil, {RightBadge = RageUI.BadgeStyle.Lock, RightLabel = "Grade insuffisant"}, true, function(Hovered, Active, Selected) end)
                                    end
                                end
                            else
                                RageUI.ButtonWithStyle("Entrer dans la propriété ~r~(porte cassée)", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false

                                        PROPERTY["returnProperty"] = false

                                        TriggerServerEvent("property:isForced:enter", {
                                            propertyId = property.id,
                                        })
                                    end
                                end)
                            end
                            if canDeleteProperty() then
                                RageUI.ButtonWithStyle("~r~Supprimer la propriété", nil, {}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("property:deleteProperty", {
                                            propertyId = property.id,
                                        })

                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false
                                    end
                                end)
                            end
                        end
                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'sell'), true, true, true, function()

                    for i,l in ipairs(GetActivePlayers()) do

                            RageUI.ButtonWithStyle("Joueur #"..GetPlayerServerId(l), nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    local coords = GetEntityCoords(GetPlayerPed(l))
                                    DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                    DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                end

                                if Selected then
                                    if tempplayer == nil then
                                        tempplayer = {
                                            serverId = GetPlayerServerId(l),
                                        }
                                    end
                                end
                            end, RMenu:Get('property', 'sellChoose'))

                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'renew'), true, true, true, function()

                    if currentIndex == nil then currentIndex = 1 end
                    RageUI.List("Durée de la location", PROPERTY["allowedTimes"], currentIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        currentIndex = Index
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("~g~Recevoir la facture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:sendBilling", {
                                propertyId = property.id,
                                serverId = GetPlayerServerId(PlayerId()),
                                time = currentIndex,
                            })

                            currentIndex = nil
                            tempplayer = nil
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'sellChoose'), true, true, true, function()

                    if currentIndex == nil then currentIndex = 1 end
                    RageUI.List("Durée de la location", PROPERTY["allowedTimes"], currentIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        currentIndex = Index
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("~g~Recevoir la facture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:sendBilling", {
                                propertyId = property.id,
                                serverId = GetPlayerServerId(PlayerId()),
                                time = currentIndex,
                            })

                            currentIndex = nil
                            tempplayer = nil
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'myInventory'), true, true, true, function()

                    RageUI.ButtonWithStyle("~c~Source inconnue", nil, {RightLabel = "~c~"..ESX.Math.GroupDigits(playerDirty).."$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = UTILS.KeyboardInput("Combien voulez-vous déposer d'argent liquide ?", "", 30)
                            amount = tonumber(amount)

                            TriggerServerEvent("property:deposit", {
                                propertyId = temptable.id,
                                type = "dirty",
                                amount = amount,
                                letterbox = true,
                            })
                        end
                    end)

                    if UTILS.TableCount(PROPERTY["myInventory"]) < 1 then
                        RageUI.ButtonWithStyle("Vide", nil, {}, true, function() end)
                    elseif UTILS.TableCount(PROPERTY["myInventory"]) > 0 then
                        if inventoryIndex == nil then inventoryIndex = 1 end
                        RageUI.ButtonWithStyle("Filtre d'objets", nil, {RightLabel = "← "..PROPERTY["categories"][inventoryIndex].." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if inventoryIndex - 1 < 1 then
                                        inventoryIndex = #PROPERTY["categories"]
                                    else
                                        inventoryIndex = inventoryIndex - 1
                                    end

                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if inventoryIndex + 1 > #PROPERTY["categories"] then
                                        inventoryIndex = 1
                                    else
                                        inventoryIndex = inventoryIndex + 1
                                    end

                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)

                        for k, v in pairs(PROPERTY["myInventory"]) do
                            local w = UTILS.getWeightOfThis(v.name, v.count)
                            if w <= 3.0 then
                                if PROPERTY["categories"][inventoryIndex] == 'Nourriture' then
                                    if cfg_inventory.foodItems[v.name] then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                elseif PROPERTY["categories"][inventoryIndex] == 'Armes' then
                                    if string.sub(v.name, 1, string.len("WEAPON_")) == "WEAPON_" then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                elseif PROPERTY["categories"][inventoryIndex] == 'Papiers' then
                                    if cfg_inventory.papersItems[v.name] then
                                        if v.label == v.olabel then
                                            RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        else
                                            RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                                if Selected then
                                                    if v.count > 1 then
                                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                        amount = tonumber(amount)

                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = amount,
                                                            letterbox = true,
                                                        })
                                                    else
                                                        TriggerServerEvent("property:deposit", {
                                                            propertyId = temptable.id,
                                                            type = "item",
                                                            itemData = v,
                                                            amount = 1,
                                                            letterbox = true,
                                                        })
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                else
                                    if v.label == v.olabel then
                                        RageUI.ButtonWithStyle(v.label.." ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                if v.count > 1 then
                                                    local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                    amount = tonumber(amount)

                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = amount,
                                                        letterbox = true,
                                                    })
                                                else
                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = 1,
                                                        letterbox = true,
                                                    })
                                                end
                                            end
                                        end)
                                    else
                                        RageUI.ButtonWithStyle(v.olabel.." '"..v.label.."' ("..v.count..")", nil, {RightLabel = "~c~"..w.."KG~s~ →"}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                if v.count > 1 then
                                                    local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                                    amount = tonumber(amount)

                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = amount,
                                                        letterbox = true,
                                                    })
                                                else
                                                    TriggerServerEvent("property:deposit", {
                                                        propertyId = temptable.id,
                                                        type = "item",
                                                        itemData = v,
                                                        amount = 1,
                                                        letterbox = true,
                                                    })
                                                end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end

                end)

                RageUI.IsVisible(RMenu:Get('property', 'visit'), true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter des visiteurs", nil, {RightLabel = "🔑"}, true, function(Hovered, Active, Selected) end, RMenu:Get('property', 'visitChoose'))

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("Entrer dans la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:visit", {
                                propertyId = property.id,
                                visitors = PROPERTY["visitors"],
                            })

                            PROPERTY["visitors"] = {}
                        end
                    end)

                end)

                RageUI.IsVisible(RMenu:Get('property', 'visitChoose'), true, true, true, function()

                    for i,l in ipairs(GetActivePlayers()) do
                        if GetPlayerServerId(PlayerId()) ~= GetPlayerServerId(l) and IsEntityVisible(GetPlayerPed(l)) then
                            if PROPERTY["visitors"][GetPlayerServerId(l)] then
                                RageUI.ButtonWithStyle("~c~Joueur #"..GetPlayerServerId(l), "~c~Appuyez pour retirer", {RightLabel = "DÉJÀ AJOUTÉ"}, true, function(Hovered, Active, Selected)
                                    if Active then
                                        local coords = GetEntityCoords(GetPlayerPed(l))
                                        DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                        DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                    end

                                    if Selected then
                                        if PROPERTY["visitors"][GetPlayerServerId(l)] then
                                            PROPERTY["visitors"][GetPlayerServerId(l)] = nil
                                        end
                                    end
                                end)
                            else
                                RageUI.ButtonWithStyle("Joueur #"..GetPlayerServerId(l), nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Active then
                                        local coords = GetEntityCoords(GetPlayerPed(l))
                                        DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                        DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                    end

                                    if Selected then
                                        if not PROPERTY["visitors"][GetPlayerServerId(l)] then
                                            PROPERTY["visitors"][GetPlayerServerId(l)] = {
                                                serverId = GetPlayerServerId(l),
                                            }
                                        end
                                    end
                                end)
                            end
                        end
                    end

                end)
            end
        end)
    end
end

PROPERTY["exitMenu"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu.Add('property', 'custom', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Que voulez-vous faire ?"))

    RMenu:Get('property', "custom").Closed = function()
        PROPERTY["menuOpenned"] = false

        dontMind = false
    end

    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
        RMenu:Delete('property', 'custom')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    local dontMind = false

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 and not dontMind then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                if PROPERTY["garageData"] then
                    if PROPERTY["garageData"].type == 2 then
                        RageUI.ButtonWithStyle("Entrer dans le garage", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false

                                TriggerServerEvent("property:enterGarageFromProperty", {
                                    id = PROPERTY["propertyIdr"],
                                })
                            end
                        end)
                        RageUI.ButtonWithStyle("Ranger mon véhicule", nil, { RightLabel = "✅" },true, function(Hovered, Active, Selected)
                            if Selected then
                                local veh = GetPlayersLastVehicle(PlayerPedId(), 1)
                                DeleteEntity(veh)
                                ESX.ShowNotification("~g~Vous avez rangé votre véhicule !")
                            end
                        end)
                    end
                end

                if PROPERTY["garageSettings"] then
                    if PROPERTY["garageSettings"].helipad then
                        if not PROPERTY["hideList"]["helipadAccess"] then
                            RageUI.ButtonWithStyle("Monter à l'helipad", nil, {RightLabel = "🚁"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    PROPERTY["menuOpenned"] = false

                                    PROPERTY["returnProperty"], PROPERTY["returnPropertyCoords"], PROPERTY["returnPropertyId"] = true, vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].helipad.door.x, PROPERTY["interiors"][PROPERTY["propertyId"]].helipad.door.y, PROPERTY["interiors"][PROPERTY["propertyId"]].helipad.door.z), PROPERTY["propertyIdr"]

                                    SetEntityCoords(PlayerPedId(), PROPERTY["interiors"][PROPERTY["propertyId"]].helipad.door)
                                    TriggerServerEvent("property:exteriorExit", {
                                        propertyId = PROPERTY["propertyIdr"],
                                    })
                                end
                            end)
                        end
                    end
                end

                RageUI.ButtonWithStyle("Sortir de la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:exit")
                    end
                end)

                if #PROPERTY["playersInProperty"] > 1 then
                    RageUI.ButtonWithStyle("Sortir de la propriété avec tout le monde ("..#PROPERTY["playersInProperty"]..")", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:exitWithAll")

                            PROPERTY["playersInProperty"] = {}
                        end
                    end)
                end

                if PROPERTY["isVipInterior"] then
                    if PROPERTY["interiors"][PROPERTY["propertyId"]].editables and PROPERTY["owned"] and PROPERTY["interiors"][PROPERTY["propertyId"]].name == "Penthouse casino" then
                        RageUI.ButtonWithStyle("Personnalisation propriété", nil, {RightLabel = "🎨"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                dontMind = true
                            end
                        end, RMenu:Get('property', 'custom'))
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'custom'), true, true, true, function()

                for k,v in pairs(PROPERTY["interiors"][PROPERTY["propertyId"]].editables) do
                    if v.type == "interiorStyles" then
                        if v.index == nil then v.index = 1 end
                        if v.last == nil then v.last = '' end

                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if v.last ~= v.list[v.index].name then
                                    v.last = v.list[v.index].name
                                    v.list[v.index].action()

                                    PROPERTY["interiorSettings"]["interiorStyle"] = v.index
                                    TriggerServerEvent("property:updateInteriorSettings", {
                                        propertyId = PROPERTY["propertyIdr"],
                                        interiorSettings = PROPERTY["interiorSettings"],
                                    })
                                end

                                if IsControlJustPressed(0, 174) then
                                    if v.index - 1 < 1 then
                                        v.index = #v.list
                                    else
                                        v.index = v.index - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if v.index + 1 > #v.list then
                                        v.index = 1
                                    else
                                        v.index = v.index + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)
                    end

                    if v.type == "strip" then
                        if v.last == nil then v.last = false end
                        if v.toggle == nil then v.toggle = false end
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.toggle = not v.toggle
                                v.action(v.toggle)
                            end
                        end)
                    end

                    if v.type == "booze" then
                        if v.last == nil then v.last = false end
                        if v.toggle == nil then v.toggle = false end
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.toggle = not v.toggle
                                v.action(v.toggle)
                            end
                        end)
                    end

                    if v.type == "chairs" then
                        if v.last == nil then v.last = false end
                        if v.toggle == nil then v.toggle = false end
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.toggle = not v.toggle
                                v.action(v.toggle)
                            end
                        end)
                    end

                    if v.type == "bunkerEquipment" then
                        if v.last == nil then v.last = false end
                        if v.toggle == nil then v.toggle = false end
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.toggle = not v.toggle
                                v.action(v.toggle)
                            end
                        end)
                    end

                    if v.type == "casinoDecors" then
                        if v.index == nil then v.index = 1 end
                        if v.last == nil then v.last = '' end

                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if v.last ~= v.list[v.index].name then
                                    v.last = v.list[v.index].name
                                    v.list[v.index].action()

                                    PROPERTY["interiorSettings"]["interiorStyle"] = v.index
                                    TriggerServerEvent("property:updateInteriorSettings", {
                                        propertyId = PROPERTY["propertyIdr"],
                                        interiorSettings = PROPERTY["interiorSettings"],
                                    })
                                end

                                if IsControlJustPressed(0, 174) then
                                    if v.index - 1 < 1 then
                                        v.index = #v.list
                                    else
                                        v.index = v.index - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if v.index + 1 > #v.list then
                                        v.index = 1
                                    else
                                        v.index = v.index + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)
                    end

                    if v.type == "casinoDecorsBar" then
                        if v.index == nil then v.index = 1 end
                        if v.last == nil then v.last = '' end

                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if v.last ~= v.list[v.index].name then
                                    v.last = v.list[v.index].name
                                    v.list[v.index].action()

                                    PROPERTY["interiorSettings"]["interiorStyle"] = v.index
                                    TriggerServerEvent("property:updateInteriorSettings", {
                                        propertyId = PROPERTY["propertyIdr"],
                                        interiorSettings = PROPERTY["interiorSettings"],
                                    })
                                end

                                if IsControlJustPressed(0, 174) then
                                    if v.index - 1 < 1 then
                                        v.index = #v.list
                                    else
                                        v.index = v.index - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if v.index + 1 > #v.list then
                                        v.index = 1
                                    else
                                        v.index = v.index + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)
                    end
                end

            end)

        end
    end)
end

PROPERTY["chestMenu"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu.Add('property', 'coOwners', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Co-propriétaires"))
    RMenu.Add('property', 'coOwners_select', RageUI.CreateSubMenu(RMenu:Get('property', 'coOwners'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'coOwners_add', RageUI.CreateSubMenu(RMenu:Get('property', 'coOwners'), "Propriété", "Qui voulez-vous ajouter ?"))
    RMenu.Add('property', 'coOwners_add_perms', RageUI.CreateSubMenu(RMenu:Get('property', 'coOwners_add'), "Propriété", "Liste des permissions"))
    RMenu.Add('property', 'clothes', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Liste des tenues"))
    RMenu.Add('property', 'clothesList', RageUI.CreateSubMenu(RMenu:Get('property', 'clothes'), "Propriété", "Liste des tenues"))
    RMenu.Add('property', 'otherClothesList', RageUI.CreateSubMenu(RMenu:Get('property', 'clothes'), "Propriété", "Liste des tenues"))
    RMenu.Add('property', 'clothesChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'clothes'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'playersList', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Liste des personnes"))
    RMenu.Add('property', 'playersListChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'playersList'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'chest', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'inventory', RageUI.CreateSubMenu(RMenu:Get('property', 'chest'), "Propriété", "Votre inventaire"))
    RMenu.Add('property', 'webhooks', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Vos webhooks"))

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
        RMenu:Delete('property', 'coOwners')
        RMenu:Delete('property', 'coOwners_select')
        RMenu:Delete('property', 'coOwners_add')
        RMenu:Delete('property', 'coOwners_add_perms')
        RMenu:Delete('property', 'clothes')
        RMenu:Delete('property', 'clothesList')
        RMenu:Delete('property', 'otherClothesList')
        RMenu:Delete('property', 'clothesChoose')
        RMenu:Delete('property', 'playersList')
        RMenu:Delete('property', 'playersListChoose')
        RMenu:Delete('property', 'chest')
        RMenu:Delete('property', 'inventory')
        RMenu:Delete('property', 'webhooks')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    PROPERTY["coOwners"] = {}
    TriggerServerEvent("property:getCoOwners", PROPERTY["propertyIdr"])
    TriggerServerEvent("property:getChestInfoBase", PROPERTY["propertyIdr"])

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                if #PROPERTY["playersInProperty"] > 1 then
                    RageUI.ButtonWithStyle("Liste des personnes dans la propriété ("..#PROPERTY["playersInProperty"]..")", nil, {RightLabel = "📜"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PROPERTY["playersInPropertyList"] = {}
                            TriggerServerEvent("property:getPlayersInProperty", PROPERTY["propertyIdr"])
                        end
                    end, RMenu:Get('property', 'playersList'))
                end

                if PROPERTY["owned"] and not PROPERTY["coOwned"] and not PROPERTY["ringed"] then
                    local add = ""
                    if #PROPERTY["coOwners"] > 0 then
                        add = " ("..#PROPERTY["coOwners"]..")"
                    end
                    RageUI.ButtonWithStyle("Co-propriétaires"..add, nil, {RightLabel = "🔑"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PROPERTY["coOwners"] = {}
                            TriggerServerEvent("property:getCoOwners", PROPERTY["propertyIdr"])
                        end
                    end, RMenu:Get('property', 'coOwners'))
                end

                if not PROPERTY["hideList"]["chestAccess"] and not PROPERTY["ringed"] and not PROPERTY["visiting"] and PROPERTY["inventoryEnabled"] then
                    RageUI.ButtonWithStyle("Coffre", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('inventory:server:openProperty', PROPERTY["propertyIdr"])
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false
                        end
                    end)
                end

                if not PROPERTY["hideList"]["wearAccess"] and not PROPERTY["ringed"] and not PROPERTY["visiting"] then
                    RageUI.ButtonWithStyle("Garde-robe", nil, {RightLabel = "👔"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if PROPERTY["visiting"] then ESX.ShowNotification("~r~Indisponible en visite") return end

                            PROPERTY["coOwners"] = {}
                            TriggerServerEvent("property:getCoOwners", PROPERTY["propertyIdr"])
                            TriggerServerEvent("property:getOwnerLicense", {
                                propertyId = PROPERTY["propertyIdr"],
                            })
                        end
                    end, RMenu:Get('property', 'clothes'))
                end

                if PROPERTY["owned"] and not PROPERTY["coOwned"] and not PROPERTY["ringed"] then
                    RageUI.ButtonWithStyle("Webhooks", nil, {RightLabel = "🖨"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("property:getWebhooks", {
                                propertyId = PROPERTY["propertyIdr"],
                            })
                        end
                    end, RMenu:Get('property', 'webhooks'))
                end

                if PROPERTY["owned"] and not PROPERTY["coOwned"] and not PROPERTY["ringed"] then
                    RageUI.ButtonWithStyle("Décorations", nil, {RightLabel = "🗿"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false
                            ExecuteCommand("deco")
                        end
                    end)
                end

                if playerCrew ~= "Aucun" then
                    if PROPERTY["owned"] and not PROPERTY["coOwned"] and not PROPERTY["ringed"] then
                        if PROPERTY["interiorSettings"] and PROPERTY["interiorSettings"]["laboType"] ~= nil then
                            if PROPERTY["transformationAllowed"] then
                                RageUI.ButtonWithStyle("~r~Changer la drogue produite", nil, {RightLabel = "← "..PROPERTY["allLabos"][PROPERTY["laboChooseIndex"]].label.." →"}, true, function(Hovered, Active, Selected)
                                    if Active then
                                        if cooldown == nil then cooldown = 0 end

                                        if IsControlPressed(0, 174) and GetGameTimer() > cooldown then
                                            cooldown = GetGameTimer() + 170
                                            if PROPERTY["laboChooseIndex"] - 1 < 1 then
                                                PROPERTY["laboChooseIndex"] = #PROPERTY["allLabos"]
                                            else
                                                PROPERTY["laboChooseIndex"] = PROPERTY["laboChooseIndex"] - 1
                                            end
                                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                        end
                                        if IsControlPressed(0, 175) and GetGameTimer() > cooldown then
                                            cooldown = GetGameTimer() + 170
                                            if PROPERTY["laboChooseIndex"] + 1 > #PROPERTY["allLabos"] then
                                                PROPERTY["laboChooseIndex"] = 1
                                            else
                                                PROPERTY["laboChooseIndex"] = PROPERTY["laboChooseIndex"] + 1
                                            end
                                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                        end
                                    end

                                    if Selected then
                                        RageUI.CloseAll()
                                        PROPERTY["menuOpenned"] = false

                                        PROPERTY["interiorSettings"]["laboType"] = PROPERTY["allLabos"][PROPERTY["laboChooseIndex"]].type

                                        TriggerServerEvent("property:labo:editSecond", {
                                            newInteriorId = PROPERTY["allLabos"][PROPERTY["laboChooseIndex"]].interiorIndex,
                                            newInteriorSettings = PROPERTY["interiorSettings"],
                                            laboLabel = PROPERTY["allLabos"][PROPERTY["laboChooseIndex"]].label,
                                            propertyId = PROPERTY["propertyIdr"],
                                        })

                                        PROPERTY["playersInProperty"] = {}
                                    end
                                end)
                            end
                        end
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'webhooks'), true, true, true, function()

                RageUI.ButtonWithStyle("Logs de coffre", nil, {RightLabel = PROPERTY["webhooks"]["chest"] and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local webhook = UTILS.KeyboardInput("Indiquez le webhook", "", 30)
                        webhook = tostring(webhook)

                        PROPERTY["webhooks"]["chest"] = webhook

                        TriggerServerEvent("property:updateWebhooks", {
                            propertyId = PROPERTY["propertyIdr"],
                            webhooks = PROPERTY["webhooks"],
                        })
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'chest'), true, true, true, function()

                RageUI.ButtonWithStyle("Déposer", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local t = ESX.GetPlayerData()
                        PROPERTY["myInventory"]       = {}

                        for k,v in pairs(t.inventory) do
                            if v.count > 0 then
                                table.insert(PROPERTY["myInventory"], {
                                    label     = t.inventory[k].label,
                                    count     = t.inventory[k].count,
                                    value     = t.inventory[k].name,
                                    name      = t.inventory[k].label,
                                    limit     = t.inventory[k].limit,
                                })
                            end
                        end
                    end
                end, RMenu:Get('property', 'inventory'))

                RageUI.Separator(ESX.Math.Round(tonumber(PROPERTY["inventoryWeight"]), 2).."/"..tonumber(PROPERTY["inventoryCapacity"]).."KG")

                RageUI.ButtonWithStyle("~c~Source inconnue", nil, {RightLabel = "~c~"..ESX.Math.GroupDigits(PROPERTY["inventoryDirtyMoney"]).."$"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = UTILS.KeyboardInput("Combien voulez-vous retirer d'argent liquide ?", "", 30)
                        amount = tonumber(amount)

                        TriggerServerEvent("property:withdraw", {
                            propertyId = PROPERTY["propertyIdr"],
                            type = "dirty",
                            amount = amount,
                        })
                    end
                end)

                if UTILS.TableCount(PROPERTY["inventory"]) < 1 then
                    RageUI.ButtonWithStyle("Coffre vide", nil, {}, true, function() end)
                elseif UTILS.TableCount(PROPERTY["inventory"]) > 0 then
                    if filterIndex == nil then filterIndex = 1 end
                    RageUI.ButtonWithStyle("Filtre d'objets", nil, {RightLabel = "← "..PROPERTY["categories"][filterIndex].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if filterIndex - 1 < 1 then
                                    filterIndex = #PROPERTY["categories"]
                                else
                                    filterIndex = filterIndex - 1
                                end

                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if IsControlJustPressed(0, 175) then
                                if filterIndex + 1 > #PROPERTY["categories"] then
                                    filterIndex = 1
                                else
                                    filterIndex = filterIndex + 1
                                end

                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                        end
                    end)

                    for k, v in pairs(PROPERTY["inventory"]) do
                        if PROPERTY["categories"][filterIndex] == 'Armes' then
                            if string.sub(v.name, 1, string.len("WEAPON_")) == "WEAPON_" then
                                RageUI.ButtonWithStyle(v.label.." ("..ESX.Math.GroupDigits(v.count)..")", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if v.count > 1 then
                                            local amount = UTILS.KeyboardInput("Combien voulez-vous retirer ?", "", 30)
                                            amount = tonumber(amount)

                                            TriggerServerEvent("property:withdraw", {
                                                propertyId = PROPERTY["propertyIdr"],
                                                type = "item",
                                                itemData = v,
                                                amount = amount,
                                                capacity = 25,
                                            })
                                        else
                                            TriggerServerEvent("property:withdraw", {
                                                propertyId = PROPERTY["propertyIdr"],
                                                type = "item",
                                                itemData = v,
                                                amount = 1,
                                                capacity = 25,
                                            })
                                        end
                                    end
                                end)
                            end
                        else
                            RageUI.ButtonWithStyle(v.label.." ("..ESX.Math.GroupDigits(v.count)..")", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if v.count > 1 then
                                        local amount = UTILS.KeyboardInput("Combien voulez-vous retirer ?", "", 30)
                                        amount = tonumber(amount)

                                        TriggerServerEvent("property:withdraw", {
                                            propertyId = PROPERTY["propertyIdr"],
                                            type = "item",
                                            itemData = v,
                                            amount = amount,
                                            capacity = 25,
                                        })
                                    else
                                        TriggerServerEvent("property:withdraw", {
                                            propertyId = PROPERTY["propertyIdr"],
                                            type = "item",
                                            itemData = v,
                                            amount = 1,
                                            capacity = 25,
                                        })
                                    end
                                end
                            end)
                        end
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'inventory'), true, true, true, function()

                RageUI.ButtonWithStyle("~c~Source inconnue", nil, {RightLabel = "~c~"..ESX.Math.GroupDigits(PROPERTY["blackMoney"]).."$"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer d'argent liquide ?", "", 30)
                        amount = tonumber(amount)

                        TriggerServerEvent("property:deposit", {
                            propertyId = PROPERTY["propertyIdr"],
                            type = "dirty",
                            amount = amount,
                        })
                    end
                end)

                if UTILS.TableCount(PROPERTY["myInventory"]) < 1 then
                    RageUI.ButtonWithStyle("Vide", nil, {}, true, function() end)
                elseif UTILS.TableCount(PROPERTY["myInventory"]) > 0 then
                    if inventoryIndex == nil then inventoryIndex = 1 end
                    RageUI.ButtonWithStyle("Filtre d'objets", nil, {RightLabel = "← "..PROPERTY["categories"][inventoryIndex].." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if inventoryIndex - 1 < 1 then
                                    inventoryIndex = #PROPERTY["categories"]
                                else
                                    inventoryIndex = inventoryIndex - 1
                                end

                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if IsControlJustPressed(0, 175) then
                                if inventoryIndex + 1 > #PROPERTY["categories"] then
                                    inventoryIndex = 1
                                else
                                    inventoryIndex = inventoryIndex + 1
                                end

                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                        end
                    end)

                    for k, v in pairs(PROPERTY["myInventory"]) do
                        if PROPERTY["categories"][inventoryIndex] == 'Armes' then
                            if string.sub(v.name, 1, string.len("WEAPON_")) == "WEAPON_" then
                                RageUI.ButtonWithStyle(v.label.." ("..ESX.Math.GroupDigits(v.count)..")", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if v.count > 1 then
                                            local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                            amount = tonumber(amount)

                                            TriggerServerEvent("property:deposit", {
                                                propertyId = PROPERTY["propertyIdr"],
                                                type = "item",
                                                itemData = v,
                                                amount = amount,
                                            })
                                        else
                                            TriggerServerEvent("property:deposit", {
                                                propertyId = PROPERTY["propertyIdr"],
                                                type = "item",
                                                itemData = v,
                                                amount = 1,
                                            })
                                        end
                                    end
                                end)
                            end
                        else
                            RageUI.ButtonWithStyle(v.label.." ("..ESX.Math.GroupDigits(v.count)..")", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if v.count > 1 then
                                        local amount = UTILS.KeyboardInput("Combien voulez-vous déposer ?", "", 30)
                                        amount = tonumber(amount)

                                        TriggerServerEvent("property:deposit", {
                                            propertyId = PROPERTY["propertyIdr"],
                                            type = "item",
                                            itemData = v,
                                            amount = amount,
                                        })
                                    else
                                        TriggerServerEvent("property:deposit", {
                                            propertyId = PROPERTY["propertyIdr"],
                                            type = "item",
                                            itemData = v,
                                            amount = 1,
                                        })
                                    end
                                end
                            end)
                        end
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'playersList'), true, true, true, function()

                RageUI.ButtonWithStyle("Vous", nil, {}, true, function(Hovered, Active, Selected)
                    if Active then
                        for i,l in ipairs(GetActivePlayers()) do
                            if GetPlayerServerId(PlayerId()) == GetPlayerServerId(l) and IsEntityVisible(GetPlayerPed(l)) then
                                local coords = GetEntityCoords(GetPlayerPed(l))
                                DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                            end
                        end
                    end
                end)

                if UTILS.TableCount(PROPERTY["playersInPropertyList"]) > 0 then
                    for k,v in pairs(PROPERTY["playersInPropertyList"]) do
                        if v.serverId ~= GetPlayerServerId(PlayerId()) then
                            RageUI.ButtonWithStyle("Joueur #"..v.serverId, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if temptable == nil then temptable = {} end
                                    temptable = v
                                end

                                if Active then
                                    for i,l in ipairs(GetActivePlayers()) do
                                        if v.serverId == GetPlayerServerId(l) and IsEntityVisible(GetPlayerPed(l)) then
                                            local coords = GetEntityCoords(GetPlayerPed(l))
                                            DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                            DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                        end
                                    end
                                end
                            end, RMenu:Get('property', 'playersListChoose'))
                        end
                    end
                else
                    RageUI.Separator("Personne n'est dans la propriété avec vous")
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'playersListChoose'), true, true, true, function()

                RageUI.ButtonWithStyle("Virer", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:kick", {
                            propertyId = PROPERTY["propertyIdr"],
                            serverId = temptable.serverId,
                        })
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'clothes'), true, true, true, function()
                RageUI.ButtonWithStyle("Votre garde-robe", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("property:getMyClothes")
                        PROPERTY["calledClothes"] = GetGameTimer() + 1 * 60 * 1000
                    end
                end, RMenu:Get('property', 'clothesList'))
            end)

            RageUI.IsVisible(RMenu:Get('property', 'otherClothesList'), true, true, true, function()

                for k,v in pairs(PROPERTY["otherPlayersClothes"]) do
                    RageUI.ButtonWithStyle("Tenue #"..k.." '"..v.label.."'", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if tempdata == nil then tempdata = {} end
                            tempdata = v

                            want_delete = false
                        end
                    end, RMenu:Get('property', 'clothesChoose'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'clothesList'), true, true, true, function()

                for k,v in pairs(PROPERTY["myClothes"]) do
                    RageUI.ButtonWithStyle("Tenue #"..k.." '"..v.label.."'", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if tempdata == nil then tempdata = {} end
                            if want_delete == nil then want_delete = false end
                            tempdata = v

                            want_delete = false
                        end
                    end, RMenu:Get('property', 'clothesChoose'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'clothesChoose'), true, true, true, function()

                RageUI.ButtonWithStyle("Porter", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerEvent('skinchanger:loadClothes', skin, json.decode(tempdata.tenue))
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                        end)
                    end
                end)

                RageUI.ButtonWithStyle("Renommer", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local rename = UTILS.KeyboardInput("Quel nom voulez-vous donner à votre tenue ?", "Quel nom voulez-vous donner à votre tenue ?", "", 100)
                        if tostring(rename) ~= nil then
                            TriggerServerEvent('clotheshop:renameClothes', tempdata.id, rename)
                        end
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false
                    end
                end)

                if not want_delete then
                    RageUI.ButtonWithStyle("~r~Supprimer", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            want_delete = true
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~r~Supprimer", nil, {RightLabel = "~r~Appuyez pour confirmer"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('clotheshop:deleteClothes', tempdata.id)
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'coOwners'), true, true, true, function()

                RageUI.ButtonWithStyle("Ajouter un co-propriétaire", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["playersInPropertyList"] = {}
                        TriggerServerEvent("property:getPlayersInProperty", PROPERTY["propertyIdr"])
                    end
                end, RMenu:Get('property', 'coOwners_add'))

                RageUI.Separator("")

                if UTILS.TableCount(PROPERTY["coOwners"]) > 0 then
                    for k,v in pairs(PROPERTY["coOwners"]) do
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if temptable == nil then temptable = {} end
                                temptable = v

                                local perms = {}
                                for i,l in pairs(v.permissions) do
                                    perms[l.name] = l.toggle
                                end
                                temptable.prms = perms
                            end
                        end, RMenu:Get('property', 'coOwners_select'))
                    end
                else
                    RageUI.Separator("Aucun co-propriétaire pour le moment")
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'coOwners_select'), true, true, true, function()

                RageUI.ButtonWithStyle("Nom ou pseudonyme", nil, {RightLabel = temptable.name}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local name = UTILS.KeyboardInput("Entrez le nouveau nom du co-propriétaire (pseudonyme)", "", 20)
                        name = tostring(name)

                        temptable.name = name

                        TriggerServerEvent("property:updateCoOwnerName", {
                            propertyId = PROPERTY["propertyIdr"],
                            license = temptable.license,
                            newName = name,
                        })
                    end
                end)

                for k,v in pairs(PROPERTY["permissionsList"]) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = temptable.prms[v.type] and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            temptable.prms[v.type] = not temptable.prms[v.type]

                            for i,l in pairs(temptable.permissions) do
                                if l.name == v.type then
                                    l.toggle = not l.toggle
                                end
                            end

                            TriggerServerEvent("property:updateCoOwnerPerms", {
                                propertyId = PROPERTY["propertyIdr"],
                                license = temptable.license,
                                permissions = temptable.permissions,
                            })
                        end
                    end)
                end

                RageUI.Separator("")

                RageUI.ButtonWithStyle("~r~Supprimer", nil, {RightLabel = "~r~→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("property:deleteCoOwner", {
                            propertyId = PROPERTY["propertyIdr"],
                            license = temptable.license,
                        })
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'coOwners_add'), true, true, true, function()

                if UTILS.TableCount(PROPERTY["playersInPropertyList"]) > 0 then
                    for k,v in pairs(PROPERTY["playersInPropertyList"]) do
                        if v.serverId ~= GetPlayerServerId(PlayerId()) then
                            RageUI.ButtonWithStyle("Joueur #"..v.serverId, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if temptable == nil then temptable = {} end
                                    temptable = v
                                end

                                if Active then
                                    for i,l in ipairs(GetActivePlayers()) do
                                        if v.serverId == GetPlayerServerId(l) and IsEntityVisible(GetPlayerPed(l)) then
                                            local coords = GetEntityCoords(GetPlayerPed(l))
                                            DrawLine(GetEntityCoords(PlayerPedId()), coords, 135, 105, 247, 255)
                                            DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 255, 117, 31, 225, true, true)
                                        end
                                    end
                                end
                            end, RMenu:Get('property', 'coOwners_add_perms'))
                        end
                    end
                else
                    RageUI.Separator("Personne n'est dans la propriété avec vous")
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'coOwners_add_perms'), true, true, true, function()

                if PROPERTY["currentCOName"] == nil then PROPERTY["currentCOName"] = "Inconnu" end
                RageUI.ButtonWithStyle("Nom ou pseudonyme", nil, {RightLabel = PROPERTY["currentCOName"]}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local name = UTILS.KeyboardInput("Entrez le nom du co-propriétaire (pseudonyme)", "", 20)
                        name = tostring(name)

                        PROPERTY["currentCOName"] = name
                    end
                end)

                for k,v in pairs(PROPERTY["permissionsList"]) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            v.toggle = not v.toggle
                        end
                    end)
                end

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Ajouter ce co-propriétaire", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local permissions = {}
                        for k,v in pairs(PROPERTY["permissionsList"]) do
                            table.insert(permissions, {
                                name = v.type,
                                toggle = v.toggle,
                            })
                        end

                        TriggerServerEvent("property:addCoOwner", {
                            name = PROPERTY["currentCOName"],
                            serverId = temptable.serverId,
                            propertyId = PROPERTY["propertyIdr"],
                            permissions = permissions,
                        })

                        PROPERTY["currentCOName"] = nil
                        PROPERTY["permissionsList"] = {
                            {
                                name = "Accès au coffre",
                                type = "chestAccess",
                                toggle = false,
                            },
                            {
                                name = "Accès à la garde-robe",
                                type = "wearAccess",
                                toggle = false,
                            },
                        }

                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false
                    end
                end)

            end)
        end
    end)
end

PROPERTY["garageMenu"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu.Add('property', 'vehiclesPlacement', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'vehicleChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'vehiclesPlacement'), "Propriété", "Quel véhicule voulez-vous mettre ?"))

    -- Le sous-menu de placement recree un vehicule fantome et y warp le joueur
    -- a CHAQUE survol d'une place ou d'un vehicule. Le detecteur "changement
    -- de vehicule" d'antisbire (event SUNAC:SetVehiclePreview) kick au 3e
    -- handle en 10 s : on se declare comme preview le temps du placement.
    local function setPlacementPreview(state)
        TriggerEvent('SUNAC:SetVehiclePreview', 'property_placement', state == true)
    end

    RMenu:Get('property', "vehiclesPlacement").Closed = function()
        SetEntityCoords(PlayerPedId(), coords)

        for i,l in pairs(spawnedVehicles) do
            DeleteEntity(l)
        end
        setPlacementPreview(false)
    end
    RMenu:Get('property', "vehicleChoose").Closed = function()
        SetEntityCoords(PlayerPedId(), coords)

        for i,l in pairs(spawnedVehicles) do
            DeleteEntity(l)
        end
    end

    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false
        setPlacementPreview(false)

        RMenu:Delete('property', 'main')
        RMenu:Delete('property', 'vehiclesPlacement')
        RMenu:Delete('property', 'vehicleChoose')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Entrer dans la propriété", nil, {RightLabel = "🚪"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        PROPERTY["returnProperty"] = false

                        TriggerServerEvent("property:enterFromGarage", {
                            id = PROPERTY["propertyId"],
                        })
                    end
                end)

                if PROPERTY["owned"] then
                    RageUI.ButtonWithStyle("Organiser le placement", nil, {RightLabel = "⚙"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            setPlacementPreview(true)
                            ClearAreaOfVehicles(PROPERTY["garages"][PROPERTY["garageInterior"]].places[1].pos, 150.0, false, false, false, false, false)

                            for k,v in pairs(PROPERTY["spawnedVehicles"]) do
                                DeleteEntity(v)
                            end
                            if spawnedVehicles then
                                for k,v in pairs(spawnedVehicles) do
                                    DeleteEntity(v)
                                end
                            end
                        end
                    end, RMenu:Get('property', 'vehiclesPlacement'))
                end

                RageUI.ButtonWithStyle("Sortir du garage", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:exit")
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'vehiclesPlacement'), true, true, true, function()

                if last == nil then last = 0 end
                if spawnedVehicles == nil then spawnedVehicles = {} end
                for k,v in pairs(PROPERTY["garages"][PROPERTY["garageInterior"]].places) do
                    if not PROPERTY["garageSettings"].placement then PROPERTY["garageSettings"].placement = {} end
                    if not PROPERTY["garageSettings"].placement[k] then
                        PROPERTY["garageSettings"].placement[k] = {
                            plate = "LIBRE"
                        }
                    end
                    RageUI.ButtonWithStyle("Place #"..k, nil, {RightLabel = PROPERTY["garageSettings"].placement[k].plate}, true, function(Hovered, Active, Selected)
                        if Active then
                            if last ~= k then
                                last = k

                                Citizen.CreateThread(function()
                                    for i,l in pairs(spawnedVehicles) do
                                        DeleteEntity(l)
                                    end

                                    RequestModel(GetHashKey("sultanrs"))
                                    while not HasModelLoaded(GetHashKey("sultanrs")) do print("attente") Citizen.Wait(100) end
                                    local vehicle = CreateVehicle(GetHashKey("sultanrs"), v.pos.x, v.pos.y, v.pos.z, v.heading, false, false)
                                    while vehicle == nil do print("attends") Citizen.Wait(100) end
                                    SetEntityAlpha(vehicle, 175, true)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                    table.insert(spawnedVehicles, vehicle)
                                end)
                            end
                        end

                        if Selected then
                            TriggerServerEvent("property:getVehiclesMinimized")
                            if temptable == nil then temptable = {} end
                            v.index = k
                            temptable = v
                        end
                    end, RMenu:Get('property', 'vehicleChoose'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'vehicleChoose'), true, true, true, function()

                if last == nil then last = 0 end
                if spawnedVehicles == nil then spawnedVehicles = {} end
                for k,v in pairs(PROPERTY["myVehicles"]) do
                    if IsModelValid(v.model) and not IsThisModelAPlane(v.model) and not IsThisModelAHeli(v.model) then
                        RageUI.ButtonWithStyle(v.vehiclename, nil, {RightLabel = v.plate}, true, function(Hovered, Active, Selected)
                            if Active then
                                if last ~= k then
                                    last = k

                                    Citizen.CreateThread(function()
                                        for i,l in pairs(spawnedVehicles) do
                                            DeleteEntity(l)
                                        end

                                        RequestModel(v.model)
                                        while not HasModelLoaded(v.model) do
                                            Citizen.Wait(100)
                                        end
                                        local vehicle = CreateVehicle(v.model, temptable.pos.x, temptable.pos.y, temptable.pos.z, temptable.heading, false, false)
                                        SetEntityAlpha(vehicle, 175, true)
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        table.insert(spawnedVehicles, vehicle)
                                    end)
                                end
                            end

                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false

                                SetEntityCoords(PlayerPedId(), coords)

                                for i,l in pairs(spawnedVehicles) do
                                    DeleteEntity(l)
                                end
                                setPlacementPreview(false)

                                TriggerServerEvent("property:setPlacement", {
                                    propertyId = PROPERTY["propertyId"],
                                    vehiclePlate = v.plate,
                                    placement = temptable.index,
                                })
                            end
                        end)
                    end
                end

            end)
        end
    end)
end

PROPERTY["openSecretarty"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu.Add('property', 'wallText', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Écriture sur le mur"))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
        RMenu:Delete('property', 'wallText')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    PROPERTY["secretaryData"] = {}

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                if PROPERTY["owned"] then
                    if PROPERTY["interiors"][PROPERTY["propertyId"]].wallText then
                        if PROPERTY["interiors"][PROPERTY["propertyId"]].wallText.enabled then
                            RageUI.ButtonWithStyle("Écriture sur le mur", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('property', 'wallText'))
                        end
                    end
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'wallText'), true, true, true, function()

                if not PROPERTY["interiorSettings"].wallText then
                    PROPERTY["interiorSettings"].wallText = {
                        enabled = false,
                        text = "",
                        color = 0,
                        font = 0,
                    }
                end

                RageUI.ButtonWithStyle("Activer", nil, {RightLabel = PROPERTY["interiorSettings"].wallText.enabled and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["interiorSettings"].wallText.enabled = not PROPERTY["interiorSettings"].wallText.enabled
                        PROPERTY["interiors"][PROPERTY["propertyId"]].wallText.action(PROPERTY["interiorSettings"].wallText.enabled)

                        PROPERTY["interiorSettings"].wallText.enabled = PROPERTY["interiorSettings"].wallText.enabled
                        TriggerServerEvent("property:updateInteriorSettings", {
                            propertyId = PROPERTY["propertyIdr"],
                            interiorSettings = PROPERTY["interiorSettings"],
                        })
                    end
                end)

                if PROPERTY["interiorSettings"].wallText.enabled then
                    RageUI.ButtonWithStyle("Texte", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local text = UTILS.KeyboardInput("Définissez le texte à mettre sur le mur", "", 30)
                            text = tostring(text)

                            local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                            FinanceOrganization.Name.Set(text)

                            PROPERTY["interiorSettings"].wallText.text = text
                            TriggerServerEvent("property:updateInteriorSettings", {
                                propertyId = PROPERTY["propertyIdr"],
                                interiorSettings = PROPERTY["interiorSettings"],
                            })
                        end
                    end)

                    if PROPERTY["secretaryData"]["wallText"] == nil then PROPERTY["secretaryData"]["wallText"] = {} end
                    if PROPERTY["secretaryData"]["wallText"]["lastColor"] == nil then PROPERTY["secretaryData"]["wallText"]["lastColor"] = 0 end
                    RageUI.ButtonWithStyle("Couleur du texte", nil, {RightLabel = "← Couleur #"..PROPERTY["interiorSettings"].wallText.color.." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if PROPERTY["secretaryData"]["wallText"]["lastColor"] ~= PROPERTY["interiorSettings"].wallText.color then
                                PROPERTY["secretaryData"]["wallText"]["lastColor"] = PROPERTY["interiorSettings"].wallText.color

                                local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                                FinanceOrganization.Name.Set(nil, nil, PROPERTY["interiorSettings"].wallText.color)

                                TriggerServerEvent("property:updateInteriorSettings", {
                                    propertyId = PROPERTY["propertyIdr"],
                                    interiorSettings = PROPERTY["interiorSettings"],
                                })
                            end

                            if IsControlJustPressed(0, 174) then
                                if PROPERTY["interiorSettings"].wallText.color - 1 < 1 then
                                    PROPERTY["interiorSettings"].wallText.color = 7
                                else
                                    PROPERTY["interiorSettings"].wallText.color = PROPERTY["interiorSettings"].wallText.color - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if PROPERTY["interiorSettings"].wallText.color + 1 > 7 then
                                    PROPERTY["interiorSettings"].wallText.color = 1
                                else
                                    PROPERTY["interiorSettings"].wallText.color = PROPERTY["interiorSettings"].wallText.color + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                        end
                    end)

                    if PROPERTY["secretaryData"]["wallText"] == nil then PROPERTY["secretaryData"]["wallText"] = {} end
                    if PROPERTY["secretaryData"]["wallText"]["lastFont"] == nil then PROPERTY["secretaryData"]["wallText"]["lastFont"] = 0 end
                    RageUI.ButtonWithStyle("Police du texte", nil, {RightLabel = "← Police #"..PROPERTY["interiorSettings"].wallText.font.." →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if PROPERTY["secretaryData"]["wallText"]["lastFont"] ~= PROPERTY["interiorSettings"].wallText.font then
                                PROPERTY["secretaryData"]["wallText"]["lastFont"] = PROPERTY["interiorSettings"].wallText.font

                                local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                                FinanceOrganization.Name.Set(nil, nil, nil, PROPERTY["interiorSettings"].wallText.font)

                                TriggerServerEvent("property:updateInteriorSettings", {
                                    propertyId = PROPERTY["propertyIdr"],
                                    interiorSettings = PROPERTY["interiorSettings"],
                                })
                            end

                            if IsControlJustPressed(0, 174) then
                                if PROPERTY["interiorSettings"].wallText.font - 1 < 1 then
                                    PROPERTY["interiorSettings"].wallText.font = 7
                                else
                                    PROPERTY["interiorSettings"].wallText.font = PROPERTY["interiorSettings"].wallText.font - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if PROPERTY["interiorSettings"].wallText.font + 1 > 7 then
                                    PROPERTY["interiorSettings"].wallText.font = 1
                                else
                                    PROPERTY["interiorSettings"].wallText.font = PROPERTY["interiorSettings"].wallText.font + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                        end
                    end)
                end

            end)
        end
    end)
end

PROPERTY["openBoombox"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    PROPERTY["secretaryData"] = {}

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                if not JK.isPlaying then
                    RageUI.ButtonWithStyle("Jouer une musique", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local url = UTILS.KeyboardInput("Indiquez le lien YouTube de votre musique", "", 30)
                            url = tostring(url)

                            if string.len(url) > 3 then
                                JK.link = url

                                playersInArea = {}

                                for _, player in ipairs(GetActivePlayers()) do
                                    local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                    if dst < 50.0 then
                                        table.insert(playersInArea, GetPlayerServerId(player))
                                    end
                                end

                                TriggerServerEvent("property:getMusicTitle", {
                                    propertyId = PROPERTY["propertyIdr"],
                                })

                                TriggerServerEvent("property:soundStatus", {
                                    propertyId = PROPERTY["propertyIdr"],
                                }, 'play', {link = JK.link, volume = JK.volume}, playersInArea)
                            end
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Synchroniser la musique avec tout le monde", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            playersInArea = {}

                            for _, player in ipairs(GetActivePlayers()) do
                                local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                if dst < 50.0 then
                                    table.insert(playersInArea, GetPlayerServerId(player))
                                end
                            end

                            TriggerServerEvent("property:soundStatus", {
                                propertyId = PROPERTY["propertyIdr"],
                            }, 'sync', {link = JK.link, time = JK.sound:getTimeStamp("property_music")}, playersInArea)
                        end
                    end)
                    RageUI.ButtonWithStyle("Arrêter la musique", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            playersInArea = {}

                            for _, player in ipairs(GetActivePlayers()) do
                                local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                if dst < 50.0 then
                                    table.insert(playersInArea, GetPlayerServerId(player))
                                end
                            end

                            JK.link = nil
                            TriggerServerEvent("property:soundStatus", {
                                propertyId = PROPERTY["propertyIdr"],
                            }, 'stop', {}, playersInArea)
                        end
                    end)
                    RageUI.ButtonWithStyle("Mettre une autre musique", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local url = UTILS.KeyboardInput("Indiquez le lien YouTube de votre musique", "", 30)
                            url = tostring(url)

                            if string.len(url) > 3 then
                                JK.link = url

                                playersInArea = {}

                                for _, player in ipairs(GetActivePlayers()) do
                                    local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                    if dst < 50.0 then
                                        table.insert(playersInArea, GetPlayerServerId(player))
                                    end
                                end
                                TriggerServerEvent("property:soundStatus", {
                                    propertyId = PROPERTY["propertyIdr"],
                                }, 'play', {link = JK.link, volume = JK.volume}, playersInArea)
                            end
                        end
                    end)
                end
                if JK.link ~= nil then
                    if not JK.isResume then
                        RageUI.ButtonWithStyle("Mettre la musique sur lecture", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                playersInArea = {}

                                for _, player in ipairs(GetActivePlayers()) do
                                    local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                    if dst < 50.0 then
                                        table.insert(playersInArea, GetPlayerServerId(player))
                                    end
                                end

                                TriggerServerEvent("property:soundStatus", {
                                    propertyId = PROPERTY["propertyIdr"],
                                }, 'resume', {link = JK.link, volume = JK.volume}, playersInArea)
                                JK.isResume = true
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Mettre la musique sur pause", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                playersInArea = {}

                                for _, player in ipairs(GetActivePlayers()) do
                                    local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                    if dst < 50.0 then
                                        table.insert(playersInArea, GetPlayerServerId(player))
                                    end
                                end

                                TriggerServerEvent("property:soundStatus", {
                                    propertyId = PROPERTY["propertyIdr"],
                                }, 'pause', {link = JK.link, volume = JK.volume}, playersInArea)
                                JK.isResume = false
                            end
                        end)
                    end
                end
                if JK.link ~= nil then
                    RageUI.ButtonWithStyle("Monter/baisser le volume de la musique", "Appuyez sur ENTRER pour valider", {RightLabel = "← "..JK.volume.."% →"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 175) then
                                if JK.volume + 0.05 < 1.05 then
                                    JK.volume = ESX.Math.Round(JK.volume + 0.05, 2)
                                else
                                    JK.volume = 0.0
                                end
                            end
                            if IsControlJustPressed(0, 174) then
                                if JK.volume - 0.05 > -0.05 then
                                    JK.volume = ESX.Math.Round(JK.volume - 0.05, 2)
                                else
                                    JK.volume = 1.0
                                end
                            end
                        end

                        if Selected then
                            playersInArea = {}

                            for _, player in ipairs(GetActivePlayers()) do
                                local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)

                                if dst < 50.0 then
                                    table.insert(playersInArea, GetPlayerServerId(player))
                                end
                            end
                            TriggerServerEvent("property:soundStatus", {
                                propertyId = PROPERTY["propertyIdr"],
                            }, 'volume', {link = i, volume = JK.volume}, playersInArea)
                        end
                    end)
                end

            end)
        end
    end)
end

PROPERTY["openCasinoBar"] = function(list)
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", PROPERTY["propertyName"], 1, 100))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    PROPERTY["secretaryData"] = {}

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                for k,v in pairs(list) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.price}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            TriggerServerEvent("property:buy", {
                                propertyId = PROPERTY["propertyIdr"],
                                itemData = v,
                            })
                        end
                    end)
                end

            end)

        end
    end)
end

PROPERTY["openBilling"] = function(label, price, event, incoins, id)
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    RMenu.Add('property', 'main', RageUI.CreateMenu("Propriété", "Système de facturation", 1, 100))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 117, 31, 225)
    end

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                if incoins == false then
                    RageUI.Separator(label)
                    RageUI.Separator(ESX.Math.GroupDigits(price).."$")
                    RageUI.ButtonWithStyle("~y~Payer "..ESX.Math.GroupDigits(price).."$", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PROPERTY["menuOpenned"] = false
                            RageUI.CloseAll()

                            TriggerServerEvent("property:billing:accept")
                        end
                    end)
                else
                    RageUI.Separator(label)
                    RageUI.Separator(ESX.Math.GroupDigits(price / 10000).."")
                    RageUI.ButtonWithStyle("~y~Payer (COINS) "..ESX.Math.GroupDigits(price / 10000).."", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PROPERTY["menuOpenned"] = false
                            RageUI.CloseAll()

                            TriggerServerEvent("property:billing:accept:coins")
                        end
                    end)
                end

                RageUI.ButtonWithStyle("~r~Refuser de payer", nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["menuOpenned"] = false
                        RageUI.CloseAll()

                        TriggerServerEvent("property:billing:deny")
                    end
                end)

            end)
        end
    end)
end

PROPERTY["openLaboComputer"] = function()
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Laboratoire", "Options laboratoire", 1, 100))
    RMenu.Add('property', 'editDetector', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Laboratoire", "Configuration des détecteurs"))
    RMenu:Get('property', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'editDetector'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    local list, drugsToBuy = {}, {}
    ESX.TriggerServerCallback("property:labo:getComputerItems", function(info, drugsList)
        if info then
            list = info
            drugsToBuy = drugsList
        end
    end, {
        propertyId = PROPERTY["propertyIdr"],
    })

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                local buyedCount = 0
                local notBuyedCount = 0
                for k,v in pairs(list) do
                    if v.buyed then
                        buyedCount = buyedCount + 1
                        if v.type == "detector" then
                            RageUI.ButtonWithStyle(v.label, v.desc, {RightLabel = "~c~CONFIGURER →"}, true, function(Hovered, Active, Selected)
                            end, RMenu:Get('property', 'editDetector'))
                        else
                            RageUI.ButtonWithStyle(v.label, v.desc, {RightLabel = "~c~AUCUNE CONFIG"}, true, function(Hovered, Active, Selected) end)
                        end
                    else
                        notBuyedCount = notBuyedCount + 1
                    end
                end

                if buyedCount > 0 and notBuyedCount > 0 then
                    RageUI.Separator("")
                end

                for k,v in pairs(list) do
                    if not v.buyed then
                        RageUI.ButtonWithStyle(v.label, v.desc, {RightLabel = ESX.Math.GroupDigits(v.price).."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                PROPERTY["menuOpenned"] = false

                                TriggerServerEvent("property:labo:buyInteriorSetting", {
                                    propertyId = PROPERTY["propertyIdr"],
                                    type = v.type,
                                })
                            end
                        end)
                    end
                end

                RageUI.Separator("")

                for k,v in pairs(drugsToBuy) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = ESX.Math.GroupDigits(v.price).."$/u"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            local amount = UTILS.KeyboardInput("Combien voulez-vous acheter ?", "", 30)
                            amount = tonumber(amount)

                            if amount == nil then return end
                            if amount < 0 then return end

                            TriggerServerEvent("property:labo:buyDrugPrep", {
                                propertyId = PROPERTY["propertyIdr"],
                                name = v.name,
                                amount = amount,
                            })
                        end
                    end)
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'editDetector'), true, true, true, function()

                if index == nil then index = 1 end
                if dstList == nil then
                    dstList = {
                        [1] = 12.5,
                        [2] = 7.5,
                        [3] = 2.5,
                    }
                end

                RageUI.ButtonWithStyle("Distance de détection", "Appuyez pour sauvegarder", {RightLabel = "← "..dstList[index].."0 mètres →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if cooldown == nil then cooldown = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > cooldown then
                            cooldown = GetGameTimer() + 170
                            if index - 1 < 1 then
                                index = #dstList
                            else
                                index = index - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                        if IsControlPressed(0, 175) and GetGameTimer() > cooldown then
                            cooldown = GetGameTimer() + 170
                            if index + 1 > #dstList then
                                index = 1
                            else
                                index = index + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                    end

                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:labo:detector:updateDst", {
                            propertyId = PROPERTY["propertyIdr"],
                            newDistance = dstList[index],
                        })
                    end
                end)

            end)

        end
    end)
end

PROPERTY["openImportExport"] = function()
    print(3430)

    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('property', 'main', RageUI.CreateMenu("Laboratoire", "Import/export", 1, 100))
    RMenu:Get('property', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                PROPERTY["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Envoyer de la drogue en ville", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        local amount = UTILS.KeyboardInput("Combien voulez-vous en envoyer ?", "", 30)
                        amount = tonumber(amount)

                        if amount == nil then return end
                        if amount < 0 then return end

                        TriggerServerEvent("property:labo:importexport:send", {
                            propertyId = PROPERTY["propertyIdr"],
                            amount = amount,
                        })
                    end
                end)

            end)

        end
    end)
end

PROPERTY["openEditMode"] = function(directProp)
    if RMenu['property'] then
        for name, menu in pairs(RMenu['property']) do
            RMenu:Delete('property', name)
        end
    end

    RMenu.Add('property', 'main', RageUI.CreateMenu("Édition", "Que voulez-vous faire ?", 1, 100))
    RMenu.Add('property', 'propsShop', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Magasin de props", "Que voulez-vous acheter ?"))
    RMenu.Add('property', 'propsShopItems', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Magasin de props", "Que voulez-vous acheter ?"))
    RMenu.Add('property', 'propsMy', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Mes props", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'propsMyChoose', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Mes props", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'propsEdit', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Édition", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'lamps', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Lumières", "Que voulez-vous faire ?"))
    RMenu:Get('property', 'main'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'propsShop'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'propsShopItems'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'propsMy'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'propsMyChoose'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'propsEdit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', 'lamps'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        ClearSpawnedProps()

        RMenu:Delete('property', 'main')
        RMenu:Delete('property', 'propsShop')
        RMenu:Delete('property', 'propsShopItems')
        RMenu:Delete('property', 'propsMy')
        RMenu:Delete('property', 'propsMyChoose')
        RMenu:Delete('property', 'propsEdit')
        RMenu:Delete('property', 'lamps')
    end
    RMenu:Get('property', "propsShop").Closed = function()
        ClearSpawnedProps()
    end
    RMenu:Get('property', "propsShopItems").Closed = function()
        ClearSpawnedProps()
    end
    RMenu:Get('property', "propsMy").Closed = function()
        ClearSpawnedProps()
    end
    RMenu:Get('property', "propsMyChoose").Closed = function()
        ClearSpawnedProps()
    end
    RMenu:Get('property', "propsEdit").Closed = function()
        ClearSpawnedProps()
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true

        if directProp then
            if not directProp.rotation then
                directProp.rotation = { x = 0.0, y = 0.0, z = 0.0 }
            elseif type(directProp.rotation) == "vector3" then
                local rx, ry, rz = table.unpack(directProp.rotation)
                directProp.rotation = { x = rx, y = ry, z = rz }
            end

            tempPropsChoosed = directProp

            RageUI.Visible(RMenu:Get('property', 'propsEdit'), true)
        else
            RageUI.Visible(RMenu:Get('property', 'main'), true)
        end
    end

    local nlank = {}
    ESX.TriggerServerCallback("property:furniture:getPropsInProperty", function(propsPlacedHere)
        if propsPlacedHere then
            nlank = propsPlacedHere

            for k,v in pairs(nlank) do
                if PROPERTY["createdPropsByIndex"][v.id] then
                    v.entity = PROPERTY["createdPropsByIndex"][v.id]
                end
            end
        end
    end, {
        propertyId = PROPERTY["propertyIdr"],
    })

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Magasin de props", nil, {RightLabel = "🛒"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tempPropsShop = {}
                        ESX.TriggerServerCallback("property:furniture:getPropsShop", function(propsShop)
                            tempPropsShop = propsShop
                        end)
                    end
                end, RMenu:Get('property', 'propsShop'))

                RageUI.ButtonWithStyle("Mes props", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tempMyProps = {}
                        ESX.TriggerServerCallback("property:furniture:getMyProps", function(props)
                            tempMyProps = props
                        end)
                    end
                end, RMenu:Get('property', 'propsMy'))

                RageUI.Separator("")

                for k,v in pairs(nlank) do
                    RageUI.ButtonWithStyle("Props #"..k, nil, {RightLabel = "📜"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if #PROPERTY["createdProps"] > 0 then
                                for i,l in pairs(PROPERTY["createdProps"]) do
                                    if l.id == v.id then
                                        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                                        DrawLine(GetEntityCoords(v.entity), vector3(x, y, z), 255.0, 255.0, 255.0, 255)
                                    end
                                end
                            end
                        end

                        if Selected then
                            tempPropsChoosed = v
                            tempPropsChoosed.index = k
                            if not tempPropsChoosed.rotation then tempPropsChoosed.rotation = {
                                x = 0.0,
                                y = 0.0,
                                z = 0.0,
                            } else
                                if type(tempPropsChoosed.rotation) == "vector3" then
                                    local x,y,z = table.unpack(tempPropsChoosed.rotation)
                                    tempPropsChoosed.rotation = {
                                        x = x,
                                        y = y,
                                        z = z,
                                    }
                                end
                            end
                        end
                    end, RMenu:Get('property', 'propsEdit'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'lamps'), true, true, true, function()

                if data == nil then

                    data = {
                        colorR = 200.0,
                        colorG = 0.0,
                        colorB = 0.0,
                        distance = 11.0,
                        brightness = 0.005,
                        hardness = 0.0,
                        radius = 11.05,
                        falloff = 82.6,
                        RX = 2.1,
                        RY = -4.8,
                        RZ = -0.8,
                        CX = 185.69,
                        CY = -309.16,
                        CZ = 44.15,
                    }

                end

                DrawSpotLight(data.CX, data.CY, data.CZ, data.RX, data.RY, data.RZ, data.colorR, data.colorG, data.colorB, data.distance, data.brightness, data.hardness, data.radius, data.falloff)

                RageUI.ButtonWithStyle("C X "..data.CX, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CX = data.CX + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CX = data.CX - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("C Y "..data.CY, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CY = data.CY + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CY = data.CY - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("C Z "..data.CZ, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CZ = data.CZ + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.CZ = data.CZ - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("R X "..data.RX, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RX = data.RX + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RX = data.RX - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("R Y "..data.RY, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RY = data.RY + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RY = data.RY - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("R Z "..data.RZ, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RZ = data.RZ + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.RZ = data.RZ - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Distance "..data.distance, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.distance = data.distance + 0.05
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.distance = data.distance - 0.05
                        end
                    end
                end)

                RageUI.ButtonWithStyle("brightness "..data.brightness, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.brightness = data.brightness + 0.025
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.brightness = data.brightness - 0.025
                        end
                    end
                end)

                RageUI.ButtonWithStyle("hardness "..data.hardness, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.hardness = data.hardness + 0.35
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.hardness = data.hardness - 0.35
                        end
                    end
                end)

                RageUI.ButtonWithStyle("radius "..data.radius, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.radius = data.radius + 0.45
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.radius = data.radius - 0.45
                        end
                    end
                end)

                RageUI.ButtonWithStyle("falloff "..data.falloff, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.falloff = data.falloff + 1.0
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            data.falloff = data.falloff - 1.0
                        end
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'propsEdit'), true, true, true, function()

                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                DrawLine(GetEntityCoords(tempPropsChoosed.entity), vector3(x, y, z), 255.0, 255.0, 255.0, 255)

                RageUI.ButtonWithStyle("~r~Ranger", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:furniture:remove", {
                            propertyId = PROPERTY["propertyIdr"],
                            props = tempPropsChoosed,
                        })
                    end
                end)

                RageUI.Separator("")

                if doedList == nil then doedList = {} end
                if type(tempPropsChoosed.rotation) == "vector3" then
                    local x,y,z = table.unpack(tempPropsChoosed.rotation)
                    tempPropsChoosed.rotation = {
                        x = x,
                        y = y,
                        z = z,
                    }
                end

                print(type(tempPropsChoosed.rotation))

                RageUI.ButtonWithStyle("Rotation X", "🚧 Retirer le 'Fixer au sol' pour que la rotation s'effectue", {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.x = tempPropsChoosed.rotation.x + 5
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.x = tempPropsChoosed.rotation.x - 5
                        end

                        SetEntityRotation(tempPropsChoosed.entity, tempPropsChoosed.rotation.x, tempPropsChoosed.rotation.y, tempPropsChoosed.rotation.z)
                    end
                end)

                RageUI.ButtonWithStyle("Rotation Y", "🚧 Retirer le 'Fixer au sol' pour que la rotation s'effectue", {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.y = tempPropsChoosed.rotation.y + 5
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.y = tempPropsChoosed.rotation.y - 5
                        end

                        SetEntityRotation(tempPropsChoosed.entity, tempPropsChoosed.rotation.x, tempPropsChoosed.rotation.y, tempPropsChoosed.rotation.z)
                    end
                end)

                RageUI.ButtonWithStyle("Rotation Z", "🚧 Retirer le 'Fixer au sol' pour que la rotation s'effectue", {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.z = tempPropsChoosed.rotation.z + 5
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.rotation.z = tempPropsChoosed.rotation.z - 5
                        end

                        SetEntityRotation(tempPropsChoosed.entity, tempPropsChoosed.rotation.x, tempPropsChoosed.rotation.y, tempPropsChoosed.rotation.z)
                    end
                end)

                RageUI.ButtonWithStyle("X", nil, {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x + 0.05, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z)
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x - 0.05, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z)
                        end

                        SetEntityCoords(tempPropsChoosed.entity, vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z))
                    end
                end)

                RageUI.ButtonWithStyle("Y", nil, {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y + 0.05, tempPropsChoosed.coords.z)
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y - 0.05, tempPropsChoosed.coords.z)
                        end

                        SetEntityCoords(tempPropsChoosed.entity, vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z))
                    end
                end)

                RageUI.ButtonWithStyle("Hauteur", nil, {RightLabel = "← →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if timeout == nil then timeout = 0 end

                        if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z + 0.05)
                        end

                        if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                            timeout = GetGameTimer() + 76
                            tempPropsChoosed.coords = vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z - 0.05)
                        end

                        SetEntityCoords(tempPropsChoosed.entity, vector3(tempPropsChoosed.coords.x, tempPropsChoosed.coords.y, tempPropsChoosed.coords.z))
                    end
                end)

                if tempPropsChoosed.fixGround == nil then tempPropsChoosed.fixGround = true end
                RageUI.ButtonWithStyle("Fixer au sol", nil, {RightLabel = tempPropsChoosed.fixGround and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tempPropsChoosed.fixGround = not tempPropsChoosed.fixGround
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("~g~Sauvegarder mes modifications", nil, {RightLabel = "✅"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:furniture:saveEdits", {
                            propertyId = PROPERTY["propertyIdr"],
                            props = tempPropsChoosed,
                        })
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'propsMy'), true, true, true, function()

                for k,v in pairs(tempMyProps) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tempPropsData = v

                            tempCanPlace = false
                            tempPropsId = v.id

                            ESX.TriggerServerCallback("property:furniture:canPlaceProps", function(can)
                                tempCanPlace = can
                            end, {
                                propsId = v.id,
                            })
                        end
                    end, RMenu:Get('property', 'propsMyChoose'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'propsMyChoose'), true, true, true, function()

                if tempCanPlace then
                    RageUI.ButtonWithStyle("Poser", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            ClearSpawnedProps()

                            local plyCoords = GetEntityCoords(PlayerPedId())
                            local plyHeading = GetEntityHeading(PlayerPedId())

                            PROPERTY["pendingEditProp"] = {
                                id = tempPropsData.id,
                                model = tempPropsData.model,
                                propertyId = PROPERTY["propertyIdr"],
                            }

                            TriggerServerEvent("property:furniture:placeProps", {
                                model = tempPropsData.model,
                                id = tempPropsData.id,
                                propertyId = PROPERTY["propertyIdr"],
                                coords = vector3(plyCoords.x, plyCoords.y, plyCoords.z),
                                heading = plyHeading,
                                rotation = vector3(0.0, 0.0, 0.0),
                            })
                        end
                    end)
                else

                end

                RageUI.ButtonWithStyle("~r~Abandonner", "Supprimera définitivement le props de votre inventaire sans possibilité de le récupérer", {RightLabel = "🗑"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:furniture:tryDelete", {
                            model = tempPropsData.model,
                            id = tempPropsData.id,
                            propertyId = PROPERTY["propertyIdr"],
                        })
                    end
                end)

            end)

            RageUI.IsVisible(RMenu:Get('property', 'propsShop'), true, true, true, function()

                if not tempIndex then tempIndex = 1 end
                RageUI.ButtonWithStyle("Acheter via le modèle (1500$/u)", nil, {RightLabel = "💻"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        local model = UTILS.KeyboardInput("Indiquez le modèle que vous voulez acheter", "", 30)
                        model = tostring(model)

                        if model == nil then return end

                        if not IsModelValid(GetHashKey(model)) then
                            ESX.ShowNotification("~r~Modèle invalide")
                            return
                        end

                        ClearSpawnedProps()

                        local item = {
                            method = tempIndex,
                            name = model,
                            model = model,
                        }

                        TriggerServerEvent("property:furniture:tryBuyCustom", item)
                    end
                end)

                RageUI.Separator("")

                for k,v in pairs(tempPropsShop) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.emoji}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tempPropsShopItems = v.props
                            tempPropsShopIndex = k
                        end
                    end, RMenu:Get('property', 'propsShopItems'))
                end

            end)

            RageUI.IsVisible(RMenu:Get('property', 'propsShopItems'), true, true, true, function()

                for k,v in pairs(tempPropsShopItems) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.price > 0 and ESX.Math.GroupDigits(v.price).."$" or "GRATUIT"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if lastIndex == nil then lastIndex = 0 end
                            if lastIndex ~= k then
                                lastIndex = k
                                Citizen.CreateThread(function()
                                    CreateSpawnedObjectPreview(v.model)
                                end)
                            end
                        end

                        if Selected then
                            RageUI.CloseAll()
                            PROPERTY["menuOpenned"] = false

                            ClearSpawnedProps()

                            v.method = tempIndex
                            v.index = tempPropsShopIndex

                            TriggerServerEvent("property:furniture:tryBuy", v)
                        end
                    end)
                end

            end)

        end
    end)
end
