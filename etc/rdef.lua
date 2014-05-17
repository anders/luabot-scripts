-- Return a random definition near preferred length.

local a, b = etc.randomDefinition(nil, 3)

if a then
  return a .. " - " .. b
end
return a, b
