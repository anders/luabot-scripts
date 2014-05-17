local assume = arg[1]
local userinput = arg[2]
if tonumber(userinput) then
  return etc.money("" .. userinput .. " " .. assume)
elseif type(userinput) == "string" then
  local a, b = userinput:match("(%d+) (.+)")
  if a then
    return etc.money(a .. " " .. assume .. " " .. b)
  else
    return etc.money("1 " .. assume .. " " .. userinput)
  end
else
  return etc.money("1 " .. assume)
end
