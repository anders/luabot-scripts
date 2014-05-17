local cache = plugin.cache(Cache)
local json = require 'json'

local CACHE_KEY = 'QuakeWeek'
local FEED_URL = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.geojson'

local testData = [[
{
    "type": "FeatureCollection",
    "metadata": {
        "generated": 1396099382000,
        "url": "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.geojson",
        "title": "USGS Significant Earthquakes, Past Week",
        "status": 200,
        "api": "1.0.13",
        "count": 3
    },
    "features": [{
        "type": "Feature",
        "properties": {
            "mag": 5.1,
            "place": "1km S of La Habra, California",
            "time": 1396066182010,
            "updated": 1396099252521,
            "tz": -420
        },
        "geometry": {
            "type": "Point",
            "coordinates": [-117.9435, 33.919, 7.46]
        },
        "id": "ci15481673"
   }]
}]]

cache.auto(CACHE_KEY, 3600 * 24, function()
  local respData = assert(httpGet(FEED_URL))
  
  local resp = assert(json.decode(respData))
  
  -- print(resp.metadata.title)
  
  table.sort(resp.features, function(a, b)
    return a.properties.mag > b.properties.mag
  end)
  
  for k, feat in ipairs(resp.features) do
    local prop = feat.properties
    local coords = feat.geometry.coordinates
    if feat.type == 'Feature' then
      print(('M%s - %s, depth: %s km'):format(prop.mag, prop.place, coords[3]))
    end
  end
end)
