local renfortConfig = {
    petite = {
        code = "CODE-2",
        importance = "~g~Légère",
        sounds = {
            "Start_Squelch",
            "OOB_Start",
            "End_Squelch"
        },
        color = 2
    },
    importante = {
        code = "CODE-3",
        importance = "~o~Importante",
        sounds = {
            "Start_Squelch",
            "OOB_Start",
            "End_Squelch"
        },
        color = 47
    },
    omgad = {
        code = "CODE-99",
        importance = "~r~URGENTE !\nDANGER IMPORTANT",
        sounds = {
            "Start_Squelch",
            "OOB_Start",
            "FocusIn",
            "End_Squelch",
            "FocusOut"
        },
        color = 1
    }
}
local statusConfig = {
    prise = {
        title = "Prise de service",
        code = "10-8",
        message = "Prise de service.",
        icon = "CHAR_CALL911",
    },
    fin = {
        title = "Fin de service",
        code = "10-10",
        message = "Fin de service.",
        icon = "CHAR_CALL911",
    },
    pause = {
        title = "Pause de service",
        code = "10-7",
        message = "Pause de service.",
        icon = "CHAR_CALL911",
    },
    standby = {
        title = "Mise en standby",
        code = "10-23",
        message = "Standby, en attente de dispatch.",
        icon = "CHAR_CALL911",
    },
    control = {
        title = "Contrôle routier",
        code = "10-38",
        message = "Contrôle routier en cours.",
        icon = "CHAR_CALL911",
    },
    refus = {
        title = "Refus d'obtempérer",
        code = "10-56",
        message = "Refus d'obtempérer en cours.",
        icon = "CHAR_CALL911",
    },
    crime = {
        title = "Crime en cours",
        code = "10-31",
        message = "Crime en cours / poursuite en cours.",
        icon = "CHAR_CALL911",
    },
    carburant = {
        title = "Ajout de carburant",
        code = "10-17",
        message = "Pause, ajout de carburant en cours.",
        icon = "CHAR_CALL911",
    },
    accident = {
        title = "Accident de la circulation",
        code = "10-50",
        message = "Un accident de la circulation est en cours.",
        icon = "CHAR_CALL911",
    }
}
RegisterNetEvent("sJobs.receiveRenfort", function(data)
    local renfort = renfortConfig[data.reason]
    if not renfort then
        return
    end

    for _, snd in ipairs(renfort.sounds) do
        local bank = snd:find("Focus") and "HintCamSounds" or "CB_RADIO_SFX"

        if snd == "OOB_Start" then
            bank = "GTAO_FM_Events_Soundset"
        end
        PlaySoundFrontend(-1, snd, bank, 1)
    end

    local serviceName = "INFORMATIONS"
    if data.job == "sheriff" then
        serviceName = "BSCO " .. serviceName
    else
        serviceName = "LSPD " .. serviceName
    end

    ESX.ShowAdvancedNotification(
        serviceName,
        "~b~Demande de renfort",
        ("Demande de renfort demandée.\nRéponse: ~g~%s\n~w~Importance: %s."):format(renfort.code, renfort.importance),
        "CHAR_CALL911",
        8
    )

    local blip = AddBlipForCoord(data.coords)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, renfort.color or 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("📡 Demande de renfort")
    EndTextCommandSetBlipName(blip)

    Citizen.CreateThread(function()
        Wait(60000)
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)

RegisterNetEvent("sJobs.receiveStatus", function(value, senderName)
    if not value then
        return
    end

    local config = statusConfig[value]
    if not config then
        ESX.ShowNotification(("~r~Statut inconnu reçu: %s"):format(value))
        return
    end

    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

    ESX.ShowAdvancedNotification(
        "INFORMATIONS",
        ("~b~%s"):format(config.title),
        ("Agent: ~g~%s\n~w~Code: ~g~%s\n~w~Information: ~g~%s"):format(senderName, config.code, config.message),
        config.icon,
        8
    )

    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
end)

RegisterNetEvent("sJobs.setBlipAlerte", function(position)
    if not position then
        return
    end

    local blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("📡 Alerte en cours")
    EndTextCommandSetBlipName(blip)

    Citizen.CreateThread(function()
        Wait(60000)
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)
