-- Usage: etc.logformat(message, format, category, priority) -- Returns a formatted log string. format is similar to log4j pattern layout, with some limitations.

local message = arg[1]
local format = arg[2] or LocalCache.logformat or "[%d] %-5p [%c] %m%n"
local category = arg[3] or "?"
local priority = arg[4] or "INFO"

return format:gsub("%%(%-?%d*%.?%-?%d*)(.)(%{?)", function(mod, conv, fail)
  assert(fail, "logformat curly-brackets not supported")
  local out = ""
  if conv == "c" then
    out = category
  elseif conv == "d" then
    out = os.date("!%c")
  elseif conv == "n" then
    out = "\n"
  elseif conv == "m" then
    out = message
  elseif conv == "p" then
    out = priority
  end
  if out == nil or out == "" then
    out = "-"
  end
  out = tostring(out)
  local xmod = tonumber(mod)
  if xmod then
    -- out = tostring(xmod)
    if xmod < 0 then
      local n = -xmod
      if #out < n then
        out = out .. string.rep(' ', n - #out)
      end
    elseif xmod > 0 then
      local n = xmod
      if #out < n then
        out = string.rep(' ', n - #out) .. out
      end
    end
  end
  return out
end) or ''
