local which = ...

if tonumber(arg[2]) then
  return etc.money("" .. arg[2] .. " " .. which)
elseif type(arg[2]) == "string" then
  local a, b = arg[2]:match("(%d+) (.+)")
  if a then
    return etc.money(a .. " " .. which .. " " .. b)
  else
    return etc.money("1 " .. which .. " " .. arg[2])
  end
else
  return etc.money("1 " .. which)
end

