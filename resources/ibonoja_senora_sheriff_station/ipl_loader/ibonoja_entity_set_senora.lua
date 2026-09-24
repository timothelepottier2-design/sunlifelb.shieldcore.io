local interiors = {
    {
        ipl = 'ibonoja_senora_sheriff_interior_milo_',
        coords = { x = 2810.473, y = 4731.34, z = 51.441 },
        entitySets = {
            { name = 'line_briefing', enable = true},
            { name = 'u_briefing', enable = false},
            { name = 'shooting_room', enable = true},
            { name = 'lab', enable = false},
            { name = 'dispatch_blinds', enable = true},
            { name = 'detective_blinds_up', enable = true},
            { name = 'detective_blinds_down', enable = false},
            { name = 'press_1', enable = true},
            { name = 'press_2', enable = false},
        }
    },
}

CreateThread(function()
    UpdateIPL()
end)

function UpdateIPL()
    for _, interior in ipairs(interiors) do
        if not interior.ipl or not interior.coords or not interior.entitySets then
            print('^5[IBONOJA]^7 ^1Error while loading interior.^7')
            return
        end
        RequestIpl(interior.ipl)
        local interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
        if IsValidInterior(interiorID) then
            for __, entitySet in ipairs(interior.entitySets) do
                if entitySet.enable then
                    EnableInteriorProp(interiorID, entitySet.name)
                    if entitySet.color then
                        SetInteriorPropColor(interiorID, entitySet.name, entitySet.color)
                    end
                else
                    DisableInteriorProp(interiorID, entitySet.name)
                end
            end
            RefreshInterior(interiorID)
        end
    end
    print("^5[IBONOJA]^7 Interiors datas loaded.")
end


RegisterNetEvent('ibonoja:setEntitySets', function(data)
    if not data then return end
    for k, v in pairs(data) do
        for _, v2 in ipairs(interiors) do
            for __, v3 in ipairs(v2.entitySets) do
                if v3.name == v.name then
                    v3.enable = v.enable
                    if v.color then
                        v3.color = v.color
                    end
                end
            end
        end
    end
    UpdateIPL()
end)