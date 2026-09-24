local function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('sJobs.identityPlayer', function(data)
		if data then

			ESX.ShowAdvancedNotification(
				'Identité',
				'~b~Citoyen',
				'Prénom: ~g~' .. data.firstname ..
				'\n~w~Nom: ~g~' .. data.lastname ..
				'\n~w~Job: ~g~' .. (data.job and data.job.label or 'Inconnu') ..
				'\n~w~Taille: ~g~' .. data.height ..
				'\n~w~ID: ~g~' .. data.name,
				'CHAR_CALL911',
				8
			)
		else
			ESX.ShowNotification('~r~Impossible de récupérer les informations.')
		end
	end, player)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'principal_police',
        icon = 'fa-solid fa-building-shield',
        openMenu = 'police_menu',
        label = 'Action Jobs',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            return ESX.PlayerData.job and ESX.PlayerData.job.name == "sheriff" or ESX.PlayerData.job.name == "police"
        end,
    },
    {
        name = 'id_card',
        label = 'Carte d\'identité',
        icon = 'fa-solid fa-id-card-clip',
        menuName = 'police_menu',
        distance = 2,
        groups = {"police", "sheriff"},
        onSelect = function(data)
            local targetServerId = NetworkGetPlayerIndexFromPed(data.entity)
            if targetServerId then
                OpenIdentityCardMenu(GetPlayerServerId(targetServerId))
                ExecuteCommand("me prend une carte d'identité")
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'amende',
        label = 'Mettre une amende',
        icon = 'fa-solid fa-receipt',
        menuName = 'police_menu',
        distance = 2,
        groups = {"police", "sheriff"},
        onSelect = function(data)
            TriggerEvent("sCore.sendBill", "society_" ..playerJob)
        end
    },
    {
        name = 'ppa_paper',
        label = 'Retirer le PPA',
        icon = 'fa-solid fa-gun',
        menuName = 'police_menu',
        distance = 2,
        groups = {"police", "sheriff"},
        onSelect = function(data)
            local targetPed = data.entity
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))

            if targetServerId then
                TriggerServerEvent('licenses:removeToTarget', targetServerId, 'weapon')
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'drive_paper',
        label = 'Retirer le permis de conduire',
        icon = 'fa-solid fa-car',
        menuName = 'police_menu',
        distance = 2,
        groups = {"police", "sheriff"},
        onSelect = function(data)
            local targetPed = data.entity
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))

            if targetServerId then
                TriggerServerEvent('licenses:removeToTarget', targetServerId, 'drive')
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'give_ppa',
        label = 'Accorder le PPA',
        icon = 'fa-solid fa-gun',
        menuName = 'police_menu',
        distance = 2,
        groups = {"police", "sheriff"},
        canInteract = function(entity, distance, coords, name, bone)
            return ESX.PlayerData.job and (ESX.PlayerData.job.name == "sheriff" or ESX.PlayerData.job.name == "police") and ESX.PlayerData.job.grade >= 3
        end,
        onSelect = function(data)
            TriggerServerEvent('licenses:addToTarget', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)), 'weapon')
        end
    },
    {
        name = 'cause_dead',
        label = 'Déterminer les causes du coma',
        icon = 'fa-solid fa-stethoscope',
        distance = 2,
        groups = {"ems"},
        canInteract = function(entity, distance, coords, name, bone)
            return IsPedDeadOrDying(entity, true)
        end,
        onSelect = function(data)
            loadAnimDict("amb@medic@standing@kneel@base")
            loadAnimDict("anim@gangops@facility@servers@bodysearch@")
            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
            TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)

            Citizen.SetTimeout(4000, function()
                ClearPedTasksImmediately(PlayerPedId())

                TriggerServerEvent("sJobs_target.getCauseDeath", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            end)
        end
    },
})
