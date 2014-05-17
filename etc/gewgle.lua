local json = require 'json'

local query = assert(arg[1])
if query:lower() == 'google' then
  print(nick..' * uh... thanks for breaking the internet, assh*le...')
  return
end

local data, err = httpGet('http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q='..urlEncode(query))
if not data then
  return false, err
end

if data:sub(1, 1) ~= '{' then
  return false, 'invalid reply?'
end

local resp = assert(json.decode(data))
assert(resp.responseData, 'no response data')

local res = resp.responseData.results
if res[1] then
  --print(etc.t(res[1]))
  -- unescapedUrl
  -- visibleUrl
  -- title
  -- titleNoFormatting
  -- content
  
  print(nick..' * '..etc.html2irc(res[1].titleNoFormatting)..': '..res[1].unescapedUrl)
else
  return false, 'no results'
end
