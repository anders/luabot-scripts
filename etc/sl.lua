API "1.1"

local json = require "json"

local url = "http://api.sl.se/api2/deviations.json?key=5cccb082a535420191f072b09a7186ef&siteId=1002&transportMode=train"
local data, mime, charset, status = httpGet(url)

assert(data, mime)

local resp = assert(json.decode(data))

local Train = "🚃"
local Warning = "⚠️"

for i, info in ipairs(resp.ResponseData) do
  etc.printf("%s %s %s %s", Warning, info.Header, Train, info.Scope)
  etc.printf("%s", info.Details)
end
