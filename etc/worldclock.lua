API "1.1"

local time = require "time"
local now = os.time()

local places = {
  {"Los Angeles",   "America/Los_Angeles"},
  {"Chicago",       "America/Chicago"    },
  {"New York",      "America/New_York"   },
  {"London",        "Europe/London"      },
  {"Stockholm",     "Europe/Stockholm"   },
  {"Helsinki",      "Europe/Helsinki"    },
  {"Moscow",        "Europe/Moscow"      },
  {"Tokyo",         "Asia/Tokyo"         },
  {"Sydney",        "Australia/Sydney"   },
  {"Wellington",    "Pacific/Auckland"   },
}

local buf = {}

for _, placezone in pairs(places) do
  local place, zone = placezone[1], placezone[2]
  local tz = time.zoneinfo(zone, now)
  local localtime = os.date("!%H:%M", now + tz.offset)
  buf[#buf + 1] = ("\2%s:\2 %s"):format(place, localtime)
end

local ret = table.concat(buf, ", ")
if network == "Telegram" then
  ret = ret:gsub(", ", "\n")
end
return ret

