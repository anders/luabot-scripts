if Editor then print 'hhhehehe' return end

-- TODO: better name
local json = require 'json'
local cache = plugin.cache(Cache)

-- 8< -------- 8< ----

-- copy/paste from money.lua
local names = {
  CBC = 'Clownbot Coin',

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
  VEF = 'Venezuelan Bolívar Fuerte (Old)',
  VES = 'Venezuelan Bolívar Soberano',
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
  ZWL = 'Zimbabwean Dollar',
}

local ignore = {}
for _, v in pairs {
  -- UK
  'JEP', 'FKP', 'SHP', 'GGP', 'IMP', 'GIP',
  
  -- USD
  'BMD', 'PAB', 'BSD', 'CUC',
} do
  ignore[v] = true
end

local APP_ID = etc.decrypt "0q4163n2s4q9407q85111n5q6s2n8s99"
local CACHE_DURATION = 60 * 5
local cached = cache.isCached('money.data')
local rates = cached and cache.get('money.data')

if not rates then
  local exchange_data, e = httpGet('http://openexchangerates.org/api/latest.json?app_id='..APP_ID)
  if not exchange_data then
    print('\002Error:\002 httpGet() returned '..tostring(e))
    return
  end

  local exchange_rates = json.load(exchange_data)
  rates = assert(exchange_rates.rates, 'Expected rates')
  cache.set('money.data', json.encode(rates), CACHE_DURATION)
else
  rates = json.decode(rates)
end

rates.CBC = 0 -- Get it later.

local function get_rate(x)
  if x:upper() == 'CBC' and rates.CBC == 0 then
    rates.CBC = 1 / etc.cbcvalue('USD')
  end
  return rates[x]
end



-- 8< -------- 8< ----

local currency = (arg[1] or etc.get('currency', nick) or 'USD'):upper()

assert(rates[currency], 'dunno that currency fr8')

local t = {}
for code, value_usd in pairs(rates) do
  if not ignore[code] then
    t[#t + 1] = {code, get_rate(currency) / value_usd, math.abs(get_rate(currency) - value_usd)}
  end
end

table.sort(t, function(a, b)
  return a[3] < b[3]
end)

for k, v in ipairs(t) do print(v[1], names[v[1]] or '(unknown)', v[2]) end
