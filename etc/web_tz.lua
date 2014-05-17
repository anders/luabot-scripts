if not Web then print(boturl..'u/anders/tz.lua?chan='..urlEncode(chan or '#clowngames')) return end

local chan = Web.GET.chan or '#clowngames'

local header_template = [[
<!DOCTYPE html>
<html>
<head>
<title>TZ in %chan%</title>
</head>
<body>
<table>
<tr>
<th>Nick</th>
<th>Time zone</th>
<th>Current date and time</th>
</tr>
]]

-- FIXME: is this enough?
local function htmlescape(s)
  s = s:gsub('&', '&amp;')
  s = s:gsub('<', '&lt;')
  s = s:gsub('>', '&gt;')
  return s
end

local function template(tmpl, vars)
  return (tmpl:gsub('%%([^%%]+)%%', function(s)
    return vars[s] or '&lt;unknown var '..s..'&gt;'
  end))
end

Web.write(template(header_template, {chan = chan}))

local rows = {}

for k, v in ipairs(nicklist(chan)) do
  local usertz = etc.getOutput(etc.tz, v)
  if not usertz:find('Unknown timez') then
    local zone, date = usertz:match('([^:]+): (.+)')
    rows[#rows + 1] = {nick=v, zone=zone, date=date}
  end
end

table.sort(rows, function(a, b)
  return a.date < b.date
end)

for i, v in ipairs(rows) do
  Web.write(template('<tr><td>%nick%</td><td>%zone%</td><td>%date%</td></tr>', v))
end

Web.write[[
</table>
</body>
</html>
]]