if type(arg[1]) ~= "table" or not arg[1].GET then
  error("Argument expected")
end

local Web = arg[1]
local fs

local p = Web.GET["p"]
local u = Web.GET["u"]

if u and u ~= "" then
  fs = getUserFS(u)
end

if p and p ~= ""  then
  u, p = p:match("^/user/([^/]+)(/?.*)")
  if u then
    fs = getUserFS(u)
  end
end

if not p or p == "" then
  p = "/"
end

if not fs then
  Web.write([==[
  <form action="">
  User: <input name="u"><input type="submit">
  <form>
  ]==])
  
  return
end

assert(fs, "Invalid user")

local attr = fs.attributes(p)
if attr and attr.mode == 'file' then
  local f = io.open(p, 'r') -- should be: fs.open
  Web.header('Content-Type: text/plain')
  Web.write(f:read('*a'))
  f:close()
  return
end

Web.write([==[<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Index of /~to-be/filled-in/</title>
<style type="text/css">
a, a:active {text-decoration: none; color: blue;}
a:visited {color: #48468F;}
a:hover, a:focus {text-decoration: underline; color: red;}
body {background-color: #F5F5F5;}
h2 {margin-bottom: 12px;}
table {margin-left: 12px;}
th, td { font: 90% monospace; text-align: left;}
th { font-weight: bold; padding-right: 14px; padding-bottom: 3px;}
td {padding-right: 14px;}
td.s, th.s {text-align: right;}
div.list { background-color: white; border-top: 1px solid #646464; border-bottom: 1px solid #646464; padding-top: 10px; padding-bottom: 14px;}
div.foot { font: 90% monospace; color: #787878; padding-top: 4px;}
</style>
</head>
<body>]==])

local function fixText(s)
  return s:gsub("[&<>\"']", function(x)
    if x == '&' then
      return "&amp;"
    elseif x == '<' then
      return "&lt;"
    elseif x == '>' then
      return "&gt;"
    elseif x == '"' then
      return "&quot;"
    elseif x == "'" then
      return "&squot;"
    end
  end)
end

Web.write("<h3 id=\"dirname\">Index of /user/" .. u .. p .. "</h3>\n")
Web.write[[
<div class="list">
<table summary="Directory Listing" cellpadding="0" cellspacing="0">
<thead><tr><th class="n">Name</th><th class="m">Last Modified</th><th class="s">Size</th><th class="t">Type</th></tr></thead>
<tbody>
]]

--[[<tr><td class="n"><a href="0/">0</a>/</td><td class="m">2011-Feb-28 20:38:14</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="1/">1</a>/</td><td class="m">2011-Feb-28 20:38:14</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="2/">2</a>/</td><td class="m">2011-Feb-28 20:38:14</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="3/">3</a>/</td><td class="m">2011-Feb-28 20:38:14</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="0.png">0.png</a></td><td class="m">2011-Feb-28 20:38:14</td><td class="s">2.1K</td><td class="t">image/png</td></tr>
<tr><td class="n"><a href="1.png">1.png</a></td><td class="m">2011-Feb-28 20:38:14</td><td class="s">1.4K</td><td class="t">image/png</td></tr>
<tr><td class="n"><a href="2.png">2.png</a></td><td class="m">2011-Feb-28 20:38:14</td><td class="s">0.6K</td><td class="t">image/png</td></tr>
<tr><td class="n"><a href="3.png">3.png</a></td><td class="m">2011-Feb-28 20:38:14</td><td class="s">1.0K</td><td class="t">image/png</td></tr>

<tr><td class="n"><a href="pigmap-default.html">pigmap-default.html</a></td><td class="m">2011-Feb-28 20:38:15</td><td class="s">5.6K</td><td class="t">text/html</td></tr>
<tr><td class="n"><a href="pigmap.params">pigmap.params</a></td><td class="m">2011-Feb-28 20:38:15</td><td class="s">0.1K</td><td class="t">application/octet-stream</td></tr>
<tr><td class="n"><a href="style.css">style.css</a></td><td class="m">2011-Feb-28 20:38:15</td><td class="s">0.3K</td><td class="t">text/css</td></tr>
]]



do
  local up = ""
  local a, b = ("/user/" .. u .. p):match("^(.*)/[^/]+/?$")
  if a and a ~= "" and a ~= "/user" then
    up = fixText(a)
  end
  up = urlEncode(up):gsub("%%2F", "/")
  Web.write('<tr><td class="n"><a href="?p='..up..'">Parent Directory</a>/</td><td class="m">&nbsp;</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>')
end

local function humansize(size)
  if size == 0 then return '- &nbsp;' end
  local suffixes = {'b', 'KiB', 'MiB', 'GiB', 'TiB'}
  local i = math.floor(math.log(size) / math.log(1024))
  if i == 0 then
    return size..' '..suffixes[1]
  end
  return ('%.1f %s'):format(size / 1024^i, suffixes[i + 1])
end

local ntotal = 0
fs.list(p, function(path, attribs)
  local name = path:match("/([^/]+)$")
  if not name then
    name = path
  end
  local attr = fs.attributes(path) or {}
  local date = attr.modification and os.date('%Y-%m-%d %H:%M:%S', attr.modification) or '-'
  local ul = urlEncode("/user/" .. u .. path):gsub("%%2F", "/")
  
  if attr.mode == 'directory' then
    Web.write('<tr><td class="n"><a href="?p='..ul..'">'..fixText(name)..'</a>/</td><td class="m">'..date..'</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>')
  else
    Web.write('<tr><td class="n"><a href="?p='..ul..'">'..fixText(name)..'</a></td><td class="m">'..date..'</td><td class="s">'..humansize(attr.size)..'</td><td class="t">File</td></tr>')
  end

  ntotal = ntotal + 1
end, "a")

Web.write([==[
</tbody>
</table>
</div>
<div class="foot">dbot/ZUU999999999</div>
</body>
</html>
]==])

