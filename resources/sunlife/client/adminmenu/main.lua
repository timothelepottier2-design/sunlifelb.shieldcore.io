isNoClip,NoClipSpeed,isNameShown,blipsActive = false,0.5,false,false
spawnInside = false
showAreaPlayers = false
selectedPlayer = nil
selectedReport = nil
local sono = true
local nombreStaffActifs = 0
local rankUser = nil

localPlayers, connecteds, staff, items = {},0,0, {}
permLevel = nil

-- Seuil d'EXP sous lequel un joueur est marque "nouveau" dans la liste staff.
-- Le tag est calcule UNE fois ici, a la reception de la liste, et non a
-- chaque frame dans le rendu RageUI (qui parcourt les +1000 joueurs) : le
-- rendu ne fait plus qu'une concatenation d'une chaine deja prete.
local STAFF_NEW_EXP = 3000
local STAFF_NEW_TAG = " 🆕"

RegisterNetEvent("adminmenu:updatePlayers")
AddEventHandler("adminmenu:updatePlayers", function(tables)
    localPlayers = tables
    local count = 0

    for key, player in pairs(tables) do
        count = count + 1
        rankUser = player.rank
        if player.source == nil then
            player.source = key
        end
        player.newTag = ((player.exp or 0) < STAFF_NEW_EXP) and STAFF_NEW_TAG or ""
    end

    connecteds = count
end)

RegisterNetEvent("adminhud:set")
AddEventHandler("adminhud:set", function(data)
    if type(data) ~= "table" then return end
    if type(data.connected) == "number" then
        connecteds = data.connected
    end
end)

RegisterNetEvent("adminmenu:setCoords")
AddEventHandler("adminmenu:setCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

RegisterNetEvent("adminmenu:setCoordsHeading")
AddEventHandler("adminmenu:setCoordsHeading", function(coords, heading)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords, false, false, false, false)
    if heading then
        SetEntityHeading(ped, heading + 0.0)
    end
end)

globalRanksRelative = {
    ["user"] = 0,
    ["help"] = 1,
    ["test"] = 2,
    ["mod"] = 3,
    ["admin"] = 4,
    ["gerant"] = 4,
    ["superadmin"] = 5
}

RegisterNetEvent("adminmenu:cbPermLevel")
AddEventHandler("adminmenu:cbPermLevel", function(pLvl)
    permLevel = pLvl
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[pLvl])
end)

RegisterNetEvent("adminmenu:cbItemsList")
AddEventHandler("adminmenu:cbItemsList", function(table)
    items = table
end)

RegisterNetEvent("adminmenu:receivewarn")
AddEventHandler("adminmenu:receivewarn", function(reason)
    ESX.Scaleform.ShowFreemodeMessage('~r~Vous avez reçu un avertissement', '~r~'..reason, 5)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

    TriggerServerEvent("adminmenu:getGroup")

    if not DecorExistOn(PlayerPedId(), "isStaffMode") then
        DecorRegister("isStaffMode", 2)
    end

    TriggerServerEvent("fakeLoaded")
    while not permLevel do Wait(1) end
    if not DecorExistOn(PlayerPedId(), "staffl") then
        DecorRegister("staffl", 3)
    end
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[permLevel])

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(120000)
            if isStaffMode then
                ESX.TriggerServerCallback("Staff:GetPlayers", function(serviceStaff)
                    nombreStaffActifs = #serviceStaff
                end)
                if reportCount > 50 and rankUser ~= "user" then
                    ShowBottomNotification("~r~Nous venons de dépasser les 50 reports. La situation est urgente !", 5000)
                end
            end
        end
    end)

    while true do
        if isStaffMode then
            if GetPlayerName(PlayerId()) ~= "Le Giga M" then

            end
        end

        if isStaffMode then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)

ADMIN = {}

function ADMIN.KeyRegister(Controls, ControlName, Description, Action)
	RegisterKeyMapping(string.format('%s', ControlName), Description, "keyboard", Controls)
	RegisterCommand(string.format('%s', ControlName), function(source, args)
		if (Action ~= nil) then
			Action();
		end
	end, false)
end

ADMIN.KeyRegister("F10", "Adminmenu", "Admin Menu", function()
    openMenu()
end)

ADMIN.KeyRegister("G", "Noclip", "Noclip", function()
    if permLevel ~= "user" and isStaffMode then
        ToogleNoClip()
    end
end)
PlayerNoClipStatus = function()
    return isNoClip
end

RegisterCommand('wipe', function(source, args)
    local license = args[1]
    TriggerServerEvent("adminmenu:wipe", license)
end)

RegisterCommand("go", function(source, args, rawCommand)
    local target = args[1]

    TriggerServerEvent("adminmenu:goto", target)
end)

RegisterNetEvent("playsoundsss", function ()
    if sono == true then
        PlaySoundFrontend(-1,"TENNIS_MATCH_POINT", "HUD_AWARDS", 1)
    end
end)

RegisterCommand('sonooff', function(source)
    if sono == true then
        sono = false
    elseif sono == false then
        sono = true
    end
end)

RegisterNetEvent("adminmenutest:screenshot")
AddEventHandler("adminmenutest:screenshot", function()
    ESX.TriggerServerCallback("adminmenu:getHook", function(hook)
        exports['screenshot-basic']:requestScreenshotUpload(hook, "files[]", function(data)
            local image = json.decode(data)
            link = image.attachments[1].proxy_url
            local soif, faim = exports["es_extended"]:whatisthisgoingon()
            TriggerServerEvent("adminmenutest:screenshot", link, soif, faim)
        end)
    end)
end)

RegisterCommand("rtp", function()
    TriggerServerEvent("staff:RandomPlayerTeleport")
end, false)

RegisterKeyMapping("rtp", "Téléportation aléatoire (Staff)", "keyboard", "")

function DrawInterface()
    local baseX = 0.50
    local baseY = 0.025
    local baseWidth = 0.15
    local baseHeight = 0.011

    local textColor = {255, 255, 255, 255}

    local barColor = {255, 117, 31, 140}
    if reportCount > 50 then
        barColor = {255, 0, 0, 255}
    end

    DrawRect(baseX, baseY, baseWidth, baseHeight * 4 + 0.01, 28, 28, 28, 180)

    DrawRect(baseX, baseY + (baseHeight * 2.2) + 0.005, baseWidth, baseHeight * 0.5, barColor[1], barColor[2], barColor[3], barColor[4])

    DrawTexts(baseX, baseY - 0.023, "Reports: " .. reportCount, true, 0.35, textColor, 6, 0)
    DrawTexts(baseX, baseY - 0.003, "Staffs en Service: " .. nombreStaffActifs, true, 0.35, textColor, 6, 0)
end

local isTextDisplayed = false

function DrawText2D(x, y, text, scale, font, color)
    SetTextFont(font or 4)
    SetTextScale(scale, scale)
    SetTextColour(color.r or 255, color.g or 255, color.b or 255, color.a or 255)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function ShowBottomNotification(message, duration)
    if isTextDisplayed then return end
    isTextDisplayed = true

    local startTime = GetGameTimer()
    local endTime = startTime + (duration or 5000)

    CreateThread(function()
        while GetGameTimer() < endTime do
            local x = 0.5
            local y = 0.95
            DrawText2D(x, y, message, 0.5, 4, { r = 255, g = 255, b = 255, a = 255 })
            Wait(0)
        end
        isTextDisplayed = false
    end)
end
