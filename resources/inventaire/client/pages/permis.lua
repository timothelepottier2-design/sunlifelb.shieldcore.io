INVENTORY.Permis = {}
INVENTORY.Permis.Open = false
INVENTORY.Permis.OpenPermis = false
INVENTORY.Permis.OpenWeapon = false
INVENTORY.Permis.OpenChasse = false
INVENTORY.Permis.OpenPeche = false
INVENTORY.Permis.LspdOpen = false
INVENTORY.Permis.BcsoOpen = false
INVENTORY.Permis.EmsOpen = false
INVENTORY.Permis.BobcatOpen = false
INVENTORY.Permis.LsfdOpen = false
INVENTORY.Permis.GouvOpen = false
INVENTORY.Permis.OpenAircraft = false
INVENTORY.Permis.OpenBateau = false
INVENTORY.Permis.OpenLvId = false
INVENTORY.Permis.DataId = {
    firstname = "John",
    lastname = "Doe",
    dataofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataLvId = {
    firstname = "John",
    lastname = "Doe",
    dob = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataPermis = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    auto = false,
    moto = false,
    truck = false,
    boat = false,
    plane = false,
    height = 180
}

INVENTORY.Permis.DataWeapon = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataAircraft = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataBateau = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataLspd = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}
INVENTORY.Permis.DataBcso = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}

INVENTORY.Permis.DataEms = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}

INVENTORY.Permis.DataBobcat = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}

INVENTORY.Permis.DataLsfd = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}

INVENTORY.Permis.DataGouv = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}
local w, h
local w2, h2
local ww2, hh2
CreateThread(function ()
    w, h = UI.ConvertToPixel(457, 272)
    w2, h2 = UI.ConvertToPixel(108, 141)
    ww2, hh2 = UI.ConvertToPixel(448, 526)
end)
local baseX, baseY = 0.69375002384186, 0.61111110448837
function INVENTORY.Permis.DrawId()
    UI.DrawSpriteNew("permis", "idcard", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
        
    end)

    local idSex = string.upper(tostring(INVENTORY.Permis.DataId.sex or "H"))
    if idSex == "H" or idSex == "HOMME" or idSex == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
            
        end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataId.firstname.." "..INVENTORY.Permis.DataId.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataId.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataId.sex, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataId.height, true, 0.20, {255, 255, 255, 255}, 0, false, false)

    if INVENTORY.Permis.DataId.textureDict and INVENTORY.Permis.DataId.textureName then
        print("zizi")
        local z, x = UI.ConvertToPixel(125, 165)
        UI.DrawSpriteNew(INVENTORY.Permis.DataId.textureDict, INVENTORY.Permis.DataId.textureName, baseX + 0.0010, baseY, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

-- Photo "homme cagoulé" de la carte Las Venturas : rendue une seule fois via
-- un DUI (nui://inventaire/web/cagoule.html) puis dessinée comme texture runtime
-- (même mécanisme que les mugshots des cartes classiques).
local lvPhotoDict, lvPhotoName
local lvPhotoDui
local function ensureLvPhoto()
    if lvPhotoName then return end
    local dui = CreateDui("nui://inventaire/web/cagoule.html", 512, 683)
    lvPhotoDui = dui
    local handle = GetDuiHandle(dui)
    local txd = CreateRuntimeTxd("lv_cagoule_txd")
    CreateRuntimeTextureFromDuiHandle(txd, "lv_cagoule_tex", handle)
    lvPhotoDict = "lv_cagoule_txd"
    lvPhotoName = "lv_cagoule_tex"
end

function INVENTORY.Permis.DrawLvId()
    local d = INVENTORY.Permis.DataLvId or {}

    local white  = { 232, 228, 220, 255 }
    local red    = { 190, 30, 30, 255 }
    local dim    = { 150, 145, 140, 255 }

    -- Contour rouge sang + fond noir (look clandestin).
    local bx, by = w * 0.018, h * 0.03
    UI.DrawRect(baseX, baseY, w, h, 0, 74, 8, 8, 240, { NoHover = true }, function () end)
    UI.DrawRect(baseX + bx, baseY + by, w - bx * 2, h - by * 2, 0, 15, 13, 14, 245, { NoHover = true }, function () end)

    -- Bandeau supérieur rouge sombre + liseré.
    local bannerH = h * 0.205
    UI.DrawRect(baseX + bx, baseY + by, w - bx * 2, bannerH, 0, 92, 10, 10, 250, { NoHover = true }, function () end)
    UI.DrawRect(baseX + bx, baseY + by + bannerH, w - bx * 2, h * 0.007, 0, 190, 30, 30, 255, { NoHover = true }, function () end)

    UI.DrawTexts(baseX + w * 0.06, baseY + h * 0.045, "LAS VENTURAS", false, 0.44, white, 0, false, false)
    UI.DrawTexts(baseX + w * 0.06, baseY + h * 0.155, "// CARTE CLANDESTINE - NON OFFICIEL", false, 0.20, { 220, 170, 170, 255 }, 0, false, false)

    -- Encart photo : portrait "homme cagoulé".
    ensureLvPhoto()
    local px, py = baseX + w * 0.055, baseY + h * 0.30
    local pw, ph = w * 0.30, h * 0.50
    local ix, iy = px + w * 0.008, py + h * 0.015
    local iw, ih = pw - w * 0.016, ph - h * 0.03
    UI.DrawRect(px, py, pw, ph, 0, 190, 30, 30, 255, { NoHover = true }, function () end)
    UI.DrawRect(ix, iy, iw, ih, 0, 8, 8, 9, 255, { NoHover = true }, function () end)
    if lvPhotoName then
        UI.DrawSpriteNew(lvPhotoDict, lvPhotoName, ix, iy, iw, ih, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function () end)
    end

    -- Colonne infos.
    local fx = baseX + w * 0.42

    UI.DrawTexts(fx, baseY + h * 0.30, "IDENTITE", false, 0.20, red, 0, false, false)
    UI.DrawTexts(fx, baseY + h * 0.365, ((d.firstname or "").." "..(d.lastname or "")), false, 0.30, white, 0, false, false)

    UI.DrawTexts(fx, baseY + h * 0.49, "NE(E) LE", false, 0.18, dim, 0, false, false)
    UI.DrawTexts(fx, baseY + h * 0.55, tostring(d.dob or ""), false, 0.26, white, 0, false, false)

    UI.DrawTexts(fx, baseY + h * 0.66, "SEXE", false, 0.18, dim, 0, false, false)
    UI.DrawTexts(fx, baseY + h * 0.72, tostring(d.sex or ""), false, 0.26, white, 0, false, false)

    UI.DrawTexts(fx + w * 0.26, baseY + h * 0.66, "TAILLE", false, 0.18, dim, 0, false, false)
    UI.DrawTexts(fx + w * 0.26, baseY + h * 0.72, tostring(d.height or ""), false, 0.26, white, 0, false, false)

    -- Pied de carte.
    UI.DrawTexts(baseX + w * 0.055, baseY + h * 0.90, "N. DOSSIER LV-XXXX  -  SANS VALEUR LEGALE", false, 0.16, { 110, 105, 100, 255 }, 0, false, false)
end

function INVENTORY.Permis.DrawPermis()
    UI.DrawSpriteNew("permis", "license", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
        
    end)

    local permisSex = string.upper(tostring(INVENTORY.Permis.DataPermis.sex or "H"))
    if permisSex == "H" or permisSex == "HOMME" or permisSex == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
            
        end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataPermis.firstname.." "..INVENTORY.Permis.DataPermis.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataPermis.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataPermis.sex, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataPermis.height, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    local x, y = UI.ConvertToPixel(24, 24)
    if INVENTORY.Permis.DataPermis.auto then 
        UI.DrawSpriteNew("permis", "car_icon", baseX+ w - 0.052, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.moto then 
        UI.DrawSpriteNew("permis", "bike_icon", baseX+ w - 0.052 + 0.002 + x, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.truck then
        UI.DrawSpriteNew("permis", "truck_icon", baseX+ w - 0.052 + 0.003+ (x *2), baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.plane then
        UI.DrawSpriteNew("permis", "plane_icon",  baseX+ w - 0.052, baseY + 0.11 + y + 0.003, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.boat then
        UI.DrawSpriteNew("permis", "boat_icon", baseX+ w - 0.052 + 0.003+ (x *2), baseY + 0.11 + y + 0.003, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawAircraft()
    UI.DrawSpriteNew("permis", "license", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true, NoHover = true, devmod = false,
    }, function () end)

    if string.upper(INVENTORY.Permis.DataAircraft.sex or "H") == "H"
       or string.upper(INVENTORY.Permis.DataAircraft.sex or "H") == "HOMME"
       or string.upper(INVENTORY.Permis.DataAircraft.sex or "H") == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true, NoHover = true, devmod = false,
        }, function () end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true, NoHover = true, devmod = false,
        }, function () end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, (INVENTORY.Permis.DataAircraft.firstname or "").." "..(INVENTORY.Permis.DataAircraft.lastname or ""), false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataAircraft.dateofbirth or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataAircraft.sex or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataAircraft.height or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)

    local x, y = UI.ConvertToPixel(24, 24)
    UI.DrawSpriteNew("permis", "plane_icon", baseX+ w - 0.052, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
        NoSelect = true, NoHover = true, devmod = false,
    }, function () end)
end

function INVENTORY.Permis.DrawBateau()
    UI.DrawSpriteNew("permis", "license", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true, NoHover = true, devmod = false,
    }, function () end)

    if string.upper(INVENTORY.Permis.DataBateau.sex or "H") == "H"
       or string.upper(INVENTORY.Permis.DataBateau.sex or "H") == "HOMME"
       or string.upper(INVENTORY.Permis.DataBateau.sex or "H") == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true, NoHover = true, devmod = false,
        }, function () end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true, NoHover = true, devmod = false,
        }, function () end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, (INVENTORY.Permis.DataBateau.firstname or "").." "..(INVENTORY.Permis.DataBateau.lastname or ""), false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataBateau.dateofbirth or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataBateau.sex or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataBateau.height or "", true, 0.20, {255, 255, 255, 255}, 0, false, false)

    local x, y = UI.ConvertToPixel(24, 24)
    UI.DrawSpriteNew("permis", "boat_icon", baseX+ w - 0.052, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
        NoSelect = true, NoHover = true, devmod = false,
    }, function () end)
end

function INVENTORY.Permis.DrawWeapon()
    UI.DrawSpriteNew("permis", "firearm", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawPeche()
    UI.DrawSpriteNew("permis", "fishing", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawChasse()
    UI.DrawSpriteNew("permis", "hunter", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawBadgeLSPD()
    UI.DrawSpriteNew("permis", "background_police", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataLspd.firstname.." "..INVENTORY.Permis.DataLspd.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataLspd.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataLspd.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataLspd.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataLspd.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataLspd.textureDict and INVENTORY.Permis.DataLspd.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataLspd.textureDict, INVENTORY.Permis.DataLspd.textureName, baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end


function INVENTORY.Permis.DrawBadgeSheriff()
    UI.DrawSpriteNew("permis", "background_sheriff", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataBcso.firstname.." "..INVENTORY.Permis.DataBcso.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataBcso.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataBcso.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataBcso.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataBcso.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataBcso.textureDict and INVENTORY.Permis.DataBcso.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataBcso.textureDict, INVENTORY.Permis.DataBcso.textureName,  baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

-- ============================================================================
-- Badges sans texture dediee (Bobcat Security, LSFD)
--
-- Le dictionnaire `permis` ne contient QUE background_police,
-- background_sheriff et background_ems, et le nom du service y est grave dans
-- l'image : reutiliser background_police faisait afficher "LOS SANTOS POLICE"
-- sur un badge Bobcat. Aucun natif ne peut effacer du texte peint dans une
-- texture.
--
-- Le visuel est donc produit en HTML/CSS puis rendu en texture via un DUI.
-- Pas de .ytd a fabriquer, et le design se retouche dans un simple fichier
-- web/badge_*.html.
-- ============================================================================

-- Le visuel de chaque badge est une page HTML rendue une seule fois dans un
-- DUI puis exposee comme texture runtime -- exactement le mecanisme deja
-- utilise par la photo de la carte Las Venturas (ensureLvPhoto ci-dessus).
-- Cout : un DUI par badge, cree a la premiere consultation et conserve.
local badgeArt = {}

---@param key string  identifiant interne, sert de nom de txd
---@param page string fichier html dans inventaire/web
---@return string|nil dict, string|nil texture
local function ensureBadgeArt(key, page)
    local cached = badgeArt[key]
    if cached then
        return cached.dict, cached.tex
    end

    local dict, tex = "badge_" .. key .. "_txd", "badge_" .. key .. "_tex"
    -- 914x544 = deux fois le gabarit de la carte d'identite (457x272), pour
    -- que le texte reste net une fois la texture reduite a l'ecran.
    local dui = CreateDui("nui://inventaire/web/" .. page, 914, 544)
    local txd = CreateRuntimeTxd(dict)
    CreateRuntimeTextureFromDuiHandle(txd, tex, GetDuiHandle(dui))

    badgeArt[key] = { dui = dui, dict = dict, tex = tex }
    return dict, tex
end

-- Mise en page exprimee en FRACTIONS de la carte (0 = bord gauche/haut,
-- 1 = bord droit/bas). `baseX, baseY` est le coin HAUT-GAUCHE et `w, h` la
-- taille, comme pour la carte d'identite.
--
-- Ces valeurs sont la copie exacte de celles utilisees dans les deux fichiers
-- web/badge_*.html : toute modification doit etre faite des deux cotes, sinon
-- les valeurs se decalent des intitules.
local BADGE_LAYOUT <const> = {
    photo  = { x = 0.004, y = 0.000, w = 0.274, h = 0.607 },
    name   = { x = 0.315, y = 0.300 },
    birth  = { x = 0.315, y = 0.520 },
    sex    = { x = 0.560, y = 0.520 },
    height = { x = 0.700, y = 0.520 },
    serial = { x = 0.220, y = 0.845 },
}

---@param data table  metadonnees du badge
---@param key string  identifiant du visuel
---@param page string fichier html
local function drawBadgeCard(data, key, page)
    local L = BADGE_LAYOUT

    local dict, tex = ensureBadgeArt(key, page)
    if dict then
        UI.DrawSpriteNew(dict, tex, baseX, baseY, w, h, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    -- Mugshot cale sur l'emplacement reserve par le HTML.
    if data.textureDict and data.textureName then
        UI.DrawSpriteNew(data.textureDict, data.textureName,
            baseX + w * L.photo.x, baseY + h * L.photo.y,
            w * L.photo.w, h * L.photo.h,
            0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    UI.DrawTexts(baseX + w * L.name.x,   baseY + h * L.name.y,   tostring(data.firstname).." "..tostring(data.lastname), false, 0.32, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + w * L.birth.x,  baseY + h * L.birth.y,  tostring(data.dateofbirth), false, 0.22, {236, 238, 244, 255}, 0, false, false)
    UI.DrawTexts(baseX + w * L.sex.x,    baseY + h * L.sex.y,    tostring(data.sex), false, 0.22, {236, 238, 244, 255}, 0, false, false)
    UI.DrawTexts(baseX + w * L.height.x, baseY + h * L.height.y, tostring(data.height), false, 0.22, {236, 238, 244, 255}, 0, false, false)
    UI.DrawTexts(baseX + w * L.serial.x, baseY + h * L.serial.y, "N° " .. tostring(data.matricule), false, 0.24, {255, 255, 255, 255}, 0, false, false)
end

function INVENTORY.Permis.DrawBadgeBobcat()
    drawBadgeCard(INVENTORY.Permis.DataBobcat, "bobcat", "badge_bobcat.html")
end

function INVENTORY.Permis.DrawBadgeLsfd()
    drawBadgeCard(INVENTORY.Permis.DataLsfd, "lsfd", "badge_lsfd.html")
end

function INVENTORY.Permis.DrawBadgeGouv()
    drawBadgeCard(INVENTORY.Permis.DataGouv, "gouv", "badge_gouv.html")
end

function INVENTORY.Permis.DrawBadgeEms()
    UI.DrawSpriteNew("permis", "background_ems", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataEms.firstname.." "..INVENTORY.Permis.DataEms.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataEms.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataEms.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataEms.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataEms.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataEms.textureDict and INVENTORY.Permis.DataEms.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataEms.textureDict, INVENTORY.Permis.DataEms.textureName,  baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end


-- permisweapon

