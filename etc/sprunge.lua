assert(arg[1], "need something to paste")
local req = assert(httpPost("http://sprunge.us", "sprunge="..urlEncode(etc.stripCodes(arg[1]))))
req = req:gsub("\n", "")
return req..'?txt or '..req..'?lua'
