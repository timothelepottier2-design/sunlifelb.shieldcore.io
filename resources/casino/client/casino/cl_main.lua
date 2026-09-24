Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local casinoposition = {
    vector3(927.54, 16.96, 80.99),
    vector3(6993.994629, 264.080414, 57.849304)
}

local roueposition = {
    vector3(952.67, 66.6, 82.05)
}

CASINO = {
    ["myJetons"] = 0,
    ["menuOpenned"] = false,
    ["nearThing"] = false,
    ["playing"] = false,
}

RegisterNetEvent("casino:updateJetons")
AddEventHandler("casino:updateJetons", function(jetons)
    CASINO["myJetons"] = jetons
end)

Citizen.CreateThread(function()
	for k,v in pairs(casinoposition) do
		local casinoposition = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (casinoposition, 680)
		SetBlipDisplay(casinoposition, 4)
		SetBlipScale(casinoposition, 0.8)
		SetBlipColour (casinoposition, 1)
		SetBlipAsShortRange(casinoposition, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Diamond Casino")
		EndTextCommandSetBlipName(casinoposition)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(roueposition) do
		local roueposition = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (roueposition, 681)
		SetBlipDisplay(roueposition, 4)
		SetBlipScale(roueposition, 0.8)
		SetBlipColour (roueposition, 1)
		SetBlipAsShortRange(roueposition, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Roue de la Fortune")
		EndTextCommandSetBlipName(roueposition)
	end
end)