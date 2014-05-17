local t = {}

for i = 1, select('#', ...) do
  local xx = select(i, ...)
  if type(xx) == "number" then
    table.insert(t, string.format("%X", xx))
  else
    local any = false
    for x in xx:gmatch("[^ ]+") do
      local n = tonumber(x)
      if n then
        table.insert(t, string.format("%X", tonumber(x)))
      else
        table.insert(t, "nil")
      end
      any = true
    end
    if not any then
      table.insert(t, "nil")
    end
  end
end

return unpack(t)
