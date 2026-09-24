Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
end)

local bagProps = nil

-- XP minimum pour menotter / porter. Doit rester aligné avec les gates
-- serveur (sCore/server/modules/criminal/cuff.lua et sunlife srv_f5menu.lua),
-- qui sont les seuls faisant autorité. Ici c'est juste du confort : ça évite
-- d'envoyer l'event et de jouer l'anim pour rien.
local ACTION_MIN_EXP = 10000

RegisterNetEvent("sCore.getEmote", function(source)
    local currentEmote = exports["sunlife"]:getIsInAnimation()
    if currentEmote and currentEmote ~= "" then
        TriggerServerEvent("sCore.sendEmote", source, currentEmote)
    end
end)

RegisterNetEvent("sCore.setEmote", function(emote)
    if not emote or emote == "" then
        ESX.ShowNotification("~r~Ce joueur n'est pas en train de faire une émote.")
        return
    end

    ExecuteCommand("e " ..emote)
end)

local function applyHeadBag()
    if not bagProps then
        print(('^2[NETDIAG][OBJET]^7 %s player.lua:38 CreateObject NETWORKED prop_money_bag_01'):format(GetCurrentResourceName()))
        bagProps = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(bagProps, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.2, 0.04, 0.0, 0.0, 270.0, 60.0, true, true, false, true, 1, true)
    end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    ExecuteCommand("ToggleHUDT")
	ExecuteCommand("hudtoggle")
    DisplayRadar(false)
end

local function removeHeadBag()
    if bagProps then
        DeleteEntity(bagProps)
        SetEntityAsNoLongerNeeded(bagProps)
        bagProps = nil
    end
    DoScreenFadeIn(500)
    DisplayRadar(true)
end

AddStateBagChangeHandler('hasBagOnHead', nil, function(bagName, key, value)
    local id = bagName:match("player:(%d+)")
    local playerId = tonumber(id)

    if playerId and GetPlayerServerId(PlayerId()) == playerId then
        if value then
            ESX.ShowNotification("~r~Un sac vous a été mis sur la tête !")
            applyHeadBag()
        else
            ESX.ShowNotification("~g~Quelqu’un a retiré le sac de votre tête !")
            removeHeadBag()
        end
    end
end)

exports.ox_target:addGlobalPlayer({
    {
        name = 'id_target',
        icon = 'fa-solid fa-id-card',
        label = 'Récupérer l\'ID',
        distance = 2.0,
        onSelect = function(data)
            local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            ESX.ShowNotification('ID du joueur : ' .. playerId)
        end
    },
    {
        name = 'report_target',
        icon = 'fa-solid fa-flag',
        label = 'Report le joueur',
        distance = 1.5,
        onSelect = function(data)
            local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            local input = lib.inputDialog('Report', {
                {
                    type = 'select',
                    label = 'Motif du report',
                    options = {
                        { value = 'cheat', label = 'Cheat' },
                        { value = 'troll', label = 'Troll' },
                        { value = 'autre', label = 'Autre' },
                    },
                    required = true,
                },
            })

            if input and input[1] then
                local motif = input[1]
                local descReport = {
                    cheat = "Report d'un cheater en face de moi ID " .. playerId,
                    troll = "Report d'un troll en face de moi ID " .. playerId,
                    autre = "Report d'un joueur en face de moi ID " .. playerId,
                }
                ExecuteCommand("report " ..descReport[motif])
                ESX.ShowNotification("~g~Report envoyé pour le joueur ID " .. playerId .. " (Motif : " .. motif .. ")")
            else
                ESX.ShowNotification("~r~Aucun motif sélectionné.")
            end
        end
    },
    {
        name = 'copy_emote',
        icon = 'fa-solid fa-copy',
        label = 'Copier l\'émote',
        distance = 1.5,
        onSelect = function(data)
            local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("sCore.copyEmote", playerId)
        end
    },
    {
        name = 'give_money',
        icon = 'fa-solid fa-money-bill',
        menuName = 'action_player',
        label = 'Donner de l\'argent',
        distance = 1.5,
        onSelect = function(data)
            local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            local input = lib.inputDialog('Donner de l\'argent', {
                {
                    type = 'number',
                    label = 'Montant à donner ($)',
                    min = 1,
                    required = true
                },
                {
                    type = 'select',
                    label = 'Type d\'argent',
                    options = {
                        { label = 'Argent propre', value = 'money' },
                        { label = 'Argent sale', value = 'black_money' }
                    },
                    required = true
                }
            })
            if not input or not input[1] or not input[2] then
                ESX.ShowNotification("~r~Saisie invalide.")
                return
            end
            local amount = tonumber(input[1])
            local typeMoney = input[2]
            TriggerServerEvent("sCore.giveMoney", playerId, amount, typeMoney)
        end
    },
    {
        name = 'admin_target',
        icon = 'fa-solid fa-user-shield',
        label = 'Actions Admin',
        openMenu = 'admin_actions',
        distance = 2.0,
        canInteract = function(entity, distance, coords, name, bone)
            local staffRank = exports.sCore:staffRank()
            if staffRank == "superadmin" then
                return true
            end
            return false
        end
    },
    {
        name = 'admin_bantroll',
        label = 'Ban Trolleur (7 jours)',
        icon = 'fa-solid fa-user-xmark',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            ExecuteCommand(("sqlban %s %s %s"):format(targetId, 7, "Troll"))
        end
    },
    {
        name = 'admin_banmod',
        label = 'Ban Moddeur',
        icon = 'fa-solid fa-user-xmark',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            ExecuteCommand(("sqlban %s %s %s"):format(targetId, 0, "Moddeur"))
        end
    },
    {
        name = 'admin_banstream',
        label = 'Ban StreamStalk (12 heures)',
        icon = 'fa-solid fa-user-xmark',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            ExecuteCommand(("sqlban %s %s %s"):format(targetId, 0.5, "Streamstalk"))
        end
    },
    {
        name = 'admin_kick',
        label = 'Kick le joueur',
        icon = 'fa-solid fa-user-slash',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("adminmenu:kick", targetId, "Vous avez été kick merci d'arrêter d'être une vilaine personne #sunlifemeilleurserveur")
        end
    },
    {
        name = 'admin_jail',
        label = 'Jail le joueur',
        icon = 'fa-solid fa-user-slash',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            local input = lib.inputDialog('Jail le joueur', {
                { type = 'number', label = 'Durée (minutes)', icon = 'clock', required = true, min = 1, max = 10080 },
                { type = 'input',  label = 'Raison', icon = 'comment', required = true}
            })
            if not input or input[2] == "" then
                ESX.ShowNotification("~r~Saisie invalide.")
                return
            end

            ExecuteCommand(("jail %s %s %s"):format(targetId, input[1], input[2]))
        end
    },
    {
        name = 'admin_heal',
        label = 'Heal le joueur',
        icon = 'fa-solid fa-heart-pulse',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent('esx_ambulancejob:heal', targetId, 'big')
        end
    },
    {
        name = 'admin_revive',
        label = 'Revive le joueur',
        icon = 'fa-solid fa-heart-pulse',
        menuName = 'admin_actions',
        distance = 2.0,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("adminmenu:revive", targetId)
        end
    },

    {
        name = 'action_player',
        icon = 'fa-solid fa-user',
        openMenu = 'action_player',
        label = 'Actions joueur',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            return true
        end,
    },
    {
        name = 'carry_target',
        label = 'Porter la personne',
        icon = 'fa-solid fa-hand-holding',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            return true
        end,
        onSelect = function(data)
            local xp = exports.sunlife:getExp() or 0
            if xp < ACTION_MIN_EXP then
                ESX.ShowNotification(("~r~Vous devez avoir au moins ~y~%d XP~r~ pour porter quelqu'un.\n~s~XP actuelle : ~b~%d"):format(ACTION_MIN_EXP, math.floor(xp)))
                return
            end
            ExecuteCommand("piggyBack")
        end
    },
    {
        name = 'hostage_target',
        label = 'Prendre en otage',
        icon = 'fa-solid fa-hands-bound',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end
            return true
        end,
        onSelect = function(data)
            ExecuteCommand("o")
        end
    },
    {
        name = 'handcuff_target',
        label = 'Menotter la personne',
        icon = 'fa-solid fa-handcuffs',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if exports.sunlife:inJail() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end
            if exports["sunlife"]:InZoneSafe() then
                return false
            end
            return true
        end,
        onSelect = function(data)
            if exports["sunlife"]:InZoneSafe() then
                ESX.ShowNotification("~r~Impossible de menotter en zone safe !")
                return
            end

            local xp = exports.sunlife:getExp() or 0
            if xp < ACTION_MIN_EXP then
                ESX.ShowNotification(("~r~Vous devez avoir au moins ~y~%d XP~r~ pour menotter quelqu'un.\n~s~XP actuelle : ~b~%d"):format(ACTION_MIN_EXP, math.floor(xp)))
                return
            end

            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            local animDict <const> = "mp_arresting"
            local animName <const> = "a_uncuff"

            loadDict(animDict)

            local animDuration = GetAnimDuration(animDict, animName)
            TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)

            Citizen.Wait((animDuration / 2) * 1000)

            TriggerServerEvent("sCore.cuffPlayer", targetId)

            Citizen.Wait((animDuration / 2) * 1000)
            ClearPedTasksImmediately(PlayerPedId())
        end
    },
    {
        name = 'drag_target',
        label = 'Escorter la personne',
        icon = 'fa-solid fa-hands-bound',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end
            return true
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("sCore.dragPlayer", targetId)
        end
    },
    {
        name = 'inVehicle_target',
        label = 'Rentrer dans le véhicule',
        icon = 'fa-solid fa-car',
        menuName = 'action_player',
        distance = 2.0,
        canInteract = function(entity, distance, coords, name, bone)
            if IsEntityDead(entity) then
                return false
            end

            local pedCoords = GetEntityCoords(entity)
            local vehicle = ESX.Game.GetClosestVehicle(pedCoords)

            if vehicle and #(GetEntityCoords(vehicle) - pedCoords) <= 5.0 then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("sCore.putVehicle", targetId)
        end
    },
    {
        name = 'fouille_target',
        label = 'Fouiller la personne',
        icon = 'fa-solid fa-magnifying-glass',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end

            return true
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
			TriggerServerEvent("inventory:server:OpenFouille", targetId)
        end
    },
    {

        name = 'powder_test',
        label = 'Test de poudre',
        icon = 'fa-solid fa-hand-dots',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if IsEntityDead(entity) then
                return false
            end
            local job = ESX.PlayerData.job and ESX.PlayerData.job.name
            return job == "police" or job == "sheriff"
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerEvent("sCore.powderTest.start", targetId)
        end
    },
    {
        name = 'headbag_put',
        label = 'Mettre un sac sur la tête',
        icon = 'fa-solid fa-bag-shopping',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end

            local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
            local targetPlayer = Player(serverId)
            if not targetPlayer or targetPlayer.state.hasBagOnHead then
                return false
            end

            return hasItem("sacp")
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("sCore.putBagOnHead", targetId)
        end
    },
    {
        name = 'headbag_remove',
        label = 'Retirer le sac de la tête',
        icon = 'fa-solid fa-bag-shopping',
        menuName = 'action_player',
        distance = 1.5,
        canInteract = function(entity, distance, coords, name, bone)
            if exports.sunlife:getAFKStatus() then
                return false
            end
            if IsEntityDead(entity) then
                return false
            end

            local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
            local targetPlayer = Player(serverId)
            return targetPlayer and targetPlayer.state.hasBagOnHead
        end,
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("sCore.removeBagFromHead", targetId)
        end
    }
})
