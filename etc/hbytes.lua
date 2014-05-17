-- Usage: 'hbytes 7129393 gets the human-readable byte quantity of 6.8 M
-- This uses units of 1024 to be in line with: ls -lh
-- If you want units of 1000, use etc.hsize.

-- etc.calc("" .. (tonumber(arg[1]) or 0) .. " bytes")

return etc.hsize(arg[1], arg[2] or 1024)
