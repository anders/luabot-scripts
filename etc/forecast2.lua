-- Changelog:
--
-- 2012-02-08:
--   initial version based on 'weather
-- 2012-04-23:
--   metricated.. fork if you don't approve
-- 2012-05-21:
--   use aliases db, use C/F again
-- 2012-05-26:
--   fix error, fix cache (oops)
-- 2012-08-04:
--   use uvars
-- 2012-08-12:
--   request 4 days
--

local cache = plugin.cache(Cache)
local json = plugin.json()
local stringx = plugin.stringx()
local settings = plugin.settings(io)
local geocode = require 'geocode'

local CACHE_DURATION = 60 * 5
local API_KEY = 'wjz9shwya2r62q29tpqcq79r'
local API_URL = 'http://api.worldweatheronline.com/free/v1/weather.ashx'
local NICK_PATTERN = '[%a%d_%-\\%[%]{}%^`|]+'

local today = os.date('!*t')
if today.month == 4 and today.day == 1 then
  local _print = print
  function print(s)
    _print((s:gsub('[AOUEIYaoueiy]', function (c)
      if c:upper() == c then return 'O' else return 'o' end
    end)))
  end
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

local fullURL = API_URL .. '?q=' .. urlEncode(latlon) .. '&num_of_days=4&format=json&includeLocation=yes&key=' .. API_KEY

local cacheKey = 'forecast2_'..latlon

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


cache.auto(cacheKey, CACHE_DURATION, function()
  
  etc.printf('Forecast for $B%s$B:', place)
  for k, e in ipairs(parsed.data.weather) do
    etc.printf('$B%s:$B max %s°C / %s°F, min %s°C / %s°F, $Bwind speed:$B %.1f m/s %s, $Bprecipitation:$B %s mm (%s)',
      e.date, e.tempMaxC, e.tempMaxF, e.tempMinC, e.tempMinF, e.windspeedKmph / 3.6, e.winddirection, e.precipMM, e.weatherDesc[1].value)
  end

end)
