if IsDuplicityVersion() then
	RegisterNetEvent("shop:GetConfig")
	AddEventHandler("shop:GetConfig", function()
		local _source = source
		TriggerEvent('calm_frame:Trig', _source, 'shop:GetConfig')
		TriggerClientEvent("shop:RecieveConfig", _source, shopobject)
	end)
end

function ShopAddItemToAll(key, data, opts)
    opts = opts or {}
    local onlyLegal = opts.onlyLegal
    local onlyIllegal = opts.onlyIllegal
    local includeMenuIds = opts.includeMenuIds
    local excludeMenuIds = opts.excludeMenuIds
    local overwrite = opts.overwrite or false
    local include = {}
    local exclude = {}
    if includeMenuIds then
        for _, v in ipairs(includeMenuIds) do include[v] = true end
    end
    if excludeMenuIds then
        for _, v in ipairs(excludeMenuIds) do exclude[v] = true end
    end
    for _, shop in pairs(shopobject) do
        if (not onlyLegal or shop.illegal == false) and (not onlyIllegal or shop.illegal == true) then
            if (not includeMenuIds or include[shop.MenuId]) and (not excludeMenuIds or not exclude[shop.MenuId]) then
                shop.items = shop.items or {}
                if overwrite or shop.items[key] == nil then
                    shop.items[key] = data
                end
            end
        end
    end
end

function ShopAddItemsToAll(items, opts)
    for k, v in pairs(items) do
        ShopAddItemToAll(k, v, opts)
    end
end

shopobject = {
	ShopLegal1 = {
		MenuId = "ShopLegal1",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(24.42, -1347.31, 28.49),
		heading = 275.0,

		items = {
			canne = {
				nom = "🎣 Canne à pêche",
				NomItem = "canne",
				prix = 1000,
			},
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal4 = {
		MenuId = "ShopLegal4",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1727.8, 6415.26, 34.03),
		heading = 247,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal5 = {
		MenuId = "ShopLegal5",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(-3038.93, 584.50, 6.91),
		heading = 17.03,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal6 = {
		MenuId = "ShopLegal6",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(-1222.0, -908.35, 11.33),
		heading = 45.3,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal7 = {
		MenuId = "ShopLegal7",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1134.22, -982.31, 46.42),
		heading = 276.03,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal8 = {
		MenuId = "ShopLegal8",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1164.92, -324.1, 69.21),
		heading = 105.56,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal10 = {
		MenuId = "ShopLegal10",
		illegal = false,
		TitreMenu = "Magasin d'électroniques",
		DescriptionMenu = "~y~Magasin d'électroniques~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu du magasin d'électroniques.",

		BlipId = 521,
		BlipScale = 0.5,
		BlipColor = 0,
		BlipName = "Magasin d'électroniques",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(386.1171, -827.0819, 28.40545),
		heading = 160.94,

		items = {
			classic_phone = {
			    nom = "📱 Téléphone",
			    NomItem = "classic_phone",
				prix = 5000,
			},
			radio = {
			    nom = "🎙 Radio",
			    NomItem = "radio",
				prix = 10000,
			},
        },
	},

	ShopLegal13 = {
		MenuId = "ShopLegal13",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1697.92, 4922.81, 42.06),
		heading = 326.28,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal14 = {
		MenuId = "ShopLegal14",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1961.0599365234, 3741.3957519531, 32.343196868896),
		heading = 300.93,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal15 = {
		MenuId = "ShopLegal15",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1392.81, 3606.61, 34.98),
		heading = 202.55,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal16 = {
		MenuId = "ShopLegal16",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(548.97, 2669.68, 42.16),
		heading = 106.2,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal17 = {
		MenuId = "ShopLegal17",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1165.9, 2710.97, 38.16),
		heading = 177.72,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal18 = {
		MenuId = "ShopLegal18",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(2555.64, 381.15, 108.62),
		heading = 359.95,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal19 = {
		MenuId = "ShopLegal19",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(-1819.9, 794.33, 138.08),
		heading = 134.85,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal20 = {
		MenuId = "ShopLegal20",
		illegal = false,
		TitreMenu = "Supérette",
		DescriptionMenu = "~g~Supérette ~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour ouvrir le menu de vente.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(-1486.1, -377.83, 40.16),
		heading = 137.22,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal22 = {
		MenuId = "ShopLegal22",
		illegal = false,
		TitreMenu = "Supérette - Prison",
		DescriptionMenu = "~g~Supérette - Prison ~w~",

		MessageZone = "Appuyez sur [~g~E~w~] pour parler au vendeur de la prison.",

		BlipId = 253,
		BlipScale = 0.85,
		BlipColor = 26,
		BlipName = "Pénitencier",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(1780.578, 2558.939, 45.67313),
		heading = 137.22,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopLegal23 = {
		MenuId = "ShopLegal23",
		illegal = false,
		TitreMenu = "Supérette - Las Venturas",
		DescriptionMenu = "~g~Supérette - Las Venturas ~w~",

		MessageZone = "Appuyez sur [~g~E~w~] pour parler au vendeur.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(7381.678223, 423.948578, 57.053705),
		heading = 56.22,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},
	ShopLegal24 = {
		MenuId = "ShopLegal24",
		illegal = false,
		TitreMenu = "Supérette - Cayo Perico",
		DescriptionMenu = "~g~Supérette - Cayo Perico ~w~",

		MessageZone = "Appuyez sur [~g~E~w~] pour parler au vendeur.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(5126.534, -5113.682, 2.213863),
		heading = 137.22,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},
	ShopLegal25 = {
		MenuId = "ShopLegal25",
		illegal = false,
		TitreMenu = "Supérette - Davis",
		DescriptionMenu = "~g~Supérette - Davis ~w~",

		MessageZone = "Appuyez sur [~g~E~w~] pour parler au vendeur.",

		BlipId = 59,
		BlipScale = 0.85,
		BlipColor = 46,
		BlipName = "Supérette",

		ped = "mp_m_shopkeep_01",
		TailleZone = 4.0,
		zone = vector3(-47.175426, -1758.726074, 28.520979),
		heading = 52.0,

		items = {
			thonsand = {
			    nom = "🥪 Sandwich Thon Mayo",
			    NomItem = "thonsand",
			  	prix = 570,
			},
			poulsand = {
			    nom = "🥪 Sandwich Poulet Curry",
			    NomItem = "poulsand",
			  	prix = 720,
			},
			saumsand = {
			    nom = "🥪 Sandwich Saumon Fromage",
			    NomItem = "saumsand",
			  	prix = 850,
			},
			eau = {
			    nom = "💧 Bouteille d'eau",
			    NomItem = "eau",
				prix = 200,
			},
			chips = {
			    nom = "🥜 Paquet de chips",
			    NomItem = "chips",
				prix = 530,
			},
			coca = {
			    nom = "🥤 Coca Cola",
			    NomItem = "coca",
				prix = 250,
			},
			chocolat = {
			    nom = "🍫 Barre de chocolat",
			    NomItem = "chocolat",
				prix = 420,
			},
			glace = {
			    nom = "🍦 Glace",
			    NomItem = "glace",
				prix = 300,
			},
			cafe = {
			    nom = "☕️ Café",
			    NomItem = "cafe",
				prix = 250,
			},
			donut = {
			    nom = "🍩 Donut",
			    NomItem = "donut",
				prix = 460,
			},
			nouilles = {
			    nom = "🥡 Nouilles",
			    NomItem = "nouilles",
				prix = 520,
			},
        },
	},

	ShopIllegalTablet = {
		MenuId = "ShopIllegalTablet",
		illegal = true,
		TitreMenu = "Vendeur clandestin",
		DescriptionMenu = "~r~Marché noir~w~",

		MessageZone = "Appuyez sur [~o~E~w~] pour parler au vendeur clandestin.",

		ped = "s_m_y_dealer_01",
		spawnPed = true,
		marker = true,

		TailleZone = 2.5,
		zone = vector3(-1491.806152, 2780.840820, 19.783449),
		heading = 289.54370117188,

		items = {
			tablette_illegale = {
			    nom = "📱 Tablette illégale",
			    NomItem = "tablette_illegale",
				prix = 200000,
			},
        },
	},
}
