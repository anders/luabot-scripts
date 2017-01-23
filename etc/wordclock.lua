API "1.1"

return etc.worldclock(...):gsub("(%d%d):(%d%d)", function (h, m)
  local suff = etc.numberToWords(m)
  if suff == "zero" then
    suff = "o'clock"
  elseif tonumber(m) < 10 then
    suff = "o'" .. suff
  end
  return etc.numberToWords(h) .. " " .. suff
end) or ""
