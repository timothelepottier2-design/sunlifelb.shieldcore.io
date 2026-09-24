cfg_camping = {}

cfg_camping.Items = {
    camp_tent_blue = {
        itemLabel = 'Tente bleue',
        prop = 'm23_2_prop_m32_tent_01a',
        price = 2500
    },
    camp_tent_big = {
        itemLabel = 'Tente chapiteau',
        prop = 'ba_prop_battle_tent_02',
        price = 6000
    },
    camp_campfire = {
        itemLabel = 'Feu de camp',
        prop = 'prop_beach_fire',
        price = 1200
    },
    camp_lounger = {
        itemLabel = 'Transat',
        prop = 'prop_yacht_lounger',
        price = 18000
    },
    camp_bbq = {
        itemLabel = 'Barbecue portable',
        prop = 'prop_bbq_2',
        price = 220
    }
}

cfg_camping.Place = {
    maxDistanceFromPlayer = 3.0,
    pickupDistance = 5.0
}

cfg_camping.AutoItems = {
    enabled = true,
    tableName = 'items',
    weight = 1,
    rare = 0,
    canRemove = 1
}

cfg_camping.Vendor = {
    model = `s_m_m_gardener_01`,
    coords = vec4(1429.6826171875, 4377.5004882812, 44.59928894043, 46.236827850342)
}
