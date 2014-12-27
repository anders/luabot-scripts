API "1.1"
-- Usage: pipe text and supply a lua pattern

arg, io.stdin = etc.stdio(arg)

local t = {}
for line in io.stdin:lines() do
  local first = true
  for x in line:gmatch(arg[1] or '.*') do
    if not first then
      t[#t + 1] = '\t'
    end
    first = false
    t[#t + 1] = x
  end
  t[#t + 1] = '\n'
end
return table.concat(t, '')
