local LOG = plugin.log(_funcname)
local json = require "json"
local urls, cb = ...

if type(urls) == "string" then
  urls = {urls}
end

assert(type(urls) == "table", "this function takes a table of URLs")

local request = {urls = urls}
local ok, resp = pcall(httpPost, "http://fgsfd.se/tzapi/shorten", json.encode(request))
local ret = {}

local data
LOG.debug("httpPost ok is "..tostring(ok).." and resp is "..tostring(resp))
if ok then
  ok, data = pcall(json.decode, resp)
  LOG.debug("json.decode ok is "..tostring(ok).." and data is "..tostring(data))
  if not ok then LOG.debug(data) end
end

if ok and data then
  LOG.debug("ok and data")
  for i, url in ipairs(urls) do
    ret[url] = data.short[i]
    ret[i] = data.short[i]
  end
else
  LOG.debug("not ok")
  for i, url in ipairs(urls) do
    ret[url] = url
    ret[i] = url
  end
end

return ret
