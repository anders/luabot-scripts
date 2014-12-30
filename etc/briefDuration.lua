local s = etc.duration(...)

return s:gsub("(%d+) *(%w+)", function(n, msg)
  if msg:sub(#msg) == "s" then
    msg = msg:sub(1, #msg - 1)
  end
  if msg == "picosecond" then
    return n .. "ps"
  elseif msg == "nanosecond" then
    return n .. "ns"
  elseif msg == "month" then
    return n .. "mo"
  else
    return n .. msg:sub(1, 1)
  end
end) or ''
