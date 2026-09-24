cfg_mecano = {}

cfg_mecano.posList = {

	{
		pos = vector3(5128.477539, -5126.976562, 1.313868),
	},
	{
		pos = vector3(5132.584473, -5136.451660, 1.313865),
	},

	{
		pos = vector3(-335.4003, -140.2042, 38.09126),
	},
	{
		pos = vector3(-328.5736, -121.1834, 38.09128),
	},
	{
		pos = vector3(-325.9886, -113.4159, 38.09126),
	},

	{
		pos = vector3(48.144547, 6532.923828, 31.929144),
	},
	{
		pos = vector3(58.587234, 6504.950195, 31.012912),
	},
	{
		pos = vector3(66.895172, 6496.561035, 31.012891),
	},

	{
		pos = vector3(-223.3319, -1329.7848, 29.8904),
	},
	{
		pos = vector3(-236.7044, -1326.2592, 29.8895),
	},
	{
		pos = vector3(-238.1628, -1319.7352, 29.8841),
	},
	{
		pos = vector3(-212.6132, -1329.3723, 29.9135),
	},

	{
		pos = vector3(1027.702, -2526.598, 27.45342),
	},
	{
		pos = vector3(1028.325, -2519.481, 27.42782),
	},
}

GenerateMult = function(modMult)
	local defaultMult, priceTable = modMult, {}
	for i=-1, 250 do
		priceTable[i] = defaultMult
		defaultMult = defaultMult + 0.42
	end
	return priceTable
end

cfg_mecano.modPrices = {
	["modEngine"] = {
		[-1] = 0,
		[0]  = 10.50,
		[1]  = 13.95,
		[2]  = 32.56,
		[3]  = 55.12,
		[4]  = 85.53,
		[5]  = 130.0,
		[6]  = 190.0,
	},
	["modBrakes"] = {
		[-1] = 0,
		[0]  = 9.3,
		[1]  = 18.6,
		[2]  = 25.95,
		[3]  = 45.0,
	},
	["modTransmission"] = {
		[-1] = 0,
		[0]  = 13.95,
		[1]  = 20.93,
		[2]  = 46.51,
		[3]  = 76.51,
	},
	["modSuspension"] = {
		[-1] = 0,
		[0]  = 3.72,
		[1]  = 7.44,
		[2]  = 14.88,
		[3]  = 29.77,
		[4]  = 40.2,
		[5]  = 60.8,
	},
	["modTurbo"] = {
		[0] = 0,
		[1] = 35.81,
	},
	["modFender"] = GenerateMult(5.12),
	["modRightFender"] = GenerateMult(5.12),
	["modSpoilers"] = GenerateMult(4.65),
	["modSideSkirt"] = GenerateMult(4.65),
	["modFrame"] = GenerateMult(5.12),
	["modHood"] = GenerateMult(4.88),
	["modGrille"] = GenerateMult(3.72),
	["modFrontBumper"] = GenerateMult(5.12),
	["modRearBumper"] = GenerateMult(5.12),
	["modExhaust"] = GenerateMult(5.12),
	["modRoof"] = GenerateMult(5.58),
	["windowTint"] = GenerateMult(1.12),
	["modHorns"] = GenerateMult(1.12),
	["neonColors"] = 1.12,
	["neonEnabled"] = {
		[0] = 0,
		[1] = 1.12,
	},
	["modXenon"] = {
		[0] = 0,
		[1] = 3.72,
	},
	["xenonColor"] = 15.75,
	["color1"] = 1.12,
	["color2"] = 0.66,
	["pearlescentColor"] = 0.88,
	["interiorColour"] = 12.3,
	["dashboardColour"] = 4.3,
	["wheelColor"] = 0.66,
	["plateIndex"] = 1.1,
	["sport"] = 4.65,
	["muscle"] = 4.19,
	["lowrider"] = 4.65,
	["suv"] = 4.19,
	["allterrain"] = 4.19,
	["tuning"] = 5.12,
	["motorcycle"] = 3.26,
	["highend"] = 6.12,
	["bennys"] = 5.12,
	["bespoke"] = 5.12,
	["street"] = 6.12,
	["tyreSmokeColor"] = 1.12,
	["modLivery"] = 9.3,
	["modWindows"] = 4.19,
	["modTank"] = 4.19,
	["modTrimB"] = 6.05,
	["modAerials"] = 1.12,
	["modArchCover"] = 4.19,
	["modAPlate"] = 4.19,
	["modSpeakers"] = 6.98,
	["modTrunk"] = 5.58,
	["modHydrolic"] = 5.12,
	["modEngineBlock"] = 5.12,
	["modAirFilter"] = 3.72,
	["modStruts"] = 6.51,
	["modPlateHolder"] = 3.49,
	["modVanityPlate"] = 1.1,
	["modTrimA"] = 6.98,
	["modOrnaments"] = 0.9,
	["modDashboard"] = 4.65,
	["modDial"] = 4.19,
	["modDoorSpeaker"] = 5.58,
	["modSeats"] = 4.65,
	["modSteeringWheel"] = 4.19,
	["modShifterLeavers"] = 3.26,
	["extras"] = 2.0,
}

cfg_mecano.upgradeNames = {
	["modEngine"] = {
		[-1] = "Stock Moteur",
		[0]  = "Reprog moteur Niv. 1",
		[1]  = "Reprog moteur Niv. 2",
		[2]  = "Reprog moteur Niv. 3",
		[3]  = "Reprog moteur Niv. 4",
		[4]  = "Reprog moteur Niv. 5",
		[5]  = "Reprog moteur Niv. 6",
		[6]  = "Reprog moteur Niv. 7",
	},
	["modBrakes"] = {
		[-1] = "Stock Freins",
		[0]  = "Freins de rue",
		[1]  = "Freins de sport",
		[2]  = "Freins de course",
		[3]  = "Freins de course 2",
	},
	["modTransmission"] = {
		[-1] = "Stock Transmission",
		[0]  = "Transmission de rue",
		[1]  = "Transmission de sport",
		[2]  = "Transmission de course",
		[3]  = "Transmission de course 2",
	},
	["modSuspension"] = {
		[-1] = "Stock Suspension",
		[0]  = "Suspension rabaissée",
		[1]  = "Suspension de rue",
		[2]  = "Suspension de sport",
		[3]  = "Suspension de compétition",
		[4]  = "Suspension de course",
		[5]  = "Suspension de course 2",
	},
}

cfg_mecano.windowsTintNames = {
	[0]  = "Stock Fenêtres",
	[1]  = "Pur noir",
	[2]  = "Fumée foncée",
	[3]  = "Fumée claire",
	[4]  = "Limousine",
	[5]  = "Vert",
}

function GetColors(color)
	local colors = {}

	if color == 'black' then
		colors = {
			{index = 0,   label = 'Noir'},
			{index = 1,   label = 'Noir graphite'},
			{index = 2,   label = 'Noir métallique'},
			{index = 3,   label = 'Noir acier moulé'},
			{index = 11,  label = 'Noir anth'},
			{index = 12,  label = 'Noir matte'},
			{index = 15,  label = 'Noir foncé'},
			{index = 16,  label = 'Noir foncé 2'},
			{index = 21,  label = 'Noir huile'},
			{index = 147, label = 'Noir charbon'}
		}
	elseif color == 'white' then
		colors = {
			{index = 106, label = 'Blanc vanille'},
			{index = 107, label = 'Blanc crème'},
			{index = 111, label = 'Blanc'},
			{index = 112, label = 'Blanc polaire'},
			{index = 113, label = 'Blanc beige'},
			{index = 121, label = 'Blanc matte'},
			{index = 122, label = 'Blanc neige'},
			{index = 131, label = 'Blanc coton'},
			{index = 132, label = 'Blanc albâtre'},
			{index = 134, label = 'Blanc pur'}
		}
	elseif color == 'grey' then
		colors = {
			{index = 4,   label = 'Gris argent'},
			{index = 5,   label = 'Gris métallique'},
			{index = 6,   label = 'Gris laminé'},
			{index = 7,   label = 'Gris foncé'},
			{index = 8,   label = 'Gris rocher'},
			{index = 9,   label = 'Gris nuit'},
			{index = 10,  label = 'Gris aluminium'},
			{index = 13,  label = 'Gris matte'},
			{index = 14,  label = 'Gris clair'},
			{index = 17,  label = 'Gris asphalt'},
			{index = 18,  label = 'Gris béton'},
			{index = 19,  label = 'Gris foncé'},
			{index = 20,  label = 'Gris magnésite'},
			{index = 22,  label = 'Gris nickel'},
			{index = 23,  label = 'Gris zinc'},
			{index = 24,  label = 'Gris dolomite'},
			{index = 25,  label = 'Gris bleu'},
			{index = 26,  label = 'Gris titanium'},
			{index = 66,  label = 'Gris acier'},
			{index = 93,  label = 'Gris champagne'},
			{index = 144, label = 'Gris chasseur'},
			{index = 156, label = 'Gris'}
		}
	elseif color == 'red' then
		colors = {
			{index = 27,  label = 'Rouge'},
			{index = 28,  label = 'Rouge torino'},
			{index = 29,  label = 'Rouge coquelicot'},
			{index = 30,  label = 'Rouge cuivre'},
			{index = 31,  label = 'Rouge cardinal'},
			{index = 32,  label = 'Rouge brique'},
			{index = 33,  label = 'Rouge grenat'},
			{index = 34,  label = 'Rouge cabernet'},
			{index = 35,  label = 'Rouge bonbon'},
			{index = 39,  label = 'Rouge matte'},
			{index = 40,  label = 'Rouge foncé'},
			{index = 43,  label = 'Rouge pulpe'},
			{index = 44,  label = 'Rouge brillant'},
			{index = 46,  label = 'Rouge pâle'},
			{index = 143, label = 'Rouge vin'},
			{index = 150, label = 'Rouge volcan'}
		}
	elseif color == 'pink' then
		colors = {
			{index = 135, label = 'Rose électrique'},
			{index = 136, label = 'Rose saumon'},
			{index = 137, label = 'Rose sucré'}
		}
	elseif color == 'blue' then
		colors = {
			{index = 54,  label = 'Bleu topaz'},
			{index = 60,  label = 'Bleu clair'},
			{index = 61,  label = 'Bleu galaxy'},
			{index = 62,  label = 'Bleu foncé'},
			{index = 63,  label = 'Bleu azure'},
			{index = 64,  label = 'Bleu marine'},
			{index = 65,  label = 'Bleu lapis'},
			{index = 67,  label = 'Bleu diamant'},
			{index = 68,  label = 'Bleu surfer'},
			{index = 69,  label = 'Bleu pastel'},
			{index = 70,  label = 'Bleu céleste'},
			{index = 73,  label = 'Bleu rally'},
			{index = 74,  label = 'Bleu paradis'},
			{index = 75,  label = 'Bleu nuit'},
			{index = 77,  label = 'Bleu cyan'},
			{index = 78,  label = 'Bleu cobalt'},
			{index = 79,  label = 'Bleu électrique'},
			{index = 80,  label = 'Bleu horizon'},
			{index = 82,  label = 'Bleu métallique'},
			{index = 83,  label = 'Bleu aquamarine'},
			{index = 84,  label = 'Bleu agathe'},
			{index = 85,  label = 'Bleu zirconium'},
			{index = 86,  label = 'Bleu spinelle'},
			{index = 87,  label = 'Bleu tourmaline'},
			{index = 127, label = 'Bleu paradis 2'},
			{index = 140, label = 'Bleu chewin-gum'},
			{index = 141, label = 'Bleu nuit 2'},
			{index = 146, label = 'Bleu interdit'},
			{index = 157, label = 'Bleu glacier'}
		}
	elseif color == 'yellow' then
		colors = {
			{index = 42,  label = 'Jaune'},
			{index = 88,  label = 'Jaune blé'},
			{index = 89,  label = 'Jaune racing'},
			{index = 91,  label = 'Jaune pâle'},
			{index = 126, label = 'Jaune clair'}
		}
	elseif color == 'green' then
		colors = {
			{index = 49,  label = 'Vert foncé métallique'},
			{index = 50,  label = 'Vert rally'},
			{index = 51,  label = 'Vert pin'},
			{index = 52,  label = 'Vert olive'},
			{index = 53,  label = 'Vert clair'},
			{index = 55,  label = 'Vert citron matte'},
			{index = 56,  label = 'Vert forêt'},
			{index = 57,  label = 'Vert gazon'},
			{index = 58,  label = 'Vert impérial'},
			{index = 59,  label = 'Vert bouteille'},
			{index = 92,  label = 'Vert citron 2'},
			{index = 125, label = 'Vert anis'},
			{index = 128, label = 'Vert kaki'},
			{index = 133, label = 'Vert armée'},
			{index = 151, label = 'Vert foncé'},
			{index = 152, label = 'Vert chasseur'},
			{index = 155, label = 'Vert feuillage matte'}
		}
	elseif color == 'orange' then
		colors = {
			{index = 36,  label = 'Orange mandarine'},
			{index = 38,  label = 'Orange'},
			{index = 41,  label = 'Orange matte'},
			{index = 123, label = 'Orange clair'},
			{index = 124, label = 'Orange pêche'},
			{index = 130, label = 'Orange citrouille'},
			{index = 138, label = 'Orange lambo'}
		}
	elseif color == 'brown' then
		colors = {
			{index = 45,  label = 'Marron cuivre'},
			{index = 47,  label = 'Marron clair'},
			{index = 48,  label = 'Marron brun foncé'},
			{index = 90,  label = 'Marron bronze'},
			{index = 94,  label = 'Marron brun métallique'},
			{index = 95,  label = 'Marron expresso'},
			{index = 96,  label = 'Marron chocolat'},
			{index = 97,  label = 'Marron terre cuite'},
			{index = 98,  label = 'Marron marbre'},
			{index = 99,  label = 'Marron sable'},
			{index = 100, label = 'Marron sepia'},
			{index = 101, label = 'Marron bison'},
			{index = 102, label = 'Marron palmier'},
			{index = 103, label = 'Marron caramel'},
			{index = 104, label = 'Marron rouillé'},
			{index = 105, label = 'Marron châtaigne'},
			{index = 108, label = 'Marron brun'},
			{index = 109, label = 'Marron noisette'},
			{index = 110, label = 'Marron coquille'},
			{index = 114, label = 'Marron acajou'},
			{index = 115, label = 'Marron chaudron'},
			{index = 116, label = 'Marron blond'},
			{index = 129, label = 'Marron gravier'},
			{index = 153, label = 'Marron terre noire'},
			{index = 154, label = 'Marron désert'}
		}
	elseif color == 'purple' then
		colors = {
			{index = 71,  label = 'Violet indigo'},
			{index = 72,  label = 'Violet foncé'},
			{index = 76,  label = 'Violet foncé 2'},
			{index = 81,  label = 'Violet Améthyste'},
			{index = 142, label = 'Violet mystique'},
			{index = 145, label = 'Violet métallique'},
			{index = 148, label = 'Violet matte'},
			{index = 149, label = 'Violet foncé matte'}
		}
	elseif color == 'chrome' then
		colors = {
			{index = 117, label = 'Chrome brossé'},
			{index = 118, label = 'Chrome foncé'},
			{index = 119, label = 'Aluminium brossé'},
			{index = 120, label = 'Chrome'}
		}
	elseif color == 'gold' then
		colors = {
			{index = 37,  label = 'Or'},
			{index = 158, label = 'Or pur'},
			{index = 159, label = 'Or brossé'},
			{index = 160, label = 'Or clair'}
		}
	end

	return colors
end

function GetWindowName(index)
	if (index == 1) then
		return "Pur noir"
	elseif (index == 2) then
		return "Fumée sombre"
	elseif (index == 3) then
		return "Fumée claire"
	elseif (index == 4) then
		return "Limousine"
	elseif (index == 5) then
		return "Vert"
	else
		return "Inconnu"
	end
end

function GetHornName(index)
	if (index == -1) then
		return "Stock klaxon"
	elseif (index == 0) then
		return "Camion"
	elseif (index == 1) then
		return "Police"
	elseif (index == 2) then
		return "Clown"
	elseif (index == 3) then
		return "Musical 1"
	elseif (index == 4) then
		return "Musical 2"
	elseif (index == 5) then
		return "Musical 3"
	elseif (index == 6) then
		return "Musical 4"
	elseif (index == 7) then
		return "Musical 5"
	elseif (index == 8) then
		return "Trombone triste"
	elseif (index == 9) then
		return "Classique 1"
	elseif (index == 10) then
		return "Classique 2"
	elseif (index == 11) then
		return "Classique 3"
	elseif (index == 12) then
		return "Classique 4"
	elseif (index == 13) then
		return "Classique 5"
	elseif (index == 14) then
		return "Classique 6"
	elseif (index == 15) then
		return "Classique 7"
	elseif (index == 16) then
		return "Note - Do"
	elseif (index == 17) then
		return "Note - Re"
	elseif (index == 18) then
		return "Note - Mi"
	elseif (index == 19) then
		return "Note - Fa"
	elseif (index == 20) then
		return "Note - Sol"
	elseif (index == 21) then
		return "Note - La"
	elseif (index == 22) then
		return "Note - Ti"
	elseif (index == 23) then
		return "Note - Do"
	elseif (index == 24) then
		return "Jazz 1"
	elseif (index == 25) then
		return "Jazz 2"
	elseif (index == 26) then
		return "Jazz 3"
	elseif (index == 27) then
		return "Jazz Infini"
	elseif (index == 28) then
		return "Bannière étoilée 1"
	elseif (index == 29) then
		return "Bannière étoilée 2"
	elseif (index == 30) then
		return "Bannière étoilée3"
	elseif (index == 31) then
		return "Bannière étoilée 4"
	elseif (index == 32) then
		return "Classique 8 Infini"
	elseif (index == 33) then
		return "Classique 9 Infini"
	elseif (index == 34) then
		return "Classique 10 Infini"
	elseif (index == 35) then
		return "Classique 8"
	elseif (index == 36) then
		return "Classique 9"
	elseif (index == 37) then
		return "Classique 10"
	elseif (index == 38) then
		return "Funéraire Infini"
	elseif (index == 39) then
		return "Funéraire"
	elseif (index == 40) then
		return "Effrayant Infini"
	elseif (index == 41) then
		return "Effrayant"
	elseif (index == 42) then
		return "San Andreas Infini"
	elseif (index == 43) then
		return "San Andreas"
	elseif (index == 44) then
		return "Liberty City Infini"
	elseif (index == 45) then
		return "Liberty City"
	elseif (index == 46) then
		return "Festif 1 Infini"
	elseif (index == 47) then
		return "Festif 1"
	elseif (index == 48) then
		return "Festif 2 Infini"
	elseif (index == 49) then
		return "Festif 2"
	elseif (index == 50) then
		return "Festif 3 Infini"
	elseif (index == 51) then
		return "Festif 3"
	else
		return "Klaxon inconnu"
	end
end

function GetNeons()
	local neons = {
		{label = 'Gris', r = 128, g = 128, b = 128},
		{label = 'Rouge', r = 255, g = 0, b = 0},
		{label = 'Orange', r = 255, g = 106, b = 0},
		{label = 'Jaune', r = 255, g = 216, b = 0},
		{label = 'Vert citron', r = 182, g = 255, b = 0},
		{label = 'Vert', r = 76, g = 255, b = 0},
		{label = 'Vert radioactif', r = 0, g = 255, b = 33},
		{label = 'Vert menthe', r = 0, g = 255, b = 144},
		{label = 'Cyan', r = 0, g = 255, b = 255},
		{label = 'Bleu électrique', r = 0, g = 148, b = 255},
		{label = 'Bleu intense', r = 0, g = 38, b = 255},
		{label = 'Violet royal', r = 72, g = 0, b = 255},
		{label = 'Rose néon', r = 178, g = 0, b = 255},
		{label = 'Rose fushia', r = 255, g = 0, b = 220},
		{label = 'Rose foncé', r = 255, g = 0, b = 110},
	}

	return neons
end

local XenonColorNames = {
	[0] = 'Blanc',
	[1] = 'Bleu',
	[2] = 'Bleu éléctrique',
	[3] = 'Vert menthe',
	[4] = 'Vert citron',
	[5] = 'Jaune',
	[6] = 'Jaune orangé',
	[7] = 'Orange',
	[8] = 'Rouge',
	[9] = 'Rose clair',
  	[10] = 'Rose',
  	[11] = 'Mauve',
  	[12] = 'Ultraviolet',
}

function GetXenonColorName(index)
   	return XenonColorNames[index]
end

function GetPlatesName(index)
	if (index == 0) then
		return 'Bleu sur blanc 1'
	elseif (index == 1) then
		return 'Jaune sur noir'
	elseif (index == 2) then
		return 'Jaune bleu'
	elseif (index == 3) then
		return 'Bleu sur blanc 2'
	elseif (index == 4) then
		return 'Bleu sur blanc 2'
	end
end

cfg_mecano.vehicles = {
    {
        cat_name = "Nouveaux véhicules",
        value = "new",
        vehicles = {
            {name = "boor", hash = "boor", price = 56000},
            {name = "broadway", hash = "broadway", price = 315000},
            {name = "entity3", hash = "entity3", price = 850000},
            {name = "eudora", hash = "eudora", price = 50000},
            {name = "everon2", hash = "everon2", price = 350000},
            {name = "issi8", hash = "issi8", price = 75000},
            {name = "journey2", hash = "journey2", price = 200000},
            {name = "manchez3", hash = "manchez3", price = 35000},
            {name = "panthere", hash = "panthere", price = 175000},
            {name = "powersurge", hash = "powersurge", price = 50000},
            {name = "r300", hash = "r300", price = 250000},
            {name = "surfer3", hash = "surfer3", price = 95000},
            {name = "tahoma", hash = "tahoma", price = 70000},
            {name = "tulip2", hash = "tulip2", price = 90000},
            {name = "virtue", hash = "virtue", price = 950000},
            {name = "brioso3", hash = "brioso3", price = 55000},
            {name = "corsita", hash = "corsita", price = 550000},
            {name = "draugur", hash = "draugur", price = 520000},
            {name = "greenwood", hash = "greenwood", price = 90000},
            {name = "kanjosj", hash = "kanjosj", price = 75000},
            {name = "lm87", hash = "lm87", price = 1200000},
            {name = "omnisegt", hash = "omnisegt", price = 355000},
            {name = "postlude", hash = "postlude", price = 45000},
            {name = "rhinehart", hash = "rhinehart", price = 290000},
            {name = "ruiner4", hash = "ruiner4", price = 95000},
            {name = "sentinel4", hash = "sentinel4", price = 225000},
            {name = "sm722", hash = "sm722", price = 785000},
            {name = "tenf", hash = "tenf", price = 520000},
            {name = "tenf2", hash = "tenf2", price = 540000},
            {name = "torero2", hash = "torero2", price = 720000},
            {name = "vigero2", hash = "vigero2", price = 30000},
        },
    },
    {
        cat_name = "Compactes",
        value = "compacts",
        vehicles = {
            {name = "asbo", hash = "asbo", price = 75000},
            {name = "blista", hash = "blista", price = 60000},
            {name = "brioso", hash = "brioso", price = 100000},
            {name = "club", hash = "club", price = 100000},
            {name = "dilettante", hash = "dilettante", price = 60000},
            {name = "kanjo", hash = "kanjo", price = 100000},
            {name = "issi2", hash = "issi2", price = 60000},
            {name = "issi3", hash = "issi3", price = 70000},
            {name = "panto", hash = "panto", price = 25000},
            {name = "prairie", hash = "prairie", price = 75000},
            {name = "rhapsody", hash = "rhapsody", price = 75000},
            {name = "brioso2", hash = "brioso2", price = 100000},
            {name = "weevil", hash = "weevil", price = 100000},
        },
    },
    {
        cat_name = "Coupés",
        value = "coupes",
        vehicles = {
            {name = "cogcabrio", hash = "cogcabrio", price = 60000},
            {name = "exemplar", hash = "exemplar", price = 125000},
            {name = "f620", hash = "f620", price = 60000},
            {name = "felon", hash = "felon", price = 125000},
            {name = "felon2", hash = "felon2", price = 125000},
            {name = "jackal", hash = "jackal", price = 125000},
            {name = "oracle", hash = "oracle", price = 125000},
            {name = "oracle2", hash = "oracle2", price = 125000},
            {name = "sentinel", hash = "sentinel", price = 125000},
            {name = "sentinel2", hash = "sentinel2", price = 135000},
            {name = "windsor", hash = "windsor", price = 200000},
            {name = "windsor2", hash = "windsor2", price = 225000},
            {name = "zion", hash = "zion", price = 125000},
            {name = "zion2", hash = "zion2", price = 135000},
        },
    },
    {
        cat_name = "Vélos",
        value = "cycles",
        vehicles = {
            {name = "bmx", hash = "bmx", price = 25000},
            {name = "cruiser", hash = "cruiser", price = 25000},
            {name = "fixter", hash = "fixter", price = 25000},
            {name = "scorcher", hash = "scorcher", price = 25000},
            {name = "tribike", hash = "tribike", price = 25000},
            {name = "tribike2", hash = "tribike2", price = 25000},
            {name = "tribike3", hash = "tribike3", price = 25000},
        },
    },
    {
        cat_name = "Motos",
        value = "motorcycles",
        vehicles = {
            {name = "akuma", hash = "akuma", price = 150000},
            {name = "avarus", hash = "avarus", price = 200000},
            {name = "bagger", hash = "bagger", price = 75000},
            {name = "bati", hash = "bati", price = 200000},
            {name = "bati2", hash = "bati2", price = 250000},
            {name = "bf400", hash = "bf400", price = 300000},
            {name = "carbonrs", hash = "carbonrs", price = 100000},
            {name = "chimera", hash = "chimera", price = 225000},
            {name = "cliffhanger", hash = "cliffhanger", price = 75000},
            {name = "daemon", hash = "daemon", price = 300000},
            {name = "daemon2", hash = "daemon2", price = 350000},
            {name = "defiler", hash = "defiler", price = 125000},
            {name = "diablous", hash = "diablous", price = 100000},
            {name = "diablous2", hash = "diablous2", price = 150000},
            {name = "double", hash = "double", price = 70000},
            {name = "enduro", hash = "enduro", price = 125000},
            {name = "esskey", hash = "esskey", price = 80000},
            {name = "faggio", hash = "faggio", price = 25000},
            {name = "faggio2", hash = "faggio2", price = 30000},
            {name = "faggio3", hash = "faggio3", price = 45000},
            {name = "fcr", hash = "fcr", price = 100000},
            {name = "fcr2", hash = "fcr2", price = 105000},
            {name = "gargoyle", hash = "gargoyle", price = 210000},
            {name = "hakuchou", hash = "hakuchou", price = 175000},
            {name = "hakuchou2", hash = "hakuchou2", price = 230000},
            {name = "hexer", hash = "hexer", price = 165000},
            {name = "innovation", hash = "innovation", price = 240000},
            {name = "lectro", hash = "lectro", price = 150000},
            {name = "manchez", hash = "manchez", price = 160000},
            {name = "nemesis", hash = "nemesis", price = 150000},
            {name = "nightblade", hash = "nightblade", price = 425000},
            {name = "pcj", hash = "pcj", price = 70000},
            {name = "ratbike", hash = "ratbike", price = 70000},
            {name = "ruffian", hash = "ruffian", price = 110000},
            {name = "rrocket", hash = "rrocket", price = 495000},
            {name = "sanchez", hash = "sanchez", price = 150000},
            {name = "sanchez2", hash = "sanchez2", price = 195000},
            {name = "sanctus", hash = "sanctus", price = 780000},
            {name = "sovereign", hash = "sovereign", price = 300000},
            {name = "stryder", hash = "stryder", price = 250000},
            {name = "thrust", hash = "thrust", price = 140000},
            {name = "vader", hash = "vader", price = 50000},
            {name = "vindicator", hash = "vindicator", price = 95000},
            {name = "vortex", hash = "vortex", price = 100000},
            {name = "wolfsbane", hash = "wolfsbane", price = 115000},
            {name = "zombiea", hash = "zombiea", price = 225000},
            {name = "zombieb", hash = "zombieb", price = 270000},
            {name = "manchez2", hash = "manchez2", price = 190000},
        },
    },
    {
        cat_name = "Muscle Car",
        value = "muscle",
        vehicles = {
            {name = "blade", hash = "blade", price = 125000},
            {name = "buccaneer", hash = "buccaneer", price = 125000},
            {name = "buccaneer2", hash = "buccaneer2", price = 145000},
            {name = "chino", hash = "chino", price = 125000},
            {name = "chino2", hash = "chino2", price = 145000},
            {name = "clique", hash = "clique", price = 125000},
            {name = "coquette3", hash = "coquette3", price = 125000},
            {name = "deviant", hash = "deviant", price = 145000},
            {name = "dominator", hash = "dominator", price = 155000},
            {name = "dominator2", hash = "dominator2", price = 225000},
            {name = "dominator3", hash = "dominator3", price = 325000},
            {name = "dukes", hash = "dukes", price = 145000},
            {name = "faction", hash = "faction", price = 125000},
            {name = "faction2", hash = "faction2", price = 155000},
            {name = "faction3", hash = "faction3", price = 225000},
            {name = "ellie", hash = "ellie", price = 135000},
            {name = "gauntlet", hash = "gauntlet", price = 135000},
            {name = "gauntlet2", hash = "gauntlet2", price = 155000},
            {name = "gauntlet3", hash = "gauntlet3", price = 185000},
            {name = "gauntlet4", hash = "gauntlet4", price = 225000},
            {name = "gauntlet5", hash = "gauntlet5", price = 275000},
            {name = "hermes", hash = "hermes", price = 175000},
            {name = "hotknife", hash = "hotknife", price = 135000},
            {name = "hustler", hash = "hustler", price = 135000},
            {name = "impaler", hash = "impaler", price = 135000},
            {name = "lurcher", hash = "lurcher", price = 135000},
            {name = "moonbeam", hash = "moonbeam", price = 135000},
            {name = "moonbeam2", hash = "moonbeam2", price = 235000},
            {name = "nightshade", hash = "nightshade", price = 225000},
            {name = "peyote2", hash = "peyote2", price = 235000},
            {name = "phoenix", hash = "phoenix", price = 135000},
            {name = "picador", hash = "picador", price = 135000},
            {name = "ratloader", hash = "ratloader", price = 135000},
            {name = "ratloader2", hash = "ratloader2", price = 235000},
            {name = "ruiner", hash = "ruiner", price = 235000},
            {name = "sabregt", hash = "sabregt", price = 235000},
            {name = "sabregt2", hash = "sabregt2", price = 255000},
            {name = "slamvan", hash = "slamvan", price = 135000},
            {name = "slamvan2", hash = "slamvan2", price = 175000},
            {name = "slamvan3", hash = "slamvan3", price = 235000},
            {name = "stalion", hash = "stalion", price = 155000},
            {name = "stalion2", hash = "stalion2", price = 235000},
            {name = "tampa", hash = "tampa", price = 135000},
            {name = "vigero", hash = "vigero", price = 135000},
            {name = "virgo", hash = "virgo", price = 135000},
            {name = "virgo2", hash = "virgo2", price = 175000},
            {name = "virgo3", hash = "virgo3", price = 235000},
            {name = "voodoo", hash = "voodoo", price = 175000},
            {name = "voodoo2", hash = "voodoo2", price = 135000},
            {name = "yosemite", hash = "yosemite", price = 155000},
            {name = "yosemite2", hash = "yosemite2", price = 235000},
            {name = "yosemite3", hash = "yosemite3", price = 135000},
        },
    },
    {
        cat_name = "Off-Road",
        value = "off-road",
        vehicles = {
            {name = "outlaw", hash = "outlaw", price = 350000},
            {name = "bfinjection", hash = "bfinjection", price = 150000},
            {name = "bifta", hash = "bifta", price = 150000},
            {name = "blazer", hash = "blazer", price = 75000},
            {name = "blazer3", hash = "blazer3", price = 125000},
            {name = "blazer4", hash = "blazer4", price = 150000},
            {name = "bodhi2", hash = "bodhi2", price = 125000},
            {name = "brawler", hash = "brawler", price = 720000},
            {name = "caracara2", hash = "caracara2", price = 750000},
            {name = "dloader", hash = "dloader", price = 150000},
            {name = "dubsta3", hash = "dubsta3", price = 760000},
            {name = "dune", hash = "dune", price = 175000},
            {name = "everon", hash = "everon", price = 550000},
            {name = "guardian", hash = "guardian", price = 1250000},
            {name = "hellion", hash = "hellion", price = 350000},
            {name = "kalahari", hash = "kalahari", price = 125000},
            {name = "kamacho", hash = "kamacho", price = 2250000},
            {name = "rancherxl", hash = "rancherxl", price = 150000},
            {name = "rebel", hash = "rebel", price = 175000},
            {name = "rebel2", hash = "rebel2", price = 195000},
            {name = "riata", hash = "riata", price = 350000},
            {name = "sandking", hash = "sandking", price = 350000},
            {name = "sandking2", hash = "sandking2", price = 550000},
            {name = "trophytruck", hash = "trophytruck", price = 650000},
            {name = "trophytruck2", hash = "trophytruck2", price = 750000},
            {name = "vagrant", hash = "vagrant", price = 250000},
            {name = "verus", hash = "verus", price = 150000},
            {name = "winky", hash = "winky", price = 225000},
        },
    },
    {
        cat_name = "SUVs",
        value = "suvs",
        vehicles = {
            {name = "baller", hash = "baller", price = 150000},
            {name = "baller2", hash = "baller2", price = 225000},
            {name = "baller3", hash = "baller3", price = 300000},
            {name = "baller4", hash = "baller4", price = 550000},
            {name = "bjxl", hash = "bjxl", price = 150000},
            {name = "cavalcade", hash = "cavalcade", price = 150000},
            {name = "cavalcade2", hash = "cavalcade2", price = 175000},
            {name = "contender", hash = "contender", price = 350000},
            {name = "dubsta", hash = "dubsta", price = 225000},
            {name = "dubsta2", hash = "dubsta2", price = 325000},
            {name = "granger", hash = "granger", price = 450000},
            {name = "fq2", hash = "fq2", price = 250000},
            {name = "gresley", hash = "gresley", price = 225000},
            {name = "habanero", hash = "habanero", price = 225000},
            {name = "huntley", hash = "huntley", price = 250000},
            {name = "landstalker", hash = "landstalker", price = 225000},
            {name = "landstalker2", hash = "landstalker2", price = 350000},
            {name = "mesa", hash = "mesa", price = 250000},
            {name = "novak", hash = "novak", price = 350000},
            {name = "patriot", hash = "patriot", price = 450000},
            {name = "patriot2", hash = "patriot2", price = 1200000},
            {name = "radi", hash = "radi", price = 225000},
            {name = "rebla", hash = "rebla", price = 1225000},
            {name = "rocoto", hash = "rocoto", price = 650000},
            {name = "seminole", hash = "seminole", price = 375000},
            {name = "seminole2", hash = "seminole2", price = 450000},
            {name = "serrano", hash = "serrano", price = 225000},
            {name = "toros", hash = "toros", price = 750000},
            {name = "xls", hash = "xls", price = 350000},
            {name = "squaddie", hash = "squaddie", price = 650000},
        },
    },
    {
        cat_name = "Berlines",
        value = "sedans",
        vehicles = {
            {name = "asea", hash = "asea", price = 150000},
            {name = "asterope", hash = "asterope", price = 160000},
            {name = "cog55", hash = "cog55", price = 220000},
            {name = "cognoscenti", hash = "cognoscenti", price = 225000},
            {name = "emperor", hash = "emperor", price = 150000},
            {name = "emperor2", hash = "emperor2", price = 145000},
            {name = "fugitive", hash = "fugitive", price = 160000},
            {name = "glendale", hash = "glendale", price = 145000},
            {name = "glendale2", hash = "glendale2", price = 160000},
            {name = "ingot", hash = "ingot", price = 145000},
            {name = "intruder", hash = "intruder", price = 160000},
            {name = "premier", hash = "premier", price = 150000},
            {name = "primo", hash = "primo", price = 175000},
            {name = "primo2", hash = "primo2", price = 250000},
            {name = "regina", hash = "regina", price = 150000},
            {name = "romero", hash = "romero", price = 350000},
            {name = "stafford", hash = "stafford", price = 275000},
            {name = "stanier", hash = "stanier", price = 150000},
            {name = "stratum", hash = "stratum", price = 175000},
            {name = "stretch", hash = "stretch", price = 650000},
            {name = "superd", hash = "superd", price = 350000},
            {name = "surge", hash = "surge", price = 175000},
            {name = "tailgater", hash = "tailgater", price = 180000},
            {name = "tailgater2", hash = "tailgater2", price = 380000},
            {name = "warrener", hash = "warrener", price = 225000},
            {name = "washington", hash = "washington", price = 250000},
        },
    },
    {
        cat_name = "Sportives",
        value = "sports",
        vehicles = {
            {name = "alpha", hash = "alpha", price = 425000},
            {name = "banshee", hash = "banshee", price = 625000},
            {name = "bestiagts", hash = "bestiagts", price = 750000},
            {name = "blista2", hash = "blista2", price = 375000},
            {name = "blista3", hash = "blista3", price = 425000},
            {name = "buffalo", hash = "buffalo", price = 425000},
            {name = "buffalo2", hash = "buffalo2", price = 550000},
            {name = "buffalo3", hash = "buffalo3", price = 625000},
            {name = "carbonizzare", hash = "carbonizzare", price = 625000},
            {name = "comet2", hash = "comet2", price = 625000},
            {name = "comet3", hash = "comet3", price = 675000},
            {name = "comet4", hash = "comet4", price = 675000},
            {name = "comet5", hash = "comet5", price = 625000},
            {name = "coquette", hash = "coquette", price = 625000},
            {name = "coquette4", hash = "coquette4", price = 675000},
            {name = "drafter", hash = "drafter", price = 625000},
            {name = "deveste", hash = "deveste", price = 825000},
            {name = "elegy", hash = "elegy", price = 725000},
            {name = "elegy2", hash = "elegy2", price = 775000},
            {name = "feltzer2", hash = "feltzer2", price = 625000},
            {name = "flashgt", hash = "flashgt", price = 425000},
            {name = "furoregt", hash = "furoregt", price = 625000},
            {name = "fusilade", hash = "fusilade", price = 425000},
            {name = "futo", hash = "futo", price = 425000},
            {name = "gb200", hash = "gb200", price = 625000},
            {name = "hotring", hash = "hotring", price = 1050000},
            {name = "komoda", hash = "komoda", price = 725000},
            {name = "imorgon", hash = "imorgon", price = 750000},
            {name = "issi7", hash = "issi7", price = 475000},
            {name = "italigto", hash = "italigto", price = 865000},
            {name = "jugular", hash = "jugular", price = 850000},
            {name = "jester", hash = "jester", price = 675000},
            {name = "jester2", hash = "jester2", price = 875000},
            {name = "jester3", hash = "jester3", price = 675000},
            {name = "khamelion", hash = "khamelion", price = 575000},
            {name = "kuruma", hash = "kuruma", price = 850000},
            {name = "locust", hash = "locust", price = 575000},
            {name = "lynx", hash = "lynx", price = 595000},
            {name = "massacro", hash = "massacro", price = 625000},
            {name = "massacro2", hash = "massacro2", price = 750000},
            {name = "neo", hash = "neo", price = 775000},
            {name = "neon", hash = "neon", price = 825000},
            {name = "ninef", hash = "ninef", price = 750000},
            {name = "ninef2", hash = "ninef2", price = 800000},
            {name = "omnis", hash = "omnis", price = 775000},
            {name = "paragon", hash = "paragon", price = 775000},
            {name = "pariah", hash = "pariah", price = 850000},
            {name = "penumbra", hash = "penumbra", price = 625000},
            {name = "penumbra2", hash = "penumbra2", price = 750000},
            {name = "raiden", hash = "raiden", price = 725000},
            {name = "rapidgt", hash = "rapidgt", price = 675000},
            {name = "rapidgt2", hash = "rapidgt2", price = 700000},
            {name = "raptor", hash = "raptor", price = 425000},
            {name = "revolter", hash = "revolter", price = 475000},
            {name = "ruston", hash = "ruston", price = 450000},
            {name = "schafter2", hash = "schafter2", price = 425000},
            {name = "schafter3", hash = "schafter3", price = 575000},
            {name = "schafter4", hash = "schafter4", price = 750000},
            {name = "schlagen", hash = "schlagen", price = 775000},
            {name = "schwarzer", hash = "schwarzer", price = 675000},
            {name = "sentinel3", hash = "sentinel3", price = 625000},
            {name = "seven70", hash = "seven70", price = 775000},
            {name = "specter", hash = "specter", price = 675000},
            {name = "specter2", hash = "specter2", price = 750000},
            {name = "streiter", hash = "streiter", price = 475000},
            {name = "sugoi", hash = "sugoi", price = 625000},
            {name = "sultan", hash = "sultan", price = 650000},
            {name = "sultan2", hash = "sultan2", price = 750000},
            {name = "surano", hash = "surano", price = 750000},
            {name = "tampa2", hash = "tampa2", price = 1100000},
            {name = "tropos", hash = "tropos", price = 725000},
            {name = "verlierer2", hash = "verlierer2", price = 575000},
            {name = "vstr", hash = "vstr", price = 675000},
            {name = "italirsx", hash = "italirsx", price = 775000},
        },
    },
    {
        cat_name = "Classiques",
        value = "classic",
        vehicles = {
            {name = "btype", hash = "btype", price = 375000},
            {name = "btype2", hash = "btype2", price = 425000},
            {name = "btype3", hash = "btype3", price = 400000},
            {name = "casco", hash = "casco", price = 350000},
            {name = "cheetah2", hash = "cheetah2", price = 450000},
            {name = "coquette2", hash = "coquette2", price = 450000},
            {name = "dynasty", hash = "dynasty", price = 305000},
            {name = "fagaloa", hash = "fagaloa", price = 225000},
            {name = "feltzer3", hash = "feltzer3", price = 425000},
            {name = "gt500", hash = "gt500", price = 405000},
            {name = "infernus2", hash = "infernus2", price = 525000},
            {name = "jb7002", hash = "jb7002", price = 475000},
            {name = "mamba", hash = "mamba", price = 425000},
            {name = "manana", hash = "manana", price = 375000},
            {name = "manana2", hash = "manana2", price = 375000},
            {name = "michelli", hash = "michelli", price = 345000},
            {name = "monroe", hash = "monroe", price = 450000},
            {name = "nebula", hash = "nebula", price = 525000},
            {name = "peyote", hash = "peyote", price = 375000},
            {name = "peyote3", hash = "peyote3", price = 425000},
            {name = "pigalle", hash = "pigalle", price = 325000},
            {name = "rapidgt3", hash = "rapidgt3", price = 450000},
            {name = "retinue", hash = "retinue", price = 350000},
            {name = "retinue2", hash = "retinue2", price = 400000},
            {name = "savestra", hash = "savestra", price = 375000},
            {name = "stinger", hash = "stinger", price = 425000},
            {name = "stingergt", hash = "stingergt", price = 450000},
            {name = "swinger", hash = "swinger", price = 525000},
            {name = "torero", hash = "torero", price = 475000},
            {name = "tornado", hash = "tornado", price = 375000},
            {name = "tornado2", hash = "tornado2", price = 400000},
            {name = "tornado3", hash = "tornado3", price = 350000},
            {name = "tornado4", hash = "tornado4", price = 325000},
            {name = "tornado5", hash = "tornado5", price = 350000},
            {name = "tornado6", hash = "tornado6", price = 450000},
            {name = "turismo2", hash = "turismo2", price = 625000},
            {name = "viseris", hash = "viseris", price = 575000},
            {name = "z190", hash = "z190", price = 425000},
            {name = "ztype", hash = "ztype", price = 995000},
            {name = "zion3", hash = "zion3", price = 525000},
            {name = "cheburek", hash = "cheburek", price = 345000},
        },
    },
    {
        cat_name = "Super-Sportives",
        value = "super",
        vehicles = {
            {name = "adder", hash = "adder", price = 725000},
            {name = "autarch", hash = "autarch", price = 925000},
            {name = "banshee2", hash = "banshee2", price = 750000},
            {name = "bullet", hash = "bullet", price = 725000},
            {name = "cheetah", hash = "cheetah", price = 875000},
            {name = "cyclone", hash = "cyclone", price = 705000},
            {name = "entity2", hash = "entity2", price = 825000},
            {name = "entityxf", hash = "entityxf", price = 850000},
            {name = "emerus", hash = "emerus", price = 950000},
            {name = "fmj", hash = "fmj", price = 875000},
            {name = "furia", hash = "furia", price = 725000},
            {name = "gp1", hash = "gp1", price = 725000},
            {name = "infernus", hash = "infernus", price = 655000},
            {name = "italigtb", hash = "italigtb", price = 705000},
            {name = "italigtb2", hash = "italigtb2", price = 775000},
            {name = "krieger", hash = "krieger", price = 800000},
            {name = "le7b", hash = "le7b", price = 850000},
            {name = "nero", hash = "nero", price = 875000},
            {name = "nero2", hash = "nero2", price = 950000},
            {name = "osiris", hash = "osiris", price = 775000},
            {name = "penetrator", hash = "penetrator", price = 675000},
            {name = "pfister811", hash = "pfister811", price = 850000},
            {name = "prototipo", hash = "prototipo", price = 1100000},
            {name = "reaper", hash = "reaper", price = 775000},
            {name = "s80", hash = "s80", price = 825000},
            {name = "sc1", hash = "sc1", price = 725000},
            {name = "sheava", hash = "sheava", price = 675000},
            {name = "sultanrs", hash = "sultanrs", price = 850000},
            {name = "t20", hash = "t20", price = 725000},
            {name = "taipan", hash = "taipan", price = 775000},
            {name = "tempesta", hash = "tempesta", price = 725000},
            {name = "tezeract", hash = "tezeract", price = 1105000},
            {name = "thrax", hash = "thrax", price = 1200000},
            {name = "tigon", hash = "tigon", price = 775000},
            {name = "turismor", hash = "turismor", price = 775000},
            {name = "tyrant", hash = "tyrant", price = 775000},
            {name = "tyrus", hash = "tyrus", price = 825000},
            {name = "vacca", hash = "vacca", price = 675000},
            {name = "vagner", hash = "vagner", price = 755000},
            {name = "visione", hash = "visione", price = 775000},
            {name = "voltic", hash = "voltic", price = 650000},
            {name = "xa21", hash = "xa21", price = 725000},
            {name = "zorrusso", hash = "zorrusso", price = 675000},
        },
    },
    {
        cat_name = "Vans",
        value = "vans",
        vehicles = {
            {name = "benson", hash = "benson", price = 500000},
            {name = "mule", hash = "mule", price = 500000},
            {name = "bison", hash = "bison", price = 150000},
            {name = "bison2", hash = "bison2", price = 175000},
            {name = "bison3", hash = "bison3", price = 200000},
            {name = "bobcatxl", hash = "bobcatxl", price = 150000},
            {name = "burrito3", hash = "burrito3", price = 225000},
            {name = "camper", hash = "camper", price = 250000},
            {name = "gburrito", hash = "gburrito", price = 325000},
            {name = "gburrito2", hash = "gburrito2", price = 325000},
            {name = "journey", hash = "journey", price = 200000},
            {name = "minivan", hash = "minivan", price = 125000},
            {name = "minivan2", hash = "minivan2", price = 250000},
            {name = "paradise", hash = "paradise", price = 150000},
            {name = "pony", hash = "pony", price = 150000},
            {name = "pony2", hash = "pony2", price = 160000},
            {name = "rumpo", hash = "rumpo", price = 150000},
            {name = "rumpo2", hash = "rumpo2", price = 200000},
            {name = "rumpo3", hash = "rumpo3", price = 525000},
            {name = "speedo", hash = "speedo", price = 150000},
            {name = "speedo4", hash = "speedo4", price = 200000},
            {name = "surfer", hash = "surfer", price = 225000},
            {name = "surfer2", hash = "surfer2", price = 200000},
            {name = "youga", hash = "youga", price = 150000},
            {name = "youga2", hash = "youga2", price = 225000},
            {name = "youga3", hash = "youga3", price = 350000},
        },
    },
}
