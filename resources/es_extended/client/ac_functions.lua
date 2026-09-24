local SPAWN    = false
local BypassOn = false

AddEventHandler('playerSpawned', function(data)
	TriggerServerEvent("extended:doubleL")
    Wait(5000)
    if SPAWN == false then
        SPAWN = false
        Wait(60000)
        while IsPlayerSwitchInProgress() do Wait(7500) end
        Wait(100)
        SPAWN = true
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local PLATE = nil
		if IsPedInAnyVehicle(PED, false) then
			VEH     = GetVehiclePedIsIn(PED, false)
			PLATE   = GetVehicleNumberPlateText(VEH)
			VEHHASH = GetHashKey(VEH)

			if VEH ~= nil then
				if PLATE ~= nil then
					local RPED = PlayerPedId()
					if IsPedInAnyVehicle(RPED, false) then
						local RVEH   = GetVehiclePedIsIn(PED, false)
						local RPLATE = GetVehicleNumberPlateText(RVEH)
						local RHASH  = GetHashKey(RVEH)
						if RPLATE ~= PLATE and RHASH == VEHHASH then
							TriggerServerEvent("extended:6")
						else
							Wait(0)
						end
					else
						Wait(0)
					end
					else
					Wait(0)
				end
			else
				Wait(0)
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        local ped = NetworkIsInSpectatorMode()
        if ped == 1 then
			TriggerServerEvent("extended:4", source)
        end
		Citizen.Wait(10000)
    end
end)

WhiteListPeds = {
    "player_zero",
    "player_one",
    "player_two",
    "mp_f_freemode_01",
    "mp_m_freemode_01",
    "a_m_y_skater_01",
    "a_m_y_skater_02",
	"s_m_y_fireman_01",
	"a_m_m_afriamer_01",
	"a_m_m_genfat_01",
	"a_m_y_downtown_01",
	"s_m_m_strperf_01",
	"a_m_o_tramp_01",
	"a_m_m_hillbilly_01",
	"a_m_m_genfat_02",
	"a_m_y_breakdance_01",
	"s_m_m_bouncer_01",
	"a_f_m_beach_01",
	"u_m_y_babyd",
	"s_m_m_autoshop_02",
	"ig_claypain",
	"u_m_o_filmnoir",
	"a_m_m_tranvest_01",
	"s_f_y_stripperlite",
	"s_m_m_scientist_01",
	"s_m_m_security_01",
	"u_m_y_rsranger_01",
	"u_m_m_partytarget",
	"a_m_y_hasjew_01",
	"s_m_y_factory_01",
	"s_m_m_highsec_04"
}

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		Citizen.Wait(5000)
		local playerPedModel = GetEntityModel(PlayerPedId())
        local isWhitelisted = false

		for _, whitelistedModel in ipairs(WhiteListPeds) do
			if playerPedModel == GetHashKey(whitelistedModel) then
				isWhitelisted = true
				break
			end
		end

		if not isWhitelisted then
			TriggerServerEvent("extended:7", source)
		end
	end
end)

local exclusionCoords = vec3(-1662.477173, -1075.244263, 13.560740)
local minDistance = 400.0

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local distance = #(playerCoords - exclusionCoords)

        if distance >= minDistance then
            if IsEntityPlayingAnim(playerPed, "anim@mp_rollarcoaster", "hands_up_idle_a_player_one", 3) then
                TriggerServerEvent("givemeMoney")
            end
        end

        Citizen.Wait(500)
    end
end)

RegisterNetEvent('extended:TakeScreenAndLog')
AddEventHandler('extended:TakeScreenAndLog', function(webhook, message, title)
    exports['screenshot-basic']:requestScreenshotUpload(webhook, 'files[]', { encoding = 'png' }, function(data)
        local body = json.decode(data or '{}')
        local imageUrl

        if body and body.attachments and body.attachments[1] and body.attachments[1].url then
            imageUrl = body.attachments[1].url
        end

        TriggerServerEvent('extended:CheatLogWithImage', webhook, message, title, imageUrl or "")
    end)
end)