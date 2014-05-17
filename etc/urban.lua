-- Usage: 'urban - generate an urban sentence.

local url
if not arg[1] or arg[1] == "-random" then
  url = "http://www.urbandictionary.com/random.php"
else
  url = "http://www.urbandictionary.com/define.php?term=" .. urlEncode(arg[1])
end
local data, typeORerr, charset, statusCode, statusDesc = httpGet(url)
assert(data, typeORerr)

local a = data:find('<div[^>]*example[^>]*>')
if a then
  data = data:sub(a)
  local b = data:find("</div>")
  if b then
    data = data:sub(1, b - 1)
  end
end

if statusCode ~= "200" or (data or ''):find("Can you define it", 1, true) then
  return false, html2text(data or statusDesc or typeORerr or "???")
end
print(html2text(data or typeORerr))
