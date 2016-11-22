local json = require 'json'

local query = assert(arg[1])
if query:lower() == 'google' then
  print(nick..' * uh... thanks for breaking the internet, assh*le...')
  return
end


local key = etc.rot13('NVmnFlPgZTnKY71YpQvGhN98f6irxsBsCl9Efn8')
local cx = '011942350363630310124:w111ktxbioi'

local data, err = httpGet('https://www.googleapis.com/customsearch/v1?num=1&key='..key..'&cx='..cx..'&q='..urlEncode(query))
if not data then
  return false, err
end

if data:sub(1, 1) ~= '{' then
  return false, 'invalid reply?'
end

local resp = assert(json.decode(data))

--[[
{
 "error": {
  "errors": [
   {
    "domain": "usageLimits",
    "reason": "accessNotConfigured",
    "message": "Access Not Configured. CustomSearch API has not been used in project 995647563394 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/customsearch/overview?project=995647563394 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.",
    "extendedHelp": "https://console.developers.google.com/apis/api/customsearch/overview?project=995647563394"
   }
  ],
  "code": 403,
  "message": "Access Not Configured. CustomSearch API has not been used in project 995647563394 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/customsearch/overview?project=995647563394 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry."
 }
}

ctx.respond(ctx._("({num} of {total}) {title}: {url}").format(
        title=results[num]["title"],
        url=results[num]["link"],
        num=num + 1,
        total=total
    ))
]]

local res = resp.items
if res and res[1] then
  print(nick..' * '..res[1].title..': '..res[1].link..' - '..res[1].snippet)
else
  return false, 'no results'..json.encode(resp.error)
end
