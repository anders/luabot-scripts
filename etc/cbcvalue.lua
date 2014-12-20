API "1.1"

local sbasevalue, currency = etc.getOutput(etc.money, '1 XAU ' .. (arg[1] or 'USD')):match('= ([%d%.]+) (.+)')
local basevalue = tonumber(sbasevalue)

local absTotal = 0
local count = 0
local minVal = math.huge
local maxVal = 0
for i = 0, 10000000 do
  local n = getname(i)
  if not n then
    break
  end
  if n:sub(1, 1) ~= '$' then
    local c = worth(n)
    absTotal = absTotal + math.abs(c)
    count = count + 1
    if c < minVal then minVal = c end
    if c > maxVal then maxVal = c end
  end
end

-- First return value is what 1 CBC is worth in USD or the provided currency.
return basevalue / absTotal / 2, currency, absTotal, basevalue, minVal, maxVal, count, absTotal / count
