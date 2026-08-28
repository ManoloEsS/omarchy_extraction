-- Application bindings.

local o = require("hypr.helpers")

o.bind("SUPER + RETURN", "Terminal", "desk-launch-terminal")
o.bind("SUPER + SHIFT + F", "File manager", "nautilus --new-window")
o.bind("SUPER + SHIFT + B", "Browser", "desk-launch-browser")
o.bind("SUPER + SHIFT + N", "Editor", "desk-launch-editor")

-- Examples:
-- o.bind("SUPER + SHIFT + M", "Music", "desk-launch-or-focus 'spotify' -- spotify")
-- o.bind("SUPER + SHIFT + D", "Docker", "desk-launch-tui lazydocker")
