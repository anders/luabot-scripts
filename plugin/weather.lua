local UnitTest = not not Editor

local function approx(a, b, err)
  err = err or 0.01
  return math.abs(a - b) <= err, math.abs(a - b)
end

local M = {}

-- fahrenheit/celsius conversion
function M.f2c(T)
  return (T - 32) * 5 / 9
end

if UnitTest then
  assert(M.f2c(-40) == -40)
  assert(M.f2c(50) == 10)
end

function M.c2f(T)
  return T * 9 / 5 + 32
end

if UnitTest then
  assert(M.c2f(-40) == -40)
end

-- http://en.wikipedia.org/wiki/Heat_index
-- T: temperature in Celsius
-- R: relative humidity
function M.heatIndex(T, R)
  if not (T >= 27 and R >= 40) then
    return false, "temperature must be >27C and humidity must be at least 40%"
  end

  local c1 = -8.784695
  local c2 = 1.61139411
  local c3 = 2.338549
  local c4 = -0.14611605
  local c5 = -1.2308094 * 10^-2
  local c6 = -1.6424828 * 10^-2
  local c7 = 2.211732 * 10^-3
  local c8 = 7.2546 * 10^-4
  local c9 = -3.582 * 10^-6

  return c1 + c2*T + c3*R + c4*T*R + c5*T^2 + c6*R^2 + c7*T^2*R + c8*T*R^2 + c9*T^2*R^2
end

if UnitTest then
  assert(approx(M.heatIndex(42, 40), 53.67))
end

-- http://www.smhi.se/kunskapsbanken/meteorologi/vindens-kyleffekt-1.259
-- T: temperature in Celsius
-- V: wind speed in m/s
function M.windChill(T, V)
  return 13.12 + 0.6215 * T - 13.956 * V^0.16 + 0.48669 * T * V^0.16
end

if UnitTest then
  assert(approx(M.windChill(-6, 14), -16.35))
end

return M
