INVENTORY.Weapon = {}
INVENTORY.Weapon.Selected = {}

local lastWeapon = nil

-- Dedup envois newAmmo : a 200+ joueurs en gunfight, le switch frenetique
-- A->B->A->B inonde le serveur d'events identiques (~46-66B / event a cause
-- de la meta complete embarquee). On garde le dernier ammo envoye par arme
-- (cle = name + meta.id quand dispo) et on skip si rien n'a change ou si
-- le dernier envoi est trop recent (< MIN_RESEND_MS).
--
-- Cas couverts :
--   * Re-switch sur la meme arme sans avoir tire = skip (ammo identique)
--   * Switch rapide hors combat = throttle naturel
--   * Tir + switch = envoi (ammo a change)
local _lastSentByKey = {}      -- [key] = { ammo, ts }
local MIN_RESEND_MS = 1500

local function ammoKey(name, meta)
    if meta and meta.id then
        return name .. '#' .. tostring(meta.id)
    end
    return name
end

local function sendAmmoIfNeeded(name, meta, ammo)
    if type(name) ~= 'string' or name == '' then return end
    local k = ammoKey(name, meta)
    local last = _lastSentByKey[k]
    local now = GetGameTimer()
    if last and last.ammo == ammo and (now - last.ts) < MIN_RESEND_MS then
        return
    end
    _lastSentByKey[k] = { ammo = ammo, ts = now }
    TriggerServerEvent("inventory:server:newAmmo", name, meta, ammo)
end

-- Expose un export pour que les autres pages (raccourci.lua, useClip) puissent
-- profiter du dedup au lieu de TriggerServerEvent direct.
exports('sendAmmoIfNeeded', sendAmmoIfNeeded)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= lastWeapon then
            -- On ne sauvegarde l'ammo que si lastWeapon correspond bien à
            -- l'arme actuellement marquée comme "Selected" côté inventaire.
            -- Sinon (ex: raccourci qui a déséquipé puis ré-équipé l'arme,
            -- où lastWeapon vaut WEAPON_UNARMED), GetAmmoInPedWeapon(ped, lastWeapon)
            -- retournerait 0 et écraserait à tort la metadata.ammo de l'arme.
            if lastWeapon
            and INVENTORY.Weapon.Selected
            and INVENTORY.Weapon.Selected.name
            and lastWeapon == GetHashKey(INVENTORY.Weapon.Selected.name) then

                local ammo = GetAmmoInPedWeapon(ped, lastWeapon)
                local meta = INVENTORY.Weapon.Selected.metadatas or {}

                sendAmmoIfNeeded(INVENTORY.Weapon.Selected.name, meta, ammo)
            end

            lastWeapon = weapon
        end

        Wait(500)
    end
end)

RegisterNetEvent('components:useClip')
AddEventHandler('components:useClip', function(type)
	local ped = PlayerPedId()
	local hash = nil
	if IsPedArmed(ped, 4) then
		hash = GetSelectedPedWeapon(ped)
        local good = false
        if type == "clip" then 
            good = true
        end
        if type ~= "clip" then 
            for key, value in pairs(ConfigShared.Clip[type]) do
                if GetHashKey(key) == hash then
                    good = true
                end
            end
        end
        if good then
            if hash ~= nil then
                local ammo =  GetAmmoInPedWeapon(ped, hash)
                AddAmmoToPed(ped, hash, 25)
                -- Passe par le dedup pour mettre a jour _lastSentByKey :
                -- evite qu'au prochain switch on re-envoie la meme valeur.
                sendAmmoIfNeeded(INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, ammo + 25)
                INVENTORY.Weapon.Selected.metadatas.ammo = ammo + 25
                ESX.ShowNotification("Tu as utilisé un chargeur")
                TriggerServerEvent("components:server:remove", type)
            else
                ESX.ShowNotification("Tu n'as pas d'armes en main !")
            end
        else
            ESX.ShowNotification("Pas le bon chargeur !")
        end
	else
		ESX.ShowNotification("Ce type de munitions ne convient pas !")
	end
end)


RegisterNetEvent('components:useComponent')
AddEventHandler('components:useComponent', function(component, weapon, compID)
    local ped = PlayerPedId()
	local hash = nil
	local currentWeaponHash = GetSelectedPedWeapon(ped)
    if IsPedArmed(ped, 4) then
		hash = GetSelectedPedWeapon(ped)
        if GetHashKey(weapon) == hash then
            if hash ~= nil then
                print(json.encode(INVENTORY.Weapon.Selected.metadatas.component))
                if INVENTORY.Weapon.Selected.metadatas.component == nil then 
                    TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component)

                    INVENTORY.Weapon.Selected.metadatas.component = {}
                    INVENTORY.Weapon.Selected.metadatas.component[component] = true
                    for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                        if value.metadatas then 
                            if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                SaveRaccourci()
                            end
                        end
                    end
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))

                else
                    if INVENTORY.Weapon.Selected.metadatas.component[component] then
                        TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component, true)

                        INVENTORY.Weapon.Selected.metadatas.component[component] = nil
                        for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                            if value.metadatas then 
                                if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                    INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                    SaveRaccourci()
                                end
                            end
                        end
                        RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
                    else
                        TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component)

                        INVENTORY.Weapon.Selected.metadatas.component[component] = true
                        for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                            if value.metadatas then 
                                if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                    INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                    SaveRaccourci()
                                end
                            end
                        end
                        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
                    end
                end
            else
                ESX.ShowNotification("Tu n'as pas d'armes en main !")
            end
        end
	else
		ESX.ShowNotification("Ce type de d'accessoire ne fonctionne pas ne convient pas !")
	end
	-- GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
end)


exports("getCurrentWeapon", function ()
    return INVENTORY.Weapon.Selected
end)