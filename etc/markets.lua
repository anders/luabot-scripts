API "1.1"

local Time = require 'time'
local unicode = require 'unicode'
local now = os.time()
local nowT = os.date("!*t", now)

local marketInfo = {
  NASDAQ = { tz = "America/New_York",  hours = {0900, 1600}, country = "us", },
  NYSE =   { tz = "America/New_York",  hours = {0900, 1600}, country = "us", },
  TSX =    { tz = "America/Toronto",   hours = {0930, 1600}, country = "ca", },
  STO =    { tz = "Europe/Stockholm",  hours = {0900, 1730}, country = "se", },
  CPH =    { tz = "Europe/Copenhagen", hours = {0900, 1700}, country = "dk", },
  TSE =    { tz = "Asia/Tokyo",        hours = {0900, 1500}, country = "jp",
                                       lunch = {1130, 1230}, },
  OSL =    { tz = "Europe/Oslo",       hours = {0900, 1630}, country = "no" },
  FIN =    { tz = "Europe/Helsinki",   hours = {1000, 1830}, country = "fi" },
}

-- [year][month][day][market] = false or {open, close}
local specialDates = {}

local holidays = {
  { 2017, 04, 17, { "STO", "CPH" } },
  {   -1, 05, 01, { "STO" } },
  { 2017, 05, 12, { "CPH" } },
  { 2017, 05, 29, { "NASDAQ", "NYSE" } },
  {   -1, 07, 04, { "NASDAQ", "NYSE" } },
}

for _, t in ipairs(holidays) do
  local y, m, d, markets = t[1], t[2], t[3], t[4]
  if y < 0 then
    y = nowT.year
  end
  specialDates[y] = specialDates[y] or {}
  specialDates[y][m] = specialDates[y][m] or {}
  specialDates[y][m][d] = specialDates[y][m][d] or {}
  for _, market in ipairs(markets) do
    specialDates[y][m][d][market] = true
  end
end

local markets = { "NYSE", "NASDAQ", "TSX", "STO", "CPH", "OSL", "FIN", "TSE" }

-- hm(0930) -> return 9, 30
local function hm(t)
  local m = t % 100
  local h = (t - m) / 100
  return h, m
end

local function flagSymbol(az)
  az = az:upper()
  local c = az:byte()
  if c < 65 or c > 90 then return "" end
  c = c - 65
  return unicode.encode(0x1F1E6 + c)
end

local function flagEmoji(country_code)
  return flagSymbol(country_code:sub(1, 1)) .. flagSymbol(country_code:sub(2, 2))
end

local getTimezone
do
  local alias = {
    ["America/Toronto"]   = "America/New_York",
    ["Europe/Copenhagen"] = "Europe/Stockholm",
  }
  local cached = {}
  function getTimezone(path, time)
    time = time or os.time()
    path = alias[path] or path
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
  local localNow = os.time(t)
  
  local open = true
  local holiday = false
  local weekend = false
  local lunch = false
  
  -- sunday? saturday?
  if t.wday == 1 or t.wday == 7 then
    holiday = true
    weekend = true
  end

  
  if holiday then
    open = false
  else
    local openHour, openMinute   = hm(m.hours[1])
    local closeHour, closeMinute = hm(m.hours[2])

    local special = specialDates[t.year]
    if special then
      special = special[t.month]
      if special then
        special = special[t.day]
        if special then
          local s = special[market]
          if s == true then
            holiday = true
            open = false
          elseif type(s) == "table" then
            openHour, openMinute   = hm(s[1])
            closeHour, closeMinute = hm(s[2])
          end
        end
      end
    end

    if not holiday then
      local tmp = {
        year = t.year, month = t.month, day = t.day,
        isdst = t.isdst,
      }
      tmp.hour = openHour
      tmp.min  = openMinute
      local openTime = os.time(tmp)
      
      tmp.hour = closeHour
      tmp.min  = closeMinute
      local closeTime = os.time(tmp)
      
      status = localNow >= openTime and localNow <= closeTime

      if m.lunch and status then
        local lunchCloseHour, lunchCloseMin = hm(m.lunch[1])
        local lunchOpenHour, lunchOpenMin   = hm(m.lunch[2])
        
        tmp.hour = lunchCloseHour
        tmp.min  = lunchCloseMin
        local lunchCloseTime = os.time(tmp)
        
        tmp.hour = lunchOpenHour
        tmp.min  = lunchCloseMin
        local lunchOpenTime  = os.time(tmp)
        
        status = not (localNow >= lunchCloseTime and localNow <= lunchOpenTime)
        lunch = not status
      end
    else
      status = false
    end
  end
  
  local tmp = ""
  if not status and lunch then
    tmp = " (lunch)"
  elseif holiday and not weekend then
    tmp = " (holiday)"
  end
  local flag = ""
  if m.country then
    flag = flagEmoji(m.country).." "
  end
  buf[#buf + 1] = ("%s\2%s\2: %s%s"):format(flag, market, status and "open" or "closed", tmp)
end

return table.concat(buf, network == "Telegram" and "\n" or ", ")
