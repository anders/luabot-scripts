-- FIXME: html escape
local function htmlEscape(s)
  return (s:gsub('&', '&amp;'))
end

if not Web then
  return boturl..'u/'..getname(owner())..'/scripts.lua'
end

if Web.GET['mod'] and Web.GET['fun'] then
  local mod, fun = Web.GET.mod, Web.GET.fun
  Web.header('Content-Type: text/plain')
  local f = assert(io.open('/pub/scripts/'..mod:match('[^/%.]+')..'/'..fun:match('[^/%.]+')..'.lua'))
  local data = f:read('*a')
  f:close()
  data = data:gsub('\r\n', '\n')
  Web.write(data)
  
  -- add trailing \n if missing
  if data:sub(-1) ~= "\n" then Web.write("\n") end
  return
end

if not Web.GET.json then
  Web.write([[<!DOCTYPE html>
  <html>
  <head>
      <title>List of scripts</title>
  </head>
  <body>]])
end

local outt = {}

for _, mod in ipairs{'etc', 'plugin', 'util', 'tests'} do
  if not Web.GET.json then
    Web.write('<h2>'..mod..'</h2>')
    Web.write('<table border="1" width="100%">')
    Web.write('<tr><th>Name</th><th>Owner</th><th>Raw</th></tr>')
  end
  
  outt[mod] = outt[mod] or {}
  
  local funcs = _G[mod].find('*', true)
  
  for i, f in ipairs(funcs) do
    local url = boturl..'t/view?module='..urlEncode(mod)..'&name='..urlEncode(f)
    local dunno, dunno, mtime, ownerid = _getCallInfo(mod, f)
    local raw = 'scripts.lua?mod='..mod..'&fun='..f
    if not Web.GET.json then
      Web.write('<tr>')
      Web.write('<td><a href="'..url..'">'..f..'</a></td>')
      Web.write('<td>'..getname(ownerid)..'</td>')
      Web.write('<td><a href="'..htmlEscape(raw)..'">src</a></td>')
      Web.write('</tr>')
    else
      outt[mod][f] = {
        owner = getname(ownerid),
        url = boturl..'u/anders/'..raw,
        mtime = mtime,
        uid = ownerid,
      }
    end
  end
  
  if not Web.GET.json then
    Web.write('</table>')
  end
end

if not Web.GET.json then
  Web.write([[</body>
  </html>]])
else
  local json = require 'json'
  Web.write(json.encode(outt))
end
