API "1.1"

-- pnmtopng

local w, h = 128, 128
local maxcolor = 8

local t = {}
for y=1, h do
  for x=1, w do
    local i = math.random(w * h)
    t[i] = (t[i] or 0) + 1
  end
end

Web.header("Content-Type: image/x-portable-bitmap")
Web.header("Content-Disposition: attachment; filename=\"" .. _funcname .. ".pnm\"")
Web.write("P2\n")
Web.write(w.." "..h.." "..maxcolor.."\n")
local startcolor = math.floor(maxcolor / 2)
local step = math.max(math.floor(maxcolor / 4), 1)
for y=1, h do
  local row = {}
  for x=1, w do
    local p = t[(y - 1) * w + x]
    if p then
      row[x] = tostring(maxcolor - math.min(p * step + startcolor, maxcolor))
    else
      row[x] = tostring(maxcolor)
    end
  end
  Web.write(table.concat(row, " ").."\n")
end

