API "1.1"

local key = "9ea90ce0-4da6-46eb-a55b-55d9f301b6e8"

local airport = (arg[1] or "NRT"):sub(1, 3)

local resp = httpGet("http://iatacodes.org/api/v6/airports?api_key="..key.."&code="..airport)
local json = require "json"

local d = assert(json.decode(resp), "probably not a valid IATA code")
local d1 = d.response[1]
print(d1.name.." ("..d1.code..")")
