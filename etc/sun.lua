local Sun = require 'sun'

local who = arg[1] or nick

-- local coords = assert(etc.get('location.coords', who), 'use set location')

local coords = etc.get('location.coords', who)
if not coords then
  local _
  _, coords = plugin.geocode().simple(who)
  who = 'UTC' -- hack
end

assert(coords, 'unable to get coordinates for '..who)

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

local diff = (length - length_past) * 3600
-- diff = diff>=0 and ("+"..etc.duration(diff)) or ("-"..etc.duration(math.floor(diff)))

local diff_string
if diff == 0 then
  diff_string = 'The length of the day has not changed'
elseif diff > 0 then
  diff_string = 'The day is now '..etc.duration(math.floor(diff))..' longer'
else
  diff_string = 'The day is now '..etc.duration(math.floor(diff))..' shorter'
end

print(("A week ago: Sunrise: %s %s; Sunset: %s %s. The day was %s long. %s."):format(
  ts_rise, tz_code_rise,
  ts_set, tz_code_set,
  etc.duration(math.floor(length_past * 3600)), diff_string))

-- print(('sunrise: %s %s, sunset: %s %s. day is %s long'):format(
--rise, tzcr, set, tzcs, etc.duration(math.floor(butt.set - butt.rise)))
