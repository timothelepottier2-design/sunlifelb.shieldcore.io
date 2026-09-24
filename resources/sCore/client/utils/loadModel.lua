function loadModel(prop)
    local hash = type(prop) == "number" and prop or GetHashKey(prop)

    if not IsModelInCdimage(hash) then
        return false
    end
    if HasModelLoaded(hash) then
        return true
    end

    RequestModel(hash)

    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() > timeout then
            return false
        end
    end

    return true
end
