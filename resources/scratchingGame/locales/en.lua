Locales['en'] = {

    -- Vous voulez utiliser vos propres couleurs personnalisées ? Utilisez :
    -- https://wiki.rage.mp/index.php?title=Fonts_and_Colors

    ['lottery_name'] = 'Gratte&Gagne', -- nom dans la notification du ticket
    ['lottery_subject'] = 'Résultat du Ticket', -- sujet dans la notification du ticket
    ['active_cooldown'] = 'Vous avez récemment gratté un ticket ! Temps d’attente restant : ~r~%s~s~ secondes.~s~', -- %s <temps en secondes>
    ['used_scratchticket'] = 'Vous avez ~g~utilisé avec succès~s~ un ~p~ticket à gratter~s~.',
    ['currency'] = '$',
    ['scratch_lost'] = 'Perdu :(', -- MAJUSCULE par défaut
    ['scratch_won'] = 'Gagné !',

    -- Webhooks
    -- Vous souhaitez utiliser la mise en forme Markdown de Discord ? Utilisez :
    -- https://support.discord.com/hc/en-us/articles/210298617-Markdown-Text-101-Chat-Formatting-Bold-Italic-Underline

    ['webhook_resourceName'] = "[ %s ]", -- %s <nom de la ressource>
    ['webhook_identifier'] = 'Identifiant', -- identifiant du joueur actuel
    ['webhook_winMessage_cash'] = '**%s** a gagné $%s en utilisant un ticket à gratter !', -- (1) %s <nom> (2) %s <montant>
    ['webhook_winMessage_item'] = '**%s** a gagné %sx %s en utilisant un ticket à gratter !', -- (1) %s <nom> (2) %s <quantité> (3) <nom de l’objet>
    ['webhook_loseMessage'] = '**%s** a perdu en utilisant un ticket à gratter.', -- %s <nom>
    ['webhook_possibleCheatingAttempt'] = '**%s** a déclenché une *tentative de triche* potentielle.', -- %s <nom>
    ['webhook_message'] = 'Message' -- en-tête du message de tentative de triche
}
