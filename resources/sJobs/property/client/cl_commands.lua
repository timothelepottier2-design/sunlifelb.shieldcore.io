RegisterCommand("deco", function(source, args, rawCommand)
    if not PROPERTY["propertyIdr"] then
        ESX.ShowNotification("~r~Vous n'êtes pas dans une propriété")
        return
    end

    if not PROPERTY["owned"] then
        if PROPERTY["coOwned"] then
            if PROPERTY["hideList"]["editMode"] then
                ESX.ShowNotification("~r~Vous n'avez pas la permission de meubler cette propriété")
                return
            end
        else
            ESX.ShowNotification("~r~Vous ne pouvez pas meubler cette propriété")
            return
        end
    end

    ESX.TriggerServerCallback("property:canEdit", function(can)
        if can then
            PROPERTY["openEditMode"]()
        end
    end, {
        propertyId = PROPERTY["propertyIdr"],
    })
end)
