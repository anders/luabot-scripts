local coin = (arg[1] or ""):lower()
coin = ({eth=ethereum, btc=bitcoin})[coin] or coin

local json = require "json"

local data, mimeType, charset, status = httpGet("https://api.coinmarketcap.com/v1/ticker/" .. coin .. "/")

assert(data, mimeType)

local dec = json.decode(data)

return tonumber(dec[1].price_usd), dec[1].name



