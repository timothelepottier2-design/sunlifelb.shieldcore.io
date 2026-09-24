AutoConcess = AutoConcess or {}

AutoConcess.Account           = 'money'
AutoConcess.OpenKey           = 38
AutoConcess.OpenRadius        = 2.0
AutoConcess.AntiSpamMs        = 2500
AutoConcess.MarkerFarDistance = 90.0
AutoConcess.MarkerFarScale    = 2.0

AutoConcess.Shops = {
    {
        id = 'marina',
        type = 'boat',
        open = vec3(-761.106934, -1486.132690, 5.000524),
        preview = vec4(-823.765747, -1522.998291, -0.474494, 133.0),
        title = 'Concession Nautique'
    },
    {
        id = 'air',
        type = 'aircraft',
        open = vec3(-992.957581, -2945.975342, 13.057446),
        preview = vec4(-1002.606384, -2967.545166, 13.954197, 60.21276473999),
        title = 'Concession Aérien'
    }
}

AutoConcess.Catalog = {
    boat = {
        { uid = 'boat_seashark', name = 'Jetsky',     model = 'seashark', price = 75000,     vtype = 'boat' },
        { uid = 'boat_dinghy',   name = 'Dinghy',     model = 'dinghy',   price = 750000,    vtype = 'boat' },
        { uid = 'boat_suntrap',  name = 'Suntrap',    model = 'suntrap',  price = 1350000,   vtype = 'boat' },
        { uid = 'boat_avisa',    name = 'Sous Marin', model = 'avisa',    price = 15000000,  vtype = 'boat' },
        { uid = 'boat_tropic',   name = 'Tropic',     model = 'tropic',   price = 2250000,   vtype = 'boat' },
        { uid = 'boat_marquis',  name = 'Marquis',    model = 'marquis',  price = 3000000,   vtype = 'boat' },
        { uid = 'boat_squalo',   name = 'Squalo',     model = 'squalo',   price = 3750000,   vtype = 'boat' },
        { uid = 'boat_speeder2', name = 'Speeder',    model = 'speeder2', price = 4500000,   vtype = 'boat' },
        { uid = 'boat_toro2',    name = 'Toro',       model = 'toro2',    price = 5250000,   vtype = 'boat' },
        { uid = 'boat_longfin',  name = 'Longfin',    model = 'longfin',  price = 7500000,   vtype = 'boat' },
        { uid = 'boat_jetmax',   name = 'Jetmax',     model = 'jetmax',   price = 9000000,   vtype = 'boat' }
    },
    aircraft = {
        { uid = 'air_havok',        name = 'Havok (Helico)',        model = 'havok',        price = 15000000,  vtype = 'aircraft' },
        { uid = 'air_stunt',        name = 'Stunt (Avion)',         model = 'stunt',        price = 15000000,  vtype = 'aircraft' },
        { uid = 'air_mammatus',     name = 'Mammatus (Avion)',      model = 'mammatus',     price = 15000000,  vtype = 'aircraft' },
        { uid = 'air_velum',        name = 'Velum (Avion)',         model = 'velum',        price = 18000000,  vtype = 'aircraft' },
        { uid = 'air_seasparrow2',  name = 'Seasparrow (Helico)',   model = 'seasparrow2',  price = 18000000,  vtype = 'aircraft' },
        { uid = 'air_alphaz1',      name = 'Alpha Z (Avion)',       model = 'alphaz1',      price = 22500000,  vtype = 'aircraft' },
        { uid = 'air_buzzard2',     name = 'Buzzard (Helico)',      model = 'buzzard2',     price = 24000000,  vtype = 'aircraft' },
        { uid = 'air_maverick',     name = 'Maverick (Helico)',     model = 'maverick',     price = 27000000,  vtype = 'aircraft' },
        { uid = 'air_dodo',         name = 'Dodo (Avion)',          model = 'dodo',         price = 30000000,  vtype = 'aircraft' },
        { uid = 'air_frogger',      name = 'Frogger (Helico)',      model = 'frogger',      price = 36000000,  vtype = 'aircraft' },
        { uid = 'air_conada',       name = 'Conada (Helico)',       model = 'conada',       price = 42000000,  vtype = 'aircraft' },
        { uid = 'air_swift2',       name = 'Swift (Helico)',        model = 'swift2',       price = 45000000,  vtype = 'aircraft' },
        { uid = 'air_supervolito2', name = 'Supervolito (Helico)',  model = 'supervolito2', price = 52500000,  vtype = 'aircraft' },
        { uid = 'air_rogue',        name = 'Rogue (Avion)',         model = 'rogue',        price = 75000000,  vtype = 'aircraft' },
        { uid = 'air_nimbus',       name = 'Nimbus (Avion)',        model = 'nimbus',       price = 135000000, vtype = 'aircraft' },
        { uid = 'air_luxor2',       name = 'Luxor (Avion)',         model = 'luxor2',       price = 180000000, vtype = 'aircraft' },
        { uid = 'air_miljet',       name = 'Miljet (Avion)',        model = 'miljet',       price = 285000000, vtype = 'aircraft' },
        { uid = 'air_avenger',      name = 'Avenger (Avion)',       model = 'avenger',      price = 400000000, vtype = 'aircraft' }
    }
}
