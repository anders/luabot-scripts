local LOG = plugin.log(_funcname)

local coin = (arg[1] or ""):lower()
LOG.trace("coin = ", coin)
coin = ({eth="ethereum", btc="bitcoin", doge="dogecoin"})[coin] or coin
LOG.trace("coin = ", coin)
local tocurrency = (arg[2] or "usd"):lower()

local json = require "json"

local url = "https://api.coinmarketcap.com/v1/ticker/" .. coin .. "/?convert=" .. tocurrency
LOG.trace("url = ", url)
local data, mimeType, charset, status, stuff = httpGet(url)

LOG.trace("mimeType = ", mimeType)
LOG.trace("data = ", data)
assert(data, mimeType)

if status ~= "200" then
  return nil, stuff
end

local dec = json.decode(data)

-- return tonumber(dec[1].price_usd), dec[1].name
return dec[1]["price_" .. tocurrency], dec[1].name
