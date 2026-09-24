local blipsSociety <const> = {
    {name="AmmuNation (Armurerie)",color=0, id=110, Position = vector3(15.493109703064, -1104.7072753906, 29.10924911499)},
    {name="AmmuNation (Armurerie)",color=0, id=110, Position = vector3(816.62622070312, -2157.2416992188, 28.931238174438)},

    {name="Bobcat security",color=29, id=175, Position = vector3(-642.883301, -2382.553711, 13.461938)},
    {name="USSS",color=29, id=487, Position = vector3(126.822548, -741.238770, 242.152008)},
    {name="Département de la justice",color=0, id=408, Position = vector3(-531.8856, -180.3118, 43.36586)},
    {name="Gouvernement",color=0, id=408, Position = vector3(-436.105804, 1094.256104, 329.766998)},
    {name="Fourrière",color=81, id=473, Position = vector3(461.488739, -1158.307373, 29.418938)},
    {name="Grotti Automobile",color=46, id=595, Position = vector3(-922.67803955078, -2033.8723144531, 8.606404876709)},
    {name="LSFD",color=1, id=436, Position = vector3(-1037.74, -1400.60, 5.07)},
    {name="Benny's",color=50, id=488, Position = vector3(-198.9436, -1317.252, 30.30135)},
    {name="Harmony Customs",color=68, id=488, Position = vector3(56.467449, 6527.250488, 31.912933)},
    {name="Hayes Auto Body Shop",color=3, id=488, Position = vector3(-352.3579, -131.4634, 39.23618)},
    {name="Paleto Automobile",color=26, id=494, Position = vector3(-230.12515258789, 6221.39453125, 30.944082260132)},
    {name="Premium Deluxe Motorsport (Concession Automobile)",color=46, id=523, Position = vector3(-31.23, -1097.91, 26.37)},
    {name="Poste de Police",color=3, id=60, Position = vector3(-1087.498413, -807.830566, 27.065102)},
    {name="Sheriff Station",color=28, id=60, Position = vector3(2829.8540039062, 4738.4819335938, 56.485622406006)},
    {name="Agence Immo",color=43, id=475, Position = vector3(-705.1777, 269.0103, 82.1474)},
    {name="Hôpital",color=8, id=61, Position = vector3(-673.50476074219, 335.44946289062, 77.118324279785)},
    {name="Hôpital",color=8, id=61, Position = vector3(7495.529785, 401.184448, 57.815830)},
    {name="Studio",color=1, id=614, Position = vector3(473.4699, -105.6492, 63.15816)},
    {name="Bureau du Taxi",color=5, id=198, Position = vector3(-1251.0328369141, -277.39172363281, 37.682594299316)},
    {name="Weazle News",color=2, id=184, Position = vector3(-583.35, -928.46, 27.16)},

    {name="Lavage de Véhicule",color=22, id=100, Position = vector3(25.0216, -1392.0176, 28.3347)},
    {name="Lavage de Véhicule",color=22, id=100, Position = vector3(-699.8776, -932.6452, 18.0139)},

    {name="Bucheron",color=56, id=285, Position = vector3(-556.2967, 5364.0430, 69.3248)},

    {name="Assurance automobile",color=3, id=545, Position = vector3(198.900284, 376.050110, 107.614182)},
    {name="Street Tuners",color=22, id=488, Position = vector3(5128.878906, -5130.602539, 2.213864)},
}

AddTextEntry("BLIP_10", "Entreprises")

Citizen.CreateThread(function()
    for k, v in ipairs(blipsSociety) do

        local key = ("BN_SJOBS_SOCIETY_%d"):format(k)
        AddTextEntry(key, v.name)

        local blip = AddBlipForCoord(v.Position)
        SetBlipSprite(blip, v.id)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, v.color)
        SetBlipAsShortRange(blip, true)
        SetBlipCategory(blip, 10)

        BeginTextCommandSetBlipName(key)
        EndTextCommandSetBlipName(blip)
    end
end)
