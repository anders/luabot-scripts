API "1.1"

if Help then
  print "Please read more about our conditions and guidelines at http://om.yr.no/verdata/  English explanation at http://om.yr.no/verdata/free-weather-data/"
end

local geocode = require "geocode"

-- original world list lacks some locations
local additional_places = {
  {48.40,   9.98, "http://www.yr.no/place/Germany/Baden-Württemberg/Ulm/forecast.xml"},
  {59.86,   5.74, "http://www.yr.no/place/Norway/Hordaland/Kvinnherad/Husnes/forecast.xml"},
  {36.35, 138.60, "http://www.yr.no/place/Japan/Other/Karuizawa-machi/forecast.xml"},
}

local query = arg[1]


query = etc.get("location", query) or query or etc.get("location", nick)

if not query then
  return false, "Please set your location using 'set location place."
end

local place, coords = geocode.simple(query)
if not place then
  print("\002Error:\002 Geocode error: "..coords)
  return
end

-- while testing: local coords = "35.69,139.69"

local function loadurls(lat, lon)
  local paths = {}
  local a, b = math.floor(lat % 10), math.floor(lon % 10)

  for y=b - 1, b + 1 do
    for x=a - 1, a + 1 do
      local tmp = ("/shared/yr/yr_urls_%dx%d.txt"):format(x, y)
      if io.fs.exists(tmp) then
        paths[#paths + 1] = tmp
      end
    end
  end

  local t = {}

  for k, v in ipairs(additional_places) do
    t[k] = v
  end

  for k, path in ipairs(paths) do
    for line in io.lines(path) do
      local lat, lon, url = line:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
      t[#t + 1] = {tonumber(lat), tonumber(lon), url}
    end
  end

  return t
end

local rad, sin, cos, atan2, sqrt = math.rad, math.sin, math.cos, math.atan2, math.sqrt

-- returns distance in km
local function distance(latA, lonA, latB, lonB)
  local R = 6371.5 -- mean earth radius in km
  local dLat = rad(latB - latA)
  local dLon = rad(lonB - lonA)
  local latA = rad(latA)
  local latB = rad(latB)

  local a = sin(dLat / 2) * sin(dLat / 2) +
            sin(dLon / 2) * sin(dLon / 2) * cos(latA) * cos(latB)
  local c = 2 * atan2(sqrt(a), sqrt(1 - a))
  local d = R * c

  return d
end

local lat, lon = coords:match("([^,]+),(.+)")
lat = tonumber(lat)
lon = tonumber(lon)

local urls = loadurls(lat, lon)

-- calculate distance for each point in the list and sort by that
for i, v in ipairs(urls) do
  v[4] = distance(lat, lon, v[1], v[2])
end

table.sort(urls, function(a, b)
  return a[4] < b[4]
end)

local lat, lng, url, dist = unpack(urls[1])

if account ~= 2 then
  print(("lat: %f lon: %f url: %s dist: %f km"):format(unpack(urls[1])))
  return
end

local xml = require "xml"

local persed = xml.parse(assert(httpGet(url)))

local loc = persed.weatherdata.location
local cur = persed.weatherdata.observations.weatherstation[1]

-- -- 17:46:54 <@luabot> Ulm, BW, Germany: 21°C (feels like 25°C), wind: 6 m/s (60°), humidity: 38%, precipitation: 0 mm, cloud coverage: 25% (Partly Cloudy)
local buf = {}
buf[#buf + 1] = "\2"..loc.name["#text"]..", "..loc.country["#text"]..":\2 "
buf[#buf + 1] = cur.temperature.value.."°C, "
if cur.windSpeed and cur.windDirection then
  buf[#buf + 1] = ("\2wind:\2 %d m/s (%d°), "):format(cur.windSpeed.mps, cur.windDirection.deg)
end
buf[#buf + 1] = "\2station:\2 "..cur.name

print(table.concat(buf))

-- 17:46:54 <@luabot> Ulm, BW, Germany: 21°C (feels like 25°C), wind: 6 m/s (60°), humidity: 38%, precipitation: 0 mm, cloud coverage: 25% (Partly Cloudy)
-- http://www.yr.no/place/Germany/Baden-Württemberg/Ulm/forecast.xml
