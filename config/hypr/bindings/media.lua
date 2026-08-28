-- Volume, brightness, keyboard backlight, and media controls.

local o = require("hypr.helpers")

local locked_repeating = { locked = true, repeating = true }
local locked = { locked = true }

o.bind("XF86AudioRaiseVolume", "Volume up", "desk-swayosd-client --output-volume raise", locked_repeating)
o.bind("XF86AudioLowerVolume", "Volume down", "desk-swayosd-client --output-volume lower", locked_repeating)
o.bind("XF86AudioMute", "Mute", "desk-swayosd-client --output-volume mute-toggle", locked_repeating)
o.bind("XF86AudioMicMute", "Mute microphone", "desk-audio-input-mute", locked_repeating)
o.bind("XF86MonBrightnessUp", "Brightness up", "desk-brightness-display +5%", locked_repeating)
o.bind("XF86MonBrightnessDown", "Brightness down", "desk-brightness-display 5%-", locked_repeating)
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "desk-brightness-display 100%", locked_repeating)
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "desk-brightness-display 1%", locked_repeating)
o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "desk-brightness-keyboard up", locked)
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "desk-brightness-keyboard down", locked)
o.bind("XF86KbdLightOnOff", "Keyboard backlight cycle", "desk-brightness-keyboard cycle", locked)

-- Precise one-percent adjustments.
o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "desk-swayosd-client --output-volume +1", locked_repeating)
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "desk-swayosd-client --output-volume -1", locked_repeating)
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", "desk-brightness-display +1%", locked_repeating)
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", "desk-brightness-display 1%-", locked_repeating)

-- Media playback.
o.bind("XF86AudioNext", "Next track", "desk-swayosd-client --playerctl next", locked)
o.bind("XF86AudioPause", "Pause", "desk-swayosd-client --playerctl play-pause", locked)
o.bind("XF86AudioPlay", "Play", "desk-swayosd-client --playerctl play-pause", locked)
o.bind("XF86AudioPrev", "Previous track", "desk-swayosd-client --playerctl previous", locked)
o.bind("SUPER + XF86AudioMute", "Switch audio output", "desk-audio-output-switch", locked)
