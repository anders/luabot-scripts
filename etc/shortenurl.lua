--[===[ NEED HTTPS
local json = plugin.json()

local urls, callback = arg[1], arg[2]

if not urls then
  error('Expected a table of Earls or an Earl string')
end

if type(urls) == 'string' then
  urls = {urls}
end

if type(urls) ~= 'table' then
  error('Expected table/string, not '..type(urls))
end

assert(#urls >= 1, 'Expected at least one Earl')

local function shorten(url)
  local postData = json.encode{longUrl = url}
  local response = assert(httpPost('http://www.googleapis.com/urlshortener/v1/url', postData))
  local parsed = assert(json.decode(response))
  return parsed.id
end

local ret = {}
for k, v in ipairs(urls) do
  ret[#ret + 1] = {
    url = v,
    short = shorten(v)
  }
end
return ret
--]===]

local url, cb = arg[1], arg[2]

if not url then
  error("need URL table arg or 1 URL string")
end

if type(url) == 'string' then
  url = {url}
end
assert(#url > 0, 'need table of URLs')

local API_URL = 'http://users.fgsfd.se/anders/short.php'

local tmp = {}
for i=1, #url do
  tmp[#tmp+1] = 'url'..i..'='..urlEncode(url[i])
end

local tmpURL = API_URL..'?n='..#url
local data, err = httpPost(tmpURL, table.concat(tmp, '&'))
if not data and err then
  print("Error: "..err)
  halt()
end
local json = plugin.json()
local parsed = json.decode(data)

if cb then
  cb(parsed)
else
  return parsed
end


--[[
local json = plugin.json()

local urls, callback = arg[1], arg[2]

if not urls then
  error('Expected a table of Earls or an Earl string')
end

if type(urls) == 'string' then
  urls = {urls}
end

if type(urls) ~= 'table' then
  error('Expected table/string, not '..type(urls))
end

assert(#urls >= 1, 'Expected at least one Earl')

local function shorten(url)
  local postData = json.encode{longUrl = url}
  local response = assert(httpPost('http://www.googleapis.com/urlshortener/v1/url', postData))
  local parsed = assert(json.decode(response))
  return parsed.id
end

print(shorten('http://google.com'))
]]