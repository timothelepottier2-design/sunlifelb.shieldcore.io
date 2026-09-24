-- Luxart Vehicle Control - Utilities (slim, no menu/HUD/STORAGE/Lang deps).

UTIL = {}

local approved_tones      = nil
local profile             = nil

local tone_main_mem_id    = nil
local tone_PMANU_id       = nil
local tone_SMANU_id       = nil
local tone_AUX_id         = nil
local tone_ARHRN_id       = nil

----------------------------------------------------------------------
-- Vehicle profile resolution against SIREN_ASSIGNMENTS.
----------------------------------------------------------------------
local function GetProfileFromTable(tbl, veh)
    if tbl == nil then return {}, false end

    local veh_name = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    if tbl[veh_name] then
        return tbl[veh_name], veh_name
    end

    local trail_only_wildcard = veh_name:gsub('%d+$', '#')
    if tbl[trail_only_wildcard] then
        return tbl[trail_only_wildcard], trail_only_wildcard
    end

    local lead_and_trail_wildcard = veh_name:gsub('%d+', '#')
    if tbl[lead_and_trail_wildcard] then
        return tbl[lead_and_trail_wildcard], lead_and_trail_wildcard
    end

    if tbl['DEFAULT'] then
        return tbl['DEFAULT'], 'DEFAULT'
    end

    return {}, false
end

----------------------------------------------------------------------
-- GTA only allows 11-char gameNames - truncate keys silently.
----------------------------------------------------------------------
function UTIL:FixOversizeKeys(TABLE)
    for k, _ in pairs(TABLE) do
        if #k > 11 then
            local short = string.sub(k, 1, 11)
            TABLE[short] = TABLE[k]
            TABLE[k] = nil
        end
    end
end

----------------------------------------------------------------------
-- Resolve approved_tones for the current vehicle and seed default tones.
----------------------------------------------------------------------
function UTIL:UpdateApprovedTones(veh)
    approved_tones, profile = GetProfileFromTable(SIREN_ASSIGNMENTS, veh)

    if profile then
        if not UTIL:IsApprovedTone(tone_main_mem_id) then UTIL:SetToneByPos('MAIN_MEM', 2) end
        if not UTIL:IsApprovedTone(tone_PMANU_id)    then UTIL:SetToneByPos('PMANU',    2) end
        if not UTIL:IsApprovedTone(tone_SMANU_id)    then UTIL:SetToneByPos('SMANU',    3) end
        if not UTIL:IsApprovedTone(tone_AUX_id)      then UTIL:SetToneByPos('AUX',      2) end
        if not UTIL:IsApprovedTone(tone_ARHRN_id)    then UTIL:SetToneByPos('ARHRN',    1) end
    end
end

function UTIL:GetApprovedTonesTable()
    return approved_tones or {}
end

function UTIL:GetVehicleProfileName()
    return profile
end

----------------------------------------------------------------------
-- Tone ID accessors.
----------------------------------------------------------------------
function UTIL:GetToneID(tone_string)
    if     tone_string == 'MAIN_MEM' then return tone_main_mem_id
    elseif tone_string == 'PMANU'    then return tone_PMANU_id
    elseif tone_string == 'SMANU'    then return tone_SMANU_id
    elseif tone_string == 'AUX'      then return tone_AUX_id
    elseif tone_string == 'ARHRN'    then return tone_ARHRN_id end
end

function UTIL:SetToneByPos(tone_string, pos)
    if not profile or not approved_tones or not approved_tones[pos] then return end
    local id = approved_tones[pos]
    if     tone_string == 'MAIN_MEM' then tone_main_mem_id = id
    elseif tone_string == 'PMANU'    then tone_PMANU_id    = id
    elseif tone_string == 'SMANU'    then tone_SMANU_id    = id
    elseif tone_string == 'AUX'      then tone_AUX_id      = id
    elseif tone_string == 'ARHRN'    then tone_ARHRN_id    = id end
end

function UTIL:SetToneByID(tone_string, tone_id)
    if not UTIL:IsApprovedTone(tone_id) then return end
    if     tone_string == 'MAIN_MEM' then tone_main_mem_id = tone_id
    elseif tone_string == 'PMANU'    then tone_PMANU_id    = tone_id
    elseif tone_string == 'SMANU'    then tone_SMANU_id    = tone_id
    elseif tone_string == 'AUX'      then tone_AUX_id      = tone_id
    elseif tone_string == 'ARHRN'    then tone_ARHRN_id    = tone_id end
end

function UTIL:GetToneAtPos(pos)
    return approved_tones and approved_tones[pos] or nil
end

function UTIL:IsApprovedTone(tone)
    if not tone or not approved_tones then return false end
    for _, t in ipairs(approved_tones) do
        if t == tone then return true end
    end
    return false
end

----------------------------------------------------------------------
-- Cycle to the next siren tone for the given vehicle.
-- main_tone=true skips disabled / button-only tones (option > 2).
----------------------------------------------------------------------
function UTIL:GetNextSirenTone(current_tone, _veh, main_tone, last_pos)
    if not approved_tones or #approved_tones < 2 then return current_tone end

    local pos = last_pos
    if not pos then
        for i, id in ipairs(approved_tones) do
            if id == current_tone then pos = i break end
        end
    end
    pos = pos or 1

    if pos < #approved_tones then pos = pos + 1 else pos = 2 end

    return approved_tones[pos]
end
