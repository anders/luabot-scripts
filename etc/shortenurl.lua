local urls, cb = ...

if type(urls) == "string" then
    urls = {urls}
end

assert(type(urls) == "table", "this function takes a table of URLs")

local ret = {}

for i, url in ipairs(urls) do
  ret[i], ret[url] = url, url
end

return ret
