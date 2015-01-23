-- U+200B, ZERO WIDTH SPACE: "\226\128\139"
-- "\226\128\142" -- LTR
local s = arg[1] or ''
local nl = arg[2] -- nicklist

local noalert
if type(arg[3]) == "string" then
  noalert = function() return arg[3] end
elseif type(arg[3]) == "function" then
  noalert = arg[3]
else
  noalert = function(x)
    return x:sub(1, #x - 1) .. etc.wide(x:sub(#x))
  end
end



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
    return noalert(x)
  end
end, nil, true)
