-- ============================================================================
-- Retour serveur de F5 > Mes Avantages > Menu des accessoires d'armes.
--
-- SetWeaponAttachment (inventaire) fait les trois ecritures necessaires pour
-- que l'accessoire survive a un re-equipement / une reconnexion : ped en main,
-- INVENTORY.Weapon.Selected.metadatas et copie KVP du raccourci.
-- ============================================================================
RegisterNetEvent('sunlife:weaponAcc:sync', function(weapon, id, category, componentID, removed)
    if type(weapon) ~= "string" or type(category) ~= "string" then return end
    exports.inventaire:SetWeaponAttachment(weapon, id, category, componentID, removed == true)
end)
