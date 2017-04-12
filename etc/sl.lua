API "1.1"

local json = require "json"

local url = "http://api.sl.se/api2/deviations.json?key=5cccb082a535420191f072b09a7186ef&siteId=1002&transportMode=train"
local data, mime, charset, status = httpGet(url)

assert(data, mime)

etc.printf("%s;%s;%s;%s", tostring(data), tostring(mime), tostring(charset), tostring(status))
