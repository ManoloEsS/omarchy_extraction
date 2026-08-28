-- App-specific tweaks.

local o = require("hypr.helpers")

o.window("(com[.]mitchellh[.]ghostty|org[.]desktop[.].*)", { tag = "+terminal" })
o.window("^org[.]desktop[.](bluetui|impala|wiremix|btop)$", { tag = "+floating-window" })
o.window({ tag = "floating-window" }, { float = true })
o.window({ tag = "floating-window" }, { center = true })
o.window({ tag = "floating-window" }, { size = "875 600" })
o.window({ tag = "terminal" }, { tag = "-default-opacity" })
o.window({ tag = "terminal" }, { opacity = "0.985 0.96" })

-- Walker is a layer surface, so it should appear without compositor animation.
hl.layer_rule({ match = { namespace = "walker" }, no_anim = true })
