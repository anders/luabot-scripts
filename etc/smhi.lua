local json = require 'json'
local url = 'http://opendata-download-metfcst.smhi.se/api/category/pmp1g/version/1/geopoint/lat/55.87/lon/12.83/data.json'
local response = httpGet(url)
local data = json.decode(response)

--[[
{	"lat": 55.906758,
	"lon": 12.889266,
	"referenceTime": "2013-11-25T07:00:00Z",
	"timeseries": [
		{
			"validTime": "2013-11-25T08:00:00Z",
			"msl": 1025.3, -- pressure, hPa
			"t": 0.2,      -- temperature, C
			"vis": 52.0,   -- visibility, km
			"wd": 348,     -- wind direction, degrees
			"ws": 3.8,     -- wind velocity, m/s
			"r": 72,       -- relative humidity, %
			"tstm": 0,     -- thunderstorm probability, %
			"tcc": 1,      -- cloud cover, eights (0-8)
			"lcc": 1,      -- cloud cover (low), eights (0-8)
			"mcc": 0,      -- cloud cover (medium), eights (0-8)
			"hcc": 0,      -- cloud cover (high), eights (0-8)
			"gust": 5.3,   -- wind gust, m/s
			"pit": 0.0,    -- precipitation intensity total, mm/h
			"pis": 0.0,    -- precipitation intensity snow, mm/h
			"pcat": 0      -- precipitation category:
                           -- 0 - none
                           -- 1 - snow
                           -- 2 - snow + rain
                           -- 3 - rain
                           -- 4 - drizzle
                           -- 5 - freezing rain
                           -- 6 - freezing drizzle
		},
    ]
}
]]

for k, row in ipairs(data.timeseries) do
  print(('\002%s:\002 %g°C, \002wind velocity:\002 %g m/s'):format(row.validTime, row.t, row.ws))
end
