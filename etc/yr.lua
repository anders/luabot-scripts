API "1.1"

if Help then
  print "Please read more about our conditions and guidelines at http://om.yr.no/verdata/  English explanation at http://om.yr.no/verdata/free-weather-data/"
end

local geocode = require "geocode"

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

local function latlng2path(lat, lng)
  return ('/shared/yr/yr_urls_%dx%d.txt'):format(math.floor(lat % 10), math.floor(lng % 10))
end

local function loadurls(path)
  local t = {}
  for line in io.lines(path) do
    local lat, lon, url = line:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
    t[#t + 1] = {tonumber(lat), tonumber(lon), url}
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

local lat, lng = coords:match("([^,]+),(.+)")
lat = tonumber(lat)
lng = tonumber(lng)

local urls = loadurls(latlng2path(lat, lng))

-- calculate distance for each point in the list and sort by that
for i, v in ipairs(urls) do
  v[4] = distance(lat, lng, v[1], v[2])
end
table.sort(urls, function(a, b)
  return a[4] < b[4]
end)

local lat, lng, url, dist = unpack(urls[1])
print(("lat: %f lng: %f url: %s dist: %f km"):format(unpack(urls[1])))

local XMLData = [[
<?xml version="1.0" encoding="utf-8"?>
<weatherdata>
  <location>
    <name>Los Angeles</name>
    <type>Administration centre</type>
    <country>United States</country>
  </location>
  <sun rise="2014-06-12T05:41:04" set="2014-06-12T20:04:48" />
  <forecast>
    <tabular>
      <time from="2014-06-12T20:00:00" to="2014-06-12T23:00:00" period="3">
        <symbol number="1" numberEx="1" name="Clear sky" var="mf/01n.48" />
        <precipitation value="0" />
        <windDirection deg="233.1" code="SW" name="Southwest" />
        <windSpeed mps="3.9" name="Gentle breeze" />
        <temperature unit="celsius" value="20" />
        <pressure unit="hPa" value="1012.7" />
      </time>
      <time from="2014-06-12T23:00:00" to="2014-06-13T05:00:00" period="0">
        <!-- Valid from 2014-06-12T23:00:00 to 2014-06-13T05:00:00 -->
        <symbol number="2" numberEx="2" name="Fair" var="mf/02n.51" />
        <precipitation value="0" />
        <!-- Valid at 2014-06-12T23:00:00 -->
        <windDirection deg="238.2" code="WSW" name="West-southwest" />
        <windSpeed mps="1.5" name="Light air" />
        <temperature unit="celsius" value="17" />
        <pressure unit="hPa" value="1014.3" />
      </time>
      <time from="2014-06-13T05:00:00" to="2014-06-13T11:00:00" period="1">
        <!-- Valid from 2014-06-13T05:00:00 to 2014-06-13T11:00:00 -->
        <symbol number="1" numberEx="1" name="Clear sky" var="01d" />
        <precipitation value="0" />
        <!-- Valid at 2014-06-13T05:00:00 -->
        <windDirection deg="311.3" code="NW" name="Northwest" />
        <windSpeed mps="0.5" name="Light air" />
        <temperature unit="celsius" value="15" />
        <pressure unit="hPa" value="1013.5" />
      </time>
      <time from="2014-06-13T11:00:00" to="2014-06-13T17:00:00" period="2">
        <!-- Valid from 2014-06-13T11:00:00 to 2014-06-13T17:00:00 -->
        <symbol number="1" numberEx="1" name="Clear sky" var="01d" />
        <precipitation value="0" />
        <!-- Valid at 2014-06-13T11:00:00 -->
        <windDirection deg="214.5" code="SW" name="Southwest" />
        <windSpeed mps="2.3" name="Light breeze" />
        <temperature unit="celsius" value="24" />
        <pressure unit="hPa" value="1013.3" />
      </time>
      <time from="2014-06-13T17:00:00" to="2014-06-13T23:00:00" period="3">
        <!-- Valid from 2014-06-13T17:00:00 to 2014-06-13T23:00:00 -->
        <symbol number="1" numberEx="1" name="Clear sky" var="mf/01n.51" />
        <precipitation value="0" />
        <!-- Valid at 2014-06-13T17:00:00 -->
        <windDirection deg="232.7" code="SW" name="Southwest" />
        <windSpeed mps="4.7" name="Gentle breeze" />
        <temperature unit="celsius" value="26" />
        <pressure unit="hPa" value="1010.7" />
      </time>
    </tabular>
  </forecast>
</weatherdata>
]]

local SLAXML = require "slaxdom"
local doc = SLAXML:dom(XMLData)

local buttprint = require "buttprint"
print(buttprint.str(doc))
