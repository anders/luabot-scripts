API "1.1"

local LOG = plugin.log(_funcname)

local to = arg[1]
local from = (arg[2] or 'usd'):lower()

--[[ -- OLD:
local info = assert(util.coinmarketcap(to))
local val = info.price[from]
local coin_name = info.name
--]]

--[[
local info = assert(etc.cryptocoincharts(to, from))
local val = info.price
local coin_name = info.coin1
--]]

val, coin_name = assert(util.coinmarketcap(to))

LOG.trace("val = ", val)
LOG.trace("coin_name = ", coin_name)

return val, coin_name
