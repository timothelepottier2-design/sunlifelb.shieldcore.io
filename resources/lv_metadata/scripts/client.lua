local Cfg = {}

Cfg.sphereRadius = 10.0
Cfg.speed        = 20.0
Cfg.fadeDuration = 750

Cfg.locations = {}

-- Tunnel 1
Cfg.locations.lv1_01 = vector4(8008.106, -2329.852, 22.782, 26.484)
Cfg.locations.lv1_02 = vector4(8052.717, -2360.523, 22.229, 30.89)

-- Tunnel 2 LV
Cfg.locations.lv2_01 = vector4(5218.140, -722.600, 191.140, 349.356)
Cfg.locations.lv2_02 = vector4(5241.786, -734.344, 191.078, 351.518)

-- LS
Cfg.locations.ls_01 = vector4(1350.505, -1411.320, 32.865, 113.701)
Cfg.locations.ls_02 = vector4(1361.191, -1378.903, 32.635, 118.277)

Cfg.links = {}

Cfg.links['lv1_01'] = 'ls_02'
Cfg.links['lv1_02'] = 'ls_02'

Cfg.links['ls_01']  = 'lv1_02'
Cfg.links['ls_02']  = 'lv1_02'

Cfg.links['lv2_01'] = 'ls_02'
Cfg.links['lv2_02'] = 'ls_02'

local teleportLock = nil

local teleport = function(fromName, targetName)

	--print('TELEPORT', fromName, targetName)

  local target     = Cfg.locations[targetName]
  local coords     = vector3(target.x, target.y, target.z)
  local heading    = target.w
  local headingRad = heading * math.pi / 180
  local ped        = PlayerPedId()

	DoScreenFadeOut(Cfg.fadeDuration)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	while not IsScreenFadedOut() do
		Wait(0)
	end

	SetHdArea(coords.x, coords.y, coords.z, 50.0)

	local veh = nil

	if IsPedInAnyVehicle(ped) then
		
		veh = GetVehiclePedIsIn(ped, false)

		-- teleport only if is driver
		if GetPedInVehicleSeat(veh, -1) == ped then
			SetEntityCoordsNoOffset(veh, coords.x, coords.y, coords.z, true, false, false)
			SetEntityHeading(veh, heading)
			Wait(50)
			SetVehicleEngineOn(veh, true, true, false)
			SetEntityVelocity(veh, math.sin(360 * math.pi / 180 - headingRad) * Cfg.speed, math.cos(headingRad) * Cfg.speed, 0.0)
		end

	else
		SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
		SetEntityHeading(ped, heading)
	end

	SetGameplayCamRelativeHeading(0.0)
	DoScreenFadeIn(Cfg.fadeDuration)

	ClearHdArea()

	if veh ~= nil then
		SetEntityVelocity(veh, math.sin(360 * math.pi / 180 - headingRad) * Cfg.speed, math.cos(headingRad) * Cfg.speed, 0.0)
	end

end

CreateThread(function()
  while true do

		while (teleportLock ~= nil) and #(teleportLock - GetEntityCoords(PlayerPedId())) <= Cfg.sphereRadius * 3 do
			Wait(100)
		end

		teleportLock = nil

    local coords      = GetEntityCoords(PlayerPedId())
		local closest     = nil
		local closestDist = math.huge

    for k, v in pairs(Cfg.locations) do
      
			local lcoords = vector3(v.x, v.y, v.z)
			local dist    = #(lcoords - coords)

      if (dist < Cfg.sphereRadius) and (dist < closestDist) then
				closest      = k
				closestDist  = dist
      end

    end

		if (closest ~= nil) then
			local v = Cfg.locations[Cfg.links[closest]]
			teleportLock = vector3(v.x, v.y, v.z)
			teleport(closest, Cfg.links[closest])
		end

		Wait(100)

  end
end)
