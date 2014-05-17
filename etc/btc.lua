
if tonumber(arg[1]) then
  return etc.money("" .. arg[1] .. " btc")
elseif type(arg[1]) == "string" then
  local a, b = arg[1]:match("(%d+) (.+)")
  if a then
    return etc.money(a .. " btc " .. b)
  else
    return etc.money("1 btc " .. arg[1])
  end
else
  return etc.money("1 btc")
end
