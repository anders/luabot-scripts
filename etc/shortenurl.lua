--[[
POST https://www.googleapis.com/urlshortener/v1/url
Content-Type: application/json

{"longUrl": "http://www.google.com/"}
]]

--[[
{
 "kind": "urlshortener#url",
 "id": "http://goo.gl/fbsS",
 "longUrl": "http://www.google.com/"
}
]]

local json = require "json"
local urls, cb = ...

if type(urls) == "string" then
    urls = {urls}
end

assert(type(urls) == "table", "this function takes a table of URLs")

local apiKey = etc.rot13("NVmnFlPgZTnKY71YpQvGhN98f6irxsBsCl9Efn8")
local ret = {}

for i, url in ipairs(urls) do
    if Cache['url_'..url] then
        ret[i], ret[url] = Cache['url_'..url], Cache['url_'..url]
    else
        local payload = json.encode{longUrl = url}
        --	hlp.httpRequest = "Returns a HTTP request object. Optional arguments: url, method. Properties: url, method, headers[key=value], mimeType, charset, responseHeaders, responseStatusCode, responseStatusDescription. Methods: setRequestBody, getResponseBody, getResponseStream"

        local ok, req = pcall(httpRequest, "https://www.googleapis.com/urlshortener/v1/url?key="..apiKey, "POST")
        req.headers["Content-Type"] = "application/json"
        req:setRequestBody(json.encode{longUrl=url})
        local resp = req:getResponseBody()
        local decoded = resp and json.decode(resp)
        if resp then
            ret[i] = decoded.id
            ret[url] = decoded.id
            Cache['url_'..url] = decoded.id
        else
            ret[i], ret[url] = url, url
        end
    end
end

return ret
