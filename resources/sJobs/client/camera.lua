local holdingCam, mooveCamn newsCam, holdingMicro, holdingMPerche = false, false, false, false, false
local camNetId, new_z, new_x, microNetId = nil, nil, nil, nil
local camDict, camAnim = "missfinale_c2mcs_1", "fin_c2_mcs_1_camman"
local fov_max = 70.0
local fov_min = 5.0
local fov = (fov_max + fov_min) * 0.5
local speed_lr = 8.0
local speed_ud = 8.0
local zoomspeed = 10.0
local microDict, microAnim = "missheistdocksprep1hold_cellphone", "hold_cellphone"
local microPDict, microPAnim = "missfra1", "mcs2_crew_idle_m_boom"

local function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

local function breaking(text)
	SetTextColour(255, 255, 255, 255)
	SetTextFont(8)
	SetTextScale(1.2, 1.2)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.2, 0.85)
end

local function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

local function checkInputRotation(cam, zoomValue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)

	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomValue + 0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomValue + 0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

local function handleZoom(cam)
	local ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(ped) then
		if IsControlJustPressed(0, 241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0, 242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end

		local current_fov = GetCamFov(cam)
		if math.abs(fov - current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
	else
		if IsControlJustPressed(0, 17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0, 16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end

		local current_fov = GetCamFov(cam)
		if math.abs(fov - current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
	end
end

local function cinemaCam()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)

    mooveCam = true

    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)

    local scaleForm = RequestScaleformMovie("security_camera")
	while not HasScaleformMovieLoaded(scaleForm) do
		Citizen.Wait(10)
	end

    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
	AttachCamToEntity(cam, ped, 0.0, 0.0, 1.0, true)
	SetCamRot(cam, 2.0, 1.0, GetEntityHeading(ped))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, 1, 0)

    PushScaleformMovieFunction(scaleForm, "security_camera")
	PopScaleformMovieFunctionVoid()

    while mooveCam and not IsEntityDead(ped) and (GetVehiclePedIsIn(ped) == vehicle) and true do
	    if IsControlJustPressed(0, 177) then
		    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
		    mooveCam = false
	    end

        local zoomValue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
        checkInputRotation(cam, zoomValue)

        handleZoom(cam)
		HideHUDThisFrame()

        drawRct(0.000 + 0.0, -0.001 + 0.0, 1.0, 0.15, 0, 0, 0, 255)
        DrawScaleformMovieFullscreen(scaleForm, 255, 255, 255, 255)
        drawRct(0.000 + 0.0, -0.001 + 0.85, 1.0, 0.16, 0, 0, 0, 255)

        local camHeading = GetGameplayCamRelativeHeading()
		local camPitch = GetGameplayCamRelativePitch()
		if camPitch < -70.0 then
			camPitch = -70.0
		elseif camPitch > 42.0 then
			camPitch = 42.0
		end
        camPitch = (camPitch + 70.0) / 112.0

        if camHeading < -180.0 then
			camHeading = -180.0
		elseif camHeading > 180.0 then
			camHeading = 180.0
		end
		camHeading = (camHeading + 180.0) / 360.0

        Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
		Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)

        Citizen.Wait(0)
    end

    mooveCam = false
    ClearTimecycleModifier()
	fov = (fov_max+fov_min) * 0.5
    RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleForm)
	DestroyCam(cam, false)
	SetNightvision(false)
	SetSeethrough(false)
end

local function newCam()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)

    newsCam = true

	SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)

    local scaleForm = RequestScaleformMovie("security_camera")
	local scaleForm2 = RequestScaleformMovie("breaking_news")
    while not HasScaleformMovieLoaded(scaleForm) or not HasScaleformMovieLoaded(scaleForm2) do
        Citizen.Wait(10)
    end

    local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cam2, ped, 0.0,0.0,1.0, true)
	SetCamRot(cam2, 2.0,1.0,GetEntityHeading(ped))
	SetCamFov(cam2, fov)
	RenderScriptCams(true, false, 0, 1, 0)

    PushScaleformMovieFunction(scaleForm, "SET_CAM_LOGO")
	PushScaleformMovieFunction(scaleForm2, "breaking_news")
	PopScaleformMovieFunctionVoid()

    while newsCam and not IsEntityDead(ped) and (GetVehiclePedIsIn(ped) == vehicle) and true do
	    if IsControlJustPressed(1, 177) then
		    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
		    newsCam = false
	    end

        local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
		checkInputRotation(cam2, zoomvalue)

        handleZoom(cam2)
		HideHUDThisFrame()

		DrawScaleformMovieFullscreen(scaleForm, 255, 255, 255, 255)
		DrawScaleformMovie(scaleForm2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
		breaking("BREAKING NEWS")

        local camHeading = GetGameplayCamRelativeHeading()
		local camPitch = GetGameplayCamRelativePitch()
        if camPitch < -70.0 then
			camPitch = -70.0
		elseif camPitch > 42.0 then
			camPitch = 42.0
		end
		camPitch = (camPitch + 70.0) / 112.0

        if camHeading < -180.0 then
		    camHeading = -180.0
	    elseif camHeading > 180.0 then
		    camHeading = 180.0
	    end
	    camHeading = (camHeading + 180.0) / 360.0

        Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
		Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)

        Citizen.Wait(0)
    end

    newsCam = false
    ClearTimecycleModifier()
	fov = (fov_max + fov_min) * 0.5
    RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleForm)
	DestroyCam(cam2, false)
	SetNightvision(false)
	SetSeethrough(false)
end

local function cameraLoop()
    Citizen.CreateThread(function()
        while holdingCam do
            while not HasAnimDictLoaded(camDict) do
                RequestAnimDict(camDict)
                Citizen.Wait(100)
            end

            if not IsEntityPlayingAnim(PlayerPedId(), camDict, camAnim, 3) then
                TaskPlayAnim(PlayerPedId(), camDict, camAnim, 1.0, -1, -1, 50, 0, 0, 0, 0)
            end

            DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

            DisplayNotification("~INPUT_PICKUP~ pour activer le mode news\n~INPUT_FRONTEND_RT~ pour activer le mode cinéma")

            if IsControlJustReleased(1, 208) then
                cinemaCam()
            end

            if IsControlJustReleased(1, 38) then
                newCam()
            end

            Wait(0)
        end
    end)
end

local function microPLoop()
    Citizen.CreateThread(function()
        while holdingMPerche do
            while not HasAnimDictLoaded(microPDict) do
                RequestAnimDict(microPDict)
                Citizen.Wait(100)
            end

            if not IsEntityPlayingAnim(PlayerPedId(), microPDict, microPAnim, 3) then
                TaskPlayAnim(PlayerPedId(), microPDict, microPAnim, 1.0, -1, -1, 50, 0, 0, 0, 0)
            end

            DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

            if (IsPedInAnyVehicle(PlayerPedId(), -1) and GetPedVehicleSeat(PlayerPedId()) == -1) or IsPedCuffed(PlayerPedId()) or holdingMicro then
				ClearPedSecondaryTask(PlayerPedId())
				DetachEntity(NetToObj(microPNetId), 1, 1)
				DeleteEntity(NetToObj(microPNetId))
				microPNetId = nil
				holdingMPerche = false
			end

            Wait(0)
        end
    end)
end

function mainCamera()
    local camModel <const> = "prop_v_cam_01"
    local ped = PlayerId()

    if not holdingCam then
        ExecuteCommand("ToggleHUDT")
		ExecuteCommand("hudtoggle")

        RequestModel(GetHashKey(camModel))
        while not HasModelLoaded(GetHashKey(camModel)) do
            Citizen.Wait(100)
        end

        local playerCoords = GetEntityCoords(GetPlayerPed(ped))
        print(('^2[NETDIAG][OBJET]^7 %s camera.lua:320 CreateObject NETWORKED cam=%s'):format(GetCurrentResourceName(), tostring(camModel)))
        local camSpawn = CreateObject(GetHashKey(camModel), playerCoords.x, playerCoords.y, playerCoords.z, 1, 1, 1)

        Citizen.Wait(0)

        local netId = ObjToNet(camSpawn)
        SetNetworkIdExistsOnAllMachines(netId, true)
        NetworkSetNetworkIdDynamic(netId, true)
        SetNetworkIdCanMigrate(netId, false)

        AttachEntityToEntity(camSpawn, GetPlayerPed(ped), GetPedBoneIndex(GetPlayerPed(ped), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(ped), camDict, camAnim, 1.0, -1, -1, 50, 0, 0, 0, 0)

        camNetId = netId
        holdingCam = true

        DisplayNotification("~INPUT_PICKUP~ pour activer le mode news\n~INPUT_FRONTEND_RT~ pour activer le mode cinéma")

        cameraLoop()
    else
        ClearPedSecondaryTask(GetPlayerPed(ped))
        DetachEntity(NetToObj(camNetId), 1, 1)
        DeleteEntity(NetToObj(camNetId))
        camNetId = nil
        holdingCam = false

        ExecuteCommand("ToggleHUDF")
		ExecuteCommand("hudtoggle")
    end
end

function mainMicro()
    local microModel <const> = "p_ing_microphonel_01"
    local ped = PlayerId()

    if not holdingMicro then
        RequestModel(GetHashKey(microModel))
        while not HasModelLoaded(GetHashKey(microModel)) do
            Citizen.Wait(100)
        end

        while not HasAnimDictLoaded(microDict) do
			RequestAnimDict(microDict)
			Citizen.Wait(100)
		end

        local playerCoords = GetEntityCoords(GetPlayerPed(ped))
        print(('^2[NETDIAG][OBJET]^7 %s camera.lua:366 CreateObject NETWORKED micro=%s'):format(GetCurrentResourceName(), tostring(microModel)))
        local microSpawn = CreateObject(GetHashKey(microModel), playerCoords.x, playerCoords.y, playerCoords.z, 1, 1, 1)

        Citizen.Wait(0)

        local netId = ObjToNet(microSpawn)
        SetNetworkIdExistsOnAllMachines(netId, true)
        NetworkSetNetworkIdDynamic(netId, true)
        SetNetworkIdCanMigrate(netId, false)

        AttachEntityToEntity(microSpawn, GetPlayerPed(ped), GetPedBoneIndex(GetPlayerPed(ped), 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(ped), microDict, microAnim, 1.0, -1, -1, 50, 0, 0, 0, 0)
        microNetId = netId
        holdingMicro = true
    else
        ClearPedSecondaryTask(GetPlayerPed(ped))
        DetachEntity(NetToObj(microNetId), 1, 1)
        DeleteEntity(NetToObj(microNetId))
        microNetId = nil
        holdingMicro = false
    end
end

function mainMPerche()
    local microPModel <const> = "prop_v_bmike_01"
    local ped = PlayerId()

    if not holdingMPerche then
        RequestModel(GetHashKey(microPModel))
        while not HasModelLoaded(GetHashKey(microPModel)) do
            Citizen.Wait(100)
        end

        while not HasAnimDictLoaded(microPDict) do
			RequestAnimDict(microPDict)
			Citizen.Wait(100)
		end

        local playerCoords = GetEntityCoords(GetPlayerPed(ped))
        print(('^2[NETDIAG][OBJET]^7 %s camera.lua:404 CreateObject NETWORKED microP=%s'):format(GetCurrentResourceName(), tostring(microPModel)))
        local microPSpawn = CreateObject(GetHashKey(microPModel), playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)

        Citizen.Wait(0)

        local netId = ObjToNet(microPSpawn)
        SetNetworkIdExistsOnAllMachines(netId, true)
        NetworkSetNetworkIdDynamic(netId, true)
        SetNetworkIdCanMigrate(netId, false)

        AttachEntityToEntity(microPSpawn, GetPlayerPed(ped), GetPedBoneIndex(GetPlayerPed(ped), 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(ped), microPDict, microPAnim, 1.0, -1, -1, 50, 0, 0, 0, 0)
        microPNetId = netId
        holdingMPerche = true
        microPLoop()
    else
        ClearPedSecondaryTask(GetPlayerPed(ped))
        DetachEntity(NetToObj(microPNetId), 1, 1)
        DeleteEntity(NetToObj(microPNetId))
        microPNetId = nil
        holdingMPerche = false
    end
end
