API "1.1"

local s = assert(arg[1], "Argument expected")
local xurl = "http://svd".."ictionary.com/"
local url, extra
local contentStart
if s == "-random" then
  -- local a, b = etc.randomDefinition()
  -- s = b:match("%w+") -- first word of a random definition
  -- s = urlEncode(s)
  url = xurl .. "random"
  contentStart = "<h1>"
else
  s = s:gsub("[ ]+", "_")
  s = urlEncode(s)
  url = xurl .. "search/?q=" .. s
  extra = url
  contentStart = [[<div class="definition-inner]]
end
local data, typeORerr, charset, statusCode, statusDesc = httpGet(url)
if data then
  local a = data:find(contentStart, 1, true)
  if a then
    data = data:sub(a)
  end
  if data:len() > 1024 * 24 then
    data = data:sub(1, 1024 * 24)
  end
end
data = data:gsub([[<span class="count">%d+</span>]], " ")
data = data:gsub("<p>", " <p>")
data = data:gsub("<(h[12])>", "<%1>\002")
data = data:gsub("</(h[12])>", "\002</%1>")
if statusCode ~= "200" then
  return false, html2text(data or statusDesc or typeORerr or "???")
end
print(html2text(data or typeORerr))
if extra then
  etc.extra(extra)
end
