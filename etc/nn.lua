API "1.1"

-- /nn 1234 1200 1354 1100

local MINIMUM = 100

local arg1 = arg[1] or "1234 1235 1236 1237"

local innehav = {}

for n in arg1:gmatch("%d+") do
  innehav[#innehav + 1] = n
end

local max = math.max(table.unpack(innehav))
local min = math.min(table.unpack(innehav))
local diff = max-min

local sum = 0
local tmp = {}
for i=1, #innehav do
  local max = max
  if diff < 100 then max = max + 100 end
  sum = sum + max - innehav[i]
  tmp[#tmp + 1] = ("%d: %d kr"):format(i, max - innehav[i])
end

return table.concat(tmp, ", ").." (summa: "..sum.." kr)"
