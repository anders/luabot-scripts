API "1.1"

local arg, last = etc.stdio(arg)
local f = loadstring("return " .. arg[1])()

while true do
  local current = etc.getOutput(f, last)
  if current == last then break end
  last = current
end

return last or ""
