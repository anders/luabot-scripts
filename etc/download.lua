-- Usage: 'download <URL> [<path>] [<io>]
-- This function can also be called from Web and will display and process a form.

local LOG = plugin.log(_funcname);
if Web and Web.GET['trace'] then
  Output.logLevel = 'TRACE'
  LOG.trace("download trace")
end

local autoweb
if not arg[1] and Web then
  autoweb = true
  arg[1] = Web.GET['url']
  if not arg[1] or arg[1] == "" then
    Web.write("<html><body><form method=\"GET\" action=\"\">")
    Web.write("<div>URL: <input width=\"40\" name=\"url\"></div>")
    Web.write("<div><input type=\"submit\"></div>")
    Web.write("</form></body></html>")
    return
  end
end


local iarg = 1

local url = arg[iarg]
assert(type(url) == "string", "URL expected")
iarg = iarg + 1
if not url:find("://", 1, true) then
  url = "http://" .. url
end

local path
local newpath
if type(arg[iarg]) == "string" then
  path = arg[iarg]
  iarg = iarg + 1
end
if not path then
  path = url:match("[^/]+$")
  if path then
    path = path:gsub("[^%a%d_%.]", "")
    newpath = true
  end
end

local io
if type(arg[iarg]) == "table" then
  io = arg[iarg]
  iarg = iarg + 1
end
if not io then
  io = godloadstring("return io")()
end

if newpath then
  local xf = io.open(path)
  if xf then
    xf:close()
    path = nil
  end
end
if not path then
  path = "download" .. (os.time() % 0xFFF) .. math.random(0xFFF)
end

local x = assert(httpGet(url))
local f = assert(io.open(path, 'w'))
f:write(x)
local size = f:seek()
f:close()

if autoweb then
  print("Saved", path, size)
  return
end
return "Saved", path, size
