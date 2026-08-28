-- Core user-session services.

local o = require("hypr.helpers")

o.exec_on_start("hypridle")
o.exec_on_start("mako")
o.exec_on_start("desk-start-waybar")

-- Uncomment and set a wallpaper if swaybg is installed.
-- o.exec_on_start('swaybg -i "$HOME/Pictures/wallpaper.jpg" -m fill')
