-- ============================================================================
--  Cahier de notes — client side
--
--  Bridge entre l'event serveur `cahier:open` et la NUI (cahier.html, chargé
--  dans index.html via iframe / DOM caché). Pure plomberie : pas de boucle,
--  pas de polling. La NUI gère 100% de la saisie et n'envoie qu'un payload
--  final au moment du Save / Close.
-- ============================================================================

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Wait(50)
    end
end)

local cahierOpen    = false
local currentId     = nil
local emoteActive   = false
local emoteProps    = {}
local emoteGen      = 0 -- invalide les keep-alive threads des anciens props

-- Constantes de l'emote "notepad" (extrait de
-- rg_core/client/dpemotes/AnimationList.lua ["notepad"]). On joue l'animation
-- DIRECTEMENT ici, sans passer par dpemotes (TriggerEvent
-- "dpemotes:playOtherEmote" → ExecuteCommand "e notepad" → OnEmotePlay), pour 3
-- raisons :
--   1. OnEmotePlay a une demi-douzaine d'early returns (zone gunfight, gilet,
--      EMS item, driver de véhicule…) qui font silencieusement échouer l'anim.
--   2. ExecuteCommand est async : il s'exécute après que SetNuiFocus(true,true)
--      ait été appelé, ce qui peut interagir bizarrement avec le command system.
--   3. On veut une garantie : "j'ouvre mon cahier → mon perso joue l'anim".
--      Pas de dépendance fragile sur le load order ou le state d'autres resources.
--
-- Les props sont networkés (bIsNetwork = true) : les autres joueurs voient
-- l'anim ET les props (cahier + crayon). Le keep-alive plus bas re-attache et
-- re-assert mission entity en boucle pour contrer le GC OneSync (sv_filter-
-- RequestControl 4 + sv_enableNetworkedScriptEntityStates false) qui sinon
-- nettoie le prop ~10s après le spawn côté propriétaire.
local NOTEPAD_DICT       = "missheistdockssetup1clipboard@base"
local NOTEPAD_ANIM       = "base"
local NOTEPAD_PROP       = "prop_notepad_01"
local NOTEPAD_PROP_BONE  = 18905
local NOTEPAD_PROP_OFF   = { 0.1, 0.02, 0.05, 10.0, 0.0, 0.0 }
local PENCIL_PROP        = "prop_pencil_01"
local PENCIL_PROP_BONE   = 58866
local PENCIL_PROP_OFF    = { 0.11, -0.02, 0.001, -120.0, 0.0, 0.0 }

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local tries = 0
    while not HasAnimDictLoaded(dict) and tries < 200 do
        Wait(10); tries = tries + 1
    end
    return HasAnimDictLoaded(dict)
end

local function loadModel(model)
    local hash = GetHashKey(model)
    if HasModelLoaded(hash) then return hash end
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        Wait(10); tries = tries + 1
    end
    return HasModelLoaded(hash) and hash or nil
end

local function attachProp(model, bone, off)
    local hash = loadModel(model)
    if not hash then return nil end
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local prop = CreateObject(hash, x, y, z + 0.2, true, true, true)
    SetEntityAsMissionEntity(prop, true, true)
    SetEntityCollision(prop, false, false)
    SetEntityInvincible(prop, true)

    if NetworkGetEntityIsNetworked(prop) then
        local netId = NetworkGetNetworkIdFromEntity(prop)
        SetNetworkIdExistsOnAllMachines(netId, true)
        SetNetworkIdCanMigrate(netId, false)
    end

    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone),
        off[1], off[2], off[3], off[4], off[5], off[6],
        true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(hash)
    return prop
end

-- Keep-alive : recolle le prop et le re-marque mission entity tant qu'il
-- existe ET que la génération courante n'a pas changé.
local function keepAlive(prop, bone, off, gen)
    CreateThread(function()
        while gen == emoteGen and DoesEntityExist(prop) and emoteActive do
            Wait(2000)
            if gen ~= emoteGen then break end
            if not DoesEntityExist(prop) then break end
            local ped = PlayerPedId()
            if not IsEntityAttachedToEntity(prop, ped) then
                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone),
                    off[1], off[2], off[3], off[4], off[5], off[6],
                    true, true, false, true, 1, true)
            end
            SetEntityAsMissionEntity(prop, true, true)
        end
    end)
end

local function destroyAllProps()
    emoteGen = emoteGen + 1
    for i, p in ipairs(emoteProps) do
        if DoesEntityExist(p) then
            DetachEntity(p, true, true)
            SetEntityAsMissionEntity(p, true, true)
            DeleteEntity(p)
        end
        emoteProps[i] = nil
    end
end

local function playNotepadEmote()
    if emoteActive then return end
    emoteActive = true

    CreateThread(function()
        if not loadAnimDict(NOTEPAD_DICT) then
            emoteActive = false
            return
        end

        local ped = PlayerPedId()
        -- Flags 49 = upper body + loop, permet de "marcher" si jamais (l'emote
        -- d'origine utilise EmoteLoop=true + EmoteMoving=true → MovementType=51).
        TaskPlayAnim(ped, NOTEPAD_DICT, NOTEPAD_ANIM, 2.0, 2.0, -1, 51, 0, false, false, false)
        RemoveAnimDict(NOTEPAD_DICT)

        local gen = emoteGen
        local p1  = attachProp(NOTEPAD_PROP, NOTEPAD_PROP_BONE, NOTEPAD_PROP_OFF)
        local p2  = attachProp(PENCIL_PROP,  PENCIL_PROP_BONE,  PENCIL_PROP_OFF)
        if p1 then table.insert(emoteProps, p1); keepAlive(p1, NOTEPAD_PROP_BONE, NOTEPAD_PROP_OFF, gen) end
        if p2 then table.insert(emoteProps, p2); keepAlive(p2, PENCIL_PROP_BONE,  PENCIL_PROP_OFF,  gen) end
    end)
end

local function cancelNotepadEmote()
    if not emoteActive then return end
    emoteActive = false
    destroyAllProps()
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        ClearPedTasks(ped)
    end
end

local function showUI(data)
    if cahierOpen then return end
    cahierOpen = true
    currentId  = data.id

    playNotepadEmote()

    SetNuiFocus(true, true)
    SendNUIMessage({
        type      = "cahier:open",
        id        = data.id,
        title     = data.title or "",
        content   = data.content or "",
        updatedAt = data.updatedAt or 0,
        maxLength = 5000,
        maxTitle  = 60,
    })
end

local function hideUI()
    if not cahierOpen then return end
    cahierOpen = false
    currentId  = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "cahier:close" })
    cancelNotepadEmote()
end

RegisterNetEvent("cahier:open")
AddEventHandler("cahier:open", function(data)
    if type(data) ~= "table" or not data.id then return end
    showUI(data)
end)

-- Ouvre le cahier en mode lecture seule (sender l'a montré). Pas d'id côté
-- viewer car il n'a pas le droit d'éditer ou save → on ne touche pas à
-- currentId, ce qui invalide naturellement les callbacks save.
RegisterNetEvent("cahier:openReadOnly")
AddEventHandler("cahier:openReadOnly", function(data)
    if type(data) ~= "table" then return end
    if cahierOpen then return end
    cahierOpen = true
    currentId  = nil

    playNotepadEmote()

    SetNuiFocus(true, true)
    SendNUIMessage({
        type      = "cahier:open",
        readonly  = true,
        from      = data.from or "",
        title     = data.title or "",
        content   = data.content or "",
        updatedAt = data.updatedAt or 0,
        maxLength = 5000,
        maxTitle  = 60,
    })

    if data.from and data.from ~= "" then
        ESX.ShowNotification("~b~" .. data.from .. "~s~ vous montre son cahier.")
    end
end)

-- ACK serveur après save → on relaye à la NUI pour qu'elle affiche "Sauvegardé"
RegisterNetEvent("cahier:saveAck")
AddEventHandler("cahier:saveAck", function(ok)
    SendNUIMessage({ type = "cahier:saveAck", ok = ok == true })
end)

-- ----------------------------------------------------------------------------
--  Callbacks NUI → client
-- ----------------------------------------------------------------------------

RegisterNUICallback("cahier:save", function(data, cb)
    if type(data) ~= "table" then cb({ ok = false }) return end
    if not currentId then cb({ ok = false }) return end

    TriggerServerEvent("cahier:save", {
        id      = currentId,
        title   = tostring(data.title or ""):sub(1, 60),
        content = tostring(data.content or ""):sub(1, 5000),
    })
    cb({ ok = true })
end)

RegisterNUICallback("cahier:close", function(_, cb)
    hideUI()
    cb({ ok = true })
end)

-- Sécurité : si la ressource s'arrête pendant qu'un joueur a la NUI ouverte
-- ou pendant qu'il joue l'anim, on cleanup tout (focus, props, anim).
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if cahierOpen then
        SetNuiFocus(false, false)
    end
    cancelNotepadEmote()
end)
