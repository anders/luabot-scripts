if Editor then return end

local APP_ID = 'ccdc436323fd4cb1a51dae367ca9a7ff'
local CACHE_DURATION = 60 * 5

local names = {
  AED = 'United Arab Emirates Dirham',
  AFN = 'Afghan Afghani',
  ALL = 'Albanian Lek',
  AMD = 'Armenian Dram',
  ANG = 'Netherlands Antillean Guilder',
  AOA = 'Angolan Kwanza',
  ARS = 'Argentine Peso',
  AUD = 'Australian Dollar',
  AWG = 'Aruban Florin',
  AZN = 'Azerbaijani Manat',
  BAM = 'Bosnia-Herzegovina Convertible Mark',
  BBD = 'Barbadian Dollar',
  BDT = 'Bangladeshi Taka',
  BGN = 'Bulgarian Lev',
  BHD = 'Bahraini Dinar',
  BIF = 'Burundian Franc',
  BMD = 'Bermudan Dollar',
  BND = 'Brunei Dollar',
  BOB = 'Bolivian Boliviano',
  BRL = 'Brazilian Real',
  BSD = 'Bahamian Dollar',
  BTC = 'Bitcoin',
  BTN = 'Bhutanese Ngultrum',
  BWP = 'Botswanan Pula',
  BYN = 'Belarusian Ruble',
  BZD = 'Belize Dollar',
  CAD = 'Canadian Dollar',
  CDF = 'Congolese Franc',
  CHF = 'Swiss Franc',
  CLF = 'Chilean Unit of Account (UF)',
  CLP = 'Chilean Peso',
  CNH = 'Chinese Yuan (Offshore)',
  CNY = 'Chinese Yuan',
  COP = 'Colombian Peso',
  CRC = 'Costa Rican Colón',
  CUC = 'Cuban Convertible Peso',
  CUP = 'Cuban Peso',
  CVE = 'Cape Verdean Escudo',
  CZK = 'Czech Republic Koruna',
  DJF = 'Djiboutian Franc',
  DKK = 'Danish Krone',
  DOP = 'Dominican Peso',
  DZD = 'Algerian Dinar',
  EGP = 'Egyptian Pound',
  ERN = 'Eritrean Nakfa',
  ETB = 'Ethiopian Birr',
  EUR = 'Euro',
  FJD = 'Fijian Dollar',
  FKP = 'Falkland Islands Pound',
  GBP = 'British Pound Sterling',
  GEL = 'Georgian Lari',
  GGP = 'Guernsey Pound',
  GHS = 'Ghanaian Cedi',
  GIP = 'Gibraltar Pound',
  GMD = 'Gambian Dalasi',
  GNF = 'Guinean Franc',
  GTQ = 'Guatemalan Quetzal',
  GYD = 'Guyanaese Dollar',
  HKD = 'Hong Kong Dollar',
  HNL = 'Honduran Lempira',
  HRK = 'Croatian Kuna',
  HTG = 'Haitian Gourde',
  HUF = 'Hungarian Forint',
  IDR = 'Indonesian Rupiah',
  ILS = 'Israeli New Sheqel',
  IMP = 'Manx pound',
  INR = 'Indian Rupee',
  IQD = 'Iraqi Dinar',
  IRR = 'Iranian Rial',
  ISK = 'Icelandic Króna',
  JEP = 'Jersey Pound',
  JMD = 'Jamaican Dollar',
  JOD = 'Jordanian Dinar',
  JPY = 'Japanese Yen',
  KES = 'Kenyan Shilling',
  KGS = 'Kyrgystani Som',
  KHR = 'Cambodian Riel',
  KMF = 'Comorian Franc',
  KPW = 'North Korean Won',
  KRW = 'South Korean Won',
  KWD = 'Kuwaiti Dinar',
  KYD = 'Cayman Islands Dollar',
  KZT = 'Kazakhstani Tenge',
  LAK = 'Laotian Kip',
  LBP = 'Lebanese Pound',
  LKR = 'Sri Lankan Rupee',
  LRD = 'Liberian Dollar',
  LSL = 'Lesotho Loti',
  LYD = 'Libyan Dinar',
  MAD = 'Moroccan Dirham',
  MDL = 'Moldovan Leu',
  MGA = 'Malagasy Ariary',
  MKD = 'Macedonian Denar',
  MMK = 'Myanma Kyat',
  MNT = 'Mongolian Tugrik',
  MOP = 'Macanese Pataca',
  MRO = 'Mauritanian Ouguiya (pre-2018)',
  MRU = 'Mauritanian Ouguiya',
  MUR = 'Mauritian Rupee',
  MVR = 'Maldivian Rufiyaa',
  MWK = 'Malawian Kwacha',
  MXN = 'Mexican Peso',
  MYR = 'Malaysian Ringgit',
  MZN = 'Mozambican Metical',
  NAD = 'Namibian Dollar',
  NGN = 'Nigerian Naira',
  NIO = 'Nicaraguan Córdoba',
  NOK = 'Norwegian Krone',
  NPR = 'Nepalese Rupee',
  NZD = 'New Zealand Dollar',
  OMR = 'Omani Rial',
  PAB = 'Panamanian Balboa',
  PEN = 'Peruvian Nuevo Sol',
  PGK = 'Papua New Guinean Kina',
  PHP = 'Philippine Peso',
  PKR = 'Pakistani Rupee',
  PLN = 'Polish Zloty',
  PYG = 'Paraguayan Guarani',
  QAR = 'Qatari Rial',
  RON = 'Romanian Leu',
  RSD = 'Serbian Dinar',
  RUB = 'Russian Ruble',
  RWF = 'Rwandan Franc',
  SAR = 'Saudi Riyal',
  SBD = 'Solomon Islands Dollar',
  SCR = 'Seychellois Rupee',
  SDG = 'Sudanese Pound',
  SEK = 'Swedish Krona',
  SGD = 'Singapore Dollar',
  SHP = 'Saint Helena Pound',
  SLL = 'Sierra Leonean Leone',
  SOS = 'Somali Shilling',
  SRD = 'Surinamese Dollar',
  SSP = 'South Sudanese Pound',
  STD = 'São Tomé and Príncipe Dobra (pre-2018)',
  STN = 'São Tomé and Príncipe Dobra',
  SVC = 'Salvadoran Colón',
  SYP = 'Syrian Pound',
  SZL = 'Swazi Lilangeni',
  THB = 'Thai Baht',
  TJS = 'Tajikistani Somoni',
  TMT = 'Turkmenistani Manat',
  TND = 'Tunisian Dinar',
  TOP = 'Tongan Pa\'anga',
  TRY = 'Turkish Lira',
  TTD = 'Trinidad and Tobago Dollar',
  TWD = 'New Taiwan Dollar',
  TZS = 'Tanzanian Shilling',
  UAH = 'Ukrainian Hryvnia',
  UGX = 'Ugandan Shilling',
  USD = 'United States Dollar',
  UYU = 'Uruguayan Peso',
  UZS = 'Uzbekistan Som',
  VEF = 'Venezuelan Bolívar Fuerte',
  VND = 'Vietnamese Dong',
  VUV = 'Vanuatu Vatu',
  WST = 'Samoan Tala',
  XAF = 'CFA Franc BEAC',
  XAG = 'Silver Ounce',
  XAU = 'Gold Ounce',
  XCD = 'East Caribbean Dollar',
  XDR = 'Special Drawing Rights',
  XOF = 'CFA Franc BCEAO',
  XPD = 'Palladium Ounce',
  XPF = 'CFP Franc',
  XPT = 'Platinum Ounce',
  YER = 'Yemeni Rial',
  ZAR = 'South African Rand',
  ZMW = 'Zambian Kwacha',
  ZWL = 'Zimbabwean Dollar'
}

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
  print('\002Usage:\002 '..etc.cmdchar..'money [amount], code1, [code2]. Tip of the day: '..etc.cmdchar..'set currency <code>')
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
local rates = cached and cache.get(cacheKey)

if not rates then
  local exchange_data, e = httpGet('http://openexchangerates.org/api/latest.json?app_id='..APP_ID)
  if not exchange_data then
    print('\002Error:\002 httpGet() returned '..tostring(e))
    return
  end

  local exchange_rates = json.load(exchange_data)
  rates = assert(exchange_rates.rates, 'Expected rates')
  cache.set(cacheKey, json.encode(rates), CACHE_DURATION)
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

  -- XYZ 1.2345 (Xy Yy Zz dollar)
  buf[#buf+1] = format_num(amount, 4, from.." ").." ("..from_name..")"
  -- =
  buf[#buf+1] = " = "
  -- XYZ 1.2345 (Foo Bar dollar)
  buf[#buf+1] = format_num(new_amount, 4, to.." ").." ("..to_name..")"
  -- (XYZXYZ 1.2345,
  buf[#buf+1] = " ("..from..format_num(rateInv, 4, to.." ")..", "
  --  XYZXYZ 1.2345)
  buf[#buf+1] = to..format_num(rate, 4, from.." ")..")"

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
