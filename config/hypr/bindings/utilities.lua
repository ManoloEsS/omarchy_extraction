-- Launcher, desktop toggles, notifications, and system controls.

local o = require("hypr.helpers")

o.bind("SUPER + SPACE", "Launch apps", "desk-launch-walker")
o.bind("SUPER + CTRL + E", "Symbols", "desk-launch-walker -m symbols")
o.bind("SUPER + ALT + SPACE", "System menu", "desk-menu")
o.bind("SUPER + ESCAPE", "System menu", "desk-menu")
o.bind("XF86PowerOff", "System menu", "desk-menu power", { locked = true })

-- Desktop toggles.
o.bind("SUPER + SHIFT + SPACE", "Toggle top bar", "desk-toggle-waybar")
o.bind("SUPER + CTRL + I", "Toggle idle lock", "desk-toggle-idle")
o.bind("SUPER + CTRL + N", "Toggle nightlight", "desk-toggle-nightlight")
o.bind("SUPER + CTRL + comma", "Toggle notifications", "desk-toggle-notifications")

-- Notifications.
o.bind("SUPER + comma", "Dismiss last notification", "makoctl dismiss")
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "makoctl dismiss --all")
o.bind("SUPER + ALT + comma", "Invoke last notification", "makoctl invoke")
o.bind("SUPER + SHIFT + ALT + comma", "Restore last notification", "makoctl restore")

-- Capture and color picking.
o.bind("PRINT", "Screenshot", "desk-screenshot")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- Control panels.
o.bind("SUPER + CTRL + A", "Audio controls", "desk-launch-audio")
o.bind("SUPER + CTRL + B", "Bluetooth controls", "desk-launch-bluetooth")
o.bind("SUPER + CTRL + W", "Wi-Fi controls", "desk-launch-wifi")
o.bind("SUPER + CTRL + T", "Activity", "desk-launch-or-focus-tui btop")

-- Zoom and lock.
o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)
o.bind("SUPER + CTRL + L", "Lock system", "desk-lock")
