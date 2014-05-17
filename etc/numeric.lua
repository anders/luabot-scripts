-- Print a number.

local n = tonumber(arg[1])

if not n or n == 0 then
    return "0"
end
if not (n < 0 or n >= 0) then
  return "nan"
end

local neg
if n < 0 then
  neg = true
  n = -n
end

local sn = tostring(n)
local a, b = sn:match("^(%d+)(%.?%d*)$")
if not a then
  return sn
end

a = string.rep('0', 3 - (#a % 3)) .. a
a = a:gsub("(%d%d%d)", ",%1")
a = a:gsub("^[0,]+", "")
a = a:gsub(",", " ")

local result = a
if #b > 0 then
  result = result .. b
end
if neg then
  result = "-" .. result
end
return result

