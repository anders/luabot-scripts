API "1.1"

local to = arg[1]
local from = (arg[2] or 'usd'):lower()

--[[
local info = assert(util.coinmarketcap(to))
local val = info.price[from]
local coin_name = info.name
--]]

local info = assert(etc.cryptocoincharts(to, from))
local val = info.price
local coin_name = info.coin1

return val, coin_name
