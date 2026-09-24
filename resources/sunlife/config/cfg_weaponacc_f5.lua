-- ============================================================================
-- Accessoires d'armes du menu F5 (avantage boutique "accarmes")
--
-- Le catalogue est derive de ConfigF5.componentList (cfg_menuperso.lua) qui ne
-- liste QUE des armes du jeu de base. Les armes addon (boutique) n'y figurent
-- pas : elles ressortent donc sans accessoire et le menu les refuse. Leurs
-- accessoires restent vendus a la piece par la boutique
-- (apps/boutique/server/srv_weapon_accessories.lua).
--
-- Charge cote client ET serveur (config/**.lua est dans les deux globs du
-- fxmanifest) : le serveur revalide ce que le client demande.
-- ============================================================================
F5WeaponAcc = F5WeaponAcc or {}

-- Rank boutique qui debloque le menu.
F5WeaponAcc.RANK = "accarmes"

-- component (cfg_menuperso) -> categorie de slot persistee dans
-- metadatas.attachments. Deux accessoires d'une meme categorie partagent le
-- meme point d'attache sur l'arme : ils sont mutuellement exclusifs, poser le
-- second retire le premier.
local CATEGORY = {
    silencieux   = "suppressor",
    flashlight   = "flashlight",
    grip         = "grip",
    barrel       = "barrel",
    railcover    = "railcover",
    muzzlebrake  = "muzzle",
    -- Toutes les lunettes tombent sur le meme bone -> une seule categorie.
    smallscope   = "scope",
    mediumscope  = "scope",
    largescope   = "scope",
    maxscope     = "scope",
    nightvision  = "scope",
    thermalscope = "scope",
}

-- [WEAPON_NAME] = { { name, hash, category }, ... }
local index = nil

-- Construction paresseuse et non au chargement : cfg_menuperso.lua fait
-- "ConfigF5 = {}" et l'ordre du glob config/**.lua n'est pas garanti. On ne
-- lit ConfigF5 qu'au premier appel, donc bien apres le chargement complet.
local function buildIndex()
    if index then return index end
    index = {}

    local list = ConfigF5 and ConfigF5.componentList
    if type(list) ~= "table" then return index end

    for _, entry in pairs(list) do
        local category = CATEGORY[entry.component]
        if category and type(entry.hash) == "string" and type(entry.weapons) == "table" then
            for _, weaponName in pairs(entry.weapons) do
                if type(weaponName) == "string" then
                    local bucket = index[weaponName]
                    if not bucket then
                        bucket = {}
                        index[weaponName] = bucket
                    end
                    bucket[#bucket + 1] = {
                        name     = entry.name or entry.hash,
                        hash     = entry.hash,
                        category = category,
                    }
                end
            end
        end
    end

    return index
end

-- Accessoires disponibles pour une arme, ou nil si l'arme n'est pas au
-- catalogue (arme addon / boutique, ou arme sans accessoire).
function F5WeaponAcc.Get(weaponName)
    if type(weaponName) ~= "string" then return nil end
    return buildIndex()[weaponName]
end

-- Validation d'une pose : l'accessoire doit exister pour CETTE arme dans CETTE
-- categorie. Empeche un client modifie de monter n'importe quel composant.
function F5WeaponAcc.Find(weaponName, category, componentID)
    local list = F5WeaponAcc.Get(weaponName)
    if not list then return nil end
    for i = 1, #list do
        local acc = list[i]
        if acc.category == category and acc.hash == componentID then
            return acc
        end
    end
    return nil
end

-- Validation d'un retrait : on ne connait que la categorie, il suffit que
-- l'arme ait au moins un accessoire dans ce slot.
function F5WeaponAcc.FindCategory(weaponName, category)
    local list = F5WeaponAcc.Get(weaponName)
    if not list then return nil end
    for i = 1, #list do
        if list[i].category == category then
            return list[i]
        end
    end
    return nil
end
