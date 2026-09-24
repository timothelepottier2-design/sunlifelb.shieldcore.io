attachedProp = 0
attachedProp2 = 0

function attachAProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp2()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp2, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function attachAProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

function loadModel(modelName)
    RequestModel(GetHashKey(modelName))
    while not HasModelLoaded(GetHashKey(modelName)) do
        RequestModel(GetHashKey(modelName))
        Citizen.Wait(1)
    end
end

function removeAttachedProp2()
	DeleteEntity(attachedProp2)
	attachedProp2 = 0
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent("khaoz-chairs:Chair1")
AddEventHandler("khaoz-chairs:Chair1", function()
	greenchair()
end)

RegisterNetEvent("khaoz-chairs:Chair2")
AddEventHandler("khaoz-chairs:Chair2", function()
	pladchair()
end)

Citizen.CreateThread(function()
	while true do
		if haschairalready == true then
			local coords = GetEntityCoords(PlayerPedId())
			DrawText3Ds(coords.x, coords.y, coords.z, "Appuyez sur E pour ramasser la chaise", 255, 255, 255)
			if IsControlPressed(0, 38) then
				haschairalready = false
				FreezeEntityPosition(PlayerPedId(),false)
				removeAttachedProp()
				removeAttachedProp2()
				ClearPedTasks(PlayerPedId())
			end
		end

		if haschairalready then
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

function greenchair()
	if not haschairalready then
		haschairalready = true
		local coords = GetEntityCoords(PlayerPedId())
		local animDict = "timetable@ron@ig_3_couch"
		local animation = "base"
		attachAProp("prop_skid_chair_01", 0, 0, 0.0, -0.22, 3.4, 0.4, 180.0, 0.0, false, false, false, false, 2, true)
		loadAnimDict(animDict)
		local animLength = GetAnimDuration(animDict, animation)
		TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
	else
		haschairalready = false
		FreezeEntityPosition(PlayerPedId(),false)
		removeAttachedProp()
		removeAttachedProp2()
		ClearPedTasks(PlayerPedId())
	end
end

function pladchair()
	if not haschairalready then
		haschairalready = true
		local coords = GetEntityCoords(PlayerPedId())
		local animDict = "timetable@ron@ig_3_couch"
		local animation = "base"
		attachAProp("hei_prop_hei_skid_chair", 0, 0, 0.0, -0.22, 3.4, 0.4, 180.0, 0.0, false, false, false, false, 2, true)
		loadAnimDict(animDict)
		local animLength = GetAnimDuration(animDict, animation)
		TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0, animLength, 1, 0, 0, 0, 0)
	else
		haschairalready = false
		FreezeEntityPosition(PlayerPedId(),false)
		removeAttachedProp()
		removeAttachedProp2()
		ClearPedTasks(PlayerPedId())
	end
end

function DrawText3Ds(x, y, z, text, r, g, b)
    r = r or 255
    g = g or 255
    b = b or 255
    local _, _x, _y = World3dToScreen2d(x,y,z)
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end