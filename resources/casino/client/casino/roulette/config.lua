cfg_roulette = {}
cfg_roulette.TranslationSelected = 'en'

cfg_roulette.Debug = false -- enable debug messages in sv/cl console
cfg_roulette.TestTicker = nil -- need for testing the numbers, you can change the fix roulette tick by /rultick [1-38]

cfg_roulette.RouletteStart = 40 -- how many seconds to start the rulett after you sit down

cfg_roulette.RulettTables = {
    -- you can implement tables easily or delete them.
    [0] = {
        position = vector3(1150.718505859375, 262.52783203125, -52.840850830078125),
        rot = -45.0,
        minBet = 5,
        maxBet = 100
    },
    [1] = {
        position = vector3(1144.732421875, 268.14117431640625, -52.840850830078125),
        rot = 135.0,
        minBet = 100,
        maxBet = 500
    },
    [2] = {
        position = vector3(1133.68115234375, 262.01678466796875, -52.03075408935547),
        rot = -156.0,
        minBet = 5,
        maxBet = 100
    },
    [3] = {
        position = vector3(1129.53955078125, 267.06097412109375, -52.03075408935547),
        rot = 26.0,
        minBet = 250,
        maxBet = 1000
    },
    [4] = {
        position = vector3(1143.45, 250.63, -52.04),
        rot = 90.0,
        minBet = 250,
        maxBet = 1000
    },
    [5] = {
        position = vector3(1149.31, 247.96, -52.04),
        rot = -90.0,
        minBet = 250,
        maxBet = 1000
    },
    -- Tables ajoutées au second casino. Le prop de table est déjà fourni par le mapping
    -- (vw_prop_casino_roulette_01b), donc usemap = true : le script récupère le prop existant
    -- au lieu d'en spawn un (évite une table en double). Seul le croupier est ajouté.
    [6] = {
        position = vector3(6998.046875, 277.58697509765627, 56.84926986694336),
        rot = 315.0,
        minBet = 5,
        maxBet = 100,
        usemap = true,
        mapModel = `vw_prop_casino_roulette_01b`,
    },
    [7] = {
        position = vector3(7000.8017578125, 280.3422546386719, 56.84926986694336),
        rot = 315.0,
        minBet = 100,
        maxBet = 500,
        usemap = true,
        mapModel = `vw_prop_casino_roulette_01b`,
    }
}

cfg_roulette.ChairIds = {
    ['Chair_Base_01'] = 1,
    ['Chair_Base_02'] = 2,
    ['Chair_Base_03'] = 3,
    ['Chair_Base_04'] = 4
}

cfg_roulette.rouletteSzamok = {
    [1] = '00',
    [2] = '27',
    [3] = '10',
    [4] = '25',
    [5] = '29',
    [6] = '12',
    [7] = '8',
    [8] = '19',
    [9] = '31',
    [10] = '18',
    [11] = '6',
    [12] = '21',
    [13] = '33',
    [14] = '16',
    [15] = '4',
    [16] = '23',
    [17] = '35',
    [18] = '14',
    [19] = '2',
    [20] = '0',
    [21] = '28',
    [22] = '9',
    [23] = '26',
    [24] = '30',
    [25] = '11',
    [26] = '7',
    [27] = '20',
    [28] = '32',
    [29] = '17',
    [30] = '5',
    [31] = '22',
    [32] = '34',
    [33] = '15',
    [34] = '3',
    [35] = '24',
    [36] = '36',
    [37] = '13',
    [38] = '1'
}

cfg_roulette.DebugMsg = function(msg)
    if cfg_roulette.Debug then
        print(msg)
    end
end

RULETT_NUMBERS = {}
RULETT_NUMBERS.Pirosak = {
    ['1'] = true,
    ['3'] = true,
    ['5'] = true,
    ['7'] = true,
    ['9'] = true,
    ['12'] = true,
    ['14'] = true,
    ['16'] = true,
    ['18'] = true,
    ['19'] = true,
    ['21'] = true,
    ['23'] = true,
    ['25'] = true,
    ['27'] = true,
    ['30'] = true,
    ['32'] = true,
    ['34'] = true,
    ['36'] = true
}
RULETT_NUMBERS.Feketek = {
    ['2'] = true,
    ['4'] = true,
    ['6'] = true,
    ['8'] = true,
    ['10'] = true,
    ['11'] = true,
    ['13'] = true,
    ['15'] = true,
    ['17'] = true,
    ['20'] = true,
    ['22'] = true,
    ['24'] = true,
    ['26'] = true,
    ['28'] = true,
    ['29'] = true,
    ['31'] = true,
    ['33'] = true,
    ['35'] = true
}
RULETT_NUMBERS.Parosak = {
    ['2'] = true,
    ['4'] = true,
    ['6'] = true,
    ['8'] = true,
    ['10'] = true,
    ['12'] = true,
    ['14'] = true,
    ['16'] = true,
    ['18'] = true,
    ['20'] = true,
    ['22'] = true,
    ['24'] = true,
    ['26'] = true,
    ['28'] = true,
    ['30'] = true,
    ['32'] = true,
    ['34'] = true,
    ['36'] = true
}
RULETT_NUMBERS.Paratlanok = {
    ['1'] = true,
    ['3'] = true,
    ['5'] = true,
    ['7'] = true,
    ['9'] = true,
    ['11'] = true,
    ['13'] = true,
    ['15'] = true,
    ['17'] = true,
    ['19'] = true,
    ['21'] = true,
    ['23'] = true,
    ['25'] = true,
    ['27'] = true,
    ['29'] = true,
    ['31'] = true,
    ['33'] = true,
    ['35'] = true
}
RULETT_NUMBERS.to18 = {
    ['1'] = true,
    ['2'] = true,
    ['3'] = true,
    ['4'] = true,
    ['5'] = true,
    ['6'] = true,
    ['7'] = true,
    ['8'] = true,
    ['9'] = true,
    ['10'] = true,
    ['11'] = true,
    ['12'] = true,
    ['13'] = true,
    ['14'] = true,
    ['15'] = true,
    ['16'] = true,
    ['17'] = true,
    ['18'] = true
}
RULETT_NUMBERS.to36 = {
    ['19'] = true,
    ['20'] = true,
    ['21'] = true,
    ['22'] = true,
    ['23'] = true,
    ['24'] = true,
    ['25'] = true,
    ['26'] = true,
    ['27'] = true,
    ['28'] = true,
    ['29'] = true,
    ['30'] = true,
    ['31'] = true,
    ['32'] = true,
    ['33'] = true,
    ['34'] = true,
    ['35'] = true,
    ['36'] = true
}
RULETT_NUMBERS.st12 = {
    ['1'] = true,
    ['2'] = true,
    ['3'] = true,
    ['4'] = true,
    ['5'] = true,
    ['6'] = true,
    ['7'] = true,
    ['8'] = true,
    ['9'] = true,
    ['10'] = true,
    ['11'] = true,
    ['12'] = true
}
RULETT_NUMBERS.sn12 = {
    ['13'] = true,
    ['14'] = true,
    ['15'] = true,
    ['16'] = true,
    ['17'] = true,
    ['18'] = true,
    ['19'] = true,
    ['20'] = true,
    ['21'] = true,
    ['22'] = true,
    ['23'] = true,
    ['24'] = true
}
RULETT_NUMBERS.rd12 = {
    ['25'] = true,
    ['26'] = true,
    ['27'] = true,
    ['28'] = true,
    ['29'] = true,
    ['30'] = true,
    ['31'] = true,
    ['32'] = true,
    ['33'] = true,
    ['34'] = true,
    ['35'] = true,
    ['36'] = true
}
RULETT_NUMBERS.ket_to_1 = {
    ['1'] = true,
    ['4'] = true,
    ['7'] = true,
    ['10'] = true,
    ['13'] = true,
    ['16'] = true,
    ['19'] = true,
    ['22'] = true,
    ['25'] = true,
    ['28'] = true,
    ['31'] = true,
    ['34'] = true
}
RULETT_NUMBERS.ket_to_2 = {
    ['2'] = true,
    ['5'] = true,
    ['8'] = true,
    ['11'] = true,
    ['14'] = true,
    ['17'] = true,
    ['20'] = true,
    ['23'] = true,
    ['26'] = true,
    ['29'] = true,
    ['32'] = true,
    ['35'] = true
}
RULETT_NUMBERS.ket_to_3 = {
    ['3'] = true,
    ['6'] = true,
    ['9'] = true,
    ['12'] = true,
    ['15'] = true,
    ['18'] = true,
    ['21'] = true,
    ['24'] = true,
    ['27'] = true,
    ['30'] = true,
    ['33'] = true,
    ['36'] = true
}

if not IsDuplicityVersion() then -- CLIENT
    Utils = {
        Draw3DText = function(coords, text, size, font)
            coords = vector3(coords.x, coords.y, coords.z)

            local camCoords = GetGameplayCamCoords()
            local distance = #(coords - camCoords)

            if not size then
                size = 1
            end
            if not font then
                font = 0
            end

            local scale = (size / distance) * 2
            local fov = (1 / GetGameplayCamFov()) * 100
            scale = scale * fov

            SetTextScale(0.0 * scale, 0.55 * scale)
            SetTextFont(font)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextCentre(true)

            SetDrawOrigin(coords, 0)
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayText(0.0, 0.0)
            ClearDrawOrigin()
        end,
        ShowHelpNotification = function(msg, thisFrame, beep, duration)
            AddTextEntry('rulettNotification', msg)

            if thisFrame then
                DisplayHelpTextThisFrame('rulettNotification', false)
            else
                if beep == nil then
                    beep = true
                end
                BeginTextCommandDisplayHelp('rulettNotification')
                EndTextCommandDisplayHelp(0, false, beep, duration or -1)
            end
        end,
        ShowNotification = function(msg)
            SetNotificationTextEntry('STRING')
            AddTextComponentString(msg)
            DrawNotification(0, 1)
        end
    }

    RegisterNetEvent('rulett:showNotification')
    AddEventHandler(
        'rulett:showNotification',
        function(msg)
            Utils.ShowNotification(msg)
        end
    )
end

if IsDuplicityVersion() then -- server
    
end