local selecting = false
local opponentServerId = nil
local displayThread = nil

local function notify(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

local function choiceToSymbol(choice)
    if choice == 1 then
        return '✊'
    elseif choice == 2 then
        return '✋'
    elseif choice == 3 then
        return '✌️'
    end
    return '?'
end

local function choiceToEmoteKey(choice)
    if choice == 1 then
        return "rock"
    elseif choice == 2 then
        return "paper"
    elseif choice == 3 then
        return "scissors"
    end
    return nil
end

local function resultToEmoteKey(result)
    if result == 'win' then
        return "win"
    elseif result == 'lose' then
        return "lose"
    elseif result == 'tie' then
        return "tie"
    end
    return nil
end

Emotes = {

	["rock"] = { "baspel@rock@animation", "rock_clip" },
	["paper"] = { "baspel@paper@animation", "paper_clip" },
	["scissors"] = { "baspel@scissors@animation", "scissors_clip" },

	["win"] = { "anim@amb@nightclub@peds@", "amb_world_human_cheering_female_c" },
	["lose"] = { "oddjobs@towingangryidle_a", "idle_a" },
	["tie"] = { "oddjobs@towingangryidle_a", "idle_a" },
}

local function playEmoteSequence(choiceName, resultName)
    CreateThread(function()
        local function playOne(name)
            if not name then return end
            local emote = Emotes[name]
            if not emote then return end

            local dict, anim = emote[1], emote[2]
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Wait(0)
            end

            local ped = PlayerPedId()
            TaskPlayAnim(ped, dict, anim, 8.0, -8.0, 10 * 1000, 0, 0.0, false, false, false)

            local duration = GetAnimDuration(dict, anim)
            if duration <= 0 then
                duration = 1.5
            end

            RemoveAnimDict(dict)
        end

        playOne(choiceName)
        playOne(resultName)
    end)
end

local function drawText3D(coords, text)
    local x, y, z = coords.x, coords.y, coords.z
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

exports.ox_target:addGlobalPlayer({
    {
        label = 'Demander un Shifoumi',
        icon = 'fa-solid fa-hand',
        onSelect = function(data)
            local targetPed = data.entity
            if not targetPed or not DoesEntityExist(targetPed) then return end
            local targetPlayer = NetworkGetPlayerIndexFromPed(targetPed)
            if targetPlayer == -1 then return end
            local targetServerId = GetPlayerServerId(targetPlayer)
            TriggerServerEvent('shifoumi:request', targetServerId)
        end
    }
})

RegisterNetEvent('shifoumi:notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('shifoumi:start', function(otherId)
    opponentServerId = otherId
    selecting = true
    notify('Shifoumi lancé avec le joueur '..otherId..' ~n~Appuie sur ↓ = ✊, ↑ = ✋, → = ✌️')

    CreateThread(function()
        while selecting do
            Wait(0)
            if IsControlJustPressed(0, 173) then
                selecting = false
                TriggerServerEvent('shifoumi:choice', 1)
                notify('Tu as choisi ✊')
            elseif IsControlJustPressed(0, 172) then
                selecting = false
                TriggerServerEvent('shifoumi:choice', 2)
                notify('Tu as choisi ✋')
            elseif IsControlJustPressed(0, 175) then
                selecting = false
                TriggerServerEvent('shifoumi:choice', 3)
                notify('Tu as choisi ✌️')
            end
        end
    end)
end)

RegisterNetEvent('shifoumi:showResult', function(myChoice, oppChoice, result, otherId)
    local mySymbol = choiceToSymbol(myChoice)
    local oppSymbol = choiceToSymbol(oppChoice)
    local txt

    if result == 'win' then
        txt = 'Tu gagnes ! '..mySymbol..' bat '..oppSymbol
    elseif result == 'lose' then
        txt = 'Tu perds ! '..oppSymbol..' bat '..mySymbol
    else
        txt = 'Égalité ! '..mySymbol..' = '..oppSymbol
    end
    notify(txt)

    local choiceEmote = choiceToEmoteKey(myChoice)
    local resultEmote = resultToEmoteKey(result)
    playEmoteSequence(choiceEmote, resultEmote)

    if displayThread then
        displayThread = nil
    end

    local otherSid = otherId or opponentServerId
    displayThread = CreateThread(function()
        local start = GetGameTimer()
        while GetGameTimer() - start < 5000 do
            Wait(0)
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            drawText3D(vector3(myCoords.x, myCoords.y, myCoords.z + 1.0), mySymbol)

            if otherSid then
                local otherPlayer = GetPlayerFromServerId(otherSid)
                if otherPlayer ~= -1 then
                    local otherPed = GetPlayerPed(otherPlayer)
                    if DoesEntityExist(otherPed) then
                        local coords = GetEntityCoords(otherPed)
                        drawText3D(vector3(coords.x, coords.y, coords.z + 1.0), oppSymbol)
                    end
                end
            end
        end
        displayThread = nil
        opponentServerId = nil
    end)
end)
