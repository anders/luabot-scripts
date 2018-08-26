local cache = plugin.cache(Cache)

local url = 'https://www.skanetrafiken.se/handlers/LocationSearch.ashx?action=loaddeparturesfromstop&fromPointId=14300&fromPointName=R%C3%B6st%C3%A5nga+busstn&noOfRowsToFetch=10'

--[[
local cacheKey = "röstånga"

local data = cache.get(cacheKey)
if not data then
  data = assert(httpGet(url))
  cache.set(cacheKey, data, 60 * 15)
end
]]

local data = assert(httpGet(url))

local json = require "json"

local resp = json.decode(data)

local emojize = {
  Regionbuss = "🚌",
  
}

local duration = function(s)
  local s = etc.duration(s)
  s = s:gsub(" mins", "m")
  s = s:gsub(" hours", "h")
  s = s:gsub(" min", "m")
  s = s:gsub(" hour", "h")
  return s
end

for k, v in ipairs(resp.RegionsBussDepartures) do
  local h = v.DepartureTime:sub(12, 13)
  local m = v.DepartureTime:sub(15, 16)

  local lineName = v.LineName:gsub("Regionbuss", "🚌")

  print("⏰ "..h..":"..m .. " " .. lineName .. " mot " .. v.Towards .. " avgår om " .. duration(v.WaitMinutes*60) .. " från läge " .. v.StopPoint)
end
