
assert(type(arg[1]) == "string" and type(arg[2]) == "string", "Invalid arguments")

-- Optimize?
if arg[1] < arg[2] then
  return -1
elseif arg[1] > arg[2] then
  return 1
end
return 0
