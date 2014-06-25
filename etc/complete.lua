API "1.1"

local json = require "json"

local query = assert(arg[1], "need a query")

local URL = "http://www.google.com/complete/search?client=serp&hl=en&xhr=t&q="..urlEncode(query)
local response = assert(httpGet(URL))


local d = assert(json.decode(response))

local out = {}

for k, v in ipairs(d[2]) do
  local completion = v[1]:gsub("<.->", "")
  out[#out + 1] = html2text(completion).."?"
end

return #out > 0 and table.concat(out, " ") or (query.." "..etc.getOutput(etc.k).."?")

--[[

d[1] = query
d[2] = {
  {"blah blah", 0, [{1, 2}]},
  {"blah blah", ...},
}
d[3] = {q = some bullshit, j = some bullshit}

]]
