-- Send a short key sequence to the focused surface.
-- Splitting key-down and key-up avoids synthetic keys getting stuck.

local o = require("hypr.helpers")

local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

o.bind("SUPER + C", "Universal copy", send_shortcut_once("CTRL", "Insert"))
o.bind("SUPER + V", "Universal paste", send_shortcut_once("SHIFT", "Insert"))
o.bind("SUPER + X", "Universal cut", send_shortcut_once("CTRL", "X"))
o.bind("SUPER + CTRL + V", "Clipboard manager", "desk-launch-walker -m clipboard")
