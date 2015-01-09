local t = {}

for i, pkgname in ipairs{"etc", "plugin"} do
  for ii, fname in ipairs(_G[pkgname].find("*", true)) do
    t[#t + 1] = { pkgname .. "." .. fname, _getCallInfo(pkgname, fname) }
  end
end

local sort_whut = tonumber(Web.GET.sort) or 2
local sort_desc = Web.GET.desc == "true" and true or false

table.sort(t, function(a, b)
  assert(b[sort_whut], "Invalid sort field")
  if sort_desc then b, a = a, b end
  local r = b[sort_whut] < a[sort_whut]
  if b[sort_whut] == a[sort_whut] then
    r = b[4] < a[4] -- fall back to mtime
  end
  return r
end)

Web.write('<html><body><table border="1">')
Web.write('<thead><tr>')
Web.write('<th><a href="?sort=1&desc='..tostring(not sort_desc)..'">Function</a></th>')
Web.write('<th><a href="?sort=2&desc='..tostring(not sort_desc)..'">#Calls</a></th>')
Web.write('<th><a href="?sort=3&desc='..tostring(not sort_desc)..'">Last Called</a></th>')
Web.write('<th><a href="?sort=4&desc='..tostring(not sort_desc)..'">Modified time</a></th>')
Web.write('<th><a href="?sort=5&desc='..tostring(not sort_desc)..'">Owner</a></th>')
Web.write('</tr></thead>')

local now = os.time()
for i, f in ipairs(t) do
  Web.write("<tr>")
  for j, x in ipairs(f) do
    if j >= 3 and j <= 4 then
      if x == 0 then
        x = "N/A"
      else
        if not Web.GET.t then
          x = os.date("!%Y-%m-%d %H:%M:%S", x) .. " (" .. etc.duration(now - x) .. " ago)"
        end
      end
    elseif j == 5 then
      x = getname(x) or "N/A"
    end
    Web.write("<td>" .. x .. "</td>")
  end
  Web.write("<tr>")
end
Web.write("</table></body></html>")
