-- Hyprland 0.55+ uses Lua configuration instead of hyprlang.

local home = os.getenv("HOME") or ""
local config_home = os.getenv("XDG_CONFIG_HOME")
if config_home == nil or config_home == "" then
  config_home = home .. "/.config"
end

-- Make modules under ~/.config/hypr available as hypr.*.
package.path = config_home .. "/?.lua;" .. package.path

require("hypr.monitors")
require("hypr.envs")
require("hypr.looknfeel")
require("hypr.input")
require("hypr.windows")
require("hypr.bindings")
require("hypr.autostart")
