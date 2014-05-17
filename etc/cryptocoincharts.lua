-- Usage: returns the cryptocoincharts.info API data parsed from JSON. For a command to call, see 'cryptocoin

assert(not Web and not Editor, "WTF")

require "json"

local expires = 60 * 5
if Cache.cryptocoincharts and os.time() - Cache.cryptocoincharts < expires then
  local f = assert(io.open(".cryptocoincharts"))
  local j, jerr = json.parse(f:read("*a"))
  f:close()
  assert(j, jerr)
  return j
end

local data = assert(httpGet("http://www.cryptocoincharts.info/v2/api/listCoins"))

local j, jerr = json.parse(data)
assert(j, jerr)

local f = assert(io.open(".cryptocoincharts", "w"))
f:write(data)
f:close()
Cache.cryptocoincharts = os.time()

return j
