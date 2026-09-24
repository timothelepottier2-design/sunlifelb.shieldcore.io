Config = {
    -- send paddle position to your opponent every 33ms (30x/s)
    -- lower the value for faster sync sync between paddles
    PositionSendRate = 33,
    -- maximum time the puck can stay on one side in ms
    PenaltyTime = 10000,
    -- block these while playing
    RestrictedControls = {37, 157, 159, 160, 161, 162, 163, 164, 165, 158, 101, 337, 53, 54, 47, 140, 141, 263, 264,
                          142, 143, 24, 257, 44, 282, 283, 284, 285, 69, 70, 114, 99, 100, 102, 22, 74, 68, 25, 36, 345,
                          346, 347, 91, 92},
    BounceStrength = 0.05, -- camera bounce effect
    DrawTableScore = true, -- draw actual match score for viewers on top tables
    Framework = 1, -- 0: Standalone (no bets), 1: ESX, 2: QBCore
    EnableBets = true,
    MinBet = 1000,
    MaxBet = 50000,
    BetType = 2, -- 1: Choose the lower stake for both (P1 choose 1k, P2 choose 2k, stake will be 1k for both), 2: both can set their own stakes
    WinMultiplier = 2, -- winner gets 2x the stake
    SpawnDistance = 30.0,
    UIFontID = 0, -- fontId (used in menus)
    UIFontName = nil, -- name of the font (used in scaleforms and notifications)
    NotifySystem = 1, -- 1: native notify, 2: okokNotify, 3: esx_notify, 4: qb_notify, 5: ox_notify
    -- Enable rcore_stats? (https://store.rcore.cz/package/6273968)
    Rcore_Stats = GetResourceState("rcore_stats") ~= "missing"
}

Objects = {
    { pos = vector3(253.385803, -769.365479, 29.757963), heading = 74.0 },
    { pos = vector3(-1635.939453, -1052.837891, 12.148856), heading = 318.0 },
    { pos = vector3(-1634.047485, -1054.425537, 12.148856), heading = 318.0 },
    { pos = vector3(220.3724, -915.0825, 29.6921), heading = 235.6817 },
    { pos = vector3(222.5682, -912.3782, 29.6921), heading = 235.6518 },
    { pos = vector3(132.7410, -1317.9928, 28.2074), heading = 306.3329 },
    { pos = vector3(-1240.9005, -3031.7593, -49.4900), heading = 268.0697 },
    { pos = vector3(-1291.9447, -3028.8762, -49.4899), heading = 91.9758 },
    { pos = vector3(-1292.6996, -3004.7363, -49.4899), heading = 95.1316 },
    { pos = vector3(-1241.9735, -2984.8669, -49.4897), heading = 269.3612 },
    { pos = vector3(-898.0166, -778.8911, 14.8823), heading = 268.8262 },
    { pos = vector3(126.92656707764, -1942.4675292969, 19.577884674072), heading = 256.8262 }
}

Translation = {
    MATCH_SETTINGS = "Paramètres du match",
    SLOW = "Lent",
    MEDIUM = "Moyen",
    FAST = "Rapide",
    PUCK_SPEED = "Vitesse du palet",
    PUCK_SPEED_DESC = "La vitesse maximale que peut atteindre le palet.",
    MAX_SCORE = "Score max",
    MAX_SCORE_DESC = "Le match se terminera dès qu’un joueur atteint ce nombre de buts.",
    START = "Démarrer",
    START_DESC = "Appuyez ici pour sauvegarder les règles et lancer le match.",
    LATENCY_HIGH = "Il semble que votre latence (%s) est trop élevée. L'expérience de jeu risque d'être dégradée.",
    LATENCY_NORMAL = "Votre latence est de %s",
    END_WINNER = "gagnant.",
    END_LOSER = "perdant.",
    END_STATS_SAVES = "%s arrêts",
    END_STATS_SHOTS = "%s tirs cadrés",
    END_STATS_GOALS = "%s buts",
    END_STATS_PLAYER = "%s m parcourus par le joueur",
    END_STATS_PUCK = "%s m parcourus par le palet",
    END_STATS_TITLE = "Air Hockey",
    TIMERBAR_PENALTY = "PÉNALITÉ",
    WAITING_FOR_OP = "En attente d’un adversaire.",
    TABLE_USED = "Cette table de Air Hockey est déjà utilisée.",
    NOT_CLOSE_ENOGUH = "Vous n’êtes pas assez proche. Reculez puis essayez de nouveau.",
    NOT_ENOUGH_PLAYERS = "Pour commencer une partie d’Air Hockey, invitez un autre joueur à se rapprocher de la table.",
    WAITING_FOR_OP_TO_JOIN = "En attente que votre adversaire rejoigne la partie.",
    PRESS_TO_PLAY = "Appuyez sur ~INPUT_CONTEXT~ pour jouer au Air Hockey.",
    MATCH_CANCELLED = "Match annulé",
    MATCH_CANCELLED_DESC = "Un des joueurs s’est déconnecté ou a annulé le match.",
    STARTING = "En attente des joueurs...",
    WAITING_FOR_HOST = "%s modifie les règles",
    PRESS_TO_CONFIRM_BET = "Appuyez sur Entrée pour confirmer votre pari de %s sur votre victoire",
    READY = "Prêt",
    READY_DESC = "Appuyez sur Entrée si vous êtes prêt à jouer.",
    WAITING_FOR_OP_READY = "Veuillez patienter pendant que votre adversaire confirme qu’il est prêt.",
    BETTINGS_CAPT = "Paris",
    BETTINGS_INFOPANEL = "MISE : %s",
    BETTING_ACC = "Compte",
    BETTING_STAKE = "Mise",
    BETTINGS_USE_ACC_DESC = "Utiliser le compte '%s' pour payer la mise. Max : %s",

-- Mise à jour 1.1.0
    PADDLE_SKIN = "Apparence de la palette",
    PADDLE_SKIN_DESC = "Choisissez l’apparence de votre palette.",
    PUCK_SKIN = "Apparence du palet",
    PUCK_SKIN_DESC = "Choisissez l’apparence du palet.",
    COLOR_BLUE = "Bleu",
    COLOR_GREEN = "Vert",
    COLOR_RED = "Rouge",
    COLOR_ORANGE = "Orange",
    COLOR_GRAY = "Gris",
    COLOR_PURPLE = "Violet",
    COLOR_PINK = "Rose",
    COLOR_BLACK = "Noir",
    
    Get = function(key)
        return Translation[key] or "Missing Translation: " .. key
    end
}
