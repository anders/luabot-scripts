-- alias:  'wq

local url = "http://en.wikiquote.org/wiki/Special:Random"
if arg[1] then
  local s = arg[1]
  s = s:gsub("[ ]+", "_")
  s = urlEncode(s)
  url = "http://en.wikiquote.org/wiki/" .. s
end

local html = assert(httpGet(url))

if html:len() > 1024 * 12 then
  html = html:sub(1, 1024 * 12)
end

local x, y = html:find(">Sourced</span>", 1, true)
if y then
  html = html:sub(y + 1)
else
  html = getContentHtml(html)
end

print(html2text(html))
