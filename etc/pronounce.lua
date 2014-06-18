local json = require 'json'
local word = arg[1] or 'this is a test string'
local req = httpRequest('http://www.sljfaq.org/cgi/e2k.cgi?o=json&romaji=1&word='..urlEncode(word))
local data = json.decode(req:getResponseBody())

local t = {}
for i=1, #data.words do
  t[#t + 1] = data.words[i].e_pron
end
return table.concat(t, ' ')
