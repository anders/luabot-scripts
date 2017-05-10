API "1.1"

local zones = {
  {"Pacific", "America/Los_Angeles"},
  {"Mountain", "America/Denver"},
  {"Central", "America/Chicago"},
  {"Eastern", "America/New_York"},
}

local buf = {}

for k, v in ipairs(zones) do
  local fmt_time, offset, tzname = etc.timezone(v[2], "%I:%M %p", nil, true)
  buf[#buf + 1] = ("\2"..v[1].." ("..tzname.."):\2 "..fmt_time):gsub("0(%d)", "%1")
end

return table.concat(buf, network ~= "Telegram" and ", " or "\n")
