local json = require "json"

return json.decode(httpGet("https://coinmarketcap-nexuist.rhcloud.com/api/eth"))
