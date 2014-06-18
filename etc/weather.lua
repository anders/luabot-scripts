do return etc.wng(...) end

-- TODO:
-- accept 'weather <coords>
-- share more code with 'forecast
-- strip whitespace from query

if nick == 'dbot' or Editor then
  return
end

local cache = plugin.cache(Cache)
local json = require 'json'
local geocode = require 'geocode'
local weather = require 'weather'
local settings = plugin.settings(io)
local stringx = require 'stringx'

local CACHE_DURATION = 60 * 5
local NICK_PATTERN = '[%a%d_%-\\%[%]{}%^`|]+'

local API_KEY = 'wjz9shwya2r62q29tpqcq79r'
local API_URL = 'http://api.worldweatheronline.com/free/v1/weather.ashx'

plugin._april_fools()

local function usage()
  etc.printf('$BUsage:$B \'weather <location> (also: \'set location <your location>)')
end

local query = arg[1] and stringx.trim(arg[1]) or nil

if not query or query:match(NICK_PATTERN) and not (query and query:sub(1, 1) == '*') then
  local uvars = settings.load('uvars/'..(query or nick):lower()..'.json')
  query = uvars.location or query
end

-- strip the escape char
if query and query:sub(1, 1) == '*' then
  query = query:sub(2)
end

-- no query, and no default location set
if not query or #query < 3 then
  return usage()
end

local location, err = geocode.lookup(query)
if not location then
  if err == 'ZERO_RESULTS' then
    err = 'no results'
  end

  etc.printf('$BError:$B Unable to find location: %s', err)
  return
end

-- build a short "Town, Country" string
-- FIXME: if not available, use some other data as the place name
--        for example when looking up raw coords of some uninhabited place
local locality, country, adminArea

local function findComponent(field, ...)
  local n = select('#', ...)
  for i=1, n do
    local searchType = select(i, ...)
    for _, component in ipairs(location.address_components) do
      for _, type in ipairs(component.types) do
        if type == searchType then
          return component[field]
        end
      end
    end
  end
end

local locality = findComponent('long_name', 'locality', 'postal_town', 'route', 'establishment', 'natural_feature')
local adminArea = findComponent('short_name', 'administrative_area_level_1')
local country = findComponent('long_name', 'country') or 'Nowhereistan'

if adminArea and #adminArea <= 5 then
  if not locality then
    locality = adminArea
  else
    locality = locality..', '..adminArea
  end
end

locality = locality or 'Null'

local place = locality..', '..country

-- fetch weather information from API or cache
local latlon = location.geometry.location.lat..','..location.geometry.location.lng

local fullURL = API_URL .. '?q=' .. urlEncode(latlon) .. '&num_of_days=1&format=json&includeLocation=yes&key=' .. API_KEY

local cacheKey = 'weather_'..latlon

if cache.isCached(cacheKey) then
  cache.print(cacheKey)
  return
end

-- sleep to prevent HTTP throttling
-- sleep(2)
local data, err = httpGet(fullURL)
if not data and err then
  etc.printf('$BHTTP Error:$B %s', err)
  return
end

local parsed = assert(json.decode(data))
if parsed.data.error then
  etc.printf('$BAPI Error:$B %s', parsed.data.error[1].msg)
  return
end

local condition = parsed.data.current_condition[1]

cache.auto(cacheKey, CACHE_DURATION, function()
  local T = tonumber(condition.temp_C)
  local V = condition.windspeedKmph / 3.6 -- km/h -> m/s
  local R = tonumber(condition.humidity)
  local chillIndex = weather.windChill(T, V)
  local heatIndex = weather.heatIndex(T, R)
  local windDirection = condition.winddir16Point
  local cloudCoverage = tonumber(condition.cloudcover)
  local description = condition.weatherDesc[1].value
  local precipMM = tonumber(condition.precipMM)
  local pressure = condition.pressure
  local visibility = condition.visibility

  local s = {}

  s[#s + 1] = '\002'..place..':\002 '..T..'°C / '..math.floor(weather.c2f(T))..'°F'
  
  if T <= 10 and V >= 1 and math.abs(T - chillIndex) > 1.5 then
    -- display chill index when there is wind and the temperature is below 10°C
    -- and the difference is significant
    s[#s + 1] = (' (feels like %d°C)'):format(chillIndex)
  elseif T >= 18 and math.abs(T - heatIndex) > 1.5 then
    -- display heat index when the temperature is above 18°C and the diff is significant
    s[#s + 1] = (' (feels like %d°C)'):format(heatIndex)
  end

  s[#s + 1] = (', \002wind:\002 %.1f m/s %s,'):format(V, windDirection)
  s[#s + 1] = ' \002humidity:\002 '..R..'%,'

  if precipMM > 0 then
    s[#s + 1] = ' \002precipitation:\002 '..precipMM..' mm,'
  end

  s[#s + 1] = ' \002cloud coverage:\002 '..cloudCoverage..'%,'
  s[#s + 1] = ' \002visibility:\002 '..visibility..' km'
  --s[#s + 1] = ' \002pressure:\002 '..pressure..' hPa'
  s[#s + 1] = ' ('..description..')'
  
  print(table.concat(s, ''))
end)
