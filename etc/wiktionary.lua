-- http://en.wiktionary.org/w/index.php?action=render&title=goat

local LOG = plugin.log(_funcname);

LOG.debug("Looking up", arg[1] or "<nil>")

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
LOG.debug(statusCode, statusDesc)
if statusCode ~= "200" then
  local dymi = data:find([[<span id="did%-you%-mean">]])
  if dymi and arg[2] ~= false then
    LOG.debug("Found did-you-mean")
    local dyma = data:sub(dymi):match("<a [^>]+>(.-)</a>")
    if dyma then
      LOG.debug("Could not find did-you-mean link")
      return etc.wiktionary(dymword, false)
    end
  else
    LOG.trace("No did-you-mean")
  end
  return false, html2text(data or statusDesc or typeORerr or "???")
end
print(html2text(data or typeORerr))
if extra then
  LOG.trace("extra:", extra)
  etc.extra(extra)
end
