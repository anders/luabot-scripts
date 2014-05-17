
local a, b = etc.get('#infoline', arg[1] or nick)

if not a then
  return a, b or "User does not have an infoline"
end

return a
