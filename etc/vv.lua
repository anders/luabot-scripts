API "1.1"

local geocode = require "geocode"
local json = require "json"

local site = "http://api.openweathermap.org"
local appID = etc.rot13 "n922227733so47927r1093sposq5n1ps"

local query = ...

query = etc.get("location", query) or query or etc.get("location", nick)

if not query then
  return false, "Please set your location using "..etc.cmdchar.."set location <your location>."
end

local place, coords = geocode.simple(query)
if not place then
  print("\2Error:\2 Geocode error: "..coords)
  return
end

local function latlon(coords)
  return coords:match("([%d%.]+),([%d%.]+)")
end

local lat, lon = latlon(coords)

local function urlencode(s)
  if type(s) == 'table' then
    local buf = {}
    for k, v in pairs(s) do
      buf[#buf + 1] = urlEncode(tostring(k))..'='..urlEncode(tostring(v))
    end
    return table.concat(buf, '&')
  end
  
  return urlEncode(s)
end

local function weather(lat, lon)
  local url = site.."/data/2.5/weather?"..urlencode{lat=lat, lon=lon, appid=appID}
  
  local resp, err = httpGet(url)
  if not resp then
    return false, err
  end
  
  local t, err = json.decode(resp)
  if not t then
    return false, err
  end
  
  if t.cod ~= 200 then
    return false, "cod ~= 200: "..t.cod
  end
  
  --[[
  <luabot> Ulm, BW, Germany: 27°C / 81°F, wind: 1 m/s, humidity: 47%, precipitation: 1 mm, cloud coverage: 16% (Sunny)
  ]]
  
  local s = "\2"..t.name..", "..t.sys.country..":\2 "
  local buf = {}
  buf[#buf + 1] = (t.main.temp - 273.15).."°C"
  buf[#buf + 1] = "\2wind:\2 "..t.wind.speed.." m/s"
  s = s..table.concat(buf, ", ")
  s = s.." ("..t.weather[1].main..")"
  return s
end

return assert(weather(lat, lon))
