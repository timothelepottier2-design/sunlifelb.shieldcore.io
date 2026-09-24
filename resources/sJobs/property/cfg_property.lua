PROPERTY = {
    ["menuOpenned"] = false,
    ["owned"] = false,
    ["seller"] = false,
    ["ringed"] = false,
    ["nearPoint"] = false,
    ["returnProperty"] = false,
    ["visiting"] = false,
    ["askedGarage"] = false,
    ["isVipInterior"] = false,
    ["inventoryEnabled"] = false,
    ["isForced"] = false,
    ["forcedProperties"] = {},
    ["inNoclip"] = false,

    ["launchedLaboThread"] = false,
    ["taked"] = false,

    ["calledExpire"] = 0,
    ["calledClothes"] = 0,
    ["inventoryWeight"] = 0,
    ["inventoryCapacity"] = 0,
    ["inventoryMoney"] = 0,
    ["inventoryDirtyMoney"] = 0,
    ["letterboxWeight"] = 0,
    ["letterboxMoney"] = 0,
    ["letterboxDirtyMoney"] = 0,
    ["blackMoney"] = 0,

    ["laboChooseIndex"] = 1,

    ["ownerLicense"] = nil,
    ["ownerExist"] = nil,
    ["returnPropertyCoords"] = nil,
    ["musicTitle"] = nil,
    ["propertyName"] = "Votre propriété",

    ["createdProps"] = {},
    ["createdPropsByIndex"] = {},

    ["categories"] = {
        "Aucun",
        "Armes",
    },
    ["creatorData"] = {},
    ["lastRinged"] = {},
    ["blips"] = {},
    ["spawnedVehicles"] = {},
    ["playersInProperty"] = {},
    ["playersInPropertyList"] = {},

    ["buildings"] = {},
    ["buildingData"] = {},

    ["coOwners"] = {},
    ["jobBlips"] = {},
    ["personnalBlips"] = {},
    ["visitors"] = {},
    ["myVehicles"] = {},
    ["garageSettings"] = {},

    ["inventory"] = {},
    ["letterbox"] = {},
    ["webhooks"] = {
        chest = false,
    },

    ["allowedTimes"] = {
        "1 semaine",
        "2 semaines",
        "3 semaines",
        "1 mois",
    },

    ["randomVehicles"] = {
        "sultanrs",
        "bf400",
        "kamacho",
        "youga",
        "primo",
    },

    ["hideList"] = {},
    ["myInventory"] = {},
    ["myClothes"] = {},
    ["otherPlayersClothes"] = {},

    ["permissionsList"] = {
        {
            name = "Accès au coffre",
            type = "chestAccess",
            toggle = false,
        },
        {
            name = "Accès à la garde-robe",
            type = "wearAccess",
            toggle = false,
        },
        {
            name = "Accès au /deco",
            type = "editMode",
            toggle = false,
        },
    },
    ["allowedLabos"] = {
        [27] = true,
        [28] = true,
        [29] = true,
    },
    ["transformationAllowed"] = false,
    ["allLabos"] = {

        {
            label = "Crack",
            type = "crack",

            interiorIndex = 36,

            entry = vector3(1088.77, -3187.81, -38.99),

            computerShop = {
                pos = vector3(1045.25, -3194.84, -38.35),
                items = {},
            },
        },
        {
            label = "Ecstasy",
            type = "ecstasy",

            interiorIndex = 37,

            entry = vector3(997.2, -3200.7, -36.39),

            computerShop = {
                pos = vector3(1001.94, -3194.19, -39.19),
                items = {},
            },
        },
        {
            label = "LSD",
            type = "lsd",

            interiorIndex = 38,

            entry = vector3(1088.77, -3187.81, -38.99),

            computerShop = {
                pos = vector3(1045.25, -3194.84, -38.35),
                items = {},
            },
        },

    },
    ["laboPos"] = {},

    ["showers"] = {
        {
            pos = vector3(-767.56, 327.43, 169.70)
        },
        {
            pos = vector3(254.29, -1000.13, -99.93)
        },
        {
            pos = vector3(346.89, -995.13, -100.11)
        },
        {
            pos = vector3(-38.57, -581.95, 77.87)
        },
        {
            pos = vector3(-32.47, -587.41, 82.95)
        },
        {
            pos = vector3(-1453.75, -555.47, 71.88)
        },
        {
            pos = vector3(-1461.38, -534.96, 49.77)
        },
        {
            pos = vector3(-898.05, -368.57, 112.11)
        },
        {
            pos = vector3(-591.71, 49.14, 96.04)
        },
        {
            pos = vector3(-796.38, 333.36, 209.93)
        },
        {
            pos = vector3(-168.89, 489.73, 132.87)
        },
        {
            pos = vector3(335.91, 430.56, 145.6)
        },
        {
            pos = vector3(373.9, 413.97, 141.13)
        },
        {
            pos = vector3(-673.75, 588.4, 140.6)
        },
        {
            pos = vector3(-765.49, 612.72, 139.36)
        },
        {
            pos = vector3(-856.46, 682.36, 148.08)
        },
        {
            pos = vector3(120.83, 551.01, 179.53)
        },
        {
            pos = vector3(-1287.27, 440.41, 93.12)
        },
        {
            pos = vector3(-80.37, -816.87, 243.37)
        }
    },

    ["interiors"] = {
        {
            name  = "Garage bas de gamme",

            entry = vector3(1110.24, -3166.82, -37.5),
            chest = vector3(1116.42, -3160.8, -36.87),
        },
        {
            name  = "Garage moyen",

            entry = vector3(997.03, -3158.09, -38.9),
            chest = vector3(1009.94, -3168.16, -38.9),
        },
        {
            name  = "Modern 3 Apartment",

            entry = vector3(-778.6, 337.63, 196.69),
            chest = vector3(-763.19, 329.09, 199.49),

            boombox = {
                enabled = true,
                coords = vector3(-770.54160, 321.65650, 195.83100),
            },

            telescope = {
                enabled = true,
                coords = vector3(-771.92580, 314.67520, 195.48350),
            },
        },
        {
            name  = "MazeBank",

            entry = vector3(-74.05, -820.04, 243.39),
            chest = vector3(-78.29, -810.52, 243.39),

            helipad = {
                enabled = true,
                door = vector3(-67.11, -821.91, 321.29),
                spawn = vector3(-74.79, -819.18, 326.18),
            },

            secretary = {
                enabled = true,
                model = {
                    hash = "a_f_y_business_01",
                    coords = {
                        pos = vector3(-71.99, -814.48, 242.39),
                        heading = 156.63,
                    },

                    action = function()
                        PROPERTY["openSecretarty"]()
                    end,
                },
            },

            boombox = {
                enabled = true,
                coords = vector3(-80.10593, -805.97470, 243.47480),
            },

            telescope = {
                enabled = true,
                coords = vector3(-75.18971, -800.55740, 242.98280),
            },

            wallText = {
                enabled = true,
                action = function(toggle)
                    local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                    if toggle then
                        FinanceOrganization.Office.Enable(true)
                        FinanceOrganization.Name.Set("Votre texte ici", 0, 0, 0)
                    else
                        FinanceOrganization.Office.Enable(false)
                    end

                    local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                    RefreshInterior(FinanceOffice2.interiorId)
                end,
            },

            ground = vector3(-55.71, -792.04, 44.22),

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "warm",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.warm, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "classical",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.classical, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "vintage",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.vintage, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "contrast",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.contrast, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "rich",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.rich, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "cool",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.cool, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "ice",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.ice, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "conservative",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.conservative, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                        {
                            name = "polished",

                            action = function()
                                local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                                FinanceOffice2.Style.Set(FinanceOffice2.Style.Theme.polished, true)
                                RefreshInterior(FinanceOffice2.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Objets festifs (alcool, cigarettes)",
                    type = "booze",

                    action = function(toggle)
                        local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()

                        if toggle then
                            FinanceOffice2.Booze.Set(FinanceOffice2.Booze.on, true)
                        else
                            FinanceOffice2.Booze.Set(FinanceOffice2.Booze.off, true)
                        end

                        RefreshInterior(FinanceOffice2.currentInteriorId)
                    end,
                },
                {
                    name = "Chaises de bureau",
                    type = "chairs",

                    action = function(toggle)
                        local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                        FinanceOffice2.Chairs.Set(FinanceOffice2.Chairs.on, toggle)

                        if toggle then
                            FinanceOffice2.Chairs.Set(FinanceOffice2.Chairs.on, true)
                        else
                            FinanceOffice2.Chairs.Set(FinanceOffice2.Chairs.off, true)
                        end

                        RefreshInterior(FinanceOffice2.currentInteriorId)
                    end,
                },
            },
        },
        {
            name  = "Arcadius",

            entry = vector3(-139.75, -627.48, 168.82),
            chest = vector3(-132.14, -634.79, 168.82),

            helipad = {
                enabled = true,
                door = vector3(-136.75, -596.2, 206.92),
                spawn = vector3(-144.41, -593.52, 211.78),
            },

            secretary = {
                enabled = true,
                model = {
                    hash = "a_f_y_business_01",
                    coords = {
                        pos = vector3(-138.99, -633.84, 167.82),
                        heading = 6.0,
                    },

                    action = function()
                        PROPERTY["openSecretarty"]()
                    end,
                },
            },

            boombox = {
                enabled = true,
                coords = vector3(-128.17960, -637.98030, 168.90940),
            },

            wallText = {
                enabled = true,
                action = function(toggle)
                    local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                    if toggle then
                        FinanceOrganization.Office.Enable(true)
                        FinanceOrganization.Name.Set("Votre texte ici", 0, 0, 0)
                    else
                        FinanceOrganization.Office.Enable(false)
                    end

                    local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                    RefreshInterior(FinanceOffice2.interiorId)
                end,
            },

            ground = vector3(-111.07, -606.65, 36.28),

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "warm",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.warm, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "classical",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.classical, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "vintage",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.vintage, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "contrast",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.contrast, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "rich",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.rich, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "cool",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.cool, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "ice",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.ice, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "conservative",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.conservative, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                        {
                            name = "polished",

                            action = function()
                                local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                                FinanceOffice1.Style.Set(FinanceOffice1.Style.Theme.polished, true)
                                RefreshInterior(FinanceOffice1.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Objets festifs (alcool, cigarettes)",
                    type = "booze",

                    action = function(toggle)
                        local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()

                        if toggle then
                            FinanceOffice1.Booze.Set(FinanceOffice1.Booze.on, true)
                        else
                            FinanceOffice1.Booze.Set(FinanceOffice1.Booze.off, true)
                        end

                        RefreshInterior(FinanceOffice1.currentInteriorId)
                    end,
                },
                {
                    name = "Chaises de bureau",
                    type = "chairs",

                    action = function(toggle)
                        local FinanceOffice1 = exports.bob74_ipl:GetFinanceOffice1Object()
                        FinanceOffice1.Chairs.Set(FinanceOffice1.Chairs.on, toggle)

                        if toggle then
                            FinanceOffice1.Chairs.Set(FinanceOffice1.Chairs.on, true)
                        else
                            FinanceOffice1.Chairs.Set(FinanceOffice1.Chairs.off, true)
                        end

                        RefreshInterior(FinanceOffice1.currentInteriorId)
                    end,
                },
            },
        },
        {
            name  = "W. MazeBank",

            entry = vector3(-1385.88, -478.55, 72.04),
            chest = vector3(-1379.14, -470.54, 72.04),

            helipad = {
                enabled = true,
                door = vector3(-1369.4, -471.92, 84.45),
                spawn = vector3(-1391.52, -477.56, 91.25),
            },

            boombox = {
                enabled = true,
                coords = vector3(-1376.06100, -466.60620, 72.13108),
            },

            telescope = {
                enabled = true,
                coords = vector3(-1368.97000, -468.40370, 71.63905),
            },

            wallText = {
                enabled = true,
                action = function(toggle)
                    local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                    if toggle then
                        FinanceOrganization.Office.Enable(true)
                        FinanceOrganization.Name.Set("Votre texte ici", 0, 0, 0)
                    else
                        FinanceOrganization.Office.Enable(false)
                    end

                    local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                    RefreshInterior(FinanceOffice2.interiorId)
                end,
            },

            ground = vector3(-1377.56, -505.1, 33.16),

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "warm",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.warm, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "classical",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.classical, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "vintage",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.vintage, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "contrast",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.contrast, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "rich",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.rich, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "cool",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.cool, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "ice",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.ice, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "conservative",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.conservative, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                        {
                            name = "polished",

                            action = function()
                                local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                                FinanceOffice4.Style.Set(FinanceOffice4.Style.Theme.polished, true)
                                RefreshInterior(FinanceOffice4.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Objets festifs (alcool, cigarettes)",
                    type = "booze",

                    action = function(toggle)
                        local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()

                        if toggle then
                            FinanceOffice4.Booze.Set(FinanceOffice4.Booze.on, true)
                        else
                            FinanceOffice4.Booze.Set(FinanceOffice4.Booze.off, true)
                        end

                        RefreshInterior(FinanceOffice4.currentInteriorId)
                    end,
                },
                {
                    name = "Chaises de bureau",
                    type = "chairs",

                    action = function(toggle)
                        local FinanceOffice4 = exports.bob74_ipl:GetFinanceOffice4Object()
                        FinanceOffice4.Chairs.Set(FinanceOffice4.Chairs.on, toggle)

                        if toggle then
                            FinanceOffice4.Chairs.Set(FinanceOffice4.Chairs.on, true)
                        else
                            FinanceOffice4.Chairs.Set(FinanceOffice4.Chairs.off, true)
                        end

                        RefreshInterior(FinanceOffice4.currentInteriorId)
                    end,
                },
            },
        },
        {
            name  = "LOM Bank",

            entry = vector3(-1574.44, -570.23, 108.52),
            chest = vector3(-1564.8, -572.44, 108.52),

            helipad = {
                enabled = true,
                door = vector3(-1561.16, -568.6, 114.45),
                spawn = vector3(-1582.14, -569.53, 116.33),
            },

            boombox = {
                enabled = true,
                coords = vector3(-1559.55900, -573.05710, 108.61190),
            },

            telescope = {
                enabled = true,
                coords = vector3(-1557.81700, -580.16210, 108.11990),
            },

            wallText = {
                enabled = true,
                action = function(toggle)
                    local FinanceOrganization = exports.bob74_ipl:GetFinanceOrganizationObject()
                    if toggle then
                        FinanceOrganization.Office.Enable(true)
                        FinanceOrganization.Name.Set("Votre texte ici", 0, 0, 0)
                    else
                        FinanceOrganization.Office.Enable(false)
                    end

                    local FinanceOffice2 = exports.bob74_ipl:GetFinanceOffice2Object()
                    RefreshInterior(FinanceOffice2.interiorId)
                end,
            },

            ground = vector3(-1594.35, -587.31, 34.97),

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "warm",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.warm, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "classical",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.classical, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "vintage",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.vintage, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "contrast",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.contrast, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "rich",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.rich, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "cool",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.cool, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "ice",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.ice, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "conservative",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.conservative, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                        {
                            name = "polished",

                            action = function()
                                local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                                FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.polished, true)
                                RefreshInterior(FinanceOffice3.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Objets festifs (alcool, cigarettes)",
                    type = "booze",

                    action = function(toggle)
                        local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()

                        if toggle then
                            FinanceOffice3.Booze.Set(FinanceOffice3.Booze.on, true)
                        else
                            FinanceOffice3.Booze.Set(FinanceOffice3.Booze.off, true)
                        end

                        RefreshInterior(FinanceOffice3.currentInteriorId)
                    end,
                },
                {
                    name = "Chaises de bureau",
                    type = "chairs",

                    action = function(toggle)
                        local FinanceOffice3 = exports.bob74_ipl:GetFinanceOffice3Object()
                        FinanceOffice3.Chairs.Set(FinanceOffice3.Chairs.on, toggle)

                        if toggle then
                            FinanceOffice3.Chairs.Set(FinanceOffice3.Chairs.on, true)
                        else
                            FinanceOffice3.Chairs.Set(FinanceOffice3.Chairs.off, true)
                        end

                        RefreshInterior(FinanceOffice3.currentInteriorId)
                    end,
                },
            },
        },
        {
            name  = "Integrity Way",

            entry = vector3(-18.74, -581.94, 90.11),
            chest = vector3(-27.74, -588.42, 90.12),

            ground = vector3(-47.8, -585.71, 37.95),

            boombox = {
                enabled = true,
                coords = vector3(-45.02653, -587.66340, 88.66412),
            },

            telescope = {
                enabled = true,
                coords = vector3(-44.62522, -578.50920, 88.32477),
            },

            editables = {
                {
                    name = "Petites culottes dans l'appartement",
                    type = "strip",

                    action = function(toggle)
                        local GTAOApartmentHi1 = exports.bob74_ipl:GetGTAOApartmentHi1Object()

                        if toggle then
                            GTAOApartmentHi1.Strip.Enable({GTAOApartmentHi1.Strip.A, GTAOApartmentHi1.Strip.B, GTAOApartmentHi1.Strip.C}, true, true)
                        else
                            GTAOApartmentHi1.Strip.Enable({GTAOApartmentHi1.Strip.A, GTAOApartmentHi1.Strip.B, GTAOApartmentHi1.Strip.C}, false, true)
                        end
                    end,
                },
                {
                    name = "Objets festifs (alcool, cigarettes)",
                    type = "booze",

                    action = function(toggle)
                        local GTAOApartmentHi1 = exports.bob74_ipl:GetGTAOApartmentHi1Object()
                        if toggle then
                            GTAOApartmentHi1.Booze.Enable({GTAOApartmentHi1.Booze.A, GTAOApartmentHi1.Booze.B, GTAOApartmentHi1.Booze.C}, true, true)
                        else
                            GTAOApartmentHi1.Booze.Enable({GTAOApartmentHi1.Booze.A, GTAOApartmentHi1.Booze.B, GTAOApartmentHi1.Booze.C}, false, true)
                        end
                    end,
                },
            },
        },
        {
            name  = "Weazel Plaza",

            entry = vector3(-900.09, -459.68, 126.53),
            chest = vector3(-899.39, -448.8, 126.54),

            ground = vector3(-914.45, -455.61, 39.6),

            boombox = {
                enabled = true,
                coords = vector3(-886.97660, -436.51220, 125.09160),
            },

            telescope = {
                enabled = true,
                coords = vector3(-880.52330, -442.92930, 124.74440),
            },
        },
        {
            name  = "Richards Majestic",

            entry = vector3(-914.73, -366.38, 109.44),
            chest = vector3(-915.46, -377.18, 109.45),

            ground = vector3(-934.24, -386.28, 38.96),

            boombox = {
                enabled = true,
                coords = vector3(-927.90512, -389.47870, 107.99740),
            },

            telescope = {
                enabled = true,
                coords = vector3(-934.34630, -383.04930, 107.65020),
            },
        },
        {
            name  = "Del Perro Heights",

            entry = vector3(-1458.55, -520.77, 69.56),
            chest = vector3(-1457.64, -531.54, 69.57),

            ground = vector3(-1441.76, -546.88, 34.74),

            boombox = {
                enabled = true,
                coords = vector3(-1468.35000, -545.37930, 68.11376),
            },

            telescope = {
                enabled = true,
                coords = vector3(-1475.53400, -540.09050, 67.75729),
            },
        },
        {
            name  = "Tinsel Towers",

            entry = vector3(-599.96, 65.08, 108.03),
            chest = vector3(-605.92, 55.66, 108.04),

            ground = vector3(-595.27, 31.68, 43.54),
        },
        {
            name  = "Eclipse Towers, Penthouse 1",

            entry = vector3(-781.75, 320.05, 217.68),
            chest = vector3(-796.13, 327.61, 217.04),

            boombox = {
                enabled = true,
                coords = vector3(-790.46510, 336.09190, 216.78320),
            },

            telescope = {
                enabled = true,
                coords = vector3(-789.08050, 343.07320, 216.43570),
            },

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "moody",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.moody, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "vibrant",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.vibrant, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "sharp",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.sharp, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "monochrome",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.monochrome, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "seductive",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.seductive, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "regal",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.regal, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                        {
                            name = "aqua",

                            action = function()
                                local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                                ExecApartment1.Style.Set(ExecApartment1.Style.Theme.aqua, true)
                                RefreshInterior(ExecApartment1.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Petites culottes dans l'appartement",
                    type = "strip",

                    action = function(toggle)
                        local ExecApartment1 = exports.bob74_ipl:GetExecApartment1Object()
                        ExecApartment1.Strip.Enable({ExecApartment1.Strip.A, ExecApartment1.Strip.B, ExecApartment1.Strip.C}, toggle, true)
                    end,
                },
            },
        },
        {
            name  = "Eclipse Towers, Penthouse 2",

            entry = vector3(-781.75, 318.83, 187.92),
            chest = vector3(-796.43, 327.56, 187.31),

            ground = vector3(-773.79, 308.44, 85.7),

            boombox = {
                enabled = true,
                coords = vector3(-794.15010, 342.24520, 187.06170),
            },

            telescope = {
                enabled = true,
                coords = vector3(-789.08050, 343.07320, 186.71070),
            },

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "moody",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.moody, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "vibrant",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.vibrant, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "sharp",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.sharp, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "monochrome",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.monochrome, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "seductive",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.seductive, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "regal",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.regal, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                        {
                            name = "aqua",

                            action = function()
                                local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                                ExecApartment3.Style.Set(ExecApartment3.Style.Theme.aqua, true)
                                RefreshInterior(ExecApartment3.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Petites culottes dans l'appartement",
                    type = "strip",

                    action = function(toggle)
                        local ExecApartment3 = exports.bob74_ipl:GetExecApartment3Object()
                        ExecApartment3.Strip.Enable({ExecApartment3.Strip.A, ExecApartment3.Strip.B, ExecApartment3.Strip.C}, toggle, true)
                    end,
                },
            },
        },
        {
            name  = "Eclipse Towers, Penthouse 3",

            entry = vector3(-779.19, 338.1, 196.69),
            chest = vector3(-764.67, 330.13, 196.09),

            ground = vector3(-773.58, 308.69, 85.7),

            boombox = {
                enabled = true,
                coords = vector3(-770.54160, 321.65650, 195.83100),
            },

            telescope = {
                enabled = true,
                coords = vector3(-771.92580, 314.67520, 195.48350),
            },

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "moody",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.moody, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "vibrant",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.vibrant, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "sharp",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.sharp, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "monochrome",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.monochrome, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "seductive",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.seductive, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "regal",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.regal, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                        {
                            name = "aqua",

                            action = function()
                                local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                                ExecApartment2.Style.Set(ExecApartment2.Style.Theme.aqua, true)
                                RefreshInterior(ExecApartment2.currentInteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Petites culottes dans l'appartement",
                    type = "strip",

                    action = function(toggle)
                        local ExecApartment2 = exports.bob74_ipl:GetExecApartment2Object()
                        ExecApartment2.Strip.Enable({ExecApartment2.Strip.A, ExecApartment2.Strip.B, ExecApartment2.Strip.C}, toggle, true)
                    end,
                },
            },
        },
        {
            name  = "Eclipse Towers, Apt 40",

            entry = vector3(-778.34, 317.25, 223.26),
            chest = vector3(-772.29, 326.55, 223.27),

            ground = vector3(-773.91, 305.73, 85.7),

            boombox = {
                enabled = true,
                coords = vector3(-755.69110, 331.70510, 221.80690),
            },

            telescope = {
                enabled = true,
                coords = vector3(-752.93730, 322.96570, 221.46760),
            },
        },
        {
            name  = "Wild Oats Drive",

            entry = vector3(-174.07, 496.08, 137.67),
            chest = vector3(-175.87, 492.16, 130.04),

            ground = vector3(-177.91, 504.11, 136.86),

            boombox = {
                enabled = true,
                coords = vector3(-171.42500, 483.11950, 137.27040),
            },

            telescope = {
                enabled = true,
                coords = vector3(-162.23500, 479.56960, 136.84140),
            },
        },
        {
            name  = "2044 North Conker Ave",

            entry = vector3(341.25, 437.39, 149.39),
            chest = vector3(336.18, 437.74, 141.77),

            ground = vector3(347.13, 441.45, 147.7),

            boombox = {
                enabled = true,
                coords = vector3(328.74850, 431.13670, 148.99750),
            },

            telescope = {
                enabled = true,
                coords = vector3(327.78370, 421.33230, 148.56850),
            },
        },
        {
            name  = "2045 North Conker Ave",

            entry = vector3(373.55, 423.36, 145.91),
            chest = vector3(378.76, 429.98, 138.3),

            ground = vector3(371.96, 430.39, 145.11),

            boombox = {
                enabled = true,
                coords = vector3(368.78700, 409.06680, 145.52640),
            },

            telescope = {
                enabled = true,
                coords = vector3(375.55920, 401.95270, 145.09750),
            },
        },
        {
            name  = "3677 Whispymound Drive",

            entry = vector3(117.45, 558.71, 184.3),
            chest = vector3(119.8, 567.47, 176.7),

            ground = vector3(119.09, 567.2, 183.13),

            boombox = {
                enabled = true,
                coords = vector3(117.66900, 544.51570, 183.92340),
            },

            telescope = {
                enabled = true,
                coords = vector3(126.46590, 540.14690, 183.49450),
            },
        },
        {
            name  = "2862 Hillcrest Ave",

            entry = vector3(-681.82, 591.96, 145.39),
            chest = vector3(-680.93, 586.9, 137.77),

            ground = vector3(-688.03, 597.78, 143.64),

            boombox = {
                enabled = true,
                coords = vector3(-672.71030, 581.29140, 144.99640),
            },

            telescope = {
                enabled = true,
                coords = vector3(-662.96360, 582.72710, 144.56750),
            },
        },
        {
            name  = "2868 Hillcrest Ave",

            entry = vector3(-758.76, 618.86, 144.15),
            chest = vector3(-764.05, 619.77, 136.53),

            ground = vector3(-751.6, 621.02, 142.24),

            boombox = {
                enabled = true,
                coords = vector3(-672.71030, 581.29140, 144.99640),
            },

            telescope = {
                enabled = true,
                coords = vector3(-662.96360, 582.72710, 144.56750),
            },
        },
        {
            name  = "2874 Hillcrest Ave",

            entry = vector3(-859.9, 690.95, 152.86),
            chest = vector3(-857.09, 698.85, 145.25),

            ground = vector3(-853.4, 698.2, 148.78),

            boombox = {
                enabled = true,
                coords = vector3(-859.84930, 675.83940, 152.47930),
            },

            telescope = {
                enabled = true,
                coords = vector3(-851.16980, 671.24170, 152.05030),
            },
        },
        {
            name  = "2113 Mad Wayne Thunder Drive",

            entry = vector3(-1289.82, 449.37, 97.9),
            chest = vector3(-1286.24, 456.99, 90.29),

            ground = vector3(-1294.69, 454.89, 97.48),

            boombox = {
                enabled = true,
                coords = vector3(-1290.99100, 434.29360, 97.52101),
            },

            telescope = {
                enabled = true,
                coords = vector3(-1282.69900, 429.02910, 97.09206),
            },
        },
        {
            name  = "1162 Power Street, Apt 3",

            entry = vector3(347.01, -1001.99, -99.2),
            chest = vector3(351.87, -998.69, -99.2),

            boombox = {
                enabled = true,
                coords = vector3(341.55560, -1001.05800, -99.04117),
            },
        },
        {
            name  = "0112 South Rockford Drive, Apt 13",

            entry = vector3(265.2, -1002.34, -99.01),
            chest = vector3(265.78, -999.33, -99.01),

            boombox = {
                enabled = true,
                coords = vector3(263.35710, -994.68510, -98.80326),
            },
        },
        {
            name  = "Petit entrepot",

            entry = vector3(1087.91, -3099.38, -39.0),
            chest = vector3(1091.27, -3098.06, -39.0),
        },
        {
            name  = "Moyen entrepot",

            entry = vector3(1048.79, -3097.29, -39.0),
            chest = vector3(1052.88, -3100.77, -39.0),
        },
        {
            name  = "Grand entrepot",

            entry = vector3(992.82, -3097.80, -39.00),
            chest = vector3(1001.85, -3100.06, -39.0),
        },
        {
            name  = "Farmhouse Bunker",

            entry = vector3(891.93, -3245.26, -98.26),
            chest = vector3(903.72, -3199.67, -97.19),

            shop = true,

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "Par défaut",

                            action = function()
                                local GunrunningBunker = exports.bob74_ipl:GetGunrunningBunkerObject()
                                GunrunningBunker.Style.Set(GunrunningBunker.Style.default)
                                RefreshInterior(GunrunningBunker.interiorId)
                            end,
                        },
                        {
                            name = "Bleu",

                            action = function()
                                local GunrunningBunker = exports.bob74_ipl:GetGunrunningBunkerObject()
                                GunrunningBunker.Style.Set(GunrunningBunker.Style.blue)
                                RefreshInterior(GunrunningBunker.interiorId)
                            end,
                        },
                        {
                            name = "Jaune",

                            action = function()
                                local GunrunningBunker = exports.bob74_ipl:GetGunrunningBunkerObject()
                                GunrunningBunker.Style.Set(GunrunningBunker.Style.yellow)
                                RefreshInterior(GunrunningBunker.interiorId)
                            end,
                        },
                    },
                },
                {
                    name = "Équipement amélioré",
                    type = "bunkerEquipment",

                    action = function(toggle)
                        local GunrunningBunker = exports.bob74_ipl:GetGunrunningBunkerObject()
                        if toggle then
                            GunrunningBunker.Tier.Set(GunrunningBunker.Tier.upgrade)
                        else
                            GunrunningBunker.Tier.Set(GunrunningBunker.Tier.default)
                        end
                        RefreshInterior(GunrunningBunker.interiorId)
                    end,
                },
            },
        },
        {
            name  = "Sous marin",

            shop = true,

            entry = vector3(514.38, 4886.12, -62.59),
            chest = vector3(514.19, 4833.0, -66.19),
        },
        {
            name  = "Penthouse casino",

            entry = vector3(971.19, 72.73, 116.18),
            chest = vector3(977.52, 47.79, 116.17),

            helipad = {
                enabled = true,
                door = vector3(971.95, 52.19, 120.24),
                spawn = vector3(969.62, 63.12, 112.56),
            },

            rooftop = {
                enabled = true,
                door = vector3(967.74, 63.64, 112.55),
                spawn = vector3(969.48, 63.27, 112.55),
            },

            boombox = {
                enabled = true,
                coords = vector3(944.09000, 21.30000, 115.59580),
            },

            barman = {
                enabled = true,
                model = {
                    hash = "u_f_m_casinocash_01",
                    coords = {
                        pos = vector3(945.51, 13.86, 115.16),
                        heading = 54.67,
                    },

                    action = function()
                        PROPERTY["openCasinoBar"]({
                            {label = "Coca", price = "1,000$",  name = "coca", count = 1, realPrice = 1000},
                            {label = "Vin", price = "1,500$",  name = "vine", count = 1, realPrice = 1500},
                            {label = "Rhum", price = "2,000$",  name = "rhum", count = 1, realPrice = 2000},
                        })
                    end,
                },
            },

            shop = true,

            editables = {
                {
                    name = "Style",
                    type = "interiorStyles",

                    list = {
                        {
                            name = "Saumon/rose",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.Walls.SetColor(1)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Bleu",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.Walls.SetColor(3)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                    },
                },
                {
                    name = "Décoration bar",
                    type = "casinoDecors",

                    list = {
                        {
                            name = "Par défaut",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarParty.Set(DiamondPenthouse.Interior.BarParty.none)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Noir & rouge",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarParty.Set(DiamondPenthouse.Interior.BarParty.party0)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Noir & jaune",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarParty.Set(DiamondPenthouse.Interior.BarParty.party1)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Blanc & bleu",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarParty.Set(DiamondPenthouse.Interior.BarParty.party2)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                    },
                },
                {
                    name = "LED de couleurs",
                    type = "casinoDecorsBar",

                    list = {
                        {
                            name = "Par défaut",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarLight.Set(DiamondPenthouse.Interior.BarLight.none)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Orange",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarLight.Set(DiamondPenthouse.Interior.BarLight.light0)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Rose & bleu",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarLight.Set(DiamondPenthouse.Interior.BarLight.light1)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                        {
                            name = "Bleu & blanc",

                            action = function()
                                local DiamondPenthouse = exports.bob74_ipl:GetDiamondPenthouseObject()
                                DiamondPenthouse.Interior.BarLight.Set(DiamondPenthouse.Interior.BarLight.light2)
                                RefreshInterior(DiamondPenthouse.interiorId)
                            end,
                        },
                    },
                },
            },
        },
        {
            name  = "Maison de franklin DLC",

            entry = vector3(-578.38, -715.84, 113.01),
            chest = vector3(-600.79, -709.66, 121.61),

            helipad = {
                enabled = true,
                door = vector3(-580.37, -716.87, 129.88),
                spawn = vector3(-580.28, -716.81, 129.88),
            },

            boombox = {
                enabled = true,
                coords = vector3(-590.13430, -708.23440, 121.62310),
            },

            editables = {
                {
                    name = "Mur",
                    type = "wpaper",

                    list = {
                        {
                            name = "Style de mur #1",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_1', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #2",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_2', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #3",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_3', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #4",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_4', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #5",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_5', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #6",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_6', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #7",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_7', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #8",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_8', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Style de mur #9",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 9 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Wpaper_9', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                    },
                },
                {
                    name = "Art",
                    type = "art",

                    list = {
                        {
                            name = "Art #1",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 6 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Art_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Art_1', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Art #2",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 6 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Art_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Art_2', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                        {
                            name = "Art #3",

                            action = function()
                                local MpSecurityOffice4 = exports.bob74_ipl:GetMpSecurityOffice4Object()

                                for i=1, 6 do
                                    MpSecurityOffice4.Entities.Set('Entity_Set_Art_'..i, false)
                                end

                                MpSecurityOffice4.Entities.Set('Entity_Set_Art_3', true)
                                RefreshInterior(MpSecurityOffice4.InteriorId)
                            end,
                        },
                    },
                },
            },
        },
        {
            name = "Laboratoire de Weed",

            type = "weed",
            hided = true,

            chest = vector3(1041.44, -3192.8, -37.91),
            entry = vector3(1066.13, -3183.46, -39.16),

            recolt = {
                coords = vector3(1058.41, -3202.87, -39.05),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1038.38, -3205.85, -38.12),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1038.93, -3195.82, -39.17),
                heading = 241.27,
            },

            glowUpAction = function(toggle)
                local BikerWeedFarm = exports.bob74_ipl:GetBikerWeedFarmObject()

                if toggle then
                    BikerWeedFarm.Style.Set(BikerWeedFarm.Style.upgrade)
                    BikerWeedFarm.Security.Set(BikerWeedFarm.Security.upgrade)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.drying, true)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.chairs, true)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.production, true)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.fans, true)

                    BikerWeedFarm.Details.Enable({
                        BikerWeedFarm.Details.production,
                        BikerWeedFarm.Details.chairs,
                        BikerWeedFarm.Details.drying,
                        BikerWeedFarm.Details.fans,
                    }, true)
                else
                    BikerWeedFarm.Style.Set(BikerWeedFarm.Style.basic)
                    BikerWeedFarm.Security.Set(BikerWeedFarm.Security.basic)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.drying, false)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.chairs, false)
                    BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.production, false)

                    BikerWeedFarm.Details.Enable({
                        BikerWeedFarm.Details.production,
                        BikerWeedFarm.Details.chairs,
                        BikerWeedFarm.Details.drying,
                        BikerWeedFarm.Details.fans,
                    }, false)
                end

                RefreshInterior(BikerWeedFarm.InteriorId)
            end,

            pedModel = "mp_f_weed_01",
            computerShop = {
                enabled = true,
                coords = vector3(1045.25, -3194.84, -38.35),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1056.98, -3199.85, -40.13), heading = 228.09},
                            {coords = vector3(1051.85, -3201.31, -40.12), heading = 31.52},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(1057.08, -3188.98, -40.03), heading = 55.3},
                            {coords = vector3(1053.38, -3192.14, -40.15), heading = 132.07},
                            {coords = vector3(1063.66, -3197.98, -40.12), heading = 251.25},

                            {coords = vector3(1062.13, -3203.82, -40.05), heading = 22.06},
                            {coords = vector3(1058.38, -3206.58, -40.14), heading = 358.85},
                            {coords = vector3(1049.42, -3207.44, -40.15), heading = 302.29},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Laboratoire de Cocaïne",

            type = "cocaine",
            hided = true,

            chest = vector3(1101.09, -3198.73, -38.99),
            entry = vector3(1088.77, -3187.81, -38.99),

            recolt = {
                coords = vector3(1090.0, -3199.65, -38.69),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1095.38, -3195.70, -39.19),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1103.39, -3194.96, -39.99),
                heading = 115.51,
            },

            glowUpAction = function(toggle)
                local BikerCocaine = exports.bob74_ipl:GetBikerCocaineObject()

                if toggle then
                    BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
                    BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)

                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, true, true)
                else
                    BikerCocaine.Style.Set(BikerCocaine.Style.basic)
                    BikerCocaine.Security.Set(BikerCocaine.Security.none)

                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, false, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, false, true)
                end

                RefreshInterior(BikerCocaine.InteriorId)
            end,

            pedModel = "mp_f_cocaine_01",
            computerShop = {
                enabled = true,
                coords = vector3(1086.52, -3194.28, -39.19),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1099.56, -3194.23, -39.99), heading = 90.23},
                            {coords = vector3(1101.74, -3193.77, -39.99), heading = 348.14},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(1090.22, -3194.83, -39.99), heading = 174.1},
                            {coords = vector3(1092.94, -3194.83, -39.99), heading = 174.1},
                            {coords = vector3(1095.43, -3194.79, -39.99), heading = 174.1},

                            {coords = vector3(1095.42, -3196.66, -39.99), heading = 356.33},
                            {coords = vector3(1092.81, -3196.57, -39.99), heading = 356.33},
                            {coords = vector3(1090.25, -3196.67, -39.99), heading = 356.33},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Laboratoire de Crack",

            type = "crack",
            hided = true,

            chest = vector3(997.92, -3200.17, -38.99),
            entry = vector3(997.2, -3200.7, -36.39),

            recolt = {
                coords = vector3(1017.34, -3195.93, -38.99),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1007.99, -3195.14, -38.99),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1013.13, -3202.37, -39.99),
                heading = 14.3,
            },

            glowUpAction = function(toggle)
                local BikerMethLab = exports.bob74_ipl:GetBikerMethLabObject()

                if toggle then
                    BikerMethLab.Style.Set(BikerMethLab.Style.upgrade)
                    BikerMethLab.Security.Set(BikerMethLab.Security.upgrade)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                else
                    BikerMethLab.Style.Set(BikerMethLab.Style.basic)
                    BikerMethLab.Security.Set(BikerMethLab.Security.none)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                end

                RefreshInterior(BikerMethLab.InteriorId)
            end,

            pedModel = "mp_f_meth_01",
            computerShop = {
                enabled = true,
                coords = vector3(1001.94, -3194.19, -39.19),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1010.52, -3200.06, -39.99), heading = 2.14},
                            {coords = vector3(1003.93, -3196.46, -39.99), heading = 182.03},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(999.0, -3201.2, -39.99), heading = 115.09},
                            {coords = vector3(1006.04, -3195.04, -39.99), heading = 357.16},
                            {coords = vector3(1014.95, -3194.96, -39.99), heading = 356.34},

                            {coords = vector3(1017.24, -3199.01, -39.99), heading = 284.17},
                            {coords = vector3(1005.72, -3200.32, -39.52), heading = 172.71},
                            {coords = vector3(1002.86, -3199.94, -39.99), heading = 128.61},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Laboratoire d'Ecstasy",

            type = "ecstasy",
            hided = true,

            chest = vector3(997.92, -3200.17, -38.99),
            entry = vector3(997.2, -3200.7, -36.39),

            recolt = {
                coords = vector3(1017.34, -3195.93, -38.99),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1007.99, -3195.14, -38.99),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1013.13, -3202.37, -39.99),
                heading = 14.3,
            },

            glowUpAction = function(toggle)
                local BikerMethLab = exports.bob74_ipl:GetBikerMethLabObject()

                if toggle then
                    BikerMethLab.Style.Set(BikerMethLab.Style.upgrade)
                    BikerMethLab.Security.Set(BikerMethLab.Security.upgrade)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                else
                    BikerMethLab.Style.Set(BikerMethLab.Style.basic)
                    BikerMethLab.Security.Set(BikerMethLab.Security.none)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                end

                RefreshInterior(BikerMethLab.InteriorId)
            end,

            pedModel = "mp_f_meth_01",
            computerShop = {
                enabled = true,
                coords = vector3(1001.94, -3194.19, -39.19),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1010.52, -3200.06, -39.99), heading = 2.14},
                            {coords = vector3(1003.93, -3196.46, -39.99), heading = 182.03},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(999.0, -3201.2, -39.99), heading = 115.09},
                            {coords = vector3(1006.04, -3195.04, -39.99), heading = 357.16},
                            {coords = vector3(1014.95, -3194.96, -39.99), heading = 356.34},

                            {coords = vector3(1017.24, -3199.01, -39.99), heading = 284.17},
                            {coords = vector3(1005.72, -3200.32, -39.52), heading = 172.71},
                            {coords = vector3(1002.86, -3199.94, -39.99), heading = 128.61},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Laboratoire de LSD",

            type = "lsd",
            hided = true,

            chest = vector3(997.92, -3200.17, -38.99),
            entry = vector3(997.2, -3200.7, -36.39),

            recolt = {
                coords = vector3(1017.34, -3195.93, -38.99),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1007.99, -3195.14, -38.99),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1013.13, -3202.37, -39.99),
                heading = 14.3,
            },

            glowUpAction = function(toggle)
                local BikerMethLab = exports.bob74_ipl:GetBikerMethLabObject()

                if toggle then
                    BikerMethLab.Style.Set(BikerMethLab.Style.upgrade)
                    BikerMethLab.Security.Set(BikerMethLab.Security.upgrade)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                else
                    BikerMethLab.Style.Set(BikerMethLab.Style.basic)
                    BikerMethLab.Security.Set(BikerMethLab.Security.none)
                    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)
                end

                RefreshInterior(BikerMethLab.InteriorId)
            end,

            pedModel = "mp_f_meth_01",
            computerShop = {
                enabled = true,
                coords = vector3(1001.94, -3194.19, -39.19),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1010.52, -3200.06, -39.99), heading = 2.14},
                            {coords = vector3(1003.93, -3196.46, -39.99), heading = 182.03},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(999.0, -3201.2, -39.99), heading = 115.09},
                            {coords = vector3(1006.04, -3195.04, -39.99), heading = 357.16},
                            {coords = vector3(1014.95, -3194.96, -39.99), heading = 356.34},

                            {coords = vector3(1017.24, -3199.01, -39.99), heading = 284.17},
                            {coords = vector3(1005.72, -3200.32, -39.52), heading = 172.71},
                            {coords = vector3(1002.86, -3199.94, -39.99), heading = 128.61},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Laboratoire d'Héroïne",

            type = "heroine",
            hided = true,

            chest = vector3(1101.09, -3198.73, -38.99),
            entry = vector3(1088.77, -3187.81, -38.99),

            recolt = {
                coords = vector3(1090.0, -3199.65, -38.69),
                radius = 1.5,
            },

            traitment = {
                coords = vector3(1095.38, -3195.70, -39.19),
                radius = 1.5,
            },

            importexport = {
                coords = vector3(1103.39, -3194.96, -39.99),
                heading = 115.51,
            },

            glowUpAction = function(toggle)
                local BikerCocaine = exports.bob74_ipl:GetBikerCocaineObject()

                if toggle then
                    BikerCocaine.Style.Set(BikerCocaine.Style.upgrade)
                    BikerCocaine.Security.Set(BikerCocaine.Security.upgrade)

                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, true, true)
                else
                    BikerCocaine.Style.Set(BikerCocaine.Style.basic)
                    BikerCocaine.Security.Set(BikerCocaine.Security.none)

                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, true, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, false, true)
                    BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, false, true)
                end

                RefreshInterior(BikerCocaine.InteriorId)
            end,

            pedModel = "mp_f_cocaine_01",
            computerShop = {
                enabled = true,
                coords = vector3(1086.52, -3194.28, -39.19),
                items = {
                    {
                        type = "glowup",
                        label = "Pack amélioré",
                        desc = "+2 employés, double traitement et amélioration globale du laboratoire",
                        price = 1500000,

                        pedsList = {
                            {coords = vector3(1099.56, -3194.23, -39.99), heading = 90.23},
                            {coords = vector3(1101.74, -3193.77, -39.99), heading = 348.14},
                        },
                    },
                    {
                        type = "employee",
                        label = "x6 employés",
                        desc = "Vitesse de récolte et traitement augmentée",
                        price = 500000,

                        pedsList = {
                            {coords = vector3(1090.22, -3194.83, -39.99), heading = 174.1},
                            {coords = vector3(1092.94, -3194.83, -39.99), heading = 174.1},
                            {coords = vector3(1095.43, -3194.79, -39.99), heading = 174.1},

                            {coords = vector3(1095.42, -3196.66, -39.99), heading = 356.33},
                            {coords = vector3(1092.81, -3196.57, -39.99), heading = 356.33},
                            {coords = vector3(1090.25, -3196.67, -39.99), heading = 356.33},
                        },
                    },
                    {
                        type = "detector",
                        label = "Détecteurs autour du laboratoire",
                        desc = "Vous envoie une notification dès que quelqu'un est autour de votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "door",
                        label = "Porte blindée",
                        desc = "Une perceuse sera nécessaire si quelqu'un veut s'introduire dans votre laboratoire",
                        price = 50000,
                    },
                    {
                        type = "importexport",
                        label = "Import/export",
                        desc = "Employé uniquement là pour faire partir de la drogue dans la ville, les gens recevront une alerte et devrons revendre votre drogue, vous touchez une commission sur chaque vente",
                        price = 50000,
                    },
                },
            },
        },
        {
            name = "Propriété non meublée #1",

            chest = vector3(296.30313110352, 114.73095703125, 141.05145263672),
            entry = vector3(295.30493164062, 128.83529663086, 141.05145263672),
        },
        {
            name = "Propriété non meublée #2",

            chest = vector3(290.36639404297, 129.21083068848, 134.35624694824),
            entry = vector3(294.50939941406, 118.39682006836, 134.35624694824),
        },
        {
            name = "Propriété non meublée #3",

            chest = vector3(285.12994384766, 131.50828552246, 129.06414794922),
            entry = vector3(294.51123046875, 126.17107391357, 129.06379699707),
        },
        {
            name = "Propriété non meublée #4",

            chest = vector3(287.74456787109, 127.26291656494, 119.21424102783),
            entry = vector3(294.77560424805, 122.22102355957, 119.21433258057),
        },
        {
            name = "Propriété non meublée #5",

            chest = vector3(306.61773681641, 119.94285583496, 102.62977600098),
            entry = vector3(301.29763793945, 114.94708251953, 102.62995147705),
        },
        {
            name  = "Bungalow",

            shop = false,

            entry = vector3(-2368.201171875, -617.23986816406, 5.9100608825684),
            chest = vector3(-2362.9606933594, -617.35815429688, 5.9100623130798),
        },
    },
    ["garages"] = {
        {
            name = "Garage 2 places",

            entry = vector3(179.05, -1005.43, -99.0),
            places = {
                {pos = vector3(175.22, -1003.46, -99.0), heading = 183.32},
                {pos = vector3(171.07, -1003.78, -99.0), heading = 180.28}
            },
        },
        {
            name = "Garage 4 places",

            entry = vector3(207.17, -1018.37, -99.0),
            places = {
                {pos = vector3(194.50, -1016.14, -99.0), heading = 180.13},
                {pos = vector3(194.57, -1022.32, -99.0), heading = 180.13},
                {pos = vector3(202.21, -1020.14, -99.0), heading = 90.13},
                {pos = vector3(202.21, -1023.32, -99.0), heading = 90.13}
            },
        },
        {
            name = "Garage 6 places",

            entry = vector3(207.0, -998.94, -99.0),
            places = {
                {pos = vector3(203.82, -1004.63, -99.0), heading = 88.05},
                {pos = vector3(194.16, -1004.63, -99.0), heading = 266.42},
                {pos = vector3(193.83, -1000.63, -99.0), heading = 266.42},
                {pos = vector3(202.62, -1000.63, -99.0), heading = 88.05},
                {pos = vector3(193.83, -997.01, -99.0), heading = 266.42},
                {pos = vector3(202.62, -997.01, -99.0), heading = 88.05},
            },
        },
        {
            name = "Garage 10 places",

            entry = vector3(236.92, -1005.23, -99.0),
            places = {
                {
                    pos = vector3(224.05, -1002.14, -99.0),
                    heading = 222.12,
                },
                {
                    pos = vector3(224.02, -996.79, -99.0),
                    heading = 222.12,
                },
                {
                    pos = vector3(223.93, -991.05, -99.0),
                    heading = 222.12,
                },
                {
                    pos = vector3(223.69, -984.98, -99.0),
                    heading = 222.12,
                },
                {
                    pos = vector3(223.7, -978.31, -99.0),
                    heading = 222.12,
                },

                {
                    pos = vector3(233.41, -978.64, -99.0),
                    heading = 136.44,
                },
                {
                    pos = vector3(233.31, -983.9, -99.0),
                    heading = 136.44,
                },
                {
                    pos = vector3(233.5, -990.57, -99.0),
                    heading = 136.44,
                },
                {
                    pos = vector3(233.35, -996.12, -99.0),
                    heading = 136.44,
                },
                {
                    pos = vector3(233.2, -1001.29, -99.0),
                    heading = 136.44,
                },
            },
        },
        {
            name = "MazeBank Garage 18 places",

            entry = vector3(-91.2, -821.29, 222.0),
            places = {
                {pos = vector3(-68.224518, -825.543274, 221.406281), heading = 108.41},
                {pos = vector3(-71.026946, -821.806641, 221.508163), heading = 139.52},
                {pos = vector3(-75.358902, -819.733276, 221.497177), heading = 169.68},
                {pos = vector3(-80.601181, -818.75647, 221.913025), heading = 175.71},
                {pos = vector3(-70.150597, -835.635193, 221.914963), heading = 46.0},
                {pos = vector3(-67.643822, -830.637146, 221.343704), heading = 81.77},
                {pos = vector3(-68.225082, -825.542664, 226.891388), heading = 111.73},
                {pos = vector3(-71.024559, -821.80481, 227.046005), heading = 140.98},
                {pos = vector3(-75.358917, -819.732361, 226.853409), heading = 160.14},
                {pos = vector3(-80.600929, -818.756042, 226.842514), heading = 160.14},
                {pos = vector3(-85.163536, -817.908081, 227.258423), heading = 188.21},
                {pos = vector3(-70.151001, -835.635498, 226.890625), heading =  43.37},
                {pos = vector3(-67.639793, -830.638672, 227.045715), heading = 81.21},
                {pos = vector3(-70.12, -835.57, 232.199112), heading =  51.41},
                {pos = vector3(-67.15, -830.66, 232.39183), heading =  72.89},
                {pos = vector3(-68.71, -824.33, 232.237), heading = 118.8},
                {pos = vector3(-74.15, -820.24, 232.258423), heading = 159.37},
                {pos = vector3(-80.83, -819.46, 232.034805), heading = 199.22},
                {pos = vector3(-85.18, -820.65, 232.604095), heading = 217.44},
            },
        },
        {
            name = "Arcadius Garage 18 places",

            entry = vector3(-198.22, -580.64, 136.0),
            places = {
                {pos = vector3(-189.88, -574.6, 135.38),  heading = 219.65},
                {pos = vector3(-185.59, -572.79, 135.37), heading = 193.46},
                {pos = vector3(-179.98, -572.06, 135.37), heading = 176.78},
                {pos = vector3(-175.09, -573.84, 135.37), heading = 144.14},
                {pos = vector3(-172.61, -578.03, 135.37), heading = 107.95},
                {pos = vector3(-172.63, -582.9, 135.37),  heading = 71.91},

                {pos = vector3(-189.88, -574.6,  140.71),  heading = 219.65},
                {pos = vector3(-185.59, -572.79, 140.71), heading = 193.46},
                {pos = vector3(-179.98, -572.06, 140.71), heading = 176.78},
                {pos = vector3(-175.09, -573.84, 140.71), heading = 144.14},
                {pos = vector3(-172.61, -578.03, 140.71), heading = 107.95},
                {pos = vector3(-172.63, -582.9,  140.71),  heading = 71.91},

                {pos = vector3(-189.88, -574.6,  146.07),  heading = 219.65},
                {pos = vector3(-185.59, -572.79, 146.07), heading = 193.46},
                {pos = vector3(-179.98, -572.06, 146.07), heading = 176.78},
                {pos = vector3(-175.09, -573.84, 146.07), heading = 144.14},
                {pos = vector3(-172.61, -578.03, 146.07), heading = 107.95},
                {pos = vector3(-172.63, -582.9,  146.07),  heading = 71.91},
            },
        },
        {
            name = "Garage casino",

            entry = vector3(2521.68, -279.03, -64.72),
            places = {
                {pos = vector3(2524.56, -270.09, -65.34), heading = 180.0},
                {pos = vector3(2533.64, -269.47, -65.34), heading = 180.0},
                {pos = vector3(2542.69, -269.55, -65.34), heading = 180.0},
                {pos = vector3(2542.63, -288.68, -65.34), heading = 0.0},
                {pos = vector3(2533.75, -288.64, -65.34), heading = 0.0},
                {pos = vector3(2524.64, -288.59, -65.34), heading = 0.0},
            },
        },
        {
            name = "Garage maison de franklin DLC",

            entry = vector3(-1065.62, -85.38, -99.0),
            places = {
                {pos = vector3(-1079.4, -82.97, -90.2), heading = 329.7},
                {pos = vector3(-1079.45, -74.56, -90.2), heading = 326.98},
                {pos = vector3(-1079.59, -68.16, -90.2), heading = 269.48},
                {pos = vector3(-1064.99, -74.7, -90.15), heading = 87.1},

                {pos = vector3(-1079.4, -82.97, -95.23), heading = 329.7},
                {pos = vector3(-1079.45, -74.56, -95.23), heading = 326.98},
                {pos = vector3(-1079.59, -68.16, -95.23), heading = 269.48},
                {pos = vector3(-1065.65, -66.35, -95.23), heading = 145.16},
                {pos = vector3(-1065.89, -74.84, -95.23), heading = 145.99},
                {pos = vector3(-1065.83, -81.21, -95.23), heading = 90.6},

                {pos = vector3(-1079.4, -82.97, -99.0), heading = 329.7},
                {pos = vector3(-1079.45, -74.56, -99.0), heading = 326.98},
                {pos = vector3(-1079.59, -68.16, -99.0), heading = 269.48},
                {pos = vector3(-1065.65, -66.35, -99.0), heading = 145.16},
                {pos = vector3(-1065.89, -74.84, -99.0), heading = 145.99},
                {pos = vector3(-1065.83, -81.21, -99.0), heading = 90.6},
            },
        },
    },
}

TELESCOPE = {}

TELESCOPE.HelpText = ""
TELESCOPE.NoFoundMessage = ""
TELESCOPE.TelescopeInUse = ""
TELESCOPE.ToFarAway = ""

TELESCOPE.UseDistanceThread = true
TELESCOPE.UseNativeNotifiactions = false

TELESCOPE.MaxInteractionDist = 1.5
TELESCOPE.MaxDetectionDist = 6.0

TELESCOPE.MovementSpeed = {
	Keyboard = 2.75,
	Controller = 1.0
}

TELESCOPE.Zoom = {
	Max = 50.0,
	Min = 5.0,
	Speed = 5.0
}

TELESCOPE.Animations = {
	["default"] = {
		enter = "enter_front",
		enterTime = 1500,
		exit = "exit_front",
		idle = "idle"
	},
	["public"] = {
		enter = "public_enter_front",
		enterTime = 1500,
		exit = "public_exit_front",
		idle = "public_idle"
	},
	["upright"] = {
		enter = "upright_enter_front",
		enterTime = 2500,
		exit = "upright_exit_front",
		idle = "upright_idle"
	}
}

TELESCOPE.Models = {
	[1186047406] = { MaxHorizontal = 55.0, MaxVertical = 20.0, offset = vector3(0.0, 0.95, 0.0), headingOffset = 180.0, animation = "public", cameraOffset = vector3(0.0, -0.5, 0.7), scaleform = "OBSERVATORY_SCOPE" },
	[844159446] = { MaxHorizontal = 55.0, MaxVertical = 20.0, offset = vector3(0.0, -0.85, 1.0), animation = "upright", cameraOffset = vector3(0.0, 0.2, 1.7), scaleform = "BINOCULARS" },
	[-656927072] = { MaxHorizontal = 55.0, MaxVertical = 35.0, offset = vector3(1.25, 0.0, 0.0), headingOffset = 90.0, animation = "default", cameraOffset = vector3(-0.25, 0.0, 1.3), scaleform = "OBSERVATORY_SCOPE" },
	[1930051531] = { MaxHorizontal = 55.0, MaxVertical = 20.0, offset = vector3(0.0, 0.95, 0.0), headingOffset = 180.0, animation = "public", cameraOffset = vector3(0.0, -0.5, 0.7), scaleform = "BINOCULARS" },
}

TELESCOPE.Telescopes = {}
