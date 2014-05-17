
local t = {}
for i = 1, select('#', ...) do
  t[#t + 1] = type(select(i, ...))
end
return unpack(t)
