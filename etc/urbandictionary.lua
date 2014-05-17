assert(type(arg[1]) == "string", "Expected search term")
local url
local extra
if arg[1] == "-random" then
  url = "http://www.urbandictionary.com/random.php"
else
  url = "http://www.urbandictionary.com/define.php?term=" .. urlEncode(arg[1])
  extra = url
end
local data, typeORerr, charset, statusCode, statusDesc = httpGet(url)
assert(data, typeORerr)

local a = data:find('<div[^>]*content[^>]*>')
if a then
  data = data:sub(a)
end

if statusCode ~= "200" or (data or ''):find("Can you define it", 1, true) then
  return false, html2text(data or statusDesc or typeORerr or "???")
end
print(html2text(data or typeORerr))
if extra then
  etc.extra(extra)
end
