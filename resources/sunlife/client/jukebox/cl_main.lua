ESX = nil

local PUBLIC_KEY = "__public__"

local currentZone = nil
local currentZoneJob = nil
local currentJob = nil
local zoneStates = {}
local jukeboxMenuOpen = false

local volumeLabels = {}
for i = 0, 20 do
    volumeLabels[#volumeLabels + 1] = (i * 5) .. "%"
end

local volumeIndex = 11

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj)
            ESX = obj
        end)
        Citizen.Wait(500)
    end

    local data = ESX.GetPlayerData()
    while not data or not data.job do
        Citizen.Wait(100)
        data = ESX.GetPlayerData()
    end

    ESX.PlayerData = data
    currentJob = data.job and data.job.name or nil
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    currentJob = xPlayer.job and xPlayer.job.name or nil
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    ESX.PlayerData.job = job
    currentJob = job.name
end)

local function buildSoundId(job, zoneId)
    return "jobmusic_" .. job .. "_" .. zoneId
end

local function getAccessibleZones()
    local list = {}

    if currentJob and cfg_jukebox and cfg_jukebox.JobMusicZones and cfg_jukebox.JobMusicZones[currentJob] then
        for _, z in ipairs(cfg_jukebox.JobMusicZones[currentJob]) do
            list[#list + 1] = { zone = z, jobKey = currentJob }
        end
    end

    if cfg_jukebox and cfg_jukebox.PublicZones then
        for _, z in ipairs(cfg_jukebox.PublicZones) do
            list[#list + 1] = { zone = z, jobKey = PUBLIC_KEY }
        end
    end

    return list
end

-- =========================================================================
-- LECTURE. Le serveur envoie un payload complet { link, index, volume,
-- distance, position, seek, playing } :
--   * seek    : position dans le morceau au moment de l'envoi (s). Appliquee
--               UNE FOIS le lecteur pret (onPlayStart de xsound), sinon le
--               seekTo YouTube est perdu et le retardataire repart de zero.
--   * playing : false = la zone est en pause, on charge puis on met en pause.
-- La fin naturelle d'un morceau est signalee au serveur une seule fois par
-- lecture ; une destruction volontaire (stop, sortie de zone) ne l'est pas.
-- =========================================================================
local manualDestroy = {}
local endReported   = {}

local function destroySound(id)
    if exports.xsound:soundExists(id) then
        manualDestroy[id] = true
        exports.xsound:Destroy(id)
    end
    manualDestroy[id] = nil
    endReported[id] = nil
end

local function startSound(id, job, zoneId, data)
    if not data or not data.link or not data.position then return end

    -- Un son du meme id encore charge (ancien morceau) : on le detruit
    -- proprement pour que sa fin ne soit pas signalee comme naturelle.
    destroySound(id)

    local receivedAt = GetGameTimer()
    local seek = tonumber(data.seek) or 0.0
    local index, link = data.index, data.link

    exports.xsound:PlayUrlPos(id, link, data.volume or 0.5, data.position, false, {
        onPlayStart = function()
            if seek > 0.5 then
                -- + temps ecoule entre l'envoi serveur et le lecteur pret.
                local target = seek + (GetGameTimer() - receivedAt) / 1000.0
                exports.xsound:setTimeStamp(id, target)
            end
            if data.playing == false then
                exports.xsound:Pause(id)
            end
        end,
        onPlayEnd = function()
            if manualDestroy[id] then return end
            if endReported[id] then return end
            endReported[id] = true
            TriggerServerEvent("jobmusic:trackEnded", job, zoneId, index, link)
        end,
    })
    exports.xsound:Distance(id, data.distance or (cfg_jukebox.DefaultDistance or 40.0))
end

RegisterNetEvent("jobmusic:soundStatus")
AddEventHandler("jobmusic:soundStatus", function(type, job, zoneId, data)
    local id = buildSoundId(job, zoneId)

    if type == "play" then
        startSound(id, job, zoneId, data)
    elseif type == "stop" then
        destroySound(id)
    elseif type == "pause" then
        if exports.xsound:soundExists(id) then
            exports.xsound:Pause(id)
        end
    elseif type == "resume" then
        if exports.xsound:soundExists(id) then
            exports.xsound:Resume(id)
            if data and tonumber(data.seek) then
                exports.xsound:setTimeStamp(id, tonumber(data.seek))
            end
        else
            -- Pas de son charge (entre pendant la pause, ou son detruit) :
            -- le payload de reprise permet de demarrer au bon endroit.
            startSound(id, job, zoneId, data)
        end
    elseif type == "volume" then
        if exports.xsound:soundExists(id) and data and data.volume then
            -- Son positionnel : c'est le volume MAX qu'il faut changer, le
            -- volume courant est recalcule par xsound selon la distance.
            exports.xsound:setVolumeMax(id, data.volume)
        end
    end
end)

RegisterNetEvent("jobmusic:syncZoneState")
AddEventHandler("jobmusic:syncZoneState", function(job, zoneId, data)
    zoneStates[job] = zoneStates[job] or {}
    if not data then
        zoneStates[job][zoneId] = {
            queue = {},
            current = 0,
            playing = false,
            volume = cfg_jukebox.DefaultVolume or 0.5
        }
    else
        zoneStates[job][zoneId] = data
        if not zoneStates[job][zoneId].volume then
            zoneStates[job][zoneId].volume = cfg_jukebox.DefaultVolume or 0.5
        end
    end
end)

RegisterNetEvent("jobmusic:addTrackResult")
AddEventHandler("jobmusic:addTrackResult", function(success, titleOrMsg)
    if success then
        ESX.ShowNotification("~y~Musique ajoutée : ~s~" .. tostring(titleOrMsg))
    else
        ESX.ShowNotification("~r~Erreur: ~s~" .. tostring(titleOrMsg))
    end
end)

local function getZoneDefinition(jobKey, zoneId)
    if not cfg_jukebox then
        return nil
    end

    local zones
    if jobKey == PUBLIC_KEY then
        zones = cfg_jukebox.PublicZones
    elseif cfg_jukebox.JobMusicZones then
        zones = cfg_jukebox.JobMusicZones[jobKey]
    end

    if not zones then
        return nil
    end

    for _, z in ipairs(zones) do
        if z.id == zoneId then
            return z
        end
    end

    return nil
end

local function getCurrentZoneState()
    if not currentZoneJob or not currentZone then
        return nil
    end

    if not zoneStates[currentZoneJob] then
        return nil
    end

    return zoneStates[currentZoneJob][currentZone]
end

local function KeyboardInputJukebox(textEntry, exampleText, maxLength)
    local input = exports["sJobs"]:KeyboardInput(textEntry or "", exampleText or "", maxLength or 180)
    if input and input ~= "" then
        return tostring(input)
    end
    return nil
end

local function getZoneLabel(job, zoneId)
    local z = getZoneDefinition(job, zoneId)
    if not z then
        return "Zone inconnue"
    end
    return z.label
end

OpenJobMusicMenu = function()
    if not currentZoneJob or not currentZone then
        return
    end

    if jukeboxMenuOpen then
        jukeboxMenuOpen = false
        return
    end

    if RMenu['jobmusic'] then
        for name, menu in pairs(RMenu['jobmusic']) do
            RMenu:Delete('jobmusic', name)
        end
    end

    RMenu.Add('jobmusic', 'main', RageUI.CreateMenu("Musique", "Gestion musique job", 1, 100))
    local menu = RMenu:Get('jobmusic', 'main')
    menu:SetRectangleBanner(255, 117, 31, 225)

    menu.Closed = function()
        jukeboxMenuOpen = false
        if RMenu['jobmusic'] then
            for name, m in pairs(RMenu['jobmusic']) do
                RMenu:Delete('jobmusic', name)
            end
        end
    end

    RageUI.CloseAll()
    jukeboxMenuOpen = true
    RageUI.Visible(menu, true)

    Citizen.CreateThread(function()
        while jukeboxMenuOpen do
            Citizen.Wait(1)

            local zState = getCurrentZoneState()

            RageUI.IsVisible(menu, true, true, true, function()
                RageUI.Separator("Zone: ~y~" .. getZoneLabel(currentZoneJob, currentZone or ""))

                if not zState then
                    RageUI.Separator("Chargement de la file d'attente...")
                    return
                end

                local currentTitle = "Aucune musique"
                if zState.current ~= 0 and zState.queue[zState.current] then
                    currentTitle = zState.queue[zState.current].title
                end

                local vol = zState.volume or 0.5
                local currentIndex = math.floor(vol * 20.0 + 0.5) + 1

                if currentIndex < 1 then
                    currentIndex = 1
                elseif currentIndex > #volumeLabels then
                    currentIndex = #volumeLabels
                end

                if not volumeIndex then
                    volumeIndex = currentIndex
                end

                RageUI.List("Volume", volumeLabels or {"…"}, volumeIndex, "Volume de la musique de la zone", {}, true,
                    function(Hovered, Active, Selected, Index)
                        volumeIndex = Index
                        if Selected then
                            local newVol = (volumeIndex - 1) / 20.0
                            TriggerServerEvent("jobmusic:setVolume", currentZone, newVol)
                        end
                    end
                )

                RageUI.Line()

                RageUI.ButtonWithStyle("Ajouter une musique (YouTube)", nil, {RightLabel = "➕"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local link = KeyboardInputJukebox("Lien YouTube", "", 180)
                        if link and link ~= "" then
                            TriggerServerEvent("jobmusic:addTrack", currentZone, link)
                        end
                    end
                end)

                local playIcon = zState.playing and "⏸️" or "▶️"
                RageUI.ButtonWithStyle("Play / Pause", nil, {RightLabel = playIcon}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if zState.playing then
                            TriggerServerEvent("jobmusic:pause", currentZone)
                        else
                            TriggerServerEvent("jobmusic:resume", currentZone)
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Stop", nil, {RightLabel = "⏹️"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("jobmusic:stop", currentZone)
                    end
                end)

                RageUI.ButtonWithStyle("Musique suivante", nil, {RightLabel = "⏭️"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("jobmusic:next", currentZone)
                    end
                end)

                RageUI.Line()
                RageUI.Separator("File d'attente")

                if #zState.queue == 0 then
                    RageUI.Separator("~c~Aucune musique en file.")
                else
                    for i, track in ipairs(zState.queue) do
                        local lbl = track.title or "Sans titre"
                        local right = ""

                        if i == zState.current then
                            if zState.playing then
                                right = "~g~Lecture"
                            else
                                right = "~o~En pause"
                            end
                        end

                        RageUI.ButtonWithStyle(i .. ". " .. lbl, nil, {RightLabel = right}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("jobmusic:removeTrack", currentZone, i)
                            end
                        end)
                    end
                end
            end)

            if not RageUI.Visible(menu) then
                jukeboxMenuOpen = false
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local newZone = nil
        local newZoneJob = nil
        local nearAny = false

        for _, item in ipairs(getAccessibleZones()) do
            local z = item.zone
            local dist = #(pos - z.center)
            if dist <= z.radius then
                newZone = z.id
                newZoneJob = item.jobKey
                nearAny = true
                break
            end
        end

        if newZone ~= currentZone or newZoneJob ~= currentZoneJob then
            currentZone = newZone
            currentZoneJob = newZoneJob
            if currentZone then
                TriggerServerEvent("jobmusic:requestZoneState", currentZone)
            end
        end

        if nearAny then
            Citizen.Wait(cfg_jukebox.ZoneCheckIntervalMs or 500)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- =========================================================================
-- ECOUTE : TOUTES les zones, pour TOUS les joueurs (les clients du bar ne
-- sont pas employes : avant, seules les zones du job du joueur etaient
-- suivies, donc un client qui entrait apres le lancement du morceau
-- n'entendait jamais rien). A l'entree dans le rayon d'ecoute on demande la
-- lecture en cours au serveur ; a la sortie on detruit le son (le lecteur
-- YouTube d'une zone quittee ne tourne plus dans le NUI pour rien).
-- Cout : ~25 distances 2D au carre, toutes les 1000 ms hors zone.
-- =========================================================================
local LISTEN_MARGIN = 60.0
local allZones = nil

local function getAllZones()
    if allZones then return allZones end
    allZones = {}
    if cfg_jukebox and cfg_jukebox.JobMusicZones then
        for jobKey, zones in pairs(cfg_jukebox.JobMusicZones) do
            for _, z in ipairs(zones) do
                if z.center and z.id ~= nil then
                    local dist = z.soundDistance or math.max(z.radius or 0.0, cfg_jukebox.DefaultDistance or 40.0)
                    local r = dist + LISTEN_MARGIN
                    allZones[#allZones + 1] = {
                        zone = z, jobKey = jobKey,
                        cx = z.center.x, cy = z.center.y,
                        r2 = r * r,
                        soundId = buildSoundId(jobKey, z.id),
                    }
                end
            end
        end
    end
    if cfg_jukebox and cfg_jukebox.PublicZones then
        for _, z in ipairs(cfg_jukebox.PublicZones) do
            if z.center and z.id ~= nil then
                local dist = z.soundDistance or math.max(z.radius or 0.0, cfg_jukebox.DefaultDistance or 40.0)
                local r = dist + LISTEN_MARGIN
                allZones[#allZones + 1] = {
                    zone = z, jobKey = PUBLIC_KEY,
                    cx = z.center.x, cy = z.center.y,
                    r2 = r * r,
                    soundId = buildSoundId(PUBLIC_KEY, z.id),
                }
            end
        end
    end
    return allZones
end

Citizen.CreateThread(function()
    local listening = {}   -- [i] = true quand on est dans le rayon d'ecoute de allZones[i]

    while true do
        local zones = getAllZones()
        local pos = GetEntityCoords(PlayerPedId())
        local px, py = pos.x, pos.y
        local anyNear = false

        for i = 1, #zones do
            local zn = zones[i]
            local dx, dy = px - zn.cx, py - zn.cy
            local inside = (dx * dx + dy * dy) <= zn.r2

            if inside then
                anyNear = true
                if not listening[i] then
                    listening[i] = true
                    TriggerServerEvent("jobmusic:enterZone", zn.jobKey, zn.zone.id)
                end
            elseif listening[i] then
                listening[i] = nil
                destroySound(zn.soundId)
            end
        end

        Citizen.Wait(anyNear and 500 or 1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local waitTime = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, item in ipairs(getAccessibleZones()) do
            local z = item.zone
            local dist = #(pos - z.center)
            if dist <= (z.radius + 5.0) then
                waitTime = 0
                DrawMarker(25, z.center.x, z.center.y, z.center.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.4, 255, 220, 0, 180, false, false, 2, false, nil, nil, false)

                if dist <= 2.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~y~[E]~s~ pour gérer la musique ~y~(" .. z.label .. ")")
                    if IsControlJustPressed(0, cfg_jukebox.MenuKey or 38) and not jukeboxMenuOpen then
                        currentZone = z.id
                        currentZoneJob = item.jobKey
                        TriggerServerEvent("jobmusic:requestZoneState", currentZone)
                        Citizen.Wait(200)
                        OpenJobMusicMenu()
                    end
                end
            end
        end

        Citizen.Wait(waitTime)
    end
end)
