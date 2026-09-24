staffRank = "user"

RegisterNetEvent("sCore.valueRankStaff", function(rank)
    staffRank = rank
end)

CreateThread(function()
    Wait(1500)
    TriggerServerEvent("sCore.requestRankStaff")
end)

exports("staffRank", function()
    return staffRank
end)
