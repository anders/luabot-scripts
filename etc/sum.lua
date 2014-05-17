local total = 0

for i = 1, #arg do
  local x = arg[i]
  if type(x) == "table" then
    for j = 1, #x do
      total = total + etc.sum(x[j])
    end
  elseif type(x) == "number" then
    total = total + x
  elseif type(x) == "string" then
    for y in x:gmatch("%d+") do
      total = total + tonumber(y)
    end
  end
end

return total
