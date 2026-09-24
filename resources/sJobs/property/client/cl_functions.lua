PROPERTY["getJob"] = function()
    return ESX.PlayerData.job
end

PROPERTY.getCamDirection = function()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

takedBox = function()
    return PROPERTY["taked"]
end

local PlacingObject, LoadedObjects = false, false
local CurrentModel, CurrentObject, CurrentCoords, CurrentObjectPreview, CurrentData = nil, nil, nil, nil, {}
local spawnedProps = {}

function DeleteAllSpawnedPropertyProps()
    for k,v in pairs(spawnedProps) do
        DeleteEntity(v)
    end
end

local function CancelPlacement()
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentCoords = nil

    for k,v in pairs(spawnedProps) do
        DeleteEntity(v)
    end
end

function RequestSpawnObject(object)
    local hash = (type(object) == 'number' and object or GetHashKey(object))

    print(IsModelValid(hash))

    local count = 0
    if IsModelValid(hash) and not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do

            if count + 1 > 3 then
                break
            else
                count = count + 1
            end

            print(count, object, hash)

            Wait(100)
        end
    end
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

local function PlaceSpawnedObject(heading)
    CurrentData.coords = vector3(CurrentCoords.x, CurrentCoords.y, CurrentCoords.z)
    CurrentData.heading = heading
    CurrentData.rotation = vector3(0.0, 0.0, 0.0)

    TriggerServerEvent("property:furniture:placeProps", CurrentData)

    DeleteObject(CurrentObject)

    PlacingObject = false
    CurrentObject = nil
    CurrentCoords = nil
    CurrentModel = nil
end

local function PlaceSpawnedObjectProps(heading)
    CurrentData.coordsModel = CurrentCoords
    CurrentData.heading = heading

    TriggerServerEvent("propsMenu:placeProps", CurrentData)

    DeleteObject(CurrentObject)

    PlacingObject = false
    CurrentObject = nil
    CurrentCoords = nil
    CurrentModel = nil
end

function CreateSpawnedObject(data)
    for k,v in pairs(spawnedProps) do
        DeleteEntity(v)
    end

    if data.model == nil then return print("Invalid Object") end
    local object = data.model

    CurrentData = data

    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, false, true, false)
    table.insert(spawnedProps, CurrentObject)

    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)

    SetEntityAlpha(CurrentObject, 175)
    SetEntityCollision(CurrentObject, false, false)
    FreezeEntityPosition(CurrentObject, true)

    PlacingObject = true
    Citizen.CreateThread(function()
        local object = UIInstructionalButton.__constructor()

        object:Add("Annuler", 194)
        object:Add("Tourner à gauche", 189)
        object:Add("Tourner à droite", 190)
        object:Add("Placer le props", 191)
        object:Visible(true)

        local timeout = 0
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
            end

            if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                timeout = GetGameTimer() + 76
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end

            if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                timeout = GetGameTimer() + 76
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end

            if IsControlJustPressed(0, 177) then
                CancelPlacement()
            end

            SetEntityHeading(CurrentObject, heading)
            PlaceObjectOnGroundProperly(CurrentObject)

            if IsControlJustPressed(0, 18) then
                PlaceSpawnedObject(heading)
            end

            Citizen.Wait(0)
            object:onTick()
        end

        object:Delete("Annuler", 194)
        object:Delete("Tourner à gauche", 189)
        object:Delete("Tourner à droite", 190)
        object:Delete("Placer le props", 191)
    end)
end

function CreateSpawnedObjectPropsMenu(data)
    for k,v in pairs(spawnedProps) do
        DeleteEntity(v)
    end

    if data.model == nil then return print("Invalid Object") end
    local object = data.model

    CurrentData = data

    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, false, true, false)
    table.insert(spawnedProps, CurrentObject)

    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)

    SetEntityAlpha(CurrentObject, 175)
    SetEntityCollision(CurrentObject, false, false)
    FreezeEntityPosition(CurrentObject, true)

    PlacingObject = true
    Citizen.CreateThread(function()
        local object = UIInstructionalButton.__constructor()

        object:Add("Annuler", 194)
        object:Add("Tourner à gauche", 189)
        object:Add("Tourner à droite", 190)
        object:Add("Placer le props", 191)
        object:Visible(true)

        local timeout = 0
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
            end

            if IsControlPressed(0, 174) and GetGameTimer() > timeout then
                timeout = GetGameTimer() + 76
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end

            if IsControlPressed(0, 175) and GetGameTimer() > timeout then
                timeout = GetGameTimer() + 76
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end

            if IsControlJustPressed(0, 177) then
                CancelPlacement()
            end

            SetEntityHeading(CurrentObject, heading)
            PlaceObjectOnGroundProperly(CurrentObject)

            if IsControlJustPressed(0, 18) then
                PlaceSpawnedObjectProps(heading)
            end

            Citizen.Wait(0)
            object:onTick()
        end

        object:Delete("Annuler", 194)
        object:Delete("Tourner à gauche", 189)
        object:Delete("Tourner à droite", 190)
        object:Delete("Placer le props", 191)
    end)
end

function CreateSpawnedObjectPreview(model)
    for k,v in pairs(spawnedProps) do
        DeleteEntity(v)
    end

    if model == nil then return end
    local object = model

    if CurrentObjectPreview and DoesEntityExist(CurrentObjectPreview) then
        DeleteEntity(CurrentObjectPreview)
    end

    CurrentData = data

    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObjectPreview = CreateObject(object, 1.0, 1.0, 1.0, false, true, false)
    table.insert(spawnedProps, CurrentObjectPreview)

    local heading = 0.0
    SetEntityHeading(CurrentObjectPreview, 0)

    SetEntityAlpha(CurrentObjectPreview, 175)
    SetEntityCollision(CurrentObjectPreview, false, false)
    FreezeEntityPosition(CurrentObjectPreview, true)

    PlacingObject = true
    Citizen.CreateThread(function()
        local timeout = 0
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            if hit then
                SetEntityCoords(CurrentObjectPreview, coords.x, coords.y, coords.z)
            end

            if GetGameTimer() > timeout then
                timeout = GetGameTimer() + 10
                heading = heading + 0.50
                if heading > 360 then heading = 0.0 end
            end

            SetEntityHeading(CurrentObjectPreview, heading)
            PlaceObjectOnGroundProperly(CurrentObjectPreview)

            Citizen.Wait(0)
        end
    end)
end

ClearSpawnedProps = function()
    CancelPlacement()

    if CurrentObjectPreview and DoesEntityExist(CurrentObjectPreview) then
        DeleteEntity(CurrentObjectPreview)
    end
end

function IsPoliceLt()
    local pd = ESX.GetPlayerData()
    if not pd or not pd.job or pd.job.name ~= "police" and pd.job.name ~= "sheriff" then return false end
    local gname = tostring(pd.job.grade_name or ""):lower()
    local gnum  = tonumber(pd.job.grade) or 0
    local allowed = {
        lieutenant=true, capitaine=true, commandant=true, commissaire=true,
        chef=true, boss=true, captain=true, chief=true
    }
    return allowed[gname] or gnum >= 4
end

PROPERTY = PROPERTY or {}

PROPERTY["forceDoorMinGrade"] = {
    police  = 5,
    sheriff = 5,
}

function CanDestroyProperty()
    if not ESX or not ESX.GetPlayerData then return false end
    local pd = ESX.GetPlayerData()
    if not pd or not pd.job then return false end

    local jobName = pd.job.name
    local grade   = tonumber(pd.job.grade) or -1

    local minGrade = PROPERTY["forceDoorMinGrade"][jobName]
    if not minGrade then return false end
    return grade >= minGrade
end

function IsPropertyDoorForced(propertyId)
    return PROPERTY["forcedProperties"] and PROPERTY["forcedProperties"][propertyId] == true
end
