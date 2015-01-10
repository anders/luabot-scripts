API "1.1"

return etc.worldclock(...):gsub("(%d%d):(%d%d)", function (h, m)
  h = tonumber(h)
  if h < 12 then
    return "8" .. ("="):rep(h) .. "D"
  else
    return "C" .. ("="):rep(h - 12) .. "8"
  end
end) or ""
