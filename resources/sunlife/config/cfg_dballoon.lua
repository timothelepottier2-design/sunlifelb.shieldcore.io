DBalloonConfig = {}

DBalloonConfig.Locale = 'fr'
DBalloonConfig.Framework = 'esx'
DBalloonConfig.Inventory = 'esx'
DBalloonConfig.InventoryResource = 'inventaire'

DBalloonConfig.ItemName = 'propane_balloon'
DBalloonConfig.PropModel = 'bonbonne'

DBalloonConfig.EmptyBalloonItem = 'balloon_empty'
DBalloonConfig.BalloonPropModel = 'ballonblue'

DBalloonConfig.UseOxNotify = false

DBalloonConfig.PlaceDistance = 0.7
DBalloonConfig.PlaceHeadingFromPlayer = true
DBalloonConfig.FreezeProp = true
DBalloonConfig.PropGroundOffset = 0.0

DBalloonConfig.InteractDistance = 2.0
DBalloonConfig.OnePropPerPlayer = true

DBalloonConfig.UseOxTarget = true

DBalloonConfig.FillTime = 5000
DBalloonConfig.SmokeTime = 2500

DBalloonConfig.RagdollPuffCount = 3
DBalloonConfig.RagdollWindow = 60 * 1000
DBalloonConfig.RagdollDuration = 20 * 1000

DBalloonConfig.DrugEffectDuration = 60 * 1000
DBalloonConfig.DrugDrivingEnabled = true
DBalloonConfig.DrugDrivingStyle = 786603
DBalloonConfig.DrugDriveShake = 0.35
DBalloonConfig.DrugDrunkWalk = true
DBalloonConfig.DrugSteerJitter = 0.03

DBalloonConfig.TankMaxUses = 20
DBalloonConfig.TankMetaKey = 'uses'
DBalloonConfig.TankBreakRemoveProp = true

DBalloonLocales = DBalloonLocales or {}

DBalloonLocales['fr'] = {
    ctx_title = "Bonbonne",
    action_carry = "Prendre la bonbonne",
    action_make = "Faire un ballon",
    action_pickup = "Ranger la bonbonne",

    instr_place = "Poser",
    instr_smoke = "Taffer",
    instr_remove = "Ranger le ballon",
    balloon_removed = "Tu ranges le ballon.",

    already_placed = "Tu as déjà une bonbonne posée.",
    invalid_model = "Model invalide : %{model}",
    cant_create_prop = "Impossible de créer le prop.",
    tank_placed = "Bonbonne posée.",
    tank_status = "Bonbonne : %{uses}/%{max}",
    too_far = "Trop loin.",
    not_our_tank = "Ce n'est pas une bonbonne.",
    tank_not_found = "Bonbonne introuvable.",
    no_net_control = "Pas le contrôle réseau de la bonbonne.",
    no_net_control_retry = "Pas le contrôle réseau de la bonbonne (réessaie).",
    carry_start = "Tu portes la bonbonne.",
    carry_stop = "Tu poses la bonbonne.",

    filling = "Gonflage du ballon...",
    fill_cancel = "Gonflage annulé.",
    balloon_ready = "Ballon prêt !",
    balloon_finished = "Taffe 3/3, Ballon vide.",
    puff_progress = "Taffe %{count}/3",

    no_tank_item = "Tu n'as pas de bonbonne.",
    cant_remove_item = "Impossible de retirer l'item.",
    tank_empty = "La bonbonne est vide.",
    need_empty_balloon = "Il te faut un ballon vide.",
    cant_remove_empty_balloon = "Impossible de retirer le ballon vide.",
    error_balloon = "Impossible de créer le ballon.",
    cant_use_in_vehicle = "Tu ne peux pas utiliser la bonbonne en véhicule.",
}

DBalloonLocales['en'] = {
    ctx_title = "Tank",
    action_carry = "Pick up tank",
    action_make = "Make a balloon",
    action_pickup = "Store the tank",

    instr_place = "Place",
    instr_smoke = "Puff",
    instr_remove = "Put balloon away",
    balloon_removed = "You put the balloon away.",

    already_placed = "You already placed a tank.",
    invalid_model = "Invalid model: %{model}",
    cant_create_prop = "Unable to create prop.",
    tank_placed = "Tank placed.",
    tank_status = "Tank: %{uses}/%{max}",
    too_far = "Too far.",
    not_our_tank = "This is not a balloon tank.",
    tank_not_found = "Tank not found.",
    no_net_control = "No network control of the tank.",
    no_net_control_retry = "No network control of the tank (try again).",
    carry_start = "You are carrying the tank.",
    carry_stop = "You put the tank down.",

    filling = "Filling the balloon...",
    fill_cancel = "Filling cancelled.",
    balloon_ready = "Balloon ready!",
    balloon_finished = "Puff 3/3, Balloon empty.",
    puff_progress = "Puff %{count}/3",

    no_tank_item = "You don't have a tank.",
    cant_remove_item = "Couldn't remove the item.",
    tank_empty = "The tank is empty.",
    need_empty_balloon = "You need an empty balloon.",
    cant_remove_empty_balloon = "Couldn't remove the empty balloon.",
    error_balloon = "Unable to create the balloon.",
    cant_use_in_vehicle = "You can't use the tank while in a vehicle.",
}

function DBalloonT(key, vars)
    vars = vars or {}
    local loc = (DBalloonConfig.Locale or 'fr'):lower()
    local dict = DBalloonLocales[loc] or DBalloonLocales['fr'] or {}
    local str = dict[key] or key

    str = tostring(str):gsub("%%{%s*(.-)%s*}", function(k)
        local v = vars[k]
        if v == nil then return "%{" .. k .. "}" end
        return tostring(v)
    end)

    return str
end
