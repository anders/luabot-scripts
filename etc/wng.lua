if Web then return end

require("spam").detect(Cache, "weather", 4, 10)

-- plugin._april_fools()

local json = require 'json'
local weather = require 'weather'
local geocode = require 'geocode'
local locale = require 'locale'
local cache = plugin.cache(Cache)

local CACHE_DURATION = 60 * 5

local function round(n)
  return math.floor(n + 0.5)
end

local function urlencode(s)
  if type(s) == 'table' then
    local buf = {}
    for k, v in pairs(s) do
      buf[#buf + 1] = urlEncode(tostring(k))..'='..urlEncode(tostring(v))
    end
    return table.concat(buf, '&')
  else
    return urlEncode(s)
  end
end

local query, forecast = ...

query = etc.get('location', query) or query or etc.get('location', nick)

if not query then
  return false, "Please set your location using "..etc.cmdchar.."set location <your location>."
end

local place, coords = geocode.simple(query)
if not place then
  print('\002Error:\002 Geocode error: '..coords)
  return
end

local function WorldWeatherOnline(coords)
  -- local API_KEY = 'kxz3zwcq55a7rkb48tqxjh9e' -- premium
  local API_KEY = 'wjz9shwya2r62q29tpqcq79r' -- free
  local API_URL = 'http://api.worldweatheronline.com/free/v1/weather.ashx'
  
  local params = {
    -- required
    q = coords,
    num_of_days = 5,
    key = API_KEY,
    
    -- optional
    --extra = '',
    --date = '',
    --fx = '',
    --cc = '',
    --includeLocation = '',
    format = 'json',
    --show_comments = '',
    --callback = ''
  }

  local finalURL = API_URL..'?'..urlencode(params)
  -- print(finalURL)
  local jsonData = assert(httpGet(finalURL))

  if #jsonData == 0 then
    print('\002Error:\002 no weather data received from API')
    halt()
  end
  
  local weatherData = assert(json.decode(jsonData))
  if not weatherData.data.current_condition then
    print('\002Error:\002 insufficient result from weather API')
    halt()
  end
  
  return weatherData
end

local _, user_cc_locale = locale.parse(etc.get('locale', nick) or 'en_SE')

-- this is terrible
local cacheKey = (forecast and 'forecast' or 'weather') 
                  .. user_cc_locale.measurement 
                  .. coords

if cache.isCached(cacheKey) then
  cache.print(cacheKey)
  return
end

local function reekize(s)
  if true or user_cc_locale.measurement == 'US' then
    return (s:gsub('(%-?%d+)°C', function(T)
      return T..'°C / '..round(weather.c2f(T))..'°F'
    end))
  else
    return s
  end
end

local function addDayOfWeek(date)
  -- date is YYYY-mm-dd
  local year, month, day = date:sub(1, 4), date:sub(6, 7), date:sub(9, 10)
  year, month, day = tonumber(year), tonumber(month), tonumber(day)
  local d = os.date("*t", os.time{year=year, month=month, day=day, hour=0, min=0, sec=0})
  local days = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}
  return date.." ("..days[d.wday]..")"
end

local weatherData = WorldWeatherOnline(coords)

local function trim(s)
  return (s:gsub("^%s*", ""):gsub("%s*$", ""))
end

cache.auto(cacheKey, CACHE_DURATION, function()
  if not forecast then
    local cur = weatherData.data.current_condition[1]
    
    local T = tonumber(cur.temp_C)
    local Tf = weather.c2f(T)
    local Vkm = cur.windspeedKmph
    local V = Vkm / 3.6 -- km/h -> m/s
    local R = tonumber(cur.humidity)

    
    local cloudCoverage = tonumber(cur.cloudcover)
    local description = cur.weatherDesc[1].value
    local precipMM = tonumber(cur.precipMM)
    local visibility = cur.visibility
    local winddirDegree = math.floor(cur.winddirDegree/10+0.5)*10
    
    local chillIndex = weather.windChill(T, V)
    local heatIndex = weather.heatIndex(T, R)
    
    local tmp = {}
    tmp[#tmp + 1] = ('\002%s:\002 %d°C'):format(place, T)

    local perceived = (T <= 10 and V >= 1 and math.abs(T - chillIndex) > 1.5) and chillIndex or
                      (T >= 27 and R >= 40 and math.abs(T - heatIndex) > 1.5) and heatIndex
    
    if perceived then
      tmp[#tmp + 1] = (' (feels like %d°C)'):format(round(perceived))
    end
    local ms = round(V)
    if ms >= 0.001 then
      tmp[#tmp + 1] = (', \002wind:\002 %d m/s,'):format(ms)
    end
    if R >= 0.001 then
      tmp[#tmp + 1] = (' \002humidity:\002 %d%%,'):format(R)
    end
    local pmm = round(precipMM)
    if pmm >= 0.001 then
      tmp[#tmp + 1] = (' \002precipitation:\002 %d mm,'):format(pmm)
    end
    tmp[#tmp + 1] = (' \002cloud coverage:\002 %d%%'):format(cloudCoverage)
    tmp[#tmp + 1] = (' (%s)'):format(trim(description))
    
    print(reekize(table.concat(tmp)))
  else
    if not etc.get('fourcast', nick) then
      print(('Forecast for \002%s:\002'):format(place))
    end
    
    for k, v in ipairs(weatherData.data.weather) do
      local tmp = {}
      local winddirDegree = math.floor(v.winddirDegree/10+0.5)*10
      
      tmp[#tmp + 1] = ('\002%s:\002'):format(addDayOfWeek(v.date))
      tmp[#tmp + 1] = (' max: %d°C,'):format(v.tempMaxC)
      tmp[#tmp + 1] = (' min: %d°C,'):format(v.tempMinC)
      
      local ms = round(v.windspeedKmph / 3.6)
      if ms >= 0.001 then
        tmp[#tmp + 1] = (' \002wind:\002 %d m/s,'):format(ms)
      end
      local pmm = round(v.precipMM)
      if pmm >= 0.001 then
        tmp[#tmp + 1] = (' \002precipitation:\002 %d mm'):format(pmm)
      end
      tmp[#tmp + 1] = (' (%s)'):format(trim(v.weatherDesc[1].value))
  
      print(reekize(table.concat(tmp)))
    end
  end
end)
