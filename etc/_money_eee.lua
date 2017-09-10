API "1.1"

local json = require "json"

local data, mimeType, charset, status = httpGet("https://api.coinmarketcap.com/v1/ticker/ethereum/")

assert(data, mimeType)

local dec = json.decode(data)

return tonumber(dec[1].price_usd), dec[1].name

