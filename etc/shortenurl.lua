local json = require "json"
local urls, cb = ...

if type(urls) == "string" then
  urls = {urls}
end

assert(type(urls) == "table", "this function takes a table of URLs")

local request = {urls = urls}
local resp = httpPost("http://fgsfd.se/tzapi/shorten", json.encode(request))
local data = json.decode(resp)

local ret = {}
for i, url in ipairs(urls) do
  ret[url] = data.short[i]
  ret[i] = data.short[i]
end
return ret
