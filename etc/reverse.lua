local x = arg[1]
local t = type(x)

if t == "string" then
  -- return x:reverse()
  local xx = {}
  for ch in etc.codepoints(x) do
    table.insert(xx, ch)
  end
  local y = etc.reverse(xx)
  return table.concat(y)
elseif t == "table" then
  local y = {}
  local newi = #x
  for i, x in ipairs(x) do
    y[newi] = x
    newi = newi - 1
  end
  return y
elseif t == "number" then
  return -x
elseif t == "boolean" then
  if t then
    return false
  end
  return true
end
