local json = require "json"
local cc = ...
return json.decode(httpGet("https://coinmarketcap-nexuist.rhcloud.com/api/" .. cc))
