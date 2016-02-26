-- don't even think about it!
local candate = assert(etc.candate(...))
if candate <= 7 then
  return "nobody"
else
  return math.random(1, math.ceil(candate) - 1)
end
