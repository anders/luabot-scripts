API "1.1"

local Time = require 'time'
local now = os.time()

local marketInfo = {
  NYSE =   { tz = "America/New_York", hours = {0900, 1600} },
  NASDAQ = { tz = "America/New_York", hours = {0900, 1600} },
  TSX =    { tz = "America/New_York", hours = {0930, 1600} },
  STO =    { tz = "Europe/Stockholm", hours = {0900, 1730} },
  CPH =    { tz = "Europe/Stockholm", hours = {0900, 1700} },
}

local markets = { "NYSE", "NASDAQ", "TSX", "STO", "CPH" }

-- hm(0930) -> return 9, 30
local function hm(t)
  local m = t % 100
  local h = (t - m) / 100
  return h, m
end

local getTimezone
do
  local cached = {}
  function getTimezone(path, time)
    time = time or os.time()
    if cached[path] then return cached[path] end
    local tz, err = Time.zoneinfo(path, time)
    if not tz then return tz, err end
    cached[path] = tz
    return tz
  end
end

local buf = {}
for _, market in ipairs(markets) do
  local m = assert(marketInfo[market])
  
  local tz = assert(getTimezone(m.tz))
  local t = os.date("!*t", now + tz.offset)
  
  local holiday = false
  if t.wday == 1 or t.wday == 7 then
    holiday = true
  end
  
  local status = "open"
  if holiday then
    status = "closed"
  end
  
  buf[#buf + 1] = ("\2%s\2: %s"):format(market, status)
end

return table.concat(buf, ", ")
