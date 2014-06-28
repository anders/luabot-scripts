API "1.2"

local s = arg[1] or etc.tz() or etc.tz("UTC")

-- s = s:gsub("DST", etc.er("daylight savings time"))
return s:gsub("(%d%d?):(%d%d):?(%d?%d?)", function(h, m, s)
  if h == "12" and (m == "00" or m == "0") then
    return etc.capwords("noon")
  end
  if m == "00" or m == "0" then
    return etc.capwords(etc.numberToWords(h) .. " o'clock")
  end
  local hn = tonumber(h)
  local ampm
  if hn > 12 then
    hn = hn - 12
    ampm = "PM"
  end
  local mprefix = ""
  if tonumber(m) < 10 then
    mprefix = "Oh-"
  end
  return etc.capwords(
    etc.numberToWords(hn)
      .. " " .. mprefix .. etc.numberToWords(m)
    ) .. (ampm and (" " .. ampm) or "")
end) or ""
