-- 'ppi 1280x1024 7.5
assert(arg[1], 'ppi WxH size')
local w, h, inch = arg[1]:match('(%d+)x(%d+) ([%d%.]+)')
w = assert(tonumber(w))
h = assert(tonumber(h))
inch = assert(tonumber(inch))
if not w or not h or not inch then
  print('usage: \'ppi WIDTHxHEIGHT SIZE"')
  return
end
return math.sqrt(w^2+h^2)/inch
