local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'boutique', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'boutique', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('boutique/' .. name, cb)
end

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getShtozaredObjtozect", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local UI_OPEN = false

local TESTDRIVE_POS = vector3(222.302917, -809.548157, 30.624828)
local TESTDRIVE_RADIUS = 30.0
local TESTDRIVE_DURATION = 60000

local testDriveVeh = nil

local function stopTestDrive()
    if testDriveVeh and DoesEntityExist(testDriveVeh) then
        DeleteVehicle(testDriveVeh)
    end
    testDriveVeh = nil
    local ped = PlayerPedId()
    SetEntityCoords(ped, TESTDRIVE_POS.x, TESTDRIVE_POS.y, TESTDRIVE_POS.z)
    ESX.ShowNotification("~y~Essai terminé")
    TriggerServerEvent('shop:testDrive:finished')
end

RegisterNetEvent('shop:open', function(payload)
  SetNuiFocus(true, true)
  UI_OPEN = true

  SendNUIMessage({
    action = 'open',
    data = payload or {}
  })
end)

RegisterNetEvent('shop:close', function()
  UI_OPEN = false
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })
end)

RegisterNetEvent('shop:updateBalance', function(bal)
  if bal and bal.coins ~= nil then
    SendNUIMessage({ action = 'updateCoins', coins = bal.coins })
  end
  if bal and (bal.loyaltyPoints ~= nil or bal.points ~= nil) then
    SendNUIMessage({
      action = 'updateLoyalty',
      loyaltyPoints = bal.loyaltyPoints or bal.points
    })
  end
end)

RegisterNetEvent('shop:coinOffer', function(offer)
  SendNUIMessage({ action = 'coinOffer', offer = offer or {} })
end)

RegisterNetEvent('shop:showPage', function(page, content)
  if page == 'admin' then

    SendNUIMessage({
      action = 'showPage',
      page = page,
      content = {
        title = content.title or "Administration - Stats",
        sales = content.sales or {}
      }
    })
  else

    SendNUIMessage({
      action = 'showPage',
      page = page,
      content = content or {}
    })
  end
end)

local _lastShopToggle = 0
local SHOP_TOGGLE_COOLDOWN = 2000

RegisterCommand('shop_open', function()
  local now = GetGameTimer()
  if (now - _lastShopToggle) < SHOP_TOGGLE_COOLDOWN then return end
  _lastShopToggle = now

  if not UI_OPEN then
    TriggerServerEvent('shop:requestOpen')
  else
    UI_OPEN = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
  end
end, false)

RegisterKeyMapping('shop_open', 'Ouvrir la boutique', 'keyboard', 'F1')

RegisterNUICallback('close', function(_, cb)
  UI_OPEN = false
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })
  cb({ ok = true })
end)

RegisterNUICallback('changePage', function(data, cb)
  local page = (data and data.page) or 'home'
  TriggerServerEvent('shop:requestPage', page)
  cb({ ok = true })
end)

RegisterNUICallback('buyItem', function(data, cb)

  TriggerServerEvent('shop:buyItem', data or {})
  cb({ ok = true })
end)

RegisterNUICallback('tryItem', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if #(coords - TESTDRIVE_POS) > TESTDRIVE_RADIUS then
        ESX.ShowNotification("~r~Tu dois être devant le parking cube pour tester ce véhicule")
        if cb then cb({ ok = false }) end
        return
    end

    UI_OPEN = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })

    TriggerServerEvent('shop:tryItem', data or {})

    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('setWishlist', function(data, cb)
  TriggerServerEvent('shop:wishlist', data or {})
  cb({ ok = true })
end)

RegisterNUICallback('limitedUpsert', function(data, cb)
    TriggerServerEvent('shop:limited:upsert', data)
    cb({ ok = true })
end)

RegisterNUICallback('limitedRemove', function(data, cb)
    TriggerServerEvent('shop:limited:remove', data)
    cb({ ok = true })
end)

RegisterNUICallback('limitedGet', function(data, cb)
    TriggerServerEvent('shop:limited:get', data)
    cb({ ok = true })
end)

RegisterNUICallback('giftItem', function(data, cb)
  TriggerServerEvent('shop:giftItem', data or {})
  cb({ ok = true })
end)

RegisterNetEvent('shop:gift:result', function(res)
  if not res then return end
  if res.coins ~= nil then
    SendNUIMessage({ action = 'updateCoins', coins = res.coins })
  end
  if res.loyaltyPoints ~= nil then
    SendNUIMessage({ action = 'updateLoyalty', loyaltyPoints = res.loyaltyPoints })
  end
end)

RegisterNUICallback('promoUpsert', function(data, cb)

  TriggerServerEvent('shop:promo:upsert', {
    id             = tonumber(data.id),
    discount_type  = tostring(data.discount_type or 'percent'),
    discount_value = tonumber(data.discount_value) or 0,
    currency       = tostring(data.currency or 'coins'),
    start_at       = tonumber(data.start_at) or 0,
    end_at         = tonumber(data.end_at) or 0,
    is_active      = data.is_active == true
  })
  if cb then cb({ ok = true }) end
end)

RegisterNUICallback('promoRemove', function(data, cb)

  TriggerServerEvent('shop:promo:remove', { id = tonumber(data.id) })
  if cb then cb({ ok = true }) end
end)

RegisterNUICallback('promoGet', function(data, cb)

  TriggerServerEvent('shop:promo:get', { id = tonumber(data.id) })
  if cb then cb({ ok = true }) end
end)

RegisterNetEvent('shop:promoInfo', function(payload)

  SendNUIMessage({
    action          = 'promoInfo',
    id              = tonumber(payload.id),
    discount_type   = payload.discount_type,
    discount_value  = tonumber(payload.discount_value) or 0,
    currency        = payload.currency,
    start_at        = tonumber(payload.start_at) or 0,
    end_at          = tonumber(payload.end_at) or 0,
    is_active       = payload.is_active == true,
    name            = payload.name
  })
end)

RegisterNetEvent('shop:promoUpdated', function(payload)

  SendNUIMessage({ action = 'promoUpdated', id = payload and payload.id or nil })
end)

RegisterNetEvent('boutique:purchaseSuccess')
AddEventHandler('boutique:purchaseSuccess', function(data)
    local payload = {
        action   = 'purchaseSuccess',
        item     = data and data.item or 'Achat',
        duration = (data and data.duration) or 3500
    }
    SendNUIMessage(payload)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30 * 60 * 1000)
        TriggerServerEvent("shop:claimPresenceReward")
    end
end)

RegisterNetEvent("boutique:usejetoncustom", function()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        oldProps = ESX.Game.GetVehicleProperties(veh)
        NetworkRequestControlOfEntity(veh)
        ESX.Game.SetVehicleProperties(veh, {
            modEngine = 3,
            modBrakes = 2,
            modTransmission = 2,
            modSuspension = 3,
            modTurbo = true
        })
        myCar = ESX.Game.GetVehicleProperties(veh)
        TriggerServerEvent("boutique:usejetoncustom", myCar)
    else
        ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
    end
end)

RegisterNUICallback('refreshDaily', function(data, cb)
    TriggerServerEvent('shop:refreshDaily')
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('dailyPreview', function(data, cb)
    TriggerServerEvent('shop:requestDailyPreview')
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('dailyRerollConfirm', function(data, cb)
    TriggerServerEvent('shop:refreshDaily')
    if cb then cb({ ok = true }) end
end)

RegisterNetEvent('shop:dailyPreview', function(payload)
    SendNUIMessage({
        action  = 'dailyPreview',
        preview = payload or { items = {}, cost = 500, canRefresh = false },
    })
end)

RegisterNetEvent('shop:dailyRefreshed', function(payload)

    SendNUIMessage({ action = 'dailyRerollResult', ok = true })

    SendNUIMessage({
        action  = 'showPage',
        page    = 'home',
        content = {
            title        = 'Daily Store',
            items        = (payload and payload.items) or {},
            dailySeconds = (payload and payload.dailySeconds) or nil,
        },
    })
end)

local accTest = nil
local ACC_TEST_DURATION = 10000

local function accDrawTimer(seconds)
    local txt = ("Test d'accessoire : Il reste %d seconde%s"):format(seconds, seconds > 1 and "s" or "")

    DrawRect(0.5, 0.935, 0.34, 0.055, 0, 0, 0, 170)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(0.5, 0.917)
end

local function accFinishTest()
    if not accTest then return end
    local t = accTest
    accTest = nil
    local original = type(t.original) == 'table' and t.original or {}

    -- Accessoire deja possede (achete ou d'origine) : on le laisse sur l'arme
    -- au lieu de le retirer puis le redonner (le chargeur etendu retombait a
    -- 30 balles en fin de test).
    local owned = false
    for _, comp in ipairs(original) do
        if comp == t.comp then owned = true break end
    end
    if not owned then
        RemoveWeaponComponentFromPed(PlayerPedId(), t.hash, GetHashKey(t.comp))
    end

    -- Remet les accessoires possedes (celui de la meme categorie a ete remplace
    -- par l'accessoire teste), une frame apres le retrait.
    CreateThread(function()
        Wait(0)
        if accTest then return end -- nouveau test lance : il restaurera a sa fin
        local ped = PlayerPedId()
        if not HasPedGotWeapon(ped, t.hash, false) then return end -- arme rangee : l'inventaire les remettra
        for _, comp in ipairs(original) do
            if type(comp) == 'string' and comp ~= '' and not HasPedGotWeaponComponent(ped, t.hash, GetHashKey(comp)) then
                GiveWeaponComponentToPed(ped, t.hash, GetHashKey(comp))
            end
        end
    end)
end

local function startAccTest(weapon, comp, original)
    local ped = PlayerPedId()
    local hash = GetHashKey(weapon)
    if not IsPedArmed(ped, 4) or GetSelectedPedWeapon(ped) ~= hash then
        ESX.ShowNotification("~r~Vous devez avoir l'arme en main pour tester.")
        return false
    end

    if accTest then accFinishTest() end

    GiveWeaponComponentToPed(ped, hash, GetHashKey(comp))
    accTest = { weapon = weapon, hash = hash, comp = comp, original = original or {}, endsAt = GetGameTimer() + ACC_TEST_DURATION }

    CreateThread(function()
        while accTest do
            Citizen.Wait(0)
            local p = PlayerPedId()

            if GetSelectedPedWeapon(p) ~= accTest.hash then
                accFinishTest()
                break
            end
            local remain = math.ceil((accTest.endsAt - GetGameTimer()) / 1000)
            if remain < 0 then remain = 0 end
            accDrawTimer(remain)
            if GetGameTimer() >= accTest.endsAt then
                accFinishTest()
                ESX.ShowNotification("~y~Fin de l'essai de l'accessoire")
                break
            end
        end
    end)
    return true
end

RegisterNUICallback('weaponAccOpen', function(_, cb)
    local w = exports.inventaire:getCurrentWeapon()
    if not w or not w.name or not w.metadatas then
        SendNUIMessage({ action = 'weaponAccList', ok = false, reason = 'noweapon' })
        if cb then cb({ ok = false }) end
        return
    end
    TriggerServerEvent('weaponAcc:request', { weapon = w.name, id = w.metadatas.id })
    if cb then cb({ ok = true }) end
end)

RegisterNetEvent('weaponAcc:list', function(weapon, id, catalog, current, owned)
    SendNUIMessage({
        action  = 'weaponAccList',
        ok      = true,
        weapon  = weapon,
        id      = id,
        catalog = catalog or {},
        current = current or {},
        owned   = owned or {},
    })
end)

RegisterNUICallback('weaponAccTest', function(data, cb)
    data = data or {}
    local ped = PlayerPedId()
    if not data.weapon or not data.componentID then
        if cb then cb({ ok = false }) end
        return
    end
    if not IsPedArmed(ped, 4) or GetSelectedPedWeapon(ped) ~= GetHashKey(data.weapon) then
        ESX.ShowNotification("~r~Vous devez avoir l'arme en main pour tester.")
        if cb then cb({ ok = false }) end
        return
    end

    UI_OPEN = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })

    startAccTest(data.weapon, data.componentID, data.owned)
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('weaponAccBuy', function(data, cb)
    TriggerServerEvent('weaponAcc:buy', data or {})
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('weaponAccRemove', function(data, cb)
    TriggerServerEvent('weaponAcc:remove', data or {})
    if cb then cb({ ok = true }) end
end)

RegisterNetEvent('weaponAcc:applied', function(weapon, id, category, componentID)
    exports.inventaire:SetWeaponAttachment(weapon, id, category, componentID, false)
    SendNUIMessage({ action = 'weaponAccUpdate', category = category, componentID = componentID, removed = false })
end)

RegisterNetEvent('weaponAcc:removed', function(weapon, id, category, componentID)
    exports.inventaire:SetWeaponAttachment(weapon, id, category, componentID, true)
    SendNUIMessage({ action = 'weaponAccUpdate', category = category, componentID = componentID, removed = true })
end)

RegisterNetEvent('shop:testDrive:start', function(model, pos, duration)
    if pos and pos.x and pos.y and pos.z then
        TESTDRIVE_POS = vector3(pos.x, pos.y, pos.z)
    end

    if testDriveVeh and DoesEntityExist(testDriveVeh) then
        DeleteVehicle(testDriveVeh)
        testDriveVeh = nil
    end

    local hash = GetHashKey(model)

    RequestModel(hash)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > timeout then
            ESX.ShowNotification("~r~Impossible de charger le véhicule d'essai")
            TriggerServerEvent('shop:testDrive:finished')
            return
        end
        Citizen.Wait(0)
    end

    local ped = PlayerPedId()

    print(('^5[NETDIAG][VEHICLE]^7 %s client.lua:527 CreateVehicle NETWORKED (testdrive) hash=%s'):format(GetCurrentResourceName(), tostring(hash)))
    local veh = CreateVehicle(hash, TESTDRIVE_POS.x, TESTDRIVE_POS.y, TESTDRIVE_POS.z, GetEntityHeading(ped), true, false)
    local netId = NetworkGetNetworkIdFromEntity(veh)
    if netId and netId ~= 0 then
        SetNetworkIdCanMigrate(netId, true)
    end
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(ped, veh, -1)

    testDriveVeh = veh

    SetModelAsNoLongerNeeded(hash)
    ESX.ShowNotification("~g~Tu as 60 secondes pour essayer le véhicule")

    local endTime = GetGameTimer() + (duration or TESTDRIVE_DURATION)
    CreateThread(function()
        while testDriveVeh == veh and GetGameTimer() < endTime do
            Citizen.Wait(0)
        end
        if testDriveVeh == veh then
            stopTestDrive()
        end
    end)
end)
