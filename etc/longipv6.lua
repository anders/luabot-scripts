require "ip"

local t = ip.IPv6(arg[1])
if not t then
  return nil, "Invalid IPv6 address"
end

local bytes = t[2]

local result = 0

for i = 1, #bytes do
  local mul = 1
  local off = #bytes - i
  if off > 0 then
    mul = math.pow(2, off * 2 * 8)
  end
  result = result + bytes[i] * mul
end

return result
