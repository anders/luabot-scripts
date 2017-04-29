-- Usage: 'fml - F my life.

local KEY = '4a6d9d18805b3'
s = assert(httpGet("http://api.betacie.com/view/random/nocomment?language=en&key=" .. KEY))
local q, qpos = s:match("<text>(.-)</text>()", i)
return html2text(q)
