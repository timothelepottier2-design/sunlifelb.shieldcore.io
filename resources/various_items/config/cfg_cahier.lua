-- ============================================================================
--  Configuration du Cahier de Notes
--
--  Item ESX classique stocké en metadata (comme une carte d'identité), une
--  ligne par cahier dans `inventory`. Pas de table dédiée → 0 coût DB
--  supplémentaire et bénéficie du save batché de l'inventaire (`SavePlayerInventory`
--  toutes les 10 min + flush sur `playerDropped`).
--
--  Tuning 800 joueurs :
--    • MaxContentLength : limite stricte côté serveur (et client UX) pour
--      empêcher qu'un joueur stocke 1 Mo de texte dans son inventaire.
--    • SaveCooldownMs   : anti-spam des saves NUI (touche "Sauvegarder" ou
--      auto-save sur close). Limite 1 write toutes les X ms.
--    • LabelMaxLength   : titre du cahier (visible sur la couverture).
-- ============================================================================
Cahier = {
    ItemName        = "cahier",
    ItemLabel       = "Cahier de notes",
    ItemWeight      = 0.20,

    -- Limites de payload (truncate côté serveur, pas d'erreur).
    MaxContentLength = 5000,
    LabelMaxLength   = 60,

    -- Anti-spam save (par joueur).
    SaveCooldownMs   = 2000,
}
