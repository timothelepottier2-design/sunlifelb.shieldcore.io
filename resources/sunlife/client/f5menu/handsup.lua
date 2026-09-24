Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local handsup = false
    RegisterKeyMapping(GetCurrentResourceName().."_handsup", "Lever les mains en l'air", 'keyboard', '')
    RegisterCommand(GetCurrentResourceName().."_handsup", function()
        if exports.sCore:UsingGilet() then return end
        if exports.sJobs:isUsingEMSItem() then return end
        if not IsPedArmed(PlayerPedId(), 7) then
            if not handsup then
                TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(PlayerPedId())
            end
        end
    end, false)
end)
