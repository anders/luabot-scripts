API "1.1"
-- Usage: util.collect(t, function(x) return x.foo end) - return a table of x.foo's [collection]

local collection, callback = ...

local result = {}
for i = 1, #collection do
  local x = callback(collection[i])
  if x ~= nil then
    result[#result + 1] = x
  end
end
return result
