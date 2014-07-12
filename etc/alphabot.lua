API "1.1"

local pat = arg[1] or "%1"
local delim = arg[2] or " "

local t = {}
for a in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
  t[#t + 1] = a:gsub(".", pat)
end

return table.concat(t, delim)
