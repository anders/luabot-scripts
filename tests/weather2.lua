-- http://www.worldweatheronline.com/weather-api.aspx
local API_KEY = '421def8533205246122501'
local API_URL = 'http://free.worldweatheronline.com/feed/weather.ashx'

local place = assert(arg[1], 'Place expected')

httpGet(API_URL .. '?q=' .. urlEncode(place) .. '&num_of_days=1&format=csv&key=' .. API_KEY, function(data, err)
  assert(data, err)

  local lines = {}
  for line in data:gmatch("[^\r\n]+") do
    if line:sub(1, 1) ~= '#' then
      lines[#lines + 1] = line
    end
  end

  -- first line:
  -- observation_time,temp_C,weatherCode,weatherIconUrl,weatherDesc,windspeedMiles,windspeedKmph,winddirDegree,winddir16Point,precipMM,humidity,visibility,pressure,cloudcover
  -- weather info (2+):
  -- date,tempMaxC,tempMaxF,tempMinC,tempMinF,windspeedMiles,windspeedKmph,winddirDegree,winddir16Point,weatherCode,weatherIconUrl,weatherDesc,precipMM
  
  local spl = {}
  for w in lines[1]:gmatch('[^,]+') do
    spl[#spl + 1] = w
  end
  local temp_C = tonumber(spl[2])
  if temp_C == nil then
    print(nick .. " * Something went wrong. " .. lines[1])
    return
  end
  local temp_F = (9/5)*temp_C+32
  local windspeedMiles = tonumber(spl[6])
  local windspeedKmph = tonumber(spl[7])
  local windspeedMs = windspeedKmph / 3.6
  local humidity = spl[11]
  print(("Temperature: %0.1f°C (%0.1f°F), wind speed: %0.1f m/s (%d mph), humidity: %s%%"):format(temp_C, temp_F, windspeedMs, windspeedMiles, humidity))
end)
