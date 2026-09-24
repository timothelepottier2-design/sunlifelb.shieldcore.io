DROP = {}
DROP.Cache = {}
DROP.Near = {}
DROP.Sublist = {}


CreateThread(function()
    while true do
        local pPos = GetEntityCoords(PlayerPedId())

        DROP.Near = {}

        for k, v in pairs(DROP.Cache) do
            local dst = GetDistanceBetweenCoords(v.pos.x, v.pos.y, v.pos.z, pPos.x, pPos.y, pPos.z, true)
            if dst <= 10.0 then
                if v.entity == nil then
                    v.entity = World.CreateLocalObject(v.props, v.pos)
                    PlaceObjectOnGroundProperly(v.entity)
                    FreezeEntityPosition(v.entity, true)
                    SetEntityCollision(v.entity, false, false)
                end
                table.insert(DROP.Near, v)
            else
                if v.entity then 
                    DeleteEntity(v.entity)
                    v.entity = nil 
                
                end
            end
        end
        Wait(400) -- Il peut être judicieux d'ajuster ce délai en fonction des besoins de performance de votre serveur.
    end
end)


-- CreateThread(function()
--     while true do
--         local pPos = GetEntityCoords(PlayerPedId())
--         for k,v in pairs(DROP.Cache) do
--             local dst = World.GetDistanceBetweenCoords(v.pos.xyz, pPos)
--             if dst <= 3.0 then
--                 DROP.Near[k] = v
--             else
--                 DROP.Near[k] = nil
--             end
--         end
--         Wait(300)
--     end
-- end)

-- Fonction pour afficher du texte en 3D
function DrawText3D(coords, text, size, font)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoord()
    local distance = #(coords - camCoords)

    if not size then size = 1.0 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(font)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255) -- Couleur du texte (blanc)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

function DrawText3D(coords, text, size, font)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoord()
    local distance = #(coords - camCoords)

    if not size then size = 1.0 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(font)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255) -- Couleur du texte (blanc)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

-- Événement pour créer un nouvel objet et afficher le texte
RegisterNetEvent("inventaire:drop:newdrop", function (data)
    -- Création de l'objet dans le monde
    data.entity = World.CreateLocalObject(data.props, data.pos)
    PlaceObjectOnGroundProperly(data.entity)
    FreezeEntityPosition(data.entity, true)
    SetEntityCollision(data.entity, false, false)

    -- Ajout des données dans le cache
    table.insert(DROP.Cache, data)

    -- Variable pour contrôler l'affichage du texte
    local showText = true

    -- Boucle pour afficher le texte flottant et gérer l'interaction
    CreateThread(function()
        while showText do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - data.pos)
            local exist = false 
            local Near = false
            for k, v in pairs(DROP.Cache) do 
                if v.pos.x == data.pos.x and v.name == data.name then 
                    exist = true
                end
            end
            if not exist then 
                showText = false 
            end
            -- Afficher le texte uniquement si le joueur est proche
            if distance < 10.0 then
                Near = true
                local text = "Ramasser [" .. data.count .. "] " .. data.label
                local textCoords = vector3(data.pos.x, data.pos.y, data.pos.z + 0.5) -- Ajuste la hauteur du texte
                DrawText3D(textCoords, text, 0.5, 4) -- Taille du texte augmentée à 0.5

                -- Vérifier si le joueur appuie sur E
                if IsControlJustReleased(0, 38) then -- 38 est la touche E
                    ExecuteCommand("e pickup") -- Jouer l'animation "pickup"
                    TriggerServerEvent("inventory:server:takeDrop", data.indexRandom, data.count, data.indexRandom)
                    showText = false -- Arrête l'affichage du texte
                    break -- Sort de la boucle
                end
            end
            if Near then 
                Wait(0)
            else
                Wait(500)
            end
        end
    end)
end)

-- Événement pour supprimer l'objet et arrêter l'affichage du texte
RegisterNetEvent("inventaire:drop:removedrop", function(index, number, random)
    index = tonumber(index)
    for key, value in pairs(DROP.Cache) do
        if value.indexRandom == random then
            index = key
        end
    end
    if index ~= nil then 
        if DROP.Cache[index] ~= nil  then
            DROP.Cache[index].count = DROP.Cache[index].count - number
            if DROP.Cache[index].count <= 0 then
                TriggerEvent("sotek_interact:client:removeInteract", "drop"..DROP.Cache[index].indexRandom)
                if DROP.Cache[index].entity ~= nil then
                    DeleteEntity(DROP.Cache[index].entity)
                end
                for key, value in pairs(DROP.Near) do
                    if value.indexRandom == random then
                        table.remove(DROP.Near, key)
                    end
                end
                DROP.Cache[index] = nil
            end
        end
    end
end)

RegisterCommand("dvdrops", function (source, args)
    if args[1] == nil then
        args[1] = 40
    end
    args[1] = tonumber(args[1])
    if args[1] > 40 then
        args[1] = 40
    end

    TriggerServerEvent("inventory:server:admin:removeprops", args[1])
end, false)
