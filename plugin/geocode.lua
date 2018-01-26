local cache = plugin.cache(Cache)
local json = plugin.json()

local API_URL = 'https://maps.googleapis.com/maps/api/geocode/json'
local API_KEY = etc.rot13('NVmnFlQ914bytxijRx_lGZxQ4zMIuYE85pjo6cV')

local M = {}

function M.lookup(address, options)
  options = options or {}

  if not address or type(address) ~= 'string' or address:len() < 3 then
    return false, 'invalid address'
  end
  
  local cacheKey = ('geocode2_'..address):lower()
  if cache.isCached(cacheKey) then
    return json.decode(cache.get(cacheKey))
  end
  
  options.language = options.language or 'en-GB'
  
  local params = {}
  for k, v in pairs(options) do
    params[#params + 1] = urlEncode(tostring(k))..'='..urlEncode(tostring(v))
  end
  
  params = table.concat(params, '&')
  if #params > 0 then
    params = '&'..params
  end
  
  local data, err = httpGet(API_URL .. '?key=' .. API_KEY .. '&address=' .. urlEncode(address) .. '&sensor=false' .. params)
  if not data then
    return false, err
  end
  
  local parsedData = json.decode(data)
  if parsedData.status ~= 'OK' then
    return false, parsedData.status or 'unknown API error'
  end
  
  local info = parsedData.results[1]
  cache.set(cacheKey, json.encode(info), 86400)
  return info
end

function M.simple(query, options)
  local location, e = M.lookup(query, options)
  if not location then return false, e end
  
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
  
  return place, location.geometry.location.lat..','..location.geometry.location.lng
end

return M
