Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local dataSociety <const> = {
    ["ammu"] = {
       {type = "boss", coords = vec3(7.052733, -1099.688721, 28.897205)},
       {type = "stashe", coords = vec3(826.3329, -2159.0613, 27.9129)},
    },
    ["bobcat"] = {
        {type = "boss", coords = vec3(-632.770264, -2368.100830, 13.203943)},
        {type = "stashe", coords = vec3(-632.398682, -2392.623291, 13.203861)},
        {type = "armory", coords = vec3(-648.443970, -2391.417480, 7.208286)},
        {type = "cloakroom", coords = vec3(-637.481018, -2365.953369, 13.203951)},
    },
    ["usss"] = {
        {type = "boss", coords = vec3(148.897095, -758.525513, 241.251520)},
        {type = "stashe", coords = vec3(119.592522, -745.134399, 241.252023)},
        {type = "armory", coords = vec3(118.933365, -729.189453, 241.252008)},
        {type = "cloakroom", coords = vec3(125.245857, -728.507507, 241.252008)},
    },
    ["doj"] = {
        {type = "boss", coords = vec3(-532.0051, -188.3757, 42.3659)},
        {type = "stashe", coords = vec3(-531.8899, -180.3158, 42.3614)},
        {type = "armory", coords = vec3(-559.0826, -228.5555, 33.2741)},
    },
    ["gouv"] = {
        {type = "boss", coords = vec3(-383.804749, 1075.936279, 333.992426)},
        {type = "stashe", coords = vec3(-405.587189, 1075.176880, 334.000665)},
    },
    ["elysian"] = {
        {type = "boss", coords = vec3(-126.9818, -2519.2371, 10.1799)},
        {type = "stashe", coords = vec3(-116.6293, -2500.8101, 5.1076)},
        {type = "cloakroom", coords = vec3(-125.4974, -2525.1865, 10.1743)},
    },
    ["fourriere"] = {
        {type = "boss", coords = vec3(463.09188842773, -1146.4752197266, 28.711644744873)},
        {type = "stashe", coords = vec3(438.06036376953, -1167.1925048828, 28.518937683105)},
    },
    ["grotti"] = {
        {type = "boss", coords = vec3(-915.5731, -2016.7793, 8.5093)},
        {type = "stashe", coords = vec3(-917.9696, -2024.1660, 8.5093)},
        {type = "buyVehicle", coords = vec3(-945.9717, -2051.1919, 8.5064)},
        {type = "sellVehicle", coords = vec3(-931.9675, -2030.8280, 8.5093)},
    },
    ["lsfd"] = {
        {type = "boss", coords = vec3(-1055.8124, -1435.0380, 3.9685)},
        {type = "stashe", coords = vec3(-1045.0286, -1387.9406, 3.9774)},
        {type = "cloakroom", coords = vec3(-1030.6998, -1392.7249, 3.9702)},
        {type = "armory", coords = vec3(-1036.3578, -1391.3951, 3.9731)},
    },
    ["bennys"] = {
        {type = "boss", coords = vec3(-195.2762, -1335.8939, 29.8905)},
        {type = "stashe", coords = vec3(-206.8696, -1340.0917, 29.8905)},
        {type = "cloakroom", coords = vec3(-209.5598, -1338.2897, 29.8904)},
    },
    ["streettuners"] = {
        {type = "boss", coords = vec3(5132.631348, -5140.447266, 1.313866)},
        {type = "stashe", coords = vec3(5126.236816, -5140.160156, 1.313866)},
        {type = "cloakroom", coords = vec3(5134.413086, -5115.995605, 1.313863)},
    },
    ["harmony"] = {
        {type = "boss", coords = vec3(71.885834, 6520.236328, 31.012931)},
        {type = "stashe", coords = vec3(46.001694, 6510.882324, 31.012912)},
        {type = "cloakroom", coords = vec3(50.864876, 6510.680176, 31.012912)},
    },
    ["hayes"] = {
        {type = "boss", coords = vec3(-352.3076, -131.5815, 38.2361)},
        {type = "stashe", coords = vec3(-351.4968, -128.4258, 42.1305)},
    },
    ["paletoauto"] = {
        {type = "boss", coords = vec3(-232.7843, 6230.6128, 30.9935)},
        {type = "stashe", coords = vec3(-230.1243, 6221.3945, 30.9270)},
    },
    ["pdm"] = {
        {type = "boss", coords = vec3(-26.8630, -1107.7042, 26.2693)},
        {type = "stashe", coords = vec3(-24.3365, -1102.6884, 26.2689)},
    },
    ["police"] = {
        {type = "boss", coords = vec3(-1109.726807, -827.838135, 33.374593)},
        {type = "stashe", coords = vec3(-1139.235718, -825.964417, 3.971974)},
        {type = "armory", coords = vec3(-1132.607422, -816.919800, 3.970651)},
    },
    ["sheriff"] = {
        {type = "boss", coords = vec3(2782.2566, 4745.7739, 47.6273)},
        {type = "stashe", coords = vec3(2814.5781, 4724.8374, 47.6273)},
        {type = "armory", coords = vec3(2809.9338, 4722.3530, 47.6229)},
    },
    ["immo"] = {
        {type = "boss", coords = vec3(-714.6487, 261.0936, 83.1378)},
        {type = "stashe", coords = vec3(-716.3448, 266.3478, 83.1009)},
    },
    ["ems"] = {
        {type = "boss", coords = vec3(-665.056885, 349.024811, 82.183633)},
        {type = "boss", coords = vec3(7468.961426, 397.055939, 60.942716)},
        {type = "stashe", coords = vec3(-666.564331, 334.525787, 82.183618)},
        {type = "stashe", coords = vec3(-258.5989, 6325.7559, 31.4121)},
        {type = "stashe", coords = vec3(7482.754883, 385.585388, 60.931245)},
        {type = "cloakroom", coords = vec3(-663.953674, 329.479431, 82.183618)},
        {type = "cloakroom", coords = vec3(7486.860352, 391.957916, 60.926847)},
        {type = "pharmacy", coords = vec3(-659.919800, 334.864868, 82.183618)},
        {type = "pharmacy", coords = vec3(7478.557129, 406.548767, 56.915830)},
    },
    ["studio"] = {
        {type = "boss", coords = vec3(486.9562, -83.5062, 57.1850)},
        {type = "stashe", coords = vec3(499.4329, -55.1462, 57.1551)},
    },
    ["taxi"] = {
        {type = "boss", coords = vec3(-1248.8390, -282.2838, 42.8040)},
        {type = "stashe", coords = vec3(-1254.7390, -277.2946, 37.8460)},
        {type = "cloakroom", coords = vec3(-1262.6641, -273.3965, 37.7898)},
    },
    ["weazle"] = {
        {type = "boss", coords = vec3(-583.3703, -928.5589, 27.1569)},
        {type = "stashe", coords = vec3(-578.1998, -924.0309, 22.8554)},
    },
    ["burgershot"] = {
        {type = "boss", coords = vec3(-823.116516, -793.184143, 21.155663)},
    },
}
local currentMarkers = {}

local function markerSociety(data)
    DrawMarker(6, data.coords.x, data.coords.y, data.coords.z, nil, nil, nil, -90, nil, nil, 1.5, 1.5, 1.5, 255, 117, 31, 225, false, false)
    if data.currentDistance < 3.0 then
        if data.type == "boss" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~menu patron")
            if IsControlJustPressed(1, 38) then
                TriggerEvent('esx_society:openBosstozMenu', data.playerJob, function(data, menu) end)
            end
        elseif data.type == "stashe" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~coffre")
            if IsControlJustPressed(1, 38) then
                TriggerEvent("coffres:openCoffre", data.playerJob)
            end
        elseif data.type == "cloakroom" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~vestiaire")
            if IsControlJustPressed(1, 38) then
                TriggerEvent("snl_clothesshop:openVestiaire")
            end
        elseif data.type == "armory" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder à ~o~l'armurerie")
            if IsControlJustPressed(1, 38) then
                openMenuArmory(data.playerJob)
            end
        elseif data.type == "pharmacy" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder à la ~o~pharmacie")
            if IsControlJustPressed(1, 38) then
                openMenuPharmacy()
            end
        elseif data.type == "buyVehicle" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~rachat d'occasion")
            if IsControlJustPressed(1, 38) then
                openMenuBuyVehicle()
            end
        elseif data.type == "sellVehicle" then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour accéder au ~o~stock d'occasion")
            if IsControlJustPressed(1, 38) then
                openMenuStockOccas()
            end
        end
    end
end

local function initMarkerSociety(playerJob)
    for key, point in pairs(currentMarkers) do
        point:remove()
        currentMarkers[key] = nil
    end

    if dataSociety[playerJob] then
        for _, v in ipairs(dataSociety[playerJob]) do
            local point = lib.points.new({
                coords = v.coords,
                distance = 10,
                nearby = function(self)
                    markerSociety({
                        coords = self.coords,
                        currentDistance = self.currentDistance,
                        playerJob = playerJob,
                        type = v.type
                    })
                end
            })

            currentMarkers[v.coords] = point
        end
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    playerJob = xPlayer.job.name
    initMarkerSociety(playerJob)
    initGarageSociety(playerJob)
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
    ESX.PlayerData.job = job
    inService = false
    playerJob = job.name
    initMarkerSociety(playerJob)
    initGarageSociety(playerJob)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    inService = false
    playerJob = job.name
    initMarkerSociety(playerJob)
    initGarageSociety(playerJob)
end)

exports("inService", function()
    return inService
end)

exports("setInService", function(state)
    inService = state and true or false
    return inService
end)
