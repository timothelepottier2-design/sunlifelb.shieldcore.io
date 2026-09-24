ESX = nil
local PlayerData                = {}
local putplongee = false
local obj = GetHashKey("prop_cs_heist_bag_02")
local UnGlitch = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function PutPlongee()
    local pPed = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.7, -1.0)
    
    RequestModel(obj)
    while not HasModelLoaded(obj) do Wait(10) end
    print(('^2[NETDIAG][OBJET]^7 %s cl_plongee.lua:20 CreateObject NETWORKED obj=%s'):format(GetCurrentResourceName(), tostring(obj)))
    local object = CreateObject(obj, coords, 1, 0, 0)
    FreezeEntityPosition(object, 1)
    TaskStartScenarioInPlace(pPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
    UnGlitch = true
    AntiChlitch()
    Wait(6500)
    ClearPedTasks(pPed)
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
    UnGlitch = false
    ESX.ShowNotification('~g~Vous avez inséré votre tenue de plongée !')
    SetEnableScuba(PlayerPedId(),true)
    putplongee = true
    CreateThread(function()
        while putplongee do
            SetPedMaxTimeUnderwater(PlayerPedId(), 5000.00)
            Wait(1000)
        end
    end)


    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == "mp_m_freemode_01" then
            local clothesSkin = {
            ['tshirt_1'] = 15,    ['tshirt_2'] = 0,
            ['ears_1'] = -1, 	  ['ears_2'] = 0,
            ['torso_1'] = 243,     ['torso_2'] = 20,
            ['decals_1'] = 0,     ['decals_2']= 0,
            ['mask_1'] = 36, 	  ['mask_2'] = 0,
            ['arms'] = 12,
            ['pants_1'] = 94, 	  ['pants_2'] = 20,
            ['shoes_1'] = 67,     ['shoes_2'] = 20,
            ['helmet_1'] 	= -1,  ['helmet_2'] = 0,
            ['bags_1'] = 43,      ['bags_2'] = 0,
            ['glasses_1'] = 26,    ['glasses_2'] = 4,
            ['chain_1'] = 0,      ['chain_2'] = 0,
            ['bproof_1'] = 0,     ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        else
            local clothesSkin = {
            ['tshirt_1'] = 2,    ['tshirt_2'] = 0,
            ['ears_1'] = -1,      ['ears_2'] = 0,
            ['torso_1'] = 251,     ['torso_2'] 	= 19,
            ['decals_1'] = 0,     ['decals_2'] = 0,
            ['mask_1'] = 0,      ['mask_2'] 	= 0,
            ['arms'] = 7,
            ['pants_1'] = 97,     ['pants_2'] 	= 19,
            ['shoes_1'] = 70,     ['shoes_2'] 	= 19,
            ['helmet_1']= -1,     ['helmet_2'] 	= 0,
            ['bags_1'] = 43,      ['bags_2']	= 0,
            ['glasses_1'] = 28,    ['glasses_2'] = 3,
            ['chain_1'] = 0,      ['chain_2'] = 0,
            ['bproof_1'] = 0,     ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end
    end)
end

function RemovePlongee()
    TriggerEvent('skinchanger:getSkin', function(skin)
        exports['esx_skin']:GetCachedSkin(function(skin, hasSkin)
            if hasSkin then
                TriggerEvent('skinchanger:loadSkin', skin)
                SetPedMaxTimeUnderwater(PlayerPedId(), 20.00)
            end
        end)
    end)
end

RegisterNetEvent('plongee:use')
AddEventHandler('plongee:use', function()
    if putplongee == false then
        PutPlongee()
        putplongee = true
    else
        RemovePlongee()
        putplongee = false
    end
end)

function AntiChlitch()
    Citizen.CreateThread(function()
        while UnGlitch do
            Wait(1)
            DisableControlAction(1, 73, 1)
            DisableControlAction(1, 166, 1)
            DisableControlAction(1, 170, 1)
        end
        ClearPedTasks(PlayerPedId())
    end)
end