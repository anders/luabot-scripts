-- Usage: etc.collect(t, function) - where t is a collection (array, string) where each element is passed to the function and collected into the returned table.

local t = arg[1]
local func = arg[2]
assert(type(func) == "function", "Need function")
local tt = type(t)

local result = {}
if tt == "table" then
  for i = 1, #t do
    local x = func(t[i])
    if x then
      result[#result + 1] = x
    end
  end
elseif tt == "string" then
  --[[
  for i = 1, #t do
    local x = func(t:sub(i, i))
    if x then
      result[#result + 1] = x
    end
  end
  --]]
  for ch in etc.codepoints(t) do
    local x = func(ch)
    if x then
      result[#result + 1] = x
    end
  end
elseif tt == "nil" then
else
  assert("Cannot collect a " .. tt)
end
return result
