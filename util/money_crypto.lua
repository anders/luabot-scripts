API "1.1"

local to = arg[1]
local from = (arg[2] or 'usd'):lower()
local info = util.coinmarketcap(to)
local prices = info.price
local val = prices[from]
return val, info.name
