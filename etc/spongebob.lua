API "1.1"

local upper, lower = string.upper, string.lower
local f = lower

return etc.translateWords(arg[1], function(w)
  local tmp = {}
  for i=1, #w do
    tmp[i] = f(w:sub(i, i))
    f = (f == upper) and lower or upper
  end
  return table.concat(tmp, "")
end)
