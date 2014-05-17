-- U+200B, ZERO WIDTH SPACE:
local s = arg[1] or ''
local nl = arg[2] -- nicklist
local zwsp = arg[3] or "\226\128\139"

if type(nl) == "string" then
  nl = nicklist(nl)
elseif not nl then
  nl = nicklist()
end
nl = nl or {}

local nlkeys = {}
for i = 1, #nl do
  nlkeys[nl[i]:lower()] = true
end
nlkeys[nick:lower()] = true

return etc.translateWords(s, function(x)
  if nlkeys[x:lower()] then
    return x:sub(1, 1) .. zwsp .. x:sub(2)
  end
end, nil, true)
