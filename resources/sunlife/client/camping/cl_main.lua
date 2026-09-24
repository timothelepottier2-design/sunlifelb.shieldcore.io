local ESX = exports['es_extended']:getSharedObject()

local function loadModel(model)
    local m = type(model) == 'string' and joaat(model) or model
    if not HasModelLoaded(m) then
        RequestModel(m)
        while not HasModelLoaded(m) do
            Wait(0)
        end
    end
    return m
end

local function spawnVendor()
    local m = loadModel(cfg_camping.Vendor.model)
    local c = cfg_camping.Vendor.coords

    local ped = CreatePed(0, m, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'camping_vendor_buy',
            icon = 'fa-solid fa-cart-shopping',
            label = 'Acheter matériel de camping',
            distance = 2.0,
            onSelect = function()
                local options = {}
                for itemName, data in pairs(cfg_camping.Items) do
                    options[#options + 1] = {
                        title = ('%s - $%s'):format(data.itemLabel, data.price),
                        description = "Acheter cet article",
                        onSelect = function()
                            local input = lib.inputDialog('Quantité', {
                                { type = 'number', label = 'Combien ?', default = 1, min = 1, max = 50 }
                            })
                            if not input or not input[1] then
                                return
                            end
                            TriggerServerEvent('camping:buyItem', itemName, input[1])
                        end
                    }
                end
                lib.registerContext({
                    id = 'camping_vendor_menu',
                    title = 'Vendeur camping',
                    options = options
                })
                lib.showContext('camping_vendor_menu')
            end
        }
    })
end

CreateThread(function()
    spawnVendor()

    local blip = AddBlipForCoord(cfg_camping.Vendor.coords.x, cfg_camping.Vendor.coords.y, cfg_camping.Vendor.coords.z)
    SetBlipSprite(blip, 280)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    AddTextEntry("BN_SUNLIFE_CAMPING_1", "Vendeur Camping")
    BeginTextCommandSetBlipName("BN_SUNLIFE_CAMPING_1")
    EndTextCommandSetBlipName(blip)
end)

local function startPlacement(itemName)
    local data = cfg_camping.Items[itemName]
    if not data then
        return
    end

    local model = loadModel(data.prop)
    local ped = PlayerPedId()

    local ghost = CreateObject(model, 0.0, 0.0, 0.0, false, false, false)
    SetEntityAlpha(ghost, 160, false)
    SetEntityCollision(ghost, false, false)
    FreezeEntityPosition(ghost, true)

    lib.showTextUI('[E] Placer  |  [BACKSPACE] Annuler', { position = 'top-center' })

    while true do
        Wait(0)

        local p = GetEntityCoords(ped)
        local f = GetEntityForwardVector(ped)
        local pos = p + f * 2.5

        SetEntityCoordsNoOffset(ghost, pos.x, pos.y, pos.z - 1.0, false, false, false)

        local heading = GetEntityHeading(ped)
        SetEntityHeading(ghost, heading)

        if IsControlJustPressed(0, 177) then
            lib.hideTextUI()
            DeleteObject(ghost)
            return false
        end

        if IsControlJustPressed(0, 38) then
            local dist = #(p - pos)
            if dist > cfg_camping.Place.maxDistanceFromPlayer then
                lib.notify({ type = 'error', description = "Trop loin." })
            else
                lib.hideTextUI()
                print(('^2[NETDIAG][OBJET]^7 %s cl_main.lua:111 CreateObject NETWORKED camping model=%s'):format(GetCurrentResourceName(), tostring(model)))
                local placed = CreateObject(model, pos.x, pos.y, pos.z - 1.05, true, true, true)
                SetEntityHeading(placed, heading)
                FreezeEntityPosition(placed, true)

                local netId = NetworkGetNetworkIdFromEntity(placed)
                SetNetworkIdCanMigrate(netId, true)

                TriggerServerEvent("camping:placedProp", netId, itemName)

                exports.ox_target:addLocalEntity(placed, {
                    {
                        name = 'camping_pickup_' .. tostring(netId),
                        icon = 'fa-solid fa-hand',
                        label = 'Récupérer',
                        distance = cfg_camping.Place.pickupDistance,
                        onSelect = function()
                            TriggerServerEvent('camping:pickupPlacedProp', netId, itemName)
                        end
                    }
                })

                DeleteObject(ghost)
                return true
            end
        end
    end
end

RegisterNetEvent('camping:useItem', function(itemName)
    local ok = startPlacement(itemName)
    if ok then
        TriggerServerEvent('esx:removeInventoryItem', itemName, 1)
    end
end)

RegisterNetEvent('camping:deleteEntityFallback', function(netId)
    if not NetworkDoesEntityExistWithNetworkId(netId) then
        return
    end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent and ent ~= 0 then
        DeleteEntity(ent)
    end
end)
