-- Usage: tresult = etc.mergetables(t1, ... tN) -- merge all values from both tables, if a key exists in both tables, the one in tN wins.

local tresult = {}

local function xtable(x, y)
  for k, v in pairs(y) do
    x[k] = v
  end
end

for i = 1, select('#', ...) do
  xtable(tresult, select(i, ...))
end

return tresult
