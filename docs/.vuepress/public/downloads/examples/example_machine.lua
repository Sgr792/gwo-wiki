-- Teaching configuration only: supply matching clips and mechanical timing.
local default = require("example:default_machine")
local config = {
    ["animation_machine"] = {
        ["version"] = 2,
        ["actions"] = {
            ["raise"] = {
                ["type"] = "finite",
                ["default_state"] = "raise"
            },
            ["drop"] = {
                ["type"] = "finite",
                ["default_state"] = "drop"
            },
            ["fire"] = {
                ["type"] = "finite",
                ["default_state"] = "fire",
                ["variants"] = array {
                    {
                        ["state"] = "fire_last_ads",
                        ["priority"] = 200,
                        ["when"] = {
                            ["aiming"] = "true",
                            ["last_round"] = "true"
                        }
                    },
                    {
                        ["state"] = "fire_ads",
                        ["priority"] = 100,
                        ["when"] = {
                            ["aiming"] = "true"
                        }
                    },
                    {
                        ["state"] = "fire_last",
                        ["priority"] = 100,
                        ["when"] = {
                            ["last_round"] = "true"
                        }
                    }
                },
                ["events"] = array {
                    {
                        ["type"] = "shot_effects",
                        ["marker"] = "shot",
                        ["offset_ms"] = 0
                    },
                    {
                        ["type"] = "fire_sound",
                        ["marker"] = "shot",
                        ["offset_ms"] = 0
                    },
                    {
                        ["type"] = "recoil",
                        ["marker"] = "shot",
                        ["offset_ms"] = 0
                    }
                }
            },
            ["reload"] = {
                ["type"] = "finite",
                ["default_state"] = "reload",
                ["variants"] = array {
                    {
                        ["state"] = "reload_empty",
                        ["priority"] = 100,
                        ["when"] = {
                            ["empty"] = "true"
                        }
                    }
                }
            },
            ["inspect"] = {
                ["type"] = "finite",
                ["default_state"] = "inspect"
            },
            ["aim"] = {
                ["type"] = "continuous",
                ["phase_states"] = {
                    ["enter"] = "ads_up",
                    ["loop"] = "idle",
                    ["exit"] = "ads_down"
                }
            },
            ["sprint"] = {
                ["type"] = "continuous",
                ["phase_states"] = {
                    ["enter"] = "sprint_in",
                    ["loop"] = "sprint_loop",
                    ["exit"] = "sprint_out"
                }
            }
        },
        ["interrupts"] = array {}
    },
    ["animation_controller"] = {
        ["channels"] = {
            ["idle"] = {
                ["clip"] = "idle",
                ["layer"] = "base",
                ["loop"] = true,
                ["duration_frame"] = 30,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["raise"] = {
                ["clip"] = "raise",
                ["layer"] = "action",
                ["loop"] = false,
                ["duration_frame"] = 15,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["drop"] = {
                ["clip"] = "drop",
                ["layer"] = "action",
                ["loop"] = false,
                ["duration_frame"] = 15,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["fire"] = {
                ["clip"] = "fire",
                ["layer"] = "recoil",
                ["loop"] = false,
                ["duration_frame"] = 12,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["fire_ads"] = {
                ["clip"] = "fire_ads",
                ["layer"] = "recoil",
                ["loop"] = false,
                ["duration_frame"] = 12,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["fire_last"] = {
                ["clip"] = "fire_last",
                ["layer"] = "recoil",
                ["loop"] = false,
                ["duration_frame"] = 12,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["fire_last_ads"] = {
                ["clip"] = "fire_last_ads",
                ["layer"] = "recoil",
                ["loop"] = false,
                ["duration_frame"] = 12,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["reload"] = {
                ["clip"] = "reload",
                ["layer"] = "action",
                ["loop"] = false,
                ["duration_frame"] = 60,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["reload_empty"] = {
                ["clip"] = "reload_empty",
                ["layer"] = "action",
                ["loop"] = false,
                ["duration_frame"] = 75,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["inspect"] = {
                ["clip"] = "inspect",
                ["layer"] = "inspect",
                ["loop"] = false,
                ["duration_frame"] = 90,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["ads_up"] = {
                ["clip"] = "ads_up",
                ["layer"] = "aim",
                ["loop"] = false,
                ["duration_frame"] = 6,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["ads_down"] = {
                ["clip"] = "ads_down",
                ["layer"] = "aim",
                ["loop"] = false,
                ["duration_frame"] = 6,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["sprint_in"] = {
                ["clip"] = "sprint_in",
                ["layer"] = "sprint",
                ["loop"] = false,
                ["duration_frame"] = 9,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["sprint_loop"] = {
                ["clip"] = "sprint_loop",
                ["layer"] = "sprint",
                ["loop"] = true,
                ["duration_frame"] = 30,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            },
            ["sprint_out"] = {
                ["clip"] = "sprint_out",
                ["layer"] = "sprint",
                ["loop"] = false,
                ["duration_frame"] = 9,
                ["speed"] = 1,
                ["fade_in"] = 0,
                ["fade_out"] = 0
            }
        }
    },
    ["animation_events"] = {
        ["raise"] = "raise",
        ["drop"] = "drop",
        ["fire"] = "fire",
        ["fire_ads"] = "fire",
        ["fire_last"] = "fire",
        ["fire_last_ads"] = "fire",
        ["reload"] = "reload",
        ["reload_empty"] = "reload_empty",
        ["inspect"] = "inspect",
        ["ads_up"] = "aim",
        ["ads_down"] = "aim",
        ["sprint_in"] = "sprint",
        ["sprint_loop"] = "sprint",
        ["sprint_out"] = "sprint"
    },
    ["paired_aim_actions"] = {
        ["fire"] = "fire_ads",
        ["fire_last"] = "fire_last_ads"
    }
}
local machine = default.new(config)
return machine
