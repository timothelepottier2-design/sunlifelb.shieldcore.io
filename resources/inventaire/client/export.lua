exports("GetSameMetadatas", function (metadatas1, metadatas2)
    return INVENTORY.AsSameMetadas(metadatas1, metadatas2)
end)

exports("IsMenuOpen", function ()
    return INVENTORY.Open
end)

exports("getActive", function ()
    return INVENTORY.ActivateInv
end)