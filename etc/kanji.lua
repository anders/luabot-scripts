-- abcin
-- oneormulti
--
-- <td class="kanji-out">互丁立戸亜句</td>

local text = assert(arg[1])
local oneormulti = '1'

local response = assert(httpPost('http://www.sljfaq.org/cgi/kanjiabc.cgi', 'oneormulti='..oneormulti..'&abcin='..urlEncode(text)))
return response --(response:match('<td class="kanji%-out">(.+)</td>'))
