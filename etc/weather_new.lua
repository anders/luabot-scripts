API "1.1"

-- http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139

local geocode = require "geocode"
local json = require "json"
local weather = require "weather"

local function round(n)
  return math.floor(n + 0.5)
end

local query, forecast = ...

query = etc.get("location", query) or query or etc.get("location", nick)

if not query then
  return false, "Please set your location using 'set location place."
end

local place, coords = geocode.simple(query)
if not place then
  return false, "geocode error: "..coords
end

local lat, lon = coords:match("([^,]+),(.+)")

local data = httpGet("http://api.openweathermap.org/data/2.5/weather?lat="..lat.."&lon="..lon)

lat, lon = tonumber(lat), tonumber(lon)

local j = assert(json.parse(data))

local T = j.main.temp - 273.15
local Tf = weather.c2f(T)
local V = j.wind.speed
local R = j.main.humidity

local chillIndex = weather.windChill(T, V)
local heatIndex = weather.heatIndex(T, R)

local tmp = {}
tmp[#tmp + 1] = ("\002%s:\002 %d°C / %d°F"):format(place, T, Tf)

local perceived = (T <= 10 and V >= 1 and math.abs(T - chillIndex) > 1.5) and chillIndex or
                  (T >= 18 and math.abs(T - heatIndex) > 1.5) and heatIndex

if perceived then
  tmp[#tmp + 1] = (" (feels like %d°C / %d°F)"):format(round(perceived), round(weather.c2f(perceived)))
end
   
tmp[#tmp + 1] = (", \002wind:\002 %d m/s"):format(round(V))

return table.concat(tmp)

--[[
{
  "coord":
  {
    "lon": 139,
    "lat": 35
  },
  "sys":
  {
    "message": 0.2129,
    "country": "JP",
    "sunrise": 1404502536,
    "sunset": 1404554497
  },
  "weather": [
  {
    "id": 804,
    "main": "Clouds",
    "description": "overcast clouds",
    "icon": "04n"
  }],
  "base": "cmc stations",
  "main":
  {
    "temp": 293.053,
    "temp_min": 293.053,
    "temp_max": 293.053,
    "pressure": 981.9,
    "sea_level": 1024.55,
    "grnd_level": 981.9,
    "humidity": 97
  },
  "wind":
  {
    "speed": 1.41,
    "deg": 70.5023
  },
  "rain":
  {
    "3h": 0
  },
  "clouds":
  {
    "all": 92
  },
  "dt": 1404563808,
  "id": 1851632,
  "name": "Shuzenji",
  "cod": 200
}
]]


