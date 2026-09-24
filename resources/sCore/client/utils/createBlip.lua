local _blipNameCounter = 0

function safeBlipName(blip, name)
    if not blip or not DoesBlipExist(blip) or type(name) ~= 'string' or name == '' then
        return
    end

    _blipNameCounter = _blipNameCounter + 1
    local key = ('BN_SCORE_%d'):format(_blipNameCounter)

    AddTextEntry(key, name)
    BeginTextCommandSetBlipName(key)
    EndTextCommandSetBlipName(blip)
end

function createBlip(position, name)
    local blip = AddBlipForCoord(position)

    SetBlipSprite(blip, 67)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)

    safeBlipName(blip, name)

    return blip
end
