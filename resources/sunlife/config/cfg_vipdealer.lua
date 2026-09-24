VipDealer = VipDealer or {}

VipDealer.UI = {
    title       = 'SUNLIFE',
    subtitle    = 'Concessionnaire VIP',
    bannerR     = 255,
    bannerG     = 117,
    bannerB     = 31,
    bannerA     = 225,
    markerR     = 255,
    markerG     = 117,
    markerB     = 31,
    markerA     = 120,
    blipSprite  = 326,
    blipColour  = 47,
    blipScale   = 0.85,
    blipName    = 'Concessionnaire VIP',
}

VipDealer.ped = {
    model   = 's_m_y_dealer_01',
    coords  = vector3(-211.172562, -2001.192139, 27.755428),
    heading = 264.19909667969,
}

VipDealer.previewCam = {
    coords  = vector3(-199.281174, -2011.104370, 27.620419),
    heading = 121.69761657715,
}

VipDealer.showroom = {
    coords  = vector3(-207.416245, -2012.216675, 27.620426),
    heading = 254.79765319824,
}

VipDealer.spawn = {
    coords  = vector3(-202.646851, -2020.173218, 27.048885),
    heading = 340.61141967773,
}

VipDealer.markerDistance   = 18.0
VipDealer.interactDistance = 2.4
VipDealer.openKey          = 38

VipDealer.vehicles = {
    { name = 'GB Sidewinder',    hash = 'gbsidewinder', price = 3000000,  rank = 'gold'      },
    { name = 'GB Hades',         hash = 'gbhades',      price = 4500000,  rank = 'gold'      },
    { name = 'GB Mojave',        hash = 'gbmojave',     price = 9000000,  rank = 'gold'      },
    { name = 'GB Ten FR',        hash = 'gbtenfr',      price = 10500000, rank = 'diamond'   },
    { name = 'GB Voyager 700kg', hash = 'gbvoyagerb2',  price = 10500000, rank = 'diamond'   },
    { name = 'Deity Mansory',    hash = 'deitymansory', price = 13500000, rank = 'diamond'   },
    { name = 'Baller P5X',       hash = 'ballerp5x',    price = 22500000, rank = 'platinium' },
    { name = 'Semicerb',         hash = 'semicerb',     price = 25500000, rank = 'legendary' },
    { name = 'Enus Regent',      hash = 'eregent',      price = 37500000, rank = 'legendary' },
}
