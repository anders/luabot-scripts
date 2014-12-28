local Sun = require 'sun'

local who = arg[1] or nick

local coords = assert(etc.get('location.coords', who), 'use set location')
-- main = function(lat, lon, year, month, day)
local lat, lon = coords:match('([%-%d%.]+),%s*([%-%d%.]+)')
lat, lon = tonumber(lat), tonumber(lon)

local week_ago = os.date("!*t", os.time() - 86400*7)
local today = os.date('!*t')
local length_past, rs_past, rise_past, set_past = Sun.opt_calc(lat, lon, week_ago.year, week_ago.month, week_ago.day)
local length, rs, rise, set = Sun.opt_calc(lat, lon, today.year, today.month, today.day)

local ts_rise, offset_rise, tz_code_rise = etc.timezone(who, "%H:%M", rise, true)
local ts_set, offset_set, tz_code_set = etc.timezone(who, "%H:%M", set, true)
print(("Sunrise: %s %s; Sunset: %s %s. Day is %s long."):format(
  ts_rise, tz_code_rise,
  ts_set, tz_code_set,
  etc.duration(math.floor(length * 3600))))

local ts_rise, offset_rise, tz_code_rise = etc.timezone(who, "%H:%M", rise_past, true)
local ts_set, offset_set, tz_code_set = etc.timezone(who, "%H:%M", set_past, true)
print(("A week ago: Sunrise: %s %s; Sunset: %s %s. The day was %s long. Difference: %s."):format(
  ts_rise, tz_code_rise,
  ts_set, tz_code_set,
  etc.duration(math.floor(length_past * 3600)), etc.duration(math.floor((length - length_past) * 3600))))

-- print(('sunrise: %s %s, sunset: %s %s. day is %s long'):format(
--rise, tzcr, set, tzcs, etc.duration(math.floor(butt.set - butt.rise)))
