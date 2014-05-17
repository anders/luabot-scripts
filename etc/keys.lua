assert(type(arg[1]) == 'table', 'expected table')
local t = {}
for k in pairs(arg[1]) do
  t[#t+1]=tostring(k)
end
return t