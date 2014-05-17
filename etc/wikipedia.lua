--[[
local s = assert(arg[1], "Argument expected")
s = s:gsub("[ ]+", "_")
s = urlEncode(s)
httpGet("http://en.wikipedia.org/wiki/" .. s, function(data, err)
  if data and data:len() > 1024 * 24 then
    data = data:sub(1, 1024 * 24)
  end
  print(nick .. " * " .. html2text(getContentHtml(data or err)) )
end)
--]]

-- http://en.wikipedia.org/w/index.php?action=render&title=goat

local s = assert(arg[1], "Argument expected")
local url, extra
if s == "-random" then
  url = "http://en.wikipedia.org/w/index.php?action=render&title=Special:Random"
else
  s = s:gsub("[ ]+", "_")
  s = urlEncode(s)
  url = "http://en.wikipedia.org/w/index.php?action=render&title=" .. s
  extra = "http://en.wikipedia.org/wiki/" .. s
end
local data, typeORerr, charset, statusCode, statusDesc = httpGet(url)
if data then
  local a = data:find("<p>", 1, true)
  if a then
    data = data:sub(a)
  end
  if data:len() > 1024 * 24 then
    data = data:sub(1, 1024 * 24)
  end
end
if statusCode ~= "200" then
  return false, html2text(data or statusDesc or typeORerr or "???")
end
print(html2text(data or typeORerr))
if extra then
  etc.extra(extra)
end
