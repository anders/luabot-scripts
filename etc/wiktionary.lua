-- http://en.wiktionary.org/w/index.php?action=render&title=goat

local s = assert(arg[1], "Argument expected")
local url, extra
if s == "-random" then
  -- url = "http://en.wiktionary.org/wiki/Special:Random"
  url = "http://en.wiktionary.org/w/index.php?action=render&title=Special:Random"
else
  s = s:gsub("[ ]+", "_")
  s = urlEncode(s)
  url = "http://en.wiktionary.org/w/index.php?action=render&title=" .. s
  extra = "http://en.wiktionary.org/wiki/" .. s
end

local data, typeORerr, charset, statusCode, statusDesc = httpGet(url)
if data then
  local a = data:find("<p>", 1, true)
  if a then
    data = data:sub(a)
  end
  local b = data:find("<strong", 1, true)
  if b then
    data = data:sub(b)
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
