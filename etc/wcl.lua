-- Usage: (deprecated) reduced-functionality 'wc -l

local s = arg[1]
assert(type(s) == "string", "Expected string")
local n = 0
if #s > 0 and s:sub(#s,#s) ~= '\n' then
  n = 1
end
for nl in s:gmatch("\n") do
  n = n + 1
end
return n
