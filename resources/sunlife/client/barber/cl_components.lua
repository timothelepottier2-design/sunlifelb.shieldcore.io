-- ============================================================
-- Définitions de composants ESX skin pour le barbier
-- (mergé depuis vms_barber/client/components.lua)
-- ============================================================

BarberCharacter = {}

local Components = {
    {name = 'sex',              value = 0,  min = 0},
    {name = 'mom',              value = 21, min = 21},
    {name = 'dad',              value = 0,  min = 0},
    {name = 'face_md_weight',   value = 50, min = 0},
    {name = 'skin_md_weight',   value = 50, min = 0},
    {name = 'nose_1',           value = 0,  min = -10},
    {name = 'nose_2',           value = 0,  min = -10},
    {name = 'nose_3',           value = 0,  min = -10},
    {name = 'nose_4',           value = 0,  min = -10},
    {name = 'nose_5',           value = 0,  min = -10},
    {name = 'nose_6',           value = 0,  min = -10},
    {name = 'cheeks_1',         value = 0,  min = -10},
    {name = 'cheeks_2',         value = 0,  min = -10},
    {name = 'cheeks_3',         value = 0,  min = -10},
    {name = 'lip_thickness',    value = 0,  min = -10},
    {name = 'jaw_1',            value = 0,  min = -10},
    {name = 'jaw_2',            value = 0,  min = -10},
    {name = 'chin_1',           value = 0,  min = -10},
    {name = 'chin_2',           value = 0,  min = -10},
    {name = 'chin_3',           value = 0,  min = -10},
    {name = 'chin_4',           value = 0,  min = -10},
    {name = 'neck_thickness',   value = 0,  min = -10},
    {name = 'hair_1',           value = 0,  min = 0},
    {name = 'hair_2',           value = 0,  min = 0},
    {name = 'hair_color_1',     value = 0,  min = 0},
    {name = 'hair_color_2',     value = 0,  min = 0},
    {name = 'tshirt_1',         value = 0,  min = 0, componentId = 8},
    {name = 'tshirt_2',         value = 0,  min = 0, textureof = 'tshirt_1'},
    {name = 'torso_1',          value = 0,  min = 0, componentId = 11},
    {name = 'torso_2',          value = 0,  min = 0, textureof = 'torso_1'},
    {name = 'decals_1',         value = 0,  min = 0, componentId = 10},
    {name = 'decals_2',         value = 0,  min = 0, textureof = 'decals_1'},
    {name = 'arms',             value = 0,  min = 0},
    {name = 'arms_2',           value = 0,  min = 0},
    {name = 'pants_1',          value = 0,  min = 0, componentId = 4},
    {name = 'pants_2',          value = 0,  min = 0, textureof = 'pants_1'},
    {name = 'shoes_1',          value = 0,  min = 0, componentId = 6},
    {name = 'shoes_2',          value = 0,  min = 0, textureof = 'shoes_1'},
    {name = 'mask_1',           value = 0,  min = 0, componentId = 1},
    {name = 'mask_2',           value = 0,  min = 0, textureof = 'mask_1'},
    {name = 'bproof_1',         value = 0,  min = 0, componentId = 9},
    {name = 'bproof_2',         value = 0,  min = 0, textureof = 'bproof_1'},
    {name = 'chain_1',          value = 0,  min = 0, componentId = 7},
    {name = 'chain_2',          value = 0,  min = 0, textureof = 'chain_1'},
    {name = 'helmet_1',         value = -1, min = -1, componentId = 0},
    {name = 'helmet_2',         value = 0,  min = 0, textureof = 'helmet_1'},
    {name = 'glasses_1',        value = 0,  min = 0, componentId = 1},
    {name = 'glasses_2',        value = 0,  min = 0, textureof = 'glasses_1'},
    {name = 'watches_1',        value = -1, min = -1, componentId = 6},
    {name = 'watches_2',        value = 0,  min = 0, textureof = 'watches_1'},
    {name = 'bracelets_1',      value = -1, min = -1, componentId = 7},
    {name = 'bracelets_2',      value = 0,  min = 0, textureof = 'bracelets_1'},
    {name = 'bags_1',           value = 0,  min = 0, componentId = 5},
    {name = 'bags_2',           value = 0,  min = 0, textureof = 'bags_1'},
    {name = 'eye_color',        value = 0,  min = 0},
    {name = 'eye_squint',       value = 0,  min = -10},
    {name = 'eyebrows_1',       value = 0,  min = 0},
    {name = 'eyebrows_2',       value = 0,  min = 0},
    {name = 'eyebrows_3',       value = 0,  min = 0},
    {name = 'eyebrows_4',       value = 0,  min = 0},
    {name = 'eyebrows_5',       value = 0,  min = -10},
    {name = 'eyebrows_6',       value = 0,  min = -10},
    {name = 'makeup_1',         value = 0,  min = 0},
    {name = 'makeup_2',         value = 0,  min = 0},
    {name = 'makeup_3',         value = 0,  min = 0},
    {name = 'makeup_4',         value = 0,  min = 0},
    {name = 'lipstick_1',       value = 0,  min = 0},
    {name = 'lipstick_2',       value = 0,  min = 0},
    {name = 'lipstick_3',       value = 0,  min = 0},
    {name = 'lipstick_4',       value = 0,  min = 0},
    {name = 'ears_1',           value = -1, min = -1, componentId = 2},
    {name = 'ears_2',           value = 0,  min = 0, textureof = 'ears_1'},
    {name = 'chest_1',          value = 0,  min = 0},
    {name = 'chest_2',          value = 0,  min = 0},
    {name = 'chest_3',          value = 0,  min = 0},
    {name = 'bodyb_1',          value = -1, min = -1},
    {name = 'bodyb_2',          value = 0,  min = 0},
    {name = 'bodyb_3',          value = -1, min = -1},
    {name = 'bodyb_4',          value = 0,  min = 0},
    {name = 'age_1',            value = 0,  min = 0},
    {name = 'age_2',            value = 0,  min = 0},
    {name = 'blemishes_1',      value = 0,  min = 0},
    {name = 'blemishes_2',      value = 0,  min = 0},
    {name = 'blush_1',          value = 0,  min = 0},
    {name = 'blush_2',          value = 0,  min = 0},
    {name = 'blush_3',          value = 0,  min = 0},
    {name = 'complexion_1',     value = 0,  min = 0},
    {name = 'complexion_2',     value = 0,  min = 0},
    {name = 'sun_1',            value = 0,  min = 0},
    {name = 'sun_2',            value = 0,  min = 0},
    {name = 'moles_1',          value = 0,  min = 0},
    {name = 'moles_2',          value = 0,  min = 0},
    {name = 'beard_1',          value = 0,  min = 0},
    {name = 'beard_2',          value = 0,  min = 0},
    {name = 'beard_3',          value = 0,  min = 0},
    {name = 'beard_4',          value = 0,  min = 0},
}

for i = 1, #Components do
    BarberCharacter[Components[i].name] = Components[i].value
end

function Barber_RefreshValues()
    BarberCharacter = {}
    for i = 1, #Components do
        BarberCharacter[Components[i].name] = Components[i].value
    end
end

function Barber_GetMaxValues()
    local components = json.decode(json.encode(Components))
    for k, v in pairs(BarberCharacter) do
        for i = 1, #components do
            if k == components[i].name then
                components[i].value = v
            end
        end
    end
    return components, Barber_GetMaxVals()
end

function Barber_GetMaxVals()
    local myPed = PlayerPedId()
    return {
        beard_1        = GetPedHeadOverlayNum(1) - 1,
        beard_2        = 10,
        beard_3        = GetNumHairColors() - 1,
        hair_1         = GetNumberOfPedDrawableVariations(myPed, 2) - 1,
        hair_2         = GetNumberOfPedTextureVariations(myPed, 2, BarberCharacter['hair_1']) - 1,
        hair_color_1   = GetNumHairColors() - 1,
        hair_color_2   = GetNumHairColors() - 1,
        eye_color      = 31,
        eyebrows_1     = GetPedHeadOverlayNum(2) - 1,
        eyebrows_2     = 10,
        eyebrows_3     = GetNumHairColors() - 1,
        makeup_1       = GetPedHeadOverlayNum(4) - 1,
        makeup_2       = 10,
        makeup_3       = GetNumHairColors() - 1,
        makeup_4       = GetNumHairColors() - 1,
        lipstick_1     = GetPedHeadOverlayNum(8) - 1,
        lipstick_2     = 10,
        lipstick_3     = GetNumHairColors() - 1,
        blush_1        = GetPedHeadOverlayNum(5) - 1,
        blush_2        = 10,
        blush_3        = GetNumHairColors() - 1,
    }
end
