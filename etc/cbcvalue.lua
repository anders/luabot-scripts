API "1.1"

local sbasevalue, currency
if arg[1] == '-cache' then
  if Cache.xau_usd and Cache.xau_usd_time and (os.time() - Cache.xau_usd_time) < 60 * 60 * 6 then
    currency = 'USD -cache'
    sbasevalue = Cache.xau_usd
  end
  arg[1] = 'USD'
end
if not sbasevalue then
  sbasevalue, currency = etc.getOutput(etc.money, '1 XAU ' .. (arg[1] or 'USD')):match('= ([%d%.]+) (.+)')
  if (arg[1] or 'USD'):upper() == 'USD' then
    Cache.xau_usd = sbasevalue
    Cache.xau_usd_time = os.time()
  end
end
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
