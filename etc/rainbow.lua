return etc.gaywords(...)


--[[
local Colors = {
  -- fg,bg
  {0, 4},
  {7, 8},
  {3, 9},
  {2, 12},
  {13, 6}
}

if not arg[1] then arg[1] = 4 end
local N = tonumber(arg[1]) or 4

local n = Cache.rainbow
if n == nil then
  n = 1
  Cache.rainbow = 1
else
  n = n + 1
  Cache.rainbow = n
end
local tmp = {}

for j=1, N do
  local tmp = {}
  for i=1, 30 do
    local color = Colors[(((n-1) + j + i) % #Colors) + 1]
    tmp[#tmp + 1] = ('\003%d,%d__'):format(color[2], color[2])
  end
  print(table.concat(tmp))
end
]]

