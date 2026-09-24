-- Icones d'items absentes de stream/item_icon.ytd.
--
-- Reecrire le .ytd demanderait OpenIV/CodeWalker (conteneur RSC7 pagine) : on
-- charge donc ces visuels dans une runtime TXD. Trois PNG 128x128 -> environ
-- 64 Ko de VRAM chacun, crees une seule fois au demarrage, aucun cout par frame.
--
-- Table globale dediee et NON "INVENTORY" : client/modules/_main.lua fait
-- "INVENTORY = {}" et se charge apres client/lib/, ce qui effacerait tout ici.
ItemIcons = ItemIcons or {}

ItemIcons.Txd = "sunlife_item_icon"

local CUSTOM_ICONS <const> = {
    ["desinfectant"] = "web/img/items/desinfectant.png",
    ["permisbobcat"] = "web/img/items/permisbobcat.png",
    ["permisgouv"]   = "web/img/items/permisgouv.png",
}

local ready = {}

CreateThread(function()
    local txd = CreateRuntimeTxd(ItemIcons.Txd)
    if not txd then return end

    for name, file in pairs(CUSTOM_ICONS) do
        if CreateRuntimeTextureFromImage(txd, name, file) then
            ready[name] = true
        end
    end
end)

--- Renvoie sprite, dict, custom.
--- Le dict "item_icon" repond 4x4 quand la texture n'existe pas : c'est le test
--- deja utilise partout dans les pages pour retomber sur l'icone "box".
function ItemIcons.Resolve(name)
    local size = GetTextureResolution("item_icon", name)

    if size.x ~= 4.0 or size.y ~= 4.0 then
        return name, "item_icon", false
    end

    if ready[name] then
        return name, ItemIcons.Txd, true
    end

    return "box", nil, false
end

--- UI.DrawSpriteNew ne convient pas ici : il ne dessine que si
--- HasStreamedTextureDictLoaded(dict) est vrai, ce qui n'est pas garanti pour
--- une runtime TXD, et il spammerait RequestStreamedTextureDict a chaque frame.
function ItemIcons.Draw(dict, sprite, x, y, w, h, alpha)
    if alpha <= 0 then return end
    DrawSprite(dict, sprite, x, y, w, h, 0.0, 255, 255, 255, math.floor(alpha))
end
