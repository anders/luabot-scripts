assert(arg[1], "expected function arg")
local s = arg[1]

local mod, func
if s:sub(1, 1) == "'" then
  mod = (arg[1] or ''):match("^'([^%.']+)")
  if not mod or mod == "" then
    mod = "etc"
  end
else
  mod = (arg[1] or ''):match("^([^%.]+)")
  -- assert(mod, "no mod found in " .. tostring(arg[1]))
end
func = (arg[1] or ''):match("[^%.']+$")

if mod == func then
  -- extremely lame workaround
  mod = "etc"
end

return boturl .. "u/anders/scripts.lua"
  .. "?mod=".. urlEncode(assert(mod, "expected module.function"))
  .. "&fun=" .. urlEncode(assert(func, "expected module.function"))
