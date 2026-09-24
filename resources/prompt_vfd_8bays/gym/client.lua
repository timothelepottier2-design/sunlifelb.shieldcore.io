-- VFD gym (client). Owns ONLY the static `gym` entity set (the fallback).
-- The animated equipment, when a core is present, is spawned by anim_core itself.
-- We read GlobalState.vfdGymAnimCore (set by our server): true = animated is up
-- (make sure the static set is OFF), false = show the static set. Never both.

local C = Config.VFDGym

local function warn(m) print('^3[vfd_gym] WARN:^7 ' .. m) end
local function dbg(m)  if C.debug then print('^5[vfd_gym]^7 ' .. m) end end

local current = GlobalState.vfdGymAnimCore   -- true / false / nil (server undecided)
local applied = nil                          -- last desired state we actually applied
local nearFails = 0                          -- consecutive interior-resolve failures while near
local warnedMissingSet = false

local function resolveInterior()
    local p = C.interiorProbe
    local id = GetInteriorAtCoords(p.x, p.y, p.z)
    if id ~= 0 and IsValidInterior(id) then return id end
    -- probe sat just outside the room volume: if we're right here, use our interior
    local ped = PlayerPedId()
    if #(GetEntityCoords(ped) - p) < 8.0 then
        id = GetInteriorFromEntity(ped)
        if id ~= 0 and IsValidInterior(id) then return id end
    end
    return nil
end

-- Returns true once the desired state is applied (interior resolved).
local function apply()
    if current == nil then return false end          -- server hasn't decided yet
    local wantStatic = (current == false)
    local id = resolveInterior()
    if not id then return false end                  -- interior not streamed → caller retries

    local isOn = IsInteriorEntitySetActive(id, C.entitySet)
    local changed = false
    if wantStatic and not isOn then
        ActivateInteriorEntitySet(id, C.entitySet); changed = true
    elseif not wantStatic and isOn then
        DeactivateInteriorEntitySet(id, C.entitySet); changed = true
    end
    if changed then RefreshInterior(id) end

    -- if we asked for the set ON but it never became active, the name is wrong / not in the ytyp
    if wantStatic and not IsInteriorEntitySetActive(id, C.entitySet) and not warnedMissingSet then
        warnedMissingSet = true
        warn(("entity set '%s' isn't in interior %d — check the name in prompt_vfd.ytyp."):format(C.entitySet, id))
    end

    applied = current
    dbg(('applied %s → set %s (interior %d)'):format(tostring(current), wantStatic and 'ON' or 'OFF', id))
    return true
end

-- Proximity-gated: only resolve/refresh the interior when the player is near the gym.
CreateThread(function()
    while true do
        local wait = 2000
        local dist = #(GetEntityCoords(PlayerPedId()) - C.interiorProbe)
        if dist <= (C.proximity or 60.0) then
            wait = 1000
            if applied ~= current and current ~= nil then
                if apply() then
                    nearFails = 0
                else
                    nearFails = nearFails + 1
                    if nearFails == 10 then
                        warn(("gym interior hasn't resolved at %s after ~10s nearby — is the MLO loaded? Try /vfdgymcheck."):format(C.interiorProbe))
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- Server flips the mode (anim_core start/stop, boot result) → re-apply.
AddStateBagChangeHandler('vfdGymAnimCore', 'global', function(_, _, value)
    current = value
    applied = nil
    nearFails = 0
    dbg('state → vfdGymAnimCore=' .. tostring(value))
end)

-- Owner diagnostic: dump interior resolution + entity-set state on demand.
RegisterCommand('vfdgymcheck', function()
    local p = C.interiorProbe
    local id = GetInteriorAtCoords(p.x, p.y, p.z)
    local valid = id ~= 0 and IsValidInterior(id)
    local me = GetEntityCoords(PlayerPedId())
    print('^5[vfd_gym] ── check ──^7')
    print(('  mode=%s  animCore(server)=%s  applied=%s'):format(C.mode, tostring(current), tostring(applied)))
    print(('  probe %s → interior=%s valid=%s'):format(p, tostring(id), tostring(valid)))
    if valid then
        print(("  entity set '%s' active=%s"):format(C.entitySet, tostring(IsInteriorEntitySetActive(id, C.entitySet))))
    end
    print(('  you@ %.2f %.2f %.2f  curInterior=%s  dist=%.1fm'):format(
        me.x, me.y, me.z, tostring(GetInteriorFromEntity(PlayerPedId())), #(me - p)))
end, false)
