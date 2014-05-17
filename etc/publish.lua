assert(Web, "etc.publish must be called from the web")

local io = godloadstring("return io")()

if Web.data == nil or Web.data == "" then
    Web.write("<html><body><form method=\"POST\" action=\"\">")
    Web.write("<div>File: <input name=\"f\"></div>")
    Web.write("<div>Contents:<div><textarea cols=\"80\" rows=\"20\" name=\"x\"></textarea></div></div>")
    Web.write("<div><input type=\"submit\"></div>")
    Web.write("</form></body></html>")
    return
end

local t = {}
for x, y in Web.data:gmatch("([^=&]+)=?([^&]*)") do
  t[urlDecode(x)] = urlDecode(y)
end

local fp = arg[1] or t.f
local data = t.x

if not fp or fp == "" or not data then
  error("Invalid file or data")
end

local f = io.open(fp, 'r')
if f then
  f:close()
  error("File already exists, cannot overwrite")
end

f = assert(io.open(fp, 'w'))

f:write(data)

f:close()

print("Done")
--[[
print("----")
Web.write(Web.data:gsub("[&<]", function(x)
  if x == '&' then
    return "&amp;"
  elseif x == '<' then
    return "&lt;"
  end
end))
--]]