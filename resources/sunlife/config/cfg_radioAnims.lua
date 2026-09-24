Config = Config or {} -- partagé avec cfg_rockstar_editor.lua : ne pas écraser

Config.Animations = {
    ["shoulder"] = {
        dict = "random@arrests",
        anim = "generic_radio_chatter"
    },
    ["chest"] = {
        dict = "anim@cop_mic_pose_002",
        anim = "chest_mic"
    },
    ["ear"] = {
        dict = "cellphone@",
        anim = "cellphone_call_listen_base"
    }
}

Config.RadioClothing = {
    [9] = {
        [14] = {
            [0] = "shoulder",
            [1] = "chest",
            [2] = "chest"
        },
        [13] = {
            [0] = "shoulder",
            [1] = "chest",
            [2] = "chest"
        },
        [12] = {
            [2] = "shoulder"
        }
    },
    [8] = {
        [7] = {
            [0] = "shoulder"
        }
    },
    [1] = {
        [16] = {
            [0] = "ear"
        }
    },
    [5] = {
        [66] = {
            [0] = "shoulder",
            [1] = "chest",
            [2] = "chest"
        },
    },
}

Config.RadioClothing = {
    male = {
        [9] = {
            [14] = {
                [0] = "shoulder",
                [1] = "chest",
                [2] = "chest"
            },
            [13] = {
                [0] = "shoulder",
                [1] = "chest",
                [2] = "chest"
            },
            [12] = {
                [2] = "shoulder"
            }
        },
        [8] = {
            [7] = {
                [0] = "shoulder"
            }
        },
        [1] = {
            [16] = {
                [0] = "ear"
            }
        },
        [5] = {
            [66] = {
                [0] = "shoulder",
                [1] = "chest",
                [2] = "chest"
            },
        },
    },
    female = {
        [9] = {
            [6] = {
                [0] = "shoulder"
            }
        },
        [8] = {
            [7] = {
                [1] = "chest"
            }
        }
    }
}
