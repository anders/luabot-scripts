
--[[

-- Note: only gets setting for current message nick.

local name = assert(arg[1], "Setting name expected")

local value
local xprint = print
print = function(s)
  value = s:match(" = (.*)")
end
etc.get(name)
print = xprint

if value then
  return value
end
return nil, 'Not set'

--]]

return etc.get(...)
