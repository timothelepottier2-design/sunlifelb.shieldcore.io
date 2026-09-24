local __SL_send_native = SendNUIMessage
local __SL_focus_native = SetNuiFocus
local __SL_reg_native = RegisterNUICallback
local function SendNUIMessage(data)
    return __SL_send_native({ _slapp = 'jobsui', _slpayload = data })
end
local function SetNuiFocus(hasFocus, hasCursor)
    __SL_send_native({ _slrouter = true, _slapp = 'jobsui', focus = hasFocus and true or false })
    return __SL_focus_native(hasFocus, hasCursor)
end
local function RegisterNUICallback(name, cb)
    return __SL_reg_native('jobsui/' .. name, cb)
end

local jobs = {
    ["private"] = {
        {discord = "", name="LSPD", value="police", coords = vector3(-1107.9444580078, -845.08624267578, 19.31694984436), banner="https://i.ibb.co/LswK5cv/LSPD.png", desc="Protège et sert la ville, fais régner l’ordre et la loi dans les rues de Los Santos.", playersIn=1},
        {discord = "", name="BCSO", value="sheriff", coords = vector3(2827.3720703125, 4730.5659179688, 48.627391815186), banner="https://i.ibb.co/wNJqcNLw/BCSO.png", desc="Assure la sécurité du comté, du désert aux petites routes perdues.", playersIn=1},
        {discord = "", name="EMS", value="ems", coords = vector3(-669.53845214844, 310.27947998047, 83.084182739258), banner="https://i.ibb.co/BHdh3c3z/EMS.png", desc="Sauve des vies et apporte les premiers soins aux citoyens de Los Santos.", playersIn=1},
        {discord = "", name="LSFD", value="lsfd", coords = vector3(-1039.8175048828, -1400.6787109375, 5.0749530792236), banner="https://i.ibb.co/ynpcvhHV/LSFD.png", desc="Lutte contre les flammes, porte secours et protège la ville des dangers.", playersIn=1},
        {discord = "", name="Département de la justice", value="gouv", coords = vector3(-531.8856, -180.3118, 43.36586), banner="https://i.ibb.co/sv1mrXqB/Gouvernement.png", desc="Dirige la ville, prends des décisions et façonne l’avenir de Los Santos.", playersIn=1},
        {discord = "", name="Ammu Nation", value="ammu", coords = vector3(16.463935852051, -1109.4421386719, 29.797204971313), banner="https://i.ibb.co/Y7C1cMjw/Ammu-Nation.png", desc="Vends des armes légales et équipe la ville pour sa sécurité… ou pas.", playersIn=1},
        {discord = "", name="Bennys Custom", value="bennys", coords = vector3(-203.923279, -1322.602173, 30.913483), banner="https://i.ibb.co/dwkyxQqs/image.png", desc="Personnalise, répare et donne du style unique à chaque voiture.", playersIn=1},
        {discord = "", name="USSS", value="usss", coords = vector3(104.317177, -744.450623, 44.854761), banner="https://i.ibb.co/wrgyJ1LY/bobcatqg.png", desc="Service de protection rapprochee et de securite des institutions.", playersIn=1},
        {discord = "", name="Bobcat Security", value="bobcat", coords = vector3(-642.883301, -2382.553711, 13.461938), banner="https://i.ibb.co/wrgyJ1LY/bobcatqg.png", desc="Assure la sécurité des entreprises et des particuliers avec expertise et vigilance.", playersIn=1},
        {discord = "", name="Dynasty 8", value="immo", coords = vector3(-706.324280, 269.042725, 83.147308), banner="https://i.ibb.co/fVd1QC4G/dynasty.png", desc="Aide à trouver la maison ou l’appartement parfait pour chaque citoyen de Los Santos.", playersIn=1},
        {discord = "", name="Fourriere", value="fourriere", coords = vector3(-194.051865, -1174.856079, 23.044044), banner="https://i.ibb.co/TB0hrTRr/fourriere.png", desc="Retire les véhicules abandonnés ou mal garés et garde les rues de Los Santos dégagées.", playersIn=1},
        {discord = "", name="Harmony Custom", value="harmony", coords = vector3(77.160553, 6533.242188, 31.032268), banner="https://i.ibb.co/4Rj7cYPh/harmony.png", desc="Personnalise chaque véhicule pour qu’il reflète le style unique de son propriétaire.", playersIn=1},
        {discord = "", name="Premium Deluxe Motorsport", value="pdm", coords = vector3(-32.947334289551, -1096.7514648438, 27.274406433105), banner="https://i.ibb.co/57mHvrS/Premium-Deluxe-Motorsport.png", desc="Concessionnaire de luxe pour trouver la voiture de prestige qui vous ressemble.", playersIn=1},
        {discord = "", name="Weazle News", value="weazle", coords = vector3(-594.64196777344, -929.80444335938, 23.869632720947), banner="https://i.ibb.co/svcZh4Lj/Weazle-News.png", desc="Informe la ville, capture l’actualité et révèle les histoires de Los Santos.", playersIn=1},
        {discord = "", name="LTD Sud", value="ltdsud", coords = vector3(-707.56164550781, -913.93597412109, 19.215599060059), banner="https://i.ibb.co/mCbhMhgL/LTD-Sud.png", desc="Épicerie de quartier où trouver tout le nécessaire du quotidien à Los Santos.", playersIn=1},
        {discord = "", name="Burger Shot", value="burgershot", coords = vector3(-1191.2590332031, -893.22357177734, 13.886160850525), banner="https://i.ibb.co/0VJRByjD/burgershot.png", desc="Sers des burgers délicieux et rapides pour régaler toute la ville.", playersIn=1},
        {discord = "", name="Unicorn", value="unicorn", coords = vector3(135.95733642578, -1290.8259277344, 29.219013214111), banner="https://i.ibb.co/3mLkgf5C/Unicorn.png", desc="Bar et club où la fête ne s’arrête jamais, entre musique et spectacles.", playersIn=1},
    },
    ["public"] = {
        {name="Jardinier", value="jardinier", coords = vector3(-1680.2, 494.7, 127.87), banner="https://i.ibb.co/4Z9Tpt2k/image.png", desc="Entretenez les espaces verts de la ville.", playersIn=1},
        {name="Maçon", value="macon", coords = vector3(-924.69, 380.97, 78.25), banner="https://i.ibb.co/0RbZjvXT/image.png", desc="Construisez et rénovez la ville.", playersIn=1},
        {name="Livreur", value="livreur", coords = vector3(1197.2325439453, -3253.4575195312, 7.0951809883118), banner="https://i.ibb.co/BKrz7gwy/image.png", desc="Assurez les livraisons en ville.", playersIn=1},
        {name="Bûcheron", value="bucheron", coords = vector3(-636.25994873047, 5493.349609375, 50.68408203125), banner="https://i.ibb.co/BH65PVzL/image.png", desc="Le bois le vrai.", playersIn=1},
        {name="Guide touristique", value="guide", coords = vector3(603.19671630859, 78.964698791504, 91.391799926758), banner="https://i.ibb.co/PZczx5HW/image-3.png", desc="Faites découvrir Los Santos, arrêts touristiques & paie à chaque stop.", playersIn=1},
        {name="Livreur SunEATS", value="pizza", coords = vector3(-296.32568359375, -1342.5970458984, 31.300100326538), banner="https://i.ibb.co/BKrz7gwy/image.png", desc="Livrez des plats en scooter, destinations aléatoires.", playersIn=1},
    },
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local JobPlaces = {
	{x = -1207.267090, y = -195.467499, z = 39.324947, },
	{x = -266.091095, y = -962.292297, z = 31.223143, },
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(JobPlaces) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, JobPlaces[k].x, JobPlaces[k].y, JobPlaces[k].z)

            if dist <= 2.0 then
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour chercher un emploi.")
                DrawMarker(6, JobPlaces[k].x, JobPlaces[k].y, JobPlaces[k].z - 1.0, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 106, 0, 100)
				if IsControlJustPressed(1,51) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = 'openJobs',
						resource = GetCurrentResourceName(),
						data = jobs
					})
				end
			end
        end

        if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

Citizen.CreateThread(function()

	AddTextEntry("BN_POLE_EMPLOI", "Pôle Emploi")

	for k in pairs(JobPlaces) do
		local poleblip = AddBlipForCoord(JobPlaces[k].x, JobPlaces[k].y, JobPlaces[k].z)
		SetBlipSprite(poleblip, 590)
		SetBlipScale(poleblip, 0.8)
		SetBlipColour(poleblip, 8)
		SetBlipAsShortRange(poleblip, true)
		BeginTextCommandSetBlipName("BN_POLE_EMPLOI")
		EndTextCommandSetBlipName(poleblip)
	end
end)

local function FindJobByValue(val)
    if not val or val == '' then return nil end
    for _, grp in pairs(jobs) do
        for _, j in ipairs(grp) do
            if j.value == val then
                return j
            end
        end
    end
    return nil
end

RegisterNUICallback('selectJob', function(data, cb)
    SetNuiFocus(false, false)
    cb(true)

    local job  = tostring(data.value or '')
    local name = tostring(data.name or job)
    if job == '' then return end

    local info = FindJobByValue(job)
    if info and info.coords then
        SetNewWaypoint(info.coords.x + 0.0, info.coords.y + 0.0)
        ESX.ShowNotification(('📍 Itinéraire vers ~y~%s~s~ défini'):format(info.name or name))
    else
        SetNewWaypoint(-265.87, -962.6)
        ESX.ShowNotification('📍 Itinéraire vers ~y~Pôle Emploi~s~ défini')
    end

    if not _G.__lastJobPick or (GetGameTimer() - _G.__lastJobPick > 1500) then
        _G.__lastJobPick = GetGameTimer()
        TriggerServerEvent('jobs:selectJob', job, name)
    end
end)

RegisterNUICallback('close', function(_, cb)
	SetNuiFocus(false, false)
	cb(true)
end)
