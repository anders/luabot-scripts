API "1.1"

-- /nn 1234 1200 1354 1100

local MINIMUM = 100

local arg1 = arg[1] or "1234 1235 1236 1237"

local n = select("#", ...)
if n > 1 then
  local tmp = {}
  for i=1, n do
    local a = select(i, ...)
    if type(a) == "number" then
      tmp[#tmp+1] = tostring(a)
    end
  end
  arg1 = table.concat(tmp, " ")
end

local innehav = {}

for n in arg1:gmatch("%d+") do
  innehav[#innehav + 1] = n
end

local max = math.max(table.unpack(innehav))
local min = math.min(table.unpack(innehav))
local diff = max-min
local innehavSum = 0
for i=1, #innehav do innehavSum = innehavSum + innehav[i] end

local sum = 0
local tmp = {}
for i=1, #innehav do
  local max = max
  if diff < 100 then max = max + 100 end
  sum = sum + max - innehav[i]
  tmp[#tmp + 1] = ("%d: %d kr (%.1f%%)"):format(i, max - innehav[i], innehav[i] / innehavSum * 100)
end

return table.concat(tmp, ", ").." (summa: "..sum.." kr)"
