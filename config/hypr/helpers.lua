-- Small standalone helpers for repeated native Hyprland Lua patterns.

local M = {}

function M.bind(keys, description, dispatcher, options)
  local opts = {}
  for key, value in pairs(options or {}) do
    opts[key] = value
  end

  if description then
    opts.description = description
  end

  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end

  return hl.bind(keys, dispatcher, opts)
end

function M.window(match, rules)
  local spec = {}
  for key, value in pairs(rules or {}) do
    spec[key] = value
  end

  spec.match = spec.match or {}
  if type(match) == "string" then
    spec.match.class = match
  else
    for key, value in pairs(match) do
      spec.match[key] = value
    end
  end

  return hl.window_rule(spec)
end

function M.exec_on_start(command)
  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

return M
