local geocode = require "geocode"

local loc1, loc2 = arg[1]:match("(.+)%->(.+)")

if not loc1 or not loc2 then
  print("Usage: 'distance from->to")
  return
end

local pos1 = assert(geocode.lookup(loc1))
local pos2 = assert(geocode.lookup(loc2))
local lat1, lon1 = pos1.geometry.location.lat, pos1.geometry.location.lng
local lat2, lon2 = pos2.geometry.location.lat, pos2.geometry.location.lng

local R = 6371.5 -- mean earth radius in km
local dLat = math.rad(lat2 - lat1)
local dLon = math.rad(lon2 - lon1)
local lat1 = math.rad(lat1)
local lat2 = math.rad(lat2)

local a = math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2)
local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
local d = R * c

print(("%.02f km"):format(d))
