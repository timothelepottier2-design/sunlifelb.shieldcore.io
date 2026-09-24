UTILS = {}

PROPERTY_BLIP_CATEGORY = 12

PROPERTY_BLIP_GROUP_GXT  = "BN_PROPERTY_GROUP"
PROPERTY_BLIP_GROUP_NAME = "Propriété"

CreateThread(function()
    AddTextEntry(PROPERTY_BLIP_GROUP_GXT, PROPERTY_BLIP_GROUP_NAME)
end)

UTILS.KeyboardInput = function(one, two, max)
    local i = nil

    exports.dialog:openDialog(one, function(value)
        i = value
    end)
    while i == nil do Wait(1) end
    i = tostring(i)

    return i
end

exports("KeyboardInput", UTILS.KeyboardInput)

UTILS.CreateBlip = function(data)
	local blip = AddBlipForCoord(data.pos)

	SetBlipSprite(blip, data.sprite)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, data.color)
	SetBlipScale(blip, data.scale)
	SetBlipAsShortRange(blip, true)
	SetBlipCategory(blip, PROPERTY_BLIP_CATEGORY)

	BeginTextCommandSetBlipName(PROPERTY_BLIP_GROUP_GXT)
	EndTextCommandSetBlipName(blip)

	return blip
end

UTILS.TableCount = function(tbl, checkCount)
    if not tbl or type(tbl) ~= "table" then
        return not checkCount and 0
    end
    local n = 0
    for k, v in pairs(tbl) do
        n = n + 1
        if checkCount and n >= checkCount then
            return true
        end
    end
    return not checkCount and n
end
