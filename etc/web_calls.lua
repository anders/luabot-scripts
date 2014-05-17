local t = {}

for i, pkgname in ipairs{"etc", "plugin"} do
  for ii, fname in ipairs(_G[pkgname].find("*", true)) do
    t[#t + 1] = { pkgname .. "." .. fname, _getCallInfo(pkgname, fname) }
  end
end

table.sort(t, function(a, b)
  local r = b[2] < a[2]
  if b[2] == a[2] then
    -- r = a[1] < b[1]
    r = b[4] < a[4]
  end
  return r
end)

Web.write("<html><body><table border='1'>")
Web.write("<thead><tr><th>Function<th>#Calls</th><th>Last Called</th></th><th>Modified time</th><th>Owner</th></tr></thead>")
local now = os.time()
for i, f in ipairs(t) do
  Web.write("<tr>")
  for j, x in ipairs(f) do
    if j >= 3 and j <= 4 then
      if x == 0 then
        x = "N/A"
      else
        x = os.date("!%Y-%m-%d %H:%M:%S", x) .. " (" .. etc.duration(now - x) .. " ago)"
      end
    elseif j == 5 then
      x = getname(x) or "N/A"
    end
    Web.write("<td>" .. x .. "</td>")
  end
  Web.write("<tr>")
end
Web.write("</table></body></html>")
