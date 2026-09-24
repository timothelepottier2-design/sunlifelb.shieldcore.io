localReportsTable, reportCount, take = {},0,0

function generateReportDisplay()
    return "~s~Reports actifs: ~o~"..reportCount.."~s~ | En cours: ~y~"..take
end

local function safeInputDialog(heading, rows, options)
    if lib and type(lib.inputDialog) == "function" then
        return lib.inputDialog(heading, rows, options)
    end
    return exports.ox_lib:inputDialog(heading, rows, options)
end

local function safeAlertDialog(data)
    if lib and type(lib.alertDialog) == "function" then
        return lib.alertDialog(data)
    end
    return exports.ox_lib:alertDialog(data)
end

RegisterNetEvent("adminmenu:cbReportTable")
AddEventHandler("adminmenu:cbReportTable", function(table)
    reportCount = 0
    take = 0
    for source,report in pairs(table) do
        reportCount = reportCount + 1
        if report.taken then take = take + 1 end
    end
    localReportsTable = table
end)

RegisterNetEvent("adminmenu:alreadyHasReport", function()
    local ok, alert = pcall(safeAlertDialog, {
        header = '🚨 Report déjà actif !',
        content = 'Vous avez déjà un report en attente.\nVoulez-vous le supprimer pour en refaire un ?',
        centered = true,
        cancel = true
    })
    if not ok then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification("~r~Erreur d'ouverture du dialogue. Réessaie.")
        end
        return
    end
    if alert == "confirm" then
        TriggerServerEvent("adminmenu:cancelReport")
    end
end)

RegisterNetEvent("adminmenu:openInputReason", function()
    local ok, input = pcall(safeInputDialog, '🚨 Faire un report', {
        {type = 'input', label = 'Description de votre report', placeholder = 'Décrivez votre problème...'},
        {type = 'select', label = 'Catégorie', options = {
            {label = 'Bug', value = 'Bug'},
            {label = 'Cheateur', value = 'Cheat'},
            {label = 'Troll / Nuisance', value = 'Troll'},
            {label = 'Support / Aide', value = 'Support'}
        }},
        {type = 'select', label = 'Gravité estimée', options = {
            {label = 'Mineur', value = 'Mineur'},
            {label = 'Modéré', value = 'Moderer'},
            {label = 'Urgent', value = 'Urgent'}
        }}
    })

    if not ok then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification("~r~Erreur d'ouverture du formulaire. Réessaie.")
        end
        return
    end

    if input then
        local description = input[1]
        local category = input[2]
        local graviter = input[3]

        if description and description ~= "" and category and graviter then
            TriggerServerEvent("adminmenu:sendReport", {
                description = description,
                category = category,
                graviter = graviter
            })
        else
            ESX.ShowNotification("~r~Merci de remplir tous les champs du report.")
        end
    end
end)
