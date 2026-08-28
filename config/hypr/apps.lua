-- App-specific tweaks.

local o = require("hypr.helpers")

o.window("(com[.]mitchellh[.]ghostty|org[.]desktop[.].*)", { tag = "+terminal" })
o.window({ tag = "terminal" }, { tag = "-default-opacity" })
o.window({ tag = "terminal" }, { opacity = "0.985 0.96" })

-- Walker is a layer surface, so it should appear without compositor animation.
hl.layer_rule({ match = { namespace = "walker" }, no_anim = true })
