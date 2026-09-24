jobs = {
     {
          metier = "beachclub",
          metierLabel = "Beach Club",
          plate = "BEA-",

          bar_on = true,
          bar = {
               coords = vector3(-2057.3811035156, -549.45062255859, 9.9573179245),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "chips", item = "chips"},
               },
          },

          grill_on = false,
          grill = {
               coords = vector3(-2054.7763671875, -547.73016357422, 9.9573179245),
               items = {
                    {name = "chips", item = "chips"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-2053.7583007812, -544.71185302734, 9.957315063477),

          vestiaire_on = true,
          vestiaire_coords = vector3(-2043.7298583984, -547.04040527344, 9.9573179245),

          bossmenu_on = true,
          bossmenu_coords = vector3(-2053.2663574219, -536.01672363281, 9.957315063477),

          blips_on = true,
          blips = {
               coords = vector3(-2038.4075927734, -531.52996826172, 9.945488548279),
               colorBase = "~p~",
               colorBlip = 48,
               blipSprite = 836,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-2029.1459960938, -496.55178833008, 10.770776367188),
               garage_spawn = {
                    {pos = vector3(-2023.7678222656, -487.56283569336, 11.699734687805), heading = 318.19,},
                    {pos = vector3(-2026.1680908203, -485.65277099609, 11.699123382568), heading = 314.41,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-2017.4086914062, -492.69958496094, 10.789960479736),

          message = {
               openingMessage = "Le Beach Club est ouvert, lâchez prise et venez vous amuser !",
               closingMessage = "Le Beach Club est fermé !",
               recruitMessage = "Le Beach Club recrute, venez postuler sur place !",
               name = "Beach Club",
               char = "CHAR_BEACHCLUB",
          },
     },
     {
          metier = "kebab",
          metierLabel = "Kebab",
          plate = "KEB-",

          bar_on = true,
          bar = {
               coords = vector3(-829.872620, -112.442963, 36.682237),
               items = {
                    {name = "Ayran", item = "ayran"},
                    {name = "Thé", item = "the"},
                    {name = "Cola", item = "coca"},
                    {name = "Blue Bull", item = "bluebull"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-822.960205, -112.220680, 36.682226),
               items = {
                    {name = "Sandwich Kebab", item = "sandkebab"},
                    {name = "Assiette Kebab", item = "assiettekebab"},
                    {name = "Adana Kebab", item = "adana"},
                    {name = "Sandwich Falafel", item = "sandfalafel"},
                    {name = "Pidé", item = "pide"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-828.006897, -109.055443, 36.682760),

          vestiaire_on = true,
          vestiaire_coords = vector3(-832.377380, -110.702644, 36.682657),

          bossmenu_on = true,
          bossmenu_coords = vector3(-827.097412, -118.552345, 36.686102),

          blips_on = true,
          blips = {
               coords = vector3(-816.808472, -107.783195, 36.682077),
               colorBase = "~o~",
               colorBlip = 50,
               blipSprite = 674,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "gbvoyagerb",
                    "nspeedo",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-843.173523, -108.821930, 36.968591),
               garage_spawn = {
                    {pos = vector3(-833.278503, -99.553917, 37.763878), heading = 293.0,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-833.278503, -99.553368, 36.863992),

          message = {
               openingMessage = "Le Turko Kebab est ouvert, venez manger !",
               closingMessage = "Le Turko Kebab est fermé !",
               name = "Turko Kebab",
               char = "CHAR_KEBAB",
          },
     },
     {
          metier = "ltdsud",
          metierLabel = "LTD Sud",
          plate = "LTD-",

          shop = {
               enabled = true,

               pos = vector3(-705.93286132812, -913.99615478516, 18.315591430664),

               items = {
                    {name = "Cahier de notes", item = "cahier", price = 25000},
                    {name = "Sandwich Thon", item = "thonsand", price = 50},
                    {name = "Sandwich Poulet", item = "poulsand", price = 50},
                    {name = "Sandwich Saumon", item = "saumsand", price = 50},
                    {name = "Eau", item = "eau", price = 30},
                    {name = "Chips", item = "chips", price = 30},
                    {name = "Cola", item = "coca", price = 30},
                    {name = "Barre de chocolat", item = "chocolat", price = 30},
                    {name = "Glace", item = "glace", price = 30},
                    {name = "Donut", item = "donut", price = 30},
                    {name = "Nouilles", item = "nouilles", price = 30},
                    {name = "Canne à pêche", item = "canne", price = 1000},
                    {name = "Appât", item = "appat", price = 100},
                    {name = "Téléphone", item = "classic_phone", price = 500},
                    {name = "Radio", item = "radio", price = 1000},
                    {name = "Voiture téléguidée", item = "rc", price = 8000},
                    {name = "Rollers", item = "roller", price = 1500},
                    {name = "Gants", item = "gants", price = 1500},
                    {name = "Chaise verte", item = "chaiseverte", price = 750},
                    {name = "Chaise bleue", item = "chaisebleue", price = 750},
                    {name = "Tenue de plongée", item = "plongee", price = 2000},
                    {name = "Jumelles", item = "jumelles", price = 1000},
                    {name = "Parachute", item = "parachute", price = 2000},
                    {name = "Feu d'artifice starburst", item = "starburst", price = 5000},
                    {name = "Feu d'artifice shotburst", item = "shotburst", price = 5000},
                    {name = "Feu d'artifice fountain", item = "fountain", price = 5000},
                    {name = "Feu d'artifice trailburst", item = "trailburst", price = 5000},
                    {name = "Dissolvant", item = "spray_remover", price = 1000},
                    {name = "Coyote", item = "coyote", price = 2000},
                    {name = "Brouilleur", item = "brouilleur", price = 5000},
                    {name = "Drone", item = "drone", price = 10000},
                    {name = "BMX", item = "bmx", price = 1000},
                    {name = "Skateboard", item = "skateboard", price = 750},
                    {name = "Ciseau", item = "ciseau", price = 500},
                    {name = "Ticket à gratter", item = "scratch_ticket", price = 25000},
                    {name = "Bidon d'essence", item = "WEAPON_PETROLCAN", price = 2000},
                    {name = "Paquet de clopes", item = "paquet_clopes", price = 1500},
                    {name = "Bombe de peinture", item = "bombepeinture", price = 9500},
                    {name = "Bombe de peinture rare", item = "bombepeinturerare", price = 18500},
                    {name = "Trousse de makeup", item = "makeup_box", price = 9500},
                    {name = "Arrosoir", item = "watering_can", price = 50},
		          {name = "Pot de Weed Vert", item = "weed_pot_green", price = 15000},
		          {name = "Pot de Weed Bleu", item = "weed_pot_blu", price = 75000},
		          {name = "Pot de Weed Violet", item = "weed_pot_purp", price = 175000},
                    {name = "Ballon vide", item = "balloon_empty", price = 5000},
                    {name = "Ballon de propane", item = "propane_balloon", price = 65000}
               },
          },

          craft = {
               enabled = false,

               pos = vector3(24.741363525391, -1339.2445068359, 29.497024536133),

               items = {
                    {name = "Rhum", item = "rhum", count = 1, need = 5},
                    {name = "Vin", item = "vine", count = 1, need = 5},
                    {name = "Bière", item = "biere", count = 1, need = 5},
               },
          },

          bar_on = false,
          bar = {
               coords = vector3(-1376.3955078125, -600.92999267578, 29.316672897339),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
               },
          },

          grill_on = false,
          grill = {
               coords = vector3(-1404.019, -599.5892, 29.41997),
               items = {
                    {name = "burger", item = "burger"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-705.72100830078, -904.92901611328, 18.315591430664),

          vestiaire_on = true,
          vestiaire_coords = vector3(-702.88494873047, -917.15228271484, 18.314139938354),

          bossmenu_on = true,
          bossmenu_coords = vector3(-709.35052490234, -905.35119628906, 18.31560859680),

          blips_on = true,
          blips = {
               coords = vector3(-711.08953857422, -912.07153320312, 18.315587615967),
               colorBase = "~o~",
               colorBlip = 27,
               blipSprite = 59,
          },

          colorBase = "~g~",

          garage_on = true,
          garage = {
               vehicles = {
                    "nspeedo",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-727.21740722656, -909.12005615234, 18.113961791992),
               garage_spawn = {
                    {pos = vector3(-730.58099365234, -912.31365966797, 19.060010910034), heading = 177.576309204102,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-730.67150878906, -909.28704833984, 18.137401199341),

          message = {
               openingMessage = "Le LTD Sud est ouvert !",
               closingMessage = "Le LTD Sud est fermé !",
               name = "LTD Sud",
               char = "CHAR_LTD",
          },
     },
     {
          metier = "unicorn",
          metierLabel = "Vanille Unicorn",
          plate = "UNI-",

          bar_on = true,
          bar = {
               coords = vector3(112.4285, -1282.081, 28.70883),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Blue Bull", item = "bluebull"},

               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-1404.019, -599.5892, 29.41997),
               items = {
                    {name = "Kebab", item = "kebab"},
                    {name = "French Tacos", item = "frenchtacos"},
                    {name = "Club Sandwich", item = "clubsand"},
                    {name = "Cacahuètes", item = "cacahuetes"},
                    {name = "Bol de fruits", item = "bolfruit"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(98.8951, -1286.813, 28.30894),

          vestiaire_on = true,
          vestiaire_coords = vector3(100.1794, -1302.3, 28.30894),

          bossmenu_on = true,
          bossmenu_coords = vector3(98.51255, -1297.716, 34.70487),

          blips_on = true,
          blips = {
               coords = vector3(98.51255, -1297.716, 34.70487),
               colorBase = "~p~",
               colorBlip = 8,
               blipSprite = 279,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "vstretch",
                    "stretch",
                    "patriot2",
                    "pbus2",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(83.24092, -1281.563, 28.30092),
               garage_spawn = {
                    {pos = vector3(83.24092, -1281.563, 29.19092), heading = 280.84,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(88.84455, -1287.626, 28.42232),

          message = {
               openingMessage = "Le Vanille Unicorn est ouvert, venez en boîte !",
               closingMessage = "Le Vanille Unicorn est fermé !",
               name = "Unicorn",
               char = "CHAR_MP_STRIPCLUB_PR",
          },
     },
     {
          metier = "bahamas",
          metierLabel = "Bahamas",
          plate = "BAH-",

          bar_on = true,
          bar = {
               coords = vector3(-1376.3955078125, -600.92999267578, 29.316672897339),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Cocktail", item = "cocktail"},
                    {name = "Blue Bull", item = "bluebull"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-1380.3815917969, -591.74359130859, 29.316449737549),
               items = {
                    {name = "Kebab", item = "kebab"},
                    {name = "French Tacos", item = "frenchtacos"},
                    {name = "Club Sandwich", item = "clubsand"},
                    {name = "Cacahuètes", item = "cacahuetes"},
                    {name = "Bol de fruits", item = "bolfruit"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-1377.2138671875, -595.97998046875, 29.316461181641),

          vestiaire_on = true,
          vestiaire_coords = vector3(-1381.709, -626.0456, 29.30892),

          bossmenu_on = true,
          bossmenu_coords = vector3(-1376.642, -621.9169, 34.9962),

          blips_on = true,
          blips = {
               coords = vector3(-1376.642, -621.9169, 35.8962),
               colorBase = "~o~",
               colorBlip = 27,
               blipSprite = 93,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "vstretch",
                    "stretch",
                    "patriot2",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-1381.2692871094, -640.19805908203, 27.773616409302),
               garage_spawn = {
                    {pos = vector3(-1375.1605224609, -645.61102294922, 28.673616409302), heading = 213.84,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-1404.396, -634.5854, 27.72376),

          message = {
               openingMessage = "Le Bahamas est ouvert, venez en boîte !",
               closingMessage = "Le Bahamas est fermé !",
               name = "Bahamas",
               char = "CHAR_BAHAMAS",
          },
     },
     {
          metier = "galaxy",
          metierLabel = "Galaxy",
          plate = "GLX-",

          bar_on = true,
          bar = {
               coords = vector3(358.0436, 280.8132, 93.25115),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Cocktail", item = "cocktail"},
                    {name = "Blue Bull", item = "bluebull"},

               },
          },

          grill_on = false,
          grill = {
               coords = vector3(-1404.019, -599.5892, 29.41997),
               items = {
                    {name = "burger", item = "burger"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(379.3941, 259.3889, 91.19),

          vestiaire_on = true,
          vestiaire_coords = vector3(393.3523, 278.5354, 94.05104),

          bossmenu_on = true,
          bossmenu_coords = vector3(389.8086, 272.3098, 94.05104),

          blips_on = true,
          blips = {
               coords = vector3(379.3941, 259.3889, 91.19),
               colorBase = "~o~",
               colorBlip = 1,
               blipSprite = 304,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "vstretch",
                    "stretch",
                    "patriot2",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(378.2158, 255.8848, 101.9941),
               garage_spawn = {
                    {pos = vector3(323.5439, 263.7807, 103.4079), heading = 270.41,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(308.0403, 262.7084, 104.1503),

          message = {
               openingMessage = "Le Galaxy est ouvert, venez en boîte !",
               closingMessage = "Le Galaxy est fermé !",
               name = "Galaxy",
               char = "CHAR_GALAXY",
          },
     },
     {
          metier = "tequilala",
          metierLabel = "Tequilala",
          plate = "TEQ-",

          bar_on = true,
          bar = {
               coords = vector3(-561.8183, 285.8414, 81.17635),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Cocktail", item = "cocktail"},
                    {name = "Blue Bull", item = "bluebull"},

               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-565.1982, 286.3598, 84.37772),
               items = {
                    {name = "Kebab", item = "kebab"},
                    {name = "French Tacos", item = "frenchtacos"},
                    {name = "Club Sandwich", item = "clubsand"},
                    {name = "Cacahuètes", item = "cacahuetes"},
                    {name = "Bol de fruits", item = "bolfruit"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-568.588, 291.6301, 78.17658),

          vestiaire_on = true,
          vestiaire_coords = vector3(-566.2521, 279.8317, 81.97557),

          bossmenu_on = true,
          bossmenu_coords = vector3(-576.3709, 286.7379, 78.1766),

          blips_on = true,
          blips = {
               coords = vector3(-576.3709, 286.7379, 78.1766),
               colorBase = "~o~",
               colorBlip = 1,
               blipSprite = 304,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "vstretch",
                    "stretch",
                    "patriot2",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-549.946, 304.8101, 82.25656),
               garage_spawn = {
                    {pos = vector3(-556.3206, 302.3421, 82.21943), heading = 267.8,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-552.6343, 308.5224, 82.20474),

          message = {
               openingMessage = "Le Tequilala est ouvert, venez en boîte !",
               closingMessage = "Le Tequilala est fermé !",
               name = "Tequilala",
               char = "CHAR_PROPERTY_BAR_TEQUILALA",
          },
     },
     {
          metier = "yellowjack",
          metierLabel = "Yellow Jack",
          plate = "YEL-",

          bar_on = true,
          bar = {
               coords = vector3(1986.874146, 3045.458496, 46.315679),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Cocktail", item = "cocktail"},
                    {name = "Blue Bull", item = "bluebull"},

               },
          },

          grill_on = true,
          grill = {
               coords = vector3(1981.977051, 3053.872559, 46.315679),
               items = {
                    {name = "Kebab", item = "kebab"},
                    {name = "French Tacos", item = "frenchtacos"},
                    {name = "Club Sandwich", item = "clubsand"},
                    {name = "Cacahuètes", item = "cacahuetes"},
                    {name = "Bol de fruits", item = "bolfruit"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(1977.246948, 3055.065918, 46.315679),

          vestiaire_on = true,
          vestiaire_coords = vector3(2002.610840, 3044.748535, 49.993188),

          bossmenu_on = true,
          bossmenu_coords = vector3(1988.899170, 3043.591553, 49.993188),

          blips_on = true,
          blips = {
               coords = vector3(1995.85, 3043.817, 49.51479),
               colorBase = "~o~",
               colorBlip = 1,
               blipSprite = 304,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "vstretch",
                    "stretch",
                    "patriot2",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(1991.197510, 3038.975830, 46.144170),
               garage_spawn = {
                    {pos = vector3(1982.687866, 3035.373047, 47.056347), heading = 58.8,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(1997.812988, 3033.045166, 46.128774),

          message = {
               openingMessage = "Le Yellow Jack est ouvert, venez en boîte !",
               closingMessage = "Le Yellow Jack est fermé !",
               name = "Yellow Jack",
               char = "CHAR_YELLOWJACK",
          },
     },
     {
          metier = "burgershot",
          metierLabel = "Burger Shot",
          plate = "BGS-",

          bar_on = true,
          bar = {
               coords = vector3(-817.024353, -797.493530, 20.221046),
               items = {
                    {name = "Ice Tea", item = "icetea"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Blue Bull", item = "bluebull"},
                    {name = "Granita", item = "granita"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-820.531921, -798.644653, 20.286693),
               items = {
                    {name = "Menu Burger", item = "menuburger"},
                    {name = "Menu Burger XL", item = "menuburgerxl"},
                    {name = "Menu Enfant", item = "menuenfant"},
                    {name = "Menu Végé", item = "menuvege"},
                    {name = "Frites", item = "frites"},
                    {name = "Sundae Chocolat", item = "sundae_chocolat"},
                    {name = "Sundae Caramel", item = "sundae_caramel"},
                    {name = "Sundae Fraise", item = "sundae_fraise"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-822.465210, -794.772278, 20.267393),

          vestiaire_on = true,
          vestiaire_coords = vector3(-1203.598, -893.7878, 12.95616),

          bossmenu_on = true,
          bossmenu_coords = vector3(-824.446167, -792.885986, 20.260746),

          blips_on = true,
          blips = {
               coords = vector3(-824.446167, -792.885986, 20.260746),
               colorBase = "~o~",
               colorBlip = 1,
               blipSprite = 106,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "stalion2",
                    "youga3",
                    "taco",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-845.799438, -780.818909, 19.464376),
               garage_spawn = {
                    {pos = vector3(-843.897583, -793.071655, 19.910751), heading = 181.55558776855,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-843.897583, -793.073364, 19.011308),

          message = {
               openingMessage = "Le Burger Shot est ouvert, venez manger !",
               closingMessage = "Le Burger Shot est fermé !",
               name = "Burger Shot",
               char = "CHAR_BURGERSHOT",
          },
     },
     {
          metier = "izakaya",
          metierLabel = "Izakaya",
          plate = "IZA-",

          bar_on = true,
          bar = {
               coords = vector3(-172.6226, 307.9022, 96.99099),
               items = {
                    {name = "Ice Tea", item = "icetea"},
                    {name = "Thé", item = "the"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "Saké", item = "sake"},
                    {name = "Blue Bull", item = "bluebull"},

               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-178.8796, 301.5312, 96.45992),
               items = {
                    {name = "Menu Ramen", item = "menuramen"},
                    {name = "Menu Sushi", item = "menusushi"},
                    {name = "Menu Tempura", item = "menutempura"},
                    {name = "Yakitori", item = "yakitori"},
                    {name = "Soupe Miso", item = "soupemiso"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-176.0609, 311.4375, 96.991),

          vestiaire_on = true,
          vestiaire_coords = vector3(-173.0611, 305.9086, 99.9231),

          bossmenu_on = true,
          bossmenu_coords = vector3(-175.6637, 301.6608, 99.9231),

          blips_on = true,
          blips = {
               coords = vector3(-175.6637, 301.6608, 99.9231),
               colorBase = "~o~",
               colorBlip = 1,
               blipSprite = 182,
          },

          colorBase = "~o~",

          garage_on = true,
          garage = {
               vehicles = {
                    "burrito3",
                    "youga3",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-162.8781, 267.5459, 92.6077),
               garage_spawn = {
                    {pos = vector3(-176.8023, 276.8553, 93.18816), heading = 171.49,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-163.2261, 276.6568, 92.52528),

          message = {
               openingMessage = "Le Izakaya est ouvert, venez manger !",
               closingMessage = "Le Izakaya est fermé !",
               name = "Izakaya",
               char = "CHAR_IZAKAYA",
          },
     },
     {
          metier = "uwu",
          metierLabel = "Uwu Café",
          plate = "UWU-",

          bar_on = true,
          bar = {
               coords = vector3(-586.28985595703, -1061.6038818359, 21.444192504883),
               items = {
                    {name = "Bubbletea", item = "bubbletea"},
                    {name = "Latte Fraise", item = "lattefraise"},
                    {name = "Latte Matcha", item = "lattematcha"},
                    {name = "Limonade Japonaise", item = "limonadejaponaise"},
                    {name = "Eau", item = "eau"},
               },
          },

          grill_on = true,
          grill = {
               coords = vector3(-590.25207519531, -1057.0179443359, 21.456174468994),
               items = {
                    {name = "Cake Japonais", item = "cakejaponais"},
                    {name = "Croffle", item = "croffle"},
                    {name = "Pancakes", item = "pancakes"},
                    {name = "Mochi", item = "mochi"},
                    {name = "Tangulu", item = "tangulu"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(-585.68054199219, -1055.9235839844, 21.444192504883),

          vestiaire_on = true,
          vestiaire_coords = vector3(-586.57836914062, -1049.8748779297, 21.444175338745),

          bossmenu_on = true,
          bossmenu_coords = vector3(-577.29119873047, -1067.6942138672, 25.714051818848),

          blips_on = true,
          blips = {
               coords = vector3(-577.29119873047, -1067.6942138672, 26.614051818848),
               colorBase = "~p~",
               colorBlip = 34,
               blipSprite = 489,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
                    "gbboxboyft",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(-599.02282714844, -1055.560546875, 21.444198226929),
               garage_spawn = {
                    {pos = vector3(-611.657349, -1064.809326, 21.847818), heading = 177.35038757324,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(-620.72698974609, -1062.3624267578, 20.888326263428),

          message = {
               openingMessage = "Le Uwu Café est ouvert, il est temps de faire une pause gourmande !",
               closingMessage = "Le Uwu Café est fermé !",
               recruitMessage = "Le Uwu Café recrute, venez postuler sur place !",
               name = "Uwu Café",
               char = "CHAR_UWU",
          },
     },
     {
          metier = "blackwoods",
          metierLabel = "BlackWoods",
          plate = "BLC-",

          bar_on = true,
          bar = {
               coords = vector3(7350.742676, 356.862885, 57.367231),
               items = {
                    {name = "Rhum", item = "rhum"},
                    {name = "Vin", item = "vine"},
                    {name = "Bière", item = "biere"},
                    {name = "Vodka", item = "vodka"},
                    {name = "Whisky", item = "whisky"},
                    {name = "Gin", item = "gin"},
                    {name = "Café", item = "cafe"},
                    {name = "Coca", item = "coca"},
                    {name = "Eau", item = "eau"},
                    {name = "chips", item = "chips"},
               },
          },

          grill_on = false,
          grill = {
               coords = vector3(7347.614746, 352.855682, 57.367315),
               items = {
                    {name = "Club Sandwich", item = "clubsand"},
                    {name = "Cacahuètes", item = "cacahuetes"},
                    {name = "Bol de fruits", item = "bolfruit"},
               },
          },

          coffre_on = true,
          coffre_coords = vector3(7329.186035, 369.423981, 56.886362),

          vestiaire_on = true,
          vestiaire_coords = vector3(7355.961914, 355.362244, 57.372713),

          bossmenu_on = true,
          bossmenu_coords = vector3(7359.458496, 351.281586, 57.376585),

          blips_on = true,
          blips = {
               coords = vector3(7359.458496, 351.281586, 57.376585),
               colorBase = "~p~",
               colorBlip = 48,
               blipSprite = 93,
          },

          colorBase = "~p~",

          garage_on = true,
          garage = {
               vehicles = {
                    "pbus2",
                    "vstretch",
                    "patriot2",
                    "stretch",
                    "tourbus",
               },
               xenon = true,
               fullCustom = true,
               color1 = 1,
               color2 = 1,
               garage_coords = vector3(7336.553711, 354.259094, 57.082300),
               garage_spawn = {
                    {pos = vector3(7323.835449, 355.173737, 56.920885), heading = 46.99,},
               },
          },

          ranger_on = true,
          ranger_coords = vector3(7331.223145, 354.766449, 56.920885),

          message = {
               openingMessage = "Le BlackWoods est ouvert, lâchez prise et venez vous amuser !",
               closingMessage = "Le BlackWoods est fermé !",
               recruitMessage = "Le BlackWoods recrute, venez postuler sur place !",
               name = "BlackWoods",
               char = "CHAR_BLACKWOODS",
          },
     },
}
