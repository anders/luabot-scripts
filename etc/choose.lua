API "1.1"
-- Usage: 'choose this or that

local a, b = (arg[1] or ''):match("^(.+) [oO][rR] (.+)$")
if b then
  if math.random(1, 2) == 1 then
    return a
  else
    return b
  end
elseif arg[1] then
  return pickone(etc.splitByPattern(arg[1], "[ ,%.!%?%|]+"))
else
  return false, 'What or what?'
end
