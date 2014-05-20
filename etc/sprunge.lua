local lang, code = etc.stdio_nofile(arg)
assert(code, 'need code')
lang = #lang > 0 and lang or 'txt'

assert(arg[1], "need something to paste")
local req = assert(httpPost("http://sprunge.us", "sprunge="..urlEncode(etc.stripCodes(code))))
req = req:gsub("\n", "")
return req..'?'..lang
