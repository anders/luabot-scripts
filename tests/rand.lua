local w, h = 128, 128

Web.header("Content-Type: image/x-portable-bitmap")
Web.write("P1\n")
Web.write(w.." "..h.."\n")
for y=1, h do
  local row = {}
  for x=1, w do
    row[x] = tostring(math.random(0, 1))
  end
  Web.write(table.concat(row, " ").."\n")
end
