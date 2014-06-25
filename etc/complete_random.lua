API "1.1"

local x, y = etc.randomDefinition()
local look
local n = 0
local maxn = math.random(1, 3)
etc.translateWords(y or '', function(w)
  if n < maxn then
    n = n + 1
    if look then
      look = look .. " " .. w
    else
      look = w
    end
  end
end)
return etc.complete(look)
