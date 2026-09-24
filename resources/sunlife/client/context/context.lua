RegisterNetEvent("cn5:PLZrepairVehicle")
AddEventHandler("cn5:PLZrepairVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) do
        Wait(1)
    end
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
end)

RegisterNetEvent("cn5:PLZdestroyVehicle")
AddEventHandler("cn5:PLZdestroyVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(vehicle))
end)

local maxDistance = 2.5

local modelsSoda = {
    'prop_vend_soda_01',
    'prop_vend_soda_02',
    'prop_vend_fridge01',
    'prop_food_bs_soda_01',
    'prop_food_cb_soda_01'
}

local optionsSoda = {
    {
        name = 'shark:sodaec',
        onSelect = function()
            lib.progressBar({
                duration = 4000,
                label = 'Achat du soda en cours...',
                useWhileDead = false,
                canCancel = true,
				distance = 2,
                disable = {
                    move = true,
                },
                anim = { dict = 'mini@sprunk', clip = 'plyr_buy_drink_pt1' },
            })
			TriggerServerEvent("context:buyStuff", 'coca')
        end,
        icon = 'fa-solid fa-jar',
        label = 'Acheter un eCola'
    },
}

exports.ox_target:addModel(modelsSoda, optionsSoda)

local modelsCoffee = {
    'ex_mp_h_acc_coffeemachine_01',
    'apa_mp_h_acc_coffeemachine_01',
    'hei_heist_kit_coffeemachine_01',
    'prop_coffee_mac_01',
    'prop_coffee_mac_02',
    'p_ld_coffee_vend_01',
    'prop_vend_coffe_01'
}

local optionsCoffee = {
    {
        name = 'coffee:get',
        onSelect = function()
            lib.progressBar({
                duration = 4000,
                label = 'Achat du café en cours...',
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = { dict = 'amb@prop_human_atm@male@idle_a', clip = 'idle_a' },
            })
			TriggerServerEvent("context:buyStuff", 'coffee')
        end,
        icon = 'fa-solid fa-jar',
        label = 'Acheter un café'
    },
}

exports.ox_target:addModel(modelsCoffee, optionsCoffee)

local modelsWater = {
    'prop_vend_water_01',
    'prop_watercooler_dark',
    'prop_vend_fridge01',
    'prop_watercooler'
}

local optionsWater = {
    {
        name = 'buy:water',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Remplissage de l'eau",
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'amb@prop_human_atm@male@idle_a',
                    clip = 'idle_a'
                }
            })
			TriggerServerEvent("context:buyStuff", 'water')
        end,
        icon = 'fa-solid fa-bottle-water',
        label = "Acheter de l'eau"
    }
}

exports.ox_target:addModel(modelsWater, optionsWater)

local modelsSnack = {
    'prop_vend_snak_01',
    'prop_vend_snak_01_tu'
}

local optionsSnack = {
    {
        name = 'buy:chocolat',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Achat d'une barre de chocolat",
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = { dict = 'mini@sprunk', clip = 'plyr_buy_drink_pt1' },
            })
			TriggerServerEvent("context:buyStuff", 'snack')
        end,
        icon = 'fa-solid fa-cookie',
        label = "Acheter un snack"
    }
}

exports.ox_target:addModel(modelsSnack, optionsSnack)

local modelFernocot = {
    'fernocot'
}

local optionsEMSWOW = {
    {
        name = 'fernocotEMSPush',
        onSelect = function()
            ExecuteCommand("pushstr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Pousser le brancard'
    },
    -- "Supprimer le brancard" retire d'ici : doublon de "Ranger le brancard"
    -- (sCore/client/target/model.lua) qui, lui, passe par le serveur et
    -- verifie le job EMS.
    {
        name = 'fernocotEMSGetInto',
        onSelect = function()
            ExecuteCommand("getintostr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Se coucher'
    }
}

exports.ox_target:addModel(modelFernocot, optionsEMSWOW)

local modelAmbulance = {
    'sandbulance'
}

local optionsAmbulance = {
    {
        name = 'ambulanceInsertBran',
        onSelect = function()
            ExecuteCommand("togglestr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Insérer le brancard'
    },
	{
        name = 'ambulanceOpenDoors',
        onSelect = function()
            ExecuteCommand("openbaydoors")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Ouvrir les portes'
    }
}

exports.ox_target:addModel(modelAmbulance, optionsAmbulance)

local showers = {
    {-767.56, 327.43, 169.70},
    {254.29, -1000.13, -99.93},
    {346.89, -995.13, -100.11},
    {-38.57, -581.95, 77.87},
    {-32.47, -587.41, 82.95},
    {-1453.75, -555.47, 71.88},
    {-1461.38, -534.96, 49.77},
    {-898.05, -368.57, 112.11},
    {-591.71, 49.14, 96.04},
    {-796.38, 333.36, 209.93},
    {-168.89, 489.73, 132.87},
    {335.91, 430.56, 145.6},
    {373.9, 413.97, 141.13},
    {-673.75, 588.4, 140.6},
    {-765.49, 612.72, 139.36},
    {-856.46, 682.36, 148.08},
    {120.83, 551.01, 179.53},
    {-1287.27, 440.41, 93.12}
}

local isShowering = false

local function startShower()
    if isShowering then return end
    isShowering = true

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

	exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
		if skin.sex == 0 then
			local clothesSkin = {
			['bags_1'] = 0, ['bags_2'] = 0,
			['tshirt_1'] = 15, ['tshirt_2'] = 15,
			['torso_1'] = 15, ['torso_2'] = 0,
			['arms'] = 15,
			['pants_1'] = 61, ['pants_2'] = 6,
			['shoes_1'] = 34, ['shoes_2'] = 0,
			['mask_1'] = 0, ['mask_2'] = 0,
			['bproof_1'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			["decals_1"] = -1, ["decals_2"] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['glasses_1'] = 0, ['glasses_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
			local clothesSkinfemale = {
				['bags_1'] = 0, ['bags_2'] = 0,
				['tshirt_1'] = 15, ['tshirt_2'] = 15,
				['torso_1'] = 15, ['torso_2'] = 0,
				['arms'] = 15,
				['pants_1'] = 61, ['pants_2'] = 6,
				['shoes_1'] = 34, ['shoes_2'] = 0,
				['mask_1'] = 0, ['mask_2'] = 0,
				['bproof_1'] = 0,
				['helmet_1'] = -1, ['helmet_2'] = 0,
				["decals_1"] = -1, ["decals_2"] = 0,
				['chain_1'] = 0, ['chain_2'] = 0,
				['glasses_1'] = 0, ['glasses_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkinfemale)
		end
	end)

    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_STAND_IMPATIENT", 0, true)

    if not HasNamedPtfxAssetLoaded("core") then
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(10)
        end
    end

    UseParticleFxAssetNextCall("core")
    local particles = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z + 1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    local timer = 8
    while timer > 0 do
        Wait(1000)
        timer = timer - 1
    end

    FreezeEntityPosition(playerPed, false)
    ClearPedTasksImmediately(playerPed)
    StopParticleFxLooped(particles, 0)

    exports['esx_skin']:GetCachedSkin(function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	lib.notify({
		title = 'Douche',
		description = "Vous êtes tout propre !",
		type = 'success',
		position = 'top',
		duration = 5000,
	})
    isShowering = false
end

for _, coords in ipairs(showers) do
    exports.ox_target:addSphereZone({
        coords = vec3(coords[1], coords[2], coords[3]),
        radius = 2,
        debug = false,
        options = {
            {
                label = "Prendre une douche",
                icon = "fa-solid fa-shower",
				distance = 2,
                onSelect = startShower
            }
        }
    })
end

local jerryCanItem = 'jerrycan'
local fuelPerUse = 20
local refillTime = 10000

local function refillVehicle(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return end

    local currentFuel = GetVehicleFuelLevel(vehicle)
    if currentFuel >= 100 then
        ESX.ShowNotification("Le réservoir est déjà plein.")
        return
    end

	ESX.TriggerServerCallback("fuel:getItem", function(isGood)
		if isGood then
			lib.progressCircle({
				duration = refillTime,
				useWhileDead = false,
				canCancel = true,
				disable = {
					move = true,
					car = true,
					combat = true,
				},
				anim = {
					dict = 'weapon@w_sp_jerrycan',
					clip = 'fire',
				},
                prop = {
                    model = 'prop_jerrycan_01a',
                    bone = 57005,
                    pos = { x = 0.05, y = 0.0, z = -0.05 },
                    rot = { x = 0, y = 180, z = 120.0 }
                }
			})

			local newFuel = math.min(currentFuel + fuelPerUse, 100)
			SetVehicleFuelLevel(vehicle, 100.0)
			DecorSetFloat(vehicle, "_ANDY_FUEL_DECORE_", 100.0)

			lib.notify({ type = 'success', description = 'Vous avez rempli le réservoir.' })
		else
			lib.notify({ type = 'error', description = "Vous n'avez pas de jerrycan sur vous !" })
			return
		end
	end)
end

exports.ox_target:addGlobalVehicle({
    label = 'Remplir avec un jerrycan',
    icon = 'fa-solid fa-gas-pump',
    distance = 2.5,
    canInteract = function(entity, distance, coords, name, bone)
        local vehicleClass = GetVehicleClass(entity)
        if vehicleClass == 13 then
            return false
        end

        return true
    end,
    onSelect = function(data)
        refillVehicle(data.entity)
    end
})
