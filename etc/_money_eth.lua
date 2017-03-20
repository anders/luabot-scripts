API "1.1"

local from = (arg[1] or 'usd'):lower()
local ethinfo = util.coinmarketcap_eth()
local prices = ethinfo.price
local val = prices[from]

return val, ethinfo.name
