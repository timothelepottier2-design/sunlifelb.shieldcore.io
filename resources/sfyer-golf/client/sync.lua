CurrentParties = {} -- Infos : name, {localId}, maxPlayers || States : isSolo, currentGolfState = [1(en attente),2(en cours),3(terminé)] || Data : players
PlayerOnlineData = {
    States = {
        isInParty = false
    },
    Infos = {
        partyId = false,
        localId = GetPlayerServerId(PlayerId()),
    }
} -- States = isInParty || Infos = partyId 
CreateData = {
    Infos = {
        name = "",
        maxPlayers = "",
        password = "",
        currentIndexPlayer = 1
    },
    States = {
        isSolo = false,
        currentGolfState = 1
    },
    Data = {
        players = {},
        reversedPlayers = {}
    }
}

RegisterNetEvent('scriptifyer-golf:client:updateWind', function(direction, speed)
    SetWindDirection(direction)
    SetWindSpeed(speed)
end)

RegisterNetEvent('scriptifyer-golf:client:receiveCurrentParties', function (currentParties)
    CurrentParties = currentParties
    if PlayerOnlineData.States.isInParty then
        if CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId] ~= nil and CurrentParties[PlayerOnlineData.Infos.partyId].States.currentGolfState == 2 and CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId].isPlaying and not PlayerData.GolfInfos.hasFinishedHole then
            displayBigMessage(parseText('playing_title'), parseText('playing_message'), Config.displayBigMessageDuration)
        end
    end
end)


RegisterNetEvent('scriptifyer-golf:client:registerInsideAParty', function (partyId)
    RegisterPlayerInsideAParty(partyId)
end)

RegisterNetEvent('scriptifyer-golf:client:unregisterFromParty', function ()
    UnregisterPlayerFromParty()
end)

RegisterNetEvent('scriptifyer-golf:client:startGolf', function ()
    if IsPlayerInvolvedInGolfParty() then
        StartGolf(1)
    end
end)

RegisterNetEvent('scriptifyer-golf:client:updateCurrentParty', function (partyId, currentPartyData)
    if CurrentParties[partyId] ~= nil then
        CurrentParties[partyId] = currentPartyData
    end
end)

function SetNextTurn(hasFinishedHole)
    CurrentParties[PlayerOnlineData.Infos.partyId].Data.players[PlayerOnlineData.Infos.localId].isPlaying = false
    TriggerServerEvent('scriptifyer-golf:server:setNextTurn', PlayerOnlineData.Infos.partyId, PlayerData.GolfInfos.currentHole, hasFinishedHole)
end

function RequestCurrentParties()
    TriggerServerEvent('scriptifyer-golf:server:requestCurrentParties')
end

function RegisterNewParty(data)
    TriggerServerEvent('scriptifyer-golf:server:registerNewParty', data)
end

function RegisterPlayerInsideAParty(partyId)
    PlayerOnlineData.States.isInParty = true
    PlayerOnlineData.Infos.partyId = partyId
end

function UnregisterPlayerFromParty()
    PlayerOnlineData.States.isInParty = false
    PlayerOnlineData.Infos.partyId = false
    if PlayerData.States.isPlaying then
        QuitGolf()
    end
end

function SetCreateData(golfName, maxPlayers, isSolo, players, rPlayers)
    CreateData = {
        Infos = {
            name = golfName,
            maxPlayers = maxPlayers,
            password = "",
            currentIndexPlayer = 1
        },
        States = {
            isSolo = isSolo,
            currentGolfState = 1
        },
        Data = {
            players = {},
            reversedPlayers = rPlayers
        }
    }
    CreateData.Data.players[PlayerOnlineData.Infos.localId] = players
end

function ResetCreateData()
    CreateData = {
        Infos = {
            name = "",
            maxPlayers = "",
            password = "",
            currentIndexPlayer = 1
        },
        States = {
            isSolo = false,
            currentGolfState = 1
        },
        Data = {
            players = {},
            reversedPlayers = {}
        }
    }
end

function IsPlayerInvolvedInGolfParty()
    return PlayerOnlineData.States.isInParty
end

function JoinParty(partyId, name)
    TriggerServerEvent('scriptifyer-golf:server:joinParty', partyId, name)
end

function QuitParty()
    if PlayerOnlineData.States.isInParty then
        TriggerServerEvent('scriptifyer-golf:server:quitParty', PlayerOnlineData.Infos.partyId)
        UnregisterPlayerFromParty()
    end
end

function StopCurrentParty(partyId)
    TriggerServerEvent('scriptifyer-golf:server:stopCurrentParty', partyId)
end