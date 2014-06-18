--[[ broken for some reason? dunno
local card = '1363094336'
local back = 'AEE9'

local URL = 'http://www.shop.skanetrafiken.se/kollasaldo.html'
local postData = 'cardno=1363094336&backno=AEE9&ST_CHECK_SALDO=Se+saldo'
local req = httpRequest(URL, 'POST')
req:setRequestBody(postData)
req.headers['Content-Type'] = 'application/x-www-form-urlencoded'

local resp = assert(req:getResponseBody())
print(resp)

-- <td class="greenrow right"><h3>104,00 kr </h3></td>

--local balance = resp:match('<td class="greenrow right"><h3>([%d%.,]+) kr')
--return balance:gsub(',', '.')..' SEK'

]]

local x = assert(httpGet("http://fgsfd.se/tzapi/jojo"))
return "Balance: "..x:gsub(',', '.').." SEK"
