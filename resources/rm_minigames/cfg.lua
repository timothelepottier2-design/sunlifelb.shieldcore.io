Config = {
    typingGame = {
        difficulty = {
            ['easy'] = 6,
            ['normal'] = 12,
            ['hard'] = 18,
        },
        duration = 20,
        initialSequences = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        }
    },
    timedLockpick = {
        speed = 600,
    },
    timedAction = {
        unlockCount = 3,
    },
    quickEvent = {
        difficulty = {
            ['easy'] = 1,
            ['normal'] = 3,
            ['hard'] = 5,
        },
        duration = 1,
        sequences = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        },
    },
    combinationLock = {
        difficulty = {
            ['easy'] = 1,
            ['normal'] = 3,
            ['hard'] = 5,
        },
        range = { 1, 360 },
    },
    buttonMashing = {
        decayRate = 5,
        incrementRate = 10,
    },
    angledLockpick = {
        difficulty = {
            ['easy'] = 1,
            ['normal'] = 3,
            ['hard'] = 5,
        },
        range = { 1, 360 },
    },
    fingerPrint = {
        time = 200,
        live = 3,
    },
    hotwire = {
        time = 3,
    },
    hackerMinigame = {
        upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        lowerCase = "abcdefghijklmnopqrstuvwxyz",
        numbers = "0123456789",
        lenght = 3,
        live = 3,
    },
    safeCrack = {
        difficulty = {
            ['easy'] = 1,
            ['normal'] = 3,
            ['hard'] = 5,
        },
    },
    timedButton = {
        wrongCount = 3,
        difficulty = {
            ['easy'] = 10,
            ['normal'] = 7,
            ['hard'] = 5,
        },
        sequences = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        },
    },
    timedBar = {
        winCount = 1,
        wrongCount = 3,
        difficulty = {
            ['easy'] = 12,
            ['normal'] = 7,
            ['hard'] = 2,
        },
    },
    circleClick = {
        wrongCount = 3,
        maxScore = 5,
        difficulty = {
            ['easy'] = 2,
            ['normal'] = 1.5,
            ['hard'] = 1,
        },
    },
    multipleLockpick = {
        wrongCount = 3,
        lockCount = 3,
    },
    memoryGame = {
        difficulty = {
            ['easy'] = 3,
            ['normal'] = 5,
            ['hard'] = 7,
        },
    }
}

Strings = {
    ['safecrack'] = '~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ Tourner\n~INPUT_FRONTEND_RDOWN~ Vérifier',
    ["hackerminigame"] = '>. Craquez ce mot de passe : %s (%s tentatives restantes)',
    ["won"] = "Vous avez gagné !",
    ["lost"] = "Vous avez perdu !",
    ["turn-green"] = "lorsque la touche devient verte",
    ["success-lockpick"] = "Vous avez réussi à crocheter la serrure.",
    ["failed-lockpick"] = "Vous avez échoué à crocheter la serrure.",
    ["input-override"] = "Forçage d'entrée",
    ["correct-key"] = "Appuyez sur les bonnes touches lorsqu'elles entrent dans la zone pour continuer.",
    ["time-button-failed-title"] = "Verrouillage du système",
    ["time-button-failed-desc"] = "Vous n'avez pas réussi à forcer le système.",
    ["time-button-success-title"] = "Succès",
    ["time-button-success-desc"] = "Le système a été déverrouillé.",
    ["typing-game-title"] = "Analyseur de séquence",
    ["typing-game-desc"] = "Tapez la bonne séquence pour déverrouiller le système.",
    ["typing-game-failed-title"] = "Échec",
    ["typing-game-failed-desc"] = "Séquence incorrecte. Arrêt du système.",
    ["typing-game-success-title"] = "Succès",
    ["typing-game-success-desc"] = "Le système a été déverrouillé."
}