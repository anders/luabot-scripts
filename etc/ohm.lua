-- Voltage (V) = Current (I) * Resistance (R) 
-- Power (P) = Voltage (V) * Current (I)

-- P / V = I
-- P / I = V
-- V * I = P

local A = arg[1] or ""

local power      = A:match("([%d%.]+[ukmM]?[WwPpVv])")
local current    = A:match("([%d%.]+[ukmM]?[IiAa])")
local resistance = A:match("([%d%.]+[ukmM]?[Rr])")

local function num(s)
  local n, u = s:match("([%d%.]+)([ukmM]?)[A-Za-z]")
  local conv = { u = 1 / 1000000, m = 1 / 1000, k = 1000, M = 1000000 }
  n = assert(tonumber(n))
  if u and conv[u] then
    n = n * conv[u]
  end
  return n
end

power = power and num(power) or nil
current = current and num(current) or nil
resistance = resistance and num(resistance) or nil

if current and resistance then
  print("voltage: "..current*resistance)
elseif voltage and current then
  print("power: "..voltage*current)
end

--[[
print("power: "..(power or "n/a"))
print("current: "..(current or "n/a"))
print("resistance: "..(resistance or "n/a"))
]]
