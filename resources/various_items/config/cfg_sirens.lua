ConfigSirens = {}

-- If set to true, only the light closest to the player will fully display. Any additional lights from vehicles further away will be optimized to reduce performance impact
-- In general, you can leave this off as the script is already optimized well, but if you expect 10+ vehicles in a compact area to be using the light simultaneously you could consider turning this on for a slightly better (ms) run-time
ConfigSirens.OptimizeMode = false

-- The speed multiplier for the light rotation, larger value means faster rotation
ConfigSirens.LightRotationSpeedMultiplier = 1.15

-- The required item to deploy a light, this can only be used if you have an inventory system to handle items
ConfigSirens.RequiredItem = {
    Enabled = true,
    Name = 'gyrophare'
}

-- Enable the command to toggle light on a vehicle (command = \light), you can use this if you do not have an inventory system to handle items
ConfigSirens.EnableLightCommand = true

-- The key which you can use to remove a light from the vehicle
ConfigSirens.RemoveLightKey = 36 -- L-CTRL

-- If you also want an optional siren to be usable with the deployable light, set Enabled to true
ConfigSirens.Siren = {
    Enabled = true,
    Key = 21, -- L-SHIFT
}

-- The blacklist for classes and models which cannot use the light
ConfigSirens.Blacklist = {
    ['classes'] = { 8, 13, 14, 15, 16, 21, 22 },
    ['models'] = { `adder` }
}

-- The settings corresponding to the light effect
ConfigSirens.LightSettings = {
    ['red'] = {
        LightPropHash = `hei_prop_wall_alarm_red`, -- Prop of the light
        RGB = vector3(255, 0, 0),                  -- RGB color of the light
        Distance = 12.0,                           -- The maximum distance the light can reach
        Brightness = 5.0,                          -- The brightness of the light
        Roundness = 2.0,                           -- "smoothness" of the circle edge
        Radius = 60.0,                             -- The radius size of the light
        Falloff = 3.0,                             -- The falloff size of the light's edge
    },
    ['blue'] = {
        LightPropHash = `hei_prop_wall_alarm_blue`,
        RGB = vector3(0, 0, 255),
        Distance = 12.0,
        Brightness = 5.0,
        Roundness = 2.0,
        Radius = 60.0,
        Falloff = 3.0,
    },
    ['orange'] = {
        LightPropHash = `hei_prop_wall_alarm_orange`,
        RGB = vector3(242, 87, 10),
        Distance = 12.0,
        Brightness = 5.0,
        Roundness = 2.0,
        Radius = 60.0,
        Falloff = 3.0,
    }
}

-- The defined animations applied when attaching/detaching the light
ConfigSirens.Animation = {
    ['default'] = {
        Dict = 'veh@drivebystd_ds_grenades',
        Name = 'throw_180r',
        AnimTime = 500,
        AttachBoneId = 18905, -- Left hand
        HandPosition = vector3(0.1, 0.0, 0.1),
        HandRotation = vector3(90.0, 0.0, 0.0),
    },
    ['front_window'] = {
        Dict = 'veh@van@ds@base',
        Name = 'change_station',
        AnimTime = 1500,
        AttachBoneId = 57005, -- Right hand
        HandPosition = vector3(0.1, 0.0, -0.05),
        HandRotation = vector3(180.0, 0.0, 0.0),
    },
    ['quad'] = {
        Dict = 'veh@bike@quad@front@base',
        Name = 'change_station',
        AnimTime = 1500,
        AttachBoneId = 57005, -- Right hand
        HandPosition = vector3(0.1, 0.05, 0.0),
        HandRotation = vector3(-90.0, 0.0, 0.0),
    },
}

-- The attachment information for the light, default is always used unless specified otherwise.
-- Position: Defines the light-prop coordinates w.r.t. the center of the vehicle. Leave at vector3(0.0, 0.0, 0.0) and the script will automatically try to estimate a good position.
-- Rotation: Defines the light-prop rotation.
-- Animation: The animation to play when attaching/detaching the light.
-- LightSetting: The light setting to use for the light.
-- SirenName: The siren name that can be used when the light is enabled, only works if ConfigSirens.Siren.Enabled is set to true. If SirenName is not defined, the siren cannot be used for that vehicle.
ConfigSirens.VehicleData = {
    ['default'] = { Position = vector3(0.0, 0.0, 0.0), Rotation = vector3(-95.0, -5.0, 0.0), Animation = 'default', LightSetting = 'red', SirenName = 'VEHICLES_HORNS_SIREN_1' },
    [`baller`] = { Position = vector3(0.0, 0.0, 0.0), Rotation = vector3(-90.0, -5.0, 0.0), Animation = 'default', LightSetting = 'blue', SirenName = 'VEHICLES_HORNS_SIREN_1' },
    [`blazer2`] = { Position = vector3(0.0, 0.15, 0.4), Rotation = vector3(-90.0, -0.0, 0.0), Animation = 'quad', LightSetting = 'red', SirenName = 'VEHICLES_HORNS_SIREN_2' },
    [`burrito4`] = { Position = vector3(0.0, 0.0, 0.0), Rotation = vector3(-95.0, -5.0, 0.0), Animation = 'default', LightSetting = 'orange' },
    [`zorrusso`] = { Position = vector3(0.3, 0.9, 0.29), Rotation = vector3(-90.0, 0.0, 0.0), Animation = 'front_window', LightSetting = 'blue' },
    -- You can add more unique vehicle settings here if you wish, the key should be the vehicle model hash
}
