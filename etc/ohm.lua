--[[
V=I*R
I=V/R
R=V/I

P=V*I

I=Ampere
R=Ohm
V=Volt
P=Watt
]]

local function human(n)
  return etc.hsize(n)
end

local A = arg[1] or ""


local V = A:match("([%d%.]+[ukmM]?[Vv])")
local I = A:match("([%d%.]+[ukmM]?[AaIi])")
local R = A:match("([%d%.]+[ukmM]?[RrOo])")
--local P = A:match("([%d%.]+[ukmM]?[Ww])")
local P

local function num(s)
  local n, u = s:match("([%d%.]+)([ukmM]?)[A-Za-z]")
  local conv = { u = 1 / 1000000, m = 1 / 1000, k = 1000, M = 1000000 }
  n = assert(tonumber(n))
  if u and conv[u] then
    n = n * conv[u]
  end
  return n
end

V = V and num(V)
I = I and num(I)
R = R and num(R)

if I and R then
  V = I * R
elseif V and R then
  I = V / R
elseif V and I then
  R = V / I
end

P = V * I

etc.printf("V=%sV, I=%sA, R=%sΩ, P=%sW", human(V), human(I), human(R), human(P))
