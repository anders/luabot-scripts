local json = require 'json'

arg, io.stdin = etc.stdio(arg)
local text
local data = io.stdin:read('*a')

local translit = false

for i, v in ipairs(arg) do
  if v == '-translit' then
    translit = true
    table.remove(arg, i)
    break
  end
end

if #data > 0 then
    text = data
else
    local tmp = {}
    for i=3, #arg do
        tmp[i - 2] = arg[i]
    end
    text = table.concat(tmp, ' ')
end

-- Strip IRC codes
text = text:gsub('\2', '')
text = text:gsub('\31', '')
text = text:gsub('\3[0-9][0-9,]*', '')

local sl = assert(arg[1], 'need source language (en, fi, sv, etc)')
local tl = assert(arg[2], 'need target language (en, fi, sv, etc)')
assert(#sl==2 and #tl==2, 'language codes must be 2 char')

local URL = 'http://translate.google.com/translate_a/t?client=p&sl='..urlEncode(sl)..'&tl='..urlEncode(tl)..'&text='..urlEncode(text)..'&ie=UTF-8&oe=UTF-8'
local data = assert(httpGet(URL))

--[[local data = [=[
{
    "sentences": [{
        "trans": "oil is a good drink. ",
        "orig": "öl ist ein gute trink.",
        "translit": "",
        "src_translit": ""
    }, {
        "trans": "my mother is beautiful",
        "orig": "meine mutter ist schön",
        "translit": "",
        "src_translit": ""
    }],
    "src": "de",
    "server_time": 30
}
]]

local u = json.decode(data)

local S = u.sentences
local out = {}

for i=1, #S do
  if translit and #S[i].translit > 0 then
    out[#out + 1] = S[i].translit
  else
    out[#out + 1] = S[i].trans
  end
end

return table.concat(out)
