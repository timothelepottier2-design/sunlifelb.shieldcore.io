ESX = exports["es_extended"]:getSharedObject()
local Config = GangConfig

local isLvAdmin = false
local authorizedGang = nil

local function refreshCanAdmin()
    ESX.TriggerServerCallback("gangbuilder:lvidcard:canAdmin", function(allowed)
        isLvAdmin = allowed == true
    end)
end

RegisterNetEvent("gangbuilder:lvidcard:sync", function(gangName)
    authorizedGang = (type(gangName) == "string" and gangName ~= "") and gangName or nil
end)

RegisterNetEvent("esx:playerLoaded", function()
    refreshCanAdmin()
end)

RegisterNetEvent("esx:setJob", function()
    refreshCanAdmin()
end)

CreateThread(function()
    Wait(2000)
    refreshCanAdmin()
end)

local function isPlayerAuthorizedGroup()
    if not authorizedGang or authorizedGang == "" then
        return false
    end
    local myGang = exports["sunlife_ui"]:GetMyGangName()
    if type(myGang) ~= "string" or myGang == "" then
        return false
    end
    return string.lower(myGang) == string.lower(authorizedGang)
end

local function drawMarker(pos, color)
    DrawMarker(
        2,
        pos.x + 0.0, pos.y + 0.0, (pos.z - 0.5) + 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.6, 0.6, 0.6,
        color[1], color[2], color[3], color[4],
        false, true, 2, false, nil, nil, false
    )
end

local function showHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function openAdminMenu()
    ESX.TriggerServerCallback("gangbuilder:lvidcard:getGangs", function(data)
        if not data or type(data) ~= "table" then
            ESX.ShowNotification("~r~Accès refusé.")
            return
        end

        local gangs = data.gangs or {}
        local options = { { label = "Aucun (retirer l'autorisation)", value = "aucun" } }
        for i = 1, #gangs do
            options[#options + 1] = { label = gangs[i], value = gangs[i] }
        end

        local currentLabel = (type(data.current) == "string" and data.current ~= "") and data.current or "Aucun"

        local input = lib.inputDialog("Carte ID Las Venturas", {
            {
                type = "select",
                label = "Groupe autorisé",
                description = "Actuellement : " .. currentLabel,
                options = options,
                required = true,
            },
        })

        if not input or not input[1] then
            return
        end

        TriggerServerEvent("gangbuilder:lvidcard:setAuthorizedGang", input[1])
    end)
end

local function openCreateMenu()
    local input = lib.inputDialog("Carte d'identité Las Venturas", {
        { type = "input", label = "Nom", required = true, max = 32 },
        { type = "input", label = "Prénom", required = true, max = 32 },
        { type = "input", label = "Date de naissance", placeholder = "JJ/MM/AAAA", required = true, max = 20 },
        { type = "input", label = "Sexe", placeholder = "H / F", required = true, max = 32 },
        { type = "input", label = "Taille", placeholder = "ex: 180cm", required = true, max = 10 },
    })

    if not input then
        return
    end

    local payload = {
        lastname = input[1],
        firstname = input[2],
        dob = input[3],
        sex = input[4],
        height = input[5],
    }

    if not payload.lastname or not payload.firstname or not payload.dob or not payload.sex or not payload.height then
        ESX.ShowNotification("~r~Tous les champs sont requis.")
        return
    end

    TriggerServerEvent("gangbuilder:lvidcard:create", payload)
end

CreateThread(function()
    local lastInteractAt = 0
    local lv = Config.LvIdCard
    local adminPoint = lv.adminPoint
    local createPoint = lv.createPoint
    local drawDist = lv.drawDist or 25.0
    local interactDist = lv.interactDist or 1.5

    while true do
        local sleep = 1000
        local pcoords = GetEntityCoords(PlayerPedId())

        if isLvAdmin then
            local d = #(pcoords - adminPoint)
            if d < drawDist then
                sleep = 0
                drawMarker(adminPoint, lv.adminMarkerColor)

                if d < interactDist then
                    showHelp("Appuie sur ~INPUT_CONTEXT~ pour ~b~définir le groupe autorisé~s~ (Carte LV)")
                    if IsControlJustReleased(0, 38) then
                        local now = GetGameTimer()
                        if now - lastInteractAt > 300 then
                            lastInteractAt = now
                            openAdminMenu()
                        end
                    end
                end
            end
        end

        if isPlayerAuthorizedGroup() then
            local d = #(pcoords - createPoint)
            if d < drawDist then
                sleep = 0
                drawMarker(createPoint, lv.createMarkerColor)

                if d < interactDist then
                    showHelp("Appuie sur ~INPUT_CONTEXT~ pour ~y~créer une carte d'identité Las Venturas~s~")
                    if IsControlJustReleased(0, 38) then
                        local now = GetGameTimer()
                        if now - lastInteractAt > 300 then
                            lastInteractAt = now
                            openCreateMenu()
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
