PRIME = {}
PRIME.Open = false
PRIME.MyVehicle = {}
PRIME.Type = 'voiture'
PRIME.MenuSelected = 'concessionnaires'
PRIME.SpawnInVehicle = true
local index = 1
local pointDeSpawn = {}
local maxVec = 80

RegisterNuiCallback('garage:categories', function(data, cb)
    if data then
        if data.value == "concessionnaires" then
            PRIME.LoadConcessVehicle()
        elseif data.value == "boutique" then
            PRIME.LoadBoutiqueVehicle()
        elseif data.value == "favorites" then
            PRIME.LoadVehicleFav()
        end
        PRIME.MenuSelected = data.value
    end
    cb('ok')
end)

function PRIME.RefreshVehicleGarage()
    if PRIME.Type == 'voiture' then
        ESX.TriggerServerCallback("zGarage:fetchPlayerVehicles", function(fetchedVehicles)
            PRIME.MyVehicle = fetchedVehicles or {}
            if PRIME.MenuSelected == "favorites" then
                PRIME.LoadVehicleFav()
            elseif PRIME.MenuSelected == "boutique" then
                PRIME.LoadBoutiqueVehicle()
            elseif PRIME.MenuSelected == "concessionnaires" then
                PRIME.LoadConcessVehicle()
            end
        end)
    end
end

function PRIME.LoadVehicleFav()
    local favPlatesJson = GetResourceKvpString("fav_plates")

    if PRIME.Type ~= "voiture" then
        favPlatesJson = GetResourceKvpString("fav_plates_others")
    end

    if favPlatesJson then
        MYFAV = json.decode(favPlatesJson)
    else
        MYFAV = {}
    end

    PRIME.MenuSelected = "favorites"
end
