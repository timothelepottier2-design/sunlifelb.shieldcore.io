PERF = {}
PERF.LOD = 1.0
PERF.Distance_cars = true
PERF.Loop = false

function PERF.SetLod(value)
    PERF.LOD = value
    if PERF.LOD < 1.0 then
        PERF.StartLoop()
    else
        PERF.Loop = false
    end
end

function PERF.StartLoop()
    if not PERF.Loop then
        PERF.Loop = true
        Citizen.CreateThread(function()
            while PERF.Loop do
                OverrideLodscaleThisFrame(PERF.LOD)
                Wait(1)
            end
        end)
    end
end

AddEventHandler("F5:client:PerfChangeLod", function(lod)
    PERF.SetLod(lod)
end)

ESX_LOAD.Load(function()
    SetDistantCarsEnabled(false)
end)
