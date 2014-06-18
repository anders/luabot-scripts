local s = assert(arg[1], "Symbol expected")
assert(s:len() <= 20, "Too many symbols specified")
local callback = arg[2] -- Optional, not cached if specified.
local flags = arg[3] or "snl1c" -- Note: depends on data source.

if not callback then

  cache = plugin.cache(Cache)
  local cachename = "sq." .. s:lower()
  if cache.isCached(cachename) then
    cache.print(cachename)
    return
  end
  
  cache.start(cachename, 5 * 60)
  
  callback = function(s, n, p, ...)
    print(s, n, '$' .. p, ...)
  end
end

local csv = plugin.csv()

-- http://www.gummy-stuff.org/Yahoo-data.htm
local data, err = httpGet("http://finance.yahoo.com/d/quotes.csv?f=" .. urlEncode(flags) .. "&s=" .. urlEncode(s))
assert(data, err)
-- print("TEST: " .. data)
local results = csv.parse(data)
for i, r in ipairs(results) do
    callback(unpack(r))
end

if cache then
  cache.stop()
end
