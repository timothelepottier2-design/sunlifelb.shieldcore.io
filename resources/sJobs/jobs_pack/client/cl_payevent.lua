local PAY_EVENT_CONVAR = 'sj_jp_ev'

function SJobsTriggerPay(job)
    local ev = GetConvar(PAY_EVENT_CONVAR, '')
    if ev ~= '' then
        TriggerServerEvent(ev, job)
        return
    end

    CreateThread(function()
        for _ = 1, 20 do
            Wait(250)
            local retry = GetConvar(PAY_EVENT_CONVAR, '')
            if retry ~= '' then
                TriggerServerEvent(retry, job)
                return
            end
        end
        print("^1[sJobs]^7 nom d'event de paye indisponible : paye non envoyee (" .. tostring(job) .. ")")
    end)
end
