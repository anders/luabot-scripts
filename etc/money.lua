if Editor then return end

local LOG = plugin.log(_funcname)

local APP_ID = etc.decrypt "0q4163n2s4q9407q85111n5q6s2n8s99"
local CACHE_DURATION = 3600

local names = etc._currencies()

-- from sam_lie
-- Compatible with Lua 5.0 and 5.1.
-- Disclaimer : use at own risk especially for hedge fund reports :-)

---============================================================
-- add comma to separate thousands
-- 
local function comma_value(amount)
  local formatted = tostring(amount)
  while true do  
    formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
    if k == 0 then
      break
    end
  end
  return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
local function round(val, decimal)
  if decimal then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val + 0.5)
  end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
--
local function format_num(amount, decimal, prefix, neg_prefix)
  local str_amount,  formatted, famount, remain

  decimal = decimal or 2  -- default 2 decimal places
  neg_prefix = neg_prefix or "-" -- default negative sign

  famount = math.abs(round(amount, decimal))
  famount = math.floor(famount)

  remain = round(math.abs(amount) - famount, decimal)

  -- comma to separate the thousands
  formatted = comma_value(famount)

  -- attach the decimal portion
  if decimal > 0 then
    remain = tostring(remain):sub(3)
    formatted = formatted .. "." .. remain .. ("0"):rep(decimal - #remain)
  end

  -- if value is negative then format accordingly
  if amount < 0 then
    if neg_prefix == "()" then
      formatted = "("..formatted ..")"
    else
      formatted = neg_prefix .. formatted 
    end
  end

  -- attach prefix string e.g '$' 
  formatted = (prefix or "") .. formatted 

  return formatted
end

-- End of sam_lie code

-- 'money 34.563 SEK USD
-- 'money SEK USD 324.657
-- 'money 342 SEK
-- 'money 434 USD
-- 'money USD

local json = plugin.json()
local cache = plugin.cache(Cache)

local default_currency = (etc.get('currency', nick) or 'USD'):upper()

local function usage()
  print('\002Usage:\002 '..etc.cmdchar..'money [amount], code1, [code2]. Example: '..etc.cmdchar..'money 20 usd sek')
end

if not arg[1] then
  usage()
  return
end

local amount = arg[1]:match('%d+%.?%d*')

local codes = {}
for code in arg[1]:gmatch('%a+') do
  if #codes == 2 then
    usage()
    return
  end

  code = code:upper()
  if code ~= 'IN' and code ~= 'TO' and code ~= 'FROM' then
    codes[#codes + 1] = code
  end
end

if #codes == 0 then
  codes[1] = default_currency
end

if amount then
  amount = tonumber(amount)
end

local cacheKey = 'money$data'
local cached = cache.isCached(cacheKey)
LOG.trace("cached(money$data) = "..tostring(cached))
local rates = cached and cache.get(cacheKey)
LOG.trace("rates = "..tostring(rates):sub(1, 15))

if not rates then
  local exchange_data, e = httpGet('http://openexchangerates.org/api/latest.json?app_id='..APP_ID)
  if not exchange_data then
    print('\002Error:\002 httpGet() returned '..tostring(e))
    return
  end

  local exchange_rates = json.load(exchange_data)
  rates = assert(exchange_rates.rates, 'Expected rates')
  cache.set(cacheKey, json.encode(rates), CACHE_DURATION)
  LOG.trace("cache.set("..cacheKey..", cache.isCached("..cacheKey..") = "..tostring(cache.isCached(cacheKey)))
else
  rates = json.decode(rates)
end

local function get_rate(x)
  if not rates[x] then
    local f = etc['_money_' .. x:lower()]
    if f then
      local val, name = f('USD')
      rates[x] = 1 / val
      names[x] = name
    end
  end
  return rates[x]
end

local function convert(amount, from, to)
  local from_rate = get_rate(from)
  local to_rate = get_rate(to)

  if not from_rate then
    return false, 'Unknown currency code '..tostring(from)..'.'
  elseif not to_rate then
    return false, 'Unknown currency code '..tostring(to)..'.'
  elseif type(amount) ~= 'number' then
    return false, 'No amount specified.'
  end

  local amount_in_USD = amount / from_rate
  local amount_in_new = amount_in_USD * to_rate

  return amount_in_new
end

local function print_convert(amount, from, to)
  local new_amount, e = convert(amount, from, to)
  if not new_amount then
    print('\002Error:\002 '..e)
    return
  end
  local from_name = names[from] or from
  local to_name = names[to] or to
  local rate = amount / new_amount
  local rateInv = 1/rate

  local buf = {}
  
  local fn = function(...)
    return format_num(...):gsub("%.0000", ""), nil
  end

  -- XYZ 1.2345 (Xy Yy Zz dollar)
  buf[#buf+1] = fn(amount, 4, from.." ").." ("..from_name..")"
  -- =
  buf[#buf+1] = " = "
  -- XYZ 1.2345 (Foo Bar dollar)
  buf[#buf+1] = fn(new_amount, 4, to.." ").." ("..to_name..")"
  -- (XYZXYZ 1.2345,
  buf[#buf+1] = " ("..from..fn(rateInv, 4, to.." ").."; "
  --  XYZXYZ 1.2345)
  buf[#buf+1] = to..fn(rate, 4, from.." ")..")"

  print(table.concat(buf, ""))
end

-- 'money 50
if #codes == 0 and amount then
  codes[1] = default_currency
  codes[2] = 'USD'
end

-- 'money SEK
if #codes == 1 and not amount then
  local a = rates[codes[1]]
  local b = rates[default_currency]
  
  if a and b then
    if a < b then
      print_convert(1, codes[1], default_currency)
    else
      print_convert(1, default_currency, codes[1])
    end
  else
    print_convert(1, codes[1], default_currency)
  end
  return
end

-- 'money 50 SEK
if #codes == 1 and amount then
  codes[2] = default_currency
  if codes[1] == codes[2] then
    codes[2] = 'USD'
  end
end

-- 'money SEK GBP
if #codes == 2 and not amount then
  print_convert(1, codes[1], codes[2])
  return
end

-- 'money 50 SEK GBP
if #codes == 2 and amount then
  print_convert(amount, codes[1], codes[2])
  return
end

usage()
