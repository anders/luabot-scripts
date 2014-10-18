API "1.1"
-- Usage: util.collectMap(map, function(k, v) return k, v.foo end) - return a table of k key and v.foo value [collection]

local collection, callback = ...

local result = {}
for k, v in pairs(collection) do
  local x, y = callback(k, v)
  if x ~= nil then
    result[x] = y
  end
end
return result
