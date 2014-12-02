API "1.1"

local resp = httpGet("http://airportcode.riobard.com/airport/"..arg[1].."?fmt=JSON")
local json = require "json"
--{"code": "FRA", "name": "Frankfurt International Airport", "location": "Frankfurt, Germany"}

local d = assert(json.decode(resp), "probably not a valid IATA code")
print(d.name.." ("..d.code..") - "..d.location)
