local rand = arg[2]
if not rand then
  rand = math.random
end
local x = arg[1]
if type(x) == "table" then
  for i = 1, #x do
    local r = rand(#x)
    x[i], x[r] = x[r], x[i]
  end
  return x
elseif type(x) == "string" then
  local t = {}
  for i = 1, x:len() do
    table.insert(t, x:sub(i, i))
  end
  local y = etc.randomize(t, rand)
  return table.concat(y)
end
return ...
