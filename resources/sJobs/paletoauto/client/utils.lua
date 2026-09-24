local NumberCharset = {}
local Charset = {}
local LastVehicles            = {}

local GeneratePlate
local GeneratePlateBoutique
local IsPlateTaken
local GetRandomNumber
local GetRandomLetter
local DeleteShopInsideVehicles
local DrawText3Ds

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

GetRandomNumber = function(length)
	local result = ''
	for i = 1, length do
		result = result .. NumberCharset[math.random(1, #NumberCharset)]
	end
	return result
end

GetRandomLetter = function(length)
	local result = ''
	for i = 1, length do
		result = result .. Charset[math.random(1, #Charset)]
	end
	return result
end

GeneratePlate = function()
	local done = false
	local result = nil
	ESX.TriggerServerCallback('paletoauto:generatePlate', function(plate)
		result = plate
		done = true
	end, "normal")
	while not done do
		Citizen.Wait(50)
	end
	return result or string.upper(GetRandomNumber(2) .. ' ' .. GetRandomLetter(3))
end

GeneratePlateBoutique = function()
	local done = false
	local result = nil
	ESX.TriggerServerCallback('paletoauto:generatePlate', function(plate)
		result = plate
		done = true
	end, "boutique")
	while not done do
		Citizen.Wait(50)
	end
	return result or string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
end

IsPlateTaken = function(plate)
	local done = false
	local result = false

	ESX.TriggerServerCallback('paletoauto:isPlateTaken', function(isPlateTaken)
		result = isPlateTaken
		done = true
	end, plate)

	while not done do
		Citizen.Wait(100)
	end

	return result
end

DeleteShopInsideVehicles = function()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

DrawText3Ds = function(x, y, z, text, r, g, b)
    r = r or 255
    g = g or 255
    b = b or 255
    local _, _x, _y = World3dToScreen2d(x,y,z)
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end
