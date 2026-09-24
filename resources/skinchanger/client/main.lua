local Components = {
	{label = _U('sex'),						name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('face'),					name = 'face',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('skin'),					name = 'skin',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_1'),					name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_2'),					name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_1'),			name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_2'),			name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('tshirt_1'),				name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 8},
	{label = _U('tshirt_2'),				name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'tshirt_1'},
	{label = _U('torso_1'),					name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 11},
	{label = _U('torso_2'),					name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'torso_1'},
	{label = _U('decals_1'),				name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 10},
	{label = _U('decals_2'),				name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'decals_1'},
	{label = _U('arms'),					name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('pants_1'),					name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	componentId	= 4},
	{label = _U('pants_2'),					name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof	= 'pants_1'},
	{label = _U('shoes_1'),					name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	componentId	= 6},
	{label = _U('shoes_2'),					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof	= 'shoes_1'},
	{label = _U('mask_1'),					name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('mask_2'),					name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'mask_1'},
	{label = _U('bproof_1'),				name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 9},
	{label = _U('bproof_2'),				name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bproof_1'},
	{label = _U('chain_1'),					name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 7},
	{label = _U('chain_2'),					name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'chain_1'},
	{label = _U('helmet_1'),				name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0 },
	{label = _U('helmet_2'),				name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'helmet_1'},
	{label = _U('glasses_1'),				name = 'glasses_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('glasses_2'),				name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'glasses_1'},
  {label = _U('watches_1'),				name = 'watches_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('watches_2'),				name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'watches_1'},
  {label = _U('bracelets_1'),				name = 'bracelets_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('bracelets_2'),				name = 'bracelets_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'bracelets_1'},
	{label = _U('bag'),						name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 5},
	{label = _U('bag_color'),				name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bags_1'},
	{label = _U('eyebrow_size'),			name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_type'),			name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_1'),			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_2'),			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_type'),				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_thickness'),		name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_1'),			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_2'),			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_type'),			name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_thickness'),		name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_1'),		name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_2'),		name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('ear_accessories'),			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65,	componentId	= 2},
	{label = _U('ear_accessories_color'),	name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof	= 'ears_1'},
	{label = _U('wrinkles'),				name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('wrinkle_thickness'),		name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_type'),				name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_size'),				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_1'),			name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_2'),			name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
}

local LastSex     = -1
local LoadSkin    = nil
local LoadClothes = nil
local Character   = {}

for i=1, #Components, 1 do
  Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(malePed, cb)

  local playerPed = PlayerPedId()
  local characterModel

  if malePed then
    characterModel = GetHashKey('mp_m_freemode_01')
  else
    characterModel = GetHashKey('mp_f_freemode_01')
  end

  RequestModel(characterModel)

  Citizen.CreateThread(function()

    while not HasModelLoaded(characterModel) do
      RequestModel(characterModel)
      Citizen.Wait(0)
    end

    if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
      SetPlayerModel(PlayerId(), characterModel)
      SetPedDefaultComponentVariation(playerPed)
    end

    SetModelAsNoLongerNeeded(characterModel)

    if cb ~= nil then
      cb()
    end

    TriggerEvent('skinchanger:modelLoaded')

  end)

end

function GetMaxVals()

  local playerPed = PlayerPedId()

  local data = {
    sex           = 1,
    face          = 45,
    skin          = 45,
    age_1         = GetNumHeadOverlayValues(3)-1,
    age_2         = 10,
    beard_1       = GetNumHeadOverlayValues(1)-1,
    beard_2       = 10,
    beard_3       = GetNumHairColors()-1,
    beard_4       = GetNumHairColors()-1,
    hair_1        = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
    hair_2        = GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
    hair_color_1  = GetNumHairColors()-1,
    hair_color_2  = GetNumHairColors()-1,
    eyebrows_1    = GetNumHeadOverlayValues(2)-1,
    eyebrows_2    = 10,
    eyebrows_3    = GetNumHairColors()-1,
    eyebrows_4    = GetNumHairColors()-1,
    makeup_1      = GetNumHeadOverlayValues(4)-1,
    makeup_2      = 10,
    makeup_3      = GetNumHairColors()-1,
    makeup_4      = GetNumHairColors()-1,
    lipstick_1    = GetNumHeadOverlayValues(8)-1,
    lipstick_2    = 10,
    lipstick_3    = GetNumHairColors()-1,
    lipstick_4    = GetNumHairColors()-1,
    ears_1        = GetNumberOfPedPropDrawableVariations  (playerPed, 1) - 1,
    ears_2        = GetNumberOfPedPropTextureVariations   (playerPed, 1, Character['ears_1'] - 1),
    tshirt_1      = GetNumberOfPedDrawableVariations      (playerPed, 8) - 1,
    tshirt_2      = GetNumberOfPedTextureVariations       (playerPed, 8, Character['tshirt_1']) - 1,
    torso_1       = GetNumberOfPedDrawableVariations      (playerPed, 11) - 1,
    torso_2       = GetNumberOfPedTextureVariations       (playerPed, 11, Character['torso_1']) - 1,
    decals_1      = GetNumberOfPedDrawableVariations      (playerPed, 10) - 1,
    decals_2      = GetNumberOfPedTextureVariations       (playerPed, 10, Character['decals_1']) - 1,
    arms          = GetNumberOfPedDrawableVariations      (playerPed, 3) - 1,
    pants_1       = GetNumberOfPedDrawableVariations      (playerPed, 4) - 1,
    pants_2       = GetNumberOfPedTextureVariations       (playerPed, 4, Character['pants_1']) - 1,
    shoes_1       = GetNumberOfPedDrawableVariations      (playerPed, 6) - 1,
    shoes_2       = GetNumberOfPedTextureVariations       (playerPed, 6, Character['shoes_1']) - 1,
    mask_1        = GetNumberOfPedDrawableVariations      (playerPed, 1) - 1,
    mask_2        = GetNumberOfPedTextureVariations       (playerPed, 1, Character['mask_1']) - 1,
    bproof_1      = GetNumberOfPedDrawableVariations      (playerPed, 9) - 1,
    bproof_2      = GetNumberOfPedTextureVariations       (playerPed, 9, Character['bproof_1']) - 1,
    chain_1       = GetNumberOfPedDrawableVariations      (playerPed, 7) - 1,
    chain_2       = GetNumberOfPedTextureVariations       (playerPed, 7, Character['chain_1']) - 1,
    bags_1        = GetNumberOfPedDrawableVariations      (playerPed, 5) - 1,
    bags_2        = GetNumberOfPedTextureVariations       (playerPed, 5, Character['bags_1']) - 1,
    helmet_1      = GetNumberOfPedPropDrawableVariations  (playerPed, 0) - 1,
    helmet_2      = GetNumberOfPedPropTextureVariations   (playerPed, 0, Character['helmet_1']) - 1,
    glasses_1     = GetNumberOfPedPropDrawableVariations  (playerPed, 1) - 1,
    glasses_2     = GetNumberOfPedPropTextureVariations   (playerPed, 1, Character['glasses_1'] - 1),
    watches_1		  = GetNumberOfPedPropDrawableVariations	(playerPed, 6) - 1,
		watches_2		  = GetNumberOfPedPropTextureVariations	  (playerPed, 6, Character['watches_1']) - 1,
		bracelets_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 7) - 1,
		bracelets_2		= GetNumberOfPedPropTextureVariations	  (playerPed, 7, Character['bracelets_1'] - 1),
}
return data

end

function ApplySkin(skin, clothes)
    local playerPed = PlayerPedId()

    for k,v in pairs(skin) do
        Character[k] = v
    end

    if clothes ~= nil then
		for k,v in pairs(clothes) do
			if
				k ~= 'sex'				and
				k ~= 'mom'				and
				k ~= 'dad'				and
				k ~= 'face_md_weight'	and
				k ~= 'skin_md_weight'	and
				k ~= 'nose_1'			and
				k ~= 'nose_2'			and
				k ~= 'nose_3'			and
				k ~= 'nose_4'			and
				k ~= 'nose_5'			and
				k ~= 'nose_6'			and
				k ~= 'cheeks_1'			and
				k ~= 'cheeks_2'			and
				k ~= 'cheeks_3'			and
				k ~= 'lip_thickness'	and
				k ~= 'jaw_1'			and
				k ~= 'jaw_2'			and
				k ~= 'chin_1'			and
				k ~= 'chin_2'			and
				k ~= 'chin_3'			and
				k ~= 'chin_4'			and
				k ~= 'neck_thickness'	and
				k ~= 'age_1'			and
				k ~= 'age_2'			and
				k ~= 'eye_color'		and
				k ~= 'eye_squint'		and
				k ~= 'beard_1'			and
				k ~= 'beard_2'			and
				k ~= 'beard_3'			and
				k ~= 'beard_4'			and
				k ~= 'hair_1'			and
				k ~= 'hair_2'			and
				k ~= 'hair_color_1'		and
				k ~= 'hair_color_2'		and
				k ~= 'eyebrows_1'		and
				k ~= 'eyebrows_2'		and
				k ~= 'eyebrows_3'		and
				k ~= 'eyebrows_4'		and
				k ~= 'eyebrows_5'		and
				k ~= 'eyebrows_6'		and
				k ~= 'makeup_1'			and
				k ~= 'makeup_2'			and
				k ~= 'makeup_3'			and
				k ~= 'makeup_4'			and
				k ~= 'lipstick_1'		and
				k ~= 'lipstick_2'		and
				k ~= 'lipstick_3'		and
				k ~= 'lipstick_4'		and
				k ~= 'blemishes_1'		and
				k ~= 'blemishes_2'		and
				k ~= 'blemishes_3'		and
				k ~= 'blush_1'			and
				k ~= 'blush_2'			and
				k ~= 'blush_3'			and
				k ~= 'complexion_1'		and
				k ~= 'complexion_2'		and
				k ~= 'sun_1'			and
				k ~= 'sun_2'			and
				k ~= 'moles_1'			and
				k ~= 'moles_2'			and
				k ~= 'chest_1'			and
				k ~= 'chest_2'			and
				k ~= 'chest_3'			and
				k ~= 'bodyb_1'			and
				k ~= 'bodyb_2'			and
				k ~= 'bodyb_3'			and
				k ~= 'bodyb_4'
			then
				Character[k] = v
			end
		end
	end

	if Character['face'] ~= nil and Character['skin'] ~= nil and Character['skin'] ~= 0 then
		SetPedHeadBlendData(playerPed, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
	else
        local face_weight = 0
        if Character['face_md_weight'] then
            face_weight = (Character['face_md_weight'] / 100) + 0.0
        end
	    local skin_weight =	0
        if Character['skin_md_weight'] then
            skin_weight = (Character['skin_md_weight'] / 100) + 0.0
        end
		SetPedHeadBlendData(playerPed, Character['mom'], Character['dad'], 0, Character['mom'], Character['dad'], 0, face_weight, skin_weight, 0.0, false)
	end

    if Character['nose_1'] == nil then Character['nose_1'] = 0 end
    if Character['nose_2'] == nil then Character['nose_2'] = 0 end
    if Character['nose_3'] == nil then Character['nose_3'] = 0 end
    if Character['nose_4'] == nil then Character['nose_4'] = 0 end
    if Character['nose_5'] == nil then Character['nose_5'] = 0 end
    if Character['nose_6'] == nil then Character['nose_6'] = 0 end
    if Character['eyebrows_5'] == nil then Character['eyebrows_5'] = 0 end
    if Character['eyebrows_6'] == nil then Character['eyebrows_6'] = 0 end
    if Character['cheeks_1'] == nil then Character['cheeks_1'] = 0 end
    if Character['cheeks_2'] == nil then Character['cheeks_2'] = 0 end
    if Character['cheeks_3'] == nil then Character['cheeks_3'] = 0 end
    if Character['eye_squint'] == nil then Character['eye_squint'] = 0 end
    if Character['lip_thickness'] == nil then Character['lip_thickness'] = 0 end
    if Character['jaw_1'] == nil then Character['jaw_1'] = 0 end
    if Character['jaw_2'] == nil then Character['jaw_2'] = 0 end
    if Character['chin_1'] == nil then Character['chin_1'] = 0 end
    if Character['chin_2'] == nil then Character['chin_2'] = 0 end
    if Character['chin_3'] == nil then Character['chin_3'] = 0 end
    if Character['chin_4'] == nil then Character['chin_4'] = 0 end
    if Character['neck_thickness'] == nil then Character['neck_thickness'] = 0 end

	SetPedFaceFeature		(playerPed,			0,								(Character['nose_1'] / 10) + 0.0)			-- Nose Width
	SetPedFaceFeature		(playerPed,			1,								(Character['nose_2'] / 10) + 0.0)			-- Nose Peak Height
	SetPedFaceFeature		(playerPed,			2,								(Character['nose_3'] / 10) + 0.0)			-- Nose Peak Length
	SetPedFaceFeature		(playerPed,			3,								(Character['nose_4'] / 10) + 0.0)			-- Nose Bone Height
	SetPedFaceFeature		(playerPed,			4,								(Character['nose_5'] / 10) + 0.0)			-- Nose Peak Lowering
	SetPedFaceFeature		(playerPed,			5,								(Character['nose_6'] / 10) + 0.0)			-- Nose Bone Twist
	SetPedFaceFeature		(playerPed,			6,								(Character['eyebrows_5'] / 10) + 0.0)		-- Eyebrow height
	SetPedFaceFeature		(playerPed,			7,								(Character['eyebrows_6'] / 10) + 0.0)		-- Eyebrow depth
	SetPedFaceFeature		(playerPed,			8,								(Character['cheeks_1'] / 10) + 0.0)			-- Cheekbones Height
	SetPedFaceFeature		(playerPed,			9,								(Character['cheeks_2'] / 10) + 0.0)			-- Cheekbones Width
	SetPedFaceFeature		(playerPed,			10,								(Character['cheeks_3'] / 10) + 0.0)			-- Cheeks Width
	SetPedFaceFeature		(playerPed,			11,								(Character['eye_squint'] / 10) + 0.0)		-- Eyes squint
	SetPedFaceFeature		(playerPed,			12,								(Character['lip_thickness'] / 10) + 0.0)	-- Lip Fullness
	SetPedFaceFeature		(playerPed,			13,								(Character['jaw_1'] / 10) + 0.0)			-- Jaw Bone Width
	SetPedFaceFeature		(playerPed,			14,								(Character['jaw_2'] / 10) + 0.0)			-- Jaw Bone Length
	SetPedFaceFeature		(playerPed,			15,								(Character['chin_1'] / 10) + 0.0)			-- Chin Height
	SetPedFaceFeature		(playerPed,			16,								(Character['chin_2'] / 10) + 0.0)			-- Chin Length
	SetPedFaceFeature		(playerPed,			17,								(Character['chin_3'] / 10) + 0.0)			-- Chin Width
	SetPedFaceFeature		(playerPed,			18,								(Character['chin_4'] / 10) + 0.0)			-- Chin Hole Size
	SetPedFaceFeature		(playerPed,			19,								(Character['neck_thickness'] / 10) + 0.0)	-- Neck Thickness

    -- SetPedHairColor         (playerPed,       29, 28)           -- Hair Color
    SetPedHairColor         (playerPed,       Character['hair_color_1'],   Character['hair_color_2'])           -- Hair Color
    SetPedHeadOverlay       (playerPed, 3,    Character['age_1'],         (Character['age_2'] / 10) + 0.0)      -- Age + opacity
    SetPedHeadOverlay       (playerPed, 1,    Character['beard_1'],       (Character['beard_2'] / 10) + 0.0)    -- Beard + opacity
    SetPedHeadOverlay       (playerPed, 2,    Character['eyebrows_1'],    (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
    SetPedHeadOverlay       (playerPed, 4,    Character['makeup_1'],      (Character['makeup_2'] / 10) + 0.0)   -- Makeup + opacity
    SetPedHeadOverlay       (playerPed, 8,    Character['lipstick_1'],    (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
    SetPedComponentVariation(playerPed, 2,    Character['hair_1'],         Character['hair_2'], 2)              -- Hair
    SetPedHeadOverlayColor  (playerPed, 1, 1, Character['beard_3'],        Character['beard_4'])                -- Beard Color
    SetPedHeadOverlayColor  (playerPed, 2, 1, Character['eyebrows_3'],     Character['eyebrows_4'])             -- Eyebrows Color
    SetPedHeadOverlayColor  (playerPed, 4, 1, Character['makeup_3'],       Character['makeup_4'])               -- Makeup Color
    SetPedHeadOverlayColor  (playerPed, 8, 1, Character['lipstick_3'],     Character['lipstick_4'])             -- Lipstick Color
    SetPedEyeColor			(playerPed,  Character['eye_color'], 0, 1)		

    if Character['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2)  -- Ears Accessories
    end

    SetPedComponentVariation(playerPed, 8,  Character['tshirt_1'],  Character['tshirt_2'], 2)     -- Tshirt
    SetPedComponentVariation(playerPed, 11, Character['torso_1'],   Character['torso_2'], 2)      -- torso parts
    if Character['arms_2'] == nil then Character['arms_2'] = 0 end
    SetPedComponentVariation(playerPed, 3,  Character['arms'], Character['arms_2'], 2)             -- arms + texture
    SetPedComponentVariation(playerPed, 10, Character['decals_1'],  Character['decals_2'], 2)     -- decals
    SetPedComponentVariation(playerPed, 4,  Character['pants_1'],   Character['pants_2'], 2)      -- pants
    SetPedComponentVariation(playerPed, 6,  Character['shoes_1'],   Character['shoes_2'], 2)      -- shoes
    SetPedComponentVariation(playerPed, 1,  Character['mask_1'],    Character['mask_2'], 2)       -- mask
    SetPedComponentVariation(playerPed, 9,  Character['bproof_1'],  Character['bproof_2'], 2)     -- bulletproof
    SetPedComponentVariation(playerPed, 7,  Character['chain_1'],   Character['chain_2'], 2)      -- chain
    SetPedComponentVariation(playerPed, 5,  Character['bags_1'],    Character['bags_2'], 2)       -- Bag

    if Character['helmet_1'] == -1 then
        ClearPedProp(playerPed, 0)
    else
        SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2)
    end

    SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2)

    if Character['watches_1'] == -1 then
	  	  ClearPedProp(playerPed, 6)
	  else
	  	  SetPedPropIndex(playerPed, 6,		Character['watches_1'],			Character['watches_2'], 2)
	  end

	  if Character['bracelets_1'] == -1 then
	  	  ClearPedProp(playerPed,	7)
	  else
	  	  SetPedPropIndex(playerPed, 7,		Character['bracelets_1'],		Character['bracelets_2'], 2)
	  end

end

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
  LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)

  local components = json.decode(json.encode(Components))

  for k,v in pairs(Character) do
    for i=1, #components, 1 do
      if k == components[i].name then
        components[i].value = v
      end
    end
  end

  cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val)

  Character[key] = val

  if key == 'sex' then
    TriggerEvent('skinchanger:loadSkin', Character)
  else
    ApplySkin(Character)
  end

end)

AddEventHandler('skinchanger:getSkin', function(cb)
  cb(Character)
end)

AddEventHandler('skinchanger:modelLoaded', function()

  ClearPedProp(PlayerPedId(), 0)

  if LoadSkin ~= nil then

    ApplySkin(LoadSkin)
    LoadSkin = nil

  end

  if LoadClothes ~= nil then

    ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
    LoadClothes = nil

  end

end)

RegisterNetEvent("skinchanger:LoadForTheFirsTime")
AddEventHandler("skinchanger:LoadForTheFirsTime", function(skin)
	while not NetworkIsSessionStarted() do Wait(1000) print("^2Waiting for session") end
	if skin['sex'] == 0 then
		skin['sex'] = 'mp_m_freemode_01'
	end
	RequestModel(GetHashKey(skin['sex']))
	Wait(200)
	while not HasModelLoaded(GetHashKey(skin['sex'])) do RequestModel(GetHashKey(skin['sex'])) Wait(100) end
	Wait(500)
	SetPlayerModel(GetPlayerIndex(), GetHashKey(skin['sex']))
	while not GetEntityModel(GetPlayerPed(-1)) == GetHashKey(skin['sex']) do Wait(300) SetPlayerModel(GetPlayerIndex(), GetHashKey(skin['sex'])) end
	SetPedDefaultComponentVariation(GetPlayerPed(-1))
	SetModelAsNoLongerNeeded(GetPlayerPed(-1))
	LoadSkin = skin
	if skin['sex'] == "mp_m_freemode_01" or skin['sex'] == "mp_f_freemode_01" then
		ApplySkin(skin)
    end
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if skin['sex'] == 0 then skin['sex'] = "mp_m_freemode_01" end
	if skin['sex'] == 1 then skin['sex'] = "mp_f_freemode_01" end

    local targetModel  = GetHashKey(skin['sex'])
    local currentModel = GetEntityModel(PlayerPedId())

    -- On force le swap de modele si le sexe a change OU si le ped courant n'est
    -- pas deja le bon modele freemode. Ce 2e cas couvre la race ou le
    -- spawnmanager a (re)applique le modele de map (skater) APRES un premier
    -- loadSkin : sans ca on ferait ApplySkin par-dessus le skater et le joueur
    -- resterait bloque en "perso non charge".
    if skin['sex'] ~= LastSex or currentModel ~= targetModel then
        LoadSkin = skin

        if skin['sex'] == "mp_m_freemode_01" then
            TriggerEvent('skinchanger:loadDefaultModel', true, cb)
        else
            TriggerEvent('skinchanger:loadDefaultModel', false, cb)
        end
    else
        ApplySkin(skin)

        if cb ~= nil then
            cb()
        end
    end

    LastSex = skin['sex']
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)

  if playerSkin['sex'] ~= LastSex then

    LoadClothes = {
      playerSkin  = playerSkin,
      clothesSkin = clothesSkin
    }

    if playerSkin['sex'] == 0 then
      TriggerEvent('skinchanger:loadDefaultModel', true)
    else
      TriggerEvent('skinchanger:loadDefaultModel', false)
    end

  else
    ApplySkin(playerSkin, clothesSkin)
  end

  LastSex = playerSkin['sex']

end)

RegisterNetEvent("skinchanger:applySkinToPed")
AddEventHandler("skinchanger:applySkinToPed", function(ped, skin, clothes)
    ApplySkinToPed(ped, skin, clothes)
end)

function ApplySkinToPed(ped, skin, clothes)
	local playerPed = ped
    local currentTable = {}

	for k,v in pairs(skin) do
		currentTable[k] = v
	end

	if clothes ~= nil then
		for k,v in pairs(clothes) do
			if
				k ~= 'sex'				and
				k ~= 'face'				and
				k ~= 'skin'				and
				k ~= 'age_1'			and
				k ~= 'age_2'			and
				k ~= 'eye_color'		and
				k ~= 'beard_1'			and
				k ~= 'beard_2'			and
				k ~= 'beard_3'			and
				k ~= 'beard_4'			and
				k ~= 'hair_1'			and
				k ~= 'hair_2'			and
				k ~= 'hair_color_1'		and
				k ~= 'hair_color_2'		and
				k ~= 'eyebrows_1'		and
				k ~= 'eyebrows_2'		and
				k ~= 'eyebrows_3'		and
				k ~= 'eyebrows_4'		and
				k ~= 'makeup_1'			and
				k ~= 'makeup_2'			and
				k ~= 'makeup_3'			and
				k ~= 'makeup_4'			and
				k ~= 'lipstick_1'		and
				k ~= 'lipstick_2'		and
				k ~= 'lipstick_3'		and
				k ~= 'lipstick_4'		and
				k ~= 'blemishes_1'		and
				k ~= 'blemishes_2'		and
				k ~= 'blush_1'			and
				k ~= 'blush_2'			and
				k ~= 'blush_3'			and
				k ~= 'complexion_1'		and
				k ~= 'complexion_2'		and
				k ~= 'sun_1'			and
				k ~= 'sun_2'			and
				k ~= 'moles_1'			and
				k ~= 'moles_2'			and
				k ~= 'chest_1'			and
				k ~= 'chest_2'			and
				k ~= 'chest_3'			and
				k ~= 'bodyb_1'			and
				k ~= 'bodyb_2'
			then
				currentTable[k] = v
			end
		end
	end

  SetPedHeadBlendData(playerPed, currentTable['mom'], currentTable['dad'], nil, currentTable['mom'], currentTable['dad'], nil, currentTable['face'], currentTable['skin'], nil, true)

	-- SetPedHeadBlendData			(playerPed, currentTable['face'], currentTable['face'], currentTable['face'], currentTable['skin'], currentTable['skin'], currentTable['skin'], 1.0, 1.0, 1.0, true)
	SetPedHairColor				(playerPed,			currentTable['hair_color_1'],		currentTable['hair_color_2'])					-- Hair Color
  if currentTable['age_1'] and currentTable['age_2'] then
	  SetPedHeadOverlay			(playerPed, 3,		currentTable['age_1'],				(currentTable['age_2'] / 10) + 0.0)			-- Age + opacity
  end
  if currentTable['blemishes_1'] and currentTable['blemishes_2'] then
	  SetPedHeadOverlay			(playerPed, 0,		currentTable['blemishes_1'],		(currentTable['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
  end
  if currentTable['beard_1'] and currentTable['beard_2'] then
	  SetPedHeadOverlay			(playerPed, 1,		currentTable['beard_1'],			(currentTable['beard_2'] / 10) + 0.0)			-- Beard + opacity
  end
	SetPedEyeColor				(playerPed,			currentTable['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		currentTable['eyebrows_1'],		(currentTable['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
  if currentTable['makeup_1'] and currentTable['makeup_2'] then
	  SetPedHeadOverlay			(playerPed, 4,		currentTable['makeup_1'],			(currentTable['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
  end
  if currentTable['lipstick_1'] and currentTable['lipstick_2'] then
	  SetPedHeadOverlay			(playerPed, 8,		currentTable['lipstick_1'],		(currentTable['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
  end
	SetPedComponentVariation	(playerPed, 2,		currentTable['hair_1'],			currentTable['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor		(playerPed, 1, 1,	currentTable['beard_3'],			currentTable['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	currentTable['eyebrows_3'],		currentTable['eyebrows_4'])					-- Eyebrows Color

	SetPedHeadOverlayColor		(playerPed, 4, 1,	currentTable['makeup_3'],			currentTable['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(playerPed, 8, 1,	currentTable['lipstick_3'],		currentTable['lipstick_4'])					-- Lipstick Color
  if currentTable['blush_1'] and currentTable['blush_2'] and currentTable['blush_3'] then
	  SetPedHeadOverlay			(playerPed, 5,		currentTable['blush_1'],			(currentTable['blush_2'] / 10) + 0.0)			-- Blush + opacity
	  SetPedHeadOverlayColor		(playerPed, 5, 2,	currentTable['blush_3'])														-- Blush Color
  end
  if currentTable['complexion_1'] and currentTable['complexion_2'] then
	  SetPedHeadOverlay			(playerPed, 6,		currentTable['complexion_1'],		(currentTable['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
  end
  if currentTable['sun_1'] and currentTable['sun_2'] then
	  SetPedHeadOverlay			(playerPed, 7,		currentTable['sun_1'],				(currentTable['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
  end
  if currentTable['moles_1'] and currentTable['moles_2'] then
	  SetPedHeadOverlay			(playerPed, 9,		currentTable['moles_1'],			(currentTable['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
  end
  if currentTable['chest_1'] and currentTable['chest_2'] then
	  SetPedHeadOverlay			(playerPed, 10,		currentTable['chest_1'],			(currentTable['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
  end
  if currentTable['chest_3'] then
	  SetPedHeadOverlayColor		(playerPed, 10, 1,	currentTable['chest_3'])														-- Torso Color
  end
  if currentTable['bodyb_1'] and currentTable['bodyb_2'] then
	  SetPedHeadOverlay			(playerPed, 11,		currentTable['bodyb_1'],			(currentTable['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity
  end
	if currentTable['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		currentTable['ears_1'],			currentTable['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation(playerPed, 8,		currentTable['tshirt_1'],			currentTable['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation(playerPed, 11,		currentTable['torso_1'],			currentTable['torso_2'], 2)					-- torso parts
	SetPedComponentVariation(playerPed, 3,		currentTable['arms'],				currentTable['arms_2'], 2)						-- Amrs
	SetPedComponentVariation(playerPed, 10,		currentTable['decals_1'],			currentTable['decals_2'], 2)					-- decals
	SetPedComponentVariation(playerPed, 4,		currentTable['pants_1'],			currentTable['pants_2'], 2)					-- pants
	SetPedComponentVariation(playerPed, 6,		currentTable['shoes_1'],			currentTable['shoes_2'], 2)					-- shoes
	SetPedComponentVariation(playerPed, 1,		currentTable['mask_1'],			currentTable['mask_2'], 2)						-- mask
	SetPedComponentVariation(playerPed, 9,		currentTable['bproof_1'],			currentTable['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation(playerPed, 7,		currentTable['chain_1'],			currentTable['chain_2'], 2)					-- chain
	SetPedComponentVariation(playerPed, 5,		currentTable['bags_1'],			currentTable['bags_2'], 2)						-- Bag
	ClearPedProp(playerPed, 0)
	if currentTable['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		currentTable['glasses_1'],			currentTable['glasses_2'], 2)					-- Glasses
	end
	if currentTable['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex			(playerPed, 6,		currentTable['watches_1'],			currentTable['watches_2'], 2)					-- Watches
	end
	if currentTable['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex			(playerPed, 7,		currentTable['bracelets_1'],		currentTable['bracelets_2'], 2)				-- Bracelets
	end

end