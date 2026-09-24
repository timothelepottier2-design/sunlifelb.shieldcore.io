Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
	end
end)

local open, canAnnounce, openArmory, openGestion, openWeaponAmmu, cacheWeapon, amount, openPharmacy, openGrottiBuy, openGrottiStock, previewGrotti = false, true, false, false, false, {}, 1, false, false, false, nil
inService = false
cacheWeapon.value = nil
cacheWeapon.price = nil
local renfortOptions <const> = {
    {
        label = "Petite demande",
        raison = "petite"
    },
    {
        label = "Demande importante",
        raison = "importante"
    },
    {
        label = "Toutes les unités sont demandées !",
        raison = "omgad"
    }
}
local statusOptions <const> = {
    {
        label = "Pause de service",
        value = "pause"
    },
    {
        label = "En attente de dispatch",
        value = "standby"
    },
    {
        label = "Control routier en cours",
        value = "control"
    },
    {
        label = "Délit de fuite en cours",
        value = "refus"
    },
    {
        label = "Ajout de carburant",
        value = "carburant"
    },
    {
        label = "Accident de la circulation",
        value = "accident"
    }
}
local k9Appearance <const> = {
    {
        label = "Teinte du chien",
        desc = "Appuyez pour modifier",
        indexKey = "currentColor",
        component = 0
    },
    {
        label = "Couleur gilet",
        desc = "Appuyez pour modifier",
        indexKey = "currentHands",
        component = 3
    },
    {
        label = "Insigne",
        desc = "Appuyez pour modifier",
        indexKey = "currentSign",
        component = 8
    }
}
local k9Toggles = {
    {
        stateKey = "follow",
        trueLabel = "Ordonner de suivre",
        falseLabel = "Ordonner de ne plus suivre",
        func = function()
            followDog()
        end
    },
    {
        stateKey = "stand",
        trueLabel = "Ordonner de se lever",
        falseLabel = "Ordonner de s'asseoir",
        func = function()
            sitDog()
        end
    },
    {
        stateKey = "inCar",
        trueLabel = "Ordonner de descendre de la voiture",
        falseLabel = "Ordonner de monter dans la voiture",
        func = function()
            carDog()
        end
    }
}
local dataArmory <const> = {

    ["usss"] = {
        {grade = {"*"}},
        {name = "WEAPON_COMBATPISTOL", label = "Pistolet de combat", price = 300000},
        {name = "WEAPON_SMG", label = "SMG", price = 450000},
        {name = "WEAPON_CARBINERIFLE", label = "Carabine", price = 900000},
    },
    ["bobcat"] = {
        {grade = {"*"}},
        {name = "WEAPON_NIGHTSTICK", label = "Matraque", price = 25000},
        {name = "WEAPON_PISTOL", label = "Pistolet", price = 250000},
        {name = "WEAPON_PUMPSHOTGUN", label = "Fusil à pompe", price = 400000},
        {name = "WEAPON_SMG", label = "SMG", price = 450000},
        {name = "WEAPON_STUNGUN", label = "Taser", price = 70000},
    },
    ["doj"] = {
        {grade = {"*"}},
        {name = "WEAPON_NIGHTSTICK", label = "Matraque", price = 25000},
        {name = "WEAPON_PISTOL", label = "Pistolet", price = 250000},
        {name = "WEAPON_PUMPSHOTGUN", label = "Fusil à pompe", price = 400000},
        {name = "WEAPON_STUNGUN", label = "Taser", price = 70000},
        {name = "menotte", label = "Menotte", price = 25000},
    },
    ["lsfd"] = {
        {grade = {"*"}},
        {name = "WEAPON_FIREEXTINGUISHER", label = "Extincteur", price = 100000},
        {name = "WEAPON_HOSE", label = "Lance à incendie", price = 100000},
    },
    ["police"] = {
        {grade = {"rookie", "officier1", "officier2", "officier3", "slo", "sergent1", "sergent2", "lieutenant", "lieutenant2", "captain1", "captain2", "commander", "asschief", "boss"}},
        {name = "WEAPON_BULLET2", label = "Gilet Pare-balles lourd", price = 0},
        {name = "WEAPON_NIGHTSTICK", label = "Matraque", price = 0},
        {name = "WEAPON_STUNGUN", label = "Tazer", price = 0},
        {name = "WEAPON_COMBATPISTOL", label = "Pistolet de combat", price = 0},
        {name = "WEAPON_SMG", label = "Mpy5", price = 0},
        {name = "WEAPON_CARBINERIFLE", label = "Carabine d'assault", price = 0},
        {name = "WEAPON_PUMPSHOTGUN", label = "Fusil à pompe", price = 0},
        {name = "WEAPON_HK416B", label = "HK416B", price = 0},
        {name = "WEAPON_LESSLETHAL", label = "Beanbag", price = 0},
        {name = "WEAPON_SHIELD", label = "Bouclier", price = 0},
        {name = "WEAPON_SHIELD2", label = "Bouclier balistique", price = 0},
        {name = "WEAPON_FLASHLIGHT", label = "Lampe de poche", price = 0},
        {name = "WEAPON_PEPPERSPRAY", label = "Spray au poivre", price = 0},
        {name = "WEAPON_ANTIDOTE", label = "Spray au poivre (ANTIDOTE)", price = 0},
        {name = "tablette", label = "Tablette MDT", price = 0},
        {name = "clipsmg", label = "Chargeur SMG", price = 0},
        {name = "clippistol", label = "Chargeur Pistol", price = 0},
        {name = "clipfusil", label = "Chargeur Fusil", price = 0},
        {name = "clippompe", label = "Chargeur Pompe", price = 0},
        {name = "cliprevolver", label = "Chargeur Revolver", price = 0},
        {name = "megaphone", label = "Mégaphone", price = 0},
        {name = "menotte", label = "Menotte", price = 0},
    },
    ["sheriff"] = {
        {grade = {"recrue", "sheriff1", "sheriff2", "sheriff3", "seniordeputy", "sergent", "lieutenant", "assistantsheriff", "undersheriff", "boss"}},
        {name = "WEAPON_BULLET2", label = "Gilet Pare-balles lourd", price = 0},
        {name = "WEAPON_NIGHTSTICK", label = "Matraque", price = 0},
        {name = "WEAPON_STUNGUN", label = "Tazer", price = 0},
        {name = "WEAPON_COMBATPISTOL", label = "Pistolet de combat", price = 0},
        {name = "WEAPON_SMG", label = "Mpy5", price = 0},
        {name = "WEAPON_CARBINERIFLE", label = "Carabine d'assault", price = 0},
        {name = "WEAPON_PUMPSHOTGUN", label = "Fusil à pompe", price = 0},
        {name = "WEAPON_HK416B", label = "HK416B", price = 0},
        {name = "WEAPON_LESSLETHAL", label = "Beanbag", price = 0},
        {name = "WEAPON_SHIELD", label = "Bouclier", price = 0},
        {name = "WEAPON_SHIELD2", label = "Bouclier balistique", price = 0},
        {name = "WEAPON_FLASHLIGHT", label = "Lampe de poche", price = 0},
        {name = "WEAPON_PEPPERSPRAY", label = "Spray au poivre", price = 0},
        {name = "WEAPON_ANTIDOTE", label = "Spray au poivre (ANTIDOTE)", price = 0},
        {name = "tablette", label = "Tablette MDT", price = 0},
        {name = "clipsmg", label = "Chargeur SMG", price = 0},
        {name = "clippistol", label = "Chargeur Pistol", price = 0},
        {name = "clipfusil", label = "Chargeur Fusil", price = 0},
        {name = "clippompe", label = "Chargeur Pompe", price = 0},
        {name = "cliprevolver", label = "Chargeur Revolver", price = 0},
        {name = "megaphone", label = "Mégaphone", price = 0},
        {name = "menotte", label = "Menotte", price = 0},
    }
}
local existantSocieties = {
    {name = "society_police", nameHash = 'LSPD', society = "police"},
    {name = "society_sheriff", nameHash = 'BCSO', society = "sheriff"},
    {name = "society_ems", nameHash = 'EMS', society = "ems"},
    {name = "society_pdm", nameHash = 'PDM', society = "pdm"},
    {name = "society_bennys", nameHash = 'Bennys', society = "bennys"},
    {name = "society_hayes", nameHash = 'Hayes', society = "hayes"},
    {name = "society_pcm", nameHash = 'PCM', society = "pcm"},
    {name = "society_bobcat", nameHash = 'Bobcat Security', society = "bobcat"},
    {name = "society_usss", nameHash = 'USSS', society = "usss"},
    {name = "society_ammu", nameHash = 'Armurerie', society = "ammu"},
    {name = "society_immo", nameHash = 'Dynasty8', society = "immo"},
    {name = "society_unicorn", nameHash = 'Unicorn', society = "unicorn"},
    {name = "society_mosley", nameHash = 'Mosley', society = "mosley"},
    {name = "society_taxi", nameHash = 'Taxi', society = "taxi"},
    {name = "society_fourriere", nameHash = 'Fourrière', society = "fourriere"},
    {name = "society_studio", nameHash = 'Sunny Records', society = "studio"},
    {name = "society_tabac", nameHash = 'Tabac', society = "tabac"},
    {name = "society_boulangerie", nameHash = 'Boulangerie', society = "boulangerie"},
    {name = "society_brasserie", nameHash = 'Brasserie', society = "brasseur"},
    {name = "society_vigneron", nameHash = 'Vigneron', society = "vigneron"},
    {name = "society_izakaya", nameHash = 'Izakaya', society = "izakaya"},
    {name = "society_pizzeria", nameHash = 'Pizza This', society = "pizzeria"},
    {name = "society_burgershot", nameHash = 'Burgershot', society = "burgershot"},
    {name = "society_bahamas", nameHash = 'Bahamas', society = "bahamas"},
    {name = "society_galaxy", nameHash = 'Galaxy', society = "galaxy"},
    {name = "society_tequilala", nameHash = 'Tequilala', society = "tequilala"},
    {name = "society_yellowjack", nameHash = 'Yellow Jack', society = "yellowjack"},
    {name = "society_weazle", nameHash = 'Weazle News', society = "weazle"},
    {name = "society_streettuners", nameHash = 'Streettuners', society = "streettuners"},
    {name = "society_harmony", nameHash = 'Harmony', society = "harmony"},
    {name = "society_uwu", nameHash = 'Uwu Coffee', society = "uwu"},
    {name = "society_ltdsud", nameHash = 'LTD', society = "ltdsud"},
    {name = "society_beachclub", nameHash = 'Beachclub', society = "beachclub"},
    {name = "society_grotti", nameHash = 'Grotti', society = "grotti"},
    {name = "society_paletoauto", nameHash = 'Paleto Automobiles', society = "paletoauto"},
    -- Manquaient dans la liste vue par le Gouvernement / DOJ.
    {name = "society_kebab", nameHash = 'Turko Kebab', society = "kebab"},
    {name = "society_lsfd", nameHash = 'LSFD', society = "lsfd"},
    {name = "society_doj", nameHash = 'DOJ', society = "doj"},
    {name = "society_gouv", nameHash = 'Gouvernement', society = "gouv"},
    {name = "society_blackwoods", nameHash = 'BlackWoods', society = "blackwoods"},
}

local ammuWeapons <const> = {
    {
        cat_name = "Armes de poing",
        value = "petit",
        weapons = {
            {name = "Couteau", hash = "WEAPON_KNIFE", prop = "w_me_knife_01", price = 30000},
			{name = "Batte", hash = "WEAPON_BAT", prop = "w_me_bat", price = 15000},
			{name = "Marteau", hash = "WEAPON_HAMMER", prop = "w_me_hammer", price = 20000},
			{name = "Pied de biche", hash = "WEAPON_CROWBAR", prop = "w_me_crowbar", price = 15000},
			{name = "Club de golf", hash = "WEAPON_GOLFCLUB", prop = "prop_golf_iron_01", price = 15000},
			{name = "Machette", hash = "WEAPON_MACHETE", prop = "prop_ld_w_me_machette", price = 35000},
			{name = "Poing américain", hash = "WEAPON_KNUCKLE", prop = "", price = 25000},
			{name = "Couteau pliant", hash = "WEAPON_SWITCHBLADE", prop = "", price = 40000},
			{name = "Dague", hash = "WEAPON_DAGGER", prop = "w_me_dagger", price = 40000},
			{name = "Bouteille", hash = "WEAPON_BOTTLE", prop = "w_me_bottle", price = 10000},
        },
    },
    {
        cat_name = "Armes",
        value = "moyen",
        weapons = {
            {name = "Pistolet 9mm", hash = "WEAPON_PISTOL", prop = "w_pi_pistol", price = 250000},
			{name = "Pistolet lourd", hash = "WEAPON_HEAVYPISTOL", prop = "w_pi_heavypistol", price = 300000},
			{name = "Pistolet cal50", hash = "WEAPON_PISTOL50", prop = "w_pi_pistol50", price = 350000},
			{name = "SMG MK2", hash = "WEAPON_SMG_MK2", prop = "w_pi_pistol50", price = 800000},
            {name = "Fusil Double Action", hash = "WEAPON_DOUBLEACTION", prop = "w_pi_pistol", price = 650000},
        },
    },
    {
        cat_name = "Accessoires",
        value = "acc",
        weapons = {
            {name = "Gilet pare-balles", hash = "WEAPON_BULLET", price = 30000},
            {name = "Gilet pare-balles lourd", hash = "WEAPON_BULLET2", price = 55000},
            {name = "Chargeur Pistolet", hash = "clippistol", price = 1500},
            {name = "Chargeur SMG", hash = "clipsmg", price = 1500},
            {name = "Chargeur Revolver", hash = "cliprevolver", price = 1500},
            {name = "Chargeur Fusil", hash = "clipfusil", price = 1500},
            {name = "Chargeur Pompe", hash = "clippompe", price = 1500},
            {name = "Grip", hash = "grip", price = 150},
            {name = "Silencieux", hash = "silencieux", price = 300},
            {name = "Flashlight", hash = "flashlight", price = 200},
            {name = "Jumelles", hash = "jumelles", price = 200},
            {name = "Skin digital MK2", hash = "digital", price = 40000},
            {name = "Skin Squelette MK2", hash = "skull", price = 40000},
            {name = "Skin Sessanta MK2", hash = "sessanta", price = 40000},
            {name = "Skin Perseus MK2", hash = "perseus", price = 40000},
            {name = "Skin Léopard MK2", hash = "leopard", price = 40000},
            {name = "Skin Patriotic", hash = "patriotic", price = 40000},
            {name = "Skin de luxe", hash = "yusuf", price = 25000},
        },
    },
}
local itemPharmacy <const> = {
    "medikit",
    "bandage",
    "donut",
    "eau"
}

Citizen.CreateThread(function()
    RMenu.Add('menu', 'general', RageUI.CreateMenu("SunLife", "Menu Entreprise", 1, 100))
    RMenu.Add('menu', 'renfort', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Renforts"))
    RMenu.Add('menu', 'status', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Status"))
    RMenu.Add('menu', 'k9', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Unité K9"))
    RMenu.Add('menu', 'bracelet', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Menu LSPD"))
    RMenu.Add('menu', 'bracelet_edit_police', RageUI.CreateSubMenu(RMenu:Get('menu', 'bracelet'), "SunLife", "Menu LSPD"))
    RMenu.Add('k9', 'k9Edit', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Unité K9"))
    RMenu.Add('k9', 'k9Search', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Unité K9"))

    RMenu:Get('menu', 'general'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'renfort'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'status'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('k9', 'k9Edit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('k9', 'k9Search'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'bracelet'):SetRectangleBanner(255, 117, 31, 225)
	RMenu:Get('menu', 'bracelet_edit_police'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'k9'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'general').EnableMouse = false
    RMenu:Get('menu', 'general').Closed = function()
        open = false
    end

    RMenu.Add('menu2', 'armory', RageUI.CreateMenu("SunLife", "Armurerie", 1, 100))
    RMenu:Get('menu2', 'armory'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu2', 'armory').EnableMouse = false
    RMenu:Get('menu2', 'armory').Closed = function()
        openArmory = false
    end

    RMenu.Add('gouv', 'gestion', RageUI.CreateMenu("SunLife", "Gouvernement", 1, 100))
    RMenu.Add('gouv', 'EmpList', RageUI.CreateSubMenu(RMenu:Get('gouv', 'gestion'), 'SunLife', 'Gouvernement'))
    RMenu:Get('gouv', 'gestion'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('gouv', 'EmpList'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('gouv', 'gestion').EnableMouse = false
    RMenu:Get('gouv', 'gestion').Closed = function()
        openGestion = false
    end

	RMenu.Add('ammu', 'WeaponSelection', RageUI.CreateMenu("SunLife", "AmmuNation", 1, 100))
    RMenu.Add('ammu', 'WeaponChoose', RageUI.CreateSubMenu(RMenu:Get('ammu', 'WeaponSelection'), "SunLife", "AmmuNation", 1, 100))
    RMenu:Get('ammu', 'WeaponSelection'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('ammu', 'WeaponChoose'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('ammu', 'WeaponSelection').EnableMouse = false
    RMenu:Get('ammu', 'WeaponSelection').Closed = function()
		openWeaponAmmu = false
    end
    for _, v in pairs(ammuWeapons) do
        RMenu.Add('ammu', v.value, RageUI.CreateSubMenu(RMenu:Get('ammu', 'WeaponSelection'), "SunLife", "AmmuNation", 1, 100))
        RMenu:Get('ammu', v.value):SetRectangleBanner(255, 117, 31, 225)
        RMenu:Get('ammu', v.value):SetSubtitle(v.cat_name)
        RMenu:Get('ammu', v.value).Closed = function()
        end
    end

    RMenu.Add('ambulance', 'pharmacy', RageUI.CreateMenu("SunLife", "Pharmacie", 1, 100))
    RMenu:Get('ambulance', 'pharmacy'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('ambulance', 'pharmacy').EnableMouse = false
    RMenu:Get('ambulance', 'pharmacy').Closed = function()
        openPharmacy = false
    end

    RMenu.Add('grotti', 'buyVehicle', RageUI.CreateMenu("SunLife", "Grotti Automobile", 1, 100))
    RMenu:Get('grotti', 'buyVehicle'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('grotti', 'buyVehicle').EnableMouse = false
    RMenu:Get('grotti', 'buyVehicle').Closed = function()
        openGrottiBuy = false
    end

    RMenu.Add('grotti', 'stockVehicle', RageUI.CreateMenu("SunLife", "Grotti Automobile", 1, 100))
    RMenu.Add('grotti', 'data_vehicle', RageUI.CreateMenu("SunLife", "Grotti Automobile", 1, 100))
    RMenu:Get('grotti', 'stockVehicle'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('grotti', 'data_vehicle'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('grotti', 'stockVehicle').EnableMouse = false
    RMenu:Get('grotti', 'stockVehicle').Closed = function()
        openGrottiStock = false
    end

    RMenu.Add('streettuners', 'craft', RageUI.CreateSubMenu(RMenu:Get('menu', 'general'), "SunLife", "Atelier de craft"))
    RMenu:Get('streettuners', 'craft'):SetRectangleBanner(255, 117, 31, 225)

    RMenu.Add('panic', 'main', RageUI.CreateMenu("SunLife", "Urgence — Panic", 1, 100))
    RMenu:Get('panic', 'main'):SetRectangleBanner(220, 25, 25, 225)
    RMenu:Get('panic', 'main').EnableMouse = false
    RMenu:Get('panic', 'main').Closed = function()
        openPanic = false
    end
end)

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function marquerJoueur()
    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance <= 4.0 then
        local pos = GetEntityCoords(GetPlayerPed(player))
        DrawMarker(2, pos.x, pos.y, pos.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, false, true, 2, false, nil, nil, false)
    end
end

local function buyOccasVehicle(targetPlayer, vehicle)
    local input = lib.inputDialog("Rachat de véhicule d'occasion", {
        {type = "number", label = "Prix de rachat", description = "Minimum 5000, maximum 150000000", min = 5000, max = 150000000, required = true},
        {type = "number", label = "Markup", description = "Entre 5 et 30", min = 5, max = 30, required = true}
    })
    if not input then
        ESX.ShowNotification("~r~Rachat annulé.")
        return
    end

    local price = tonumber(input[1])
    local markup = tonumber(input[2])
    if not price or price < 5000 or price > 150000000 then
        ESX.ShowNotification("~r~Le prix doit être compris entre 5 000$ et 150 000 000$")
        return
    end
    if not markup or markup < 5 or markup > 30 then
        ESX.ShowNotification("~r~Le markup doit être compris entre 5 et 30")
        return
    end

    local targetId = GetPlayerServerId(targetPlayer)
    local nameVehicle = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    ESX.ShowNotification("~g~Rachat en cours, patientez..")

    TriggerServerEvent("sJobs.buyOccasVehicle", vehicleProps, nameVehicle, targetId, price, markup)
end

local function spawnInShowroom(vehicleProps)
    for i, slot in ipairs(Config.ShowRoomGrotti) do
        if not slot.veh or not DoesEntityExist(slot.veh) then
            local model = type(vehicleProps.model) == "number" and vehicleProps.model or GetHashKey(vehicleProps.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local pos = slot.position
            TriggerServerEvent('eye:veh:authorize', model, 'concess')
            print(('^5[NETDIAG][VEHICLE]^7 %s menu.lua:417 CreateVehicle NETWORKED model=%s'):format(GetCurrentResourceName(), tostring(model)))
            local veh = CreateVehicle(model, pos.x, pos.y, pos.z, pos.w, true, true)
            ESX.Game.SetVehicleProperties(veh, vehicleProps)
            SetVehicleOnGroundProperly(veh)
            SetVehicleNumberPlateText(veh, "SHOWROOM")
            SetEntityAsMissionEntity(veh, true, true)
            FreezeEntityPosition(veh, true)
            SetVehicleDoorsLocked(veh, 2)

            Config.ShowRoomGrotti[i].veh = veh

            ESX.ShowNotification("~g~Véhicule placé dans le showroom.")
            return
        end
    end
    ESX.ShowNotification("~r~Aucune place disponible dans le showroom.")
end

local function removeShowroomVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for i, slot in ipairs(Config.ShowRoomGrotti) do
        if slot.veh and DoesEntityExist(slot.veh) then
            DeleteEntity(slot.veh)
            Config.ShowRoomGrotti[i].veh = nil
            ESX.ShowNotification("~g~Véhicule retiré du showroom.")
            return
        end
    end

    ESX.ShowNotification("~r~Aucun véhicule à retirer.")
end

function openMenuStockOccas(arg)
    if openGrottiStock then
        return
    end

    local spawnPreview = nil
    if arg then
        spawnPreview = vector3(-925.1293, -2043.0830, 8.5064)
    else
        spawnPreview = vector3(-931.9675, -2030.8280, 8.5093)
    end

    ESX.TriggerServerCallback("sJobs.getStockGrotti", function(vehicles)
        stockVeh = vehicles or {}

        openGrottiStock = true
        RageUI.Visible(RMenu:Get('grotti', 'stockVehicle'), true)
        Citizen.CreateThread(function()
            local price, vehicleProps = nil, nil
            local ped = PlayerPedId()

            while openGrottiStock do
                RageUI.IsVisible(RMenu:Get('grotti', 'stockVehicle'), true, true, true, function()
                    RageUI.Separator("Véhicules en Stock")

                    for _, value in pairs(stockVeh) do
                        RageUI.ButtonWithStyle(GetDisplayNameFromVehicleModel(value.vehicle.model), nil, {RightLabel = ESX.Math.GroupDigits(tonumber(value.price) or 0) .. "$"}, true, function(_, _, Selected)
                            if Selected then
                                price = value.price
                                vehicleProps = value.vehicle
                            end
                        end, RMenu:Get('grotti', 'data_vehicle'))
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('grotti', 'data_vehicle'), true, true, true, function()
                    RageUI.Separator("Prix du véhicule : " ..tonumber(price).. "$")

                    if vehicleProps.modTurbo == 1 and vehicleProps.modEngine == 3 and vehicleProps.modBrakes >= 2 and vehicleProps.modTransmission >= 2 then
                        RageUI.Separator("~g~Full Custom")
                    else
                        RageUI.Separator("~r~Non Custom")
                    end

                    RageUI.ButtonWithStyle("Regarder le véhicule", nil, {RightLabel = nil}, true, function(_, _, Selected)
                        if Selected then
                            if DoesEntityExist(previewGrotti) then
                                DeleteEntity(previewGrotti)
                            end

                            RageUI.CloseAll()
                            local model = type(vehicleProps.model) == "number" and vehicleProps.model or GetHashKey(vehicleProps.model)
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Wait(0)
                            end

                            TriggerServerEvent('eye:veh:authorize', model, 'concess')
                            print(('^5[NETDIAG][VEHICLE]^7 %s menu.lua:509 CreateVehicle NETWORKED (preview) model=%s'):format(GetCurrentResourceName(), tostring(model)))
                            previewGrotti = CreateVehicle(model, -982.91314697266, -2057.9040527344, 9.4056758880615, 225.56, true, false)
                            SetEntityAsMissionEntity(previewGrotti, true, true)
                            ESX.Game.SetVehicleProperties(previewGrotti, vehicleProps)
                            TaskWarpPedIntoVehicle(ped, previewGrotti, -1)
                            SetVehicleDirtLevel(previewGrotti, 0.0)
                            SetVehicleColours(previewGrotti, 0, 0)
                            SetVehicleNumberPlateText(previewGrotti, "GROTTI")
                            SetVehicleDoorsLocked(previewGrotti, 2)
                            FreezeEntityPosition(previewGrotti, true)
                            SetVehicleFixed(previewGrotti)

                            SetModelAsNoLongerNeeded(model)
                        end

                        Citizen.CreateThread(function()
                            local show = true
                            while show and DoesEntityExist(previewGrotti) do
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour quitter le mode aperçu du véhicule")
                                if IsControlJustPressed(0, 38) then
                                    DeleteEntity(previewGrotti)
                                    previewGrotti = nil
                                    SetEntityCoords(ped, spawnPreview.x, spawnPreview.y, spawnPreview.z)
                                    show = false
                                end
                                Wait(0)
                            end
                        end)
                    end)

                    if arg ~= "catalogue" then
                        -- Patron uniquement (re-verifie cote serveur) : corrige un
                        -- prix de revente fixe trop haut au rachat.
                        if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == "boss" then
                            RageUI.ButtonWithStyle("Modifier le prix de revente", "~o~Patron~s~ : change le prix affiché aux clients pour ce véhicule.", {RightLabel = "✏️"}, true, function(_, _, Selected)
                                if Selected then
                                    local input = lib.inputDialog("Nouveau prix de revente", {
                                        {type = "number", label = "Prix de revente", description = "Entre 1 000$ et 150 000 000$", default = tonumber(price), min = 1000, max = 150000000, required = true}
                                    })
                                    local newPrice = input and tonumber(input[1])
                                    if not newPrice then return end

                                    local plate = vehicleProps and vehicleProps.plate
                                    ESX.TriggerServerCallback("sJobs.setOccasPrice", function(ok, appliedPrice)
                                        if not ok then return end
                                        price = appliedPrice
                                        for _, value in pairs(stockVeh) do
                                            if value.vehicle and value.vehicle.plate == plate then
                                                value.price = appliedPrice
                                            end
                                        end
                                    end, plate, newPrice)
                                end
                            end)
                        end

                        RageUI.ButtonWithStyle("Sortir le véhicule en showroom", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                spawnInShowroom(vehicleProps)
                            end
                        end)
                        RageUI.ButtonWithStyle("Retirer un véhicule du showroom", nil, {}, true, function(_, _, Selected)
                            if Selected then
                                removeShowroomVehicle()
                            end
                        end)

                        RageUI.ButtonWithStyle("Vendre le véhicule", nil, {RightLabel = "~o~" ..tonumber(price).. "$"}, true, function(Active, _, Selected)
                            if Active then
                                marquerJoueur()
                            end
                            if Selected then
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if player == -1 or distance > 3.0 then
                                    ESX.ShowNotification("~r~Aucun joueur à proximité.")
                                    return
                                end

                                local playerServerId = GetPlayerServerId(player)
                                if not playerServerId then
                                    return
                                end

                                openGrottiStock = false
                                RageUI.CloseAll()

                                TriggerServerEvent("sJobs.sellVehicleCustomer", vehicleProps, GetDisplayNameFromVehicleModel(vehicleProps.model), playerServerId)
                            end
                        end)
                    end
                end, function()
                end)

                if not RageUI.Visible(RMenu:Get('grotti', 'stockVehicle')) and
                   not RageUI.Visible(RMenu:Get('grotti', 'data_vehicle')) then
                    openGrottiStock = false
                    break
                end
                Wait(0)
            end
        end)
    end)
end

function openMenuBuyVehicle()
    if openGrottiBuy then
        return
    end
    openGrottiBuy = true
    RageUI.Visible(RMenu:Get('grotti', 'buyVehicle'), true)
    Citizen.CreateThread(function()
        while openGrottiBuy do
            RageUI.IsVisible(RMenu:Get('grotti', 'buyVehicle'), true, true, true, function()
                RageUI.ButtonWithStyle("Ajouter un véhicule au stock", nil, {RightLabel = nil}, true, function(Active, _, Selected)
                    if Active then
                        marquerJoueur()
                    end
                    if Selected then
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if player == -1 or distance > 3.0 then
                            ESX.ShowNotification("~r~Aucun joueur à proximité.")
                            return
                        end

                        local ped = PlayerPedId()
                        if IsPedSittingInAnyVehicle(ped) then
                            ESX.ShowNotification("~r~Vous ne pouvez pas rentrer un véhicule dans le stock en étant dedans")
                            return
                        end

                        local vehicle, distance = ESX.Game.GetClosestVehicle()
                        if not vehicle or distance > 5.0 then
                            ESX.ShowNotification("~r~Aucun véhicule à proximité.")
                            return
                        end

                        RageUI.CloseAll()
                        openGrottiBuy = false
                        buyOccasVehicle(player, vehicle)
                    end
                end)
            end, function()
            end)

            if not RageUI.Visible(RMenu:Get('grotti', 'buyVehicle')) then
                openGrottiBuy = false
                break
            end
            Wait(0)
        end
    end)
end

function openMenuPharmacy()
    if openPharmacy then
        return
    end
    openPharmacy = true
    RageUI.Visible(RMenu:Get('ambulance', 'pharmacy'), true)
    Citizen.CreateThread(function()
        while openPharmacy do
            RageUI.IsVisible(RMenu:Get('ambulance', 'pharmacy'), true, true, true, function()
                for _, item in ipairs(itemPharmacy) do
                    RageUI.ButtonWithStyle(item:gsub("^%l", string.upper), nil, {RightLabel = nil}, true, function(_, _, Selected)
                        if Selected then
                            local input = lib.inputDialog("Pharmacie", {
                                {type = "number", label = "Quantité", required = true, min = 1},
                            })
                            if input and input[1] then
                                local quantity = tonumber(input[1])
                                if quantity and quantity > 0 then
                                    TriggerServerEvent("sJobs.buyItems", item, quantity)
                                else
                                    ESX.ShowNotification("~r~Quantité invalide.")
                                end
                            end
                        end
                    end)
                end
            end, function()
            end)

            if not RageUI.Visible(RMenu:Get('ambulance', 'pharmacy')) then
                openPharmacy = false
                break
            end
            Wait(0)
        end
    end)
end

function openMenuArmory(playerJob)
    if openArmory then
        return
    end
    openArmory = true
    RageUI.Visible(RMenu:Get('menu2', 'armory'), true)
    Citizen.CreateThread(function()
        while openArmory do
            RageUI.IsVisible(RMenu:Get('menu2', 'armory'), true, true, true, function()
                local weapons = dataArmory[playerJob]
                local allowed = false

                if weapons then
                    for _, v in pairs(weapons) do
                        if v.grade then
                            if type(v.grade) == "table" then
                                for _, g in pairs(v.grade) do
                                    if g == "*" or g == ESX.PlayerData.job.grade_name then
                                        allowed = true
                                        break
                                    end
                                end
                            elseif v.grade == "*" or v.grade == ESX.PlayerData.job.grade_name then
                                allowed = true
                                break
                            end
                        end
                    end
                end

                if not weapons then
                    RageUI.Separator("~r~Aucune armurerie configuree")
                    RageUI.Separator("~c~pour le metier " .. tostring(playerJob))
                elseif not allowed then
                    RageUI.Separator("~r~Votre grade n'a pas acces")
                    RageUI.Separator("~c~Grade actuel : " .. tostring(ESX.PlayerData.job.grade_name or "?"))
                end

                if allowed then
                    for _, v in pairs(weapons) do
                        if not v.grade then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = ESX.Math.GroupDigits(v.price).."$"}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    openArmory = false

                                    local prefix = string.sub(v.name, 1, 4)
                                    local quantity = 1
                                    if prefix == "clip" then
                                        local input = lib.inputDialog("Achat de munitions", {
                                            {
                                                type = "number",
                                                label = "Quantité de munitions",
                                                description = "Entrez la quantité désirée",
                                                required = true,
                                                min = 1,
                                                max = 10
                                            }
                                        })
                                        if input and input[1] then
                                            quantity = tonumber(input[1])
                                            if not quantity or quantity < 1 or quantity > 10 then
                                                ESX.ShowNotification("~r~Quantité invalide. (1-10)")
                                                return
                                            end
                                        else
                                            ESX.ShowNotification("~r~Achat annulé.")
                                            return
                                        end
                                    end
                                    TriggerServerEvent("sJobs.buyArmory", v.name, v.price, quantity, prefix)
                                end
                            end)
                        end
                    end
                else
                    RageUI.Separator("~r~Aucune arme disponible.")
                end
            end, function()
            end)
            if not RageUI.Visible(RMenu:Get('menu2', 'armory')) then
                openArmory = false
                break
            end
            Wait(0)
        end
    end)
end

local function openMenu()
    if open then
        return
    else
        open = true
        RageUI.Visible(RMenu:Get('menu', 'general'), true)

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(RMenu:Get('menu', 'general'), true, true, true, function()
                    if not inService then
                        RageUI.ButtonWithStyle("Prendre son service", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                inService = true
                                ESX.ShowNotification("Vous avez pris votre service")
                                TriggerServerEvent("sJobs.service", "on")
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Prendre sa fin de service", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                inService = false
                                ESX.ShowNotification("Vous avez pris votre fin de service")
                                TriggerServerEvent("sJobs.service", "off")
                            end
                        end)

                        RageUI.ButtonWithStyle("Facturation", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                local societyName = "society_" ..string.lower(playerJob)
                                TriggerEvent("sCore.sendBill", societyName)
                                RageUI.CloseAll()
                                open = false
                            end
                        end)

                        RageUI.ButtonWithStyle("Annonce Entreprise", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                if not canAnnounce then
                                    ESX.ShowNotification("Veuillez patienter avant de refaire une annonce.")
                                    return
                                end

                                local input <const> = lib.inputDialog("Annonce Entreprise", {
                                    {
                                        type = "select",
                                        label = "Choix de l'annonce",
                                        options = {
                                            {label = "Entreprise ouverte", value = "Entreprise ouverte"},
                                            {label = "Entreprise fermée", value = "Entreprise fermée"},
                                        },
                                        required = true
                                    },
                                })

                                if input and input[1] then
                                    canAnnounce = false
                                    local announce = input[1]
                                    TriggerServerEvent("sJobs.announce", announce, playerJob)
                                    RageUI.CloseAll()
                                    open = false
                                    Citizen.SetTimeout(5000, function()
                                        canAnnounce = true
                                    end)
                                end
                            end
                        end)

                        if playerJob == "taxi" then
                            RageUI.ButtonWithStyle("Missions PNJ", nil, { RightLabel = nil}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    missionTaxi()
                                end
                            end)
                        end

                        if playerJob == "immo" then
                            RageUI.ButtonWithStyle("Menu de création de propriété", nil, { RightLabel = nil}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    ExecuteCommand("immo")
                                end
                            end)
                            RageUI.ButtonWithStyle("Menu de création de buldings", nil, { RightLabel = nil}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    ExecuteCommand("immob")
                                end
                            end)
                        end

                        if playerJob == "weazle" then
                            RageUI.ButtonWithStyle("Sortir/Ranger la caméra", nil, { RightLabel = "🎥"}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    mainCamera()
                                end
                            end)
                            RageUI.ButtonWithStyle("Sortir/Ranger le micro", nil, { RightLabel = "🎤"}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    mainMicro()
                                end
                            end)
                            RageUI.ButtonWithStyle("Sortir/Ranger le micro-perche", nil, { RightLabel = "🎤"}, true, function(_, _, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    open = false
                                    mainMPerche()
                                end
                            end)
                        end

                        if playerJob == "streettuners" then
                            RageUI.ButtonWithStyle("Atelier de craft", "Crafter les items spécifiques Streettuners", { RightLabel = "→" }, true, function(_, _, Selected)
                                if Selected and not StreettunersConfig then
                                    ESX.ShowNotification("~r~Configuration Streettuners introuvable.")
                                end
                            end, RMenu:Get('streettuners', 'craft'))
                        end

                        if playerJob == "police" or playerJob == "sheriff" then
                            RageUI.ButtonWithStyle("Appeler la fourrière", "Signale votre position aux agents de la fourrière en service.", { RightLabel = "🚛" }, true, function(_, _, Selected)
                                if Selected then
                                    TriggerServerEvent("sJobs.callFourriere")
                                    RageUI.CloseAll()
                                    open = false
                                end
                            end)
                        end

                        if playerJob == "police" or playerJob == "sheriff" or playerJob == "doj" then
					        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            RageUI.ButtonWithStyle("Ajouter bracelet électronique", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    marquerJoueur()
                                end
                                if (Selected) then
                                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                        ExecuteCommand("e mechanic4")

                                        Citizen.CreateThread(function()
                                            FreezeEntityPosition(PlayerPedId(), true)
                                            local time = GetGameTimer() + 2500
                                            while time > GetGameTimer() do
                                                Citizen.Wait(0)
                                                DisableControlAction(0, 73, true)
                                            end
                                            FreezeEntityPosition(PlayerPedId(), false)
                                        end)

                                        TriggerEvent("core:drawBar", 2.5 * 1000, "⏳ INSTALLATION DU BRACELET...")
                                        Citizen.Wait(2.5 * 1000)
                                        ClearPedTasks(PlayerPedId())
                                        TriggerServerEvent('lspd:bracelet:add', GetPlayerServerId(closestPlayer))
                                    else
                                        ESX.ShowNotification('Il n\'y a personne autour !')
                                    end
                                end
                            end)

                            RageUI.ButtonWithStyle("Liste des personnes sous bracelet électronique", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    tempData = {}
                                    ESX.TriggerServerCallback("lspd:getBracelets", function(rep)
                                        tempData = rep or {}
                                    end)
                                end
                            end, RMenu:Get('menu', 'bracelet'))
                        end

                        if playerJob == "police" or playerJob == "sheriff" then
                            RageUI.ButtonWithStyle("Demande de Renfort", nil, { RightLabel = nil}, true, function() end, RMenu:Get('menu', 'renfort'))
                            RageUI.ButtonWithStyle("Statut de l'agent", nil, { RightLabel = nil}, true, function() end, RMenu:Get('menu', 'status'))
                            RageUI.ButtonWithStyle("Unité K9", nil, { RightLabel = nil}, true, function() end, RMenu:Get('menu', 'k9'))
                        end
                    end
                end, function()
				end)

                RageUI.IsVisible(RMenu:Get('menu', 'bracelet'), true, true, true, function()
					if tempData then
						for k,v in pairs(tempData) do
							RageUI.ButtonWithStyle(v.identity, "Appuyez sur SUPR pour retirer la personne des bracelets électroniques", {}, true, function(Hovered, Active, Selected)
								if Active then
									if IsControlJustPressed(0, 178) then
										RageUI.GoBack()

										TriggerServerEvent("lspd:bracelet:delete", v.identifier)
									end
								end

								if Selected then
									tempIndex = v
								end
							end, RMenu:Get('menu', 'bracelet_edit_police'))
						end
					end
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'bracelet_edit_police'), true, true, true, function()

                    RageUI.ButtonWithStyle("Retirer le bracelet", "Retirera le bracelet électronique à la personne", {}, true, function(Hovered, Active, Selected)
						if Selected then
							local playerPed = PlayerPedId()
							local players = GetActivePlayers()
							local found = false

							if not tempIndex.source then
								ESX.ShowNotification("~r~La personne n'est pas en ville.")
								return
							end

							for _, player in ipairs(players) do
								local ped = GetPlayerPed(player)
								if ped ~= playerPed then
									local serverId = GetPlayerServerId(player)
									if tempIndex and tempIndex.source and serverId == tempIndex.source then
										local playerCoords = GetEntityCoords(playerPed)
										local targetCoords = GetEntityCoords(ped)
										local distance = #(playerCoords - targetCoords)
										if distance > 5.0 then
											ESX.ShowNotification("~r~La personne est trop loin pour retirer le bracelet.")
											found = true
											return
										end
									end
								end
							end

							ExecuteCommand("e mechanic4")

							Citizen.CreateThread(function()
								FreezeEntityPosition(PlayerPedId(), true)
								local time = GetGameTimer() + 2500
								while time > GetGameTimer() do
									Citizen.Wait(0)
									DisableControlAction(0, 73, true)
								end
								FreezeEntityPosition(PlayerPedId(), false)
							end)

                            TriggerEvent("core:drawBar", 2.5 * 1000, "⏳ RETRAIT DU BRACELET...")
							Citizen.Wait(2.5 * 1000)
							ClearPedTasks(PlayerPedId())
							TriggerServerEvent("lspd:bracelet:delete", tempIndex.identifier)
							RageUI.GoBack()
						end
					end)

					RageUI.ButtonWithStyle("Faire sonner", "Enverra une notification à la personne pour qu'elle sache qu'elle doit venir au poste", {}, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("lspd:bracelet:sendAlert", tempIndex.identifier)
						end
					end)

					RageUI.ButtonWithStyle("Obtenir la position", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("lspd:bracelet:getPos", tempIndex.identifier)
						end
					end)

					RageUI.ButtonWithStyle("Envoyer un message", "Envoie un message sur le bracelet électronique de la personne", { RightLabel = "✉️" }, true, function(Hovered, Active, Selected)
						if Selected then
							if not tempIndex.source then
								ESX.ShowNotification("~r~La personne n'est pas en ville.")
								return
							end
							local input = lib.inputDialog("Message bracelet électronique", {
								{ type = "textarea", label = "Message", description = "200 caractères maximum", required = true, max = 200, autosize = true },
							})
							if not input or not input[1] or input[1] == "" then return end
							TriggerServerEvent("lspd:bracelet:sendMessage", tempIndex.identifier, input[1])
						end
					end)

                end, function()
				end)

                RageUI.IsVisible(RMenu:Get('menu', 'renfort'), true, true, true, function()
                    for _, option in pairs(renfortOptions) do
                        RageUI.ButtonWithStyle(option.label, nil, {}, true, function(_, _, Selected)
                            if Selected then
                                local coords = GetEntityCoords(PlayerPedId())
                                local playerJob = ESX.PlayerData.job.name

                                TriggerServerEvent('sJobs.requestRenfort', coords, option.raison, playerJob)
                                RageUI.CloseAll()
                                open = false
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'status'), true, true, true, function()
                    for _, option in pairs(statusOptions) do
                        RageUI.ButtonWithStyle(option.label, nil, {}, true, function(_, _, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                open = false

                                TriggerServerEvent("sJobs.setStatus", option.value)
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'k9'), true, true, true, function()
                    if not DoesEntityExist(dogEntity) then
                        RageUI.ButtonWithStyle("Déployer le chien", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                spawnDog()
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Renvoyer le chien", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                spawnDog()
                            end
                        end)
                    end

                    if DoesEntityExist(dogEntity) then
                        RageUI.ButtonWithStyle("Modifier l'apparence", nil, { RightLabel = nil}, true, function() end, RMenu:Get('k9', 'k9Edit'))

                        for _, action in pairs(k9Toggles) do
                            if K9.data[action.stateKey] == nil then
                                K9.data[action.stateKey] = false
                            end
                            local label = K9.data[action.stateKey] and action.trueLabel or action.falseLabel

                            RageUI.ButtonWithStyle(label, nil, {RightLabel = nil}, true, function(_, _, Selected)
                                if Selected then
                                    Citizen.CreateThread(function()
                                        action.func()
                                    end)
                                end
                            end)
                        end

                        RageUI.ButtonWithStyle("Ordonner de rechercher de la drogue", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                searchType = 'drug'
                            end
                        end, RMenu:Get('k9', 'k9Search'))

                        RageUI.ButtonWithStyle("Ordonner de rechercher des armes", nil, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                searchType = 'weapons'
                            end
                        end, RMenu:Get('k9', 'k9Search'))
                    end
                end)

                RageUI.IsVisible(RMenu:Get('k9', 'k9Edit'), true, true, true, function()
                    for _, option in ipairs(k9Appearance) do
                        RageUI.ButtonWithStyle(option.label, option.description, {RightLabel = nil}, true, function(_, _, Selected)
                            if Selected then
                                if K9[option.indexKey] == nil then
                                    K9[option.indexKey] = 0
                                end

                                if K9[option.indexKey] + 1 > 4 then
                                    K9[option.indexKey] = 0
                                end

                                SetPedComponentVariation(dogEntity, option.component, 0, K9[option.indexKey], 2)
                                K9[option.indexKey] = K9[option.indexKey] + 1
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(RMenu:Get('k9', 'k9Search'), true, true, true, function()
                    local ped = PlayerPedId()
                    local playerCoords = GetEntityCoords(ped)
                    local nearbyPlayers = lib.getNearbyPlayers(playerCoords, 3.0, true)

                    for _, playerData in pairs(nearbyPlayers) do
                        local playerId = playerData.id
                        local targetPed = GetPlayerPed(playerId)
                        local targetCoords = GetEntityCoords(targetPed)

                        RageUI.ButtonWithStyle("Joueur #" .. playerId, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Active then
                                DrawMarker(20, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 0, 170, 0, 100, true, true)
                            end
                            if Selected then
                                if searchType == 'drug' then
                                    searchPlayer(playerId, searchType)
                                elseif searchType == 'weapons' then
                                    searchPlayer(playerId, searchType)
                                end
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(RMenu:Get('streettuners', 'craft'), true, true, true, function()
                    if not StreettunersConfig or not StreettunersConfig.recipes then
                        RageUI.Separator("~r~Configuration indisponible.")
                        return
                    end
                    for _, recipe in ipairs(StreettunersConfig.recipes) do
                        local desc = ("Coût société : %d$\nDurée du craft : %ds")
                            :format(recipe.price or 0, math.floor((recipe.craftMs or 0) / 1000))
                        RageUI.ButtonWithStyle(recipe.label, desc,
                            { RightLabel = ("~o~%d$ ~s~société"):format(recipe.price or 0) },
                            true, function(_, _, Selected)
                                if Selected then
                                    startStreettunersCraft(recipe)
                                end
                            end)
                    end
                end)

                if not RageUI.Visible(RMenu:Get('menu', 'general')) and
                    not RageUI.Visible(RMenu:Get('menu', 'status')) and
                    not RageUI.Visible(RMenu:Get('menu', 'k9')) and
                    not RageUI.Visible(RMenu:Get('k9', 'k9Edit')) and
                    not RageUI.Visible(RMenu:Get('k9', 'k9Search')) and
                    not RageUI.Visible(RMenu:Get('menu', 'renfort')) and
                    not RageUI.Visible(RMenu:Get('menu', 'bracelet')) and
                    not RageUI.Visible(RMenu:Get('menu', 'bracelet_edit_police')) and
                    not RageUI.Visible(RMenu:Get('streettuners', 'craft')) then

                    open = false
                    break
                end
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function menuGestion()
    if openGestion then
        return
    else
        openGestion = true
        RageUI.Visible(RMenu:Get('gouv', 'gestion'), true)

        local societie, empy = {}, {}

        ESX.TriggerServerCallback('sJobs_gouv.getSocieties', function(societies)
            societie = societies
        end)

        Citizen.CreateThread(function()
            while openGestion do
                RageUI.IsVisible(RMenu:Get('gouv', 'gestion'), true, true, true, function()

                    RageUI.Separator("Sociétés:")

                    for _, v in pairs(societie) do
                        for _, j in pairs(existantSocieties) do
                            if j.name == v.account_name then
                                RageUI.ButtonWithStyle(j.nameHash, nil, {RightLabel = ESX.Math.GroupDigits(v.money).."$"}, true, function(_, _, Selected)
                                    if Selected then
                                        ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
                                            empy = employees
                                        end, j.society)
                                    end
                                end, RMenu:Get('gouv', 'EmpList'))
                            end
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('gouv', 'EmpList'), true, false, true, function()
                    if #empy == 0 then
                        RageUI.Separator("~r~Aucun employé trouvé.")
                    else
                        for _, v in pairs(empy) do
                            RageUI.ButtonWithStyle(v.firstname.. " " ..v.lastname, nil, {RightLabel = v.job.grade_label}, true)
                        end
                    end
                end)

                if not RageUI.Visible(RMenu:Get('gouv', 'gestion')) and
                   not RageUI.Visible(RMenu:Get('gouv', 'EmpList')) then
                    openGestion = false
                    break
                end
                Wait(0)
            end
        end)
    end
end

function menuWeapon()
    if openWeaponAmmu then
        return
    else
        openWeaponAmmu = true
        RageUI.Visible(RMenu:Get('ammu', 'WeaponSelection'), true)

        Citizen.CreateThread(function()
            while openWeaponAmmu do
                RageUI.IsVisible(RMenu:Get('ammu', 'WeaponSelection'), true, true, true, function()
                    for _, v in pairs(ammuWeapons) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {RightLabel = nil}, true, function(_, _, Selected)
                        end, RMenu:Get('ammu', v.value))
                    end
                end, function()
                end)

                for _, v in pairs(ammuWeapons) do
                    RageUI.IsVisible(RMenu:Get('ammu', v.value), true, true, true, function()
                        for _, j in pairs(v.weapons) do
                            RageUI.ButtonWithStyle(firstToUpper(j.name), nil, {RightLabel = ESX.Math.GroupDigits(j.price).. "$"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    cacheWeapon.value = j.hash
                                    cacheWeapon.price = j.price
                                end
                            end, RMenu:Get('ammu', 'WeaponChoose'))
                        end
                    end, function()
                    end)
                end

                RageUI.IsVisible(RMenu:Get('ammu', 'WeaponChoose'), true, true, true, function()
                    RageUI.ButtonWithStyle("Montant à vendre: ~g~", nil, {RightLabel = ESX.Math.GroupDigits(amount)}, true, function(_, _, Selected)
                        if Selected then
                            local input = lib.inputDialog("Montant à vendre", {
                                {
                                    type = "number",
                                    label = "Quantité",
                                    default = amount,
                                    min = 1
                                }
                            })

                            if input and input[1] then
                                amount = tonumber(input[1])
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Vendre l'objet", nil, {RightLabel = nil}, true, function(_, Active, Selected)
                        if Active then
                            marquerJoueur()
                        end
                        if Selected then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            if distance <= 3.0 then
                                TriggerServerEvent('sJobs.ammuSell', GetPlayerServerId(player), cacheWeapon.value, amount, cacheWeapon.price)
                                RageUI.CloseAll()
                                openWeaponAmmu = false
                            else
                                ESX.ShowNotification("Personnes autour de vous.")
                            end
                        end
                    end)
                end, function()
                end)
                Wait(0)
            end
        end)
    end
end

function contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local _streettunersCrafting = false

local function _ensureAnim(dict)
    if not dict or dict == "" then return end
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
        Wait(10)
    end
end

function startStreettunersCraft(recipe)
    if _streettunersCrafting then return end
    if not recipe or not recipe.id then return end
    _streettunersCrafting = true

    RageUI.CloseAll()
    open = false

    local ped = PlayerPedId()
    if recipe.animDict and recipe.animDict ~= "" then
        _ensureAnim(recipe.animDict)
        if HasAnimDictLoaded(recipe.animDict) then
            TaskPlayAnim(ped, recipe.animDict, recipe.animName or "base", 4.0, -4.0,
                recipe.craftMs or 5000, 49, 0, false, false, false)
        end
    end

    local progressOk = false
    if lib and lib.progressBar then
        progressOk = lib.progressBar({
            duration = recipe.craftMs or 5000,
            label    = ("Craft : %s"):format(recipe.label),
            useWhileDead = false,
            canCancel    = true,
            disable      = { car = true, move = true, combat = true, sprint = true },
        })
    else
        Wait(recipe.craftMs or 5000)
        progressOk = true
    end

    ClearPedTasks(PlayerPedId())

    if not progressOk then
        if ESX and ESX.ShowNotification then ESX.ShowNotification("~r~Craft annulé.") end
        _streettunersCrafting = false
        return
    end

    TriggerServerEvent("streettuners:craft:request", recipe.id)
    SetTimeout(1500, function() _streettunersCrafting = false end)
end

RegisterNetEvent("streettuners:craft:result")
AddEventHandler("streettuners:craft:result", function(_success, _recipeId)
    _streettunersCrafting = false
end)

RegisterCommand("societyMenu", function()

    local excludedJobs = {"unemployed", "ems", "lsfd", "fourriere"}
    local isExcluded = contains(excludedJobs, playerJob)
    local isEligibleSociety = vehicleSociety[playerJob]
        or playerJob == "ammu"
        or playerJob == "grotti"
        or playerJob == "pdm"
        or playerJob == "paletoauto"
        or playerJob == "bennys"
        or playerJob == "police"
        or playerJob == "sheriff"
        or playerJob == "streettuners"
        or playerJob == "bobcat"

    if (not isExcluded) and isEligibleSociety then
        openMenu()
    end
end)

RegisterKeyMapping("societyMenu", "Menu Société / Panic", "keyboard", "F6")

RegisterNetEvent("bracelet:remove")
AddEventHandler("bracelet:remove", function()
    ESX.TriggerServerCallback("lspd:bracelet:remove", function(rep)
    end)
end)

RegisterNetEvent("lspd:bracelet:sendPos")
AddEventHandler("lspd:bracelet:sendPos", function(coords)

    local alpha = 250
    local alpha2 = 170
    local info = AddBlipForCoord(coords)
    local info2 = AddBlipForCoord(coords)

    SetBlipSprite(info, 161)
    SetBlipDisplay(info, 4)
    SetBlipColour(info, 30)
    SetBlipScale(info, 0.8)
    SetBlipAsShortRange(info, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info)

    SetBlipSprite(info2, 280)
    SetBlipDisplay(info2, 4)
    SetBlipColour(info2, 30)
    SetBlipScale(info2, 0.8)
    SetBlipAsShortRange(info2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info2)

	while alpha ~= 0 do
		Citizen.Wait(50 * 4)
		alpha = alpha - 1
		SetBlipAlpha(info, alpha)
		SetBlipAlpha(info2, alpha)

		if alpha == 0 then
			RemoveBlip(info)
			RemoveBlip(info2)
			return
		end
	end
end)

RegisterNetEvent("lspd:bracelet:sendAlert")
AddEventHandler("lspd:bracelet:sendAlert", function()
    for i=1, 5 do
        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", false)
        Citizen.Wait(150)
    end
    ESX.ShowNotification("~r~Un agent vous a localisé grâce à votre bracelet électronique !")
end)

-- Message recu sur le bracelet electronique (envoye par un agent).
RegisterNetEvent("lspd:bracelet:receiveMessage")
AddEventHandler("lspd:bracelet:receiveMessage", function(senderLabel, message)
    for i = 1, 3 do
        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", false)
        Citizen.Wait(150)
    end
    ESX.ShowAdvancedNotification(tostring(senderLabel or "Forces de l'ordre"), "~r~Bracelet électronique", tostring(message or ""), "CHAR_CALL911", 8)
end)
