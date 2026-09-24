-- Anti "recuperation de vehicule a distance" (warp-in / vehicle-warp des mod
-- menus).
--
-- Trois signaux independants, tous evalues a l'instant ou le joueur apparait
-- assis dans un vehicule qu'il n'occupait pas :
--
--   1. DISTANCE  : sa derniere position DE CONFIANCE (l'ancre) doit etre a
--      moins de VE_MAX_DIST du vehicule (une entree legitime passe par la
--      portiere). L'ancre est GELEE pendant VE_RETRUST_MS des qu'un
--      deplacement physiquement impossible est detecte : se teleporter a cote
--      de la voiture puis monter ne blanchit donc plus la montee, il faut
--      rester sur place VE_RETRUST_MS avant que la nouvelle position redevienne
--      une reference.
--   2. VEHICULE TELEPORTE : le vehicule lui-meme ne doit pas avoir saute vers
--      le joueur dans les VE_VEH_JUMP_MS (menus "amener le vehicule a moi").
--   3. SIEGE PRIS : un vehicule occupe par un AUTRE joueur ne peut etre rejoint
--      qu'apres une vraie tache d'entree (animation de portiere). Sans tache,
--      le seuil de distance tombe a VE_TAKE_DIST.
--
-- Sanction : ejection + retour a l'ancre, puis re-ejection immediate pendant
-- VE_BAN_MS (les menus re-warpent en boucle), et report serveur throttle.
--
-- Faux positifs couverts :
--   - sorties de garage / concess / jobs / farms : zones motif du sv_config
--     (envoyees par le serveur, memes positions que le guard entityCreating).
--     Les zones neutralisent aussi la detection de teleportation du joueur.
--   - scripts qui warp le joueur dans un vehicule : ecran en fondu, ou grace
--     explicite via export vehEnterGrace / event antisbire:vehEnterGrace
--     (la grace degele aussi l'ancre).
--   - vehicule frais : un vehicule apparu il y a moins de VE_MIN_AGE_MS dans
--     le pool local est un spawn de script (permis, bobcat, livreur, previews
--     de garage de propriete...) qui warp le joueur dedans juste apres l'avoir
--     cree. Les spawns non autorises sont deja bloques cote serveur par le
--     guard entityCreating. Cette exemption ne s'applique PLUS si un autre
--     joueur est a bord, si le vehicule vient de sauter, ou si le joueur vient
--     de se teleporter.
--   - re-entree : re-monter dans un vehicule qu'on occupait il y a moins de
--     VE_REENTER_MS n'est pas une prise de controle (re-tp de l'examen du
--     permis, re-seat apres suppression/resync du camion bobcat...).
--   - ped attache (AttachEntityToEntity) : portage de joueurs, brancard,
--     escorte menottee... les coordonnees sautent avec le porteur.
--   - ragdoll / chute / parachute / saut, montee-descente de vehicule : la
--     detection de teleportation y est desactivee.
--   - respawn / staff

local VE_MAX_DIST     = 10.0
local VE_MAX_DIST_SQ  = VE_MAX_DIST * VE_MAX_DIST
-- Seuil resserre quand un autre joueur est deja a bord ET qu'aucune tache
-- d'entree n'a ete vue : on ne "glisse" pas dans la voiture d'un autre.
local VE_TAKE_DIST_SQ = 6.0 * 6.0
local VE_POLL_MS      = 10    -- echantillonnage a la frame (volontairement peu optimise)
local VE_SCAN_MS      = 250   -- periodicite du scan du pool vehicules
local VE_REPORT_MS    = 5000
local VE_EVENT        = "mv58_ktz2qw"
local VE_MIN_AGE_MS   = 10000 -- age minimal du vehicule pour etre flaggable
local VE_REENTER_MS   = 60000 -- fenetre pendant laquelle re-entrer est permis
local VE_TASK_MS      = 6000  -- duree de validite d'une tache d'entree observee
local VE_BAN_MS       = 8000  -- re-ejection auto apres un flag

-- Teleportation du JOUEUR : un deplacement est impossible s'il depasse
-- vitesse_mesuree * dt * VE_TP_FACTOR + VE_TP_MARGIN (jamais moins de
-- VE_TP_MIN). Une chaine de micro-sauts (chacun sous le seuil dur) est
-- rattrapee par l'accumulateur VE_HOP_*.
local VE_TP_FACTOR     = 2.5
local VE_TP_MARGIN     = 6.0
local VE_TP_MIN        = 8.0
local VE_RETRUST_MS    = 5000
local VE_HOP_MIN       = 2.5
local VE_HOP_MARGIN    = 2.0
local VE_HOP_WINDOW_MS = 3000
local VE_HOP_TOTAL     = 12.0
-- Fenetre apres une descente de vehicule pendant laquelle on ne juge pas les
-- deplacements (animation de sortie, ejection, resync).
local VE_VEH_EXIT_MS   = 1500

-- Teleportation du VEHICULE : meme principe, avec une marge large (les resyncs
-- reseau des vehicules distants font des bonds). Le saut n'est retenu que s'il
-- amene le vehicule PRES du joueur : c'est la signature du "bring vehicle to
-- me", pas celle d'un resync quelconque.
local VE_VEH_JUMP_FACTOR  = 2.0
local VE_VEH_JUMP_MIN     = 30.0
local VE_VEH_JUMP_NEAR_SQ = 60.0 * 60.0
local VE_VEH_JUMP_MS      = 10000
local VE_VEH_JUMP_MIN_AGE = 3000

-- Classes de vehicules exclues du kick "prise de controle" tant qu'aucun autre
-- joueur n'est a bord : 14 = bateaux, 15 = helicopteres, 16 = avions.
local VE_SKIP_CLASS  = { [14] = true, [15] = true, [16] = true }

-- Zones motif recues du serveur : { {x, y, z, r2}, ... }
local veZones = nil

RegisterNetEvent('eye:veh:zones:data', function(data)
    if type(data) == 'table' then veZones = data end
end)

CreateThread(function()
    while veZones == nil do
        TriggerServerEvent('eye:veh:zones:req')
        Wait(5000)
    end
end)

local function veInZone(x, y, z)
    local zs = veZones
    if not zs then return false end
    for i = 1, #zs do
        local zn = zs[i]
        local dx, dy, dz = x - zn[1], y - zn[2], z - zn[3]
        if (dx * dx + dy * dy + dz * dz) <= zn[4] then return true end
    end
    return false
end

local veIsStaff = false
RegisterNetEvent('antisbire:nc:staffResult', function(v)
    if v == true then veIsStaff = true end
end)

local veGraceUntil = 0
-- Remis a zero par la grace : un script qui annonce un warp legitime annule
-- aussi le gel de l'ancre qu'il vient peut-etre de provoquer.
local veUnfreeze   = false

local function veGrace(ms)
    local until_ = GetGameTimer() + (tonumber(ms) or 5000)
    if until_ > veGraceUntil then veGraceUntil = until_ end
    veUnfreeze = true
end

exports('vehEnterGrace', veGrace)
RegisterNetEvent('antisbire:vehEnterGrace', function(ms) veGrace(ms) end)

AddEventHandler('playerSpawned', function()
    veGrace(8000)
end)

-- ---------------------------------------------------------------------------
-- Suivi du pool vehicules : premiere apparition locale + detection de saut.
-- ---------------------------------------------------------------------------
local veFirstSeen = {}   -- [veh] = ms de la premiere apparition dans le pool
local veLastPos   = {}   -- [veh] = { x, y, z } de la derniere passe
local veJumpAt    = {}   -- [veh] = ms du dernier saut vers le joueur

CreateThread(function()
    local lastScan = GetGameTimer()

    while true do
        Wait(VE_SCAN_MS)

        local now = GetGameTimer()
        local dt  = (now - lastScan) / 1000.0
        lastScan  = now
        if dt <= 0.0 then dt = 0.001 end

        local ppos = GetEntityCoords(PlayerPedId())
        local pool = GetGamePool('CVehicle')
        local seen = {}

        for i = 1, #pool do
            local v = pool[i]
            seen[v] = true

            local c     = GetEntityCoords(v)
            local first = veFirstSeen[v]
            local prev  = veLastPos[v]

            if not first or not prev then
                veFirstSeen[v] = first or now
                veLastPos[v]   = { c.x, c.y, c.z }
            else
                local dx, dy, dz = c.x - prev[1], c.y - prev[2], c.z - prev[3]
                local moved = math.sqrt(dx * dx + dy * dy + dz * dz)
                local allow = GetEntitySpeed(v) * dt * VE_VEH_JUMP_FACTOR + VE_VEH_JUMP_MIN

                if moved > allow and (now - first) > VE_VEH_JUMP_MIN_AGE then
                    local px, py, pz = c.x - ppos.x, c.y - ppos.y, c.z - ppos.z
                    if (px * px + py * py + pz * pz) <= VE_VEH_JUMP_NEAR_SQ then
                        veJumpAt[v] = now
                    end
                end

                prev[1], prev[2], prev[3] = c.x, c.y, c.z
            end
        end

        for v in pairs(veFirstSeen) do
            if not seen[v] then
                veFirstSeen[v] = nil
                veLastPos[v]   = nil
                veJumpAt[v]    = nil
            end
        end
    end
end)

-- Un vehicule est "frais" s'il est apparu localement il y a peu : c'est un
-- spawn de script qui warp le joueur dedans (le guard serveur bloque deja les
-- spawns non autorises).
local function veIsFresh(veh, now)
    local first = veFirstSeen[veh]
    if not first then return true end
    return (now - first) <= VE_MIN_AGE_MS
end

local function veOtherPlayerAboard(veh, ped)
    for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
        local p = GetPedInVehicleSeat(veh, seat)
        if p ~= 0 and p ~= ped and IsPedAPlayer(p) then return true end
    end
    return false
end

local function veEject(ped, veh, x, y, z)
    ClearPedTasksImmediately(ped)
    if veh ~= 0 and DoesEntityExist(veh) and GetVehiclePedIsIn(ped, false) ~= 0 then
        TaskLeaveVehicle(ped, veh, 16)
    end
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    ClearPedTasksImmediately(ped)
end

-- ---------------------------------------------------------------------------
-- Boucle principale.
-- ---------------------------------------------------------------------------
CreateThread(function()
    local anchorX, anchorY, anchorZ = 0.0, 0.0, 0.0
    local hasAnchor   = false
    local frozenUntil = 0

    local prevX, prevY, prevZ = 0.0, 0.0, 0.0
    local prevT     = 0
    local prevSpeed = 0.0
    local hasPrev   = false

    local hopTotal = 0.0
    local hopStart = 0

    local lastVeh     = 0
    local lastInVehAt = 0
    local lastReport  = 0
    local selfTpUntil = 0

    local taskVeh, taskAt = 0, 0

    -- occupiedAt[veh] = derniere fois assis dedans (re-entree autorisee)
    -- banned[veh]     = date jusqu'a laquelle toute montee est re-ejectee
    local occupiedAt = {}
    local banned     = {}
    local lastPurge  = 0

    Wait(5000)

    while true do
        Wait(VE_POLL_MS)

        local ped = PlayerPedId()
        local now = GetGameTimer()

        if veUnfreeze then
            veUnfreeze  = false
            frozenUntil = 0
            hopTotal    = 0.0
        end

        local skip = ped == 0 or IsEntityDead(ped) or veIsStaff
            or now < veGraceUntil
            or IsScreenFadedOut() or IsScreenFadingOut() or IsScreenFadingIn()
            or IsPlayerSwitchInProgress()
            -- portage / brancard / escorte : le ped est attache a un autre ped
            -- ou a un objet, ses coordonnees suivent le porteur. (Ne PAS tester
            -- IsEntityAttached : il est vrai pour un ped assis dans un vehicule
            -- et desactiverait tout le check.)
            or IsEntityAttachedToAnyPed(ped)
            or IsEntityAttachedToAnyObject(ped)

        if skip then
            hasAnchor   = false
            hasPrev     = false
            frozenUntil = 0
            hopTotal    = 0.0
            lastVeh = GetVehiclePedIsIn(ped, false)
            if lastVeh ~= 0 then
                occupiedAt[lastVeh] = now
                lastInVehAt = now
            end
        else
            local pc  = GetEntityCoords(ped)
            local spd = GetEntitySpeed(ped)
            local veh = GetVehiclePedIsIn(ped, false)

            -- Tache d'entree reelle (le ped marche vers la portiere et joue
            -- l'animation). Un warp n'en produit jamais.
            local te = GetVehiclePedIsTryingToEnter(ped)
            if te ~= 0 then taskVeh, taskAt = te, now end

            -- ---- 1. detection de teleportation du joueur -------------------
            if hasPrev then
                local dt = (now - prevT) / 1000.0
                if dt <= 0.0 then dt = 0.001 end

                local dx, dy, dz = pc.x - prevX, pc.y - prevY, pc.z - prevZ
                local moved = math.sqrt(dx * dx + dy * dy + dz * dz)

                -- On ne juge que le joueur a pied et stable : les animations de
                -- montee/descente, le ragdoll, la chute libre et le parachute
                -- deplacent le ped bien plus vite que sa vitesse mesuree.
                local stable = veh == 0 and lastVeh == 0
                    and (now - lastInVehAt) > VE_VEH_EXIT_MS
                    and now >= selfTpUntil
                    and not IsPedRagdoll(ped)
                    and not IsPedFalling(ped)
                    and not IsPedJumping(ped)
                    and not IsPedInParachuteFreeFall(ped)

                if stable then
                    local ref  = (spd > prevSpeed) and spd or prevSpeed
                    local base = ref * dt * VE_TP_FACTOR
                    local hard = base + VE_TP_MARGIN
                    if hard < VE_TP_MIN then hard = VE_TP_MIN end

                    local jumped = false
                    if moved > hard then
                        jumped = true
                    elseif moved > VE_HOP_MIN and moved > (base + VE_HOP_MARGIN) then
                        -- micro-saut : seul, il ne prouve rien ; accumule sur
                        -- VE_HOP_WINDOW_MS, il trahit un deplacement par bonds.
                        if (now - hopStart) > VE_HOP_WINDOW_MS then
                            hopStart = now
                            hopTotal = 0.0
                        end
                        hopTotal = hopTotal + moved
                        if hopTotal >= VE_HOP_TOTAL then jumped = true end
                    end

                    if jumped
                        and not veInZone(pc.x, pc.y, pc.z)
                        and not veInZone(prevX, prevY, prevZ) then
                        frozenUntil = now + VE_RETRUST_MS
                        hopTotal    = 0.0
                    end
                else
                    hopTotal = 0.0
                    hopStart = now
                end
            end

            -- ---- ancre : derniere position atteinte par un vrai deplacement -
            if not hasAnchor then
                anchorX, anchorY, anchorZ = pc.x, pc.y, pc.z
                hasAnchor = true
            elseif now >= frozenUntil then
                anchorX, anchorY, anchorZ = pc.x, pc.y, pc.z
            end

            local ban = (veh ~= 0) and banned[veh] or nil

            if ban and now < ban then
                -- Le menu re-warpe en boucle : on re-ejecte sans re-logger.
                veEject(ped, veh, anchorX, anchorY, anchorZ)
                selfTpUntil = now + 1000
                veh = 0

            elseif veh ~= 0 and veh ~= lastVeh and hasAnchor and veZones
                and DoesEntityExist(veh)
                -- si le vehicule qu'on occupait vient d'etre supprime, le
                -- nouveau handle est un resync reseau (suppression/recreation,
                -- ex. camion bobcat livre), pas une prise de controle
                and (lastVeh == 0 or DoesEntityExist(lastVeh))
                -- re-entree dans un vehicule qu'on occupait il y a peu
                and not (occupiedAt[veh] and (now - occupiedAt[veh]) < VE_REENTER_MS)
            then
                local vc = GetEntityCoords(veh)
                local dx, dy, dz = vc.x - anchorX, vc.y - anchorY, vc.z - anchorZ
                local d2 = dx * dx + dy * dy + dz * dz

                local others  = veOtherPlayerAboard(veh, ped)
                local vJumped = veJumpAt[veh] and (now - veJumpAt[veh]) < VE_VEH_JUMP_MS
                local frozen  = now < frozenUntil
                local hadTask = taskVeh == veh and (now - taskAt) < VE_TASK_MS

                -- L'exemption "spawn de script" saute des qu'un des trois
                -- signaux de vol est present.
                local fresh = (not others) and (not vJumped) and (not frozen)
                    and veIsFresh(veh, now)

                local guarded = others or not VE_SKIP_CLASS[GetVehicleClass(veh)]
                local inZone  = veInZone(vc.x, vc.y, vc.z)
                    or veInZone(anchorX, anchorY, anchorZ)

                local reason = nil
                if guarded and not fresh and not inZone then
                    if d2 > VE_MAX_DIST_SQ then
                        reason = "distance"
                    elseif vJumped and not hadTask then
                        -- Un joueur qui marche jusqu'a la portiere produit une
                        -- vraie tache d'entree : la seule montee suspecte dans
                        -- un vehicule qui vient de sauter est celle sans tache.
                        -- (Filtre les corrections reseau des vehicules laggy.)
                        reason = "vehicule teleporte"
                    elseif others and not hadTask and d2 > VE_TAKE_DIST_SQ then
                        reason = "siege occupe pris"
                    end
                end

                if reason then
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                    local dist  = math.sqrt(d2)

                    banned[veh] = now + VE_BAN_MS
                    veEject(ped, veh, anchorX, anchorY, anchorZ)
                    selfTpUntil = now + 1000
                    veh = 0

                    if (now - lastReport) >= VE_REPORT_MS then
                        lastReport = now
                        TriggerServerEvent(VE_EVENT, dist, model, reason)
                    end
                end
            end

            lastVeh = veh
            if veh ~= 0 then
                occupiedAt[veh] = now
                lastInVehAt = now
            end

            prevX, prevY, prevZ = pc.x, pc.y, pc.z
            prevT     = now
            prevSpeed = spd
            hasPrev   = true
        end

        if (now - lastPurge) > 10000 then
            lastPurge = now
            for v, t in pairs(occupiedAt) do
                if (now - t) > VE_REENTER_MS then occupiedAt[v] = nil end
            end
            for v, t in pairs(banned) do
                if now > t then banned[v] = nil end
            end
        end
    end
end)
