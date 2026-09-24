-- Luxart Vehicle Control - Radars avant / arriere (verrouillage automatique).
--
-- Affiche en permanence, dans le panneau LVC, la vitesse et la plaque du
-- premier vehicule capte devant et du premier vehicule capte derriere le
-- vehicule d'urgence. Aucune touche : tout est automatique.
--
-- Regles :
--   * Les radars mesurent uniquement au volant d'un vehicule d'urgence
--     (player_is_emerg_driver, cl_lvc.lua) et a partir de
--     radar_min_patrol_kmh (20 km/h). En dessous, afficheurs eteints.
--   * Des qu'un vehicule entre dans le cone (avant ou arriere), sa vitesse et
--     sa plaque sont VERROUILLEES : la lecture ne bouge plus (temoin LOCK).
--   * La lecture reste affichee tant que ce vehicule est dans le cone, puis
--     apres sa sortie, jusqu'a ce qu'un NOUVEAU vehicule soit capte (qui la
--     remplace), ou que la patrouille repasse sous la vitesse mini.
--
-- Perf : une mesure toutes les radar_tick_ms (250 ms) seulement au volant
-- d'un vehicule d'urgence, un seul parcours du pool vehicules pour les deux
-- radars, et la NUI n'est mise a jour que si une valeur affichee change.
----------------------------------------------------------------------

local RADAR_MAX_DIST   = radar_max_distance or 150.0
local RADAR_CONE_DEG   = radar_cone_deg or 8.0
local RADAR_TICK_MS    = radar_tick_ms or 250
local RADAR_MIN_PATROL = radar_min_patrol_kmh or 20
local RADAR_LOCK_BEEP  = radar_lock_beep ~= false

local IDLE = { has = false, speed = 0, plate = '', dist = 0, locked = false }

local last_sent = nil

-- Suivi par direction : entity = vehicule verrouille (nil une fois sorti du
-- cone), reading = lecture figee affichee.
local track_front = { entity = nil, reading = IDLE }
local track_rear  = { entity = nil, reading = IDLE }

local function sameReading(a, b)
    return a.has == b.has and a.speed == b.speed and a.plate == b.plate
        and a.dist == b.dist and a.locked == b.locked
end

local function sendUpdate(front, rear, patrol)
    if last_sent
        and last_sent.patrol == patrol
        and sameReading(last_sent.front, front)
        and sameReading(last_sent.rear, rear) then
        return
    end
    last_sent = { front = front, rear = rear, patrol = patrol }
    SendNUIMessage({
        _type  = 'radar:update',
        front  = front,
        rear   = rear,
        patrol = patrol,
        locked = (front.locked or rear.locked) == true,
    })
end

local function kmh(entity)
    return math.floor(GetEntitySpeed(entity) * 3.6 + 0.5)
end

local function trimPlate(p)
    if not p then return '' end
    return (tostring(p):gsub('^%s+', ''):gsub('%s+$', ''))
end

-- Au-dela de cette distance, on ne teste plus la ligne de vue : le trace
-- sur 300 m echoue des qu'il y a un peu de relief ou une legere pente,
-- alors que le vehicule est bien "devant". En dessous, on garde le test
-- pour ne pas capter a travers un mur / un batiment.
local RADAR_LOS_MAX = radar_los_max_distance or 120.0

-- Distance si `v` est dans le cone (dirSign = 1 avant, -1 arriere), sinon nil.
local function coneDistance(myVeh, origin, fwd, dirSign, cosMin, v)
    local diff = GetEntityCoords(v) - origin
    local d = #diff
    if d <= 1.0 or d > RADAR_MAX_DIST then return nil end
    -- Angle calcule a plat (x/y) : une cote ou une descente ne doit pas
    -- sortir la cible du cone.
    local fx, fy = fwd.x, fwd.y
    local fl = math.sqrt(fx * fx + fy * fy)
    local dl = math.sqrt(diff.x * diff.x + diff.y * diff.y)
    if fl < 0.001 or dl < 0.001 then return nil end
    local dot = dirSign * (diff.x * fx + diff.y * fy) / (fl * dl)
    if dot < cosMin then return nil end
    if d <= RADAR_LOS_MAX and not HasEntityClearLosToEntity(myVeh, v, 17) then return nil end
    return d
end

-- Lecture figee au moment de la capture.
local function lockReading(target, dist)
    return {
        has    = true,
        speed  = kmh(target),
        plate  = trimPlate(GetVehicleNumberPlateText(target)),
        dist   = math.floor(dist + 0.5),
        locked = true,
    }
end

-- Met a jour un suivi :
--   * cible accrochee toujours dans le cone -> sa vitesse est rafraichie en
--     direct (c'est le premier vehicule capte, on le garde tant qu'il est la) ;
--   * sinon on cherche un NOUVEAU vehicule dans le cone : s'il y en a un, il
--     devient la cible ; s'il n'y en a pas, la derniere lecture reste affichee.
local function updateTrack(track, myVeh, origin, fwd, dirSign, cosMin, pool)
    local cur = track.entity
    if cur then
        if DoesEntityExist(cur) then
            local d = coneDistance(myVeh, origin, fwd, dirSign, cosMin, cur)
            if d then
                track.reading = lockReading(cur, d) -- mise a jour en direct
                return false
            end
        end
        track.entity = nil -- sorti du cone : lecture conservee, on guette le suivant
    end

    local best, bestDist = nil, RADAR_MAX_DIST + 1.0
    for i = 1, #pool do
        local v = pool[i]
        if v ~= myVeh and v ~= cur then
            local d = coneDistance(myVeh, origin, fwd, dirSign, cosMin, v)
            if d and d < bestDist then
                best, bestDist = v, d
            end
        end
    end

    if best then
        track.entity  = best
        track.reading = lockReading(best, bestDist)
        return true
    end
    return false
end

local function scan(myVeh)
    local myPos  = GetEntityCoords(myVeh)
    local fwd    = GetEntityForwardVector(myVeh)
    local cosMin = math.cos(math.rad(RADAR_CONE_DEG))
    local pool   = GetGamePool('CVehicle')

    local newF = updateTrack(track_front, myVeh, myPos + fwd * 2.0, fwd,  1, cosMin, pool)
    local newR = updateTrack(track_rear,  myVeh, myPos - fwd * 2.0, fwd, -1, cosMin, pool)

    if (newF or newR) and RADAR_LOCK_BEEP then
        AUDIO:Play('Upgrade', AUDIO.upgrade_volume)
    end
end

local function clearTracks()
    track_front.entity, track_front.reading = nil, IDLE
    track_rear.entity,  track_rear.reading  = nil, IDLE
end

local function radarTick()
    local myVeh = veh
    if not myVeh or myVeh == 0 or not DoesEntityExist(myVeh) then return end

    local patrol = kmh(myVeh)

    -- En dessous de la vitesse mini, les radars sont au repos.
    if patrol < RADAR_MIN_PATROL then
        clearTracks()
        sendUpdate(IDLE, IDLE, patrol)
        return
    end

    scan(myVeh)
    sendUpdate(track_front.reading, track_rear.reading, patrol)
end

local function radarReset()
    last_sent = nil
    clearTracks()
    SendNUIMessage({ _type = 'radar:update', front = IDLE, rear = IDLE, patrol = 0, locked = false })
end

----------------------------------------------------------------------
-- Boucle : mesure uniquement au volant d'un vehicule d'urgence.
----------------------------------------------------------------------
CreateThread(function()
    local was_active = false
    while true do
        if player_is_emerg_driver then
            was_active = true
            radarTick()
            Wait(RADAR_TICK_MS)
        else
            if was_active then
                was_active = false
                radarReset()
            end
            Wait(1000)
        end
    end
end)

-- Changement de vehicule : on repart de zero.
AddEventHandler('lvc:onVehicleChange', function()
    radarReset()
end)

----------------------------------------------------------------------
-- Diagnostic F8 : /radardebug
-- Affiche l'etat du radar et, pour chaque vehicule a portee, sa distance,
-- son angle par rapport a l'avant et si la ligne de vue passe.
----------------------------------------------------------------------
RegisterCommand('radardebug', function()
    print('[LVC RADAR] script charge = oui')
    print(('[LVC RADAR] conducteur urgence = %s | veh = %s'):format(tostring(player_is_emerg_driver), tostring(veh)))
    local myVeh = veh
    if not myVeh or myVeh == 0 or not DoesEntityExist(myVeh) then
        print('[LVC RADAR] pas de vehicule -> radar au repos')
        return
    end
    local patrol = kmh(myVeh)
    print(('[LVC RADAR] vitesse patrouille = %d km/h (mini %d)'):format(patrol, RADAR_MIN_PATROL))
    print(('[LVC RADAR] verrou avant = %s | verrou arriere = %s'):format(
        track_front.reading.has and (track_front.reading.speed .. ' km/h ' .. track_front.reading.plate) or 'aucun',
        track_rear.reading.has  and (track_rear.reading.speed  .. ' km/h ' .. track_rear.reading.plate)  or 'aucun'))

    local myPos = GetEntityCoords(myVeh)
    local fwd   = GetEntityForwardVector(myVeh)
    local pool  = GetGamePool('CVehicle')
    print(('[LVC RADAR] vehicules dans le pool = %d | portee %.0f m | cone %.0f deg'):format(#pool, RADAR_MAX_DIST, RADAR_CONE_DEG))
    local n = 0
    for i = 1, #pool do
        local v = pool[i]
        if v ~= myVeh then
            local diff = GetEntityCoords(v) - myPos
            local d = #diff
            if d <= RADAR_MAX_DIST then
                n = n + 1
                local fl = math.sqrt(fwd.x * fwd.x + fwd.y * fwd.y)
                local dl = math.sqrt(diff.x * diff.x + diff.y * diff.y)
                local dot = (dl > 0.001 and fl > 0.001) and ((diff.x * fwd.x + diff.y * fwd.y) / (fl * dl)) or 0.0
                local angle = math.deg(math.acos(math.max(-1.0, math.min(1.0, dot))))
                local los = (d > RADAR_LOS_MAX) and 'ignoree' or tostring(HasEntityClearLosToEntity(myVeh, v, 17))
                print(('[LVC RADAR]  - %s | %.0f m | angle %.0f deg (%s) | LOS %s | %d km/h'):format(
                    trimPlate(GetVehicleNumberPlateText(v)), d, angle,
                    angle <= RADAR_CONE_DEG and 'AVANT' or (angle >= 180 - RADAR_CONE_DEG and 'ARRIERE' or 'hors cone'),
                    tostring(los), kmh(v)))
            end
        end
    end
    if n == 0 then print('[LVC RADAR] aucun vehicule a portee') end
end, false)
