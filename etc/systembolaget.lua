API "1.1"

local coords = etc.get("location.coords")

local params = {}
params["loc"] = coords

local postDataTmp = {}
for k, v in pairs(params) do
  postDataTmp[#postDataTmp+1] = urlEncode(k).."="..urlEncode(v)
end
local postData = table.concat(postDataTmp, "&")

local url = "http://home.fgsfd.se:8080/systembolaget?"..postData
local resp = assert(httpGet(url))

return resp
