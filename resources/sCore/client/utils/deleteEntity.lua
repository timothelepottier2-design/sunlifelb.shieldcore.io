function forceDeleteEntity(entity)
	if DoesEntityExist(entity) then
		local gameTime = GetGameTimer()

		while DoesEntityExist(entity) and not NetworkHasControlOfEntity(entity) and (GetGameTimer() - gameTime) < 1000 do
			NetworkRequestControlOfEntity(entity)
			Citizen.Wait(10)
		end

		if DoesEntityExist(entity) then
			DetachEntity(entity, false, false)
			SetEntityAsMissionEntity(entity, false, false)
			SetEntityCollision(entity, false, false)
			SetEntityAlpha(entity, 0, true)
			SetEntityAsNoLongerNeeded(entity)

			DeleteEntity(entity)

			gameTime = GetGameTimer()

			while DoesEntityExist(entity) and ((GetGameTimer() - gameTime) < 2000) do
				Citizen.Wait(10)
			end

			if DoesEntityExist(entity) then
				SetEntityCoords(entity, 10000.0, -1000.0, 10000.0, false, false, false, false)
			end
		end
	end
end
