local input = assert(arg[1], "Argument expected")
local s = ""

for i = 1, input:len() do
  local ch = input:sub(i, i)
  if ch:find("^[a-zA-Z]$") then
    s = s .. "[" .. ch:upper() .. ch:lower() ..  "]"
  else
    s = s .. ch
  end
end

return s
