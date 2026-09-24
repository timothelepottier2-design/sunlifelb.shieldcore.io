local inUi = false

function openDialog(title, cb) 
    SendNUIMessage({
        type = "enableui",
        title = title,
        enable = true
    })
    Wait(100)
    SetNuiFocus(true, true)
    inUi = true

    Citizen.CreateThread(function()
        while inUi do
            Citizen.Wait(0)
            for i=400, 1 do
                DisableControlAction(0, i, true)
            end
        end
    end)
    
    RegisterNUICallback("sumbit", function(v)
        cb(v)
        SetNuiFocus(false, false)
        inUi = false
    end)

    RegisterNUICallback("cancel", function(v)
        cb(v)
        SetNuiFocus(false, false)
        inUi = false
    end)
end