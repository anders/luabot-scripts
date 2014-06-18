if type(arg[1]) == "table" then
  local r = {}
  for k, v in pairs(arg[1]) do
    r[k] = v
  end
  return r
end
return arg[1]
