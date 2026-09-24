local ESX = exports["es_extended"]:getSharedObject()

local PetConfig = {
    lewall_alien = { model = `lewall_alien`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien2 = { model = `lewall_alien2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien3 = { model = `lewall_alien3`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien4 = { model = `lewall_alien4`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_alien5 = { model = `lewall_alien5`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_bulldog = { model = `lewall_bulldog`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_cowboy = { model = `lewall_cowboy`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_crab = { model = `lewall_crab`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_cthulhu = { model = `lewall_cthulhu`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dino = { model = `lewall_dino`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dog = { model = `lewall_dog`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dog2 = { model = `lewall_dog2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_doggy = { model = `lewall_doggy`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon = { model = `lewall_dragon`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon2 = { model = `lewall_dragon2`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_dragon3 = { model = `lewall_dragon3`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_parrot = { model = `lewall_parrot`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_rabbit = { model = `lewall_rabbit`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_saw = { model = `lewall_saw`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_shiba = { model = `lewall_shiba`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_snake = { model = `lewall_snake`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_spider = { model = `lewall_spider`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_tiger = { model = `lewall_tiger`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) },
    lewall_witch = { model = `lewall_witch`, offset = vector3(0.300, -0.026, 0.166), rotation = vector3(180.0, 110.0, 0.0) }
}

local currentPet = nil
local currentItem = nil
local currentOffset = nil
local currentRotation = nil
local isEditing = false
local restoring = false

local function ShowHelpNotification(msg)
    if ESX and ESX.ShowHelpNotification then
        ESX.ShowHelpNotification(msg)
    else
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandDisplayHelp(0, false, false, -1)
    end
end

local function SaveStateToServer()
    if not currentItem or not currentOffset or not currentRotation then return end
    TriggerServerEvent("lewall_pets:server:save", {
        item = currentItem,
        offset_x = currentOffset.x, offset_y = currentOffset.y, offset_z = currentOffset.z,
        rot_x = currentRotation.x,  rot_y = currentRotation.y,  rot_z = currentRotation.z
    })
end

local function ClearStateOnServer()
    TriggerServerEvent("lewall_pets:server:clear")
end

local function DestroyEntityOnly()

    if currentPet and DoesEntityExist(currentPet) then
        DetachEntity(currentPet, true, true)
        DeleteEntity(currentPet)
    end
    currentPet = nil
end

local function ResetStateLocal()
    DestroyEntityOnly()
    currentItem = nil
    currentOffset = nil
    currentRotation = nil
    isEditing = false
end

local function DeleteCurrentPet()

    ResetStateLocal()
    ClearStateOnServer()
end

local function AttachPet()
    if not currentPet or not DoesEntityExist(currentPet) then
        return
    end
    local ped = PlayerPedId()
    local bone = GetPedBoneIndex(ped, 24818)
    AttachEntityToEntity(
        currentPet,
        ped,
        bone,
        currentOffset.x,
        currentOffset.y,
        currentOffset.z,
        currentRotation.x,
        currentRotation.y,
        currentRotation.z,
        true,
        true,
        false,
        true,
        2,
        true
    )
end

local function CreatePetEntityNow()

    if not currentItem or not PetConfig[currentItem] then
        return nil
    end
    if currentPet and DoesEntityExist(currentPet) then
        return currentPet
    end

    local cfg = PetConfig[currentItem]
    if not currentOffset then currentOffset = cfg.offset end
    if not currentRotation then currentRotation = cfg.rotation end

    local model = cfg.model
    if not IsModelValid(model) then return nil end

    RequestModel(model)
    local startReq = GetGameTimer()
    while not HasModelLoaded(model) and (GetGameTimer() - startReq) < 5000 do
        Wait(0)
    end
    if not HasModelLoaded(model) then return nil end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    print(('^2[NETDIAG][OBJET]^7 %s cl_lewall.lua:135 CreateObjectNoOffset NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
    local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, false)

    if not DoesEntityExist(obj) then
        local startTime = GetGameTimer()
        while not DoesEntityExist(obj) and (GetGameTimer() - startTime) < 5000 do
            Wait(0)
        end
        if not DoesEntityExist(obj) then
            return nil
        end
    end

    SetEntityCollision(obj, false, false)
    SetEntityCompletelyDisableCollision(obj, true, true)
    SetEntityInvincible(obj, true)
    SetEntityAsMissionEntity(obj, true, true)

    currentPet = obj
    AttachPet()
    return obj
end

local function StartEditLoop()
    if isEditing then
        return
    end
    isEditing = true

    local step = 0.003
    local stepZ = 0.005

    CreateThread(function()
        while isEditing and currentPet and DoesEntityExist(currentPet) do
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)

            ShowHelpNotification("~INPUT_CELLPHONE_UP~/~INPUT_CELLPHONE_DOWN~ monter/descendre\n~INPUT_CELLPHONE_LEFT~/~INPUT_CELLPHONE_RIGHT~ avancer/reculer\n~INPUT_CONTEXT~ valider\n~INPUT_CELLPHONE_CANCEL~ ranger le pet")

            if IsControlPressed(0, 172) then
                currentOffset = vector3(currentOffset.x, currentOffset.y, currentOffset.z + stepZ)
                AttachPet()
            end

            if IsControlPressed(0, 173) then
                currentOffset = vector3(currentOffset.x, currentOffset.y, currentOffset.z - stepZ)
                AttachPet()
            end

            if IsControlPressed(0, 174) then
                currentOffset = vector3(currentOffset.x, currentOffset.y + step, currentOffset.z)
                AttachPet()
            end

            if IsControlPressed(0, 175) then
                currentOffset = vector3(currentOffset.x, currentOffset.y - step, currentOffset.z)
                AttachPet()
            end

            if IsControlJustPressed(0, 38) then
                isEditing = false

                SaveStateToServer()
            end

            if IsControlJustPressed(0, 177) then
                DeleteCurrentPet()
            end

            if IsPedDeadOrDying(PlayerPedId(), true) then
                DestroyEntityOnly()
                isEditing = false
            end

            Wait(0)
        end
    end)
end

local function SpawnPetForItem(itemName)
    local cfg = PetConfig[itemName]
    if not cfg then return end

    currentItem = itemName
    currentOffset = cfg.offset
    currentRotation = cfg.rotation

    local obj = CreatePetEntityNow()
    if not obj then return end

    SaveStateToServer()

    StartEditLoop()
end

RegisterNetEvent("lewall_pets:useItem", function(itemName)
    if currentPet and DoesEntityExist(currentPet) then
        if currentItem == itemName then
            DeleteCurrentPet()
            ESX.ShowNotification("Tu ranges le pet")
        else

            ResetStateLocal()
            ClearStateOnServer()
            SpawnPetForItem(itemName)
            ESX.ShowNotification("Tu changes de pet")
        end
    else
        if not PetConfig[itemName] then return end
        if currentItem and currentItem ~= itemName then

            ResetStateLocal()
            ClearStateOnServer()
        end
        SpawnPetForItem(itemName)
        ESX.ShowNotification("Utilise les touches pour ajuster ton pet")
    end
end)

RegisterNetEvent("lewall_pets:client:restore", function(state)
    if type(state) ~= "table" then return end
    local item = tostring(state.item or "")
    if item == "" or not PetConfig[item] then return end

    DestroyEntityOnly()
    isEditing = false
    restoring = true

    currentItem = item
    currentOffset = vector3(
        tonumber(state.offset_x) or PetConfig[item].offset.x,
        tonumber(state.offset_y) or PetConfig[item].offset.y,
        tonumber(state.offset_z) or PetConfig[item].offset.z
    )
    currentRotation = vector3(
        tonumber(state.rot_x) or PetConfig[item].rotation.x,
        tonumber(state.rot_y) or PetConfig[item].rotation.y,
        tonumber(state.rot_z) or PetConfig[item].rotation.z
    )

    CreateThread(function()
        local tries = 0
        while tries < 60 do
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and NetworkIsPlayerActive(PlayerId()) then
                if CreatePetEntityNow() then
                    break
                end
            end
            Wait(500)
            tries = tries + 1
        end
        restoring = false
    end)
end)

AddEventHandler("onClientResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    CreateThread(function()

        local tries = 0
        while (not ESX or type(ESX.TriggerServerCallback) ~= "function") and tries < 40 do
            Wait(250)
            tries = tries + 1
        end
        if not ESX or type(ESX.TriggerServerCallback) ~= "function" then return end

        ESX.TriggerServerCallback("lewall_pets:server:get", function(state)
            if state and state.item and PetConfig[state.item] then
                TriggerEvent("lewall_pets:client:restore", state)
            end
        end)
    end)
end)

CreateThread(function()
    local lastPed = 0
    while true do
        Wait(2000)

        local ped = PlayerPedId()
        if not ped or ped == 0 then

        elseif currentItem and not isEditing and not restoring then
            local pedChanged = (lastPed ~= 0 and lastPed ~= ped)
            local petGone = (not currentPet) or (not DoesEntityExist(currentPet))
            local petWrongAttach = false

            if currentPet and DoesEntityExist(currentPet) then
                if not IsEntityAttachedToEntity(currentPet, ped) then
                    petWrongAttach = true
                end
            end

            if (pedChanged or petGone or petWrongAttach) and not IsEntityDead(ped) then
                DestroyEntityOnly()
                CreatePetEntityNow()
            end
        end

        if ped and ped ~= 0 then
            lastPed = ped
        end
    end
end)

AddEventHandler("onClientResourceStop", function(res)
    if res == GetCurrentResourceName() then
        DestroyEntityOnly()
    end
end)
