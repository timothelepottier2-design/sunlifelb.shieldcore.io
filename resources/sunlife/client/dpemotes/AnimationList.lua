DP = {}

DP.GunStyles = {
    [1] = {name = "De base",  a = "default"},
    [2] = {name = "Hillbilly", a = "Hillbilly", b = "combat@aim_variations@1h@hillbilly", c = "aim_variation_a"},
    [3] = {name = "Gang",      a = "Gang1H",    b = "combat@aim_variations@1h@gang",      c = "aim_variation_a"},
    [4] = {name = "Costaud",   a = "Tough_Guy", b = "combat@aim_variations@1h@tough_guy", c = "aim_variation_a"},
    [5] = {name = "Femme",     a = "Female",    b = "combat@aim_variations@1h@female",    c = "aim_variation_a"},
}

DP.Expressions = {
    ["Énervé"] = { "Expression", "mood_angry_1" },
    ["Bourré"] = { "Expression", "mood_drunk_1" },
    ["Débile"] = { "Expression", "pose_injured_1" },
    ["Électrocuté"] = { "Expression", "electrocuted_1" },
    ["Grincheux"] = { "Expression", "effort_1" },
    ["Grincheux 2"] = { "Expression", "mood_drivefast_1" },
    ["Grincheux 3"] = { "Expression", "pose_angry_1" },
    ["Joyeux"] = { "Expression", "mood_happy_1" },
    ["Blessé"] = { "Expression", "mood_injured_1" },
    ["Joyeux 2"] = { "Expression", "mood_dancing_low_1" },
    ["Bouche bée"] = { "Expression", "smoking_hold_1" },
    ["Cligne pas des yeux"] = { "Expression", "pose_normal_1" },
    ["Oeil crevé"] = { "Expression", "pose_aiming_1" },
    ["Choqué"] = { "Expression", "shocked_1" },
    ["Choqué 2"] = { "Expression", "shocked_2" },
    ["Endormi"] = { "Expression", "mood_sleeping_1" },
    ["Endormi 2"] = { "Expression", "dead_1" },
    ["Endormi 3"] = { "Expression", "dead_2" },
    ["Content"] = { "Expression", "mood_smug_1" },
    ["Spéculatif"] = { "Expression", "mood_aiming_1" },
    ["Stressé"] = { "Expression", "mood_stressed_1" },
    ["Boude"] = { "Expression", "mood_sulk_1" },
    ["Bizarre"] = { "Expression", "effort_2" },
    ["Bizarre 2"] = { "Expression", "effort_3" },
}

DP.Walks = {
    ["Alien"] = { "move_m@alien" },
    ["Blindé"] = { "anim_group_move_ballistic" },
    ["Arrogant"] = { "move_f@arrogant@a" },
    ["Brave"] = { "move_m@brave" },
    ["Occasionnel"] = { "move_m@casual@a" },
    ["Occasionnel 2"] = { "move_m@casual@b" },
    ["Occasionnel 3"] = { "move_m@casual@c" },
    ["Occasionnel 4"] = { "move_m@casual@d" },
    ["Occasionnel 5"] = { "move_m@casual@e" },
    ["Occasionnel 6"] = { "move_m@casual@f" },
    ["Chichi"] = { "move_f@chichi" },
    ["Confident"] = { "move_m@confident" },
    ["Policier"] = { "move_m@business@a" },
    ["Policier 2"] = { "move_m@business@b" },
    ["Policier 3"] = { "move_m@business@c" },

    ["Bourré"] = { "move_m@drunk@a" },
    ["Bourré"] = { "move_m@drunk@slightlydrunk" },
    ["Bourré 2"] = { "move_m@buzzed" },
    ["Bourré 3"] = { "move_m@drunk@verydrunk" },
    ["Femme"] = { "move_f@femme@" },
    ["Feu"] = { "move_characters@franklin@fire" },
    ["Feu 2"] = { "move_characters@michael@fire" },
    ["Feu 3"] = { "move_m@fire" },
    ["Fuir"] = { "move_f@flee@a" },
    ["Franklin"] = { "move_p_m_one" },
    ["Gangster"] = { "move_m@gangster@generic" },
    ["Gangster 2"] = { "move_m@gangster@ng" },
    ["Gangster 3"] = { "move_m@gangster@var_e" },
    ["Gangster 4"] = { "move_m@gangster@var_f" },
    ["Gangster 5"] = { "move_m@gangster@var_i" },
    ["Grooving"] = { "anim@move_m@grooving@" },
    ["Gardien"] = { "move_m@prison_gaurd" },
    ["Menottes"] = { "move_m@prisoner_cuffed" },
    ["Talons"] = { "move_f@heels@c" },
    ["Talons 2"] = { "move_f@heels@d" },
    ["Randonnée"] = { "move_m@hiking" },
    ["Hipster"] = { "move_m@hipster@a" },
    ["Hobo"] = { "move_m@hobo@a" },
    ["Pressé"] = { "move_f@hurry@a" },
    ["Concierge"] = { "move_p_m_zero_janitor" },
    ["Concierge 2"] = { "move_p_m_zero_slow" },
    ["Jog"] = { "move_m@jog@" },
    ["Lemar"] = { "anim_group_move_lemar_alley" },
    ["Lester"] = { "move_heist_lester" },
    ["Lester 2"] = { "move_lester_caneup" },
    ["Maneater"] = { "move_f@maneater" },
    ["Michael"] = { "move_ped_bucket" },
    ["Money"] = { "move_m@money" },
    ["Muscle"] = { "move_m@muscle@a" },
    ["Posh"] = { "move_m@posh@" },
    ["Posh 2"] = { "move_f@posh@" },
    ["Quick"] = { "move_m@quick" },
    ["Runner"] = { "female_fast_runner" },
    ["Sad"] = { "move_m@sad@a" },
    ["Sassy"] = { "move_m@sassy" },
    ["Sassy 2"] = { "move_f@sassy" },
    ["Scared"] = { "move_f@scared" },
    ["Sexy"] = { "move_f@sexy@a" },
    ["Shady"] = { "move_m@shadyped@a" },
    ["Slow"] = { "move_characters@jimmy@slow@" },
    ["Swagger"] = { "move_m@swagger" },
    ["Tough"] = { "move_m@tough_guy@" },
    ["Tough 2"] = { "move_f@tough_guy@" },
    ["Trash"] = { "clipset@move@trash_fast_turn" },
    ["Trash 2"] = { "missfbi4prepp1_garbageman" },
    ["Trevor"] = { "move_p_m_two" },
    ["Wide"] = { "move_m@bag" },
    ["Chubby Male"] = { "move_chubby" },
    ["Chubby Female"] = { "move_f@chubby@a" },
	["Depressed"] = { "move_m@depressed@a" },
	["Depressed 2"] = { "move_m@depressed@b" },

}

DP.Couple = {
    ["coupleembr"] = {"tigerle@custom@couple@kissing2a", "tigerle_couple_kissing2a", "Couple qui s'embrasse", "coupleembr2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["coupleembr2"] = {"tigerle@custom@couple@kissing2b", "tigerle_couple_kissing2b", "Couple qui s'embrasse 2", "coupleembr", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zb"] = {"tigerle@custom@couple@standcuddle_a", "tigerle_couple_standcuddle_a", "your name for the Animation", "zb2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.35,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 180.0,
    }},
    ["zb2"] = {"tigerle@custom@couple@standcuddle_b", "tigerle_couple_standcuddle_b", "your name for the Animation", "zb", AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Atatchto = true,
            xPos = 0.0,
            yPos = 0.35,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 180.0,
    }},
    ["zc"] = {"tigerle@custom@couple@kissing1a", "tigerle_couple_kissing1a", "your name for the Animation", "zc2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zc2"] = {"tigerle@custom@couple@kissing1b", "tigerle_couple_kissing1b", "your name for the Animation", "zc", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zd"] = {"tigerle@custom@couple@standing_a", "tigerle_couple_standing_a", "your name for the Animation", "zd2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = -0.10,
        yPos = -0.30,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zd2"] = {"tigerle@custom@couple@standing_b", "tigerle_couple_standing_b", "your name for the Animation", "zd", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.10,
        yPos = 0.30,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["ze"] = {"tigerle@custom@pose@bff1a", "tigerle_pose_bff1a", "your name for the Animation", "ze2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = -0.70,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["ze2"] = {"tigerle@custom@pose@bff1b", "tigerle_pose_bff1b", "your name for the Animation", "ze", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.70,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zf"] = {"tigerle@custom@couple@laying1a", "tigerle_couple_laying1a", "your name for the Animation", "zf2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zf2"] = {"tigerle@custom@couple@laying1b", "tigerle_couple_laying1b", "your name for the Animation", "zf", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zg"] = {"tigerle@custom@couple@cuddle1a", "tigerle_couple_cuddle1a", "your name for the Animation", "zg2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
    ["zg2"] = {"tigerle@custom@couple@cuddle1b", "tigerle_couple_cuddle1b", "your name for the Animation", "zg", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        Atatchto = true,
        xPos = 0.0,
        yPos = 0.0,
        zPos = 0.0,
        xRot = 0.0,
        yRot = 0.0,
        zRot = 0.0,
    }},
}

DP.Shared = {

    ["pcarrya1"] = {
        "pcarrya1@animations",
        "pcarrya1clip",
        "PCarry 1 Shoulder Covering Eyes",
        "pcarrya2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarrya2"] = {
        "pcarrya2@animations",
        "pcarrya2clip",
        "PCarry 2 Shoulder Covering Eyes",
        "pcarrya1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.000,
            yPos = 0.000,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryb1"] = {
        "pcarryb1@animations",
        "pcarryb1clip",
        "PCarry 1 Struggle Behind",
        "pcarryb2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryb2"] = {
        "pcarryb2@animations",
        "pcarryb2clip",
        "PCarry 2 Struggle Behind",
        "pcarryb1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.000,
            yPos = 0.000,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryc1"] = {
        "pcarryc1@animations",
        "pcarryc1clip",
        "PCarry 1 Dead Behind",
        "pcarryc2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryc2"] = {
        "pcarryc2@animations",
        "pcarryc2clip",
        "PCarry 2 Dead Behind",
        "pcarryc1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.360,
            yPos = 0.000,
            zPos = -0.020,
            xRot = 0.0,
            yRot = 0.0,
            zRot = -10.0
        }
    },
    ["pcarryd1"] = {
        "pcarryd1@animations",
        "pcarryd1clip",
        "PCarry 1 Firemans Shoulder",
        "pcarryd2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryd2"] = {
        "pcarryd2@animations",
        "pcarryd2clip",
        "PCarry 2 Firemans Shoulder",
        "pcarryd1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.120,
            yPos = -0.150,
            zPos = -0.050,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -3.000
        }
    },
    ["pcarrye1"] = {
        "pcarrye1@animations",
        "pcarrye1clip",
        "PCarry 1 Standing Shoulder",
        "pcarrye2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarrye2"] = {
        "pcarrye2@animations",
        "pcarrye2clip",
        "PCarry 2 Standing Shoulder",
        "pcarrye1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.230,
            yPos = 0.020,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryf1"] = {
        "pcarryf1@animations",
        "pcarryf1clip",
        "PCarry 1 Meditation Feet On Head",
        "pcarryf2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryf2"] = {
        "pcarryf2@animations",
        "pcarryf2clip",
        "PCarry 2 Meditation Feet On Head",
        "pcarryf1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.230,
            yPos = 0.020,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryg1"] = {
        "pcarryg1@animations",
        "pcarryg1clip",
        "PCarry 1 Superman",
        "pcarryg2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryg2"] = {
        "pcarryg2@animations",
        "pcarryg2clip",
        "PCarry 2 Superman",
        "pcarryg1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.850,
            yPos = -0.120,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryh1"] = {
        "pcarryh1@animations",
        "pcarryh1clip",
        "PCarry 1 Cute Shoulder Back",
        "pcarryh2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryh2"] = {
        "pcarryh2@animations",
        "pcarryh2clip",
        "PCarry 2 Cute Shoulder Back",
        "pcarryh1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.130,
            yPos = -0.130,
            zPos = -0.050,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryi1"] = {
        "pcarryi1@animations",
        "pcarryi1clip",
        "PCarry 1 Bird",
        "pcarryi2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryi2"] = {
        "pcarryi2@animations",
        "pcarryi2clip",
        "PCarry 2 Bird",
        "pcarryi1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.700,
            yPos = -0.330,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -15.000
        }
    },
    ["pcarryj1"] = {
        "pcarryj1@animations",
        "pcarryj1clip",
        "PCarry 1 Woohoo",
        "pcarryj2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryj2"] = {
        "pcarryj2@animations",
        "pcarryj2clip",
        "PCarry 2 Woohoo",
        "pcarryj1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.350,
            yPos = -0.490,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -30.000
        }
    },
    ["pcarryk1"] = {
        "pcarryk1@animations",
        "pcarryk1clip",
        "PCarry 1 Sad Curl Up",
        "pcarryk2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryk2"] = {
        "pcarryk2@animations",
        "pcarryk2clip",
        "PCarry 2 Sad Curl Up",
        "pcarryk1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.060,
            yPos = 0.100,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryl1"] = {
        "pcarryl1@animations",
        "pcarryl1clip",
        "PCarry 1 Sad Front",
        "pcarryl2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryl2"] = {
        "pcarryl2@animations",
        "pcarryl2clip",
        "PCarry 2 Sad Front",
        "pcarryl1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.050,
            yPos = 0.070,
            zPos = 0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarrym1"] = {
        "pcarrym1@animations",
        "pcarrym1clip",
        "PCarry 1 Standing Upside Down",
        "pcarrym2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarrym2"] = {
        "pcarrym2@animations",
        "pcarrym2clip",
        "PCarry 2 Standing Upside Down",
        "pcarrym1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.820,
            yPos = 0.150,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 5.000
        }
    },
    ["pcarryn1"] = {
        "pcarryn1@animations",
        "pcarryn1clip",
        "PCarry 1 Salute",
        "pcarryn2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryn2"] = {
        "pcarryn2@animations",
        "pcarryn2clip",
        "PCarry 2 Salute",
        "pcarryn1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.230,
            yPos = 0.020,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryo1"] = {
        "pcarryo1@animations",
        "pcarryo1clip",
        "PCarry 1 Arrogant",
        "pcarryo2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryo2"] = {
        "pcarryo2@animations",
        "pcarryo2clip",
        "PCarry 2 Arrogant",
        "pcarryo1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.550,
            yPos = 0.010,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryp1"] = {
        "pcarryp1@animations",
        "pcarryp1clip",
        "PCarry 1 Dab",
        "pcarryp2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryp2"] = {
        "pcarryp2@animations",
        "pcarryp2clip",
        "PCarry 2 Dab",
        "pcarryp1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.550,
            yPos = 0.010,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryq1"] = {
        "pcarryq1@animations",
        "pcarryq1clip",
        "PCarry 1 Bull Meditation",
        "pcarryq2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryq2"] = {
        "pcarryq2@animations",
        "pcarryq2clip",
        "PCarry 2 Bull Meditation",
        "pcarryq1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.200,
            yPos = -0.500,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryr1"] = {
        "pcarryr1@animations",
        "pcarryr1clip",
        "PCarry 1 Cute Shy Shoulder",
        "pcarryr2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryr2"] = {
        "pcarryr2@animations",
        "pcarryr2clip",
        "PCarry 2 Cute Shy Shoulder",
        "pcarryr1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.070,
            yPos = -0.100,
            zPos = -0.280,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarrys1"] = {
        "pcarrys1@animations",
        "pcarrys1clip",
        "PCarry 2 Sleep Over Head",
        "pcarrys2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarrys2"] = {
        "pcarrys2@animations",
        "pcarrys2clip",
        "PCarry 2 Sleep Over Head",
        "pcarrys1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.880,
            yPos = 0.000,
            zPos = -0.080,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryt1"] = {
        "pcarryt1@animations",
        "pcarryt1clip",
        "PCarry 1 Riding Motorcycle",
        "pcarryt2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryt2"] = {
        "pcarryt2@animations",
        "pcarryt2clip",
        "PCarry 2 Riding Motorcycle",
        "pcarryt1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.520,
            yPos = 0.030,
            zPos = -0.010,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryu1"] = {
        "pcarryu1@animations",
        "pcarryu1clip",
        "PCarry 1 Cute Sit Shoulder",
        "pcarryu2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryu2"] = {
        "pcarryu2@animations",
        "pcarryu2clip",
        "PCarry 2 Cute Sit Shoulder",
        "pcarryu1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.290,
            yPos = 0.040,
            zPos = -0.220,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryv1"] = {
        "pcarryv1@animations",
        "pcarryv1clip",
        "PCarry 1 Pull Head Back",
        "pcarryv2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryv2"] = {
        "pcarryv2@animations",
        "pcarryv2clip",
        "PCarry 2 Pull Head Back",
        "pcarryv1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.340,
            yPos = -0.180,
            zPos = 0.150,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 50.000
        }
    },
    ["pcarryw1"] = {
        "pcarryw1@animations",
        "pcarryw1clip",
        "PCarry 1 Disgusting",
        "pcarryw2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryw2"] = {
        "pcarryw2@animations",
        "pcarryw2clip",
        "PCarry 2 Disgusting",
        "pcarryw1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 28422,
            xPos = 0.000,
            yPos = -0.140,
            zPos = -0.410,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryx1"] = {
        "pcarryx1@animations",
        "pcarryx1clip",
        "PCarry 1 Caught",
        "pcarryx2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryx2"] = {
        "pcarryx2@animations",
        "pcarryx2clip",
        "PCarry 2 Caught",
        "pcarryx1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 28422,
            xPos = 0.250,
            yPos = -0.200,
            zPos = 0.130,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryy1"] = {
        "pcarryy1@animations",
        "pcarryy1clip",
        "PCarry 1 Torture",
        "pcarryy2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryy2"] = {
        "pcarryy2@animations",
        "pcarryy2clip",
        "PCarry 2 Torture",
        "pcarryy1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 28422,
            xPos = 0.240,
            yPos = -0.560,
            zPos = 0.750,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -160.000
        }
    },
    ["pcarryz1"] = {
        "pcarryz1@animations",
        "pcarryz1clip",
        "PCarry 1 Bazoka",
        "pcarryz2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryz2"] = {
        "pcarryz2@animations",
        "pcarryz2clip",
        "PCarry 2 Bazoka",
        "pcarryz1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 57005,
            xPos = 0.020,
            yPos = 0.190,
            zPos = -0.220,
            xRot = 0.0,
            yRot = 0.0,
            zRot = -79.999
        }
    },
    ["pcarryza1"] = {
        "pcarryza1@animations",
        "pcarryza1clip",
        "PCarry 1 Drunk Behind",
        "pcarryza2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryza2"] = {
        "pcarryza2@animations",
        "pcarryza2clip",
        "PCarry 2 Drunk Behind",
        "pcarryza1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.560,
            yPos = 0.030,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzb1"] = {
        "pcarryzb1@animations",
        "pcarryzb1clip",
        "PCarry 1 Peek High",
        "pcarryzb2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzb2"] = {
        "pcarryzb2@animations",
        "pcarryzb2clip",
        "PCarry 2 Peek High",
        "pcarryzb1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.943,
            yPos = -0.010,
            zPos = -0.024,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzc1"] = {
        "pcarryzc1@animations",
        "pcarryzc1clip",
        "PCarry 1 Meditation Master",
        "pcarryzc2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzc2"] = {
        "pcarryzc2@animations",
        "pcarryzc2clip",
        "PCarry 2 Meditation Master",
        "pcarryzc1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.160,
            yPos = 0.020,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzd1"] = {
        "pcarryzd1@animations",
        "pcarryzd1clip",
        "PCarry 1 Strongman",
        "pcarryzd2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzd2"] = {
        "pcarryzd2@animations",
        "pcarryzd2clip",
        "PCarry 2 Strongman",
        "pcarryzd1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.590,
            yPos = 0.010,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryze1"] = {
        "pcarryze1@animations",
        "pcarryze1clip",
        "PCarry 1 Cute Piggyback",
        "pcarryze2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryze2"] = {
        "pcarryze2@animations",
        "pcarryze2clip",
        "PCarry 2 Cute Piggyback",
        "pcarryze1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.180,
            yPos = -0.020,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -10.000
        }
    },
    ["pcarryzf1"] = {
        "pcarryzf1@animations",
        "pcarryzf1clip",
        "PCarry 1 Piggyback Run",
        "pcarryzf2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzf2"] = {
        "pcarryzf2@animations",
        "pcarryzf2clip",
        "PCarry 2 Piggyback Run",
        "pcarryzf1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.210,
            yPos = -0.270,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -90.000
        }
    },
    ["pcarryzg1"] = {
        "pcarryzg1@animations",
        "pcarryzg1clip",
        "PCarry 1 Pulling Hands Back",
        "pcarryzg2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzg2"] = {
        "pcarryzg2@animations",
        "pcarryzg2clip",
        "PCarry 2 Pulling Hands Back",
        "pcarryzg1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.150,
            yPos = -0.670,
            zPos = -0.010,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryzh1"] = {
        "pcarryzh1@animations",
        "pcarryzh1clip",
        "PCarry 1 Pole",
        "pcarryzh2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzh2"] = {
        "pcarryzh2@animations",
        "pcarryzh2clip",
        "PCarry 2 Pole",
        "pcarryzh1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.110,
            yPos = 0.120,
            zPos = -0.270,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -10.000
        }
    },
    ["pcarryzi1"] = {
        "pcarryzi1@animations",
        "pcarryzi1clip",
        "PCarry 1 Cute Front",
        "pcarryzi2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzi2"] = {
        "pcarryzi2@animations",
        "pcarryzi2clip",
        "PCarry 2 Cute Front",
        "pcarryzi1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.100,
            yPos = 0.250,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzj1"] = {
        "pcarryzj1@animations",
        "pcarryzj1clip",
        "PCarry 1 Caress Head",
        "pcarryzj2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzj2"] = {
        "pcarryzj2@animations",
        "pcarryzj2clip",
        "PCarry 2 Caress Head",
        "pcarryzj1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.270,
            yPos = 0.010,
            zPos = -0.060,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzk1"] = {
        "pcarryzk1@animations",
        "pcarryzk1clip",
        "PCarry 1 Cute Scared",
        "pcarryzk2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzk2"] = {
        "pcarryzk2@animations",
        "pcarryzk2clip",
        "PCarry 2 Cute Scared",
        "pcarryzk1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.200,
            yPos = 0.010,
            zPos = 0.100,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzl1"] = {
        "pcarryzl1@animations",
        "pcarryzl1clip",
        "PCarry 1 Bag",
        "pcarryzl2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzl2"] = {
        "pcarryzl2@animations",
        "pcarryzl2clip",
        "PCarry 2 Bag",
        "pcarryzl1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.040,
            yPos = 0.060,
            zPos = -0.030,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzm1"] = {
        "pcarryzm1@animations",
        "pcarryzm1clip",
        "PCarry 1 Bag Flip",
        "pcarryzm2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzm2"] = {
        "pcarryzm2@animations",
        "pcarryzm2clip",
        "PCarry 2 Bag Flip",
        "pcarryzm1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.120,
            yPos = 0.050,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -15.000
        }
    },
    ["pcarryzn1"] = {
        "pcarryzn1@animations",
        "pcarryzn1clip",
        "PCarry 1 Hug Back Flip",
        "pcarryzn2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzn2"] = {
        "pcarryzn2@animations",
        "pcarryzn2clip",
        "PCarry 2 Hug Back Flip",
        "pcarryzn1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.210,
            yPos = 0.050,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -15.000
        }
    },
    ["pcarryzo1"] = {
        "pcarryzo1@animations",
        "pcarryzo1clip",
        "PCarry 1 Sit & Wave Over Head",
        "pcarryzo2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzo2"] = {
        "pcarryzo2@animations",
        "pcarryzo2clip",
        "PCarry 2 Sit & Wave Over Head",
        "pcarryzo1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.190,
            yPos = -0.020,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzp1"] = {
        "pcarryzp1@animations",
        "pcarryzp1clip",
        "PCarry 1 Cute Punch Head",
        "pcarryzp2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzp2"] = {
        "pcarryzp2@animations",
        "pcarryzp2clip",
        "PCarry 2 Cute Punch Head",
        "pcarryzp1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.450,
            yPos = -0.160,
            zPos = -0.030,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzq1"] = {
        "pcarryzq1@animations",
        "pcarryzq1clip",
        "PCarry 1 Superhero",
        "pcarryzq2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzq2"] = {
        "pcarryzq2@animations",
        "pcarryzq2clip",
        "PCarry 2 Superhero",
        "pcarryzq1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.270,
            yPos = 0.540,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzr1"] = {
        "pcarryzr1@animations",
        "pcarryzr1clip",
        "PCarry 1 Shoulder Leg Cross Head",
        "pcarryzr2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzr2"] = {
        "pcarryzr2@animations",
        "pcarryzr2clip",
        "PCarry 2 Shoulder Leg Cross Head",
        "pcarryzr1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.600,
            yPos = -0.090,
            zPos = 0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzs1"] = {
        "pcarryzs1@animations",
        "pcarryzs1clip",
        "PCarry 1 Can't Breath",
        "pcarryzs2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzs2"] = {
        "pcarryzs2@animations",
        "pcarryzs2clip",
        "PCarry 2 Can't Breath",
        "pcarryzs1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.030,
            yPos = -0.180,
            zPos = 0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzt1"] = {
        "pcarryzt1@animations",
        "pcarryzt1clip",
        "PCarry 1 Firemans Back",
        "pcarryzt2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzt2"] = {
        "pcarryzt2@animations",
        "pcarryzt2clip",
        "PCarry 2 Firemans Back",
        "pcarryzt1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.330,
            yPos = 0.000,
            zPos = -0.040,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryzu1"] = {
        "pcarryzu1@animations",
        "pcarryzu1clip",
        "PCarry 1 Happy Behind",
        "pcarryzu2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzu2"] = {
        "pcarryzu2@animations",
        "pcarryzu2clip",
        "PCarry 2 Happy Behind",
        "pcarryzu1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.290,
            yPos = -0.300,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryzv1"] = {
        "pcarryzv1@animations",
        "pcarryzv1clip",
        "PCarry 1 Happy Swing",
        "pcarryzv2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzv2"] = {
        "pcarryzv2@animations",
        "pcarryzv2clip",
        "PCarry 2 Happy Swing",
        "pcarryzv1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.040,
            yPos = -0.720,
            zPos = -0.600,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },
    ["pcarryzw1"] = {
        "pcarryzw1@animations",
        "pcarryzw1clip",
        "PCarry 1 Piggyback Head",
        "pcarryzw2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzw2"] = {
        "pcarryzw2@animations",
        "pcarryzw2clip",
        "PCarry 2 Piggyback Head",
        "pcarryzw1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.320,
            yPos = -0.220,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryzx1"] = {
        "pcarryzx1@animations",
        "pcarryzx1clip",
        "PCarry 1 Pose Over Head",
        "pcarryzx2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzx2"] = {
        "pcarryzx2@animations",
        "pcarryzx2clip",
        "PCarry 2 Pose Over Head",
        "pcarryzx1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.430,
            yPos = -0.860,
            zPos = 0.000,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -80.000
        }
    },
    ["pcarryzy1"] = {
        "pcarryzy1@animations",
        "pcarryzy1clip",
        "PCarry 1 Piggyback Hold Head",
        "pcarryzy2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzy2"] = {
        "pcarryzy2@animations",
        "pcarryzy2clip",
        "PCarry 2 Piggyback Hold Head",
        "pcarryzy1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 0.060,
            yPos = -0.070,
            zPos = -0.020,
            xRot = 0.000,
            yRot = 0.000,
            zRot = -20.000
        }
    },
    ["pcarryzz1"] = {
        "pcarryzz1@animations",
        "pcarryzz1clip",
        "PCarry 1 Heart Power",
        "pcarryzz2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pcarryzz2"] = {
        "pcarryzz2@animations",
        "pcarryzz2clip",
        "PCarry 2 Heart Power",
        "pcarryzz1",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = 1.110,
            yPos = 0.210,
            zPos = -0.780,
            xRot = 0.000,
            yRot = 0.000,
            zRot = 0.000
        }
    },

    ["holdme"] = {
        "mx_couple5_1_a",
        "mx_couple5_1_a_clip",
        "Hold Me",
        "holdmeb",
        AnimationOptions = {
            EmoteLoop = true
        },
    },
    ["holdmeb"] = {
        "mx_couple5_1_b",
        "mx_couple5_1_b_clip",
        "Be Held",
        "holdme",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = -0.0200,
            yPos =  0.2400,
            zPos = -0.0100,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        },
    },
    ["holdmec"] = {
        "mx_couple5_2_a",
        "mx_couple5_2_a_clip",
        "Hold Me 2",
        "holdmed",
        AnimationOptions = {
            EmoteLoop = true
        },
    },
    ["holdmed"] = {
        "mx_couple5_2_b",
        "mx_couple5_2_b_clip",
        "Be Held 2",
        "holdmec",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = -0.1200,
            yPos =  0.3600,
            zPos = -0.0100,
            xRot = 0.0,
            yRot = 0.0,
            zRot = -180.0
        },
    },
    ["holdmee"] = {
        "mx_couple5_3_a",
        "mx_couple5_3_a_clip",
        "Hold Me 3",
        "holdmef",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["holdmef"] = {
        "mx_couple5_3_b",
        "mx_couple5_3_b_clip",
        "Be Held 3",
        "holdmee",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos =  0.0400,
            yPos =  0.2100,
            zPos = -0.0300,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        },
    },

    ["carrycmg"] = {
        "couplepose1cmg@animation",
        "couplepose1cmg_clip",
        "Carry Me Cute 3",
        "carrycmg2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true
        }
    },
    ["carrycmg2"] = {
        "couplepose2cmg@animation",
        "couplepose2cmg_clip",
        "Carry Me Cute 4",
        "carrycmg",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0100,
            yPos = 0.3440,
            zPos = -0.0100,
            xRot = 180.0000,
            yRot = 180.0000,
            zRot = -1.9999
        }
    },

    ["followa"] = {
        "dollie_mods@follow_me_001",
        "follow_me_001",
        "Suis-moi A (Avant)",
        "followb",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,

        }
    },
    ["followb"] = {
        "dollie_mods@follow_me_002",
        "follow_me_002",
        "Suis-moi B (Arrière)",
        "followa",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            xPos = 0.078,
            yPos = 0.018,
            zPos = 0.00,
            xRot = 0.00,
            yRot = 0.00,
            zRot = 0.00
        }
    },

    ["kisslips"] = {
        "chocoholic@couple13",
        "couple13_clip",
        "Galoche vénère (Femme)",
        "kisslips2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.1600,
            yPos = 0.2700,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 130.0,

        }
    },
    ["kisslips2"] = {
        "chocoholic@couple14",
        "couple14_clip",
        "Galoche vénère (Homme)",
        "kisslips",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,

        }
    },

    ["kisscuteneck"] = {
        "genesismods_kissme@kissmale8",
        "kissmale8",
        "Kiss Cute - Neck (Male)",
        "kisscuteneck2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,

            xPos = -0.56,
            yPos = 0.0,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0,

        }
    },
    ["kisscuteneck2"] = {
        "genesismods_kissme@kissfemale8",
        "kissfemale8",
        "Kiss Cute - Neck (Female)",
        "kisscuteneck",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,

        }
    },
    ["kisscutecheek"] = {
        "genesismods_kissme@kissmale9",
        "kissmale9",
        "Kiss Cute Cheek (Male)",
        "kisscutecheek2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,

            xPos = 0.35,
            yPos = 0.0,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0,

        }
    },
    ["kisscutecheek2"] = {
        "genesismods_kissme@kissfemale9",
        "kissfemale9",
        "Kiss Cute Cheek (Female)",
        "kisscutecheek",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,

        }
    },
    ["kisscutefh"] = {
        "genesismods_kissme@kissmale10",
        "kissmale10",
        "Kiss Forehead (Male)",
        "kisscutefh2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,

            xPos = 0.38,
            yPos = 0.0,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0,

        }
    },

    ["hugtip"] = {
        "littlespoon@friendship007",
        "friendship007",
        "Hug Pose Tippy Toes",
        "hugtip2",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true
        }
    },
    ["hugtip2"] = {
        "littlespoon@friendship008",
        "friendship008",
        "Hug Pose Tippy Toes 2",
        "hugtip",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0100,
            yPos = 0.2700,
            zPos = 0.0,
            xRot = -180.0000,
            yRot = -180.0000,
            zRot = 10.0000
        }
    },
    ["couplewed1a"] = {
        "EnchantedBrwny@wedding1a",
        "wedding1a",
        "Couple Wedding Pose 1A",
        "couplewed1b",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true
        }
    },
    ["couplewed1b"] = {
        "EnchantedBrwny@wedding1b",
        "wedding1b",
        "Couple Wedding Pose 1B",
        "couplewed1a",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0300,
            yPos = 1.0000,
            zPos = 0.0200,
            xRot = 0.0000,
            yRot = 0.0000,
            zRot = 130.0000
        }
    },
    ["couplewed2a"] = {
        "EnchantedBrwny@wedding2b",
        "wedding2b",
        "Couple Wedding Pose 2A",
        "couplewed2b",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true
        }
    },
    ["couplewed2b"] = {
        "EnchantedBrwny@wedding2a",
        "wedding2a",
        "Couple Wedding Pose 2B",
        "couplewed2a",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0100,
            yPos = 0.2500,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = -88.9000
        }
    },
    ["liftme"] = {
        "couplepose1pack1anim2@animation",
        "couplepose1pack1anim2_clip",
        "Lift Me",
        "liftme2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["liftme2"] = {
        "couplepose1pack1anim1@animation",
        "couplepose1pack1anim1_clip",
        "Lift Me 2",
        "liftme",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0020,
            yPos = 0.2870,
            zPos = 0.2500,
            xRot = 0.0000,
            yRot = 0.0000,
            zRot = 180.0000
        }
    },
    ["liftme3"] = {
        "couplepose2pack1anim2@animation",
        "couplepose2pack1anim2_clip",
        "Lift Me 3",
        "liftme4",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true
        }
    },
    ["liftme4"] = {
        "couplepose2pack1anim1@animation",
        "couplepose2pack1anim1_clip",
        "Lift Me 4",
        "liftme3",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0100,
            yPos = 0.4800,
            zPos = 0.5300,
            xRot = 0.0000,
            yRot = 0.0000,
            zRot = 180.0000
        }
    },
    ["liftme5"] = {
        "couplepose3pack1anim2@animation",
        "couplepose3pack1anim2_clip",
        "Lift Me 5",
        "liftme6",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["liftme6"] = {
        "couplepose3pack1anim1@animation",
        "couplepose3pack1anim1_clip",
        "Lift Me 6",
        "liftme5",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = -0.2120,
            yPos = -0.5400,
            zPos = -0.1000,
            xRot = 0.0000,
            yRot = 0.0000,
            zRot = 0.0000
        }
    },
    ["csdog3"] = {
        "hooman@hugging_little_doggy",
        "base",
        "Carry Small Dog 2",
        "csdog4",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        },
        AnimalEmote = true
    },
    ["csdog4"] = {
        "little_doggy@hugging_hooman",
        "base",
        "Small Dog Carried 2",
        "csdog3",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 24818,
            xPos = -0.95,
            yPos = 0.16,
            zPos = -0.15,
            xRot = 3.70,
            yRot = 75.00,
            zRot = -161.90,
        },
        AnimalEmote = true
    },
    ["pback"] = {
        "mx@piggypack_a",
        "mxclip_a",
        "Offer Piggy Back",
        "pback2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["pback2"] = {
        "mx@piggypack_b",
        "mxanim_b",
        "Be Piggy Backed",
        "pback",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = 0.0200,
            yPos = -0.4399,
            zPos = 0.4200,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        }
    },
    ["search"] = {
        "custom@police",
        "police",
        "Search",
        "search2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = false,

        }
    },
    ["search2"] = {
        "missfam5_yoga",
        "a2_pose",
        "Be searched",
        "search",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = false,

            Attachto = true,
            xPos = 0.0,
            yPos = 0.5,
            zPos = 0.0,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        }
    },
    ["followa"] = {
        "dollie_mods@follow_me_001",
        "follow_me_001",
        "Follow A (Front)",
        "followb",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,

        }
    },
    ["followb"] = {
        "dollie_mods@follow_me_002",
        "follow_me_002",
        "Follow B (Back)",
        "followa",
        AnimationOptions = {
            EmoteLoop = true,
            Attachto = true,
            xPos = 0.078,
            yPos = 0.018,
            zPos = 0.00,
            xRot = 0.00,
            yRot = 0.00,
            zRot = 0.00
        }
    },
    ["holdme"] = {
        "mx_couple5_1_a",
        "mx_couple5_1_a_clip",
        "Hold Me",
        "holdmeb",
        AnimationOptions = {
            EmoteLoop = true
        },
    },
    ["holdmeb"] = {
        "mx_couple5_1_b",
        "mx_couple5_1_b_clip",
        "Be Held",
        "holdme",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = -0.0200,
            yPos =  0.2400,
            zPos = -0.0100,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        },
    },
    ["holdmec"] = {
        "mx_couple5_2_a",
        "mx_couple5_2_a_clip",
        "Hold Me 2",
        "holdmed",
        AnimationOptions = {
            EmoteLoop = true
        },
    },
    ["holdmed"] = {
        "mx_couple5_2_b",
        "mx_couple5_2_b_clip",
        "Be Held 2",
        "holdmec",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos = -0.1200,
            yPos =  0.3600,
            zPos = -0.0100,
            xRot = 0.0,
            yRot = 0.0,
            zRot = -180.0
        },
    },
    ["holdmee"] = {
        "mx_couple5_3_a",
        "mx_couple5_3_a_clip",
        "Hold Me 3",
        "holdmef",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["holdmef"] = {
        "mx_couple5_3_b",
        "mx_couple5_3_b_clip",
        "Be Held 3",
        "holdmee",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
            Attachto = true,
            bone = 0,
            xPos =  0.0400,
            yPos =  0.2100,
            zPos = -0.0300,
            xRot = 0.0,
            yRot = 0.0,
            zRot = 0.0
        },
    },

    ["kiss"] = { "mp_ped_interaction", "kisses_guy_a", "Faire un bisou", "kiss2", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.05,
    } },
    ["kiss2"] = { "mp_ped_interaction", "kisses_guy_b", "Faire un bisou 2", "kiss", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.13
    } },
    ["bro"] = { "mp_ped_interaction", "hugs_guy_a", "Bro", "bro2", AnimationOptions = {
        SyncOffsetFront = 1.14
    } },
    ["bro2"] = { "mp_ped_interaction", "hugs_guy_b", "Bro 2", "bro", AnimationOptions = {
        SyncOffsetFront = 1.14
    } },
    ["give"] = { "mp_common", "givetake1_a", "Give", "give2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["give2"] = { "mp_common", "givetake1_b", "Give 2", "give", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["baseball"] = { "anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_a", "Baseball", "baseballthrow" },
    ["baseballthrow"] = { "anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_b", "Baseball Throw", "baseball" },
    ["stickup"] = { "random@countryside_gang_fight", "biker_02_stickup_loop", "Viser avec une arme", "stickupscared", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stickupscared"] = { "missminuteman_1ig_2", "handsup_base", "Viser en ayant peur", "stickup", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["punch"] = { "melee@unarmed@streamed_variations", "plyr_takedown_rear_lefthook", "Punch", "punched" },
    ["punched"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_cross_r", "Punched", "punch" },
    ["headbutt"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Headbutt", "Coup de tête" },
    ["headbutted"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_headbutt", "Headbutted", "Coup de tête" },
    ["slap2"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_backslap", "Claque 2", "slapped2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["slap"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Claque", "slapped", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["slapped"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_slap", "Slapped", "slap" },
    ["slapped2"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_backslap", "Slapped 2", "slap2" },
    ["receiveblowjob"] = { "misscarsteal2pimpsex", "pimpsex_punter", "Receive Blowjob", "Give Blowjob", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 30000,
        SyncOffsetFront = 0.63
    } },
    ["giveblowjob"] = { "misscarsteal2pimpsex", "pimpsex_hooker", "Give Blowjob", "Receive Blowjob", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 30000,
        SyncOffsetFront = 0.63
    } },
    ["streetsexmale"] = { "misscarsteal2pimpsex", "shagloop_pimp", "Street Sex Male", "Street Sex Female", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = 0.50
    } },
    ["streetsexfemale"] = { "misscarsteal2pimpsex", "shagloop_hooker", "Street Sex Female", "Street Sex Male", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = -0.50
    } },
}

DP.Dances = {
    ["dancewave"] = {
        "dancing_wave_part_one@anim",
        "wave_dance_1",
        "Wave Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave02"] = {
        "dancing_wave_part_one@anim",
        "wave_dance_2",
        "Wave Dance 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave03"] = {
        "dancing_wave_part_one@anim",
        "wave_dance_3",
        "Wave Dance 3",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave04"] = {
        "dancing_wave_part_one@anim",
        "wave_dance_4",
        "Wave Dance 4",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave05"] = {
        "dancing_wave_part_one@anim",
        "tutankhamun_dance_1",
        "Wave Dance 5 - Tutankhamen",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave06"] = {
        "dancing_wave_part_one@anim",
        "tutankhamun_dance_2",
        "Wave Dance 6 - Tutankhamen 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave07"] = {
        "dancing_wave_part_one@anim",
        "snake_dance_1",
        "Wave Dance 7 - Snake Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave08"] = {
        "dancing_wave_part_one@anim",
        "slide_dance",
        "Wave Dance 8 - Slide Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave09"] = {
        "dancing_wave_part_one@anim",
        "slide_dance_2",
        "Wave Dance 9 - Slide Dance 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave10"] = {
        "dancing_wave_part_one@anim",
        "robot_dance",
        "Wave Dance 10 - Robot Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave11"] = {
        "dancing_wave_part_one@anim",
        "locking_dance",
        "Wave Dance 11 - Locking Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancewave12"] = {
        "dancing_wave_part_one@anim",
        "headspin",
        "Wave Dance 12 - Headspin",
        AnimationOptions = {
            EmoteLoop = false
        }
    },
    ["dancewave13"] = {
        "dancing_wave_part_one@anim",
        "flaire_dance",
        "Wave Dance 13 - Flaire Dance",
        AnimationOptions = {
            EmoteLoop = false
        }
    },
    ["dancewave14"] = {
        "dancing_wave_part_one@anim",
        "crowd_girl_dance",
        "Wave Dance 14 - Female Crowd Dance",
        AnimationOptions = {
            EmoteLoop = false
        }
    },
    ["dancewave15"] = {
        "dancing_wave_part_one@anim",
        "uprock_dance_1",
        "Wave Dance 15 - Uprock Dance",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["dancethriller"] = {
        "mj_thriller",
        "mj_thriller_dance",
        "Dance - MJ Thriller",
        AnimationOptions = {
            EmoteLoop = true
        }
    },

    ["waitdance"] = {"waitdance@animations", "waitdanceclip", "Danse Wait", AnimationOptions =
    {
        EmoteLoop = true,
    }},

    ["pratdance"] = {"pratdance@animations", "pratdanceclip", "Danse du rat", AnimationOptions =
    {
        EmoteLoop = true,
    }},

    ["dance"] = { "anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5", "Dance", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance2"] = { "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", "Dance 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance3"] = { "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", "Dance 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance4"] = { "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_up", "Dance 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance5"] = { "anim@amb@casino@mini@dance@dance_solo@female@var_a@", "med_center", "Dance 5", AnimationOptions = {
        EmoteLoop = true
    } },
    ["dance6"] = { "misschinese2_crystalmazemcs1_cs", "dance_loop_tao", "Dance 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance7"] = { "misschinese2_crystalmazemcs1_ig", "dance_loop_tao", "Dance 7", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance8"] = { "missfbi3_sniping", "dance_m_default", "Dance 8", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dance9"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_center_up", "Dance 9", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef"] = { "anim@amb@nightclub@dancers@solomun_entourage@", "mi_dance_facedj_17_v1_female^1", "Dance F", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef2"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center", "Dance F2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef3"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef4"] = { "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^1", "Dance F4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef5"] = { "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^3", "Dance F5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancef6"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceclub"] = { "anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m03", "Dance Club", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub2"] = { "anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m05", "Dance Club 2", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub3"] = { "anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m02", "Dance Club 3", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub4"] = { "anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_b_f01", "Dance Club 4", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub5"] = { "anim@amb@nightclub_island@dancers@club@", "hi_idle_a_f02", "Dance Club 5", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub6"] = { "anim@amb@nightclub_island@dancers@club@", "hi_idle_b_m03", "Dance Club 6", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceclub7"] = { "anim@amb@nightclub_island@dancers@club@", "hi_idle_d_f01", "Dance Club 7", AnimationOptions = {
        EmoteLoop = true
    } },
    ["dancedrink"] = { "anim@amb@nightclub_island@dancers@beachdanceprop@", "mi_idle_c_m01", "Dance Drink (Beer)", AnimationOptions = {
        Prop = 'prop_beer_amopen',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.00, 0.0, 0.0, 0.0, 20.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink2"] = { "anim@amb@nightclub_island@dancers@beachdanceprop@", "mi_loop_f1", "Dance Drink 2 (Wine)", AnimationOptions = {
        Prop = 'p_wine_glass_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0900, 0.0, 0.0, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink3"] = { "anim@amb@nightclub_island@dancers@beachdanceprop@", "mi_loop_m04", "Dance Drink 3 (Whiskey)", AnimationOptions = {
        Prop = 'ba_prop_battle_whiskey_opaque_s',
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.00, 0.0, 0.0, 0.0, 10.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink4"] = { "anim@amb@nightclub_island@dancers@beachdanceprops@male@", "mi_idle_b_m04", "Dance Drink 4 (Whiskey)", AnimationOptions = {
        Prop = 'ba_prop_battle_whiskey_opaque_s',
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.00, 0.0, 0.0, 0.0, 10.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink5"] = { "anim@amb@nightclub_island@dancers@crowddance_single_props@", "hi_dance_prop_09_v1_female^3", "Dance Drink 5 (Wine)", AnimationOptions = {
        Prop = 'p_wine_glass_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0900, 0.0, 0.0, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink6"] = { "anim@amb@nightclub_island@dancers@crowddance_single_props@", "hi_dance_prop_09_v1_male^3", "Dance Drink 6 (Beer)", AnimationOptions = {
        Prop = 'prop_beer_logopen',
        PropBone = 28422,
        PropPlacement = { 0.0090, 0.0010, -0.0310, 180.0, 180.0, -69.99 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink7"] = { "anim@amb@nightclub_island@dancers@crowddance_single_props@", "hi_dance_prop_11_v1_female^3", "Dance Drink 7 (Wine)", AnimationOptions = {
        Prop = 'p_wine_glass_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0900, 0.0, 0.0, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dancedrink8"] = { "anim@amb@nightclub_island@dancers@crowddance_single_props@", "hi_dance_prop_11_v1_female^1", "Dance Drink 8 (Wine)", AnimationOptions = {
        Prop = 'p_wine_glass_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0900, 0.0, 0.0, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["danceslow2"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center", "Dance Slow 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceslow3"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center_down", "Dance Slow 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceslow4"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center", "Dance Slow 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceupper"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Upper", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["danceupper2"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center_up", "Dance Upper 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["danceshy"] = { "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "low_center", "Dance Shy", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceshy2"] = { "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down", "Dance Shy 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["danceslow"] = { "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "low_center", "Dance Slow", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly9"] = { "rcmnigel1bnmt_1b", "dance_loop_tyler", "Dance Silly 9", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly"] = { "special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag", "Dance Silly", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly2"] = { "move_clown@p_m_zero_idles@", "fidget_short_dance", "Dance Silly 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly3"] = { "move_clown@p_m_two_idles@", "fidget_short_dance", "Dance Silly 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly4"] = { "anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_11_buttwiggle_b_laz", "Dance Silly 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly5"] = { "timetable@tracy@ig_5@idle_a", "idle_a", "Dance Silly 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly6"] = { "timetable@tracy@ig_8@idle_b", "idle_d", "Dance Silly 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["dancesilly7"] = { "anim@amb@casino@mini@dance@dance_solo@female@var_b@", "med_center", "Dance Silly 7", AnimationOptions = {
        EmoteLoop = true
    } },
    ["dancesilly8"] = { "anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Silly 8", AnimationOptions = {
        EmoteLoop = true
   } },
    ["dancesilly9"] = { "anim@mp_player_intcelebrationfemale@the_woogie", "the_woogie", "Dance Silly 9", AnimationOptions = {
        EmoteLoop = true
    } },
    ["danceglowstick"] = { "anim@amb@nightclub@lazlow@hi_railing@", "ambclub_13_mi_hi_sexualgriding_laz", "Dance Glowsticks", AnimationOptions = {
        Prop = 'ba_prop_battle_glowstick_01',
        PropBone = 28422,
        PropPlacement = { 0.0700, 0.1400, 0.0, -80.0, 20.0 },
        SecondProp = 'ba_prop_battle_glowstick_01',
        SecondPropBone = 60309,
        SecondPropPlacement = { 0.0700, 0.0900, 0.0, -120.0, -20.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["danceglowstick2"] = { "anim@amb@nightclub@lazlow@hi_railing@", "ambclub_12_mi_hi_bootyshake_laz", "Dance Glowsticks 2", AnimationOptions = {
        Prop = 'ba_prop_battle_glowstick_01',
        PropBone = 28422,
        PropPlacement = { 0.0700, 0.1400, 0.0, -80.0, 20.0 },
        SecondProp = 'ba_prop_battle_glowstick_01',
        SecondPropBone = 60309,
        SecondPropPlacement = { 0.0700, 0.0900, 0.0, -120.0, -20.0 },
        EmoteLoop = true,
    } },
    ["danceglowstick3"] = { "anim@amb@nightclub@lazlow@hi_railing@", "ambclub_09_mi_hi_bellydancer_laz", "Dance Glowsticks 3", AnimationOptions = {
        Prop = 'ba_prop_battle_glowstick_01',
        PropBone = 28422,
        PropPlacement = { 0.0700, 0.1400, 0.0, -80.0, 20.0 },
        SecondProp = 'ba_prop_battle_glowstick_01',
        SecondPropBone = 60309,
        SecondPropPlacement = { 0.0700, 0.0900, 0.0, -120.0, -20.0 },
        EmoteLoop = true,
    } },
    ["dancehorse"] = { "anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_15_handup_laz", "Dance Horse", AnimationOptions = {
        Prop = "ba_prop_battle_hobby_horse",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["dancehorse2"] = { "anim@amb@nightclub@lazlow@hi_dancefloor@", "crowddance_hi_11_handup_laz", "Dance Horse 2", AnimationOptions = {
        Prop = "ba_prop_battle_hobby_horse",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["dancehorse3"] = { "anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_11_hu_shimmy_laz", "Dance Horse 3", AnimationOptions = {
        Prop = "ba_prop_battle_hobby_horse",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["dj"] = { "anim@amb@nightclub@djs@dixon@", "dixn_dance_cntr_open_dix", "DJ", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["dj2"] = { "anim@amb@nightclub@djs@solomun@", "sol_idle_ctr_mid_a_sol", "DJ 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj3"] = { "anim@amb@nightclub@djs@solomun@", "sol_dance_l_sol", "DJ 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj4"] = { "anim@amb@nightclub@djs@black_madonna@", "dance_b_idle_a_blamadon", "DJ 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj5"] = { "anim@amb@nightclub@djs@dixon@", "dixn_end_dix", "DJ 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj5"] = { "anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_a_dix", "DJ 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj6"] = { "anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_b_dix", "DJ 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj7"] = { "anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_g_dix", "DJ 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj8"] = { "anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_gb_dix", "DJ 8", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dj9"] = { "anim@amb@nightclub@djs@dixon@", "dixn_sync_cntr_j_dix", "DJ 9", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["twerk"] = { "switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper", "Twerk", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdance"] = { "mp_safehouse", "lap_dance_girl", "Lapdance" },
    ["lapdance2"] = { "mini@strip_club@private_dance@idle", "priv_dance_idle", "Lapdance 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdance3"] = { "mini@strip_club@private_dance@part1", "priv_dance_p1", "Lapdance 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdance4"] = { "mini@strip_club@private_dance@part2", "priv_dance_p2", "Lapdance 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdance5"] = { "mini@strip_club@private_dance@part3", "priv_dance_p3", "Lapdance 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdance6"] = { "oddjobs@assassinate@multi@yachttarget@lapdance", "yacht_ld_f", "Lapdance 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdancewith"] = { "mini@strip_club@lap_dance_2g@ld_2g_p3", "ld_2g_p3_s2", "Lapdance With", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdancewith2"] = { "mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s2", "Lapdance With2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapdancewith3"] = { "mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s2", "Lapdance With3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapchair"] = { "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", "Lap Chair", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapchair2"] = { "mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f", "Lap Chair2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lapchair3"] = { "mini@strip_club@lap_dance@ld_girl_a_song_a_p3", "ld_girl_a_song_a_p3_f", "Lap Chair3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["fishdance"] = { "anim@mp_player_intupperfind_the_fish", "idle_a", "Danse némo", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
}

DP.AnimalEmotes = {
    ["bdogbeg"] = { "creatures@rottweiler@tricks@", "beg_loop", "Beg (gros chien)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["bdogbeg2"] = { "creatures@rottweiler@tricks@", "paw_right_loop", "Beg 2 (gros chien)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["bdogdump"] = { "creatures@rottweiler@move", "dump_loop", "Dump (gros chien)", AnimationOptions = {
        Prop = 'prop_big_shit_02',
        PropBone = 51826,
        PropPlacement = { 0.0, 0.2000, -0.4600, 0.0, -20.00, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["bdogitch"] = { "creatures@rottweiler@amb@world_dog_sitting@idle_a", "idle_a", "Itch (gros chien)", AnimationOptions = {
        EmoteDuration = 2000
    } },
    ["bdogsleep"] = { "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", "Dormir (gros chien)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["bdogsit"] = { "creatures@rottweiler@amb@world_dog_sitting@base", "base", "Sit (gros chien)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["bdogpee"] = { "creatures@rottweiler@move", "pee_left_idle", "Pee (gros chien)", AnimationOptions = {
        EmoteLoop = false
    } },
    ["bdogpee2"] = { "creatures@rottweiler@move", "pee_right_idle", "Pee 2 (gros chien)", AnimationOptions = {
        EmoteLoop = false
    } },
    ["sdogbark"] = { "creatures@pug@amb@world_dog_barking@idle_a", "idle_a", "Bark (small dog)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["sdogitch"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_a", "Itch (small dog)", AnimationOptions = {
        EmoteDuration = 2000
    } },
    ["sdogsit"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Sit (small dog)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["sdogld"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_c", "Lay Down (small dog)", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogshake"] = { "creatures@pug@amb@world_dog_barking@idle_a", "idle_c", "Shake (small dog)", AnimationOptions = {
        EmoteLoop = true
    } },
    ["sdogdance"] = { "creatures@pug@move", "idle_turn_0", "Dance (small dog)", AnimationOptions = {
        Prop = 'ba_prop_battle_glowstick_01',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogdance2"] = { "creatures@pug@move", "idle_turn_0", "Dance 2 (small dog)", AnimationOptions = {
        Prop = 'ba_prop_battle_glowstick_01',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0300, 0.0, 0.0, 0.0 },
        SecondProp = 'prop_cs_sol_glasses',
        SecondPropBone = 31086,
        SecondPropPlacement = { 0.0500, 0.0300, 0.000, -100.0000003, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogbb"] = { "creatures@pug@move", "nill", "Baseball (small dog)", AnimationOptions = {
        Prop = 'w_am_baseball',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0500, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogburger"] = { "creatures@pug@move", "nill", "Burger (small dog)", AnimationOptions = {
        Prop = 'prop_cs_burger_01',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0400, 0.0000, -90.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogcontroller"] = { "creatures@pug@move", "nill", "Controller (small dog)", AnimationOptions = {
        Prop = 'prop_controller_01',
        PropBone = 31086,
        PropPlacement = { 0.1800, -0.0300, 0.0000, -180.000, 90.0000, 0.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogdolla"] = { "creatures@pug@move", "nill", "Dollar Bill (small dog)", AnimationOptions = {
        Prop = 'p_banknote_onedollar_s',
        PropBone = 31086,
        PropPlacement = { 0.1700, -0.0100, 0.0000, 90.0000, 0.0000, 0.000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogdolla2"] = { "creatures@pug@move", "nill", "Dollar Bill Scrunched  (small dog)", AnimationOptions = {
        Prop = 'bkr_prop_scrunched_moneypage',
        PropBone = 31086,
        PropPlacement = { 0.1700, 0.000, 0.0000, 90.0000, 00.0000, 00.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogdolla3"] = { "creatures@pug@move", "nill", "Money Stack  (small dog)", AnimationOptions = {
        Prop = 'bkr_prop_money_wrapped_01',
        PropBone = 31086,
        PropPlacement = { 0.1700, -0.0100, 0.0000, 90.0000, 0.0000, 0.000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogdolla4"] = { "creatures@pug@move", "nill", "Money Bag  (small dog)", AnimationOptions = {
        Prop = 'ch_prop_ch_moneybag_01a',
        PropBone = 31086,
        PropPlacement = { 0.1200, -0.2000, 0.0000, -79.9999997, 90.00, 0.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogmic"] = { "creatures@pug@move", "nill", "Microphone (small dog)", AnimationOptions = {
        Prop = 'p_ing_microphonel_01',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0170, 0.0300, 0.000, 0.0000, 0.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogteddy"] = { "creatures@pug@move", "nill", "Teddy (small dog)", AnimationOptions = {
        Prop = 'v_ilev_mr_rasberryclean',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.1100, -0.23, 0.000, 0.0000, 0.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogteddy2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Teddy 2 (small dog)", AnimationOptions = {
        Prop = 'v_ilev_mr_rasberryclean',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.1100, -0.23, 0.000, 0.0000, 0.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogtennis"] = { "creatures@pug@move", "nill", "Tennis Ball (small dog)", AnimationOptions = {
        Prop = 'prop_tennis_ball',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0600, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogtennisr"] = { "creatures@pug@move", "nill", "Tennis Racket (small dog)", AnimationOptions = {
        Prop = 'prop_tennis_rack_01',
        PropBone = 31086,
        PropPlacement = { 0.1500, -0.0200, 0.00, 0.000, 0.0000, -28.0000 },
        EmoteLoop = true,
        EmoteMoving = false,
    }
    },
    ["sdogrose"] = { "creatures@pug@move", "nill", "Rose (small dog)", AnimationOptions = {
        Prop = 'prop_single_rose',
        PropBone = 12844,
        PropPlacement = { 0.1090, -0.0140, 0.0500, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    }
    },
    ["sdogrose2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Rose Sit (small dog)", AnimationOptions = {
        Prop = 'prop_single_rose',
        PropBone = 12844,
        PropPlacement = { 0.1090, -0.0140, 0.0500, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogggun"] = { "creatures@pug@move", "nill", "Gun Gold (small dog)", AnimationOptions = {
        Prop = 'w_pi_pistol_luxe',
        PropBone = 12844,
        PropPlacement = { 0.2010, -0.0080, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoggun2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Gun Gold Sit (small dog)", AnimationOptions = {
        Prop = 'w_pi_pistol_luxe',
        PropBone = 12844,
        PropPlacement = { 0.2010, -0.0080, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogstun"] = { "creatures@pug@move", "nill", "Stun Gun (small dog)", AnimationOptions = {
        Prop = 'w_pi_stungun',
        PropBone = 12844,
        PropPlacement = { 0.1400, -0.0100, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
        PtfxAsset = "core",
        PtfxName = "blood_stungun",
        PtfxPlacement = { 0.208, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 },
        PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['stun'],
        PtfxWait = 200,
    } },
    ["sdoggl1"] = { "creatures@pug@move", "nill", "Aviators (small dog)", AnimationOptions = {
        Prop = 'prop_aviators_01',
        PropBone = 31086,
        PropPlacement = { 0.0500, 0.0400, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoggl2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Aviators Sitting (small dog)", AnimationOptions = {
        Prop = 'prop_aviators_01',
        PropBone = 31086,
        PropPlacement = { 0.0500, 0.0400, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoggl3"] = { "creatures@pug@move", "nill", "Sunglasses (small dog)", AnimationOptions = {
        Prop = 'prop_cs_sol_glasses',
        PropBone = 31086,
        PropPlacement = { 0.0500, 0.0300, 0.000, -100.0000003, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoggl4"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Sunglasses Sitting (small dog)", AnimationOptions = {
        Prop = 'prop_cs_sol_glasses',
        PropBone = 31086,
        PropPlacement = { 0.0500, 0.0300, 0.000, -100.0000003, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghd1"] = { "creatures@pug@move", "nill", "Hot Dog (small dog)", AnimationOptions = {
        Prop = 'prop_cs_hotdog_01',
        PropBone = 31086,
        PropPlacement = { 0.1300, -0.0250, 0.000, -88.272053, -9.8465858, -0.1488562 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghd2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Hot Dog Sitting (small dog)", AnimationOptions = {
        Prop = 'prop_cs_hotdog_01',
        PropBone = 31086,
        PropPlacement = { 0.1300, -0.0250, 0.000, -88.272053, -9.8465858, -0.1488562 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghlmt1"] = { "creatures@pug@move", "nill", "Helmet 1 (small dog)", AnimationOptions = {
        Prop = 'ba_prop_battle_sports_helmet',
        PropBone = 31086,
        PropPlacement = { 0.00, -0.0200, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghlmt2"] = { "creatures@pug@move", "nill", "Helmet 2 (small dog)", AnimationOptions = {
        Prop = 'prop_hard_hat_01',
        PropBone = 31086,
        PropPlacement = { 0.00, 0.1300, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghat"] = { "creatures@pug@move", "nill", "Hat 1 (small dog)", AnimationOptions = {
        Prop = 'prop_proxy_hat_01',
        PropBone = 31086,
        PropPlacement = { 0.0, 0.1200, 0.000, -99.8510766, 80.1489234, 1.7279411 },
        SecondProp = 'prop_aviators_01',
        SecondPropBone = 31086,
        SecondPropPlacement = { 0.0500, 0.0400, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdoghat2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_b", "Hat 2 Sitting (small dog)", AnimationOptions = {
        Prop = 'prop_proxy_hat_01',
        PropBone = 31086,
        PropPlacement = { 0.0, 0.1200, 0.000, -99.8510766, 80.1489234, 1.7279411 },
        SecondProp = 'prop_aviators_01',
        SecondPropBone = 31086,
        SecondPropPlacement = { 0.0500, 0.0400, 0.000, -90.00, 90.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogsteak"] = { "creatures@pug@move", "nill", "Steak (small dog)", AnimationOptions = {
        Prop = 'prop_cs_steak',
        PropBone = 31086,
        PropPlacement = { 0.1800, -0.0200, 0.000, 90.00, 0.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["sdogsteak2"] = { "creatures@pug@amb@world_dog_sitting@idle_a", "idle_c", "Steak 2 Lay Down (small dog)", AnimationOptions = {
        Prop = 'prop_cs_steak',
        PropBone = 31086,
        PropPlacement = { 0.1800, -0.0200, 0.000, 90.00, 0.00, 0.00 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
}

DP.Emotes = {
    ["pgreetingsa"] = {
        "pazeee@greetings@a@animations",
        "pazeee@greetings@a@clip",
        "Greetings A",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pgreetingsb"] = {
        "pazeee@greetings@b@animations",
        "pazeee@greetings@b@clip",
        "Greetings B",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pgreetingsc"] = {
        "pazeee@greetings@c@animations",
        "pazeee@greetings@c@clip",
        "Greetings C",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pgreetingsd"] = {
        "pazeee@greetings@d@animations",
        "pazeee@greetings@d@clip",
        "Greetings D",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pgreetingse"] = {
        "pazeee@greetings@e@animations",
        "pazeee@greetings@e@clip",
        "Greetings E",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pbowinga"] = {
        "pazeee@bowing@a@animations",
        "pazeee@bowing@a@clip",
        "Bowing A",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["pbowingb"] = {
        "pazeee@bowing@b@animations",
        "pazeee@bowing@b@clip",
        "Bowing B",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["pbowingc"] = {
        "pazeee@bowing@c@animations",
        "pazeee@bowing@c@clip",
        "Bowing C",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["pbowingd"] = {
        "pazeee@bowing@d@animations",
        "pazeee@bowing@d@clip",
        "Bowing D",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["pbowinge"] = {
        "pazeee@bowing@e@animations",
        "pazeee@bowing@e@clip",
        "Bowing E",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologya"] = {
        "pazeee@apology@a@animations",
        "pazeee@apology@a@clip",
        "Apology A",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyb"] = {
        "pazeee@apology@b@animations",
        "pazeee@apology@b@clip",
        "Apology B",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyc"] = {
        "pazeee@apology@c@animations",
        "pazeee@apology@c@clip",
        "Apology C",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyd"] = {
        "pazeee@apology@d@animations",
        "pazeee@apology@d@clip",
        "Apology D",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologye"] = {
        "pazeee@apology@e@animations",
        "pazeee@apology@e@clip",
        "Apology E",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyf"] = {
        "pazeee@apology@f@animations",
        "pazeee@apology@f@clip",
        "Apology F",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyg"] = {
        "pazeee@apology@g@animations",
        "pazeee@apology@g@clip",
        "Apology G",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["papologyh"] = {
        "pazeee@apology@h@animations",
        "pazeee@apology@h@clip",
        "Apology H",
        AnimationOptions = {
            EmoteLoop = true,
        }
    },
    ["pohhnooa"] = {
        "pazeee@ohhnoo@a@animations",
        "pazeee@ohhnoo@a@clip",
        "Oh Noo A",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pohhnoob"] = {
        "pazeee@ohhnoo@b@animations",
        "pazeee@ohhnoo@b@clip",
        "Oh Noo B",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["phehehe"] = {
        "pazeee@hehehe@a@animations",
        "pazeee@hehehe@a@clip",
        "Awkward Scracth Hehehe",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["pconfused"] = {
        "pazeee@confused@a@animations",
        "pazeee@confused@a@clip",
        "Confused or I don't know",
        AnimationOptions = {
            EmoteLoop = true,
			EmoteMoving = true
        }
    },
    ["trick"] = {
        "rcmextreme2atv", "idle_b",
        "P'tit trick",
        AnimationOptions = {
            EmoteLoop = false,
            EmoteMoving = false,
            EmoteDuration = 5000
        }
    },
    ["trick2"] = {
        "rcmextreme2atv", "idle_c",
        "P'tit trick #2",
        AnimationOptions = {
            EmoteLoop = false,
            EmoteMoving = false,
            EmoteDuration = 3000
        }
    },
    ["trick3"] = {
        "rcmextreme2atv", "idle_d",
        "P'tit trick #3",
        AnimationOptions = {
            EmoteLoop = false,
            EmoteMoving = false,
            EmoteDuration = 5000
        }
    },
    ["trick4"] = {
        "rcmextreme2atv", "idle_e",
        "P'tit trick #4",
        AnimationOptions = {
            EmoteLoop = false,
            EmoteMoving = false,
            EmoteDuration = 3000
        }
    },

    ["sexypose"] = {
        "littlespoon@sexy003",
        "sexy003",
        "Sexy Pose",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
    ["sexypose2"] = {
        "littlespoon@sexy004",
        "sexy004",
        "Sexy Pose 2",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
    ["sexypose3"] = {
        "littlespoon@sexy005",
        "sexy005",
        "Sexy Pose 3",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
    ["sexypose4"] = {
        "littlespoon@sexy006",
        "sexy006",
        "Sexy Pose 4",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
    ["sexypose5"] = {
        "littlespoon@sexy009",
        "sexy009",
        "Sexy Pose 5",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
    ["sexypose6"] = {
        "littlespoon@sexy012",
        "sexy012",
        "Sexy Pose 5",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },

    ["elbow2"] = {
        "chocoholic@single47",
        "single47_clip",
        "Window Elbow 2",
        AnimationOptions = {
            EmoteLoop = true
        }
    },

    ["big_jump_01"] = {"parkour@anims", "big_jump_01", "Test parkour #1", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["front_twist_flip"] = {"parkour@anims", "front_twist_flip", "Test parkour #2", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["jump_over_01"] = {"parkour@anims", "jump_over_01", "Test parkour #3", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["jump_over_02"] = {"parkour@anims", "jump_over_02", "Test parkour #4", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["slide_kip_up"] = {"parkour@anims", "slide_kip_up", "Test parkour #5", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["jump_over_03"] = {"parkour@anims", "jump_over_03", "Test parkour #6", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["slide_backside"] = {"parkour@anims", "slide_backside", "Test parkour #7", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["slide"] = {"parkour@anims", "slide", "Test parkour #8", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["swing_jump"] = {"parkour@anims", "swing_jump", "Test parkour #9", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["wall_flip"] = {"parkour@anims", "wall_flip", "Test parkour #10", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    }},

    ["mariage"] = {"tigerle@custom@pose@proposal", "tigerle_pose_proposal", "Demande en mariage", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},

    ["dab"] = { "custom@dab", "dab", "Dab", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = true,
   }},
   ["cantsee"] = { "custom@cant_see", "cant_see", "Can't See", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = true,
   }},
   ["sheesh"] = {"custom@sheeeeesh", "sheeeeesh", "Sheesh", AnimationOptions =
   {
     EmoteMoving = true,
     EmoteDuration = 8000,
   }},
   ["copsearch"] = {"custom@police", "police", "Cop Search", AnimationOptions =
   {
     EmoteMoving = false,
     EmoteDuration = 8000,
   }},
   ["sus"] = {"custom@suspect", "suspect", "Suspect", AnimationOptions =
   {
     EmoteMoving = false,
   }},
   ["cdig"] = {"custom@dig", "dig", "Custom Dig", AnimationOptions =
   {
     EmoteMoving = false,
     EmoteDuration = 8000,
   }},
   ["armswirl"] = {"custom@armswirl", "armswirl", "Arm Swirl", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["woowalk"] = {"div@woowalk@test", "woowalk", "Woo Walk", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["drilldance"] = {"div@woowalk@test", "drilldance", "Drill Dance", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["sturdy2"] = {"div@woowalk@test", "sturdy2", "Get Sturdy", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["bloodwalk2"] = {"div@woowalk@test", "bloodwalk2", "Blood Walk", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["blixkytwirl2"] = {"div@woowalk@test", "blixkytwirl2", "Blixky Twirl", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["armwave"] = {"custom@armwave", "armwave", "Arm Wave", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["circlecrunch"] = {"custom@circle_crunch", "circle_crunch", "Circle Crunch", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["circlecrunch"] = {"custom@circle_crunch", "circle_crunch", "Circle Crunch", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["whatidk"] = {"custom@what_idk", "what_idk", "What? Don't Know", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["pickfromground"] = {"custom@pickfromground", "pickfromground", "Pick From Ground", AnimationOptions =
   {
     EmoteLoop = true,
     EmoteMoving = false,
   }},
   ["bellydance"] = {"custom@bellydance", "bellydance", "Belly Dance", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["convulsion"] = {"custom@convulsion", "convulsion", "Convulsion", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose1"] = {"custom@female_pose_1", "female_pose_1", "Pose 1", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose2"] = {"custom@female_pose_2", "female_pose_2", "Pose 2", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose3"] = {"custom@female_pose_3", "female_pose_3", "Pose 3", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["hiphopslide"] = {"custom@hiphop_slide", "hiphop_slide", "HipHop Slide", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["hiphop1"] = {"custom@hiphop1", "hiphop1", "HipHop 1", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["hiphop2"] = {"custom@hiphop2", "hiphop2", "HipHop 2", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["hiphop3"] = {"custom@hiphop3", "hiphop3", "HipHop 3", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = false,
   }},
   ["hiphopold"] = {"custom@hiphop90s", "hiphop90s", "HipHop Old", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose4"] = {"custom@male_pose_1", "male_pose_1", "Pose 4", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose5"] = {"custom@male_pose_2", "male_pose_2", "Pose 5", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pose6"] = {"custom@male_pose_3", "male_pose_3", "Pose 6", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["pluck"] = {"custom@pluck_fruits", "pluck_fruits", "Pluck Fruits", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["waiter"] = {"custom@waiter", "waiter", "Waiter", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }},

   ["breakdance"] = {"export@breakdance", "breakdance", "Break Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["gangnamstyle"] = {"custom@gangnamstyle", "gangnamstyle", "Gangnam Style", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["macarena"] = {"custom@makarena", "makarena", "Macarena", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["maraschino"] = {"custom@maraschino", "maraschino", "Maraschino", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["salsa"] = {"custom@salsa", "salsa", "Salsa", AnimationOptions =
   {
      EmoteLoop = true,
   }},

   ["ddance1"] = {"divined@dances@new", "ddance1", "Divined Dance 1", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance2"] = {"divined@dances@new", "ddance2", "Divined Dance 2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance3"] = {"divined@dances@new", "ddance3", "Divined Dance 3", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance4"] = {"divined@dances@new", "ddance4", "Divined Dance 4", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance5"] = {"divined@dances@new", "ddance5", "Divined Dance 5", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance6"] = {"divined@dances@new", "ddance6", "Divined Dance 6", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance7"] = {"divined@dances@new", "ddance7", "Divined Dance 7", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance8"] = {"divined@dances@new", "ddance8", "Divined Dance 8", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance9"] = {"divined@dances@new", "ddance9", "Divined Dance 9", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance10"] = {"divined@dances@new", "ddance10", "Divined Dance 10", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance11"] = {"divined@dances@new", "ddance11", "Divined Dance 11", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance12"] = {"divined@dances@new", "ddance12", "Divined Dance 12", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["ddance13"] = {"divined@dances@new", "ddance13", "Divined Dance 13", AnimationOptions =
   {
      EmoteLoop = true
   }},

   ["divdance1"] = {"divined@dancesv2@new", "divdance1", "Divined Dance 1 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance2"] = {"divined@dancesv2@new", "divdance2", "Divined Dance 2 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance3"] = {"divined@dancesv2@new", "divdance3", "Divined Dance 3 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance4"] = {"divined@dancesv2@new", "divdance4", "Divined Dance 4 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance5"] = {"divined@dancesv2@new", "divdance5", "Divined Dance 5 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance6"] = {"divined@dancesv2@new", "divdance6", "Divined Dance 6 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance7"] = {"divined@dancesv2@new", "divdance7", "Divined Dance 7 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance8"] = {"divined@dancesv2@new", "divdance8", "Divined Dance 8 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance9"] = {"divined@dancesv2@new", "divdance9", "Divined Dance 9 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance10"] = {"divined@dancesv2@new", "divdance10", "Divined Dance 10 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance11"] = {"divined@dancesv2@new", "divdance11", "Divined Dance 11 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance12"] = {"divined@dancesv2@new", "divdance12", "Divined Dance 12 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance13"] = {"divined@dancesv2@new", "divdance13", "Divined Dance 13 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divdance14"] = {"divined@dancesv2@new", "divdance14", "Divined Dance 14 V2", AnimationOptions =
   {
      EmoteLoop = true
   }},

   ["divbdance1"] = {"divined@breakdances@new", "divbdance1", "Divined Break Dance 1", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance2"] = {"divined@breakdances@new", "divbdance2", "Divined Break Dance 2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance3"] = {"divined@breakdances@new", "divbdance3", "Divined Break Dance 3", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance4"] = {"divined@breakdances@new", "divbdance4", "Divined Break Dance 4", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance5"] = {"divined@breakdances@new", "divbdance5", "Divined Break Dance 5", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance6"] = {"divined@breakdances@new", "divbdance6", "Divined Break Dance 6", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance7"] = {"divined@breakdances@new", "divbdance7", "Divined Break Dance 7", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance8"] = {"divined@breakdances@new", "divbdance8", "Divined Break Dance 8", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance9"] = {"divined@breakdances@new", "divbdance9", "Divined Break Dance 9", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance10"] = {"divined@breakdances@new", "divbdance10", "Divined Break Dance 10", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance11"] = {"divined@breakdances@new", "divbdance11", "Divined Break Dance 11", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance12"] = {"divined@breakdances@new", "divbdance12", "Divined Break Dance 12", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance13"] = {"divined@breakdances@new", "divbdance13", "Divined Break Dance 13", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance14"] = {"divined@breakdances@new", "divbdance14", "Divined Break Dance 14", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["divbdance15"] = {"divined@breakdances@new", "divbdance14", "Divined Break Dance 15", AnimationOptions =
   {
      EmoteLoop = true
   }},

   ["dbrdance1"] = {"divined@brdancesv2@new", "dbrdance1", "Divined Dance 1", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance2"] = {"divined@brdancesv2@new", "dbrdance2", "Divined Dance 2", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance3"] = {"divined@brdancesv2@new", "dbrdance3", "Divined Dance 3", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance4"] = {"divined@brdancesv2@new", "dbrdance4", "Divined Dance 4", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance5"] = {"divined@brdancesv2@new", "dbrdance5", "Divined Dance 5", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance6"] = {"divined@brdancesv2@new", "dbrdance6", "Divined Dance 6", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance7"] = {"divined@brdancesv2@new", "dbrdance7", "Divined Dance 7", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance8"] = {"divined@brdancesv2@new", "dbrdance8", "Divined Dance 8", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance9"] = {"divined@brdancesv2@new", "dbrdance9", "Divined Dance 9", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance10"] = {"divined@brdancesv2@new", "dbrdance10", "Divined Dance 10", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance11"] = {"divined@brdancesv2@new", "dbrdance11", "Divined Dance 11", AnimationOptions =
   {
      EmoteLoop = true
   }},
   ["dbrdance12"] = {"divined@brdancesv2@new", "dbrdance12", "Divined Dance 12", AnimationOptions =
   {
      EmoteLoop = true
   }},

   ["banddance"] = {"divined@tdances@new", "dtdance1", "Band Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["bopdance"] = {"divined@tdances@new", "dtdance2", "Bop", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["bboydance"] = {"divined@tdances@new", "dtdance3", "BBoy Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["capoeiramove"] = {"divined@tdances@new", "dtdance4", "Capoeira Move", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hiphopdance"] = {"divined@tdances@new", "dtdance5", "Hip Hop Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hipsterdance"] = {"divined@tdances@new", "dtdance6", "Hipster Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hippiedance"] = {"divined@tdances@new", "dtdance7", "Hippie Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hiphoptaunt"] = {"divined@tdances@new", "dtdance8", "Hip Hop Taunt", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hilowave"] = {"divined@tdances@new", "dtdance9", "Hi Lo Wave", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["squaredance"] = {"divined@tdances@new", "dtdance10", "Square Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hotdance"] = {"divined@tdances@new", "dtdance11", "Hot Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["hulahula"] = {"divined@tdances@new", "dtdance12", "Hula-Hula", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["dabloop"] = {"divined@tdances@new", "dtdance13", "Dab Loop", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["kingdance"] = {"divined@tdances@new", "dtdance14", "The King's Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["linedance"] = {"divined@tdances@new", "dtdance15", "Dance Line", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["magicman"] = {"divined@tdances@new", "dtdance16", "Magic Man", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["marat"] = {"divined@tdances@new", "dtdance17", "Marat", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["maskoff"] = {"divined@tdances@new", "dtdance18", "Mask Off", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["mellow"] = {"divined@tdances@new", "dtdance19", "Mellow", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["showroomdance"] = {"divined@tdances@new", "dtdance20", "Showroom Dance", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["windmillfloss"] = {"divined@tdances@new", "dtdance21", "Windmill Floss", AnimationOptions =
   {
      EmoteLoop = true,
   }},
   ["woahdance"] = {"divined@tdances@new", "dtdance22", "Woah", AnimationOptions =
   {
      EmoteLoop = true,
   }},

   ["fsign"] = {"custom@fsign_1", "fsign_1", "Female Sign 1", AnimationOptions =
   {
      EmoteLoop = true,
      EmoteMoving = false,
   }},
   ["cane"] = {"missheistdocksprep1hold_cellphone", "static", "Cane", AnimationOptions =
   {
       Prop = "prop_cs_walking_stick",
       PropBone = 57005,
       PropPlacement = {0.15, 0.05, -0.03, 0.0, 266.0, 180.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["handspocket"] = {"custom@handsinpockets_1", "handsinpockets_1", "Hands in Pocket", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }},
   ["renegade"] = {"custom@renegade", "renegade", "Renegade", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["savage"] = {"custom@savage", "savage", "Savage", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["sayso"] = {"custom@sayso", "sayso", "Say So", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},
   ["tslide"] = {"custom@toosie_slide", "toosie_slide", "Tootsie Slide", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["defaultdance"] = {"custom@dancemoves", "dancemoves", "Default Dance", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["discodance"] = {"custom@disco_dance", "disco_dance", "Disco Dance", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["electroshuffle"] = {"custom@electroshuffle_original", "electroshuffle_original", "Electro Shuffle", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["electroshuffle2"] = {"custom@electroshuffle", "electroshuffle", "Electro Shuffle 2", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["hitit"] = {"custom@hitit", "hitit", "Hit It", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["floss"] = {"custom@floss", "floss", "Floss", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["orangejustice"] = {"custom@orangejustice", "orangejustice", "Orange Justice", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

   ["takel"] = {"custom@take_l", "take_l", "Take the L", AnimationOptions =
   {
      EmoteMoving = false,
      EmoteLoop = true,
   }},

    ["mog1"] = {"mogangsign1@animation", "mogangsign1_clip", "Gang Sign 1", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},
    ["mop1"] = {"mopose1@animation", "mopose1_clip", "Chill Pose 1", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},
    ["mop2"] = {"mopose2@animation", "mopose2_clip", "Chill Pose 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},
    ["mop3"] = {"mopose3@animation", "mopose3_anim", "Chill Pose 3", AnimationOptions = {
        Prop = 'prop_whiskey_bottle',
        PropBone = 12345,
        PropPlacement = {0.00, 0.00, 0.00, 0.00, 0.00},
        EmoteLoop = true,
        EmoteMoving = false,
    }},
    ["mop4"] = {"mopose4@animation", "mopose4_clip", "Chill Pose 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},
    ["mop5"] = {"mopose5@animation", "mopose5_clip", "Chill Pose 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    }},

    ["beast"] = { "anim@mp_fm_event@intro", "beast_transform", "Péter un plomb", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 5000,
    } },

    ["cloudgaze2"] = { "switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_guy", "S'allonger sur le dos 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["pullover"] = { "misscarsteal3pullover", "pull_over_right", "Pullover", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1300,
    } },
    ["idle"] = { "anim@heists@heist_corona@team_idles@male_a", "idle", "Attendre", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle8"] = { "amb@world_human_hang_out_street@male_b@idle_a", "idle_b", "Attendre 8" },
    ["idle9"] = { "friends@fra@ig_1", "base_idle", "Attendre 9", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle10"] = { "mp_move@prostitute@m@french", "idle", "Attendre 10", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["idle11"] = { "random@countrysiderobbery", "idle_a", "Attendre 11", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle2"] = { "anim@heists@heist_corona@team_idles@female_a", "idle", "Attendre 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle3"] = { "anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", "Attendre 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle4"] = { "anim@mp_celebration@idles@female", "celebration_idle_f_a", "Attendre 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle5"] = { "anim@mp_corona_idles@female_b@idle_a", "idle_a", "Attendre 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle6"] = { "anim@mp_corona_idles@male_c@idle_a", "idle_a", "Attendre 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle7"] = { "anim@mp_corona_idles@male_d@idle_a", "idle_a", "Attendre 7", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk"] = { "random@drunk_driver_1", "drunk_driver_stand_loop_dd1", "Attendre bourré", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk2"] = { "random@drunk_driver_1", "drunk_driver_stand_loop_dd2", "Attendre bourré 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk3"] = { "missarmenian2", "standing_idle_loop_drunk", "Attendre bourré 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["airguitar"] = { "anim@mp_player_intcelebrationfemale@air_guitar", "air_guitar", "Allumer le feu" },
    ["airsynth"] = { "anim@mp_player_intcelebrationfemale@air_synth", "air_synth", "Pianiste" },
    ["argue2"] = { "oddjobs@assassinate@vice@hooker", "argue_a", "Argue 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["bartender"] = { "anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", "Se réchauffer les mains", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["blowkiss"] = { "anim@mp_player_intcelebrationfemale@blow_kiss", "blow_kiss", "Envoyer des bisous" },
    ["blowkiss2"] = { "anim@mp_player_intselfieblow_kiss", "exit", "Envoyer un bisou", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000

    } },
    ["curtsy"] = { "anim@mp_player_intcelebrationpaired@f_f_sarcastic", "sarcastic_left", "Curtsy" },
    ["bringiton"] = { "misscommon@response", "bring_it_on", "Je suis le boss", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["comeatmebro"] = { "mini@triathlon", "want_some_of_this", "Tu me cherches mec", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["damn"] = { "gestures@m@standing@casual", "gesture_damn", "Balancer ses bras", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["damn2"] = { "anim@am_hold_up@male", "shoplift_mid", "Damn 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["pointdown"] = { "gestures@f@standing@casual", "gesture_hand_down", "Pointer vers le bas", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["surrender"] = { "random@arrests@busted", "idle_a", "Se rendre", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender2"] = { "mp_bank_heist_1", "f_cower_02", "Se rendre 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender3"] = { "mp_bank_heist_1", "m_cower_01", "Se rendre 3", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender4"] = { "mp_bank_heist_1", "m_cower_02", "Se rendre 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender5"] = { "random@arrests", "kneeling_arrest_idle", "Se rendre 5", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender6"] = { "rcmbarry", "m_cower_01", "Se rendre 6", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["facepalm2"] = { "anim@mp_player_intcelebrationfemale@face_palm", "face_palm", "Désespéré  2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm"] = { "random@car_thief@agitated@idle_a", "agitated_idle_a", "Désespéré ", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm3"] = { "missminuteman_1ig_2", "tasered_2", "Désespéré  3", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm4"] = { "anim@mp_player_intupperface_palm", "idle_a", "Désespéré  4", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["fallover"] = { "random@drunk_driver_1", "drunk_fall_over", "Ëtre Bourré" },
    ["fallover2"] = { "mp_suicide", "pistol", "Se tirer une balle 2" },
    ["fallover3"] = { "mp_suicide", "pill", "Manger une pillule 3" },
    ["fallover4"] = { "friends@frf@ig_2", "knockout_plyr", "Se prendre un poing 4" },
    ["fallover5"] = { "anim@gangops@hostage@", "victim_fail", "Se prendre un poing 5" },
    ["fallasleep"] = { "mp_sleep", "sleep_loop", "Baisser la tête", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["handshake"] = { "mp_ped_interaction", "handshake_guy_a", "Check moi ça", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["handshake2"] = { "mp_ped_interaction", "handshake_guy_b", "Check moi ça 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["wait"] = { "random@shop_tattoo", "_idle_a", "Attendre", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitb"] = { "missbigscore2aig_3", "wait_for_van_c", "Attendre B", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitc"] = { "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", "Attendre C", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitd"] = { "amb@world_human_hang_out_street@Female_arm_side@idle_a", "idle_a", "Attendre D", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waite"] = { "missclothing", "idle_storeclerk", "Attendre E", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitf"] = { "timetable@amanda@ig_2", "ig_2_base_amanda", "Attendre F", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitg"] = { "rcmnigel1cnmt_1c", "base", "Attendre G", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waith"] = { "rcmjosh1", "idle", "Attendre H", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waiti"] = { "rcmjosh2", "josh_2_intp1_base", "Attendre I", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitj"] = { "timetable@amanda@ig_3", "ig_3_base_tracy", "Attendre J", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitk"] = { "misshair_shop@hair_dressers", "keeper_base", "Attendre K", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitl"] = { "rcmjosh1", "keeper_base", "Attendre L", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitm"] = { "rcmnigel1a", "base", "Attendre M", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["hiking"] = { "move_m@hiking", "idle", "Tenir son sac à dos", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["hug"] = { "mp_ped_interaction", "kisses_guy_a", "Hug" },
    ["hug2"] = { "mp_ped_interaction", "kisses_guy_b", "Hug 2" },
    ["hug3"] = { "mp_ped_interaction", "hugs_guy_a", "Hug 3" },
    ["inspect"] = { "random@train_tracks", "idle_e", "Inspecter" },
    ["jazzhands"] = { "anim@mp_player_intcelebrationfemale@jazz_hands", "jazz_hands", "Danse gitane (ou po)", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 6000,
    } },
    ["jog2"] = { "amb@world_human_jog_standing@male@idle_a", "idle_a", "S'échauffer 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog3"] = { "amb@world_human_jog_standing@female@idle_a", "idle_a", "S'échauffer 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog4"] = { "amb@world_human_power_walker@female@idle_a", "idle_a", "S'échauffer 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog5"] = { "move_m@joy@a", "walk", "S'échauffer 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jumpingjacks"] = { "timetable@reunited@ig_2", "jimmy_getknocked", "Il saute le con", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["kneel2"] = { "rcmextreme3", "idle", "Inspecter 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["kneel3"] = { "amb@world_human_bum_wash@male@low@idle_a", "idle_a", "Inspecter 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["knock"] = { "timetable@jimmy@doorknock@", "knockdoor_idle", "Toc toc", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["knock2"] = { "missheistfbi3b_ig7", "lift_fibagent_loop", "Toc toc 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["knucklecrunch"] = { "anim@mp_player_intcelebrationfemale@knuckle_crunch", "knuckle_crunch", "Craquer les doigts", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lean2"] = { "amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", "Posé 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lean3"] = { "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", "idle_a", "Posé 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lean4"] = { "amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a", "Posé 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lean5"] = { "amb@world_human_leaning@male@wall@back@hands_together@idle_b", "idle_b", "Posé 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanflirt"] = { "random@street_race", "_car_a_flirt_girl", "Posé au calme", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar2"] = { "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", "Posé Bar 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar3"] = { "anim@amb@nightclub@lazlow@ig1_vip@", "clubvip_base_laz", "Posé Bar 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar4"] = { "anim@heists@prison_heist", "ped_b_loop_a", "Posé Bar 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanhigh"] = { "anim@mp_ferris_wheel", "idle_a_player_one", "Posé haut", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanhigh2"] = { "anim@mp_ferris_wheel", "idle_a_player_two", "Posé haut 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside"] = { "timetable@mime@01_gc", "idle_a", "Accoudé", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside2"] = { "misscarstealfinale", "packer_idle_1_trevor", "Je tiens le mur", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside3"] = { "misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Accoudé 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside4"] = { "misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Accoudé 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["leanside5"] = { "rcmjosh2", "josh_2_intp1_base", "Accoudé bizarre wesh", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["me"] = { "gestures@f@standing@casual", "gesture_me_hard", "Moi ?", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["mechanic"] = { "mini@repair", "fixing_a_ped", "Mécano", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic2"] = { "mini@repair", "fixing_a_player", "Mécano 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic3"] = { "amb@world_human_vehicle_mechanic@male@base", "base", "Mécano 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["mechanic4"] = { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Mécano 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic5"] = { "amb@prop_human_movie_bulb@idle_a", "idle_b", "Mécano 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["medic2"] = { "amb@medic@standing@tendtodead@base", "base", "Medic 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["meditate"] = { "rcmcollect_paperleadinout@", "meditiate_idle", "Méditer", AnimationOptions =
    {
        EmoteLoop = true,
    } },
    ["meditate2"] = { "rcmepsilonism3", "ep_3_rcm_marnie_meditating", "Méditer 2", AnimationOptions =
    {
        EmoteLoop = true,
    } },
    ["meditate3"] = { "rcmepsilonism3", "base_loop", "Méditer 3", AnimationOptions =
    {
        EmoteLoop = true,
    } },
    ["metal"] = { "anim@mp_player_intincarrockstd@ps@", "idle_a", "Rock'n'roll", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["no"] = { "anim@heists@ornate_bank@chat_manager", "fail", "Non", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["no2"] = { "mp_player_int_upper_nod", "mp_player_int_nod_no", "Non 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nosepick"] = { "anim@mp_player_intcelebrationfemale@nose_pick", "nose_pick", "Crotte de nez", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["noway"] = { "gestures@m@standing@casual", "gesture_no_way", "Non", AnimationOptions = {
        EmoteDuration = 1500,
        EmoteMoving = true,
    } },
    ["ok"] = { "anim@mp_player_intselfiedock", "idle_a", "OK", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["outofbreath"] = { "re@construction", "out_of_breath", "Plus de souffle", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pickup"] = { "random@domestic", "pickup_low", "Ramasser" },
    ["push"] = { "missfinale_c2ig_11", "pushcar_offcliff_f", "Pousser", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["push2"] = { "missfinale_c2ig_11", "pushcar_offcliff_m", "Pousser 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["point"] = { "gestures@f@standing@casual", "gesture_point", "Pointer du doigt", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pushup"] = { "amb@world_human_push_ups@male@idle_a", "idle_d", "Faire des pompes", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["countdown"] = { "random@street_race", "grid_girl_race_start", "Applaudissement joyeux", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pointright"] = { "mp_gun_shop_tut", "indicate_right", "Pointer vers la droite", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute"] = { "anim@mp_player_intincarsalutestd@ds@", "idle_a", "Salut militaire", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute2"] = { "anim@mp_player_intincarsalutestd@ps@", "idle_a", "Salute militaire 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute3"] = { "anim@mp_player_intuppersalute", "idle_a", "Salute militaire 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["scared"] = { "random@domestic", "f_distressed_loop", "Avoir peur", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["scared2"] = { "random@homelandsecurity", "knees_loop_girl", "Avoir peur 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["screwyou"] = { "misscommon@response", "screw_you", "J'te baise", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shakeoff"] = { "move_m@_idles@shake_off", "shakeoff_1", "Se nettoyer", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3500,
    } },
    ["shot"] = { "random@dealgonewrong", "idle_a", "Tombé love d'un voyou", AnimationOptions = {
        EmoteLoop = true,
    } },

    ["shrug"] = { "gestures@f@standing@casual", "gesture_shrug_hard", "Je sais pas", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["shrug2"] = { "gestures@m@standing@casual", "gesture_shrug_hard", "Je sais pas 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["clapangry"] = { "anim@arena@celeb@flat@solo@no_props@", "angry_clap_a_player_a", "Applaudissement Aggressive", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["slowclap3"] = { "anim@mp_player_intupperslow_clap", "idle_a", "Applaudir lentement 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["clap"] = { "amb@world_human_cheering@male_a", "base", "Applaudir 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slowclap"] = { "anim@mp_player_intcelebrationfemale@slow_clap", "slow_clap", "Applaudir lentement", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slowclap2"] = { "anim@mp_player_intcelebrationmale@slow_clap", "slow_clap", "Applaudir lentement 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["smell"] = { "move_p_m_two_idles@generic", "fidget_sniff_fingers", "Sentir", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stickup"] = { "random@countryside_gang_fight", "biker_02_stickup_loop", "Stick Up", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stumble"] = { "misscarsteal4@actor", "stumble", "Mal de tête", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stunned"] = { "stungun@standing", "damage", "Électrocuté", AnimationOptions = {
        EmoteLoop = true,
    } },

    ["t"] = { "missfam5_yoga", "a2_pose", "T", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["t2"] = { "mp_sleep", "bind_pose_180", "T 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["think5"] = { "mp_cp_welcome_tutthink", "b_think", "Penser 5", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["think"] = { "misscarsteal4@aliens", "rehearsal_base_idle_director", "Penser", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["think3"] = { "timetable@tracy@ig_8@base", "base", "Penser 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["think2"] = { "missheist_jewelleadinout", "jh_int_outro_loop_a", "Penser 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["thumbsup3"] = { "anim@mp_player_intincarthumbs_uplow@ds@", "enter", "Pouce 3", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },
    ["thumbsup2"] = { "anim@mp_player_intselfiethumbs_up", "idle_a", "Pouce 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["thumbsup"] = { "anim@mp_player_intupperthumbs_up", "idle_a", "Pouce", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type"] = { "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", "Écrire sur un clavier", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type2"] = { "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", "Écrire sur un clavier 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type3"] = { "mp_prison_break", "hack_loop", "Écrire sur un clavier 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type4"] = { "mp_fbi_heist", "loop", "Écrire sur un clavier 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["warmth"] = { "amb@world_human_stand_fire@male@idle_a", "idle_a", "Même nous on sait pas", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave4"] = { "random@mugging5", "001445_01_gangintimidation_1_female_idle_b", "Coucou 4", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },
    ["wave2"] = { "anim@mp_player_intcelebrationfemale@wave", "wave", "Coucou 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave3"] = { "friends@fra@ig_1", "over_here_idle_a", "Coucou 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave"] = { "friends@frj@ig_1", "wave_a", "Coucou", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave5"] = { "friends@frj@ig_1", "wave_b", "Coucou 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave6"] = { "friends@frj@ig_1", "wave_c", "Coucou 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave7"] = { "friends@frj@ig_1", "wave_d", "Coucou 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave8"] = { "friends@frj@ig_1", "wave_e", "Coucou 8", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave9"] = { "gestures@m@standing@casual", "gesture_hello", "Coucou 9", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["whistle"] = { "taxi_hail", "hail_taxi", "Siffler", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1300,
    } },
    ["whistle2"] = { "rcmnigel1c", "hailing_whistle_waive_a", "Siffler 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["yeah"] = { "anim@mp_player_intupperair_shagging", "idle_a", "Je t'encule fdp", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lift"] = { "random@hitch_lift", "idle_f", "Faire du stop", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lol"] = { "anim@arena@celeb@flat@paired@no_props@", "laugh_a_player_b", "Rigoler", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lol2"] = { "anim@arena@celeb@flat@solo@no_props@", "giggle_a_player_b", "Chut", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["statue2"] = { "fra_0_int-1", "cs_lamardavis_dual-1", "Statue 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["statue3"] = { "club_intro2-0", "csb_englishdave_dual-0", "Statue 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["petting"] = { "creatures@rottweiler@tricks@", "petting_franklin", "Joue avec l'animal", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["crawl"] = { "move_injured_ground", "front_loop", "Ramper", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["slide"] = { "anim@arena@celeb@flat@solo@no_props@", "slide_a_player_a", "Glisser" },
    ["slide2"] = { "anim@arena@celeb@flat@solo@no_props@", "slide_b_player_a", "Glisser 2" },
    ["slide3"] = { "anim@arena@celeb@flat@solo@no_props@", "slide_c_player_a", "Glisser 3" },
    ["slugger"] = { "anim@arena@celeb@flat@solo@no_props@", "slugger_a_player_a", "Baseball" },
    ["keyfob"] = { "anim@mp_player_intmenu@key_fob@", "fob_click", "Bip bip", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["reaching"] = { "move_m@intimidation@cop@unarmed", "idle", "Main holster", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slap"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Slap", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["headbutt"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Coup de tête" },
    ["peace"] = { "mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", "PNL", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace2"] = { "anim@mp_player_intupperpeace", "idle_a", "PNL 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace3"] = { "anim@mp_player_intupperpeace", "idle_a_fp", "PNL 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace4"] = { "anim@mp_player_intincarpeacestd@ds@", "idle_a", "PNL 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
     } },
    ["peace5"] = { "anim@mp_player_intincarpeacestd@ds@", "idle_a_fp", "PNL 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace6"] = { "anim@mp_player_intincarpeacebodhi@ds@", "idle_a", "PNL 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace7"] = { "anim@mp_player_intincarpeacebodhi@ds@", "idle_a_fp", "PNL 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peacef"] = { "anim@mp_player_intcelebrationfemale@peace", "peace", "PNL Femme", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["ledge"] = { "missfbi1", "ledge_loop", "Faire l'avion 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["airplane"] = { "missfbi1", "ledge_loop", "Faire l'avion", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peek"] = { "random@paparazzi@peek", "left_peek_a", "Se cacher", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cough"] = { "timetable@gardener@smoking_joint", "idle_cough", "Tousser", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stretch"] = { "mini@triathlon", "idle_e", "S'étirer", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch2"] = { "mini@triathlon", "idle_f", "S'étirer 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch3"] = { "mini@triathlon", "idle_d", "S'étirer 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch4"] = { "rcmfanatic1maryann_stretchidle_b", "idle_e", "S'étirer 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["celebrate"] = { "rcmfanatic1celebrate", "celebrate", "Célébration", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["punching"] = { "rcmextreme2", "loop_punching", "Shadow boxing", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["superhero"] = { "rcmbarry", "base", "Superhero", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["superhero2"] = { "rcmbarry", "base", "Superhero 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["mindcontrol"] = { "rcmbarry", "mind_control_b_loop", "Contrôle par la pensée", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mindcontrol2"] = { "rcmbarry", "bar_1_attack_idle_aln", "Contrôle par la pensée 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["clown"] = { "rcm_barry2", "clown_idle_0", "Faire le clown", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["clown2"] = { "rcm_barry2", "clown_idle_1", "Faire le clown 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["clown3"] = { "rcm_barry2", "clown_idle_2", "Faire le clown 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["clown4"] = { "rcm_barry2", "clown_idle_3", "Faire le clown 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tryclothes"] = { "mp_clothing@female@trousers", "try_trousers_neutral_a", "Essai vêtements", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["tryclothes2"] = { "mp_clothing@female@shirt", "try_shirt_positive_a", "Essai vêtements 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["tryclothes3"] = { "mp_clothing@female@shoes", "try_shoes_positive_a", "Essai vêtements 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["nervous2"] = { "mp_missheist_countrybank@nervous", "nervous_idle", "Nerveux 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nervous"] = { "amb@world_human_bum_standing@twitchy@idle_a", "idle_c", "Nerveux", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nervous3"] = { "rcmme_tracey1", "nervous_loop", "Nerveux 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["uncuff"] = { "mp_arresting", "a_uncuff", "Démenotter", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["namaste"] = { "timetable@amanda@ig_4", "ig_4_base", "Chintok", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["threaten"] = { "random@atmrobberygen", "b_atm_mugging", "Pointer avec une arme", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["radio"] = { "random@arrests", "generic_radio_chatter", "Radio", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pull"] = { "random@mugging4", "struggle_loop_b_thief", "Il tire un truc le mec", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["bird"] = { "random@peyote@bird", "wakeup", "Faire l'oiseau" },
    ["chicken"] = { "random@peyote@chicken", "wakeup", "Poule Mouillée", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["bark"] = { "random@peyote@dog", "wakeup", "Bark" },
    ["rabbit"] = { "random@peyote@rabbit", "wakeup", "Faire le lapin" },
    ["spiderman"] = { "missexile3", "ex03_train_roof_idle", "Spider-Man", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["boi"] = { "special_ped@jane@monologue_5@monologue_5c", "brotheradrianhasshown_2", "Tu veux une claque ", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },

    ["handsup"] = { "missminuteman_1ig_2", "handsup_base", "Lever les mains", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["handsup2"] = { "anim@mp_player_intuppersurrender", "idle_a_fp", "Lever les mains 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["pee"] = { "misscarsteal2peeing", "peeing_loop", "Pisser", AnimationOptions = {
        EmoteStuck = true,
        PtfxAsset = "scr_amb_chop",
        PtfxName = "ent_anim_dog_peeing",
        PtfxNoProp = true,
        PtfxPlacement = { -0.05, 0.3, 0.0, 0.0, 90.0, 90.0, 1.0 },
        PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['pee'],
        PtfxWait = 3000,
    } },
    ["valet"] = { "anim@amb@casino@valet_scenario@pose_a@", "base_a_m_y_vinewood_01", "Réchauffer les mains 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["valet2"] = { "anim@amb@casino@valet_scenario@pose_b@", "base_a_m_y_vinewood_01", "Réchauffer les mains 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["valet3"] = { "anim@amb@casino@valet_scenario@pose_d@", "base_a_m_y_vinewood_01", "Réchauffer les mains 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["showerf"] = { "mp_safehouseshower@female@", "shower_enter_into_idle", "Douche homme", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerf2"] = { "mp_safehouseshower@female@", "shower_idle_a", "Douche femme", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerf3"] = { "mp_safehouseshower@female@", "shower_idle_b", "Douche femme 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm"] = { "mp_safehouseshower@male@", "male_shower_idle_a", "Shower Enter Male", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm2"] = { "mp_safehouseshower@male@", "male_shower_idle_b", "Shower Male 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm3"] = { "mp_safehouseshower@male@", "male_shower_idle_c", "Shower Male 3", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm4"] = { "mp_safehouseshower@male@", "male_shower_idle_d", "Shower Male 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["picklock"] = { "missheistfbisetup1", "hassle_intro_loop_f", "Crochetter", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["cleanhands"] = { "missheist_agency3aig_23", "urinal_sink_loop", "Se nettoyer les mains", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["cleanface"] = { "switch@michael@wash_face", "loop_michael", "Se nettoyer le visage", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["buzz"] = { "anim@apt_trans@buzzer", "buzz_reg", "Buzz Door", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    } },
    ["piss"] = { "missbigscore1switch_trevor_piss", "piss_loop", "Pisser Homme", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
     } },
    ["respect"] = { "anim@mp_player_intcelebrationmale@respect", "respect", "Respect Homme", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = false,
     } },
    ["respectf"] = { "anim@mp_player_intcelebrationfemale@respect", "respect", "Respect Femme", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = false,
    } },

    ["bbq"] = { "MaleScenario", "PROP_HUMAN_BBQ", "Cuisiner" },

    ["cheer"] = { "Scenario", "WORLD_HUMAN_CHEERING", "Applaudir" },
    ["filmshocking"] = { "Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Filmer avec son téléphone" },
    ["hangout"] = { "Scenario", "WORLD_HUMAN_HANG_OUT_STREET", "Regarde comme un bouffon" },
    ["impatient"] = { "Scenario", "WORLD_HUMAN_STAND_IMPATIENT", "Impatient" },
    ["janitor"] = { "Scenario", "WORLD_HUMAN_JANITOR", "Tenir un balais" },
    ["jog"] = { "Scenario", "WORLD_HUMAN_JOG_STANDING", "S'échauffer" },
    ["kneel"] = { "Scenario", "CODE_HUMAN_MEDIC_KNEEL", "Inspecter" },
    ["lean"] = { "Scenario", "WORLD_HUMAN_LEANING", "Lean" },
    ["leanbar"] = { "Scenario", "PROP_HUMAN_BUM_SHOPPING_CART", "Accoudé à un bar" },
    ["lookout"] = { "Scenario", "CODE_HUMAN_CROSS_ROAD_WAIT", "Regarder" },
    ["maid"] = { "Scenario", "WORLD_HUMAN_MAID_CLEAN", "Nettoyer" },
    ["medic"] = { "Scenario", "CODE_HUMAN_MEDIC_TEND_TO_DEAD", "Medic" },
    ["musician"] = { "MaleScenario", "WORLD_HUMAN_MUSICIAN", "Gitan" },
    ["notepad2"] = { "Scenario", "CODE_HUMAN_MEDIC_TIME_OF_DEATH", "Bloc-note 2" },
    ["parkingmeter"] = { "Scenario", "PROP_HUMAN_PARKING_METER", "Compte les sous" },
    ["party"] = { "Scenario", "WORLD_HUMAN_PARTYING", "Fêtard" },
    ["texting"] = { "Scenario", "WORLD_HUMAN_STAND_MOBILE", "P'tit texto" },
    ["prosthigh"] = { "Scenario", "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", "Pute" },
    ["prostlow"] = { "Scenario", "WORLD_HUMAN_PROSTITUTE_LOW_CLASS", "Pute 2" },
    ["puddle"] = { "Scenario", "WORLD_HUMAN_BUM_WASH", "Gitan" },
    ["record"] = { "Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Filmer" },

    ["statue"] = { "Scenario", "WORLD_HUMAN_HUMAN_STATUE", "Statue" },
    ["sunbathe3"] = { "Scenario", "WORLD_HUMAN_SUNBATHE", "Bronzay 3" },
    ["sunbatheback"] = { "Scenario", "WORLD_HUMAN_SUNBATHE_BACK", "Bronzay sur le dos" },
    ["weld"] = { "Scenario", "WORLD_HUMAN_WELDING", "Souder" },
    ["windowshop"] = { "Scenario", "WORLD_HUMAN_WINDOW_SHOP_BROWSE", "Regarder" },
    ["yoga"] = { "Scenario", "WORLD_HUMAN_YOGA", "Yoga 2" },

    ["karate"] = { "anim@mp_player_intcelebrationfemale@karate_chops", "karate_chops", "Karaté" },
    ["karate2"] = { "anim@mp_player_intcelebrationmale@karate_chops", "karate_chops", "Karaté 2" },
    ["cutthroat"] = { "anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", "T'es un homme mort" },
    ["cutthroat2"] = { "anim@mp_player_intcelebrationfemale@cut_throat", "cut_throat", "T'es un homme mort 2" },
    ["mindblown"] = { "anim@mp_player_intcelebrationmale@mind_blown", "mind_blown", "Tête qui explose", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 4000
    } },
    ["mindblown2"] = { "anim@mp_player_intcelebrationfemale@mind_blown", "mind_blown", "Tête qui explose 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 4000
    } },
    ["stink"] = { "anim@mp_player_intcelebrationfemale@stinker", "stinker", "Ça pue wesh", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["think4"] = { "anim@amb@casino@hangout@ped_male@stand@02b@idles", "idle_a", "Penser 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },

}

DP.PropEmotes = {
    ["ptrashcana"] = {
        "ptrashcana@animations",
        "ptrashcanaclip",
        "Trash Can Hide A Loop",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanb"] = {
        "ptrashcanb@animations",
        "ptrashcanbclip",
        "Trash Can Hide A Look & Peek",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.06,
                -0.1170,
               -0.090,
                -90,
                0,
                18.00,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanc"] = {
        "ptrashcanc@animations",
        "ptrashcancclip",
        "Trash Can Hide A Peek",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcand"] = {
        "ptrashcand@animations",
        "ptrashcandclip",
        "Trash Can Stuck Struggle",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                -0.02,
                -0.5900,
               0.030,
                -88.000,
                0,
                0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcane"] = {
        "ptrashcane@animations",
        "ptrashcaneclip",
        "Trash Can Stuck Upside Down",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 39317,
            PropPlacement = {
                0,
                -0.100,
               0.0,
                -90.000,
                0,
                -20,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanf"] = {
        "ptrashcanf@animations",
        "ptrashcanfclip",
        "Trash Can Stuck Flip",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 18905,
            PropPlacement = {
                0.15,
                0.100,
                0.050,
                -9.400,
                -160.280,
                -3.40,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcang"] = {
        "ptrashcang@animations",
        "ptrashcangclip",
        "Trash Can Full Stuck Upside Down",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 18905,
            PropPlacement = {
                0.13,
                0.1100,
                0.050,
                -9.51,
                -162.25,
                -3.0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanh"] = {
        "ptrashcanh@animations",
        "ptrashcanhclip",
        "Trash Can Hide B Loop",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                0.100,
                0.725,
                0.000,
                180,
                0,
            },
            EmoteLoop = true

        }
    },
    ["ptrashcani"] = {
        "ptrashcani@animations",
        "ptrashcaniclip",
        "Trash Can Hide B Sneaky",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                0.100,
                0.80,
                0.000,
                180,
                0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanj"] = {
        "ptrashcanj@animations",
        "ptrashcanjclip",
        "Trash Can Hide B Walk",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.005,
                0.125,
                0.780,
                0.000,
                180,
                0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcank"] = {
        "ptrashcank@animations",
        "ptrashcankclip",
        "Trash Can Hide B Panic",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.005,
                0.125,
                0.780,
                0.000,
                180,
                0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanl"] = {
        "ptrashcanl@animations",
        "ptrashcanlclip",
        "Trash Can Hide B Run For Your Lifeee",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 24817,
            PropPlacement = {
                0.580,
                0.1500,
                0,
                10.000,
                -90,
                0,
            },
            EmoteMoving = true,
            EmoteLoop = true

        }
    },
    ["ptrashcanm"] = {
        "ptrashcanm@animations",
        "ptrashcanmclip",
        "Trash Can Dance Happy 1",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 24817,
            PropPlacement = {
                0.70,
                0.175,
                0,
                10.000,
                -90,
                0,
            },
            EmoteLoop = true

        }
    },
    ["ptrashcann"] = {
        "ptrashcann@animations",
        "ptrashcannclip",
        "Trash Can Dance Happy 2",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 24817,
            PropPlacement = {
                0.70,
                0.175,
                0,
                10.000,
                -90,
                0,
            },
            EmoteLoop = true

        }
    },
    ["ptrashcano"] = {
        "ptrashcano@animations",
        "ptrashcanoclip",
        "Trash Can Dance Happy 3",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 24817,
            PropPlacement = {
                0.70,
                0.175,
                0,
                10.000,
                -90,
                0,
            },
            EmoteLoop = true

        }
    },
    ["ptrashcanp"] = {
        "ptrashcanp@animations",
        "ptrashcanpclip",
        "Trash Can Cool Lean",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanq"] = {
        "ptrashcanq@animations",
        "ptrashcanqclip",
        "Trash Can Jump Slow",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanr"] = {
        "ptrashcanr@animations",
        "ptrashcanrclip",
        "Trash Can Jump Fast",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcans"] = {
        "ptrashcans@animations",
        "ptrashcansclip",
        "Trash Can Jump Long",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.08,
                -0.0900,
               -0.10,
                -90,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcant"] = {
        "ptrashcant@animations",
        "ptrashcantclip",
        "Trash Can Turtle Stuck",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.4100,
               -0.340,
                -40,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanu"] = {
        "ptrashcanu@animations",
        "ptrashcanuclip",
        "Trash Can Turtle Enjoy",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.4100,
               -0.340,
                -40,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanv"] = {
        "ptrashcanv@animations",
        "ptrashcanvclip",
        "Trash Can Turtle Walk Struggle",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.470,
               -0.390,
                -40,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanw"] = {
        "ptrashcanw@animations",
        "ptrashcanwclip",
        "Trash Can Turtle Walk Normal",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.400,
               -0.440,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanx"] = {
        "ptrashcanx@animations",
        "ptrashcanxclip",
        "Trash Can Turtle Walk Panic",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.400,
               -0.440,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcany"] = {
        "ptrashcany@animations",
        "ptrashcanyclip",
        "Trash Can Hide C Look Around",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.0600,
               -0.230,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanz"] = {
        "ptrashcanz@animations",
        "ptrashcanzclip",
        "Trash Can Hide C Loop",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.03,
                -0.1300,
                0.02,
                -98,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanza"] = {
        "ptrashcanza@animations",
        "ptrashcanzaclip",
        "Trash Can Spin",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.03,
                -0.1300,
                0.02,
                -98,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzb"] = {
        "ptrashcanzb@animations",
        "ptrashcanzbclip",
        "Trash Can Spin Fast",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.03,
                -0.1300,
                0.02,
                -98,
                0,
                20.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzc"] = {
        "ptrashcanzc@animations",
        "ptrashcanzcclip",
        "Trash Can Roll Slow",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.0600,
               -0.230,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzd"] = {
        "ptrashcanzd@animations",
        "ptrashcanzdclip",
        "Trash Can Roll Fast",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.0600,
               -0.230,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanze"] = {
        "ptrashcanze@animations",
        "ptrashcanzeclip",
        "Trash Can Roll Out Of Control",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                -0.0600,
               -0.230,
                -35,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzf"] = {
        "ptrashcanzf@animations",
        "ptrashcanzfclip",
        "Trash Can Cool Sit 1",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                0.10,
               -0.150,
                164.9,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzg"] = {
        "ptrashcanzg@animations",
        "ptrashcanzgclip",
        "Trash Can Cool Sit 2",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 0,
            PropPlacement = {
                0.0,
                0.10,
               -0.150,
                169.9,
                0,
                0.000,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzh"] = {
        "ptrashcanzh@animations",
        "ptrashcanzhclip",
        "Trash Can Impossible Pose 1",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.120,
                -0.980,
                00,
                -90,
                0,
                -20.000,
            },
            SecondProp = 'prop_recyclebin_03_a',
            SecondPropBone = 64097,
            SecondPropPlacement = {
                0.20,
                -0.20,
                0.000,
              -38.255,
               74.42,
                12.700,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzi"] = {
        "ptrashcanzi@animations",
        "ptrashcanziclip",
        "Trash Can Impossible Pose 2",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 14201,
            PropPlacement = {
                0.10,
                -0.050,
                0.0,
                90,
                0,
                20,
            },
            SecondProp = 'prop_recyclebin_03_a',
            SecondPropBone = 31086,
            SecondPropPlacement = {
                0.140,
                0.10,
                0.000,
                -90,
                0,
                -40,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzj"] = {
        "ptrashcanzj@animations",
        "ptrashcanzjclip",
        "Trash Can Impossible Pose 3",
        AnimationOptions = {
            Prop = "prop_recyclebin_03_a",
            PropBone = 52301,
            PropPlacement = {
                0.110,
                -0.050,
                -0.150,
                90,
                0,
                20.000,
            },
            SecondProp = 'prop_recyclebin_03_a',
            SecondPropBone = 24817,
            SecondPropPlacement = {
                0.09,
                -0.10,
                0.000,
                90,
                0,
                5.0,
            },
            EmoteLoop = true
        }
    },
    ["ptrashcanzk"] = {
        "ptrashcanzk@animations",
        "ptrashcanzkclip",
        "Trash Can Carry 1",
        AnimationOptions = {
            Prop = "prop_bin_07d",
            PropBone = 57005,
            PropPlacement = {
                0.090,
                -0.640,
                -0.37,
                -85.076,
                -0.867,
                -0.037,
            },
			EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["ptrashcanzl"] = {
        "ptrashcanzl@animations",
        "ptrashcanzlclip",
        "Trash Can Carry 2",
        AnimationOptions = {
            Prop = "prop_bin_07d",
            PropBone = 57005,
            PropPlacement = {
                -0.17,
                -0.370,
                -0.370,
                -79.372,
                3.616,
                -19.683,
            },
            SecondProp = 'prop_bin_07d',
            SecondPropBone = 18905,
            SecondPropPlacement = {
                -0.15,
                -0.34,
                0.370,
                -100.62,
                -3.616,
                -19.683,
            },
			EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["ptrashcanzm"] = {
        "ptrashcanzm@animations",
        "ptrashcanzmclip",
        "Trash Can Carry Overhead",
        AnimationOptions = {
            Prop = "prop_bin_07d",
            PropBone = 57005,
            PropPlacement = {
                -0.090,
                0.060,
                -0.31,
                0,
                79.999,
                0,
            },
			EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["ptrashcanzn"] = {
        "ptrashcanzn@animations",
        "ptrashcanznclip",
        "Trash Can I Can't See",
        AnimationOptions = {
            Prop = "prop_bin_07d",
            PropBone = 24818,
            PropPlacement = {
                1.04,
                0.10,
                0.0,
                0,
                -90,
                -10,
            },
			EmoteMoving = true,
            EmoteLoop = true
        }
    },
    ["bball"] = {
        "anim@male_bskball_hold",
        "bskball_hold_clip",
        "Basketball Hold",
        AnimationOptions = {
            Prop = "prop_bskball_01",
            PropBone = 28422,
            PropPlacement = {
                0.0600,
                0.0400,
                -0.1200,
                0.0,
                0.0,
                40.00
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["bball2"] = {
        "anim@male_bskball_photo_pose",
        "photo_pose_clip",
        "Basketball Pose",
        AnimationOptions = {
            Prop = "prop_bskball_01",
            PropBone = 60309,
            PropPlacement = {
                -0.0100,
                0.0200,
                0.1300,
                0.0,
                0.0,
                0.0
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["bball3"] = {
        "anim@male_basketball_03",
        "m_basketball_03_clip",
        "Basketball Hold 2",
        AnimationOptions = {
            Prop = "prop_bskball_01",
            PropBone = 28422,
            PropPlacement = {
                0.0400,
                0.0200,
            -0.1400,
                90.0000,
            -99.9999,
                79.9999
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },

    ["bball4"] = {
        "mx@pose2",
        "mx_clippose2",
        "Basketball Hold 3",
        AnimationOptions = {
            Prop = "prop_bskball_01",
            PropBone = 28422,
            PropPlacement = {
                0.0400,
                0.0200,
            -0.1400,
                90.0000,
            -99.9999,
                79.9999
            },
            EmoteLoop = true
        }
    },

    ["microck"] = {
        "lunyx@mic@p1",
        "mic@p1",
        "Microphone Rock",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckb"] = {
        "lunyx@mic@p2",
        "mic@p2",
        "Microphone Rock 2",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0350,
                0.0180,
                0.0290,
            -180.0000,
            -13.0000,
                0.0000
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckc"] = {
        "lunyx@mic@p3",
        "mic@p3",
        "Microphone Rock 3",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckd"] = {
        "lunyx@mic@p4",
        "mic@p4",
        "Microphone Rock 4",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microcke"] = {
        "lunyx@mic@p5",
        "mic@p5",
        "Microphone Rock 5",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0370,
                0.0130,
                0.0150,
            -173.6259,
            -93.5253,
                4.6450
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckf"] = {
        "lunyx@mic@p6",
        "mic@p6",
        "Microphone Rock 6",
        AnimationOptions = {
            Prop = "v_ilev_fos_mic",
            PropBone = 28422,
            PropPlacement = {
                -0.4410,
                -1.0600,
                -0.4800,
                -57.7266,
                51.8164,
                3.0976
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckg"] = {
        "lunyx@mic@p7",
        "mic@p7",
        "Microphone Rock 7",
        AnimationOptions = {
            Prop = "v_ilev_fos_mic",
            PropBone = 28422,
            PropPlacement = {
                -0.8210,
                -0.0900,
                -1.1900,
                -2.5478,
                36.3684,
                -11.7503
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckh"] = {
        "lunyx@mic@p8",
        "mic@p8",
        "Microphone Rock 8",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0370,
                0.0130,
                0.0150,
            -173.6259,
            -93.5253,
                4.6450
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microcki"] = {
        "lunyx@mic@p9",
        "mic@p9",
        "Microphone Rock 9",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckj"] = {
        "lunyx@mic@p10",
        "mic@p10",
        "Microphone Rock 10",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },

    ["megaphone"] = {
        "molly@megaphone",
        "megaphone_clip",
        "Megaphone",
        AnimationOptions = {
            Prop = "prop_megaphone_01",
            PropBone = 28422,
            PropPlacement = {
                0.0500,
                0.0540,
                -0.0060,
                -71.8855,
                -13.0889,
                -16.0242
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["megaphone2"] = {
        "molly@megaphone2",
        "megaphone_clip",
        "Megaphone 2",
        AnimationOptions = {
            Prop = "prop_megaphone_01",
            PropBone = 28422,
            PropPlacement = {
                0.0500,
                0.0540,
                -0.0060,
                -71.8855,
                -13.0889,
                -16.0242
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },

    ["umbrella"] = { "amb@world_human_drinking@coffee@male@base", "base", "Umbrella", AnimationOptions = {
        Prop = "p_amb_brolly_01",
        PropBone = 57005,
        PropPlacement = { 0.15, 0.005, 0.0, 87.0, -20.0, 180.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ['umbrella2'] = { 'rcmnigel1d', 'base_club_shoulder', 'Umbrella 2', AnimationOptions = {
        Prop = 'p_amb_brolly_01',
        PropBone = 28422,
        PropPlacement = { 0.0700, 0.0100, 0.1100, 2.3402393, -150.9605721, 57.3374916 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["notepad"] = { "missheistdockssetup1clipboard@base", "base", "Notepad", AnimationOptions = {
        Prop = 'prop_notepad_01',
        PropBone = 18905,
        PropPlacement = { 0.1, 0.02, 0.05, 10.0, 0.0, 0.0 },
        SecondProp = 'prop_pencil_01',
        SecondPropBone = 58866,
        SecondPropPlacement = { 0.11, -0.02, 0.001, -120.0, 0.0, 0.0 },

        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["box"] = { "anim@heists@box_carry@", "idle", "Box", AnimationOptions = {
        Prop = "hei_prop_heist_box",
        PropBone = 60309,
        PropPlacement = { 0.025, 0.08, 0.255, -145.0, 290.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["boxfruit"] = { "anim@heists@box_carry@", "idle", "Box fruit", AnimationOptions = {
        Prop = "prop_fruit_basket",
        PropBone = 60309,
        PropPlacement = { 0.025, 0.08, 0.255, -45.0, 290.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["boxsteel"] = { "anim@heists@box_carry@", "idle", "Box metal", AnimationOptions = {
        Prop = "bkr_prop_coke_metalbowl_02",
        PropBone = 60309,
        PropPlacement = { 0.125, -0.21, 0.255, -45.0, 290.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["rose"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Rose", AnimationOptions = {
        Prop = "prop_single_rose",
        PropBone = 18905,
        PropPlacement = { 0.13, 0.15, 0.0, -100.0, 0.0, -20.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["smoke2"] = { "amb@world_human_aa_smoke@male@idle_a", "idle_c", "Smoke 2", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
        hide = true,
    } },
    ["smoke3"] = { "amb@world_human_aa_smoke@male@idle_a", "idle_b", "Smoke 3", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
        hide = true,
    } },
    ["smoke4"] = { "amb@world_human_smoking@female@idle_a", "idle_b", "Smoke 4", AnimationOptions = {
        Prop = 'prop_cs_ciggy_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
        hide = true,
    } },
    ["bong"] = { "anim@safehouse@bong", "bong_stage3", "Bong", AnimationOptions = {
        Prop = 'hei_heist_sh_bong_01',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.25, 0.0, 95.0, 190.0, 180.0 },
    } },
    ["fishing1"] = { "amb@world_human_stand_fishing@idle_a", "idle_a", "Fishing1", AnimationOptions = {
        Prop = 'prop_fishing_rod_01',
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["fishing2"] = { "amb@world_human_stand_fishing@idle_a", "idle_b", "Fishing2", AnimationOptions = {
        Prop = 'prop_fishing_rod_01',
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["fishing3"] = { "amb@world_human_stand_fishing@idle_a", "idle_c", "Fishing3", AnimationOptions = {
        Prop = 'prop_fishing_rod_01',
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["suitcase"] = { "move_weapon@jerrycan@generic", "idle", "Suitcase", AnimationOptions = {
        Prop = "prop_ld_suitcase_01",
        PropBone = 57005,
        PropPlacement = { 0.35, 0.0, 0.0, 0.0, 266.0, 90.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["suitcase2"] = { "move_weapon@jerrycan@generic", "idle", "Suitcase 2", AnimationOptions = {
        Prop = "prop_security_case_01",
        PropBone = 57005,
        PropPlacement = { 0.13, 0.0, -0.01, 0.0, 280.0, 90.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["panier"] = { "move_weapon@jerrycan@generic", "idle", "Panier fruits", AnimationOptions = {
        Prop = "prop_fruit_basket",
        PropBone = 57005,
        PropPlacement = { 0.35, 0.0, 0.10, -5.0, 280.0, 90.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["boombox"] = { "move_weapon@jerrycan@generic", "idle", "Boombox", AnimationOptions = {
        Prop = "prop_boombox_01",
        PropBone = 57005,
        PropPlacement = { 0.27, 0.0, 0.0, 0.0, 263.0, 58.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["toolbox"] = { "move_weapon@jerrycan@generic", "idle", "Toolbox", AnimationOptions = {
        Prop = "prop_tool_box_04",
        PropBone = 28422,
        PropPlacement = { 0.3960, 0.0410, -0.0030, -90.00, 0.0, 90.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["toolbox2"] = { "move_weapon@jerrycan@generic", "idle", "Toolbox 2", AnimationOptions = {
        Prop = "imp_prop_tool_box_01a",
        PropBone = 28422,
        PropPlacement = { 0.3700, 0.0200, 0.0, 90.00, 0.0, -90.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["gbag"] = { "missfbi4prepp1", "_idle_garbage_man", "Garbage Bag", AnimationOptions = {
        Prop = "prop_cs_street_binbag_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0400, -0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beerbox"] = { "move_weapon@jerrycan@generic", "idle", "Beer Box 1", AnimationOptions = {
        Prop = "v_ret_ml_beerdus",
        PropBone = 57005,
        PropPlacement = { 0.22, 0.0, 0.0, 0.0, 266.0, 48.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beerbox2"] = { "move_weapon@jerrycan@generic", "idle", "Beer Box 2", AnimationOptions = {
        Prop = "v_ret_ml_beeram",
        PropBone = 57005,
        PropPlacement = { 0.22, 0.0, 0.0, 0.0, 266.0, 48.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beerbox3"] = { "move_weapon@jerrycan@generic", "idle", "Beer Box 3", AnimationOptions = {
        Prop = "v_ret_ml_beerpride",
        PropBone = 57005,
        PropPlacement = { 0.22, 0.0, 0.0, 0.0, 266.0, 48.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beerbox4"] = { "move_weapon@jerrycan@generic", "idle", "Beer Box 4", AnimationOptions = {
        Prop = "v_ret_ml_beerbar",
        PropBone = 57005,
        PropPlacement = { 0.22, 0.0, 0.0, 0.0, 266.0, 60.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["mugshot"] = { "mp_character_creation@customise@male_a", "loop", "Mugshot", AnimationOptions = {
        Prop = 'prop_police_id_board',
        PropBone = 58868,
        PropPlacement = { 0.12, 0.24, 0.0, 5.0, 0.0, 70.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["coffee"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee", AnimationOptions = {
        Prop = 'p_amb_coffeecup_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["whiskey"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions = {
        Prop = 'prop_drink_whisky',
        PropBone = 28422,
        PropPlacement = { 0.01, -0.01, -0.06, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["whiskeyb"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_a", "Whiskey Bottle", AnimationOptions = {
        Prop = 'ba_prop_battle_whiskey_bottle_2_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.05, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beer"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_c", "Beer", AnimationOptions = {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.06, 0.0, 15.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beer2"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_a", "Beer 2", AnimationOptions = {
        Prop = 'ba_prop_battle_whiskey_bottle_2_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.05, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beer3"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_c", "Beer 3", AnimationOptions = {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.06, 0.0, 15.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["beer4"] = { "amb@world_human_drinking@beer@male@idle_a", "idle_a", "Beer 4", AnimationOptions = {
        Prop = 'ba_prop_battle_whiskey_bottle_2_s',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.05, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["beerf"] = { "amb@world_human_drinking@beer@female@idle_a", "idle_a", "Beer Female", AnimationOptions = {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, -0.0, 0.05, 15.0, 15.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beerf2"] = { "amb@world_human_drinking@beer@female@idle_a", "idle_e", "Beer Female 2", AnimationOptions = {
        Prop = 'prop_wine_rose',
        PropBone = 28422,
        PropPlacement = { -0.0, 0.04, -0.19, 10.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,

    } },
    ["beerf3"] = { "amb@world_human_drinking@beer@female@idle_a", "idle_a", "Beer Female 3", AnimationOptions = {
        Prop = 'prop_amb_beer_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, -0.0, 0.05, 15.0, 15.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["beerf4"] = { "amb@world_human_drinking@beer@female@idle_a", "idle_e", "Beer Female 4", AnimationOptions = {
        Prop = 'prop_wine_rose',
        PropBone = 28422,
        PropPlacement = { -0.0, 0.04, -0.19, 10.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,

    } },
    ["cup"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Cup", AnimationOptions = {
        Prop = 'prop_plastic_cup_02',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["donut"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions = {
        Prop = 'prop_amb_donut',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
        EmoteMoving = true,
    } },
    ["burger"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Burger", AnimationOptions = {
        Prop = 'prop_cs_burger_01',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
        EmoteMoving = true,
    } },
    ["sandwich"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions = {
        Prop = 'prop_sandwich_01',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
        EmoteMoving = true,
    } },
    ["tacos"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Tacos", AnimationOptions = {
        Prop = 'prop_taco_02',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
        EmoteMoving = true,
    } },
    ["pizza"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Pizza", AnimationOptions = {
        Prop = 'knjgh_pizzaslice4',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, 60.0, 15.0, 90.0 },
        EmoteMoving = true,
    } },
    ["acanthe"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Acanthe", AnimationOptions = {
        Prop = 'prop_weed_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["orange"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Orange", AnimationOptions = {
        Prop = 'prop_golf_ball_p3',
        PropBone = 18905,
        PropPlacement = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },
        EmoteMoving = true,
    } },
    ["soda"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Soda", AnimationOptions = {
        Prop = 'prop_ecola_can',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tequilasunrise"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tequila Sunrise", AnimationOptions = {
        Prop = 'brum_tequilasunrise',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["sexonthebeach"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Sex on the beach", AnimationOptions = {
        Prop = 'brum_sexonthebeach',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["vodkacranberry"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vodka Cranberry", AnimationOptions = {
        Prop = 'cocktail_red4',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["longisland"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Long Island iced tea", AnimationOptions = {
        Prop = 'cocktail_orange6',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["pinacolada"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Piña colada", AnimationOptions = {
        Prop = 'brum_pina',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["maitai"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Mai tai", AnimationOptions = {
        Prop = 'brum_maitai',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["cosmopolitan"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Cosmopolitan", AnimationOptions = {
        Prop = 'brum_cosmopolitan',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["cocktailunicorn"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Cocktail Unicorn", AnimationOptions = {
        Prop = 'cocktail_purple7',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["martini"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Martini", AnimationOptions = {
        Prop = 'brum_martini',
        PropBone = 18905,
        PropPlacement = { 0.15, 0.05, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["strawberrymargaritas"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Strawberry Margaritas", AnimationOptions = {
        Prop = 'brum_strawberrymargarita',
        PropBone = 18905,
        PropPlacement = { 0.15, 0.05, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["icetea"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Ice-tea (de wish)", AnimationOptions = {
        Prop = 'prop_orang_can_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["water"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Water", AnimationOptions = {
        Prop = 'ba_prop_club_water_bottle',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.090, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["energydrink"] = { "amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Energy Drink", AnimationOptions = {
        Prop = 'prop_energy_drink',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.090, 0.0, 0.0, 130.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["egobar"] = { "mp_player_inteat@burger", "mp_player_int_eat_burger", "Ego Bar", AnimationOptions = {
        Prop = 'prop_choc_ego',
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteMoving = true,
    } },
    ["candy"] = { "mp_player_inteat@pnq", "loop", "Candy", AnimationOptions = {
        Prop = 'prop_candy_pqs',
        PropBone = 60309,
        PropPlacement = { -0.0300, 0.0180, 0.0, 180.0, 180.0, -88.099 },
        EmoteMoving = true,
    } },
    ["wine"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vin rouge", AnimationOptions = {
        Prop = 'prop_drink_redwine',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["wine2"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vin blanc", AnimationOptions = {
        Prop = 'prop_drink_whtwine',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["wine3"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Vin rosé", AnimationOptions = {
        Prop = 'p_wine_glass_s',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },

    ["flute"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Flute", AnimationOptions = {
        Prop = 'prop_champ_flute',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["champagne"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Champagne", AnimationOptions = {
        Prop = 'prop_drink_champ',
        PropBone = 18905,
        PropPlacement = { 0.10, -0.03, 0.03, -100.0, 0.0, -10.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["cigar"] = { "amb@world_human_smoking@male@male_a@enter", "enter", "Cigar", AnimationOptions = {
        Prop = 'prop_cigar_02',
        PropBone = 47419,
        PropPlacement = { 0.010, 0.0, 0.0, 50.0, 0.0, -80.0 },
        EmoteMoving = true,
        EmoteDuration = 2600
    } },
    ["cigar2"] = { "amb@world_human_smoking@male@male_a@enter", "enter", "Cigar 2", AnimationOptions = {
        Prop = 'prop_cigar_01',
        PropBone = 47419,
        PropPlacement = { 0.010, 0.0, 0.0, 50.0, 0.0, -80.0 },
        EmoteMoving = true,
        EmoteDuration = 2600
    } },
    ["guitar"] = { "amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar", AnimationOptions = {
        Prop = 'prop_acc_guitar_01',
        PropBone = 24818,
        PropPlacement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["guitar2"] = { "switch@trevor@guitar_beatdown", "001370_02_trvs_8_guitar_beatdown_idle_busker", "Guitar 2", AnimationOptions = {
        Prop = 'prop_acc_guitar_01',
        PropBone = 24818,
        PropPlacement = { -0.05, 0.31, 0.1, 0.0, 20.0, 150.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["guitarelectric"] = { "amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar Electric", AnimationOptions = {
        Prop = 'prop_el_guitar_01',
        PropBone = 24818,
        PropPlacement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["guitarelectric2"] = { "amb@world_human_musician@guitar@male@idle_a", "idle_b", "Guitar Electric 2", AnimationOptions = {
        Prop = 'prop_el_guitar_03',
        PropBone = 24818,
        PropPlacement = { -0.1, 0.31, 0.1, 0.0, 20.0, 150.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["book"] = { "cellphone@", "cellphone_text_read_base", "Book", AnimationOptions = {
        Prop = 'prop_novel_01',
        PropBone = 6286,
        PropPlacement = { 0.15, 0.03, -0.065, 0.0, 180.0, 90.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["bouquet"] = { "impexp_int-0", "mp_m_waremech_01_dual-0", "Bouquet", AnimationOptions = {
        Prop = 'prop_snow_flower_02',
        PropBone = 24817,
        PropPlacement = { -0.29, 0.40, -0.02, -90.0, -90.0, 0.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["teddy"] = { "impexp_int-0", "mp_m_waremech_01_dual-0", "Teddy", AnimationOptions = {
        Prop = 'v_ilev_mr_rasberryclean',
        PropBone = 24817,
        PropPlacement = { -0.20, 0.46, -0.016, -180.0, -90.0, 0.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["backpack"] = { "move_p_m_zero_rucksack", "nill", "Backpack", AnimationOptions = {
        Prop = 'p_michael_backpack_s',
        PropBone = 24818,
        PropPlacement = { 0.07, -0.11, -0.05, 0.0, 90.0, 175.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["clipboard"] = { "missfam4", "base", "Clipboard", AnimationOptions = {
        Prop = 'p_amb_clipboard_01',
        PropBone = 36029,
        PropPlacement = { 0.16, 0.08, 0.1, -130.0, -50.0, 0.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["map"] = { "amb@world_human_tourist_map@male@base", "base", "Map", AnimationOptions = {
        Prop = 'prop_tourist_map_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteMoving = true,
        EmoteLoop = true
    } },
    ["map2"] = { "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "Map 2", AnimationOptions = {
        Prop = "prop_tourist_map_01",
        PropBone = 28422,
        PropPlacement = { -0.05, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beg"] = { "amb@world_human_bum_freeway@male@base", "base", "Beg", AnimationOptions = {
        Prop = 'prop_beggers_sign_03',
        PropBone = 58868,
        PropPlacement = { 0.19, 0.18, 0.0, 5.0, 0.0, 40.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["makeitrain"] = { "anim@mp_player_intupperraining_cash", "idle_a", "Make It Rain", AnimationOptions = {
        Prop = 'prop_anim_cash_pile_01',
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 180.0, 0.0, 70.0 },
        EmoteMoving = true,
        EmoteLoop = true,
        PtfxAsset = "scr_xs_celebration",
        PtfxName = "scr_xs_money_rain",
        PtfxPlacement = { 0.0, 0.0, -0.09, -80.0, 0.0, 0.0, 1.0 },
        PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['makeitrain'],
        PtfxWait = 500,
    } },
    ["camera"] = { "amb@world_human_paparazzi@male@base", "base", "Camera", AnimationOptions = {
        Prop = 'prop_pap_camera_01',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
        PtfxAsset = "scr_bike_business",
        PtfxName = "scr_bike_cfid_camera_flash",
        PtfxPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 },
        PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
        PtfxWait = 200,
    } },
    ["champagnespray"] = { "anim@mp_player_intupperspray_champagne", "idle_a", "Champagne Spray", AnimationOptions = {
        Prop = 'ba_prop_battle_champ_open',
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteMoving = true,
        EmoteLoop = true,
        PtfxAsset = "scr_ba_club",
        PtfxName = "scr_ba_club_champagne_spray",
        PtfxPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['spraychamp'],
        PtfxWait = 500,
    } },
    ["joint"] = { "amb@world_human_smoking@male@male_a@enter", "enter", "Joint", AnimationOptions = {
        Prop = 'p_cs_joint_02',
        PropBone = 47419,
        PropPlacement = { 0.015, -0.009, 0.003, 55.0, 0.0, 110.0 },
        EmoteMoving = true,
        EmoteDuration = 2600
    } },
    ["cig"] = { "amb@world_human_smoking@male@male_a@enter", "enter", "Cig", AnimationOptions = {
        Prop = 'prop_amb_ciggy_01',
        PropBone = 47419,
        PropPlacement = { 0.015, -0.009, 0.003, 55.0, 0.0, 110.0 },
        EmoteMoving = true,
        EmoteDuration = 2600
    } },
    ["brief"] = { "move_weapon@jerrycan@generic", "idle", "Briefcase", AnimationOptions = {
        Prop = "prop_ld_case_01",
        PropBone = 57005,
        PropPlacement = { 0.12, 0.0, 0.0, 0.0, 255.0, 80.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tablet"] = { "amb@world_human_tourist_map@male@base", "base", "Tablet", AnimationOptions = {
        Prop = "prop_cs_tablet",
        PropBone = 28422,
        PropPlacement = { 0.0, -0.03, 0.0, 20.0, -90.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tablet2"] = { "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "Tablet 2", AnimationOptions = {
        Prop = "prop_cs_tablet",
        PropBone = 28422,
        PropPlacement = { -0.05, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["phonecall"] = { "cellphone@", "cellphone_call_listen_base", "Phone Call", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["phonecall2"] = { "random@kidnap_girl", "ig_1_girl_on_phone_loop", "Phone Call 2", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["phone"] = { "cellphone@", "cellphone_text_read_base", "Phone", AnimationOptions = {
        Prop = "prop_phone_cs_frank",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wt"] = { "cellphone@", "cellphone_text_read_base", "Walkie Talkie", AnimationOptions = {
        Prop = "prop_cs_hand_radio",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
        ["wt3"] = {
        "anim@radio_left",
        "radio_left_clip",
        "Walkie Talkie 3 Left",
        EmoteMoving = true,
        AnimationOptions = {
            Prop = "prop_cs_hand_radio",
            PropBone = 60309,
            PropPlacement = {
                0.0750,
                0.0470,
                0.0110,
              -97.9442,
                3.7058,
              -23.2367
				},
            onFootFlag = 51,
        }
    },
    ["wt4"] = {
        "anim@male@holding_radio",
        "holding_radio_clip",
        "Walkie Talkie 4",
        EmoteMoving = true,
        AnimationOptions = {
            Prop = "prop_cs_hand_radio",
            PropBone = 28422,
            PropPlacement = {
                0.0750,
                0.0230,
               -0.0230,
              -90.0000,
                0.0000,
              -59.9999
				},
            onFootFlag = 51,
        }
    },
    ["wt5"] = {
        "missfbi3_steve_phone",
        "steve_phone_idle_a",
        "Walkie Talkie 5",
        EmoteMoving = true,
        AnimationOptions = {
            Prop = "prop_cs_hand_radio",
            PropBone = 18905,
            PropPlacement = {
                0.1300,
                0.0500,
                0.0100,
             -113.0000,
                0.0000,
              -60.0000
				},
            onFootFlag = 51,
        }
    },
    ["clean"] = { "timetable@floyd@clean_kitchen@base", "base", "Clean", AnimationOptions = {
        Prop = "prop_sponge_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["clean2"] = { "amb@world_human_maid_clean@", "base", "Clean 2", AnimationOptions = {
        Prop = "prop_sponge_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["protest"] = { "rcmnigel1d", "base_club_shoulder", "protest", AnimationOptions = {
        Prop = "prop_cs_protest_sign_01",
        PropBone = 57005,
        PropPlacement = { 0.1820, 0.2400, 0.0600, -69.3774235, 5.9142048, -13.9572354 },

        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["binoculars"] = { "amb@world_human_binoculars@male@idle_b", "idle_f", "Binoculars", AnimationOptions = {
        Prop = "prop_binoc_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },

        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["binoculars2"] = { "amb@world_human_binoculars@male@idle_a", "idle_c", "Binoculars 2", AnimationOptions = {
        Prop = "prop_binoc_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tennisplay"] = { "move_weapon@jerrycan@generic", "idle", "Tennis Play", AnimationOptions = {
        Prop = "prop_tennis_bag_01",
        PropBone = 57005,
        PropPlacement = { 0.27, 0.0, 0.0, 91.0, 0.0, -82.9999951 },
        SecondProp = 'prop_tennis_rack_01',
        SecondPropBone = 60309,
        SecondPropPlacement = { 0.0800, 0.0300, 0.0, -130.2907295, 3.8782324, 6.588224 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["weights"] = { "amb@world_human_muscle_free_weights@male@barbell@base", "base", "Weights", AnimationOptions = {
        Prop = "prop_curl_bar_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["weights2"] = { "amb@world_human_muscle_free_weights@male@barbell@idle_a", "idle_d", "Weights 2", AnimationOptions = {
        Prop = "prop_curl_bar_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["fuel"] = { "weapons@misc@jerrycan@", "fire", "fuel", AnimationOptions = {
        Prop = "w_am_jerrycan",
        PropBone = 57005,
        PropPlacement = { 0.1800, 0.1300, -0.2400, -165.8693883, -11.2122753, -32.9453021 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["fuel2"] = { "weapons@misc@jerrycan@franklin", "idle", "Fuel 2 (Carry)", AnimationOptions = {
        Prop = "w_am_jerrycan",
        PropBone = 28422,
        PropPlacement = { 0.26, 0.050, 0.0300, 80.00, 180.000, 79.99 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["hitchhike"] = { "random@hitch_lift", "idle_f", "Hitchhike", AnimationOptions = {
        Prop = "w_am_jerrycan",
        PropBone = 18905,
        PropPlacement = { 0.32, -0.0100, 0.0, -162.423, 74.83, 58.79 },
        SecondProp = 'prop_michael_backpack',
        SecondPropBone = 40269,
        SecondPropPlacement = { -0.07, -0.21, -0.11, -144.93, 117.358, -6.16 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign"] = { "rcmnigel1d", "base_club_shoulder", "Steal Stop Sign ", AnimationOptions = {
        Prop = "prop_sign_road_01a",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign2"] = { "rcmnigel1d", "base_club_shoulder", "Steal Yield Sign ", AnimationOptions = {
        Prop = "prop_sign_road_02a",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign3"] = { "rcmnigel1d", "base_club_shoulder", "Steal Hospital Sign ", AnimationOptions = {
        Prop = "prop_sign_road_03d",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign4"] = { "rcmnigel1d", "base_club_shoulder", "Steal Parking Sign ", AnimationOptions = {
        Prop = "prop_sign_road_04a",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign5"] = { "rcmnigel1d", "base_club_shoulder", "Steal Parking Sign 2 ", AnimationOptions = {
        Prop = "prop_sign_road_04w",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign6"] = { "rcmnigel1d", "base_club_shoulder", "Steal Pedestrian Sign ", AnimationOptions = {
        Prop = "prop_sign_road_05a",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign7"] = { "rcmnigel1d", "base_club_shoulder", "Steal Street Sign ", AnimationOptions = {
        Prop = "prop_sign_road_05t",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign8"] = { "rcmnigel1d", "base_club_shoulder", "Steal Freeway Sign ", AnimationOptions = {
        Prop = "prop_sign_freewayentrance",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ssign9"] = { "rcmnigel1d", "base_club_shoulder", "Steal Stop Sign Snow ", AnimationOptions = {
        Prop = "prop_snow_sign_road_01a",
        PropBone = 60309,
        PropPlacement = { -0.1390, -0.9870, 0.4300, -67.3315314, 145.0627869, -4.4318885 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["conehead"] = { "move_m@drunk@verydrunk_idles@", "fidget_07", "Cone Head ", AnimationOptions = {
        Prop = "prop_roadcone02b",
        PropBone = 31086,
        PropPlacement = { 0.0500, 0.0200, -0.000, 30.0000004, 90.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtraya"] = { "anim@heists@box_carry@", "idle", "Food Tray", AnimationOptions = {
        Prop = "prop_food_bs_tray_03",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.0400, -0.1390, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayb"] = { "anim@heists@box_carry@", "idle", "Food Tray B", AnimationOptions = {
        Prop = "prop_food_bs_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.0400, -0.1390, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayc"] = { "anim@heists@box_carry@", "idle", "Food Tray C", AnimationOptions = {
        Prop = "prop_food_cb_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.0400, -0.1390, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayd"] = { "anim@heists@box_carry@", "idle", "Food Tray D", AnimationOptions = {
        Prop = "prop_food_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.0400, -0.1390, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtraye"] = { "anim@heists@box_carry@", "idle", "Food Tray E", AnimationOptions = {
        Prop = "prop_food_tray_03",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.0400, -0.1390, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayf"] = { "anim@heists@box_carry@", "idle", "Food Tray F", AnimationOptions = {
        Prop = "prop_food_bs_tray_02",
        PropBone = 57005,
        PropPlacement = { 0.2500, 0.1000, 0.0700, -110.5483936, 73.3529273, -16.338362 },
        SecondProp = 'prop_food_bs_tray_03',
        SecondPropBone = 18905,
        SecondPropPlacement = { 0.2200, 0.1300, -0.1000, -127.7725487, 110.2074758, -3.5886263 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayg"] = { "anim@heists@box_carry@", "idle", "Food Tray G", AnimationOptions = {
        Prop = "prop_food_cb_tray_02",
        PropBone = 57005,
        PropPlacement = { 0.2500, 0.1000, 0.0700, -110.5483936, 73.3529273, -16.338362 },
        SecondProp = 'prop_food_cb_tray_02',
        SecondPropBone = 18905,
        SecondPropPlacement = { 0.2200, 0.1300, -0.1000, -127.7725487, 110.2074758, -3.5886263 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayh"] = { "anim@heists@box_carry@", "idle", "Food Tray H", AnimationOptions = {
        Prop = "prop_food_tray_02",
        PropBone = 57005,
        PropPlacement = { 0.2500, 0.1000, 0.0700, -110.5483936, 73.3529273, -16.338362 },
        SecondProp = 'prop_food_tray_03',
        SecondPropBone = 18905,
        SecondPropPlacement = { 0.2200, 0.1300, -0.1000, -127.7725487, 110.2074758, -3.5886263 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayi"] = { "anim@heists@box_carry@", "idle", "Food Tray I", AnimationOptions = {
        Prop = "prop_food_tray_02",
        PropBone = 57005,
        PropPlacement = { 0.2500, 0.1000, 0.0700, -110.5483936, 73.3529273, -16.338362 },
        SecondProp = 'prop_food_tray_02',
        SecondPropBone = 18905,
        SecondPropPlacement = { 0.2200, 0.1300, -0.1000, -127.7725487, 110.2074758, -3.5886263 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayj"] = { "anim@move_f@waitress", "idle", "Food Tray J", AnimationOptions = {
        Prop = "prop_food_bs_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayk"] = { "anim@move_f@waitress", "idle", "Food Tray K", AnimationOptions = {
        Prop = "prop_food_bs_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayl"] = { "anim@move_f@waitress", "idle", "Food Tray L", AnimationOptions = {
        Prop = "prop_food_bs_tray_03",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtraym"] = { "anim@move_f@waitress", "idle", "Food Tray M", AnimationOptions = {
        Prop = "prop_food_cb_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayn"] = { "anim@move_f@waitress", "idle", "Food Tray N", AnimationOptions = {
        Prop = "prop_food_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foodtrayo"] = { "anim@move_f@waitress", "idle", "Food Tray O", AnimationOptions = {
        Prop = "prop_food_tray_02",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["carrypizza"] = { "anim@heists@box_carry@", "idle", "Carry Pizza Box", AnimationOptions = {
        Prop = "prop_pizza_box_02",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.1000, -0.1590, 20.0000007, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["carryfoodbag"] = { "move_weapon@jerrycan@generic", "idle", "Carry Food Bag", AnimationOptions = {
        Prop = "prop_food_bs_bag_01",
        PropBone = 57005,
        PropPlacement = { 0.3300, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["carryfoodbag2"] = { "move_weapon@jerrycan@generic", "idle", "Carry Food Bag 2", AnimationOptions = {
        Prop = "prop_food_cb_bag_01",
        PropBone = 57005,
        PropPlacement = { 0.3800, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["carryfoodbag3"] = { "move_weapon@jerrycan@generic", "idle", "Carry Food Bag 3", AnimationOptions = {
        Prop = "prop_food_bag1",
        PropBone = 57005,
        PropPlacement = { 0.3800, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag"] = { "anim@scripted@freemode@postertag@graffiti_spray@male@", "shake_can_male", "Tagging Shake Can Male", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag2"] = { "anim@scripted@freemode@postertag@graffiti_spray@heeled@", "shake_can_female", "Tagging Shake Can Female", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag3"] = { "anim@scripted@freemode@postertag@graffiti_spray@male@", "spray_can_var_01_male", "Tagging Male 1", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag4"] = { "anim@scripted@freemode@postertag@graffiti_spray@male@", "spray_can_var_02_male", "Tagging Male 2", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag5"] = { "anim@scripted@freemode@postertag@graffiti_spray@heeled@", "spray_can_var_01_female", "Tagging Female 1", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["tag6"] = { "anim@scripted@freemode@postertag@graffiti_spray@heeled@", "spray_can_var_02_female", "Tagging Female 2", AnimationOptions = {
        Prop = "prop_cs_spray_can",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["beans"] = { "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "Beans", AnimationOptions = {
        Prop = "h4_prop_h4_caviar_tin_01a",
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0300, 0.0100, 0.0, 0.0, 0.0 },
        SecondProp = 'h4_prop_h4_caviar_spoon_01a',
        SecondPropBone = 28422,
        SecondPropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["seringue"] = { "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "Seringue création", AnimationOptions = {
        Prop = "prop_drug_erlenmeyer",
        PropBone = 60309,
        PropPlacement = { -0.0400, 0.0000, -0.0500, 0.0, 0.0, 0.0 },
        SecondProp = 'p_syringe_01_s',
        SecondPropBone = 28422,
        SecondPropPlacement = { -0.0200, 0.0600, -0.0, 0.0, 0.0500, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["fruit"] = { "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "Fruit création", AnimationOptions = {
        Prop = "apa_mp_h_acc_fruitbowl_02",
        PropBone = 60309,
        PropPlacement = { -0.0400, 0.0000, -0.0500, 0.0, 0.0, 0.0 },
        SecondProp = 'prop_pineapple',
        SecondPropBone = 28422,
        SecondPropPlacement = { -0.0200, 0.0600, -0.0, 0.0, 0.0500, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["weedfarm"] = { "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "Weed création", AnimationOptions = {
        Prop = "bkr_prop_weed_bud_02a",
        PropBone = 60309,
        PropPlacement = { -0.0400, 0.0000, -0.0500, 0.0, 0.0, 0.0 },
        SecondProp = 'bkr_prop_weed_bag_01a',
        SecondPropBone = 28422,
        SecondPropPlacement = { -0.0200, 0.0600, -0.0, 0.0, 0.0500, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["methfarm"] = { "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "Meth création", AnimationOptions = {
        Prop = "bkr_prop_meth_smashedtray_01",
        PropBone = 60309,
        PropPlacement = { -0.0400, 0.2500, -0.0500, 0.0, 0.0, 0.0 },
        SecondProp = 'bkr_prop_meth_scoop_01a',
        SecondPropBone = 28422,
        SecondPropPlacement = { -0.0200, 0.0600, -0.0, 0.0, 0.0500, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["newscam"] = { "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", "News Camera", AnimationOptions = {
        Prop = "prop_v_cam_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0300, 0.0100, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["newsmic"] = { "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "News Microphone", AnimationOptions = {
        Prop = "p_ing_microphonel_01",
        PropBone = 4154,
        PropPlacement = { -0.00, -0.0200, 0.1100, 0.00, 0.0, 60.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["newsbmic"] = { "missfra1", "mcs2_crew_idle_m_boom", "News Boom Microphone", AnimationOptions = {
        Prop = "prop_v_bmike_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leafblower"] = { "amb@world_human_gardener_leaf_blower@base", "base", "Leaf Blower", AnimationOptions = {
        Prop = "prop_leaf_blower_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["bbqf"] = { "amb@prop_human_bbq@male@idle_a", "idle_b", "BBQ (Female)", AnimationOptions = {
        Prop = "prop_fish_slice_01",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pump"] = { "missfbi4prepp1", "idle", "Pumpkin", AnimationOptions = {
        Prop = "prop_veg_crop_03_pump",
        PropBone = 28422,
        PropPlacement = { 0.0200, 0.0600, -0.1200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pump2"] = { "anim@heists@box_carry@", "idle", "Pumpkin 2", AnimationOptions = {
        Prop = "prop_veg_crop_03_pump",
        PropBone = 28422,
        PropPlacement = { 0.0100, -0.16000, -0.2100, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["mop"] = { "missfbi4prepp1", "idle", "Mop", AnimationOptions = {
        Prop = "prop_cs_mop_s",
        PropBone = 28422,
        PropPlacement = { -0.0200, -0.0600, -0.2000, -13.377, 10.3568, 17.9681 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["mop2"] = { "move_mop", "idle_scrub_small_player", "Mop 2", AnimationOptions = {
        Prop = "prop_cs_mop_s",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.1200, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["rake"] = { "anim@amb@drug_field_workers@rake@male_a@base", "base", "Rake", AnimationOptions = {
        Prop = "prop_tool_rake",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["rake2"] = { "anim@amb@drug_field_workers@rake@male_a@idles", "idle_b", "Rake 2", AnimationOptions = {
        Prop = "prop_tool_rake",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["rake3"] = { "anim@amb@drug_field_workers@rake@male_b@base", "base", "Rake 3", AnimationOptions = {
        Prop = "prop_tool_rake",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["rake4"] = { "anim@amb@drug_field_workers@rake@male_b@idles", "idle_d", "Rake 4", AnimationOptions = {
        Prop = "prop_tool_rake",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["broom"] = { "anim@amb@drug_field_workers@rake@male_a@base", "base", "Broom", AnimationOptions = {
        Prop = "prop_tool_broom",
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.0400, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["broom2"] = { "anim@amb@drug_field_workers@rake@male_a@idles", "idle_b", "Broom 2", AnimationOptions = {
        Prop = "prop_tool_broom",
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.0400, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["broom3"] = { "anim@amb@drug_field_workers@rake@male_b@base", "base", "Broom 3", AnimationOptions = {
        Prop = "prop_tool_broom",
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.0400, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["broom4"] = { "anim@amb@drug_field_workers@rake@male_b@idles", "idle_d", "Broom 4", AnimationOptions = {
        Prop = "prop_tool_broom",
        PropBone = 28422,
        PropPlacement = { -0.0100, 0.0400, -0.0300, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
    } },
    ["champw"] = { "anim@move_f@waitress", "idle", "Champagne Waiter", AnimationOptions = {
        Prop = "vw_prop_vw_tray_01a",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0100, 0.0, 0.0, 0.0 },
        SecondProp = 'prop_champ_cool',
        SecondPropBone = 28422,
        SecondPropPlacement = { 0.0, 0.0, 0.010, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shit"] = { "missfbi3ig_0", "shit_loop_trev", "Shit", AnimationOptions = {
        Prop = "prop_toilet_roll_01",
        PropBone = 28422,
        PropPlacement = { 0.0700, -0.02000, -0.2100, 0, 0, 0.0, 0.0 },
        SecondProp = 'prop_big_shit_01',
        SecondPropBone = 0,
        SecondPropPlacement = { -0.0100, 0.0600, -0.1550, 101.3015175, 7.3512213, -29.2665794 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["selfie"] = { "anim@mp_player_intuppertake_selfie", "idle_a", "Selfie", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie2"] = { "cellphone@self@franklin@", "peace", "Selfie 2", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie3"] = { "cellphone@self@franklin@", "west_coast", "Selfie 3 - West Side", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie4"] = { "cellphone@self@trevor@", "aggressive_finger", "Selfie 4 - Finger", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie5"] = { "cellphone@self@trevor@", "proud_finger", "Selfie 5 - Finger 2", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie6"] = { "cellphone@self@trevor@", "throat_slit", "Selfie 6 - Throat Slit", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["selfie7"] = { "cellphone@self@franklin@", "chest_bump", "Selfie 7 - Chest Bump", AnimationOptions = {
        Prop = "prop_phone_ing",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["sittv"] = { "anim@heists@heist_safehouse_intro@variations@male@tv", "tv_part_one_loop", "Sit TV", AnimationOptions = {
        Prop = "v_res_tre_remote",
        PropBone = 57005,
        PropPlacement = { 0.0990, 0.0170, -0.0300, -64.760, -109.544, 18.717 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["dig"] = { "random@burial", "a_burial", "Dig", AnimationOptions = {
        Prop = "prop_tool_shovel",
        PropBone = 28422,
        PropPlacement = { 0.0, 0.0, 0.24, 0, 0, 0.0, 0.0 },
        SecondProp = 'prop_ld_shovel_dirt',
        SecondPropBone = 28422,
        SecondPropPlacement = { 0.0, 0.0, 0.24, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["bongos"] = { "amb@world_human_musician@bongos@male@base", "base", "Bongo Drums", AnimationOptions = {
        Prop = "prop_bongos_01",
        PropBone = 60309,
        PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["medbag"] = { "move_weapon@jerrycan@generic", "idle", "Medic Bag", AnimationOptions = {
        Prop = "xm_prop_x17_bag_med_01a",
        PropBone = 57005,
        PropPlacement = { 0.3900, -0.0600, -0.0600, -100.00, -180.00, -78.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["dufbag"] = { "move_weapon@jerrycan@generic", "idle", "Duffel Bag", AnimationOptions = {
        Prop = "bkr_prop_duffel_bag_01a",
        PropBone = 28422,
        PropPlacement = { 0.2600, 0.0400, 0.00, 90.00, 0.00, -78.99 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shopbag"] = { "move_weapon@jerrycan@generic", "idle", "Shopping Bag", AnimationOptions = {
        Prop = "vw_prop_casino_shopping_bag_01a",
        PropBone = 28422,
        PropPlacement = { 0.24, 0.03, -0.04, 0.00, -90.00, 10.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shopbag2"] = { "move_weapon@jerrycan@generic", "idle", "Shopping Bag 2", AnimationOptions = {
        Prop = "prop_shopping_bags02",
        PropBone = 28422,
        PropPlacement = { 0.05, 0.02, 0.00, 178.80, 91.19, 9.97 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shopbag3"] = { "move_weapon@jerrycan@generic", "idle", "Shopping Bag 3", AnimationOptions = {
        Prop = "prop_cs_shopping_bag",
        PropBone = 28422,
        PropPlacement = { 0.24, 0.03, -0.04, 0.00, -90.00, 10.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shopbag4"] = { "move_weapon@jerrycan@generic", "idle", "Shopping Bag 4", AnimationOptions = {
        Prop = "prop_ld_handbag_s",
        PropBone = 28422,
        PropPlacement = { 0.48, 0.03, -0.00, 0.00, -90.00, 85.00 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["idcard"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Id Card", AnimationOptions = {
        Prop = "p_ld_id_card_002",
        PropWait = 500,
        PropBone = 60309,
        PropPlacement = {0.0, 0.0, 0.0, 0.0, 90.0, 0.0},
        EmoteStuck = true,

    }},
    ["idcardb"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 2 - FIB", AnimationOptions = {
        Prop = "prop_fib_badge",
        PropBone = 28422,
        PropPlacement = { 0.0600, 0.0210, -0.0400, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcardc"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 3", AnimationOptions = {
        Prop = "prop_michael_sec_id",
        PropBone = 28422,
        PropPlacement = { 0.1000, 0.0200, -0.0300, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcardd"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 4", AnimationOptions = {
        Prop = "prop_trev_sec_id",
        PropBone = 28422,
        PropPlacement = { 0.1000, 0.0200, -0.0300, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcarde"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 5", AnimationOptions = {
        Prop = "p_ld_id_card_002",
        PropBone = 28422,
        PropPlacement = { 0.1000, 0.0200, -0.0300, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcardf"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 6", AnimationOptions = {
        Prop = "prop_cs_r_business_card",
        PropBone = 28422,
        PropPlacement = { 0.1000, 0.0200, -0.0300, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcardg"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 7", AnimationOptions = {
        Prop = "prop_michael_sec_id",
        PropBone = 28422,
        PropPlacement = { 0.1000, 0.0200, -0.0300, -90.00, -180.00, 78.999 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["idcardh"] = { "paper_1_rcm_alt1-8", "player_one_dual-8", "ID Card 8", AnimationOptions = {
        Prop = "prop_cop_badge",
        PropBone = 28422,
        PropPlacement = { 0.0800, -0.0120, -0.0600, -90.00, 180.00, 69.99 },
        EmoteLoop = false,
        EmoteMoving = true,
    } },
    ["drilling"] = { "Scenario", "WORLD_HUMAN_CONST_DRILL", "Marteau piqueur" },
    ["garden"] = { "Scenario", "WORLD_HUMAN_GARDENER_PLANT", "Jardiner" },
    ["hammer"] = { "Scenario", "WORLD_HUMAN_HAMMERING", "Marteau" },

    ["pizzaslice"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Jalapeño And Peperoni",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice1',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },
    ["pizzas"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Jalapeño And Peperoni",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice1',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },
    ["pizzas2"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Tomato And Pesto",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice2',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },
    ["pizzas3"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Mushroom",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice3',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },
    ["pizzas4"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Margherita",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice4',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },
    ["pizzas5"] = {
        "mp_player_inteat@burger",
        "mp_player_int_eat_burger",
        "Pizza Slice - Double Peperoni",
        AnimationOptions = {
            Prop = 'knjgh_pizzaslice5',
            PropBone = 60309,
            PropPlacement = {
                0.0500,
                -0.0200,
                -0.0200,
                73.6928,
                -66.7427,
                68.3677
            },
            EmoteMoving = true
        }
    },

    ["microck"] = {
        "lunyx@mic@p1",
        "mic@p1",
        "Microphone Rock",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckb"] = {
        "lunyx@mic@p2",
        "mic@p2",
        "Microphone Rock 2",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0350,
                0.0180,
                0.0290,
             -180.0000,
              -13.0000,
                0.0000
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckc"] = {
        "lunyx@mic@p3",
        "mic@p3",
        "Microphone Rock 3",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckd"] = {
        "lunyx@mic@p4",
        "mic@p4",
        "Microphone Rock 4",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microcke"] = {
        "lunyx@mic@p5",
        "mic@p5",
        "Microphone Rock 5",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0370,
                0.0130,
                0.0150,
               -173.6259,
               -93.5253,
                4.6450
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckf"] = {
        "lunyx@mic@p6",
        "mic@p6",
        "Microphone Rock 6",
        AnimationOptions = {
            Prop = "v_ilev_fos_mic",
            PropBone = 28422,
            PropPlacement = {
                -0.4410,
                -1.0600,
                -0.4800,
                -57.7266,
                51.8164,
                3.0976
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckg"] = {
        "lunyx@mic@p7",
        "mic@p7",
        "Microphone Rock 7",
        AnimationOptions = {
            Prop = "v_ilev_fos_mic",
            PropBone = 28422,
            PropPlacement = {
                -0.8210,
                -0.0900,
                -1.1900,
                -2.5478,
                36.3684,
                -11.7503
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckh"] = {
        "lunyx@mic@p8",
        "mic@p8",
        "Microphone Rock 8",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 60309,
            PropPlacement = {
                0.0370,
                0.0130,
                0.0150,
               -173.6259,
               -93.5253,
                4.6450
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microcki"] = {
        "lunyx@mic@p9",
        "mic@p9",
        "Microphone Rock 9",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["microckj"] = {
        "lunyx@mic@p10",
        "mic@p10",
        "Microphone Rock 10",
        AnimationOptions = {
            Prop = "sf_prop_sf_mic_01a",
            PropBone = 28422,
            PropPlacement = {
                0.0300,
                0.0200,
                -0.0300,
                162.9608,
                -91.1712,
                -3.8249
            },
            EmoteLoop = true,
            EmoteMoving = true
        }
    },

    ["selfiepeace"] = {
        "mirror_selfie@peace_sign",
        "base",
        "Selfie Peace",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 57005,
            PropPlacement = {
                0.1700,
                0.0299,
                -0.0159,
                -126.2687,
                -139.9058,
                35.6203
            },
            EmoteLoop = true,
            EmoteMoving = true,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch"] = {
        "crouching@taking_selfie",
        "base",
        "Selfie Crouching",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 18905,
            PropPlacement = {
                0.1580,
                0.0180,
                0.0300,
                -150.4798,
                -67.8240,
                -46.0417
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch2"] = {
        "eagle@girlphonepose13",
        "girl",
        "Selfie Crouching 2",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 60309,
            PropPlacement = {
                0.0670,
                0.0300,
                0.0300,
                -90.0000,
                0.0000,
                -25.9000
            },
            EmoteLoop = true,
            EmoteMoving = false,
            ExitEmote = "getup",
            ExitEmoteType = "Exits",
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch3"] = {
        "anim@male_insta_selfie",
        "insta_selfie_clip",
        "Selfie Crouching 3",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 60309,
            PropPlacement = {
                0.0700,
                0.0100,
                0.0690,
                0.0,
                0.0,
                -150.0000
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch4"] = {
        "anim@female_selfie_risque",
        "selfie_risque_clip",
        "Selfie Crouching 4",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 18905,
            PropPlacement = {
                0.1580,
                0.0180,
                0.0300,
                -150.4798,
                -67.8240,
                -46.0417
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfieegirl"] = {
        "anim@female_egirl_cute_selfie",
        "cute_selfie_clip",
        "Selfie E Girl",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 26613,
            PropPlacement = {
                0.0760,
               -0.0220,
                0.0350,
               -22.0968,
                30.4351,
                -7.9339
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfieslut"] = {
        "anim@female_floor_slutarch_selfie",
        "slutarch_selfie_clip",
        "Selfie Slut Pose",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 58868,
            PropPlacement = {
                0.0350,
                0.0140,
                0.0290,
              167.9999,
              180.0000,
               -8.8999
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200

        },
        AdultAnimation = true
    },
    ["selfiepeace"] = {
        "mirror_selfie@peace_sign",
        "base",
        "Selfie Peace",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 57005,
            PropPlacement = {
                0.1700,
                0.0299,
                -0.0159,
                -126.2687,
                -139.9058,
                35.6203
            },
            EmoteLoop = true,
            EmoteMoving = true,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch"] = {
        "crouching@taking_selfie",
        "base",
        "Selfie Crouching",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 18905,
            PropPlacement = {
                0.1580,
                0.0180,
                0.0300,
                -150.4798,
                -67.8240,
                -46.0417
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch2"] = {
        "eagle@girlphonepose13",
        "girl",
        "Selfie Crouching 2",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 60309,
            PropPlacement = {
                0.0670,
                0.0300,
                0.0300,
                -90.0000,
                0.0000,
                -25.9000
            },
            EmoteLoop = true,
            EmoteMoving = false,
            ExitEmote = "getup",
            ExitEmoteType = "Exits",
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch3"] = {
        "anim@male_insta_selfie",
        "insta_selfie_clip",
        "Selfie Crouching 3",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 60309,
            PropPlacement = {
                0.0700,
                0.0100,
                0.0690,
                0.0,
                0.0,
                -150.0000
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfiecrouch4"] = {
        "anim@female_selfie_risque",
        "selfie_risque_clip",
        "Selfie Crouching 4",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 18905,
            PropPlacement = {
                0.1580,
                0.0180,
                0.0300,
                -150.4798,
                -67.8240,
                -46.0417
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfieegirl"] = {
        "anim@female_egirl_cute_selfie",
        "cute_selfie_clip",
        "Selfie E Girl",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 26613,
            PropPlacement = {
                0.0760,
               -0.0220,
                0.0350,
               -22.0968,
                30.4351,
                -7.9339
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200
        }
    },
    ["selfieslut"] = {
        "anim@female_floor_slutarch_selfie",
        "slutarch_selfie_clip",
        "Selfie Slut Pose",
        AnimationOptions = {
            Prop = "prop_phone_taymckenzienz",
            PropTextureVariations = {
                {Name = "<font color=\"#00A0F4\">Blue", Value = 0},
                {Name = "<font color=\"#1AA20E\">Green", Value = 1},
                {Name = "<font color=\"#800B0B\">Dark Red", Value = 2},
                {Name = "<font color=\"#FF7B00\">Orange", Value = 3},
                {Name = "<font color=\"#5F5F5F\">Grey", Value = 4},
                {Name = "<font color=\"#a356fa\">Purple", Value = 5},
                {Name = "<font color=\"#FF0099\">Pink", Value = 6},
                {Name = "Black", Value = 7}
            },
            PropBone = 58868,
            PropPlacement = {
                0.0350,
                0.0140,
                0.0290,
              167.9999,
              180.0000,
               -8.8999
            },
            EmoteLoop = true,
            EmoteMoving = false,
            PtfxAsset = "scr_tn_meet",
            PtfxName = "scr_tn_meet_phone_camera_flash",
            PtfxPlacement = {
                -0.015,
                0.0,
                0.041,
                0.0,
                0.0,
                0.0,
                1.0
            },
            PtfxInfo = CFGDPEMOTES.Languages[CFGDPEMOTES.MenuLanguage]['camera'],
            PtfxWait = 200

        },
        AdultAnimation = true
    },
}

DP.Sits = {
    ["sit"] = { "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", "Sit", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit2"] = { "rcm_barry3", "barry_3_sit_loop", "Sit 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit3"] = { "amb@world_human_picnic@male@idle_a", "idle_a", "Sit 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit4"] = { "amb@world_human_picnic@female@idle_a", "idle_a", "Sit 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit5"] = { "anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle", "Sit 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit6"] = { "timetable@jimmy@mics3_ig_15@", "idle_a_jimmy", "Sit 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit7"] = { "anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", "Sit 7", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit8"] = { "timetable@jimmy@mics3_ig_15@", "mics3_15_base_jimmy", "Sit 8", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit9"] = { "amb@world_human_stupor@male@idle_a", "idle_a", "Sit 9", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitlow"] = { "anim@veh@lowrider@std@ds@arm@base", "sit_low_lowdoor", "Sit Lowrider", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitlean"] = { "timetable@tracy@ig_14@", "ig_14_base_tracy", "Sit Lean", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitsad"] = { "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", "Sit Sad", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared"] = { "anim@heists@ornate_bank@hostages@hit", "hit_loop_ped_b", "Sit Scared", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared2"] = { "anim@heists@ornate_bank@hostages@ped_c@", "flinch_loop", "Sit Scared 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared3"] = { "anim@heists@ornate_bank@hostages@ped_e@", "flinch_loop", "Sit Scared 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitdrunk"] = { "timetable@amanda@drunk@base", "base", "Sit Drunk", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair2"] = { "timetable@ron@ig_5_p3", "ig_5_p3_base", "Sit Chair 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair3"] = { "timetable@reunited@ig_10", "base_amanda", "Sit Chair 3 (Female)", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair4"] = { "timetable@ron@ig_3_couch", "base", "Sit Chair 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair5"] = { "timetable@jimmy@mics3_ig_15@", "mics3_15_base_tracy", "Sit Chair Legs Crossed", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair6"] = { "timetable@maid@couch@", "base", "Sit Chair Lean Back", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchairside"] = { "timetable@ron@ron_ig_2_alt1", "ig_2_alt1_base", "Sit Chair Side", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["situp"] = { "amb@world_human_sit_ups@male@idle_a", "idle_a", "Sit Up", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["bumsleep"] = { "Scenario", "WORLD_HUMAN_BUM_SLUMPED", "S'endormir" },
    ["chill"] = { "switch@trevor@scares_tramp", "trev_scares_tramp_idle_tramp", "Chill", AnimationOptions = {
        EmoteLoop = true,
    } },
}

DP.Pegi = {
    ["dock"] = { "anim@mp_player_intincardockstd@rds@", "idle_a", "Dans ton cul", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["finger"] = { "anim@mp_player_intselfiethe_bird", "idle_a", "Faire un doigt", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["finger2"] = { "anim@mp_player_intupperfinger", "idle_a_fp", "Faire deux doigts", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["flipoff"] = { "anim@arena@celeb@podium@no_prop@", "flip_off_a_1st", "Faire un doigt 2", AnimationOptions = {
        EmoteMoving = true,
    } },
    ["flipoff2"] = { "anim@arena@celeb@podium@no_prop@", "flip_off_c_1st", "Faire deux doigts 2", AnimationOptions = {
        EmoteMoving = true,
    } },
    ["fspose"] = { "missfam5_yoga", "c2_pose", "F Sex Pose", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["fspose2"] = { "missfam5_yoga", "c6_pose", "F Sex Pose 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["fspose4"] = { "anim@amb@carmeet@checkout_car@", "female_c_idle_d", "F Sex Pose 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["hump"] = { "timetable@trevor@skull_loving_bear", "skull_loving_bear", "B*iser", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
}

DP.VehicleAnimations = {
    ["pavehcar1l"] = {"pavehcar1l@animations", "pavehcar1lclip", "Veh Assis à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar1r"] = {"pavehcar1r@animations", "pavehcar1rclip", "Veh Assis à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar2r"] = {"pavehcar2r@animations", "pavehcar2rclip", "Veh Se Tenir Fort à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar2l"] = {"pavehcar2l@animations", "pavehcar2lclip", "Veh Se Tenir Fort à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar3r"] = {"pavehcar3r@animations", "pavehcar3rclip", "Veh Assis Détendu à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar3l"] = {"pavehcar3l@animations", "pavehcar3lclip", "Veh Assis Détendu à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar4r"] = {"pavehcar4r@animations", "pavehcar4rclip", "Veh Assis et Salue à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar4l"] = {"pavehcar4l@animations", "pavehcar4lclip", "Veh Assis Cool à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar5r"] = {"pavehcar5r@animations", "pavehcar5rclip", "Veh Rock and Roll à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar5l"] = {"pavehcar5l@animations", "pavehcar5lclip", "Veh Rock and Roll à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar6r"] = {"pavehcar6r@animations", "pavehcar6rclip", "Veh Assis Détendu sur le Toit à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar6l"] = {"pavehcar6l@animations", "pavehcar6lclip", "Veh Assis Détendu sur le Toit à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar7r"] = {"pavehcar7r@animations", "pavehcar7rclip", "Veh Assis Heureux à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false,
        }},
    ["pavehcar7l"] = {"pavehcar7l@animations", "pavehcar7lclip", "Veh Assis Heureux à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pavehcar8r"] = {"pavehcar8r@animations", "pavehcar8rclip", "Veh Dort à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pavehcar8l"] = {"pavehcar8l@animations", "pavehcar8lclip", "Veh Dort à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pavehcar9r"] = {"pavehcar9r@animations", "pavehcar9rclip", "Veh Prend une Vidéo à Droite", AnimationOptions =
        {
            Prop = "prop_phone_ing",
            PropBone = 28422,
            PropPlacement = {0.05, 0.0100, 0.060, -174.961, 149.618, 8.649},
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pavehcar9l"] = {"pavehcar9l@animations", "pavehcar9lclip", "Veh Prend une Vidéo à Gauche", AnimationOptions =
        {
            Prop = "prop_phone_ing",
            PropBone = 58866,
            PropPlacement = {0.07, -0.0500, 0.010, -105.33, -168.30, 48.97},
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pavehcar10"] = {"pavehcar10@animations", "pavehcar10clip", "Veh Assis Profite de Lucia", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar1"] = {"pbvehcar1@animations", "pbvehcar1clip", "Veh Assis Me Voici", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar2"] = {"pbvehcar2@animations", "pbvehcar2clip", "Veh Assis Profite du Vent", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar3r"] = {"pbvehcar3r@animations", "pbvehcar3rclip", "Veh Assis Profite du Trajet à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar3l"] = {"pbvehcar3l@animations", "pbvehcar3lclip", "Veh Assis Profite du Trajet à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar4r"] = {"pbvehcar4r@animations", "pbvehcar4rclip", "Veh Assis Profite du Trajet 2 à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar4l"] = {"pbvehcar4l@animations", "pbvehcar4lclip", "Veh Assis Profite du Trajet 2 à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar5r"] = {"pbvehcar5r@animations", "pbvehcar5rclip", "Veh Assis Regarde la Vue à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar5l"] = {"pbvehcar5l@animations", "pbvehcar5lclip", "Veh Assis Regarde la Vue à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar6r"] = {"pbvehcar6r@animations", "pbvehcar6rclip", "Veh Twerk à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar6l"] = {"pbvehcar6l@animations", "pbvehcar6lclip", "Veh Twerk à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar7l"] = {"pbvehcar7l@animations", "pbvehcar7lclip", "Veh Debout Au Conducteur à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar8"] = {"pbvehcar8@animations", "pbvehcar8clip", "Veh Dort Sur le Toit", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar9"] = {"pbvehcar9@animations", "pbvehcar9clip", "Veh Assis Détendu sur le Toit", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pbvehcar10"] = {"pbvehcar10@animations", "pbvehcar10clip", "Veh Détendu sur le Toit", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar1"] = {"pcvehcar1@animations", "pcvehcar1clip", "Veh Assis Profite sur le Toit", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar2r"] = {"pcvehcar2r@animations", "pcvehcar2rclip", "Veh Assis Coffre à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar2l"] = {"pcvehcar2l@animations", "pcvehcar2lclip", "Veh Assis Coffre à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar3r"] = {"pcvehcar3r@animations", "pcvehcar3rclip", "Veh Assis Coffre Inférieur à Droite", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar3l"] = {"pcvehcar3l@animations", "pcvehcar3lclip", "Veh Assis Coffre Inférieur à Gauche", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar7"] = {"pcvehcar7@animations", "pcvehcar7clip", "Veh Moto Se Tenir Fort", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar8"] = {"pcvehcar8@animations", "pcvehcar8clip", "Veh Moto Deux Pistolets", AnimationOptions =
        {
            Prop = 'w_pi_pistol',
            PropBone = 26611,
            PropPlacement = {0.07, -.01, 0.01, -29.999, 0.0, 10.000},
            SecondProp = 'w_pi_pistol',
            SecondPropBone = 58867,
            SecondPropPlacement = {0.07, 0.01, 0.01, 29.999, 0.0, -10.000 },
            EmoteLoop = true,
            EmoteMoving = false
        }},
    ["pcvehcar9"] = {"pcvehcar9@animations", "pcvehcar9clip", "Veh Moto Assis Face Arrière", AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = false
        }
    },
}

DP.Neige = {

}

DP.Sports = {
    ["boxing"] = { "anim@mp_player_intcelebrationmale@shadow_boxing", "shadow_boxing", "Shadow Boxing", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 4000
    } },
    ["boxing2"] = { "anim@mp_player_intcelebrationfemale@shadow_boxing", "shadow_boxing", "Shadow Boxing 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 4000
    } },
    ["chinup"] = { "Scenario", "PROP_HUMAN_MUSCLE_CHIN_UPS", "Faire des tractions" },
    ["fightme"] = { "anim@deathmatch_intros@unarmed", "intro_male_unarmed_c", "S'échauffer" },
    ["fightme2"] = { "anim@deathmatch_intros@unarmed", "intro_male_unarmed_e", "S'échauffer 2" },
    ["flex"] = { "Scenario", "WORLD_HUMAN_MUSCLE_FLEX", "Montrer ses muscles" },
    ["flip2"] = { "anim@arena@celeb@flat@solo@no_props@", "cap_a_player_a", "Acrobatie 2" },
    ["flip"] = { "anim@arena@celeb@flat@solo@no_props@", "flip_a_player_a", "Acrobatie 1" },
    ["pushup"] = { "amb@world_human_push_ups@male@idle_a", "idle_d", "Faire des pompes", AnimationOptions = {
        EmoteLoop = true,
    } },
}

DP.Salutes = {
    ["bow"] = { "anim@arena@celeb@podium@no_prop@", "regal_c_1st", "Faire ses salutations", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["bow2"] = { "anim@arena@celeb@podium@no_prop@", "regal_a_1st", "Faire ses salutations 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["handshake"] = { "mp_ped_interaction", "handshake_guy_a", "Check moi ça", "handshake2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
        SyncOffsetFront = 0.9
    } },
    ["handshake2"] = { "mp_ped_interaction", "handshake_guy_b", "Check moi ça 2", "handshake", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["hug"] = { "mp_ped_interaction", "kisses_guy_a", "Calin", "hug2", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.05,
    } },
    ["hug2"] = { "mp_ped_interaction", "kisses_guy_b", "Calin 2", "hug", AnimationOptions = {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.13
    } },
    ["hug4"] = { "misscarsteal2chad_goodbye", "chad_armsaround_girl", "Calin 3", "hug3", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = 0.13
    } },
    ["hug3"] = { "misscarsteal2chad_goodbye", "chad_armsaround_chad", "Check de l'épaule", "hug4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = 0.05,
    } },
}

DP.Poses = {
    ["posepol"] = { "anim@male@holding_weapon_2", "holding_weapon_2_clip", "Animation police #1", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol2"] = { "anim@male@holding_weapon_4", "holding_weapon_4_clip", "Animation police #2", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol3"] = { "anim@male@holding_weapon_kneel", "anim@male@holding_weapon_kneel_clip", "Animation police #3", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol4"] = { "anim@male@holding_weapon_nvg", "holding_weapon_nvg_clip", "Animation police #4", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol5"] = { "anim@male@holding_weapon_nvg_2", "holding_weapon_nvg_2_clip", "Animation police #5", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol6"] = { "anim@male@hug_weapon", "hug_weapon_clip", "Animation police #6", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol7"] = { "anim@male@hug_weapon_2", "hug_weapon_2_clip", "Animation police #7", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol8"] = { "anim@male@pose_weapon", "pose_weapon_clip", "Animation police #8", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol9"] = { "anim@male@pose_weapon_2", "pose_weapon_2_clip", "Animation police #9", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol10"] = { "anim@male@pose_weapon_3", "pose_weapon_3_clip", "Animation police #10", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol11"] = { "anim@male@aim_weapon", "aim_weapon_clip", "Animation police #11", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol12"] = { "anim@male@preaim_weapon", "preaim_weapon_clip", "Animation police #12", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol13"] = { "anim@male@run_weapon", "run_weapon_clip", "Animation police #13", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol14"] = { "anim@male@tactical_kneel", "tactical_kneel_clip", "Animation police #14", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol15"] = { "anim@male@holding_vest", "holding_vest_clip", "Animation police #15", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol16"] = { "anim@holding_side_vest", "holding_side_vest_clip", "Animation police #16", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol17"] = { "anim@holding_siege_vest_side", "holding_siege_vest_side_clip", "Animation police #17", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol18"] = { "anim@male@holding_vest_2", "holding_vest_2_clip", "Animation police #18", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol19"] = { "anim@male@holding_vest_siege", "holding_vest_siege_clip", "Animation police #19", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol20"] = { "anim@male@holding_vest_siege_2", "holding_vest_siege_2_clip", "Animation police #20", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol21"] = { "anim@radio_left", "radio_left_clip", "Animation police #21", AnimationOptions = {
        EmoteLoop = true,
    }},
    ["posepol22"] = { "anim@male@holding_radio", "holding_radio_clip", "Animation police #22", AnimationOptions = {
        EmoteLoop = true,
    }},

    ["cop"] = { "Scenario", "WORLD_HUMAN_COP_IDLES", "Mains sur la ceinture" },
    ["cop2"] = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Bras croisés", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cop3"] = { "amb@code_human_police_investigate@idle_a", "idle_b", "Faire un call radio", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cop4"] = { "amb@world_human_car_park_attendant@male@base", "base", "Faire la circulation", AnimationOptions = {
        Prop = "prop_parking_wand_01",
        PropBone = 57005,
        PropPlacement = { 0.12, 0.05, 0.0, 80.0, -20.0, 180.0 },
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms"] = { "amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a", "Bras croisés", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms2"] = { "amb@world_human_hang_out_street@male_c@idle_a", "idle_b", "Bras croisés 2", AnimationOptions = {
        EmoteMoving = true,
    } },
    ["crossarms3"] = { "anim@heists@heist_corona@single_team", "single_team_loop_boss", "Bras croisés 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms4"] = { "random@street_race", "_car_b_lookout", "Bras croisés 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms5"] = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Bras croisés 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms6"] = { "random@shop_gunstore", "_idle", "Bras croisés 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarmsside"] = { "rcmnigel1a_band_groupies", "base_m2", "Bras croisés 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foldarms2"] = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Bras croisés 9", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["foldarms"] = { "anim@amb@business@bgen@bgen_no_work@", "stand_phone_phoneputdown_idle_nowork", "Bras croisés 8", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["grieve"] = { "anim@miss@low@fin@vagos@", "idle_ped05", "Pose garde", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["guard"] = { "Scenario", "WORLD_HUMAN_GUARD_STAND", "Pose garde 2" },
}

DP.Gangs = {
    ["gangsign"] = { "mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", "Signe Mara", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["gangsign2"] = { "mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", "Signe Ballas", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["gangsign3"] = { "amb@code_human_in_car_mp_actions@gang_sign_b@low@ps@base", "idle_a", "Signe Families", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["gangsign4"] = { "amb@code_human_in_car_mp_actions@v_sign@std@rds@base", "idle_a", "Signe Vagos", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
}

DP.Meme = {
    ["meme67a"] = {
        "pazeee@meme67a@animations",
        "pazeee@meme67a@clip",
        "6 7 Meme A",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["meme67b"] = {
        "pazeee@meme67b@animations",
        "pazeee@meme67b@clip",
        "6 7 Meme B",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["meme67c"] = {
        "pazeee@meme67c@animations",
        "pazeee@meme67c@clip",
        "6 7 Meme C",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["meme67d"] = {
        "pazeee@meme67d@animations",
        "pazeee@meme67d@clip",
        "6 7 Meme D",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memeednaidle"] = {
        "pazeee@memeednaidle@animations",
        "pazeee@memeednaidle@clip",
        "Edna Idle",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memeednarun"] = {
        "pazeee@memeednarun@animations",
        "pazeee@memeednarun@clip",
        "Edna Run",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memeednawalk"] = {
        "pazeee@memeednawalk@animations",
        "pazeee@memeednawalk@clip",
        "Edna Walk",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memespidermana"] = {
        "pazeee@memespidermana@animations",
        "pazeee@memespidermana@clip",
        "Spiderman Meme A",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memespidermanb"] = {
        "pazeee@memespidermanb@animations",
        "pazeee@memespidermanb@clip",
        "Spiderman Meme B",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memespidermanc"] = {
        "pazeee@memespidermanc@animations",
        "pazeee@memespidermanc@clip",
        "Spiderman Meme C",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memespidermand"] = {
        "pazeee@memespidermand@animations",
        "pazeee@memespidermand@clip",
        "Spiderman Meme D",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
    ["memespidermane"] = {
        "pazeee@memespidermane@animations",
        "pazeee@memespidermane@clip",
        "Spiderman Meme E",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = true,
        }
    },
}
