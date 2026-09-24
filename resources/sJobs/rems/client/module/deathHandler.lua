local debug = false
Citizen.CreateThread(function()
	local attente = 10
	while true do
		Wait(attente)
		if not IsDead then
			attente = 500
			local pPed = PlayerPedId()
			if IsPedDeadOrDying(pPed, 1) and not exports.sunlife_ui:IsInGunFightZone() then
				if not debug then
					IsDead = true
					OnPlayerDeath()
					DebugEMSRespawn()
				else
					TriggerEvent("rems:rItems")
					AfterDeath()
				end
			end
		else
			attente = 1500
		end
	end
end)

function DebugEMSRespawn()
	local pPed = PlayerPedId()
	local pCoords = vector3(GetEntityCoords(pPed).x, GetEntityCoords(pPed).y, GetEntityCoords(pPed).z-1.0)
	SetEntityCoords(pPed, pCoords, 0.0, 0.0, 0.0, 0)
	Citizen.CreateThread(function()
		while IsDead do
			SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
			Wait(1)
		end
	end)
end

DecorRegister("CivilProps", 3)
function SpawnSacDead()
	SpawnObject("xm_prop_body_bag", GetEntityCoords(PlayerPedId()), function(obj)
        SetEntityCoords(obj, GetEntityCoords(PlayerPedId(), 0.0, 0.0, 0.0, 0))
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
		PlaceObjectOnGroundProperly(obj)
		DecorSetInt(obj, "CivilProps", 1)
        Wait(1)
    end)
end

function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		print(('^2[NETDIAG][OBJET]^7 %s deathHandler.lua:57 CreateObject NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end

function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end
