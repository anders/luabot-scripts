--[[
httpGet(assert(arg[1], "Argument expected"), function(data, err)
  print(nick .. " * " .. html2text(getContentHtml(data or err)) )
end)
--]]

local url = assert(arg[1], "Argument expected")
local data, err = httpGet(url)
data = data or err or 'ERROR'
Cache.weblen = data:len()
if data:len() > 16 * 1024 then
  local a = data:find("<[Bb][Oo][Dd][Yy]")
  if a then
    data = data:sub(a)
  end
  if data:len() > 16 * 1024 then
    data = data:sub(1, 16 * 1024)
  end
end
assert(type(data) == "string", "String expected, not " .. type(data) .. ": " .. tostring(data))
data = data:gsub("(</[dD][iI][vV]%s*>)", "%1 ")
data = getContentHtml(data)
data = html2text(data)
print(nick .. " * " .. data)
