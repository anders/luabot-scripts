local result = ""

for i = 1, select('#', ...) do
  local xx = select(i, ...)
  if type(xx) == "number" then
    result = result .. string.char(xx)
  else
    for x in xx:gmatch("[^ ]+") do
      local y = tonumber(x)
      assert(y, "nan: " .. x)
      result = result .. string.char(y)
    end
  end
end

return result
