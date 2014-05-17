local Sun = require 'sun'

local who = arg[1] or nick

local coords = assert(etc.get('location.coords', who), 'use set location')
-- main = function(lat, lon, year, month, day)
local lat, lon = coords:match('([%-%d%.]+),%s*([%-%d%.]+)')
lat, lon = tonumber(lat), tonumber(lon)

local date = os.date('!*t')
local butt = Sun.calc(lat, lon, date.year, date.month, date.day)

if butt.rs == 0 then
  local rise, ofs, tzcr = etc.timezone(who, '%H:%M:%S', butt.rise, true)
  local set, ofs, tzcs = etc.timezone(who, '%H:%M:%S', butt.set, true)
  print(('sunrise: %s %s, sunset: %s %s. day is %s long'):format(rise, tzcr, set, tzcs, etc.duration(math.floor(butt.set - butt.rise))))
else
  print('either the sun never rises, or sets')
end