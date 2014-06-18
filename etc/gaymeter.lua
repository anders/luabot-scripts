local json = require 'json'

function randomOctet()
    return math.random(0, 256)
end

local endpoint = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q="

function jsonRequest(url)
    return json.decode(httpRequest(url):getResponseBody() or "null")
end

local a = jsonRequest(endpoint .. urlEncode(arg[1]))

if a.responseStatus ~= 200 then
  return "error for request #1: " .. a.responseDetails
end

local na
if #a.responseData.results == 0 then
  na = 0
else
  na = tonumber((a.responseData.cursor.estimatedResultCount:gsub(",", "")))
end

sleep(1)

local b = jsonRequest(endpoint .. urlEncode("gay " .. arg[1]))

if b.responseStatus ~= 200 then
  return "error for request #2: " .. b.responseDetails
end


local nb
if #b.responseData.results == 0 then
  nb = 0
else
  nb = tonumber((b.responseData.cursor.estimatedResultCount:gsub(",", "")))
end

return ("%s: %.1f%%"):format(arg[1], (nb / na * 100))
