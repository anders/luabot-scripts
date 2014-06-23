API "1.1"

local time = require "time"
local now = os.time()

local places = {
  ["Los Angeles"] = "America/Los_Angeles",
  ["New York"] = "America/New_York",
  ["Stockholm"] = "Europe/Stockholm",
  ["Tokyo"] = "Asia/Tokyo",
  ["Sydney"] = "Australia/Sydney",
  ["London"] = "Europe/London",
}

local buf = {}

for place, zone in pairs(places) do
  local tz = time.zoneinfo(zone, now)
  local localtime = os.date("!%H:%M", now + tz.offset)
  buf[#buf + 1] = ("\2%s:\2 %s"):format(place, localtime)
end

return table.concat(buf, ", ")
