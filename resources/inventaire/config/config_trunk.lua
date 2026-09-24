ConfigShared.Trunk = {}

ConfigShared.Trunk.BlacklistedVehicleTypes = {13, 8} -- Cycles and Motorcycles | default: {13, 8}
ConfigShared.Trunk.TrunkIndividualWeights = {
  ["inter6x6"] = 5000,
  ["nspeedo"] = 400,
  ["gstbisxl5"] = 500,
  ["benefactor"] = 1000
}
ConfigShared.Trunk.TrunkClassWeights = {
  [0] = 50, --Compact
  [1] = 60, --Sedan
  [2] = 90, --SUV
  [3] = 20, --Coupes
  [4] = 30, --Muscle
  [5] = 20, --Sports Classics
  [6] = 20, --Sports
  [7] = 15, --Super
  [8] = 0, --Motorcycles
  [9] = 100, --Off-road
  [10] = 1000, --Industrial
  [11] = 120, --Utility
  [12] = 110, --Vans
  [13] = 0, --Cycles
  [14] = 30, --Boats
  [15] = 0, --Helicopters
  [16] = 0, --Planes
  [17] = 100, --Service
  [18] = 100, --Emergency
  [19] = 400, --Military
  [20] = 100, --Commercial
  [21] = 0 --Trains
}