ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj)
            ESX = obj
        end)
        Citizen.Wait(500)
    end
end)

local makeupMenuOpen = false
local currentEyeColor = 0
local currentMakeupIndex = 0
local currentMakeupOpacity = 1.0
local currentMakeupColor = 0
local currentLipstickIndex = 0
local currentLipstickOpacity = 1.0
local currentLipstickColor = 0

local originalEyeColor = 0
local originalMakeupIndex = 0
local originalMakeupOpacity = 0.0
local originalMakeupColor1 = 0
local originalMakeupColor2 = 0
local originalLipstickIndex = 0
local originalLipstickOpacity = 0.0
local originalLipstickColor1 = 0
local originalLipstickColor2 = 0
local originalSkin = nil

local maxEyeColors = 31
local maxMakeup = 40
local maxLipstick = 30
local maxColors = 63

local eyeList = {}
for i = 0, maxEyeColors do
    eyeList[#eyeList + 1] = tostring(i)
end

local makeupList = {}
for i = 0, maxMakeup do
    makeupList[#makeupList + 1] = tostring(i)
end

local lipstickList = {}
for i = 0, maxLipstick do
    lipstickList[#lipstickList + 1] = tostring(i)
end

local intensityList = {}
for i = 0, 10 do
    intensityList[#intensityList + 1] = tostring(i)
end

local colorList = {}
for i = 0, maxColors do
    colorList[#colorList + 1] = tostring(i)
end

local makeupCam = nil

local function CreateMakeupCam()
    local ped = PlayerPedId()
    local camCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.7, 0.65)
    if DoesCamExist(makeupCam) then
        DestroyCam(makeupCam, false)
        makeupCam = nil
    end
    makeupCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(makeupCam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtPedBone(makeupCam, ped, 31086, 0.0, 0.0, 0.0, true)
    SetCamActive(makeupCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function DestroyMakeupCam()
    if DoesCamExist(makeupCam) then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(makeupCam, false)
        makeupCam = nil
    end
end

local function SaveOriginalAppearance()
    local ped = PlayerPedId()
    TriggerEvent('skinchanger:getSkin', function(skin)
        originalSkin = skin

        originalEyeColor = skin.eye_color or 0

        originalMakeupIndex = skin.makeup_1 or 0
        originalMakeupOpacity = (skin.makeup_2 or 0) / 10.0
        originalMakeupColor1 = skin.makeup_3 or 0
        originalMakeupColor2 = skin.makeup_4 or originalMakeupColor1

        originalLipstickIndex = skin.lipstick_1 or 0
        originalLipstickOpacity = (skin.lipstick_2 or 0) / 10.0
        originalLipstickColor1 = skin.lipstick_3 or 0
        originalLipstickColor2 = skin.lipstick_4 or originalLipstickColor1

        currentEyeColor = originalEyeColor
        currentMakeupIndex = originalMakeupIndex
        currentMakeupOpacity = originalMakeupOpacity
        currentMakeupColor = originalMakeupColor1
        currentLipstickIndex = originalLipstickIndex
        currentLipstickOpacity = originalLipstickOpacity
        currentLipstickColor = originalLipstickColor1
    end)
end

local function ApplyCurrentMakeup()
    local ped = PlayerPedId()
    SetPedEyeColor(ped, currentEyeColor)
    SetPedHeadOverlay(ped, 4, currentMakeupIndex, currentMakeupOpacity)
    SetPedHeadOverlayColor(ped, 4, 1, currentMakeupColor, currentMakeupColor)
    SetPedHeadOverlay(ped, 8, currentLipstickIndex, currentLipstickOpacity)
    SetPedHeadOverlayColor(ped, 8, 1, currentLipstickColor, currentLipstickColor)
end

local function RevertMakeup()
    if originalSkin then
        TriggerEvent('skinchanger:loadSkin', originalSkin)
    else
        local ped = PlayerPedId()
        SetPedEyeColor(ped, originalEyeColor)
        SetPedHeadOverlay(ped, 4, originalMakeupIndex, originalMakeupOpacity)
        SetPedHeadOverlayColor(ped, 4, 1, originalMakeupColor1, originalMakeupColor2)
        SetPedHeadOverlay(ped, 8, originalLipstickIndex, originalLipstickOpacity)
        SetPedHeadOverlayColor(ped, 8, 1, originalLipstickColor1, originalLipstickColor2)
    end
end

RegisterNetEvent('makeup:openMenu')
AddEventHandler('makeup:openMenu', function()
    if makeupMenuOpen then
        return
    end

    if IsPedDeadOrDying(PlayerPedId(), false) then
        return
    end

    SaveOriginalAppearance()

    if RMenu['makeup'] then
        for name, menu in pairs(RMenu['makeup']) do
            RMenu:Delete('makeup', name)
        end
    end

    RMenu.Add('makeup', 'main', RageUI.CreateMenu("Maquillage", "Personnalisation visage", 100, 100))
    local menu = RMenu:Get('makeup', 'main')
    menu:SetRectangleBanner(200, 120, 200, 180)

    menu.Closed = function()
        makeupMenuOpen = false
        RevertMakeup()
        DestroyMakeupCam()
        RMenu:Delete('makeup', 'main')
    end

    RageUI.CloseAll()
    makeupMenuOpen = true
    RageUI.Visible(menu, true)
    CreateMakeupCam()

    Citizen.CreateThread(function()
        local selectedConfirmed = false
        while makeupMenuOpen do
            Citizen.Wait(1)

            RageUI.IsVisible(menu, true, true, true, function()

                RageUI.Separator("Maquillage")

                RageUI.List("Style maquillage", makeupList, currentMakeupIndex + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local index = Index - 1
                    if index ~= currentMakeupIndex then
                        currentMakeupIndex = index
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.List("Intensité maquillage", intensityList, math.floor(currentMakeupOpacity * 10) + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local value = (Index - 1) / 10.0
                    if value ~= currentMakeupOpacity then
                        currentMakeupOpacity = value
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.List("Couleur maquillage", colorList, currentMakeupColor + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local index = Index - 1
                    if index ~= currentMakeupColor then
                        currentMakeupColor = index
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.Separator("Rouge à lèvres")

                RageUI.List("Style lèvres", lipstickList, currentLipstickIndex + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local index = Index - 1
                    if index ~= currentLipstickIndex then
                        currentLipstickIndex = index
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.List("Intensité lèvres", intensityList, math.floor(currentLipstickOpacity * 10) + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local value = (Index - 1) / 10.0
                    if value ~= currentLipstickOpacity then
                        currentLipstickOpacity = value
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.List("Couleur lèvres", colorList, currentLipstickColor + 1, nil, {}, true, function(Hovered, Active, Selected, Index)
                    local index = Index - 1
                    if index ~= currentLipstickColor then
                        currentLipstickColor = index
                        ApplyCurrentMakeup()
                    end
                end)

                RageUI.ButtonWithStyle("Valider", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected and not selectedConfirmed then
                        selectedConfirmed = true
                        TriggerServerEvent('makeup:payAndApply')
                    end
                end)

                RageUI.ButtonWithStyle("Annuler", "Annule les modifications", {RightLabel = "Retour"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RevertMakeup()
                        makeupMenuOpen = false
                        RageUI.CloseAll()
                    end
                end)
            end)
        end
    end)
end)

RegisterNetEvent('makeup:applyResult')
AddEventHandler('makeup:applyResult', function(success, price, account)
    if success then
        TriggerEvent('skinchanger:getSkin', function(skin)
            skin.eye_color = currentEyeColor
            skin.makeup_1 = currentMakeupIndex
            skin.makeup_2 = math.floor(currentMakeupOpacity * 10)
            skin.makeup_3 = currentMakeupColor
            skin.makeup_4 = currentMakeupColor
            skin.lipstick_1 = currentLipstickIndex
            skin.lipstick_2 = math.floor(currentLipstickOpacity * 10)
            skin.lipstick_3 = currentLipstickColor
            skin.lipstick_4 = currentLipstickColor

            TriggerServerEvent('esx_skin:save', skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)

        ESX.ShowNotification("~g~Maquillage appliqué~s~")
        makeupMenuOpen = false
        RageUI.CloseAll()
        DestroyMakeupCam()
    else
        RevertMakeup()
        ESX.ShowNotification("~r~Vous n'avez pas assez d'argent pour ce maquillage.")
        makeupMenuOpen = false
        RageUI.CloseAll()
        DestroyMakeupCam()
    end
end)
