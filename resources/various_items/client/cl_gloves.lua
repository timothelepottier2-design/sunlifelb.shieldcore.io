local Gloves = {}
local putgloves = false

function putGloves()
    local ped = PlayerPedId()
    local hash = GetHashKey('prop_boxing_glove_01')
    while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
    local pos = GetEntityCoords(ped)
    print(('^2[NETDIAG][OBJET]^7 %s cl_gloves.lua:9-10 CreateObject NETWORKED x2 gloves'):format(GetCurrentResourceName()))
    local gloveA = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
    local gloveB = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
    table.insert(Gloves,gloveA)
    table.insert(Gloves,gloveB)
    SetModelAsNoLongerNeeded(hash)
    FreezeEntityPosition(gloveA,false)
    SetEntityCollision(gloveA,false,true)
    ActivatePhysics(gloveA)
    FreezeEntityPosition(gloveB,false)
    SetEntityCollision(gloveB,false,true)
    ActivatePhysics(gloveB)
    if not ped then ped = PlayerPedId(); end -- gloveA = L, gloveB = R
    AttachEntityToEntity(gloveA, ped, GetPedBoneIndex(ped, 0xEE4F), 0.05, 0.00,  0.04,     00.0, 90.0, -90.0, true, true, false, true, 1, true) -- object is attached to right hand 
    AttachEntityToEntity(gloveB, ped, GetPedBoneIndex(ped, 0xAB22), 0.05, 0.00, -0.04,     00.0, 90.0,  90.0, true, true, false, true, 1, true) -- object is attached to right hand 
end

function removeGloves()
    for k,v in pairs(Gloves) do DeleteObject(v); end
end

RegisterNetEvent('gloves:use')
AddEventHandler('gloves:use', function()
    if putgloves == false then
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            ESX.ShowNotification("~r~Vous ne pouvez pas mettre de gants de boxe dans un véhicule.")
            return
        end
        putGloves()
        putgloves = true
    else
        removeGloves()
        putgloves = false
    end
end)