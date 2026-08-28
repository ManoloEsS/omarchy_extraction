-- Generic window rules are applied before app-specific rules.

local o = require("hypr.helpers")

o.window(".*", { suppress_event = "maximize" })
o.window(".*", { tag = "+default-opacity" })

-- Avoid focusing empty XWayland helper windows.
o.window(
  {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  { no_focus = true }
)

require("hypr.apps")

o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
