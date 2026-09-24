RegisterNetEvent('antisbire:noclip:uploadSS')
AddEventHandler('antisbire:noclip:uploadSS', function(webhook, token)
    if type(webhook) ~= 'string' or webhook == '' then
        TriggerServerEvent('antisbire:noclip:ssReport', '', token, 'webhook invalide cote client')
        return
    end

    local okExp, ssExp = pcall(function() return exports['screenshot-basic'] end)
    if not okExp or not ssExp then
        TriggerServerEvent('antisbire:noclip:ssReport', '', token, 'screenshot-basic introuvable cote client')
        return
    end

    local ok = pcall(function()
        exports['screenshot-basic']:requestScreenshotUpload(webhook, 'files[]', { encoding = 'png' }, function(data)
            local body = json.decode(data or '{}')
            local imageUrl
            if body and body.attachments and body.attachments[1] and body.attachments[1].url then
                imageUrl = body.attachments[1].url
            end
            TriggerServerEvent('antisbire:noclip:ssReport', imageUrl or '', token, 'ok')
        end)
    end)

    if not ok then
        TriggerServerEvent('antisbire:noclip:ssReport', '', token, 'exception requestScreenshotUpload')
    end
end)
